setwd("C:/Users/sukujo01/Downloads")

library(lubridate)
library(choroplethr)
library(dplyr)

##Data Processing
data <- read.csv("Food_Inspections.csv", header = TRUE, stringsAsFactors = FALSE)# Read in data

names(data) <- tolower(names(data))# Lower case varnames
data$inspection.date <- parse_date_time(data$inspection.date, "mdy")# Convert to POSIX date variable
data$facility.type <- as.factor(data$facility.type)# Convert to factor
data$risk <- as.factor(data$risk)# Convert to factor
data$inspection.type <- as.factor(data$inspection.type)# Convert to factor
data$results <- as.factor(data$results)# Convert to factor
data$city <- gsub("CCHICAGO|
                  CHCHICAGO|
                  CHCICAGO|
                  chicago|
                  CHicago|
                  Chicago|
                  CHICAGOCHICAGO|
                  CHICAGOI", 
                  "CHICAGO", 
                  data$city)# Substitute different versions of "Chicago" city name to "CHICAGO"

chidat <- filter(data, 
                 city == "CHICAGO", 
                 risk != "", 
                 zip != "", 
                 latitude != "", 
                 longitude != "")# Filter data frame for Chicago restaurants only with non-blank risk classification and remove rows with NAs
chidat$risk <- droplevels(chidat$risk)# Clean out unused levels

zips <- chidat %>% 
        group_by(as.character(zip)) %>%
        summarise(mean(as.numeric(risk)))
names(zips) <- c("region","value")
