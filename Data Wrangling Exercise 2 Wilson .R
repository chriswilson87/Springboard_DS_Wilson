library(tidyverse)
library(stringr)
library(readxl)

raw_data <- read_excel("titanic3.xls")


# 1: Port of embarkation
ind <- which(is.na(raw_data$embarked))
raw_data$embarked[ind] <- "S"
raw_data$embarked

#2 Mean of age column

raw_data$age[is.na(raw_data$age)] <- mean(raw_data$age)
raw_data$age


#3 Lifeboat
ind_boat <- which(is.na(raw_data$boat))
raw_data$boat[ind_boat] <- "None"
raw_data$boat

# 4 Cabin -- needed help here 
raw_data$has_cabin_number <- as.numeric(!(is.na(raw_data$cabin)))
raw_data$has_cabin_number

write_csv(raw_data, "data_wrang_ex2_wilson.csv")

