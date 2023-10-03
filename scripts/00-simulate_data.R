#### Preamble ####
# Purpose: Simulates dataset about Bicycle Theft in Toronto from 2014 to 2022
# Author: Yufei Liu
# Date: 2 Oct 2023
# Contact: florence.liu@mail.utoronto.ca
# License: MIT

#### Data expectations ####
# The difference in days between the occurrence date and report date is positive and cencered at 0
# Expect more lost outside locations and different location types
# Expect much more stolen status than recovery status
# Have columns: occurrence_year, occurrence_month, difference, location, status

#### Workspace setup ####
library(tidyverse)
library(lubridate)


#### Simulate data ####
set.seed(777) # set a random seed for simulation

## Simulate occurrence date and report date 
n_obs <- 500 # simulated data size

# give range of date
start_date <- as.Date("2014-01-01") 
end_date <- as.Date("2022-12-31")

# generate a group of random date from start_date to end_date
occurrence_date <- sample(seq(start_date,end_date, by="day"), n_obs, replace = TRUE)

# extract year and month from the simulated occurrence_date
occurrence_month <- as.character(month(occurrence_date))
occurrence_year <- as.character(year(occurrence_date))

# generate a positive random difference centered at 0 and decayed until 366 (in case of leap year)
difference <- sample(0:366, size = n_obs, prob = c(0.3, rep(0.25/7,7), rep(0.2/30, 30), rep(0.15/90, 90), 
                                     rep(0.1/239,239)), replace = TRUE)

## Simulate location
# expect 5 location types: Outside, House, Apartment, Commercial, Transit
location <- sample(c("Outside", "House", "Apartment", "Commercial", "Transit"), 
                   n_obs, prob = c(0.3, rep(0.7/4,4)), replace = TRUE)


## Simulate status
# expect 3 status: Stolen, Recovered, Unknown
status <- sample(c("Stolen", "Recovered", "Unknown"), n_obs, prob = c(0.7,0.15,0.15),
                 replace = TRUE)


## Simulated dataset
simulated_data <- data.frame(occurrence_year, occurrence_month, difference,
                             location, status)


## Create graphs of simulated data
# Reference data from https://tellingstorieswithdata.com/05-static_communication.html


# Bar plot for bicycle status and occurrence year
simulated_data |> ggplot(aes(x=occurrence_year, fill=status)) +
  geom_bar()

# Bar plot for occurrence location and occurrence year
simulated_data |> ggplot(aes(x=occurrence_year, fill=location)) +
  geom_bar()

# Scatter plot for difference in days between occurrence date and report date and occurrence year
simulated_data |> ggplot(aes(x=occurrence_year, y=difference)) +
  geom_point()



## Data validation
#  Reference data from: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html

# Check that occurrence_year are all between 2014 and 2022
simulated_data$occurrence_year |> as.numeric() |> max() <= 2022
simulated_data$occurrence_year |> as.numeric() |> min() >= 2014


# Check that occurrence_month are all between 1 and 12
simulated_data$occurrence_month |> as.numeric() |> max() <= 12
simulated_data$occurrence_month |> as.numeric() |> min() >= 1


# Check that the difference in days between the occurrence date and report date is positive
simulated_data$difference |> min() <= 0


# Check there 5 location types
simulated_data$location |> unique() |> sort() == c("Apartment", "Commercial", 
                                                   "House", "Outside", "Transit")

# Check there are 3 status
simulated_data$status |> unique() |> sort() == c("Recovered", "Stolen", "Unknown")

# Check variable types
simulated_data$occurrence_year |> class() == "character"
simulated_data$occurrence_month |> class() == "character"
simulated_data$difference |> class() == "integer"
simulated_data$location |> class() == "character"
simulated_data$status |> class() == "character"






