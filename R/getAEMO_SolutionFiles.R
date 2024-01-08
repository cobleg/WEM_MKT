#
#
# Objective: get AEMO solution file data
# Author: Grant Coble-Neal
# Dependencies: 
# Source: https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/weekAheadDispatchData/previous/
# References: (1) https://cran.r-project.org/web/packages/tidyjson/vignettes/introduction-to-tidyjson.html

library(here)
library(jsonlite)
library(rjson)
library(tidyjson)
library(tidyverse)


url_solution_file <- "https://data.wa.aemo.com.au/public/market-data/wemde/dispatchSolution/weekAheadDispatchData/previous/DispatchSolutionWeekAhead_20230930.zip"
download.file(url_solution_file, destfile = 'DispatchSolution.zip')
unzip(zipfile = 'DispatchSolution.zip', exdir = here('data'))
solution_file <- jsonlite::fromJSON("data/ReferenceWeekAhead-DispatchSolution_202309290800.json")

solution_file$data$solutionData$schedule[1] %>% 
  as_tibble() -> solution

solution_file.0 <- flatten(solution_file)$solutionData
head(solution_file.0)

solution_file.2 <- solution_file %>% tidyr::unnest(data)


# get number of columns needed
rgx_split <- "\\."
n_cols_max <-
  solution_file.1 %>%
  pull(name) %>% 
  str_split(rgx_split) %>% 
  map_dbl(~length(.)) %>% 
  max()
n_cols_max

# separate the columns
nms_sep <- paste0("name", 1:n_cols_max)
solution_file.2 <-
  solution_file.1 %>% 
  separate(name, into = nms_sep, sep = rgx_split, fill = "right")

solution_file.2 %>% pivot_longer(
  cols = c(name3:name5),
  names_to = "col_name",
  values_to="classes"
) -> solution_file.3

solution_file.3  %>%  select(
  name2, classes, value
) -> solution_file.4

names(solution_file.4) <- c("Class", "Classes", "Value")

solution_file.4 %>% pivot_wider(
  names_from = Classes,
  values_from = Value
) -> solution_file.5
