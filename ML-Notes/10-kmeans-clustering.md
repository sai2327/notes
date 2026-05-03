# 10. K-Means Clustering

## Table of Contents
- [10.1 Intuition](#101-intuition)
- [10.2 How K-Means Works (Step by Step)](#102-how-k-means-works-step-by-step)
- [10.3 Choosing K (Elbow Method)](#103-choosing-k-elbow-method)
- [10.4 Python Implementation](#104-python-implementation)
- [10.5 Limitations & Variants](#105-limitations--variants)
- [10.6 Practice & Assessment](#106-practice--assessment)

---

## 10.1 Intuition

### Definition
**K-Means Clustering** is an **unsupervised** algorithm that groups data into **K clusters** by minimizing the distance between points and their cluster's center (**centroid**).

> **Analogy:** Sorting a pile of different colored balls into K boxes — each box gets the balls most similar to its center.

```
┌──────────────────────────────────────────────────────────────┐
│  K-MEANS RESULT (K=3)                                         │
│                                                              │
│  x₂ ▲                                                        │
│     │    ◆ ◆              ◆ = Cluster 1                      │
│     │  ◆  ★◆              ★ = Centroid                       │
│     │    ◆                                                    │
│     │          ▲ ▲         ▲ = Cluster 2                     │
│     │        ▲ ★ ▲                                           │
│     │          ▲                                              │
│     │  ● ●                 ● = Cluster 3                     │
│     │ ● ★ ●                                                  │
│     │  ● ●                                                   │
│     └──────────────────────► x₁                              │
│                                                              │
│  Each point is assigned to the NEAREST centroid              │
└──────────────────────────────────────────────────────────────┘
```

---

## 10.2 How K-Means Works (Step by Step)

### Algorithm

```
1. Choose K (number of clusters)
2. Randomly initialize K centroids
3. REPEAT until convergence:
   a. ASSIGN each point to the nearest centroid
   b. UPDATE each centroid to the mean of its assigned points
4. Stop when centroids don't change (or max iterations reached)
```

### Dry Run (K=2)

```
Data points: A(1,1), B(1.5,2), C(3,4), D(5,7), E(3.5,5), F(4.5,5)

ITERATION 0: Initialize centroids randomly
  C₁ = (1, 1)     ← Point A
  C₂ = (5, 7)     ← Point D

ITERATION 1: Assign to nearest centroid
  ┌───────┬──────────┬──────────┬──────────┐
  │ Point │ d(C₁)    │ d(C₂)    │ Cluster  │
  ├───────┼──────────┼──────────┼──────────┤
  │ A(1,1)│ 0.00     │ 7.21     │ Cluster 1│
  │ B(1.5,2)│ 1.12   │ 6.10     │ Cluster 1│
  │ C(3,4)│ 3.61     │ 3.61     │ Cluster 1│ ← tie, assign C1
  │ D(5,7)│ 7.21     │ 0.00     │ Cluster 2│
  │ E(3.5,5)│ 4.72   │ 2.50     │ Cluster 2│
  │ F(4.5,5)│ 5.32   │ 2.06     │ Cluster 2│
  └───────┴──────────┴──────────┴──────────┘

  Update centroids:
  C₁ = mean(A, B, C) = ((1+1.5+3)/3, (1+2+4)/3) = (1.83, 2.33)
  C₂ = mean(D, E, F) = ((5+3.5+4.5)/3, (7+5+5)/3) = (4.33, 5.67)

ITERATION 2: Reassign
  ┌───────┬──────────┬──────────┬──────────┐
  │ Point │ d(C₁)    │ d(C₂)    │ Cluster  │
  ├───────┼──────────┼──────────┼──────────┤
  │ A     │ 1.55     │ 5.73     │ Cluster 1│
  │ B     │ 0.47     │ 4.57     │ Cluster 1│
  │ C     │ 2.02     │ 2.04     │ Cluster 1│
  │ D     │ 5.61     │ 1.49     │ Cluster 2│
  │ E     │ 3.13     │ 1.06     │ Cluster 2│
  │ F     │ 3.66     │ 0.69     │ Cluster 2│
  └───────┴──────────┴──────────┴──────────┘

  Same assignments as before → CONVERGED!

  Final clusters:
  Cluster 1: {A, B, C} with centroid (1.83, 2.33)
  Cluster 2: {D, E, F} with centroid (4.33, 5.67)
```

---

## 10.3 Choosing K (Elbow Method)

### WCSS (Within-Cluster Sum of Squares)

$$WCSS = \sum_{k=1}^{K} \sum_{x_i \in C_k} \|x_i - \mu_k\|^2$$

```
┌──────────────────────────────────────────────────────────────┐
│  ELBOW METHOD                                                 │
│                                                              │
│  WCSS                                                        │
│   ▲                                                          │
│   │ ╲                                                        │
│   │  ╲                                                       │
│   │   ╲                                                      │
│   │    ╲                                                     │
│   │     ● ← ELBOW (K=3 optimal)                             │
│   │      ╲___                                                │
│   │          ╲____                                           │
│   │               ╲_______                                   │
│   └──────┬───┬───┬───┬───┬──► K                             │
│          1   2   3   4   5                                   │
│                  ↑                                           │
│             Best K = 3                                       │
│                                                              │
│  Rule: Pick K where WCSS curve bends (diminishing returns)  │
└──────────────────────────────────────────────────────────────┘
```

### Silhouette Score

$$s(i) = \frac{b(i) - a(i)}{\max(a(i), b(i))}$$

Where $a(i)$ = avg distance to same cluster, $b(i)$ = avg distance to nearest other cluster.

- $s = +1$: Point is well clustered
- $s = 0$: Point is on cluster boundary
- $s = -1$: Point is in wrong cluster

```python
from sklearn.metrics import silhouette_score

# Try different K values
for k in range(2, 8):
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    labels = kmeans.fit_predict(X)
    score = silhouette_score(X, labels)
    print(f"K={k}: Silhouette Score = {score:.4f}")
```

---

## 10.4 Python Implementation

### Complete Example: Customer Segmentation

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import silhouette_score

# Generate customer data
np.random.seed(42)
n = 300

# 3 natural clusters
data = np.vstack([
    np.random.randn(100, 2) * 0.8 + [2, 2],   # Young, low spend
    np.random.randn(100, 2) * 0.8 + [8, 8],   # Middle, high spend
    np.random.randn(100, 2) * 0.8 + [5, 2],   # Middle, low spend
])

df = pd.DataFrame(data, columns=["Annual_Income", "Spending_Score"])

# Scale
scaler = StandardScaler()
X_scaled = scaler.fit_transform(df)

# Elbow Method
wcss = []
K_range = range(1, 11)
for k in K_range:
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    kmeans.fit(X_scaled)
    wcss.append(kmeans.inertia_)

plt.figure(figsize=(8, 4))
plt.plot(K_range, wcss, 'b-o')
plt.xlabel("Number of Clusters (K)")
plt.ylabel("WCSS")
plt.title("Elbow Method")
plt.grid(True)
plt.show()

# Apply K-Means with optimal K=3
kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
df["Cluster"] = kmeans.fit_predict(X_scaled)

# Evaluate
sil_score = silhouette_score(X_scaled, df["Cluster"])
print(f"Silhouette Score: {sil_score:.4f}")

# Visualize
plt.figure(figsize=(10, 6))
colors = ['red', 'blue', 'green']
for i in range(3):
    cluster_data = df[df["Cluster"] == i]
    plt.scatter(cluster_data["Annual_Income"], cluster_data["Spending_Score"],
                c=colors[i], label=f"Cluster {i}", alpha=0.6)

# Plot centroids (inverse transform to original scale)
centroids = scaler.inverse_transform(kmeans.cluster_centers_)
plt.scatter(centroids[:, 0], centroids[:, 1], c='black', marker='X',
            s=200, label='Centroids')
plt.xlabel("Annual Income")
plt.ylabel("Spending Score")
plt.title("Customer Segments")
plt.legend()
plt.show()

# Cluster analysis
print("\nCluster Summary:")
for i in range(3):
    cluster = df[df["Cluster"] == i]
    print(f"\nCluster {i} ({len(cluster)} customers):")
    print(f"  Income: mean={cluster['Annual_Income'].mean():.1f}, std={cluster['Annual_Income'].std():.1f}")
    print(f"  Spending: mean={cluster['Spending_Score'].mean():.1f}, std={cluster['Spending_Score'].std():.1f}")
```

---

## 10.5 Limitations & Variants

### K-Means Limitations

| Limitation | Explanation |
|-----------|-------------|
| Must specify K in advance | Need elbow/silhouette to determine |
| Sensitive to initialization | Different starting points → different results |
| Assumes spherical clusters | Fails with elongated or irregular shapes |
| Sensitive to outliers | Outliers pull centroids |
| Only convex clusters | Cannot find non-convex shapes |

### K-Means++ (Better Initialization)

```python
# sklearn uses K-Means++ by default (init='k-means++')
# Spreads initial centroids apart for better convergence
kmeans = KMeans(n_clusters=3, init='k-means++', n_init=10, random_state=42)
```

### Mini-Batch K-Means (For Large Datasets)

```python
from sklearn.cluster import MiniBatchKMeans

# Uses random subsets for faster training
mbk = MiniBatchKMeans(n_clusters=3, batch_size=100, random_state=42)
mbk.fit(X_scaled)
```

---

## 10.6 Practice & Assessment

### MCQs

**Q1.** K-Means is which type of learning?
- A) Supervised
- B) Unsupervised
- C) Reinforcement
- D) Semi-supervised

**Answer:** B — K-Means finds clusters without labeled data.

---

**Q2.** The Elbow Method helps determine:
- A) The best algorithm
- B) The optimal number of clusters K
- C) The best features
- D) The learning rate

**Answer:** B — Plot WCSS vs K and pick the "elbow" point.

---

**Q3.** K-Means converges when:
- A) All data points move to one cluster
- B) Centroids stop changing (assignments stabilize)
- C) WCSS reaches 0
- D) K reaches its maximum

**Answer:** B — Convergence = no further changes in cluster assignments.

---

> **Next Topic:** [11 - Hierarchical Clustering & DBSCAN](11-hierarchical-dbscan.md)
