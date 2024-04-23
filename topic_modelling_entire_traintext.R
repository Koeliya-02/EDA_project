# Load required libraries
library(quanteda)
library(topicmodels)

# Load the CSV file
data <- read.csv("train_data_with_sentiments.csv")

# Create a corpus from the text column
corp <- corpus(data$text)

# Create a document-feature matrix (DFM)
dfm <- dfm(corp, remove_punct = TRUE, remove = stopwords("english"))

# Trim the DFM
dfm <- dfm_trim(dfm, min_docfreq = 5)

# Convert the DFM to a document-term matrix (DTM) for topic modeling
dtm <- convert(dfm, to = "topicmodels")

# Set a seed for reproducibility
set.seed(1)

# Perform Latent Dirichlet Allocation (LDA) for topic modeling
m <- LDA(dtm, method = "Gibbs", k = 10, control = list(alpha = 0.1))
# View the LDA model
m2 <- LDA(dtm, method = "VEM", k = 10)
print(m)
terms(m2, 5)
# View the top terms for each topic
terms(m, 5)
