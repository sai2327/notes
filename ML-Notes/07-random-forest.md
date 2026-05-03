# 07. Random Forest

## Table of Contents
- [7.1 Intuition](#71-intuition)
- [7.2 How Random Forest Works](#72-how-random-forest-works)
- [7.3 Bagging & Feature Randomness](#73-bagging--feature-randomness)
- [7.4 Python Implementation](#74-python-implementation)
- [7.5 Hyperparameter Tuning](#75-hyperparameter-tuning)
- [7.6 Advantages & Disadvantages](#76-advantages--disadvantages)
- [7.7 Practice & Assessment](#77-practice--assessment)

---

## 7.1 Intuition

### Definition
**Random Forest** is an **ensemble learning** method that builds multiple decision trees and combines their predictions through **majority voting** (classification) or **averaging** (regression).

> **Analogy:** Instead of asking one expert, ask 100 experts and go with the majority opinion. The "wisdom of the crowd" reduces individual errors.

```
┌────────────────────────────────────────────────────────────────┐
│  RANDOM FOREST = MANY DECISION TREES                            │
│                                                                │
│  ┌──────┐    ┌──────┐    ┌──────┐         ┌──────┐           │
│  │Tree 1│    │Tree 2│    │Tree 3│  . . .  │Tree N│           │
│  │      │    │      │    │      │         │      │           │
│  │ Cat  │    │ Dog  │    │ Cat  │         │ Cat  │           │
│  └──┬───┘    └──┬───┘    └──┬───┘         └──┬───┘           │
│     │           │           │                │               │
│     └───────────┴───────────┴────────────────┘               │
│                        │                                      │
│                   MAJORITY VOTE                               │
│                        │                                      │
│                     [ Cat ]  ← Final prediction               │
│                                                               │
│  Cat=3 votes, Dog=1 vote → Cat wins!                          │
└────────────────────────────────────────────────────────────────┘
```

---

## 7.2 How Random Forest Works

### Algorithm

```
1. From original dataset (N samples, M features):
   a. Create B bootstrap samples (random sampling WITH replacement)
   b. For each bootstrap sample:
      - Build a Decision Tree
      - At each split, consider only √M random features (not all M)
      - Grow tree to full depth (no pruning)
   
2. For prediction:
   - Classification: Each tree votes → majority class wins
   - Regression: Each tree predicts → average of all predictions

This is called BAGGING + FEATURE RANDOMNESS
```

### Step-by-Step Visualization

```
Original Dataset (10 samples, 5 features):
[S1, S2, S3, S4, S5, S6, S7, S8, S9, S10]

Bootstrap Sample 1:          Bootstrap Sample 2:
[S3, S1, S7, S3, S5,        [S2, S6, S4, S8, S1,
 S9, S1, S10, S4, S7]        S5, S2, S10, S3, S6]
    ↓ (random √5≈2             ↓ (random √5≈2
       features each split)       features each split)

┌────────┐                   ┌────────┐
│ Tree 1 │                   │ Tree 2 │
│  Uses  │                   │  Uses  │
│ F2, F4 │                   │ F1, F5 │
│ at root│                   │ at root│
│        │                   │        │
│→ Cat   │                   │→ Dog   │     ... 98 more trees
└────────┘                   └────────┘

Final: Aggregate all 100 tree predictions → Majority vote
```

---

## 7.3 Bagging & Feature Randomness

### Bagging (Bootstrap Aggregation)

```
┌────────────────────────────────────────────────────────────┐
│  BOOTSTRAP SAMPLING                                         │
│                                                            │
│  Original: [A, B, C, D, E, F, G, H, I, J]                │
│                                                            │
│  Sample 1: [A, C, C, D, F, G, G, H, I, J]  ← with replacement │
│  Sample 2: [B, B, D, E, F, F, H, I, I, J]  (some repeated,   │
│  Sample 3: [A, A, C, D, E, G, H, H, I, J]   some missing)    │
│                                                            │
│  ~63.2% unique samples per bootstrap (1 - 1/e)            │
│  ~36.8% left out → "Out-of-Bag" (OOB) samples             │
│  OOB samples can be used for validation!                   │
└────────────────────────────────────────────────────────────┘
```

### Why Feature Randomness?

```
Without feature randomness:     With feature randomness:
┌─────────────────────┐        ┌─────────────────────┐
│ Tree 1: Split on F3 │        │ Tree 1: Split on F3 │
│ Tree 2: Split on F3 │        │ Tree 2: Split on F1 │
│ Tree 3: Split on F3 │        │ Tree 3: Split on F5 │
│                     │        │                     │
│ All trees look      │        │ Trees are DIVERSE!  │
│ similar → correlated│        │ Less correlated     │
│ → not much benefit  │        │ → better ensemble   │
└─────────────────────┘        └─────────────────────┘

Default features per split:
  Classification: √M features
  Regression: M/3 features
```

---

## 7.4 Python Implementation

### Complete Example

```python
import numpy as np
import pandas as pd
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
import matplotlib.pyplot as plt

# Load data
data = load_breast_cancer()
X = pd.DataFrame(data.data, columns=data.feature_names)
y = data.target

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Train Random Forest
rf = RandomForestClassifier(
    n_estimators=100,       # Number of trees
    max_depth=None,          # No depth limit
    min_samples_split=2,
    max_features='sqrt',     # √M features per split
    random_state=42,
    oob_score=True           # Out-of-Bag score
)
rf.fit(X_train, y_train)

# Evaluate
y_pred = rf.predict(X_test)
print(f"Test Accuracy: {accuracy_score(y_test, y_pred):.4f}")
print(f"OOB Score: {rf.oob_score_:.4f}")
print(f"\n{classification_report(y_test, y_pred, target_names=data.target_names)}")

# Cross-validation
cv_scores = cross_val_score(rf, X, y, cv=5, scoring='accuracy')
print(f"CV Accuracy: {cv_scores.mean():.4f} ± {cv_scores.std():.4f}")

# Feature Importance (top 10)
importance = pd.Series(rf.feature_importances_, index=X.columns)
top10 = importance.nlargest(10)

plt.figure(figsize=(10, 6))
top10.sort_values().plot(kind='barh', color='steelblue')
plt.title("Top 10 Feature Importances")
plt.xlabel("Importance")
plt.tight_layout()
plt.show()
```

### Random Forest for Regression

```python
from sklearn.ensemble import RandomForestRegressor

rf_reg = RandomForestRegressor(n_estimators=100, random_state=42)
rf_reg.fit(X_train, y_train)
y_pred = rf_reg.predict(X_test)
```

---

## 7.5 Hyperparameter Tuning

| Parameter | Description | Default | Tuning |
|-----------|-------------|---------|--------|
| `n_estimators` | Number of trees | 100 | More = better but slower (100-500) |
| `max_depth` | Max tree depth | None | Lower to prevent overfitting (5-20) |
| `min_samples_split` | Min samples to split node | 2 | Higher to prevent overfitting |
| `min_samples_leaf` | Min samples in leaf | 1 | Higher to prevent overfitting |
| `max_features` | Features per split | 'sqrt' | 'sqrt', 'log2', or float |
| `bootstrap` | Use bootstrap sampling | True | Usually keep True |

```python
from sklearn.model_selection import GridSearchCV

param_grid = {
    'n_estimators': [100, 200, 300],
    'max_depth': [5, 10, 15, None],
    'min_samples_split': [2, 5, 10],
    'max_features': ['sqrt', 'log2']
}

grid = GridSearchCV(
    RandomForestClassifier(random_state=42),
    param_grid, cv=5, scoring='accuracy', n_jobs=-1
)
grid.fit(X_train, y_train)

print(f"Best params: {grid.best_params_}")
print(f"Best CV score: {grid.best_score_:.4f}")
print(f"Test score: {grid.score(X_test, y_test):.4f}")
```

---

## 7.6 Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Very high accuracy — one of best algorithms | Slow for large datasets (many trees) |
| Handles overfitting well (ensemble) | Less interpretable than single tree |
| No feature scaling needed | Memory intensive |
| Built-in feature importance | Overkill for simple linear problems |
| Works for classification and regression | Can still overfit noisy data |
| Handles missing values and outliers | Doesn't extrapolate well |
| Parallelizable (n_jobs=-1) | |

### Decision Tree vs Random Forest

| | Decision Tree | Random Forest |
|-|--------------|---------------|
| Overfitting | High risk | Low risk |
| Accuracy | Lower | Higher |
| Speed (training) | Fast | Slower |
| Interpretability | High | Lower |
| Stability | Unstable | Stable |

### Real-World Applications
- Credit risk assessment in banking
- Patient diagnosis in healthcare
- Stock market prediction
- E-commerce recommendation
- Fraud detection

---

## 7.7 Practice & Assessment

### MCQs

**Q1.** Random Forest reduces overfitting compared to a single Decision Tree by:
- A) Using deeper trees
- B) Combining predictions from many diverse trees
- C) Using fewer features
- D) Removing outliers

**Answer:** B — Ensemble of diverse trees averages out individual errors.

---

**Q2.** In Random Forest, each tree sees:
- A) The full dataset with all features
- B) A bootstrap sample with random subset of features at each split
- C) Only 50% of the data
- D) Only numerical features

**Answer:** B — Bagging + feature randomness creates diverse trees.

---

**Q3.** What is the OOB (Out-of-Bag) score?
- A) Training accuracy
- B) Validation score using samples NOT in the bootstrap
- C) Test set accuracy
- D) Cross-validation score

**Answer:** B — Each tree is validated on the ~37% samples it didn't train on.

---

> **Next Topic:** [08 - Support Vector Machine (SVM)](08-svm.md)
