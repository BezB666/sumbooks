@echo off
setlocal enabledelayedexpansion
rem Temporary probe: verifies the push.cmd fixes without touching the repo.
echo --- 1. old-style plain for /f call (expected to FAIL) ---
for /f "delims=" %%b in ('git branch --show-current') do echo BRANCH=%%b
echo --- 2. find_git lookup, for /f child env proxy ---
set "GIT="
for /f "delims=" %%g in ('where git 2^>nul') do if not defined GIT set "GIT=%%g"
echo GIT=!GIT!
echo --- 3. new-style for /f call via absolute path (expected to WORK) ---
for /f "delims=" %%b in ('"!GIT!" branch --show-current') do echo BRANCH=%%b
echo --- 4. same, run through the real :find_git label of push.cmd ---
set "GIT="
call :find_git
echo find_git returned GIT=!GIT!
for /f "delims=" %%b in ('"!GIT!" branch --show-current') do echo BRANCH=%%b
goto :eof

:find_git
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
