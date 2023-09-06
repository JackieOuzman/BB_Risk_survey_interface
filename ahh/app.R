library(shiny)
library(dplyr)

raw_data <-  read_excel("C:/Users/ouz001/working_from_home_post_Sep2022/BB_Risk/Copy of Overview of Snapshot Survey for RiskWise SYD meeting.xlsx",
  sheet = "Data")

ui <- fluidPage(
  
  selectInput("workshop_ID", label = h3("List of workshops"), choices = raw_data$`workshop ID`,selected = raw_data$`workshop ID`[1])
  )
  
  
  

server <- function(input, output, session) {
  
 
   observe({
     workshop_ID_names <- unique(raw_data$`Workshop ID`)
    
    updateSelectInput(
      session = session, 
      inputId = "workshop_ID",
      choices = workshop_ID_names,
      selected = head(workshop_ID_names, 1)
    )
  })  
  
} #server bracket
shinyApp(ui = ui, server = server)