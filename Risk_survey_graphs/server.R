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

raw_data <- read.csv("https://kf.kobotoolbox.org/api/v2/assets/aBuC7N2fuqWo7BkJfgHYcX/export-settings/esRMkzGooa8ZgP76sAk677o/data.csv", sep=';')
raw_data <- raw_data %>% rename( "Workshop ID"="The.facilitator.will.provide.you.with.a.workshop.ID...please.provide.it.here.")





#---BB note: Might need to tidy up your df selecting a subset of clms?








# Define server logic required to draw a histogram
function(input, output, session) {
  
  
  
  #---BB note: output$plotly1 <- renderPlotly({ }) https://plotly-r.com/controlling-tooltips.html
  
  #### this is for the dynamic drop down list
  observe({
    workshop_ID_names <- unique(raw_data$`Workshop ID`)
    
    updateSelectInput(
      session = session, 
      inputId = "workshop_ID",
      choices = workshop_ID_names,
      selected = head(workshop_ID_names, 1)
    )
  })  
  
  
  
  
  
  
  
  
  
  output$plolt1 <- renderPlot({
    
    ### manipulate data for plotting
    
    
    df_selected <- raw_data %>% select("Workshop ID" ,
                                      # "Respondant",
                                       "X.Question.2..How.risk.averse.do.you.think.you.are.when.making.a....selected...decision." ,
                                       "X.Question.3...What.balance.do.you.tend.to.have.between.intuition..gut.feel.informed.by.past.experience..and.numerical.calculation..data.driven..when.making.a....selected...decision." ,
                                       "X.Question.4..How.comfortable.are.you.with.your.decision.process..not.outcome..when.making.current....selected...decisions."  
    ) %>% 
      rename(  "Risk Aversion"                  =   "X.Question.2..How.risk.averse.do.you.think.you.are.when.making.a....selected...decision." ,
               "Intuition Vs Calculation"       =   "X.Question.3...What.balance.do.you.tend.to.have.between.intuition..gut.feel.informed.by.past.experience..and.numerical.calculation..data.driven..when.making.a....selected...decision.",
               "Comfort with Decision Process"  =   "X.Question.4..How.comfortable.are.you.with.your.decision.process..not.outcome..when.making.current....selected...decisions.")
    
    
    #---BB note: you may need to make your df long
    df_selected_wide <- df_selected %>% 
      pivot_longer(
        cols = `Risk Aversion`:`Comfort with Decision Process`,
        values_to = "score"
      )
    
    #---BB note: If you want all of the data plotted and the w/s. 
    #---BB note: You may not need this step if you just want the 1 w/s plotted or could be better ways to do this
    
    df_selected_wide_all         <- df_selected_wide %>% mutate(data_grouping = "all")
    df_selected_wide_filtered  <- df_selected_wide %>%  filter(`Workshop ID` == input$workshop_ID) %>% mutate(data_grouping = input$workshop_ID) #add the worhsop name here
    df_selected_wide_merge <- rbind(df_selected_wide_all,df_selected_wide_filtered )
    
    
    ### Make series of box plot
    
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
  
  
  
  
  
}


#### TASK TO WORK ON ###
#1. move the data manipulation step so its outside the render plot - so make it reactive
#2. get the box plot to draw on the reactive df using ()

#3. split the graphs off in to different ones.