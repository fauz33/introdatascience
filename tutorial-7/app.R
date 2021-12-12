#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)

df <- as.data.frame(VADeaths)
# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Death Rates in Virginia (1940)"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("category", "Category", choices = names(df)),
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("data")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  data <- reactive(df %>%
                     select(.data[[input$category]]))
  
  output$data <- renderPlot({
    barplot( df[[input$category]],main = "Death Rates in Virginia",
             xlab = "Age", ylab = "Rate",ylim = c(0, 100),names.arg=rownames(df))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

