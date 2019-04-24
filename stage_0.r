# Causal Effect of Trade Openness on Agricultural Variables
# STAGE 0:
# Constructed trade openness
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries
library(XLConnect)
library(reshape2)
library(data.table)
library(dplyr)
# Load in functions from copies of Qian's scripts


# Read in data
df <- read.csv('results/input_data_clean.csv') # all input data (from collect_data.r script)
# Calculate bilateral trade from geographic variables and time-variant panel variables (constructed trade openness) 
#Read Bilateral trade data
bi_trade<-read.csv(file = 'rawdata/DOT_03-01-2019 14-24-34-36_timeSeries/DOT_03-01-2019 14-24-34-36_timeSeries.csv',stringsAsFactors = FALSE)
#bi_trade<-bi_trade[!(bi_trade$Indicator.Name=='Goods, Value of Trade Balance, US Dollars'),]
bi_trade<-subset(bi_trade, Indicator.Name!="Goods, Value of Trade Balance, US Dollars")
bi_trade<-bi_trade[,!names(bi_trade) %in% c('Attribute')]
colnames(bi_trade)[1]<-'Country.Name'
names(bi_trade)<-sub('X','',names(bi_trade))
bi_trade <- melt(bi_trade, id.vars= c('Country.Name', 'Country.Code' ,'Indicator.Name','Indicator.Code', 'Counterpart.Country.Name','Counterpart.Country.Code'), variable.name='Year', value.name='ExportsandImports')
bi_trade$ExportsandImports<-as.integer(bi_trade$ExportsandImports)
bi_trade<-bi_trade %>%
  group_by(Country.Name,Country.Code,Counterpart.Country.Name,Counterpart.Country.Code,Year) %>%
  summarize(bi_trade=sum(as.numeric(ExportsandImports)))
bi_trade<-bi_trade[which(bi_trade$Year==1995:2016),]
#bi_trade<-na.omit(bi_trade)

# 
pa_formula1_1 = "log(biopenness) ~ factor(iso_o)+factor(iso_d) + factor(Year) + log(dist)*(log(pop_o) + log(pop_d)) + contig*(log(pop_o) + log(pop_d) + log(dist)) + wto + rta"

ver1_step1<- lm(formula = pa_formula1_1, data = df)
#pa_formula2_1 = "log(value) ~ openness_real+ log(lperP) + log(ckperP) + log(Pop)+pr +tas  + factor(ISO) + factor(Year) | . - openness_real + openness_hat"
ver1_step0<- lm(formula = pa_formula1_1, data = df)
# trade = (geographic variables and time variables, ie. WTO and RTA) (distance, population, dummies, etc.)


# Sum to calculate constructed trade openness


# Save as new .csv file
# df.to_csv('results/stage_0_results.csv')
# 
# # Qian process flow
# # # Formula used
#version 1
# pa_formula1_1 = "log(biopenness) ~ factor(iso_o)+factor(iso_d) + factor(Year) + log(dist)*(log(pop_o) + log(pop_d)) + contig*(log(pop_o) + log(pop_d) + log(dist))"
# pa_formula2_1 = "log(value) ~ openness_real+ log(lperP) + log(ckperP) + log(Pop)+pr +tas  + factor(ISO) + factor(Year) | . - openness_real + openness_hat" 
# ##### version 2
# pa_formula1_2 = "log(biopenness) ~ factor(iso_o)+factor(iso_d) + factor(Year) + log(dist)*(log(pop_o) + log(pop_d)) + contig*(log(pop_o) + log(pop_d) + log(dist) +wto_o+wto_d+rta)" 
# pa_formula2_2 = "log(value) ~ openness_real*log(lperP) + openness_real*log(ckperP) + log(Pop)+pr +tas   + factor(ISO) + factor(Year) | . - openness_real*log(lperP) - openness_real*log(ckperP)  + openness_hat*log(lperP) + openness_hat*log(ckperP)"
#pa_formula2_2 = "log(value) ~ openness_real*lperP_dummy1 + openness_real*ckperP_dummy1 + log(Pop)+pr +tas   + factor(ISO) + factor(Year) | . - openness_real*lperP_dummy1 - openness_real*ckperP_dummy1  + openness_hat*lperP_dummy1 + openness_hat*ckperP_dummy1"

# # # # Panel Analysis
# panel_IV = function(df1_all, df2_all,all_years, dependentVar,pa_formulas, version, is_simple=T, rns, n_F) {
#   ## stage
#   stage = 1
#   temp = get_df2_final(df1_all, df2_all, pa_formulas[[version]][[stage]])
#   df2_final = temp[[1]]  # df2 for each year with instrument
#   model_instrument = temp[[2]] # bilateral trade model
#   summary(model_instrument)
#   
#   # label = paste("tablesPanelVersion", version,"Stage",stage, sep="")
#   # write(stargazer(model_instrument, label = label), paste("./tables/",label,".tex",sep=""), append=F, sep="\n\n")
#   # #plot
#   # plot_checkIV(df2_final, paste("./figures/",label,".pdf",sep=""))
#   # stage
#   stage = 2
#   
#   ## update standard error
#   var_table = list()
#   IVmodel = list()
#   for(dv in dependentVar){
#     res = get_panel_res(df2_final,dv, dependentVar, pa_formulas[[version]][[stage]], model_instrument, df1_all, is_simple)
#     var_table[[dv-dependentVar[[1]]+1]] = res[[1]]
#     IVmodel[[dv-dependentVar[[1]]+1]] = res[[2]]
#   }
# # # # #Functions used in Panel Analysis
#get_df2_final= It gives the final dataframe of estimated values
#get_df2_final <- function(df1_all, df2_all,  formula1){
# df1_curr = df1_all
# #df2_curr = subset(df2_all, Year == curr_year) 
# #formula1 = log(biopenness) ~ log(dist) + log(pop_o) + log(area_o) + log(pop_d) + log(area_d) + landlocked + contig*(1+log(dist) + log(pop_o) + log(area_o) + log(pop_d) + log(area_d) + landlocked)
# fo <- lm(formula = formula1, data = df1_curr)
# hat_totalopen <- predopen(fo, df1_curr)
# df2_curr = merge(df2_all, hat_totalopen, by = c("ISO","Year"))
# return(list(df2_curr, fo))
# }
# df1 has columns x, y, and z
# df 2 look like 
# panel_IV = function(){
	# this function does blah blah blah
