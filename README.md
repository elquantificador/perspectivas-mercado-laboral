# Perspectivas sobre el mercado laboral: ¿donde están los mejores sueldos del país?

Este repositorio contiene archivos relacionados al artículo de **El Quantificador** sobre el análisis de las perspectivas del mercado laboral ecuatoriano 2022-2023, utilizando la base de datos del Registro Estadístico de Empleo en la Seguridad Social (REESS).

## Descripción del proyecto

El proyecto analiza la evolución del mercado laboral formal en Ecuador entre 2022 y 2023, enfocándose en:
- Análisis por provincias del Ecuador
- Análisis por sectores industriales (clasificación CIIU)
- Evolución de salarios y empleo formal
- Identificación de provincias e industrias con mejores salarios y mayor generación de empleo

**Pregunta de investigación**: ¿Qué provincias e industrias aportan más empleos y tienen mejores salarios? ¿Existe una mejora sustancial en el desempeño del Ecuador en términos de salarios y puestos de trabajo durante este período?

## Estructura del proyecto

```
perspectivas-mercado-laboral/
├── code/                    # Scripts de análisis
│   ├── setup.R             # Instalación y carga de paquetes R
│   ├── download_reess.R    # Descarga de datos REESS
│   ├── analisis_reess.R    # Análisis principal de datos
│   └── tablas_ress.R       # Generación de tablas por CIIU
├── figures/                # Gráficos generados (creado automáticamente)
├── data/                   # Datos descargados (creado automáticamente)
├── articulo_1.Rmd         # Artículo principal en R Markdown
├── articulo_1.html        # Artículo renderizado en HTML
├── referencias.bib        # Referencias bibliográficas
├── style.csl             # Estilo de citación
├── *.xlsx                # Archivos Excel generados
└── README.md             # Este archivo
```

### Descripción de archivos principales

**Scripts de análisis (`code/`)**:
- `setup.R`: Script centralizado para instalación y carga automática de todos los paquetes R requeridos
- `download_reess.R`: Script para descargar automáticamente la base de datos REESS desde el repositorio de GitHub
- `analisis_reess.R`: Script principal que realiza el análisis de datos y genera las visualizaciones
- `tablas_ress.R`: Script para generar tablas de resumen y análisis por sectores CIIU

**Documentos**:
- `articulo_1.Rmd`: Artículo principal en formato R Markdown con análisis completo
- `articulo_1.html`: Versión renderizada del artículo para visualización web
- `referencias.bib`: Base de datos bibliográfica en formato BibTeX

**Archivos generados**:
- `figures/`: Directorio con gráficos generados automáticamente (PNG de alta resolución)
- `data/`: Directorio con datos descargados de REESS (archivos CSV)
- `*.xlsx`: Archivos Excel con tablas de resultados por sectores industriales

## Fuentes de datos

### Base de datos REESS (Registro Estadístico de Empleo en la Seguridad Social)

El proyecto utiliza datos del **REESS**, publicado por el **INEC** (Instituto Nacional de Estadística y Censos del Ecuador). Esta base de datos contiene información completa sobre empleados registrados en la seguridad social ecuatoriana.

