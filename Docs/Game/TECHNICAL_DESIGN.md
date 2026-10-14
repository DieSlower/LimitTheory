<!-- LimitTheory -->

# Technical Design Document (TDD)

> *"TDP"/"TDD" in the request is read here as **Technical Design Document**. This document records the goals, constraints and design decisions that can be inferred from the code and its comments, and lists known issues and open design questions. It is a reconstruction, not an original design spec written by the authors.*

## 1. Purpose and scope

**Product.** *Limit Theory* — a persistent, procedurally generated, open-world space simulation with a deep player-driven economy and empire management (ship command, mining, trade, production). The code in this repository is the second-generation implementation: a C engine (libphx) with all game logic in Lua.

**Scope of this document.** The Lua game layer in `script/`: simulation, AI, economy model, procedural generation, UI and rendering orchestration. The engine is covered in [`../Engine/`](../Engine/README.md).

**Non-goals (as built).** Networking/multiplayer, persistence, mod packaging, campaign content, localisation and accessibility are not implemented.

## 2. Goals and constraints inferred from the code

| # | Goal / constraint | Evidence | Consequence |
|---|---|---|---|
| G1 | **Fast iteration** — hot reload and scripted gameplay | F5 reload, all gameplay in Lua, shaders loaded from text | LuaJIT host; no compile step for content |
| G2 | **Procedural everything** — ships, stations, asteroids, nebulae, names | `Gen/` (37 files), `res/grammar`, GPU generation shaders | Seeds drive content; deterministic generation (`RNG`, `Distribution`) |
| G3 | **Many entities** — hundreds of AI ships, thousands of asteroids and projectiles | `Config.gen.nFieldSize`, 100 escorts, pooled pulses, LOD meshes, "Perf" comments | Event-driven updates, native physics, FFI-backed structs, render batching |
| G4 | **Large worlds, small floats** — origin and scale testing | `Config.gen.origin` comment: *"Set far from zero to test engine precision"* | Doubles in generation, float rendering; no floating-origin yet |
| G5 | **Mod-friendly structure** | README, `Game/Content.lua` "typically be added in mod format" | Content as data/Lua tables; entities as composable parts |
| G6 | **Gamepad-first controls** | `ShipBindings` gamepad axes, `NavGroup` focus navigation | Input abstraction (`WIP/Control`), UI navigable without mouse |
| G7 | **Debuggability** | Debug window, inspector, `Event.Debug`, profiler scopes everywhere | Instrumentation is part of the architecture |

## 3. High-level design

See [ARCHITECTURE.md](ARCHITECTURE.md) for diagrams. Key design decisions follow.

### D1 — Entities as tables + component mix-ins instead of a class hierarchy or ECS

**Decision.** `Entity` is a tiny class (id + handler table). Capabilities are added by calling `entity:addX()`, which stores fields on the entity and registers event handlers; methods live on `Entity` itself, shared by all instances.

**Rationale.** Maximum flexibility for procedural content (any entity may have any capability) with almost no boilerplate; very cheap in LuaJIT.

**Trade-offs.**

| + | − |
|---|---|
| Composition without inheritance chains | Name collisions across components are possible (single flat namespace on `Entity`) |
| Cheap dispatch via direct method calls | No data-oriented layout; cache behaviour relies on LuaJIT tables |
| Components can be added at runtime | No schema or validation beyond `assert(not self.x)` |
| Easy to debug (`Event.Debug` dumps) | Cross-component dependencies are implicit (e.g. Dockable requires Children) |

### D2 — Event propagation by tree broadcast

**Decision.** The world is a tree (`System` → ships/stations → attached parts). `Event.Update` is wrapped in `Event.Broadcast` and forwarded by every container to its children.

**Rationale.** Uniform update/render dispatch without a global registry; entities deleted or reparented are naturally handled by tree membership.

**Trade-offs.** Every entity is visited every frame even if idle; handler lists are walked with `ipairs`. Culling or sleeping would need an extra layer. Updating is single-threaded.

### D3 — Native physics, scripted control

**Decision.** Rigid-body integration, collision and ray casting are done by Bullet in the engine; the script layer only applies forces/torques and reads transforms.

