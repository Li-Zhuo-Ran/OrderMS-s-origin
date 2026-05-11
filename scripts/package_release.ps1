param(
    [string]$ProjectRoot = ".",
    [string]$OutputDir = "dist"
)

$ErrorActionPreference = "Stop"

$projectPath = (Resolve-Path $ProjectRoot).Path
$distPath = Join-Path $projectPath $OutputDir
$tempPath = Join-Path $distPath "OrderMS_release_tmp"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipPath = Join-Path $distPath ("OrderMS_release_" + $timestamp + ".zip")

if (-not (Test-Path $distPath)) {
    New-Item -ItemType Directory -Path $distPath | Out-Null
}

if (Test-Path $tempPath) {
    Remove-Item $tempPath -Recurse -Force
}

New-Item -ItemType Directory -Path $tempPath | Out-Null

Write-Host "Copying files..." -ForegroundColor Cyan
Copy-Item (Join-Path $projectPath "*") $tempPath -Recurse -Force -Exclude @(
    ".idea",
    "dist",
    "__pycache__",
    "*.pyc",
    "db.sqlite3"
)

# Remove local runtime data not suitable for distribution
$removeList = @(
    (Join-Path $tempPath "mysql\data"),
    (Join-Path $tempPath "mysql\logs"),
    (Join-Path $tempPath "mysql\my.ini")
)
foreach ($p in $removeList) {
    if (Test-Path $p) {
        Remove-Item $p -Recurse -Force
    }
}

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Write-Host "Creating zip package..." -ForegroundColor Cyan
Compress-Archive -Path (Join-Path $tempPath "*") -DestinationPath $zipPath -CompressionLevel Optimal

Remove-Item $tempPath -Recurse -Force

Write-Host "Package created:" -ForegroundColor Green
Write-Host $zipPath -ForegroundColor Green
