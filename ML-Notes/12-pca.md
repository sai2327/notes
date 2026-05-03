# 12. PCA (Principal Component Analysis)

## Table of Contents
- [12.1 Intuition](#121-intuition)
- [12.2 Mathematical Foundation](#122-mathematical-foundation)
- [12.3 Step-by-Step Working](#123-step-by-step-working)
- [12.4 Python Implementation](#124-python-implementation)
- [12.5 Advantages & Disadvantages](#125-advantages--disadvantages)
- [12.6 Practice & Assessment](#126-practice--assessment)

---

## 12.1 Intuition

### Definition
**PCA** reduces the number of features (dimensions) while **preserving as much variance** (information) as possible. It transforms original features into new, uncorrelated components called **principal components**.

> **Analogy:** You have a 100-column spreadsheet. Most columns are redundant. PCA finds that 5 new combined columns can capture 95% of the important patterns.

```
┌────────────────────────────────────────────────────────────────────┐
│  DIMENSIONALITY REDUCTION                                          │
│                                                                    │
│  Before PCA (2D):              After PCA (1D):                     │
│                                                                    │
│  y ▲     ●                    ──●──●──●──●──●──●──► PC1           │
│    │    ● ●                                                        │
│    │  ●  ●                    Projected onto direction of          │
│    │ ●  ●                     MAXIMUM VARIANCE                     │
│    │● ●                                                            │
│    └──────► x                                                      │
│                                                                    │
│  2 features → 1 principal component                                │
│  Lost a little info, but much simpler!                            │
└────────────────────────────────────────────────────────────────────┘
```

### Why Use PCA?
| Problem | PCA Solution |
|---------|-------------|
| Too many features (curse of dimensionality) | Reduce to fewer components |
| Features are correlated | Creates uncorrelated components |
| Visualization of high-dim data | Project to 2D/3D for plotting |
| Speed up ML models | Fewer features = faster training |
| Noise reduction | Small components capture noise → drop them |

---

## 12.2 Mathematical Foundation

### Steps of PCA

$$\text{Original Data} \xrightarrow{\text{Standardize}} \xrightarrow{\text{Covariance Matrix}} \xrightarrow{\text{Eigenvalues}} \xrightarrow{\text{Select Top K}} \text{Reduced Data}$$

### Key Concepts

**Variance** = how spread out data is along an axis.  
PCA finds axes (directions) where data has **maximum variance**.

**Eigenvalues** ($\lambda$) = amount of variance captured by each component.  
**Eigenvectors** = direction of each principal component.

**Explained Variance Ratio:**

$$\text{Explained Variance Ratio}_k = \frac{\lambda_k}{\sum_{i=1}^{n} \lambda_i}$$

---

## 12.3 Step-by-Step Working

### Dry Run (2D → 1D)

```
Data: (2,4), (4,6), (6,8), (8,10)

Step 1: Standardize (mean = 0, std = 1)
  Mean_x = 5, Mean_y = 7
  Std_x = 2.24, Std_y = 2.24

  Centered data: (-3,-3), (-1,-1), (1,1), (3,3)

Step 2: Compute Covariance Matrix
  Cov(X,X) = Σ(xᵢ²) / (n-1) = (9+1+1+9)/3 = 6.67
  Cov(X,Y) = Σ(xᵢyᵢ) / (n-1) = (9+1+1+9)/3 = 6.67
  Cov(Y,Y) = 6.67

  Covariance Matrix:
  C = ┌ 6.67  6.67 ┐
      └ 6.67  6.67 ┘

Step 3: Compute Eigenvalues and Eigenvectors
  |C - λI| = 0
  (6.67-λ)² - 6.67² = 0
  λ₁ = 13.33  (captures most variance!)
  λ₂ = 0.00   (captures no additional variance)

  Eigenvector for λ₁ = [0.707, 0.707]  (direction: 45°)
  Eigenvector for λ₂ = [-0.707, 0.707]

Step 4: Explained Variance
  PC1 = 13.33 / 13.33 = 100%  ← All variance in 1 component!
  PC2 = 0.00 / 13.33 = 0%

Step 5: Project data onto PC1
  Projection = data × eigenvector₁
  (-3,-3) · (0.707, 0.707) = -4.24
  (-1,-1) · (0.707, 0.707) = -1.41
  (1,1)   · (0.707, 0.707) = 1.41
  (3,3)   · (0.707, 0.707) = 4.24

  Reduced 1D data: [-4.24, -1.41, 1.41, 4.24]
  (2D → 1D with 100% variance preserved because data was perfectly linear)
```

### Explained Variance Visualization

```
┌────────────────────────────────────────────────────────────────┐
│  CUMULATIVE EXPLAINED VARIANCE                                  │
│                                                                │
│  100% ┤─────────────────────────────── ●─────●──────●          │
│       │                           ●                            │
│   90% ┤                       ●                                │
│       │                   ●                                    │
│   80% ┤              ●                                         │
│       │          ●                                             │
│   70% ┤      ●                                                 │
│       │   ●                                                    │
│   50% ┤ ●                                                      │
│       └──┬───┬───┬───┬───┬───┬───┬───┬───┬──► Components      │
│          1   2   3   4   5   6   7   8   9                     │
│                      ↑                                         │
│               Pick K=4 for 90%                                 │
│                                                                │
│  Rule: Choose K components that capture ≥ 90-95% variance     │
└────────────────────────────────────────────────────────────────┘
```

---

## 12.4 Python Implementation

### Complete PCA Example

```python
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA

# Load data
iris = load_iris()
X = iris.data       # 4 features
y = iris.target

# Step 1: Standardize (IMPORTANT for PCA!)
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Step 2: Apply PCA
pca = PCA()   # Keep all components first
X_pca = pca.fit_transform(X_scaled)

# Step 3: Check explained variance
print("Explained Variance Ratio per component:")
for i, var in enumerate(pca.explained_variance_ratio_):
    print(f"  PC{i+1}: {var:.4f} ({var*100:.1f}%)")

cumulative = np.cumsum(pca.explained_variance_ratio_)
print(f"\nCumulative: {[f'{c:.1%}' for c in cumulative]}")

# Plot cumulative variance
plt.figure(figsize=(8, 4))
plt.bar(range(1, 5), pca.explained_variance_ratio_, alpha=0.6, label='Individual')
plt.step(range(1, 5), cumulative, where='mid', label='Cumulative', color='red')
plt.axhline(y=0.95, color='gray', linestyle='--', label='95% threshold')
plt.xlabel("Principal Component")
plt.ylabel("Explained Variance Ratio")
plt.title("PCA — Explained Variance")
plt.legend()
plt.show()

# Step 4: Reduce to 2D and visualize
pca_2d = PCA(n_components=2)
X_2d = pca_2d.fit_transform(X_scaled)

plt.figure(figsize=(8, 6))
colors = ['red', 'green', 'blue']
for i, name in enumerate(iris.target_names):
    mask = y == i
    plt.scatter(X_2d[mask, 0], X_2d[mask, 1], c=colors[i], label=name, alpha=0.7)

plt.xlabel(f"PC1 ({pca_2d.explained_variance_ratio_[0]:.1%} variance)")
plt.ylabel(f"PC2 ({pca_2d.explained_variance_ratio_[1]:.1%} variance)")
plt.title("Iris Dataset — PCA 2D Projection")
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()

print(f"\nOriginal dimensions: {X.shape[1]}")
print(f"Reduced dimensions: 2")
print(f"Variance preserved: {sum(pca_2d.explained_variance_ratio_):.1%}")
```

### PCA + Classification Pipeline

```python
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import cross_val_score

# Without PCA
pipe_no_pca = Pipeline([
    ('scaler', StandardScaler()),
    ('clf', LogisticRegression(max_iter=200))
])

# With PCA (reduce to 2 components)
pipe_pca = Pipeline([
    ('scaler', StandardScaler()),
    ('pca', PCA(n_components=2)),
    ('clf', LogisticRegression(max_iter=200))
])

score_full = cross_val_score(pipe_no_pca, X, y, cv=5).mean()
score_pca = cross_val_score(pipe_pca, X, y, cv=5).mean()

print(f"Without PCA (4 features): {score_full:.4f}")
print(f"With PCA (2 components):  {score_pca:.4f}")
```

---

## 12.5 Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Reduces dimensionality effectively | Loses some information |
| Removes correlated features | Principal components are not interpretable |
| Speeds up model training | Assumes linear relationships |
| Helps with visualization (2D/3D) | Sensitive to feature scaling |
| Reduces noise in data | Not suitable for categorical data |

### When to Use PCA
- High-dimensional data (100+ features)
- Many correlated features
- Need to visualize high-dimensional data
- Model is slow due to too many features
- **Always standardize before PCA!**

---

## 12.6 Practice & Assessment

### MCQs

**Q1.** PCA finds directions of:
- A) Minimum variance
- B) Maximum variance
- C) Zero variance
- D) Equal variance

**Answer:** B — Principal components point in the direction of maximum variance.

---

**Q2.** Before applying PCA, you should:
- A) Remove all features
- B) Standardize the data
- C) Convert to categorical
- D) Remove outliers only

**Answer:** B — PCA is sensitive to scale; features must be standardized.

---

**Q3.** If 3 components capture 95% variance from 50 features:
- A) Use all 50 features
- B) Use 3 principal components
- C) Use 25 features
- D) Add more features

**Answer:** B — 3 components preserve 95% of information with massive dimension reduction.

---

> **Next Topic:** [13 - Model Evaluation](13-model-evaluation.md)
