
# Objective: create a forecast model of operational demand
# Author: Grant Coble-Neal
# Reference: https://otexts.com/fpp3/

library(fpp3)

demand <- tsibble(analytics_df, index = Trading.Interval)

demand$Operational.Demand..MW. %>% forecast::mstl(lambda = 0.9, iterate = 100, s.window = "periodic", t.window = 48 * 365) %>% forecast::autoplot() # assess multiple seasonal patterns

annual.demand <- demand %>% 
  index_by(Calendar.Year) %>% 
  select(Calendar.Year, Operational.Demand..MW.) %>% 
  summarise(Annual.Demand.GWh = sum(Operational.Demand..MW./2000))

demand.quarterly <- demand %>% 
  mutate( Quarter = lubridate::quarter(Trading.Interval, type = "year.quarter")) %>% 
  index_by(Quarter) %>% 
  summarise(Demand.Qtr.GWh = sum(Operational.Demand..MW./2000))

demand.monthly <- demand %>% 
  mutate(Trading.Date = lubridate::date(Trading.Interval)) 

demand.weekly <- demand %>% 
  mutate( Week = lubridate::week(Trading.Interval)) %>% 
  summarise( Demand.Week.MWh = sum(Operational.Demand..MW./2))

demand.daily <- demand %>% 
  mutate(Trading.Date = lubridate::date(Trading.Interval)) %>% 
  select(Trading.Date, Operational.Demand..MW.) 

demand.daily <- demand.daily %>% 
  index_by(Trading.Date) %>% 
  summarise( Demand.Daily.MWh = sum(Operational.Demand..MW./2))

demand.monthly <- demand.daily %>% 
  index_by(Year_Month = ~ yearmonth(.)) %>% 
  summarise( Demand.Month.GWh = sum(Demand.Daily.MWh/1000)) %>% 
  filter(lubridate::year(Year_Month) < 2022)

gg_season(data = demand, y = Operational.Demand..MW., period = "year") + 
  labs(y = "MW",
       title = "Seasonal plot: Operational Demand",
       subtitle = "Wholesale Electricity Market (WA)")

demand.monthly %>% 
    gg_subseries(y = Demand.Month.GWh, period = "year") + 
    labs(y = "GWh",
       title = "Seasonal plot: Operational Demand",
       subtitle = "Wholesale Electricity Market (WA)")

