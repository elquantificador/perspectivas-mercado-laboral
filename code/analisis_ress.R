# Repositorio REES

# Preliminares --------------------------------------------------------------------------------------------

# Cargar librerias

library(dplyr)
library(readxl)
library(ggplot2)
library(readr)
library(forcats)

# Cargando datos ------------------------------------------------------------------------------------------

source("code/ress_download.R")

# Guardar la base de datos en la computadora con save(ress_raw, file = 'data/base_iess.Rdata')
# Cargar la base de datos del archivo Rdata con load('data/base_iess.Rdata')

# Análisis ------------------------------------------------------------------------------------------------

df_raw <- 
  ress_raw %>%  
  select(ano, mes, provincia, edad, sueldo , dias, empleo_total, ciiu4_1, empleo) %>% 
  filter(provincia %in% seq(1:24), sueldo>0, empleo_total %in% c(1,2)) %>%
  mutate(sector = factor(empleo_total, levels = c(1:2), labels = c("Privado", "Público")),
         prov_fct = factor(provincia, levels = c(1:24), 
                           labels = c("Azuay","Bolívar","Cañar","Carchi","Cotopaxi","Chimborazo",
                                      "El Oro","Esmeraldas","Guayas","Imbabura","Loja","Los Ríos",
                                      "Manabí","Morona Santiago","Napo","Pastaza","Pichincha",
                                      "Tungurahua","Z.Chinchipe","Galápagos","Sucumbíos","Orellana",
                                      "Santo Domingo de los Tsáchilas","Santa Elena")),
         ciiu4_1_fct = as.factor(ciiu4_1))

# agrupando la base de 2022 -----

