@echo off
setlocal enabledelayedexpansion
rem Temporary probe 3: no child cmd, so it works even where for /f is denied.
echo PATH-contains-Git-cmd: 
echo [%PATH%] | findstr /i /c:"\Git\cmd" >nul && echo   YES || echo   NO
echo.
echo Files under "C:\Program Files\Git\cmd":
if exist "%ProgramFiles%\Git\cmd" dir /b "%ProgramFiles%\Git\cmd"
echo.
echo Absolute-path git works directly?
if exist "%ProgramFiles%\Git\cmd\git.exe" (
    for /f "delims=" %%v in ('') do rem noop
    "%ProgramFiles%\Git\cmd\git.exe" --version
    echo    git-exit=%errorlevel%
) else (
    echo    git.exe NOT present at that path
)
echo.
echo --- :delay timing test ---
echo Before delay: %TIME%
call :delay_probe
echo After delay:  %TIME%
goto :eof

:delay_probe
>"nul" 2>&1 (timeout /t 10 /nobreak || ping -n 11 127.0.0.1)
exit /b 0
