library(ggplot2)
library(leaflet)
library(dplyr)
library(shinydashboard)
library(scales)

server <- function(input, output){
  #年齢層の選択
  selectdata <- reactive({
    df <- data.frame('都道府県' = jpn.census$prefecture,
                     'data' = jpn.census[, input$data]  )
  })
  

  #地図:mymap
  output$mymap <- renderLeaflet({
    pal <- colorNumeric("Blues", domain = jpn.census[, input$data], reverse=F)
    
    # マウスオーバー時の表示内容を設定（sprintf()で実数表記など指定）
    labels <- sprintf("<strong>%s</strong><br/>%5.1f",
                      paste0(jpn.shp@data$NL_NAME_1),
                      jpn.census[, input$data]) %>% lapply(htmltools::HTML)
    
    # 地図にプロット
    jpn.shp %>% 
      leaflet() %>% 
      # setView() : 地図を日本にズームした状態で表示する
      setView(lat=39, lng=139, zoom=5) %>% 
      # addProviderTiles() : 背景のタイルを指定
      addProviderTiles(providers$CartoDB.Positron) %>% 
      # addPolygons() : 塗り分け地図の描画
      addPolygons(fillOpacity = 0.5,
                  weight=1,
                  fillColor = ~pal(jpn.census[, input$data]),
                  label = labels,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto"),
                  highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE)) %>% 
      # addLegend() : 凡例の設定
      addLegend("bottomright", pal = pal, values = ~jpn.census[, input$data],
                title = input$data)

    
      })
  
  #グラフ:graph
  windowsFonts('Yu'=windowsFont('游ゴシック')) #フォントを指定
  output$graph <- renderPlot({
    # reorder()によって自動的に順に並べ替える
    g <- ggplot(selectdata(), aes(x = reorder(x = 都道府県, X = -data, FUN = mean),
                                  y = data)) +
      geom_bar(width = 0.8, stat = 'identity', fill='steelblue') +
      theme_bw(base_family = 'Yu') + 
      ylab(input$data) + xlab('都道府県') +
      scale_y_continuous(labels = scales::comma) + #Y軸を浮動小数点表記しない
      theme(axis.text.x = element_text(angle = 90,hjust = 1)) #X軸目盛りを縦に
    plot(g)
  })

}


