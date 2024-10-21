library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

bag_data <- read_excel("raw_data/bag_data_wagga.xlsx")%>%
  unite("Plot", Site_name, Burnt_Unburnt, Quadrat, sep = "", remove = FALSE)
dried_resins <- read_excel("raw_data/bag_data_wagga.xlsx", 
                             sheet = "Dry_bead_w")%>%
  rename(dry_w=Bead_weight)

#average weight of undamaged bag
initial_bag_w<-15.1257
dry_bag_w<- 7.09

bag_moisture<-bag_data%>%
  group_by(Plot)%>%
  summarise(field_w=sum(Bag_weight, na.rm = TRUE), #one bag was found out of ground is na, thus the na.rm
            Reps= n())%>% 
  left_join(dried_resins)%>%
  mutate(percent_water=((field_w-dry_w)/field_w)*100,
         intial_weight= initial_bag_w*Reps,
         theoretical_dry_w= dry_bag_w*Reps,
         bead_change= ((dry_w-theoretical_dry_w)/dry_w)*100)

#just making sure they are related
ggplot(bag_moisture, aes(x = dry_w, y = theoretical_dry_w)) +
  geom_point() +  # Add points
  geom_smooth(method = "lm", se = FALSE, color = "blue") +  # Add trendline
  labs(title = "Field Weight vs Dry Weight", 
       x = "Dry Weight", 
       y = "Theoretical dry weight") +
  theme_minimal()


# ID damaged bag
damaged_bags<-bag_data%>%
  #remove missing or damaged bags
  filter(str_detect(Damage, 'mod|extreme'),
         Bag_weight > 10)#remove samples with only one bag,locations over 10g because it seems like the weight where the bags arent damaged

undamaged_bags<-anti_join(bag_data,damaged_bags)%>%
  group_by(Plot)%>%
  summarise(field_w=sum(Bag_weight, na.rm = TRUE), #one bag was found out of ground is na, thus the na.rm
            Reps= n())

#mutate(resin_mass_est = (initial_bag_w * Res_total_Location) / mean_undam_resin_w,

