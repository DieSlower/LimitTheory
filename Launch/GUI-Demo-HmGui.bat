@echo off
rem Immediate-mode GUI (HmGui) widget demo
rem Runs script\App\TestHmGui.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - TestHmGui
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo Starting TestHmGui: Immediate-mode GUI (HmGui) widget demo
"bin\lt64.exe" TestHmGui
if errorlevel 1 (
  echo.
  echo TestHmGui exited with error code %errorlevel%.
  pause
)
endlocal
