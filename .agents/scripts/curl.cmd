@echo off
setlocal
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0curl.ps1" %*
exit /b %errorlevel%
