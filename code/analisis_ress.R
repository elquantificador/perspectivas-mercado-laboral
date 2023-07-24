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
         ciiu4_1_fct = as.factor(ciiu4_1),
         region = fct_collapse(prov_fct,
                               "Sierra" = c("Azuay","Bolívar","Carchi","Cañar","Chimborazo",
                                            "Cotopaxi","Imbabura","Loja","Pichincha","Tungurahua"),
                               "Costa" = c("El Oro","Esmeraldas","Guayas","Los Ríos","Manabí",
                                           "Santa Elena","Santo Domingo de los Tsáchilas"),
                               "Región Amazónica" = c("Morona Santiago","Napo","Orellana",
                                                      "Pastaza","Sucumbíos","Z.Chinchipe"),
                               "Islas Galápagos" = "Galápagos")) 

# agrupando la base de 2022 -----

df_2022_p <- 
  df_raw %>% 
  filter(ano == 2022, mes == 12, 
         prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí")) %>%
  group_by(prov_fct,sector) %>% 
  summarize(empleo = n(),
            tot_empleo = sum(empleo))

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

df_2022_r <- 
  df_raw %>%
  filter(ano == 2022) %>%
  group_by(region) %>%
  summarize(sueldo_promedio = mean(sueldo, na.rm = TRUE)) %>% 
  arrange(desc(sueldo_promedio))

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

df_2023_r <- 
  df_raw %>%
  filter(ano == 2023) %>%
  group_by(region) %>%
  summarize(sueldo_promedio = mean(sueldo, na.rm = TRUE)) %>% 
  arrange(desc(sueldo_promedio))

# agrupando la base para la evolucion del salario mediano -----

df_median <- 
  df_raw %>% 
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1, region) %>%
  summarise(sueldo_mediano = median(sueldo, na.rm = TRUE))

# Base para la evolucion de la tasa de empleo formal-----

df_empleo <- 
  df_raw %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1) %>%
  summarise(empleo = n())

# Base para la evolucion del salario promedio-----

df_avgw <- 
  df_raw %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1) %>%
  summarise(sueldo_promedio = mean(sueldo, na.rm = TRUE))

# Base del salario promedio por ciiu-----

df_avgw_c <- 
  df_raw %>% 
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
  summarize(avg_sueldo = mean(sueldo, na.rm = TRUE)) %>% 
  arrange(desc(avg_sueldo))

# Base del salario promedio por provincia y sector-----

