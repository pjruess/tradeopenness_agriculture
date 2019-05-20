# Causal Effect of Trade Openness on Agricultural Variables
# STAGE 1:
# Estimation of Real trade openness
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries
library(XLConnect)
library(reshape2)
library(data.table)
library(dplyr)
library(sqldf)
library(Matrix)
cat(rankMatrix(ver1_step1), "\n")
# Load in functions from copies of Qian's scripts
#EStimates constructed trade openness

# Read in data
df <- read.csv('results/input_data_clean_stage1.csv') # all input data (from collect_data.r script)
pa_formula1_1 = "TO ~ openness_hat+ log(AperP) + log(ckperP) + log(pop_o) + rainfall + temperature + factor(iso_o) + factor(year)"
ver1_step1<- lm(formula = pa_formula1_1, data = df)
hat_realopen <- as.data.frame(predict(ver1_step1, newdata = df))
colnames(hat_realopen)<-'hat_realopen'
df$hat_realopen<-hat_realopen$hat_realopen
write.csv(df,file='results/input_data_clean_stage2.csv',row.names = FALSE)
