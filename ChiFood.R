#setwd("C:/Users/sukujo01/Downloads")# Work laptop directory


library(lubridate)
library(leaflet)
library(dplyr)
library(shiny)
library(jsonlite)

##Data Processing
data <- read.csv("C:/Users/John E Sukup III/Downloads/Food_Inspections.csv", header = TRUE, stringsAsFactors = FALSE)# Read in data

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

geojson <- readLines("https://raw.githubusercontent.com/smartchicago/chicago-atlas/master/db/import/zipcodes.geojson", warn = FALSE) %>%
    paste(collapse = "\n") %>%
    fromJSON(simplifyVector = FALSE)

map <- leaflet() %>% 
    addTiles() %>% 
    addGeoJSON(geojson) %>%
    setMaxBounds(-87.9353, 42.0003, -87.5171, 41.6746) %>% 
    setView(-87, 42, zoom = 11)

