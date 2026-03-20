@echo off
setlocal
call "%~dp0..\tools\bin\windows\git.cmd" %*
exit /b %errorlevel%
