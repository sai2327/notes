# 19. Machine Learning Workflow

## Table of Contents
- [19.1 What is Machine Learning?](#191-what-is-machine-learning)
- [19.2 ML Pipeline](#192-ml-pipeline)
- [19.3 Data Preprocessing](#193-data-preprocessing)
- [19.4 Model Training (scikit-learn)](#194-model-training-scikit-learn)
- [19.5 Model Evaluation](#195-model-evaluation)
- [19.6 Complete ML Project](#196-complete-ml-project)
- [19.7 Practice & Assessment](#197-practice--assessment)

---

## 19.1 What is Machine Learning?

### Definition
**Machine Learning** is a subset of AI where computers learn patterns from data without being explicitly programmed.

### Types of ML

```
┌───────────────────────────────────────────────────────┐
│  MACHINE LEARNING TYPES                                │
│                                                       │
│  ┌─────────────────┐  ┌──────────────────┐           │
│  │  SUPERVISED     │  │  UNSUPERVISED    │           │
│  │  (labeled data) │  │  (no labels)     │           │
│  │                 │  │                  │           │
│  │  Classification │  │  Clustering      │           │
│  │  - Spam/Not     │  │  - K-Means       │           │
│  │  - Disease/Healthy│ │  - DBSCAN       │           │
│  │                 │  │                  │           │
│  │  Regression     │  │  Dimensionality  │           │
│  │  - House price  │  │  Reduction       │           │
│  │  - Stock price  │  │  - PCA           │           │
│  └─────────────────┘  └──────────────────┘           │
│                                                       │
│  ┌─────────────────┐                                  │
│  │  REINFORCEMENT  │                                  │
│  │  (reward-based) │                                  │
│  │  - Game AI      │                                  │
│  │  - Robotics     │                                  │
│  └─────────────────┘                                  │
└───────────────────────────────────────────────────────┘
```

---

## 19.2 ML Pipeline

```
┌───────────────────────────────────────────────────────────────┐
│  DATA PIPELINE                                                 │
│                                                               │
│  Raw Data → Clean → Transform → Split → Train → Evaluate     │
│                                                               │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌──────┐  ┌────────┐  │
│  │Collect │─►│Clean   │─►│Feature │─►│Split │─►│ Train  │  │
│  │Data    │  │Missing │  │Engineer│  │Train/│  │ Model  │  │
│  │        │  │Outliers│  │Scale   │  │Test  │  │        │  │
│  └────────┘  └────────┘  └────────┘  └──────┘  └───┬────┘  │
│                                                      │        │
│                                         ┌────────────▼──────┐ │
│                                         │ Evaluate & Deploy │ │
│                                         └───────────────────┘ │
└───────────────────────────────────────────────────────────────┘
```

---

## 19.3 Data Preprocessing

```python
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split

# Load data
df = pd.DataFrame({
    "age": [25, 30, np.nan, 35, 28, 40, 22, np.nan, 33, 27],
    "salary": [30000, 50000, 40000, 60000, 35000, 70000, 25000, 45000, 55000, 32000],
    "department": ["IT", "HR", "IT", "Finance", "HR", "IT", "Finance", "HR", "IT", "Finance"],
    "performance": ["good", "excellent", "good", "excellent", "average", "excellent", "average", "good", "excellent", "good"]
})

# 1. Handle missing values
df["age"].fillna(df["age"].mean(), inplace=True)

# 2. Encode categorical variables
le = LabelEncoder()
df["department_encoded"] = le.fit_transform(df["department"])
# Finance=0, HR=1, IT=2

# One-hot encoding (better for most models)
df_encoded = pd.get_dummies(df, columns=["department"], drop_first=True)

# 3. Feature scaling
scaler = StandardScaler()
df[["age_scaled", "salary_scaled"]] = scaler.fit_transform(df[["age", "salary"]])

# 4. Train-Test Split
X = df[["age", "salary", "department_encoded"]]
y = le.fit_transform(df["performance"])  # Target

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)
print(f"Train: {X_train.shape}, Test: {X_test.shape}")
```

---

## 19.4 Model Training (scikit-learn)

```python
from sklearn.linear_model import LinearRegression, LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier

# Example: Classification
from sklearn.datasets import load_iris

# Load dataset
iris = load_iris()
X, y = iris.data, iris.target

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train multiple models
models = {
    "Logistic Regression": LogisticRegression(max_iter=200),
    "Decision Tree": DecisionTreeClassifier(),
    "Random Forest": RandomForestClassifier(n_estimators=100),
    "KNN": KNeighborsClassifier(n_neighbors=5),
    "SVM": SVC(kernel="rbf")
}

for name, model in models.items():
    model.fit(X_train, y_train)
    score = model.score(X_test, y_test)
    print(f"{name}: {score:.4f}")

# Linear Regression (for continuous target)
from sklearn.datasets import make_regression

X, y = make_regression(n_samples=100, n_features=1, noise=10, random_state=42)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

lr = LinearRegression()
lr.fit(X_train, y_train)
print(f"R² Score: {lr.score(X_test, y_test):.4f}")
print(f"Coefficient: {lr.coef_[0]:.4f}")
print(f"Intercept: {lr.intercept_:.4f}")
```

---

## 19.5 Model Evaluation

### Classification Metrics

```python
from sklearn.metrics import (accuracy_score, precision_score, recall_score,
                            f1_score, confusion_matrix, classification_report)

# Predictions
y_pred = model.predict(X_test)

# Accuracy
print(f"Accuracy: {accuracy_score(y_test, y_pred):.4f}")

# Full report
print(classification_report(y_test, y_pred, target_names=iris.target_names))

# Confusion Matrix
cm = confusion_matrix(y_test, y_pred)
print("Confusion Matrix:")
print(cm)
```

### Metrics Explained

```
┌───────────────────────────────────────────────────────┐
│  CONFUSION MATRIX                                      │
│                                                       │
│                    Predicted                           │
│                 Positive  Negative                    │
│  Actual   Pos │   TP    │   FN    │                  │
│           Neg │   FP    │   TN    │                  │
│                                                       │
│  Accuracy  = (TP + TN) / Total                       │
│  Precision = TP / (TP + FP) — "of predicted pos"     │
│  Recall    = TP / (TP + FN) — "of actual pos"        │
│  F1 Score  = 2 * (Precision * Recall)/(P + R)        │
└───────────────────────────────────────────────────────┘
```

### Cross-Validation

```python
from sklearn.model_selection import cross_val_score

model = RandomForestClassifier(n_estimators=100)
scores = cross_val_score(model, X, y, cv=5, scoring="accuracy")
print(f"CV Scores: {scores}")
print(f"Mean: {scores.mean():.4f} ± {scores.std():.4f}")
```

---

## 19.6 Complete ML Project

```python
"""Complete ML Project: Predict if a person earns >50K"""
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, accuracy_score

# Step 1: Create sample data
np.random.seed(42)
n = 500
data = pd.DataFrame({
    "age": np.random.randint(18, 65, n),
    "education_years": np.random.randint(8, 20, n),
    "hours_per_week": np.random.randint(20, 60, n),
    "experience": np.random.randint(0, 30, n)
})
# Target: higher age, education, hours → more likely >50K
data["income"] = ((data["age"] * 0.3 + data["education_years"] * 3 + 
                   data["hours_per_week"] * 0.5 + data["experience"] * 1.5 +
                   np.random.randn(n) * 10) > 50).astype(int)

print(f"Dataset shape: {data.shape}")
print(f"Target distribution:\n{data['income'].value_counts()}")

# Step 2: Split features and target
X = data.drop("income", axis=1)
y = data["income"]

# Step 3: Train-test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Step 4: Scale features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)  # Use SAME scaler!

# Step 5: Train model
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train_scaled, y_train)

# Step 6: Evaluate
y_pred = model.predict(X_test_scaled)
print(f"\nAccuracy: {accuracy_score(y_test, y_pred):.4f}")
print("\nClassification Report:")
print(classification_report(y_test, y_pred, target_names=["<=50K", ">50K"]))

# Step 7: Feature importance
importances = pd.Series(model.feature_importances_, index=X.columns)
print("\nFeature Importance:")
print(importances.sort_values(ascending=False))

# Step 8: Predict on new data
new_person = scaler.transform([[35, 16, 45, 10]])
prediction = model.predict(new_person)
print(f"\nPrediction for new person: {'> 50K' if prediction[0] else '<= 50K'}")
```

---

## 19.7 Practice & Assessment

### MCQs

**Q1.** What is overfitting?
- A) Model performs well on training data but poorly on new data
- B) Model performs poorly on all data
- C) Model is too simple
- D) Dataset is too small

**Answer:** A — Model memorized training data instead of learning patterns.

---

**Q2.** What metric is best for imbalanced classification?
- A) Accuracy
- B) F1-Score
- C) R² Score
- D) MSE

**Answer:** B — F1-Score balances precision and recall, better for imbalanced data.

---

### Coding Task

**Task:** Build a model to classify Iris flowers using KNN with hyperparameter tuning.

```python
from sklearn.datasets import load_iris
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import GridSearchCV, train_test_split

X, y = load_iris(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Grid search for best k
param_grid = {"n_neighbors": range(1, 21)}
grid = GridSearchCV(KNeighborsClassifier(), param_grid, cv=5, scoring="accuracy")
grid.fit(X_train, y_train)

print(f"Best k: {grid.best_params_['n_neighbors']}")
print(f"Best CV score: {grid.best_score_:.4f}")
print(f"Test score: {grid.score(X_test, y_test):.4f}")
```

---

> **Next Topic:** [20 - Deep Learning with TensorFlow](20-deep-learning-tensorflow.md)
