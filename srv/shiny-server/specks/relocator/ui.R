# ui.R

# shinyUI(fluidPage(
#     tags$head(tags$script(src="redirect.js")),
#     tags$style(
#         type='text/css',
#         "body { overflow-y: scroll; overflow-x: hidden;}

#         /*#link {visibility: hidden;}*/
#         "
#     ),
#     titlePanel("App1"),
#     sidebarLayout(
#         sidebarPanel(
#             textInput(inputId = "link", label = "", value = "")
#         ),
#         mainPanel(
#             tags$div(
#                 id = "redirect",
#                 HTML('<a href="#">Raw HTML!</a>')
#             )
#         )
#     )
# ))

shinyUI(bootstrapPage(uiOutput("uiHTML")))
