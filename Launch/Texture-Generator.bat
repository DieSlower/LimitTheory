@echo off
rem Procedural texture generation test
rem Runs script\App\GenTex2D.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - GenTex2D
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo WARNING: known problem on a clean checkout - crashes (memory access violation).
echo Starting GenTex2D: Procedural texture generation test
"bin\lt64.exe" GenTex2D
if errorlevel 1 (
  echo.
  echo GenTex2D exited with error code %errorlevel%.
  pause
)
endlocal
