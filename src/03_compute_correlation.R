library(hydroGOF)
library(Hmisc)
Crop_name <-"Rice"
df_kh <- read.csv(paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/02_Kharif_season.csv"))
df_ra <- read.csv(paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/02_Whole_year.csv"))
for (i in unique(df_kh$District_Name))
{
  print (i)
  foo <- df_kh[df_kh$District_Name==i,]
  rowd <- match(i,df_kh$District_Name)
  Area <- mean(foo$Area,na.rm=TRUE)
  if (Area<500){  df_kh[rowd,12] <- NA
  df_kh[rowd,13]<- NA
  df_kh[rowd,14]<- NA
  df_kh[rowd,15]<- NA}
  else{  
  df_kh[rowd,12] <- Area
  if (length(foo$Yield)==length(foo$NDVI) & sd(foo$Yield,na.rm=TRUE) >0 & is.na(sd(foo$Yield,na.rm = TRUE))==FALSE & sd(foo$NDVI,na.rm = TRUE) > 0 & is.na(sd(foo$NDVI,na.rm = TRUE))==FALSE){
  df_kh[rowd,13]<- gof(foo$Yield,foo$NDVI)[16]}
  else{df_kh[rowd,13]<- NA}
  x <- lm(formula  =  foo$Yield  ~  foo$NDVI)
  df_kh[rowd,14]<- x$coefficients[1]
  df_kh[rowd,15]<- x$coefficients[2]
  #plot(foo$Yield,foo$NDVI)
  }
}
colnames(df_kh)<- c("X","State_Name","District_Name","Crop_Year","Season","Crop","Area","Production","Yield","NDVI","Rainfall","Average area", "Correlation_coefficient", "Intersecpt","Slope")
write.csv(df_kh,paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/03_Kharif_season_correlation_computed.csv"))

for (i in unique(df_ra$District_Name))
{
  print(i)
  foo <- df_ra[na.omit(df_ra$District_Name)==i,]
  rowd <- match(i,df_ra$District_Name)
  Area <-    mean(foo$Area)
  if (Area<500){df_ra[rowd,12] <- NA
  df_ra[rowd,13]<- NA
  df_ra[rowd,14]<- NA
  df_ra[rowd,15]<- NA}
   else{
     df_ra[rowd,12]<- Area
  if (length(foo$Yield)==length(foo$NDVI) & sd(foo$Yield,na.rm=TRUE) >0 & is.na(sd(foo$Yield,na.rm = TRUE))==FALSE & sd(foo$NDVI,na.rm = TRUE) > 0 & is.na(sd(foo$NDVI,na.rm = TRUE))==FALSE)
  {
  df_ra[rowd,13]<- gof(foo$Yield,foo$NDVI)[16]}
  #df_kh[rowd,14]<- gof(foo$Yield,foo$Rainfall)[16]
  x <- lm(formula  =  foo$Yield  ~  foo$NDVI)
  df_ra[rowd,14]<- x$coefficients[1]
  df_ra[rowd,15]<- x$coefficients[2]
  #lm(foo$Yield,foo$NDVI)
  #plot(foo$NDVI,foo$Yield)
  }
  #foo_ra <- df_ra[df_ra$District_Name==i]
  }
colnames(df_ra)<- c("X","State_Name","District_Name","Crop_Year","Season","Crop","Area","Production","Yield","NDVI","Rainfall","Average area", "Correlation_coefficient", "Intersecpt","Slope")
write.csv(df_ra,paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/03_Whole_year_correlation_computed.csv"))