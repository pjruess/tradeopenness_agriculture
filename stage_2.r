# Causal Effect of Trade Openness on Agricultural Variables
# STAGE 2:
# Final regression on variable of interest
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries


# Load in functions from copies of Qian's scripts


# Read in all data
df <- read.csv('results/stage_1_reg_2_results.csv') # all data AND calculated AND estimated trade openness (from stage_1_reg_2.r)

# Regress agricultural variables on estimated real trade openness + control variables, country and time fixed effects, and error (same as stage 1)


# Save as new .csv file
df.to_csv('results/stage_2_results.csv')
