<!-- LimitTheory -->

# Getting started with libphx

Three ways to use the engine, from easiest to most manual:

1. **A Lua app** inside this repository's game host (`lt64.exe <App>`) — recommended.
2. **A custom C/C++ host** linking `libphx64.dll`.
3. **Your own Lua host** embedding LuaJIT and loading the FFI bindings.

Every code sample on this page was compiled/run on this machine (Windows 11, VS 2022, RelWithDebInfo x64).

## 1. Build

See [`../BUILDING.md`](../BUILDING.md) for the full procedure. The short version, from the repo root:

```powershell
cmake -S . -B build -G "Visual Studio 17 2022" -A x64 -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build build --config RelWithDebInfo
```

Outputs in `bin\`:

| File | Purpose |
|---|---|
| `libphx64.dll` | The engine |
| `phx64.lib` | Import library for C/C++ hosts |
| `lt64.exe` | The generic Lua host that runs `script/Main.lua` |
| `SDL2.dll`, `glew32.dll`, `fmodL64.dll`, `fmodstudioL64.dll`, `liblz4.dll`, `lua51.dll` | Runtime dependencies (copied by the build) |

## 2. Hello, window (Lua app)

Create `script/App/Hello.lua`:

```lua
local Hello = Application()

function Hello:onInit ()
  self.font = Font.Load('NovaMono', 16)
  self.rng  = RNG.FromTime()
end

function Hello:onDraw ()
  Draw.Clear(0.08, 0.08, 0.12, 1)
  Draw.Color(1, 0.6, 0.1, 1)
  Draw.Rect(100, 100, 200, 120)
  self.font:draw('Hello, libphx', 110, 170, 1, 1, 1, 1)
end

return Hello
```

Run it from the repo root:

```powershell
.\bin\lt64.exe Hello
```

What happens:

* `lt64.exe` initializes the engine, creates a Lua state and runs `script/Main.lua`.
* `Main.lua` loads the bindings and `require('App.Hello'):run()`.
* `Application` (from `script/phx/util/Application.lua`) creates a 1600×900 resizable window, runs your `onInit`, then loops: input → `onInput` → `onUpdate(dt)` → `onDraw` → swap.
* Standard shortcuts work in any app: **F5** reload, **F10** profiler, **F11** fullscreen, **F12** screenshot, **Tab** wireframe, **Ctrl+W** quit.

### The `Application` template

| Override | Called | Typical use |
|---|---|---|
| `getTitle()` / `getDefaultSize()` / `getWindowMode()` | before window creation | window caption, size (default 1600×900), flags |
| `onInit()` | once, after the GL context exists | load assets, create objects |
| `onResize(sx, sy)` | after init and on every size change | resize render targets |
| `onInput()` | each frame, before update | read input |
| `onUpdate(dt)` | each frame | simulation |
| `onDraw()` | each frame, between begin/end draw | rendering |
| `onExit()` | on shutdown | cleanup |
| `self:quit()` | any time | request exit |

### A slightly bigger example: input and 2D drawing

```lua
local Paint = Application()

function Paint:onInit ()
  self.font = Font.Load('NovaMono', 14)
  self.dots = {}
  self.rng  = RNG.FromTime()
end

function Paint:onUpdate (dt)
  if Input.GetPressed(Button.Keyboard.Escape) then self:quit() end
  if Input.GetDown(Button.Mouse.Left) then
    local mp = Input.GetMousePosition()
    insert(self.dots, { x = mp.x, y = mp.y, r = self.rng:getUniformRange(2, 12) })
  end
end

