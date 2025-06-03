# There are plenty of stuffs in packages that we initially cannot use it unless we've installed it and call the library first.
install.packages(c('readr', 'readxl', 'googlesheets4', 'jsonlite', 'dplyr', 'sqldf', 'RSQLite', 'lubridate', 'janitor', 'tidyverse', 'caret', 'ggplot2'))

# You can just install the packages while only call the library() only you usually use.
library(readr)
library(dplyr)
library(tidyverse)
library(caret)

# The method I use here will be connecting database instead of exporting a .csv file due to the limitation of the platform.

# You can connect to your .db file like this.
# But you have to make sure that the file is in the working directory
  # setwd("your/file/location") to set new working directory or you can set from the session menu.
  # getwd() to check your working directory location.

# We need to connect to the SQLite database.
con <- dbConnect(RSQLite::SQLite(), "chinook_updated.db")

# List all tables in the database to check if the connection is complete.
  # If the table names show up, then we are good to go!
dbListTables(con)

# In case that we didn't export a .csv file from SQL code that I attached in personal_sql_project, then you have to write the SQL code in R too.
sql_query1 <- "
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

genre_top_sales <- dbGetQuery(con, sql_query1)

# Then, we can make our first plot in bar chart with several of settings to make it look clean and ready to present.
ggplot(genre_top_sales, aes(x = reorder(genre, -total_revenue), y = total_revenue)) +
  geom_bar(stat = "identity", fill = "springgreen3") +
  labs(title = "Top 10 Best-Selling Genres", x = "Genre", y = "Revenue") +
  theme_minimal()

# Our second plot can be a pie chart that represents our revenue in each level of our customer segmentation.
sql_query2 <- "
WITH customers_total_sales AS (
    SELECT
        c.CustomerId,
        c.FirstName,
        c.LastName,
  		c.Email,
  		c.Phone,
        SUM(i.total) AS total_spent
    FROM invoices i
    JOIN customers c ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId
)
SELECT
	row_number() over (order by total_spent DESC) AS 'No.',
    customerid,
    firstName,
    lastName,
    email,
    phone,
    total_spent,
    CASE
    	WHEN total_spent <= 38 THEN 'low'
        WHEN total_spent <= 40 THEN 'regular'
        WHEN total_spent > 40 THEN 'high'
    ELSE 'other'
    END AS customer_segmentation
FROM customers_total_sales
ORDER BY total_spent DESC;
"

cust_seg <- dbGetQuery(con, sql_query2)

revenue_by_segment <- cust_seg %>%
  group_by(customer_segmentation) %>%
  summarise(total_revenue = sum(total_spent))

ggplot(revenue_by_segment, aes(x = "", y = total_revenue, fill = customer_segmentation)) +
  geom_col(width = 1) +
  coord_polar("y") +
  labs(title = "Revenue Contribution by Segment")

# Our last plot, I'll make just a line chart from our yearly sales.
  # I change the method just in little to use the direct query in the dbGetQuery function.
annual_sales <- dbGetQuery(con, "SELECT
    strftime('%Y', invoicedate) AS year,
    SUM(total) AS yearly_sales
FROM invoices
GROUP BY year
ORDER BY year;")

ggplot(annual_sales, aes(x = as.integer(year), y = yearly_sales)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "darkblue", size = 3) +
  labs(title = "Yearly Sales Trend", x = "Year", y = "Total Sales") +
  theme_minimal()

# Once we finish using the SQL connection, then we have to close the connection too.
dbDisconnect(con)
