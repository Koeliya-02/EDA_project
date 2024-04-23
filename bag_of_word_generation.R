library(quanteda)
library(topicmodels)

data <- read.csv("train_data_with_sentiments.csv")
data_label_1 <- data[data$label == 1, ]
corp <- corpus(data_label_1$text)

# Create a document-feature matrix (DFM)
dfm <- dfm(corp, remove_punct = TRUE, remove = stopwords("english"))
dfm <- dfm_trim(dfm, min_docfreq = 5)

# Convert DFM to Document-Term Matrix (DTM) for topic modeling
dtm <- convert(dfm, to = "topicmodels")

alpha_grid <- seq(from = 0.1, to = 2, by = 0.1)  # Adjust grid range as needed

# Perform model fitting and perplexity calculation for each alpha
models <- lapply(alpha_grid, function(a) {
  m <- LDA(dtm, method = "Gibbs", k = 10, control = list(alpha = a))
  perplexity(m,dtm)  # Calculate perplexity for each model
})

# Find the alpha value with the lowest perplexity
best_alpha <- alpha_grid[which.min(models)]
print(paste("Estimated best alpha:", best_alpha))


# Function to perform topic modeling
perform_topic_modeling <- function(data_subset) {
  # Set seed for reproducibility
  set.seed(1)
  
  # Perform LDA topic modeling
  m <- LDA(dtm, method = "Gibbs", k = 10, control = list(alpha = 0.1))
  
  # Return the model
  return(m)
}
perform_VEM_topic_modeling <- function(data_subset) {
  # Set seed for reproducibility
  set.seed(1)
  
  # Perform LDA topic modeling
  m <- LDA(dtm, method = "VEM", k = 10)
  
  # Return the model
  return(m)
}


nrow(data)
nrow(data_label_1)
# Perform topic modeling on data_label_1
model_label_1 <- perform_topic_modeling(data_label_1)

print(model_label_1)
perplexity(model_label_1,dtm)

# Get the top terms for each topic for data_label_1
terms(model_label_1, 10)
all_top_terms <- topicmodels::terms(model_label_1, 10)
all_top_terms <- unlist(sapply(all_top_terms, function(x) as.character(x)))

all_top_terms
all_top_terms <- wordStem(all_top_terms, language = "english")
print(all_top_terms)
all_top_terms<- unique(all_top_terms)
all_top_terms
terms(model_label_1)

model2_label_1 <- perform_VEM_topic_modeling(data_label_1)
terms(model2_label_1, 10)
all_top_terms2 <- topicmodels::terms(model2_label_1, 10)
all_top_terms2 <- unlist(sapply(all_top_terms2, function(x) as.character(x)))
all_top_terms2
all_top_terms2 <- wordStem(all_top_terms2, language = "english")
print(all_top_terms2)
all_top_terms2<- unique(all_top_terms2)
all_top_terms2

merged_terms <- c(all_top_terms, all_top_terms2)
print(merged_terms)
merged_terms<- unique(merged_terms)
merged_terms

fileConn<-file("bag_of_troll_words_without_stemming.txt")
writeLines(merged_terms, fileConn)
close(fileConn)
