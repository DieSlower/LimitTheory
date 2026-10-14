@echo off
rem Economy simulation (stations, factories, miners, traders)
rem Runs script\App\TestEcon.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - TestEcon
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo Starting TestEcon: Economy simulation (stations, factories, miners, traders)
"bin\lt64.exe" TestEcon
if errorlevel 1 (
  echo.
  echo TestEcon exited with error code %errorlevel%.
  pause
)
endlocal
