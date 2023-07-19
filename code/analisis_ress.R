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
  mutate(sector = factor(empleo_total, levels = c(1:2), labels = c("Privado", "Público")),
         prov_fct = factor(provincia, levels = c(1:24), 
                           labels = c("Azuay","Bolívar","Cañar","Carchi","Cotopaxi","Chimborazo",
                                      "El Oro","Esmeraldas","Guayas","Imbabura","Loja","Los Ríos",
                                      "Manabí","Morona Santiago","Napo","Pastaza","Pichincha",
                                      "Tungurahua","Z.Chinchipe","Galápagos","Sucumbíos","Orellana",
                                      "Santo Domingo de los Tsáchilas","Santa Elena")))

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
  group_by(ciiu4_1) %>% 
  summarize(mediana_sueldo = median(sueldo, na.rm = TRUE), empleo = n()) %>% 
  arrange(desc(mediana_sueldo))

# agrupando la base de 2023 -----

df_2023_p <- 
  df_raw %>% 
  filter(ano == 2023, mes == 12, 
         prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí")) %>%
  group_by(prov_fct,sector) %>% 
  summarize(empleo = n())

df_2023_c <- 
  df_raw %>% 
  filter(ano == 2023, mes == 12) %>% 
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

empleo_2022_c <- ggplot(df_2022_c, aes(x = reorder(as.factor(ciiu4_1), -empleo), empleo, fill = empleo)) +
  geom_col(fill = "#647A8F",
           width = 0.8,
           color = "black")+
  labs(x = "Actividad productiva", 
       y = "Número de empleos", 
       title = "Número de empleos por actividad productiva 2022",
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
       y = "Número de empleos",
       title = "Número de empleos por provincia y sector 2022",
       subtitle = "Fuente : IESS",
       fill = "Sector") +
  geom_text(aes(label = empleo),
            color = 'white',
            vjust = 1.5) +
  theme_iess_2

# visualizacion 2023 -----

empleo_2023_c
empleo_2023_p 

empleo_2023_c <- ggplot(df_2023_c %>% filter(ciiu4_1 != "Z0_Nocla_CIIU"),
                        aes(x = reorder(as.factor(ciiu4_1), -empleo), empleo, fill = empleo)) +
  geom_col(fill = "#647A8F",
           width = 0.8,
           color = "black")+
  labs(x = "Actividad productiva", 
       y = "Número de empleos", 
       title = "Número de empleos por actividad productiva hasta marzo 2023",
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
       y = "Número de empleos",
       title = "Número de empleos por provincia y sector hasta marzo 2023",
       subtitle = "Fuente : IESS",
       fill = "Sector") +
  theme_iess_2