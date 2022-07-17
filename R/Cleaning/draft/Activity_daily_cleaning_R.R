# Load Libraries 
library(tidyverse)
library(ggplot2)
library(janitor)

# Load dataset V01.00
activity_daily <- read_csv("./Data/Data/Data/Activities/activity_daily_important_cols_05_05_2022_V01.csv")
View(activity_daily)

colnames(activity_daily)

empty_rows <- activity_daily %>%
  filter(TotalSteps == 0 &
           TotalDistance == 0 &
           VeryActiveDistance ==0 &
           ModeratelyActiveDistance == 0 &
           LightActiveDistance == 0 &
           VeryActiveMinutes == 0 &
           FairlyActiveMinutes ==0 &
           LightlyActiveMinutes ==0 &
           #SedentaryMinutes== 1440 &
           Calories == 0)
View(empty_rows) 
# we have 4 empty rows (all variables are zero except SedentaryMinutes =1440 )
# we should delete these rows

# select not empty rows 
# when using != we should use | OR instead of & AND
# to get the complement of what we selected with == & AND
activity_daily_cleaned_v01_01 <- activity_daily %>%
  filter(TotalSteps != 0 |
           TotalDistance != 0 |
           VeryActiveDistance !=0 |
           ModeratelyActiveDistance != 0 |
           LightActiveDistance != 0 |
           VeryActiveMinutes != 0 |
           FairlyActiveMinutes !=0 |
           LightlyActiveMinutes !=0 |
           SedentaryMinutes != 1440 |
           Calories != 0)
View(activity_daily_cleaned_v01_01)

# cleaning col names 

activity_daily_cleaned_v01_02 <- 
  activity_daily_cleaned_v01_01 %>% 
  clean_names()

View(activity_daily_cleaned_v01_02)

ggplot(data = activity_daily_cleaned_v01_02) +
  geom_histogram(aes(x = total_steps))

total_steps_grtr_25k <- 
  activity_daily_cleaned_v01_02 %>%
  filter(total_steps > 25000)

View(total_steps_grtr_25k)

hist_plot <- function(df, x_to_plot){
  ggplot({{df}}) + geom_histogram(aes({{x_to_plot}}),inherit.aes = FALSE , binwidth = 10)
}

hist_plot(activity_daily_cleaned_v01_02, calories)

#"total_steps"                "total_distance"            
# "very_active_distance"       "moderately_active_distance"
# "light_active_distance"      "very_active_minutes"
#"fairly_active_minutes"      "lightly_active_minutes"    
#"sedentary_minutes"          "calories"  

ggplot(data = activity_daily_cleaned_v01_02) + geom_histogram(aes(x = calories), binwidth = 10)
