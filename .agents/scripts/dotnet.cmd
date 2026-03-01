@echo off
setlocal
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0dotnet.ps1" %*
exit /b %errorlevel%
