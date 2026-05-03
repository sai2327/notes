# 16. ML Cheat Sheet & Interview Questions

## Table of Contents
- [16.1 Algorithm Selection Cheat Sheet](#161-algorithm-selection-cheat-sheet)
- [16.2 Quick Reference Tables](#162-quick-reference-tables)
- [16.3 Common Interview Questions](#163-common-interview-questions)
- [16.4 Code Snippets Cheat Sheet](#164-code-snippets-cheat-sheet)

---

## 16.1 Algorithm Selection Cheat Sheet

```
┌────────────────────────────────────────────────────────────────────────────┐
│  ML ALGORITHM DECISION FLOWCHART                                           │
│                                                                            │
│  Do you have LABELED data?                                                │
│  ├── YES (Supervised)                                                     │
│  │   ├── Predicting a category? → CLASSIFICATION                         │
│  │   │   ├── Binary?                                                      │
│  │   │   │   ├── Need interpretability → Logistic Regression              │
│  │   │   │   ├── Small data → SVM, KNN                                   │
│  │   │   │   ├── Text data → Naive Bayes                                 │
│  │   │   │   └── Best accuracy → Random Forest, XGBoost                  │
│  │   │   └── Multi-class?                                                 │
│  │   │       ├── Few classes → Random Forest, SVM                        │
│  │   │       └── Many classes → Naive Bayes, Neural Nets                 │
│  │   │                                                                    │
│  │   └── Predicting a number? → REGRESSION                               │
│  │       ├── Linear relationship → Linear/Ridge/Lasso                    │
│  │       ├── Non-linear → Decision Tree, Random Forest                   │
│  │       └── Best accuracy → XGBoost, Neural Nets                        │
│  │                                                                        │
│  └── NO (Unsupervised)                                                    │
│      ├── Group similar items? → CLUSTERING                               │
│      │   ├── Know K → K-Means                                            │
│      │   ├── Don't know K → DBSCAN, Hierarchical                        │
│      │   └── Irregular shapes → DBSCAN                                   │
│      │                                                                    │
│      └── Reduce features? → DIMENSIONALITY REDUCTION                    │
│          └── PCA                                                          │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 16.2 Quick Reference Tables

### All Algorithms at a Glance

| Algorithm | Type | Scaling? | Training Speed | Prediction Speed | Interpretable | Handles Non-linear |
|-----------|------|----------|---------------|-----------------|--------------|-------------------|
| Linear Regression | Reg | For regularized | Very Fast | Very Fast | High | No |
| Logistic Regression | Clf | Yes | Very Fast | Very Fast | High | No |
| KNN | Both | Yes | None (lazy) | Slow | Medium | Yes |
| Decision Tree | Both | No | Fast | Very Fast | Very High | Yes |
| Random Forest | Both | No | Medium | Medium | Low | Yes |
| SVM | Both | Yes | Slow | Medium | Low | Yes (kernel) |
| Naive Bayes | Clf | No | Very Fast | Very Fast | Medium | No |
| K-Means | Clustering | Yes | Medium | Fast | Medium | No |
| DBSCAN | Clustering | Yes | Medium | - | Medium | Yes |
| PCA | Dim. Reduction | Yes | Fast | Fast | Low | No |

### Evaluation Metrics Quick Reference

| Metric | Type | Range | Higher is Better? | Use When |
|--------|------|-------|-------------------|----------|
| Accuracy | Clf | 0-1 | Yes | Balanced classes |
| Precision | Clf | 0-1 | Yes | FP is costly |
| Recall | Clf | 0-1 | Yes | FN is costly |
| F1 Score | Clf | 0-1 | Yes | Imbalanced data |
| AUC-ROC | Clf | 0-1 | Yes | Need ranking |
| MAE | Reg | 0-∞ | No | Robust to outliers |
| MSE/RMSE | Reg | 0-∞ | No | Penalize large errors |
| R² | Reg | -∞ to 1 | Yes | Explain variance |

### Preprocessing Quick Reference

| Problem | Solution | sklearn Class |
|---------|----------|--------------|
| Missing values (numeric) | Mean/Median imputation | `SimpleImputer(strategy='median')` |
| Missing values (categorical) | Mode imputation | `SimpleImputer(strategy='most_frequent')` |
| Different scales | Standardization | `StandardScaler()` |
| Normalize 0-1 | Min-Max scaling | `MinMaxScaler()` |
| Categorical → Numbers | One-Hot Encoding | `OneHotEncoder()` |
| Ordinal categories | Label Encoding | `OrdinalEncoder()` |
| Too many features | PCA | `PCA(n_components=k)` |
| Feature selection | L1 regularization | `Lasso()` or `SelectFromModel()` |

---

## 16.3 Common Interview Questions

### Fundamentals

**Q1. What is the difference between supervised and unsupervised learning?**
> **Supervised:** Has labeled data (input → output). Model learns mapping.  
> **Unsupervised:** No labels. Model finds patterns/structure in data.  
> Example: Spam detection (supervised) vs Customer segmentation (unsupervised).

**Q2. What is the bias-variance tradeoff?**
> **Bias:** Error from wrong assumptions (underfitting). High bias = too simple.  
> **Variance:** Error from sensitivity to training data (overfitting). High variance = too complex.  
> **Tradeoff:** Reducing one often increases the other. Goal: minimize both (sweet spot).

**Q3. How do you handle overfitting?**
> - More training data
> - Regularization (L1/L2)
> - Reduce model complexity (fewer features, shallower tree)
> - Cross-validation
> - Dropout (neural networks)
> - Early stopping

**Q4. What is cross-validation and why use it?**
> K-Fold CV splits data into K parts. Each part takes a turn as test set. Provides more reliable performance estimate than a single train-test split. Detects overfitting.

---

### Algorithms

**Q5. When would you use Random Forest over Decision Tree?**
> Decision Trees overfit easily. Random Forest reduces overfitting by averaging many trees (bagging + random features). Use RF when accuracy matters more than interpretability.

**Q6. Explain the kernel trick in SVM.**
> When data isn't linearly separable, SVM maps data to a higher-dimensional space using a kernel function where it becomes separable. The "trick" is doing this without actually computing the transformation — just using dot products.

**Q7. Why is Naive Bayes called "naive"?**
> It assumes all features are conditionally independent given the class. This is rarely true (e.g., height and weight are correlated), but the algorithm still works surprisingly well in practice, especially for text classification.

**Q8. How does K-Means work?**
> 1. Choose K, randomly initialize centroids  
> 2. Assign each point to nearest centroid  
> 3. Recalculate centroids as mean of assigned points  
> 4. Repeat until convergence (centroids stop moving)

---

### Practical

**Q9. How do you handle imbalanced datasets?**
> - Use F1/AUC instead of accuracy
> - Oversample minority (SMOTE)
> - Undersample majority
> - Use class_weight='balanced'
> - Try ensemble methods
> - Adjust classification threshold

**Q10. What is data leakage and how to prevent it?**
> Data leakage = test data influences training (e.g., scaling before splitting). Prevent by:
> - Split BEFORE any preprocessing
> - Use sklearn Pipelines
> - Never look at test data during development
> - fit_transform on train, transform only on test

**Q11. Explain the difference between L1 and L2 regularization.**
> **L1 (Lasso):** Adds sum of absolute weights. Can zero out coefficients → feature selection.  
> **L2 (Ridge):** Adds sum of squared weights. Shrinks but never zeros → keeps all features.  
> Use L1 for sparse solutions, L2 when all features may be relevant.

**Q12. How do you choose the right evaluation metric?**
> - Balanced classes → Accuracy
> - Imbalanced + FP costly (spam filter) → Precision
> - Imbalanced + FN costly (disease) → Recall
> - Balance P & R → F1 Score
> - Probability ranking → AUC-ROC
> - Regression → RMSE or R²

---

### Scenario-Based

**Q13. You trained a model with 99% training accuracy but 60% test accuracy. What happened?**
> **Overfitting.** Solutions: regularization, more data, simpler model, cross-validation, dropout.

**Q14. Your model has high precision but low recall. What does this mean?**
> The model is conservative — when it predicts positive, it's usually correct (few FP), but it misses many actual positives (many FN). Lower the classification threshold to increase recall.

**Q15. You have 1000 features and 500 samples. What would you do?**
> - Apply PCA for dimensionality reduction
> - Use L1 regularization for feature selection
> - Use models that handle high dimensions (SVM, Naive Bayes)
> - Remove correlated features
> - Collect more data if possible

---

## 16.4 Code Snippets Cheat Sheet

### Essential Imports

```python
# Data
import numpy as np
import pandas as pd

# Visualization
import matplotlib.pyplot as plt
import seaborn as sns

# Preprocessing
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV
from sklearn.preprocessing import StandardScaler, OneHotEncoder, LabelEncoder
from sklearn.impute import SimpleImputer
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline

# Models
from sklearn.linear_model import LinearRegression, LogisticRegression, Ridge, Lasso
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB, MultinomialNB
from sklearn.cluster import KMeans, DBSCAN, AgglomerativeClustering
from sklearn.decomposition import PCA

# Metrics
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    confusion_matrix, classification_report, roc_auc_score, roc_curve,
    mean_absolute_error, mean_squared_error, r2_score, silhouette_score
)

# Save/Load
import joblib
```

### One-Line Operations

```python
# Train-Test Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

# Quick model evaluation
cross_val_score(model, X, y, cv=5, scoring='f1').mean()

# Feature importance
pd.Series(model.feature_importances_, index=feature_names).sort_values(ascending=False)

# Confusion matrix heatmap
sns.heatmap(confusion_matrix(y_test, y_pred), annot=True, fmt='d', cmap='Blues')

# Save & load model
joblib.dump(model, 'model.joblib')
model = joblib.load('model.joblib')
```

### Quick Pipeline Template

```python
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV

pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('clf', RandomForestClassifier(random_state=42))
])

param_grid = {'clf__n_estimators': [100, 200], 'clf__max_depth': [10, 20, None]}
grid = GridSearchCV(pipe, param_grid, cv=5, scoring='f1', n_jobs=-1)
grid.fit(X_train, y_train)

print(f"Best: {grid.best_params_}, Score: {grid.best_score_:.4f}")
```

---

> **Next Topic:** [17 - ML Projects](17-ml-projects.md)
