
# Objective: create an analytical dataset
# Author: Grant Coble-Neal

library(tidyverse)

analytics_df <- left_join( WEM_data, df.30 ) %>% 
  select( Calendar.Year, Calendar.Month, Calendar.Day, Trading.Date, Interval.Number, Trading.Interval, Operational.Demand..MW., AirTemperature ) %>%
  mutate( cooling = pmax(analytics_df[,"AirTemperature"], 18),
          heating = pmin(analytics_df[,"AirTemperature"], 18)) %>% 
  left_join( PublicHolidays ) %>% 
  mutate( holiday = ifelse( is.na(analytics_df$Public.Holiday), 0,1 ) )

