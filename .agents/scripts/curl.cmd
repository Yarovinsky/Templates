@echo off
setlocal
call "%~dp0..\tools\bin\windows\curl.cmd" %*
exit /b %errorlevel%
