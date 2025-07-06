# Repositorio REES

# Preliminares --------------------------------------------------------------------------------------------

# Cargar librerias

source("code/utils.R")

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
  mutate(sector = factor(empleo_total, levels = c(1:2), labels = c("Privado", "Público"))) %>%
  create_province_factors() %>%
  create_region_factors() %>%
  mutate(ciiu4_1_fct = as.factor(ciiu4_1)) 

# agrupando la base por actividad productiva -----

df_ciiu <- 
  df_raw %>% 
  filter(ano == 2023, mes == 3) %>% 
  create_ciiu_classification_grouped() %>%
  group_by(ciiu4_1_fct) %>% 
  summarize(mediana_sueldo = median(sueldo, na.rm = TRUE), empleo = n(), .groups = "drop") %>%
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
  create_date_column() %>%
  create_employment_summary_by_sector()

# Base para la evolucion de la tasa de empleo formal-----

df_empleo_1 <- 
  df_raw %>%
  create_date_column() %>%
  create_employment_summary()

# Base para la evolucion del salario mediano por sector-----

df_median <- 
  df_raw %>%
  create_date_column() %>%
  group_by(fecha_1, sector) %>%
  summarise(sueldo_mediano = median(sueldo, na.rm = TRUE), .groups = "drop")

# Base para la evolucion de la tasa de empleo formal-----

df_empleo <- 
  df_raw %>%
  create_date_column() %>%
  create_employment_summary()

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

save_plot_standard(graf_median, "figures/grafico_median.png")
save_plot_standard(graf_median_p, "figures/grafico_median_p.png")
save_plot_standard(graf_median_ciiu, "figures/grafico_ciiu.png")
save_plot_standard(graf_empleo, "figures/grafico_empleo_tot.png")

