@echo off
echo ========================================
echo    TrinityCore Restart Script
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

REM Find the output directory
set "BIN_DIR=%ROOT%\build\bin\Release"
if not exist "%BIN_DIR%\worldserver.exe" (
    set "BIN_DIR=%ROOT%\build\bin\RelWithDebInfo"
)
if not exist "%BIN_DIR%\worldserver.exe" (
    echo ERROR: Could not find worldserver.exe in build output
    pause
    exit /b 1
)

REM Start servers
echo [2/2] Starting servers from %BIN_DIR%...
cd /d "%BIN_DIR%"
start "" authserver.exe
echo       authserver.exe started
timeout /t 2 /nobreak >nul
start "" worldserver.exe
echo       worldserver.exe started
echo.

echo ========================================
echo    Servers restarted!
echo ========================================
