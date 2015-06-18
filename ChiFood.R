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

data <- filter(data, 
                 city == "CHICAGO", 
                 risk != "",
                 risk != "All",
                 zip != "", 
                 latitude != "", 
                 longitude != "")# Filter data frame for Chicago restaurants only with non-blank risk classification and remove rows with NAs
data$risk <- droplevels(data$risk)# Clean out unused levels
data$facility.type <- tolower(data$facility.type)# Drop case of facility type names for filtering
data$facility.type <- gsub("^rest.*$", "restaurant", data$facility.type)# Rename all restaurant facility types to "restaurant"
data$dba.name <- toupper(data$dba.name)# Capitalize all business names for cleaner popups
data <- filter(data, facility.type == "restaurant")# Filter for restaurant-only data frame

##Shiny widget
zip <- filter(data, zip == "60827") %>% # Zip code filter

#Leaflet map
color <- colorFactor("RdYlGn", domain = zip$risk)
map <- leaflet(zip) %>% 
    addProviderTiles("Stamen.Toner") %>% 
    addCircleMarkers(lat = ~latitude, lng = ~longitude, popup = ~dba.name, color = ~color(risk), fillOpacity = .5) %>% 
    mapOptions(zoomToLimits = "always")

    
    
    
    
    






# zips <- data %>% 
#        group_by(as.character(zip)) %>%
#        summarise(mean(as.numeric(risk)))
# names(zips) <- c("region","value")
# 
# geojson <- readLines("https://raw.githubusercontent.com/smartchicago/chicago-atlas/master/db/import/zipcodes.geojson", warn = FALSE) %>%
#     paste(collapse = "\n") %>%
#     fromJSON(simplifyVector = FALSE)
# 
# map <- leaflet() %>% 
#     addTiles() %>% 
#     addGeoJSON(geojson) %>%
#     fitBounds(-87.9353, 42.0003, -87.5171, 41.6746) %>% 
#     setView(-87.7, 41.85, zoom = 11)

