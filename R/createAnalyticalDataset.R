
# Objective: create an analytical dataset
# Author: Grant Coble-Neal

library(tidyverse)

WEM_data <- WEM_data %>% mutate(Trading.Interval = as.POSIXct(Trading.Interval, format = "%Y-%m-%d %H:%M:%S"))

analytics_df <- inner_join( WEM_data, df.30 ) %>% 
  select( Calendar.Year, Calendar.Month, Calendar.Day, Trading.Date, Interval.Number, Trading.Interval, Operational.Demand..MW., AirTemperature ) 

analytics_df <- analytics_df %>%
  mutate( cooling = pmax(analytics_df[,"AirTemperature"], 18),
          heating = pmin(analytics_df[,"AirTemperature"], 18)) 

analytics_df <- analytics_df %>% 
  left_join( PublicHolidays ) 

analytics_df <- analytics_df %>% 
  mutate( holiday = ifelse( is.na(analytics_df$Public.Holiday), "Normal", "Holiday" ) )

