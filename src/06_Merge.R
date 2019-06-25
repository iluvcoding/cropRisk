out_dir <- "/home/satyukt/Projects/1056/crop_yield/out/"
Crop_name_Kharif <- c("Sugarcane","Groundnut","Rice","Maize","Tobacco","Other Cereals & Millets","Rapeseed &Mustard","Potato","Gram","Onion","Soyabean","Cotton(lint)","Turmeric","Wheat","Arhar_Tur","Bajra","Jowar","Sunflower")
files_Kharif <-paste0(out_dir,Crop_name_Kharif,"/03_Kharif_season_correlation_computed.csv")
Crop_name_Rabi <- c("Groundnut","Rice","Maize","Tobacco","Rapeseed &Mustard","Potato","Gram","Onion","Soyabean","Cotton(lint)","Turmeric","Wheat","Arhar_Tur","Bajra","Jowar","Sunflower")

files_Rabi <-paste0(out_dir,Crop_name_Rabi,"/03_Rabi_season_correlation_computed.csv")

df_Kharif <-c()
for (i in files_Kharif)
{
  df <-read.csv(i)
  df <- df[which(is.na(df$Average.area) == FALSE),c(-5,-8,-9,-10,-11,-12)]
  df_Kharif <- rbind.data.frame(df_Kharif,df)
}
for (i in files_Rabi)
{
  df <-read.csv(i)
  df <- df[which(is.na(df$Average.area) == FALSE),c(-5,-8,-9,-10,-11,-12)]
  df_Kharif <- rbind.data.frame(df_Kharif,df)
}

df_Kharif_new <- df_Kharif[order(df_Kharif$X),]
write.csv(df_Kharif_new,paste0(out_dir,"Merged_df_with_model_parameters.csv"))