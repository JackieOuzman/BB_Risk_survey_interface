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

#---BB note: This is where you could have a API and a download button see:https://shiny.posit.co/r/reference/shiny/0.11/downloadbutton
#---BB note: This is just info on a API https://www.dataquest.io/blog/r-api-tutorial/


#---BB note: Might need to tidy up your df selecting a subset of clms?


#---BB note: get a distinct list of w/s names this will need to be an extra step to make this reactive
#---BB note: that means it will be used as in input and then inside the add in the middle step.
#---BB note: I will show you how to do this not super easy but very doable

#### get a unique list of names from the file. I am using this to manually code the list of sites
list_of_workshop_names <- df %>% 
  distinct(`Workshop ID`)

#---BB note: work out what widget you want to use to select the w/s with https://shiny.posit.co/r/gallery/widgets/widget-gallery/







# Define server logic required to draw a histogram
function(input, output, session) {
  
  
  
  #---BB note: output$plotly1 <- renderPlotly({ }) https://plotly-r.com/controlling-tooltips.html
  
  
  output$plolt1 <- renderPlot({
    
    
    
    
    #---BB note: subset the data and rename some clms - you may not need this step 
    df_selected <- df %>% select("Workshop ID" ,
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
    
    #---BB note: If you want all of the data plotted and the w/s. 
    #---BB note: You may not need this step if you just want the 1 w/s plotted or could be better ways to do this
    
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