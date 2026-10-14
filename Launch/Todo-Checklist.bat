@echo off
rem Project to-do checklist UI
rem Runs script\App\Todo.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - Todo
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
if not exist "screenshot\wp2.png" (
  echo NOTE: this app needs screenshot\wp2.png ^(any image^). Create the folder and file first.
  echo Continuing anyway...
)
echo Starting Todo: Project to-do checklist UI
"bin\lt64.exe" Todo
if errorlevel 1 (
  echo.
  echo Todo exited with error code %errorlevel%.
  pause
)
endlocal
