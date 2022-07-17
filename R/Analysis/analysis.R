library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)
library(janitor)

#this dataset contains records of users 
#who used the fitbit for at least 1 day from 12 April to 12 May 
# and have total steps count > 0 

activity_sleep_weight <- read_csv("./Data/cleaned_data/activity_sleep_weight_daily_joined_08_05_2022_v02.csv")
View(activity_sleep_weight)

# how users use fitbit 
table_sumarry <- activity_sleep_weight %>% group_by(id) %>%
  summarise(days_count = n(), avg_steps = mean(total_steps))
View(table_sumarry) 

# days_range <- c("1 Week","2 Weeks", "3 Weeks","4 Weeks")
users_percent <-data.frame(days_range =c("1 Week","2 Weeks", "3 Weeks","4 Weeks"), user_count= c(0,0,0,0))

#users_percent$days_range <- NA
#users_percent$user_count <- NA 

counter_1_wk <- 0
counter_2_wks <- 0
counter_3_wks <- 0
counter_4_wks <- 0

for (i in table_sumarry$days_count){
  
  if (1<= i & i <= 7){
    
    users_percent[1,]['days_range'] <- "1-7"
    counter_1_wk <- counter_1_wk+ 1
    users_percent[1,]['user_count'] <- counter_1_wk
  }
  
  else if (8 <= i & i <= 14){
    users_percent[2,]['days_range'] <- "8-14"
    counter_2_wks <- counter_2_wks + 1
    users_percent[2,]['user_count'] <- counter_2_wks
  }
  
  else if (15 <= i & i <= 21){
    users_percent[3,]['days_range'] <- "15-21"
    counter_3_wks <- counter_3_wks + 1
    users_percent[3,]['user_count'] <- counter_3_wks
  }
  else if (22 <= i & i <= 31){
    users_percent[4,]['days_range'] <- "22-31"
    counter_4_wks <- counter_4_wks + 1
    users_percent[4,]['user_count'] <- counter_4_wks
  }
  
}

View(users_percent)

users_percent$user_percentage <- round((users_percent$user_count/24)*100,1)
users_percent$user_percentage_lbl <- str_c(users_percent$user_percentage,"%")

##--users_percent$days_range <- 
#ggplot(data = users_percent) + geom_bar(aes(x= days_range))

users_percent <- users_percent[order(users_percent$user_percentage, decreasing = TRUE),]

View(users_percent)

barplot(users_percent$user_count, names.arg = users_percent$days_range,
        xlab = "Days count range", ylab = "Number of Users", 
        col = "darkblue", main = "Active users Vs number of days they used the device",
        font.main = 1 )

pie(users_percent$user_percentage, users_percent$user_percentage, col = rainbow(length(users_percent$user_percentage)))
legend("topright",c("1-7","8-14", "15-21","22-31"), cex = 1, fill = rainbow(length(users_percent$user_percentage)))


ggplot(users_percent, aes(x="", y = user_percentage, fill= days_range)) + 
  geom_col() + 
  geom_text(aes(label= user_percentage_lbl),
            position= position_stack(vjust = .5),
            color = c("white","white",1,1)) +
  labs(title = "Users and the number of days they used the device", 
       subtitle = "N=24", 
       caption = "users used their device at least once ONLY COUNTS")+
  scale_fill_viridis_d()+
  scale_fill_discrete(name= "Days Count")+
  coord_polar(theta = "y")+
  theme_void() +
  theme( plot.title = element_text(hjust = .5, size = 9 ),
    plot.subtitle = element_text(hjust = 0.5, size = 8),
    plot.caption = element_text(hjust = 3, size = 8)) 
#########################

# analyzing weight 

users_log_weight <- activity_sleep_weight %>% filter(weight_kg >=1)

weight_logs <- users_log_weight %>% 
  group_by(id) %>% 
  summarise(weight_logs_count = n())
