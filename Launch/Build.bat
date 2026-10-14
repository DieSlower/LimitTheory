@echo off
rem Configures (first time) and builds Limit Theory + libphx in RelWithDebInfo.
rem Requires: Visual Studio 2022 (Desktop C++), CMake 3.21+ (4.x needs the policy flag below).
setlocal
cd /d "%~dp0.."
where cmake >nul 2>nul
if errorlevel 1 (
  echo CMake was not found on PATH.
  pause
  exit /b 1
)
if not exist "build\CMakeCache.txt" (
  echo === Configuring ===
  cmake -S . -B build -G "Visual Studio 17 2022" -A x64 -DCMAKE_POLICY_VERSION_MINIMUM=3.5
  if errorlevel 1 goto :fail
)
echo === Building RelWithDebInfo ===
cmake --build build --config RelWithDebInfo
if errorlevel 1 goto :fail
echo.
echo Build finished: bin\lt64.exe
pause
exit /b 0
:fail
echo.
echo BUILD FAILED - see output above.
pause
exit /b 1
