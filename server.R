# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


# Define server logic required to draw a histogram

  myDataTable <- mydata@data %>%
    dplyr::select(NATCODE, NAMEUNIT, Tavg, mosq.abund.MosqAlert, 
                  GDP.test , rnott.expected, 
                  rnot.ests.mean.MosquitoAlert, 
                  ProbabilidadEpidemiaBaja, 
                  ProbabilidadEpidemiaMedio, 
                  ProbabilidadEpidemiaAlto)

  
    #load("SimulBajoRiesgo.rdata")
    #load("SimulMedioRiesgo.rdata")
    SimulAltoRiesgo <- load("data/SimulAltoRiesgo.rdata")
    #CatalunyaData <- load("data/CatalunyaData.rdata")
    load("data/CatalunyaData.rdata")
    CatalunyaDem <- load("data/CatalunyaDem.rdata")
    source("outbreak_analysis_fxns.R")
    source("plotting_fxns.R")

  
  
    
    
server <- function(input, output, session) {
 
   
  mydata = readRDS("data/MapaDeRiesgos.rds")
 
  # Make my data reactive 
  data <- reactive(
    x <- mydata
  )
  
  # select data for data table:
  
  #myDataTable <- mydata@data %>%
  #  dplyr::select(NATCODE, NAMEUNIT, Tavg, mosq.abund.MosqAlert, 
  #                GDP.test , rnott.expected, 
  #                rnot.ests.mean.MosquitoAlert, 
  #                ProbabilidadEpidemiaBaja, 
  #                ProbabilidadEpidemiaMedio, 
  #                ProbabilidadEpidemiaAlto)
 
  #### 
  output$myMapRisk <- renderLeaflet({
    
   df <- data()
   
   pal <- colorNumeric(palette = "YlOrRd", domain = df$input$riskLevel)
   #pal <- colorNumeric(palette = "Reds", domain = df$input$riskLevel)
   
   labels <- sprintf(
     #"<strong>%s</strong><br/>%g people / mi<sup>2</sup>",
     "<strong>%s</strong><br/> Prob.Outbreak =  %g",
     #"<strong>%s</strong><br/>%g <sup>º</sup>C",
     #mydata$NAMEUNIT,mydata$Tavg
     #mydata$NAMEUNIT,mydata$ProbabilidadEpidemiaMedio) %>% 
     mydata$NAMEUNIT, df[[input$riskLevel]]) %>% 
     lapply(htmltools::HTML)
   
   map <- leaflet(data = df) %>%
     
     addTiles(group = "OSM (default)") %>%
     addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
     addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
     #addTiles() %>% # Add default OpenStreetMap map tiles
     
     setView(lng = 2.183333333333333, lat = 40.8688333333333333, zoom = 7.5) %>%
     #setView(lng = -73.935242, lat = 40.730610, zoom = 10),
     
     addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5, 
                 opacity = 1.0, 
                 #fillColor = ~colorQuantile("YlOrRd", ProbabilidadEpidemiaBaja),
                 #fillColor = ~pal(ProbabilidadEpidemiaAlto),
                 fillColor =  ~pal(df[[input$riskLevel]]),
                 fillOpacity = 0.5,
                 highlightOptions = highlightOptions(color = "white", weight = 2,
                                                     bringToFront = TRUE),
                 label = labels,
                 labelOptions = labelOptions(
                   style = list("font-weight" = "normal", padding = "3px 8px"),
                   textsize = "15px",
                   direction = "auto"),
                 group = "High Risk") %>%
     
     
     addLegend(pal = pal, values = ~ProbabilidadEpidemiaAlto, opacity = 0.7, 
               title = "Outbreak Probability",
               position = "topright") %>%
     
     addLayersControl( 
       baseGroups = c("OSM (default)", "Toner", "Toner Lite")#,
       )
   
     map
   
  })
#}


