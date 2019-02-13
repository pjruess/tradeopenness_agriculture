# Causal Effect of Trade Openness on Agricultural Variables
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries


# Load in functions from copies of Qian's scripts


### Read in all data

# Read in Capital Stocks at Current PPPs (2011)
ck <- read.csv('rawdata/pwt90.xlsx')
ck <- # select correct sheet
ck <- ck[,c('countrycode','country','year','ck')]
print(head(ck))
ck.to_csv('cleandata/pwt90.csv') #save cleaned version


# Read in Population data...


### Merge datasets on country and year
df <- 

# Save merged df as new .csv file
df.to_csv('results/input_data_clean.csv')
