# Repositorio REES

# Preliminares --------------------------------------------------------------------------------------------

# Cargar librerias

library(dplyr)
library(readxl)
library(ggplot2)
library(readr)
library(forcats)
library(lubridate)
library(tidyverse)
library(patchwork)

# Cargando datos ------------------------------------------------------------------------------------------

source("code/ress_download.R")

# Guardar la base de datos en la computadora con save(ress_raw, file = 'data/base_iess.RData')
# Si no se ejecuta el codigo por si solo ejecutar parte por parte siguiendo instrucciones dentro del script ress_download.R
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
         ciiu4_1_fct = as.factor(ciiu4_1),
         region = fct_collapse(prov_fct,
                               "Sierra" = c("Azuay","Bolívar","Carchi","Cañar","Chimborazo",
                                            "Cotopaxi","Imbabura","Loja","Pichincha","Tungurahua"),
                               "Costa" = c("El Oro","Esmeraldas","Guayas","Los Ríos","Manabí",
                                           "Santa Elena","Santo Domingo de los Tsáchilas"),
                               "Región Amazónica" = c("Morona Santiago","Napo","Orellana",
                                                      "Pastaza","Sucumbíos","Z.Chinchipe"),
                               "Islas Galápagos" = "Galápagos")) 

# agrupando la base por actividad productiva -----

df_ciiu <- 
  df_raw %>% 
  filter(ano == 2023, mes == 3) %>% 
  mutate(ciiu4_1_fct = fct_collapse(ciiu4_1_fct,
                                    "Agropecuaria y pesca" = "A",
                                    "Industria minero-energética" = c("B","D"),
                                    "Industrias manufactureras" = "C",
                                    "Servicios publicos/defensa/saneamiento" = c("E","O"),
                                    "Sector inmobiliario y construcción" = c("F","L"),
                                    "Comercio; reparación de vehículos motorizados" = "G",
                                    "Transporte y almacenamiento" = "H",
                                    "Hospitalidad y de servicio de comidas" = "I",
                                    "Información y comunicación" = "J",
                                    "Actividades financieras y de seguros" = "K",
                                    "Servicios profesionales y técnicos" = "M",
                                    "Servicios administrativos y otros" =c("N","S"),
                                    "Enseñanza" = "P",
                                    "Salud y asistencia" = "Q",
                                    "Artes, entretenimiento y recreación" = "R",
                                    "Organizaciones internacionales" = "U",
                                    "Otro" = "Z0_Nocla_CIIU")) %>%
  group_by(ciiu4_1_fct) %>% 
  summarize(mediana_sueldo = median(sueldo, na.rm = TRUE)) %>% 
  arrange(desc(mediana_sueldo))

# Base del salario mediano por provincia -----

df_median_p <- 
  df_raw %>%
  filter(prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí"),
         ano == 2023, mes == 3) %>%
  group_by(prov_fct) %>%
  summarise(median_p = median(sueldo, na.rm = TRUE)) %>%
  arrange(desc(median_p))

# Base para la evolucion de la tasa de empleo formal por sector-----

df_empleo <- 
  df_raw %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1, sector) %>%
  summarise(empleo = n())

# Base para la evolucion de la tasa de empleo formal-----

df_empleo_1 <- 
  df_raw %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1) %>%
  summarise(empleo = n())

# Base para la evolucion del salario mediano-----

df_median <- 
  df_raw %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1) %>%
  summarise(sueldo_mediano = median(sueldo, na.rm = TRUE))

# theme -----

theme_iess_2 <-
  theme_classic() +
  theme(panel.grid = element_blank(),
        plot.caption = element_text(hjust = 0, face = 'italic'),
        legend.background = element_blank(),
        text =  element_text(color = 'black', size = 12))

# visualizacion ciiu -----

