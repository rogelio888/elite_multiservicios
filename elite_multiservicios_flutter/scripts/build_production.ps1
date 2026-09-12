# Build del frontend Flutter para produccion.
# Requiere que SERVER_URL este configurado como parametro.

param(
    [Parameter(Mandatory=$true)]
    [string]$ServerUrl
)

$ErrorActionPreference = "Stop"

Write-Host "Building Flutter Web for production..." -ForegroundColor Cyan
Write-Host "   Backend URL: $ServerUrl" -ForegroundColor Cyan

flutter build web --release --dart-define=SERVER_URL=$ServerUrl

Write-Host ""
Write-Host "Build completado. Output: build/web/" -ForegroundColor Green
Write-Host ""
Write-Host "Siguiente paso: deployar el contenido de build/web/ a Render Static Site." -ForegroundColor Yellow
