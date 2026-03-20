@echo off
setlocal
call "%~dp0..\tools\bin\windows\dotnet.cmd" %*
exit /b %errorlevel%
