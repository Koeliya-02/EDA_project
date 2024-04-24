# Load required libraries
library(randomForest)
library(e1071)
library(caret)
class_weights = c(1,1.25)
# Train Random Forest model
rf_model <- randomForest(x = train_features, 
                         y = train_labels, 
                         ntree = 35, importance = TRUE, corr.bias = TRUE, classwt=class_weights,replace=TRUE )
rf_model
# Train SVM model
svm_model <- svm(x = train_features, 
                 y = train_labels, 
                 kernel = 'radial', 
                 cost = 10, 
                 scale = TRUE)
svm_model

# Predict using XGBoost
xgb_predictions <- predict(xgb_model, as.matrix(test_features))
# Generate predictions from base models
rf_predictions <- predict(rf_model, test_features)
svm_predictions <- predict(svm_model, test_features)

conf_matrix_rf <- confusionMatrix(rf_predictions, test_labels)

# Generate confusion matrix for SVM predictions
conf_matrix_svm <- confusionMatrix(svm_predictions, test_labels)

# Print confusion matrices
print("Random Forest Confusion Matrix:")
print(conf_matrix_rf)

print("SVM Confusion Matrix:")
print(conf_matrix_svm)

# Plot heatmaps
library(pheatmap)

# Random Forest heatmap
pheatmap(conf_matrix_rf$table, 
         main = "Random Forest Confusion Matrix Heatmap", 
         color = colorRampPalette(c("brown", "red"))(20),
         cluster_rows = FALSE,
         cluster_cols = FALSE)

# SVM heatmap
pheatmap(conf_matrix_svm$table, 
         main = "SVM Confusion Matrix Heatmap", 
         color = colorRampPalette(c("brown", "red"))(20),
         cluster_rows = FALSE,
         cluster_cols = FALSE)

# Create a data frame of base model predictions
stacked_data <- data.frame(RF = rf_predictions, SVM = svm_predictions)

# Train a meta-model (Logistic Regression)
meta_model <- train(x = stacked_data, 
                    y = test_labels,
                    method = "glm",
                    family = "binomial")

# Predict using meta-model
stacked_predictions <- predict(meta_model, stacked_data)

# Calculate final accuracy
final_accuracy <- sum(stacked_predictions == test_labels) / length(test_labels)

# Print final accuracy
cat("Final Stacked Model Accuracy using logistic regression:", final_accuracy, "\n")


library(randomForest)

# Confusion matrix
conf_matrix_meta <- confusionMatrix(stacked_predictions, test_labels)
print(conf_matrix_meta)


# Extract recall for class 1 (assuming 1 is the positive class)
# Assuming the positive class (troll) has index 1
recall <- conf_matrix_meta$table[2, 2] / sum(conf_matrix_meta$table[2, ])

# Print recall
cat("Recall for Logistic Regression Meta-Model (Class 1 - Troll):", recall, "\n")


