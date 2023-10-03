#### Preamble ####
# Purpose: Cleans the Bicycle Theft data from OpenDataToronto
# Author: Yufei Liu
# Date: 2 Oct 2023
# Contact: florence.liu@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(janitor)

#### Read in the raw data ####
raw_data <- read_csv("inputs/data/bicycle_theft.csv", show_col_types = FALSE)


#### Clean data ####\
cleaned_data <-
  raw_data |>
  janitor::clean_names() |> # to make variables name easier to read
  # select our variable of interest
  select(occ_year, occ_date, report_date, premises_type, status) |> 
  tidyr::drop_na()

cleaned_data <- 
  # add a new column showing the difference in days between the report date and occurrence date
  # add a new column showing the numerical expression of occurrence month as a character
  cleaned_data |> mutate(difference = as.numeric(report_date - occ_date),
                         occ_month = as.character(month(occ_date))) |>
  # filter to get thefts of which occurrence year between 2014 and 2022
  filter(occ_year >= 2014 & occ_year <= 2022) |>
  # make the numerical occurrence yeaer as a character
  mutate(occ_year = as.character(occ_year)) |>
  # rename columns to be more readable
  rename(location = premises_type, bicycle_status = status) |>
  # drop columns that will not be used in the analysis
  select(occ_year, occ_month, difference, location, bicycle_status)


#### Data validation ####
# Referencing data from: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html


# Check that occurrence_year are all between 2014 and 2022
cleaned_data$occ_year |> as.numeric() |> max() <= 2022
cleaned_data$occ_year |> as.numeric() |> min() >= 2014


# Check that occurrence_month are all between 1 and 12
cleaned_data$occ_month |> as.numeric() |> max() <= 12
cleaned_data$occ_month |> as.numeric() |> min() >= 1


# Check that the difference in days between the occurrence date and report date is positive
cleaned_data$difference |> min() <= 0



# Check variable types
cleaned_data$occ_year |> class() == "character"
cleaned_data$occ_month |> class() == "character"
cleaned_data$difference |> class() == "numeric"
cleaned_data$location |> class() == "character"
cleaned_data$bicycle_status |> class() == "character"



#### Save data ####
write_csv(cleaned_data, "outputs/data/cleaned_bicycle_theft.csv")
