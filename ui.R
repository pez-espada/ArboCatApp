# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  #themeSelector(),
  theme = shinytheme("cerulean"), 
  
  sidebarLayout(
    
  
    sidebarPanel(
      conditionalPanel( 
        condition="input.tabselected == 1",
        wellPanel(
          h4("Outbreak Risk Level:"),
          selectInput(inputId = "riskLevel",
                      label = "Level:",
                      choices = c("high" = "ProbabilidadEpidemiaAlto", 
                                 "med" = "ProbabilidadEpidemiaMedio", 
                                 "low" = "ProbabilidadEpidemiaBaja"),
                      selected = "ProbabilidadEpidemiaMedio")
          )#, # for wellPanel
        ), # for conditionalPanel
      
      conditionalPanel(
        condition="input.tabselected == 2",
        wellPanel(
          h4("Select Covariate:"),
          selectInput(inputId = "covariate",
                      label = "Kind:",
                      choices = c("Temp" = "Tavg", 
                                  "GDP" = "GDP.test", 
                                  "Mosq. Abund." = "mosq.abund.MosqAlert",
                                  "R0" = "rnott.expected.MosqAlert"),
                      selected = "Tavg")
          ) # for wellPanel
      ), # forconditionPanel
      
      width = 2  
    ), # for sidebarPanel
  
    
  #######
  # map
  mainPanel(
  # App title
  titlePanel(h3("ArboCat - Assessing Arbovirals' Risk in Catalonia",
                img(src = './img/arbocat_logo.png', height=50, width=50) ), windowTitle = "ArboCat"), 
  # 
  
  tabsetPanel(type = "tabs", id = "tabselected",
              # Tab 1 Riks Maps
              tabPanel("Risk Maps", value = 1,
                       leafletOutput("myMapRisk", height = 1000),
                       selectInput(inputId = "risk", label = "Risk Level:", 
                                   choices = c("high_risk", "med_risk", "low_risk"),
                                   selected = "med_risk") 
                       ),
              
              # Tab 2 Covariates Maps
              tabPanel("Covariate Maps", value = 2,
                       leafletOutput("myMapCovariates", height = 1000),
                       h5("Put the covariate maps here, Temp, PBI, Mosq abundace, Population, importation risk,")
                       ),
              
              # Tab 3 Data Table
              tabPanel("Data", value = 3,
                       h3("Put the data table here"),
                       DT::dataTableOutput(outputId = "myTable")
                       ),
              
              # Tab 4 scatter plots and histograms, value = 4,
              tabPanel("Scatter Plots and Histograms", 
                       h3("Put the scateer plots and histograms here")
                       ),
              
              # Tab 4 about, value = 5,
              tabPanel("About", 
                       h3("Here some words about the project and put contacts.")
                       )
              
              ),
  #leafletOutput("mymap", height = 1000)
  
  width = 10

  
  ) # for main panel
  ) # for sidebarLayaout  
) # for fluidPage
