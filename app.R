library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(datasets)
library(wordcloud)
library(babynames)
library(ISLR)

ui <- dashboardPage(skin = 'green', 
                    dashboardHeader(title = "DataViz", titleWidth = 300),
                    dashboardSidebar(width = 300,
                                     sidebarMenu(
                                       id = "tabs",
                                       menuItem(tabName = "home", icon = icon("circle-info"), 
                                                tags$span("Sobre o app")),
                                       menuItem(tabName = "numerico", icon = icon("chart-line"),
                                                tags$span("Numérico"),
                                                menuSubItem("Uma variável",
                                                            tabName = "subMenu1"),
                                                menuSubItem("Duas variáveis",
                                                            tabName = "subMenu2")),
                                       menuItem(tabName = "categorico", icon = icon("chart-bar"),
                                                tags$span("Categórico"),
                                                menuSubItem("Uma variável",
                                                            tabName = "subMenu3"),
                                                menuSubItem("Duas variáveis",
                                                            tabName = "subMenu4")),
                                       menuItem(tabName = "numerico_categorico", icon = icon("chart-pie"),
                                                tags$span("Numérico & Categórico"), 
                                                menuSubItem("Uma variável num. e uma variável cat.",
                                                            tabName = "subMenu5"),
                                                menuSubItem("Uma variável num. e muitas categóricas",
                                                            tabName = "subMenu6"),
                                                menuSubItem("Uma variável cat. e muitas numéricas",
                                                            tabName = "subMenu7")),
                                       tags$div(
                                         style = "position: absolute; 
                                         bottom: 0; 
                                         width: 100%; 
                                         padding: 10px; 
                                         color: #B2BEC4;
                                         background: #242D31;
                                         font-family: 'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif';
                                         font-weight: regular;
                                         font-size: 14px;",
                                         p('Desenvolvido por: Raquel Rossi Ferreira'),
                                         p('Todos os direitos reservados.'), 
                                         p("Contato: raquelderossi@hotmail.com"))
                                     )),
                    
                    dashboardBody(
                      tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Roboto Slab", "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-weight: bold;
        font-size: 24px;
      }
      
      .sidebar  span {
        font-family: "Montserrat", "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-weight: regular;
        font-size: 16px;
      }
      
      .custom-box {
        background-color: #fff;
        #border: 1px solid #ccc;
        margin-bottom: 20px;
      }
    
      .title-home {
        font-family: "Roboto Slab", "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-weight: regular;
        font-size: 20px;
        color: #1F0E65;
        padding-top: 20px;
        padding-left: 20px;
        padding-bottom: 10px;
      }
      
      .text-home {
        font-family: "Montserrat", "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-weight: regular;
        font-size: 16px;
        color: #4A4040;
        padding-bottom: 10px;
        padding-left: 20px;
        padding-right: 20px;
      }
      
      .choice {
        font-family: "Roboto Slab", "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-weight: bold;
        font-size: 16px;
        color: #1F0E65;
        padding-top: 20px;
      }
      
       .sidebar .treeview-menu > .active > a {
        background-color: #2A5736;
        color: #1F0E65;
        font-weight: bold;
       }
       
       .title-tab {
        font-family: "Roboto Slab", "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-weight: regular;
        font-size: 20px;
        color: #4a7da5;
        padding-left: 10px;
       }
      
      .text-home a {
        font-family: "Montserrat", "Helvetica Neue", Helvetica, Arial, sans-serif;
        font-weight: regular;
        font-size: 16px;
        color: #4A4040;
        padding-left: 10px;
        padding-right: 10px;
        text-decoration: none; 
      }
      
      .text-home a:hover {
        color: #F2A93B;
      }
      
      '))),
                      tabItems(
                         tabItem(tabName = "home",
                                 fluidRow(tags$div(class = "custom-box",
                                          box( width = 8, solidHeader = TRUE,tags$div(class = "title-home", "App DataViz"), 
                                          br(), 
                                          tags$div(class = "text-home", style="text-align: justify",
                                          tags$p("O aplicativo DataViz simplifica a visualização de dados de acordo com a 
                                                                             escolha de tipo de variável: Numérico, Categórico ou Numérico-Categórico."), 
                                          tags$p("Utilizar o app é muito simples: Basta selecionar ao lado o tipo de dado que 
                                                      você esteja analisando, a quantidade e clicar no botão 'Gráfico!' para ser 
                                                      direcionado para a aba com as informações sobre a melhor visualização gráfica.")),
                                         tags$div(class = "title-home", "Exemplos de tipos de dados"), 
                                              br(), 
                                              tags$div(class = "text-home", style="text-align: justify",
                                                                            tags$p(tags$b("Dados numéricos"), "são valores que representam quantidades ou medidas. É possível fazer operações matemáticas com eles (somar, subtrair, etc.)."), 
                                                                            tags$p("- Idade, altura, renda mensal, temperatura, preço de produto."), 
                                                                            tags$p(tags$b("Dados categóricos"), "representam categorias ou grupos. Podem ser palavras ou números, mas não se pode fazer operações matemáticas com eles."),
                                                                            tags$p("- Gênero, cor dos olhos, nível de escolaridade, categorias de produtos."),
                                                                            tags$p(tags$b("Se estiver analisando apenas duas variáveis númericas fique atento a variável do eixo x, pois existem gráficos para dados não ordenados e ordenados.")))),
                                         box(width = 4, solidHeader = TRUE, tags$div(class = "title-home", 
                                                                                     tags$span("Tipos de dados", style = "font-size: 20px;"),
                                                                                     selectInput("dashboard_variavel1", 
                                                                                                 tags$div(class = "choice", "Escolha uma opção:"),
                                                                                                 choices = c("Numérico", "Categórico", "Numérico & Categórico"),
                                                                                                 selectize = FALSE),
                                                                                     uiOutput("variavel_options"),
                                         ),
                                          actionButton("dashboard_switchTabs", "Gráfico!", 
                                                       style="background-color: #1F0E65;
                                                           color: #ffff;
                                                           font-family: 'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif';
                                                           font-weight: bold;
                                                           font-size: 16px;
                                                           margin-left: 20px;"))),
                                 )),
                                
                        tabItem(tabName = "numerico"),
                        tabItem(tabName = "subMenu1",
                                fluidRow(
                                  div(
                                    class = "text-center", width = 8,
                                    actionButton("redirect_home", "Voltar para Home", 
                                                 style="background-color: #1F0E65;
                                color: #fff;
                                font-family: 'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif';
                                font-weight: bold;
                                font-size: 16px;
                                margin-bottom: 20px;"),
                                  ),
                                ),
                                tabBox(
                                  id = "tabset1", width = "550px", 
                                  tabPanel("Densidade", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("densityPlot")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um gráfico de densidade mostra a distribuição de uma variável numérica. 
                                                            Leva apenas variáveis numéricas como entrada e é uma versão suavizada do histograma."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Brinque com a largura de banda (bandwidth), pode levar a conclusões muito diferentes."),
                                                             tags$p("- Não compare mais de 3 grupos no mesmo gráfico de densidade. O gráfico fica confuso e dificilmente compreensível. Em vez disso, use um gráfico boxplot."),
                                                             tags$p("- Evite preencher com várias cores. Cores são úteis para demonstrar grupos e destacar um item específico na visualização.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/densidade.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/densidade.py", target="_blank", "Python"))
                                             )
                                           )
                                  ), 
                                  tabPanel("Histograma", style="text-align: justify",
                                              fluidRow(
                                                column(width = 6,  plotOutput("histogramPlot")),
                                                column(width = 6,
                                                       tags$div(
                                                         tags$div(class = "title-tab", "Sobre"), 
                                                         br(),
                                                         tags$div(class = "text-home", tags$p("Um histograma recebe como entrada apenas variáveis numéricas. 
                                                         A variável é dividida em vários compartimentos, e o número de observações por compartimento é representado pela altura da barra."))),
                                                       tags$div(class = "title-tab", "Dicas"), 
                                                       br(),
                                                       tags$div(class = "text-home", tags$p("- Não confunda com o gráfico de barras. Um gráfico de barras fornece um valor para cada grupo de uma 
                                                                variável categórica. Aqui temos apenas uma variável numérica e verificamos sua distribuição."),
                                                                tags$p("- Não mostre a distribuição de mais de 5 variáveis, para isso use o gráfico boxplot."),
                                                                tags$p("- Evite preencher com várias cores. Cores são úteis para demonstrar grupos e destacar um item específico na visualização.")),
                                                       tags$div(class = "title-tab", "Códigos"), 
                                                       br(),
                                                       tags$div(class = "text-home", 
                                                                tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/histograma.R", target="_blank", "R"),
                                                                br(),
                                                                tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/histograma.py", target="_blank", "Python"),
                                                                br(),
                                                                tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/histograma.md", target="_blank", "Outras plataformas"))
                                                )
                                              )))
                          
                                
                        ),
                        tabItem(tabName = "subMenu2",
                                fluidRow(
                                  div(
                                    class = "text-center", width = 8,
                                    actionButton("redirect_home2", "Voltar para Home", 
                                                 style="background-color: #1F0E65;
                                color: #fff;
                                font-family: 'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif';
                                font-weight: bold;
                                font-size: 16px;
                                margin-bottom: 20px;"),
                                  ),
                                ),
                                tabBox(title= "Dados não ordenados",
                                  id = "tabset1", width = "550px", 
                                  tabPanel("Densidade", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("densityPlot2")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um gráfico de densidade mostra a distribuição de uma variável numérica. 
                                                            Leva apenas variáveis numéricas como entrada e é uma versão suavizada do histograma."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Brinque com a largura de banda (bandwidth), pode levar a conclusões muito diferentes."),
                                                             tags$p("- Não compare mais de 3 grupos no mesmo gráfico de densidade. O gráfico fica confuso e dificilmente compreensível. Em vez disso, use um gráfico boxplot."),
                                                             tags$p("- Evite preencher com várias cores. Cores são úteis para demonstrar grupos e destacar um item específico na visualização.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/densidade2.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/densidade2.py", target="_blank", "Python"))
                                             )
                                           )
                                  ), 
                                  tabPanel("Dispersão", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("scatterPlot")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um gráfico de dispersão exibe a relação entre 2 variáveis numéricas. 
                                                      Para cada ponto de dados, o valor da sua primeira variável é representado no eixo X, o segundo no eixo Y."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Quando o seu conjunto de dados é grande, os pontos do seu gráfico de dispersão tendem a se sobrepor, tornando o gráfico ilegível.
                                                    A solução mais fácil é provavelmente reduzir o tamanho do ponto."),
                                                             tags$p("- Não se esqueça de mostrar subgrupos, se tiver algum. Pode revelar importantes padrões ocultos nos seus dados.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/dispersao.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/dispersao.py", target="_blank", "Python"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/dispersao.md", target="_blank", "Outras plataformas"))
                                             )
                                           )),
                                  tabPanel("Histograma", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("histogramPlot2")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um histograma recebe como entrada apenas variáveis numéricas. 
                                                         A variável é dividida em vários compartimentos, e o número de observações por compartimento é representado pela altura da barra."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Não confunda com o gráfico de barras. Um gráfico de barras fornece um valor para cada grupo de uma 
                                                                variável categórica. Aqui temos apenas uma variável numérica e verificamos sua distribuição."),
                                                             tags$p("- Não mostre a distribuição de mais de 5 variáveis, para isso use o gráfico boxplot."),
                                                             tags$p("- Evite preencher com várias cores. Cores são úteis para demonstrar grupos e destacar um item específico na visualização.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/histograma2.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/histograma2.py", target="_blank", "Python"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/histograma.md", target="_blank", "Outras plataformas"))
                                             )
                                           ))
                                  
                                  ),
                                tabBox(title= "Dados ordenados",
                                       id = "tabset1", width = "550px", 
                                       tabPanel("Área", style="text-align: justify",
                                                fluidRow(
                                                  column(width = 6,  plotOutput("areaPlot")),
                                                  column(width = 6,
                                                         tags$div(
                                                           tags$div(class = "title-tab", "Sobre"), 
                                                           br(),
                                                           tags$div(class = "text-home", tags$p("Um gráfico de área é muito semelhante a um gráfico de linhas e representa a evolução de uma variável 
                                                           numérica. Basicamente, o eixo X representa o tempo ou uma variável ordenada, e o eixo Y fornece o valor de outra variável. Os pontos de dados são 
                                                           conectados por segmentos de linha reta e a área entre o eixo X e a linha é preenchida com cor ou sombreamento."))),
                                                         tags$div(class = "title-tab", "Dicas"), 
                                                         br(),
                                                         tags$div(class = "text-home", tags$p("- Usar a mesma cor para a linha e o preenchimento com mais transparência geralmente dá uma aparência bonita.")),
                                                         tags$div(class = "title-tab", "Códigos"), 
                                                         br(),
                                                         tags$div(class = "text-home", 
                                                                  tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/area.R", target="_blank", "R"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/area.py", target="_blank", "Python"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/area.md", target="_blank", "Outras plataformas"))
                                                  )
                                                )
                                       ), 
                                       tabPanel("Dispersão conectado", style="text-align: justify",
                                                fluidRow(
                                                  column(width = 6,  plotOutput("scattercPlot")),
                                                  column(width = 6,
                                                         tags$div(
                                                           tags$div(class = "title-tab", "Sobre"), 
                                                           br(),
                                                           tags$div(class = "text-home", tags$p("Um gráfico de dispersão conectado exibe a evolução de uma variável numérica. 
                                                           Os pontos de dados são representados por um ponto e conectados por segmentos de linha reta. Muitas vezes mostra uma tendência 
                                                           nos dados ao longo de intervalos de tempo."))),
                                                         tags$div(class = "title-tab", "Dicas"), 
                                                         br(),
                                                         tags$div(class = "text-home", tags$p("- Quando o seu conjunto de dados é grande, os pontos do seu gráfico de dispersão tendem a se sobrepor, tornando o gráfico ilegível.
                                                          A solução mais fácil é provavelmente reduzir o tamanho do ponto.")),
                                                         tags$div(class = "title-tab", "Códigos"), 
                                                         br(),
                                                         tags$div(class = "text-home", 
                                                                  tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/dispersao_conectado.R", target="_blank", "R"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/dispersao_conectado.py", target="_blank", "Python"))
                                                  )
                                                )
                                       ), 
                                       tabPanel("Linha", style="text-align: justify",
                                                fluidRow(
                                                  column(width = 6,  plotOutput("linePlot")),
                                                  column(width = 6,
                                                         tags$div(
                                                           tags$div(class = "title-tab", "Sobre"), 
                                                           br(),
                                                           tags$div(class = "text-home", tags$p("Um gráfico de linhas exibe a evolução de uma ou várias variáveis numéricas. 
                                                           Os pontos de dados são conectados por segmentos de linha reta. É semelhante a um gráfico de dispersão, exceto que os pontos de medição 
                                                           são ordenados e unidos com segmentos de linha reta."))),
                                                         tags$div(class = "title-tab", "Dicas"), 
                                                         br(),
                                                         tags$div(class = "text-home", tags$p("- Muitas linhas tornam o gráfico ilegível.")),
                                                         tags$div(class = "title-tab", "Códigos"), 
                                                         br(),
                                                         tags$div(class = "text-home", 
                                                                  tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/linha.R", target="_blank", "R"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/linha.py", target="_blank", "Python"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/linha.md", target="_blank", "Outras plataformas"))
                                                  )
                                                ))
                                       
                                )
                              
                        ),
                        tabItem(tabName = "categorico"),
                        tabItem(tabName = "subMenu3",
                                fluidRow(
                                  div(
                                    class = "text-center", width = 8,
                                    actionButton("redirect_home3", "Voltar para Home", 
                                                 style="background-color: #1F0E65;
                                color: #fff;
                                font-family: 'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif';
                                font-weight: bold;
                                font-size: 16px;
                                margin-bottom: 20px;"),
                                  ),
                                ),
                                tabBox(
                                  id = "tabset1", width = "550px", 
                                  tabPanel("Barras", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("barPlot")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um gráfico de barras mostra a relação entre uma variável numérica e uma variável categórica. 
                                                      Cada entidade da variável categórica é representada como uma barra. O tamanho da barra representa seu valor numérico."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Não confunda isso com um histograma."),
                                                             tags$p("- Rótulos longos? Faça uma versão horizontal do gráfico."),
                                                             tags$p("- Se os níveis da sua variável categórica não tiverem uma ordem óbvia, ordene as barras seguindo seus valores.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/barras.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/barras.py", target="_blank", "Python"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/barras.md", target="_blank", "Outras plataformas"))
                                             )
                                           )
                                  ), 
                                  tabPanel("Nuvem de palavras", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("cloudPlot")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Uma nuvem de palavras exibe uma lista de palavras, sendo a importância de 
                                                      cada uma mostrada com tamanho ou cor da fonte."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Palavras longas terão mais destaque na imagem, independentemente da sua ocorrência."),
                                                             tags$p("- Útil apenas se o tamanho da amostra for enorme.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/nuvem.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/nuvem.py", target="_blank", "Python"))
                                             )
                                           )),
                                  tabPanel("Pirulito", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("loliPlot")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um gráfico de pirulito é basicamente um gráfico de barras, onde a barra é transformada em 
                                                      uma linha e um ponto. Ele mostra a relação entre uma variável numérica e uma variável categórica."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Se os níveis da sua variável categórica não tiverem uma ordem óbvia, ordene as barras seguindo seus valores.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/pirulito.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/pirulito.py", target="_blank", "Python"))
                                             )
                                           ))
                                  )
                        ),
                        tabItem(tabName = "subMenu4",
                                fluidRow(
                                  div(
                                    class = "text-center", width = 8,
                                    actionButton("redirect_home4", "Voltar para Home", 
                                                 style="background-color: #1F0E65;
                                color: #fff;
                                font-family: 'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif';
                                font-weight: bold;
                                font-size: 16px;
                                margin-bottom: 20px;"),
                                  ),
                                ),
                                tabBox(
                                  id = "tabset1", width = "550px", 
                                  tabPanel("Barras agrupadas", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("groupPlot")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um gráfico de barras exibe o valor de uma variável numérica para diversas entidades. 
                                                      Essas entidades podem ser agrupadas usando uma variável categórica, resultando em um gráfico de barras agrupado."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Não confunda isso com um histograma."),
                                                             tags$p("- Rótulos longos? Faça uma versão horizontal do gráfico."),
                                                             tags$p("- Se os níveis da sua variável categórica não tiverem uma ordem óbvia, ordene as barras seguindo seus valores.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/barras_agrupadas.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/barras_agrupadas.py", target="_blank", "Python"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/barras_agrupadas.md", target="_blank", "Outras plataformas"))
                                             )
                                           )
                                  ), 
                                  tabPanel("Mapa de calor", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("mapPlot")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um mapa de calor é uma representação gráfica de dados onde os valores individuais 
                                                              contidos em uma matriz são representados como cores."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Muitas vezes é necessário normalizar seus dados."),
                                                             tags$p("- Utilizar análise de cluster e assim permutar as linhas e colunas da matriz para 
                                                              colocar valores semelhantes próximos uns dos outros de acordo com o agrupamento.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/mapa.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/mapa.py", target="_blank", "Python"))
                                             )
                                           ))
                                )),
                        tabItem(tabName = "numerico_categorico"), 
                        tabItem(tabName = "subMenu5",
                                fluidRow(
                                  div(
                                    class = "text-center", width = 8,
                                    actionButton("redirect_home5", "Voltar para Home", 
                                                 style="background-color: #1F0E65;
                                color: #fff;
                                font-family: 'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif';
                                font-weight: bold;
                                font-size: 16px;
                                margin-bottom: 20px;"),
                                  ),
                                ),
                                tabBox(
                                       id = "tabset1", width = "550px", 
                                       tabPanel("Boxplot", style="text-align: justify",
                                                fluidRow(
                                                  column(width = 6,  plotOutput("boxPlot")),
                                                  column(width = 6,
                                                         tags$div(
                                                           tags$div(class = "title-tab", "Sobre"), 
                                                           br(),
                                                           tags$div(class = "text-home", tags$p("Um boxplot fornece um bom resumo de uma ou várias variáveis numéricas. 
                                                      A linha que divide a caixa em 2 partes representa a mediana dos dados. O final da caixa mostra os quartis superior 
                                                      e inferior. As linhas extremas mostram o valor mais alto e mais baixo, excluindo valores discrepantes."))),
                                                         tags$div(class = "title-tab", "Dicas"), 
                                                         br(),
                                                         tags$div(class = "text-home", tags$p("- Ordenar seu boxplot por mediana pode torná-lo mais esclarecedor.")),
                                                         tags$div(class = "title-tab", "Códigos"), 
                                                         br(),
                                                         tags$div(class = "text-home", 
                                                                  tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/boxplot.R", target="_blank", "R"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/boxplot.py", target="_blank", "Python"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/boxplot.md", target="_blank", "Outras plataformas"))
                                                  )
                                                )
                                       ),
                                       tabPanel("Densidade", style="text-align: justify",
                                                fluidRow(
                                                  column(width = 6,  plotOutput("densityPlot3")),
                                                  column(width = 6,
                                                         tags$div(
                                                           tags$div(class = "title-tab", "Sobre"), 
                                                           br(),
                                                           tags$div(class = "text-home", tags$p("Um gráfico de densidade mostra a distribuição de uma variável numérica. 
                                                            Leva apenas variáveis numéricas como entrada e é uma versão suavizada do histograma."))),
                                                         tags$div(class = "title-tab", "Dicas"), 
                                                         br(),
                                                         tags$div(class = "text-home", tags$p("- Brinque com a largura de banda (bandwidth), pode levar a conclusões muito diferentes."),
                                                                  tags$p("- Não compare mais de 3 grupos no mesmo gráfico de densidade. O gráfico fica confuso e dificilmente compreensível. Em vez disso, use um gráfico boxplot."),
                                                                  tags$p("- Evite preencher com várias cores. Cores são úteis para demonstrar grupos e destacar um item específico na visualização.")),
                                                         tags$div(class = "title-tab", "Códigos"), 
                                                         br(),
                                                         tags$div(class = "text-home", 
                                                                  tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/densidade3.R", target="_blank", "R"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/densidade3.py", target="_blank", "Python"))
                                                  )
                                                )
                                       ),
                                       tabPanel("Histograma", style="text-align: justify",
                                                fluidRow(
                                                  column(width = 6,  plotOutput("histogramPlot3")),
                                                  column(width = 6,
                                                         tags$div(
                                                           tags$div(class = "title-tab", "Sobre"), 
                                                           br(),
                                                           tags$div(class = "text-home", tags$p("Um histograma recebe como entrada apenas variáveis numéricas. 
                                                         A variável é dividida em vários compartimentos, e o número de observações por compartimento é representado pela altura da barra."))),
                                                         tags$div(class = "title-tab", "Dicas"), 
                                                         br(),
                                                         tags$div(class = "text-home", tags$p("- Não confunda com o gráfico de barras. Um gráfico de barras fornece um valor para cada grupo de uma 
                                                                variável categórica. Aqui temos apenas uma variável numérica e verificamos sua distribuição."),
                                                                  tags$p("- Não mostre a distribuição de mais de 5 variáveis, para isso use o gráfico boxplot."),
                                                                  tags$p("- Evite preencher com várias cores. Cores são úteis para demonstrar grupos e destacar um item específico na visualização.")),
                                                         tags$div(class = "title-tab", "Códigos"), 
                                                         br(),
                                                         tags$div(class = "text-home", 
                                                                  tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/histograma3.R", target="_blank", "R"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/histograma3.py", target="_blank", "Python"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/histograma.md", target="_blank", "Outras plataformas"))
                                                  )
                                                )),
                                       tabPanel("Pirulito", style="text-align: justify",
                                                fluidRow(
                                                  column(width = 6,  plotOutput("loliPlot2")),
                                                  column(width = 6,
                                                         tags$div(
                                                           tags$div(class = "title-tab", "Sobre"), 
                                                           br(),
                                                           tags$div(class = "text-home", tags$p("Um gráfico de pirulito é basicamente um gráfico de barras, onde a barra é transformada em 
                                                      uma linha e um ponto. Ele mostra a relação entre uma variável numérica e uma variável categórica."))),
                                                         tags$div(class = "title-tab", "Dicas"), 
                                                         br(),
                                                         tags$div(class = "text-home", tags$p("- Se os níveis da sua variável categórica não tiverem uma ordem óbvia, ordene as barras seguindo seus valores.")),
                                                         tags$div(class = "title-tab", "Códigos"), 
                                                         br(),
                                                         tags$div(class = "text-home", 
                                                                  tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/pirulito2.R", target="_blank", "R"),
                                                                  br(),
                                                                  tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/pirulito2.py", target="_blank", "Python"))
                                                  )
                                                ))
                               )),
                        tabItem(tabName = "subMenu6",
                                fluidRow(
                                  div(
                                    class = "text-center", width = 8,
                                    actionButton("redirect_home6", "Voltar para Home", 
                                                 style="background-color: #1F0E65;
                                color: #fff;
                                font-family: 'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif';
                                font-weight: bold;
                                font-size: 16px;
                                margin-bottom: 20px;"),
                                  ),
                                ),
                                tabBox(
                                  id = "tabset1", width = "550px",
                                tabPanel("Barras agrupadas", style="text-align: justify",
                                         fluidRow(
                                           column(width = 6,  plotOutput("groupPlot2")),
                                           column(width = 6,
                                                  tags$div(
                                                    tags$div(class = "title-tab", "Sobre"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("Um gráfico de barras exibe o valor de uma variável numérica para diversas entidades. 
                                                      Essas entidades podem ser agrupadas usando uma variável categórica, resultando em um gráfico de barras agrupado."))),
                                                  tags$div(class = "title-tab", "Dicas"), 
                                                  br(),
                                                  tags$div(class = "text-home", tags$p("- Não confunda isso com um histograma."),
                                                           tags$p("- Rótulos longos? Faça uma versão horizontal do gráfico."),
                                                           tags$p("- Se os níveis da sua variável categórica não tiverem uma ordem óbvia, ordene as barras seguindo seus valores.")),
                                                  tags$div(class = "title-tab", "Códigos"), 
                                                  br(),
                                                  tags$div(class = "text-home", 
                                                           tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/barras_agrupadas2.R", target="_blank", "R"),
                                                           br(),
                                                           tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/barras_agrupadas2.py", target="_blank", "Python"),
                                                           br(),
                                                           tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/barras_agrupadas.md", target="_blank", "Outras plataformas"))
                                           )
                                         )
                                ),
                                  tabPanel("Boxplot", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("boxPlot2")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um boxplot fornece um bom resumo de uma ou várias variáveis numéricas. 
                                                      A linha que divide a caixa em 2 partes representa a mediana dos dados. O final da caixa mostra os quartis superior 
                                                      e inferior. As linhas extremas mostram o valor mais alto e mais baixo, excluindo valores discrepantes."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Ordenar seu boxplot por mediana pode torná-lo mais esclarecedor.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/boxplot2.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/boxplot2.py", target="_blank", "Python"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/boxplot.md", target="_blank", "Outras plataformas"))
                                             )
                                           )
                                  )
                                )),
                        tabItem(tabName = "subMenu7",
                                fluidRow(
                                  div(
                                    class = "text-center", width = 8,
                                    actionButton("redirect_home7", "Voltar para Home", 
                                                 style="background-color: #1F0E65;
                                color: #fff;
                                font-family: 'Montserrat', 'Helvetica Neue', 'Helvetica', 'Arial', 'sans-serif';
                                font-weight: bold;
                                font-size: 16px;
                                margin-bottom: 20px;"),
                                  ),
                                ),
                                tabBox(
                                  id = "tabset1", width = "550px",
                                  tabPanel("Boxplot", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("boxPlot3")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um boxplot fornece um bom resumo de uma ou várias variáveis numéricas. 
                                                      A linha que divide a caixa em 2 partes representa a mediana dos dados. O final da caixa mostra os quartis superior 
                                                      e inferior. As linhas extremas mostram o valor mais alto e mais baixo, excluindo valores discrepantes."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Ordenar seu boxplot por mediana pode torná-lo mais esclarecedor.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/boxplot3.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/boxplot3.py", target="_blank", "Python"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/boxplot.md", target="_blank", "Outras plataformas"))
                                             )
                                           )
                                  ),
                                  tabPanel("Dispersão", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("scatterPlot2")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um gráfico de dispersão exibe a relação entre 2 variáveis numéricas. 
                                                      Para cada ponto de dados, o valor da sua primeira variável é representado no eixo X, o segundo no eixo Y."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Quando o seu conjunto de dados é grande, os pontos do seu gráfico de dispersão tendem a se sobrepor, tornando o gráfico ilegível.
                                                    A solução mais fácil é provavelmente reduzir o tamanho do ponto."),
                                                             tags$p("- Não se esqueça de mostrar subgrupos, se tiver algum. Pode revelar importantes padrões ocultos nos seus dados.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/dispersao2.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/dispersao2.py", target="_blank", "Python"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/dispersao.md", target="_blank", "Outras plataformas"))
                                             )
                                           )), 
                                  tabPanel("Linha", style="text-align: justify",
                                           fluidRow(
                                             column(width = 6,  plotOutput("linePlot2")),
                                             column(width = 6,
                                                    tags$div(
                                                      tags$div(class = "title-tab", "Sobre"), 
                                                      br(),
                                                      tags$div(class = "text-home", tags$p("Um gráfico de linhas exibe a evolução de uma ou várias variáveis numéricas. 
                                                           Os pontos de dados são conectados por segmentos de linha reta. É semelhante a um gráfico de dispersão, exceto que os pontos de medição 
                                                           são ordenados e unidos com segmentos de linha reta."))),
                                                    tags$div(class = "title-tab", "Dicas"), 
                                                    br(),
                                                    tags$div(class = "text-home", tags$p("- Muitas linhas tornam o gráfico ilegível.")),
                                                    tags$div(class = "title-tab", "Códigos"), 
                                                    br(),
                                                    tags$div(class = "text-home", 
                                                             tags$a(href = "https://github.com/rachderossi/DataViz/blob/main/linha2.R", target="_blank", "R"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/linha2.py", target="_blank", "Python"),
                                                             br(),
                                                             tags$a(href= "https://github.com/rachderossi/DataViz/blob/main/linha.md", target="_blank", "Outras plataformas"))
                                             )
                                           ))
                          )
                        )
                      )
                    )
                  )

server <- function(input, output, session) {
  
output$variavel_options <- renderUI({
    if(input$dashboard_variavel1 == "Numérico") {
      selectInput("dashboard_variavel2",
                  tags$div(class = "choice", "Escolha a quantidade:"),
                  choices = c("Uma variável", "Duas variáveis"),
                  selectize = FALSE)
    } else if(input$dashboard_variavel1 == "Categórico") {
      selectInput("dashboard_variavel2", 
                  tags$div(class = "choice", "Escolha a quantidade:"),
                  choices = c("Uma variável", "Duas variáveis"),
                  selectize = FALSE)
    } else if(input$dashboard_variavel1 == "Numérico & Categórico") {
      selectInput("dashboard_variavel2", 
                  tags$div(class = "choice", "Escolha a quantidade:"),
                  choices = c("Uma variável num. e uma variável cat.", "Uma variável num. e muitas categóricas", "Uma variável cat. e muitas numéricas"),
                  selectize = FALSE)
    }

})

observeEvent(input$dashboard_switchTabs, {
selected_tab <- switch(input$dashboard_variavel1,
                           "Numérico" = switch(input$dashboard_variavel2,
                                               "Uma variável" = "subMenu1",
                                               "Duas variáveis" = "subMenu2"
                           ),
                           "Categórico" = switch(input$dashboard_variavel2,
                                                 "Uma variável" = "subMenu3",
                                                 "Duas variáveis" = "subMenu4"
                           ),
                           "Numérico & Categórico" = switch(input$dashboard_variavel2,
                                                            "Uma variável num. e uma variável cat." = "subMenu5",
                                                            "Uma variável num. e muitas categóricas" = "subMenu6",
                                                            "Uma variável cat. e muitas numéricas" = "subMenu7"
                           )
                        )
  updateTabsetPanel(session, "tabs", selected = selected_tab)

})

observeEvent(input$redirect_home, {
  updateTabsetPanel(session, "tabs", selected = "home")
  
})

observeEvent(input$redirect_home2, {
  updateTabsetPanel(session, "tabs", selected = "home")
  
})
  
observeEvent(input$redirect_home3, {
  updateTabsetPanel(session, "tabs", selected = "home")
  
})

observeEvent(input$redirect_home4, {
  updateTabsetPanel(session, "tabs", selected = "home")
  
})

observeEvent(input$redirect_home5, {
  updateTabsetPanel(session, "tabs", selected = "home")
  
})

observeEvent(input$redirect_home6, {
  updateTabsetPanel(session, "tabs", selected = "home")
  
})

observeEvent(input$redirect_home7, {
  updateTabsetPanel(session, "tabs", selected = "home")
  
})


output$densityPlot <- renderPlot({
  data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/1_OneNum.csv", header=TRUE)
  
  data %>%
    filter( price<300 ) %>%
    ggplot( aes(x=price)) +
    geom_density(fill="#69b3a2", color="#e9ecef", alpha=0.8) +
    ggtitle("Distribuição de preços de aluguel") +
    xlab("preço") +
    ylab("densidade") +
    theme_ipsum()
})

output$densityPlot2 <- renderPlot({
  data <- ISLR::Carseats
  
  data %>%
    filter(Price < 300) %>%
    ggplot() +
    geom_density(aes(x = Price, fill = "preço"), alpha = 0.8) +  
    geom_density(aes(x = CompPrice, fill = "renda"), alpha = 0.8) +  
    scale_fill_manual(values = c("#6E9AF8", "#009E73"), name = NULL) +
    ggtitle("Distribuição de preço e renda") +
    xlab("valor") +
    ylab("densidade") +
    guides(fill = guide_legend(title.position = "left", title.hjust = 1, title = NULL)) +
    theme_ipsum() 
})

output$densityPlot3 <- renderPlot({
  iris %>%
    ggplot(aes(x = Sepal.Length, fill = Species)) +
    geom_density(alpha = 0.5) + 
    ggtitle("Distribuição do comprimento da sépala por espécie de flor") +
    xlab("comprimento da sépala") +
    ylab("densidade") +
    labs(fill = "espécies") +
    theme_ipsum()
})

output$histogramPlot <- renderPlot({
  data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/1_OneNum.csv", header=TRUE)
  
  data %>%
    filter(price<300 ) %>%
    ggplot(aes(x=price)) +
    geom_histogram(fill="#69b3a2", color="#e9ecef", alpha=0.8) +
    ggtitle("Distribuição de preços de aluguel") +
    xlab("preço") +
    ylab("frequência") +
    theme_ipsum()
})

output$histogramPlot2 <- renderPlot({
  data <- ISLR::Carseats
  
  data %>%
    filter(Price < 300) %>%
    ggplot() +
    geom_histogram(aes(x = Price, fill = "preço"), alpha = 0.8) +  
    geom_histogram(aes(x = CompPrice, fill = "renda"),  alpha = 0.8) +  
    scale_fill_manual(values = c("#6E9AF8", "#009E73"), name= NULL) +  
    ggtitle("Distribuição de preço e renda") +
    xlab("valor") +
    ylab("frequência") +
    guides(fill = guide_legend(title.position = "left", title.hjust = 1, title = NULL)) +
    theme_ipsum() 
})

output$histogramPlot3 <- renderPlot({
    iris %>%
      ggplot(aes(x = Petal.Length, fill = Species)) +
      geom_histogram(binwidth = 0.2, alpha = 0.5, position = "identity") +
      ggtitle("Distribuição do comprimento da sépala por espécie de flor") +
      xlab("comprimento da pétala") +
      ylab("frequência") +
      labs(fill = "espécies") +
      theme_ipsum()
})

output$boxPlot <- renderPlot({
  mpg %>%
    ggplot(aes(x = class, y = hwy)) + 
    geom_boxplot(fill = "#69b3a2", alpha = 0.5) +  
    ggtitle("Consumo de combustível por tipo de veículo") +
    xlab("categorias") +
    ylab("milhas por galão") +
    theme(legend.position = "left") + 
    guides(fill = guide_legend(title = NULL)) +
    theme_ipsum() 
})

output$boxPlot2 <- renderPlot({
  diamonds %>%
    ggplot(aes(x = cut, y = price, fill = color)) +
    geom_boxplot() +
    ggtitle("Distribuição do preço dos diamantes por corte e cor") +
    xlab("corte") +
    ylab("preço") +
    labs(fill = "cor") +
    theme_ipsum()
})

output$boxPlot3 <- renderPlot({
  mtcars %>%
    ggplot(aes(x = as.factor(cyl), y = mpg, fill = factor(am, labels = c("Automático", "Manual")))) +
    geom_boxplot() +
    ggtitle("Consumo de combustível por cilindros e tipo de transmissão") +
    xlab("número de cilindros") +
    ylab("milhas por galão") +
    scale_fill_manual(values = c("#009E73", "#6E9AF8")) +
    guides(fill = guide_legend(title = NULL)) +
    theme_ipsum() 
})

output$scatterPlot <- renderPlot({
  data <- ISLR::Carseats
  
  data %>%
    ggplot(aes(x = CompPrice, y = Price)) + 
    geom_point(size = 3, color = "#009E73") +
    ggtitle("Relação entre o preço da mercadoria na empresa e no concorrente") +
    xlab("preço no concorrente") +
    ylab("preço na empresa") +
    theme(legend.position = "left") + 
    guides(color = guide_legend(title = NULL)) +
    theme_ipsum() 
})

output$scatterPlot2 <- renderPlot({
  iris %>%
    ggplot(aes(x = Sepal.Length, y = Sepal.Width, color = Species)) + 
    geom_point(size = 3) +
    ggtitle("Relação entre comprimento e largura das sépalas por espécie") +
    xlab("comprimento") +
    ylab("largura") +
    labs(color = "espécies") +
    theme(legend.position = "left") + 
    guides(color = guide_legend(title = NULL)) +
    theme_ipsum() 
})

output$areaPlot <- renderPlot({
  
  data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/3_TwoNumOrdered.csv", header=T)
  data$date <- as.Date(data$date)
  
  data %>%
    ggplot(aes(x=date, y=value)) +
    geom_area(fill="#69b3a2", alpha=0.5) +
    geom_line(color="#69b3a2") +
    ggtitle("Evolução do preço do Bitcoin") +
    xlab("ano") +
    ylab("preço do Bitcoin ($)") +
    theme_ipsum()
})

output$scattercPlot <- renderPlot({
  data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/3_TwoNumOrdered.csv", header = TRUE)
  data$date <- as.Date(data$date)
  
  data_filtrado <- data %>%
    filter(format(date, "%Y-%m") == "2018-04")
  
  data_filtrado %>%
    ggplot(aes(x = date, y = value)) +
    geom_point(shape=21, color="black", fill="#69b3a2", size=2) +
    geom_line(color = "#69b3a2") +
    ggtitle("Evolução do preço do Bitcoin em abril de 2018") +
    xlab("data") +
    ylab("preço do Bitcoin ($)") +
    theme_ipsum()
})

output$linePlot <- renderPlot({
  data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/3_TwoNumOrdered.csv", header=T)
  data$date <- as.Date(data$date)
  
  data %>%
    ggplot( aes(x=date, y=value)) +
    geom_line(color="#69b3a2") +
    ggtitle("Evolução do preço do Bitcoin") +
    xlab("ano") +
    ylab("preço do Bitcoin ($)") +
    theme_ipsum()
})

output$linePlot2 <- renderPlot({
  name <- babynames %>%
    filter(name %in% c("Ashley", "Patricia", "Helen")) %>%
    filter(sex == "F")
  
  name %>%
    ggplot(aes(x = year, y = n, group = name, color = name)) +
    geom_line() +
    scale_color_manual(values = c("#6E9AF8", "#009E73", "#FFA07A"), name = NULL) +
    ggtitle("Popularidade de nomes Americanos nos últimos 30 Anos") +
    xlab("ano") +
    ylab("número de bebês") +
    guides(color = guide_legend(title.position = "left", title.hjust = 1, title = NULL)) +
    theme_ipsum() 
})

output$barPlot <- renderPlot({
  mpg %>%
    count(class) %>%
    mutate(class = reorder(class, n)) %>%
    ggplot(aes(x = class, y = n)) + 
    geom_bar(fill = "#6E9AF8", stat = "identity") + 
    ggtitle("Distribuição das classes de veículo") +
    xlab("classe") +
    ylab("frequência") +
    theme_ipsum()
  
})

output$cloudPlot <- renderPlot({
  paises <- c("Brasil", "Estados Unidos", "Canadá", "Reino Unido", "França", "Alemanha", "Austrália", "Japão", "China", "Índia")
  frequencias <- c(50, 30, 40, 35, 25, 20, 45, 15, 10, 5)
  df_paises <- data.frame(Pais = paises, Frequencia = frequencias)
  
  wordcloud(words = df_paises$Pais, freq = df_paises$Frequencia, scale = c(5, 0.5), 
            max.words = 10, min.freq = 1, random.order = FALSE, 
            colors=brewer.pal(8, "Dark2"))
})

output$loliPlot <- renderPlot({
  # Contar a frequência de cada classe de veículo
  freq_class <- table(mpg$class)
  
  # Criar um data frame com os dados da frequência
  data_freq <- data.frame(class = names(freq_class), freq = as.numeric(freq_class))
  
  # Ordenar o data frame pela frequência em ordem ascendente
  data_freq <- arrange(data_freq, freq)
  
  # Criar o gráfico de pirulito
  data_freq %>%
    ggplot(aes(x = reorder(class, freq), y = freq)) +
    geom_segment(aes(xend = reorder(class, freq), yend = 0), color = "black") +
    geom_point(size = 4, color = "#6E9AF8") +
    ggtitle("Distribuição das classes de veículo") +
    xlab("classe") +
    ylab("frequência") +
    coord_flip() +
    theme_ipsum()
})

output$loliPlot2 <- renderPlot({
  data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/7_OneCatOneNum.csv", header=TRUE, sep=",")
  
  data %>%
    filter(!is.na(Value)) %>%
    arrange(Value) %>%
    tail(20) %>%
    mutate(Country=factor(Country, Country)) %>%
    ggplot( aes(x=Country, y=Value) ) +
    geom_segment( aes(x=Country ,xend=Country, y=0, yend=Value), color="grey") +
    geom_point(size=3, color="#69b3a2") +
    theme(
      panel.grid.minor.y = element_blank(),
      panel.grid.major.y = element_blank(),
      legend.position="none",
      plot.title = element_text(hjust = 0.5, size = 15)) +
    ggtitle("Quantidade de armas exportadas pelos 20 maiores exportadores em 2017") +
    xlab("países") +
    ylab("quantidade de armas") +
    coord_flip() +
    theme_ipsum() 
})

output$groupPlot <- renderPlot({
  diamonds %>%
    ggplot(aes(x = cut, fill = color)) +
    geom_bar(position = "dodge") +
    ggtitle("Qualidade do corte de diamante de acordo com a cor") +
    xlab("corte") +
    ylab("frequência") +
    labs(fill = "cor") +
    theme_ipsum() 
})

output$groupPlot2 <- renderPlot({
  data <- babynames %>% 
    filter(name %in% c("Anna", "Mary")) %>%
    filter(sex=="F")
  
  data  %>% 
    filter(year %in% c(1950, 1960, 1970, 1980, 1990, 2000)) %>%
    mutate(year=as.factor(year)) %>%
    ggplot( aes(x=year, y=n, fill=name)) +
    geom_bar(stat="identity", position="dodge") +
    scale_fill_manual(values = c("Anna" = "#6E9AF8", "Mary" = "#69b3a2")) + 
    ggtitle("Número de bebês chamados Anna e Mary ao longo dos anos") +
    ylab("número de bebês") +
    xlab("anos") +
    guides(fill = guide_legend(title = NULL)) +
    theme_ipsum() 
})

output$mapPlot <- renderPlot({
  data <- as.matrix(mtcars)
  
  heatmap(data, Colv = NA, Rowv = NA, scale="column", main = "Mapa de calor")
})
}

shinyApp(ui, server)