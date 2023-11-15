#
#
# Objective: get SWIS substation spatial data
# Author: Grant Coble-Neal
# Dependencies: nil

library(ggplot2)
library(here)
library(sf)
library(tidyverse)

# Get the SWIS spatial data set ----
# URL: https://data-downloads.slip.wa.gov.au/ExtractDownload/DownloadFile/816510
# Requires SLIP WA log-in account

SWIS <- sf::st_read(here("data", "NCMT_Existing_Substations_Terminals_Power_Stations.shp"))

# Get the map of Australia for context ----
URL.Australia <- c("https://www.abs.gov.au/statistics/standards/australian-statistical-geography-standard-asgs-edition-3/jul2021-jun2026/access-and-downloads/digital-boundary-files/AUS_2021_AUST_SHP_GDA2020.zip")
download.file(URL.Australia, destfile = 'Australia.zip')
unzip(zipfile = 'Australia.zip', exdir = here('data'))

Aust <- sf::st_read(here("data", "AUS_2021_AUST_GDA2020.shp"))

# Map the file ----

SWIS.map <- ggplot() +
  # geom_sf(data = Aust, size = 5, colour ="black") +
  geom_sf(data = SWIS, colour ="black") +
  coord_sf() +
  theme_bw()

SWIS.map

library(ggmap)

qmap('kalgoorlie', zoom = 6, maptype='roadmap', shapefiles = SWIS)
  