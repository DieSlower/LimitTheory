<!-- LimitTheory -->

# Glossary

Terms used in the Limit Theory game code and documentation.

| Term | Meaning |
|---|---|
| **Action** | A unit of behaviour on an entity's action stack (`MoveTo`, `Attack`, …). Only the top action is *active*. |
| **Application** | Base class that owns the window and main loop (`phx/util/Application.lua`); the game is the `LTheory` application. |
| **Asset** | An entity owned by a `Player` (ships, stations); tracked by the *Assets* component. |
| **Broadcast** | `Event.Broadcast(event)`: wrapper that makes containers forward an event to all children. |
| **Camera (Chase/Orbit)** | Third-person follow camera vs free orbiting camera. |
| **Canvas** | Root of the retained UI widget tree. |
| **Capacitor** | Energy store used by boost (and other consumers); recharges over time. |
| **Command (control)** | RTS-style panel to select and order units. |
| **Component** | A capability mix-in added to an entity (`addHealth`, `addRigidBody`, …). |
| **Config** | Static Lua tables with tunables (`Config.App.lua`, `Config.Local.lua`). |
| **Control (panel)** | A player-facing mode (Ship/HUD, Command, Debug, Dock) selected by `MasterControl`. |
| **Control set** | A group of panels available under a condition (undocked or docked). |
| **Disposition** | Relationship value −1..+1 between owners; drives friend/foe colours. |
| **Dockable / Docked** | Station capability / ships parented under a station. |
| **Economy** | System-level cache of factories, markets, traders, yields and candidate jobs. |
| **Entity** | Base game object: id + event handlers. Everything in the world is an entity (or a pooled struct like `Pulse`). |
| **Escort** | Action keeping a ship near a leader at an offset. |
| **Event** | A table `{type=Event.X, …}` delivered to registered handlers. |
| **Factory** | Component that runs `Production` recipes at a location. |
| **Flow** | Rate of an item entering/leaving a location (`item`, `rate`, `location`). |
| **GameView** | Widget that renders the 3D world and composites the UI. |
| **Gen** | Procedural generation library (`script/Gen`). |
| **HmGui** | Engine immediate-mode GUI (used for tools/demos). |
| **HUD** | The Ship control panel: reticle, trackers, flight input. |
| **Item** | A trade good (`name`, `mass`, `energy`). |
| **Job** | An action that also describes economic flows, payout and travel time. |
| **LOD** | Level of detail: `VisibleLodMesh` picks a mesh by distance. |
| **Market** | Per-entity order books of buy/sell orders. |
| **Material** | Shader + textures bound to render an entity. |
| **MasterControl** | Chooses and switches the active control panel. |
| **Nebula** | Procedural cube-map skybox + irradiance map. |
| **Owner** | The `Player` that owns an entity. |
| **Preload** | Registry of functions run once a GL context exists. |
| **Production** | Recipe: inputs, outputs, duration. |
| **Pulse** | The plasma bolt projectile (FFI struct, pooled in the system). |
| **Player** | Entity representing a human or AI faction; may control one ship. |
| **RigidBody** | Engine physics body wrapped by the RigidBody component. |
| **Settings** | Runtime-tunable, typed values (`Settings.addFloat`…). |
| **ShipType** | Generated hull + mount points, instantiable into many ships. |
| **Socket** | Mount point on a ship for a `Thruster`/`Turret`/`Generator`. |
| **System** | The world root entity (a "star system"): RNG, physics, projectiles, economy. |
| **Think** | AI manager action that assigns jobs to idle assets. |
| **ThrustController** | Converts normalised demands into forces and torques. |
| **TrackingList** | Auto-maintained list of root entities matching a predicate. |
| **Trader** | Component quoting bids/asks for items. |
| **Yield** | Resource an asteroid produces when mined. |
| **Zone** | Named collection of entities, e.g. an asteroid field. |
