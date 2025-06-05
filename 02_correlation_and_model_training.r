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


# MODEL TRAINING
# This is the part where we do model training from chinook_updated.db as usual.
# With an objective to build a model to predict an artist’s total_sales based on their track_count.

query <- "
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
WHERE total_sales IS NOT NULL AND track_count IS NOT NULL;
"
df <- dbGetQuery(con, query)

# Data Preparation (Split Into 80% Train and 20% Test Data)
train_test_split <- function(data) {
  set.seed(99)
  n <- nrow(data)
  id <- sample(n, size = 0.8 * n)
  train_data <- data[id, ]
  test_data <- data[-id, ]
  return(list(train_data, test_data))
}

split_data <- train_test_split(df)

# 1. Linear Regression Model
lm_model <- train(total_sales ~ track_count,
                  data = split_data[[1]],
                  method = "lm")

# Score
p <- predict(lm_model, newdata=split_data[[2]])

# Evaluate
error <- split_data[[2]]$total_sales - p
rmse <- sqrt(mean(error**2))

# 2. Decision Tree
dt_model <- train(total_sales ~ track_count, 
                  data = split_data[[1]], 
                  method = "rpart")
p2 <- predict(dt_model, newdata = split_data[[2]])
error2 <- split_data[[2]]$total_sales - p2
rmse2 <- sqrt(mean((split_data[[2]]$total_sales - p2)**2))

# 3. Random Forest
rf_model <- train(total_sales ~ track_count, 
                  data = split_data[[1]], 
                  method = "rf")
p3 <- predict(rf_model, newdata = split_data[[2]])
error3 <- split_data[[2]]$total_sales - p3
rmse3 <- sqrt(mean((split_data[[2]]$total_sales - p3)**2))

# 4. KNN
knn_model <- train(total_sales ~ track_count, 
                   data = split_data[[1]], 
                   method = "knn")
p4 <- predict(knn_model, newdata = split_data[[2]])
error4 <- split_data[[2]]$total_sales - p4
rmse4 <- sqrt(mean((split_data[[2]]$total_sales - p4)**2))

# Compare Model
(model_compare <- data.frame(
  Model = c("Linear", "Decision Tree", "Random Forest", "kNN"),
  RMSE = c(rmse, rmse2, rmse3, rmse4)
))

# From the comparison, the Linear Regression Model tends to work better than the other 3 models with RMSE around 4.92.
