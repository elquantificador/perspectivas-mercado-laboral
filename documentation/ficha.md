# Ficha del artículo

Completa esta ficha al crear el repositorio y mantenla al día. Es el único
lugar con datos propios del artículo; el README es igual en todos los
repositorios.

## Identificación

- **Título:** Perspectivas sobre el mercado laboral: ¿dónde están los mejores sueldos del país?
- **Descripción del repositorio:** Articulo del Quantificador sobre las perspectivas sobre el mercado laboral entre el periodo 2022 y 2023.
- **Autoría:** Sebastián Morales (en el sitio figura solo con ese nombre; no se encontró un segundo apellido).
- **Fecha de publicación:** 2023-09-07
- **Artículo publicado:** https://elquantificador.org/post/economia/2023-09-07-perspectivas-sobre-el-mercado-laboral/
- **Categoría:** Economía
- **Edición:** Septiembre 2023 - Marzo 2024

## Estado

Publicado el 2023-09-07. Nota: el "README anterior" de este repositorio estaba copiado del artículo de protestas (repositorio `protestas-2022-07-16`) y no describe este artículo; esta ficha se redactó a partir del código de `code/`, de `report/articulo_1.Rmd` y del artículo publicado. El título que traía la ficha también era el de protestas y se corrigió.

## Pregunta y alcance

El artículo analiza la evolución del mercado laboral formal de Ecuador entre 2022 y 2023, con foco en provincias e industrias, para saber qué provincias e industrias aportan más empleos y tienen mejores salarios, y si hubo una mejora sustancial en salarios y puestos de trabajo en ese periodo. La cobertura es nacional (24 provincias) y la unidad de análisis es el registro de empleo en la seguridad social (empleo formal solamente), de enero de 2022 a marzo de 2023.

## Requisitos

- R: no documentada en el repositorio.
- Paquetes de R: openxlsx, patchwork, png, readxl, scales, tidyverse (incluye dplyr, forcats, ggplot2, lubridate, readr y stringr) y webp. `code/setup.R` los instala si faltan y los carga.

## Fuentes de datos

| Fuente | Institución | Periodo | Acceso | Script |
|---|---|---|---|---|
| Registro Estadístico de Empleo en la Seguridad Social (REESS), bases mensuales | Instituto Nacional de Estadística y Censos (INEC) | 2022-01 a 2022-12 y 2023-01 a 2023-03 | Descarga automática, de una copia mensual en el repositorio de GitHub `laboratoriolide/datos-reess` (`BDD_REESS_AAAA_M.csv`) | `code/download_reess.R` |

Fuente oficial: https://www.ecuadorencifras.gob.ec/registro-empleo-seguridad-social/. El script no descarga del portal del INEC sino de la copia de LIDE en GitHub (ruta `media.githubusercontent.com`); guarda cada mes en `data/REESS_AAAA_M.csv`.

## Salidas

- `figures/grafico_empleo_tot.png`: evolución del número de empleos registrados en la seguridad social, 2022-2023.
- `figures/grafico_median.png`: mediana del sueldo en el sector privado formal, 2022-2023.
- `figures/grafico_median_p.png`: mediana del sueldo formal por provincia, marzo de 2023.
- `figures/grafico_ciiu.png`: mediana del sueldo formal por industria (CIIU), marzo de 2023.
- `df_ciiu.xlsx`, `df_empleo_1.xlsx`, `df_ciiugr.xlsx`, `df_empleo_ciiu.xlsx` y `archivo_combinado.xlsx` (en la raíz): tablas de empleo por industria y por mes que escribe `code/tablas_ress.R`; el combinado reúne las cuatro hojas.
- `report/articulo_1.Rmd` y `report/articulo_1.html`: texto del artículo; el Rmd carga las figuras desde `figures/`.

Los PNG y los Excel no están versionados en el repositorio; se generan al ejecutar los scripts.

## Cómo replicar en este repositorio

Este repositorio no tiene `MASTER.R` ni una guía propia de replicación (el README anterior describía otro artículo), así que el orden siguiente se dedujo de los scripts. Hay pasos que dependen de la sesión de R, por lo que conviene correr todo en la misma sesión y desde la raíz del repositorio (abre `repositorio_IESS.Rproj`).

1. Crea las carpetas `data/` y `figures/` si no existen; los scripts no las crean y `.gitignore` excluye `data/`.
2. Corre `code/analisis_reess.R`. Ese script ejecuta `code/setup.R` (carga paquetes) y `code/download_reess.R` (descarga los 15 CSV mensuales a `data/` y los une en el objeto `ress_raw`), y luego construye y guarda las cuatro figuras en `figures/`.
3. Corre `code/tablas_ress.R` en la misma sesión. Usa el objeto `ress_raw` que dejó el paso anterior, porque no vuelve a descargar los datos, y escribe los archivos Excel en la raíz.
4. Para ver el artículo, abre `report/articulo_1.Rmd` y usa Knit. El Rmd busca las imágenes en `figures/` relativa a `report/`, mientras que el script las guarda en `figures/` de la raíz; copia o ajusta la ruta si el Knit no las encuentra.

## README anterior

Texto del README de este repositorio antes de adoptar el README estándar,
conservado sin cambios de contenido para no perder información.

### Una perspectiva cuantitativa sobre las protestas en Ecuador

Este repositorio contiene el código y los archivos necesarios para analizar la participación en protestas en Ecuador utilizando los datos de LAPOP.

#### Requisitos
- R (se recomienda usar RStudio).
- Paquetes de R que se instalarán automáticamente al ejecutar los scripts.
- Opcionalmente LaTeX para compilar el artículo en PDF.

#### Cómo reproducir el análisis
1. Clona o descarga este repositorio.
2. Ejecuta `code/protestas_download.R` para descargar la base de datos desde Google Drive.
3. Corre `code/protestas_data_manipulation.R` para procesar y guardar las bases de datos.
4. Finalmente ejecuta `code/protestas_analysis.R` para generar las figuras y el artículo.

Para más información, revisa el perfil de GitHub del [autor](https://github.com/sebastian2627). El [repositorio original](https://github.com/sebastian2627/repositorio_mercadolab) contiene una versión preliminar del proyecto.
