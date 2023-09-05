#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(ggplot2)
library(tidyverse)
library(readxl)
###############################################################################
#### Import data 

###############################################################################

#### Central location of the files the app will draw on - id the directory here ######################
######################################################################################################
#---BB note: you will need the below code if you are swapping between machines probably don't need to worry about it now
node_name <- Sys.info()["nodename"]

# location_files_for_app <- 'C:/Users/bro87m/R/'


## the below code just says if its Jackie machine "TOPAZ-GW" look for data on Jackie computer otherwise look for data on Brendan computer
if (node_name=="TOPAZ-GW" ) {
  location_files_for_app <- 'C:/Users/ouz001/working_from_home_post_Sep2022/BB_Risk/'
} else {
  location_files_for_app <- "C:/Users/bro87m/R/"} 
#################################################################################

######BB 

df <- read_excel(
  paste0(location_files_for_app,
         "Copy of Overview of Snapshot Survey for RiskWise SYD meeting.xlsx"),
  sheet = "Data")



#--------------------- STUCK HERE --------------------------------------------#
#https://www.google.com/search?q=r+shiny+how+to+make+a+dynamic+drop+down+list&rlz=1C1GCEB_enAU1023AU1023&oq=r+shiny+how+to+make+a+dynamic+drop+down+list&aqs=chrome..69i57j69i64.12997j0j15&sourceid=chrome&ie=UTF-8#fpstate=ive&vld=cid:11be4898,vid:mHRVFMQ54ZE
reactive_df <- reactive(df)
observe({
  updateSelectInput(session, "workshop_ID",
                    choices = distinct(df$`workshop ID`))
})
#--------------------- STUCK HERE --------------------------------------------#








# Define server logic required to draw a histogram
function(input, output, session) {
  
  output$test <-renderPrint({head(reactive_df(),10)}) # this is just a step for testing
  
 
  output$plolt1 <- renderPlot({
    
    df_selected <- reactive_df() %>% select("Workshop ID" ,
                                 "Respondant",
                                 "[2] Risk Aversion",
                                 "[3] Intuition Vs Calculation" ,
                                 "[4] Comfort with Decision Process"  
    ) %>% 
      rename(  "Risk Aversion"                  =   "[2] Risk Aversion",
               "Intuition Vs Calculation"       =   "[3] Intuition Vs Calculation",
               "Comfort with Decision Process"  =   "[4] Comfort with Decision Process")
    
    
    #---BB note: you may need to make your df long
    df_selected_wide <- df_selected %>% 
      pivot_longer(
        cols = `Risk Aversion`:`Comfort with Decision Process`,
        values_to = "score"
      )
    
   
    
    df_selected_wide_all         <- df_selected_wide %>% mutate(data_grouping = "all")
    df_selected_wide_filtered  <- df_selected_wide %>%  filter(`Workshop ID` == input$workshop_ID) %>% mutate(data_grouping = input$workshop_ID) #add the worhsop name here
    df_selected_wide_merge <- rbind(df_selected_wide_all,df_selected_wide_filtered )
    
    
    ### Make a box plot
    
    df_selected_wide_merge %>%  
      filter(!is.na("score" )) %>% #removing any missing data 
      #filter(`Workshop ID` == "1807hart") %>%  # this is where you add the input$ for shiny if you only one w/s to display
      ggplot( mapping = aes(x = name, 
                            y = score ,
                            #group = name,
                            fill=data_grouping)) +
      theme_bw()+
      geom_boxplot(outlier.shape = NA,
                   #alpha = 0.2
      ) +
      labs(x = "Question", y = "Resposne", fill = "")
    
    
    
    
    
    
  })
  
  
  
  function(input, output) {
    
    # You can access the values of the widget (as a vector)
    # with input$checkGroup, e.g.
    output$value <- renderPrint({ input$checkGroup })
    
  }
  
}