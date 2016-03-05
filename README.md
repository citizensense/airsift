# Requirements

1. R -v 3.2.0
2. Shiny -v latest

# Package Dependencies

1. plyr
2. RSQLite
3. openair
4. reshape2

# RStudio (Local Machine)

## Openair Installation

Go to,

    https://github.com/davidcarslaw/openair

Type these lines below in R or RStudio console:

    require(devtools)
    install_github('davidcarslaw/openair')

In case you can't install devtools, run these lines below in your terminal, then run the lines above again in your R's:

    $ sudo apt-get -y build-dep libcurl4-gnutls-dev
    $ sudo apt-get -y install libcurl4-gnutls-dev

Ref:

1. http://stackoverflow.com/questions/30794035/install-packagesdevtools-on-r-3-0-2-fails-in-ubuntu-14-04
2. http://stackoverflow.com/questions/20923209/problems-installing-the-devtools-package

# Ubuntu Linux (Localhost)

## Install Shiny Server

Paste these below on your terminal:

    $ sudo apt-get install r-base

    $ sudo su - \
    -c "R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\""

    $ sudo apt-get install gdebi-core
    $ wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.4.1.759-amd64.deb
    $ sudo gdebi shiny-server-1.4.1.759-amd64.deb

## Grant Permissions

Now we have the directory structure for our files, but they are owned by our root user. If we want our regular user to be able to modify files in our web directories, we can change the ownership by doing this:

    $ sudo chown lau.users /srv/shiny-server/

## Upstart (Ubuntu 12.04 through 14.10, RedHat 6)

    $ sudo start shiny-server
    $ sudo stop shiny-server
    $ sudo restart shiny-server

## Install packages

    $ sudo su - -c "R -e \"install.packages('plyr', repos='http://cran.rstudio.com/')\""
    $ sudo su - -c "R -e \"install.packages('RSQLite', repos='http://cran.rstudio.com/')\""
    $ sudo su - -c "R -e \"devtools::install_github('davidcarslaw/openair')\""
    $ sudo su - -c "R -e \"install.packages('reshape2', repos='http://cran.rstudio.com/')\""
    $ sudo su - -c "R -e \"install.packages('memoise', repos='http://cran.rstudio.com/')\""
    $ sudo su - -c "R -e \"install.packages('maps', repos='http://cran.rstudio.com/')\""

The config file for Shiny Server is at /etc/shiny-server/shiny-server.conf.

Ref:

1. http://rstudio.github.io/shiny-server/latest/#r-installation-location
2. https://www.rstudio.com/products/shiny/download-server/
3. http://www.r-bloggers.com/how-to-get-your-very-own-rstudio-server-and-shiny-server-with-digitalocean/

## System Performance Monitoring

Using command top, we can get the Process ID (PID), CPU/Memory usage for each shiny app.

    $ top -u shiny

**netstat** is a command-line tool that displays all network connections. It can list all connections to a shiny app by specifing its Process ID (PID) using command:

    $ sudo netstat -p | grep <PID>

Now, we have known the CPU/Memory performance and connections number for each shiny app, however, we still don’t know the name of each shiny app, which can be get using command **lsof**:

    $ sudo lsof -p <PID> | grep DIR

Ref:

1. http://tagteam.harvard.edu/hub_feeds/1981/feed_items/536189

## Cron Task

1. Create shiny-system folder via terminal:

    $ mkdir /srv/shiny-system/

2. Create cron folder and keep cpu.R in this folder.

3. Start the crontab editor from a terminal window,

    $ crontab -e

4. Add entries to your own user's crontab file,

    $ * * * * * Rscript /srv/shiny-system/cron/cpu.R

# Arch Linux

## Check release

To check what Linux release you are running on your server:

    $ cat /etc/*-release

    NAME="Arch Linux"
    ID=arch
    PRETTY_NAME="Arch Linux"
    ANSI_COLOR="0;36"
    HOME_URL="https://www.archlinux.org/"
    SUPPORT_URL="https://bbs.archlinux.org/"
    BUG_REPORT_URL="https://bugs.archlinux.org/"

## Install net-tools for netstat

You should Arch package manager - pacman to install net-tools:

    $ sudo pacman -S net-tools

## Install cronie

Install cronie for running cron tasks:

    $ sudo pacman -Syu cronie

Then enable it:

    $ sudo systemctl enable --now cronie.service

Check its status:

    $ systemctl status cronie

Start it:

    $ sudo systemctl start crond

    [citizensense@localhost ~]$ sudo systemctl enable --now cronie.service
    Created symlink from /etc/systemd/system/multi-user.target.wants/cronie.service to /usr/lib/systemd/system/cronie.service.

Ref:

1. https://wiki.archlinux.org/index.php/Cron
2. https://wiki.archlinux.org/index.php/Systemd/Timers#Management status crond

## Set editor

Set editor to your editor:

    $ sudo export EDITOR=vim

## Add cront tasks (as a user)

Note that adding cron tasks as a user does not work on the production/ live server:

    $ crontab -e

    * * * * * Rscript /srv/shiny-system/cron/cpu.R
    ~
    ~
    "/tmp/crontab.8VZ7vq" 1 line, 47 characters

## Add cront tasks (as a root)

On the production server, you should add the cron task as a root or the tasks won't not be executed:

    $ sudo crontab -e

    * * * * * Rscript /srv/shiny-system/cron/specks/cpu.R
    ~
    ~
    "/tmp/crontab.8VZ7vq" 1 line, 47 characters

You can run the cpu.R manually by type this in your terminal,

    $ Rscript /srv/shiny-system/cron/cpu.R

## List cron tasks

Check what tasks are running:

    $ crontab -l

# Final notes

1. Make sure /srv/shiny-system/cron/specks/ folder is set to 777, and cpu.R is set to be executable.
2. Make sure /srv/shiny-server/specks/speck<1-4>/ folders are set to 777, and log.txt in each of them is set to to 777.
