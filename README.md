# Airsift
The Airsift PM2.5 and Airsift Frackbox, Data Analysis Toolkits have been developed by Citizen Sense for use with citizen-generated air quality data collected in Pennsylvania as part of the “Pollution Sensing” project area.For more information see http://www.citizensense.net/psresources/about-airsift/. The toolkit is Free and Open Source. 

# Credits

The research leading to these results has received funding from the European Research Council under the European Union's Seventh Framework Programme (FP/2007-2013) / ERC Grant Agreement n. 313347, “Citizen Sensing and Environmental Practice: Assessing Participatory Engagements with Environments through Sensor Technologies.” For more information on the project and contributors, see http://www.citizensense.net

# License

The source code for Airsift, Airsift pm2.5 and Airsift frackbox, Copyright (C) <2016>  Citizen Sense is distributed under the terms of the GNU GPL.   

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. 

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>. 

Airsift incorporates code from openair, Copyright © 2015 David C. Carslaw. Openair is distributed under the terms of the GNU GPL.

Airsift incorporates code from Shiny, Rstudio.  The shiny package as a whole is distributed under GPL-3.


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

    $ * * * * * Rscript /srv/shiny-system/cron/specks/cpu.R
    $ * * * * * Rscript /srv/shiny-system/cron/fracks/cpu.R

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

    * * * * * Rscript /srv/shiny-system/cron/specks/cpu.R
    * * * * * Rscript /srv/shiny-system/cron/fracks/cpu.R
    ~
    ~
    "/tmp/crontab.8VZ7vq" 1 line, 47 characters

## Add cront tasks (as a root)

On the production server, you should add the cron task as a root or the tasks won't not be executed:

    $ sudo crontab -e

    * * * * * Rscript /srv/shiny-system/cron/specks/cpu.R
    * * * * * Rscript /srv/shiny-system/cron/fracks/cpu.R
    ~
    ~
    "/tmp/crontab.8VZ7vq" 1 line, 47 characters

Add vim to your crontab editor env that makes it easy to edit the cron tasks:

    $ sudo EDITOR=vim crontab -e

You can run the cpu.R manually by type this in your terminal,

    $ Rscript /srv/shiny-system/cron/specks/cpu.R
    $ Rscript /srv/shiny-system/cron/fracks/cpu.R

Ref:

1. https://bbs.archlinux.org/viewtopic.php?id=78700
2. https://archlinuxarm.org/forum/viewtopic.php?f=53&t=6281

## List cron tasks

Check what tasks are running:

    $ sudo crontab -l

# Final notes

1. Make sure /srv/shiny-system/cron/specks/ folder is set to 777, and cpu.R is set to be executable.
2. Make sure /srv/shiny-server/specks/speck<1-4>/ folders are set to 777, and log.txt in each of them is set to to 777.
