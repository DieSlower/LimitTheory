@echo off
rem Deletes generated build output (build\ and bin\). Source files are untouched.
setlocal
cd /d "%~dp0.."
set /p ANSWER=Delete build\ and bin\ folders? (y/N): 
if /i not "%ANSWER%"=="y" exit /b 0
if exist build rmdir /s /q build
if exist bin rmdir /s /q bin
echo Done. Run Launch\Build.bat to rebuild.
pause
