# 13. NumPy — Numerical Python

## Table of Contents
- [13.1 Introduction to NumPy](#131-introduction-to-numpy)
- [13.2 Creating Arrays](#132-creating-arrays)
- [13.3 Array Operations](#133-array-operations)
- [13.4 Indexing and Slicing](#134-indexing-and-slicing)
- [13.5 Broadcasting](#135-broadcasting)
- [13.6 Linear Algebra](#136-linear-algebra)
- [13.7 Practice & Assessment](#137-practice--assessment)

---

## 13.1 Introduction to NumPy

### What is NumPy?
NumPy is Python's fundamental library for numerical computing. It provides fast, memory-efficient multi-dimensional arrays.

### Why NumPy Over Lists?

| Feature | Python List | NumPy Array |
|---------|-------------|-------------|
| Speed | Slow (interpreted loops) | Fast (C-optimized) |
| Memory | More (stores type info per element) | Less (homogeneous) |
| Operations | Element-by-element loops | Vectorized (whole array) |
| Broadcasting | Not supported | Supported |
| Linear Algebra | Not built-in | Built-in |

```python
import numpy as np

# Speed comparison
import time

size = 1000000
py_list = list(range(size))
np_array = np.arange(size)

# List operation
start = time.time()
result = [x * 2 for x in py_list]
print(f"List: {time.time() - start:.4f}s")

# NumPy operation
start = time.time()
result = np_array * 2
print(f"NumPy: {time.time() - start:.4f}s")

# NumPy is typically 10-100x faster!
```

---

## 13.2 Creating Arrays

```python
import numpy as np

# From Python list
a = np.array([1, 2, 3, 4, 5])
print(a)        # [1 2 3 4 5]
print(a.dtype)  # int64

# 2D array (matrix)
m = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
print(m)
# [[1 2 3]
#  [4 5 6]
#  [7 8 9]]
print(m.shape)  # (3, 3)

# Special arrays
print(np.zeros((3, 4)))     # 3x4 matrix of zeros
print(np.ones((2, 3)))      # 2x3 matrix of ones
print(np.full((2, 2), 7))   # 2x2 matrix filled with 7
print(np.eye(3))            # 3x3 identity matrix
print(np.empty((2, 3)))     # Uninitialized (random values)

# Ranges
print(np.arange(0, 10, 2))      # [0 2 4 6 8]
print(np.linspace(0, 1, 5))     # [0.   0.25 0.5  0.75 1.  ]

# Random
print(np.random.rand(3, 3))     # 3x3 random floats [0, 1)
print(np.random.randint(1, 10, size=(2, 3)))  # Random ints
print(np.random.randn(3))       # Normal distribution
```

### Array Attributes

```python
a = np.array([[1, 2, 3], [4, 5, 6]])

print(a.ndim)    # 2 (dimensions)
print(a.shape)   # (2, 3) (rows, cols)
print(a.size)    # 6 (total elements)
print(a.dtype)   # int64
print(a.itemsize) # 8 bytes per element
```

```
┌───────────────────────────────────────────────┐
│  Array Shape Visualization                     │
│                                               │
│  1D: shape (5,)      [1, 2, 3, 4, 5]         │
│                                               │
│  2D: shape (2, 3)    [[1, 2, 3],             │
│                       [4, 5, 6]]              │
│                                               │
│  3D: shape (2, 3, 4) [[[...], [...], [...]],  │
│                       [[...], [...], [...]]]   │
│       └─ 2 blocks of 3 rows × 4 cols         │
└───────────────────────────────────────────────┘
```

---

## 13.3 Array Operations

### Element-wise Operations (Vectorized)

```python
a = np.array([1, 2, 3, 4, 5])
b = np.array([10, 20, 30, 40, 50])

print(a + b)    # [11 22 33 44 55]
print(a * b)    # [10 40 90 160 250]
print(a ** 2)   # [1 4 9 16 25]
print(np.sqrt(a))  # [1.  1.41 1.73 2.  2.24]
print(a > 3)    # [False False False True True]
```

### Aggregate Functions

```python
a = np.array([[1, 2, 3], [4, 5, 6]])

print(np.sum(a))        # 21 (all elements)
print(np.sum(a, axis=0))  # [5 7 9] (column sums)
print(np.sum(a, axis=1))  # [6 15] (row sums)

print(np.mean(a))       # 3.5
print(np.median(a))     # 3.5
print(np.std(a))        # 1.707...
print(np.min(a))        # 1
print(np.max(a))        # 6
print(np.argmax(a))     # 5 (index of max in flattened)
```

### Reshaping

```python
a = np.arange(12)
print(a)  # [ 0  1  2  3  4  5  6  7  8  9 10 11]

# Reshape
b = a.reshape(3, 4)
print(b)
# [[ 0  1  2  3]
#  [ 4  5  6  7]
#  [ 8  9 10 11]]

c = a.reshape(2, 2, 3)  # 3D
print(c.shape)  # (2, 2, 3)

# Flatten
print(b.flatten())  # [ 0  1  2  ...  11] (returns copy)
print(b.ravel())    # Same but returns view

# Transpose
print(b.T)
# [[ 0  4  8]
#  [ 1  5  9]
#  [ 2  6 10]
#  [ 3  7 11]]
```

### Stacking and Splitting

```python
a = np.array([1, 2, 3])
b = np.array([4, 5, 6])

# Stack
print(np.hstack([a, b]))  # [1 2 3 4 5 6] (horizontal)
print(np.vstack([a, b]))  # [[1 2 3] [4 5 6]] (vertical)

# Split
c = np.array([1, 2, 3, 4, 5, 6])
print(np.split(c, 3))  # [array([1, 2]), array([3, 4]), array([5, 6])]
```

---

## 13.4 Indexing and Slicing

```python
# 2D indexing
m = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

print(m[0, 0])     # 1 (row 0, col 0)
print(m[1, 2])     # 6 (row 1, col 2)
print(m[0])        # [1 2 3] (entire row 0)
print(m[:, 1])     # [2 5 8] (entire column 1)
print(m[0:2, 1:3]) # [[2 3] [5 6]] (submatrix)

# Boolean indexing
a = np.array([10, 20, 30, 40, 50])
mask = a > 25
print(mask)        # [False False True True True]
print(a[mask])     # [30 40 50]
print(a[a > 25])   # [30 40 50] (shorthand)

# Fancy indexing
print(a[[0, 2, 4]])  # [10 30 50] (select by indices)
```

---

## 13.5 Broadcasting

### Definition
**Broadcasting** allows NumPy to perform operations on arrays of different shapes.

```
┌───────────────────────────────────────────────────────┐
│  BROADCASTING RULES                                    │
│                                                       │
│  Rule 1: If arrays differ in ndim, pad smaller with 1s│
│  Rule 2: Arrays with size 1 along a dim are stretched │
│  Rule 3: If sizes differ and neither is 1 → Error!   │
│                                                       │
│  Example: (3,3) + (3,) → (3,3) + (1,3) → (3,3)      │
│                                                       │
│  [[1, 2, 3],     [10, 20, 30]   [[11, 22, 33],       │
│   [4, 5, 6],  +       ↓          [14, 25, 36],       │
│   [7, 8, 9]]   broadcast        [17, 28, 39]]       │
└───────────────────────────────────────────────────────┘
```

```python
# Scalar broadcasting
a = np.array([1, 2, 3, 4])
print(a * 10)  # [10 20 30 40]

# 1D + 2D broadcasting
m = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
v = np.array([10, 20, 30])
print(m + v)
# [[11 22 33]
#  [14 25 36]
#  [17 28 39]]

# Column broadcasting
col = np.array([[1], [2], [3]])  # Shape (3,1)
print(m + col)
# [[ 2  3  4]
#  [ 6  7  8]
#  [10 11 12]]
```

---

## 13.6 Linear Algebra

```python
# Matrix multiplication
A = np.array([[1, 2], [3, 4]])
B = np.array([[5, 6], [7, 8]])

print(A @ B)          # Matrix multiplication
# [[19 22]
#  [43 50]]

print(np.dot(A, B))   # Same as @

# Determinant
print(np.linalg.det(A))  # -2.0

# Inverse
print(np.linalg.inv(A))
# [[-2.   1. ]
#  [ 1.5 -0.5]]

# Eigenvalues and eigenvectors
eigenvalues, eigenvectors = np.linalg.eig(A)
print(f"Eigenvalues: {eigenvalues}")

# Solving linear equations: Ax = b
# 2x + y = 5
# x + 3y = 7
A = np.array([[2, 1], [1, 3]])
b = np.array([5, 7])
x = np.linalg.solve(A, b)
print(f"Solution: x={x[0]:.2f}, y={x[1]:.2f}")  # x=1.60, y=1.80
```

---

## 13.7 Practice & Assessment

### MCQs

**Q1.** What is `np.zeros((2,3)).shape`?
- A) `(3, 2)`
- B) `(2, 3)`
- C) `(6,)`
- D) `(2, 3, 1)`

**Answer:** B

---

**Q2.** What does vectorization mean?
- A) Converting to vectors
- B) Operating on entire arrays without loops
- C) Using GPU
- D) Parallel processing

**Answer:** B — Operations applied to entire array at once (in C).

---

### Coding Tasks

**Task 1:** Normalize an array to range [0, 1].

```python
def normalize(arr):
    return (arr - arr.min()) / (arr.max() - arr.min())

data = np.array([10, 20, 30, 40, 50])
print(normalize(data))  # [0.   0.25 0.5  0.75 1.  ]
```

**Task 2:** Find common elements between two arrays.

```python
a = np.array([1, 2, 3, 4, 5])
b = np.array([3, 4, 5, 6, 7])
common = np.intersect1d(a, b)
print(common)  # [3 4 5]
```

---

> **Next Topic:** [14 - Pandas Basics](14-pandas-basics.md)
