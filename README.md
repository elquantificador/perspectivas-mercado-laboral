# Perspectivas sobre el mercado laboral: ¿donde están los mejores sueldos del país?

Este repositorio contiene el código y los archivos necesarios para reproducir el análisis del artículo de **El Quantificador** sobre las perspectivas del mercado laboral ecuatoriano 2022-2023.

**Fuente de datos**: [Registro Estadístico de Empleo en la Seguridad Social (REESS)](https://github.com/laboratoriolide/datos-reess) del Instituto Nacional de Estadística y Censos del Ecuador.

## Requisitos

- R (versión 4.0 o superior)
- RStudio (recomendado)
- Conexión a internet para descarga de datos
- Paquetes de R que se instalarán automáticamente: tidyverse, readxl, patchwork, scales, png, webp, openxlsx

## Reproducir el análisis

1. Clona o descarga este repositorio:
   ```bash
   git clone https://github.com/elquantificador/perspectivas-mercado-laboral.git
   cd perspectivas-mercado-laboral
   ```

2. Ejecuta el análisis completo desde R/RStudio:
   ```r
   source("code/analisis_reess.R")
   ```

3. Alternativamente, ejecuta paso a paso:
   ```r
   source("code/setup.R")          # Instalar y cargar paquetes
   source("code/download_reess.R") # Descargar datos REESS
   source("code/analisis_reess.R") # Ejecutar análisis
   source("code/tablas_ress.R")    # Generar tablas adicionales
   ```

4. Para generar el artículo completo:
   ```r
   rmarkdown::render("articulo_1.Rmd")
   ```

## Estructura

- `code/` contiene los scripts de análisis
- `figures/` gráficos generados automáticamente
- `data/` datos descargados de REESS
- `articulo_1.Rmd` artículo principal en R Markdown
- `*.xlsx` archivos Excel con tablas de resultados

**El Quantificador**
- Web: [elquantificador.blog](https://elquantificador.blog)
- Email: elquantificador@gmail.com
