
# Objective: create a public holiday dataset for Western Australia
# Author: Grant Coble-Neal

PublicHolidays <- dplyr::tibble( Trading.Date = as.character(c("2018-01-01", "2018-01-26", "2018-03-05", "2018-03-30",
                                                     "2018-04-02", "2018-04-25", "2018-06-04", "2018-09-24",
                                                     "2018-12-25", "2018-12-26",
                                                     "2019-01-01", "2019-01-28", "2019-03-04", "2019-04-19",
                                                     "2019-04-22", "2019-04-25", "2019-06-03", "2019-09-30",
                                                     "2019-12-25", "2019-12-26",
                                                     "2020-01-01", "2020-01-27", "2020-03-02", "2020-04-10",
                                                     "2020-04-13", "2020-04-25", "2020-04-27", "2020-06-01",
                                                     "2020-09-28", "2020-12-25", "2020-12-26", "2020-12-28",
                                                     "2021-01-01", "2021-01-26", "2021-03-01", "2021-04-02",
                                                     "2021-04-05", "2021-04-25", "2021-04-26", "2021-06-07",
                                                     "2021-09-27", "2021-12-25", "2021-12-26", "2021-12-27",
                                                     "2021-12-28", 
                                                     "2022-01-01", "2022-01-03", "2022-01-26", "2022-03-07",
                                                     "2022-04-15", "2022-04-17", "2022-04-18", "2022-04-25",
                                                     "2022-06-06", "2022-09-26", "2022-12-25", "2022-12-26",
                                                     "2022-12-27")),
                                 Public.Holiday = c("New Year's Day", "Australia Day", "Labour Day", "Good Friday",
                                                    "Easter Monday", "ANZAC Day", "Western Australia Day", "Queen's Birthday",
                                                    "Christmas Day", "Boxing Day",
                                                    "New Year's Day", "Australia Day", "Labour Day", "Good Friday",
                                                    "Easter Monday", "ANZAC Day", "Western Australia Day", "Queen's Birthday",
                                                    "Christmas Day", "Boxing Day",
                                                    "New Year's Day", "Australia Day", "Labour Day", "Good Friday",
                                                    "Easter Monday", "ANZAC Day", "ANZAC Day Holiday", "Western Australia Day", "Queen's Birthday",
                                                    "Christmas Day", "Boxing Day", "Boxing Day Holiday",
                                                    "New Year's Day", "Australia Day", "Labour Day", "Good Friday", 
                                                    "Easter Monday", "ANZAC Day", "ANZAC Day Holiday", "Western Australia Day",
                                                    "Queen's Birthday", "Christmas Day", "Boxing Day", "Christmas Day Holiday", "Boxing Day Holiday",
                                                    "New Year's Day", "New Year's Day Holiday", "Australia Day", "Labour Day", "Good Friday", 
                                                    "Easter Sunday", "Easter Monday", "ANZAC Day", "Western Australia Day",
                                                    "Queen's Birthday", "Christmas Day", "Boxing Day", "Boxing Day Holiday"))



