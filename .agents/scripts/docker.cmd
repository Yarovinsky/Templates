@echo off
setlocal
call "%~dp0..\tools\bin\windows\docker.cmd" %*
exit /b %errorlevel%
