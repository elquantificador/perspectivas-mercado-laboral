# Perspectivas sobre el mercado laboral: ¿donde están los mejores sueldos del país?

Este es el repositorio contiene archivos relacionados al artículo del Quantificador sobre el análisis de las Perspectivas sobre el mercado laboral 2022-2023 utilizando la base de datos RESS.

# Contenido del repositorio

**Code**: Tres archivos R que contienen el análisis de la base de datos RESS y el código necesario para la descarga de la base de datos.

- `setup.R`: Script centralizado para instalación y carga de todos los paquetes R requeridos
- `download_reess.R`: Script para descargar la base de datos RESS
- `analisis_reess.R`: Script principal de análisis de datos
- `tablas_ress.R`: Script para generar tablas y análisis por CIIU

**Figures**: Las imágenes utilizadas en el artículo.

# Dependencias de R

Este proyecto requiere los siguientes paquetes de R:

- **tidyverse**: Colección de paquetes para ciencia de datos (incluye dplyr, ggplot2, readr, forcats, lubridate)
- **readxl**: Para leer archivos Excel
- **patchwork**: Para combinar gráficos
- **scales**: Para escalado y formateo
- **png**: Para manejo de imágenes PNG
- **webp**: Para manejo de imágenes WebP  
- **openxlsx**: Para escribir archivos Excel

## Instalación y uso

1. Ejecute `source("code/setup.R")` para instalar y cargar automáticamente todos los paquetes requeridos
2. Los scripts `analisis_reess.R` y `tablas_ress.R` ya incluyen esta llamada al setup

## Reproducibilidad

Todos los paquetes se instalan automáticamente desde CRAN si no están disponibles. El script `setup.R` también muestra las versiones de los paquetes cargados para asegurar la reproducibilidad.

