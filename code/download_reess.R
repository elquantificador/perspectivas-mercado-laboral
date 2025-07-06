# Descarga de base de datos del Registro Estadístico de Empleo en la Seguridad Social
# Perspectivas sobre el mercado laboral - El Quantificador 2023
# 
# Este script descarga automáticamente los datos del REESS desde el repositorio de GitHub

# Preliminares ------------------------------------------------------------


# Descargar ---------------------------------------------------------------

# Configuración de datos a descargar
# Para agregar nuevos períodos, actualizar estas variables:
# - Agregar años a download_years
# - Actualizar download_months con los meses disponibles para cada año

download_years <- c(2022, 2023)
download_months <- list(
  "2022" = 1:12,  # Todos los meses de 2022
  "2023" = 1:3    # Primeros 3 meses de 2023
)

# URLs base para la descarga
base_url <- 'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/'
dest_dir <- 'data/'

# Generar URLs y archivos de destino dinámicamente
# Esta función crea las listas de URLs y archivos de destino basándose en la configuración

generate_download_lists <- function(years, months_list, base_url, dest_dir) {
  urls <- c()
  dest_files <- c()
  
  for (year in years) {
    year_str <- as.character(year)
    months <- months_list[[year_str]]
    
    for (month in months) {
      # Generar URL: BDD_REESS_YYYY_M.csv
      url <- paste0(base_url, 'BDD_REESS_', year, '_', month, '.csv')
      urls <- c(urls, url)
      
      # Generar archivo de destino: REESS_YYYY_M.csv
      dest_file <- paste0(dest_dir, 'REESS_', year, '_', month, '.csv')
      dest_files <- c(dest_files, dest_file)
    }
  }
  
  return(list(urls = urls, dest_files = dest_files))
}

# Generar listas de URLs y archivos de destino
download_lists <- generate_download_lists(download_years, download_months, base_url, dest_dir)
github_urls <- download_lists$urls
dest_files <- download_lists$dest_files

# Mostrar información sobre los archivos a descargar
cat("Archivos a descargar:\n")
cat("- Años:", paste(download_years, collapse = ", "), "\n")
for (year in download_years) {
  year_str <- as.character(year)
  months <- download_months[[year_str]]
  cat("- Meses", year_str, ":", paste(months, collapse = ", "), "\n")
}
cat("- Total de archivos:", length(github_urls), "\n\n")

# Descargar todos

for (i in seq_along(github_urls)) {
  download.file(url = github_urls[i], 
                destfile = dest_files[i], 
                method = "libcurl")
  cat(paste("Downloaded", dest_files[i], "\n"))
}

# Cargar y juntar ---------------------------------------------------------

# Lista de todos los archivos del 2022 al 23

list_csv_files <-
  list.files(path = 'data/',
             full.names = T,
             pattern = '*.csv')

# Leer todos los archivos

ress_raw <-
  readr::read_csv(list_csv_files,
                  id = 'file_name')


