# Install and load necessary packages
library(raster)
library(sf)
library("chirps")
library('readxl')
library('dplyr')

#import data
Wagga_Field_Sites <- read_excel("~/Cultral Burning of Grassy Woodland/Wagga/Wagga_Field_Sites.xlsx")
#change to date
Wagga_Field_Sites$Date_Burned<-as.Date(as.numeric(Wagga_Field_Sites$Date_Burned),origin = "1899-12-30")
#change col names
colnames(Wagga_Field_Sites)[4]<-'lat'
colnames(Wagga_Field_Sites)[5]<-'lon'


#keep only unique sites and add ID col
Wagga_Field_Sites_Unique<- Wagga_Field_Sites %>% 
  distinct(Site_Name, Burn_Treatment, .keep_all = T) %>%
  group_by(Site_Name, Burn_Treatment)%>%
  mutate(ID = cur_group_id())


#extract precipitation data

#put lat col before long
location <-as.data.frame(Wagga_Field_Sites_Unique[,c('lon','lat')])

###this step takes a while
Precip <- get_chirps(location, dates = c("2021-01-01", "2023-10-02"), server = "ClimateSERV")

#merge df's based on ID
colnames(Precip)[1]<-'ID'
Precip$ID<-as.character(Precip$ID)
Wagga_Field_Sites_Unique$ID<-as.character(Wagga_Field_Sites_Unique$ID)

Sites_Precip<-full_join(Wagga_Field_Sites_Unique,Precip, by=c('ID'))

#Tmax data from bom
Tmax<-read.csv('Tmax_Wagga/IDCJAC0010_072150_1800_Data.csv')

Tmax$date <- as.Date(with(Tmax, paste(Year, Month, Day,sep="-")), "%Y-%m-%d")