**Rationale.** Physics is the heaviest per-entity cost and is branch-free numeric work, ideal for native code.

**Trade-offs.** Control code must express intent as forces (`ThrustController`), so AI steering (`Action:flyToward`) is expensive in Lua — flagged in source as *"a major bottleneck; AI steering / thrust controller needs to be pushed to C"*.

### D4 — Actions as a stack, jobs as scored actions

**Decision.** Each ship has an action stack; AI managers (`Think`) push `Job` actions chosen by scoring candidate jobs on payout (or economic *pressure*) from a bounded random sample.

**Rationale.** Interruptible, composable behaviours (e.g. *Mine* = move → mine → return → sell) without a full planner; random sampling bounds cost regardless of world size.

**Trade-offs.** Job quality is stochastic; no hierarchical planning; payoffs are heuristic.

### D5 — Economy as flow balancing

**Decision.** Economic state is represented as **flows** (items per second at locations). Jobs expose the flows they create; a job's *pressure* measures how much it reduces the squared imbalance.

**Rationale.** A scalable, continuous-time model that avoids simulating every trade; supports decentralised, price-driven AI.

**Trade-offs.** Requires sensible production chains and price signals (`Content.lua` is minimal); not yet tuned (trade-job generation is behind `if false`).

### D6 — Dual UI strategy

**Decision.** In-game UI uses a Lua retained-mode toolkit (`UI/`) with navigation groups for gamepad support; developer tools and demos use the engine's immediate-mode `HmGui`.

**Rationale.** Retained widgets give animation, focus, modal windows and consistent skinning; immediate-mode is fastest to write for tools.

**Trade-offs.** Two toolkits to maintain; the retained toolkit has numerous TODOs (clipping, focus edge cases).

### D7 — Deferred rendering orchestrated from Lua

**Decision.** `GameView` and `phx.util.Renderer` build a G-buffer, apply lighting with full-screen passes and post-process, all through engine primitives (render targets, shader variables).

**Rationale.** Many dynamic lights, easy post effects, resolution scaling (supersample 1/2/4).

**Trade-offs.** Draw submission is CPU-bound in Lua; the author notes the monolithic renderer should be refactored into `RenderPass` objects (TODO in `Renderer.lua`).

### D8 — Determinism through seeds

**Decision.** All procedural content is a pure function of a 64-bit seed; the world root owns an `RNG` and children get derived seeds (`rng:get31()`).

**Rationale.** Reproducible bugs, shareable worlds, ability to regenerate rather than save content.

**Trade-off.** Gameplay simulation itself (floating-point physics, wall-clock RNG in AI) is not deterministic.

## 4. Runtime behaviour

### 4.1 Time and update ordering

* Wall-clock `dt`, optionally scaled (hold **H**: ×10). No fixed time step; physics receives variable `dt` (Bullet substepping is internal to the engine).
* Order per frame: input → player AI → system handlers → broadcast update → physics → post-physics (projectiles) → UI update → render.

### 4.2 Memory and GC

* Entities are Lua tables; engine objects (`Mesh`, `RigidBody`, `Physics`) are `:managed()` (GC-owned) or explicitly freed.
* Hot paths avoid allocation: pulses are FFI structs in a plain array with swap-remove; shader uniform indices are cached (`ShaderVarCache`); `Debug` metrics report Lua memory and GC passes.
* LuaJIT is tuned via `Config.jit.tune` (`maxtrace`, `hotloop`, …) in `Main.lua`.

### 4.3 Threading

Single-threaded script and engine. Audio is mixed by FMOD's own thread.

## 5. Interfaces

| Interface | Direction | Description |
|---|---|---|
| Engine FFI | Game → libphx | Mesh/Shader/Physics/Input/Audio… ([Engine docs](../Engine/README.md)) |
| `Application` virtuals | Engine loop → game | `onInit/onInput/onUpdate/onDraw/onResize/onExit` |
| Entity events | tree-wide | `Event.*` table |
| Control panel contract | `MasterControl` ↔ panel | `Create(gameView, player)`, `icon`, `onEnable/onDisable`, `onInput`, `onUpdate`, `onDraw` |
| Action/Job contract | AI ↔ entity | `clone/getName/onStart/onStop/onUpdateActive/onUpdatePassive`; jobs add `getFlows/getPayout/getTravelTime` |
| Generator contract | `Gen.Generator.Add(type, weight, fn)` | `fn(rng, ...)` returns an asset |
| Config | tables | `Config.*`, `Settings.*` |

