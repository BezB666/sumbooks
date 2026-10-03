@echo off
setlocal enabledelayedexpansion
rem Temporary probe 2: what does the for /f child environment actually contain?
echo --- parent PATH ---
echo [%PATH%]
echo --- child PATH seen by for /f ---
for /f "delims=" %%p in ('echo %PATH%') do echo [%%p]
echo --- child can run cmd builtins? ---
for /f "delims=" %%v in ('echo hello_from_child') do echo GOT=%%v
echo --- SystemRoot / ComSpec in child ---
for /f "delims=" %%r in ('echo %SystemRoot%') do echo SR=%%r
echo --- does for /f find ping (non-git binary)? ---
for /f "delims=" %%n in ('ping -n 1 127.0.0.1 ^| findstr /i ttl') do echo PING=%%n
goto :eof
