#!/usr/bin/env python3
"""Regenerates API_REFERENCE.md from libphx/include/*.h.

Usage (from Docs/Engine):  python gen_api_reference.py
"""
import glob
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
INC = os.path.join(HERE, '..', '..', 'libphx', 'include')
OUT = os.path.join(HERE, 'API_REFERENCE.md')

CATS = [
  ('Core, memory, errors and utilities', ['Engine', 'Common', 'Error', 'PhxMemory', 'PhxSignal', 'Bit', 'Hash', 'GUID', 'Bytes', 'StrBuffer', 'StrMap', 'HashMap', 'MemPool', 'MemStack', 'OS', 'Metric', 'Profiler', 'PhxTime', 'TimeStamp', 'Timer', 'Thread', 'ThreadPool']),
  ('Lua hosting', ['Lua']),
  ('Math, geometry and random', ['PhxMath', 'Vec2', 'Vec3', 'Vec4', 'Quat', 'Matrix', 'Box3', 'Ray', 'Plane', 'LineSegment', 'Triangle', 'Polygon', 'Intersect', 'RNG']),
  ('Spatial data structures and procedural', ['BSP', 'KDTree', 'Octree', 'BoxTree', 'HashGrid', 'SDF']),
  ('Files and resources', ['File', 'Directory', 'Resource', 'ResourceType']),
  ('Window and input', ['Window', 'WindowMode', 'WindowPos', 'Input', 'InputBindings', 'InputEvent', 'Button', 'Device', 'DeviceType', 'Keyboard', 'Mouse', 'Gamepad', 'Joystick', 'Midi', 'Modifier', 'VR']),
  ('Rendering state', ['OpenGL', 'BlendMode', 'CullFace', 'DepthTest', 'RenderState', 'RenderTarget', 'ClipRect', 'Viewport', 'GLMatrix', 'CubeFace', 'State']),
  ('Drawing, meshes and textures', ['Draw', 'Mesh', 'Meshes', 'BoxMesh', 'LodMesh', 'Tex1D', 'Tex2D', 'Tex3D', 'TexCube', 'TexFilter', 'TexFormat', 'TexWrapMode', 'PixelFormat', 'DataFormat']),
  ('Shaders', ['Shader', 'ShaderState', 'ShaderVar', 'ShaderVarType']),
  ('Text and UI', ['Font', 'HmGui', 'ImGui', 'UIRenderer']),
  ('Physics', ['Physics', 'RigidBody', 'Trigger', 'CollisionShape']),
  ('Audio', ['Audio', 'Sound', 'SoundDesc']),
  ('Networking', ['Socket']),
]


def sigs(path):
  s = open(path, encoding='utf-8', errors='ignore').read()
  ffi_ignore = '__FFI_IGNORE__' in s
  s = re.sub(r'//.*', '', s)
  s = re.sub(r'/\*.*?\*/', '', s, flags=re.S)
  res = []
  for m in re.finditer(r'PHX_API\s+([^;{}]*?)\s+\**(\w+)\s*\(([^;{}]*?)\)\s*;', s, flags=re.S):
    name = m.group(2)
    full = re.search(r'PHX_API\s+([^;{}]*?' + name + r'\s*\([^;{}]*?\))\s*;', s, flags=re.S).group(1)
    res.append((name, re.sub(r'\s+', ' ', full)))
  return ffi_ignore, res


def section(mod, ign, fs):
  n = len(fs)
  lines = ['### %s%s - %d function%s\n' % (mod, ' *(C only)*' if ign else '', n, '' if n == 1 else 's'), '```c']
  lines += [f for _, f in fs]
  lines.append('```\n')
  return lines


def main():
  out = ['<!-- LimitTheory -->', '', '# libphx API reference', '',
         'Catalog of the public C API generated from `libphx/include/*.h` (every `PHX_API` function). '
         'Names are `Module_Verb`; in Lua they become `Module.Verb(...)` and, for functions whose first '
         'parameter is the module\'s own type, `obj:verb(...)` (see [LUA_BINDINGS.md](LUA_BINDINGS.md)). '
         'Parameter conventions: `Type*` is an opaque handle or out-parameter, `cstr` is `const char*`, '
         'vectors are passed by pointer.', '',
         '> Headers that carry the `__FFI_IGNORE__` marker (e.g. `Lua.h`, `ArrayList.h`, `PhxSignal.h`) are '
         'C-only: part of the C API but without a generated Lua binding. They are flagged **C only** below.', '',
         'TOTAL_PLACEHOLDER', '',
         '> Enum-like constants (`PHX_API const Button Button_Keyboard_Escape;`, `BlendMode_Alpha`, '
         '`WindowMode_Shown`, ...) are not listed individually; they appear in Lua as members of the matching '
         'table (`Button.Keyboard.Escape`, `BlendMode.Alpha`, `WindowMode.Shown`) and are defined in the '
         'module\'s header.', '',
         '> **Generated** by `Docs/Engine/gen_api_reference.py`; re-run it after changing the API '
         '(see [EXTENDING.md](EXTENDING.md#6-regenerating-this-reference)).', '']
  seen, total = set(), 0
  for title, mods in CATS:
    out.append('## %s\n' % title)
    for mod in mods:
      p = os.path.join(INC, mod + '.h')
      if not os.path.exists(p):
        continue
      seen.add(mod)
      ign, fs = sigs(p)
      if fs:
        total += len(fs)
        out += section(mod, ign, fs)
  rest = [os.path.basename(h)[:-2] for h in sorted(glob.glob(os.path.join(INC, '*.h')))
          if os.path.basename(h)[:-2] not in seen]
  extra, hdr_only = [], []
  for mod in rest:
    ign, fs = sigs(os.path.join(INC, mod + '.h'))
    if fs:
      total += len(fs)
      extra += section(mod, ign, fs)
    else:
      hdr_only.append(mod)
  if extra:
    out.append('## Other modules\n')
    out += extra
  out.append('## Header-only / type-only modules\n')
  out.append('These headers define types, constants or macros but no exported functions: `' +
             '`, `'.join(sorted(hdr_only)) + '`.\n')
  text = '\n'.join(out).replace('TOTAL_PLACEHOLDER', '**Total exported functions listed: %d.**' % total)
  open(OUT, 'w', encoding='utf-8', newline='\n').write(text)
  print('wrote', OUT, total)


if __name__ == '__main__':
  main()
