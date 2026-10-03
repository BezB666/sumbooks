@echo off
rem ============================================================
rem  diag3.cmd - minimal, crash-proof test of the "|" comparison.
rem  No findstr, no caret-escaped literals on their own lines,
rem  no fancy syntax. The pause is FIRST so the window can never
rem  disappear before the result is visible.
rem ============================================================
pause
setlocal enabledelayedexpansion

set "REST=|src|docs|"
echo REST=[!REST!]
echo char0=[!REST:~0,1!]
echo.

set "BAR=|"
echo ACTEST1: comparing against a variable holding a bar
if "!REST:~0,1!"=="!BAR!" (echo   RESULT=MATCH) else (echo   RESULT=NOMATCH)

echo.
echo ACTEST2: comparing against a caret-escaped bar
if "!REST:~0,1!"=="^|" (echo   RESULT=MATCH) else (echo   RESULT=NOMATCH)

echo.
echo ACTEST3: does the substring operation itself work
set "SUB=!REST:~1!"
echo   SUB=[!SUB!]
set "SUB2=!REST:~0,1!"
echo   SUB2=[!SUB2!]

echo.
echo ACTEST4: replace-substitution with a variable as the search text
set "L=!REST:%BAR%=%"
echo   L=[!L!]

echo.
echo ACTEST5: count the characters, to prove slicing works
set "N=0"
set "W=!REST!"
:count
if "!W!"=="" goto :counted
set "W=!W:~1!"
set /a N+=1
goto :count
:counted
echo   length=!N!

echo.
echo ALL TESTS DONE - press any key to close
pause
endlocal
