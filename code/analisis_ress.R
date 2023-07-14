# Repositorio REES

# Preliminares --------------------------------------------------------------------------------------------

# Cargar librerias

library(dplyr)
library(readxl)
library(ggplot2)
library(readr)

# Cargando datos ------------------------------------------------------------------------------------------

source("code/ress_download.R")

# Guardar la base de datos en la computadora con save(ress_raw, file = 'data/base_iess.Rdata')
# Cargar la base de datos del archivo Rdata con load('data/base_iess.Rdata')

# Análisis ------------------------------------------------------------------------------------------------

df_raw <- 
  ress_raw %>%  
  select(ano, mes, provincia, edad, sueldo , dias, sector_afiliacion, tipo_empleador, tamano_empleo, ciiu4_1) %>% 
  filter(provincia %in% seq(1:24), sueldo>0)

# agrupando la base de 2022 -----

df_2022 <- 
  df_raw %>% 
  filter(ano == 2022, sueldo >= 425, dias == 30) %>% 
  group_by(provincia, ciiu4_1) %>% 
  summarize(media_sueldo = mean(sueldo, na.rm = TRUE)) %>% 
  arrange(desc(media_sueldo))

# agrupando la base de 2023 -----

df_2023 <- 
  df_raw %>% 
  filter(ano == 2023, sueldo >= 425, dias == 30) %>% 
  group_by(provincia, ciiu4_1) %>% 
  summarize(media_sueldo = mean(sueldo, na.rm = TRUE)) %>% 
  arrange(desc(media_sueldo))
