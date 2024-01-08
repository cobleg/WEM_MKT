#
#
# Objective:
# Author: Grant Coble-Neal
# Dependencies: 

library(here)
library(tidyverse)

URL <- c("https://direct-download.slip.wa.gov.au/datadownload/WP_Public_Secure/Substations_Terminals_PowerStations_WP_046_WA_GDA2020_Public_Secure_Shapefile.zip")
download.file(URL, destfile = 'WesternPower.zip')
"Substations_Terminals_PowerStations_WP_046.shp"
unzip(zipfile = 'WesternPower.zip', exdir = here('data'))