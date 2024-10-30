### adrs
ADRS (Active Directory Recon Suite) es una herramienta de auditoría para Active Directory que recopila información clave del dominio, incluyendo usuarios, grupos, políticas y controladores de dominio. Diseñada para administradores y profesionales de ciberseguridad, permite exportar los datos a CSV y JSON para un análisis detallado.

# **ADRS (AD Recon Suite)**
**Autor**: [espinozan](https://github.com/espinozan)

---

```markdown
# ADRS (AD Recon Suite)

## Descripción General

**ADRS** (Active Directory Reconnaissance Suite) es una herramienta avanzada de auditoría y reconocimiento para entornos de **Active Directory**. Su objetivo es ayudar a administradores de sistemas y profesionales de ciberseguridad a recopilar y analizar información clave del dominio de manera rápida y estructurada. Esta herramienta permite obtener una visión clara y detallada de la configuración del dominio, identificando usuarios, grupos, políticas, controladores de dominio, unidades organizativas (OUs), enlaces de sitio, y otros recursos críticos de AD.

ADRS es ideal para:
- Auditorías de seguridad en entornos de Active Directory.
- Evaluaciones de infraestructura de red.
- Reconocimiento de información en pruebas de penetración.
- Administración avanzada y exploración de configuraciones de AD.

## Características

- **Verificación de Permisos**: Comprueba automáticamente si el usuario tiene permisos de administrador y, si no los tiene, permite relanzar el script como administrador.
- **Descarga Automática de PowerView**: Si el módulo PowerView no está disponible, el script ofrece la opción de descargarlo automáticamente desde GitHub para asegurar su correcto funcionamiento.
- **Menú Interactivo**: Un menú fácil de usar permite ejecutar comandos específicos para obtener diferentes tipos de información sobre el dominio.
- **Recopilación Detallada**: Incluye una opción de "Recopilación Completa" que extrae todos los datos disponibles en un solo comando.
- **Opciones de Exportación**: Los resultados de cada consulta se pueden exportar a formato **CSV** o **JSON** para facilitar el análisis posterior y la documentación.
- **Formato de Salida Clara**: Presenta los resultados en un formato de tabla en la consola para facilitar la visualización.

## Instalación

Para instalar y configurar **ADRS**, sigue estos pasos:

1. **Clonar el Repositorio**:
   ```bash
   git clone https://github.com/espinozan/adrs.git
   cd adrs
   ```
```

2. **Permisos de Ejecución**:
   Asegúrate de tener permisos de administrador para ejecutar el script. ADRS verificará automáticamente si tienes permisos de administrador al inicio y, si no, te dará la opción de relanzar el script como administrador.

3. **Ejecución de Scripts**:
   Si no tienes habilitada la ejecución de scripts en PowerShell, necesitarás ajustar la política de ejecución. El script te preguntará automáticamente si deseas cambiar la política a `RemoteSigned` para permitir la ejecución segura de scripts locales y de terceros.

## Uso

Para ejecutar **ADRS**, simplemente inicia PowerShell como administrador y ejecuta el archivo principal del script.

```powershell
.\adrs.ps1
```

Una vez iniciado, el script mostrará un **menú interactivo** que permite elegir entre varias opciones de recopilación de información. A continuación, se explica el funcionamiento de cada opción del menú.

### Opciones del Menú

1. **Verificar acceso de administrador local**: Comprueba si el usuario actual tiene permisos de administrador local en otras máquinas del dominio. Esto es útil para identificar cuentas privilegiadas que puedan ser utilizadas para la administración remota.

2. **Obtener todos los usuarios del dominio y sus grupos**: Muestra una lista de todos los usuarios del dominio, incluyendo su descripción, los grupos a los que pertenecen, la última vez que cambiaron su contraseña, y el número de intentos fallidos de contraseña.

3. **Obtener todas las computadoras del dominio**: Muestra información sobre las computadoras del dominio, incluyendo el sistema operativo y su versión. Esto es útil para identificar el entorno operativo y cualquier posible máquina obsoleta.

4. **Obtener todos los grupos del dominio y sus miembros**: Enumera todos los grupos del dominio y sus miembros. Esto permite identificar grupos críticos y verificar sus permisos.

5. **Obtener todos los controladores de dominio**: Muestra todos los controladores de dominio, así como el sitio y el bosque en el que se encuentran. Esto es esencial para entender la topología de replicación y administración.

6. **Obtener todas las políticas de dominio**: Extrae las políticas configuradas en el dominio, como las políticas de contraseñas, lo que puede revelar configuraciones de seguridad clave.

7. **Obtener todos los dominios de confianza**: Lista los dominios de confianza asociados al dominio actual, lo que es útil para entender la arquitectura de confianza en la red.

8. **Obtener todos los enlaces de sitios**: Enumera los enlaces de sitios y sus frecuencias de replicación, lo que es crucial para entender la conectividad y el costo de replicación entre sitios de AD.

9. **Obtener todas las OUs (Unidades Organizativas)**: Muestra todas las unidades organizativas en el dominio, permitiendo visualizar la estructura jerárquica de Active Directory.

10. **Obtener todos los GPOs (Objetos de Política de Grupo)**: Lista todos los GPOs aplicados en el dominio, lo cual es fundamental para entender cómo se aplican las políticas en los diferentes niveles.

11. **Recopilación Completa y Detallada**: Ejecuta todas las opciones anteriores y recopila todos los datos en un solo paso. Los resultados se pueden exportar en CSV o JSON, lo que facilita el análisis exhaustivo.

12. **Salir**: Finaliza la ejecución del script.

### Exportación de Resultados

Para cada opción del menú, **ADRS** da la posibilidad de exportar los resultados en formato **CSV** o **JSON**. Esto permite documentar los resultados de la auditoría y facilita la integración con otras herramientas de análisis o reportes.

## Requisitos Previos

- **PowerShell**: Asegúrate de tener PowerShell instalado en tu máquina (preferiblemente PowerShell 5.1 o superior).
- **Permisos de Administrador**: Algunas funciones de ADRS requieren permisos de administrador en el dominio.
- **Conexión a Internet**: Si el módulo PowerView no está disponible, el script intentará descargarlo desde GitHub, por lo que se requiere una conexión activa.

## Ejemplo de Flujo de Trabajo

1. Ejecuta `adrs.ps1` como administrador.
2. Elige la opción **Recopilación Completa y Detallada** para obtener toda la información del dominio en un solo paso.
3. Selecciona el formato de exportación **CSV** para analizar los resultados en Excel o **JSON** para integrarlo en otras herramientas de análisis.
4. Revisa los archivos exportados para identificar posibles riesgos o áreas de interés en la configuración de Active Directory.

## Seguridad

**ADRS** está diseñado para ejecutarse en entornos de pruebas o auditoría con autorización previa. Algunos cmdlets pueden acceder a información sensible en el entorno de Active Directory, por lo que es importante usar esta herramienta únicamente en entornos donde tengas permiso explícito para realizar auditorías.

**Nota**: **ADRS** no realiza cambios en la configuración de Active Directory ni modifica permisos. Su función es únicamente de recolección de información.

## Limitaciones

- **Entornos de Red Restringidos**: En entornos donde las políticas de ejecución de scripts o los permisos de red están restringidos, algunas funcionalidades pueden no estar disponibles.
- **Dependencia de PowerView**: ADRS utiliza PowerView para recopilar información, por lo que requiere este módulo para funcionar correctamente.

## Licencia

Este proyecto está bajo la [Licencia MIT](https://opensource.org/licenses/MIT) - puedes ver el archivo `LICENSE` para más detalles.

---

¡Gracias por usar **ADRS**! Si tienes sugerencias o encuentras problemas, no dudes en crear un issue en el repositorio o contactarme directamente en GitHub.

---

```

### Explicación de las Secciones

- **Descripción General** y **Características**: Estas secciones explican la finalidad de la herramienta y destacan sus características principales.
- **Instalación** y **Uso**: Guían al usuario para clonar, configurar y ejecutar el script, incluyendo explicaciones sobre el menú interactivo.
- **Exportación de Resultados** y **Requisitos Previos**: Detallan cómo exportar los datos y los requisitos necesarios para su uso.
- **Ejemplo de Flujo de Trabajo**: Ayuda al usuario a entender cómo utilizar **ADRS** de manera efectiva en un escenario típico.
- **Seguridad** y **Limitaciones**: Informan al usuario sobre el contexto de uso y las posibles limitaciones en ciertos entornos.
- **Licencia**: Aclara la licencia del proyecto.

Esta documentación es completa y fácil de entender para cualquier usuario interesado en usar o contribuir al proyecto en GitHub. ¡Espero que te sea útil!
