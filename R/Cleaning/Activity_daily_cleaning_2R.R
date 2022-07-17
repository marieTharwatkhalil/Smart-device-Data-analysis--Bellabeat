# Load Libraries 
library(tidyverse)
library(ggplot2)
library(janitor)

# Load dataset V01.00
activity_daily <- read_csv("./Data/Data/Data/Activities/activity_daily_important_cols_05_05_2022_V01.csv")
View(activity_daily)

colnames(activity_daily)

# cleaning col names 
activity_daily_cleaned_v01_01 <- 
  activity_daily %>% 
  clean_names()

View(activity_daily_cleaned_v01_01)

# function to plot histogram 
# ,inherit.aes = FALSE
hist_plot <- function(df, x_to_plot){
  ggplot({{df}}) + geom_histogram(aes({{x_to_plot}}))
}

# checking total_steps
hist_plot(activity_daily_cleaned_v01_01, total_steps)

# we should check if values > 25K are outliers 
total_steps_grtr_25k <- 
  activity_daily_cleaned_v01_01 %>%
  filter(total_steps > 25000)

View(total_steps_grtr_25k)
# values > 25K are not outliers 
# other variables Ex: calories, distance are also big numbers 
# this means the users truly walked this number of steps and lost huge number of calories

# checking total_distance
hist_plot(activity_daily_cleaned_v01_01, total_distance) 
hist_plot(activity_daily_cleaned_v01_01, total_distance) + facet_wrap(~id)

# according to the histograms plots with value greaeter than 25 KM are not outliers
# and they belong to users with total_steps > 25K 

# we can create more plots to check if there is outliers 
# but its clear that there is no outliers 

# saving the cleand dataframe 
write.csv(activity_daily_cleaned_v01_01, file = "./Data/cleaned_data/activity_daily_cleaned__06_05_2022_V01.01.csv", row.names = FALSE)


