from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import KMeans
from sklearn.metrics import accuracy_score
import csv


import csv


# Assuming messages and labels are your data and corresponding labels
messages = [...]  # List of messages
labels = [...] 
# Initialize empty lists to store each column
column1 = []
column2 = []
# Add more lists if your CSV file has more columns

# Open the CSV file
with open('combined_post_data_2_labels.csv', mode='r', encoding='utf-8') as file:
    # Create a CSV reader object
    reader = csv.reader(file)
    # Iterate over each row in the CSV file
    for row in reader:
        # Append each element of the row to respective columns
        print(ResourceWarning)
        # messages.append(row[0])
        # labels.append(row[1])
        break
        # Append more elements if your CSV file has more columns

# # Print the contents of each column
print("Column 1:", messages)
print("Column 2:", labels)
# # Print more columns if your CSV file has more columns





   # List of corresponding labels (0 for non-troll, 1 for troll)

# Text Vectorization
vectorizer = TfidfVectorizer(stop_words='english')
X = vectorizer.fit_transform(messages)

# Clustering
k = 2  # Number of clusters
kmeans = KMeans(n_clusters=k, random_state=42)
predicted_labels = kmeans.fit_predict(X)

# Evaluate
accuracy = accuracy_score(labels, predicted_labels)
print("Accuracy:", accuracy)