#######
  output$myMapCovariates <- renderLeaflet({
    
   df <- data()
   #mypal = 
   #pal <- colorNumeric(palette = "YlOrRd", domain = df$ProbabilidadEpidemiaMedio)
   #pal <- colorNumeric(palette = "Reds", domain = df$input$riskLevel)
   pal <- colorNumeric(palette = rev("Purples"),  domain = df$input$covariate)
   #pal <- colorNumeric(palette = "YlOrRd", domain = df$input$riskLevel)
   
   labels <- sprintf(
     "<strong>%s</strong><br/> %g",
     mydata$NAMEUNIT, df[[input$covariate]]) %>% 
     lapply(htmltools::HTML)
   
   map <- leaflet(data = df) %>%
     
     addTiles(group = "OSM (default)") %>%
     addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
     addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
     #addTiles() %>% # Add default OpenStreetMap map tiles
     
     setView(lng = 2.183333333333333, lat = 40.8688333333333333, zoom = 7.5) %>%
     #setView(lng = -73.935242, lat = 40.730610, zoom = 10),
     
     addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5, 
                 opacity = 1.0, 
                 #fillColor = ~colorQuantile("YlOrRd", ProbabilidadEpidemiaBaja),
                 #fillColor = ~pal(ProbabilidadEpidemiaAlto),
                 fillColor =  ~pal(df[[input$covariate]]),
                 fillOpacity = 0.5,
                 highlightOptions = highlightOptions(color = "white", weight = 2,
                                                     bringToFront = TRUE),
                 label = labels,
                 labelOptions = labelOptions(
                   style = list("font-weight" = "normal", padding = "3px 8px"),
                   textsize = "15px",
                   direction = "auto"),
                 group = "High Risk") %>%
     
     
     addLegend(pal = pal, values = ~df[[input$covariate]], opacity = 0.7, 
               title = "Outbreak Probability",
               position = "topright") %>%
     
     addLayersControl( 
       baseGroups = c("OSM (default)", "Toner", "Toner Lite")#,
       )
   map
  })
#}


########
  # Print data table if checked
  output$myTable <- DT::renderDataTable({
      DT::datatable(data = myDataTable,
                    rownames = FALSE)
    })
  

  
########  
  # Plot Muninicipality Final Size
  output$finalSize <- renderPlot({
    
    ##load("SimulBajoRiesgo.rdata")
    ##load("SimulMedioRiesgo.rdata")
    #SimulAltoRiesgo <- load("data/SimulAltoRiesgo.rdata")
    ##CatalunyaData <- load("data/CatalunyaData.rdata")
    #load("data/CatalunyaData.rdata")
    #CatalunyaDem <- load("data/CatalunyaDem.rdata")
    #source("outbreak_analysis_fxns.R")
    #source("plotting_fxns.R")
    
    
    nameMunicip <- input$municipality
    nameMunicip<-paste("^",nameMunicip,"$", sep="")
    pos<-grep(nameMunicip, CatalunyaData$NAMEUNIT)
    plot_final_sizes(outbreak_sim[[pos]]) 
    
  })
  
  # Plot Municipality Outbreaks Only
  output$plot_Dengue_outbreaks_only <- renderPlot({
    
    ##load("SimulBajoRiesgo.rdata")
    ##load("SimulMedioRiesgo.rdata")
    #SimulAltoRiesgo <- load("data/SimulAltoRiesgo.rdata")
    ##CatalunyaData <- load("data/CatalunyaData.rdata")
    #load("data/CatalunyaData.rdata")
    #CatalunyaDem <- load("data/CatalunyaDem.rdata")
    #source("outbreak_analysis_fxns.R")
    #source("plotting_fxns.R")
    
    
    nameMunicip <- input$municipality
    nameMunicip<-paste("^",nameMunicip,"$", sep="")
    pos<-grep(nameMunicip, CatalunyaData$NAMEUNIT)
    plot_zika_outbreaks(outbreak_sim[[pos]]) 
    
  })
  
  
  # Plot Municipality Outbreaks All
  output$plot_Dengue_outbreaks_all <- renderPlot({
    
    ##load("SimulBajoRiesgo.rdata")
    ##load("SimulMedioRiesgo.rdata")
    #SimulAltoRiesgo <- load("data/SimulAltoRiesgo.rdata")
    ##CatalunyaData <- load("data/CatalunyaData.rdata")
    #load("data/CatalunyaData.rdata")
    #CatalunyaDem <- load("data/CatalunyaDem.rdata")
    #source("outbreak_analysis_fxns.R")
    #source("plotting_fxns.R")
    
    
    nameMunicip <- input$municipality
    nameMunicip<-paste("^",nameMunicip,"$", sep="")
    pos<-grep(nameMunicip, CatalunyaData$NAMEUNIT)
    plot_zika_outbreaks(outbreak_sim[[pos]], cases = "all") 
    
  })
  
 
  
  
   
  
}

## Run the application 
#shinyApp(ui = ui, server = server) # not needed when separating files

