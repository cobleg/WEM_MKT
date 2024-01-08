#
#
# Objective: get facilities list
# Author: Grant Coble-Neal
# Dependencies: 

library(here)
library(XML)
library(tidyverse)

url_facilities <- "https://data.wa.aemo.com.au/datafiles/post-facilities/facilities.csv"

facilities <- read.csv(url_facilities)[,1:6]

names(facilities) <- c("Participant.Code", "Participant.Name", "Facility.Code", "Facility.Class", "System.Size.MW", "Remaining.Capacity.MW")
