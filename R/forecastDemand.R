
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
  filter_index(~ "2022-05")

gg_season(data = demand, y = Operational.Demand..MW., period = "year") + 
  labs(x = "Month",
       y = "MW",
       title = "Seasonal plot: Operational Demand",
       subtitle = "Wholesale Electricity Market (WA)")

demand.monthly %>% 
    gg_subseries(y = Demand.Month.GWh, period = "year") + 
    labs(x = "Year",
         y = "GWh",
       title = "Seasonal plot: Operational Demand",
       subtitle = "Wholesale Electricity Market (WA)")

year <- 2021
myTitle <- paste0("Wholesale Electricity Market: ", year)
demand %>% 
  filter(year(Trading.Interval) == year) %>% 
  ggplot(aes(x = AirTemperature, y = Operational.Demand..MW.)) + 
  geom_point() + 
  labs( x= "Ambient temperature (degrees Celsius)",
        y = "Electricity demand (MW)",
        title = "Wholesale Electricity Market: 2021")



demand.longer <- demand %>%
  mutate(Calendar.Year = as.character(Calendar.Year)) %>% 
  select(!c(Calendar.Day, Trading.Date, Public.Holiday)) %>%
  group_by(Calendar.Year) %>% 
  pivot_longer(cols = !c(Trading.Interval, Calendar.Year, Calendar.Month, holiday),
               names_to = "name",
               values_to = "value")
demand.longer %>% 
  ggplot(aes( x = Trading.Interval, y = value )) + 
  geom_line() +
  facet_grid(vars(holiday)) + 
  labs(title = "Wholesale Electricity Market: Operational Demand",
       y = "MW")

demand.longer %>% 
  select(!c("Calendar.Year", "Calendar.Month", "Trading.Interval", "holiday")) %>% 
  pivot_wider(values_from = value, names_from = name) %>% 
  GGally::ggpairs() 

demand.longer %>%
  filter(name == "Operational.Demand..MW.") %>% 
  group_by( Calendar.Year, Calendar.Month, holiday) %>% 
  summarise(Monthly.Demand.GWh = sum(value/2000)) %>% 
  features(Monthly.Demand.GWh, feat_stl) %>% 
  ggplot(aes(x = trend_strength, y = seasonal_strength_hour, col = c(Calendar.Year))) +
  geom_point() + 
  facet_wrap(vars(Calendar.Month, holiday ))
