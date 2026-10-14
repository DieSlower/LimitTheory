@echo off
rem Prints keyboard / mouse / gamepad events to the console
rem Runs script\App\InputTest.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - InputTest
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo Starting InputTest: Prints keyboard / mouse / gamepad events to the console
"bin\lt64.exe" InputTest
if errorlevel 1 (
  echo.
  echo InputTest exited with error code %errorlevel%.
  pause
)
endlocal
