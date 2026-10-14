@echo off
rem FMOD audio test
rem Runs script\App\FMODTest.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - FMODTest
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo WARNING: known problem on a clean checkout - undefined global Key.
echo Starting FMODTest: FMOD audio test
"bin\lt64.exe" FMODTest
if errorlevel 1 (
  echo.
  echo FMODTest exited with error code %errorlevel%.
  pause
)
endlocal
