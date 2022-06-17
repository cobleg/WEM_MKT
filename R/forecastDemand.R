
# Objective: create a forecast model of operational demand
# Author: Grant Coble-Neal

library(fpp3)

demand <- ts(analytics_df[, "Operational.Demand..MW."], frequency = 48 * 365, start = c(2018, 1))

demand %>% forecast::mstl(lambda = 0.95, iterate = 100, s.window = "periodic", t.window = 48 * 365) %>% forecast::autoplot() # assess multiple seasonal patterns

analytics_ts <- tsibble( analytics_df )
autoplot(analytics_ts, Operational.Demand..MW.) + 
  labs( title = "Operational Demand",
        subtitle = "Wholesale Electricity Market (WA)",
        y = "MW")

analytics_ts %>% 
  gg_season(Operational.Demand..MW., labels = "both") +
  labs(y = "MW",
       title = "Seasonal plot: Operational Demand")

analytics_ts %>% 
  gg_season(AirTemperature, labels = "both") +
  labs(y = "Celsius",
       title = "Seasonal plot: Temperature")

fit <- analytics_ts %>% 
  model( ARIMA(Operational.Demand..MW. ~ cooling + heating + 
                 fourier(period = "day", K = 10) + 
                 fourier(period = "week", K = 5) +
                 fourier(period = "year", K = 3)) )
fit$ARIMA$fitted
