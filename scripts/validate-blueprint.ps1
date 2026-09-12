# Valida el render.yaml antes de crear el Blueprint.

$ErrorActionPreference = "Stop"

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Validando render.yaml..." -ForegroundColor Cyan

render blueprints validate render.yaml

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Blueprint valido." -ForegroundColor Green
    Write-Host ""
    Write-Host "Proximos pasos:" -ForegroundColor Yellow
    Write-Host "  1. Pushear render.yaml a GitHub (main)." -ForegroundColor Yellow
    Write-Host "  2. Ir a https://dashboard.render.com/blueprints" -ForegroundColor Yellow
    Write-Host "  3. New Blueprint Instance -> Conectar repo." -ForegroundColor Yellow
    Write-Host "  4. Configurar variables manuales (docs/deployment/render-manual-vars.md)." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "Blueprint invalido. Revisar los errores arriba." -ForegroundColor Red
    exit 1
}
