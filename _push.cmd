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

rem --- Make sure git is reachable -------------------------------------------
rem Symptom this guards against: a plain "git branch --show-current" works, but
rem the same command inside for /f says "'git' is not recognized". Reason: the
rem environment can contain PATH and Path as two separate entries, and the child
rem cmd.exe spawned for for /f inherits only one of them, losing the Git folder.
rem A stock cmd window still finds git.cmd (its own Path), this script does not.
rem Fix: locate git once and call it by the absolute path via %GIT%.
set "GIT="
call :find_git
if not defined GIT goto :no_git

set "STAMP=%DATE% %TIME%"
echo.>>"%LOG%"
echo === %STAMP% ===>>"%LOG%"

echo === Branch and remote ===
"%GIT%" branch --show-current
"%GIT%" remote -v
echo.

rem --- 0. Are we on main? Committing to another branch is usually a mistake ---
set "BRANCH="
for /f "delims=" %%b in ('"%GIT%" branch --show-current') do set "BRANCH=%%b"
if not defined BRANCH (
    echo FAILED: could not read the current branch.
    echo   Git was found at: %GIT%
    echo   "git branch --show-current" returned nothing - normally this means
    echo   the repository has no commits yet, or this is not a git work tree.
    goto :fail
)
if /i not "%BRANCH%"=="main" (
    echo WARNING: current branch is "%BRANCH%", not "main".
    echo   This script pushes to main. Press Ctrl+C to abort.
    echo.
    echo   Continuing in 10 seconds...
    >"nul" 2>&1 (timeout /t 10 /nobreak || ping -n 11 127.0.0.1)
)

rem --- 1. Stage everything except ignored files ---
"%GIT%" add . >>"%LOG%" 2>&1
if errorlevel 1 goto :fail

rem --- 2. Nothing staged? Just make sure the remote is up to date ---
"%GIT%" diff --cached --quiet >nul 2>&1
if not errorlevel 1 goto :clean

rem --- 3. Commit message: argument, or "update <folders>" ---
rem delims=/ splits each staged path and for /f keeps only the FIRST component,
rem which is exactly the top-level folder (or the file name for root files).
set "SCOPE="
for /f "delims=/" %%d in ('"%GIT%" diff --cached --name-only') do (
    if not "%%d"=="" echo !SCOPE! | findstr /i /c:"|%%d|" >nul
    if not "%%d"=="" if errorlevel 1 set "SCOPE=!SCOPE!|%%d|"
)

rem --- 4. Commit message: argument, or "update <folders>" ---
rem NOTE: no ( ) block here on purpose. Inside a block cmd expands %VAR% once,
rem before the block runs, so "if %MSG%=="" would always be true.
set "MSG=%~1"
if not "%MSG%"=="" goto :have_msg

set "LIST=!SCOPE:|=%"
set "LIST=!LIST:|=, !"
if "!LIST!"=="" set "LIST=changes"
set "MSG=update !LIST!"

:have_msg
echo.
echo Commit message: !MSG!
echo.

"%GIT%" commit -m "!MSG!" >>"%LOG%" 2>&1
if errorlevel 1 goto :fail

rem --- 5. Push (sets upstream on first run) ---
"%GIT%" push -u origin main >>"%LOG%" 2>&1
if errorlevel 1 goto :fail

call :show_result
exit /b 0

rem ============================================================
:clean
rem Nothing staged: still check for commits that were never pushed
echo Nothing to commit: working tree is clean.
"%GIT%" push >>"%LOG%" 2>&1
if errorlevel 1 goto :fail

call :show_result
exit /b 0

rem ============================================================
:show_result
for /f "delims=" %%u in ('"%GIT%" remote get-url origin') do set "URL=%%u"
for /f "delims=" %%h in ('"%GIT%" rev-parse --short HEAD') do set "HASH=%%h"
set "WEB=!URL:.git=!"
set "WEB=!WEB:git@github.com:=https://github.com/!"

echo ============================================
echo  Done: changes pushed to GitHub.
echo  Repo:    !WEB!
echo  Commit:  !WEB!/commit/!HASH!
echo  Log:     %LOG%
echo ============================================
echo Pushed !HASH! to !WEB!/commit/!HASH!>>"%LOG%"
call :delay
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
call :delay
endlocal
exit /b 1

rem ============================================================
:delay
rem Keep the console window open for 10 seconds so the result of
rem a double-clicked run can be read before the window disappears.
rem (timeout/ping are used instead of pause so no key press is needed;
rem  >nul on the whole line also silences the "Waiting for 0 seconds" text.)
echo.
echo This window closes in 10 seconds...
>"nul" 2>&1 (timeout /t 10 /nobreak || ping -n 11 127.0.0.1)
exit /b 0

rem ============================================================
:find_git
rem "where git" reports git.exe AND git.cmd/git.bat (the /mingw64/cmd shims).
rem Both work, so the first hit is used. The usual install locations are checked
rem as a fallback because PATH may be missing from the child environment.
for /f "delims=" %%g in ('where git 2^>nul') do if not defined GIT set "GIT=%%g"
if defined GIT exit /b 0
if exist "%ProgramFiles%\Git\cmd\git.exe" set "GIT=%ProgramFiles%\Git\cmd\git.exe"
if defined GIT exit /b 0
if exist "%ProgramFiles(x86)%\Git\cmd\git.exe" set "GIT=%ProgramFiles(x86)%\Git\cmd\git.exe"
if defined GIT exit /b 0
if exist "%LocalAppData%\Programs\Git\cmd\git.exe" set "GIT=%LocalAppData%\Programs\Git\cmd\git.exe"
if defined GIT exit /b 0
if exist "%ProgramFiles%\Git\bin\git.exe" set "GIT=%ProgramFiles%\Git\bin\git.exe"
exit /b 0

rem ============================================================
:no_git
rem Starts with a blank line because "echo." is unusable in a labeled block
rem (cmd's echo. trick fails when a label such as :no_git precedes it).
echo.
echo ============================================
echo  FAILED: git.exe was not found.
echo  Looked in PATH, "%ProgramFiles%\Git\cmd",
echo  "%ProgramFiles(x86)%\Git\cmd" and
echo  "%LocalAppData%\Programs\Git\cmd".
echo  Install Git for Windows or add its cmd folder to PATH.
echo ============================================
echo FAILED: git not found>>"%LOG%"
call :delay
endlocal
exit /b 1
