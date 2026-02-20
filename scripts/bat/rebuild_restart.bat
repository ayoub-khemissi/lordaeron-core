@echo off
echo ========================================
echo    TrinityCore Rebuild + Restart Script
echo ========================================
echo.

pushd "%~dp0..\.."
set "ROOT=%CD%"
popd

REM Kill running servers
echo [1/4] Stopping servers...
taskkill /F /IM authserver.exe 2>nul
if %errorlevel%==0 (echo       authserver.exe stopped) else (echo       authserver.exe was not running)
taskkill /F /IM worldserver.exe 2>nul
if %errorlevel%==0 (echo       worldserver.exe stopped) else (echo       worldserver.exe was not running)
echo.

REM Build the project
echo [2/4] Building project (Release)...
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

echo [3/4] Build successful!
echo.

REM Start servers
echo [4/4] Starting servers from %BIN_DIR%...
cd /d "%BIN_DIR%"
start "" authserver.exe
echo       authserver.exe started
timeout /t 2 /nobreak >nul
start "" worldserver.exe
echo       worldserver.exe started
echo.

echo ========================================
echo    Done!
echo ========================================
