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

# Load in functions from copies of Qian's scripts
#EStimates constructed trade openness
predopen <- function(fo, y_bigeo){
  # y_bigeo = df1_curr
  hat_open <- as.data.frame(predict(fo, newdata = y_bigeo))
  pred <- cbind(y_bigeo[,1:3], hat_open)
  names(pred)[4] <- "log_hat_open"
  pred$hat_open <- exp(pred$log_hat_open)
  hat_totalopen <- sqldf("SELECT iso_o,Year, sum(hat_open)
                         FROM pred
                         GROUP BY iso_o, Year")
  names(hat_totalopen) <- c("ISO", "Year","openness_hat")
  #write.csv(hat_totalopen,"hat_totalopen.csv", row.names = F)
  return(hat_totalopen)
}

# Read in data
df <- read.csv('cleandata/input_data_clean_stage1.csv') # all input data (from collect_data.r script)
pa_formula1_1 = "log(TO) ~ openness_hat+ log(AperP) + log(ckperP) + log(pop_o) + rainfall + temperature + factor(iso_o) + factor(year)"
ver1_step1<- lm(formula = pa_formula1_1, data = df)
