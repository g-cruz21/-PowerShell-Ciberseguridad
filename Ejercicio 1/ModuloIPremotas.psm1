Set-StrictMode -Version Latest

<#
.SYNOPSIS
    Verifica las IPs remotas de las conexiones activas.
.DESCRIPTION
    Lee el archivo ConnectionsReport.csv generado por Get-ProcessConnections,
    filtra las IPs remotas válidas y consulta su nivel de riesgo usando la API de AbuseIPDB.
.EXAMPLE
    Get-IPRemotas
.NOTES
    Requiere que ConnectionsReport.csv exista en la misma carpeta y conexión a internet.
#>
function Get-IPRemotas {
    # Verificar que el archivo CSV exista
    if (-not (Test-Path -Path ".\ConnectionsReport.csv")) {
        Write-Host "No se encontraron los archivos .csv, favor de ejecutar la opción 2 del menú primero."
        return 
    }

    $api = "3fedecd9ae5043dbc3f4cf2f1b62dc5c0c901a505df4148135eb209de4c6351fcc975d6a4532f1d5"

    $ips = Import-Csv .\ConnectionsReport.csv |
           Where-Object { $_.RemoteAddress -and $_.RemoteAddress -ne '::' -and $_.RemoteAddress -ne '127.0.0.1' } |
           Select-Object -ExpandProperty RemoteAddress -Unique

    $resultados = @()

    foreach ($ip in $ips) {
        try {
            # Consulta a la API
            $response = Invoke-RestMethod -Uri "https://api.abuseipdb.com/api/v2/check?ipAddress=$ip&maxAgeInDays=90" `
                        -Headers @{Key = $api; Accept = "application/json"} -Method GET

            $data = $response.data

            # Determinar nivel de riesgo
            $nriesgo = switch ($data.abuseConfidenceScore) {
                { $_ -ge 71 } { "Alto"; break }
                { $_ -ge 21 } { "Medio"; break }
                default { "Bajo" }
            }

            # Mostrar resultados
            $response.data | Format-List
            Write-Host "Nivel de Riesgo: $nriesgo"
            Write-Host "__________________________________________"

            # Guardar resultados en la lista
            $resultados += "" | Select-Object `
                @{Name = "IP"; Expression = { $data.ipAddress } },
                @{Name = "Score"; Expression = { $data.abuseConfidenceScore } },
                @{Name = "Riesgo"; Expression = { $nriesgo } }

        } catch {
            Write-Warning "Error al consultar $ip"
        }
    }

    # Guardar resultados en CSV
    $resultados | Export-Csv -Path "Reporte_IPs.csv" -NoTypeInformation -Encoding UTF8
}

# Exportar la función
Export-ModuleMember -Function Get-IPRemotas
