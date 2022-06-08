
# Objective: create a forecast model of operational demand
# Author: Grant Coble-Neal

library(dplyr)
library(forecast)

demand <- analytics_df[, "Operational.Demand..MW."]

demand %>% forecast::mstl() %>% forecast::autoplot() # assess multiple seasonal patterns

fit <- auto.arima(analytics_df[, "Operational.Demand..MW."],
                  xreg = cbind(four)) 