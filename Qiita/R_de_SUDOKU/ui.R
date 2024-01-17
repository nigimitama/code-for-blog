
library(shiny)
library(shinydashboard)
library(shinyjs) # 非表示処理のためのshinyjs

# header
header <- dashboardHeader(title = "R de SUDOKU")

# sidebar
sidebar <- dashboardSidebar(disable = F,
                            sidebarMenu(
                              menuItem("Generate Puzzle", tabName = "GeneratePuzzle", icon = icon("th")),
                              menuItem("Upload Puzzle", tabName = "UploadPuzzle", icon = icon("upload"))
                            )
)

# body
body <- dashboardBody(
  useShinyjs(), # 非表示処理のためのshinyjs
  tabItems(
    # First tab content =========================================================================
    tabItem(tabName = "GeneratePuzzle",
            fluidRow(
              # main panel
              
              column(width = 8,
                     box(width = NULL, status = "warning", 
                         helpText("Puzzle"),
                         tableOutput("sudokuPuzzle")
                     ),
                     box(width = NULL, status = "warning", 
                         helpText("Answer (solve by R)"),
                         tableOutput('sudokuAnswer')
                     )
              ),
              # side panel
              column(width = 4,
                     box(width = NULL, solidHeader = TRUE, 
                         actionButton("generate", "Generate a New Puzzle")
                     ),
                     box(width = NULL, solidHeader = TRUE, 
                         actionButton("solve", "Show/Hide Answer")
                     ),
                     box(width = NULL, solidHeader = TRUE, 
                         helpText("Download sudoku matrix (.csv)"),
                         downloadButton("downloadPuzzle", "Download"),
                         downloadButton("downloadAnswer", "Download (Answer)")
                     )
              )
              
              
            )
    ),
    # Second tab content =========================================================================
    tabItem(tabName = "UploadPuzzle",
            fluidRow(
              # main panel
              column(width = 8,
                     box(width = NULL, 
                         helpText("Puzzle"),
                         tableOutput("sudokuPuzzleUploaded")
                     ),
                     box(width = NULL, 
                         helpText("Answer (solve by R)"),
                         tableOutput('sudokuAnswerUploaded')
                     )
              ),
              # side panel -----------------------------------------------
              column(width = 4,
                     box(width = NULL, solidHeader = TRUE, 
                         helpText("Upload sudoku matrix (.csv)"),
                         fileInput("uploadedFile", "Choose CSV File",
                                   accept = c("text/csv",
                                              "text/comma-separated-values,text/plain",
                                              ".csv"))
                     ),
                     box(width = NULL, solidHeader = TRUE,
                         actionButton("solveUploaded", "Show/Hide Answer")
                     ),
                     box(width = NULL, solidHeader = TRUE,
                         helpText("Download sudoku matrix (.csv)"),
                         downloadButton("downloadAnswerUploaded", "Download (Answer)")
                     )
                     
                     
              )
            )
    )
  )
)

# ページの構成
dashboardPage(
  header,
  sidebar,
  body
)