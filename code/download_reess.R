# Descarga de base de datos del Registro Estadístico de Empleo en la Seguridad Social
# El Quantificador 2023

# Preliminares ------------------------------------------------------------


# Descargar ---------------------------------------------------------------

# Lista de URLs en GitHub

github_urls <- c(
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_1.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_2.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_3.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_4.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_5.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_6.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_7.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_8.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_9.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_10.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_11.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2022_12.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2023_1.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2023_2.csv',
  'https://media.githubusercontent.com/media/laboratoriolide/datos-reess/main/data/BDD_REESS_2023_3.csv'
  
)

# Nombres para archivos de descarga

dest_files <- c(
  'data/REESS_2022_1.csv',
  'data/REESS_2022_2.csv',
  'data/REESS_2022_3.csv',
  'data/REESS_2022_4.csv',
  'data/REESS_2022_5.csv',
  'data/REESS_2022_6.csv',
  'data/REESS_2022_7.csv',
  'data/REESS_2022_8.csv',
  'data/REESS_2022_9.csv',
  'data/REESS_2022_10.csv',
  'data/REESS_2022_11.csv',
  'data/REESS_2022_12.csv',
  'data/REESS_2023_1.csv',
  'data/REESS_2023_2.csv',
  'data/REESS_2023_3.csv'
)

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


