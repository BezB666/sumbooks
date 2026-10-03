@echo off
rem ============================================================
rem  diag.cmd - find out where push2.cmd stops.
rem  Run it by double-clicking. It prints one line per step and
rem  waits 60 seconds at the end so you can read the result.
rem ============================================================
setlocal enabledelayedexpansion

echo STEP 1 - script started
echo STEP 2 - TEMP is [%TEMP%]
set "TMPOUT=%TEMP%\push2_tmp.txt"
echo STEP 3 - TMPOUT is [%TMPOUT%]

echo STEP 4 - about to run: git branch --show-current
git branch --show-current
echo STEP 5 - bare git finished, errorlevel=%errorlevel%

echo STEP 6 - about to run: where git
where git
echo STEP 7 - where git finished, errorlevel=%errorlevel%

echo STEP 8 - about to write a test file
echo hello> "%TMPOUT%"
echo STEP 9 - write finished, errorlevel=%errorlevel%
if exist "%TMPOUT%" (echo STEP 10 - file exists) else (echo STEP 10 - FILE MISSING)
for %%f in ("%TMPOUT%") do echo STEP 11 - file size=%%~zf

echo STEP 12 - about to run: git branch --show-current > TMPOUT
git branch --show-current > "%TMPOUT%" 2>nul
echo STEP 13 - redirect finished, errorlevel=%errorlevel%
for %%f in ("%TMPOUT%") do echo STEP 14 - file size=%%~zf

echo STEP 15 - about to read the file with for /f usebackq
set "BRANCH="
for /f "usebackq delims=" %%b in ("%TMPOUT%") do if not defined BRANCH set "BRANCH=%%b"
echo STEP 16 - read finished, BRANCH=[!BRANCH!]

echo STEP 17 - about to test the pipe in a comparison
set "REST=|src|docs|"
set "FOUND=no"
if "!REST:~0,1!"=="^|" set "FOUND=yes"
echo STEP 18 - FOUND=[!FOUND!]

del "%TMPOUT%" >nul 2>&1
echo STEP 19 - done
echo.
echo This window closes in 60 seconds...
>"nul" 2>&1 (timeout /t 60 /nobreak || ping -n 61 127.0.0.1)
endlocal
