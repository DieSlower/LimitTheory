@echo off
rem ImGui-style demo
rem Runs script\App\TestImGui.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - TestImGui
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
if not exist "screenshot\wp2.png" (
  echo NOTE: this app needs screenshot\wp2.png ^(any image^). Create the folder and file first.
  echo Continuing anyway...
)
echo Starting TestImGui: ImGui-style demo
"bin\lt64.exe" TestImGui
if errorlevel 1 (
  echo.
  echo TestImGui exited with error code %errorlevel%.
  pause
)
endlocal
