
# Objective: create a forecast model of operational demand
# Author: Grant Coble-Neal

library(dplyr)
library(forecast)

demand <- ts(analytics_df[, "Operational.Demand..MW."], frequency = 48 * 365, start = c(2018, 1))

demand %>% forecast::mstl(lambda = 0.95, iterate = 100, s.window = "periodic", t.window = 48 * 365) %>% forecast::autoplot() # assess multiple seasonal patterns

fit <- auto.arima(analytics_df[, "Operational.Demand..MW."],
                  xreg = cbind(four)) 