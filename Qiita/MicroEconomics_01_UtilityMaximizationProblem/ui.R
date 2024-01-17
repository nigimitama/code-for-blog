

# 日本語の文字列が本文中にあるとdeployできないみたい
# server側のRenderUI内の日本語は問題ないのでコレを利用

library(shinydashboard)
library(shiny)
library(Rsolnp)

header <- dashboardHeader(
  title = "Utility maximization problem"
)

body <- dashboardBody(
    column(width = 3,
           #予算制約
           box(width = NULL,
               uiOutput('budgettext'),
               numericInput("budget", 
                            label = "$$B$$", 
                            value = 100),
               numericInput("p_1", 
                            label = "$$p_1$$", 
                            value = 2),
               numericInput("p_2", 
                            label = "$$p_2$$", 
                            value = 2),
               uiOutput("budgetform")
              
           ),
           
           box(width = NULL, 
               #効用関数モジュール
               uiOutput('utilityfunctiontext'),
               withMathJax(),   #TeX表記有効化
               numericInput("a", 
                            label = "$$a$$", 
                            value = 1),
               numericInput("b", 
                            label = "$$b$$", 
                            value = 1),
               numericInput("c", 
                            label = "$$c$$", 
                            value = 1),
               numericInput("d", 
                            label = "$$d$$", 
                            value = 2),
               numericInput("e", 
                            label = "$$e$$", 
                            value = 1),
               numericInput("f", 
                            label = "$$f$$", 
                            value = 2),
               uiOutput("utilityfunction")
               ),
           box(width = NULL,
               #p("変数の範囲（描画範囲）"),
               numericInput("range", 
                            label =  "range of graph", 
                            value = 50)
               )
    ),
    fluidRow(
      column(width = 7,
             #設定された効用最大化問題
             box(width = NULL,
                 uiOutput("Utilitymaximizationproblem")
             ),
             #効用最大化問題の解
             box(width = NULL, status = "warning",
                 uiOutput("maxutility")
                 ),
             #無差別曲線
             box(width = NULL, solidHeader = TRUE,
                 uiOutput('indifferencecurve'),
                 plotOutput("Plot2D", width = 300, height = 300)
                 ),
             box(width = NULL, solidHeader = TRUE,
                 uiOutput('Plot3Dtext'),
                 plotOutput("Plot3D",height = 300)
                 )
             )
      )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)
