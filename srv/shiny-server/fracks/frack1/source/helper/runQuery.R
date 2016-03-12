#functions.R:
runQuery <- function(DB, query, site, site_name, date_from, date_to, year) {

    # Match the pattern and replace it.
    dataQuery <- sub("DATE1", as.character(date_from), query)
    dataQuery <- sub("DATE2", as.character(date_to), dataQuery)
    dataQuery <- sub("YEAR", as.character(year), dataQuery)
    dataQuery <- sub("SITE", as.character(site), dataQuery)

    # Log.
    # qry <- gsub("\\s", "", query)
    # logme(qry)
    # logme('<start> data = dbGetQuery(DB, dataQuery) ------ !!! Long computation time')

    # Store the result in data.
    data <- dbGetQuery(DB, dataQuery)

    # Log.
    # logme('<finished> data = dbGetQuery(DB, dataQuery)')

    # logme(colnames(data))

    if(nrow(data) > 0) {

        # Transform/ convert the data to numberic.
        data[,'wspdi'] <- suppressWarnings(as.numeric(as.character(data[,'wspdi'])))
        data[,'wdird'] <- suppressWarnings(as.numeric(as.character(data[,'wdird'])))

        # Or:
        # data <- transform(data, wspdi=as.numeric(as.character(data)))

        # Convert timestamp to date and bind it to the data.
        data$date <- as.POSIXct(as.numeric(as.character(data$timestamp)), origin="1970-01-01", tz="America/New_York")

        # Bind the site name to the data.
        data$site <- as.character(site_name)

        # Bind the ws and wd to the data.
        data$ws <- data$wspdi
        data$wd <- data$wdird
    }

    return(data)
}
