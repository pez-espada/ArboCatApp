# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#rm(list = ls())
#library(rstudioapi)
##current_path = rstudioapi::getActiveDocumentContext()$path 
##setwd(dirname(current_path ))

library(shiny)
library(dplyr)
library(shinythemes)
#setwd("~/carlos-code/R/Texas/LeoScripts/Shiny/")
#setwd("./")
library(rgdal)
library(raster)
library(ggplot2)
library(rgeos)
#library(mapview)
library(leaflet)
library(broom) # if you plot with ggplot and need to turn sp data into dataframes
options(stringsAsFactors = FALSE)
library(rgdal)
library(RColorBrewer)
mydata = readRDS("data/MapaDeRiesgos.rds")

#load("SimulBajoRiesgo.rdata")
#load("SimulMedioRiesgo.rdata")
SimulAltoRiesgo <- load("data/SimulAltoRiesgo.rdata")
#CatalunyaData <- load("data/CatalunyaData.rdata")
load("data/CatalunyaData.rdata")
CatalunyaDem <- load("data/CatalunyaDem.rdata")
source("outbreak_analysis_fxns.R")
source("plotting_fxns.R")