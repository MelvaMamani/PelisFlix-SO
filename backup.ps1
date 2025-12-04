# backup.ps1 - hace dump de MariaDB y guarda tar.gz de configs
Set-StrictMode -Version Latest

$backupDir = "C:\srv\backups"
if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir -Force | Out-Null }

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$sqlFile = "$backupDir\jellyseerr-sql-$timestamp.sql"
$archiveFile = "$backupDir\configs-$timestamp.zip"

Write-Host "1) Creando dump de MariaDB (container: mariadb)..."

# Ejecuta mysqldump dentro del contenedor mariadb y redirige a un archivo en el host
# NOTA: la contraseña está embebida aquí por simplicidad; cambia por credencial segura en producción
docker exec mariadb sh -c 'exec mysqldump --databases jellyseerr -u jellyuser -pjellypass' > $sqlFile

if (Test-Path $sqlFile) {
    Write-Host "Dump creado: $sqlFile"
} else {
    Write-Error "Error creando dump de MariaDB"
    exit 1
}

Write-Host "2) Comprimiendo configuraciones y datos relevantes..."
$itemsToZip = @(
    "C:\srv\jellyfin\config",
    "C:\srv\jellyseerr\config",
    "C:\srv\mariadb\data"
)
# Remove files older than 30 days (opcional)
Get-ChildItem -Path $backupDir -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force -ErrorAction SilentlyContinue

Compress-Archive -Path $itemsToZip -DestinationPath $archiveFile -Force

Write-Host "`nBackups guardados en: $backupDir"
Get-ChildItem -Path $backupDir | Sort-Object LastWriteTime -Descending | Format-Table Name,Length,LastWriteTime