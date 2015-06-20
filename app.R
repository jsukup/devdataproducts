
library(leaflet)
library(dplyr)
library(shiny)
library(jsonlite)

## Shiny app
load(file = "data.RData")# Load RData

# Leaflet map
# # Zip code filter
ui <- fluidPage(
        leafletOutput("map"),
        selectInput("zipcodes", "Select Zip Code", choices = c(data$zip), selected = "60601")
        )


server <- function(input, output){
    zip <- eventReactive(input$zipcodes, {
        filter(data, zip == input) %>% 
        group_by(dba.name, 
                 latitude, 
                 longitude) %>% 
        summarise(risk = round(mean(as.integer(risk))))
        }
)
    
    color <- colorFactor(c("red","yellow","green"), domain = zip$risk)# Create color palette

    
    output$map <- renderLeaflet({
        leaflet(zip) %>% 
        addProviderTiles("Stamen.Toner") %>% 
        addCircleMarkers(lat = ~latitude, 
                         lng = ~longitude, 
                         popup = ~dba.name, 
                         color = ~color(risk), 
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










