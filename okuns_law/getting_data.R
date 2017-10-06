rm(list=ls())

#Download Libraries
library(bea.R)
library(rjson)
library(blsAPI)
library(jsonlite)
library(dplyr)
library(readr)

# Download monthly unemployment rate from BLS  
payload <- list(
  'seriesid'=c('LNS14000000'),
  'startyear'=1990,
  'endyear'=1999
  )
response<-blsAPI(payload)
unempljson <- fromJSON(response,simplifyVector = TRUE)

#transform json to dataframe
unempldata <- unempljson['Results'] $Results$series$data
unempldf <- do.call(rbind.data.frame, unempldata)

#import gdp growth from csv file
gdpchg <- read_delim("gdpchg_90_99.csv", ";", escape_double = FALSE, trim_ws = TRUE)
colnames(gdpchg) <- c("time", "growth")

