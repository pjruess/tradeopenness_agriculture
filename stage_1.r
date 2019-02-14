# Causal Effect of Trade Openness on Agricultural Variables
# STAGE 1:
# Estimated trade openness
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries


# Load in functions from copies of Qian's scripts


# Read in all data
df <- read.csv('results/stage_0_results.csv') # all data AND calculated trade openness (from stage_0.r)

# Estimate real trade openness from constructed trade openness by regressing real trade openness on constructed trade openness
# estimate = constructed + control variables (pcp, tmp, pop, land) + country and time effects + error


# Use coefficients from estimate to calculate estimated trade openness


# Save as new .csv file
df.to_csv('results/stage_1_results.csv')
