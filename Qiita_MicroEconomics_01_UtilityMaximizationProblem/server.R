library(shinydashboard)
library(shiny)
library(Rsolnp)

# サーバロジックの定義
shinyServer(function(input, output) {
  
  # 予算制約式box見出し
  output$budgettext <- renderUI({
    withMathJax(helpText("予算制約と価格の設定$$p_1 x_1 + p_2 x_2 \\leq B$$"))
  })
  #指定された予算をTeXでUIに表示
  output$budgetform <- renderUI({
    withMathJax(helpText(paste0('指定された予算制約式:$$',
                                input$p_1,'x_1 + ', input$p_2,'x_2',
                                '\\leq',input$budget,'$$')))
  })
  
  
  # 効用関数box見出し
  output$utilityfunctiontext <- renderUI({
    withMathJax(helpText('効用関数のパラメータを設定$$U(x_1,x_2)=a x_1^ \\frac{c}{d} b x_2^ \\frac{e}{f}$$'))
  })
  #指定された効用関数をTeXでUIに表示
  output$utilityfunction <- renderUI({
    withMathJax(helpText(paste0('指定された効用関数:$$U(x_1,x_2)=',
                              input$a,'x_1','^\\frac{',input$c,'}','{',input$d,'}', input$b,'x_2','^\\frac{',input$e,'}','{',input$f,'}','$$')))
  })
  
  
  #設定された効用最大化問題
  output$Utilitymaximizationproblem <- renderUI({
    withMathJax(helpText(paste0(
      '設定された効用最大化問題:',

      '$$ \\max_{x_1,x_2} \\hspace{1em}  U(x_1,x_2)=',input$a,'x_1','^\\frac{',input$c,'}','{',input$d,'}', input$b,'x_2','^\\frac{',input$e,'}','{',input$f,'}$$',
      
      '$$s.t. \\hspace{1em} ', input$p_1,'x_1 + ', input$p_2,'x_2 = ',input$budget,'$$'
      )))
  })
  
  
  #最適消費計画の解
  output$maxutility <- renderUI({
    
    ObjFunc = function(x) return( - input$a * x[1]^(input$c/input$d) * input$b * x[2]^(input$e/input$f) ) #目的関数
    #solnp()は最小化をするようになっているので，目的関数にマイナスを掛ける
    ConstFunc = function(x) return( x[1]* input$p_1 + x[2] * input$p_2 ) #制約式の右辺
    eq.value <- c(input$budget) #制約式の左辺
    x0 <- c(1,1) #決定変数を初期化
    
    solution <- solnp(x0, fun = ObjFunc, eqfun = ConstFunc, eqB = eq.value )
    
    #return
    withMathJax(helpText(paste0("効用を最大化する消費量:",
                                '$$x_{1}^*=',solution$pars[1],', \\hspace{1em}  x_{2}^*=',solution$pars[2],'$$')))
  })
  
  
  #無差別曲線と予算制約線と最適消費点
  output$indifferencecurve <- renderUI({
    withMathJax(helpText('無差別曲線と予算制約線と最適消費点'))
  })
  output$Plot2D <- renderPlot({
    #以下のreactiveな要素をrenderPlotに入れれば使えるっぽい
    #効用関数をfunctionの形で定義
    u <- function(x_1,x_2) {input$a * x_1 ^ (input$c/input$d) * input$b * x_2 ^ (input$e/input$f)} #効用関数を定義
    
    #xの範囲指定
    x_1 <- 1:input$range
    x_2 <- 1:input$range
    U <- outer(x_1, x_2, u) #outer()はx_1,x_2に対応したf(x_1,x_2)の値を行列で返す
    
    #plot
    par(mar=c(3,3,1,1))
    contour(x_1, x_2, U, method = "edge", labcex = 1,lwd = 2)
    abline(a = input$budget/input$p_2, b = -input$p_1/input$p_2, lwd = 2, col = "blue") #予算制約線 x_2 = ...
    
    #最適消費点
    ObjFunc = function(x) return( - input$a * x[1]^(input$c/input$d) * input$b * x[2]^(input$e/input$f) ) #目的関数
    #solnp()は最小化をするようになっているので，目的関数にマイナスを掛ける
    ConstFunc = function(x) return( x[1]* input$p_1 + x[2] * input$p_2 ) #制約式の右辺
    eq.value <- c(input$budget) #制約式の左辺
    x0 <- c(1,1) #決定変数を初期化
    solution <- solnp(x0, fun = ObjFunc, eqfun = ConstFunc, eqB = eq.value )
    points(x = solution$pars[1], y = solution$pars[2], lwd = 3, col = "darkblue", pch = 16) #最適消費点
    
  })
  
  
  #3D plot of utility function 効用関数の3次元図
  output$Plot3Dtext <- renderUI({
    withMathJax(helpText('効用関数の3次元図'))
  })
  output$Plot3D <- renderPlot({
    
    #以下のreactiveな要素をrenderPlotに入れれば使えるっぽい
    #効用関数をfunctionの形で定義
    u <- function(x_1,x_2) {input$a * x_1 ^ (input$c/input$d) * input$b * x_2 ^ (input$e/input$f)} #効用関数を定義
    
    #xの範囲指定
    x_1 <- 1:input$range
    x_2 <- 1:input$range
    U <- outer(x_1, x_2, u) #outer()はx_1,x_2に対応したf(x_1,x_2)の値を行列で返す
    
    persp(x_1, x_2, U,
          theta = 30, # 横回転の角度。ここをいじって表示のアングルを変える。
          phi = 20, # 縦回転の角度。ここをいじって表示のアングルを変える。
          ticktype = "simple", # 線の種類
          lwd = 0.5, # 線が太いと見づらかったりするので0.5にしておいた。
          col = F, #塗りつぶしなし
          border = 8 #枠線灰色
          )

  })
  
  
  
  
})

