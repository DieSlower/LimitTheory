@echo off
rem Interactive menu of every runnable app and tool.
setlocal
cd /d "%~dp0"
:menu
cls
echo ==========================================
echo   Limit Theory launcher
echo ==========================================
echo    1. LTheory      - Limit Theory - the main game ^(flight, combat, command, docking^)
echo    2. TestEcon     - Economy simulation ^(stations, factories, miners, traders^)
echo    3. PhysicsTest  - Physics / collision / trigger sandbox
echo    4. BSPTest      - BSP / mesh generation viewer and benchmarks
echo    5. CoordTest    - Coordinate, quaternion and matrix tests
echo    6. InputTest    - Prints keyboard / mouse / gamepad events to the console
echo    7. TestHmGui    - Immediate-mode GUI ^(HmGui^) widget demo
echo    8. TestStrMap   - String-map unit test ^(console^)
echo    9. TestImGui    - ImGui-style demo [needs screenshot\wp2.png]
echo   10. Todo         - Project to-do checklist UI [needs screenshot\wp2.png]
echo   11. TestIcon     - Icon test [known broken]
echo   12. FMODTest     - FMOD audio test [known broken]
echo   13. GenTex2D     - Procedural texture generation test [known broken]
echo.
echo   B. Build           C. Clean build output
echo   Q. Quit
echo.
set CHOICE=
set /p CHOICE=Choose: 
if /i "%CHOICE%"=="Q" exit /b 0
if /i "%CHOICE%"=="B" call "%~dp0Build.bat" & goto menu
if /i "%CHOICE%"=="C" call "%~dp0Clean.bat" & goto menu
if "%CHOICE%"=="1" call "%~dp0Game.bat" & goto menu
if "%CHOICE%"=="2" call "%~dp0Economy-Simulation.bat" & goto menu
if "%CHOICE%"=="3" call "%~dp0Physics-Sandbox.bat" & goto menu
if "%CHOICE%"=="4" call "%~dp0BSP-Mesh-Viewer.bat" & goto menu
if "%CHOICE%"=="5" call "%~dp0Coordinate-Test.bat" & goto menu
if "%CHOICE%"=="6" call "%~dp0Input-Test.bat" & goto menu
if "%CHOICE%"=="7" call "%~dp0GUI-Demo-HmGui.bat" & goto menu
if "%CHOICE%"=="8" call "%~dp0StrMap-Test.bat" & goto menu
if "%CHOICE%"=="9" call "%~dp0GUI-Demo-ImGui.bat" & goto menu
if "%CHOICE%"=="10" call "%~dp0Todo-Checklist.bat" & goto menu
if "%CHOICE%"=="11" call "%~dp0Icon-Test.bat" & goto menu
if "%CHOICE%"=="12" call "%~dp0Audio-Test-FMOD.bat" & goto menu
if "%CHOICE%"=="13" call "%~dp0Texture-Generator.bat" & goto menu
goto menu
