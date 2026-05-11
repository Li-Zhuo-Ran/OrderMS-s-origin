param(
    [string]$Host = "127.0.0.1",
    [string]$Port = "8000",
    [string]$PythonCmd = "python"
)

$ErrorActionPreference = "Stop"

Write-Host "Starting Django server at http://$Host`:$Port/ ..." -ForegroundColor Cyan
& $PythonCmd "manage.py" runserver "$Host`:$Port"
