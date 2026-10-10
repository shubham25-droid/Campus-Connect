Write-Host "========================================================" -ForegroundColor Cyan
Write-Host " CampusConnect - Build & Deploy Script" -ForegroundColor Cyan
Write-Host " Connecting Students with Every Campus Opportunity" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

$javacPath = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot\bin\javac.exe"
if (-not (Test-Path $javacPath)) {
    $javacPath = "javac"
}

Write-Host "[1/3] Compiling Java MVC Source Files..." -ForegroundColor Yellow
if (-not (Test-Path "WebContent\WEB-INF\classes")) {
    New-Item -ItemType Directory -Force -Path "WebContent\WEB-INF\classes" | Out-Null
}

& $javacPath -encoding UTF-8 -cp "lib/*;WebContent/WEB-INF/lib/*" -d "WebContent/WEB-INF/classes" src/util/*.java src/model/*.java src/dao/*.java src/filter/*.java src/controller/*.java

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Compilation failed!" -ForegroundColor Red
    exit $LASTEXITCODE
}
Write-Host "[OK] Compilation successful." -ForegroundColor Green

Write-Host "[2/3] Deploying to Tomcat Webapps..." -ForegroundColor Yellow
if (-not (Test-Path "tomcat\webapps\CampusConnect")) {
    New-Item -ItemType Directory -Force -Path "tomcat\webapps\CampusConnect" | Out-Null
}

Copy-Item -Path "WebContent\*" -Destination "tomcat\webapps\CampusConnect\" -Recurse -Force

Write-Host "[3/3] Setting up Root redirect..." -ForegroundColor Yellow
if (-not (Test-Path "tomcat\webapps\ROOT")) {
    New-Item -ItemType Directory -Force -Path "tomcat\webapps\ROOT" | Out-Null
}
Set-Content -Path "tomcat\webapps\ROOT\index.jsp" -Value '<%@ page session="false" %><% response.sendRedirect(request.getContextPath() + "/CampusConnect/"); %>'

Write-Host "========================================================" -ForegroundColor Green
Write-Host " BUILD COMPLETE! Ready to run on http://localhost:8080/CampusConnect/" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
