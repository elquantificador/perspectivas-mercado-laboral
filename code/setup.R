# CONFIGURACIÓN DE PAQUETES
# Perspectivas sobre el mercado laboral - El Quantificador 2023
# 
# Este script consolida todas las dependencias de paquetes del proyecto
# y proporciona una fuente única de verdad para la gestión de paquetes.

# Function to install and load packages efficiently
install_and_load_packages <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, repos = "http://cran.us.r-project.org")
      library(pkg, character.only = TRUE)
    }
  }
}

# Lista de paquetes requeridos para el proyecto
required_packages <- c(
  "tidyverse",    # incluye dplyr, ggplot2, readr, forcats, lubridate, y más
  "readxl",       # para leer archivos Excel
  "patchwork",    # para combinar gráficos
  "scales",       # para escalas y formato
  "png",          # para manejo de imágenes PNG
  "webp",         # para manejo de imágenes WebP
  "openxlsx"      # para escribir archivos Excel
)

# Instalar y cargar todos los paquetes requeridos
cat("Instalando y cargando paquetes requeridos...\n")
install_and_load_packages(required_packages)
cat("¡Todos los paquetes cargados exitosamente!\n")

# Imprimir versiones de paquetes para reproducibilidad
cat("\nVersiones de paquetes cargados:\n")
for (pkg in required_packages) {
  cat(sprintf("- %s: %s\n", pkg, packageVersion(pkg)))
}