View(weight_logs)

View(users_log_weight)
users

#userx <- users_log_weight %>% filter(id == 6962181067)
#View(userx)
#users_weight_percent <- nrow(weight_logs)/nrow(table_sumarry)

weight_logs_count <- nrow(weight_logs) 
no_weight_logs_count <- nrow(table_sumarry)-nrow(weight_logs)
total_users <- nrow(table_sumarry)
weight_logs_perc <- round((weight_logs_count/total_users)*100,0)
no_weight_logs_perc <- round(no_weight_logs_count/total_users*100,0)
total_percent <- weight_logs_perc+ no_weight_logs_perc

users_summary_weight <- data.frame(users_behavior = c("weight logged","no weight logged","total"),
                            users_count = c(weight_logs_count,no_weight_logs_count,total_users),
                            users_perc = c(weight_logs_perc,no_weight_logs_perc,total_percent))
View(users_summary_weight)

#trans_users_summary_weight <- t(users_summary_weight)
#trans_users_summary_weight <- trans_users_summary_weight %>% row_to_names(row_number = 1)
#View(trans_users_summary_weight)


#ggplot(users_summary_weight, aes(x="",y= users_percent, fill= users_behavior))+
 # geom_col()

users_summary_weight_no_tatal <- users_summary_weight %>% filter(users_perc < 100)
View(users_summary_weight_no_tatal)
users_summary_weight_no_tatal$users_perc_lbl <- str_c(users_summary_weight_no_tatal$users_perc,"%")

pie(users_summary_weight_no_tatal$users_perc,
    labels = users_summary_weight_no_tatal$users_perc_lbl, 
    col = c("green","red"),
    main = "Active Users and Weight logs") 
   # subtitle = "N=24", 
   # caption = "users used their device at least once ONLY COUNTS")
legend("topright",c("weight","no weight"), cex = .8, fill = c("green","red")) 

##### 
View(activity_sleep_weight)

# how many users log in per day

activity_sleep_weight

users_per_day <- activity_sleep_weight %>%
  group_by(activity_date) %>% 
  summarise(users_count = n())

View(users_per_day)

ggplot(data = users_per_day, aes(x= activity_date, y = users_count)) +
  geom_line()

summary(users_per_day)


ggplot(data = users_per_day) + 
  geom_histogram(aes(x= users_count))


activity_sleep_weight$weekday <- weekdays(activity_sleep_weight$activity_date)

activity_sleep_weight_2 <- activity_sleep_weight
View(activity_sleep_weight_2)

activity_sleep_weight_2$weekday <- factor(activity_sleep_weight_2$weekday, levels = c("Monday", 
    "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday","Sunday"))

activity_sleep_weight_2[order(activity_sleep_weight_2$weekday),]


ggplot(data = activity_sleep_weight_2) + 
  geom_bar(aes(x= weekday,color="red",fill= "Orange"),width = .5,show.legend = FALSE)+
  ggtitle("Number of users per weekday")+
  ylab("Number of users")+
  theme( title = element_text(size = 12, vjust = .5),
    axis.text.x = element_text(angle = 45, vjust = .5),
        axis.title.x = element_text(size = 8),
        axis.title.y = element_text(size = 8))















###################### 
View(users_log_weight)
ggplot(data = users_log_weight)+
  geom_point(aes(x = weight_kg, y = total_steps))#+ 
  #geom_smooth(aes(x = weight_kg, y = total_steps))
  
  #facet_wrap(~id)

ggplot(data = activity_sleep_weight)+
  geom_point(aes(x = total_hours_asleep, y = total_steps)) +
  geom_smooth(aes(x = total_hours_asleep, y = total_steps))

#+facet_wrap(~id) 

######################

ggplot(table_sumarry) + 
  geom_point(aes(x = days_count , y = avg_steps)) +
  geom_smooth(aes(x = days_count , y = avg_steps))



############# 
