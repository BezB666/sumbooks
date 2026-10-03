@echo off
rem ============================================================
rem  push.cmd - commit all changes and push them to GitHub
rem  Usage:
rem     push.cmd                  - auto commit message (from changed folders)
rem     push.cmd "commit message"  - your own message
rem  Everything is mirrored to push.log next to this file.
rem  NOTE: keep this file ASCII-only, cmd.exe reads .cmd in the
rem        system codepage (cp866) and mangles UTF-8 text.
rem
rem  ------------------------------------------------------------
rem  MEASURED FACTS ABOUT THIS MACHINE (from diag3.cmd output).
rem  Do not "simplify" the code below back to the obvious form:
rem
rem   1. Comparing against an escaped bar NEVER matches:
rem        if "!X:~0,1!"=="^|"    -> NO MATCH   (wrong)
rem        set "BAR=|"
rem        if "!X:~0,1!"=="!BAR!" -> MATCH      (correct)
rem      The escaped form made the folder loops spin forever.
rem
rem   2. The :search=replace% substitution does not work here, with a
rem      literal OR with a variable:
rem        set "L=!REST:|=%"        -> L=[REST:|=]   (wrong)
rem        set "L=!REST:%BAR%=%"     -> L=[REST:|=]   (wrong)
rem      That is why the old script committed "update SCOPE:, =".
rem      So no substring replacement is used anywhere in this file.
rem
rem   3. git is called through %GIT% (absolute path). Bare "git"
rem      resolves through PATH, which may not contain the Git folder.
rem
rem   4. for /f never runs git directly. git writes to a temp file and
rem      for /f "usebackq" reads that file. This was measured working
rem      (diag.cmd STEP 15/16) and avoids the child-cmd PATH problem.
rem  ------------------------------------------------------------

setlocal enabledelayedexpansion
cd /d "%~dp0"

set "LOG=push.log"

rem --- Locate git once, use %GIT% everywhere afterwards -----------
set "GIT="
call :find_git
if not defined GIT goto :no_git

rem --- Temp file for every "git output -> for /f" read -------------
set "TMPOUT=%TEMP%\push_tmp.txt"
if not defined TEMP set "TMPOUT=%~dp0push_tmp.txt"

set "STAMP=%DATE% %TIME%"
echo.>>"%LOG%"
echo === %STAMP% ===>>"%LOG%"

echo === Branch and remote ===
"%GIT%" branch --show-current
"%GIT%" remote -v
echo.

rem --- 0. Are we on main? Committing elsewhere is usually a mistake ---
set "BRANCH="
"%GIT%" branch --show-current >"%TMPOUT%" 2>nul
for /f "usebackq delims=" %%b in ("%TMPOUT%") do if not defined BRANCH set "BRANCH=%%b"
if not defined BRANCH (
    echo FAILED: could not read the current branch.
    echo   Git was found at: %GIT%
    echo   "git branch --show-current" returned nothing - normally this
    echo   means the repository has no commits yet.
    goto :fail
)
if /i not "%BRANCH%"=="main" (
    echo WARNING: current branch is "%BRANCH%", not "main".
    echo   This script pushes to main. Press Ctrl+C to abort.
    echo.
    echo   Continuing in 10 seconds...
    >"nul" 2>&1 (timeout /t 10 /nobreak || ping -n 11 127.0.0.1)
)

rem --- 1. Stage everything except ignored files --------------------
"%GIT%" add . >>"%LOG%" 2>&1
if errorlevel 1 goto :fail

rem --- 2. Nothing staged? Just make sure the remote is up to date -
"%GIT%" diff --cached --quiet >nul 2>&1
if not errorlevel 1 goto :clean

rem --- 3. Collect the top-level folders that changed ---------------
rem The first path component of each staged file is its top-level folder
rem (or the file name itself for files in the repo root). :add_scope adds
rem each name once, as "|name|".
set "BAR=|"
set "SCOPE="
"%GIT%" diff --cached --name-only >"%TMPOUT%" 2>nul
for /f "usebackq tokens=1 delims=/" %%d in ("%TMPOUT%") do call :add_scope "%%d"

rem --- 4. Commit message: argument, or "update <folders>" ----------
rem NOTE: no ( ) block here on purpose. Inside a block cmd expands %VAR%
rem once, before the block runs, so "if %MSG%=="" would always be true.
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

rem --- 5. Push (sets upstream on first run) ------------------------
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
rem "git@github.com:x/y.git" -> "https://github.com/x/y" is done with
rem character copying in :to_web, not with :search=replace% (see fact 2).
set "URL="
"%GIT%" remote get-url origin >"%TMPOUT%" 2>nul
for /f "usebackq delims=" %%u in ("%TMPOUT%") do if not defined URL set "URL=%%u"
set "HASH="
"%GIT%" rev-parse --short HEAD >"%TMPOUT%" 2>nul
for /f "usebackq delims=" %%h in ("%TMPOUT%") do if not defined HASH set "HASH=%%h"
if exist "%TMPOUT%" del "%TMPOUT%" >nul 2>&1

set "WEB="
call :to_web

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
rem Keep the console window open for 10 seconds so the result of a
rem double-clicked run can be read before the window disappears.
rem timeouts/ping instead of pause, so no key press is needed.
echo.
echo This window closes in 10 seconds...
>"nul" 2>&1 (timeout /t 10 /nobreak || ping -n 11 127.0.0.1)
exit /b 0

