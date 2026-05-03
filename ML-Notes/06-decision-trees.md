# 06. Decision Trees

## Table of Contents
- [6.1 Intuition](#61-intuition)
- [6.2 How Decision Trees Work](#62-how-decision-trees-work)
- [6.3 Splitting Criteria (Math)](#63-splitting-criteria-math)
- [6.4 Step-by-Step Tree Building](#64-step-by-step-tree-building)
- [6.5 Pruning (Preventing Overfitting)](#65-pruning-preventing-overfitting)
- [6.6 Python Implementation](#66-python-implementation)
- [6.7 Decision Tree for Regression](#67-decision-tree-for-regression)
- [6.8 Advantages & Disadvantages](#68-advantages--disadvantages)
- [6.9 Practice & Assessment](#69-practice--assessment)

---

## 6.1 Intuition

### Definition
A **Decision Tree** is a flowchart-like structure where each internal node represents a **test on a feature**, each branch represents an **outcome**, and each leaf node represents a **class label** or prediction.

> **Analogy:** Like playing 20 Questions — you ask yes/no questions to narrow down the answer.

### Visual Intuition

```
┌────────────────────────────────────────────────────────────────┐
│  "Should I play tennis today?"                                  │
│                                                                │
│                    [Outlook?]                                   │
│                   ╱    │     ╲                                  │
│               Sunny  Overcast  Rain                            │
│                ╱        │        ╲                              │
│         [Humidity?]    YES    [Windy?]                          │
│           ╱    ╲                ╱    ╲                          │
│        High   Normal       True    False                       │
│          │      │            │        │                         │
│         NO     YES          NO      YES                        │
│                                                                │
│  Path example: Outlook=Sunny → Humidity=High → NO              │
└────────────────────────────────────────────────────────────────┘
```

---

## 6.2 How Decision Trees Work

### Key Concepts

| Term | Definition |
|------|-----------|
| **Root Node** | Top node — first split on best feature |
| **Internal Node** | Intermediate decision point |
| **Leaf Node** | Final prediction (class or value) |
| **Branch** | Connection representing decision outcome |
| **Depth** | Number of levels from root to deepest leaf |
| **Splitting** | Dividing data based on a feature condition |

### The Algorithm (ID3 / CART)

```
1. Start with entire dataset at root
2. Find the BEST feature to split on (using Gini/Entropy)
3. Split data into subsets based on feature values
4. Repeat recursively for each subset
5. Stop when:
   - All samples in node belong to same class (pure)
   - Maximum depth reached
   - Minimum samples threshold reached
   - No further improvement possible
```

---

## 6.3 Splitting Criteria (Math)

### Gini Impurity (used by CART — sklearn default)

$$Gini(S) = 1 - \sum_{i=1}^{C} p_i^2$$

Where $p_i$ is the proportion of class $i$ in the set.

```
Example: 10 samples — 6 Yes, 4 No
  p(Yes) = 6/10 = 0.6
  p(No)  = 4/10 = 0.4
  
  Gini = 1 - (0.6² + 0.4²) = 1 - (0.36 + 0.16) = 0.48

Pure node (all same class): Gini = 0 (perfect)
50/50 split:                Gini = 0.5 (worst)
```

### Entropy (used by ID3 / C4.5)

$$Entropy(S) = -\sum_{i=1}^{C} p_i \log_2(p_i)$$

```
Example: 10 samples — 6 Yes, 4 No
  Entropy = -(0.6 × log₂(0.6) + 0.4 × log₂(0.4))
          = -(0.6 × (-0.737) + 0.4 × (-1.322))
          = -(- 0.442 - 0.529)
          = 0.971

Pure node: Entropy = 0
50/50:     Entropy = 1 (maximum disorder)
```

### Information Gain

$$IG(S, A) = Entropy(S) - \sum_{v \in Values(A)} \frac{|S_v|}{|S|} \times Entropy(S_v)$$

The feature with the **highest Information Gain** is chosen for splitting.

```
┌──────────────────────────────────────────────────────┐
│  GINI vs ENTROPY COMPARISON                          │
│                                                      │
│  Value                                               │
│  1.0 ┤                                               │
│      │  ╱──── Entropy                                │
│      │╱                                              │
│  0.5 ├─╱───── Gini                                   │
│      │╱                                              │
│      │                                               │
│  0.0 ├───────────────────────                        │
│      0    0.25   0.5   0.75   1.0                    │
│              p(class=1)                              │
│                                                      │
│  Both are 0 when pure, max at 50/50 split            │
│  Gini is slightly faster to compute                  │
│  Results are usually very similar                    │
└──────────────────────────────────────────────────────┘
```

---

## 6.4 Step-by-Step Tree Building

### Dry Run: "Play Tennis" Dataset

```
Data:
┌──────┬──────────┬──────────┬───────┬───────┬──────┐
│  #   │ Outlook  │ Temp     │ Humid │ Windy │ Play │
├──────┼──────────┼──────────┼───────┼───────┼──────┤
│  1   │ Sunny    │ Hot      │ High  │ False │  No  │
│  2   │ Sunny    │ Hot      │ High  │ True  │  No  │
│  3   │ Overcast │ Hot      │ High  │ False │  Yes │
│  4   │ Rain     │ Mild     │ High  │ False │  Yes │
│  5   │ Rain     │ Cool     │ Normal│ False │  Yes │
│  6   │ Rain     │ Cool     │ Normal│ True  │  No  │
│  7   │ Overcast │ Cool     │ Normal│ True  │  Yes │
│  8   │ Sunny    │ Mild     │ High  │ False │  No  │
│  9   │ Sunny    │ Cool     │ Normal│ False │  Yes │
│  10  │ Rain     │ Mild     │ Normal│ False │  Yes │
│  11  │ Sunny    │ Mild     │ Normal│ True  │  Yes │
│  12  │ Overcast │ Mild     │ High  │ True  │  Yes │
│  13  │ Overcast │ Hot      │ Normal│ False │  Yes │
│  14  │ Rain     │ Mild     │ High  │ True  │  No  │
└──────┴──────────┴──────────┴───────┴───────┴──────┘

Total: 14 samples → 9 Yes, 5 No

Step 1: Calculate base entropy
  Entropy(S) = -(9/14)log₂(9/14) - (5/14)log₂(5/14) = 0.940

Step 2: Calculate Info Gain for each feature

  OUTLOOK: Sunny(5), Overcast(4), Rain(5)
    Sunny:    2 Yes, 3 No → Entropy = 0.971
    Overcast: 4 Yes, 0 No → Entropy = 0.000 (pure!)
    Rain:     3 Yes, 2 No → Entropy = 0.971
    IG(Outlook) = 0.940 - (5/14×0.971 + 4/14×0.000 + 5/14×0.971)
                = 0.940 - 0.694 = 0.246

  WINDY: False(8), True(6)
    False: 6 Yes, 2 No → Entropy = 0.811
    True:  3 Yes, 3 No → Entropy = 1.000
    IG(Windy) = 0.940 - (8/14×0.811 + 6/14×1.000)
              = 0.940 - 0.892 = 0.048

Step 3: OUTLOOK has highest IG (0.246) → Split on Outlook first!

Result:
                 [Outlook]
                ╱    │     ╲
           Sunny  Overcast  Rain
          2Y,3N    4Y,0N    3Y,2N
                    │
                   YES      ← Pure (no more splits needed)

Repeat for Sunny branch and Rain branch...
```

---

## 6.5 Pruning (Preventing Overfitting)

### Pre-Pruning (Early Stopping)

Set constraints **before** building the tree:

```python
from sklearn.tree import DecisionTreeClassifier

model = DecisionTreeClassifier(
    max_depth=5,              # Maximum tree depth
    min_samples_split=10,     # Min samples to split a node
    min_samples_leaf=5,       # Min samples in a leaf
    max_features='sqrt',      # Max features considered per split
    max_leaf_nodes=20         # Max number of leaf nodes
)
```

### Post-Pruning (Cost Complexity Pruning)

Build a full tree, then prune branches that don't improve performance:

```python
# Cost complexity pruning (ccp_alpha)
model = DecisionTreeClassifier(ccp_alpha=0.01)

# Higher alpha → more pruning → simpler tree
# Lower alpha → less pruning → more complex tree
```

```
┌────────────────────────────────────────────────────────────┐
│  BEFORE PRUNING                   AFTER PRUNING            │
│                                                            │
│       [A]                             [A]                  │
│      ╱   ╲                           ╱   ╲                 │
│    [B]   [C]                       [B]   Leaf              │
│   ╱  ╲  ╱  ╲                     ╱  ╲                      │
│  L1  L2 L3  L4                  L1  L2                     │
│  ╱╲  ╱╲                                                    │
│ L5 L6 L7 L8                    Simpler tree = less         │
│                                 overfitting                │
│ Complex tree =                                             │
│ overfitting risk                                           │
└────────────────────────────────────────────────────────────┘
```

---

## 6.6 Python Implementation

### Complete Example

```python
import numpy as np
import pandas as pd
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier, export_text, plot_tree
from sklearn.metrics import accuracy_score, classification_report
import matplotlib.pyplot as plt

# Load data
iris = load_iris()
X, y = iris.data, iris.target

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Train (no scaling needed for Decision Trees!)
model = DecisionTreeClassifier(
    criterion='gini',     # or 'entropy'
    max_depth=4,
    min_samples_split=5,
    random_state=42
)
model.fit(X_train, y_train)

# Predict & Evaluate
y_pred = model.predict(X_test)
print(f"Accuracy: {accuracy_score(y_test, y_pred):.4f}")
print(f"\n{classification_report(y_test, y_pred, target_names=iris.target_names)}")

# Print text representation
print("\nTree Structure:")
print(export_text(model, feature_names=list(iris.feature_names)))

# Visualize tree
plt.figure(figsize=(20, 10))
plot_tree(model, feature_names=iris.feature_names,
          class_names=iris.target_names, filled=True, rounded=True)
plt.title("Decision Tree - Iris Classification")
plt.tight_layout()
plt.show()

# Feature importance
importance = pd.Series(model.feature_importances_, index=iris.feature_names)
importance.sort_values().plot(kind='barh')
plt.title("Feature Importance")
plt.show()
```

---

## 6.7 Decision Tree for Regression

```python
from sklearn.tree import DecisionTreeRegressor

# Instead of majority vote → average of leaf values
reg_tree = DecisionTreeRegressor(max_depth=4)
reg_tree.fit(X_train, y_train)
y_pred = reg_tree.predict(X_test)
```

```
Regression Tree splits data to minimize MSE within each leaf:

         [Age ≤ 30?]
         ╱          ╲
       Yes            No
  [Salary≤40K?]    [Salary≤80K?]
    ╱      ╲         ╱       ╲
 $25K     $35K     $60K     $95K     ← Leaf = average price
```

---

## 6.8 Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Easy to understand and visualize | Prone to overfitting (without pruning) |
| No feature scaling needed | Unstable — small data changes → different tree |
| Handles both numerical and categorical | Biased toward features with more levels |
| Captures non-linear relationships | Cannot extrapolate beyond training range |
| Feature importance built-in | Greedy algorithm — may not find global optimum |
| Fast prediction (O(log n)) | Performs poorly with highly linear data |

### Real-World Applications
- Medical diagnosis (symptom-based decision making)
- Customer churn prediction
- Loan approval systems
- Fraud detection
- Quality control in manufacturing

---

## 6.9 Practice & Assessment

### MCQs

**Q1.** Gini impurity of a pure node is:
- A) 0.5
- B) 1.0
- C) 0.0
- D) Infinity

**Answer:** C — A pure node has all samples of one class, so Gini = 0.

---

**Q2.** Decision Trees do NOT require:
- A) Labeled data
- B) Feature scaling
- C) A target variable
- D) Features

**Answer:** B — Decision Trees split on thresholds and don't depend on feature magnitude.

---

**Q3.** Pruning a decision tree helps prevent:
- A) Underfitting
- B) Overfitting
- C) Data leakage
- D) Slow training

**Answer:** B — Pruning simplifies the tree, reducing overfitting.

---

> **Next Topic:** [07 - Random Forest](07-random-forest.md)
