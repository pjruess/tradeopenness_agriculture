# Causal Effect of Trade Openness on Agricultural Variables
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries


# Load in functions from copies of Qian's scripts


# Read in all data
ck <- read.csv('rawdata/pwt90.csv')[,c('countrycode','country','year','ck')] #capital stock at current PPPs (2011)
print(head(ck))
# Merge datasets on country and year

# Save cleaned versions of raw data
ck.to_csv('cleandata/pwt90.csv')

# Save as new .csv file
df.to_csv('results/input_data_clean.csv')
