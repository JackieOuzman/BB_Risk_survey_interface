#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
library(readxl)




        fluidPage(
           #Application title
               titlePanel("BB Risk Data"),
               
               radioButtons("workshop_ID", 
                            label = h3("List of workshops"),
                            choices = list("neshalby" = "1204neshalby", 
                                           "EP" = "0206ep", 
                                           "Hart" = "1807hart",
                                           "FR" = "1907fr",
                                           "Temora" = "2107temora",
                                           "Nss" = "2607nss",
                                           "mnhrz" = "2807mnhrz",
                                           "Birchip" = "0408birchip",
                                           "dalwallin" = "1408dalwallinu"), 
                            selected = "1807hart"),
         
          
          

          hr(),
          fluidRow(column(3, verbatimTextOutput("value"))
                   
                   ), #fluid page bracket

        

        # Show a plot 
        mainPanel(
            plotOutput("plolt1")
        )
    )

