Write-Host "---------------------------------------------"
Write-Host "   Deteniendo el proyecto Home Media Server   "
Write-Host "---------------------------------------------`n"

# Verificar Docker
try {
    docker info > $null 2>&1
} catch {
    Write-Host "Docker no está corriendo. Inicie Docker Desktop e intente nuevamente."
    exit 1
}

# Detener servicios
Write-Host "Deteniendo servicios con docker compose..."
docker compose down

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al detener los servicios."
    exit 1
}

# Estado final
Write-Host "`nEstado final de contenedores:"
docker ps

Write-Host "`n---------------------------------------------"
Write-Host "  Proyecto detenido correctamente"
Write-Host "---------------------------------------------"