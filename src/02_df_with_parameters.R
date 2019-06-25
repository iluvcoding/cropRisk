library(rgdal)
apy <- as.data.frame(read.csv("/home/satyukt/Projects/1056/crop_yield/data/apy.csv"))
foo_kh <- c()
foo_ra <- c()
foo_final_kh <- c()
foo_final_ra <- c()
years <- seq(2001,2014,1)
Crop_name <- "Rice"
dir.create(paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/"))

#major_crop <- read.csv("/home/satyukt/Projects/1056/crop_yield/out/major_crop_per_district_all_states.csv")

ndvi_kh <- as.data.frame(readOGR("/home/satyukt/Projects/1056/crop_yield/data/ndvi_kh_2001_2018/ndvi_kh_2001_2018.shp"))
ndvi_ra <- as.data.frame(readOGR("/home/satyukt/Projects/1056/crop_yield/data/ndvi_ra_2001_2018/ndvi_ra_2001_2018.shp"))
rain_kh <- as.data.frame(readOGR("/home/satyukt/Projects/1056/crop_yield/data/rain_kh_2001_2017/rain_ka_ra_2001_2017.shp"))
rain_ra <- as.data.frame(readOGR("/home/satyukt/Projects/1056/crop_yield/data/rain_ra_2001_2017/rain_ra_2001_2017.shp"))
apy <- apy[apy$Crop == Crop_name,]

for (i in unique(apy$District))
{
  df <- apy[apy$District_Name == i,]
  #crop <- as.character(major_crop[major_crop$District==i,4])
  #df <- df[df$Crop==crop,]
  df$yield <- (df$Production/df$Area)
  season <- unique(df$Season)
  df_kh <- df[df$Season == 'Kharif     ',]
  df_ra <- df[df$Season == 'Rabi       ',]
  foo_kh <- rbind (foo_kh,df_kh)
  foo_ra <- rbind(foo_ra,df_ra)
}

index_ndvi_kh <- na.omit(match(tolower(foo_kh$District_Name),tolower(ndvi_kh$DISTRIC)))
index_ndvi_ra <- na.omit(match(tolower(foo_ra$District_Name),tolower(ndvi_ra$DISTRICT)))
index_rain_kh <- na.omit(match(tolower(foo_kh$District_Name),tolower(rain_kh$DISTRIC)))
index_rain_ra <- na.omit(match(tolower(foo_ra$District_Name),tolower(rain_ra$DISTRICT)))

#index_apy <- na.omit(match(major_crop$District,apy$District_Name))

ndvi_kh <-unique(ndvi_kh[index_ndvi_kh,])
ndvi_ra <- unique(ndvi_ra[index_ndvi_ra,])
rain_kh <-unique(rain_kh[index_rain_kh,])
rain_ra <- unique(rain_ra[index_rain_ra,])

#df_new <- merge.data.frame(foo_kh,ndvi_kh,by=intersect(foo_kh$District_Name,ndvi_kh$DISTRIC))

for (ii in seq(1,nrow(ndvi_kh)))
  {
  print (ii)
  dis <- tolower(as.character(ndvi_kh$DISTRIC[ii]))
  foo <- foo_kh[tolower(as.character(foo_kh$District_Name))==dis,]
  rows <- na.omit(match(years, foo$Crop_Year))
  cols <- unlist(strsplit(c(as.character(colnames(ndvi_kh)[6:19])),"_"))
  cols <- substring(cols[seq(1,length(cols),2)],2)
  cols <- na.omit(match(cols, foo$Crop_Year))
  if (length(rows)>0)
    {
  foo[rows,9] <- as.numeric(ndvi_kh[ii,seq(6,(5+length(cols)))])
  foo_final_kh <- rbind(foo_final_kh,foo)
    }
  }


for (ii in seq(1,nrow(ndvi_ra)))
{
  dis <- tolower(as.character(ndvi_ra$DISTRIC[ii]))
  foo <- foo_ra[tolower(as.character(foo_ra$District_Name))==dis,]
  rows <- na.omit(match(years, foo$Crop_Year))
  if (length(rows)>0)
    {
  cols <- unlist(strsplit(c(as.character(colnames(ndvi_ra)[6:19])),"_"))
  cols <- substring(cols[seq(1,length(cols),2)],2)
  cols <- na.omit(match(cols, foo$Crop_Year))
  foo[rows,9] <- as.numeric(ndvi_ra[ii,seq(6,(5+length(cols)))])
  foo_final_ra <- rbind(foo_final_ra,foo)
    }
}
#colnames(foo_final_kh) <-c("State_Name","District_Name","Crop_Year","Season","Crop","Area","Production","Yield","NDVI")
#colnames(foo_final_ra) <-c("State_Name","District_Name","Crop_Year","Season","Crop","Area","Production","Yield","NDVI")

#rain
for (jj in seq(1,nrow(rain_kh)))
{
  dis <- tolower(as.character(na.omit(rain_kh$DISTRIC[jj])))
  print(dis)
  foo <- foo_kh[tolower(as.character(foo_kh$District_Name))==dis,]
  rows <- na.omit(match(years, foo$Crop_Year))
  if (length(rows)>0)
    cols <- unlist(strsplit(c(as.character(colnames(rain_kh)[6:19])),"_"))
    cols <- substring(cols[seq(1,length(cols),2)],2)
    cols <- na.omit(match(cols, as.character(foo$Crop_Year)))
    {
  foo_final_kh[rows,10] <- as.numeric(rain_kh[jj,seq(6,(5+length(cols)))])
    }
}

for (kk in seq(1,nrow(rain_ra)))
  {
  dis <- tolower(as.character(na.omit(rain_ra$DISTRICT[kk])))
  print(dis)
  foo <- foo_ra[tolower(as.character(na.omit(foo_ra$District_Name)))==dis,]
  rows <- na.omit(match(years, foo$Crop_Year))
  cols <- unlist(strsplit(c(as.character(colnames(rain_ra)[6:19])),"_"))
  cols <- substring(cols[seq(1,length(cols),2)],2)
  cols <- na.omit(match(cols, foo$Crop_Year))
  if (length(rows)>0)
    {
    foo_final_ra[rows,10] <- as.numeric(rain_ra[kk,seq(6,(5+length(cols)))])
    print(as.numeric(rain_ra[kk,seq(6,(5+length(cols)))]))
    foo_final_ra <- rbind(foo_final_ra,foo)
    }
  }

colnames(foo_final_kh) <-c("State_Name","District_Name","Crop_Year","Season","Crop","Area","Production","Yield","NDVI","Rainfall")
colnames(foo_final_ra) <-c("State_Name","District_Name","Crop_Year","Season","Crop","Area","Production","Yield","NDVI","Rainfall")
write.csv(foo_final_kh,paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/02_Kharif_season.csv"))
write.csv(foo_final_ra,paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/02_Rabi.csv"))

#delete "na"s manually