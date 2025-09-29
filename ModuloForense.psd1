@{
    # Nombre del módulo principal
    RootModule        = 'ModuloForense.psm1'

    # Versión del módulo
    ModuleVersion     = '1.0.1'

    # Identificador único del módulo
    GUID              = 'a1234567-89ab-4cde-f123-456789abcdef'

    # Autor del módulo
    Author            = 'Angel Cruz'

    # Descripción breve del módulo
    Description       = 'Función para extraer eventos de registro de Windows y generar reportes en CSV, XML o HTML.'

    # Funciones que se exportan al importar el módulo
    FunctionsToExport = @('Get-Forense')

    # No hay cmdlets personalizados exportados
    CmdletsToExport   = @()

    # No hay aliases
    AliasesToExport   = @()

    # Variables que se exportan (ninguna)
    VariablesToExport = @()

    # Versión mínima de PowerShell requerida
    PowerShellVersion = '5.1'
}
