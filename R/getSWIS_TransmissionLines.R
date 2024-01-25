#
#
# Objective: get SWIS transmission line data
# Author: Grant Coble-Neal
# Dependencies: 

library(here)
library(sf)
library(tidyverse)

URL.SWIS_TransmissionLines <- "https://direct-download.slip.wa.gov.au/datadownload/WP_Public_Secure/Transmission_Overhead_Powerlines_WP_032_WA_GDA2020_Public_Secure_Shapefile.zip"
# download.file(URL.SWIS_TransmissionLines, destfile = 'SWIS_Lines.zip')
unzip(zipfile = 'Transmission_Overhead_Powerlines_WP_032_WA_GDA2020_Public_Secure_Shapefile.zip', exdir = here('data'))


SWISLines <- sf::st_read(here("data", "Transmission_Overhead_Powerlines_WP_032.shp"))

Aust <- sf::st_read(here("data", "AUS_2021_AUST_GDA2020.shp")) %>% 
  st_transform(4326)


# Map the files ----
ggplot() +
  geom_sf(data = Aust) + 
  geom_sf(data = SWISLines) +
  coord_sf()

# extract line names from shapefile ----
LineNames <- SWISLines['line_name']
