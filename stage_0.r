# Causal Effect of Trade Openness on Agricultural Variables
# STAGE 0:
# Constructed trade openness
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries
library(XLConnect)
library(reshape2)
# Load in functions from copies of Qian's scripts


# Read in data
df <- read.csv('results/input_data_clean.csv') # all input data (from collect_data.r script)
# Calculate bilateral trade from geographic variables and time-variant panel variables (constructed trade openness) 
#Read Bilateral trade data
bi_trade<-read.csv(file = 'rawdata/DOT_03-01-2019 14-24-34-36_timeSeries/DOT_03-01-2019 14-24-34-36_timeSeries.csv')
bi_trade<-bi_trade[,!names(bi_trade) %in% c('Indicator.Name', 'Indicator.Code','Attribute')]
colnames(bi_trade)[1]<-'Country.Name'
names(bi_trade)<-sub('X','',names(bi_trade))
bi_trade <- melt(bi_trade, id.vars= c('Country.Name', 'Country.Code' , 'Counterpart.Country.Name','Counterpart.Country.Code'), variable.name='Year', value.name='Exports and Imports')
bi_trade<-na.omit(bi_trade)
bi_trade<-aggregate(x=bi_trade$`Exports and Imports`,by=list(bi_trade$Country.Name,bi_trade$Counterpart.Country.Code,bi_trade$Year),FUN='sum')
pa_formula1_1 = "log(biopenness) ~ factor(iso_o)+factor(iso_d) + factor(Year) + log(dist)*(log(pop_o) + log(pop_d)) + contig*(log(pop_o) + log(pop_d) + log(dist))"
# trade = (geographic variables and time variables, ie. WTO and RTA) (distance, population, dummies, etc.)


# Sum to calculate constructed trade openness


# Save as new .csv file
df.to_csv('results/stage_0_results.csv')
# Causal Effect of Trade Openness on Agricultural Variables
# STAGE 0:
# Constructed trade openness
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries


# Load in functions from copies of Qian's scripts


# Read in data
df <- read.csv('results/input_data_clean.csv') # all input data (from collect_data.r script)

# Calculate bilateral trade from geographic variables and time-variant panel variables (constructed trade openness) 
# trade = (geographic variables and time variables, ie. WTO and RTA) (distance, population, dummies, etc.)


# Sum to calculate constructed trade openness


# Save as new .csv file
df.to_csv('results/stage_0_results.csv')


# Qian process flow

# df1 has columns x, y, and z
# df 2 look like 
# panel_IV = function(){
	# this function does blah blah blah
<<<<<<< HEAD
<<<<<<< HEAD
# }
>>>>>>> 7773752f202247569d3eaa3f9445431522652e6f
=======
# }
>>>>>>> 7d69881876ddd8b69f3d3d0056960b31744d36e2
=======
# }
>>>>>>> 7d69881876ddd8b69f3d3d0056960b31744d36e2
