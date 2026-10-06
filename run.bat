@echo off
setlocal

echo ========================================================
echo  CampusConnect - Launching Server
echo ========================================================

if not exist "tomcat\webapps\CampusConnect\WEB-INF\classes\controller\LoginServlet.class" (
    echo Building project before first run...
    call build.bat
)

if "%JAVA_HOME%"=="" (
    if exist "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot" (
        set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
    )
)
set "JRE_HOME=%JAVA_HOME%"
set "CATALINA_HOME=%~dp0tomcat"

echo Starting Apache Tomcat at http://localhost:8080/CampusConnect/
echo Demo Student Login: student@campusconnect.com / student123
echo Demo Admin Login:   admin@campusconnect.com / admin123
echo Press Ctrl+C in this terminal to stop the server.
echo.

call "%~dp0tomcat\bin\catalina.bat" run
