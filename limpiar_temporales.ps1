Write-Host "Ejecutando Limpiador de Archivos Temporales..."
# Script para limpiar archivos temporales de Windows
$paths = @(
    "$env:LOCALAPPDATA\Temp",
    "$env:WINDIR\Temp"
)

foreach ($path in $paths) {
    Get-ChildItem -Path $path -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

Import-Module BurntToast
$mensaje = [Text.Encoding]::UTF8.GetString([Text.Encoding]::UTF8.GetBytes("Archivos temporales eliminados!"))
$logo = "D:\RJLB9\Pictures\Icons\information.png"
New-BurntToastNotification -Text $mensaje -AppLogo $logo
