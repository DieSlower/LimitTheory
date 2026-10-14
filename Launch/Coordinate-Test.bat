@echo off
rem Coordinate, quaternion and matrix tests
rem Runs script\App\CoordTest.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - CoordTest
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo Starting CoordTest: Coordinate, quaternion and matrix tests
"bin\lt64.exe" CoordTest
if errorlevel 1 (
  echo.
  echo CoordTest exited with error code %errorlevel%.
  pause
)
endlocal
