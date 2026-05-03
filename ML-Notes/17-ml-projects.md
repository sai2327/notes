# 17. ML Projects

## Table of Contents
- [17.1 Mini Projects](#171-mini-projects)
- [17.2 Real-World Projects](#172-real-world-projects)
- [17.3 Project Workflow Template](#173-project-workflow-template)

---

## 17.1 Mini Projects

### Project 1: Iris Flower Classification

```python
"""
Mini Project 1: Iris Flower Classification
Goal: Classify flowers into 3 species using petal/sepal measurements
Skills: Multi-class classification, model comparison, visualization
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import classification_report, confusion_matrix
import seaborn as sns

# Load data
iris = load_iris()
X, y = iris.data, iris.target
feature_names = iris.feature_names
target_names = iris.target_names

# Explore
df = pd.DataFrame(X, columns=feature_names)
df['species'] = [target_names[i] for i in y]
print(df.describe())
print(f"\nClass distribution:\n{df['species'].value_counts()}")

# Visualize
fig, axes = plt.subplots(1, 2, figsize=(12, 5))
for species in target_names:
    subset = df[df['species'] == species]
    axes[0].scatter(subset.iloc[:, 0], subset.iloc[:, 1], label=species, alpha=0.7)
    axes[1].scatter(subset.iloc[:, 2], subset.iloc[:, 3], label=species, alpha=0.7)
axes[0].set_xlabel(feature_names[0]); axes[0].set_ylabel(feature_names[1])
axes[1].set_xlabel(feature_names[2]); axes[1].set_ylabel(feature_names[3])
axes[0].legend(); axes[1].legend()
plt.tight_layout()
plt.show()

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Compare models
models = {
    'Logistic Regression': LogisticRegression(max_iter=200),
    'KNN (K=5)': KNeighborsClassifier(n_neighbors=5),
    'Decision Tree': DecisionTreeClassifier(random_state=42),
    'Random Forest': RandomForestClassifier(n_estimators=100, random_state=42),
    'SVM': SVC(kernel='rbf')
}

print(f"\n{'Model':<25} {'Accuracy':>10}")
print("-" * 37)

best_name, best_score = None, 0
for name, model in models.items():
    pipe = Pipeline([('scaler', StandardScaler()), ('clf', model)])
    scores = cross_val_score(pipe, X_train, y_train, cv=5, scoring='accuracy')
    if scores.mean() > best_score:
        best_score, best_name = scores.mean(), name
    print(f"{name:<25} {scores.mean():>10.4f} ± {scores.std():.4f}")

# Train best model and evaluate on test
print(f"\nBest: {best_name}")
best_pipe = Pipeline([('scaler', StandardScaler()), ('clf', models[best_name])])
best_pipe.fit(X_train, y_train)
y_pred = best_pipe.predict(X_test)
print(f"\n{classification_report(y_test, y_pred, target_names=target_names)}")

# Confusion matrix
cm = confusion_matrix(y_test, y_pred)
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
            xticklabels=target_names, yticklabels=target_names)
plt.xlabel('Predicted'); plt.ylabel('Actual')
plt.title('Confusion Matrix')
plt.show()
```

---

### Project 2: House Price Prediction

```python
"""
Mini Project 2: House Price Prediction
Goal: Predict house prices from features
Skills: Regression, feature engineering, regularization
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.datasets import fetch_california_housing
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LinearRegression, Ridge, Lasso
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error

# Load
housing = fetch_california_housing()
X = pd.DataFrame(housing.data, columns=housing.feature_names)
y = housing.target

print("Features:", list(X.columns))
print(f"Samples: {len(X)}, Target range: ${y.min()*100000:.0f} - ${y.max()*100000:.0f}")
print(f"\n{X.describe().round(2)}")

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Compare models
models = {
    'Linear Regression': LinearRegression(),
    'Ridge (α=1)': Ridge(alpha=1.0),
    'Lasso (α=0.01)': Lasso(alpha=0.01),
    'Random Forest': RandomForestRegressor(n_estimators=100, random_state=42)
}

print(f"\n{'Model':<25} {'RMSE':>8} {'R²':>8}")
print("-" * 43)

for name, model in models.items():
    pipe = Pipeline([('scaler', StandardScaler()), ('model', model)])
    scores = cross_val_score(pipe, X_train, y_train, cv=5,
                            scoring='neg_root_mean_squared_error')
    r2 = cross_val_score(pipe, X_train, y_train, cv=5, scoring='r2')
    print(f"{name:<25} {-scores.mean():>8.4f} {r2.mean():>8.4f}")

# Train best and evaluate
best_pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('model', RandomForestRegressor(n_estimators=100, random_state=42))
])
best_pipe.fit(X_train, y_train)
y_pred = best_pipe.predict(X_test)

print(f"\nTest Results (Random Forest):")
print(f"  MAE:  {mean_absolute_error(y_test, y_pred):.4f}")
print(f"  RMSE: {np.sqrt(mean_squared_error(y_test, y_pred)):.4f}")
print(f"  R²:   {r2_score(y_test, y_pred):.4f}")

# Actual vs Predicted
plt.figure(figsize=(8, 6))
plt.scatter(y_test, y_pred, alpha=0.3)
plt.plot([y.min(), y.max()], [y.min(), y.max()], 'r--', lw=2)
plt.xlabel("Actual Price")
plt.ylabel("Predicted Price")
plt.title("Actual vs Predicted House Prices")
plt.show()

# Feature importance
importances = pd.Series(
    best_pipe.named_steps['model'].feature_importances_,
    index=housing.feature_names
).sort_values(ascending=True)
importances.plot(kind='barh', figsize=(8, 5))
plt.title("Feature Importance")
plt.show()
```

---

### Project 3: Customer Segmentation (Unsupervised)

```python
"""
Mini Project 3: Customer Segmentation
Goal: Group customers into segments using clustering
Skills: K-Means, PCA, Elbow method, visualization
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.metrics import silhouette_score

# Generate realistic customer data
np.random.seed(42)
n = 500

data = {
    'Annual_Income': np.concatenate([
        np.random.normal(30, 8, 150),   # Low income
        np.random.normal(60, 10, 200),  # Medium income
        np.random.normal(100, 15, 150)  # High income
    ]),
    'Spending_Score': np.concatenate([
        np.random.normal(70, 15, 150),  # High spend (low income, high spend)
        np.random.normal(50, 12, 200),  # Medium spend
        np.random.normal(30, 10, 150)   # Low spend (high income, low spend)
    ]),
    'Age': np.concatenate([
        np.random.normal(25, 5, 150),
        np.random.normal(40, 10, 200),
        np.random.normal(55, 8, 150)
    ])
}

df = pd.DataFrame(data)
df = df.clip(lower=0)  # No negative values
print(df.describe().round(1))

# Scale
scaler = StandardScaler()
X_scaled = scaler.fit_transform(df)

# Elbow Method
wcss = []
sil_scores = []
K_range = range(2, 11)

for k in K_range:
    km = KMeans(n_clusters=k, random_state=42, n_init=10)
    labels = km.fit_predict(X_scaled)
    wcss.append(km.inertia_)
    sil_scores.append(silhouette_score(X_scaled, labels))

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
ax1.plot(K_range, wcss, 'b-o')
ax1.set_xlabel('K'); ax1.set_ylabel('WCSS'); ax1.set_title('Elbow Method')
ax2.plot(K_range, sil_scores, 'r-o')
ax2.set_xlabel('K'); ax2.set_ylabel('Silhouette Score'); ax2.set_title('Silhouette Analysis')
plt.tight_layout()
plt.show()

# Apply K-Means with optimal K
optimal_k = 3
kmeans = KMeans(n_clusters=optimal_k, random_state=42, n_init=10)
df['Cluster'] = kmeans.fit_predict(X_scaled)

print(f"\nSilhouette Score: {silhouette_score(X_scaled, df['Cluster']):.4f}")

# PCA for 2D visualization
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_scaled)

plt.figure(figsize=(10, 7))
colors = ['#e74c3c', '#3498db', '#2ecc71']
for i in range(optimal_k):
    mask = df['Cluster'] == i
    plt.scatter(X_pca[mask, 0], X_pca[mask, 1], c=colors[i],
                label=f'Cluster {i}', alpha=0.6, s=50)

centroids_pca = pca.transform(kmeans.cluster_centers_)
plt.scatter(centroids_pca[:, 0], centroids_pca[:, 1], c='black',
            marker='X', s=200, label='Centroids')
plt.xlabel(f'PC1 ({pca.explained_variance_ratio_[0]:.1%})')
plt.ylabel(f'PC2 ({pca.explained_variance_ratio_[1]:.1%})')
plt.title('Customer Segments (PCA Projection)')
plt.legend()
plt.show()

# Cluster profiles
print("\n=== CLUSTER PROFILES ===")
for i in range(optimal_k):
    cluster = df[df['Cluster'] == i]
    print(f"\nCluster {i} ({len(cluster)} customers):")
    print(f"  Avg Income:   ${cluster['Annual_Income'].mean():.0f}K")
    print(f"  Avg Spending: {cluster['Spending_Score'].mean():.0f}")
    print(f"  Avg Age:      {cluster['Age'].mean():.0f}")
```

---

## 17.2 Real-World Projects

### Project 4: Breast Cancer Detection (Full Pipeline)

```python
"""
Real-World Project: Breast Cancer Detection
Goal: Classify tumors as malignant/benign with full ML pipeline
Skills: Complete pipeline, evaluation, hyperparameter tuning, model comparison
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.svm import SVC
from sklearn.metrics import (
    classification_report, confusion_matrix, roc_curve, roc_auc_score
)

# ========== LOAD & EXPLORE ==========
data = load_breast_cancer()
X = pd.DataFrame(data.data, columns=data.feature_names)
y = pd.Series(data.target, name='target')

print(f"Shape: {X.shape}")
print(f"Classes: {dict(zip(data.target_names, np.bincount(y)))}")
print(f"Class ratio: {y.mean():.2%} benign")

# Correlation of top features
correlations = X.corrwith(y).abs().sort_values(ascending=False)
print(f"\nTop 10 correlated features:\n{correlations.head(10)}")

# ========== SPLIT ==========
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# ========== COMPARE MODELS ==========
models = {
    'Logistic Regression': LogisticRegression(max_iter=5000),
    'Random Forest': RandomForestClassifier(n_estimators=200, random_state=42),
    'SVM (RBF)': SVC(kernel='rbf', probability=True),
    'Gradient Boosting': GradientBoostingClassifier(random_state=42)
}

results = {}
print(f"\n{'Model':<25} {'F1':>8} {'AUC':>8}")
print("-" * 43)

for name, model in models.items():
    pipe = Pipeline([('scaler', StandardScaler()), ('clf', model)])
    f1 = cross_val_score(pipe, X_train, y_train, cv=5, scoring='f1').mean()
    auc = cross_val_score(pipe, X_train, y_train, cv=5, scoring='roc_auc').mean()
    results[name] = {'f1': f1, 'auc': auc}
    print(f"{name:<25} {f1:>8.4f} {auc:>8.4f}")

# ========== TUNE BEST MODEL ==========
pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('clf', LogisticRegression(max_iter=5000, random_state=42))
])

param_grid = {
    'clf__C': [0.01, 0.1, 1, 10, 100],
    'clf__penalty': ['l1', 'l2'],
    'clf__solver': ['liblinear']
}

grid = GridSearchCV(pipe, param_grid, cv=5, scoring='f1', n_jobs=-1)
grid.fit(X_train, y_train)

print(f"\nBest params: {grid.best_params_}")
print(f"Best CV F1:  {grid.best_score_:.4f}")

# ========== FINAL EVALUATION ==========
y_pred = grid.predict(X_test)
y_proba = grid.predict_proba(X_test)[:, 1]

print(f"\n{'='*50}")
print("FINAL TEST SET RESULTS")
print(f"{'='*50}")
print(classification_report(y_test, y_pred, target_names=data.target_names))

# Confusion Matrix
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

cm = confusion_matrix(y_test, y_pred)
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
            xticklabels=data.target_names, yticklabels=data.target_names, ax=ax1)
ax1.set_xlabel('Predicted'); ax1.set_ylabel('Actual')
ax1.set_title('Confusion Matrix')

# ROC Curve
fpr, tpr, _ = roc_curve(y_test, y_proba)
auc = roc_auc_score(y_test, y_proba)
ax2.plot(fpr, tpr, 'b-', label=f'Model (AUC={auc:.3f})')
ax2.plot([0,1], [0,1], 'r--', label='Random')
ax2.set_xlabel('FPR'); ax2.set_ylabel('TPR')
ax2.set_title('ROC Curve')
ax2.legend()

plt.tight_layout()
plt.show()

# ========== FEATURE IMPORTANCE ==========
coefs = pd.Series(
    np.abs(grid.best_estimator_.named_steps['clf'].coef_[0]),
    index=data.feature_names
).sort_values(ascending=True)

plt.figure(figsize=(10, 8))
coefs.tail(15).plot(kind='barh')
plt.title('Top 15 Feature Importances (|Coefficient|)')
plt.xlabel('Absolute Coefficient Value')
plt.tight_layout()
plt.show()
```

---

## 17.3 Project Workflow Template

### Use This Template for Any ML Project

```
┌─────────────────────────────────────────────────────────────────────┐
│  ML PROJECT TEMPLATE                                                │
│                                                                     │
│  Step 1: UNDERSTAND                                                 │
│  □ Define the problem (classification/regression?)                 │
│  □ Identify success metric (accuracy/F1/RMSE/R²?)                 │
│  □ Understand the data (features, target, size)                    │
│                                                                     │
│  Step 2: EXPLORE (EDA)                                             │
│  □ df.info(), df.describe(), df.isnull().sum()                     │
│  □ Target distribution (balanced?)                                 │
│  □ Feature distributions (histograms)                              │
│  □ Correlations (heatmap)                                          │
│  □ Outlier detection                                               │
│                                                                     │
│  Step 3: PREPROCESS                                                │
│  □ Train-test split FIRST                                          │
│  □ Handle missing values                                           │
│  □ Encode categoricals                                             │
│  □ Scale numerics                                                  │
│  □ Use sklearn Pipeline + ColumnTransformer                        │
│                                                                     │
│  Step 4: MODEL                                                     │
│  □ Try 3-5 algorithms with cross-validation                       │
│  □ Compare using appropriate metric                                │
│  □ Select top 1-2 models                                           │
│                                                                     │
│  Step 5: OPTIMIZE                                                  │
│  □ GridSearchCV / RandomizedSearchCV                               │
│  □ Try regularization                                              │
│  □ Feature selection if needed                                     │
│                                                                     │
│  Step 6: EVALUATE                                                  │
│  □ Final evaluation on test set                                    │
│  □ Classification: confusion matrix, report, ROC                   │
│  □ Regression: MAE, RMSE, R², residual plot                       │
│                                                                     │
│  Step 7: DEPLOY                                                    │
│  □ Save model with joblib                                          │
│  □ Create prediction function or API                               │
│  □ Document model and results                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

### Suggested Project Ideas

| # | Project | Type | Dataset |
|---|---------|------|---------|
| 1 | Spam Email Classifier | Classification | SMS Spam Collection |
| 2 | Movie Recommendation | Clustering | MovieLens |
| 3 | Stock Price Prediction | Regression | Yahoo Finance API |
| 4 | Digit Recognition | Multi-class | MNIST (sklearn) |
| 5 | Customer Churn Prediction | Classification | Telco Customer Churn |
| 6 | Credit Card Fraud Detection | Imbalanced Clf | Kaggle CC Fraud |
| 7 | Sentiment Analysis | NLP + Classification | Twitter/Amazon Reviews |
| 8 | Heart Disease Prediction | Classification | UCI Heart Disease |

---

> **Congratulations!** You have completed the entire ML Notes series.  
> Review files 01-17 for comprehensive coverage from fundamentals to real-world projects.
