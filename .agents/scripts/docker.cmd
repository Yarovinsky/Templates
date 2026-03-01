@echo off
setlocal
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0docker.ps1" %*
exit /b %errorlevel%
