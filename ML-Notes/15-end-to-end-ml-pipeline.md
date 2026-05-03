# 15. End-to-End ML Pipeline

## Table of Contents
- [15.1 Complete ML Workflow](#151-complete-ml-workflow)
- [15.2 Step 1: Define Problem](#152-step-1-define-problem)
- [15.3 Step 2: Collect & Explore Data](#153-step-2-collect--explore-data)
- [15.4 Step 3: Preprocess Data](#154-step-3-preprocess-data)
- [15.5 Step 4: Feature Engineering](#155-step-4-feature-engineering)
- [15.6 Step 5: Model Selection & Training](#156-step-5-model-selection--training)
- [15.7 Step 6: Evaluation & Tuning](#157-step-6-evaluation--tuning)
- [15.8 Step 7: Deployment](#158-step-7-deployment)
- [15.9 Complete Pipeline Code](#159-complete-pipeline-code)
- [15.10 Practice & Assessment](#1510-practice--assessment)

---

## 15.1 Complete ML Workflow

```
┌────────────────────────────────────────────────────────────────────────┐
│  END-TO-END ML PIPELINE                                                │
│                                                                        │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐           │
│  │ 1.DEFINE │──▶│ 2.COLLECT│──▶│ 3.CLEAN  │──▶│4.FEATURE │           │
│  │ PROBLEM  │   │ & EDA    │   │ & PREPROC│   │ENGINEER  │           │
│  └──────────┘   └──────────┘   └──────────┘   └──────────┘           │
│       │                                              │                │
│       │         ┌──────────┐   ┌──────────┐   ┌──────────┐           │
│       └────────▶│ 7.DEPLOY │◀──│ 6.TUNE   │◀──│ 5.MODEL  │           │
│                 │ & MONITOR│   │ & EVALUAT│   │ TRAINING │           │
│                 └──────────┘   └──────────┘   └──────────┘           │
│                      │                                                │
│                      ▼                                                │
│               ┌──────────┐                                            │
│               │PRODUCTION│    ← If performance drops,               │
│               │MONITORING│      retrain with new data                │
│               └──────────┘                                            │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 15.2 Step 1: Define Problem

```
┌────────────────────────────────────────────────────────────────────┐
│  PROBLEM DEFINITION CHECKLIST                                      │
│                                                                    │
│  □ What is the business goal?                                     │
│  □ Classification or Regression?                                  │
│  □ What data is available?                                        │
│  □ What metric defines success?                                   │
│  □ What is the baseline performance?                              │
│  □ Are there constraints (speed, memory, interpretability)?       │
└────────────────────────────────────────────────────────────────────┘
```

| Example Problem | Type | Target | Success Metric |
|----------------|------|--------|---------------|
| Will customer churn? | Binary Classification | churn (0/1) | F1, Recall |
| Predict house price | Regression | price ($) | RMSE, R² |
| Which product to recommend? | Multi-class Classification | product_id | Accuracy, Top-K |
| Customer segments | Clustering (Unsupervised) | None | Silhouette Score |

---

## 15.3 Step 2: Collect & Explore Data

```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load data
df = pd.read_csv("data.csv")

# Quick overview
print(df.shape)                  # Rows, Columns
print(df.info())                 # Dtypes, non-null counts
print(df.describe())             # Statistics
print(df.isnull().sum())         # Missing values
print(df.duplicated().sum())     # Duplicates
print(df['target'].value_counts())  # Class distribution

# Visualize distributions
df.hist(figsize=(12, 8), bins=30)
plt.tight_layout()
plt.show()

# Correlation heatmap
plt.figure(figsize=(10, 8))
sns.heatmap(df.corr(numeric_only=True), annot=True, cmap='coolwarm', center=0)
plt.title("Feature Correlations")
plt.show()
```

---

## 15.4 Step 3: Preprocess Data

```python
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer

# Identify column types
numeric_features = ['age', 'income', 'score']
categorical_features = ['gender', 'city', 'category']

# Build preprocessor
numeric_pipeline = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler', StandardScaler())
])

categorical_pipeline = Pipeline([
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('encoder', OneHotEncoder(handle_unknown='ignore', sparse_output=False))
])

preprocessor = ColumnTransformer([
    ('num', numeric_pipeline, numeric_features),
    ('cat', categorical_pipeline, categorical_features)
])
```

---

## 15.5 Step 4: Feature Engineering

```python
# Common techniques
df['age_group'] = pd.cut(df['age'], bins=[0,25,45,65,100],
                         labels=['Young','Middle','Senior','Elder'])

df['income_per_age'] = df['income'] / df['age']

df['signup_year'] = pd.to_datetime(df['signup_date']).dt.year
df['signup_month'] = pd.to_datetime(df['signup_date']).dt.month

# Drop unnecessary columns
df = df.drop(['id', 'name', 'signup_date'], axis=1)
```

---

## 15.6 Step 5: Model Selection & Training

### Algorithm Selection Guide

```
┌────────────────────────────────────────────────────────────────┐
│  WHICH ALGORITHM TO USE?                                       │
│                                                                │
│  Data size?                                                    │
│  ├── Small (< 1K) → KNN, SVM, Naive Bayes                    │
│  │                                                             │
│  └── Large (> 10K)                                             │
│      ├── Classification?                                       │
│      │   ├── Need interpretability → Logistic Reg, Decision Tree│
│      │   ├── Need best accuracy → Random Forest, XGBoost      │
│      │   └── Text data → Naive Bayes                          │
│      │                                                         │
│      └── Regression?                                           │
│          ├── Linear relationship → Linear/Ridge/Lasso          │
│          └── Non-linear → Random Forest, XGBoost              │
└────────────────────────────────────────────────────────────────┘
```

### Compare Multiple Models

```python
from sklearn.model_selection import cross_val_score
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier

models = {
    'Logistic Regression': LogisticRegression(max_iter=1000),
    'Random Forest': RandomForestClassifier(n_estimators=100, random_state=42),
    'SVM': SVC(kernel='rbf'),
    'KNN': KNeighborsClassifier(n_neighbors=5),
    'Gradient Boosting': GradientBoostingClassifier(random_state=42)
}

print(f"{'Model':<25} {'CV F1 Mean':>10} {'CV F1 Std':>10}")
print("-" * 47)

for name, model in models.items():
    full_pipe = Pipeline([
        ('preprocessor', preprocessor),
        ('classifier', model)
    ])
    scores = cross_val_score(full_pipe, X, y, cv=5, scoring='f1')
    print(f"{name:<25} {scores.mean():>10.4f} {scores.std():>10.4f}")
```

---

## 15.7 Step 6: Evaluation & Tuning

```python
from sklearn.model_selection import GridSearchCV

# Build full pipeline
full_pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('classifier', RandomForestClassifier(random_state=42))
])

# Define hyperparameter search
param_grid = {
    'classifier__n_estimators': [100, 200],
    'classifier__max_depth': [10, 20, None],
    'classifier__min_samples_split': [2, 5]
}

grid = GridSearchCV(
    full_pipeline, param_grid, cv=5,
    scoring='f1', n_jobs=-1, verbose=1
)
grid.fit(X_train, y_train)

print(f"Best params: {grid.best_params_}")
print(f"Best CV F1:  {grid.best_score_:.4f}")

# Final evaluation on test set
from sklearn.metrics import classification_report
y_pred = grid.predict(X_test)
print(classification_report(y_test, y_pred))
```

---

## 15.8 Step 7: Deployment

### Save Model

```python
import joblib

# Save
joblib.dump(grid.best_estimator_, 'model.joblib')

# Load
loaded_model = joblib.load('model.joblib')
prediction = loaded_model.predict(new_data)
```

### Simple Flask API

```python
# app.py
from flask import Flask, request, jsonify
import joblib
import pandas as pd

app = Flask(__name__)
model = joblib.load('model.joblib')

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    df = pd.DataFrame([data])
    prediction = model.predict(df)
    probability = model.predict_proba(df).max()
    return jsonify({
        'prediction': int(prediction[0]),
        'confidence': float(probability)
    })

if __name__ == '__main__':
    app.run(debug=False, port=5000)
```

---

## 15.9 Complete Pipeline Code

```python
"""
Complete End-to-End ML Pipeline
Dataset: Titanic Survival Prediction (example)
"""

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, GridSearchCV, cross_val_score
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, f1_score
import joblib

# ============================================
# STEP 1: Load & Explore
# ============================================
# Using sklearn's built-in dataset for reproducibility
from sklearn.datasets import load_breast_cancer
data = load_breast_cancer()
df = pd.DataFrame(data.data, columns=data.feature_names)
df['target'] = data.target

print(f"Shape: {df.shape}")
print(f"Target distribution:\n{df['target'].value_counts()}")
print(f"Missing values:\n{df.isnull().sum().sum()}")

# ============================================
# STEP 2: Split Data (BEFORE any preprocessing!)
# ============================================
X = df.drop('target', axis=1)
y = df['target']

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

print(f"\nTrain: {X_train.shape}, Test: {X_test.shape}")

# ============================================
# STEP 3: Build Preprocessing Pipeline
# ============================================
numeric_features = X.columns.tolist()

preprocessor = ColumnTransformer([
    ('num', Pipeline([
        ('imputer', SimpleImputer(strategy='median')),
        ('scaler', StandardScaler())
    ]), numeric_features)
])

# ============================================
# STEP 4: Compare Models
# ============================================
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC

models = {
    'Logistic Regression': LogisticRegression(max_iter=1000),
    'Random Forest': RandomForestClassifier(n_estimators=100, random_state=42),
    'SVM': SVC(kernel='rbf'),
}

print("\nModel Comparison (5-Fold CV):")
print(f"{'Model':<25} {'F1 Mean':>8} {'F1 Std':>8}")
print("-" * 43)

best_model_name = None
best_score = 0

for name, model in models.items():
    pipe = Pipeline([('preprocessor', preprocessor), ('clf', model)])
    scores = cross_val_score(pipe, X_train, y_train, cv=5, scoring='f1')
    if scores.mean() > best_score:
        best_score = scores.mean()
        best_model_name = name
    print(f"{name:<25} {scores.mean():>8.4f} {scores.std():>8.4f}")

print(f"\nBest model: {best_model_name} (F1={best_score:.4f})")

# ============================================
# STEP 5: Hyperparameter Tuning (Best Model)
# ============================================
final_pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('clf', RandomForestClassifier(random_state=42))
])

param_grid = {
    'clf__n_estimators': [100, 200, 300],
    'clf__max_depth': [10, 20, None],
    'clf__min_samples_split': [2, 5],
}

grid = GridSearchCV(final_pipeline, param_grid, cv=5,
                    scoring='f1', n_jobs=-1)
grid.fit(X_train, y_train)

print(f"\nBest hyperparameters: {grid.best_params_}")
print(f"Best CV F1: {grid.best_score_:.4f}")

# ============================================
# STEP 6: Final Evaluation on Test Set
# ============================================
y_pred = grid.predict(X_test)
print(f"\nTest Set Results:")
print(f"F1 Score: {f1_score(y_test, y_pred):.4f}")
print(f"\n{classification_report(y_test, y_pred, target_names=data.target_names)}")

# ============================================
# STEP 7: Save Model
# ============================================
joblib.dump(grid.best_estimator_, 'best_model.joblib')
print("\nModel saved as 'best_model.joblib'")

# Test loading
loaded = joblib.load('best_model.joblib')
assert np.array_equal(loaded.predict(X_test), y_pred)
print("Model loaded and verified successfully!")
```

---

## 15.10 Practice & Assessment

### MCQs

**Q1.** When should you split data into train/test sets?
- A) After feature engineering
- B) After scaling
- C) Before any preprocessing
- D) After model training

**Answer:** C — Split first to prevent data leakage (test data must never influence preprocessing).

---

**Q2.** Why use a Pipeline in sklearn?
- A) Makes code shorter
- B) Prevents data leakage and automates preprocessing
- C) Makes models faster
- D) Only for visualization

**Answer:** B — Pipelines ensure preprocessing is fit only on training data, preventing leakage.

---

**Q3.** Cross-validation is used to:
- A) Clean the data
- B) Get a more reliable estimate of model performance
- C) Deploy the model
- D) Reduce features

**Answer:** B — CV tests on multiple folds for a more robust performance estimate.

---

> **Next Topic:** [16 - ML Cheat Sheet & Interview Questions](16-ml-cheat-sheet-interview.md)
