# Setup script for R package installation and loading
# Perspectivas sobre el mercado laboral - El Quantificador 2023
# 
# This script consolidates all package dependencies for the project
# and provides a single source of truth for package management.

# Function to install and load packages efficiently
install_and_load_packages <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, repos = "http://cran.us.r-project.org")
      library(pkg, character.only = TRUE)
    }
  }
}

# List of required packages for the project
required_packages <- c(
  "tidyverse",    # includes dplyr, ggplot2, readr, forcats, lubridate, and more
  "readxl",       # for reading Excel files
  "patchwork",    # for combining plots
  "scales",       # for scaling and formatting
  "png",          # for PNG image handling
  "webp",         # for WebP image handling
  "openxlsx"      # for writing Excel files
)

# Install and load all required packages
cat("Installing and loading required packages...\n")
install_and_load_packages(required_packages)
cat("All packages loaded successfully!\n")

# Print package versions for reproducibility
cat("\nLoaded package versions:\n")
for (pkg in required_packages) {
  cat(sprintf("- %s: %s\n", pkg, packageVersion(pkg)))
}