function Paint:onDraw ()
  Draw.Clear(0.05, 0.05, 0.08, 1)
  Draw.Color(0.2, 0.8, 1.0, 0.8)
  for i = 1, #self.dots do
    local d = self.dots[i]
    Draw.Rect(d.x - d.r, d.y - d.r, 2 * d.r, 2 * d.r)
  end
  self.font:draw(format('%d dots - hold LMB to paint, Esc to quit', #self.dots), 10, 20, 1, 1, 1, 1)
end

return Paint
```

For 3D (meshes, shaders, cameras, deferred lighting) read `script/App/BSPTest.lua`, `script/App/PhysicsTest.lua` and `script/Game/GUI/GameView.lua`, and the *Rendering* section of [SUBSYSTEMS.md](SUBSYSTEMS.md).

## 3. A custom C/C++ host

`libphx` can be used from any language that can load a C DLL. Minimal verified host:

```cpp
// main.cpp
#include "Draw.h"
#include "Engine.h"
#include "Input.h"
#include "Button.h"
#include "Window.h"
#include "WindowMode.h"
#include "WindowPos.h"
#include "TimeStamp.h"

int main () {
  Engine_Init(2, 1);                                   // GL 2.1 compatibility context
  Window* w = Window_Create("libphx C host",
                            WindowPos_Centered, WindowPos_Centered,
                            800, 450, WindowMode_Shown);
  Window_SetVsync(w, true);

  TimeStamp start = TimeStamp_Get();
  while (TimeStamp_GetElapsed(start) < 3.0) {          // run for 3 seconds
    Engine_Update();                                   // poll input, reset metrics
    if (Input_GetPressed(Button_Keyboard_Escape)) break;

    Window_BeginDraw(w);
    Draw_Clear(0.1f, 0.1f, 0.2f, 1.0f);
    Draw_Color(1.0f, 0.6f, 0.1f, 1.0f);
    Draw_Rect(100, 100, 200, 120);
    Window_EndDraw(w);                                 // swap buffers
  }

  Window_Free(w);
  Engine_Free();
  return 0;
}
```

Build (from a *x64 Native Tools* prompt, repo root):

```bat
cl /nologo /EHs-c- /MD ^
   /Ilibphx\include /Ilibphx\ext\include /Ilibphx\ext\include\bullet ^
   main.cpp /Fe:bin\myhost.exe /link bin\phx64.lib
bin\myhost.exe
```

Rules for hosts:

* Include only the headers you use; each is self-contained and wrapped in `PHX_API` (`extern "C"` + `dllimport`).
* The **same CRT** (`/MD`) and the same allocator should be used for memory you pass across the boundary; or use `Memory_Alloc/Memory_Free` from the engine.
* Run with the DLLs next to the exe and the working directory containing `res/` and (if you use the Lua layer) `script/`.
* The GL context lives on the thread that called `Window_Create`; call all engine functions from that thread.
* Const exports such as `Button_Keyboard_Escape`, `WindowMode_Shown` are `PHX_API const` *data* symbols, not functions.

### Embedding Lua from C

The host in `src/Main.cpp` is the reference:

```cpp
Engine_Init(2, 1);
Lua* lua = Lua_Create();
Lua_SetBool  (lua, "__debug__",    false);
Lua_SetBool  (lua, "__embedded__", true);
Lua_SetNumber(lua, "__checklevel__", 0);
Lua_SetStr   (lua, "__app__", "Hello");     // optional: which App to run
Lua_DoFile   (lua, "./script/Main.lua");
Lua_Free(lua);
Engine_Free();
```

## 4. Your own Lua host

Load only the engine bindings and skip the game framework:

```lua
package.path = package.path .. ';./libphx/script/?.lua'   -- makes require('ffi.libphx') resolve
local libphx = require('ffi.libphx').lib                   -- ffi.load('libphx64')
local ffi    = require('ffi')

libphx.Engine_Init(2, 1)
local win = libphx.Window_Create('raw', libphx.WindowPos_Centered, libphx.WindowPos_Centered,
                                 640, 360, libphx.WindowMode_Shown)
-- ... loop using libphx.Window_BeginDraw / Draw_* / Window_EndDraw ...
```

`ffi/libphx.lua` performs the `ffi.cdef` of every type and loads the DLL by name:
`libphx<64|32>[d]` (`d` when `__debug__` is true). Put the DLL on `PATH` or next to the executable.

## 5. Project templates

| Goal | Start from |
|---|---|
| Small tool/demo | `script/App/Todo.lua`, `TestHmGui.lua` (GUI), `InputTest.lua` (input) |
| 3D viewer | `script/App/BSPTest.lua`, `CoordTest.lua` |
| Physics sandbox | `script/App/PhysicsTest.lua` |
| Full game | `script/App/LTheory.lua` (see [`../Game/`](../Game/README.md)) |

## 6. Common first-run problems

| Symptom | Cause / fix |
|---|---|
| `cannot load module 'libphx64'` | DLL not found or wrong build config; build `RelWithDebInfo` |
| `Resource_Resolve: Failed to find …` | Wrong working directory (must contain `res/`) or LFS assets missing |
| Black window, no error | Shader failed to compile — check stdout/`log/`; try F5 reload |
| `PHX Engine: Fatal Error` dialog | Engine `Fatal()`; read the message, *Cancel* continues, *Yes* breaks into a debugger |
| Crash with "Lua Backtrace" | Native fault inside a call from script; the backtrace shows the Lua frame |
