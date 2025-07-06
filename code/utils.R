# Utility functions for REESS analysis
# Common functions to reduce code duplication

# Utility functions for REESS analysis
# Common functions to reduce code duplication

# Load required packages --------------------------------------------------

#' Load all required packages for REESS analysis
#' @param packages Character vector of package names to load
load_required_packages <- function(packages = NULL) {
  if (is.null(packages)) {
    packages <- c("dplyr", "readxl", "ggplot2", "readr", "forcats", 
                  "lubridate", "tidyverse", "patchwork", "scales", 
                  "png", "webp", "openxlsx")
  }
  
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, repos = "http://cran.us.r-project.org")
      library(pkg, character.only = TRUE)
    }
  }
}

# Load packages immediately when file is sourced
load_required_packages()

# Date processing ---------------------------------------------------------

#' Create standardized date column from month and year
#' @param data Data frame containing mes and ano columns
#' @param mes_col Name of month column (default: "mes")
#' @param ano_col Name of year column (default: "ano")
#' @param date_col Name of new date column (default: "fecha_1")
create_date_column <- function(data, mes_col = "mes", ano_col = "ano", date_col = "fecha_1") {
  data %>%
    mutate(!!date_col := paste("01", paste(.data[[mes_col]], .data[[ano_col]], sep = '-')) %>% dmy())
}

# Province and region factors ---------------------------------------------

#' Create province factors with standardized labels
#' @param data Data frame containing provincia column
#' @param provincia_col Name of province column (default: "provincia")
create_province_factors <- function(data, provincia_col = "provincia") {
  province_labels <- c("Azuay", "Bolívar", "Cañar", "Carchi", "Cotopaxi", "Chimborazo",
                      "El Oro", "Esmeraldas", "Guayas", "Imbabura", "Loja", "Los Ríos",
                      "Manabí", "Morona Santiago", "Napo", "Pastaza", "Pichincha",
                      "Tungurahua", "Z.Chinchipe", "Galápagos", "Sucumbíos", "Orellana",
                      "Santo Domingo de los Tsáchilas", "Santa Elena")
  
  data %>%
    mutate(prov_fct = factor(.data[[provincia_col]], levels = c(1:24), labels = province_labels))
}

#' Create region factors from province factors
#' @param data Data frame containing prov_fct column
create_region_factors <- function(data) {
  data %>%
    mutate(region = fct_collapse(prov_fct,
                                "Sierra" = c("Azuay", "Bolívar", "Carchi", "Cañar", "Chimborazo",
                                           "Cotopaxi", "Imbabura", "Loja", "Pichincha", "Tungurahua"),
                                "Costa" = c("El Oro", "Esmeraldas", "Guayas", "Los Ríos", "Manabí",
                                          "Santa Elena", "Santo Domingo de los Tsáchilas"),
                                "Región Amazónica" = c("Morona Santiago", "Napo", "Orellana",
                                                     "Pastaza", "Sucumbíos", "Z.Chinchipe"),
                                "Islas Galápagos" = "Galápagos"))
}

# CIIU classification -----------------------------------------------------

#' Create CIIU sector classification - detailed version
#' @param data Data frame containing ciiu4_1 column
create_ciiu_classification_detailed <- function(data) {
  data %>%
    mutate(ciiu4_1_fct = as.factor(ciiu4_1),
           ciiu4_fct = fct_collapse(ciiu4_1_fct,
                                   "Agricultura, ganadería,  silvicultura y pesca" = "A",
                                   "Explotación de minas y canteras" = "B",
                                   "Industrias manufactureras" = "C",
                                   "Suministro de electricidad, gas, vapor y aire acondicionado" = "D",
                                   "Distribución de agua; alcantarillado, gestión de desechos y actividades de saneamiento." = "E",
                                   "Construcción" = "F",
                                   "Comercio al por mayor y al por menor; reparación de vehículos automotores y motocicletas" = "G",
                                   "Transporte y almacenamiento" = "H",
                                   "Actividades de alojamiento y de servicio de comidas" = "I",
                                   "Información y comunicación" = "J",
                                   "Actividades financieras y de seguros" = "K",
                                   "Actividades inmobiliarias" = "L",
                                   "Actividades profesionales, científicas y técnicas" = "M",
                                   "Actividades de servicios administrativos y de apoyo" = "N",
                                   "Administración pública y defensa; planes de seguridad social de afiliación obligatoria" = "O",
                                   "Enseñanza" = "P",
                                   "Actividades de atención de la salud humana y de asistencia social" = "Q",
                                   "Artes, entretenimiento y recreación" = "R",
                                   "Otras actividades de servicios" = "S",
                                   "Actividades de los hogares como empleadores; actividades no diferenciadas de los hogares como productores de bienes y servicios para uso propio" = "T",
                                   "Organizaciones internacionales" = "U",
                                   "Otro" = "Z0_Nocla_CIIU"))
}

#' Create CIIU sector classification - grouped version
#' @param data Data frame containing ciiu4_1 column
create_ciiu_classification_grouped <- function(data) {
  data %>%
    mutate(ciiu4_1_fct = as.factor(ciiu4_1),
           ciiu4_1_fct = fct_collapse(ciiu4_1_fct,
                                     "Agropecuaria y pesca" = "A",
                                     "Industria minero-energética" = c("B", "D"),
                                     "Industrias manufactureras" = "C",
                                     "Servicios publicos/defensa/saneamiento" = c("E", "O"),
                                     "Sector inmobiliario y construcción" = c("F", "L"),
                                     "Comercio; reparación de vehículos motorizados" = "G",
                                     "Transporte y almacenamiento" = "H",
                                     "Hospitalidad y de servicio de comidas" = "I",
                                     "Información y comunicación" = "J",
                                     "Actividades financieras y de seguros" = "K",
                                     "Servicios profesionales y técnicos" = "M",
                                     "Servicios administrativos y otros" = c("N", "S"),
                                     "Enseñanza" = "P",
                                     "Salud y asistencia" = "Q",
                                     "Artes, entretenimiento y recreación" = "R",
                                     "Organizaciones internacionales" = "U",
                                     "Otro" = "Z0_Nocla_CIIU"))
}

# Employment summaries ----------------------------------------------------

#' Create employment summary by date
#' @param data Data frame with fecha_1 column
create_employment_summary <- function(data) {
  data %>%
    group_by(fecha_1) %>%
    summarise(empleo = n(), .groups = "drop")
}

#' Create employment summary by date and sector
#' @param data Data frame with fecha_1 and sector columns
create_employment_summary_by_sector <- function(data) {
  data %>%
    group_by(fecha_1, sector) %>%
    summarise(empleo = n(), .groups = "drop") %>%
    group_by(fecha_1) %>%
    mutate(porcentaje_empleo = empleo / sum(empleo)) %>%
    ungroup()
}

# Plot saving -------------------------------------------------------------

#' Save plot with standard parameters
#' @param plot ggplot object
#' @param filename Character string for filename
#' @param width Numeric width (default: 12)
#' @param height Numeric height (default: 8)
#' @param dpi Numeric DPI (default: 1200)
save_plot_standard <- function(plot, filename, width = 12, height = 8, dpi = 1200) {
  ggsave(filename, 
         plot = plot,
         device = "png",
         width = width,
         height = height,
         dpi = dpi)
}

# Excel export ------------------------------------------------------------

#' Export data frame to Excel
#' @param data Data frame to export
#' @param filename Character string for filename
export_to_excel <- function(data, filename) {
  write.xlsx(data, filename)
}