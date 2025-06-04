# From our SQL project, we have extracted top 10 track count and total_sales genres 

con <- dbConnect(RSQLite::SQLite(), "chinook_updated.db")
dbListTables(con)

cor_query <- "
SELECT
    ar.Name AS artist_name,
    (SELECT COUNT(t.TrackId)
        FROM albums al
        JOIN tracks t ON al.AlbumId = t.AlbumId
        WHERE al.ArtistId = ar.ArtistId) AS track_count,
    (SELECT SUM(il.UnitPrice * il.Quantity)
        FROM albums al
        JOIN tracks t ON al.AlbumId = t.AlbumId
        JOIN invoicelines il ON il.TrackId = t.TrackId
        WHERE al.ArtistId = ar.ArtistId) AS total_sales
FROM artists ar
ORDER BY total_sales DESC
LIMIT 10;
"

cor_df <- dbGetQuery(con, cor_query)

ggplot(cor_df, aes(x = track_count, y = total_sales)) +
  geom_point(color = "midnightblue", size = 3) +
  geom_smooth(method = "lm", color = "violetred2") +
  labs(title = "Track Count vs. Total Sales by Artist",
       x = "Number of Tracks",
       y = "Total Sales") +
  theme_minimal()

# We use correlation to see the relationship between the track_count and the total_sales.
# The value ranges between -1 to 1.
  # If the value is close to 1, it demonstrates that they have a strong positive relationship.
    # It means if track_count increases, then the total_sales potentially increases too.
  # If the value is close to 0, it shows no clear relationship.
  # If the value is close to -1, it indicates a strong negative relationship.
    # It means if track_count increases, then the total_sales potentially decrease.
cor(cor_df$track_count, cor_df$total_sales)


# 
