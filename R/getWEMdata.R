
# Objective: get and compile operational demand data from the WEM
# Author: Grant Coble-Neal

library(stringr)
year <- 2022
prefix <- c("operational-demand-")
filePath <- c("https://data.wa.aemo.com.au/datafiles/operational-demand/")

subdirectory <- c("data")
wd <- getwd()
filePath2 <- file.path(wd, subdirectory, paste0("WEM_operational_demand.rds"))
datalist = list()

for (myYear in 2018:2022)
{
  year <- str_pad(myYear, 2, "left", pad="0")
  file <- c(paste0(prefix, year, ".csv" ))
  myURL <- paste0(filePath, file)
  
  df <- read.csv(myURL)
  datalist[[myYear]] <- df # add to list
}


# append files
WEM_data = do.call(rbind, datalist)

WEM_data$Trading.Interval = as.POSIXct(WEM_data$Trading.Interval, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")


# save file
saveRDS(WEM_data, filePath2)