## 6. Quality attributes

| Attribute | Status |
|---|---|
| Performance | Designed for hundreds of ships; per-frame work is O(entities) in Lua; known hot spots: AI steering, economy cache rebuild each frame, per-light fullscreen passes, per-entity draw calls |
| Scalability | Limited by single-thread Lua; LOD meshes and pooled projectiles mitigate |
| Testability | No unit-test harness; `script/App/*Test*.lua` are manual test beds (`CoordTest` runs a few asserts) |
| Maintainability | Consistent component idiom; many TODO comments (≈130 in game/gen/UI/util code); duplicated fields on `Entity` |
| Portability | Engine is Windows-focused; Lua is portable |
| Observability | Strong (profiler scopes, debug window, metrics) |
| Security | Not applicable (no network/untrusted input) |

## 7. Known issues, risks and technical debt

Collected from in-source `TODO`/`BUG`/`HACK` comments and from running the code.

| Area | Issue | Reference |
|---|---|---|
| Flight | Backward-thrust maximum not respected; forward force applied regardless | `ThrustController.lua` |
| AI | Steering in Lua is the dominant AI cost (*"major bottleneck"*) | `Game/Action.lua` |
| Docking | Forward alignment can cause docking failure; dock range hard-coded (200) rather than coming from `Dockable` | `Actions/DockAt.lua` |
| Entities | Possible leak of Thruster/Turret rigid bodies on `plug` failure | `Entities/System.lua` |
| Economy | Trade jobs disabled; factory trade orders disabled due to order explosion | `Economy.lua`, `Factory.lua` |
| Camera | NDC-to-view conversion yields NaN / wrong values at extreme near/far (`zNear=0.1`, `zFar=1e7`) | `Util/Camera.lua` |
| Command UI | Attack-self error, group panel confusion, `firstRun` hack, collapsible click bug | `CommandControl.lua` |
| Prompts | Dock/undock prompts print `???` | `HUD.lua`, `DockControl.lua` |
| Rendering | Monolithic renderer; per-pass state leaks possible if pushes/pops unbalanced | `Renderer.lua` |
| Content | No real content: 4 items and a handful of recipes; no research, construction or diplomacy | `Content.lua`, `App/Todo.lua` |
| Apps | `TestIcon`, `FMODTest`, `GenTex2D`, `TestImGui`, `Todo` fail on a clean checkout (see [`../RUNNING.md`](../RUNNING.md)) | |
| Build | Requires `RelWithDebInfo` because Lua loads `libphx64`; CMake 4 needs a policy flag | [`../BUILDING.md`](../BUILDING.md) |
| Docs | Original author comments are the only upstream documentation | — |

## 8. Possible evolution (from code comments and structure)

1. Push AI steering / thrust control and nav grids into C.
2. Refactor `Renderer` into `RenderPass` objects; batch light passes.
3. Unify `Capacitor`, `Health` and shields into an "energy inventory".
4. Replace the flat component namespace with namespaced component tables or an archetype store.
5. Introduce a floating origin / double-precision world coordinates for galaxy scale.
6. Finish economy: trade jobs, order limits, production chains, pricing.
7. Persistence: serialise seed + diffs.
8. Real mod loader around `Content.lua`-style data files.

## 9. Test strategy (current and recommended)

| Level | Current | Recommended |
|---|---|---|
| Unit | none (only assertions inside `CoordTest`, `BSPTest`) | Lua unit tests for `Production`, `Flow`, `Market`, `List`, `Distribution`, bindings combinators |
| Integration | manual test apps | headless sim test: spawn system, run N frames with fixed seed, assert invariants (no NaNs, conservation of items) |
| Visual | manual | screenshot (F12) comparisons for generators with fixed seeds |
| Performance | profiler overlay | scripted soak run with `Profiler` dumps and frame-time budget checks |
