#### Preamble ####
# Purpose: Simulates dataset about Bicycle Theft in Toronto from 2014 to 2022
# Author: Yufei Liu
# Date: 2 Oct 2023
# Contact: florence.liu@mail.utoronto.ca
# License: MIT

#### Data expectations ####
# There are columns occurrence_date and report_date in format yyyy-mm-dd
# Both dates are between 2014-01-01 and 2022-12-31
# Difference between the report_date and occurrence_date will center at 0
# occurrence_hours are between 0-24
# Expect more lost outside locations and different location types
# Expect much more stolen status than recovery status

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

# generate a positive random difference centered at 0 and decayed until 366 (in case of leap year)
difference <- sample(0:366, size = n_obs, prob = c(0.3, rep(0.25/7,7), rep(0.2/30, 30), rep(0.15/90, 90), 
                                     rep(0.1/239,239)), replace = TRUE)

# generate the report_date based on occurrence_date and difference
temp_report_date <- occurrence_date + difference 

# replace years greater than 2022 with NA
df.report <- data.frame(x=temp_report_date)
df.report$x[df.report$x >= as.Date("2022-12-31")] <- NA
report_date <- df.report$x


## Simulate occurrence_hour
# expect occurrence_hour between 0-24
occurrence_hour <- sample(0:24, n_obs, replace = TRUE)



## Simulate location
# expect 5 location types: Outside, House, Apartment, Commercial, Transit
location <- sample(c("Outside", "House", "Apartment", "Commercial", "Transit"), 
                   n_obs, prob = c(0.3, rep(0.7/4,4)), replace = TRUE)


## Simulate status
# expect 3 status: Stolen, Recovered, Unknown
status <- sample(c("Stolen", "Recovered", "Unknown"), n_obs, prob = c(0.7,0.15,0.15),
                 replace = TRUE)

## Simulated dataset
simulated_data <- data.frame(occurrence_date, report_date, difference, occurrence_hour,
                             location, status)



## Create graphs of simulated data
# Reference data from https://tellingstorieswithdata.com/05-static_communication.html

# Histograms of bicycle theft occurrence by occurrence_date and report_date
simulated_data |> ggplot(aes(x=occurrence_date)) +
  geom_histogram(bins = 20, color = "grey42", fill = "darkgreen") +
  theme_classic()
  
simulated_data |> ggplot(aes(x=report_date)) +
  geom_histogram(bins = 20, color = "grey42", fill = "darkgreen") +
  theme_classic()

# Bar plot for status and location
simulated_data |> ggplot(aes(x=location, fill=status)) +
  geom_bar()

# Bar plot for occurrence_hour
simulated_data |> ggplot(aes(x=occurrence_hour)) +
  geom_bar()

# Histogram of difference in days between occurrence_date and report_date
simulated_data |> ggplot(aes(x=difference)) +
  geom_histogram()



## Data validation
#  Reference data from: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html

# Check that occurrence_date are all between 2014-01-01 and 2022-12-31
sum(simulated_data$occurrence_date <= as.Date("2022-12-31")) == nrow(simulated_data)

# Check that report_date are all between 2014-01-01 and 2022-12-31
max(simulated_data$report_date, na.rm = T) <= as.Date("2022-12-31")
min(simulated_data$report_date, na.rm = T) >= as.Date("2014-01-01")

# Check that differnce in days between occurrence_date and report_date is positive
simulated_data$difference |> min() >= 0

# Check that occurrence_hour are all between 0 and 24
simulated_data$occurrence_hour |> min() >= 0
simulated_data$occurrence_hour |> max() <= 24

# Check there 5 location types
simulated_data$location |> unique() |> sort() == c("Apartment", "Commercial", 
                                                   "House", "Outside", "Transit")

# Check there are 3 status
simulated_data$status |> unique() |> sort() == c("Recovered", "Stolen", "Unknown")

# Check variable types
simulated_data$occurrence_date |> class() == "Date"
simulated_data$report_date |> class() == "Date"
simulated_data$difference |> class() == "integer"
simulated_data$occurrence_hour |> class() == "integer"
simulated_data$location |> class() == "character"
simulated_data$status |> class() == "character"






