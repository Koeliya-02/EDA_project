# Install and load required library
install.packages("ggplot2")
library(ggplot2)

# Load the CSV file into a DataFrame
df <- read.csv("train_data.csv")

# Plot the distribution of labels with smaller size
ggplot(df, aes(x = label)) +
  geom_bar(fill = "blue") +
  labs(title = "Distribution of Labels", x = "Label", y = "Count") +
  theme(plot.margin = unit(c(1, 4, 1, 4), "cm"))  # Adjust the values inside unit() to change margins

