@echo off
rem Physics / collision / trigger sandbox
rem Runs script\App\PhysicsTest.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - PhysicsTest
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo Starting PhysicsTest: Physics / collision / trigger sandbox
"bin\lt64.exe" PhysicsTest
if errorlevel 1 (
  echo.
  echo PhysicsTest exited with error code %errorlevel%.
  pause
)
endlocal
