# Repositorio REES

# Preliminares --------------------------------------------------------------------------------------------

# Cargar librerias - usar setup centralizado
source("code/setup.R")

# Cargando datos ------------------------------------------------------------------------------------------

# Ejecutar script de descarga, revisar codigo para mas información

source("code/download_reess.R")

# theme -----

theme_iess_2 <-
  theme_bw() +
  theme(panel.grid = element_blank(),
        plot.caption = element_text(hjust = 0, face = 'italic'),
        legend.background = element_rect(fill="white", 
                                         size=0.5, 
                                         linetype="solid", 
                                         colour ="black"),
        text =  element_text(color = 'black', 
                             size = 14),
        axis.text = element_text(size = 12,
                                 color = 'black'))

# captions -----

caption_median <- "Nota:  se usó la mediana del salario para la realización de este gráfico, 
al ser un mejor indicador que el salario promedio para observar los cambios en los salarios, 
a causa de que la mediana se ve menos afectada por valores atípicos o valores extremos que sí 
pueden distorsionar en mayor medida al promedio. La mediana del sueldo indica cual es el valor 
del salario que se encuentra en el medio de todo el conjunto de datos, de modo que la mitad de los 
trabajadores del sector formal ganan más que la mediana del sueldo, mientras que la otra mitad gana menos.
Fuente: Instituto Nacional de Estadística y Censos (INEC), www.ecuadorencifras.gob.ec"

caption_medianp <- "Nota: En la realización de este grafico se tomó en cuenta las cinco provincias mas
grandes del Ecuador y otras cinco provincias amazónicas para el análisis de las diferencias entre salarios medianos. 
Fuente: Instituto Nacional de Estadística y Censos (INEC), www.ecuadorencifras.gob.ec"

caption_ciiu <- "Nota: Para la  división de industrias vistas en este gráfico, se 
tomó en cuenta la Clasificación Industrial Internacional Uniforme (CIIU), que agrupa
una serie de actividades económicas, agrupándolas en categorías y asinando un código alfanumérico.
Fuente: Instituto Nacional de Estadística y Censos (INEC), www.ecuadorencifras.gob.ec"

caption_totempl <- "Nota: Fuente: Instituto Nacional de Estadística y Censos (INEC), www.ecuadorencifras.gob.ec"

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
  summarize(mediana_sueldo = median(sueldo, na.rm = TRUE),empleo = n()) %>%
  mutate(porcentaje_empleo = empleo/sum(empleo)*100) %>%
  arrange(desc(mediana_sueldo))

# Base del salario mediano por provincia -----

df_median_p <- 
  df_raw %>%
  filter(prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí",
                         "Morona Santiago","Napo","Orellana","Sucumbíos","Z.Chinchipe"),
         ano == 2023, mes == 3) %>%
  group_by(prov_fct) %>%
  summarise(median_p = median(sueldo, na.rm = TRUE)) %>%
  arrange(desc(median_p))

# Base para la evolucion de la tasa de empleo formal por sector-----

df_empleo <- 
  df_raw %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1, sector) %>%
  summarise(empleo = n()) %>%
  mutate(porcentaje_empleo = empleo/sum(empleo))

# Base para la evolucion de la tasa de empleo formal-----

df_empleo_1 <- 
  df_raw %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1) %>%
  summarise(empleo = n())

# Base para la evolucion del salario mediano por sector-----

df_median <- 
  df_raw %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1, sector) %>%
  summarise(sueldo_mediano = median(sueldo, na.rm = TRUE))

# Base para la evolucion de la tasa de empleo formal-----

df_empleo <- 
  df_raw %>%
  mutate(fecha_1= paste("01", paste(mes,ano, sep = '-')) %>% dmy()) %>%
  group_by(fecha_1) %>%
  summarise(empleo = n())

# Base % de personas empleadas por provincia-----

df_empl_p1 <- 
  df_raw %>%
  filter(ano == 2023, mes == 3) %>%
  group_by(prov_fct) %>%
  summarise(empleo = n()) %>%
  mutate(porcentaje_empleo = empleo/sum(empleo))

