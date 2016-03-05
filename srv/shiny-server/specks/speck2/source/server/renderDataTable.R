output$annotations <- renderDataTable({

    # Take a dependency on input$goButton
    input$goPlot # Re-run when button is clicked

    # Include the global vars.
    source('source/server/vars.R', local = TRUE)

    # Set vars.
    site1_anno_data <- NULL

    # Make sure it is not googlemaps
    if(plot != 'googlemaps') {

        query <- "
            SELECT
                a.aid,
                a.text,
                a.timestamp,
                n.code
            FROM annotations AS a

            LEFT JOIN nodes AS n
            ON n.nid = a.nid
            AND n.datatype = 'speck'

            WHERE n.nid = 'SITE'
            ORDER BY a.aid ASC
        "

        # Fetch annotations belong to a site.
        # Match the pattern and replace it.
        annoQuery <- sub("SITE", as.character(site1), query)

        # Store the result in data.
        site1_anno_data <- dbGetQuery(DB, annoQuery)

    }

    # Make sure to have data.
    if(exists("site1_anno_data") && !is.null(site1_anno_data) && nrow(site1_anno_data) > 0) {

        logme('Annotations data loaded')

        # Convert timestamp to date and bind it to the data.
        site1_anno_data$date <- as.POSIXct(as.numeric(as.character(site1_anno_data$timestamp)), origin = "1970-01-01", tz = "GMT")

        # Remove columns.
        site1_anno_data$timestamp <- NULL
        site1_anno_data$code <- NULL

        # Reorder by column name
        site1_anno_data <- site1_anno_data[c("aid", "date", "text")]

        # Rename columns name.
        colnames(site1_anno_data)[which(names(site1_anno_data) == "aid")] <- "Id"
        colnames(site1_anno_data)[which(names(site1_anno_data) == "date")] <- "Date"
        colnames(site1_anno_data)[which(names(site1_anno_data) == "text")] <- "Text"

        site1_anno_data
    }
} ,
    # Customize the length drop-down menu; display 10 rows per page by default.
    options = list(lengthMenu = c(5, 10, 30), pageLength = 5)
)
