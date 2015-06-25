
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
    titlePanel("Chicago Food Inspections: Restaurant Risk Level - 2001 to Present"),
    mainPanel(
        tabsetPanel(
            tabPanel("App", leafletOutput("chimap"),
                     selectInput("zipcodes", 
                                 "Select Zip Code", 
                                 choices = sort(data$zip))),
            tabPanel("Description", includeMarkdown("description.md"))
    )
)
)

server <- function(input, output){
    data <- data
    color <- colorFactor(c("red","yellow","green"), domain = data$risk)
    getData <- reactive({data[data$zip == input$zipcodes,]})
    
    output$chimap <- renderLeaflet({
        leaflet(getData()) %>% 
        addProviderTiles("Stamen.Toner") %>% 
        addCircleMarkers(lat = ~latitude, 
                         lng = ~longitude, 
                         popup = ~dba.name,
                         radius = 5,
                         color = ~color(risk), # Create color palette
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

