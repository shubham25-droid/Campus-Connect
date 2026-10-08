@echo off
setlocal
echo ========================================================
echo  CampusConnect - Standalone WAR Packaging Script
echo  Production-ready archive for Apache Tomcat Deployment
echo ========================================================

powershell -ExecutionPolicy Bypass -File "%~dp0package-war.ps1"

pause
