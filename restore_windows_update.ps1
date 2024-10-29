# Verificar permisos de administrador
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Este script debe ejecutarse con privilegios de administrador."
    exit
}

# Detener los servicios de Windows Update
Stop-Service -Name wuauserv -Force
Stop-Service -Name cryptSvc -Force
Stop-Service -Name bits -Force
Stop-Service -Name msiserver -Force

# Esperar un momento para asegurar que los servicios están completamente en detenidos
Start-Sleep -Seconds 10

# Verificar si las carpetas existen antes de renombrarlas
if (Test-Path "C:\Windows\SoftwareDistribution") {
    Rename-Item -Path "C:\Windows\SoftwareDistribution" -NewName "SoftwareDistribution.OLD" -ErrorAction SilentlyContinue
}

if (Test-Path "C:\Windows\System32\catroot2") {
    Rename-Item -Path "C:\Windows\System32\catroot2" -NewName "Catroot2.OLD" -ErrorAction SilentlyContinue
}

# Cambiar los permisos de las carpetas .OLD para permitir su eliminación
icacls "C:\Windows\SoftwareDistribution.OLD" /grant Administrators:F /T
icacls "C:\Windows\System32\catroot2.OLD" /grant Administrators:F /T

# Reiniciar los servicios de Windows Update
Start-Service -Name wuauserv
Start-Service -Name cryptSvc
Start-Service -Name bits
Start-Service -Name msiserver

# Esperar un momento para asegurar que los servicios están completamente en marcha
Start-Sleep -Seconds 10

# Verificar y eliminar las carpetas .OLD si existen
if (Test-Path "C:\Windows\SoftwareDistribution.OLD") {
    Remove-Item -Path "C:\Windows\SoftwareDistribution.OLD" -Recurse -Force
}
if (Test-Path "C:\Windows\System32\catroot2.OLD") {
    Remove-Item -Path "C:\Windows\System32\catroot2.OLD" -Recurse -Force
}

Import-Module BurntToast
$mensaje = [Text.Encoding]::UTF8.GetString([Text.Encoding]::UTF8.GetBytes("Windows Update se restauro correctamente!"))
$logo = "D:\RJLB9\Pictures\Icons\information.png"
New-BurntToastNotification -Text $mensaje -AppLogo $logo
