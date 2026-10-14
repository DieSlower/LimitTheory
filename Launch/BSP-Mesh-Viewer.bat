@echo off
rem BSP / mesh generation viewer and benchmarks
rem Runs script\App\BSPTest.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - BSPTest
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo Starting BSPTest: BSP / mesh generation viewer and benchmarks
"bin\lt64.exe" BSPTest
if errorlevel 1 (
  echo.
  echo BSPTest exited with error code %errorlevel%.
  pause
)
endlocal
