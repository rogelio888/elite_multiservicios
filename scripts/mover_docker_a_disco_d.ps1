Write-Host "Deteniendo procesos de Docker Desktop..." -ForegroundColor Cyan
Stop-Process -Name "*docker*" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

$targetDir = "D:\Docker"
$targetProg = "D:\Docker\DockerDesktop"
$targetData = "D:\Docker\DockerData"

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
New-Item -ItemType Directory -Path $targetProg -Force | Out-Null
New-Item -ItemType Directory -Path $targetData -Force | Out-Null

$prog = "$env:LOCALAPPDATA\Programs\DockerDesktop"
$isProgJunction = (Test-Path $prog) -and ((Get-Item $prog).Attributes -band [System.IO.FileAttributes]::ReparsePoint)

if ((Test-Path $prog) -and (-not $isProgJunction)) {
    Write-Host "Moviendo archivos del programa Docker Desktop a $targetProg..." -ForegroundColor Cyan
    robocopy $prog $targetProg /E /MOVE /NFL /NDL /NJH /NJS
    Start-Sleep -Seconds 1
    Remove-Item $prog -Recurse -Force -ErrorAction SilentlyContinue
    cmd /c "mklink /J `"$prog`" `"$targetProg`""
    Write-Host "Enlace simbolico (Junction) del programa creado con exito." -ForegroundColor Green
} else {
    Write-Host "El programa ya esta enlazado en $targetProg." -ForegroundColor Yellow
}

$data = "$env:LOCALAPPDATA\Docker"
$isDataJunction = (Test-Path $data) -and ((Get-Item $data).Attributes -band [System.IO.FileAttributes]::ReparsePoint)

if ((Test-Path $data) -and (-not $isDataJunction)) {
    Write-Host "Moviendo datos y maquinas virtuales de Docker a $targetData..." -ForegroundColor Cyan
    robocopy $data $targetData /E /MOVE /NFL /NDL /NJH /NJS
    Start-Sleep -Seconds 1
    Remove-Item $data -Recurse -Force -ErrorAction SilentlyContinue
    cmd /c "mklink /J `"$data`" `"$targetData`""
    Write-Host "Enlace simbolico (Junction) de datos creado con exito." -ForegroundColor Green
} elseif (-not (Test-Path $data)) {
    cmd /c "mklink /J `"$data`" `"$targetData`""
    Write-Host "Enlace simbolico (Junction) de datos creado hacia $targetData." -ForegroundColor Green
} else {
    Write-Host "Los datos ya estan enlazados en $targetData." -ForegroundColor Yellow
}

Write-Host "Comprobando enlaces:" -ForegroundColor Cyan
Get-Item $prog, $data | Select-Object FullName, LinkType, Target
