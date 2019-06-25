library(rgdal)
library(hydroGOF)
library(ggplot2)
Crop_name <- "Sunflower"

out_dir <- "/home/satyukt/Projects/1056/crop_yield/out/"
dir.create(paste0("/home/satyukt/Projects/1056/crop_yield/out/",Crop_name,"/plot/"))

df_Kharif <- read.csv(paste0(out_dir,Crop_name,"/03_Kharif_season_correlation_computed.csv"))
#index <- which(is.na(df_Kharif$Correlation_coefficient)==FALSE)
#df_Kharif <- df_Kharif[index,c(3,4,6,7,13,14,15,16)]
df_Rabi <- read.csv(paste0(out_dir,Crop_name,"/03_Rabi_season_correlation_computed.csv"))
observed_2014 <- df_Rabi[df_Rabi$Crop_Year==2014,"Yield"]
#index <- which(is.na(df_Rabi$Correlation_coefficient)==FALSE)
#df_Rabi <- df_Rabi[index,c(3,4,6,7,13,14,15,16)]
#NDVI
ndvi_kh <- as.data.frame(readOGR("/home/satyukt/Projects/1056/crop_yield/data/ndvi_kh_2001_2018/ndvi_kh_2001_2018.shp"))
ndvi_ra <- as.data.frame(readOGR("/home/satyukt/Projects/1056/crop_yield/data/ndvi_ra_2001_2018/ndvi_ra_2001_2018.shp"))
#model
m=1
for (i in unique(df_Rabi$District_Name))
  {
  print(i)
  ndvi <- ndvi_ra[tolower(ndvi_ra$DISTRICT)==tolower(i),"X2014_rabi"]
  row <- df_Rabi[tolower(df_Rabi$District_Name)==tolower(i),]
  row <- row[row$Crop_Year==2014,2]
  slope <-na.omit(df_Rabi[df_Rabi$District_Name==i,16])
  interscept <-na.omit(df_Rabi[df_Rabi$District_Name==i,15])
  if(length(slope)>0)
  {
    yield_predicted <- slope*ndvi + interscept
    print(yield_predicted)
    print( df_Rabi[df_Rabi$X==row,"Yield"])
    if(length(row>1))
    {
      for( k in seq(1,length(row)))
      {
        df_Rabi[df_Rabi$X==row,17] <- yield_predicted[k]
        df_Rabi[df_Rabi$X==row,18] <- df_Rabi[df_Rabi$X==row,"Yield"]
      }
    }
    else
    {
      df_Rabi[df_Rabi$X==row,17] <- yield_predicted
      df_Rabi[df_Rabi$X==row,18] <- df_Rabi[df_Rabi$X==row,"Yield"]
    }
  }
  m=m+1
  }
#df_Rabi <- cbind(df_Rabi,observed_2014)
colnames(df_Rabi) <- c("X.1","X","State_Name","District_Name","Crop_Year","Season","Crop","Area","Production","Yield","NDVI","Rainfall", "Average.area", "Correlation_coefficient","Intersecpt","Slope","Yield_predicted","Yield_observed")
write.csv(df_Rabi,paste0(out_dir,Crop_name,"/Rabi_predicted.csv"))
RMSE <- gof(df_Rabi$Yield_predicted,df_Rabi$Yield_observed)[4]
gg <- ggplot(data= df_Rabi, aes(x = Yield_predicted, y = Yield_observed))
gg <- gg + geom_point(color="blue")+  geom_smooth(method = "lm", se = FALSE,color="red")
gg <- gg +  annotate("text",x=1, y=5,label=paste0("RMSE:",RMSE))
gg <- gg + xlab("Yield_Predicted")+ ylab("Yield_Observed")
gg <- gg + ggtitle(paste0(Crop_name,"_2014_Rabi")) 
ggsave(paste0(out_dir,Crop_name,"/plot/2014_Rabi.png"),last_plot())
print(gg)
for (i in unique(df_Kharif$District_Name))
{
  print(i)
  ndvi <- ndvi_kh[tolower(ndvi_kh$DISTRIC)==tolower(i),"X2014_kh"]
  row <- df_Kharif[tolower(df_Kharif$District_Name)==tolower(i),]
  row <- row[row$Crop_Year==2014,2]
  slope <-na.omit(df_Kharif[df_Kharif$District_Name==i,16])
  interscept <-na.omit(df_Kharif[df_Kharif$District_Name==i,15])
  print(row)
    if(length(row)>0)
      {
      print("no!!!!!!!!")
      yield_predicted <- slope*ndvi + interscept
      print(yield_predicted)
      print( df_Kharif[df_Kharif$X==row,"Yield"])
      if(length(row>1))
      {
        print("yes!!!!!!!!")
      for( k in seq(1,length(row)))
        {
        df_Kharif[df_Kharif$X==row,17] <- yield_predicted[k]
        print(yield_predicted)
        df_Kharif[df_Kharif$X==row,18] <- df_Kharif[df_Kharif$X==row,"Yield"]
        }
      }
    else
      {
        print("else_yes!!!!!!!!")
        df_Kharif[df_Kharif$X==row,17] <- yield_predicted
        df_Kharif[df_Kharif$X==row,18] <- df_Kharif[df_Kharif$X==row,"Yield"]
      }
    }
  m=m+1
}
colnames(df_Kharif) <- c("X.1","X","State_Name","District_Name","Crop_Year","Season","Crop","Area","Production","Yield","NDVI","Rainfall", "Average.area", "Correlation_coefficient","Intersecpt","Slope","Yield_predicted","Yield_observed")
write.csv(df_Kharif,paste0(out_dir,Crop_name,"/Kharif_predicted.csv"))
RMSE <- gof(df_Kharif$Yield_predicted,df_Kharif$Yield_observed)[4]
gg <- ggplot(data= df_Kharif, aes(x = Yield_predicted, y = Yield_observed))
gg <- gg + geom_point(color="blue")+  geom_smooth(method = "lm", se = FALSE,color="red")
gg <- gg +  annotate("text",x=0.2, y=1,label=paste0("RMSE:",RMSE))
gg <- gg + xlab("Yield_Predicted")+ ylab("Yield_Observed")
gg <- gg + ggtitle(paste0(Crop_name,"_2014_Kharif")) 
ggsave(paste0(out_dir,Crop_name,"/plot/2014_Kharif.png"),last_plot())
print(gg)