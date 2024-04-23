library(sentimentr)
library(ggplot2)
#install.packages(lexicon)
library(lexicon)
num_rows <- 5000
# Read the entire CSV
data <- read.csv("test_no_empty_rows.csv",  header = FALSE, stringsAsFactors = FALSE)

column_names <- c( "text", "label")
names(data) <- column_names
# Sample data (replace with your actual data)


# Create the ggplot object
ggplot(data, aes(x = label)) +
  geom_bar(fill = "red") +
  labs(title = "Distribution of Labels", x = "Label", y = "Count") +
  theme(plot.margin = unit(c(1, 4, 1, 4), "cm"))

sample_indices <- sample(1:nrow(data), size = num_rows, replace = FALSE)

# Subset the data frame using the random indices
text_data <- data[sample_indices, ]
#view(text_data)
ggplot(text_data, aes(x = label)) +
  geom_bar(fill = "blue") +
  labs(title = "Distribution of Labels", x = "Label", y = "Count") +
  theme(plot.margin = unit(c(1, 4, 1, 4), "cm")) 
troll_lexicon = lexicon::hash_sentiment_nrc

text_data$sentiment <- sentiment_by(text_data$text,averaging.function = sentimentr::average_weighted_mixed_sentiment,
                                    polarity_dt = hash_sentiment_socal_google,
                                    valence_shifters_dt = hash_valence_shifters,
                                    hyphen = "",
                                    amplifier.weight = 0.6,
                                    
                                    question.weight = -1,
                                    adversative.weight = 1)$ave_sentiment

text_data$sentiment_label <- ifelse(text_data$sentiment > 0, "Positive", 
                                    ifelse(text_data$sentiment == 0, "Neutral", "Negative"))

View(text_data)
ncol(text_data)
nrow(text_data)
verify <- text_data[text_data$sentiment < 0 & text_data$label == 0, ]
#View(verify)
nrow(verify)
verify <- text_data[text_data$sentiment > 0 & text_data$label == 1, ]
#View(verify)
nrow(verify)
write.csv(text_data, "test_data_with_sentiments.csv", row.names = FALSE, col.names = TRUE, append = TRUE)