rem ============================================================
:find_git
rem "where git" lists git.exe and the git.cmd/git.bat shims; the first hit
rem is used. The usual install folders are checked afterwards because PATH
rem can be missing from a child environment.
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
rem Adds one top-level folder name to !SCOPE! unless already present.
rem The name arrives as %~1 so it does not depend on the caller's %%d.
if "%~1"=="" exit /b 0
call :seen_scope "%~1"
if not errorlevel 1 exit /b 0
set "SCOPE=!SCOPE!|%~1|"
exit /b 0

rem ============================================================
:seen_scope
rem errorlevel 1 if "%~1" is NOT in !SCOPE! yet, errorlevel 0 if it is.
rem !SCOPE! looks like "|a|b|". Every path through :seen_chunk removes at
rem least one character before returning to :seen_loop, so this always
rem terminates. Bars are matched with "!BAR!" (fact 1), never with "^|".
set "REST=!SCOPE!"
:seen_loop
if "!REST!"=="" exit /b 1
if not "!REST:~0,1!"=="!BAR!" goto :seen_advance
set "REST=!REST:~1!"
if "!REST!"=="" exit /b 1
set "CHUNK="
:seen_chunk
if "!REST!"=="" goto :seen_tail
if "!REST:~0,1!"=="!BAR!" goto :seen_bar
set "CHUNK=!CHUNK!!REST:~0,1!"
set "REST=!REST:~1!"
goto :seen_chunk
:seen_bar
rem REST starts with the closing bar: consume it, then compare.
set "REST=!REST:~1!"
if "!CHUNK!"=="%~1" exit /b 0
goto :seen_loop
:seen_tail
rem REST ran out while collecting the chunk: compare, then stop.
if "!CHUNK!"=="%~1" exit /b 0
exit /b 1
:seen_advance
set "REST=!REST:~1!"
goto :seen_loop

rem ============================================================
:join_scope
rem Turns "|a|b|c|" into "a, b, c" for the commit message, by copying
rem characters. No :search=replace% substitution is used (fact 2).
set "REST=!SCOPE!"
:join_loop
if "!REST!"=="" exit /b 0
if "!REST:~0,1!"=="!BAR!" goto :join_skip
set "ITEM="
:join_item
if "!REST!"=="" goto :join_emit
if "!REST:~0,1!"=="!BAR!" goto :join_emit
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
:to_web
rem Turns !URL! into a browsable https URL:
rem   "git@github.com:u/r.git"    -> "https://github.com/u/r"
rem   "https://github.com/u/r.git" -> "https://github.com/u/r"
rem The https prefix is added AFTER the body is normalised, so the colon of
rem "https://" is never confused with the colon of "git@host:path". An
rem earlier version scanned character by character and produced
rem "https://github.com:BezB666/sumbooks" and "https///github.com/...".
rem No :search=replace% substitution is used (fact 2).
if "!URL!"=="" set "WEB="
if "!URL!"=="" exit /b 0

set "BODY=!URL!"
set "PREFIX="

rem --- strip a leading scheme, remembering which one it was ---
set "HEAD4=!BODY:~0,4!"
if "!HEAD4!"=="http" goto :to_web_has_scheme
set "HEAD6=!BODY:~0,6!"
if "!HEAD6!"=="git@gi" goto :to_web_scp
rem Anything else (a bare path) is used as is.

:to_web_normalise
rem Drop a trailing ".git".
if "!BODY!"=="" goto :to_web_assemble
set "TAIL=!BODY:~-4!"
if not "!TAIL!"==".git" goto :to_web_assemble
set "BODY=!BODY:~0,-4!"

:to_web_assemble
rem Add the https prefix unless BODY already carries a scheme.
if not "!PREFIX!"=="" goto :to_web_done
set "HEAD4=!BODY:~0,4!"
if "!HEAD4!"=="http" goto :to_web_done
set "BODY=https://!BODY!"
:to_web_done
set "WEB=!BODY!"
exit /b 0

rem --- "https://..." or "http://...": keep the scheme as it is ---------
:to_web_has_scheme
set "PREFIX=yes"
goto :to_web_normalise

rem --- "git@host:owner/repo": drop "git@", turn the FIRST ":" into "/" ----
:to_web_scp
rem Remove the leading "git@".
set "BODY=!BODY:~4!"
rem Walk the body and replace the first ":" with "/".
set "SRC=!BODY!"
set "BODY="
set "DONE=no"
:to_web_scp_loop
if "!SRC!"=="" goto :to_web_scp_end
set "C=!SRC:~0,1!"
set "SRC=!SRC:~1!"
if "!C!"==":" goto :to_web_scp_colon
set "BODY=!BODY!!C!"
goto :to_web_scp_loop
:to_web_scp_colon
if "!DONE!"=="yes" goto :to_web_scp_keep
set "BODY=!BODY!/"
set "DONE=yes"
goto :to_web_scp_loop
:to_web_scp_keep
set "BODY=!BODY!:"
goto :to_web_scp_loop
:to_web_scp_end
set "BODY=https://!BODY!"
set "PREFIX=yes"
goto :to_web_normalise

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
