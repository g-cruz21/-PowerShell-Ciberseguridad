@{
    # Nombre del módulo principal
    RootModule        = 'Forensem.psm1'

    # Versión del módulo
    ModuleVersion     = '1.0.1'

    # Identificador único del módulo
    GUID              = 'c2345678-90ab-4cde-f123-456789abcdef'

    # Autor del módulo
    Author            = 'Jesus Ramirez'

    # Descripción breve del módulo
    Description       = 'Funciones para analizar procesos y conexiones de red, generando reportes de actividad y procesos sospechosos.'

    # Funciones que se exportan al importar el módulo
    FunctionsToExport = @('Get-ProcessConnections','Get-SuspiciousProcesses')

    # No hay cmdlets personalizados exportados
    CmdletsToExport   = @()

    # No hay aliases
    AliasesToExport   = @()

    # Variables que se exportan (ninguna)
    VariablesToExport = @()

    # Versión mínima de PowerShell requerida
    PowerShellVersion = '5.1'
}
