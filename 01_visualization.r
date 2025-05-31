# There are plenty of stuffs in packages that we initially cannot use it unless we've installed it and call the library first.
install.packages(c('readr', 'readxl', 'googlesheets4', 'jsonlite', 'dplyr', 'sqldf', 'RSQLite', 'lubridate', 'janitor', 'tidyverse', 'caret', 'ggplot2'))
# You can just install the packages while only call the library() only you usually use.
library(readr)
library(dplyr)
library(tidyverse)
library(caret)

# In case that you export .csv file from the SQL project already, then you can read the .csv file like this.
top10 <- read.csv("top_10_spenders.csv")
