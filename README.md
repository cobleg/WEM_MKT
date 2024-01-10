# WEM_MKT
Modelling electricity market dynamics in the Wholesale Electricity Market (WEM). As the WEM accumulates more Variable Renewable Energy (VRE) resources, we observe evolving market dynamics, which impacts on future investment in large-scale electricity generation. This project provides methods of analysing evolving market dynamics by statistically modelling observed operational demand and balancing prices, controlling for causal drivers such as temperature variation, public and weekend effects, solar irradiance variation as well as latent factors.

## Update to market rules
As of 1 October 2023, the WEM is now in a 'post-reform' phase. Among other things, this has changed the data sources, formats and what is tracked (e.g. facility level data is now available). Scripts are updated as new data becomes available. This has a consequential impact on the modelling required in this project.

# Ventity model
A model of the Wholesale Electricity Market has been created in [Ventity](https://ventity.biz/). Ventity provides a visual presentation of the model logic and integrates nicely with Excel. The model design is centred on time series dynamics driven by autonomous growth of households. A Commercial sector is represented with the number of commercial sites (treated as a distinct electricity connection point) growing in proportion to the number of households.

Weather and non-weather dynamics are included to capture the typical demand profile over the course of each year. The time interval (aka frequency) is monthly.

This model is intended to be a simple 'ready reckoner' that provides a formal benchmark of expectations over the forecast horizon. This makes the model a useful benchmark against real operational demand data. Sustained deviations from real data prompts investigation to establish the cause. Note that this includes Distributed Energy Resource growth, which accounts for a component of demand reduction.
