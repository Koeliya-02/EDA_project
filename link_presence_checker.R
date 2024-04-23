#data <- read.csv("train_data_with_sentiments.csv")
#df <-data
# Initialize variables
# Initialize variables
# Initialize variables
c <- 0
url_pattern <- "https?://[^\\s]+"
link_presence <- numeric(num_rows)  # Initialize as numeric vector

# Loop through each row
for (i in 1:num_rows) {
  # Access 'text' column from the ith row of df
  text <- df[i, "text"]
  
  # Check if the text contains a URL using grepl
  url_found <- grepl(url_pattern, text, ignore.case = TRUE)
  
  if (url_found) {
    c <- 1
  } else {
    c <- 0
  }
  
  # Store the result in link_presence
  link_presence[i] <- c
}

# Update 'link_presence' column in the data frame
df$link_presence <- link_presence

# View the updated data frame
View(df)
