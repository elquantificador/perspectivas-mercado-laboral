# Descarga de base de datos del Registro Estadístico de Empleo en la Seguridad Social
# El Quantificador 2023

# Preliminares ------------------------------------------------------------

# Load required libraries
if(!require(readr)) install.packages("readr", repos = "http://cran.us.r-project.org")

# Helper functions for error handling and validation ---------------------

# Function to safely download a file with error handling
safe_download <- function(url, destfile, method = "libcurl") {
  tryCatch({
    # Attempt to download the file
    result <- download.file(url = url, destfile = destfile, method = method, quiet = TRUE)
    
    # Check if download was successful (return code 0)
    if (result != 0) {
      warning(paste("Download failed for", url, "- HTTP error or network issue"))
      return(FALSE)
    }
    
    # Check if the file was actually created and has content
    if (!file.exists(destfile)) {
      warning(paste("File not created:", destfile))
      return(FALSE)
    }
    
    # Check if file has reasonable size (not empty)
    file_size <- file.info(destfile)$size
    if (is.na(file_size) || file_size == 0) {
      warning(paste("Downloaded file is empty:", destfile))
      file.remove(destfile)  # Clean up empty file
      return(FALSE)
    }
    
    cat(paste("Successfully downloaded", destfile, "- Size:", file_size, "bytes\n"))
    return(TRUE)
    
  }, error = function(e) {
    warning(paste("Error downloading", url, ":", e$message))
    return(FALSE)
  })
}

# Function to validate CSV structure and content
validate_csv_data <- function(data, filename) {
  # Required columns based on actual CSV structure and usage in other scripts
  required_columns <- c("ano", "mes", "provincia", "edad", "sueldo", "dias", "empleo_total", "ciiu4_1", "empleo")
  
  # Check if data frame is empty
  if (nrow(data) == 0) {
    warning(paste("CSV file is empty:", filename))
    return(FALSE)
  }
  
  # Check if all required columns are present
  missing_columns <- setdiff(required_columns, names(data))
  if (length(missing_columns) > 0) {
    warning(paste("Missing required columns in", filename, ":", paste(missing_columns, collapse = ", ")))
    return(FALSE)
  }
  
  # Check for basic data integrity
  # Check if numeric columns contain reasonable values (allowing for some NA values)
  
  # Check year values (must be present and reasonable)
  if (all(is.na(data$ano)) || any(data$ano[!is.na(data$ano)] < 2020 | data$ano[!is.na(data$ano)] > 2025)) {
    warning(paste("Invalid year values in", filename))
    return(FALSE)
  }
  
  # Check month values (must be present and reasonable)
  if (all(is.na(data$mes)) || any(data$mes[!is.na(data$mes)] < 1 | data$mes[!is.na(data$mes)] > 12)) {
    warning(paste("Invalid month values in", filename))
    return(FALSE)
  }
  
  # Check if provincia values are reasonable (allow various values since filtering happens in analysis)
  # Just check that we have some valid provincia values (1-24) in the data
  valid_provincias <- sum(data$provincia %in% seq(1:24), na.rm = TRUE)
  if (valid_provincias == 0) {
    warning(paste("No valid provincia values (1-24) found in", filename))
    return(FALSE)
  }
  
  # Check if edad (age) values are reasonable (allowing for some unusual ages)
  if (all(is.na(data$edad)) || any(data$edad[!is.na(data$edad)] < 14 | data$edad[!is.na(data$edad)] > 130)) {
    warning(paste("Invalid edad values in", filename))
    return(FALSE)
  }
  
  # Check if sueldo (salary) values are reasonable (non-negative numbers, allow zeros and NAs)
  if (any(data$sueldo[!is.na(data$sueldo)] < 0)) {
    warning(paste("Invalid sueldo values in", filename))
    return(FALSE)
  }
  
  # Check if dias (days) are reasonable
  if (any(data$dias[!is.na(data$dias)] < 0 | data$dias[!is.na(data$dias)] > 31)) {
    warning(paste("Invalid dias values in", filename))
    return(FALSE)
  }
  
  # Check if empleo_total values are reasonable (allow various values including NAs)
  if (any(data$empleo_total[!is.na(data$empleo_total)] < 1 | data$empleo_total[!is.na(data$empleo_total)] > 10)) {
    warning(paste("Invalid empleo_total values in", filename))
    return(FALSE)
  }
  
  # Check if ciiu4_1 column exists and has some non-empty values
  if (all(is.na(data$ciiu4_1)) || all(data$ciiu4_1[!is.na(data$ciiu4_1)] == "")) {
    warning(paste("Invalid ciiu4_1 values in", filename))
    return(FALSE)
  }
  
  cat(paste("Successfully validated", filename, "- Rows:", nrow(data), "Columns:", ncol(data), "\n"))
  cat(paste("  Valid provincias (1-24):", valid_provincias, "out of", nrow(data), "\n"))
  return(TRUE)
}

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

# Descargar todos con manejo de errores

successful_downloads <- c()
failed_downloads <- c()

for (i in seq_along(github_urls)) {
  cat(paste("Downloading", i, "of", length(github_urls), ":", dest_files[i], "\n"))
  
  if (safe_download(github_urls[i], dest_files[i])) {
    successful_downloads <- c(successful_downloads, dest_files[i])
  } else {
    failed_downloads <- c(failed_downloads, dest_files[i])
  }
}

# Report download results
cat(paste("\nDownload Summary:\n"))
cat(paste("Successful downloads:", length(successful_downloads), "\n"))
cat(paste("Failed downloads:", length(failed_downloads), "\n"))

if (length(failed_downloads) > 0) {
  cat("Failed files:\n")
  for (failed_file in failed_downloads) {
    cat(paste("  -", failed_file, "\n"))
  }
}

# Check if we have any successful downloads
if (length(successful_downloads) == 0) {
  stop("Error: No files were successfully downloaded. Please check your internet connection and try again.")
}

# Cargar y juntar con validación -------------------------------------------

# Lista de todos los archivos CSV descargados exitosamente
list_csv_files <- successful_downloads

# Verificar que tenemos archivos para cargar
if (length(list_csv_files) == 0) {
  stop("Error: No CSV files available to load. Download process failed.")
}

cat(paste("Loading", length(list_csv_files), "CSV files...\n"))

# Leer y validar todos los archivos
valid_data_list <- list()

for (csv_file in list_csv_files) {
  cat(paste("Processing", csv_file, "...\n"))
  
  tryCatch({
    # Read the CSV file
    temp_data <- readr::read_csv(csv_file, show_col_types = FALSE)
    
    # Validate the data structure
    if (validate_csv_data(temp_data, csv_file)) {
      # Add file identifier
      temp_data$file_name <- csv_file
      valid_data_list[[csv_file]] <- temp_data
    } else {
      warning(paste("Skipping invalid file:", csv_file))
    }
    
  }, error = function(e) {
    warning(paste("Error reading", csv_file, ":", e$message))
  })
}

# Check if we have any valid data
if (length(valid_data_list) == 0) {
  stop("Error: No valid CSV files could be loaded. All files failed validation.")
}

cat(paste("Successfully loaded", length(valid_data_list), "valid CSV files\n"))

# Combine all valid data
ress_raw <- do.call(rbind, valid_data_list)

# Final validation of combined dataset
if (nrow(ress_raw) == 0) {
  stop("Error: Combined dataset is empty. Please check your data files.")
}

cat(paste("Final dataset created successfully with", nrow(ress_raw), "rows and", ncol(ress_raw), "columns\n"))

# Clean up temporary variables
rm(valid_data_list, temp_data)


