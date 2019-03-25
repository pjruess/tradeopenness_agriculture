# Causal Effect of Trade Openness on Agricultural Variables
# STAGE 0:
# Constructed trade openness
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries
library(XLConnect)
library(reshape2)
library(data.table)
library(dplyr)
# Load in functions from copies of Qian's scripts


# Read in data
df <- read.csv('results/input_data_clean.csv') # all input data (from collect_data.r script)
# Calculate bilateral trade from geographic variables and time-variant panel variables (constructed trade openness) 
#Read Bilateral trade data
bi_trade<-read.csv(file = 'rawdata/DOT_03-01-2019 14-24-34-36_timeSeries/DOT_03-01-2019 14-24-34-36_timeSeries.csv',stringsAsFactors = FALSE)
#bi_trade<-bi_trade[!(bi_trade$Indicator.Name=='Goods, Value of Trade Balance, US Dollars'),]
bi_trade<-subset(bi_trade, Indicator.Name!="Goods, Value of Trade Balance, US Dollars")
bi_trade<-bi_trade[,!names(bi_trade) %in% c('Attribute')]
colnames(bi_trade)[1]<-'Country.Name'
names(bi_trade)<-sub('X','',names(bi_trade))
bi_trade <- melt(bi_trade, id.vars= c('Country.Name', 'Country.Code' ,'Indicator.Name','Indicator.Code', 'Counterpart.Country.Name','Counterpart.Country.Code'), variable.name='Year', value.name='ExportsandImports')
bi_trade$ExportsandImports<-as.integer(bi_trade$ExportsandImports)
bi_trade<-bi_trade %>%
  group_by(Country.Name,Country.Code,Counterpart.Country.Name,Counterpart.Country.Code,Year) %>%
  summarize(bi_trade=sum(as.numeric(ExportsandImports)))
#bi_trade<-na.omit(bi_trade)
pa_formula1_1 = "log(biopenness) ~ factor(iso_o)+factor(iso_d) + factor(Year) + log(dist)*(log(pop_o) + log(pop_d)) + contig*(log(pop_o) + log(pop_d) + log(dist) + wto + rta)"
# trade = (geographic variables and time variables, ie. WTO and RTA) (distance, population, dummies, etc.)


# Sum to calculate constructed trade openness


# Save as new .csv file
df.to_csv('results/stage_0_results.csv')

# Qian process flow

# df1 has columns x, y, and z
# df 2 look like 
# panel_IV = function(){
	# this function does blah blah blah
