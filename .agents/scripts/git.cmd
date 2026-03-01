@echo off
setlocal
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0git.ps1" %*
exit /b %errorlevel%
