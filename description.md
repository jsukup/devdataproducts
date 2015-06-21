Description
-----------

Data
====

Data for this app was imported from City of Chicago Data Portal:

("<https://data.cityofchicago.org/Health-Human-Services/Food-Inspections/4ijn-s7e5>")

Data Processing
===============

Not shown in the app are steps taken to clean the raw data set retrieved
from the above URL. Steps take are as follow:

    library(lubridate)
    library(leaflet)
    library(dplyr)
    library(shiny)
    library(jsonlite)

    ## Data Processing
    data <- read.csv("C:/Users/[LOCAL USER]/Downloads/Food_Inspections.csv", header = TRUE, stringsAsFactors = FALSE)# Read in data
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
    data <- select(data, c(dba.name,latitude,longitude,risk,zip))
    save(data, file = "data.RData")

Use
===

1.  Users select a City of Chicago Zip Code from the drom down menu
2.  Map updates to show restaurants in that area and their Risk Level
    according to the City of Chicago (more on data set can be found at
    [here](https://data.cityofchicago.org/api/assets/BAD5301B-681A-4202-9D25-51B2CAE672FF))
3.  Markets can be clicked on to see restaurant name
4.  Color of marker indicates level of risk associated with restaurant
    (see legend)

Limitations
===========

1.  Some latitude/longitude combinations for different restaurants are
    the same in the data set. This allows two or more locations to
    overlap and markers to "blend" colors.
2.  Some locations have multiple entries with different risk scores.
    This allows for overlap and markers to "blend" colors.
3.  Locations with multiple entires can have all their entires in the
    underlying data set accessed when clicked.
