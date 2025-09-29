# -PowerShell-Ciberseguridad
## 📂 Actividad 1 – Módulo de PowerShell para tareas forenses en Windows

### 🎯 Objetivo
El objetivo principal de esta actividad fue desarrollar un **módulo de PowerShell** que automatizara tres tareas forenses esenciales en sistemas Windows personales.  
El proyecto se centró en la **recopilación, correlación y documentación de evidencia digital**, aplicando buenas prácticas de scripting y desarrollo modular.

### 🔧 Scripts incluidos
- `Forense.psm1` → Módulo de PowerShell con funciones forenses.  
- `Forense.psd1` → Archivo de manifiesto del módulo.  
- `Main.ps1` → Script principal con un menú interactivo para invocar las funciones.  
- **Reportes** en formatos `.csv`, `.html` y `.xml`.  

### 🛠️ Tareas automatizadas
1. **Extracción de eventos relevantes del Visor de Eventos**
   - Uso de `Get-WinEvent` para filtrar registros por tipo y fecha.  
   - Exportación de eventos a CSV/HTML/XML.  
   - Identificación de actividad sospechosa (intentos de inicio de sesión fallidos, cambios no autorizados).  

2. **Correlación de procesos activos con conexiones de red**
   - Listado de procesos (`Get-Process`).  
   - Identificación de conexiones (`Get-NetTCPConnection`, `netstat`).  
   - Correlación de puertos abiertos con procesos.  
   - Detección de procesos sospechosos sin firma digital o en rutas no confiables.  

3. **Investigación de direcciones IP remotas con AbuseIPDB**
   - Extracción de IPs detectadas en conexiones activas.  
   - Consulta de reputación usando `Invoke-RestMethod` y la API de AbuseIPDB.  
   - Clasificación de IPs según nivel de riesgo.  

### 📘 Aprendizajes
- Uso avanzado de **cmdlets forenses en PowerShell** (`Get-WinEvent`, `Get-Process`, `Get-NetTCPConnection`).  
- Diseño de scripts **modulares y documentados** con `.psm1` y `.psd1`.  
- Manejo de **APIs externas** desde PowerShell.  
- Generación de reportes forenses claros y reutilizables.

- # 🛡️ AuditoriaBasica - Módulo de PowerShell

## 📖 Descripción
`AuditoriaBasica` es un **módulo de PowerShell** diseñado para realizar auditorías básicas en sistemas Windows. Permite:

- Detectar **usuarios locales inactivos**.
- Listar **servicios externos en ejecución**.  

Ideal para mantener la seguridad y control de cuentas y servicios en tu sistema.

---

## 📂 Actividad 2
- **`AuditoriaBasica.psm1`** – Módulo con funciones:
  - `Obtener-UsuariosInactivos`: Encuentra cuentas locales habilitadas que nunca han iniciado sesión.
  - `Obtener-ServiciosExternos`: Lista servicios en ejecución que no pertenecen explícitamente a Windows.
- **`AuditoriaBasica.psd1`** – Manifiesto del módulo (versión, autor, compatibilidad).
- **`Principal.ps1`** – Script principal interactivo que genera reportes en **CSV** y **HTML**.

---

## ⚙️ Funcionalidades
1. **Auditoría de usuarios** 👤  
   Identifica cuentas locales inactivas que podrían representar un riesgo de seguridad.
2. **Detección de servicios externos** 🖥️  
   Muestra software de terceros corriendo en segundo plano.
3. **Generación de reportes** 📊  
   - CSV para usuarios inactivos (`users_inac.csv` en el escritorio).  
   - HTML para servicios externos (`serv_e.html` en el escritorio).

---

## 🚀 Uso

1. **Abrir PowerShell como administrador.**
2. **Crear la carpeta del módulo e instalarlo:**
   ```powershell
   $moduloPath = "C:\Program Files\WindowsPowerShell\Modules\AuditoriaBasica"
   New-Item -Path $moduloPath -ItemType Directory
   Set-Location $moduloPath
