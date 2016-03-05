setwd("/srv/shiny-system/cron/mock")
I <- 0
for (i in 1:60) {
    system("top -n 1 -b -u shiny > top.log")
    dat <- readLines("top.log")
    id <- grep("R$", dat)

    # live server.
    # Names <- strsplit(gsub("^ +|%|\\+", "", dat[14]), " +")[[1]]

    # Localhost
    Names <- strsplit(gsub("^ +|%|\\+", "", dat[7]), " +")[[1]]

    if (length(id) > 0) {
        # ‘top’ data frame;
        L <- strsplit(gsub("^ *", "", dat[id]), " +")
        dat <- data.frame(matrix(unlist(L), ncol = 12, byrow = T))
        names(dat) <- Names
        dat <- data.frame(Time = Sys.time(), dat[, -ncol(dat)], usr = NA, app = NA)
        dat$CPU <-as.numeric(as.character(dat$CPU))
        dat$MEM <-as.numeric(as.character(dat$MEM))

        # Check if connection number changed;
        for (i in 1:length(dat$PID)) {
            PID <- dat$PID[i]

            # system(paste("echo ", PID, " >> track.log"))

            system(paste("sudo -i netstat -p | grep ", PID, " > netstat.log"))
            # system(paste("sudo -i netstat -p | grep ", PID, " >> netstat.log2"))
            system(paste("sudo -i lsof -p ", PID, " | grep DIR > lsof.log"))
            netstat <- readLines("netstat.log")
            lsof <- readLines("lsof.log")
            dat$usr[i] <- length(grep("ESTABLISHED", netstat) & grep("tcp", netstat))

            # system(paste("echo ", dat$usr[i], " >> track.log"))

            # Liveserver.
            # dat$app[i] <- regmatches(lsof, regexec("usr/local/chroot/csshiny/devopenair.citizensense.net/(.*)", lsof))[[1]][2]

            # Localhost.
            dat$app[i] <- regmatches(lsof, regexec("srv/shiny-server/mock/(.*)", lsof))[[1]][2]

        }
        dat <- dat[, c("app", "usr")]
    } else {
        dat <- data.frame(app = "app1", usr = 0)
    }
    write.table(dat, file = "cpu.txt")
}
