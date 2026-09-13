$envFile = Join-Path $PSScriptRoot "..\.env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line.Contains("=")) {
            $parts = $line.Split("=", 2)
            $k = $parts[0].Trim()
            $v = $parts[1].Trim()
            [System.Environment]::SetEnvironmentVariable($k, $v, "Process")
        }
    }
}
$serverDir = Join-Path $PSScriptRoot "..\elite_multiservicios_server"
Push-Location $serverDir
try {
    Write-Host "[Serverpod Runner] Variables cargadas desde .env."
    Write-Host "[Serverpod Runner] Iniciando Serverpod con --apply-migrations --seed..."
    dart bin/main.dart --apply-migrations --seed
} finally {
    Pop-Location
}
