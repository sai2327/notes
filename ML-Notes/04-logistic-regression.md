# 04. Logistic Regression

## Table of Contents
- [4.1 Intuition](#41-intuition)
- [4.2 Mathematical Formula](#42-mathematical-formula)
- [4.3 Step-by-Step Working](#43-step-by-step-working)
- [4.4 Decision Boundary](#44-decision-boundary)
- [4.5 Cost Function](#45-cost-function)
- [4.6 Multi-Class Logistic Regression](#46-multi-class-logistic-regression)
- [4.7 Python Implementation](#47-python-implementation)
- [4.8 Advantages & Disadvantages](#48-advantages--disadvantages)
- [4.9 Practice & Assessment](#49-practice--assessment)

---

## 4.1 Intuition

### Definition
**Logistic Regression** is a **classification** algorithm (despite "regression" in its name) that predicts the **probability** of an instance belonging to a class using the **sigmoid function**.

### When to Use
- Binary classification: Spam / Not Spam, Disease / Healthy, Pass / Fail
- When you need probability output (not just class label)
- When relationship between features and log-odds is linear

### Why Not Use Linear Regression for Classification?

```
┌────────────────────────────────────────────────────────────────┐
│  LINEAR REGRESSION FOR CLASSIFICATION (BAD!)                    │
│                                                                │
│  y ▲   ·                                                       │
│  1 ├─── · · ·─────────── Actual class 1                       │
│    │       ╱ ← Linear prediction                               │
│    │     ╱                                                      │
│ 0.5├───╱───────────── Threshold                                │
│    │ ╱                                                          │
│  0 ├ · · ·──────────── Actual class 0                          │
│    │ ╱                                                          │
│ -0.3 ← Predictions go below 0! (Not probability)              │
│    └──────────────────────────► x                              │
│                                                                │
│  Problem: Linear regression predicts values < 0 or > 1!        │
│  We need output bounded between [0, 1] → Use SIGMOID           │
└────────────────────────────────────────────────────────────────┘
```

---

## 4.2 Mathematical Formula

### Step 1: Linear Combination (same as linear regression)

$$z = w_0 + w_1 x_1 + w_2 x_2 + \ldots + w_n x_n$$

### Step 2: Apply Sigmoid Function

$$\sigma(z) = \frac{1}{1 + e^{-z}}$$

### Sigmoid Function Properties

```
┌────────────────────────────────────────────────────────┐
│  SIGMOID FUNCTION: σ(z) = 1 / (1 + e^(-z))           │
│                                                        │
│  σ(z)                                                  │
│  1.0 ├─────────────────────────────── · · · ·         │
│      │                          · ·                    │
│      │                       ·                         │
│  0.5 ├─ ─ ─ ─ ─ ─ ─ ─ ─ · ─ ─ ─ ─ ─ ← Threshold    │
│      │                ·                                │
│      │             · ·                                 │
│  0.0 ├── · · · · ·────────────────────                │
│      └──────────┬──────────┬─────────► z              │
│              z < 0      z > 0                          │
│                                                        │
│  Properties:                                           │
│  • Output always between 0 and 1                       │
│  • σ(0) = 0.5                                          │
│  • z → +∞: σ(z) → 1                                   │
│  • z → -∞: σ(z) → 0                                   │
│  • S-shaped (sigmoid) curve                            │
└────────────────────────────────────────────────────────┘
```

### Final Prediction

$$P(y=1|x) = \sigma(w^T x) = \frac{1}{1 + e^{-(w_0 + w_1 x_1 + \ldots)}}$$

$$\hat{y} = \begin{cases} 1 & \text{if } P(y=1|x) \geq 0.5 \\ 0 & \text{if } P(y=1|x) < 0.5 \end{cases}$$

---

## 4.3 Step-by-Step Working

### Dry Run Example

```
Problem: Predict if a student passes (1) or fails (0) based on hours studied.

Data:
Hours (x):  [1,  2,  3,  4,  5,  6,  7,  8]
Pass  (y):  [0,  0,  0,  0,  1,  1,  1,  1]

After training, suppose we get: w₁ = 1.5, w₀ = -6

For a student who studied 5 hours:
  Step 1: z = w₀ + w₁ × x = -6 + 1.5 × 5 = 1.5
  Step 2: σ(1.5) = 1 / (1 + e^(-1.5))
                  = 1 / (1 + 0.2231)
                  = 1 / 1.2231
                  = 0.8176
  Step 3: 0.8176 ≥ 0.5 → Predict: PASS (class 1)
  Probability: 81.76% chance of passing

For a student who studied 3 hours:
  Step 1: z = -6 + 1.5 × 3 = -1.5
  Step 2: σ(-1.5) = 1 / (1 + e^(1.5))
                   = 1 / (1 + 4.4817)
                   = 1 / 5.4817
                   = 0.1824
  Step 3: 0.1824 < 0.5 → Predict: FAIL (class 0)
  Probability: 18.24% chance of passing

Summary Table:
┌───────┬────────┬──────────┬────────────┬────────────┐
│ Hours │   z    │  σ(z)    │ Prediction │  Actual    │
├───────┼────────┼──────────┼────────────┼────────────┤
│   1   │  -4.5  │  0.011   │   Fail     │   Fail ✓  │
│   2   │  -3.0  │  0.047   │   Fail     │   Fail ✓  │
│   3   │  -1.5  │  0.182   │   Fail     │   Fail ✓  │
│   4   │   0.0  │  0.500   │  50-50     │   Fail    │
│   5   │   1.5  │  0.818   │   Pass     │   Pass ✓  │
│   6   │   3.0  │  0.953   │   Pass     │   Pass ✓  │
│   7   │   4.5  │  0.989   │   Pass     │   Pass ✓  │
│   8   │   6.0  │  0.998   │   Pass     │   Pass ✓  │
└───────┴────────┴──────────┴────────────┴────────────┘
```

---

## 4.4 Decision Boundary

```
┌────────────────────────────────────────────────────────────┐
│  DECISION BOUNDARY (2 features)                             │
│                                                            │
│  x₂ ▲                                                      │
│     │  × × ×                                               │
│     │    × × ×      × = Class 1                            │
│     │  × × ×╲                                              │
│     │    ×    ╲     Decision                                │
│     │         ╲    Boundary                                 │
│     │          ╲   (w₀ + w₁x₁ + w₂x₂ = 0)                │
│     │    ○      ╲                                          │
│     │  ○ ○ ○     ╲  ○ = Class 0                            │
│     │    ○ ○ ○                                             │
│     │  ○ ○ ○                                               │
│     └──────────────────────► x₁                            │
│                                                            │
│  Points above line: w₀ + w₁x₁ + w₂x₂ > 0 → Class 1      │
│  Points below line: w₀ + w₁x₁ + w₂x₂ < 0 → Class 0      │
│  On the line:       w₀ + w₁x₁ + w₂x₂ = 0 → 50% either   │
└────────────────────────────────────────────────────────────┘
```

---

## 4.5 Cost Function

### Why Not Use MSE?

MSE with sigmoid creates a **non-convex** function with many local minima. Instead, we use **Log Loss (Binary Cross-Entropy)**:

$$J(w) = -\frac{1}{n} \sum_{i=1}^{n} \left[ y_i \log(\hat{y}_i) + (1-y_i) \log(1-\hat{y}_i) \right]$$

### Intuition

```
When actual y = 1:
  Cost = -log(ŷ)
  If ŷ → 1: Cost → 0  (correct prediction, low cost)
  If ŷ → 0: Cost → ∞  (wrong prediction, huge penalty)

When actual y = 0:
  Cost = -log(1 - ŷ)
  If ŷ → 0: Cost → 0  (correct prediction, low cost)
  If ŷ → 1: Cost → ∞  (wrong prediction, huge penalty)
```

---

## 4.6 Multi-Class Logistic Regression

### One-vs-Rest (OvR) Strategy

```
3 classes: Cat, Dog, Bird

Classifier 1: Cat vs (Dog + Bird)
Classifier 2: Dog vs (Cat + Bird)
Classifier 3: Bird vs (Cat + Dog)

For new input → run all 3 classifiers
Pick class with HIGHEST probability
```

### Softmax Regression (Multinomial)

$$P(y=k|x) = \frac{e^{z_k}}{\sum_{j=1}^{K} e^{z_j}}$$

```python
from sklearn.linear_model import LogisticRegression

# Multi-class (automatic with sklearn)
model = LogisticRegression(multi_class='multinomial', max_iter=200)
model.fit(X_train, y_train)  # y has 3+ classes
```

---

## 4.7 Python Implementation

### Complete Example: Breast Cancer Classification

```python
import numpy as np
import pandas as pd
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix

# Load dataset
data = load_breast_cancer()
X = pd.DataFrame(data.data, columns=data.feature_names)
y = data.target  # 0=malignant, 1=benign

print(f"Dataset shape: {X.shape}")
print(f"Classes: {data.target_names}")
print(f"Class distribution: {np.bincount(y)}")

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Scale features (important for Logistic Regression!)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train
model = LogisticRegression(max_iter=1000, random_state=42)
model.fit(X_train_scaled, y_train)

# Predict
y_pred = model.predict(X_test_scaled)
y_proba = model.predict_proba(X_test_scaled)  # Probabilities!

# Evaluate
print(f"\nAccuracy: {accuracy_score(y_test, y_pred):.4f}")
print(f"\nClassification Report:\n{classification_report(y_test, y_pred, target_names=data.target_names)}")
print(f"Confusion Matrix:\n{confusion_matrix(y_test, y_pred)}")

# Sample predictions with probabilities
print("\nSample Predictions:")
for i in range(5):
    print(f"  Prob: [{y_proba[i][0]:.3f}, {y_proba[i][1]:.3f}] → "
          f"Predicted: {data.target_names[y_pred[i]]}, "
          f"Actual: {data.target_names[y_test.iloc[i] if hasattr(y_test, 'iloc') else y_test[i]]}")
```

---

## 4.8 Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Outputs probabilities (not just class) | Assumes linear decision boundary |
| Simple, fast, interpretable | Cannot capture complex non-linear patterns |
| Works well for linearly separable data | Sensitive to outliers |
| Low risk of overfitting (with regularization) | Requires feature scaling |
| Good baseline for classification | Not suitable for very complex data |
| Feature importance from coefficients | Performance drops with many irrelevant features |

### Real-World Applications
- Credit scoring (approve/reject loan)
- Medical diagnosis (disease present/absent)
- Email spam filtering
- Customer churn prediction

---

## 4.9 Practice & Assessment

### MCQs

**Q1.** What function does Logistic Regression use to map output to [0, 1]?
- A) ReLU
- B) Sigmoid
- C) Tanh
- D) Softmax

**Answer:** B — Sigmoid squashes any value to the range [0, 1].

---

**Q2.** Logistic Regression is used for:
- A) Regression (continuous output)
- B) Classification (categorical output)
- C) Clustering
- D) Dimensionality reduction

**Answer:** B — Despite its name, it's a classification algorithm.

---

**Q3.** If σ(z) = 0.73, what class is predicted (threshold = 0.5)?
- A) Class 0
- B) Class 1
- C) Cannot determine
- D) Both classes

**Answer:** B — 0.73 ≥ 0.5, so the model predicts class 1.

---

### Coding Task

```python
# Predict if a customer will buy a product
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

# Features: [age, estimated_salary]
X_train = np.array([
    [19, 19000], [35, 20000], [26, 43000], [27, 57000],
    [19, 76000], [27, 58000], [27, 84000], [32, 150000],
    [25, 33000], [35, 65000], [26, 80000], [26, 52000],
    [20, 86000], [32, 18000], [18, 82000], [29, 80000],
    [47, 25000], [45, 26000], [46, 28000], [48, 29000]
])
y_train = np.array([0,0,0,0,0,0,1,1,0,0,1,0,1,0,1,1,1,1,1,1])

model = LogisticRegression()
model.fit(X_train, y_train)
print(f"Training accuracy: {model.score(X_train, y_train):.4f}")

new_customer = [[30, 60000]]
prob = model.predict_proba(new_customer)[0]
print(f"Purchase probability: {prob[1]:.2%}")
print(f"Prediction: {'Buy' if model.predict(new_customer)[0] else 'Not Buy'}")
```

---

> **Next Topic:** [05 - K-Nearest Neighbors (KNN)](05-knn.md)
