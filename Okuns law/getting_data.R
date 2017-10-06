#Download Libraries
library(bea.R)
library(rjson)
library(blsAPI)


# Download monthly unemployment rate from BLS  
payload <- list(
  'seriesid'=c('LNS14000000'),
  'startyear'=1990,
  'endyear'=2015)
response<-blsAPI(payload)
unempljson <- fromJSON(response)