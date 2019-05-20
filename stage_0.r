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
df <- read.csv('cleandata/input_data_clean.csv') # all input data (from collect_data.r script)
# Calculate bilateral trade from geographic variables and time-variant panel variables (constructed trade openness) 
#Read Bilateral trade data
bi_trade<-read.csv(file = 'rawdata/DOT_03-01-2019 14-24-34-36_timeSeries/DOT_03-01-2019 14-24-34-36_timeSeries.csv',stringsAsFactors = FALSE)
#bi_trade<-bi_trade[!(bi_trade$Indicator.Name=='Goods, Value of Trade Balance, US Dollars'),]
bi_trade<-subset(bi_trade, Indicator.Name!="Goods, Value of Trade Balance, US Dollars")
bi_trade<-bi_trade[,!names(bi_trade) %in% c('Attribute')]
colnames(bi_trade)[1]<-'Country.Name'
names(bi_trade)<-gsub('X','',names(bi_trade))
bi_trade<-bi_trade[-c(7:60,76:77)]
bi_trade <- melt(bi_trade, id.vars= c('Country.Name', 'Country.Code' ,'Indicator.Name','Indicator.Code', 'Counterpart.Country.Name','Counterpart.Country.Code'), variable.name='Year', value.name='ExportsandImports')
bi_trade$ExportsandImports<-as.integer(bi_trade$ExportsandImports)
bi_trade[is.na(bi_trade)]<-0
bi_trade<-bi_trade %>%
  group_by(Country.Name,Country.Code,Counterpart.Country.Name,Counterpart.Country.Code,Year) %>%
  summarize(bi_trade=sum(as.numeric(ExportsandImports)))

IMF_codes<-read.csv('rawdata/IMF_codes.csv')#IMF list
bi_trade<-merge(IMF_codes,bi_trade,by.x="IMF.Code",by.y="Country.Code")
colnames(bi_trade)[1]<-'Country.IMF.Code'
colnames(bi_trade)[2]<-'Country.Code'
bi_trade<-merge(IMF_codes,bi_trade,by.x="IMF.Code",by.y="Counterpart.Country.Code")
colnames(bi_trade)[1]<-'Counterpart.Country.IMF.Code'
colnames(bi_trade)[2]<-'Counterpart.Country.Code'
bi_trade<-bi_trade[-c(1,3,5,6)]
bi_trade<-bi_trade[c(2,1,3,4)]
bi_trade<-bi_trade[which(bi_trade$bi_trade!=0),]
#Reading GDP (in US$) data
GDP<-read.csv('rawdata/GDP_world_bank.csv')
names(GDP)<-gsub('X','',names(GDP))
GDP<-GDP[-c(3:44,60)]
GDP<- melt(GDP, id.vars= c('Country.Name' ,'Country.Code'), variable.name='Year', value.name='GDP')
GDP<-na.omit(GDP)
GDP<-GDP[which(GDP$GDP!=0),]
biopen<-merge(bi_trade,GDP,by.x=c('Country.Code','Year'),by.y=c('Country.Code','Year'))
biopen<-biopen[-c(5)]
biopen$biopenness<-biopen$bi_trade/biopen$GDP
df<-merge(df,biopen,by.x=c('iso_o','iso_d','year'),by.y=c('Country.Code','Counterpart.Country.Code','Year'))
df<-na.omit(df)
df<-df[-c(21:22)]

#Running stage0 analysis
pa_formula1_0 = "log(biopenness) ~ factor(iso_o)+factor(iso_d) + factor(year) + log(dist)*(log(pop_o) + log(pop_d)) + contig*(log(pop_o) + log(pop_d) + log(dist)) + wto_o + wto_d + rta"

#ver1_step1<- lm(formula = pa_formula1_1, data = df)
#pa_formula1_2 = "log(value) ~ openness_real+ log(AperP) + log(ckperP) + log(Pop)+pr +tas  + factor(ISO) + factor(Year) | . - openness_real + openness_hat"
ver1_step0<- lm(formula = pa_formula1_0, data = df)
hat_totalopen<-predopen(ver1_step0,df)
#building new dataframe for Stage 1 analysis
df2<-df[-c(2,7:13,17:21)]
df2<-unique(df2)
df2<-merge(df2,hat_totalopen,by.x=c('iso_o','year'),by.y=c('ISO','Year'))
df2$AperP<-df2$area/df2$pop_o
df2$ckperP<-df2$ck/df2$pop_o
write.csv(df2,file='results/input_data_clean_stage1.csv',row.names = FALSE)
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
