
# Objective: calculate average cooling degree days (CDD) and heating degee days (HDD) by month for Perth, Western Australia

library(lubridate)
library(parsedate)
library(purrr)
library(tidyverse)
library(worldmet)

getMeta(lat = -31.95224, lon = 115.8614) # check the latitude and longitude, should indicate Perth, Western Australia & obtain weather station code

year <- seq(from = 2018, to = 2022, by = 1)

data <- map(year, worldmet::importNOAA, code = "946100-99999")

df <- data %>% bind_rows() %>%
  select(date, air_temp) %>% 
  mutate( Calendar.Year = lubridate::year(date),
          Calendar.Month = lubridate::month(date),
          Calendar.Day = lubridate::day(date) 
          ) %>% 
  group_by(Calendar.Year, Calendar.Month,Calendar.Day) 

# create 30 minute version

df.30 <- data.frame(date = as.POSIXct(seq(min(df$date), max(df$date), by = '30 min'))) %>% 
  left_join(df) %>% 
  mutate(minutes = minute(date),
    AirTemperature = ifelse(minutes == 30, (lag(air_temp) + lead(air_temp))/2, air_temp), 
    Trading.Interval = date) %>%  
  select(Trading.Interval, AirTemperature)

subdirectory <- c("data")
wd <- getwd()
filePath2 <- file.path(wd, subdirectory, paste0("weather.rds"))

write.csv(df.30, file = './data/weather.csv')
saveRDS(WEM_data, filePath2)

