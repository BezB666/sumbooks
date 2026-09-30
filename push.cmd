@echo off
rem ============================================================
rem  push.cmd - commit all changes and push them to GitHub
rem  Usage:
rem     push.cmd                  - auto commit message (from changed folders)
rem     push.cmd "commit message"  - your own message
rem  Everything is mirrored to push.log next to this file.
rem  NOTE: keep this file ASCII-only, cmd.exe reads .cmd in the
rem        system codepage (cp866) and mangles UTF-8 text.
rem ============================================================

setlocal enabledelayedexpansion
cd /d "%~dp0"

set "LOG=push.log"

set "STAMP=%DATE% %TIME%"
echo.>>"%LOG%"
echo === %STAMP% ===>>"%LOG%"

echo === Branch and remote ===
git branch --show-current
git remote -v
echo.

rem --- 0. Are we on main? Committing to another branch is usually a mistake ---
for /f "delims=" %%b in ('git branch --show-current') do set "BRANCH=%%b"
if /i not "%BRANCH%"=="main" (
    echo WARNING: current branch is "%BRANCH%", not "main".
    echo   This script pushes to main. Press Ctrl+C to abort, or
    pause
)

rem --- 1. Stage everything except ignored files ---
git add . >>"%LOG%" 2>&1
if errorlevel 1 goto :fail

rem --- 2. Nothing staged? Just make sure the remote is up to date ---
git diff --cached --quiet >nul 2>&1
if not errorlevel 1 goto :clean

rem --- 3. Commit message: argument, or "update <folders>" ---
rem delims=/ splits each staged path and for /f keeps only the FIRST component,
rem which is exactly the top-level folder (or the file name for root files).
set "SCOPE="
for /f "delims=/" %%d in ('git diff --cached --name-only') do (
    if not "%%d"=="" echo !SCOPE! | findstr /i /c:"|%%d|" >nul
    if not "%%d"=="" if errorlevel 1 set "SCOPE=!SCOPE!|%%d|"
)

rem --- 4. Commit message: argument, or "update <folders>" ---
set "MSG=%~1"
if "%MSG%"=="" (
    set "LIST=!SCOPE:|=%"
    set "LIST=!LIST:|=, !"
    if "!LIST!"=="" set "LIST=changes"
    set "MSG=update !LIST!"
)

echo.
echo Commit message: !MSG!
echo.

git commit -m "!MSG!" >>"%LOG%" 2>&1
if errorlevel 1 goto :fail

rem --- 5. Push (sets upstream on first run) ---
git push -u origin main >>"%LOG%" 2>&1
if errorlevel 1 goto :fail

call :show_result
exit /b 0

rem ============================================================
:clean
rem Nothing staged: still check for commits that were never pushed
echo Nothing to commit: working tree is clean.
git push >>"%LOG%" 2>&1
if errorlevel 1 goto :fail

call :show_result
exit /b 0

rem ============================================================
:show_result
for /f "delims=" %%u in ('git remote get-url origin') do set "URL=%%u"
for /f "delims=" %%h in ('git rev-parse --short HEAD') do set "HASH=%%h"
set "WEB=!URL:.git=!"
set "WEB=!WEB:git@github.com:=https://github.com/!"

echo ============================================
echo  Done: changes pushed to GitHub.
echo  Repo:    !WEB!
echo  Commit:  !WEB!/commit/!HASH!
echo  Log:     %LOG%
echo ============================================
echo Pushed !HASH! to !WEB!/commit/!HASH!>>"%LOG%"
endlocal
exit /b 0

rem ============================================================
:fail
echo.
echo ============================================
echo  FAILED (exit code %errorlevel%). Nothing pushed.
echo  Common causes:
echo    - no access to github.com (403 / expired token)
echo    - conflict: run "git pull --rebase" first
echo  Full output: %LOG%
echo ============================================
echo FAILED with exit code %errorlevel% - see log above>>"%LOG%"
endlocal
exit /b 1
