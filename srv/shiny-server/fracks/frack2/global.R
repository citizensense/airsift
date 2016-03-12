# Load package - for googlemaps.
library(plyr)

# Load package.
library(shiny)

# Load package.
library("RSQLite")

# Load package.
library("openair")

# Load package.
library(reshape2)

# Load package - cache
library(memoise)

# Connect to the sqlite file.
# Localhost.
DB <- dbConnect(SQLite(), dbname = "../../../shiny-system/data/db.sqlite3")

# Live server.
# DB <- dbConnect(SQLite(), dbname="../../../db.sqlite3")
