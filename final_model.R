# Load required libraries
library(randomForest)
library(e1071)
library(caret)

#ON TRAIN DATA-TRAINING OF ENSEMBLE MODEL
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


# Generate predictions from base models
rf_predictions <- predict(rf_model, train_features)
svm_predictions <- predict(svm_model, train_features)

conf_matrix_rf <- confusionMatrix(rf_predictions, train_labels)

# Generate confusion matrix for SVM predictions
conf_matrix_svm <- confusionMatrix(svm_predictions, train_labels)

# Print confusion matrices
print("Random Forest Confusion Matrix:")
print(conf_matrix_rf)

print("SVM Confusion Matrix:")
print(conf_matrix_svm)

# Plot heatmaps
library(pheatmap)

# Random Forest heatmap
pheatmap(conf_matrix_rf$table, 
         main = "Random Forest Confusion Matrix Heatmap(train)", 
         color = colorRampPalette(c("brown", "red"))(20),
         cluster_rows = FALSE,
         cluster_cols = FALSE)

# SVM heatmap
pheatmap(conf_matrix_svm$table, 
         main = "SVM Confusion Matrix Heatmap(train)", 
         color = colorRampPalette(c("brown", "red"))(20),
         cluster_rows = FALSE,
         cluster_cols = FALSE)

# Create a data frame of base model predictions
stacked_data <- data.frame(RF = rf_predictions, SVM = svm_predictions)

# Train a meta-model (Logistic Regression)
meta_model <- train(x = stacked_data, 
                    y = train_labels,
                    method = "glm",
                    family = "binomial")

# Predict using meta-model
stacked_predictions <- predict(meta_model, stacked_data)

# Calculate final accuracy
final_accuracy <- sum(stacked_predictions ==train_labels) / length(train_labels)

# Print final accuracy
cat("Final Stacked Model Accuracy using logistic regression:", final_accuracy, "\n")


#FOR TEST DATA

rf_predictions_test <- predict(rf_model, test_features)
svm_predictions_test <- predict(svm_model, test_features)
stacked_data_test <- data.frame(RF = rf_predictions_test, SVM = svm_predictions_test)
stacked_data_test
stacked_predictions_test <- predict(meta_model, stacked_data_test)
stacked_predictions_test # Assuming prediction on test data
test_labels


confusion_matrix <- confusionMatrix(stacked_predictions_test, test_labels)
confusion_matrix
# Assuming positive class (troll) has index 1
tp <- confusion_matrix$table[2, 2]  # True Positives (class 1)
fp <- confusion_matrix$table[2, 1]  # False Positives (incorrectly predicted as class 1)
fn <- confusion_matrix$table[1, 2]  # False Negatives (missed class 1)

precision <- tp / (tp + fp)
recall <- tp / (tp + fn)

# F1-score for class 1 (troll)
f1_score <- 2 * (precision * recall) / (precision + recall)

cat("F1-Score for Logistic Regression Meta-Model (Class 1 - Troll):", f1_score, "\n")



