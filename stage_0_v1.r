# Causal Effect of Trade Openness on Agricultural Variables
# STAGE 0: Instument construction (constructed trade openness from geographic variables)
# Akshay Pandit & Paul J. Ruess
# Spring 2019

# Load necessary libraries
library(XLConnect)
library(reshape2)
library(data.table)
library(dplyr)

# Read in geographic variables
df <- read.csv('cleandata/input_data_clean.csv') # all input data (from collect_data.r script)
print(head(df))
break

### Read Bilateral trade data

# Clean bilateral trade data
bi_trade_file <- 'cleandata/bilateral_trade_clean.csv'
if(!file.exists(bi_trade_file)){

    # Clean raw bilateral trade data
    print('Cleaning bilateral trade file...')
    bi_trade <- read.csv(file = 'rawdata/DOT_03-01-2019 14-24-34-36_timeSeries/DOT_03-01-2019 14-24-34-36_timeSeries.csv',stringsAsFactors = FALSE)
    bi_trade <- subset(bi_trade, Indicator.Name!="Goods, Value of Trade Balance, US Dollars")
    bi_trade <- bi_trade[,!names(bi_trade) %in% c('Attribute')]
    colnames(bi_trade)[1] <- 'Country.Name'
    names(bi_trade) <- sub('X','',names(bi_trade))
    bi_trade <- melt(bi_trade, id.vars= c('Country.Name', 'Country.Code' ,'Indicator.Name','Indicator.Code', 'Counterpart.Country.Name','Counterpart.Country.Code'), variable.name='Year', value.name='ExportsandImports')
    bi_trade$ExportsandImports<-as.numeric(bi_trade$ExportsandImports)
    
    # Sum exports and imports for all country pairs
    bi_trade <- setDT(bi_trade)[, sum(ExportsandImports), by=list(Country.Name,Country.Code,Counterpart.Country.Name,Counterpart.Country.Code,Year)]

    # Remove links with no trade
    bi_trade<-na.omit(bi_trade)

    # Rename value column
    colnames(bi_trade)[colnames(bi_trade) == 'V1'] <- 'bi_trade'

    # Save file
    write.csv(bi_trade,file=bi_trade_file,row.names=FALSE)

} else {

    # Read cleaned bilateral trade file if it exists
    print('Loading cleaned bilateral trade file...')
    bi_trade <- read.csv(bi_trade_file)

}

print(head(bi_trade))

# Define formula to construct instrument
# General approach: trade = (geographic variables & time variables, ie. WTO and RTA) (distance, population, dummies, etc.)
# Original formula from Dang et al., 2018: 'log(biopenness) ~ factor(iso_o) + factor(iso_d) + factor(Year) + log(dist)*(log(pop_o) + log(pop_d)) + contig*(log(pop_o) + log(pop_d) + log(dist) + wto + rta)'
stage_0_formula = 'log(biopenness) ~ log(dist)*log(pop_o) + log(dist)*log(pop_d) + contig*log(dist) + contig*log(pop_o) + contig*log(pop_d) + contig*wto + contig*rta + factor(iso_o) + factor(iso_d) + factor(Year)'


# Read in geographic variables
df <- read.csv('cleandata/input_data_clean.csv') # all input data (from collect_data.r script)


# Sum to calculate constructed trade openness


# Save as new .csv file
df.to_csv('results/stage_0_results.csv')

# Qian process flow

# df1 has columns x, y, and z
# df 2 look like 
# panel_IV = function(){
	# this function does blah blah blah
