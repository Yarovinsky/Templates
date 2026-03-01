@echo off
setlocal
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0repo.ps1" %*
exit /b %errorlevel%
