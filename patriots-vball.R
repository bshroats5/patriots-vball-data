# Clear the enviroment

rm(list = ls())

# Load necessary libraries

library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)

# Load the dataset

data <- read_csv("data/patriots-vball-data.csv")