####site locations####

library(tidyverse)
library(ggplot2)
library(forcats)
library(patchwork)
library(splitstackshape)
library(tidyr)
library(ggrepel)
library(maps)
library(oz)
library(ggmap)
setwd("\\\\ad.uws.edu.au/dfshare/HomesCMB$/90957135/My Documents/MER Fire")

Map_Info<-read.csv('MER Fire and Fungi Sites labelss.csv')






australia_map <- map_data("world", region = "Australia")
australian_states <- map_data("state")




p<-ggplot() +
  geom_polygon(data = australia_map, aes(x = long, y = lat, group = group), 
               fill = "lightgray", color = "black") +
  geom_point(data = Map_Info, aes(x = Long, y = Lat, color = Vegetation.type), size = 5) +
 # geom_text_repel(data = Site_Info, aes(x = Long, y = Lat, label = Vegetation.type), vjust = -0.5, hjust = 0.5, size = 4.5) +
  scale_color_discrete(name = "Vegetation Type") +
  coord_fixed(ratio = 1) + # Adjust the ratio for a better-looking map+
  theme_void()+
  theme(legend.text = element_text(size=12),legend.title = element_text(size=14))
p
plotly::ggplotly(p)

###

library(oz)

oz() +
  oz_regions("aus") +
  oz_points(data, lat = "lat", lon = "long", col = "Vegetation.type", size = 3) +
  oz_legend(col = "Vegetation.type", title = "Vegetation Type") +
  oz_title("Vegetation Type") +
  oz_theme_void() +
  oz_scalebar(position = "bottomright")












### plot distribution of trees globally using 'maps' library

# load library
library(maps)

# plot world map in graphics window
# can resize graphics window after plotting and map still looks good
map('world')

colnames(Site_Info)

# add points to map
with(Site_Info, points(Long, Lat, pch=16, col="red", cex=0.5))


### plot distribution of trees in Australia using 'oz' library

# load library
dev.off()
oz()

oz(section= 4, states = TRUE, coast = TRUE,
   ylim = NULL, add = FALSE, ar = 1, eps = 0.25)

# plot Australian map in graphics window


#add points to map
map <- get_stamenmap( bbox = c(left = 110, bottom = -40, right = 160, top = -10),
                      zoom = 4)
ggmap(map, extent = 'normal') + 
geom_point(data = Map_Info, aes(x = Long, y = Lat, group = as.factor(Veg_Class)), fill = "red")


theme_void() + 
  theme(plot.title = element_text(colour = "orange"), 
    panel.border = element_rect(colour = "grey", fill=NA, size=2)
    geom_point(data=Site_Info, aes(x=X0m_Long, y=X0m_Lat, colour= as.factor(Treatment)), cex=0.75)))
    
#NSW
nsw()

# this time colour points by 'species' and add legend
with(Site_Info, points(X0m_Long, X0m_Lat, pch=16 ,col= as.factor(Treatment), cex=0.75))
legend('topright', levels(as.factor(Site_Info$Treatment)), col=palette(), pch=16, cex=0.5)

library(ggmap)
map <- qmap('NSW', zoom = 7, maptype = 'hybrid')





### plot distribution of trees globally using 'plotly' (good for interactive viz)

# load library
library(plotly)

# plot tree locations on world map, colour points by AMT
p <- plot_geo(Site_Info, lat = ~X0m_Lat, lon = ~X0m_Long, color = ~Treatment) %>%
  layout(geo = list(scope = 'Aus'))
p

# add species onto markers
p <- p %>% add_markers(text = ~Treatment, hoverinfo = "text")
p

