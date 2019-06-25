#Crop yield prediction
apy <- as.data.frame(read.csv("/home/satyukt/Projects/1056/crop_yield/data/apy.csv"))
State <- unique(apy[,1])
#State <- c("Maharashtra","Madhya Pradesh","Karnataka","Gujarat")
#Crop <- unique(apy[,5])
apy$Yield <- apy$Production/apy$Area
foo <- c()
foo_crop <- c()
major_crop <- c()
crop_major <- c()
for (ii in State)
{
  print(ii)
  df1 <- apy[apy$State_Name==ii,]
  districts <- unique(df1$District_Name)
    for (i in districts)
      {
        df2 <- df1[df1$District_Name==i,]
        Crop <- unique(df1$Crop)
        for (jj in Crop)
        {
          df_new <- df2[df2$Crop==jj,]
          season <- unique(df_new$Season)
          foo_crop <- rbind.data.frame(foo_crop, cbind.data.frame(ii,jj,i,sum(df_new$Area)))
          area <- mean(df_new$Area)
          for (j in season)
          {
            df_new1 <- df_new[df_new$Season==j,]
            print(area)
            foo <- rbind.data.frame(foo,cbind.data.frame(ii,jj,i,j,area))
          }
        }
    }
}
colnames(foo) <- c("State", "Crop", "District","Season","Avg_area")
write.csv(foo,"/home/satyukt/Projects/1056/crop_yield/out/Avg_area.csv")
Districts <- unique(foo_crop$i)
for (m in Districts)
  {
  df3 <-foo_crop[foo_crop$i==m,] 
  df3$Rank <-rank(df3$`sum(df_new$Area)`)
  crop_major <- rbind.data.frame(crop_major,cbind.data.frame(df3[which.max(df3$Rank),1],m,df3[which.max(df3$Rank),2]))
  major_crop <- rbind.data.frame(major_crop,df3)
}
colnames(crop_major)<- c("State","District","Major_crop")
colnames(major_crop)<- c("State","Crop","District","Sum_Area","Rank")

write.csv(major_crop,paste0("/home/satyukt/Projects/1056/crop_yield/out/crops_sorted_by_area_per_district_all_states.csv"))
write.csv(crop_major,paste0("/home/satyukt/Projects/1056/crop_yield/out/major_crop_per_district_all_states.csv"))

#find_major crops
#df_major <- foo[foo$Crop=