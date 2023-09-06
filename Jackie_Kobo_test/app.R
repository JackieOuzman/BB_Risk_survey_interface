library(shiny)
library(dplyr)

#some helpful notes
#https://sparkbyexamples.com/r-programming/read-csv-from-url-in-r/
#https://www.r-bloggers.com/2022/03/how-to-download-kobotoolbox-data-in-r/


## ok this sort of works, but now we have a naming problem



# raw_data <-  read_excel("C:/Users/ouz001/working_from_home_post_Sep2022/BB_Risk/Copy of Overview of Snapshot Survey for RiskWise SYD meeting.xlsx",
#   sheet = "Data")

raw_data <- read.csv("https://kf.kobotoolbox.org/api/v2/assets/aBuC7N2fuqWo7BkJfgHYcX/export-settings/esRMkzGooa8ZgP76sAk677o/data.csv", sep=';')

#select a few clm and rename them

raw_data <- raw_data %>% select("The.facilitator.will.provide.you.with.a.workshop.ID...please.provide.it.here." ) %>% 
  rename(`Workshop ID`= "The.facilitator.will.provide.you.with.a.workshop.ID...please.provide.it.here.")
#convert to upper case
raw_data$`Workshop ID` <- toupper(raw_data$`Workshop ID`)

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