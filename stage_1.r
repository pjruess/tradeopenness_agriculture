# Causal Effect of Trade Openness on Agricultural Variables
# STAGE 1:
# Estimation of Real trade openness
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries
library(sqldf)
library(AER)
library(MASS)
library(gtools)
library(stringr)
library(stargazer)
library(xtable)
library(reshape2)
cat(rankMatrix(ver1_step1), "\n")
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
# df <- read.csv('results/input_data_clean_stage1.csv') # all input data (from collect_data.r script)
# df = df[df$iso_o != "LBR" ,]
# df = df[df$iso_o != "LUX" ,]
# nutrients<-read.csv('cleandata/main_df2_wq_all.csv')
# nutrients<-nutrients[-c(3:5)]
# df<-merge(df,nutrients,by.x=c('iso_o','year'),by.y=c('ISO','Year'))
# #df<-na.omit(df)
# df<-df[which(df$N!=0),]
# pa_formula1_2 = "log(N) ~ TO + log(AperP) + log(ckperP) + log(pop_o) + rainfall + temperature + factor(iso_o) + factor(year) |. -TO + openness_hat"
# ver1_step2<- ivreg(formula = pa_formula1_2, data = df)
# result = data.frame(summary(ver1_step2)$coefficient)
# colnames(result) = c("coef", "sd", "t", "p")
# Read in Qian's data
# df <- read.csv('cleandata/main_df1_0621.csv')
# df = df[df$iso_o != "LBR" ,]
# df = df[df$iso_o != "LUX" ,]
# pa_formula1_0 = "log(biopenness) ~ factor(iso_o)+factor(iso_d) + factor(Year) + log(dist)*(log(pop_o) + log(pop_d)) + contig*(log(pop_o) + log(pop_d) + log(dist))"
# df<-df[which(df$biopenness!=0),]
# ver1_step0<- lm(formula = pa_formula1_0, data = df)
# hat_totalopen<-predopen(ver1_step0,df)
# df<-df[-c(2,5:11,13:18,20:21)]
# df<-df[!duplicated(df[1:2]),]
# df<-merge(df,hat_totalopen,by.x=c('iso_o','Year'),by.y=c('ISO','Year'))
# nutrients<-read.csv('cleandata/main_df2_wq_all.csv')
# control<-read.csv('cleandata/main_control_0708.csv')
# nutrients<-nutrients[-c(3:4)]
# df<-merge(df,nutrients,by.x=c('iso_o','Year'),by.y=c('ISO','Year'))
# df<-merge(df,control[,c(1:2,12:13)],by.x=c('iso_o','Year'),by.y=c('ISO','Year'))
# df<-na.omit(df)
# df$lperP<-df$area_o/df$pop_o
# df$ckperP<-df$ck_o/df$pop_o
# df2<-df[which(df$P!=0),]
# pa_formula1_2 = "log(P) ~ openness_real + log(lperP) + log(ckperP) + log(pop_o) + pr + tas + factor(iso_o) + factor(Year)|. -openness_real + openness_hat"
# ver1_step2<- ivreg(formula = pa_formula1_2, data = df2)
# result = data.frame(summary(ver1_step2)$coefficient)
# colnames(result) = c("coef", "sd", "t", "p")
# #pa_formula1_1 = "TO ~ openness_hat+ log(AperP) + log(ckperP) + log(pop_o) + rainfall + temperature + factor(iso_o) + factor(year)"
# ver1_step1<- lm(formula = pa_formula1_1, data = df)
# hat_realopen <- as.data.frame(predict(ver1_step1, newdata = df))
# colnames(hat_realopen)<-'hat_realopen'
# df$hat_realopen<-hat_realopen$hat_realopen
# write.csv(df,file='results/input_data_clean_stage2.csv',row.names = FALSE)
