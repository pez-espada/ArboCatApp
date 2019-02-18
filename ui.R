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
                      label = NULL,
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
                      label = NULL,
                      choices = c("Temp" = "Tavg", 
                                  "GDP" = "GDP.test", 
                                  "Mosq. Abund." = "mosq.abund.MosqAlert",
                                  "R0" = "rnott.expected.MosqAlert"),
                      selected = "Tavg")
          ) # for wellPanel
      ), # forconditionPanel
     
      conditionalPanel(
        condition="input.tabselected == 4",
        wellPanel(
          h4("Select Municipality:"),
          selectInput(inputId = "municipality",
                      label = NULL,
                      choices = mydata$NAMEUNIT,
                      selected = "NAMEUNIT")
          ) # for wellPanel
      ), # forconditionPanel
      
      
       
      width = 2  
    ), # for sidebarPanel
  
    
  #######
  # map
  mainPanel(
  # App title
  titlePanel(#img(src = "arbocat_logo.png"), 
    h2("ArboCat - Assessing Arbovirals' Risk in Catalonia",
                img(src = 'ISGlobal_Logo.png', height=180, width=280) ), windowTitle = "ArboCat"), 
    
   
  #titlePanel(title=div(id="title", img(height = 120,
  #                                     width = 120,
  #                                     src = "ISGlobal_Logo.png"), 
  #                     "ArboCat - Assessing Arbovirals' Risk in Catalonia"), img(src = "arbocat_logo.png")), 
  
  
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
                       leafletOutput("myMapCovariates", height = 1000)#,
                       #h5("Put the covariate maps here, Temp, PBI, Mosq abundace, Population, importation risk,")
                       ),
              
              # Tab 3 Data Table
              tabPanel("Data", value = 3,
                       h3("Put the data table here"),
                       DT::dataTableOutput(outputId = "myTable")
                       ),
              
              # Tab 4 scatter plots and histograms, value = 4,
              tabPanel("Simulations Plots and Histograms", value = 4, 
                       #h3("Put the simulation plots and histograms here"),
                       plotOutput(outputId = "finalSize", height = 250, width = 500),
                       #br(),
                       plotOutput(outputId = "plot_Dengue_outbreaks_only", height = 250, width = 500),
                       #br()
                       plotOutput(outputId = "plot_Dengue_outbreaks_all", height = 250, width = 500)
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
