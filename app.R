library(shiny)
library(shinydashboard)
library(sparkline)
library(jsonlite)
library(dplyr)
library(leaflet)
source('global.R')

header <- dashboardHeader(title="Databrew app")
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      text="Main",
      tabName="main",
      icon=icon("eye")),
    menuItem(
      text = 'About',
      tabName = 'about',
      icon = icon("cog", lib = "glyphicon"))
  )
)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  tabItems(
    tabItem(
      tabName="main",
      fluidPage(
        fluidRow(
          column(4, 
                 selectInput("layer", "Choose tile:", choices= c("Esri.OceanBasemap", "Esri.NatGeoWorldMap", "Stamen.Watercolor")),
                 checkboxInput("showPlaces", "Show Places?", value = FALSE)
                 ),
          column(8, leafletOutput("leaf"))
        )
      )
    ),
    tabItem(
      tabName = 'about',
      fluidPage(
        fluidRow(
          div(img(src='logo_clear.png', align = "center"), style="text-align: center;"),
                 h4('Built in partnership with ',
                   a(href = 'http://databrew.cc',
                     target='_blank', 'Databrew'),
                   align = 'center'),
          p('Empowering research and analysis through collaborative data science.', align = 'center'),
          div(a(actionButton(inputId = "email", label = "info@databrew.cc", 
                             icon = icon("envelope", lib = "font-awesome")),
                href="mailto:info@databrew.cc",
                align = 'center')), 
          style = 'text-align:center;'
          )
        )
    )
  )
)

# UI
ui <- dashboardPage(header, sidebar, body, skin="blue")

# Server
server <- function(input, output) {
  
  output$leaf <- renderLeaflet({
    tile <- input$layer
    print(tile)
    l <- leaflet() %>% 
      addProviderTiles(tile) %>%
      # addPolygons(data=isr)
      addPolylines(data=isr)
    
    if(input$showPlaces) {
      l <- l %>% addMarkers(data = places, popup = places$name)
    }
    
    l
      
  })
}

shinyApp(ui, server)