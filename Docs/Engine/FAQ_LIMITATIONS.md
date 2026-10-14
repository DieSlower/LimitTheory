<!-- LimitTheory -->

# libphx — FAQ, limitations and glossary

## Frequently asked questions

**Is libphx a framework like Unity or Unreal?**
No. It is a library. You write `main` (or a Lua `Application`), call `Engine_Update`, decide what to draw, and the engine does the heavy lifting on request. There is no scene graph, entity system, editor or asset pipeline in the engine.

**Do I have to use Lua?**
No. The C API stands alone (see the C host in [GETTING_STARTED.md](GETTING_STARTED.md)). Lua is how the author used it and what the shipped tooling (`genffi`, `Application`, caches) assumes.

**What OpenGL version does it need?**
`Engine_Init(major, minor)` requests a compatibility-profile context; the game passes 2.1. Shaders are `#version 130`. Anything that supports GL 3.0-era features (FBOs with multiple render targets, float textures) works.

**Why do I see `Game.X is shadowing PHX.FFI.X in _G` on start-up?**
`Namespace.Inline` injects module tables into globals and warns when two modules define the same name (`Socket`, `SocketType`). It is a harmless diagnostic of the game's own `Socket` entity type clashing with the engine's networking `Socket`.

**Why must I run from the repo root?**
Resource paths (`./res/...`, `./script/...`) are relative to the process working directory.

**Where are errors reported?**
`Fatal()` → stderr + a dialog in non-distributable Windows builds. Lua errors go through `ErrorHandler` and print colourised source excerpts. `log/` is created at start-up (reserved for logs; most output goes to stdout).

**Is it thread-safe?**
No. Treat every engine call as main-thread-only (the GL context requires it). `ThreadPool` is for your own native work.

**Can I use it for 2D games?**
Yes: `Draw_Rect/Line/Poly`, textures via `Tex2D_Draw`, fonts, HmGui and clip rects are 2D-capable; set up an orthographic view with `GLMatrix` / `Viewport`.

**Is there documentation upstream?**
The upstream README states the engine is "mostly undocumented"; headers carry design notes (see `Physics.h`, `RigidBody.h`, `Input.h`). These docs consolidate and extend them.

## Known limitations

| Area | Limitation |
|---|---|
| Platform | Windows x64 is the only verified target. The Linux CMake branch is incomplete (`# TODO`); macOS has no build support. |
| Rendering | Fixed GL compatibility-profile pipeline; no Vulkan/DX; immediate-mode submission from script (CPU-bound for large scenes). |
| Threading | Single-threaded engine; scheduler is global to one Lua state (`LuaScheduler` header warns about this). |
| Physics | Single parent/child compound level; triggers are AABB-only with one-frame latency when attached; child bodies don't contribute mass (see `RigidBody.h`). |
| Audio | Uses FMOD's *core* API; FMOD Studio is a TODO; no handling for device loss/default-device change (documented TODOs in `Audio.h`). |
| Input | Gamepad hot-plug re-mapping handled, but mouse motion is not a button; `InputBindings` C API is partly commented out and unused by the game. |
| Error handling | Mostly fatal; no exceptions; release builds (`BUILD_DISTRIBUTABLE`) abort silently with no dialog. |
| FFI generator | Regex based, silent on failure, limited struct-array and `const*` support (see generator TODO list). |
| Math | `/fp:fast` / `-ffast-math`: no NaN/Inf guarantees. |
| Packaging | No archive/virtual file system; assets are loose files resolved by search paths. |
| Documentation | Several headers refer to `../doc/RefCounted.txt`, which is not in the repository. |

## Troubleshooting matrix

| Message / symptom | Meaning | Fix |
|---|---|---|
| `Engine_Init: Detected SDL version mismatch` | Header SDL version differs from loaded `SDL2.dll` | Use the DLL from `ext/lib/win64`/`bin` that the build copies |
| `Failed to initialize SDL's subsystems` | No video/audio device or driver problem | Run on a machine with a GPU/driver, not a headless session |
| Window opens black | Shader compile/link failed or FBO incomplete | Check console output; verify GPU supports GL 3.0; reduce `render.superSample` |
| `Shader_Load: Failed to find ...` | Missing `res/shader/...` file | Check path/case; run from repo root |
| `Attempt to access undefined global variable` | `GlobalRestrict` caught a typo or missing local | Declare the variable or `require` the module |
| `Signal_Handler: Caught Memory Access Violation` + `Lua Backtrace` | Native crash called from script (e.g. bad pointer) | The backtrace lists the Lua frame; check object lifetimes (`:managed()`/`:free()`), null args |
| FPS very low | CPU-bound script rendering or huge supersample | Use the profiler (F10), reduce `render.superSample`, batch draw calls |
| No sound | FMOD device missing or `Audio.Init()` not called | Call `Audio.Init()`; check Windows output device |

## Glossary

| Term | Meaning |
|---|---|
| **PHX** | "Phoenix", the engine's internal name and function-name prefix of the exported macro `PHX_API` |
| **FFI** | LuaJIT's foreign function interface for calling C directly |
| **cdef** | `ffi.cdef` — declares C types/functions to LuaJIT |
| **Opaque type** | Handle whose layout is hidden from Lua (`Mesh*`, `Shader*`) |
| **Transparent struct** | Plain data struct with Lua-visible fields (`Vec3f`) |
| **Metatype** | `ffi.metatype` — attaches methods/operators to a C type |
| **ffiext** | Hand-written Lua extension files that hook the generator's output |
| **ShaderVar** | Stack-scoped named values auto-bound to matching `#autovar` uniforms |
| **HmGui** | The engine's immediate-mode GUI toolkit |
| **MRT** | Multiple render targets — used for the deferred G-buffer |
| **LOD** | Level of detail — `LodMesh` swaps meshes by distance |
| **BSP** | Binary space partition tree built from a mesh for fast intersection |
| **SDF** | Signed distance field |
| **Compound body** | A parent `RigidBody` with attached child bodies |
| **RefCounted** | Intrusive reference-count mixin; `Acquire`/`Free` pairs |
| **Distributable build** | Build with `BUILD_DISTRIBUTABLE` defined: no debug dialogs or `../shared` search paths |
