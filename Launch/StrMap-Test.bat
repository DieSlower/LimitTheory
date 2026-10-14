@echo off
rem String-map unit test (console)
rem Runs script\App\TestStrMap.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - TestStrMap
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo Starting TestStrMap: String-map unit test (console)
"bin\lt64.exe" TestStrMap
if errorlevel 1 (
  echo.
  echo TestStrMap exited with error code %errorlevel%.
  pause
)
endlocal
