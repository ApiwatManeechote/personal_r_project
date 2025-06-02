# There are plenty of stuffs in packages that we initially cannot use it unless we've installed it and call the library first.
install.packages(c('readr', 'readxl', 'googlesheets4', 'jsonlite', 'dplyr', 'sqldf', 'RSQLite', 'lubridate', 'janitor', 'tidyverse', 'caret', 'ggplot2'))
# You can just install the packages while only call the library() only you usually use.
library(readr)
library(dplyr)
library(tidyverse)
library(caret)

# In case that you export .csv file from the SQL project already, then you can read the .csv file like this.
country_spend <- read.csv("country_spend.csv")
cust_seg <- read.csv("cust_seg.csv")




# You can connect to your .db file like this.
# But you have to make sure that the file is in the working directory
  # setwd("your/file/location") to set new working directory or you can set from the session menu.
  # getwd() to check your working directory location.

# Connect to the SQLite database
con <- dbConnect(RSQLite::SQLite(), "chinook_updated.db")

# List all tables in the database to check if the connection is complete.
  # If the table names show up, then we are good to go!
dbListTables(con)

# In case that we didn't export a .csv file from SQL code that I attached, then you can do SQL code in R too.
query <- "
SELECT
    g.Name AS genre,
    SUM(il.UnitPrice * il.Quantity) AS total_revenue
FROM invoicelines il
JOIN tracks t ON il.TrackId = t.TrackId
JOIN genres g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY total_revenue DESC
LIMIT 10;
"

genre_top_sales <- dbGetQuery(con, query)

# Then, we plot the graph with several of settings to make it look clean and ready to present.
ggplot(genre_top_sales, aes(x = reorder(genre, -total_revenue), y = total_revenue)) +
  geom_bar(stat = "identity", fill = "springgreen3") +
  labs(title = "Top 10 Best-Selling Genres", x = "Genre", y = "Revenue") +
  theme_minimal()
