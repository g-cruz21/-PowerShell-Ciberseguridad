#Editado por: Gabriel Cruz el 29/09/2025
# Importar módulos
Import-Module .\ModuloIPremotas.psm1
Import-Module .\ModuloForense.psm1
Import-Module .\Forensem.psm1

# Bucle principal
do {
    Clear-Host
    Write-Host "----------Menu----------"
    Write-Host "1: Registro de eventos"
    Write-Host "2: Conexiones de red"
    Write-Host "3: Procesos sospechosos"
    Write-Host "4: Direcciones IP remotas"
    Write-Host "5: Exit"
    Write-Host "------------------------"

    $op = Read-Host 'Por favor elige una opcion del menu (1-5)'

    switch ($op) {
        '1' {
            $logName    = Read-Host 'Ingresa el nombre del log (Security, System, Application)'
            $startDate  = Read-Host 'Ingresa fecha de inicio (dd-MM-yyyy)' 
            $endDate    = Read-Host 'Ingresa fecha de fin (dd-MM-yyyy)'
            $format     = Read-Host 'Formato de salida (CSV, XML, HTML)'

            # Convertir las fechas ingresadas
            $startDate = [datetime]::ParseExact($startDate, 'dd-MM-yyyy', $null)
            $endDate   = [datetime]::ParseExact($endDate, 'dd-MM-yyyy', $null)

            Get-Forense -LogName $logName -StartDate $startDate -EndDate $endDate -Format $format
        }

        '2' {
            $result = Get-ProcessConnections
            $result | Format-Table -AutoSize

            $export = Read-Host "¿Deseas exportar a CSV o XML? (CSV/XML/N para omitir)"
            switch ($export.ToUpper()) {
                'CSV' { $result | Export-Csv -Path "ConnectionsReport.csv" -NoTypeInformation; Write-Host "Exportado a ConnectionsReport.csv" -ForegroundColor Green }
                'XML' { $result | Export-Clixml -Path "ConnectionsReport.xml"; Write-Host "Exportado a ConnectionsReport.xml" -ForegroundColor Green }
                default { Write-Host "No se exportó nada." }
            }
        }

        '3' {
            $result = Get-SuspiciousProcesses
            $result | Format-Table -AutoSize

            $export = Read-Host "¿Deseas exportar a HTML? (S/N)"
            if ($export.ToUpper() -eq 'S') {
                $result | ConvertTo-Html | Out-File "SuspiciousProcesses.html"
                Write-Host "Exportado a SuspiciousProcesses.html" -ForegroundColor Green
            }
        }

        '4' {
            Get-IPRemotas
            Write-Host "Resultados exportados a Reporte_IPs.csv" -ForegroundColor Green
        }

        '5' { Write-Host 'Adios!' -ForegroundColor Green }

        default { Write-Host 'Opcion invalida, por favor elige una opcion que exista en el menu (1-5)' -ForegroundColor Red }
    }

    if ($op -ne '5') {
        Write-Host "`nPresiona ENTER para volver al menu..."
        Read-Host
    }

} while ($op -ne '5')

