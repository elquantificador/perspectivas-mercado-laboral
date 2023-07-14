# Repositorio REES
# librerias -----
library(dplyr)
library(plyr)
library(readxl)
library(ggplot2)
library(readr)
# Descargando la Data -----
source("code/ress_download.R")
View(ress_raw)
# Analisis -----
df_raw <- ress_raw %>%  transmute(ano, mes, provincia, edad, sueldo, dias, sector_afiliacion, tipo_empleador, tamano_empleo, ciiu4_1) %>% filter(provincia %in% seq(1:24), sueldo>0)
View(df_raw)
# agrupando la base de 2022 -----
df_2022 <- df_raw %>% filter(ano == 2022, sueldo >= 425, dias == 30) %>% group_by(provincia, ciiu4_1) %>% summarize(media_sueldo = mean(sueldo, na.rm = TRUE)) %>% arrange(desc(media_sueldo))

# agrupando la base de 2023 -----
df_2023 <- df_raw %>% filter(ano == 2023, sueldo >= 425, dias == 30) %>% group_by(provincia, ciiu4_1) %>% summarize(media_sueldo = mean(sueldo, na.rm = TRUE)) %>% arrange(desc(media_sueldo))