df_avgw_p <- 
  df_raw %>%
  filter(prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí")) %>%
  group_by(prov_fct,sector) %>%
  summarise(avgw_p = mean(sueldo, na.rm = TRUE)) %>%
  arrange(desc(avgw_p))
  
# Base del salario promedio por provincia -----

df_avgw_1 <- 
  df_raw %>%
  filter(prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí")) %>%
  group_by(prov_fct) %>%
  summarise(avgw_p = mean(sueldo, na.rm = TRUE)) %>%
  arrange(desc(avgw_p))

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
sueldo_region_22

empleo_2022_c <- ggplot(df_2022_c, aes(reorder(ciiu4_1_fct, empleo), empleo)) +
  geom_bar(stat = "identity",
           fill = "#647A8F",
           width = 0.8,
           color = "black") +
  coord_flip() +
  labs(x = "", 
       y = "Número de empleos", 
       title = "Número de empleos formales por actividad productiva 2022",
       subtitle = "Fuente : IESS") +
  geom_text(aes(label = empleo, y = empleo + 2), color = "black", 
            size = 3, position = position_dodge(0.9),
            hjust = -0.1) +
  theme(axis.text.y = element_text(hjust = 0)) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

empleo_2022_p <- ggplot(df_2022_p,
                        aes(reorder(prov_fct, -tot_empleo), tot_empleo, 
                            fill = sector)) +
  geom_col(width = 0.7,
           position = "dodge",
           color = "black") +
  scale_fill_manual(values =c("#647A8F","#FFAC8E")) +
  labs(x = "",
       y = "Número de empleos",
       title = "2022",
       fill = "Sector") +
  geom_text(aes(label = empleo),
            position = position_dodge(0.72),
            color = 'black',
            vjust = -0.4,
            hjust = 0.4) +
  theme_iess_2 +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

sueldo_region_22 <- ggplot(df_2022_r, aes(reorder(region, sueldo_promedio),
                                       sueldo_promedio)) +
  geom_col(color = "black",
           width = 0.8,
           fill = "#647A8F") +
  labs(x = "",
       y = "Sueldo promedio",
       title = "2022") +
  geom_text(aes(label = round(sueldo_promedio, digits = 2)),
            position = position_dodge(1),
            vjust = -0.4) +
  theme_iess_2 +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
  theme(axis.title.x = element_blank()) +
  theme(axis.ticks.x = element_blank())

# visualizacion 2023 -----

empleo_2023_c
empleo_2023_p
sueldo_region_23

empleo_2023_c <- ggplot(df_2023_c, aes(reorder(ciiu4_1_fct, empleo), empleo)) +
  geom_bar(stat = "identity",
           fill = "#647A8F",
           width = 0.8,
           color = "black") +
  coord_flip() +
  labs(x = "", 
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
  labs(x = "",
       y = "Número de empleos",
       title = "2023",
       fill = "Sector") +
  geom_text(aes(label = empleo),
            position = position_dodge(0.72),
            color = 'black',
            vjust = -0.4,
            hjust = 0.4) +
  theme_iess_2 +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

sueldo_region_23 <- ggplot(df_2023_r, aes(reorder(region, sueldo_promedio),
                                       sueldo_promedio)) +
  geom_col(color = "black",
           width = 0.8,
           fill = "#FFAC8E") +
  labs(x = "",
       y = "Sueldo promedio",
       title = "2023") +
  geom_text(aes(label = round(sueldo_promedio, digits = 2)),
            position = position_dodge(1),
            vjust = -0.4) +
  theme_iess_2 +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
  theme(axis.title.x = element_blank()) +
  theme(axis.ticks.x = element_blank())

# visualizacion sueldo mediano -----
sueldo_mediano_p

sueldo_mediano_p <- df_median %>%
  filter(fecha_1 %>%  between(as.Date('2022-01-01'), as.Date('2023-03-01'))) %>%
  ggplot(aes(fecha_1, sueldo_mediano, color = region)) +
  geom_point() +
  geom_line() +
  scale_x_date(date_breaks = '3 months', 
               date_labels = '%b-%y')+
  labs(x = "",
       y = "",
       title = "Sueldo mediano en el sector formal Ecuador 2022-2023",
       subtitle = "Fuente : IESS",
       color = "Región") +
  scale_color_manual(values = c("#8B0000", "#FFAC8E", "#808000", "#647A8F")) +
  theme_iess_2 +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5),
        axis.text.y = element_text(size = 12))

# visualizacion del numero de empleos formales-----
graf_empleo

graf_empleo <- ggplot(df_empleo, aes(fecha_1, empleo)) +
  geom_line(colour = '#647A8F') +
  geom_point(color = 'black') +
  scale_x_date(date_breaks = '3 months', 
               date_labels = '%b-%y') +
  labs(x = "",
       y = "",
       title = "Número de empleos sector formal Ecuador 2022-2023",
       subtitle = "Fuente : IESS") +
  theme_iess_2 +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5),
        axis.text.y = element_text(size = 12))

# visualizacion del salario promedio-----
graf_avgw

graf_avgw <- ggplot(df_avgw, aes(fecha_1, sueldo_promedio)) +
  geom_line(colour = '#FFAC8E') +
  geom_point(color = 'black') +
  scale_x_date(date_breaks = '3 months', 
               date_labels = '%b-%y') +
  labs(x = "",
       y = "",
       title = "Sueldo promedio en el sector formal Ecuador 2022-2023",
       subtitle = "Fuente : IESS") +
  theme_iess_2 +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5),
        axis.text.y = element_text(size = 12))

# visualizacion del salario promedio por ciiu-----
avgw_c

