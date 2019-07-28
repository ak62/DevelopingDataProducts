library(shiny)


shinyServer(function(input, output, session) {
    cachelist <- wb_cachelist
    WBData <- wb(country="countries_only", indicator = c("SP.POP.TOTL", "SP.POP.TOTL.MA.IN", "SP.POP.TOTL.FE.IN"), return_wide = TRUE)
    setnames(WBData, c("date","SP.POP.TOTL", "SP.POP.TOTL.MA.IN", "SP.POP.TOTL.FE.IN"), c("Year","Total", "Male", "Female"))
    WBData$Year <- as.numeric(WBData$Year)
    
    updateSelectizeInput(session, "countrynamebox", choices = unique(WBData$country),server = TRUE)
    
    CountryData <- reactive({
        CountryName <- renderText(input$countrynamebox)
        subset(cachelist$countries, country==CountryName())
    })
    
    PopHist <- reactive({
        CountryName <- renderText(input$countrynamebox)
        selectCol <- c("Year","Total")
        if(input$MPop){
            selectCol <- c(selectCol, "Male")
        }
        if(input$FPop){
            selectCol <- c(selectCol, "Female")
        }
        countryPop <- subset(WBData, country==CountryName(), select = selectCol)
        gather(countryPop, StatsType, Population, 2:ncol(countryPop))
    })
    
    output$CountryMap <- renderLeaflet({
        capital <- CountryData()[[4]]
        lat <- as.numeric(CountryData()[[6]])
        lon <- as.numeric(CountryData()[[5]])
        CountryMap <- leaflet() %>% addTiles()
        CountryMap <- CountryMap %>% addMarkers(lat = lat, lng = lon, popup = paste("Capital:", capital))
        CountryMap <- CountryMap %>% setView(lat = lat, lng = lon, zoom = 3.5)
    })
    
    output$PopPlot <- renderPlot({
        ggplot(PopHist(), aes(x = Year, y = Population)) + geom_line(aes(color = StatsType))},
        height = 200
    )

})
