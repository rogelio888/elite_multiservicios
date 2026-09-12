# Script para arrancar el backend con migraciones y seed automáticamente.
# Lee las variables del .env y las inyecta en el proceso.

param(
    [switch]$NoSeed = $false
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 Iniciando backend Serverpod..." -ForegroundColor Cyan

# 1. Ubicar la raíz del servidor y el archivo .env
$serverDir = Split-Path -Parent $PSScriptRoot
Set-Location $serverDir

$envPath = (Resolve-Path (Join-Path $serverDir "..\.env") -ErrorAction SilentlyContinue).Path
if (-not $envPath) {
    $envPath = Join-Path (Split-Path -Parent $serverDir) ".env"
}

if (-not (Test-Path $envPath)) {
    Write-Host "❌ No se encontró .env en $envPath" -ForegroundColor Red
    Write-Host "   Ejecutá: copy .env.example .env y completá las variables." -ForegroundColor Yellow
    exit 1
}

$envVars = @{}
Get-Content $envPath | ForEach-Object {
    if ($_ -match '^([^#][^=]+)=(.+)$') {
        $envVars[$matches[1].Trim()] = $matches[2].Trim()
    }
}

# 2. Verificar variables críticas
if (-not $NoSeed) {
    if (-not $envVars.ContainsKey("SEED_ADMIN_EMAIL") -or -not $envVars.ContainsKey("SEED_ADMIN_PASSWORD")) {
        Write-Host "⚠️  SEED_ADMIN_EMAIL o SEED_ADMIN_PASSWORD no están en .env" -ForegroundColor Yellow
        Write-Host "   El seed no se ejecutará." -ForegroundColor Yellow
        $NoSeed = $true
    }
}

# 3. Inyectar variables en el proceso
foreach ($key in $envVars.Keys) {
    [Environment]::SetEnvironmentVariable($key, $envVars[$key], "Process")
}

# 4. Construir argumentos
$dartArgs = @("bin/main.dart", "--apply-migrations")
if (-not $NoSeed) {
    $dartArgs += "--seed"
    Write-Host "   Modo: migraciones + seed" -ForegroundColor Green
} else {
    Write-Host "   Modo: solo migraciones" -ForegroundColor Green
}

# 5. Ejecutar
Write-Host "   Ejecutando: dart $($dartArgs -join ' ')" -ForegroundColor Cyan
Write-Host ""
& dart @dartArgs
