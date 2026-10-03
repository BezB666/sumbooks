@echo off
setlocal enabledelayedexpansion
rem ============================================================
rem  diag2.cmd - which way of testing for a "|" character works?
rem  diag.cmd showed: if "!REST:~0,1!"=="^|" evaluated FALSE
rem  even though the character really is a bar. This finds the
rem  form that actually works on this machine.
rem ============================================================

set "REST=|src|docs|"
echo REST=[!REST!]
echo first char is: [!REST:~0,1!]
echo.

echo --- A. caret-escaped in quotes (what push2.cmd uses) ---
if "!REST:~0,1!"=="^|" (echo A: MATCH) else (echo A: NO MATCH)

echo --- B. plain bar in quotes ---
if "!REST:~0,1!"=="|" (echo B: MATCH) else (echo B: NO MATCH)

echo --- C. via a variable holding the bar ---
set "BAR=|"
if "!REST:~0,1!"=="!BAR!" (echo C: MATCH) else (echo C: NO MATCH)

echo --- D. caret-escaped, no quotes ---
if !REST:~0,1!==^| (echo D: MATCH) else (echo D: NO MATCH)

echo --- E. compare full strings, caret form ---
set "T=^|src^|"
if "!T!"=="^|src^|" (echo E: MATCH) else (echo E: NO MATCH)

echo --- F. build a bar with a variable and compare full strings ---
set "B=|"
set "T2=!B!src!B!"
if "!T2!"=="!B!src!B!" (echo F: MATCH) else (echo F: NO MATCH)

echo --- G. does a bare bar on the if line get treated as a pipe? ---
set "S=|abc"
set "SUB=!S:~1!"
echo G: substring after bar=[!SUB!]

echo --- H. findstr with a caret-escaped bar ---
echo !REST!| findstr /c:"^|" >nul
if errorlevel 1 (echo H: NO MATCH) else (echo H: MATCH)

echo --- I. findstr literal, no caret ---
echo !REST!| findstr /c:"|" >nul
if errorlevel 1 (echo I: NO MATCH) else (echo I: MATCH)

echo --- J. replace-substitution, the form that failed before ---
set "L=!REST:|=%"
echo J: after replacing bars = [!L!]

echo.
echo done - window closes in 60 seconds
>"nul" 2>&1 (timeout /t 60 /nobreak || ping -n 61 127.0.0.1)
endlocal
