rm(list=ls())

#Download Libraries
library(bea.R)
library(rjson)
library(blsAPI)
library(jsonlite)
library(dplyr)
library(readr)


## GETTING UNEMPLOYMENT RATE DATA

# Download monthly unemployment rate from BLS  
payload <- list(
  'seriesid'=c('LNS14000000'),
  'startyear'=1990,
  'endyear'=1999
  )
response<-blsAPI(payload)
unempljson <- fromJSON(response,simplifyVector = TRUE)

#Transform json to dataframe
unempldata <- unempljson['Results'] $Results$series$data
unempldf <- do.call(rbind.data.frame, unempldata)


#Merge year and month

unempldf$time <- paste(unempldf$year,unempldf$period)

#Remove columns in dataframe
keeps <- c("time","value")
unempldf = unempldf[keeps]

#Order by ascending time

unempldf <- unempldf[order(unempldf$time,decreasing=FALSE), ]

# Create quarterly unemployment rate 

monthly <- ts(unempldf,start=c(1990,1),frequency=12)
unemplquarterly <- data.frame(aggregate(monthly, nfrequency=4, mean))


# Create change quarterly unemployment rate

unemplchg<-data.frame(diff(unemplquarterly$value, lag=1))




## GETTING GDP GROWTH DATA

#import GDP growth from csv file

gdpchg <- read_delim("gdpchg_90_99.csv", ";", escape_double=FALSE, trim_ws=TRUE)
colnames(gdpchg)<-c("time", "growth")

# Get rid of first row because it matches the unemployment data
gdpchg = gdpchg[-1,]


## MERGE THE TWO DATAFRAMES and RENAME VARIABLES

wholedta <- data.frame(gdpchg, unemplchg)
colnames(wholedta)<-c("time", "gdpchg", "unemplchg")















































