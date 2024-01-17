library(shinydashboard)
library(ggplot2)
library(leaflet)

header <- dashboardHeader(
  title = "コロプレス図"
)


body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("mymap", height = 500) #leaflet
           ),
           box(width = NULL,
               plotOutput("graph", height = 300) #グラフ
           )
    ),
    column(width = 3,
           box(width = NULL, status = "warning",
               selectInput('data', 'データを選択', choices = col_choice, width = 600)
               )
           )
    )
  )

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)
