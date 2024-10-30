# Función para verificar permisos de administrador
function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Función para relanzar el script como administrador si el usuario no tiene permisos
function Relaunch-AsAdmin {
    if (-not (Test-Admin)) {
        Write-Host "No tienes permisos de administrador. ¿Deseas ejecutar el script como administrador? (yes/no)"
        $response = Read-Host
        if ($response -eq "yes") {
            # Relaunch the script with elevated privileges
            Start-Process powershell.exe "-File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
            Exit
        } else {
            Write-Host "El script necesita permisos de administrador para ejecutarse." -ForegroundColor Red
            Exit
        }
    }
}

# Llamada a la función para verificar permisos de administrador
Relaunch-AsAdmin

# Verificar y establecer la política de ejecución para permitir scripts de terceros
$currentPolicy = Get-ExecutionPolicy

if ($currentPolicy -ne "RemoteSigned") {
    Write-Host "La política de ejecución actual es '$currentPolicy'. Necesita ser 'RemoteSigned' para ejecutar scripts de terceros."
    Write-Host "¿Deseas cambiar la política de ejecución a 'RemoteSigned'? (yes/no)"
    $response = Read-Host

    if ($response -eq "yes") {
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
            Write-Host "Política de ejecución establecida a 'RemoteSigned' temporalmente para esta sesión." -ForegroundColor Green
        } catch {
            Write-Host "Error: No se pudo cambiar la política de ejecución. Ejecuta el script con permisos de administrador." -ForegroundColor Red
            Exit
        }
    } else {
        Write-Host "El script requiere una política de ejecución 'RemoteSigned'. Saliendo..." -ForegroundColor Red
        Exit
    }
} else {
    Write-Host "La política de ejecución ya está configurada en 'RemoteSigned'." -ForegroundColor Green
}


# Verificación de la existencia del módulo PowerView
$powerViewPath = ".\PowerView.ps1"
if (-not (Test-Path $powerViewPath)) {
    Write-Host "El módulo PowerView no está en el directorio actual. ¿Deseas descargarlo? (yes/no)"
    $downloadResponse = Read-Host
    if ($downloadResponse -eq "yes") {
        # URL de descarga de PowerView
        $powerViewUrl = "https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1"
        
        try {
            Write-Host "Descargando PowerView desde $powerViewUrl..."
            Invoke-WebRequest -Uri $powerViewUrl -OutFile $powerViewPath -UseBasicParsing
            if (Test-Path $powerViewPath) {
                Write-Host "PowerView se ha descargado correctamente." -ForegroundColor Green
            } else {
                Write-Host "Error: No se pudo descargar PowerView. Verifica tu conexión a internet." -ForegroundColor Red
                Exit
            }
        } catch {
            Write-Host "Error: Ocurrió un problema al intentar descargar PowerView." -ForegroundColor Red
            Exit
        }
    } else {
        Write-Host "El módulo PowerView es necesario para ejecutar este script. Saliendo..." -ForegroundColor Red
        Exit
    }
}

# Importar el módulo PowerView
Write-Host "Importando el módulo PowerView..."
Import-Module $powerViewPath -ErrorAction Stop
Write-Host "Módulo PowerView importado con éxito." -ForegroundColor Green


########################################################################################

# Importar el módulo PowerView
Import-Module .\PowerView.ps1

# Función para exportar los resultados
function Export-Results {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Data,
        
        [string]$Format = "CSV"
    )

    $timestamp = (Get-Date -Format "yyyyMMdd_HHmmss")
    $filename = "Export_${Data}_${timestamp}.$Format"

    if ($Format -eq "CSV") {
        $Data | Export-Csv -Path $filename -NoTypeInformation -Encoding UTF8
    } elseif ($Format -eq "JSON") {
        $Data | ConvertTo-Json | Out-File -FilePath $filename -Encoding UTF8
    }
    
    Write-Host "Datos exportados a $filename" -ForegroundColor Green
}

# Función para mostrar el menú
function Show-Menu {
    Write-Host "`nSeleccione una opción:"
    Write-Host "1. Verificar acceso de administrador local para el usuario actual"
    Write-Host "2. Obtener todos los usuarios del dominio y su pertenencia a grupos"
    Write-Host "3. Obtener todas las computadoras del dominio"
    Write-Host "4. Obtener todos los grupos del dominio y sus miembros"
    Write-Host "5. Obtener todos los controladores de dominio"
    Write-Host "6. Obtener todas las políticas de dominio"
    Write-Host "7. Obtener todos los dominios de confianza"
    Write-Host "8. Obtener todos los enlaces de sitios"
    Write-Host "9. Obtener todas las OUs (Unidades Organizativas)"
    Write-Host "10. Obtener todos los GPOs (Objetos de Política de Grupo)"
    Write-Host "11. Realizar recopilación completa y detallada"
    Write-Host "0. Salir"
}

