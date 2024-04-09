data <- read.csv("train_no_empty_rows.csv")

data_label_0 <- data[data$label == 0, ]


data_label_1 <- data[data$label == 1, ]


write.csv(data_label_0, "train_label_0.csv", row.names = FALSE)


write.csv(data_label_1, "train_label_1.csv", row.names = FALSE)
