#
#
# Objective: get AEMO solution file data, explore its structure and extract the desired data frames
# Author: Grant Coble-Neal
# Dependencies: nil
# Source: https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/weekAheadDispatchData/previous/
# References: 
# (1) https://cran.r-project.org/web/packages/tidyjson/vignettes/introduction-to-tidyjson.html
# (2) https://themockup.blog/posts/2020-05-22-parsing-json-in-r-with-jsonlite/

library(here)
library(jsonlite)
library(rjson)
library(tidyjson)
library(tidyverse)


# url_solution_file <- "https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/weekAheadDispatchData/previous/DispatchSolutionWeekAhead_20230930.zip"
#  download.file(url_solution_file, destfile = 'DispatchSolution.zip')
# unzip(zipfile = 'DispatchSolution.zip', exdir = here('data'))
solution_file <- jsonlite::fromJSON("data/ReferenceWeekAhead-DispatchSolution_202309290800.json")

# explore the data ----

str(solution_file, max.level = 1) # inspect the first level
solution_file[["data"]][["solutionData"]] %>% str(max.level = 1) # this displays the available data
solution_file[["data"]][["solutionData"]][["schedule"]] %>% str(max.level = 1)
solution_file[["data"]][["solutionData"]][["schedule"]][[1]] %>% str(max.level = 1)

# Compile the data ----

# get primary dispatch interval
solution_file %>% purrr::pluck("data", "primaryDispatchInterval") -> primaryDispatchInterval
string_length = nchar(primaryDispatchInterval)

Date = str_sub(primaryDispatchInterval, 1, 10)
Time = str_sub(primaryDispatchInterval, string_length-4, string_length)
Date_Time = paste(Date, Time, sep = " ")

# Create custom function to add date-time to each data frame
add_date_time <- function(df){
  df %>% mutate(
    DateTime = ymd_hm(Date_Time)
  ) %>% relocate(DateTime) -> df.0
  return(df.0)
}

# Create a custom function to select the desired data frame
get_data_frame <- function(df.name = "constraints"){
  solution_file %>% purrr::pluck("data", "solutionData", df.name, 1) -> df.0
  df.0 %>% add_date_time() -> df.1
  
  # check if the last column is a list
  column.number = ncol(df.1)
  if(is.list(df.1[column.number])){
    # if the last column is a list then flatten the data frame
    df.1 %>% unnest(all_of(column.number)) -> df.1
  }

  return(df.1)
}

# Create a custom function to extract the desired data frames
extract_data_frames <- function(my.list = c("schedule", "dispatchCaps", "constraints")){
  list.0 <- map(my.list, get_data_frame) %>%  setNames(my.list)
  #df <- bind_rows(list.0)
  return(list.0)
}

data_extract <- extract_data_frames()

# Export the extracted data
data_extract %>% iwalk(~ write_csv(.x, file = here("data", paste0(.y, ".csv"))))

