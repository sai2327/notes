# 08. Support Vector Machine (SVM)

## Table of Contents
- [8.1 Intuition](#81-intuition)
- [8.2 Mathematical Foundation](#82-mathematical-foundation)
- [8.3 Kernel Trick](#83-kernel-trick)
- [8.4 SVM Parameters (C and Gamma)](#84-svm-parameters-c-and-gamma)
- [8.5 Python Implementation](#85-python-implementation)
- [8.6 Advantages & Disadvantages](#86-advantages--disadvantages)
- [8.7 Practice & Assessment](#87-practice--assessment)

---

## 8.1 Intuition

### Definition
**Support Vector Machine (SVM)** finds the **optimal hyperplane** that separates classes with the **maximum margin**. The data points closest to the boundary are called **support vectors**.

> **Analogy:** Drawing a line between two groups of people with the widest possible gap.

### Visual Intuition

```
┌────────────────────────────────────────────────────────────────┐
│  MAXIMUM MARGIN CLASSIFIER                                      │
│                                                                │
│  x₂ ▲                                                          │
│     │   × ×           × = Class +1                             │
│     │ ×   × ×         ○ = Class -1                             │
│     │   ×   ╱ ← Margin                                        │
│     │  [×] ╱  ← Support Vector                                │
│     │     ╱                                                    │
│     │    ╱ ← Decision Boundary (Hyperplane)                    │
│     │   ╱                                                      │
│     │  ╱ [○] ← Support Vector                                 │
│     │ ╱   ○                                                    │
│     │╱  ○ ○ ○                                                  │
│     │ ○   ○                                                    │
│     └────────────────────────► x₁                              │
│                                                                │
│  Key insight: SVM MAXIMIZES the margin between classes         │
│  Only support vectors (closest points) define the boundary     │
└────────────────────────────────────────────────────────────────┘
```

### Key Terms

| Term | Definition |
|------|-----------|
| **Hyperplane** | Decision boundary (line in 2D, plane in 3D) |
| **Margin** | Distance between hyperplane and nearest data points |
| **Support Vectors** | Training points closest to the hyperplane |
| **Maximum Margin** | SVM goal — find hyperplane with largest margin |

---

## 8.2 Mathematical Foundation

### Linear SVM

The hyperplane equation:

$$w \cdot x + b = 0$$

Classification rule:

$$\hat{y} = \begin{cases} +1 & \text{if } w \cdot x + b \geq +1 \\ -1 & \text{if } w \cdot x + b \leq -1 \end{cases}$$

### Margin Width

$$\text{Margin} = \frac{2}{\|w\|}$$

**Goal:** Maximize margin = Minimize $\|w\|$

```
┌────────────────────────────────────────────────────────────┐
│  MARGIN GEOMETRY                                            │
│                                                            │
│          w·x + b = +1  (positive margin)                   │
│              ╱                                             │
│    ×  [×]  ╱                                               │
│      ×   ╱   ← margin = 2/||w||                           │
│         ╱                                                  │
│        ╱  w·x + b = 0  (hyperplane)                       │
│       ╱                                                    │
│      ╱   ← margin = 2/||w||                               │
│    ╱  [○]  ○                                              │
│   ╱     ○  ○                                              │
│          w·x + b = -1  (negative margin)                   │
│                                                            │
│  [×] and [○] = Support Vectors                            │
└────────────────────────────────────────────────────────────┘
```

### Soft Margin (C Parameter)

Real data is rarely perfectly separable. The **C parameter** controls the tradeoff between maximizing margin and allowing misclassifications.

```
┌────────────────────────────────────────────────────────────┐
│  EFFECT OF C PARAMETER                                      │
│                                                            │
│  Small C (e.g., 0.1)          Large C (e.g., 100)         │
│  ┌──────────────────┐         ┌──────────────────┐        │
│  │  × ×  ╱  ○       │         │  × ×╲ ○          │        │
│  │ ×  × ╱ ○  ○      │         │ ×  ×  ╲○  ○      │        │
│  │  × ╱○  ○         │         │  ×  ○  ╲○        │        │
│  └──────────────────┘         └──────────────────┘        │
│  WIDER margin                 NARROW margin               │
│  Allows misclassifications    Fewer misclassifications    │
│  Less overfitting             More overfitting            │
│  (Regularization)             (Tight fit)                 │
└────────────────────────────────────────────────────────────┘
```

---

## 8.3 Kernel Trick

### Problem: Non-Linearly Separable Data

```
┌────────────────────────────────────────────────────────────┐
│  LINEARLY SEPARABLE          NOT LINEARLY SEPARABLE        │
│                                                            │
│   × ×  │  ○ ○               ○ ○ ○ ○ ○ ○                  │
│  × ×   │   ○ ○             ○  × × × ×  ○                 │
│   × ×  │  ○ ○              ○  × × × ×  ○                 │
│  × ×   │   ○ ○             ○  × × × ×  ○                 │
│                              ○ ○ ○ ○ ○ ○                  │
│  ✓ Linear line works        ✗ No straight line works!     │
└────────────────────────────────────────────────────────────┘
```

### Solution: Map to Higher Dimensions

```
┌────────────────────────────────────────────────────────────────┐
│  KERNEL TRICK: Transform to higher dimension                    │
│                                                                │
│  2D (not separable):          3D (now separable!):             │
│                                                                │
│  y ▲   ○ × × ○               z ▲                              │
│    │  ○ × × ×  ○               │  ○     ○                     │
│    │  ○ × × ×  ○               │    ╱─────╲   ← hyperplane   │
│    │   ○ × ×  ○                │  × × × × ×                   │
│    └──────────► x              │   × × × ×                    │
│                                └──────────────► x              │
│                                                                │
│  φ(x₁, x₂) = (x₁, x₂, x₁² + x₂²)                          │
│  Now a flat plane can separate them!                           │
│                                                                │
│  The TRICK: We don't actually compute the transformation!      │
│  Kernel function K(x,y) = φ(x)·φ(y) computes dot product     │
│  in high-dim space WITHOUT explicitly transforming              │
└────────────────────────────────────────────────────────────────┘
```

### Common Kernels

| Kernel | Formula | Use When |
|--------|---------|----------|
| **Linear** | $K(x,y) = x \cdot y$ | Linearly separable, high-dimensional text data |
| **RBF (Gaussian)** | $K(x,y) = e^{-\gamma\|x-y\|^2}$ | Default, most versatile, non-linear data |
| **Polynomial** | $K(x,y) = (x \cdot y + c)^d$ | Interaction features needed |
| **Sigmoid** | $K(x,y) = \tanh(\gamma x \cdot y + c)$ | Similar to neural networks |

---

## 8.4 SVM Parameters (C and Gamma)

### Gamma (for RBF kernel)

Controls how far the influence of a single training example reaches.

```
┌────────────────────────────────────────────────────────────┐
│  EFFECT OF GAMMA                                            │
│                                                            │
│  Small Gamma (e.g., 0.001)    Large Gamma (e.g., 100)     │
│  ┌──────────────────┐         ┌──────────────────┐        │
│  │     ╱‾‾‾‾‾╲      │         │  ╭╮  ╭╮  ╭╮     │        │
│  │   ╱ × × ×  ╲     │         │ ╭╯×╰╮╭╯×╰╮╭╯    │        │
│  │  ╱  × × ×   ╲    │         │ ╰╮×╭╯╰╮×╭╯╰╮    │        │
│  │ ╱    × × ×    ╲   │         │  ╰╯  ╰╯  ╰╯     │        │
│  └──────────────────┘         └──────────────────┘        │
│  Smooth boundary              Tight boundary              │
│  Far reach → UNDERFITTING     Close reach → OVERFITTING   │
└────────────────────────────────────────────────────────────┘
```

### C and Gamma Summary

| | Small Value | Large Value |
|-|------------|-------------|
| **C** | Wide margin, more misclassifications (underfit) | Narrow margin, fewer misclassifications (overfit) |
| **Gamma** | Smooth boundary, far influence (underfit) | Complex boundary, close influence (overfit) |

---

## 8.5 Python Implementation

### Complete Example

```python
import numpy as np
import pandas as pd
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report

# Load data
data = load_breast_cancer()
X, y = data.data, data.target

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Scale (CRITICAL for SVM!)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train SVM with RBF kernel
svm = SVC(kernel='rbf', C=1.0, gamma='scale', random_state=42)
svm.fit(X_train_scaled, y_train)

# Evaluate
y_pred = svm.predict(X_test_scaled)
print(f"Accuracy: {accuracy_score(y_test, y_pred):.4f}")
print(f"\n{classification_report(y_test, y_pred, target_names=data.target_names)}")
print(f"Support Vectors per class: {svm.n_support_}")

# Compare kernels
kernels = ['linear', 'rbf', 'poly', 'sigmoid']
for kernel in kernels:
    model = SVC(kernel=kernel, random_state=42)
    model.fit(X_train_scaled, y_train)
    score = model.score(X_test_scaled, y_test)
    print(f"Kernel={kernel:8s}: Accuracy={score:.4f}")

# Hyperparameter tuning
param_grid = {
    'C': [0.1, 1, 10, 100],
    'gamma': ['scale', 'auto', 0.01, 0.001],
    'kernel': ['rbf']
}
grid = GridSearchCV(SVC(random_state=42), param_grid, cv=5, scoring='accuracy')
grid.fit(X_train_scaled, y_train)

print(f"\nBest params: {grid.best_params_}")
print(f"Best CV score: {grid.best_score_:.4f}")
print(f"Test score: {grid.score(X_test_scaled, y_test):.4f}")
```

### SVM with Probability Estimates

```python
# SVM doesn't output probabilities by default
svm_prob = SVC(kernel='rbf', probability=True, random_state=42)
svm_prob.fit(X_train_scaled, y_train)

proba = svm_prob.predict_proba(X_test_scaled[:5])
print("Probabilities:")
for i, p in enumerate(proba):
    print(f"  Sample {i}: Malignant={p[0]:.3f}, Benign={p[1]:.3f}")
```

---

## 8.6 Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Effective in high-dimensional spaces | Slow on large datasets (O(n²) to O(n³)) |
| Works well with clear margin of separation | Sensitive to feature scaling (must scale!) |
| Kernel trick handles non-linear data | Doesn't output probabilities directly |
| Memory efficient (uses only support vectors) | Hard to interpret (black box) |
| Robust to overfitting in high dimensions | Poor performance on noisy data with overlapping classes |
| | Choosing the right kernel can be difficult |

### When to Use SVM
- Text classification (high-dimensional, sparse)
- Image classification
- Bioinformatics (gene expression)
- Small to medium datasets with many features
- When margin of separation exists

---

## 8.7 Practice & Assessment

### MCQs

**Q1.** What are support vectors?
- A) All training data points
- B) The data points closest to the decision boundary
- C) Outliers in the dataset
- D) Feature vectors after PCA

**Answer:** B — Support vectors are the critical points that define the margin.

---

**Q2.** The kernel trick is used to:
- A) Speed up training
- B) Handle non-linearly separable data by mapping to higher dimensions
- C) Reduce features
- D) Handle missing values

**Answer:** B — Kernel implicitly maps data to higher-dimensional space.

---

**Q3.** Why is feature scaling critical for SVM?
- A) SVM can't handle numbers
- B) SVM uses distance-based computations; unscaled features distort margins
- C) It makes SVM faster
- D) It's optional

**Answer:** B — Features with larger ranges would dominate the margin calculation.

---

> **Next Topic:** [09 - Naive Bayes](09-naive-bayes.md)
