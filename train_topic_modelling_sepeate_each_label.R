sink("logfile_lda_k_10_alpha_0_2.txt",append=TRUE)
library(quanteda)
library(topicmodels)

# Function to perform topic modeling
perform_topic_modeling <- function(data_subset) {
  # Create a corpus from the "text" column of the subset
  corp <- corpus(data_subset$text)
  
  # Create a document-feature matrix (DFM)
  dfm <- dfm(corp, remove_punct = TRUE, remove = stopwords("english"))
  dfm <- dfm_trim(dfm, min_docfreq = 5)
  
  # Convert DFM to Document-Term Matrix (DTM) for topic modeling
  dtm <- convert(dfm, to = "topicmodels")
  
  # Set seed for reproducibility
  set.seed(1)
  
  # Perform LDA topic modeling
  m <- LDA(dtm, method = "Gibbs", k = 10, control = list(alpha = 0.2))
  
  # Return the model
  return(m)
}

# Perform topic modeling on data_label_0
model_label_0 <- perform_topic_modeling(data_label_0)

# Perform topic modeling on data_label_1
model_label_1 <- perform_topic_modeling(data_label_1)

# Print the models
print(model_label_0)
print(model_label_1)

# Get the top terms for each topic for data_label_0
print("for benign data\n")
terms(model_label_0, 5)
print("\n\n")
print("for troll data\n")
# Get the top terms for each topic for data_label_1
terms(model_label_1, 5)

#topic = 6
#words_label_0 = posterior(model_label_0)$terms[topic, ]
#topwords_label_0 = head(sort(words_label_0, decreasing = T), n=50)
#head(topwords_label_0)

#topic = 6
#words_label_1 = posterior(model_label_1)$terms[topic, ]
#topwords_label_1 = head(sort(words_label_1, decreasing = T), n=50)
#head(topwords_label_1)

#library(wordcloud)
#wordcloud(names(topwords_label_0), topwords)
#wordcloud(names(topwords_label_1), topwords)

sink()

