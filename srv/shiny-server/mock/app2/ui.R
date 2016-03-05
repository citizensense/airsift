# ui.R

shinyUI(fluidPage(
    titlePanel("Frack2"),
    sidebarLayout(
        sidebarPanel(
            tags$div(
                HTML('<p">Side bar menu...</p>')
            )
        ),
        mainPanel(
            tags$div(
                HTML('<p">Hello World!</p>')
            )
        )
    )
))
