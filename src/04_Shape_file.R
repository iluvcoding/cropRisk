library(rgdal)
library(raster)
library(data.table)
Crop_name<- "Soyabean"
dir.create(paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/shp/"))
districts <- readOGR("/home/satyukt/Projects/1056/crop_yield/data/Districts/Districts.shp")
Rabi <- as.data.frame(read.csv(paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/03_Whole_year_correlation_computed.csv")))
colnames(Rabi)[4] <- "DISTRICT"
#Rabi <- read.csv ("/home/satyukt/Projects/1056/crop_yield/out/Rabi_season_groundnut_correlation_computed.csv")
index <- which(is.na(Rabi$Correlation_coefficient)==FALSE)
Rabi <- Rabi[index,c(3,4,6,7,13,14,15,16)]
Rabi$DISTRICT = tolower(Rabi$DISTRICT)
districts$DISTRICT =tolower(districts$DISTRICT)
districts_rabi<- merge(districts, Rabi, by='DISTRICT')
shapefile(districts_rabi, paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/shp/04_Districts_Whole_year.shp"),overwrite=TRUE)
hist(Rabi$Slope)
Kharif <- as.data.frame(read.csv(paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/03_Kharif_season_correlation_computed.csv")))
colnames(Kharif)[4] <- "DISTRICT"
#Rabi <- read.csv ("/home/satyukt/Projects/1056/crop_yield/out/Rabi_season_groundnut_correlation_computed.csv")
index <- which(is.na(Kharif$Correlation_coefficient)==FALSE)
Kharif <- Kharif[index,c(3,4,6,7,13,14,15,16)]
Kharif$DISTRICT = tolower(Kharif$DISTRICT)
districts$DISTRICT =tolower(districts$DISTRICT)
districts_kharif<- merge(districts, Kharif, by='DISTRICT')
shapefile(districts_kharif, paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/shp/04_Districts_kharif.shp"),overwrite=TRUE)
hist(Kharif$Slope)