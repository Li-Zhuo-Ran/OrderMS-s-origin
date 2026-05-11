param(
    [string]$PythonCmd = "python"
)

$ErrorActionPreference = "Stop"

Write-Host "[1/2] Installing dependencies from requirements.txt..." -ForegroundColor Cyan
& $PythonCmd -m pip install -r "requirements.txt"

Write-Host "[2/2] Running Django system check..." -ForegroundColor Cyan
& $PythonCmd "manage.py" check

Write-Host "Setup completed." -ForegroundColor Green
