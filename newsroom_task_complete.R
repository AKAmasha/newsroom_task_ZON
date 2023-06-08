#install.packages("tidyverse")
#install.packages("readxl")
#install.packages("dplyr")

library(readxl)
library(dplyr)

my_data <- read_excel("Desktop/vgrdl_r2b3_bs2021_0.xlsx", 
                                  sheet = "2.4", 
                                  skip = 3)
column_names <- my_data[1, ]
colnames(my_data) <- column_names
my_data <- my_data[-1, ]
my_data

my_data_filtered <- my_data %>%
  select(Gebietseinheit, `1995`:`2020`) %>%
  filter(Gebietseinheit == "Berlin" | Gebietseinheit == "Deutschland")

library(tidyverse)

my_data_filtered_long <- my_data_filtered %>%
  mutate(across(`1995`:`2020`, as.numeric)) %>%
  pivot_longer(cols = `1995`:`2020`, names_to = "Year", values_to = "Value") %>%
  filter(Gebietseinheit %in% c("Berlin", "Deutschland"))

ggplot(data = my_data_filtered_long, aes(x = Year, y = Value, color = Gebietseinheit, group = Gebietseinheit)) +
  geom_point(size = 2) +
  geom_line()+
  labs(x = "Jahre", 
       y = "Einkommen je Einwohner in Euro",
       title = "Einkommen privater Haushalte je Einwohner pro Jahr",
       subtitle = "Vergleich zwischen Berlin und dem Durchschnitt von Deutschland,
                  von 1995 bis 2020")+
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  ggsave("newsroom_task_zeitonline.jpg")
