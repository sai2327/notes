# 14. Model Optimization

## Table of Contents
- [14.1 What is Model Optimization?](#141-what-is-model-optimization)
- [14.2 Hyperparameter Tuning](#142-hyperparameter-tuning)
- [14.3 Regularization (L1 & L2)](#143-regularization-l1--l2)
- [14.4 Handling Imbalanced Data](#144-handling-imbalanced-data)
- [14.5 Python Implementation](#145-python-implementation)
- [14.6 Practice & Assessment](#146-practice--assessment)

---

## 14.1 What is Model Optimization?

```
┌────────────────────────────────────────────────────────────────┐
│  MODEL OPTIMIZATION WORKFLOW                                    │
│                                                                │
│  Base Model → Tune Hyperparameters → Add Regularization       │
│      │               │                       │                │
│      ▼               ▼                       ▼                │
│  Accuracy: 80%   Accuracy: 88%          Accuracy: 90%         │
│  (underfitting)  (better)               (optimal!)            │
│                                                                │
│  Goal: Find the BEST model settings without overfitting       │
└────────────────────────────────────────────────────────────────┘
```

### Parameters vs Hyperparameters

| | Parameters | Hyperparameters |
|---|-----------|----------------|
| **Set by** | Model during training | You, before training |
| **Examples** | Weights, bias, coefficients | Learning rate, max_depth, C, K |
| **Learned from** | Data | Trial and error / search |
| **Tunable?** | Automatic | Manual or Grid/Random Search |

---

## 14.2 Hyperparameter Tuning

### Grid Search (Exhaustive)

Tries **every combination** of hyperparameter values.

```
┌────────────────────────────────────────────────────────────────┐
│  GRID SEARCH EXAMPLE (Random Forest)                           │
│                                                                │
│  n_estimators: [50, 100, 200]                                  │
│  max_depth:    [5, 10, 20]                                     │
│  min_samples_split: [2, 5]                                     │
│                                                                │
│  Total combinations = 3 × 3 × 2 = 18                          │
│  With 5-fold CV = 18 × 5 = 90 model fits!                    │
│                                                                │
│  ┌──────────────┬───────────┬──────────────┬────────────────┐ │
│  │ n_estimators │ max_depth │ min_samples  │ CV Score       │ │
│  ├──────────────┼───────────┼──────────────┼────────────────┤ │
│  │ 50           │ 5         │ 2            │ 0.8523         │ │
│  │ 50           │ 5         │ 5            │ 0.8601         │ │
│  │ ...          │ ...       │ ...          │ ...            │ │
│  │ 200          │ 10        │ 2            │ 0.9234  ← BEST│ │
│  │ ...          │ ...       │ ...          │ ...            │ │
│  └──────────────┴───────────┴──────────────┴────────────────┘ │
└────────────────────────────────────────────────────────────────┘
```

```python
from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestClassifier

param_grid = {
    'n_estimators': [50, 100, 200],
    'max_depth': [5, 10, 20, None],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4]
}

grid_search = GridSearchCV(
    estimator=RandomForestClassifier(random_state=42),
    param_grid=param_grid,
    cv=5,
    scoring='f1',
    n_jobs=-1,      # Use all CPU cores
    verbose=1
)

grid_search.fit(X_train, y_train)

print(f"Best Parameters: {grid_search.best_params_}")
print(f"Best CV Score: {grid_search.best_score_:.4f}")
best_model = grid_search.best_estimator_
```

### Random Search (Efficient)

Tries **random combinations** — often finds good results faster.

```python
from sklearn.model_selection import RandomizedSearchCV
from scipy.stats import randint, uniform

param_distributions = {
    'n_estimators': randint(50, 500),
    'max_depth': randint(3, 30),
    'min_samples_split': randint(2, 20),
    'min_samples_leaf': randint(1, 10),
    'max_features': uniform(0.1, 0.9)
}

random_search = RandomizedSearchCV(
    estimator=RandomForestClassifier(random_state=42),
    param_distributions=param_distributions,
    n_iter=100,      # Try 100 random combinations
    cv=5,
    scoring='f1',
    random_state=42,
    n_jobs=-1
)

random_search.fit(X_train, y_train)
print(f"Best Parameters: {random_search.best_params_}")
print(f"Best CV Score: {random_search.best_score_:.4f}")
```

### Grid vs Random Search

| Feature | Grid Search | Random Search |
|---------|-----------|--------------|
| **Coverage** | All combinations | Random subset |
| **Speed** | Slow (exponential) | Fast |
| **Best for** | Small param space | Large param space |
| **Guarantee** | Finds best in grid | May miss optimal |
| **Recommended** | ≤ 3 params | ≥ 4 params |

---

## 14.3 Regularization (L1 & L2)

### What is Regularization?

**Regularization** adds a **penalty** to the model's cost function to prevent it from learning overly complex patterns (overfitting).

```
┌────────────────────────────────────────────────────────────────┐
│  WITHOUT REGULARIZATION        WITH REGULARIZATION             │
│                                                                │
│  y ▲  ·  ·                    y ▲  ·  ·                       │
│    │ · ╱╲ · ╱╲                  │ ·  ╱──── ·                  │
│    │╱  ╲╱  ╲                    │╱  ╱       ╲                 │
│    │    ·   · ╲                 │  ·         ╲                │
│    └──────────► x               └──────────► x                │
│    Overfitting!                 Smooth (generalizes!)          │
│    Memorizes noise              Captures pattern only          │
└────────────────────────────────────────────────────────────────┘
```

### L1 Regularization (Lasso)

$$Cost = MSE + \lambda \sum_{j=1}^{n} |w_j|$$

- Adds **absolute values** of weights as penalty
- Can shrink some weights to **exactly zero** → **Feature Selection!**
- Produces **sparse** models

### L2 Regularization (Ridge)

$$Cost = MSE + \lambda \sum_{j=1}^{n} w_j^2$$

- Adds **squared values** of weights as penalty
- Shrinks weights toward zero but **never exactly zero**
- Keeps all features but with smaller coefficients

### Elastic Net (L1 + L2 Combined)

$$Cost = MSE + \lambda_1 \sum |w_j| + \lambda_2 \sum w_j^2$$

### Comparison Table

| Feature | L1 (Lasso) | L2 (Ridge) | Elastic Net |
|---------|-----------|-----------|-------------|
| **Penalty** | $\sum\|w_j\|$ | $\sum w_j^2$ | Both |
| **Feature selection** | Yes (zeros out) | No | Yes (partial) |
| **Correlated features** | Picks one, drops rest | Keeps all, shrinks | Balanced |
| **When to use** | Many irrelevant features | All features may matter | Best of both |
| **sklearn** | `Lasso()` | `Ridge()` | `ElasticNet()` |
| **Logistic** | `penalty='l1'` | `penalty='l2'` | `penalty='elasticnet'` |

### Lambda (α) — Regularization Strength

```
┌────────────────────────────────────────────────────────────────┐
│  α (lambda) EFFECT                                             │
│                                                                │
│  α = 0     → No regularization (overfitting risk)             │
│  α = small → Mild penalty (slight regularization)             │
│  α = large → Heavy penalty (underfitting risk — too simple)   │
│                                                                │
│  Model Complexity ◄──────────────────────► Regularization      │
│  (overfit)            Sweet Spot            (underfit)         │
└────────────────────────────────────────────────────────────────┘
```

```python
from sklearn.linear_model import Ridge, Lasso, ElasticNet

# Ridge (L2)
ridge = Ridge(alpha=1.0)
ridge.fit(X_train, y_train)

# Lasso (L1)
lasso = Lasso(alpha=0.1)
lasso.fit(X_train, y_train)
print(f"Features with zero coefficient: {sum(lasso.coef_ == 0)}")

# Elastic Net
enet = ElasticNet(alpha=0.1, l1_ratio=0.5)  # l1_ratio: mix of L1 vs L2
enet.fit(X_train, y_train)
```

---

## 14.4 Handling Imbalanced Data

### The Problem

```
┌────────────────────────────────────────────────────────────────┐
│  Fraud Detection Dataset:                                      │
│  ████████████████████████████████████████████████  99% Normal  │
│  █                                                 1% Fraud   │
│                                                                │
│  Model predicts "Normal" for everything → 99% accuracy!       │
│  But catches 0% fraud → USELESS                               │
└────────────────────────────────────────────────────────────────┘
```

### Solutions

| Technique | How It Works |
|-----------|-------------|
| **Class Weights** | Give more importance to minority class |
| **SMOTE** | Create synthetic minority samples |
| **Undersampling** | Reduce majority class samples |
| **Oversampling** | Duplicate minority class samples |
| **Threshold tuning** | Adjust decision threshold |

```python
# Method 1: Class Weights (built-in to most sklearn models)
from sklearn.ensemble import RandomForestClassifier
model = RandomForestClassifier(class_weight='balanced', random_state=42)

# Method 2: SMOTE (need to install: pip install imbalanced-learn)
from imblearn.over_sampling import SMOTE
smote = SMOTE(random_state=42)
X_resampled, y_resampled = smote.fit_resample(X_train, y_train)
```

---

## 14.5 Python Implementation

### Complete Optimization Pipeline

```python
import numpy as np
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import (
    train_test_split, GridSearchCV, cross_val_score
)
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.metrics import f1_score

# Load
data = load_breast_cancer()
X_train, X_test, y_train, y_test = train_test_split(
    data.data, data.target, test_size=0.2, random_state=42, stratify=data.target
)

# === PIPELINE WITH GRID SEARCH ===
pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('clf', LogisticRegression(max_iter=1000, random_state=42))
])

param_grid = {
    'clf__C': [0.01, 0.1, 1, 10, 100],
    'clf__penalty': ['l1', 'l2'],
    'clf__solver': ['liblinear']
}

grid = GridSearchCV(pipe, param_grid, cv=5, scoring='f1', n_jobs=-1)
grid.fit(X_train, y_train)

print(f"Best params: {grid.best_params_}")
print(f"Best CV F1:  {grid.best_score_:.4f}")
print(f"Test F1:     {f1_score(y_test, grid.predict(X_test)):.4f}")

# Show top 5 results
import pandas as pd
results = pd.DataFrame(grid.cv_results_)
top5 = results.nsmallest(5, 'rank_test_score')[
    ['param_clf__C', 'param_clf__penalty', 'mean_test_score', 'std_test_score']
]
print(f"\nTop 5 configurations:\n{top5.to_string(index=False)}")

# === COMPARE REGULARIZATION ===
from sklearn.linear_model import Ridge, Lasso
from sklearn.datasets import make_regression

X_reg, y_reg = make_regression(n_samples=200, n_features=20, n_informative=5,
                               noise=10, random_state=42)
X_r_train, X_r_test, y_r_train, y_r_test = train_test_split(
    X_reg, y_reg, test_size=0.2, random_state=42
)

for alpha in [0.01, 0.1, 1, 10, 100]:
    ridge = Ridge(alpha=alpha).fit(X_r_train, y_r_train)
    lasso = Lasso(alpha=alpha).fit(X_r_train, y_r_train)
    print(f"\nalpha={alpha:>6}:")
    print(f"  Ridge R²: {ridge.score(X_r_test, y_r_test):.4f}, "
          f"Non-zero coefs: {sum(ridge.coef_ != 0)}")
    print(f"  Lasso R²: {lasso.score(X_r_test, y_r_test):.4f}, "
          f"Non-zero coefs: {sum(lasso.coef_ != 0)}")
```

---

## 14.6 Practice & Assessment

### MCQs

**Q1.** Which regularization technique can be used for feature selection?
- A) L2 (Ridge)
- B) L1 (Lasso)
- C) Both equally
- D) Neither

**Answer:** B — L1 (Lasso) can shrink coefficients to exactly zero, removing features.

---

**Q2.** Random Search is preferred over Grid Search when:
- A) You have very few hyperparameters
- B) You need the absolute best combination
- C) You have many hyperparameters (large search space)
- D) You have unlimited time

**Answer:** C — Random Search is more efficient for large search spaces.

---

**Q3.** Increasing regularization strength (λ) too much leads to:
- A) Overfitting
- B) Underfitting
- C) Perfect model
- D) No effect

**Answer:** B — Too much regularization makes the model too simple (underfitting).

---

> **Next Topic:** [15 - End-to-End ML Pipeline](15-end-to-end-ml-pipeline.md)