# Función para ejecutar comandos y mostrar resultados en formato tabla
function Execute-Command {
    param (
        [Parameter(Mandatory = $true)]
        [ScriptBlock]$Command,
        
        [string]$Description,
        
        [string]$ExportFormat = "CSV"
    )

    Write-Host "`nEjecutando: $Description" -ForegroundColor Cyan
    $result = & $Command
    $result | Format-Table -AutoSize

    # Preguntar si quiere exportar
    $export = Read-Host "`n¿Quieres exportar los resultados? (s/n)"
    if ($export -eq 's') {
        Export-Results -Data $result -Format $ExportFormat
    }
}

# Menú principal
do {
    Show-Menu
    $choice = Read-Host "Elige una opción (0-11)"

    switch ($choice) {
        1 {
            Execute-Command -Command { Invoke-UserHunter -CheckAccess (Invoke-GetCurrentUser) } -Description "Verificar acceso de administrador local para el usuario actual"
        }
        2 {
            Execute-Command -Command { Get-NetUser -FullData | Select-Object Name, Description, MemberOf, PasswordLastSet, BadPwdCount } -Description "Obtener todos los usuarios del dominio y su pertenencia a grupos"
        }
        3 {
            Execute-Command -Command { Get-NetComputer -FullData | Select-Object Name, Description, OperatingSystem, OperatingSystemVersion } -Description "Obtener todas las computadoras del dominio"
        }
        4 {
            Execute-Command -Command { Get-NetGroup -FullData | Select-Object Name, Description, Members } -Description "Obtener todos los grupos del dominio y sus miembros"
        }
        5 {
            Execute-Command -Command { Get-NetDomainController | Select-Object Name, Site, Forest, Domain } -Description "Obtener todos los controladores de dominio"
        }
        6 {
            Execute-Command -Command { Get-NetDomainPolicy | Select-Object Name, Description, DisplayName, Domain } -Description "Obtener todas las políticas de dominio"
        }
        7 {
            Execute-Command -Command { Get-NetDomainTrust | Select-Object Name, Description, Domain, Type } -Description "Obtener todos los dominios de confianza"
        }
        8 {
            Execute-Command -Command { Get-NetSiteLink | Select-Object Name, Description, Cost, ReplicationFrequency } -Description "Obtener todos los enlaces de sitios"
        }
        9 {
            Execute-Command -Command { Get-NetOU | Select-Object Name, Description, DistinguishedName } -Description "Obtener todas las OUs"
        }
        10 {
            Execute-Command -Command { Get-NetGPO | Select-Object Name, DisplayName, Description, GPLink } -Description "Obtener todos los GPOs"
        }
        11 {
            Write-Host "`nRealizando recopilación completa y detallada..." -ForegroundColor Yellow
            $fullData = @{
                Users = Get-NetUser -FullData | Select-Object Name, Description, MemberOf, PasswordLastSet, BadPwdCount
                Computers = Get-NetComputer -FullData | Select-Object Name, Description, OperatingSystem, OperatingSystemVersion
                Groups = Get-NetGroup -FullData | Select-Object Name, Description, Members
                DomainControllers = Get-NetDomainController | Select-Object Name, Site, Forest, Domain
                DomainPolicies = Get-NetDomainPolicy | Select-Object Name, Description, DisplayName, Domain
                TrustedDomains = Get-NetDomainTrust | Select-Object Name, Description, Domain, Type
                SiteLinks = Get-NetSiteLink | Select-Object Name, Description, Cost, ReplicationFrequency
                OUs = Get-NetOU | Select-Object Name, Description, DistinguishedName
                GPOs = Get-NetGPO | Select-Object Name, DisplayName, Description, GPLink
            }

            # Mostrar resumen en la consola
            foreach ($key in $fullData.Keys) {
                Write-Host "`n$key" -ForegroundColor Cyan
                $fullData[$key] | Format-Table -AutoSize
            }

            # Preguntar el formato de exportación
            $exportFormat = Read-Host "`n¿En qué formato quieres exportar la recopilación completa? (CSV/JSON)"
            foreach ($key in $fullData.Keys) {
                Export-Results -Data $fullData[$key] -Format $exportFormat.ToUpper()
            }
        }
        0 {
            Write-Host "Saliendo del programa..." -ForegroundColor Red
        }
        default {
            Write-Host "Opción no válida. Por favor, selecciona una opción del 0 al 11." -ForegroundColor Red
        }
    }
} while ($choice -ne 0)
