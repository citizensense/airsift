#functions.R:
runSiteQuery <- function(DB, query, site) {

    # Fetch a site.
    # Match the pattern and replace it.
    siteQuery <- sub("SITE", as.character(site), query)

    # Store the result in data.
    data <- dbGetQuery(DB, siteQuery)

    # Return the data.
    return(data)
}