**Características de los datos**:
- **Período**: 2022 (todos los meses) y 2023 (enero-marzo)
- **Cobertura**: Empleados del sector formal registrados en la seguridad social
- **Variables principales**: provincia, edad, sueldo, días trabajados, sector industrial (CIIU), tipo de empleo
- **Fuente**: Instituto Nacional de Estadística y Censos (INEC) - www.ecuadorencifras.gob.ec
- **Repositorio de datos**: [laboratoriolide/datos-reess](https://github.com/laboratoriolide/datos-reess)

**Clasificación Industrial**:
- Los sectores industriales se clasifican según la **CIIU** (Clasificación Industrial Internacional Uniforme)
- Permite análisis detallado por actividad económica
- Facilita comparaciones intersectoriales de salarios y empleo

## Requisitos del sistema

### Software necesario
- **R** (versión 4.0 o superior)
- **RStudio** (recomendado para desarrollo)
- Conexión a internet (para descarga de datos y paquetes)

### Paquetes de R requeridos

Los siguientes paquetes se instalan automáticamente al ejecutar el proyecto:

- **tidyverse**: Colección de paquetes para ciencia de datos (incluye dplyr, ggplot2, readr, forcats, lubridate)
- **readxl**: Para leer archivos Excel
- **patchwork**: Para combinar gráficos
- **scales**: Para escalado y formateo
- **png**: Para manejo de imágenes PNG
- **webp**: Para manejo de imágenes WebP  
- **openxlsx**: Para escribir archivos Excel

## Instalación y configuración

### Paso 1: Clonar el repositorio
```bash
git clone https://github.com/elquantificador/perspectivas-mercado-laboral.git
cd perspectivas-mercado-laboral
```

### Paso 2: Configurar entorno R
```r
# Abrir R o RStudio en el directorio del proyecto
# Los paquetes se instalan automáticamente al ejecutar cualquier script
```

### Paso 3: Verificar instalación
```r
# Ejecutar el script de configuración para verificar dependencias
source("code/setup.R")
```

## Reproducción del análisis

### Opción 1: Análisis completo automático
```r
# Ejecutar el análisis completo desde R/RStudio
source("code/analisis_reess.R")
```

Este comando:
1. Instala automáticamente todos los paquetes necesarios
2. Descarga los datos REESS más recientes
3. Procesa y analiza los datos
4. Genera todas las visualizaciones en `figures/`
5. Muestra las versiones de paquetes para reproducibilidad

### Opción 2: Ejecución paso a paso

#### 1. Configurar paquetes
```r
source("code/setup.R")
```

#### 2. Descargar datos
```r
source("code/download_reess.R")
```

#### 3. Ejecutar análisis
```r
source("code/analisis_reess.R")
```

#### 4. Generar tablas adicionales
```r
source("code/tablas_ress.R")
```

### Opción 3: Generar el artículo completo
```r
# Renderizar el artículo completo en HTML
rmarkdown::render("articulo_1.Rmd")
```

## Resultados esperados

Al completar la ejecución, se generarán los siguientes archivos:

### Visualizaciones (`figures/`)
- `grafico_median.png`: Evolución de la mediana salarial por provincia
- `grafico_median_p.png`: Evolución de salarios sector privado vs público  
- `grafico_ciiu.png`: Salarios por sector industrial (CIIU)
- `grafico_empleo_tot.png`: Evolución del empleo formal total

### Tablas de datos (`*.xlsx`)
- `df_ciiu.xlsx`: Empleo por sector industrial (marzo 2023)
- `df_empleo_ciiu.xlsx`: Evolución del empleo por sector CIIU
- `df_empleo_1.xlsx`: Datos de empleo procesados
- `archivo_combinado.xlsx`: Todas las tablas en un archivo Excel

### Artículo
- `articulo_1.html`: Artículo completo con análisis y visualizaciones

## Personalización del análisis

### Modificar período de análisis
Editar `code/download_reess.R`:
```r
# Cambiar años y meses a analizar
download_years <- c(2022, 2023, 2024)  # Agregar años
download_months <- list(
  "2022" = 1:12,    # Todos los meses
  "2023" = 1:12,    # Todos los meses  
  "2024" = 1:6      # Primeros 6 meses
)
```

### Filtrar provincias específicas
Editar `code/analisis_reess.R`:
```r
# Filtrar provincias específicas (ejemplo: solo Pichincha y Guayas)
df_raw <- ress_raw %>%  
  filter(provincia %in% c(17, 9))  # 17=Pichincha, 9=Guayas
```

## Contribución al proyecto

### Cómo contribuir
1. Fork el repositorio
2. Crea una rama para tu funcionalidad: `git checkout -b feature/nueva-funcionalidad`
3. Realiza tus cambios siguiendo las convenciones del proyecto
4. Ejecuta las pruebas y verifica que el análisis se reproduce correctamente
5. Commit tus cambios: `git commit -m "Agregar nueva funcionalidad"`
6. Push a la rama: `git push origin feature/nueva-funcionalidad`
7. Abre un Pull Request

### Convenciones de código
- Usar comentarios descriptivos en español
- Mantener consistencia en el estilo de código R
- Documentar nuevas funciones y análisis
- Actualizar README.md si se agregan nuevas funcionalidades

### Reportar problemas
- Usar GitHub Issues para reportar bugs o solicitar funcionalidades
- Incluir información sobre versión de R y sistema operativo
- Proporcionar ejemplos reproducibles cuando sea posible

## Notas técnicas

### Sobre la metodología
- Se utiliza la **mediana salarial** en lugar del promedio para mejor representación de la tendencia central
- El análisis se enfoca en el **sector formal** debido a la disponibilidad y calidad de datos
- La clasificación **CIIU** permite análisis comparativo internacional

### Limitaciones
- Los datos cubren únicamente empleados registrados en la seguridad social (sector formal)
- No incluye información sobre empleo informal
- La muestra puede tener sesgos hacia sectores con mayor formalización

## Reproducibilidad

Todos los paquetes se instalan automáticamente desde CRAN si no están disponibles. El script `setup.R` también muestra las versiones de los paquetes cargados para asegurar la reproducibilidad.

Para garantizar resultados idénticos:
1. Usar la misma versión de R
2. Ejecutar `source("code/setup.R")` al inicio
3. Verificar las versiones de paquetes mostradas en consola

## Licencia

Este proyecto está bajo los términos de la licencia especificada en el repositorio.

## Contacto

**El Quantificador**
- Web: [elquantificador.org](https://elquantificador.org)
- Email: Para consultas sobre metodología y datos

---

*Proyecto desarrollado por El Quantificador para el análisis del mercado laboral ecuatoriano*

