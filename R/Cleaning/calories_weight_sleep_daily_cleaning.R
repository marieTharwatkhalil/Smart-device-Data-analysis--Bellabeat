# Load libraries 
library(tidyverse)
library(janitor)
# cleaning calories table
calories_daily <- read_csv("./Data/Data/Data/Calories/dailyCalories_merged.csv")
View(calories_daily)

zero_cals <- calories_daily %>% filter(Calories == 0)
View(zero_cals)
# we can keep these values we will use it in the analysis 

# cleaning col names 
calories_daily_cleaned_v01 <- calories_daily %>% clean_names()

View(calories_daily_cleaned_v01)

#saving cleaned dataframe 
write.csv(calories_daily_cleaned_v01, 
          file = "./Data/cleaned_data/calories_daily_cleaned_06_05_2022_v01.csv",
          row.names = FALSE)

# Cleaning Weight table 
weight_daily <- read_csv("./Data/Data/Data/weight/weightLogInfo_merged.csv")
View(weight_daily)
# checking the structure of the table 
str(weight_daily)

# table summary 
summary(weight_daily)
# total number of columns is 67 
# fat col has 65 NA (97%) of the entries are NA we should exclude this column 

# selecting all columns except fat column
weight_daily_cleaned_v01 <- weight_daily %>% 
  select(Id, Date, WeightKg, WeightPounds, BMI, IsManualReport, LogId)

# checking if there is duplicates 
View(unique(weight_daily_cleaned_v01))

# it has the same number of rows 67 
# there`s no duplicates each row is a unique entry 

weight_daily_cleaned_v02 <- weight_daily_cleaned_v01 %>% clean_names()

View(weight_daily_cleaned_v02)

# checking if there is outliers
# function to plot histogram 
hist_plot <- function(df, x_to_plot){
  ggplot({{df}}) + geom_histogram(aes({{x_to_plot}}))
}

hist_plot(weight_daily_cleaned_v02, weight_kg)
hist_plot(weight_daily_cleaned_v02, bmi)

wt_grtr_120 <- weight_daily_cleaned_v02 %>% filter(weight_kg >120)
# weight greater than 120 is not an outlier we should keep it 

#ggplot(data = weight_daily_cleaned_v02) + geom_bar(aes(weight_kg)) 


write.csv(weight_daily_cleaned_v02, file= "./Data/cleaned_data/weight_daily_cleaned_07_05_2022_v01.csv",
          row.names = FALSE)

# sleep 

sleep_daily <- read_csv("./Data/Data/Data/sleep/sleepDay_merged.csv")
View(sleep_daily) 

sleep_daily_clean_v01 <- sleep_daily

# add two columns and converted minutes to hours
sleep_daily_clean_v01$TotalHoursAsleep <- round((sleep_daily_clean_v01$TotalMinutesAsleep/60),2) 
sleep_daily_clean_v01$TotalHoursInBed <- round((sleep_daily_clean_v01$TotalTimeInBed/60),2) 

summary(sleep_daily_clean_v01)
# there is no NA 

View(unique(sleep_daily_clean_v01))
# there are 3 duplicate rows 

# we should select only unique rows (remove duplicates)

sleep_daily_clean_v02 <- unique(sleep_daily_clean_v01) 

# clean col names to be in snake_case
sleep_daily_clean_v02 <- sleep_daily_clean_v02 %>% clean_names()

View(sleep_daily_clean_v02)

write.csv(sleep_daily_clean_v02, "./Data/cleaned_data/sleep_daily_cleaned_07_05_2022_v01.csv",
          row.names = FALSE)