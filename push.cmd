@echo off
rem ============================================================
rem  push.cmd - commit all changes and push them to GitHub
rem  Usage:
rem     push.cmd                  - auto commit message
rem     push.cmd "commit message"  - your own message
rem  NOTE: keep this file ASCII-only, cmd.exe reads .cmd in the
rem        system codepage (cp866) and mangles UTF-8 text.
rem ============================================================

cd /d "%~dp0"

echo === Branch and remote ===
git branch --show-current
git remote -v
echo.

echo === Changes to commit ===
git status --short
echo.

rem --- 1. Stage everything except ignored files ---
git add .
if errorlevel 1 goto :fail

rem --- 2. Nothing staged? Just make sure the remote is up to date ---
git diff --cached --quiet
if not errorlevel 1 (
    echo Nothing to commit: working tree is clean.
    echo Checking for unpushed commits...
    git push
    if errorlevel 1 goto :fail
    echo.
    echo Done.
    exit /b 0
)

rem --- 3. Commit message: argument or auto-generated ---
set "MSG=%~1"
if "%MSG%"=="" set "MSG=update %DATE% %TIME%"

rem --- 4. Commit ---
git commit -m "%MSG%"
if errorlevel 1 goto :fail

rem --- 5. Push (sets upstream on first run) ---
git push -u origin main
if errorlevel 1 goto :fail

echo.
echo ============================================
echo  Done: changes pushed to GitHub.
echo ============================================
exit /b 0

:fail
echo.
echo ============================================
echo  FAILED (exit code %errorlevel%). Nothing pushed.
echo  Common causes:
echo    - no access to github.com (403 / expired token)
echo    - conflict: run "git pull --rebase" first
echo ============================================
exit /b 1