graf_median_ciiu <- 
  ggplot(df_ciiu %>% filter(ciiu4_1_fct != "Otro" ), 
         aes(reorder(ciiu4_1_fct, mediana_sueldo), mediana_sueldo)) +
  geom_bar(stat = "identity",
           fill = "#647A8F",
           width = 0.8,
           color = "black") +
  coord_flip() +
  labs(x = "", 
       y = "Mediana del sueldo", 
       title = "Mediana del sueldo en el sector formal por actividad productiva",
       subtitle = "Fuente: Instituto de Seguridad Social (IESS)") +
  geom_text(aes(label = round(mediana_sueldo, digits = 2),
                y = mediana_sueldo + 2), color = "black", 
            size = 3, position = position_dodge(0.9),
            hjust = -0.1) +
  theme(axis.text.y = element_text(hjust = 0)) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

# visualizacion del numero de empleos formales por sector-----

graf_empleo <- ggplot(df_empleo, aes(fecha_1, empleo, color = sector)) +
  geom_line() +
  geom_point(color = 'black') +
  scale_x_date(date_breaks = '3 months', 
               date_labels = '%b-%y') +
  labs(x = "",
       y = "",
       title = "Por sector",
       color = "Sector") +
  scale_color_manual(values = c("#647A8F","#FFAC8E")) +
  theme_iess_2 +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5),
        axis.text.y = element_text(size = 12)) 

# visualizacion del numero de empleos formales-----

graf_empleo_1 <- ggplot(df_empleo_1, aes(fecha_1, empleo)) +
  geom_line(colour = '#647A8F') +
  geom_point(color = 'black') +
  scale_x_date(date_breaks = '3 months', 
               date_labels = '%b-%y') +
  labs(x = "",
       y = "",
       title = "Total") +
  theme_iess_2 +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5),
        axis.text.y = element_text(size = 12))

# visualizacion del salario mediano-----

graf_median <- ggplot(df_median, aes(fecha_1, sueldo_mediano)) +
  geom_line(colour = '#647A8F') +
  geom_point(color = 'black') +
  scale_x_date(date_breaks = '3 months', 
               date_labels = '%b-%y') +
  labs(x = "",
       y = "",
       title = "Mediana del sueldo en el sector formal Ecuador 2022-2023",
       subtitle = "Fuente: Instituto de Seguridad Social (IESS)") +
  theme_iess_2 +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5),
        axis.text.y = element_text(size = 12))

# visualizacion del salario mediano por provincia-----

graf_median_p <- ggplot(df_median_p, aes(reorder(prov_fct, median_p),median_p)) +
  geom_col(width = 0.8,
           fill = "#FFAC8E",
           position = "dodge",
           color = "black") +
  coord_flip() +
  labs(x = "", 
       y = "Mediana del sueldo", 
       title = "Mediana del sueldo en el sector formal por provincia",
       subtitle = "Fuente: Instituto de Seguridad Social (IESS)") +
  geom_text(aes(label = round(median_p, digits = 2), y = median_p + 2), color = "black", 
            size = 3, position = position_dodge(0.9),
            hjust = -0.1) +
  theme(axis.text.y = element_text(hjust = 0)) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())


# guardando los graficos-----
 
graf_empleo_t <- graf_empleo + 
  graf_empleo_1 +
  plot_layout(ncol = 2) + 
  plot_annotation(title = "Evolución del número de empleos formales",
                  subtitle = "Fuente: Instituto de Seguridad Social (IESS)") +
  theme(plot.title = element_text(hjust = 0.5, size = 20)) +
theme(axis.title.x = element_text(hjust=-0.12))

ggsave("figures/grafico_empleo_t.png", plot = graf_empleo_t,
       device = "png",
       width = 13,
       height = 7,
       dpi =1200)

ggsave("figures/grafico_ciiu.png", plot = graf_median_ciiu,
       device = "png",
       width = 14,
       height = 7,
       dpi =1200)

ggsave("figures/grafico_median.png", plot = graf_median,
       device = "png",
       width = 13,
       height = 7,
       dpi =1200)

ggsave("figures/grafico_median_p.png", plot = graf_median_p,
       device = "png",
       width = 13,
       height = 7,
       dpi =1200)