Write-Host "========================================================" -ForegroundColor Cyan
Write-Host " CampusConnect - Standalone WAR Packaging Script" -ForegroundColor Cyan
Write-Host " Production-ready archive for Apache Tomcat Deployment" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

# 1. Detect Java Compiler and Archiver
$javacPath = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot\bin\javac.exe"
if (-not (Test-Path $javacPath)) { $javacPath = "javac" }

$jarPath = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot\bin\jar.exe"
if (-not (Test-Path $jarPath)) { $jarPath = "jar" }

# 2. Compile MVC Sources
Write-Host "[1/3] Compiling Java MVC Source Files..." -ForegroundColor Yellow
if (-not (Test-Path "WebContent\WEB-INF\classes")) {
    New-Item -ItemType Directory -Force -Path "WebContent\WEB-INF\classes" | Out-Null
}

& $javacPath -encoding UTF-8 -cp "lib/*;WebContent/WEB-INF/lib/*" -d "WebContent/WEB-INF/classes" src/util/*.java src/model/*.java src/dao/*.java src/controller/*.java

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Java compilation failed!" -ForegroundColor Red
    exit $LASTEXITCODE
}
Write-Host "[OK] Compilation successful." -ForegroundColor Green

# 3. Create dist directory
Write-Host "[2/3] Preparing Output Directory..." -ForegroundColor Yellow
$distDir = "dist"
if (-not (Test-Path $distDir)) {
    New-Item -ItemType Directory -Force -Path $distDir | Out-Null
}

$warFile = "$distDir\CampusConnect.war"
if (Test-Path $warFile) {
    Remove-Item $warFile -Force
}

# 4. Package WAR file
Write-Host "[3/3] Packaging WebContent into CampusConnect.war..." -ForegroundColor Yellow
& $jarPath -cvf $warFile -C WebContent .

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] WAR archive packaging failed!" -ForegroundColor Red
    exit $LASTEXITCODE
}

# Also keep a root copy for immediate convenience
Copy-Item $warFile -Destination "CampusConnect.war" -Force

$fileSizeMb = ((Get-Item $warFile).Length / 1MB).ToString("0.00")
Write-Host "========================================================" -ForegroundColor Green
Write-Host " [SUCCESS] WAR File Generated Successfully!" -ForegroundColor Green
Write-Host " Output File: $warFile ($fileSizeMb MB)" -ForegroundColor Cyan
Write-Host " Root Copy:   CampusConnect.war ($fileSizeMb MB)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""
Write-Host "HOW TO DEPLOY ON ANY APACHE TOMCAT SERVER:" -ForegroundColor White
Write-Host " 1. Copy 'CampusConnect.war' into the 'webapps/' directory of your Tomcat server." -ForegroundColor Gray
Write-Host " 2. Start Tomcat ('catalina.bat start' or 'startup.bat')." -ForegroundColor Gray
Write-Host " 3. Tomcat will automatically extract and deploy it." -ForegroundColor Gray
Write-Host " 4. Access the application in your browser at:" -ForegroundColor Gray
Write-Host "    http://localhost:8080/CampusConnect/" -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Green
