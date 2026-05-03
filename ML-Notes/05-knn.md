# 05. K-Nearest Neighbors (KNN)

## Table of Contents
- [5.1 Intuition](#51-intuition)
- [5.2 How KNN Works (Step by Step)](#52-how-knn-works-step-by-step)
- [5.3 Distance Metrics](#53-distance-metrics)
- [5.4 Choosing K](#54-choosing-k)
- [5.5 Python Implementation](#55-python-implementation)
- [5.6 KNN for Regression](#56-knn-for-regression)
- [5.7 Advantages & Disadvantages](#57-advantages--disadvantages)
- [5.8 Practice & Assessment](#58-practice--assessment)

---

## 5.1 Intuition

### Definition
**K-Nearest Neighbors (KNN)** classifies a new data point based on the **majority class of its K closest neighbors** in the feature space.

> **Analogy:** "Tell me who your neighbors are, and I'll tell you who you are."

### Key Properties
- **Lazy learner** — no training phase; stores all training data and computes at prediction time
- **Instance-based** — makes decisions based on stored instances
- **Non-parametric** — makes no assumptions about data distribution

### Visual Intuition

```
┌───────────────────────────────────────────────────────────────┐
│  KNN CLASSIFICATION (K=3)                                      │
│                                                               │
│  x₂ ▲                                                         │
│     │     ▲ ▲              ▲ = Class A (triangle)             │
│     │   ▲                  ● = Class B (circle)               │
│     │     ▲  ╭─────╮      ? = New point to classify           │
│     │        │  ?  │                                          │
│     │    ●   │     │      3 nearest neighbors:                │
│     │     ●  ╰─────╯       - 2 circles (●)                   │
│     │        ●              - 1 triangle (▲)                  │
│     │  ●         ●                                            │
│     │      ●                Majority vote → Class B (●)       │
│     └──────────────────────► x₁                               │
└───────────────────────────────────────────────────────────────┘
```

---

## 5.2 How KNN Works (Step by Step)

### Algorithm

```
1. Choose the value of K (number of neighbors)
2. For a new data point:
   a. Calculate distance from new point to ALL training points
   b. Sort distances in ascending order
   c. Pick the K closest neighbors
   d. Count the class of each neighbor (majority vote)
   e. Assign the majority class to the new point
```

### Dry Run Example

```
Training Data:
┌───────┬────┬────┬───────┐
│ Point │ x₁ │ x₂ │ Class │
├───────┼────┼────┼───────┤
│  A    │  1 │  1 │  Red  │
│  B    │  2 │  1 │  Red  │
│  C    │  3 │  3 │  Blue │
│  D    │  6 │  5 │  Blue │
│  E    │  7 │  8 │  Blue │
└───────┴────┴────┴───────┘

New point: P = (3, 2), K = 3

Step 1: Calculate Euclidean distances from P(3,2) to all points
  d(P, A) = √((3-1)² + (2-1)²) = √(4+1) = √5 = 2.24
  d(P, B) = √((3-2)² + (2-1)²) = √(1+1) = √2 = 1.41  ← closest
  d(P, C) = √((3-3)² + (2-3)²) = √(0+1) = √1 = 1.00  ← closest
  d(P, D) = √((3-6)² + (2-5)²) = √(9+9) = √18 = 4.24
  d(P, E) = √((3-7)² + (2-8)²) = √(16+36) = √52 = 7.21

Step 2: Sort by distance
  C (1.00) → B (1.41) → A (2.24) → D (4.24) → E (7.21)

Step 3: Pick K=3 nearest
  C (Blue), B (Red), A (Red)

Step 4: Majority vote
  Red: 2 votes  ← Winner!
  Blue: 1 vote

Step 5: Predict P → RED
```

---

## 5.3 Distance Metrics

### Euclidean Distance (Most Common)

$$d(p, q) = \sqrt{\sum_{i=1}^{n} (p_i - q_i)^2}$$

### Manhattan Distance

$$d(p, q) = \sum_{i=1}^{n} |p_i - q_i|$$

### Minkowski Distance (Generalization)

$$d(p, q) = \left(\sum_{i=1}^{n} |p_i - q_i|^p\right)^{1/p}$$

When $p=2$: Euclidean. When $p=1$: Manhattan.

### Comparison

```
┌────────────────────────────────────────────────────────────┐
│  DISTANCE METRICS COMPARISON                                │
│                                                            │
│  Point A (1,1) to Point B (4,5):                           │
│                                                            │
│        B(4,5)                                              │
│       ╱│                                                   │
│     ╱  │ 4 (vertical)    Euclidean: √(3²+4²) = 5          │
│   ╱    │                  (straight line)                   │
│  A─────┘                                                   │
│    3 (horizontal)        Manhattan: 3 + 4 = 7              │
│                           (city block distance)             │
└────────────────────────────────────────────────────────────┘
```

| Distance | Use When | Properties |
|----------|----------|-----------|
| Euclidean | Default, continuous features | Straight-line distance |
| Manhattan | Grid-like data, high dimensions | Sum of absolute differences |
| Cosine | Text data, sparse vectors | Measures angle, not magnitude |

> ⚠️ **Important:** Always **scale features** before KNN! Otherwise, features with larger ranges dominate the distance.

---

## 5.4 Choosing K

```
┌────────────────────────────────────────────────────────────┐
│  EFFECT OF K VALUE                                          │
│                                                            │
│  K=1 (too small)      K=optimal         K=n (too large)   │
│                                                            │
│  ╭──╮  ╭──╮          ╭──────────╮      ╭──────────────╮   │
│  │× │  │× │          │ ×  ×  ×  │      │              │   │
│  │ ×│  │  │          │   ×  ×   │      │  ALL ONE     │   │
│  ╰──╯  │○ │          │ ○  ○     │      │  CLASS       │   │
│  ╭──╮  ╰──╯          │   ○  ○   │      │              │   │
│  │○ │               ╰──────────╯      ╰──────────────╯   │
│  ╰──╯                                                     │
│  Complex boundary     Smooth boundary   Too smooth         │
│  OVERFITTING          GOOD FIT          UNDERFITTING       │
│  High variance        Balanced          High bias          │
└────────────────────────────────────────────────────────────┘
```

### Rules for Choosing K
1. Start with K = √n (where n = number of training samples)
2. Always use **odd K** for binary classification (avoid ties)
3. Use **cross-validation** to find optimal K
4. Smaller K → complex boundary (overfitting risk)
5. Larger K → simpler boundary (underfitting risk)

### Finding Optimal K

```python
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import cross_val_score
import matplotlib.pyplot as plt

k_range = range(1, 31)
k_scores = []

for k in k_range:
    knn = KNeighborsClassifier(n_neighbors=k)
    scores = cross_val_score(knn, X_train_scaled, y_train, cv=10, scoring='accuracy')
    k_scores.append(scores.mean())

# Plot
plt.figure(figsize=(10, 5))
plt.plot(k_range, k_scores, 'b-o')
plt.xlabel('K value')
plt.ylabel('Cross-Validation Accuracy')
plt.title('Finding Optimal K')
plt.grid(True)
plt.show()

best_k = k_range[k_scores.index(max(k_scores))]
print(f"Best K: {best_k} with accuracy: {max(k_scores):.4f}")
```

---

## 5.5 Python Implementation

### Complete Example: Iris Classification

```python
import numpy as np
import pandas as pd
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix

# Load
iris = load_iris()
X, y = iris.data, iris.target

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Scale (CRITICAL for KNN!)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train
knn = KNeighborsClassifier(n_neighbors=5, metric='euclidean')
knn.fit(X_train_scaled, y_train)

# Predict
y_pred = knn.predict(X_test_scaled)

# Evaluate
print(f"Accuracy: {accuracy_score(y_test, y_pred):.4f}")
print(f"\n{classification_report(y_test, y_pred, target_names=iris.target_names)}")

# Predict new flower
new_flower = scaler.transform([[5.1, 3.5, 1.4, 0.2]])
prediction = knn.predict(new_flower)
proba = knn.predict_proba(new_flower)
print(f"\nNew flower prediction: {iris.target_names[prediction[0]]}")
print(f"Probabilities: {dict(zip(iris.target_names, proba[0].round(3)))}")
```

---

## 5.6 KNN for Regression

KNN can also predict **continuous values** by averaging the target values of K nearest neighbors.

```python
from sklearn.neighbors import KNeighborsRegressor

# Predict house price
X = np.array([[1500, 3], [2000, 4], [1200, 2], [1800, 3], [2500, 5]])  # area, bedrooms
y = np.array([300000, 450000, 200000, 350000, 550000])  # prices

knn_reg = KNeighborsRegressor(n_neighbors=3)
knn_reg.fit(X, y)

new_house = [[1600, 3]]
predicted_price = knn_reg.predict(new_house)
print(f"Predicted price: ${predicted_price[0]:,.0f}")
# Average of 3 nearest house prices
```

---

## 5.7 Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Simple to understand and implement | Slow prediction (computes all distances) |
| No training phase (lazy learner) | High memory usage (stores all data) |
| Works for multi-class naturally | Sensitive to irrelevant features |
| No assumptions about data distribution | Requires feature scaling |
| Good for small datasets | Poor on high-dimensional data (curse of dimensionality) |
| Can handle non-linear boundaries | Sensitive to imbalanced classes |

### Real-World Applications
- Recommendation systems
- Handwriting recognition
- Image classification
- Medical diagnosis
- Credit scoring

---

## 5.8 Practice & Assessment

### MCQs

**Q1.** KNN is called a "lazy learner" because:
- A) It's slow
- B) It doesn't learn during training — it memorizes data
- C) It's inaccurate
- D) It uses lazy evaluation

**Answer:** B — KNN stores all training data and defers computation to prediction time.

---

**Q2.** If K = 1, KNN tends to:
- A) Underfit
- B) Overfit
- C) Generalize well
- D) Not work at all

**Answer:** B — K=1 creates very complex boundaries that memorize noise.

---

**Q3.** Why is feature scaling critical for KNN?
- A) Makes training faster
- B) Prevents features with larger ranges from dominating distance
- C) Improves memory usage
- D) Required by the algorithm's code

**Answer:** B — Features like Salary (10K-100K) would dominate Age (18-65) without scaling.

---

> **Next Topic:** [06 - Decision Trees](06-decision-trees.md)
