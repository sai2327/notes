# 11. Hierarchical Clustering & DBSCAN

## Table of Contents
- [11.1 Hierarchical Clustering](#111-hierarchical-clustering)
- [11.2 Dendrogram](#112-dendrogram)
- [11.3 DBSCAN](#113-dbscan)
- [11.4 Clustering Algorithms Comparison](#114-clustering-algorithms-comparison)
- [11.5 Python Implementation](#115-python-implementation)
- [11.6 Practice & Assessment](#116-practice--assessment)

---

## 11.1 Hierarchical Clustering

### Definition
**Hierarchical Clustering** builds a **tree of clusters** (dendrogram) by either merging small clusters into bigger ones (**agglomerative** — bottom-up) or splitting big clusters into smaller ones (**divisive** — top-down).

### Agglomerative (Bottom-Up) Algorithm

```
1. Start: Each data point is its own cluster (N clusters)
2. Find the two CLOSEST clusters
3. Merge them into one cluster
4. Repeat steps 2-3 until only 1 cluster remains
5. Cut the dendrogram at desired height to get K clusters
```

### Step-by-Step Example

```
Data: A(1,1), B(1.5,1.5), C(5,5), D(5.5,5.5), E(3,3)

Step 1: Each point is a cluster
  {A}, {B}, {C}, {D}, {E}

Step 2: Distance matrix
         A      B      C      D      E
  A      0     0.71   5.66   6.36   2.83
  B     0.71    0     4.95   5.66   2.12
  C     5.66   4.95    0     0.71   2.83
  D     6.36   5.66   0.71    0     3.54
  E     2.83   2.12   2.83   3.54    0

Step 3: Merge closest → A & B (d=0.71)
  {A,B}, {C}, {D}, {E}

Step 4: Merge closest → C & D (d=0.71)
  {A,B}, {C,D}, {E}

Step 5: Merge closest → {A,B} & E (linkage distance)
  {A,B,E}, {C,D}

Step 6: Merge all
  {A,B,E,C,D}
```

### Linkage Methods

| Method | Distance Between Clusters | Behavior |
|--------|--------------------------|----------|
| **Single** | Min distance between any two points | Chaining effect, elongated clusters |
| **Complete** | Max distance between any two points | Compact, spherical clusters |
| **Average** | Average distance between all pairs | Balanced approach |
| **Ward** | Minimizes variance increase | Most popular, compact clusters |

```
┌────────────────────────────────────────────────────────┐
│  LINKAGE METHODS                                        │
│                                                        │
│  Cluster A: {●, ●}    Cluster B: {○, ○}               │
│                                                        │
│  Single:    min distance ●───────○  (shortest link)    │
│  Complete:  max distance ●═══════════○ (longest)       │
│  Average:   avg of ALL distances                       │
│  Ward:      minimizes within-cluster variance          │
└────────────────────────────────────────────────────────┘
```

---

## 11.2 Dendrogram

```
┌────────────────────────────────────────────────────────────────┐
│  DENDROGRAM (Tree of Merges)                                    │
│                                                                │
│  Height                                                        │
│  (distance)                                                    │
│     6 ┤              ┌──────────────┐                          │
│       │              │              │                          │
│     4 ┤        ┌─────┤              │                          │
│       │        │     │              │                          │
│     2 ┤   ┌────┤     │         ┌────┤  ← Cut here → 2 clusters│
│       │   │    │     │         │    │                          │
│     1 ┤ ┌─┤    │     │       ┌─┤    │                          │
│       │ │ │    │     │       │ │    │                          │
│     0 ┤ A B    E     │       C D    │                          │
│       └──┴────┴──────┴───────┴─┴────┘                          │
│                                                                │
│  Cluster 1: {A, B, E}                                          │
│  Cluster 2: {C, D}                                              │
│                                                                │
│  Rule: Horizontal line at certain height → defines clusters    │
│        Taller vertical lines → more distinct clusters          │
└────────────────────────────────────────────────────────────────┘
```

---

## 11.3 DBSCAN

### Definition
**DBSCAN** (Density-Based Spatial Clustering of Applications with Noise) groups points that are **densely packed together** and marks points in low-density regions as **noise/outliers**.

### Key Parameters

| Parameter | Description |
|-----------|-------------|
| **eps (ε)** | Maximum radius of the neighborhood |
| **min_samples** | Minimum points required to form a dense cluster |

### Point Types

```
┌──────────────────────────────────────────────────────────────────┐
│  DBSCAN POINT CLASSIFICATION                                     │
│                                                                  │
│  ┌─────────────────────────┐                                    │
│  │  ε-neighborhood of P:  │                                    │
│  │                         │                                    │
│  │  Points within radius ε │                                   │
│  │  around point P          │                                   │
│  └─────────────────────────┘                                    │
│                                                                  │
│  min_samples = 4                                                │
│                                                                  │
│  CORE POINT:      Has ≥ min_samples points within ε-radius     │
│   ╭────────╮                                                    │
│   │ · · ·  │  ← 5 points in radius (≥ 4) → CORE              │
│   │  [P]·  │                                                    │
│   ╰────────╯                                                    │
│                                                                  │
│  BORDER POINT:    Within ε of a core point, but < min_samples  │
│   ╭────────╮                                                    │
│   │  ·     │  ← 2 points in radius (< 4) but near a core      │
│   │  [P]   │                                                    │
│   ╰────────╯                                                    │
│                                                                  │
│  NOISE POINT:     Not within ε of any core point               │
│        [P]        ← Alone, far from everyone → OUTLIER         │
└──────────────────────────────────────────────────────────────────┘
```

### Algorithm

```
1. For each point P:
   a. Find all points within ε distance
   b. If ≥ min_samples → P is a CORE point
2. Connect all reachable core points into clusters
3. Assign border points to nearest core point's cluster
4. Points not reachable from any core → NOISE (-1)
```

### DBSCAN vs K-Means

```
┌────────────────────────────────────────────────────────────┐
│  K-MEANS                       DBSCAN                      │
│                                                            │
│  Must specify K                No need to specify K        │
│                                                            │
│  ╭───╮  ╭───╮                 ╭───────────╮               │
│  │ ● │  │ ● │                │  ●  ●      │              │
│  │●●●│  │●●●│                │ ● ●● ●●●  │              │
│  │ ● │  │ ● │                │  ●   ●     │              │
│  ╰───╯  ╰───╯                ╰───────────╯              │
│  Spherical only                ╭──╮                       │
│                                │●●│  Any shape!           │
│  ×  ← treats as                │●●│                       │
│       cluster member           ╰──╯                       │
│                                × ← detected as NOISE     │
└────────────────────────────────────────────────────────────┘
```

---

## 11.4 Clustering Algorithms Comparison

| Feature | K-Means | Hierarchical | DBSCAN |
|---------|---------|-------------|--------|
| **Specify K** | Yes (must) | Optional (cut dendrogram) | No |
| **Cluster shape** | Spherical | Any | Any |
| **Handles noise** | No | No | Yes (labels as -1) |
| **Scalability** | Very good O(nkT) | Poor O(n²) or O(n³) | Good O(n log n) |
| **Sensitivity** | To initialization | To linkage method | To ε and min_samples |
| **Deterministic** | No (random init) | Yes | Yes |
| **Best for** | Large, spherical data | Small data, need hierarchy | Irregular shapes, noise |

---

## 11.5 Python Implementation

### Hierarchical Clustering

```python
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import AgglomerativeClustering
from scipy.cluster.hierarchy import dendrogram, linkage

# Sample data
np.random.seed(42)
X = np.vstack([
    np.random.randn(50, 2) + [0, 0],
    np.random.randn(50, 2) + [5, 5],
    np.random.randn(50, 2) + [10, 0]
])

# Plot dendrogram
linked = linkage(X, method='ward')
plt.figure(figsize=(12, 5))
dendrogram(linked, truncate_mode='lastp', p=20)
plt.title("Dendrogram (Ward Linkage)")
plt.xlabel("Cluster Size")
plt.ylabel("Distance")
plt.show()

# Apply clustering
hc = AgglomerativeClustering(n_clusters=3, linkage='ward')
labels = hc.fit_predict(X)

# Visualize
plt.figure(figsize=(8, 6))
plt.scatter(X[:, 0], X[:, 1], c=labels, cmap='viridis', alpha=0.6)
plt.title("Hierarchical Clustering (K=3)")
plt.show()
```

### DBSCAN

```python
from sklearn.cluster import DBSCAN
from sklearn.datasets import make_moons
from sklearn.preprocessing import StandardScaler

# Generate moon-shaped data (K-Means would fail here!)
X, _ = make_moons(n_samples=300, noise=0.1, random_state=42)
X = StandardScaler().fit_transform(X)

# Apply DBSCAN
db = DBSCAN(eps=0.3, min_samples=5)
labels = db.fit_predict(X)

n_clusters = len(set(labels)) - (1 if -1 in labels else 0)
n_noise = list(labels).count(-1)

print(f"Clusters found: {n_clusters}")
print(f"Noise points: {n_noise}")

# Visualize
plt.figure(figsize=(10, 5))

# DBSCAN result
plt.subplot(1, 2, 1)
plt.scatter(X[:, 0], X[:, 1], c=labels, cmap='viridis', alpha=0.6)
plt.scatter(X[labels == -1, 0], X[labels == -1, 1],
            c='red', marker='x', s=50, label='Noise')
plt.title("DBSCAN")
plt.legend()

# K-Means comparison (fails on moons!)
from sklearn.cluster import KMeans
km = KMeans(n_clusters=2, random_state=42, n_init=10)
km_labels = km.fit_predict(X)

plt.subplot(1, 2, 2)
plt.scatter(X[:, 0], X[:, 1], c=km_labels, cmap='viridis', alpha=0.6)
plt.title("K-Means (incorrect!)")

plt.tight_layout()
plt.show()
```

---

## 11.6 Practice & Assessment

### MCQs

**Q1.** Hierarchical clustering does NOT require:
- A) Distance metric
- B) Linkage method
- C) Pre-specifying K (can choose from dendrogram)
- D) Data

**Answer:** C — K can be chosen after viewing the dendrogram.

---

**Q2.** DBSCAN labels a point as NOISE when:
- A) It's in the center of a cluster
- B) It's not reachable from any core point
- C) It has too many neighbors
- D) It's the farthest point

**Answer:** B — Noise points aren't within ε of any core point.

---

**Q3.** Which algorithm handles non-spherical clusters best?
- A) K-Means
- B) DBSCAN
- C) Linear Regression
- D) Naive Bayes

**Answer:** B — DBSCAN detects clusters of arbitrary shape based on density.

---

> **Next Topic:** [12 - PCA (Dimensionality Reduction)](12-pca.md)