ggplot(df_empl_p1 %>% filter(prov_fct %in% c("Azuay","Pichincha","Guayas","El Oro","Manabí",
                                             "Morona Santiago","Napo","Orellana","Sucumbíos","Z.Chinchipe")),
       aes(reorder(prov_fct,porcentaje_empleo),porcentaje_empleo)) +
  geom_col(width = 0.8,
           fill = "#647A8F",
           position = "dodge",
           color = "black") +
  coord_flip() +
  geom_text(aes(label = scales::percent(porcentaje_empleo,accuracy = 0.1)), color = "black", 
            size = 2.4,
            hjust = -0.5) +
  theme(axis.text.y = element_text(hjust = 0)) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

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
       title = "Mediana del sueldo en el sector formal por industria",
       caption = str_wrap(caption_ciiu, 160)) +
  geom_text(aes(label = round(mediana_sueldo, digits = 2),
                y = mediana_sueldo + 2), color = "black", 
            size = 3, position = position_dodge(0.9),
            hjust = -0.1) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        plot.caption.position = 'plot',
        axis.text.y = element_text(hjust = 0))

# visualizacion del salario mediano-----

graf_median <- ggplot(df_median %>% filter(sector == "Privado"),
  aes(fecha_1, sueldo_mediano, color = sector)) +
  geom_line() +
  geom_point(color = 'black') +
  scale_x_date(date_breaks = '1 month', 
               date_labels = '%b-%y') +
  labs(x = "",
       y = "",
       title = "Mediana del sueldo en el sector privado-formal Ecuador 2022-2023",
       caption = str_wrap(caption_median, 160)) +
  scale_color_manual(values = c("#647A8F")) +
  theme_iess_2 +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, size = 12, color = 'black'),
        axis.text.y = element_text(size = 12, color = 'black'),
        legend.position = "none",
        plot.caption.position = 'plot')

# visualizacion del salario mediano por provincia-----

graf_median_p <- 
  ggplot(df_median_p, aes(reorder(prov_fct, median_p),median_p-450)) +
  geom_col(width = 0.8,
           fill = "#FFAC8E",
           position = "dodge",
           color = "black") +
  coord_flip() +
  labs(x = "", 
       y = "Mediana del sueldo", 
       title = "Mediana del sueldo en el sector formal por provincia marzo 2023",
       caption = str_wrap(caption_medianp, 160)) +
  geom_text(aes(label = round(median_p, digits = 2), y = median_p-448), color = "black", 
            size = 3, position = position_dodge(0.9),
            hjust = -0.1) +
  theme_iess_2 +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_text(hjust = 0, size = 12, color = 'black'),
        plot.caption.position = 'plot')

# visualizacion del numero de empleos formales-----

graf_empleo <- ggplot(df_empleo, aes(fecha_1, empleo)) +
  geom_line(colour = '#647A8F') +
  geom_point(color = 'black') +
  scale_x_date(date_breaks = '1 month', 
               date_labels = '%b-%y') +
  labs(x = "",
       y = "",
       title = "Evolución del número de empleos registrados en la seguridad social 2022-2023",
       caption = str_wrap(caption_totempl, 160)) +
  theme_iess_2 +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, color = 'black'),
        axis.text.y = element_text(size = 12, colour = 'black'),
        plot.caption.position = 'plot')

# guardando los graficos-----

ggsave("figures/grafico_median.png", 
       plot = graf_median,
       device = "png",
       width = 12,
       height = 8,
       dpi = 1200)

ggsave("figures/grafico_median_p.png", 
       plot = graf_median_p,
       device = "png",
       width = 12,
       height = 8,
       dpi = 1200)

ggsave("figures/grafico_ciiu.png", 
       plot = graf_median_ciiu,
       device = "png",
       width = 12,
       height = 8,
       dpi = 1200)

ggsave("figures/grafico_empleo_tot.png", 
       plot = graf_empleo,
       device = "png",
       width = 12,
       height = 8,
       dpi = 1200)

