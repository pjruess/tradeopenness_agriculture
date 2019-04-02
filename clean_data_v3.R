# Causal Effect of Trade Openness on Agricultural Variables
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries
library(XLConnect)
library(reshape2)
library(data.table)
library(dplyr)
library(gtools)
# Load in functions from copies of Qian's scripts

### Read in all data
#Read in Distance between countries
dist<-readxl::read_xls('rawdata/dist_cepii.xls')
dist<- dist[,c('iso_o','iso_d','contig','dist', 'distcap')]
#dist<-na.omit(dist)
print(head(dist))
write.csv(dist,file='cleandata/dist_cepii.csv',row.names = FALSE) #save cleaned version

#Read in Geometric Variables(Latitude, Longitude, area, dummy variables etc)
geo<-readxl::read_xls('rawdata/geo_cepii.xls')
geo<- geo[,c('country','iso3','area','dis_int', 'lat', 'lon','landlocked')]
#geo<-na.omit(geo)
print(head(geo))
write.csv(geo,file='cleandata/geo_cepii.csv',row.names = FALSE) #save cleaned version

# Read in Capital Stocks at Current PPPs (2011)
ck <- readxl::read_xlsx('rawdata/pwt90.xlsx',sheet=3)
ck <- ck[,c('countrycode','country','year','ck')]
#ck<-na.omit(ck)
print(head(ck))
write.csv(ck,file='cleandata/pwt90.csv',row.names = FALSE) #save cleaned version

# Read in Population data(in thousands)...
pop<- readxl::read_xlsx('rawdata/WPP2017_POP_F01_1_TOTAL_POPULATION_BOTH_SEXES_1.xlsx', sheet = 1)
colnames(pop)[2]<-"iso"
col_drop<- c('Index', 'Variant', 'Notes')
pop<-pop[,!names(pop) %in% col_drop]
pop <- melt(pop, id.vars= c('Region, subregion, country or area *','Country code'), variable.name='Year', value.name='Population')
write.csv(pop,file='cleandata/population_data.csv',row.names = FALSE) #save cleaned version
iso_code<-read.csv('rawdata/wikipedia-iso-country-codes.csv')#wikipedia iso codes list
pop<-merge(iso_code[,3:4],pop,by.x="Numeric.code",by.y="Country code")
#Read in Export and Import to Calculate Real Trade Openness (Import and Export data are % of GDP)
exp<-read.csv(file = 'rawdata/Exports_world_bank.csv')
names(exp)<-sub('X','',names(exp))
imp<-read.csv(file = 'rawdata/Imports_world_bank.csv')
names(imp)<-sub('X','',names(imp))
exp <- melt(exp, id.vars= c('CountryName','CountryCode'), variable.name='Year', value.name='Exports')
imp <- melt(imp, id.vars= c('CountryName','CountryCode'), variable.name='Year', value.name='Imports')
#exp<-na.omit(exp)
#imp<-na.omit(imp)
Real_TO<-merge(exp,imp,by=c("CountryName","CountryCode", 'Year'))
TO<-(Real_TO[,4]+Real_TO[,5])/100
Real_TO<-cbind(Real_TO,TO)
col_drop<- c('Exports', 'Imports')
Real_TO<-Real_TO[,!names(Real_TO) %in% col_drop]

#Read in temperature data
temp_path <- 'rawdata/Temperature'
temp_files <- list.files(path=temp_path,pattern= "*.csv")
temp_files <- lapply(temp_files, function(x) paste(temp_path,x,sep='/')) #list of file names
temp<-do.call(rbind, lapply(temp_files, function(x) read.csv(x, stringsAsFactors = FALSE)))
names(temp) <- sub('X.','',names(temp))
temp=aggregate(x=temp$tas,by=list(temp$Country,temp$Year),FUN='mean')
colnames(temp) <- c('Country_iso','Year','Temperature')
write.csv(temp,file='rawdata/temperature_data.csv',row.names = FALSE)

#Read in rainfall data
rf_path <- 'rawdata/Rainfall'
rf_files <- list.files(path=rf_path,pattern= "*.csv")
rf_files <- lapply(rf_files, function(x) paste(rf_path,x,sep='/')) #list of file names
rf<-do.call(rbind, lapply(rf_files, function(x) read.csv(x, stringsAsFactors = FALSE)))
names(rf) <- sub('X.','',names(rf))
rf=aggregate(x=rf$pr,by=list(rf$Country,rf$Year),FUN='mean')
colnames(rf) <- c('Country_iso','Year','Rainfall')
write.csv(rf,file='rawdata/rainfall_data.csv',row.names = FALSE)

#Read in wto data
wto<-read.csv(file = "rawdata/wto_new.csv")
yrs<-1995:2016
tmp <- as.data.frame(matrix(0,nrow=(nrow(wto)*length(yrs)),ncol=ncol(wto)-2))
index <- rep(seq_len(nrow(wto)), each = length(yrs))
con_repeated<-as.character(wto[,'Members'])
iso_repeated<-as.character(wto[,'ISO'])
colnames(tmp)<- c('Members','Year','ISO')
tmp['Members']<- con_repeated
tmp['ISO']<-iso_repeated
tmp<-tmp[order(tmp[,1]),]
rownames(tmp)<- NULL
tmp['Year']<-rep(yrs,nrow(wto))
wto1<- wto %>% select(Members, Year,ISO) %>%
  rename(Year1 = Year)
wto_com <- right_join(wto1, tmp, by = c("Members","ISO")) %>% 
  mutate(wto_o= ifelse(Year >= Year1, 1, 0))
wto_com<-wto_com[,-2]
#Read in wto data
rta<-read.csv(file = "rawdata/rta.csv")
### Merge datasets on country and year
df <- merge(ck,pop,by.x=c("countrycode","country","year"),by.y=c("Alpha.3.code","Region, subregion, country or area *","Year"))
df <- merge(df,geo,by.x=c("countrycode","country"),by.y=c("iso3","country"))
df <- merge(df,dist,by.x=c("countrycode"),by.y=c("iso_o"))
df <- merge(df,Real_TO,by.x=c("countrycode","country","year"),by.y=c("CountryCode",'CountryName','Year'))
df <- merge(df,temp,by.x=c("countrycode","year"),by.y=c("Country_iso",'Year'))
df <- merge(df,rf,by.x=c("countrycode","year"),by.y=c("Country_iso",'Year'))
df<-df[which(df$year==1995:2016),]
df<-merge(df,wto_com,by.x=c("countrycode","year"),by.y=c("ISO",'Year'))
df<-df[,-19]
df_sub<- df %>% select(iso_d, year) %>%
  rename(ISO=iso_d)
wto_sub_com <- right_join(wto1,df_sub, by = "ISO") %>%
  mutate(wto_d = ifelse(year>= Year1, 1, 0))
wto_sub_com<-wto_sub_com[,-c(1,4)]
df$wto_d<-wto_sub_com$wto_d
df<-merge(df,rta,by.x=c("countrycode","iso_d","year"),by.y=c("iso_o","iso_d",'Year'))
df<-merge(df,pop[,c("iso","Year","Population")],by.x=c("iso_d","year"),by.y=c("iso",'Year'))
df<-df[,-6]
colnames(df)[6]<-"pop_o"
colnames(df)[21]<-"pop_d"
colnames(df)[3]<-"iso_o"
df<-df[,-4]
# Save merged df as new .csv file
write.csv(df,file='results/input_data_clean.csv',row.names = FALSE)
