library(geosphere)
require(dplyr)
require(tbart)
require(sp)

final=read.csv("D:/2022시계열스터디/데이터/필수데이터/최종보고서/final_col_english_noname.csv")
key=read.csv("D:/2022시계열스터디/데이터/필수데이터/최종보고서/final_col_english_divisiononly.csv")
key %>% head(2)
head(final)
as.data.frame(final)->final
pca=final %>% dplyr::select(evnum, building,  house, ave_traffic, tourist)
head(pca)            
round(cor(pca), 2)
target_pca <- prcomp(pca, scale = TRUE)
print(target_pca)
summary(target_pca)
screeplot(target_pca, main = "", col = "green", type = "lines", pch = 1, npcs = length(target_pca$sdev))
biplot(target_pca)

pmedian=function(num, ev.num, pop, building, ev.location, dtframe, dt_name){
  #num: number of parking lots aimed to construct new EV Charger station
  #ev.num: weight for number of EV cars
  #pop:weight for population density
  #building:weight for fliving facilities
  #ev.location:weight for availblility of other EV stations 
  #dtframe: data frame consists of 6 columns(=[latitude, longtitude, evnum, building, house, charger])
  #dt_name: name of parking lots for dtframe
  
  dtframe_idx=dtframe
  dtframe$weight=ev.location*dtframe$charger + pop*dtframe$house + ev.num*dtframe$evnum + building*dtframe$building
  coordinates(dtframe)<- ~lng+lat
  eucdist=euc.dists(dtframe, dtframe)
  len=dim(dtframe)[1]
  dist=matrix(0, len, len)
  for(i in 1:len){
    dist[i,]=dtframe$weight[i]*eucdist[i,]
  }
  allocations(dtframe, metric = dist, p=num, verbose = T)->result_t
  print('<P-median location result>')
  options(pillar.sigfig = 7)
  dt_name[unique(result_t$allocation)]
}
final.2=final %>% dplyr::select(lat, lng, house, evnum, charger, building)

pmedian(4, 1, 1, 1, 1, final.2, key$name)
