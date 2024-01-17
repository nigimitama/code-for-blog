library(shiny)
library(shinydashboard)
library(sudoku)


# 数独のmatrixを見やすくするための処理を行なう関数 ---------------------------
SudokuForShow <- function(sudoku){
  # 問題に区切りの横棒を追加
  sudoku <- rbind(sudoku[1:3,], rep('―', ncol(sudoku)),
                  sudoku[4:6,], rep('―', ncol(sudoku)),
                  sudoku[7:9,]  )
  # 問題に区切りの縦棒を追加
  sudoku <- cbind(sudoku[,1:3], rep('|', nrow(sudoku)),
                  sudoku[,4:6], rep('|', nrow(sudoku)),
                  sudoku[,7:9]  )
  # 問題の0を削除
  sudoku <- gsub("0","",sudoku)
  # to DataFrame
  sudoku <- data.frame(sudoku)
  #colnames(sudoku) <- c((1:3),' ',(4:6),' ',(7:9)) # colnamesに数字を入れたい場合
  colnames(sudoku) <- rep(' ', ncol(sudoku))
  return(sudoku)
}


server <- function(input, output) {
  ### First tab ###
  # generate puzzle ===================================================
  # generate ---------------------------------------
  sudoku_raw <- reactive({
    # 実行のトリガーとなるinput
    input$generate
    # 数独の問題を生成
    generateSudoku()
  })
  # show --------------------------------------------
  output$sudokuPuzzle <- renderTable({
    SudokuForShow(sudoku_raw()) # print
    })
  
  
  # solve ============================================================
  # solve --------------------------------------------
  sudoku_solved <- reactive({
    solveSudoku(sudoku_raw(), verbose=F, print.it = F) # 数独の問題を解く
  })
  

  # print ---------------------------------------------
  output$sudokuAnswer <- renderTable({
    SudokuForShow(sudoku_solved()) # print
    })
  
  # 答えの非表示・表示処理 -----------------------------
  observeEvent(input$solve, {
    toggle("sudokuAnswer", anim = TRUE)
  }, ignoreNULL = FALSE)
  
  
  # Download csv ==================================================
  # Download Puzzle
  output$downloadPuzzle <- downloadHandler(
    filename = paste("sudoku", ".csv", sep = ""),
    content = function(file) {
      write.csv(sudoku_raw(), file, row.names = FALSE)
    }
  )
  # Download Answer
  output$downloadAnswer <- downloadHandler(
    filename = paste("sudokuAnswer", ".csv", sep = ""),
    content = function(file) {
      write.csv(sudoku_solved(), file, row.names = FALSE)
    }
  )
  
  
  ### Second tab ###
  # Upload csv ========================================================
  # upload -----------------------------------------
  sudoku_raw_Uploaded <- reactive({
    # 実行のトリガーとなるinput
    req(input$uploadedFile)
    # read
    sudokuUploaded <- read.csv(input$uploadedFile$datapath)
    # print
    as.matrix(sudokuUploaded)
  })
  
  # Show Puzzle -------------------------------------
  output$sudokuPuzzleUploaded <- renderTable({
    SudokuForShow(sudoku_raw_Uploaded()) # print
  })
  
  
  # solve ============================================================
  # solve --------------------------------------------
  sudoku_solved_Uploaded <- reactive({
    solveSudoku(sudoku_raw_Uploaded(), verbose=F, print.it = F) # 数独の問題を解く
  })
  
  
  # print ---------------------------------------------
  output$sudokuAnswerUploaded <- renderTable({
    SudokuForShow(sudoku_solved_Uploaded()) # print
  })
  
  # 答えの非表示・表示処理 -----------------------------
  observeEvent(input$solveUploaded, {
    toggle("sudokuAnswerUploaded", anim = TRUE)
  }, ignoreNULL = FALSE)
  
  
  # Download csv ====================================================
  # Download Answer
  output$downloadAnswerUploaded <- downloadHandler(
    filename = paste("sudokuAnswer", ".csv", sep = ""),
    content = function(file) {
      write.csv(sudoku_solved_Uploaded(), file, row.names = FALSE)
    }
  )
  

  
}
