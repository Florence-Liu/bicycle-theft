#### Preamble ####
# Purpose: Downloads and saves the data about Bicycle Theft in Toronto from opendatatoronto
# Author: Yufei Liu
# Date: 2 Oct 2023
# Contact: florence.liu@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download data ####
# The package has multiple datasets with different file type and modified date.
# We choose the most up-to-date version and a csv file.
# Use head() to review the dataset id we want.
bicycle_theft <- list_package_resources("c7d34d9b-23d2-44fe-8b3b-cd82c8b38978") |>
  filter(id == "55136dac-26b1-4028-b9f5-7c2344f94153") |>
  get_resource()



#### Save data ####
write_csv(bicycle_theft, "inputs/data/bicycle_theft.csv") 
