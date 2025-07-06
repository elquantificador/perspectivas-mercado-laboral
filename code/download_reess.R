# Descarga de base de datos del Registro Estadístico de Empleo en la Seguridad Social
# El Quantificador 2023
#
# NOTA: Las URLs y nombres de archivos se generan dinámicamente basándose en la
# configuración de períodos de tiempo. Para añadir nuevos meses/años, simplemente
# actualizar las variables start_year, start_month, end_year, end_month más abajo.

# Preliminares ------------------------------------------------------------


# Descargar ---------------------------------------------------------------

# Configuración de períodos de datos - actualizar estas variables para añadir nuevos períodos
# Para añadir nuevos meses/años, simplemente modificar estas variables
start_year <- 2022
start_month <- 1
end_year <- 2023
end_month <- 3

# Patrón base de URL para el repositorio de GitHub
base_url <- "https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS"

# Generar combinaciones año-mes dinámicamente
# Este código maneja automáticamente las transiciones entre años
year_months <- c()
for (year in start_year:end_year) {
  # Determinar el rango de meses para cada año
  if (year == start_year && year == end_year) {
    # Caso de un solo año
    months <- start_month:end_month
  } else if (year == start_year) {
    # Primer año: desde start_month hasta 12
    months <- start_month:12
  } else if (year == end_year) {
    # Último año: desde 1 hasta end_month
    months <- 1:end_month
  } else {
    # Años intermedios: todos los meses
    months <- 1:12
  }
  
  # Añadir combinaciones año_mes
  for (month in months) {
    year_months <- c(year_months, paste(year, month, sep = "_"))
  }
}

# Generar URLs y nombres de archivos de destino dinámicamente
# Estas listas se crean automáticamente basándose en la configuración de arriba
github_urls <- paste0(base_url, "_", year_months, ".csv")
dest_files <- paste0("data/REESS_", year_months, ".csv")

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


