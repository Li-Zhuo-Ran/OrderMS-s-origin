param(
    [string]$DbHost = "127.0.0.1",
    [string]$DbPort = "3306",
    [string]$DbName = "db_order",
    [string]$DbUser = "root",
    [string]$DbPassword = "",
    [string]$SqlPath = "db_order.sql",
    [string]$PythonCmd = "python"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $SqlPath)) {
    throw "SQL file not found: $SqlPath"
}

$env:DB_HOST = $DbHost
$env:DB_PORT = $DbPort
$env:DB_NAME = $DbName
$env:DB_USER = $DbUser
$env:DB_PASSWORD = $DbPassword
$env:SQL_PATH = $SqlPath

Write-Host "[1/2] Importing SQL into MySQL..." -ForegroundColor Cyan
& $PythonCmd ".\scripts\import_db_order.py"

Write-Host "[2/2] Applying Django migrations..." -ForegroundColor Cyan
& $PythonCmd "manage.py" migrate

Write-Host "Database initialization completed." -ForegroundColor Green
