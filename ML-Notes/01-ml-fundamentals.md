# 01. Machine Learning Fundamentals

## Table of Contents
- [1.1 What is Machine Learning?](#11-what-is-machine-learning)
- [1.2 Types of Machine Learning](#12-types-of-machine-learning)
- [1.3 ML Workflow Pipeline](#13-ml-workflow-pipeline)
- [1.4 Training, Testing, Validation](#14-training-testing-validation)
- [1.5 Bias vs Variance](#15-bias-vs-variance)
- [1.6 Overfitting vs Underfitting](#16-overfitting-vs-underfitting)
- [1.7 Key Terminology](#17-key-terminology)
- [1.8 Python ML Ecosystem](#18-python-ml-ecosystem)
- [1.9 Practice & Assessment](#19-practice--assessment)

---

## 1.1 What is Machine Learning?

### Definition
**Machine Learning (ML)** is a branch of Artificial Intelligence (AI) where computers learn patterns from data and make decisions or predictions **without being explicitly programmed** for each scenario.

### Traditional Programming vs Machine Learning

```
┌────────────────────────────────────────────────────────────────┐
│  TRADITIONAL PROGRAMMING                                        │
│                                                                │
│   Input Data  ─────┐                                           │
│                    ├──► [ Program / Rules ] ──► Output          │
│   Rules       ─────┘                                           │
│                                                                │
│  Example: if temperature > 30: print("Hot")                    │
├────────────────────────────────────────────────────────────────┤
│  MACHINE LEARNING                                               │
│                                                                │
│   Input Data  ─────┐                                           │
│                    ├──► [ ML Algorithm ] ──► Rules / Model      │
│   Output Data ─────┘                                           │
│                                                                │
│  Example: Model LEARNS what "Hot" means from thousands of      │
│           temperature → label pairs                             │
└────────────────────────────────────────────────────────────────┘
```

### Real-World Applications

| Domain | Application | ML Type |
|--------|-------------|---------|
| Email | Spam detection | Classification |
| Netflix | Movie recommendation | Recommendation |
| Banking | Fraud detection | Anomaly detection |
| Healthcare | Disease prediction | Classification |
| Tesla | Self-driving cars | Reinforcement Learning |
| Google | Search ranking | Ranking algorithms |
| Amazon | Price optimization | Regression |
| Siri/Alexa | Voice recognition | Deep Learning |

---

## 1.2 Types of Machine Learning

### Overview Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    MACHINE LEARNING                              │
│                         │                                        │
│          ┌──────────────┼──────────────┐                        │
│          │              │              │                        │
│   ┌──────▼──────┐ ┌────▼─────┐ ┌─────▼──────────┐            │
│   │ SUPERVISED  │ │UNSUPERV. │ │ REINFORCEMENT   │            │
│   │ LEARNING    │ │ LEARNING │ │ LEARNING        │            │
│   └──────┬──────┘ └────┬─────┘ └─────┬──────────┘            │
│          │              │              │                        │
│     ┌────┴────┐    ┌───┴────┐    Agent learns by               │
│     │         │    │        │    trial & error                  │
│  Classif. Regress. Cluster. Dim.Red.  with rewards              │
│     │         │    │        │                                    │
│  Spam/Not  Price  Customer  PCA     Game AI, Robotics           │
│  Disease   Stock  Segments  t-SNE                               │
│  Fraud     House  Patterns                                      │
└─────────────────────────────────────────────────────────────────┘
```

### 1. Supervised Learning

**Definition:** The algorithm learns from **labeled data** — input-output pairs where the correct answer is provided during training.

```
Training Data (Labeled):
┌──────────────────────────────────────────┐
│  Features (X)         │  Label (y)       │
├───────────────────────┼──────────────────┤
│  Area=1500, Rooms=3   │  Price=$300,000  │  ← Regression
│  Area=2000, Rooms=4   │  Price=$450,000  │
│  Email has "free$$"   │  Spam            │  ← Classification
│  Email has "meeting"  │  Not Spam        │
└──────────────────────────────────────────┘
```

**Two Types:**

| Type | Output | Example | Algorithms |
|------|--------|---------|-----------|
| **Classification** | Discrete category | Spam / Not Spam | Logistic Regression, KNN, SVM, Decision Tree, Random Forest, Naive Bayes |
| **Regression** | Continuous number | House price = $350K | Linear Regression, Polynomial Regression, Ridge, Lasso |

### 2. Unsupervised Learning

**Definition:** The algorithm finds hidden patterns in **unlabeled data** — no correct answer is provided.

```
Unlabeled Data:
┌────────────────────────────┐
│  Customer  Age   Spending  │
│  A         25    High      │     No labels!
│  B         45    Low       │     Algorithm finds
│  C         23    High      │     patterns itself
│  D         50    Medium    │
└────────────────────────────┘
         ↓ ML Algorithm ↓
Cluster 1: Young + High spenders (A, C)
Cluster 2: Older + Low spenders (B, D)
```

| Type | Purpose | Algorithms |
|------|---------|-----------|
| **Clustering** | Group similar data points | K-Means, DBSCAN, Hierarchical |
| **Dimensionality Reduction** | Reduce features | PCA, t-SNE, LDA |
| **Association** | Find rules/patterns | Apriori, FP-Growth |

### 3. Reinforcement Learning

**Definition:** An **agent** learns by interacting with an **environment**, receiving **rewards** for good actions and **penalties** for bad actions.

```
┌────────────────────────────────────────────┐
│  REINFORCEMENT LEARNING LOOP               │
│                                            │
│     ┌───────┐   Action    ┌──────────┐    │
│     │       │────────────►│          │    │
│     │ AGENT │             │ENVIRONMENT│   │
│     │       │◄────────────│          │    │
│     └───────┘  State +    └──────────┘    │
│                Reward                      │
│                                            │
│  Example: Robot learning to walk           │
│  - Action: Move left leg                   │
│  - Reward: +1 if steps forward             │
│  - Penalty: -1 if falls down               │
└────────────────────────────────────────────┘
```

| Application | Agent | Environment | Reward |
|-------------|-------|-------------|--------|
| Chess AI | Chess player | Chess board | Win/Lose |
| Self-driving | Car controller | Road/Traffic | Safe driving |
| Trading bot | Trader | Stock market | Profit/Loss |

---

## 1.3 ML Workflow Pipeline

```
┌─────────────────────────────────────────────────────────────────────┐
│  COMPLETE ML PIPELINE                                                │
│                                                                     │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐       │
│  │  1. DATA │──►│ 2. DATA  │──►│ 3.FEATURE│──►│ 4. MODEL │       │
│  │COLLECTION│   │CLEANING  │   │ENGINEERING│  │ SELECTION│       │
│  │          │   │          │   │          │   │          │       │
│  │ Gather   │   │ Missing  │   │ Create   │   │ Choose   │       │
│  │ data from│   │ values,  │   │ new      │   │ algorithm│       │
│  │ sources  │   │ outliers,│   │ features,│   │ (LR,SVM, │       │
│  │ (CSV,DB, │   │ duplicat-│   │ scaling, │   │  RF...)  │       │
│  │  API)    │   │ es       │   │ encoding │   │          │       │
│  └──────────┘   └──────────┘   └──────────┘   └────┬─────┘       │
│                                                      │             │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌────▼─────┐       │
│  │ 8.DEPLOY │◄──│ 7. TUNE  │◄──│6.EVALUATE│◄──│ 5. TRAIN │       │
│  │          │   │          │   │          │   │          │       │
│  │ Flask/   │   │ Grid     │   │ Accuracy,│   │ fit() on │       │
│  │ Docker/  │   │ Search,  │   │ F1,ROC,  │   │ training │       │
│  │ Cloud    │   │ Random   │   │ Confusion│   │ data     │       │
│  │          │   │ Search   │   │ Matrix   │   │          │       │
│  └──────────┘   └──────────┘   └──────────┘   └──────────┘       │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 1.4 Training, Testing, Validation

### Data Splitting

```
┌─────────────────────────────────────────────────────────────────┐
│  FULL DATASET (100%)                                             │
│                                                                 │
│  ┌──────────────────────────────────┬────────────┬────────────┐ │
│  │      TRAINING SET (60-70%)      │ VALIDATION │  TEST SET  │ │
│  │                                  │ (10-20%)   │  (20%)     │ │
│  │  Model LEARNS from this data    │ Tune hyper-│ FINAL eval │ │
│  │                                  │ parameters │ NEVER seen │ │
│  └──────────────────────────────────┴────────────┴────────────┘ │
│                                                                 │
│  Simple split (no validation):                                  │
│  ┌──────────────────────────────────────────┬──────────────────┐ │
│  │         TRAINING SET (80%)              │  TEST SET (20%)  │ │
│  └──────────────────────────────────────────┴──────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

| Set | Purpose | When Used | Size |
|-----|---------|-----------|------|
| **Training** | Model learns patterns | During model.fit() | 60-80% |
| **Validation** | Tune hyperparameters, prevent overfitting | During tuning | 10-20% |
| **Test** | Final performance check on unseen data | After all tuning done | 10-20% |

### Python Implementation

```python
from sklearn.model_selection import train_test_split

# Simple train-test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Train-validation-test split (two steps)
X_train_full, X_test, y_train_full, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)
X_train, X_val, y_train, y_val = train_test_split(
    X_train_full, y_train_full, test_size=0.25, random_state=42
)
# Result: 60% train, 20% validation, 20% test
```

### K-Fold Cross-Validation

```
┌─────────────────────────────────────────────────────────┐
│  5-FOLD CROSS-VALIDATION                                 │
│                                                         │
│  Fold 1: [TEST][ Train ][ Train ][ Train ][ Train ]    │
│  Fold 2: [Train][ TEST ][ Train ][ Train ][ Train ]    │
│  Fold 3: [Train][ Train ][ TEST ][ Train ][ Train ]    │
│  Fold 4: [Train][ Train ][ Train ][ TEST ][ Train ]    │
│  Fold 5: [Train][ Train ][ Train ][ Train ][ TEST ]    │
│                                                         │
│  Final Score = Average of all 5 fold scores             │
│  More reliable than single train-test split!            │
└─────────────────────────────────────────────────────────┘
```

```python
from sklearn.model_selection import cross_val_score
from sklearn.ensemble import RandomForestClassifier

model = RandomForestClassifier()
scores = cross_val_score(model, X, y, cv=5, scoring='accuracy')
print(f"CV Scores: {scores}")
print(f"Mean: {scores.mean():.4f} ± {scores.std():.4f}")
```

---

## 1.5 Bias vs Variance

### Definition

| Concept | Meaning | Cause |
|---------|---------|-------|
| **Bias** | Error from wrong assumptions → model is too simple | Underfitting |
| **Variance** | Error from sensitivity to training data fluctuations → model is too complex | Overfitting |

### Visual Representation

```
┌──────────────────────────────────────────────────────────────────┐
│  BIAS-VARIANCE TRADEOFF                                          │
│                                                                  │
│  Error                                                           │
│   ▲                                                              │
│   │   ╲  Total Error                                             │
│   │    ╲        ╱                                                │
│   │     ╲      ╱                                                 │
│   │      ╲    ╱                                                  │
│   │       ╲  ╱   ← Sweet Spot (Best Model)                      │
│   │        ╳                                                     │
│   │       ╱ ╲                                                    │
│   │  Bias╱   ╲ Variance                                         │
│   │    ╱      ╲                                                  │
│   │  ╱         ╲                                                 │
│   │╱             ╲                                               │
│   └──────────────────────────────────────► Model Complexity      │
│   Simple                              Complex                    │
│   (High Bias)                     (High Variance)                │
└──────────────────────────────────────────────────────────────────┘
```

### Bullseye Analogy

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  Low Bias         Low Bias          High Bias       High Bias    │
│  Low Variance     High Variance     Low Variance    High Var.    │
│                                                                  │
│   ┌───────┐       ┌───────┐        ┌───────┐      ┌───────┐   │
│   │  ·    │       │ ·     │        │       │      │·      │   │
│   │   ··  │       │    ·  │        │  ···  │      │  ·    │   │
│   │  ·⊕·  │       │·  ⊕   │        │  ·⊕·  │      │    ⊕ ·│   │
│   │   ··  │       │     · │        │  ···  │      │ ·     │   │
│   │  ·    │       │  ·    │        │       │      │    ·  │   │
│   └───────┘       └───────┘        └───────┘      └───────┘   │
│   IDEAL!          Inconsistent     Consistent     Worst case   │
│                   predictions      but wrong      scenario     │
│                                    target                      │
└──────────────────────────────────────────────────────────────────┘

⊕ = True target (center)
· = Model predictions
```

### Comparison Table

| | High Bias | High Variance |
|--|-----------|---------------|
| **Model** | Too simple | Too complex |
| **Training error** | High | Very low |
| **Test error** | High | Very high |
| **Problem** | Underfitting | Overfitting |
| **Fix** | Add features, complex model | More data, regularization, simpler model |
| **Example** | Linear line for curved data | Memorizing noise in training data |

---

## 1.6 Overfitting vs Underfitting

### Visual Explanation

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│  UNDERFITTING          GOOD FIT            OVERFITTING         │
│  (High Bias)          (Balanced)          (High Variance)      │
│                                                                │
│  y│                   y│     .  ·          y│  .·  ·  ·        │
│   │  ────────          │   ·/ \·            │ / \/ \/ \        │
│   │ · ·  · ·           │ ·/   \·            │/   \  \ /\       │
│   │· ·                 │/     ·\             │·    \  \/  ·     │
│   │      · ·           │       ·             │                  │
│   └──────────x         └──────────x         └──────────x       │
│                                                                │
│  Model too simple     Model captures       Model memorizes     │
│  Misses the pattern   the true pattern     noise/outliers      │
│                                                                │
│  Train Error: HIGH    Train Error: LOW     Train Error: ~ZERO  │
│  Test Error:  HIGH    Test Error:  LOW     Test Error:  HIGH   │
└────────────────────────────────────────────────────────────────┘
```

### How to Detect

```
┌────────────────────────────────────────────────────┐
│  LEARNING CURVES                                    │
│                                                    │
│  Error                    Error                    │
│   ▲                        ▲                       │
│   │ ───── Test             │      Test             │
│   │ ───── Train            │ ─────────── ╱ ╱       │
│   │                        │            ╱          │
│   │ Train ≈ Test           │     ╱─────╱ Train     │
│   │ (both HIGH)            │    ╱       (GAP!)     │
│   └──────────► Data        └──────────► Data       │
│   UNDERFITTING             OVERFITTING              │
│   (both errors high)      (train low, test high)   │
└────────────────────────────────────────────────────┘
```

### Solutions

| Problem | Solutions |
|---------|----------|
| **Underfitting** | Use more complex model, add more features, reduce regularization, train longer |
| **Overfitting** | Get more training data, simplify model, add regularization (L1/L2), dropout, early stopping, cross-validation |

---

## 1.7 Key Terminology

| Term | Definition | Example |
|------|-----------|---------|
| **Feature** | Input variable (column) | Age, Income, Height |
| **Target/Label** | Output variable to predict | Price, Spam/Not Spam |
| **Instance/Sample** | One row of data | One customer record |
| **Model** | Trained algorithm | Trained Random Forest |
| **Hyperparameter** | Setting configured BEFORE training | Learning rate, max_depth |
| **Parameter** | Values LEARNED during training | Weights, biases, coefficients |
| **Epoch** | One complete pass through training data | 10 epochs = 10 full passes |
| **Loss/Cost Function** | Measures how wrong the model is | MSE, Cross-Entropy |
| **Gradient Descent** | Optimization to minimize loss | Adjust weights to reduce error |
| **Regularization** | Penalty to prevent overfitting | L1 (Lasso), L2 (Ridge) |

---

## 1.8 Python ML Ecosystem

```
┌───────────────────────────────────────────────────────────────┐
│  PYTHON ML STACK                                               │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  DEEP LEARNING: TensorFlow, PyTorch, Keras              │  │
│  ├─────────────────────────────────────────────────────────┤  │
│  │  MACHINE LEARNING: scikit-learn, XGBoost, LightGBM      │  │
│  ├─────────────────────────────────────────────────────────┤  │
│  │  VISUALIZATION: Matplotlib, Seaborn, Plotly             │  │
│  ├─────────────────────────────────────────────────────────┤  │
│  │  DATA PROCESSING: Pandas, NumPy, SciPy                  │  │
│  ├─────────────────────────────────────────────────────────┤  │
│  │  PYTHON (Core Language)                                  │  │
│  └─────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────┘
```

```python
# Core imports for ML projects
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.metrics import accuracy_score, classification_report
```

---

## 1.9 Practice & Assessment

### MCQs

**Q1.** A model that has high training accuracy but low test accuracy is likely:
- A) Underfitting
- B) Overfitting
- C) Well-generalized
- D) Unbiased

**Answer:** B — The model memorized training data but fails on new data (overfitting / high variance).

---

**Q2.** Which type of ML uses labeled data?
- A) Unsupervised
- B) Reinforcement
- C) Supervised
- D) Semi-supervised

**Answer:** C — Supervised learning requires input-output pairs (labeled data).

---

**Q3.** K-Fold Cross-Validation is used to:
- A) Increase training data
- B) Get a more reliable performance estimate
- C) Speed up training
- D) Reduce features

**Answer:** B — It trains on different folds and averages scores for robust evaluation.

---

**Q4.** Which is NOT an example of supervised learning?
- A) Email spam detection
- B) Customer segmentation
- C) House price prediction
- D) Disease diagnosis

**Answer:** B — Customer segmentation is clustering (unsupervised).

---

**Q5.** A model with high bias will:
- A) Overfit the training data
- B) Underfit the training data
- C) Perform perfectly
- D) Have high variance

**Answer:** B — High bias = oversimplified model = underfitting.

---

### Coding Task

**Task:** Load the Iris dataset, split it, and verify the split sizes.

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split

# Load
iris = load_iris()
X, y = iris.data, iris.target

print(f"Total samples: {X.shape[0]}")
print(f"Features: {X.shape[1]}")
print(f"Classes: {list(iris.target_names)}")

# Split 80-20
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

print(f"\nTrain: {X_train.shape[0]} samples ({X_train.shape[0]/X.shape[0]*100:.0f}%)")
print(f"Test:  {X_test.shape[0]} samples ({X_test.shape[0]/X.shape[0]*100:.0f}%)")

# Verify stratification (equal class distribution)
import numpy as np
print(f"\nTrain class distribution: {np.bincount(y_train)}")
print(f"Test class distribution:  {np.bincount(y_test)}")
```

**Output:**
```
Total samples: 150
Features: 4
Classes: ['setosa', 'versicolor', 'virginica']

Train: 120 samples (80%)
Test:  30 samples (20%)

Train class distribution: [40 40 40]
Test class distribution:  [10 10 10]
```

---

> **Next Topic:** [02 - Data Preprocessing](02-data-preprocessing.md)
