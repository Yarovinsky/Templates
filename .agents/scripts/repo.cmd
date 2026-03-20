@echo off
setlocal
call "%~dp0..\tools\bin\windows\repo.cmd" %*
exit /b %errorlevel%
