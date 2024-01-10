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
dates <- date_seq(from, by = duration_minutes(5), total_size = 288)

# create custom function to generate date-time suffix
date_time_suffix <- function(my.date_time = as.Date(c("2023-09-28"))){
  date_time_string = as.character(my.date_time)
  string.digits <- str_remove_all(date_time_string, "[-: ]")
  if(nchar(date_time_string)==10){
    string.digits <- substr( string.digits, 1,nchar(string.digits))
  }else{
    string.digits <- substr( string.digits, 1,nchar(string.digits)-2)
  }
  return( string.digits )
}

date.digits <- date_time_suffix(from)

# URL construction test ----
url_stub <- c("https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/dispatchData/current/ReferenceDispatchSolution_")
url_RDS <- paste0(url_stub, date_time_suffix(as.character(from)),".json")
sample.url <- c("https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/dispatchData/current/ReferenceDispatchSolution_202401090800.json")
all.equal(url_RDS,sample.url)
file_name = "ReferenceDispatchSolution.json"
destfile = here('data', file_name)
download.file(url_RDS, destfile)


# Read & interrograte the downloaded file ----
reference_file <- jsonlite::read_json(destfile)

str(reference_file, max.level = 1) # inspect the first level
reference_file[["data"]] %>% str( max.level = 1)
reference_file[["data"]][["solutionData"]][[1]] %>% str( max.level = 1)
reference_file[["data"]][["solutionData"]][[1]][["facilityScheduleDetails"]] %>% str( max.level = 1)

date_time <- extract_date_time(reference_file)
reference_file %>% purrr::pluck("data", "solutionData", 1, "facilityScheduleDetails", 2) %>% as_tibble() -> df.0


number_of_facilities <- length(reference_file[["data"]][["solutionData"]][[1]][["facilityScheduleDetails"]])

# create a custom function to extract and compile the facility schedule details ----
get_facility_schedule_details <- function(facility_number = 2, file = reference_file){
  
  file %>% purrr::pluck("data", "solutionData", 1, "facilityScheduleDetails", facility_number) %>% as_tibble() -> df
  return(df)
}

df.0 <- get_facility_schedule_details(facility_number = 72)

# Create a custom function to compile the facility schedule details data ----
compile_facility_schedule_details <- function(facility_number = 1:number_of_facilities){
  list.0 <- map(facility_number, get_facility_schedule_details)
  df <- bind_rows(list.0)
  return(df)
}

# Add date-time to the data frame ----
df.1 <- compile_facility_schedule_details() %>% mutate(
  DateTime = dates[1]
) %>% relocate(DateTime)

# To Do:

# Create bulk processor script to compile a time series ----

# Step 1: construct the list of data files URLs
url.dispath.solution.files <- "https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/dispatchData/previous/"
from <- as.Date(c("2023-09-28"))
to <- as.Date(Sys.Date()-1)
dates <- date_seq(from=from, to=to, by = duration_days(1))

getDSR.data <- function(date = dates[1]){

  date.digits <- date_time_suffix(my.date_time = date)
  url_stub <- "https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/dispatchData/previous/DispatchSolutionReference_"
  url_DSR <- paste0(url_stub, date.digits,".zip")
  sample.URL <- "https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/dispatchData/previous/DispatchSolutionReference_20230928.zip"
  all.equal(url_DSR, sample.URL) # test constructed URL
  
  # Step 2: download the files
  destfile = here('temp', 'DispatchSolutionReference.zip')
  options(timeout = max(1000, getOption("timeout")))
  download.file(url_DSR, destfile, overwrite=TRUE)
  unzip(zipfile = here('temp', 'DispatchSolutionReference.zip'), exdir = here('data'))
  file.remove(here('temp', 'DispatchSolutionReference.zip')) # delete zip file
  
  # Step 3: read the files
  file.list <- get.file.list()
  reference_file <- jsonlite::read_json(here("data", file.list[2]))
  
  # Step 4: get the target data & add the date-time to it
  date.time <- reference_file[["data"]][["primaryDispatchInterval"]]
  string_length = nchar(date.time)
  Date = str_sub(date.time, 1, 10)
  Time = str_sub(date.time, string_length-4, string_length)
  Date_Time = ymd_hm(paste(Date, Time, sep = " "))

  df.1 <- compile_facility_schedule_details() %>% mutate(
    DateTime = Date_Time
  ) %>% relocate(DateTime)
  
  return(df.1)
}

df <- getDSR.data()

# Save the data to disk ----
df.1 <- df
dt.character = as.character(Date_Time)
dt.suffix <- date_time_suffix(dt.character)
save(df.1, file = here("data", paste0("RDS_", dt.suffix, ".RData")))
rm(df.1)

# remove files once processed
json.files <- list.files( path=here('data'), pattern="(\\.json)$", full.names=TRUE )
file.remove(json.files)

# helper function to get list of files
get.file.list <- function(){
  return( list.files(path = here("data"), pattern = '*.json') )
}
