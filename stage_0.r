<<<<<<< HEAD
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
# trade = (geographic variables and time variables, ie. WTO and RTA) (distance, population, dummies, etc.)


# Sum to calculate constructed trade openness


# Save as new .csv file
df.to_csv('results/stage_0_results.csv')
=======
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
