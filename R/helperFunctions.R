#
#
# Objective: contains a set of helper functions
# Author: Grant Coble-Neal
# Dependencies: nil

library(here)
library(tidyverse)

# create custom function to generate date-time suffix ----
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

# helper function to get list of files ----
get.file.list <- function(){
  return( list.files(path = here("data"), pattern = '*.json') )
}

# custom function to extract and compile the facility schedule details ----
get_facility_schedule_details <- function(facility_number = 1:72){
  
  file %>% purrr::pluck("data", "solutionData", 1, "facilityScheduleDetails", facility_number) %>% as_tibble() -> df
  return(df)
}

# Custom function to compile the facility schedule details data ----
compile_facility_schedule_details <- function(facility_number = 1){
  list.0 <- map(facility_number, get_facility_schedule_details())
  df <- bind_rows(list.0)
  return(df)
}
