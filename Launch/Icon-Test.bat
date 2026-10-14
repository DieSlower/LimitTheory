@echo off
rem Icon test
rem Runs script\App\TestIcon.lua through bin\lt64.exe.
setlocal
cd /d "%~dp0.."
title Limit Theory - TestIcon
if not exist "bin\lt64.exe" (
  echo bin\lt64.exe not found. Run Launch\Build.bat first.
  pause
  exit /b 1
)
echo WARNING: known problem on a clean checkout - undefined global Icon.
echo Starting TestIcon: Icon test
"bin\lt64.exe" TestIcon
if errorlevel 1 (
  echo.
  echo TestIcon exited with error code %errorlevel%.
  pause
)
endlocal
