# server.R
shinyServer(function(input, output, session) {
  output$uiHTML <- renderUI({

    # Localhost.
    CPU <- read.table("../../../shiny-system/cron/specks/cpu.txt")

    # Live server.
    # CPU <- read.table("../../../../../../../srv/shiny-system/cron/specks/cpu.txt")

    App <- data.frame(app = c("speck1", "speck2", "speck3", "speck4"))
    App <- merge(App, CPU, all.x = TRUE)
    App$usr[which(is.na(App$usr))] <- 0

    # Localhost.
    Link <- paste("http://127.0.0.1:3838/specks/", App$app[which.min(App$usr)], sep = "")

    # Live server.
    # Link <- paste("http://devopenair.citizensense.net/specks/", App$app[which.min(App$usr)], sep = "")

    Iframe <- '<iframe style="width:100%; height:100vh;" scrolling="no" seamless="seamless" frameborder="0" src="Link"></iframe>'
    HTML(gsub("Link", Link, Iframe))
  })
})
