## LOG:
## Capture all the output to a file.
zz <- file("log.txt", open = "wt")
sink(zz)
sink(zz, type = "message")

logme <- function(msg) {
    cat('\n', file=stderr())
    starttime = format(Sys.time() , "%a %b %d %X %Y | ")
    cat(starttime, file=stderr())
    cat(msg, file=stderr())
}

# A quick fix to Shiny/ R cache issue.
# Fetch all site names.
sites <- dbGetQuery(
    DB,
    "SELECT
        nid,
        title,
        code
    FROM nodes
    WHERE datatype = 'frackbox'
    AND visible = '1'
    AND code NOT NULL"
)

# Set the nid and title.
site_choices <- setNames(sites$nid, sites$title)

# Set choices of title and code for select input.
conditions_choices <- c(
    'Device Humidity %' = 'humidity',
    'Temperature in Fahrenheit' = 'tempi',
    'Humidity %' = 'hum',
    'Wind speed in miles per hour' = 'wspdi',
    'Wind direction in degrees' = 'wdird',
    'Visibility in miles' = 'visi'
)

# Set choices of title and code for select input.
species_choices <- c(
    '​Nitrogen Oxide (ppb)' = 'NOppb',
    '​Nitrogen Dioxide (ppb)' = 'NO2ppb',
    '​Ozone  (ppb) (sensor 1)' = '​O3ppb',
    '​Ozone (ppb) (sensor 2)' = 'O2No2ppb',
    '​Volatile Organic Compounds (ppm)' = '​PIDppm'
)

# Server.
shinyServer(function(input, output, session) {

    # 3 reactive things that are useful for caching.
    #x <- eventReactive(input$goPlot, { input$site1 })
    #x <- reactive({ isolate(input$site1) })
    #x <- reactiveValues( x = '1' )

    # Site reactive values when the data from the ui is changed.
    sites <- reactiveValues(
        site1 = '1',
        site2 = '2',
        site1_name = 'Foo',
        site2_name = 'Boo'
    )

    # Period reactive values when the data from the ui is changed.
    periods <- reactiveValues(
        date_from = '1',
        date_to = '2',
        year = '2014'
    )

    # Test the reactive with reactiveValues.
    cache <- reactive({
        paste("current values - site 1: ", sites$site1, " and site 2:", sites$site2)
    })

    # Send test data to the front to ui.R
    output$test <- renderText({

        # Take a dependency on input$goButton
        input$goPlot # Re-run when button is clicked

        # Include the global vars.
        source('source/server/vars.R', local = TRUE)

        # Get the reative data.
        data <- cache()

        # Render it.
        data

    })

    # Include reactive objects.
    source('source/server/getData.R', local = TRUE)

    # Render the plot.
    output$plot <- renderPlot({

        # Log.
        cat('\n\n', file=stderr())
        starttime = Sys.time()
        logme('Start plotting =========>')

        # Take a dependency on input$goButton
        input$goPlot # Re-run when button is clicked

        # Include the global vars.
        source('source/server/vars.R', local = TRUE)

        # @ reference: http://shiny.rstudio.com/gallery/progress-bar-example.html
        # Create a Progress object
        progress <- shiny::Progress$new()
        progress$set(message = "Computing data", value = 0)
        # Close the progress when this reactive exits (even if there's an error)
        on.exit(progress$close())

        # Create a closure to update progress.
        # Each time this is called:
        # - If `value` is NULL, it will move the progress bar 1/5 of the remaining
        #   distance. If non-NULL, it will set the progress to that value.
        # - It also accepts optional detail text.
        updateProgress <- function(value = NULL, detail = NULL) {
            if (is.null(value)) {
                value <- progress$getValue()
                value <- value + (progress$getMax() - value) / 5
            }
            progress$set(value = value, detail = detail)
        }

        # Compute the new data, and pass in the updateProgress function so
        # that it can update the progress indicator.
        compute_data(updateProgress)

        # Fetch the data from the reactive.
        all_data <- getData()

        # Check if no row in the data.
        if (nrow(all_data) == 0) {

            # As we need to return plot to renderPlot() we need to display
            # the error/warning within plot() function

            # Print error/ warning message.
            # Plotting a point at x=1, y=1 in white colour, trying to plot blank frame.
            # (Probably there is more elegant way of doing this.)
            # Then adding the text at x=1, y=1.
            plot(1, 1, col = "white")
            text(1, 1, "Sorry, no data is found.")

        } else {

            # Include the plot functions.
            source('source/server/plots.R', local = TRUE)

            # Download the data into a csv file.
            output$downloadData <- downloadHandler(
              filename = function() {
                paste('data - ', plot_main_title, '.csv', sep = '')
              },
              content = function(file) {
                write.csv(all_data, file, row.names = FALSE)
              }
            )

            # Download the plot into a png file.
            output$downloadPlot <- downloadHandler(
              filename = function() {
                paste(plot_main_title, ' - ', toupper(substr(plot, 1, 1)), substr(plot, 2, nchar(plot)), ' Plot', '.png', sep = '')
              },
              content = function(file) {
                png(file, width = 943, height = 400)
                source('source/server/plots.R', local = TRUE)
                dev.off()
              }
            )
        }

        # Log.
        endtime = Sys.time()-starttime
        logme('Plot took: ')
        cat(endtime, file = stderr())
        cat(' seconds', file = stderr())
        cat('\n', file = stderr())
    })

})

# This function computes a new data set. It can optionally take a function,
# updateProgress, which will be called as each row of data is added.
compute_data <- function(updateProgress = NULL) {
    # Create 0-row data frame which will be used to store data
    dat <- data.frame(x = numeric(0), y = numeric(0))

    for (i in 1:10) {
        Sys.sleep(0.25)

        # Compute new row of data
        new_row <- data.frame(x = rnorm(1), y = rnorm(1))

        # If we were passed a progress update function, call it
        if (is.function(updateProgress)) {
          text <- paste0("x:", round(new_row$x, 2), " y:", round(new_row$y, 2))
          updateProgress(detail = text)
        }

        # Add the new row of data
        dat <- rbind(dat, new_row)
    }

    dat
}
