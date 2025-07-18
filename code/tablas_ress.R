# Analisis empleo por ciiu

# Preliminares --------------------------------------------------------------------------------------------

# Cargar librerias - usar setup centralizado
source("code/setup.R")

# Análisis ------------------------------------------------------------------------------------------------

df_ress <- 
  ress_raw %>%  
  select(ano, mes, provincia, edad, sueldo , dias, empleo_total, ciiu4_1, empleo) %>% 
  filter(provincia %in% seq(1:24), sueldo>0) %>%
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

# agrupando la base por actividad productiva -----

df_ciiu <- 
  df_ress %>% 
  filter(ano == 2023, mes == 3) %>% 
  group_by(ciiu4_fct,ciiu4_1_fct) %>% 
  summarize(empleo = n())

# Exportar df_ciiu a Excel

write.xlsx(df_ciiu, "df_ciiu.xlsx")

# Base para la evolucion de la tasa de empleo formal por sector-----

df_empleo_1 <- 
  df_ress %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1) %>%
  summarise(empleo = n())

# Exportar df_empleo_1 a Excel

write.xlsx(df_empleo_1, "df_empleo_1.xlsx")

# agrupando la base por actividad productiva -----

df_ciiugr <- 
  df_ress %>%
  filter(ciiu4_fct %in% c('Administración pública y defensa; planes de seguridad social de afiliación obligatoria',
                            'Comercio al por mayor y al por menor; reparación de vehículos automotores y motocicletas',
                            'Industrias manufactureras',
                            'Agricultura, ganadería,  silvicultura y pesca',
                            'Actividades de servicios administrativos y de apoyo')) %>%
  group_by(ciiu4_1_fct, ciiu4_fct) %>%
  summarize(empleo = n()) %>%
  arrange(desc(empleo))

# Exportar df_ciiugr a Excel

write.xlsx(df_ciiugr, "df_ciiugr.xlsx")

# Base para la evolucion de la tasa de empleo formal por los cinco ciiu mas grandes-----

df_empleo_ciiu <- 
  df_ress %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  filter(ciiu4_fct %in% c('Administración pública y defensa; planes de seguridad social de afiliación obligatoria',
                          'Comercio al por mayor y al por menor; reparación de vehículos automotores y motocicletas',
                          'Industrias manufactureras',
                          'Agricultura, ganadería,  silvicultura y pesca',
                          'Actividades de servicios administrativos y de apoyo')) %>%
  group_by(fecha_1,ciiu4_1_fct, ciiu4_fct) %>%
  summarise(empleo = n())

# Exportar df_ciiugr a Excel

write.xlsx(df_empleo_ciiu, "df_empleo_ciiu.xlsx")

# Especificar los nombres de los archivos de salida y los data frames

nombres_archivos <- c("df_ciiu.xlsx", "df_empleo_1.xlsx", "df_ciiugr.xlsx", "df_empleo_ciiu.xlsx")
data_frames <- list(df_ciiu, df_empleo_1, df_ciiugr, df_empleo_ciiu)

# Crea un nuevo archivo Excel

wb <- createWorkbook()

# Escribir cada data frame en una hoja de Excel separada

for (i in 1:length(nombres_archivos)) {
  addWorksheet(wb, sheetName = nombres_archivos[i])
  write.xlsx(data_frames[[i]], wb, sheet = nombres_archivos[i])
}

# Guarda el archivo Excel
saveWorkbook(wb, "archivo_combinado.xlsx", overwrite = TRUE)


