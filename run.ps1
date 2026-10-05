Write-Host "========================================================" -ForegroundColor Cyan
Write-Host " CampusConnect - Launching Server" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

$classPath = "tomcat\webapps\CampusConnect\WEB-INF\classes\controller\LoginServlet.class"
if (-not (Test-Path $classPath)) {
    Write-Host "Building project before initial launch..." -ForegroundColor Yellow
    & ".\build.ps1"
}

$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
$env:JRE_HOME = $env:JAVA_HOME
$env:CATALINA_HOME = "$PSScriptRoot\tomcat"

Write-Host "Starting Apache Tomcat at http://localhost:8080/CampusConnect/" -ForegroundColor Green
Write-Host "Demo Student Login: student@campusconnect.com / student123" -ForegroundColor Cyan
Write-Host "Demo Admin Login:   admin@campusconnect.com / admin123" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to terminate." -ForegroundColor Yellow
Write-Host ""

& "$PSScriptRoot\tomcat\bin\catalina.bat" run
