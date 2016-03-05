# Create reactive data for plots (accept map plot).
getData <- reactive({

    # Prepare SQL query1.
    query <- "
        SELECT
            s.timestamp,
            CASE WHEN n.nid = '323' AND s.particle_concentration >= '250' THEN '250' ELSE s.particle_concentration END AS `PM2.5`,
            CASE WHEN s.humidity = '-9999.0' THEN NULL ELSE s.humidity END AS humidity,
            CASE WHEN w.wdird = '0' AND w.wspdi = '0.0' THEN NULL ELSE CASE WHEN w.wdird = '0' AND w.wspdi = '-9999.0' THEN NULL ELSE w.wdird END END AS wdird,
            CASE WHEN w.wdird = '0' AND w.wspdi = '0.0' THEN NULL ELSE CASE WHEN w.wdird = '0' AND w.wspdi = '-9999.0' THEN NULL ELSE w.wspdi END END AS wspdi,
            CASE WHEN w.hum = '-9999.0' THEN NULL ELSE w.hum END AS hum,
            CASE WHEN w.tempi = '-9999.0' THEN NULL ELSE w.tempi END AS tempi,
            CASE WHEN w.visi = '-9999.0' THEN NULL ELSE w.visi END AS visi,
            n.code
        FROM speckdata AS s

        LEFT JOIN weatherunderground AS w
        ON s.wid_timestamp = w.wid_timestamp

        LEFT JOIN nodes AS n
        ON n.nid = s.nid
        AND n.datatype = 'speck'

        WHERE DATE(localdate) BETWEEN 'DATE1' AND 'DATE2'
        AND n.nid = 'SITE'
    "


    # Include googlemaps SQLite query and function.
    source('source/helper/runQuery.R', local = TRUE)

    # Empty vector for storing listData later.
    data1 <- c()
    data2 <- c()

    rr <- memoise(runQuery)

    # Data: site 1
    data1 <- rr(DB, query, sites$site1, sites$site1_name, periods$date_from, periods$date_to, periods$year)

    # Data: site 2
    if (sites$site1 != 'None' && sites$site2 != 'None') {
        data2 <- rr(DB, query, sites$site2, sites$site2_name, periods$date_from, periods$date_to, periods$year)
    }

    # Merge data sets.
    set.seed(1)
    if (isolate(input$plot) == "line" && isolate(input$site2) != 'None') {
        data_list = list(data1, data2)
    }else{
        data_list = list(data1)
    }
    data <- Reduce(function(...) merge(..., all=T), data_list)

    # Return the data.
    data
})
