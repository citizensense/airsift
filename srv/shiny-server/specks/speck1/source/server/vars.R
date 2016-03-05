# @reference: http://shiny.rstudio.com/articles/isolation.html
# Use isolate() to avoid dependency on inputs below.
# Sites.
site1 <- isolate(input$site1)
site2 <- isolate(input$site2)

# Pollutant.
species <- isolate(input$species)
condition <- isolate(input$condition)
conditions <- isolate(input$conditions)

# Text value.
species_text_value <- isolate(names(species_choices[species_choices == input$species]))
condition_text_value <- isolate(names(conditions_choices[conditions_choices == input$conditions]))
site1_text_value <- isolate(names(site_choices[site_choices == input$site1]))
site2_text_value <- isolate(names(site_choices[site_choices == input$site2]))

# Period.
date_from <- isolate(input$date_from)
date_to <- isolate(input$date_to)
year <- isolate(input$year)

# Plot.
plot <- isolate(input$plot)
variation_line <- isolate(input$variation_line)
variation_googlemaps <- isolate(input$variation_googlemaps)

# Mean.
avg_time <- isolate(input$mean)
type_googlemaps <- isolate(input$type_googlemaps)

# Plot main (title)
if (site2 != 'None' && plot == 'line') {
    plot_main_title = paste(site1_text_value, site2_text_value, sep = ", ")
} else {
    plot_main_title = site1_text_value
}

# Prepare date info.
if (plot == 'calendar') {
    time_period_value = paste('\nTime Period: ', as.character(year))
} else {
    time_period_value = paste('\nTime Period: ', as.character(date_from, "%B %d, %Y"), ' - ', as.character(date_to, "%B %d, %Y"))
}

# Reactive values
sites$site1 <- site1
sites$site2 <- if(plot == 'line') site2 else 'None'
sites$site1_name <- site1_text_value
sites$site2_name <- site2_text_value
periods$date_from <- date_from
periods$date_to <- date_to
periods$year <- year
pollutants$species <- species
pollutants$condition <- condition
