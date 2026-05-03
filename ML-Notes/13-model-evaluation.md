# 13. Model Evaluation

## Table of Contents
- [13.1 Why Model Evaluation?](#131-why-model-evaluation)
- [13.2 Classification Metrics](#132-classification-metrics)
- [13.3 Confusion Matrix (Visual)](#133-confusion-matrix-visual)
- [13.4 ROC Curve & AUC](#134-roc-curve--auc)
- [13.5 Regression Metrics](#135-regression-metrics)
- [13.6 Cross-Validation](#136-cross-validation)
- [13.7 Python Implementation](#137-python-implementation)
- [13.8 Practice & Assessment](#138-practice--assessment)

---

## 13.1 Why Model Evaluation?

```
┌────────────────────────────────────────────────────────────────┐
│  A model with 99% accuracy on cancer detection sounds great... │
│  But if 99% of patients DON'T have cancer, a model that       │
│  always says "No Cancer" gets 99% accuracy!                    │
│                                                                │
│  → Accuracy alone is NOT enough. We need multiple metrics.     │
└────────────────────────────────────────────────────────────────┘
```

---

## 13.2 Classification Metrics

### Core Metrics

| Metric | Formula | Meaning | When to Use |
|--------|---------|---------|-------------|
| **Accuracy** | $\frac{TP+TN}{TP+TN+FP+FN}$ | Overall correct predictions | Balanced classes only |
| **Precision** | $\frac{TP}{TP+FP}$ | Of predicted positive, how many correct? | When FP is costly (spam filter) |
| **Recall** (Sensitivity) | $\frac{TP}{TP+FN}$ | Of actual positive, how many found? | When FN is costly (disease detection) |
| **F1 Score** | $2 \times \frac{Precision \times Recall}{Precision + Recall}$ | Harmonic mean of P and R | Imbalanced datasets |
| **Specificity** | $\frac{TN}{TN+FP}$ | Of actual negative, how many correct? | When both classes matter |

### Understanding TP, TN, FP, FN

```
┌──────────────────────────────────────────────────────────────┐
│  PREDICTION OUTCOMES                                          │
│                                                              │
│  TP (True Positive):  Predicted cancer, HAS cancer      ✅   │
│  TN (True Negative):  Predicted healthy, IS healthy     ✅   │
│  FP (False Positive): Predicted cancer, IS healthy      ❌   │
│                       (Type I Error — False alarm)           │
│  FN (False Negative): Predicted healthy, HAS cancer     ❌   │
│                       (Type II Error — Missed detection)     │
│                                                              │
│  → FP = "Crying wolf"                                        │
│  → FN = "Missing the wolf"  ← Usually more dangerous!       │
└──────────────────────────────────────────────────────────────┘
```

---

## 13.3 Confusion Matrix (Visual)

```
┌────────────────────────────────────────────────────────────────┐
│  CONFUSION MATRIX                                              │
│                                                                │
│                    PREDICTED                                   │
│                 Positive  Negative                             │
│              ┌──────────┬──────────┐                          │
│   ACTUAL     │          │          │                          │
│   Positive   │  TP=45   │  FN=5    │ → Recall = 45/50 = 90% │
│              │          │          │                          │
│              ├──────────┼──────────┤                          │
│   ACTUAL     │          │          │                          │
│   Negative   │  FP=10   │  TN=40   │ → Specificity=40/50=80%│
│              │          │          │                          │
│              └──────────┴──────────┘                          │
│                   ↓          ↓                                │
│           Precision     Accuracy                              │
│           = 45/55       = 85/100                              │
│           = 81.8%       = 85%                                 │
│                                                                │
│  F1 = 2 × (0.818 × 0.90) / (0.818 + 0.90) = 0.857          │
└────────────────────────────────────────────────────────────────┘
```

### Precision vs Recall Tradeoff

```
┌────────────────────────────────────────────────────────────────┐
│  WHEN TO PRIORITIZE:                                           │
│                                                                │
│  HIGH PRECISION (minimize FP):                                 │
│  ├── Email spam filter (don't put real email in spam!)        │
│  ├── YouTube recommendations (don't show irrelevant videos)   │
│  └── Search engine results                                    │
│                                                                │
│  HIGH RECALL (minimize FN):                                    │
│  ├── Cancer detection (don't miss any cancer patient!)        │
│  ├── Fraud detection (catch ALL fraudulent transactions)      │
│  └── Airport security screening                               │
│                                                                │
│  ┌─────────────────────────────────────────┐                  │
│  │ Threshold ↑ → Precision ↑, Recall ↓    │                  │
│  │ Threshold ↓ → Precision ↓, Recall ↑    │                  │
│  └─────────────────────────────────────────┘                  │
└────────────────────────────────────────────────────────────────┘
```

---

## 13.4 ROC Curve & AUC

### ROC Curve

```
┌────────────────────────────────────────────────────────────────┐
│  ROC CURVE (Receiver Operating Characteristic)                 │
│                                                                │
│  TPR (Recall)                                                  │
│   1.0 ┤──────────────────────●                                 │
│       │                  ●                                     │
│       │              ●     ← Good Model (AUC=0.9)            │
│   0.5 ┤        ● /                                            │
│       │      / ╱                                               │
│       │    / ╱    ╱── Random (AUC=0.5)                        │
│       │  ●╱                                                    │
│   0.0 ┤●───────────────────────                                │
│       └──┬────┬────┬────┬────┤                                │
│         0.0  0.25 0.5  0.75 1.0                               │
│                FPR                                              │
│                                                                │
│  ● Perfect model:  AUC = 1.0 (top-left corner)               │
│  / Random model:   AUC = 0.5 (diagonal)                      │
│  ● Good model:     AUC = 0.8-0.9                              │
└────────────────────────────────────────────────────────────────┘
```

### AUC (Area Under the Curve)

| AUC Value | Interpretation |
|-----------|---------------|
| 1.0 | Perfect classifier |
| 0.9 - 1.0 | Excellent |
| 0.8 - 0.9 | Good |
| 0.7 - 0.8 | Fair |
| 0.5 - 0.7 | Poor |
| 0.5 | Random (useless) |
| < 0.5 | Worse than random (flip predictions) |

---

## 13.5 Regression Metrics

| Metric | Formula | Interpretation |
|--------|---------|---------------|
| **MAE** | $\frac{1}{n}\sum\|y_i - \hat{y}_i\|$ | Average absolute error (same unit as target) |
| **MSE** | $\frac{1}{n}\sum(y_i - \hat{y}_i)^2$ | Penalizes large errors more |
| **RMSE** | $\sqrt{MSE}$ | Same unit as target, penalizes large errors |
| **R²** | $1 - \frac{SS_{res}}{SS_{tot}}$ | % variance explained (0 to 1, higher = better) |

### R² Interpretation

```
┌──────────────────────────────────────────────────────────────┐
│  R² SCORE SCALE                                               │
│                                                              │
│  ◄─────────────────────────────────────────────────────────► │
│  0.0      0.3      0.5      0.7      0.85      1.0          │
│  Poor    Weak    Moderate   Good   Very Good  Perfect        │
│                                                              │
│  R² = 0.85 means model explains 85% of variance in target   │
│  Remaining 15% is unexplained (noise, missing features)     │
└──────────────────────────────────────────────────────────────┘
```

---

## 13.6 Cross-Validation

### K-Fold Cross-Validation

```
┌────────────────────────────────────────────────────────────────────┐
│  5-FOLD CROSS-VALIDATION                                           │
│                                                                    │
│  Fold 1: [TEST]  [Train] [Train] [Train] [Train] → Score 1       │
│  Fold 2: [Train] [TEST]  [Train] [Train] [Train] → Score 2       │
│  Fold 3: [Train] [Train] [TEST]  [Train] [Train] → Score 3       │
│  Fold 4: [Train] [Train] [Train] [TEST]  [Train] → Score 4       │
│  Fold 5: [Train] [Train] [Train] [Train] [TEST]  → Score 5       │
│                                                                    │
│  Final Score = Average(Score1, Score2, Score3, Score4, Score5)     │
│                                                                    │
│  ✓ Every data point gets to be in test set exactly once           │
│  ✓ More reliable than single train-test split                     │
│  ✓ Detects overfitting (high train, low CV score)                 │
└────────────────────────────────────────────────────────────────────┘
```

### Stratified K-Fold (For Imbalanced Classes)

```python
from sklearn.model_selection import StratifiedKFold, cross_val_score

skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
scores = cross_val_score(model, X, y, cv=skf, scoring='f1')
print(f"Stratified CV F1: {scores.mean():.4f} ± {scores.std():.4f}")
```

---

## 13.7 Python Implementation

### Complete Evaluation Example

```python
import numpy as np
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    confusion_matrix, classification_report, roc_curve, roc_auc_score
)
import matplotlib.pyplot as plt

# Load and split
data = load_breast_cancer()
X_train, X_test, y_train, y_test = train_test_split(
    data.data, data.target, test_size=0.2, random_state=42, stratify=data.target
)

# Train
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)
y_pred = model.predict(X_test)
y_proba = model.predict_proba(X_test)[:, 1]

# --- ALL METRICS ---
print("=" * 50)
print("CLASSIFICATION METRICS")
print("=" * 50)
print(f"Accuracy:  {accuracy_score(y_test, y_pred):.4f}")
print(f"Precision: {precision_score(y_test, y_pred):.4f}")
print(f"Recall:    {recall_score(y_test, y_pred):.4f}")
print(f"F1 Score:  {f1_score(y_test, y_pred):.4f}")
print(f"AUC-ROC:   {roc_auc_score(y_test, y_proba):.4f}")

# Classification Report
print(f"\n{classification_report(y_test, y_pred, target_names=data.target_names)}")

# Confusion Matrix
cm = confusion_matrix(y_test, y_pred)
print("Confusion Matrix:")
print(cm)
print(f"  TP={cm[1][1]}, FP={cm[0][1]}, FN={cm[1][0]}, TN={cm[0][0]}")

# ROC Curve Plot
fpr, tpr, thresholds = roc_curve(y_test, y_proba)
plt.figure(figsize=(8, 6))
plt.plot(fpr, tpr, 'b-', label=f'Model (AUC = {roc_auc_score(y_test, y_proba):.3f})')
plt.plot([0, 1], [0, 1], 'r--', label='Random (AUC = 0.5)')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate (Recall)')
plt.title('ROC Curve')
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()

# Cross-Validation
cv_scores = cross_val_score(model, data.data, data.target, cv=5, scoring='f1')
print(f"\n5-Fold CV F1: {cv_scores.mean():.4f} ± {cv_scores.std():.4f}")
print(f"Individual folds: {[f'{s:.4f}' for s in cv_scores]}")
```

### Choosing the Right Metric

```
┌────────────────────────────────────────────────────────────────┐
│  METRIC DECISION GUIDE                                         │
│                                                                │
│  Is it classification or regression?                           │
│  ├── Regression → MAE, RMSE, R²                               │
│  │                                                             │
│  └── Classification                                            │
│      ├── Balanced classes? → Accuracy is fine                  │
│      │                                                         │
│      └── Imbalanced classes?                                   │
│          ├── Is FP costly? → Precision                         │
│          ├── Is FN costly? → Recall                            │
│          ├── Both matter? → F1 Score                           │
│          └── Need probability ranking? → AUC-ROC              │
└────────────────────────────────────────────────────────────────┘
```

---

## 13.8 Practice & Assessment

### MCQs

**Q1.** For cancer detection, which metric matters MOST?
- A) Accuracy
- B) Precision
- C) Recall
- D) Specificity

**Answer:** C — Missing a cancer patient (FN) is far more dangerous than a false alarm (FP).

---

**Q2.** If your model has 99% accuracy on imbalanced data (99% negative), the model likely:
- A) Is very good
- B) Is predicting all negative (useless)
- C) Has perfect recall
- D) Is overfitting

**Answer:** B — Always predicting majority class gives high accuracy but zero recall.

---

**Q3.** AUC = 0.5 means:
- A) Perfect model
- B) Model is no better than random guessing
- C) Model is overfitting
- D) Model has high precision

**Answer:** B — AUC 0.5 = diagonal ROC = random guessing.

---

> **Next Topic:** [14 - Model Optimization](14-model-optimization.md)
