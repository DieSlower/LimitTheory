<!-- LimitTheory -->

# libphx API reference

Catalog of the public C API generated from `libphx/include/*.h` (every `PHX_API` function). Names are `Module_Verb`; in Lua they become `Module.Verb(...)` and, for functions whose first parameter is the module's own type, `obj:verb(...)` (see [LUA_BINDINGS.md](LUA_BINDINGS.md)). Parameter conventions: `Type*` is an opaque handle or out-parameter, `cstr` is `const char*`, vectors are passed by pointer.

> Headers that carry the `__FFI_IGNORE__` marker (e.g. `Lua.h`, `ArrayList.h`, `PhxSignal.h`) are C-only: part of the C API but without a generated Lua binding. They are flagged **C only** below.

**Total exported functions listed: 1131.**

> Enum-like constants (`PHX_API const Button Button_Keyboard_Escape;`, `BlendMode_Alpha`, `WindowMode_Shown`, ...) are not listed individually; they appear in Lua as members of the matching table (`Button.Keyboard.Escape`, `BlendMode.Alpha`, `WindowMode.Shown`) and are defined in the module's header.

> **Generated** by `Docs/Engine/gen_api_reference.py`; re-run it after changing the API (see [EXTENDING.md](EXTENDING.md#6-regenerating-this-reference)).

## Core, memory, errors and utilities

### Engine — 9 functions

```c
void Engine_Init (int glVersionMajor, int glVersionMinor)
void Engine_Free ()
void Engine_Abort ()
int Engine_GetBits ()
double Engine_GetTime ()
cstr Engine_GetVersion ()
bool Engine_IsInitialized ()
void Engine_Terminate ()
void Engine_Update ()
```

### Common — 2 functions

```c
void Fatal (cstr, ...)
void Warn (cstr, ...)
```

### Error — 1 function

```c
void Error_Print (Error)
```

### PhxMemory — 6 functions

```c
void* Memory_Alloc (size_t)
void* Memory_Calloc (size_t n, size_t size)
void Memory_Free (void* ptr)
void Memory_MemCopy (void* dst, void const* src, size_t size)
void Memory_MemMove (void* dst, void const* src, size_t size)
void* Memory_Realloc (void* ptr, size_t newSize)
```

### PhxSignal *(C only)* — 8 functions

```c
void Signal_Init ()
void Signal_Free ()
void Signal_AddHandler (Signal, SignalHandler)
void Signal_AddHandlerAll (SignalHandler)
void Signal_RemoveHandler (Signal, SignalHandler)
void Signal_RemoveHandlerAll (SignalHandler)
cstr Signal_ToString (Signal)
void Signal_IgnoreDefault ()
```

### Bit — 8 functions

```c
uint32 Bit_And32 (uint32 x, uint32 y)
uint32 Bit_Or32 (uint32 x, uint32 y)
uint32 Bit_Xor32 (uint32 x, uint32 y)
bool Bit_Has32 (uint32 x, uint32 y)
uint64 Bit_And64 (uint64 x, uint64 y)
uint64 Bit_Or64 (uint64 x, uint64 y)
uint64 Bit_Xor64 (uint64 x, uint64 y)
bool Bit_Has64 (uint64 x, uint64 y)
```

### Hash — 8 functions

```c
uint32 Hash_FNV32 (void const* buf, int len)
uint64 Hash_FNV64 (void const* buf, int len)
uint32 Hash_FNVStr32 (cstr)
uint64 Hash_FNVStr64 (cstr)
uint64 Hash_FNV64_Init ()
uint64 Hash_FNV64_Incremental (uint64, void const* buf, int len)
uint32 Hash_Murmur3 (void const* buf, int len)
uint64 Hash_XX64 (void const* buf, int len, uint64 seed)
```

### GUID — 3 functions

```c
uint64 GUID_Create ()
bool GUID_Exists (uint64)
void GUID_Reset ()
```

### Bytes — 36 functions

```c
Bytes* Bytes_Create (uint32 len)
Bytes* Bytes_FromData (void const* data, uint32 len)
Bytes* Bytes_Load (cstr path)
void Bytes_Free (Bytes*)
void* Bytes_GetData (Bytes*)
uint32 Bytes_GetSize (Bytes*)
Bytes* Bytes_Compress (Bytes*)
Bytes* Bytes_Decompress (Bytes*)
uint32 Bytes_GetCursor (Bytes*)
void Bytes_Rewind (Bytes*)
void Bytes_SetCursor (Bytes*, uint32)
void Bytes_Read (Bytes*, void* data, uint32 len)
uint8 Bytes_ReadU8 (Bytes*)
uint16 Bytes_ReadU16 (Bytes*)
uint32 Bytes_ReadU32 (Bytes*)
uint64 Bytes_ReadU64 (Bytes*)
int8 Bytes_ReadI8 (Bytes*)
int16 Bytes_ReadI16 (Bytes*)
int32 Bytes_ReadI32 (Bytes*)
int64 Bytes_ReadI64 (Bytes*)
float Bytes_ReadF32 (Bytes*)
double Bytes_ReadF64 (Bytes*)
void Bytes_Write (Bytes*, void const* data, uint32 len)
void Bytes_WriteStr (Bytes*, cstr data)
void Bytes_WriteU8 (Bytes*, uint8)
void Bytes_WriteU16 (Bytes*, uint16)
void Bytes_WriteU32 (Bytes*, uint32)
void Bytes_WriteU64 (Bytes*, uint64)
void Bytes_WriteI8 (Bytes*, int8)
void Bytes_WriteI16 (Bytes*, int16)
void Bytes_WriteI32 (Bytes*, int32)
void Bytes_WriteI64 (Bytes*, int64)
void Bytes_WriteF32 (Bytes*, float)
void Bytes_WriteF64 (Bytes*, double)
void Bytes_Print (Bytes*)
void Bytes_Save (Bytes*, cstr path)
```

### StrBuffer — 8 functions

```c
StrBuffer* StrBuffer_Create (uint32 capacity)
StrBuffer* StrBuffer_FromStr (cstr)
void StrBuffer_Free (StrBuffer*)
void StrBuffer_Append (StrBuffer*, StrBuffer*)
void StrBuffer_AppendStr (StrBuffer*, cstr)
void StrBuffer_Set (StrBuffer*, cstr format, ...)
StrBuffer* StrBuffer_Clone (StrBuffer*)
cstr StrBuffer_GetData (StrBuffer*)
```

### StrMap — 14 functions

```c
StrMap* StrMap_Create (uint32 initCapacity)
void StrMap_Free (StrMap*)
void StrMap_FreeEx (StrMap*, void (*freeFn)(cstr key, void* value))
void* StrMap_Get (StrMap*, cstr key)
uint32 StrMap_GetSize (StrMap*)
void StrMap_Remove (StrMap*, cstr key)
void StrMap_Set (StrMap*, cstr key, void* val)
void StrMap_Dump (StrMap*)
StrMapIter* StrMap_Iterate (StrMap*)
void StrMapIter_Advance (StrMapIter*)
void StrMapIter_Free (StrMapIter*)
bool StrMapIter_HasMore (StrMapIter*)
cstr StrMapIter_GetKey (StrMapIter*)
void* StrMapIter_GetValue (StrMapIter*)
```

### HashMap — 8 functions

```c
HashMap* HashMap_Create (uint32 keySize, uint32 capacity)
void HashMap_Free (HashMap*)
void HashMap_Foreach (HashMap*, ValueForeach, void* userData)
void* HashMap_Get (HashMap*, void const* key)
void* HashMap_GetRaw (HashMap*, uint64 keyHash)
void HashMap_Resize (HashMap*, uint32 capacity)
void HashMap_Set (HashMap*, void const* key, void* value)
void HashMap_SetRaw (HashMap*, uint64 keyHash, void* value)
```

### MemPool — 8 functions

```c
MemPool* MemPool_Create (uint32 cellSize, uint32 blockSize)
MemPool* MemPool_CreateAuto (uint32 elemSize)
void MemPool_Free (MemPool*)
void* MemPool_Alloc (MemPool*)
void MemPool_Clear (MemPool*)
void MemPool_Dealloc (MemPool*, void*)
uint32 MemPool_GetCapacity (MemPool*)
uint32 MemPool_GetSize (MemPool*)
```

### MemStack — 9 functions

```c
MemStack* MemStack_Create (uint32 capacity)
void MemStack_Free (MemStack*)
void* MemStack_Alloc (MemStack*, uint32 size)
void MemStack_Clear (MemStack*)
void MemStack_Dealloc (MemStack*, uint32 size)
bool MemStack_CanAlloc (MemStack*, uint32 size)
uint32 MemStack_GetSize (MemStack*)
uint32 MemStack_GetCapacity (MemStack*)
uint32 MemStack_GetRemaining (MemStack*)
```

### OS — 4 functions

```c
cstr OS_GetClipboard ()
int OS_GetCPUCount ()
cstr OS_GetVideoDriver ()
void OS_SetClipboard (cstr text)
```

### Metric — 2 functions

```c
int32 Metric_Get (Metric)
cstr Metric_GetName (Metric)
```

### Profiler — 7 functions

```c
void Profiler_Enable ()
void Profiler_Disable ()
void Profiler_Begin (cstr)
void Profiler_End ()
void Profiler_SetValue (cstr, int)
void Profiler_LoopMarker ()
void Profiler_Backtrace ()
```

### PhxTime — 3 functions

```c
Time Time_GetLocal ()
Time Time_GetUTC ()
uint Time_GetRaw ()
```

### TimeStamp — 7 functions

```c
TimeStamp TimeStamp_Get ()
double TimeStamp_GetDifference (TimeStamp start, TimeStamp end)
double TimeStamp_GetElapsed (TimeStamp start)
double TimeStamp_GetElapsedMs (TimeStamp start)
TimeStamp TimeStamp_GetFuture (double seconds)
TimeStamp TimeStamp_GetRelative (TimeStamp start, double seconds)
double TimeStamp_ToDouble (TimeStamp)
```

### Timer — 5 functions

```c
Timer* Timer_Create()
void Timer_Free (Timer*)
double Timer_GetAndReset (Timer*)
double Timer_GetElapsed (Timer*)
void Timer_Reset (Timer*)
```

### Thread — 4 functions

```c
Thread* Thread_Create (cstr name, ThreadFn, void* data)
void Thread_Detach (Thread*)
void Thread_Sleep (uint ms)
int Thread_Wait (Thread*)
```

### ThreadPool — 4 functions

```c
ThreadPool* ThreadPool_Create (int threads)
void ThreadPool_Free (ThreadPool*)
void ThreadPool_Launch (ThreadPool*, ThreadPoolFn, void* data)
void ThreadPool_Wait (ThreadPool*)
```

## Lua hosting

### Lua *(C only)* — 28 functions

```c
Lua* Lua_Create ()
Lua* Lua_CreateThread (Lua*)
void Lua_Free (Lua*)
Lua* Lua_GetActive ()
void Lua_DoFile (Lua*, cstr name)
void Lua_DoString (Lua*, cstr code)
void Lua_LoadFile (Lua*, cstr name)
void Lua_LoadString (Lua*, cstr code)
void Lua_Call (Lua*, int args, int rets, int errorHandler)
void Lua_PushGlobal (Lua*, cstr name)
void Lua_PushNumber (Lua*, double)
void Lua_PushPtr (Lua*, void*)
void Lua_PushStr (Lua*, cstr)
void Lua_PushThread (Lua*, Lua* thread)
void Lua_SetBool (Lua*, cstr name, bool)
void Lua_SetFn (Lua*, cstr name, LuaFn)
void Lua_SetNumber (Lua*, cstr name, double)
void Lua_SetPtr (Lua*, cstr name, void*)
void Lua_SetStr (Lua*, cstr name, cstr)
void Lua_TransferStack (Lua* src, Lua* dst, int count)
LuaRef Lua_GetRef (Lua*)
void Lua_ReleaseRef (Lua*, LuaRef)
void Lua_PushRef (Lua*, LuaRef)
void Lua_GCFull (Lua*)
void Lua_GCSetActive (Lua*, bool active)
void Lua_GCStep (Lua*)
void Lua_Backtrace ()
int Lua_GetMemory (Lua*)
```

## Math, geometry and random

### PhxMath — 15 functions

```c
double Math_Bezier3 (double x, double, double, double)
double Math_Bezier4 (double x, double, double, double, double)
double Math_Clamp (double x, double a, double b)
double Math_Clamp01 (double x)
double Math_ClampSafe (double x, double a, double b)
double Math_ClampUnit (double x)
double Math_ExpMap (double x, double p)
double Math_ExpMapSigned (double x, double p)
double Math_ExpMap1 (double x)
double Math_ExpMap1Signed (double x)
double Math_ExpMap2 (double x)
double Math_ExpMap2Signed (double x)
double Math_PowSigned (double x, double p)
double Math_Round (double x)
double Math_Sign (double x)
```

### Quat — 32 functions

```c
Quat Quat_Create (float x, float y, float z, float w)
void Quat_GetAxisX (Quat const*, Vec3f*)
void Quat_GetAxisY (Quat const*, Vec3f*)
void Quat_GetAxisZ (Quat const*, Vec3f*)
void Quat_GetForward (Quat const*, Vec3f*)
void Quat_GetRight (Quat const*, Vec3f*)
void Quat_GetUp (Quat const*, Vec3f*)
void Quat_Identity (Quat*)
void Quat_Canonicalize (Quat const*, Quat* out)
void Quat_ICanonicalize (Quat*)
float Quat_Dot (Quat const*, Quat const*)
bool Quat_Equal (Quat const*, Quat const*)
bool Quat_ApproximatelyEqual (Quat const*, Quat const*)
void Quat_Inverse (Quat const*, Quat* out)
void Quat_IInverse (Quat*)
void Quat_Lerp (Quat const*, Quat const*, float t, Quat* out)
void Quat_ILerp (Quat*, Quat const*, float t)
void Quat_Mul (Quat const*, Quat const*, Quat* out)
void Quat_IMul (Quat*, Quat const*)
void Quat_MulV (Quat const*, Vec3f const*, Vec3f* out)
void Quat_Normalize (Quat const*, Quat* out)
void Quat_INormalize (Quat*)
void Quat_Scale (Quat const*, float, Quat* out)
void Quat_IScale (Quat*, float)
void Quat_Slerp (Quat const*, Quat const*, float, Quat* out)
void Quat_ISlerp (Quat*, Quat const*, float)
cstr Quat_ToString (Quat const*)
Error Quat_Validate (Quat const*)
void Quat_FromAxisAngle (Vec3f const* axis, float radians, Quat*)
void Quat_FromBasis (Vec3f const* x, Vec3f const* y, Vec3f const* z, Quat*)
void Quat_FromLookUp (Vec3f const* look, Vec3f const* up, Quat*)
void Quat_FromRotateTo (Vec3f const* from, Vec3f const* to, Quat*)
```

### Matrix — 40 functions

```c
Matrix* Matrix_Clone (Matrix const*)
void Matrix_Free (Matrix*)
bool Matrix_Equal (Matrix const*, Matrix const*)
bool Matrix_ApproximatelyEqual (Matrix const*, Matrix const*)
Matrix* Matrix_Inverse (Matrix const*)
Matrix* Matrix_InverseTranspose (Matrix const*)
Matrix* Matrix_Product (Matrix const*, Matrix const*)
Matrix* Matrix_Sum (Matrix const*, Matrix const*)
Matrix* Matrix_Transpose (Matrix const*)
void Matrix_IInverse (Matrix*)
void Matrix_IScale (Matrix*, float)
void Matrix_ITranspose (Matrix*)
Matrix* Matrix_Identity ()
Matrix* Matrix_LookAt (Vec3f const* pos, Vec3f const* at, Vec3f const* up)
Matrix* Matrix_LookUp (Vec3f const* pos, Vec3f const* look, Vec3f const* up)
Matrix* Matrix_Perspective (float degreesFovY, float aspect, float zNear, float zFar)
Matrix* Matrix_RotationX (float rads)
Matrix* Matrix_RotationY (float rads)
Matrix* Matrix_RotationZ (float rads)
Matrix* Matrix_Scaling (float sx, float sy, float sz)
Matrix* Matrix_SRT (float sx, float sy, float sz, float ry, float rp, float rr, float tx, float ty, float tz)
Matrix* Matrix_Translation (float tx, float ty, float tz)
Matrix* Matrix_YawPitchRoll (float yaw, float pitch, float roll)
void Matrix_MulBox (Matrix const*, Box3f* out, Box3f const* in)
void Matrix_MulDir (Matrix const*, Vec3f* out, float x, float y, float z)
void Matrix_MulPoint (Matrix const*, Vec3f* out, float x, float y, float z)
void Matrix_MulVec (Matrix const*, Vec4f* out, float x, float y, float z, float w)
void Matrix_GetForward (Matrix const*, Vec3f* out)
void Matrix_GetRight (Matrix const*, Vec3f* out)
void Matrix_GetUp (Matrix const*, Vec3f* out)
void Matrix_GetPos (Matrix const*, Vec3f* out)
void Matrix_GetRow (Matrix const*, Vec4f* out, int row)
Matrix* Matrix_FromBasis (Vec3f const* x, Vec3f const* y, Vec3f const* z)
Matrix* Matrix_FromPosRot (Vec3f const*, Quat const*)
Matrix* Matrix_FromPosRotScale (Vec3f const*, Quat const*, float)
Matrix* Matrix_FromPosBasis (Vec3f const* pos, Vec3f const* x, Vec3f const* y, Vec3f const* z)
Matrix* Matrix_FromQuat (Quat const*)
void Matrix_ToQuat (Matrix const*, Quat* out)
void Matrix_Print (Matrix const*)
cstr Matrix_ToString (Matrix const*)
```

### Ray — 7 functions

```c
void Ray_GetPoint (Ray const*, float t, Vec3f* out)
bool Ray_IntersectPlane (Ray const*, Plane const*, Vec3f* pHit)
bool Ray_IntersectTriangle_Barycentric (Ray const*, Triangle const*, float tEpsilon, float* tHit)
bool Ray_IntersectTriangle_Moller1 (Ray const*, Triangle const*, float* tHit)
bool Ray_IntersectTriangle_Moller2 (Ray const*, Triangle const*, float* tHit)
void Ray_ToLineSegment (Ray const*, LineSegment*)
void Ray_FromLineSegment (LineSegment const*, Ray*)
```

### Plane — 5 functions

```c
PointClassification Plane_ClassifyPoint (Plane*, Vec3f*)
PolygonClassification Plane_ClassifyPolygon (Plane*, Polygon*)
Error Plane_Validate (Plane*)
void Plane_FromPolygon (Polygon*, Plane*)
void Plane_FromPolygonFast (Polygon*, Plane*)
```

### LineSegment — 3 functions

```c
void LineSegment_ToRay (LineSegment const*, Ray*)
void LineSegment_FromRay (Ray const*, LineSegment*)
cstr LineSegment_ToString (LineSegment*)
```

### Triangle — 4 functions

```c
void Triangle_ToPlane (Triangle const*, Plane*)
void Triangle_ToPlaneFast (Triangle const*, Plane*)
float Triangle_GetArea (Triangle const*)
Error Triangle_Validate (Triangle const*)
```

### Polygon — 7 functions

```c
void Polygon_ToPlane (Polygon*, Plane*)
void Polygon_ToPlaneFast (Polygon*, Plane*)
void Polygon_Split (Polygon*, Plane splitPlane, Polygon* back, Polygon* front)
void Polygon_SplitSafe (Polygon*, Plane splitPlane, Polygon* back, Polygon* front)
void Polygon_GetCentroid (Polygon*, Vec3f*)
void Polygon_ConvexToTriangles (Polygon*, int32* triangles_capacity, int32* triangles_size, Triangle** triangles_data)
Error Polygon_Validate (Polygon*)
```

### Intersect — 10 functions

```c
bool Intersect_PointBox (Matrix* t1, Matrix* t2)
bool Intersect_PointTriangle_Barycentric (Vec3f const*, Triangle const*)
bool Intersect_RayPlane (Ray const*, Plane const*, Vec3f* pHit)
bool Intersect_RayTriangle_Barycentric (Ray const*, Triangle const*, float tEpsilon, float* tHit)
bool Intersect_RayTriangle_Moller1 (Ray const*, Triangle const*, float* tHit)
bool Intersect_RayTriangle_Moller2 (Ray const*, Triangle const*, float* tHit)
bool Intersect_LineSegmentPlane (LineSegment const*, Plane const*, Vec3f* pHit)
bool Intersect_RectRect (Vec4f const*, Vec4f const*)
bool Intersect_RectRectFast (Vec4f const*, Vec4f const*)
bool Intersect_SphereTriangle (Sphere const*, Triangle const*, Vec3f* pHit)
```

### RNG — 28 functions

```c
RNG* RNG_Create (uint64 seed)
RNG* RNG_FromStr (cstr)
RNG* RNG_FromTime ()
void RNG_Free (RNG*)
void RNG_Rewind (RNG*)
bool RNG_Chance (RNG*, double probability)
int32 RNG_Get31 (RNG*)
uint32 RNG_Get32 (RNG*)
uint64 RNG_Get64 (RNG*)
double RNG_GetAngle (RNG*)
double RNG_GetErlang (RNG*, int k)
double RNG_GetExp (RNG*)
double RNG_GetGaussian (RNG*)
int RNG_GetInt (RNG*, int lower, int upper)
RNG* RNG_GetRNG (RNG*)
double RNG_GetSign (RNG*)
double RNG_GetUniform (RNG*)
double RNG_GetUniformRange (RNG*, double lower, double upper)
void RNG_GetAxis2 (RNG*, Vec2f* out)
void RNG_GetAxis3 (RNG*, Vec3f* out)
void RNG_GetDir2 (RNG*, Vec2f* out)
void RNG_GetDir3 (RNG*, Vec3f* out)
void RNG_GetDisc (RNG*, Vec2f* out)
void RNG_GetSphere (RNG*, Vec3f* out)
void RNG_GetVec2 (RNG*, Vec2f* out, double lower, double upper)
void RNG_GetVec3 (RNG*, Vec3f* out, double lower, double upper)
void RNG_GetVec4 (RNG*, Vec4f* out, double lower, double upper)
void RNG_GetQuat (RNG*, Quat* out)
```

## Spatial data structures and procedural

### BSP — 14 functions

```c
BSP* BSP_Create (Mesh*)
void BSP_Free (BSP*)
bool BSP_IntersectRay (BSP*, Ray const*, float* tHit)
bool BSP_IntersectLineSegment (BSP*, LineSegment const*, Vec3f* pHit)
bool BSP_IntersectSphere (BSP*, Sphere const*, Vec3f* pHit)
BSPNodeRef BSPDebug_GetNode (BSP*, BSPNodeRef, BSPNodeRel)
void BSPDebug_DrawNode (BSP*, BSPNodeRef)
void BSPDebug_DrawNodeSplit (BSP*, BSPNodeRef)
void BSPDebug_DrawLineSegment (BSP*, LineSegment*)
void BSPDebug_DrawSphere (BSP*, Sphere*)
void BSPDebug_PrintRayProfilingData (BSP*, double totalTime)
void BSPDebug_PrintSphereProfilingData (BSP*, double totalTime)
bool BSPDebug_GetIntersectSphereTriangles (BSP*, Sphere*, IntersectSphereProfiling* sphereProf)
BSPNodeRef BSPDebug_GetLeaf (BSP*, int32 leafIndex)
```

### KDTree — 5 functions

```c
KDTree* KDTree_FromMesh (Mesh*)
void KDTree_Free (KDTree*)
void KDTree_Draw (KDTree*, int maxDepth)
int KDTree_GetMemory (KDTree*)
bool KDTree_IntersectRay (KDTree*, Matrix*, Vec3f const* ro, Vec3f const* rd)
```

### Octree — 9 functions

```c
Octree* Octree_Create (Box3f bound)
Octree* Octree_FromMesh (Mesh*)
void Octree_Free (Octree*)
void Octree_Add (Octree*, Box3f bound, uint32 id)
void Octree_Draw (Octree*)
double Octree_GetAvgLoad (Octree*)
int Octree_GetMaxLoad (Octree*)
int Octree_GetMemory (Octree*)
bool Octree_IntersectRay (Octree*, Matrix*, Vec3f const* ro, Vec3f const* rd)
```

### BoxTree — 7 functions

```c
BoxTree* BoxTree_Create ()
BoxTree* BoxTree_FromMesh (Mesh*)
void BoxTree_Free (BoxTree*)
void BoxTree_Add (BoxTree*, Box3f bound, void* data)
void BoxTree_Draw (BoxTree*, int maxDepth)
int BoxTree_GetMemory (BoxTree*)
bool BoxTree_IntersectRay (BoxTree*, Matrix*, Vec3f const* ro, Vec3f const* rd)
```

### HashGrid — 9 functions

```c
HashGrid* HashGrid_Create (float cellSize, uint32 cellCount)
void HashGrid_Free (HashGrid*)
HashGridElem* HashGrid_Add (HashGrid*, void* object, Box3f const*)
void HashGrid_Clear (HashGrid*)
void HashGrid_Remove (HashGrid*, HashGridElem*)
void HashGrid_Update (HashGrid*, HashGridElem*, Box3f const*)
void** HashGrid_GetResults (HashGrid*)
int HashGrid_QueryBox (HashGrid*, Box3f const*)
int HashGrid_QueryPoint (HashGrid*, Vec3f const*)
```

### SDF — 8 functions

```c
SDF* SDF_Create (int sx, int sy, int sz)
SDF* SDF_FromTex3D (Tex3D*)
void SDF_Free (SDF*)
Mesh* SDF_ToMesh (SDF*)
void SDF_Clear (SDF*, float value)
void SDF_ComputeNormals (SDF*)
void SDF_Set (SDF*, int x, int y, int z, float value)
void SDF_SetNormal (SDF*, int x, int y, int z, Vec3f const* normal)
```

## Files and resources

### File — 31 functions

```c
File* File_Create (cstr path)
File* File_Open (cstr path)
void File_Close (File*)
bool File_Exists (cstr path)
bool File_IsDir (cstr path)
Bytes* File_ReadBytes (cstr path)
cstr File_ReadCstr (cstr path)
int64 File_Size (cstr path)
void File_Read (File*, void* data, uint32 len)
uint8 File_ReadU8 (File*)
uint16 File_ReadU16 (File*)
uint32 File_ReadU32 (File*)
uint64 File_ReadU64 (File*)
int8 File_ReadI8 (File*)
int16 File_ReadI16 (File*)
int32 File_ReadI32 (File*)
int64 File_ReadI64 (File*)
float File_ReadF32 (File*)
double File_ReadF64 (File*)
void File_Write (File*, void const* data, uint32 len)
void File_WriteStr (File*, cstr)
void File_WriteU8 (File*, uint8)
void File_WriteU16 (File*, uint16)
void File_WriteU32 (File*, uint32)
void File_WriteU64 (File*, uint64)
void File_WriteI8 (File*, int8)
void File_WriteI16 (File*, int16)
void File_WriteI32 (File*, int32)
void File_WriteI64 (File*, int64)
void File_WriteF32 (File*, float)
void File_WriteF64 (File*, double)
```

### Directory — 7 functions

```c
Directory* Directory_Open (cstr path)
void Directory_Close (Directory*)
cstr Directory_GetNext (Directory*)
bool Directory_Change (cstr cwd)
bool Directory_Create (cstr path)
cstr Directory_GetCurrent ()
bool Directory_Remove (cstr path)
```

### Resource — 5 functions

```c
void Resource_AddPath (ResourceType, cstr format)
bool Resource_Exists (ResourceType, cstr name)
cstr Resource_GetPath (ResourceType, cstr name)
Bytes* Resource_LoadBytes (ResourceType, cstr name)
cstr Resource_LoadCstr (ResourceType, cstr name)
```

### ResourceType — 1 function

```c
cstr ResourceType_ToString (ResourceType)
```

## Window and input

### Window — 15 functions

```c
Window* Window_Create (cstr title, WindowPos x, WindowPos y, int sx, int sy, WindowMode mode)
void Window_Free (Window*)
void Window_BeginDraw (Window*)
void Window_EndDraw (Window*)
void Window_GetPosition (Window*, Vec2i* out)
void Window_GetSize (Window*, Vec2i* out)
cstr Window_GetTitle (Window*)
void Window_SetFullscreen (Window*, bool)
void Window_SetPosition (Window*, WindowPos, WindowPos)
void Window_SetSize (Window*, int, int)
void Window_SetTitle (Window*, cstr)
void Window_SetVsync (Window*, bool)
void Window_ToggleFullscreen (Window*)
void Window_Hide (Window*)
void Window_Show (Window*)
```

### Input — 35 functions

```c
void Input_LoadGamepadDatabase (cstr filepath)
bool Input_GetPressed (Button)
bool Input_GetDown (Button)
bool Input_GetReleased (Button)
float Input_GetValue (Button)
float Input_GetIdleTime ()
void Input_GetActiveDevice (Device*)
DeviceType Input_GetActiveDeviceType ()
uint32 Input_GetActiveDeviceID ()
float Input_GetActiveDeviceIdleTime ()
bool Input_GetDevicePressed (Device*, Button)
bool Input_GetDeviceDown (Device*, Button)
bool Input_GetDeviceReleased (Device*, Button)
float Input_GetDeviceValue (Device*, Button)
float Input_GetDeviceIdleTime (Device*)
void Input_GetMouseDelta (Vec2i*)
float Input_GetMouseIdleTime ()
void Input_GetMousePosition (Vec2i*)
void Input_GetMouseScroll (Vec2i*)
void Input_SetMousePosition (Vec2i*)
void Input_SetMouseScroll (Vec2i*)
void Input_SetMouseVisible (bool)
void Input_SetMouseVisibleAuto ()
float Input_GetKeyboardIdleTime ()
bool Input_GetKeyboardMod (Modifier)
bool Input_GetKeyboardAlt ()
bool Input_GetKeyboardCtrl ()
bool Input_GetKeyboardShift ()
float Input_GetGamepadIdleTime (uint32 id)
bool Input_GetGamepadPressed (uint32 id, Button)
bool Input_GetGamepadDown (uint32 id, Button)
bool Input_GetGamepadReleased (uint32 id, Button)
float Input_GetGamepadValue (uint32 id, Button)
int32 Input_GetEventCount ()
bool Input_GetNextEvent (InputEvent*)
```

### InputBindings *(C only)* — 28 functions

```c
void InputBindings_Init ()
void InputBindings_Free ()
void InputBindings_Update ()
bool InputBinding_GetPressed (InputBinding*)
bool InputBinding_GetDown (InputBinding*)
bool InputBinding_GetReleased (InputBinding*)
float InputBinding_GetValue (InputBinding*)
Vec2f InputBinding_GetVecValue (InputBinding*)
float InputBinding_GetXValue (InputBinding*)
float InputBinding_GetYValue (InputBinding*)
bool InputBinding_GetXPosPressed (InputBinding*)
bool InputBinding_GetXPosDown (InputBinding*)
bool InputBinding_GetXPosReleased (InputBinding*)
bool InputBinding_GetXNegPressed (InputBinding*)
bool InputBinding_GetXNegDown (InputBinding*)
bool InputBinding_GetXNegReleased (InputBinding*)
bool InputBinding_GetYPosPressed (InputBinding*)
bool InputBinding_GetYPosDown (InputBinding*)
bool InputBinding_GetYPosReleased (InputBinding*)
bool InputBinding_GetYNegPressed (InputBinding*)
bool InputBinding_GetYNegDown (InputBinding*)
bool InputBinding_GetYNegReleased (InputBinding*)
InputBinding* InputBinding_SetDeadzone (InputBinding*, float)
InputBinding* InputBinding_SetExponent (InputBinding*, float)
InputBinding* InputBinding_SetInvertX (InputBinding*, bool)
InputBinding* InputBinding_SetInvertY (InputBinding*, bool)
InputBinding* InputBinding_SetRange (InputBinding*, float min, float max)
InputBinding* InputBinding_SetThresholds (InputBinding*, float press, float release)
```

### InputEvent — 1 function

```c
cstr InputEvent_ToString (InputEvent*)
```

### Button — 2 functions

```c
DeviceType Button_ToDeviceType (Button)
cstr Button_ToString (Button)
```

### Device — 2 functions

```c
bool Device_Equal (Device*, Device*)
cstr Device_ToString (Device*)
```

### DeviceType — 2 functions

```c
DeviceType DeviceType_FromButton (Button)
cstr DeviceType_ToString (DeviceType)
```

### Keyboard *(C only)* — 7 functions

```c
bool Keyboard_Down (Key)
bool Keyboard_Pressed (Key)
bool Keyboard_Released (Key)
double Keyboard_GetIdleTime ()
bool KeyMod_Alt ()
bool KeyMod_Ctrl ()
bool KeyMod_Shift ()
```

### Mouse *(C only)* — 10 functions

```c
void Mouse_GetDelta (Vec2i* out)
double Mouse_GetIdleTime ()
void Mouse_GetPosition (Vec2i* out)
void Mouse_GetPositionGlobal (Vec2i* out)
int Mouse_GetScroll ()
void Mouse_SetPosition (int, int)
void Mouse_SetVisible (bool)
bool Mouse_Down (MouseButton)
bool Mouse_Pressed (MouseButton)
bool Mouse_Released (MouseButton)
```

### Gamepad *(C only)* — 14 functions

```c
bool Gamepad_CanOpen (int index)
Gamepad* Gamepad_Open (int index)
void Gamepad_Close (Gamepad*)
int Gamepad_AddMappings (cstr file)
double Gamepad_GetAxis (Gamepad*, GamepadAxis)
double Gamepad_GetAxisDelta (Gamepad*, GamepadAxis)
bool Gamepad_GetButton (Gamepad*, GamepadButton)
double Gamepad_GetButtonPressed (Gamepad*, GamepadButton)
double Gamepad_GetButtonReleased (Gamepad*, GamepadButton)
double Gamepad_GetIdleTime (Gamepad*)
int Gamepad_GetID (Gamepad*)
cstr Gamepad_GetName (Gamepad*)
bool Gamepad_IsConnected (Gamepad*)
void Gamepad_SetDeadzone (Gamepad*, GamepadAxis, double)
```

### Joystick *(C only)* — 19 functions

```c
int Joystick_GetCount ()
Joystick* Joystick_Open (int index)
void Joystick_Close (Joystick*)
cstr Joystick_GetGUID (Joystick*)
cstr Joystick_GetGUIDByIndex (int index)
cstr Joystick_GetName (Joystick*)
cstr Joystick_GetNameByIndex (int index)
int Joystick_GetAxisCount (Joystick*)
int Joystick_GetBallCount (Joystick*)
int Joystick_GetButtonCount (Joystick*)
int Joystick_GetHatCount (Joystick*)
double Joystick_GetIdleTime (Joystick*)
double Joystick_GetAxis (Joystick*, int index)
bool Joystick_GetAxisAlive (Joystick*, int index)
double Joystick_GetAxisDelta (Joystick*, int index)
HatDir Joystick_GetHat (Joystick*, int index)
bool Joystick_ButtonDown (Joystick*, int index)
bool Joystick_ButtonPressed (Joystick*, int index)
bool Joystick_ButtonReleased (Joystick*, int index)
```

### Midi — 6 functions

```c
int MidiDevice_GetCount ()
MidiDevice* MidiDevice_Open (int index)
void MidiDevice_Close (MidiDevice*)
cstr MidiDevice_GetNameByIndex (int index)
bool MidiDevice_HasMessage (MidiDevice*)
Vec2i MidiDevice_PopMessage (MidiDevice*)
```

### Modifier — 1 function

```c
cstr Modifier_ToString (Modifier)
```

### VR *(C only)* — 20 functions

```c
bool VR_Exists ()
bool VR_Init ()
void VR_Free ()
Vec2i VR_GetResolution ()
Matrix VR_GetProjection (int eye, double z0, double z1)
Matrix VR_GetEyeTransform (int eye)
int VR_GetMaxAxis ()
int VR_GetMaxButton ()
int VR_GetMaxDevice ()
cstr VR_GetDeviceName (int index)
Matrix VR_GetDeviceTransform (int index)
VRDeviceType VR_GetDeviceType (int index)
bool VR_IsDeviceConnected (int index)
VRController* VR_OpenController (int index)
void VR_CloseController (VRController*)
Vec2d VR_GetAxis (VRController*, int button)
bool VR_GetButton (VRController*, int button)
void VR_Vibrate (VRController*, int axis, int microseconds)
void VR_GetTransforms ()
void VR_Render (int eye, Tex2D* texture)
```

## Rendering state

### BlendMode — 6 functions

```c
void BlendMode_Pop ()
void BlendMode_Push (BlendMode)
void BlendMode_PushAdditive ()
void BlendMode_PushAlpha ()
void BlendMode_PushDisabled ()
void BlendMode_PushPreMultAlpha ()
```

### CullFace — 5 functions

```c
void CullFace_Pop ()
void CullFace_Push (CullFace)
void CullFace_PushNone ()
void CullFace_PushBack ()
void CullFace_PushFront ()
```

### DepthTest — 4 functions

```c
void DepthTest_Pop ()
void DepthTest_Push (bool)
void DepthTest_PushDisabled ()
void DepthTest_PushEnabled ()
```

### RenderState — 12 functions

```c
void RenderState_PushAllDefaults ()
void RenderState_PushBlendMode (BlendMode)
void RenderState_PushCullFace (CullFace)
void RenderState_PushDepthTest (bool)
void RenderState_PushDepthWritable (bool)
void RenderState_PushWireframe (bool)
void RenderState_PopAll ()
void RenderState_PopBlendMode ()
void RenderState_PopCullFace ()
void RenderState_PopDepthTest ()
void RenderState_PopDepthWritable ()
void RenderState_PopWireframe ()
```

### RenderTarget — 12 functions

```c
void RenderTarget_Push (int sx, int sy)
void RenderTarget_Pop ()
void RenderTarget_BindTex2D (Tex2D*)
void RenderTarget_BindTex2DLevel (Tex2D*, int level)
void RenderTarget_BindTex3D (Tex3D*, int layer)
void RenderTarget_BindTex3DLevel (Tex3D*, int layer, int level)
void RenderTarget_BindTexCube (TexCube*, CubeFace)
void RenderTarget_BindTexCubeLevel (TexCube*, CubeFace, int level)
void RenderTarget_PushTex2D (Tex2D*)
void RenderTarget_PushTex2DLevel (Tex2D*, int level)
void RenderTarget_PushTex3D (Tex3D*, int layer)
void RenderTarget_PushTex3DLevel (Tex3D*, int layer, int level)
```

### ClipRect — 6 functions

```c
void ClipRect_Push (float x, float y, float sx, float sy)
void ClipRect_PushCombined (float x, float y, float sx, float sy)
void ClipRect_PushDisabled ()
void ClipRect_PushTransform (float tx, float ty, float sx, float sy)
void ClipRect_Pop ()
void ClipRect_PopTransform ()
```

### Viewport — 4 functions

```c
void Viewport_Pop ()
void Viewport_Push (int x, int y, int sx, int sy, bool isWindow)
float Viewport_GetAspect ()
void Viewport_GetSize (Vec2i* out)
```

### GLMatrix — 16 functions

```c
void GLMatrix_Clear ()
void GLMatrix_LookAt (Vec3d const* eye, Vec3d const* at, Vec3d const* up)
void GLMatrix_Load (Matrix* matrix)
void GLMatrix_ModeP ()
void GLMatrix_ModeWV ()
Matrix* GLMatrix_Get ()
void GLMatrix_Mult (Matrix* matrix)
void GLMatrix_Perspective (double degreesFovY, double aspect, double zNear, double zFar)
void GLMatrix_Pop ()
void GLMatrix_Push ()
void GLMatrix_PushClear ()
void GLMatrix_RotateX (double rads)
void GLMatrix_RotateY (double rads)
void GLMatrix_RotateZ (double rads)
void GLMatrix_Scale (double x, double y, double z)
void GLMatrix_Translate (double x, double y, double z)
```

### CubeFace — 1 function

```c
CubeFace CubeFace_Get (int index)
```

### State — 1 function

```c
cstr State_ToString (State)
```

## Drawing, meshes and textures

### Draw — 26 functions

```c
void Draw_Clear (float r, float g, float b, float a)
void Draw_ClearDepth (float d)
void Draw_Color (float r, float g, float b, float a)
void Draw_Flush ()
void Draw_LineWidth (float width)
void Draw_PointSize (float size)
void Draw_PushAlpha (float a)
void Draw_PopAlpha ()
void Draw_SmoothLines (bool)
void Draw_SmoothPoints (bool)
void Draw_Border (float s, float x, float y, float w, float h)
void Draw_Line (float x1, float y1, float x2, float y2)
void Draw_Point (float x, float y)
void Draw_Poly (Vec2f const* points, int count)
void Draw_Quad (Vec2f const* p1, Vec2f const* p2, Vec2f const* p3, Vec2f const* p4)
void Draw_Rect (float x, float y, float sx, float sy)
void Draw_Tri (Vec2f const* p1, Vec2f const* p2, Vec2f const* p3)
void Draw_Axes (Vec3f const* pos, Vec3f const* x, Vec3f const* y, Vec3f const* z, float scale, float alpha)
void Draw_Box3 (Box3f const* box)
void Draw_Line3 (Vec3f const* p1, Vec3f const* p2)
void Draw_Plane (Vec3f const* p, Vec3f const* n, float scale)
void Draw_Point3 (float x, float y, float z)
void Draw_Poly3 (Vec3f const* points, int count)
void Draw_Quad3 (Vec3f const* p1, Vec3f const* p2, Vec3f const* p3, Vec3f const* p4)
void Draw_Sphere (Vec3f const* p, float r)
void Draw_Tri3 (Vec3f const* p1, Vec3f const* p2, Vec3f const* p3)
```

### Mesh — 47 functions

```c
Mesh* Mesh_Create ()
void Mesh_Acquire (Mesh*)
void Mesh_Free (Mesh*)
Mesh* Mesh_Load (cstr name)
Mesh* Mesh_Clone (Mesh*)
Bytes* Mesh_ToBytes (Mesh*)
Mesh* Mesh_FromBytes (Bytes*)
Mesh* Mesh_FromObj (cstr)
Mesh* Mesh_FromSDF (SDF*)
void Mesh_AddIndex (Mesh*, int)
void Mesh_AddMesh (Mesh*, Mesh*)
void Mesh_AddQuad (Mesh*, int, int, int, int)
void Mesh_AddTri (Mesh*, int, int, int)
void Mesh_AddVertex (Mesh*, float px, float py, float pz, float nx, float ny, float nz, float u, float v)
void Mesh_AddVertexRaw (Mesh*, Vertex const*)
uint64 Mesh_GetVersion (Mesh*)
void Mesh_IncVersion (Mesh*)
void Mesh_GetBound (Mesh*, Box3f* out)
void Mesh_GetCenter (Mesh*, Vec3f* out)
int Mesh_GetIndexCount (Mesh*)
int* Mesh_GetIndexData (Mesh*)
float Mesh_GetRadius (Mesh*)
Vertex* Mesh_GetVertex (Mesh*, int)
int Mesh_GetVertexCount (Mesh*)
Vertex* Mesh_GetVertexData (Mesh*)
void Mesh_ReserveIndexData (Mesh*, int capacity)
void Mesh_ReserveVertexData (Mesh*, int capacity)
Error Mesh_Validate (Mesh*)
void Mesh_Draw (Mesh*)
void Mesh_DrawBind (Mesh*)
void Mesh_DrawBound (Mesh*)
void Mesh_DrawUnbind (Mesh*)
void Mesh_DrawNormals (Mesh*, float scale)
Mesh* Mesh_Center (Mesh*)
Mesh* Mesh_Invert (Mesh*)
Mesh* Mesh_RotateX (Mesh*, float rads)
Mesh* Mesh_RotateY (Mesh*, float rads)
Mesh* Mesh_RotateZ (Mesh*, float rads)
Mesh* Mesh_RotateYPR (Mesh*, float yaw, float pitch, float roll)
Mesh* Mesh_Scale (Mesh*, float x, float y, float z)
Mesh* Mesh_ScaleUniform (Mesh*, float)
Mesh* Mesh_Transform (Mesh*, Matrix*)
Mesh* Mesh_Translate (Mesh*, float x, float y, float z)
void Mesh_ComputeAO (Mesh*, float radius)
void Mesh_ComputeOcclusion (Mesh*, Tex3D* sdf, float radius)
void Mesh_ComputeNormals (Mesh*)
void Mesh_SplitNormals (Mesh*, float minDot)
```

### Meshes — 3 functions

```c
Mesh* Mesh_Box (int res)
Mesh* Mesh_BoxSphere (int res)
Mesh* Mesh_Plane (Vec3f origin, Vec3f du, Vec3f dv, int resU, int resV)
```

### BoxMesh — 4 functions

```c
BoxMesh* BoxMesh_Create ()
void BoxMesh_Free (BoxMesh*)
void BoxMesh_Add (BoxMesh*, float px, float py, float pz, float sx, float sy, float sz, float rx, float ry, float rz, float bx, float by, float bz)
Mesh* BoxMesh_GetMesh (BoxMesh*, int res)
```

### LodMesh — 6 functions

```c
LodMesh* LodMesh_Create ()
void LodMesh_Acquire (LodMesh*)
void LodMesh_Free (LodMesh*)
void LodMesh_Add (LodMesh*, Mesh*, float distMin, float distMax)
void LodMesh_Draw (LodMesh*, float distanceSquared)
Mesh* LodMesh_Get (LodMesh*, float distanceSquared)
```

### Tex1D — 16 functions

```c
Tex1D* Tex1D_Create (int size, TexFormat)
void Tex1D_Acquire (Tex1D*)
void Tex1D_Free (Tex1D*)
void Tex1D_Draw (Tex1D*, float x, float y, float xs, float ys)
void Tex1D_GenMipmap (Tex1D*)
void Tex1D_GetData (Tex1D*, void*, PixelFormat, DataFormat)
Bytes* Tex1D_GetDataBytes (Tex1D*, PixelFormat, DataFormat)
TexFormat Tex1D_GetFormat (Tex1D*)
uint Tex1D_GetHandle (Tex1D*)
uint Tex1D_GetSize (Tex1D*)
void Tex1D_SetData (Tex1D*, void const*, PixelFormat, DataFormat)
void Tex1D_SetDataBytes (Tex1D*, Bytes*, PixelFormat, DataFormat)
void Tex1D_SetMagFilter (Tex1D*, TexFilter)
void Tex1D_SetMinFilter (Tex1D*, TexFilter)
void Tex1D_SetTexel (Tex1D*, int x, float r, float g, float b, float a)
void Tex1D_SetWrapMode (Tex1D*, TexWrapMode)
```

### Tex2D — 28 functions

```c
Tex2D* Tex2D_Create (int sx, int sy, TexFormat)
Tex2D* Tex2D_Load (cstr name)
Tex2D* Tex2D_ScreenCapture ()
void Tex2D_Acquire (Tex2D*)
void Tex2D_Free (Tex2D*)
void Tex2D_Pop (Tex2D*)
void Tex2D_Push (Tex2D*)
void Tex2D_PushLevel (Tex2D*, int level)
void Tex2D_Clear (Tex2D*, float r, float g, float b, float a)
Tex2D* Tex2D_Clone (Tex2D*)
void Tex2D_Draw (Tex2D*, float x, float y, float sx, float sy)
void Tex2D_DrawEx (Tex2D*, float x0, float y0, float x1, float y1, float u0, float v0, float u1, float v1)
void Tex2D_GenMipmap (Tex2D*)
void Tex2D_GetData (Tex2D*, void*, PixelFormat, DataFormat)
Bytes* Tex2D_GetDataBytes (Tex2D*, PixelFormat, DataFormat)
TexFormat Tex2D_GetFormat (Tex2D*)
uint Tex2D_GetHandle (Tex2D*)
void Tex2D_GetSize (Tex2D*, Vec2i* out)
void Tex2D_GetSizeLevel (Tex2D*, Vec2i* out, int level)
void Tex2D_SetAnisotropy (Tex2D*, float)
void Tex2D_SetData (Tex2D*, void const*, PixelFormat, DataFormat)
void Tex2D_SetDataBytes (Tex2D*, Bytes*, PixelFormat, DataFormat)
void Tex2D_SetMagFilter (Tex2D*, TexFilter)
void Tex2D_SetMinFilter (Tex2D*, TexFilter)
void Tex2D_SetMipRange (Tex2D*, int minLevel, int maxLevel)
void Tex2D_SetTexel (Tex2D*, int x, int y, float r, float g, float b, float a)
void Tex2D_SetWrapMode (Tex2D*, TexWrapMode)
void Tex2D_Save (Tex2D*, cstr path)
```

### Tex3D — 19 functions

```c
Tex3D* Tex3D_Create (int sx, int sy, int sz, TexFormat)
void Tex3D_Acquire (Tex3D*)
void Tex3D_Free (Tex3D*)
void Tex3D_Pop (Tex3D*)
void Tex3D_Push (Tex3D*, int layer)
void Tex3D_PushLevel (Tex3D*, int layer, int level)
void Tex3D_Draw (Tex3D* self, int layer, float x, float y, float xs, float ys)
void Tex3D_GenMipmap (Tex3D*)
void Tex3D_GetData (Tex3D*, void*, PixelFormat, DataFormat)
Bytes* Tex3D_GetDataBytes (Tex3D*, PixelFormat, DataFormat)
TexFormat Tex3D_GetFormat (Tex3D*)
uint Tex3D_GetHandle (Tex3D*)
void Tex3D_GetSize (Tex3D*, Vec3i* out)
void Tex3D_GetSizeLevel (Tex3D*, Vec3i* out, int level)
void Tex3D_SetData (Tex3D*, void const*, PixelFormat, DataFormat)
void Tex3D_SetDataBytes (Tex3D*, Bytes*, PixelFormat, DataFormat)
void Tex3D_SetMagFilter (Tex3D*, TexFilter)
void Tex3D_SetMinFilter (Tex3D*, TexFilter)
void Tex3D_SetWrapMode (Tex3D*, TexWrapMode)
```

### TexCube — 19 functions

```c
TexCube* TexCube_Create (int size, TexFormat)
TexCube* TexCube_Load (cstr path)
void TexCube_Acquire (TexCube*)
void TexCube_Free (TexCube*)
void TexCube_Clear (TexCube*, float r, float g, float b, float a)
void TexCube_Generate (TexCube*, ShaderState*)
TexCube* TexCube_GenIRMap (TexCube*, int samples)
void TexCube_GenMipmap (TexCube*)
void TexCube_GetData (TexCube*, void*, CubeFace, int level, PixelFormat, DataFormat)
Bytes* TexCube_GetDataBytes (TexCube*, CubeFace, int level, PixelFormat, DataFormat)
TexFormat TexCube_GetFormat (TexCube*)
uint TexCube_GetHandle (TexCube*)
int TexCube_GetSize (TexCube*)
void TexCube_SetData (TexCube*, void const*, CubeFace, int level, PixelFormat, DataFormat)
void TexCube_SetDataBytes (TexCube*, Bytes*, CubeFace, int level, PixelFormat, DataFormat)
void TexCube_SetMagFilter (TexCube*, TexFilter)
void TexCube_SetMinFilter (TexCube*, TexFilter)
void TexCube_Save (TexCube*, cstr path)
void TexCube_SaveLevel (TexCube*, cstr path, int level)
```

### TexFormat — 5 functions

```c
int TexFormat_Components (TexFormat)
int TexFormat_GetSize (TexFormat)
bool TexFormat_IsColor (TexFormat)
bool TexFormat_IsDepth (TexFormat)
bool TexFormat_IsValid (TexFormat)
```

### PixelFormat — 1 function

```c
int PixelFormat_Components (PixelFormat)
```

### DataFormat — 1 function

```c
int DataFormat_GetSize (DataFormat)
```

## Shaders

### Shader — 33 functions

```c
Shader* Shader_Create (cstr vertCode, cstr fragCode)
Shader* Shader_Load (cstr vertName, cstr fragName)
void Shader_Acquire (Shader*)
void Shader_Free (Shader*)
ShaderState* Shader_ToShaderState (Shader*)
void Shader_Start (Shader*)
void Shader_Stop (Shader*)
uint Shader_GetHandle (Shader*)
int Shader_GetVariable (Shader*, cstr)
bool Shader_HasVariable (Shader*, cstr)
void Shader_ClearCache ()
void Shader_SetFloat (cstr, float)
void Shader_SetFloat2 (cstr, float, float)
void Shader_SetFloat3 (cstr, float, float, float)
void Shader_SetFloat4 (cstr, float, float, float, float)
void Shader_SetInt (cstr, int)
void Shader_SetMatrix (cstr, Matrix*)
void Shader_SetMatrixT (cstr, Matrix*)
void Shader_SetTex1D (cstr, Tex1D*)
void Shader_SetTex2D (cstr, Tex2D*)
void Shader_SetTex3D (cstr, Tex3D*)
void Shader_SetTexCube (cstr, TexCube*)
void Shader_ISetFloat (int, float)
void Shader_ISetFloat2 (int, float, float)
void Shader_ISetFloat3 (int, float, float, float)
void Shader_ISetFloat4 (int, float, float, float, float)
void Shader_ISetInt (int, int)
void Shader_ISetMatrix (int, Matrix*)
void Shader_ISetMatrixT (int, Matrix*)
void Shader_ISetTex1D (int, Tex1D*)
void Shader_ISetTex2D (int, Tex2D*)
void Shader_ISetTex3D (int, Tex3D*)
void Shader_ISetTexCube (int, TexCube*)
```

### ShaderState — 16 functions

```c
ShaderState* ShaderState_Create (Shader*)
void ShaderState_Acquire (ShaderState*)
void ShaderState_Free (ShaderState*)
ShaderState* ShaderState_FromShaderLoad (cstr vertName, cstr fragName)
void ShaderState_SetFloat (ShaderState*, cstr, float)
void ShaderState_SetFloat2 (ShaderState*, cstr, float, float)
void ShaderState_SetFloat3 (ShaderState*, cstr, float, float, float)
void ShaderState_SetFloat4 (ShaderState*, cstr, float, float, float, float)
void ShaderState_SetInt (ShaderState*, cstr, int)
void ShaderState_SetMatrix (ShaderState*, cstr, Matrix*)
void ShaderState_SetTex1D (ShaderState*, cstr, Tex1D*)
void ShaderState_SetTex2D (ShaderState*, cstr, Tex2D*)
void ShaderState_SetTex3D (ShaderState*, cstr, Tex3D*)
void ShaderState_SetTexCube (ShaderState*, cstr, TexCube*)
void ShaderState_Start (ShaderState*)
void ShaderState_Stop (ShaderState*)
```

### ShaderVar — 12 functions

```c
void* ShaderVar_Get (cstr, ShaderVarType)
void ShaderVar_PushFloat (cstr, float)
void ShaderVar_PushFloat2 (cstr, float, float)
void ShaderVar_PushFloat3 (cstr, float, float, float)
void ShaderVar_PushFloat4 (cstr, float, float, float, float)
void ShaderVar_PushInt (cstr, int)
void ShaderVar_PushMatrix (cstr, Matrix*)
void ShaderVar_PushTex1D (cstr, Tex1D*)
void ShaderVar_PushTex2D (cstr, Tex2D*)
void ShaderVar_PushTex3D (cstr, Tex3D*)
void ShaderVar_PushTexCube (cstr, TexCube*)
void ShaderVar_Pop (cstr)
```

### ShaderVarType — 4 functions

```c
ShaderVarType ShaderVarType_FromStr (cstr)
cstr ShaderVarType_GetGLSLName (ShaderVarType)
cstr ShaderVarType_GetName (ShaderVarType)
int ShaderVarType_GetSize (ShaderVarType)
```

## Text and UI

### Font — 8 functions

```c
Font* Font_Load (cstr name, int size)
void Font_Acquire (Font*)
void Font_Free (Font*)
void Font_Draw (Font*, cstr text, float x, float y, float r, float g, float b, float a)
void Font_DrawShaded (Font*, cstr text, float x, float y)
int Font_GetLineHeight (Font*)
void Font_GetSize (Font*, Vec4i* out, cstr text)
void Font_GetSize2 (Font*, Vec2i* out, cstr text)
```

### HmGui — 33 functions

```c
void HmGui_Begin (float sx, float sy)
void HmGui_End ()
void HmGui_Draw ()
void HmGui_BeginGroupX ()
void HmGui_BeginGroupY ()
void HmGui_BeginGroupStack ()
void HmGui_EndGroup ()
void HmGui_BeginScroll (float maxSize)
void HmGui_EndScroll ()
void HmGui_BeginWindow (cstr title)
void HmGui_EndWindow ()
bool HmGui_Button (cstr)
bool HmGui_Checkbox (cstr label, bool value)
float HmGui_Slider (float lower, float upper, float value)
void HmGui_Rect (float sx, float sy, float r, float g, float b, float a)
void HmGui_Image (Tex2D*)
void HmGui_Text (cstr text)
void HmGui_TextColored (cstr text, float r, float g, float b, float a)
void HmGui_TextEx (Font* font, cstr text, float r, float g, float b, float a)
void HmGui_SetAlign (float ax, float ay)
void HmGui_SetPadding (float px, float py)
void HmGui_SetPaddingEx (float left, float top, float right, float bottom)
void HmGui_SetPaddingLeft (float)
void HmGui_SetPaddingTop (float)
void HmGui_SetPaddingRight (float)
void HmGui_SetPaddingBottom (float)
void HmGui_SetSpacing (float)
void HmGui_SetStretch (float x, float y)
bool HmGui_GroupHasFocus (int type)
void HmGui_PushStyle ()
void HmGui_PushFont (Font*)
void HmGui_PushTextColor (float r, float g, float b, float a)
void HmGui_PopStyle (int depth)
```

### ImGui — 41 functions

```c
void ImGui_Begin (float sx, float sy)
void ImGui_End ()
void ImGui_Draw ()
void ImGui_AlignCursor (float sx, float sy, float alignX, float alignY)
float ImGui_GetCursorX ()
float ImGui_GetCursorY ()
void ImGui_PushCursor ()
void ImGui_PopCursor ()
void ImGui_SetCursor (float x, float y)
void ImGui_SetCursorX (float x)
void ImGui_SetCursorY (float y)
void ImGui_Indent ()
void ImGui_Undent ()
bool ImGui_Button (cstr label)
bool ImGui_ButtonEx (cstr label, float sx, float sy)
bool ImGui_Checkbox (bool value)
void ImGui_Divider ()
bool ImGui_Selectable (cstr label)
void ImGui_Tex2D (Tex2D*)
void ImGui_Text (cstr text)
void ImGui_TextColored (cstr text, float r, float g, float b, float a)
void ImGui_TextEx (Font* font, cstr text, float r, float g, float b, float a)
void ImGui_BeginGroupX (float sy)
void ImGui_BeginGroupY (float sx)
void ImGui_EndGroup ()
void ImGui_BeginPanel (float sx, float sy)
void ImGui_EndPanel ()
void ImGui_BeginWindow (cstr title, float sx, float sy)
void ImGui_EndWindow ()
void ImGui_BeginScrollFrame (float sx, float sy)
void ImGui_EndScrollFrame ()
void ImGui_PushStyle ()
void ImGui_PushStyleFont (Font*)
void ImGui_PushStylePadding (float px, float py)
void ImGui_PushStyleSpacing (float sx, float sy)
void ImGui_PushStyleTextColor (float r, float g, float b, float a)
void ImGui_PopStyle ()
void ImGui_SetFont (Font*)
void ImGui_SetSpacing (float sx, float sy)
void ImGui_SetNextWidth (float sx)
void ImGui_SetNextHeight (float sy)
```

### UIRenderer — 9 functions

```c
void UIRenderer_Begin ()
void UIRenderer_End ()
void UIRenderer_Draw ()
void UIRenderer_BeginLayer (float x, float y, float sx, float sy, bool clip)
void UIRenderer_EndLayer ()
void UIRenderer_Image (Tex2D*, float x, float y, float sx, float sy)
void UIRenderer_Panel (float x, float y, float sx, float sy, float r, float g, float b, float a, float bevel, float innerAlpha)
void UIRenderer_Rect (float x, float y, float sx, float sy, float r, float g, float b, float a, bool outline)
void UIRenderer_Text (Font* font, cstr text, float x, float y, float r, float g, float b, float a)
```

## Physics

### Physics — 18 functions

```c
Physics* Physics_Create ()
void Physics_Free (Physics*)
void Physics_AddRigidBody (Physics*, RigidBody*)
void Physics_RemoveRigidBody (Physics*, RigidBody*)
void Physics_AddTrigger (Physics*, Trigger*)
void Physics_RemoveTrigger (Physics*, Trigger*)
bool Physics_GetNextCollision (Physics*, Collision*)
void Physics_Update (Physics*, float dt)
void Physics_RayCast (Physics*, Ray*, RayCastResult*)
void Physics_SphereCast (Physics*, Sphere*, ShapeCastResult*)
void Physics_BoxCast (Physics*, Vec3f* pos, Quat* rot, Vec3f* halfExtents, ShapeCastResult*)
bool Physics_SphereOverlap (Physics*, Sphere*)
bool Physics_BoxOverlap (Physics*, Vec3f* pos, Quat* rot, Vec3f* halfExtents)
void Physics_PrintProfiling (Physics*)
void Physics_DrawBoundingBoxesLocal (Physics*)
void Physics_DrawBoundingBoxesWorld (Physics*)
void Physics_DrawTriggers (Physics*)
void Physics_DrawWireframes (Physics*)
```

### RigidBody — 42 functions

```c
RigidBody* RigidBody_CreateBox ()
RigidBody* RigidBody_CreateBoxFromMesh (Mesh*)
RigidBody* RigidBody_CreateSphere ()
RigidBody* RigidBody_CreateSphereFromMesh (Mesh*)
RigidBody* RigidBody_CreateHullFromMesh (Mesh*)
void RigidBody_Free (RigidBody*)
void RigidBody_ApplyForce (RigidBody*, Vec3f*)
void RigidBody_ApplyTorque (RigidBody*, Vec3f*)
void RigidBody_Attach (RigidBody*, RigidBody* other, Vec3f*, Quat*)
void RigidBody_Detach (RigidBody*, RigidBody* other)
void RigidBody_GetBoundingBox (RigidBody*, Box3f*)
void RigidBody_GetBoundingBoxCompound (RigidBody*, Box3f*)
void RigidBody_GetBoundingBoxLocal (RigidBody*, Box3f*)
void RigidBody_GetBoundingBoxLocalCompound (RigidBody*, Box3f*)
float RigidBody_GetBoundingRadius (RigidBody*)
float RigidBody_GetBoundingRadiusCompound (RigidBody*)
RigidBody* RigidBody_GetParentBody (RigidBody*)
float RigidBody_GetSpeed (RigidBody*)
Matrix* RigidBody_GetToLocalMatrix (RigidBody*)
Matrix* RigidBody_GetToWorldMatrix (RigidBody*)
void RigidBody_GetVelocity (RigidBody*, Vec3f*)
void RigidBody_GetVelocityA (RigidBody*, Vec3f*)
void RigidBody_SetCollidable (RigidBody*, bool)
void RigidBody_SetCollisionGroup (RigidBody*, int)
void RigidBody_SetCollisionMask (RigidBody*, int)
void RigidBody_SetDrag (RigidBody*, float linear, float angular)
void RigidBody_SetFriction (RigidBody*, float)
void RigidBody_SetKinematic (RigidBody*, bool)
void RigidBody_SetRestitution (RigidBody*, float)
void RigidBody_SetSleepThreshold (RigidBody*, float linear, float angular)
float RigidBody_GetMass (RigidBody*)
void RigidBody_SetMass (RigidBody*, float)
void RigidBody_GetPos (RigidBody*, Vec3f*)
void RigidBody_GetPosLocal (RigidBody*, Vec3f*)
void RigidBody_SetPos (RigidBody*, Vec3f*)
void RigidBody_SetPosLocal (RigidBody*, Vec3f*)
void RigidBody_GetRot (RigidBody*, Quat*)
void RigidBody_GetRotLocal (RigidBody*, Quat*)
void RigidBody_SetRot (RigidBody*, Quat*)
void RigidBody_SetRotLocal (RigidBody*, Quat*)
float RigidBody_GetScale (RigidBody*)
void RigidBody_SetScale (RigidBody*, float)
```

### Trigger — 10 functions

```c
Trigger* Trigger_CreateBox (Vec3f* halfExtents)
void Trigger_Free (Trigger*)
void Trigger_Attach (Trigger*, RigidBody*, Vec3f*)
void Trigger_Detach (Trigger*, RigidBody*)
void Trigger_GetBoundingBox (Trigger*, Box3f*)
int Trigger_GetContentsCount (Trigger*)
RigidBody* Trigger_GetContents (Trigger*, int)
void Trigger_SetCollisionMask (Trigger*, int)
void Trigger_SetPos (Trigger*, Vec3f*)
void Trigger_SetPosLocal (Trigger*, Vec3f*)
```

### CollisionShape *(C only)* — 8 functions

```c
CollisionShape* CollisionShape_Create (CollisionShape)
void CollisionShape_Free (CollisionShape*)
CollisionShape* CollisionShape_CreateBox (Vec3f* halfExtents)
CollisionShape* CollisionShape_CreateBoxFromMesh (Mesh*)
CollisionShape* CollisionShape_CreateSphere (float)
CollisionShape* CollisionShape_CreateSphereFromMesh (Mesh*)
CollisionShape* CollisionShape_CreateHullFromMesh (Mesh*)
CollisionShape* CollisionShape_GetCached (int)
```

## Audio

### Audio — 9 functions

```c
void Audio_Init ()
void Audio_Free ()
void Audio_AttachListenerPos (Vec3f const* pos, Vec3f const* vel, Vec3f const* fwd, Vec3f const* up)
void Audio_Set3DSettings (float doppler, float scale, float rolloff)
void Audio_SetListenerPos (Vec3f const* pos, Vec3f const* vel, Vec3f const* fwd, Vec3f const* up)
void Audio_Update ()
int32 Audio_GetLoadedCount ()
int32 Audio_GetPlayingCount ()
int32 Audio_GetTotalCount ()
```

### Sound — 32 functions

```c
void Sound_Acquire (Sound*)
void Sound_Free (Sound*)
Sound* Sound_Load (cstr name, bool isLooped, bool is3D)
Sound* Sound_LoadAsync (cstr name, bool isLooped, bool is3D)
Sound* Sound_Clone (Sound*)
void Sound_ToFile (Sound*, cstr)
void Sound_Pause (Sound*)
void Sound_Play (Sound*)
void Sound_Rewind (Sound*)
bool Sound_Get3D (Sound*)
float Sound_GetDuration (Sound*)
bool Sound_GetLooped (Sound*)
cstr Sound_GetName (Sound*)
cstr Sound_GetPath (Sound*)
bool Sound_IsFinished (Sound*)
bool Sound_IsPlaying (Sound*)
void Sound_Attach3DPos (Sound*, Vec3f const* pos, Vec3f const* vel)
void Sound_Set3DLevel (Sound*, float)
void Sound_Set3DPos (Sound*, Vec3f const* pos, Vec3f const* vel)
void Sound_SetFreeOnFinish (Sound*, bool)
void Sound_SetPan (Sound*, float)
void Sound_SetPitch (Sound*, float)
void Sound_SetPlayPos (Sound*, float)
void Sound_SetVolume (Sound*, float)
Sound* Sound_LoadPlay (cstr name, bool isLooped, bool is3D)
Sound* Sound_LoadPlayAttached (cstr name, bool isLooped, bool is3D, Vec3f const* pos, Vec3f const* vel)
void Sound_LoadPlayFree (cstr name, bool isLooped, bool is3D)
void Sound_LoadPlayFreeAttached (cstr name, bool isLooped, bool is3D, Vec3f const* pos, Vec3f const* vel)
Sound* Sound_ClonePlay (Sound*)
Sound* Sound_ClonePlayAttached (Sound*, Vec3f const* pos, Vec3f const* vel)
void Sound_ClonePlayFree (Sound*)
void Sound_ClonePlayFreeAttached (Sound*, Vec3f const* pos, Vec3f const* vel)
```

## Networking

### Socket — 13 functions

```c
Socket* Socket_Create (SocketType)
void Socket_Free (Socket*)
void Socket_Bind (Socket*, int port)
cstr Socket_Read (Socket*)
Bytes* Socket_ReadBytes (Socket*)
void Socket_Write (Socket*, cstr)
void Socket_WriteBytes (Socket*, Bytes*)
Socket* Socket_Accept (Socket*)
void Socket_Listen (Socket*)
int Socket_ReceiveFrom (Socket*, void* data, size_t len)
cstr Socket_GetAddress (Socket*)
void Socket_SetAddress (Socket*, cstr addr)
int Socket_SendTo (Socket*, void const* data, size_t len)
```

## Header-only / type-only modules

These headers define types, constants or macros but no exported functions: `Array`, `ArrayList`, `Bullet`, `FMODError`, `GamepadAxis`, `GamepadButton`, `HatDir`, `Key`, `LinkedList`, `List`, `Macro`, `MatrixDef`, `MouseButton`, `PhxConfig`, `PhxFloat`, `PhxInt`, `PhxString`, `PhysicsDefs`, `Random`, `RefCounted`, `SDL`, `SocketType`, `SoundDef`, `Sphere`, `Vertex`.
