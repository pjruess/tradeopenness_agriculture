# Causal Effect of Trade Openness on Agricultural Variables
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries
library(XLConnect)

# Load in functions from copies of Qian's scripts


### Read in all data

# Read in Capital Stocks at Current PPPs (2011)
ck <- readxl::read_xlsx('rawdata/pwt90.xlsx')
#ck <- # select correct sheet
ck <- ck[,c('countrycode','country','year','ck')]
print(head(ck))
write.csv(ck,file='cleandata/pwt90.csv') #save cleaned version


# Read in Population data...
pop<- readxl::read_xlsx('rawdata/WPP2017_POP_F01_1_TOTAL_POPULATION_BOTH_SEXES_1.xlsx', sheet = 1)
col_drop<- c('Index', 'Variant', 'Notes')
pop<-pop[,!names(pop) %in% col_drop]
write.csv(pop,file='cleandata/population_data.csv') #save cleaned version
### Merge datasets on country and year
df <- 

# Save merged df as new .csv file
write.csv('results/input_data_clean.csv')
