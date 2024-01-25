#
#
# Objective: get SWIS substation spatial data
# Author: Grant Coble-Neal
# Dependencies: nil

library(devtools)
library(ggplot2)
library(here)
library(leafgl)
library(leaflet)
library(sf)
library(tidyverse)

# Get the SWIS spatial data set ----
# URL: https://data-downloads.slip.wa.gov.au/ExtractDownload/DownloadFile/816510
# Requires SLIP WA log-in account

SWIS <- sf::st_read(here("data", "NCMT_Existing_Substations_Terminals_Power_Stations.shp")) %>% 
  st_transform(4326)


# Get the map of Australia for context ----
URL.Australia <- c("https://www.abs.gov.au/statistics/standards/australian-statistical-geography-standard-asgs-edition-3/jul2021-jun2026/access-and-downloads/digital-boundary-files/AUS_2021_AUST_SHP_GDA2020.zip")
download.file(URL.Australia, destfile = 'Australia.zip')
unzip(zipfile = 'Australia.zip', exdir = here('data'))

Aust <- sf::st_read(here("data", "AUS_2021_AUST_GDA2020.shp")) %>% 
  st_transform(4326)


# Map the files ----
ggplot() +
  geom_sf(data = Aust) + 
  geom_sf(data = SWIS) +
  coord_sf()
  
