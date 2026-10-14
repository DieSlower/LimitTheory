@echo off
rem Limit Theory - the main game (flight, combat, command, docking)
rem Runs script\App\LTheory.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - LTheory
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo Starting LTheory: Limit Theory - the main game (flight, combat, command, docking)
"bin\lt64.exe" LTheory
if errorlevel 1 (
  echo.
  echo LTheory exited with error code %errorlevel%.
  pause
)
endlocal