df_2022_p <- 
  df_raw %>% 
  filter(ano == 2022, mes == 12, 
         prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí")) %>%
  group_by(prov_fct,sector) %>% 
  summarize(empleo = n())

df_2022_c <- 
  df_raw %>% 
  filter(ano == 2022, mes == 12) %>% 
  mutate(ciiu4_1_fct = fct_recode(ciiu4_1_fct,
                                  "Agropecuaria y pesca" = "A",
                                  "Explotación de minas y canteras" = "B",
                                  "Industrias manufactureras" = "C",
                                  "Suministro de energía" = "D",
                                  "Servicios públicos de saneamiento" = "E",
                                  "Construcción" = "F",
                                  "Comercio; reparación de vehículos motorizados" = "G",
                                  "Transporte y almacenamiento" = "H",
                                  "Hospitalidad y de servicio de comidas" = "I",
                                  "Información y comunicación" = "J",
                                  "Actividades financieras y de seguros" = "K",
                                  "Actividades inmobiliarias" = "L",
                                  "Actividades profesionales, científicas y técnicas" = "M",
                                  "Servicios administrativos y de apoyo" = "N",
                                  "Servicios públicos y de defensa" = "O",
                                  "Enseñanza" = "P",
                                  "Salud y asistencia" = "Q",
                                  "Artes, entretenimiento y recreación" = "R",
                                  "Otras actividades de servicios" = "S",
                                  "Organizaciones internacionales" = "U",
                                  "No determinada" = "Z0_Nocla_CIIU")) %>%
  group_by(ciiu4_1_fct) %>% 
  summarize(mediana_sueldo = median(sueldo, na.rm = TRUE), empleo = n()) %>% 
  arrange(desc(mediana_sueldo))

# agrupando la base de 2023 -----

df_2023_p <- 
  df_raw %>% 
  filter(ano == 2023, mes == 3, 
         prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí")) %>%
  group_by(prov_fct,sector) %>% 
  summarize(empleo = n())

df_2023_c <- 
  df_raw %>% 
  filter(ano == 2023, mes == 3) %>% 
  mutate(ciiu4_1_fct = fct_recode(ciiu4_1_fct,
                                  "Agropecuaria y pesca" = "A",
                                  "Explotación de minas y canteras" = "B",
                                  "Industrias manufactureras" = "C",
                                  "Suministro de energía" = "D",
                                  "Servicios públicos de saneamiento" = "E",
                                  "Construcción" = "F",
                                  "Comercio; reparación de vehículos motorizados" = "G",
                                  "Transporte y almacenamiento" = "H",
                                  "Hospitalidad y de servicio de comidas" = "I",
                                  "Información y comunicación" = "J",
                                  "Actividades financieras y de seguros" = "K",
                                  "Actividades inmobiliarias" = "L",
                                  "Actividades profesionales, científicas y técnicas" = "M",
                                  "Servicios administrativos y de apoyo" = "N",
                                  "Servicios públicos y de defensa" = "O",
                                  "Enseñanza" = "P",
                                  "Salud y asistencia" = "Q",
                                  "Artes, entretenimiento y recreación" = "R",
                                  "Otras actividades de servicios" = "S",
                                  "Organizaciones internacionales" = "U",
                                  "No determinada" = "Z0_Nocla_CIIU")) %>%
  group_by(ciiu4_1_fct) %>% 
  summarize(mediana_sueldo = median(sueldo, na.rm = TRUE), empleo = n()) %>% 
  arrange(desc(mediana_sueldo))

# theme -----

theme_iess_2 <-
  theme_classic() +
  theme(panel.grid = element_blank(),
        plot.caption = element_text(hjust = 0, face = 'italic'),
        legend.background = element_blank(),
        text =  element_text(color = 'black', size = 12))

# visualizacion 2022 -----
empleo_2022_c
empleo_2022_p

empleo_2022_c <- ggplot(df_2022_c, aes(reorder(ciiu4_1_fct, empleo), empleo)) +
  geom_bar(stat = "identity",
           fill = "#647A8F",
           width = 0.8,
           color = "black") +
  coord_flip() +
  labs(x = "Actividad productiva", 
       y = "Número de empleos", 
       title = "Número de empleos por actividad productiva 2022",
       subtitle = "Fuente : IESS") +
  geom_text(aes(label = empleo, y = empleo + 2), color = "black", 
            size = 3, position = position_dodge(0.9),
            hjust = -0.1) +
  theme(axis.text.y = element_text(hjust = 0)) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

empleo_2022_p <- ggplot(df_2022_p,
                        aes(reorder(prov_fct, -empleo), empleo, 
                            fill = sector)) +
  geom_col(width = 0.7,
           position = "dodge",
           color = "black") +
  scale_fill_manual(values =c("#647A8F","#FFAC8E")) +
  labs(x = "Provincia",
       y = "Número de empleos",
       title = "Número de empleos por provincia y sector 2022",
       subtitle = "Fuente : IESS",
       fill = "Sector") +
  geom_text(aes(label = empleo),
            position = position_dodge(0.72),
            color = 'black',
            vjust = -0.4,
            hjust = 0.4) +
  theme_iess_2 +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

# visualizacion 2023 -----

empleo_2023_c
empleo_2023_p 

empleo_2023_c <- ggplot(df_2023_c, aes(reorder(ciiu4_1_fct, empleo), empleo)) +
  geom_bar(stat = "identity",
           fill = "#647A8F",
           width = 0.8,
           color = "black") +
  coord_flip() +
  labs(x = "Actividad productiva", 
       y = "Número de empleos", 
       title = "Número de empleos por actividad productiva hasta marzo 2023",
       subtitle = "Fuente : IESS") +
  geom_text(aes(label = empleo, y = empleo + 2), color = "black", 
            size = 3, position = position_dodge(0.9),
            hjust = -0.1) +
  theme(axis.text.y = element_text(hjust = 0)) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

empleo_2023_p <- ggplot(df_2023_p,
                        aes(reorder(prov_fct, -empleo), empleo, 
                            fill = sector)) +
  geom_col(width = 0.7,
           position = "dodge",
           color = "black") +
  scale_fill_manual(values =c("#647A8F","#FFAC8E")) +
  labs(x = "Provincia",
       y = "Número de empleos",
       title = "Número de empleos por provincia y sector hasta marzo 2023",
       subtitle = "Fuente : IESS",
       fill = "Sector") +
  geom_text(aes(label = empleo),
            position = position_dodge(0.72),
            color = 'black',
            vjust = -0.4,
            hjust = 0.4) +
  theme_iess_2 +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
