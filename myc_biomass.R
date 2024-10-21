library(readxl)
library(tidyr)
library(dplyr)
library(ggplot2)

myc_biomass <- read_excel("raw_data/bag_data_wagga.xlsx", 
                             sheet = "myc_biomass")

myc_biomass%>%
  ggplot(aes(x=Plot_label,y=weight_mg))+
  geom_col(aes(fill=Amount_Beads_in_sample))+
  theme(
    axis.title.x = element_text(size = rel(1.5)),   
    axis.title.y = element_text(size = rel(1.5), angle = 90),
    axis.text.x = element_text(size = rel(2), angle = 45), 
    axis.text.y = element_text(size = rel(1.5)),
    legend.position = "bottom" )

    