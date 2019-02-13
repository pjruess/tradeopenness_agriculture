# Causal Effect of Trade Openness on Agricultural Variables
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries


# Load in functions from copies of Qian's scripts



# pop: population
# tmp: temperature
# 


### Stage 1

# Read in all data
ck <- read.csv('rawdata/pwt90.csv')[,c('countrycode','country','year','ck')] #capital stock at current PPPs (2011)
print(head(ck))
# Merge datasets on country and year


# Calculate bilateral trade from geographic variables and time-variant panel variables (constructed trade openness) 
# trade = (geographic variables and time variables, ie. WTO and RTA) (distance, population, dummies, etc.)


# Sum to calculate constructed trade openness


# Estimate real trade openness from constructed trade openness by regressing real trade openness on constructed trade openness
# estimate = constructed + control variables (pcp, tmp, pop, land) + country and time effects + error


# Use coefficients from estimate to calculate estimated trade openness



### Stage 2


# Regress agricultural variables on estimated real trade openness + control variables, country and time fixed effects, and error (same as stage 1)





### Functions


