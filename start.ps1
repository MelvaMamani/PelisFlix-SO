# start.ps1 - levanta stack con docker-compose
Set-StrictMode -Version Latest
$composeFile = "C:\srv\docker-compose.yml"

Write-Host "1) Comprobando Docker..."
docker version | Out-Null

Write-Host "2) Subiendo servicios con docker-compose..."
cd C:\srv
docker compose -f $composeFile up -d --remove-orphans

Start-Sleep -Seconds 6

Write-Host ""
Write-Host "Estado de contenedores:"
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

Write-Host ""
Write-Host "Accesos:"
Write-Host " - Jellyfin  -> http://localhost:8096"
Write-Host " - Jellyseerr -> http://localhost:5055"
Write-Host "Nota: MariaDB expuesta en el host en el puerto 3306 para backups/inspección si lo necesitas."