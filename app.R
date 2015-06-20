## Shiny app
data <- load(file = "data.RData")# Load RData
# Zip code filter
zip <- filter(data, zip == "60618") %>% 
    group_by(dba.name, latitude, longitude) %>% 
    summarise(risk = round(mean(as.integer(risk))))
color <- colorFactor(c("red","yellow","green"), domain = zip$risk)# Create color palette
# Leaflet map
map <- leaflet(zip) %>% 
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