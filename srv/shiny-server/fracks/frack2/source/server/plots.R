# Empty vector for storing line_pollutants later.
line_pollutants <- c()

# Prepare the info of line_pollutants for line plot multisite in a single plot.
if (isolate(input$plot) == "line" && isolate(input$site2) != 'None') {

    query <- "
        SELECT
            nid,
            title,
            description,
            code
        FROM nodes

        WHERE datatype = 'frackbox'
        AND visible = '1'
        AND nid = 'SITE'
    "

    # Include googlemaps SQLite query and function.
    source('source/helper/runSiteQuery.R', local = TRUE)

    ss <- memoise(runSiteQuery)

    # Data: site 1
    # Store the result in data.
    site1_data <- ss(DB, query, sites$site1)

    # Concat the string.
    site1_code_pollutant <- paste(site1_data$code, "_", species, sep = "")

    # Append the data to the list.
    line_pollutants <- append(line_pollutants, site1_code_pollutant)

    # Data: site 2
    # Store the result in data.
    site2_data <- ss(DB, query, sites$site2)

    # Concat the string.
    site2_code_pollutant <- paste(site2_data$code, "_", species, sep = "")

    # Append the data to the list.
    line_pollutants <- append(line_pollutants, site2_code_pollutant)

}

# Plot the data.
# Conditions.

if(plot == 'line') {

    # Line plot, multisite, single plot rendering, eg: two sites, 1 plot.
    if(variation_line == 'single') {

        # first drop site name
        thedata <- subset(all_data, select = -site)

        # now reshape the data using the reshape package
        thedata <- melt(thedata, id.vars = c("date", "code"))
        thedata <- dcast(thedata, ... ~ code + variable)

        timePlot(
            main = plot_main_title,
            sub = time_period_value,
            thedata,
            pollutant = line_pollutants,
            avg.time = avg_time,
            group = TRUE,
            lwd = 2
        )

    # Line plot, multisite, multi plot rendering, eg: two sites, two plots.
    } else if(variation_line == 'multiple') {

        if(condition == 'none') {

            # Averaged the data to [annual] means.
            # Set the line width to 2 the line type to 1 (continuous line).
            # Give alternative names for the variables plotted, instead of taking the column headings as names
            # Group pollutants from several sites on one plot.
            # Chosen to group the data in one panel.
            timePlot(
                main = plot_main_title,
                sub = time_period_value,
                all_data,
                pollutant = c(species),
                avg.time = avg_time,
                lwd = 2,
                lty = 1,
                name.pol = c(species_text_value),
                type = "site",
                group = TRUE,
                auto.text = FALSE,
                scales = list(x = list(alternating = FALSE))
            )
        } else {

            # Averaged the data to [annual] means.
            # Set the line width to 2 the line type to 1 (continuous line).
            # Give alternative names for the variables plotted, instead of taking the column headings as names
            # Group pollutants from several sites on one plot.
            # Chosen to group the data in one panel.
            timePlot(
                main = plot_main_title,
                sub = time_period_value,
                all_data,
                pollutant = c(species, conditions),
                avg.time = avg_time,
                lwd = 2,
                lty = 1,
                name.pol = c(species_text_value, condition_text_value),
                type = "site",
                group = TRUE,
                auto.text = FALSE,
                scales = list(x = list(alternating = FALSE))
            )
        }
    }

} else if (plot == 'scatter') {

    scatterPlot(
        main = plot_main_title,
        sub = time_period_value,
        all_data,
        x = conditions,
        y = species,
        xlab = condition_text_value,
        ylab = species_text_value
    )

} else if (plot == 'polar1') {

    polarPlot(
        main = plot_main_title,
        sub = time_period_value,
        all_data,
        pollutant = species,
        na.rm = TRUE, k = 25
    )

} else if (plot == 'rose') {

    windRose(
        main = plot_main_title,
        sub = time_period_value,
        all_data,
        type = species,
        key.footer = "miles/hour"
    )

}
