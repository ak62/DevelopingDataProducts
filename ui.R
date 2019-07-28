# loading the required packages
library(shiny)
library(data.table)
library(tidyr)
library(leaflet)
library(wbstats)
library(ggplot2)

shinyUI(fluidPage(
    titlePanel("Country Population"),
    sidebarLayout(
        sidebarPanel(
            h4("Description:"),
            p("This application provides the population statistics of world's countries using  World Bank's database."), 
            p("To pull the data from World Bank database,", strong(span("wbstats", style="color:blue")), "package is used. Allow about", strong(span("15 seconds", style="color:red")), "for the data to download!"),
            p("The map on the right shows the capital of the selected country (move your mouse to the marker to see the name of the capital)."),
            p("In addition to the total population, the user can choose to plot the population by gender."),
            selectizeInput("countrynamebox", "Select country name", choices=c("Aruba"), selected="United States"),
            checkboxInput("MPop", "Show/Hide male", value = TRUE),
            checkboxInput("FPop", "Show/Hide female", value = TRUE)
        ),
        mainPanel(
            leafletOutput("CountryMap"),
            plotOutput("PopPlot")
        )
    )
))

