library(rgdal)
library(hydroGOF)
library(ggplot2)
library(data.table)
df <- read.csv("/home/satyukt/Projects/1056/crop_yield/out/Merged_df_with_model_parameters.csv")[,-1:-2]
df <- df[!duplicated(df), ]
df_Rabi <- df[df$Season=="Rabi       ",]
df_Kharif <- df[df$Season=="Kharif     ",]
ndvi_kh <- as.data.frame(readOGR("/home/satyukt/Projects/1056/crop_yield/data/ndvi_kh_2001_2018/ndvi_kh_2001_2018.shp"))
ndvi_ra <- as.data.frame(readOGR("/home/satyukt/Projects/1056/crop_yield/data/ndvi_ra_2001_2018/ndvi_ra_2001_2018.shp"))

#model
years <- seq(2014,2018)

for (j in unique(df_Rabi$X))
  {  
  df_filtered <- df_Rabi[df_Rabi$X==j,]
  ndvi <- ndvi_ra[tolower(ndvi_ra$ST_NM)==tolower(df_filtered$State_Name),]
  ndvi <- ndvi[tolower(ndvi$DISTRICT)==tolower(df_filtered$District_Name),paste0("X",years,"_rabi")]
  slope <-na.omit(df_filtered[,8])
  interscept <-na.omit(df_filtered[,9])
  yield_predicted <- slope*as.numeric(ndvi) + interscept
  print(yield_predicted)
  for (i in seq(1,length(years)))
    {
    col <- i+9
    print(col)
    df_Rabi[df_Rabi$X==j,col]<-yield_predicted[i]
    }
  }
colnames(df_Rabi) <- c("X","State_Name","DISTRICT","Season","Crop","Average.area", "Correlation_coefficient","Intersecpt","Slope",paste0("Yield_predicted_",years))
write.csv(df_Rabi,"/home/satyukt/Projects/1056/crop_yield/out/Rabi_predicted.csv")

for (j in unique(df_Kharif$X))
{
  df_filtered <- df_Kharif[df_Kharif$X==j,]
  ndvi <- ndvi_ra[tolower(ndvi_ra$ST_NM)==tolower(df_filtered$State_Name),]
  ndvi <- ndvi[tolower(ndvi$DISTRICT)==tolower(df_filtered$District_Name),paste0("X",years,"_rabi")]
  slope <-na.omit(df_filtered[,8])
  interscept <-na.omit(df_filtered[,9])
  yield_predicted <- slope*as.numeric(ndvi) + interscept
  print(yield_predicted)
  for (i in seq(1,length(years)))
  {
    col <- i+9
    df_Kharif[df_Kharif$X==j,col]<-yield_predicted[i]
  }
}
colnames(df_Kharif) <- c("X","State_Name","DISTRICT","Season","Crop","Average.area", "Correlation_coefficient","Intersecpt","Slope",paste0("Yield_predicted_",years))
write.csv(df_Kharif,"/home/satyukt/Projects/1056/crop_yield/out/Kharif_predicted.csv")
df_new <- rbind.data.frame(df_Kharif,df_Rabi)
df_new <- df_new[order(df_new$X),]
write.csv(df_new,"/home/satyukt/Projects/1056/crop_yield/out/predicted.csv")

#seperate shapefiles
crop <- unique(df_new$Crop)
districts <- readOGR("/home/satyukt/Projects/1056/crop_yield/data/Districts/Districts.shp")
districts$DISTRICT =tolower(districts$DISTRICT)
for (m in crop[2:18])
  {
  df <- df_new[df_new$Crop==m,]
  dir.create(paste0("/home/satyukt/Projects/1056/crop_yield/out/shp/",m,"/"))
  for (kk in unique(df$Season))
    {
    df1 <- df[df$Season==kk,]
    df1$DISTRICT = tolower(df1$DISTRICT )
    foo <-merge(districts, df1, by='DISTRICT')
    shapefile(foo, paste0("/home/satyukt/Projects/1056/crop_yield/out/shp/",m,"/",m,"_",trimws(kk,"right"),".shp"),overwrite=TRUE)
    }
  }