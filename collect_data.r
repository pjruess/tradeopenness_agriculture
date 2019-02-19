# Causal Effect of Trade Openness on Agricultural Variables
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries
library(XLConnect)
library(reshape2)
# Load in functions from copies of Qian's scripts

setwd("C:/Users/pandi/OneDrive/tradeopenness_agriculture")
### Read in all data
#Read in Distance between countries
dist<-readxl::read_xls('rawdata/dist_cepii.xls')
dist<- dist[,c('iso_o','iso_d','contig','dist', 'distcap')]
dist<-na.omit(dist)
print(head(dist))
write.csv(dist,file='cleandata/dist_cepii.csv',row.names = FALSE) #save cleaned version
#Read in Geometric Variables(Latitude, Longitude, area, dummy variables etc)
geo<-readxl::read_xls('rawdata/geo_cepii.xls')
geo<- geo[,c('country','iso3','area','dis_int', 'lat', 'lon','landlocked')]
geo<-na.omit(geo)
print(head(geo))
write.csv(geo,file='cleandata/geo_cepii.csv',row.names = FALSE) #save cleaned version
# Read in Capital Stocks at Current PPPs (2011)
ck <- readxl::read_xlsx('rawdata/pwt90.xlsx',sheet=3)
#ck <- # select correct sheet
ck <- ck[,c('countrycode','country','year','ck')]
ck<-na.omit(ck)
print(head(ck))
write.csv(ck,file='cleandata/pwt90.csv',row.names = FALSE) #save cleaned version


# Read in Population data(in thousands)...
pop<- readxl::read_xlsx('rawdata/WPP2017_POP_F01_1_TOTAL_POPULATION_BOTH_SEXES_1.xlsx', sheet = 1)
col_drop<- c('Index', 'Variant', 'Notes')
pop<-pop[,!names(pop) %in% col_drop]
pop <- melt(pop, id.vars= c('Region, subregion, country or area *','Country code'), variable.name='Year', value.name='Population')
write.csv(pop,file='cleandata/population_data.csv',row.names = FALSE) #save cleaned version
iso_code<-read.csv('rawdata/wikipedia-iso-country-codes.csv')#wikipedia iso codes list
pop<-merge(iso_code[,3:4],pop,by.x="Numeric.code",by.y="Country code")
### Merge datasets on country and year
df <- merge(ck,pop,by.x=c("countrycode","country","year"),by.y=c("Alpha.3.code","Region, subregion, country or area *","Year"))

# Save merged df as new .csv file
write.csv('results/input_data_clean.csv')
