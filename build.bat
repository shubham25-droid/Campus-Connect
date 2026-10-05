@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo  CampusConnect - Build ^& Deploy Script
echo  Connecting Students with Every Campus Opportunity
echo ========================================================

set "JAVA_CMD=C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot\bin\javac.exe"
if not exist "!JAVA_CMD!" (
    set "JAVA_CMD=javac"
)

echo [1/3] Compiling Java MVC Source Files...
if not exist "WebContent\WEB-INF\classes" mkdir "WebContent\WEB-INF\classes"

"!JAVA_CMD!" -encoding UTF-8 -cp "lib/*;WebContent/WEB-INF/lib/*" -d "WebContent/WEB-INF/classes" src/util/*.java src/model/*.java src/dao/*.java src/controller/*.java

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Compilation failed!
    exit /b %ERRORLEVEL%
)
echo [OK] Compilation successful.

echo [2/3] Deploying to Tomcat Webapps...
if not exist "tomcat\webapps\CampusConnect" mkdir "tomcat\webapps\CampusConnect"

xcopy /E /I /Y "WebContent" "tomcat\webapps\CampusConnect" >nul

echo [3/3] Setting up Root redirect...
if not exist "tomcat\webapps\ROOT" mkdir "tomcat\webapps\ROOT"
echo ^<%@ page session="false" %^>^<% response.sendRedirect(request.getContextPath() + "/CampusConnect/"); %^> > "tomcat\webapps\ROOT\index.jsp"

echo ========================================================
echo  BUILD COMPLETE! Ready to run on http://localhost:8080/CampusConnect/
echo ========================================================
