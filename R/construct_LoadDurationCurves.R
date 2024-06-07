#
#
# Objective: create load duration curves
# Author: Grant Coble-Neal
# Dependencies: 

library(ggplot2)
library(here)
library(tidyverse)

df <- readRDS("~/R/WEM_MKT/data/WEM_operational_demand.rds")

df %>% 
  mutate(
  Year = year(Trading.Date)
) %>% select(c(Year, Operational.Demand..MW.)) %>% 
  group_by(Year) %>% arrange(Year, -Operational.Demand..MW.) %>% 
  mutate(
    Index = row_number(Year)
  )  -> df.1

# Create chart
ggplot(data = df.1, aes(x = Index, y = Operational.Demand..MW., group = Year, colour = Year), ) + 
  geom_line() +
  ggtitle( paste0("SWIS Load Duration Curve by Year")) + 
  xlab("Market Interval (30 minutes)") + 
  ylab("MW") +
  theme_bw()

# export the data
write.csv(df.1, here("data", "SWIS_LoadDurationCurves.csv"), row.names = FALSE)
