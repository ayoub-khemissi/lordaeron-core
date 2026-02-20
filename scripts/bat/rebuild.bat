@echo off
echo ========================================
echo    TrinityCore Rebuild Script
echo ========================================
echo.

pushd "%~dp0..\.."
set "ROOT=%CD%"
popd

REM Kill running servers
echo [1/2] Stopping servers...
taskkill /F /IM authserver.exe 2>nul
if %errorlevel%==0 (echo       authserver.exe stopped) else (echo       authserver.exe was not running)
taskkill /F /IM worldserver.exe 2>nul
if %errorlevel%==0 (echo       worldserver.exe stopped) else (echo       worldserver.exe was not running)
echo.

REM Build the project
echo [2/2] Building project (Release)...
echo.
cmake --build "%ROOT%\build" --config Release
if %errorlevel% neq 0 (
    echo.
    echo ========================================
    echo    BUILD FAILED!
    echo ========================================
    pause
    exit /b 1
)
echo.

echo ========================================
echo    Build completed successfully!
echo ========================================
