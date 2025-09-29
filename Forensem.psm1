Set-StrictMode -Version Latest

<#
.SYNOPSIS
    Extrae eventos del Visor de Eventos de Windows según el log y rango de fechas.
.DESCRIPTION
    Permite extraer eventos de los logs 'Security', 'System' o 'Application' en un rango de fechas
    determinado y exportarlos en formatos CSV, XML o HTML. El archivo se guarda en la carpeta
    actual donde se ejecuta el script.
.PARAMETER LogName
    Nombre del log a consultar. Puede ser 'Security', 'System' o 'Application'.
.PARAMETER StartDate
    Fecha de inicio para filtrar los eventos. Formato: dd/MM/yyyy.
.PARAMETER EndDate
    Fecha final para filtrar los eventos. Formato: dd/MM/yyyy.
.PARAMETER Format
    Formato de salida: CSV, XML o HTML.
.EXAMPLE
    Get-Forense -LogName Security -StartDate 01/09/2025 -EndDate 09/09/2025 -Format CSV
.NOTES
    Requiere permisos de administrador para acceder al log de Security.
#>
function Get-Forense {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet('Security', 'System', 'Application')]
        [string]$LogName,

        [Parameter(Mandatory=$true)]
        [datetime]$StartDate,

        [Parameter(Mandatory=$true)]
        [datetime]$EndDate,

        [Parameter(Mandatory=$true)]
        [ValidateSet('CSV', 'XML', 'HTML')]
        [string]$Format
    )

    if ($StartDate -gt $EndDate) {
        throw "La fecha de inicio no puede ser posterior a la fecha de fin."
    }

    Write-Host "Extrayendo eventos de '$LogName' entre $($StartDate.ToString('dd/MM/yyyy')) y $($EndDate.ToString('dd/MM/yyyy'))..."

    if ($LogName -eq 'Security') {
        $filter = @{
            LogName   = $LogName
            StartTime = $StartDate
            EndTime   = $EndDate
            Id        = 4624,4625,4634,4720,4776,1102
        }
    }
    else {
        $filter = @{
            LogName   = $LogName
            StartTime = $StartDate
            EndTime   = $EndDate
        }
    }

    try {
        $events = Get-WinEvent -FilterHashtable $filter -ErrorAction SilentlyContinue |
                  ForEach-Object {
                      try {
                          $_ | Select-Object TimeCreated, Id, LevelDisplayName, Message, ProviderName
                      } catch {
                          Write-Warning "Evento dañado (ID=$($_.Id)) no se pudo procesar."
                      }
                  }

        if ($events) {
            $outputDir  = (Get-Location)  # Carpeta actual
            $fileName   = "$LogName`_Eventos.$Format"
            $outputPath = Join-Path -Path $outputDir -ChildPath $fileName

            Write-Host "Exportando $(@($events).Count) eventos en formato $Format..."

            switch ($Format) {
                'CSV'  { $events | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8 }
                'XML'  { $events | Export-Clixml -Path $outputPath }
                'HTML' {
                    $title = "Informe de Eventos - $LogName"
                    $head  = "<title>$title</title><style>
                                body{font-family: Arial;} 
                                table{border-collapse: collapse;width: 100%;} 
                                th,td{border:1px solid #ddd;padding:8px;}
                                th{background:#4CAF50;color:white;} 
                                tr:nth-child(even){background:#f2f2f2;}
                              </style>"
                    $events | ConvertTo-Html -Head $head -PreContent "<h1>$title</h1><h2>Generado el $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')</h2>" |
                    Out-File -FilePath $outputPath -Encoding UTF8
                }
            }

            Write-Host "Informe guardado en: $outputPath" -ForegroundColor Green
        } else {
            Write-Warning "No se encontraron eventos en el rango especificado."
        }
    } catch {
        Write-Error "Error al extraer eventos: $_"
    }
}

# Exportar la función
Export-ModuleMember -Function Get-Forense
