net start W32Time
w32tm /resync


Import-Module BurntToast
$mensaje = [Text.Encoding]::UTF8.GetString([Text.Encoding]::UTF8.GetBytes("El tiempo se sincronizo correctamente!"))
$logo = "D:\RJLB9\Pictures\Icons\information.png"
New-BurntToastNotification -Text $mensaje -AppLogo $logo
