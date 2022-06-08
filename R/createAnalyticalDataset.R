
# Objective: create an analytical dataset
# Author: Grant Coble-Neal

library(tidyverse)

analytics_df <- left_join(WEM_data, df.30) %>% 
  select(Trading.Date, Interval.Number, Trading.Interval, Operational.Demand..MW., AirTemperature) %>% 
  left_join( PublicHolidays)
