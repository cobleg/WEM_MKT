
# Objective: create a forecast model of operational demand
# Author: Grant Coble-Neal
# References: https://otexts.com/fpp3/

library(fpp3)

demand <- tsibble(analytics_df, index = Trading.Interval)

demand$Operational.Demand..MW. %>% forecast::mstl(lambda = 0.9, iterate = 100, s.window = "periodic", t.window = 48 * 365) %>% forecast::autoplot() # assess multiple seasonal patterns

gg_season(data = demand, y = Operational.Demand..MW., period = "year") + 
  labs(y = "MW",
       title = "Seasonal plot: Operational Demand",
       subtitle = "Wholesale Electricity Market (WA)")

demand %>% 
    gg_subseries(y = Operational.Demand..MW., period = "month") + 
    labs(y = "MW",
       title = "Seasonal plot: Operational Demand",
       subtitle = "Wholesale Electricity Market (WA)")

