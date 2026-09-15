# Valida archivos de Blueprint de Render (render.yaml o render-develop.yaml)

param(
    [string]$File = "render.yaml",
    [switch]$All
)

$ErrorActionPreference = "Stop"

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

function Validate-SingleBlueprint([string]$targetFile) {
    if (-not (Test-Path $targetFile)) {
        Write-Host "Archivo no encontrado: $targetFile" -ForegroundColor Red
        exit 1
    }

    Write-Host "Validando $targetFile..." -ForegroundColor Cyan
    render blueprints validate $targetFile

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Blueprint $targetFile es valido." -ForegroundColor Green
    } else {
        Write-Host "Blueprint $targetFile es invalido. Revisar los errores arriba." -ForegroundColor Red
        exit 1
    }
}

if ($All) {
    Validate-SingleBlueprint "render.yaml"
    Write-Host ""
    Validate-SingleBlueprint "render-develop.yaml"
} else {
    Validate-SingleBlueprint $File
}

Write-Host ""
Write-Host "Proximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Ir a https://dashboard.render.com/blueprints" -ForegroundColor Yellow
Write-Host "  2. New Blueprint Instance -> Conectar repositorio." -ForegroundColor Yellow
Write-Host "  3. Para produccion: Branch 'main', Blueprint Path 'render.yaml'." -ForegroundColor Yellow
Write-Host "  4. Para staging/develop: Branch 'develop', Blueprint Path 'render-develop.yaml'." -ForegroundColor Yellow
Write-Host "  5. Configurar variables manuales de entorno." -ForegroundColor Yellow
