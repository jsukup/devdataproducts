
library(leaflet)
library(dplyr)
library(shiny)
library(jsonlite)

## Shiny app
load(file = "data.RData")# Load RData
data <- data %>% 
    group_by(dba.name,
             latitude,
             longitude,
             zip) %>% 
    summarise(risk = round(mean(as.integer(risk)))) 


# Leaflet map
## Zip code filter
ui <- fluidPage(
    leafletOutput("chimap"),
    selectInput("zipcodes", "Select Zip Code", choices = sort(data$zip), selected = "60601")
)

server <- function(input, output){
    data <- data
    getData <- reactive({data[data$zip == input$zipcodes,]})
    
    output$chimap <- renderLeaflet({
        leaflet(getData()) %>% 
        addProviderTiles("Stamen.Toner") %>% 
        addCircleMarkers(lat = ~latitude, 
                         lng = ~longitude, 
                         popup = ~dba.name, 
 # Create color palette
                         fillOpacity = .3) %>% 
        mapOptions(zoomToLimits = "always") %>% 
        addLegend("topright",
                  color = c("red","yellow","green"),
                  labels = c("High Risk","Medium Risk","Low Risk"),
                  values = ~risk,
                  title = "Risk Level for Chicago Restaurants",
                  opacity = .7)
    }
    )
}
  
shinyApp(ui, server)        
