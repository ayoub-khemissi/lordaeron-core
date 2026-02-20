@echo off
:: ============================================================================
:: apply_config.bat
:: Reads worldserver.init and applies properties onto worldserver.conf
:: If worldserver.conf doesn't exist, it is copied from worldserver.conf.dist
:: Both files are expected in the build output directory.
:: ============================================================================
setlocal

pushd "%~dp0..\.."
set "ROOT=%CD%"
popd

:: Locate build output directory
set "DIR=%ROOT%\build\bin\Release"
if not exist "%DIR%\worldserver.exe" (
    set "DIR=%ROOT%\build\bin\RelWithDebInfo"
)
if not exist "%DIR%\worldserver.exe" (
    echo [ERROR] Could not find worldserver.exe in build output
    pause
    exit /b 1
)

if not exist "%DIR%\worldserver.init" (
    echo [ERROR] worldserver.init not found in %DIR%
    pause
    exit /b 1
)

if not exist "%DIR%\worldserver.conf" (
    if exist "%DIR%\worldserver.conf.dist" (
        echo worldserver.conf not found, copying from worldserver.conf.dist...
        copy "%DIR%\worldserver.conf.dist" "%DIR%\worldserver.conf" >nul
    ) else (
        echo [ERROR] worldserver.conf not found in %DIR%
        pause
        exit /b 1
    )
)

echo Applying worldserver.init onto worldserver.conf in %DIR%...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$confPath = '%DIR%\worldserver.conf';" ^
"$initLines = Get-Content '%DIR%\worldserver.init';" ^
"$conf = [IO.File]::ReadAllText($confPath);" ^
"$count = 0;" ^
"foreach ($line in $initLines) {" ^
"  $line = $line.Trim();" ^
"  if ($line -eq '' -or $line.StartsWith('#')) { continue }" ^
"  if ($line -match '^\s*([A-Za-z0-9_.]+)\s*=\s*(.*)$') {" ^
"    $key = $Matches[1]; $val = $Matches[2].Trim();" ^
"    $escaped = [regex]::Escape($key);" ^
"    $pattern = '(?m)^(' + $escaped + '\s*=\s*).*$';" ^
"    if ($conf -match $pattern) {" ^
"      $conf = $conf -replace $pattern, ('${1}' + $val);" ^
"      $count++;" ^
"      Write-Host ('  [OK] ' + $key + ' = ' + $val);" ^
"    } else {" ^
"      Write-Host ('  [SKIP] ' + $key + ' not found in worldserver.conf');" ^
"    }" ^
"  }" ^
"}" ^
"[IO.File]::WriteAllText($confPath, $conf);" ^
"Write-Host ''; Write-Host ($count.ToString() + ' property(ies) updated.')"

echo.
pause