avgw_c <- ggplot(df_avgw_c, aes(reorder(ciiu4_1_fct, avg_sueldo), avg_sueldo)) +
  geom_bar(stat = "identity",
           fill = "#647A8F",
           width = 0.8,
           color = "black") +
  coord_flip() +
  labs(x = "", 
       y = "Sueldo promedio", 
       title = "Sueldo promedio en el sector formal por actividad productiva 2022-2023",
       subtitle = "Fuente : IESS") +
  geom_text(aes(label = round(avg_sueldo, digits = 2), y = avg_sueldo + 2), color = "black", 
            size = 3, position = position_dodge(0.9),
            hjust = -0.1) +
  theme(axis.text.y = element_text(hjust = 0)) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

# visualizacion del salario promedio por provincia-----
avgw_p
avgw_p_1

avgw_p <- ggplot(df_avgw_p, aes(reorder(prov_fct, avgw_p),avgw_p,fill = sector)) +
  geom_col(width = 0.7,
           position = "dodge",
           color = "black") +
  scale_fill_manual(values =c("#647A8F","#FFAC8E")) +
  coord_flip() +
  labs(x = "", 
       y = "Sueldo promedio", 
       title = "Sueldo promedio por provincia y sector 2022-2023",
       subtitle = "Fuente : IESS",
       fill = "Sector") +
  geom_text(aes(label = round(avgw_p, digits = 2), y = avgw_p + 2), color = "black", 
            size = 3, position = position_dodge(0.9),
            hjust = -0.1) +
  theme(axis.text.y = element_text(hjust = 0)) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

avgw_p_1 <- ggplot(df_avgw_1, aes(reorder(prov_fct, avgw_p),avgw_p,fill = avgw_p)) +
  geom_col(width = 0.7,
           color = "black",
           fill = "#FFAC8E") +
  coord_flip() +
  labs(x = "", 
       y = "Sueldo promedio", 
       title = "Sueldo promedio por provincia 2022-2023",
       subtitle = "Fuente : IESS") +
  geom_text(aes(label = round(avgw_p, digits = 2), y = avgw_p + 2), color = "black", 
            size = 3, position = position_dodge(0.9),
            hjust = -0.1) +
  theme(axis.text.y = element_text(hjust = 0)) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

# guardando los graficos-----
 
graf_empleo_p <- 
  empleo_2022_p + 
  empleo_2023_p +
  plot_layout(ncol = 2) + 
  plot_annotation(title = "Número de empleos formales por provincia y sector 2022-2023",
                  subtitle = "Fuente: IESS") +
  theme = theme(plot.title = element_text(hjust = 0.5, size = 20)) +
  labs( x = "Provincia") + 
  theme(axis.title.x = element_text(hjust=-0.10))

ggsave("figures/grafico_empleo_p.png", plot = graf_empleo_p,
       device = "png",
       width = 13,
       height = 7,
       dpi =1200)

graf_sueldo_r <- sueldo_region_22 + sueldo_region_23 +
  plot_layout(ncol = 2) +
  plot_annotation(title = "Sueldo promedio de los trabajadores en el sector formal 2022-2023",
                  subtitle = "Fuente: IESS") +
  theme = theme(plot.title = element_text(hjust = 0.5, size = 20)) +
  labs( x = "Región") + 
  theme(axis.title.x = element_text(hjust=-0.10))

ggsave("figures/grafico_sueldo_r.png", plot = graf_sueldo_r,
       device = "png",
       width = 13,
       height = 7,
       dpi =1200)

ggsave("figures/grafico_empleo_c.png", plot = empleo_2022_c,
       device = "png",
       width = 13,
       height = 7,
       dpi =1200)

ggsave("figures/grafico_medianw_p.png", plot = sueldo_mediano_p,
       device = "png",
       width = 13,
       height = 7,
       dpi =900)

ggsave("figures/grafico_empleos_ec.png", plot = graf_empleo,
       device = "png",
       width = 13,
       height = 7,
       dpi =900)

ggsave("figures/grafico_avg_w.png", plot = graf_avgw,
       device = "png",
       width = 13,
       height = 7,
       dpi =900)

ggsave("figures/grafico_avgw_c.png", plot = avgw_c,
       device = "png",
       width = 14,
       height = 7,
       dpi =1200)

ggsave("figures/grafico_avgw_ps.png", plot = avgw_p,
       device = "png",
       width = 14,
       height = 7,
       dpi =1200)

ggsave("figures/grafico_avgw_p.png", plot = avgw_p_1,
       device = "png",
       width = 14,
       height = 7,
       dpi =1200)
