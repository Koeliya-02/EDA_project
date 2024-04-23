word_list_file <- "bag_of_troll_words_without_stemming.txt"

# Function to read word list from a file
read_word_list <- function(file_path) {
  # Read lines from the file
  words <- readLines(file_path, warn = FALSE)
  
  # Remove empty lines and leading/trailing whitespaces (optional)
  words <- trim(words[!sapply(words, is.null)])
  
  return(words)
}

# Read the word list
word_list <- read_word_list(word_list_file)

# Read the data
data <- read.csv("test_data_with_sentiments.csv")
df <- data

# Get the number of rows
num_rows <- nrow(df)

# Initialize troll_word_count column
df$troll_word_count <- numeric(num_rows)

# Loop through each row
for (i in 1:num_rows) {
  # Access the row using numeric index (i)
  row <- df[i,]
  
  # Text from the "text" column
  text <- as.character(row["text"])
  
  # Initialize counter for word occurrences
  c <- 0
  
  # Loop through each word in the word_list
  for (word in word_list) {
    # Check if word is present in the text
    word_found <- grepl(word, text)
    
    # Increment counter if word is found
    if (word_found) {
      c <- c + 1
    }
  }
  
  # Assign the count (c) to the troll_word_count column
  df$troll_word_count[i] <- c
}

# View the updated data frame
View(df)
