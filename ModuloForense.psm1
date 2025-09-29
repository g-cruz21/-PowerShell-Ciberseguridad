
Set-StrictMode -Version Latest

<#
.SYNOPSIS
    Lista procesos activos y sus conexiones de red.
.DESCRIPTION
    Permite obtener todos los procesos en ejecución, filtrarlos por ruta y correlacionarlos con
    sus conexiones TCP activas, mostrando puertos locales y remotos.
.EXAMPLE
    Get-ProcessConnections
.NOTES
    Se recomienda ejecutar como administrador para obtener información completa.
#>
function Get-ProcessConnections {
    Get-NetTCPConnection | ForEach-Object {
        $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            ProcessName   = $proc.ProcessName
            ProcessId     = $_.OwningProcess
            LocalAddress  = $_.LocalAddress
            LocalPort     = $_.LocalPort
            RemoteAddress = $_.RemoteAddress
            RemotePort    = $_.RemotePort
            State         = $_.State
        }
    } | Sort-Object -Property ProcessName
}

<#
.SYNOPSIS
    Detecta procesos potencialmente sospechosos.
.DESCRIPTION
    Marca procesos que no tienen firma digital válida o que se ejecutan desde rutas inusuales
    como Temp, Downloads o Desktop.
.EXAMPLE
    Get-SuspiciousProcesses
.NOTES
    Requiere permisos de administrador para verificar algunas rutas.
#>
function Get-SuspiciousProcesses {
    Get-Process | ForEach-Object {
        $path = $_.Path
        if ($path) {
            $signature = Get-AuthenticodeSignature -FilePath $path
            $isSigned = ($signature.Status -eq "Valid")
            $isSuspiciousPath = ($path -like "*Temp*" -or $path -like "*Downloads*" -or $path -like "*Desktop*")

            if (-not $isSigned -or $isSuspiciousPath) {
                [PSCustomObject]@{
                    ProcessName    = $_.ProcessName
                    Id             = $_.Id
                    Path           = $path
                    Signed         = $isSigned
                    SuspiciousPath = $isSuspiciousPath
                }
            }
        }
    }
}

# Exportar las funciones
Export-ModuleMember -Function Get-ProcessConnections, Get-SuspiciousProcesses