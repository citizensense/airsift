# Create reactive data for map plot.
output$text <- renderUI({

    # Take a dependency on input$goButton
    input$goPlot # Re-run when button is clicked

    # Include the global vars.
    source('source/server/vars.R', local = TRUE)

    # Text value.
    site1_title <- isolate(names(site_choices[site_choices == input$site1]))
    site2_title <- isolate(names(site_choices[site_choices == input$site2]))

    logme('Sites description loaded')

    query <- "
        SELECT
            nid,
            title,
            description,
            code
        FROM nodes

        WHERE datatype = 'speck'
        AND visible = '1'
        AND nid = 'SITE'
    "

    # Site Data: site 1.
    # Match the pattern and replace it.
    site1_query <- sub("SITE", as.character(site1), query)

    # Store the result in data.
    site1_data = dbGetQuery(DB, site1_query)

    # Site Data: site 2.
    # Match the pattern and replace it.
    site2_query <- sub("SITE", as.character(site2), query)

    # Store the result in data.
    site2_data = dbGetQuery(DB, site2_query)

    #
    #
    #

    if (isolate(input$site1) == '178') {
        site1_heading <-'Notes and observations'
        site1_description <-'Initial indoor test, and later outdoor monitoring with Speck'
    } else {
        site1_heading <- 'Notes and observations'
        site1_description <- site1_data$description
    }

    if (isolate(input$site2) == '178') {
        site2_heading <-'Notes and observations'
        site2_description <-'Initial indoor test, and later outdoor monitoring with Speck'
    } else {
        site2_heading <- 'Notes and observations'
        site2_description <- site2_data$description
    }

    # Don't execute this if it is googlemaps.
    if (isolate(input$plot) != "googlemaps") {

        # Paste the all str together.
        HTML(
            #'<a class="btn btn-default button-download method-download" href="#">Download image</a>',
            #'<h4 style="font-size:11px; font-weight:bold;">Description</h4>',
            '<br/>',
            if (isolate(input$plot) == "line") {
                if (isolate(input$site2) != 'None') {
                    paste('
                        <h4 style="font-size:11px; font-weight:bold;">', site1_heading, '</h4>
                        <p style="font-size:11px; text-align: left;">', site1_description, '</p>
                        <h4 style="font-size:11px; font-weight:bold;">', site2_heading, '</h4>
                        <p style="font-size:11px; text-align: left;">', site2_description, '</p>
                        <span id="site1-title" class="hidden">', site1_title, '</span>
                        <span id="site2-title" class="hidden">', site2_title, '</span>
                    ')
                } else {
                    paste('
                        <h4 style="font-size:11px; font-weight:bold;">', site1_heading, '</h4>
                        <p style="font-size:11px; text-align: left;">', site1_description, '</p>
                        <span id="site1-title" class="hidden">', site1_title, '</span>
                    ')
                }

            } else {
                paste('
                    <h4 style="font-size:11px; font-weight:bold;">', site1_heading, '</h4>
                    <p style="font-size:11px; text-align: left;">', site1_description, '</p>
                    <span id="site1-title" class="hidden">', site1_title, '</span>
                ')
            }
        )
    }

})
