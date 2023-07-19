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
  select(ano, mes, provincia, edad, sueldo , dias, empleo_total, ciiu4_1, empleo) %>% 
  filter(provincia %in% seq(1:24), sueldo>0, empleo_total %in% c(1,2)) %>%
  mutate(sector = factor(empleo_total, levels = c(1:2), labels = c("Privado", "Publico")),
         prov_fct = factor(provincia, levels = c(1:24), 
                           labels = c("Azuay","Bolívar","Cañar","Carchi","Cotopaxi","Chimborazo",
                                      "El Oro","Esmeraldas","Guayas","Imbabura","Loja","Los Ríos",
                                      "Manabí","Morona Santiago","Napo","Pastaza","Pichincha",
                                      "Tungurahua","Z.Chinchipe","Galápagos","Sucumbíos","Orellana",
                                      "Santo Domingo de los Tsáchilas","Santa Elena")),
         ciiu4_1_fct =factor(ciiu4_1, levels = c(1:22),
                             labels = c("Agricultura, ganadería,  silvicultura y pesca",
                                        "Explotación de minas y canteras",
                                        "Industrias manufactureras",
                                        "Suministro de electricidad, gas, vapor y aire acondicionado",
                                        "Distribución de agua; alcantarillado, gestión de desechos y actividades de saneamiento.",
                                        "Construcción",
                                        "Comercio al por mayor y al por menor; reparación de vehículos automotores y motocicletas",
                                        "Transporte y almacenamiento",
                                        "Actividades de alojamiento y de servicio de comidas",
                                        "Información y comunicación",
                                        "Actividades financieras y de seguros",
                                        "Actividades inmobiliarias",
                                        "Actividades profesionales, científicas y técnicas",
                                        "Actividades de servicios administrativos y de apoyo",
                                        "Administración pública y defensa; planes de seguridad social de afiliación obligatoria",
                                        "Enseñanza",
                                        "Actividades de atención de la salud humana y de asistencia social",
                                        "Artes, entretenimiento y recreación",
                                        "Otras actividades de servicios",
                                        "Actividades de los hogares como empleadores; actividades no diferenciadas de los hogares como productores de bienes y servicios para uso propio",
                                        "Actividades de organizaciones y órganos extraterritoriales",
                                        "CIIU no determinada")))

# agrupando la base de 2022 d-----

df_2022_p <- 
  df_raw %>% 
  filter(ano == 2022, sueldo >= 425, dias == 30, 
         prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí")) %>%
  group_by(prov_fct,sector) %>% 
  summarize(empleo = n())

df_2022_sp <- df_raw %>% 
  filter(ano == 2022, sueldo >= 425, dias == 30) %>%
  group_by(provincia, mes) %>%
  summarize(mediana_sueldo = median(sueldo, na.rm = TRUE)) %>%
  arrange(desc(mediana_sueldo))

df_2022_c <- 
  df_raw %>% 
  filter(ano == 2022) %>% 
  group_by(ciiu4_1) %>% 
  summarize(mediana_sueldo = median(sueldo, na.rm = TRUE), empleo = n()) %>% 
  arrange(desc(mediana_sueldo))

# agrupando la base de 2023 -----

df_2023_p <- 
  df_raw %>% 
  filter(ano == 2023, sueldo >= 450, dias == 30, 
         prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí")) %>%
  group_by(prov_fct,sector) %>% 
  summarize(empleo = n())

df_2023_c <- 
  df_raw %>% 
  filter(ano == 2023, sueldo >= 425, dias == 30) %>% 
  group_by(ciiu4_1) %>% 
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
mediana_2022_p

mediana_2022_p <- ggplot(df_2022_sp %>% filter(provincia %in% c(17,9,1,13,7)), 
                         aes(x = as.factor(mes),y = mediana_sueldo, color = as.factor(provincia), 
                             group = 5)) +
  geom_line()

empleo_2022_c <- ggplot(df_2022_c, aes(x = reorder(as.factor(ciiu4_1), -empleo), empleo, fill = empleo)) +
  geom_col(fill = "#647A8F",
           width = 0.8,
           color = "black")+
  labs(x = "actividad productiva", 
       y = "numero de empleos", 
       title = "Numero de empleos por actividad productiva 2022",
       subtitle = "Fuente : IESS"
  ) +
  geom_text(aes(label = empleo), color = "black", size = 2, vjust = -0.5) +
  theme_iess_2 +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

empleo_2022_p <- ggplot(df_2022_p,
                        aes(reorder(prov_fct, -empleo), empleo, 
                            fill = sector)) +
  geom_col(width = 0.7,
           position = "stack",
           color = "black") +
  scale_fill_manual(values =c("#647A8F","#FFAC8E")) +
  labs(x = "Provincia",
       y = "numero de empleos",
       title = "Numero de empleos por provincia y sector 2022",
       subtitle = "Fuente : IESS",
       fill = "Sector") +
  theme_iess_2

# visualizacion 2023 -----

empleo_2023_c
empleo_2023_p 

empleo_2023_c <- ggplot(df_2023_c %>% filter(ciiu4_1 != "Z0_Nocla_CIIU"),
                        aes(x = reorder(as.factor(ciiu4_1), -empleo), empleo, fill = empleo)) +
  geom_col(fill = "#647A8F",
           width = 0.8,
           color = "black")+
  labs(x = "actividad productiva", 
       y = "numero de empleos", 
       title = "Numero de empleos por actividad productiva hasta marzo 2023",
       subtitle = "Fuente : IESS"
  ) +
  geom_text(aes(label = empleo), color = "black", size = 2,  vjust = -0.5) +
  theme_iess_2 +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

empleo_2023_p <- ggplot(df_2023_p,
                        aes(reorder(prov_fct, -empleo), empleo, 
                            fill = sector)) +
  geom_col(width = 0.7,
           position = "stack",
           color = "black") +
  scale_fill_manual(values =c("#647A8F","#FFAC8E")) +
  labs(x = "Provincia",
       y = "numero de empleos",
       title = "Numero de empleos por provincia y sector hasta marzo 2023",
       subtitle = "Fuente : IESS",
       fill = "Sector") +
  theme_iess_2