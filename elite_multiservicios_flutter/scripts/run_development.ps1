# Run del frontend Flutter en desarrollo.
# Apunta al backend local (localhost:8080).

Write-Host "Running Flutter Web in development mode..." -ForegroundColor Cyan
Write-Host "   Backend URL: http://localhost:8080/" -ForegroundColor Cyan

flutter run -d chrome --dart-define=SERVER_URL=http://localhost:8080/
