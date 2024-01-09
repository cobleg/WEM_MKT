#
#
# Objective: custom functions needed for extracting data from json files
# Author: Grant Coble-Neal
# Dependencies: nil

library(here)
library(tidyverse)

## Extract the date-time from the selected file
extract_date_time <- function(solution_file){

  # get primary dispatch interval
  solution_file %>% purrr::pluck("data", "primaryDispatchInterval") -> primaryDispatchInterval
  string_length = nchar(primaryDispatchInterval)
  
  Date = str_sub(primaryDispatchInterval, 1, 10)
  Time = str_sub(primaryDispatchInterval, string_length-4, string_length)
  Date_Time = paste(Date, Time, sep = " ")
  
  return(Date_Time)
}

extract_date_time(solution_file = reference_file) # Test


# Create custom function to add date-time to each data frame
add_date_time <- function(df, solution_file){
  Date_Time <- extract_date_time(solution_file)
  df %>% mutate(
    DateTime = ymd_hm(Date_Time)
  ) %>% relocate(DateTime) -> df.0
  return(df.0)
}

add_date_time(solution_file = reference_file)

# Create a custom function to select the desired data frame
get_data_frame <- function(solution_file, df.name = "dispatchTotal"){
  if(df.name == "dispatchTotal"){
    solution_file %>% purrr::pluck("data", "solutionData", df.name) -> df.0
  }else{
    solution_file %>% purrr::pluck("data", "solutionData", df.name, 1) -> df.0
  }
  
  df.0 %>% add_date_time(solution_file) -> df.1
  
  # check if the last column is a list
  column.number = ncol(df.1)
  if(is.list(df.1[column.number])){
    # if the last column is a list then flatten the data frame
    df.1 %>% unnest(all_of(column.number)) -> df.1
  }
  
  return(df.1)
}

# Create a custom function to extract the desired data frames
extract_data_frames <- function(my.list = c("schedule", "dispatchCaps", "constraints"), solution_file, df.name){
  list.0 <- map(my.list, get_data_frame(solution_file, df.name)) %>%  setNames(my.list)
  #df <- bind_rows(list.0)
  return(list.0)
}