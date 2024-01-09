#
#
# Objective: get the AEMO (WA/SWIS/WEM) Reference Dispatch Solution data
# Author: Grant Coble-Neal
# Dependencies: jsonExtractFunctions.R

library(clock)
library(here)
library(tidyverse)

source(here("R","jsonExtractFunctions.R"))

zone <- "Australia/Perth"

from <- date_time_build(2024, 1, 9, 8, zone = zone)
dates <- date_seq(from, by = duration_minutes(5), total_size = 3)

# create custom function to generate date-time suffix
date_time_suffix <- function(my.string){
  string.digits <- str_remove_all(my.string, "[-: ]")
  
  return( substr( string.digits, 1,nchar(string.digits)-2) )
}

url_stub <- c("https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/dispatchData/current/ReferenceDispatchSolution_")
url_RDS <- paste0(url_stub, date_time_suffix(as.character(from)),".json")
sample.url <- c("https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/dispatchData/current/ReferenceDispatchSolution_202401090800.json")
all.equal(url_RDS,sample.url)
file_name = "ReferenceDispatchSolution.json"
destfile = here('data', file_name)
download.file(url_RDS, destfile)
reference_file <- jsonlite::read_json(destfile)

str(reference_file, max.level = 1) # inspect the first level
reference_file[["data"]] %>% str( max.level = 1)
reference_file[["data"]][["solutionData"]][[1]] %>% str( max.level = 1)
reference_file[["data"]][["solutionData"]][[1]][["facilityScheduleDetails"]] %>% str( max.level = 1)

date_time <- extract_date_time(reference_file)
reference_file %>% purrr::pluck("data", "solutionData", 1, "facilityScheduleDetails", 2) %>% as_tibble() -> df.0

# create a custom function to extract and compile the facility schedule details
number_of_facilities <- length(reference_file[["data"]][["solutionData"]][[1]][["facilityScheduleDetails"]])

get_facility_schedule_details <- function(facility_number = 2, file = reference_file){
  
  file %>% purrr::pluck("data", "solutionData", 1, "facilityScheduleDetails", facility_number) %>% as_tibble() -> df
  return(df)
}

df.0 <- get_facility_schedule_details(facility_number = 72)
# Create a custom function to compile the facility schedule details data
compile_facility_schedule_details <- function(facility_number = 1:number_of_facilities){
  list.0 <- map(facility_number, get_facility_schedule_details)
  df <- bind_rows(list.0)
  return(df)
}

df.1 <- compile_facility_schedule_details()

# To Do:
# (1) Add date-time to file
# (2) Create bulk processor script to compile a time series