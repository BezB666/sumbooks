@echo off
rem ============================================================
rem  push2.cmd - same as push.cmd, with the reported problems fixed.
rem
rem  Differences from push.cmd:
rem    1. git is located once and called by absolute path, because
rem       "C:\Program Files\Git\cmd" is not always in PATH. That is why a
rem       bare "git" worked on one line and failed on the next.
rem    2. A child cmd (what for /f spawns) may run with a broken or empty
rem       PATH, so every for /f that used to call git directly now does not
rem       depend on PATH at all.
rem    3. The auto commit message no longer goes through
rem       "set LIST=!SCOPE:|=%". That substitution came out as the literal
rem       text "update SCOPE:, =" on the machine where this was reported.
rem       The message is now built by :join_scope, which copies characters.
rem    4. The branch warning no longer ends in "pause" (it ate the window on
rem       a keypress); it waits 10 seconds like the end of the script.
rem    5. An unreadable branch is now a hard failure instead of a warning.
rem
rem  Usage is unchanged:
rem     push2.cmd                  - auto commit message (from changed folders)
rem     push2.cmd "commit message"  - your own message
rem  Everything is mirrored to push2.log next to this file.
rem  NOTE: keep this file ASCII-only, cmd.exe reads .cmd in the
rem        system codepage (cp866) and mangles UTF-8 text.
rem ============================================================

setlocal enabledelayedexpansion
cd /d "%~dp0"

set "LOG=push2.log"

rem --- Git must be reachable ------------------------------------------------
rem Reproduced on the machine where this was reported: PATH did not contain
rem "C:\Program Files\Git\cmd" at all, so a bare "git" resolved to nothing.
rem %GIT% is now the absolute path; it is set once here.
set "GIT="
call :find_git
if not defined GIT goto :no_git

rem Temp file used for every "git output -> for /f" read, so the git call
rem itself is a normal command line (absolute path, real quoting) and only a
rem plain file is parsed by for /f.
set "TMPOUT=%TEMP%\push2_tmp.txt"
if not defined TEMP set "TMPOUT=%~dp0push2_tmp.txt"

set "STAMP=%DATE% %TIME%"
echo.>>"%LOG%"
echo === %STAMP% ===>>"%LOG%"

echo === Branch and remote ===
"%GIT%" branch --show-current
"%GIT%" remote -v
echo.

rem --- 0. Are we on main? Committing to another branch is usually a mistake ---
set "BRANCH="
"%GIT%" branch --show-current >"%TMPOUT%" 2>nul
for /f "usebackq delims=" %%b in ("%TMPOUT%") do if not defined BRANCH set "BRANCH=%%b"
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

rem --- 3. Collect the top-level folders that changed ------------------------
rem First path component of each staged file = top-level folder (or the file
rem name itself for files in the repo root). The list is built with :add_scope,
rem which skips duplicates.
set "SCOPE="
set "SEEN="
"%GIT%" diff --cached --name-only >"%TMPOUT%" 2>nul
for /f "usebackq tokens=1 delims=/" %%d in ("%TMPOUT%") do call :add_scope "%%d"

rem --- 4. Commit message: argument, or "update <folders>" -------------------
rem NOTE: no ( ) block here on purpose. Inside a block cmd expands %VAR% once,
rem before the block runs, so "if %MSG%=="" would always be true.
set "MSG=%~1"
if not "%MSG%"=="" goto :have_msg

set "LIST="
call :join_scope
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
set "URL="
"%GIT%" remote get-url origin >"%TMPOUT%" 2>nul
for /f "usebackq delims=" %%u in ("%TMPOUT%") do if not defined URL set "URL=%%u"
set "HASH="
"%GIT%" rev-parse --short HEAD >"%TMPOUT%" 2>nul
for /f "usebackq delims=" %%h in ("%TMPOUT%") do if not defined HASH set "HASH=%%h"
if exist "%TMPOUT%" del "%TMPOUT%" >nul 2>&1
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
rem "where git" reports git.exe AND git.cmd/git.bat (the /mingw64/cmd shims);
rem both work, so the first hit is used. The usual install locations are
rem checked afterwards because PATH may be missing from a child environment.
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
:add_scope
rem Records one top-level folder name in !SCOPE! as "|name|", skipping names
rem that are already there. The name arrives as %~1 so it does not depend on
rem the caller's %%d being visible inside this called label.
if "%~1"=="" exit /b 0
call :seen_scope "%~1"
if not errorlevel 1 exit /b 0
set "SCOPE=!SCOPE!|%~1|"
exit /b 0

rem ============================================================
:seen_scope
rem errorlevel 1 when "%~1" is not in !SCOPE! yet, errorlevel 0 when it is.
rem The list holds "|name|name|" with names of any length.
rem EVERY path through :seen_chunk strips at least one character before it
rem loops back to :seen_loop. An earlier version jumped back to the top with
rem the leading "|" still in place and the same chunk, so it spun forever on
rem the second and later names - that was the hang.
set "REST=!SCOPE!"
:seen_loop
if "!REST!"=="" exit /b 1
if not "!REST:~0,1!"=="^|" goto :seen_advance
set "REST=!REST:~1!"
if "!REST!"=="" exit /b 1
set "CHUNK="
:seen_chunk
if "!REST!"=="" goto :seen_compare
if "!REST:~0,1!"=="^|" goto :seen_unchar
set "CHUNK=!CHUNK!!REST:~0,1!"
set "REST=!REST:~1!"
goto :seen_chunk
:seen_unchar
rem REST starts with the closing "|": consume it, then compare.
set "REST=!REST:~1!"
if "!CHUNK!"=="%~1" exit /b 0
goto :seen_loop
:seen_compare
rem REST ran out while collecting the chunk: compare, then stop.
if "!CHUNK!"=="%~1" exit /b 0
exit /b 1
:seen_advance
set "REST=!REST:~1!"
goto :seen_loop

rem ============================================================
:join_scope
rem Turns "|a|b|c|" into "a, b, c" for the commit message. Written as an
rem explicit character copy because on the machine where this was reported
rem "set LIST=!SCOPE:|=%" produced the literal text "SCOPE:|=" instead of a
rem substitution, and the message came out as "update SCOPE:, =".
set "REST=!SCOPE!"
:join_loop
if "!REST!"=="" exit /b 0
if "!REST:~0,1!"=="^|" goto :join_skip
set "ITEM="
:join_item
if "!REST!"=="" goto :join_emit
if "!REST:~0,1!"=="^|" goto :join_emit
set "ITEM=!ITEM!!REST:~0,1!"
set "REST=!REST:~1!"
goto :join_item
:join_skip
set "REST=!REST:~1!"
goto :join_loop
:join_emit
set "REST=!REST:~1!"
if "!LIST!"=="" set "LIST=!ITEM!"
if not "!LIST!"=="" if not "!LIST!"=="!ITEM!" set "LIST=!LIST!, !ITEM!"
goto :join_loop

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
