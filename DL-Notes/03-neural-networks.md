# 03. Neural Networks (Detailed)

## Table of Contents
- [3.1 Perceptron](#31-perceptron)
- [3.2 Multi-Layer Perceptron (MLP)](#32-multi-layer-perceptron-mlp)
- [3.3 Activation Functions](#33-activation-functions)
- [3.4 Loss Functions](#34-loss-functions)
- [3.5 Weight Initialization](#35-weight-initialization)
- [3.6 Practice & Assessment](#36-practice--assessment)

---

## 3.1 Perceptron

### Definition
The **Perceptron** is the simplest neural network — a single neuron that makes binary decisions.

### How It Works

$$\hat{y} = \begin{cases} 1 & \text{if } \sum w_i x_i + b \geq 0 \\ 0 & \text{if } \sum w_i x_i + b < 0 \end{cases}$$

```
┌────────────────────────────────────────────────────────────────┐
│  PERCEPTRON                                                     │
│                                                                │
│       Inputs      Weights                                      │
│                                                                │
│  x₁ ───(w₁)───┐                                               │
│                ├──▶ Σ(wᵢxᵢ + b) ──▶ Step Function ──▶ ŷ      │
│  x₂ ───(w₂)───┤                                               │
│                │     Weighted        if sum ≥ 0 → 1           │
│  x₃ ───(w₃)───┘     Sum + Bias      if sum < 0 → 0           │
│                                                                │
│  b ─────────────┘    (Bias added)                              │
└────────────────────────────────────────────────────────────────┘
```

### Dry Run: AND Gate

```
AND Gate Truth Table:
  x₁  x₂  │  y
  0   0   │  0
  0   1   │  0
  1   0   │  0
  1   1   │  1

Learned weights: w₁=1, w₂=1, b=-1.5

  x₁=0, x₂=0: 0(1) + 0(1) + (-1.5) = -1.5 → 0 ✓
  x₁=0, x₂=1: 0(1) + 1(1) + (-1.5) = -0.5 → 0 ✓
  x₁=1, x₂=0: 1(1) + 0(1) + (-1.5) = -0.5 → 0 ✓
  x₁=1, x₂=1: 1(1) + 1(1) + (-1.5) =  0.5 → 1 ✓
```

### Perceptron Limitation: XOR Problem

```
┌────────────────────────────────────────────────────────────────┐
│  XOR CANNOT BE SOLVED BY A SINGLE PERCEPTRON                   │
│                                                                │
│  AND (linearly separable):    XOR (NOT linearly separable):    │
│                                                                │
│  x₂ ▲                       x₂ ▲                              │
│     │ ○       ●                 │ ●       ○                    │
│     │     ╱                     │     ╳ ← no single line!     │
│     │   ╱                       │   ╱ ╲                        │
│     │ ○╱    ○                   │ ○       ●                    │
│     └──────────▶ x₁             └──────────▶ x₁               │
│   One line separates!          Cannot separate with one line!  │
│                                                                │
│  Solution: Add HIDDEN LAYERS → Multi-Layer Perceptron (MLP)   │
└────────────────────────────────────────────────────────────────┘
```

---

## 3.2 Multi-Layer Perceptron (MLP)

### Architecture

```
┌────────────────────────────────────────────────────────────────────┐
│  MULTI-LAYER PERCEPTRON (MLP)                                      │
│                                                                    │
│  Input Layer      Hidden Layer 1     Hidden Layer 2    Output     │
│  (no computation)  (learned features)  (deeper features) (pred)   │
│                                                                    │
│    x₁ ──○──┐    ┌──○──┐    ┌──○──┐                               │
│            ├────┤     ├────┤     ├────○── ŷ                      │
│    x₂ ──○──┤    ├──○──┤    ├──○──┤                               │
│            ├────┤     ├────┤     │                                │
│    x₃ ──○──┘    └──○──┘    └──○──┘                               │
│                                                                    │
│   Layer 0        Layer 1        Layer 2       Layer 3             │
│   3 inputs      3 neurons      3 neurons     1 neuron            │
│                 9 weights      9 weights     3 weights           │
│                 3 biases       3 biases      1 bias              │
│                                                                    │
│  Total trainable parameters: 9+3 + 9+3 + 3+1 = 28               │
└────────────────────────────────────────────────────────────────────┘
```

### Parameter Count Formula

For a layer with $n_{in}$ inputs and $n_{out}$ neurons:

$$\text{Parameters} = n_{in} \times n_{out} + n_{out}$$
$$\text{(weights)} + \text{(biases)}$$

```
Example: Input(784) → Dense(256) → Dense(128) → Dense(10)

Layer 1: 784 × 256 + 256 = 200,960 parameters
Layer 2: 256 × 128 + 128 =  32,896 parameters
Layer 3: 128 × 10  + 10  =   1,290 parameters
                            ─────────
                    Total:  235,146 parameters
```

---

## 3.3 Activation Functions

### Why Activation Functions?

Without activation functions, a neural network is just a **linear function** — stacking linear layers produces another linear function. Activation functions add **non-linearity** so the network can learn complex patterns.

```
┌────────────────────────────────────────────────────────────────┐
│  WITHOUT ACTIVATION:                                           │
│  Layer 1: y = W₁x + b₁                                       │
│  Layer 2: y = W₂(W₁x + b₁) + b₂ = W₂W₁x + W₂b₁ + b₂      │
│  → Still just y = Ax + B (LINEAR!)                            │
│                                                                │
│  WITH ACTIVATION:                                              │
│  Layer 1: a₁ = ReLU(W₁x + b₁)                               │
│  Layer 2: a₂ = ReLU(W₂a₁ + b₂)                              │
│  → NON-LINEAR! Can learn curves, boundaries, complex shapes  │
└────────────────────────────────────────────────────────────────┘
```

### 1. ReLU (Rectified Linear Unit) — Most Popular

$$\text{ReLU}(x) = \max(0, x)$$

```
┌────────────────────────────────────────────────────────────────┐
│  ReLU GRAPH                        DERIVATIVE                  │
│                                                                │
│  f(x)                              f'(x)                      │
│   ▲        ╱                        ▲                          │
│   │       ╱                         │  ────────  1             │
│   │      ╱                          │                          │
│   │     ╱                           │                          │
│   │    ╱                            │                          │
│   ├───●                             ├──●                       │
│   │   │                             │  │                       │
│   │   │                             │  │  0                    │
│   └───┴──────► x                    └──┴──────► x             │
│                                                                │
│  If x > 0: output = x        If x > 0: derivative = 1        │
│  If x ≤ 0: output = 0        If x ≤ 0: derivative = 0        │
│                                                                │
│  ✅ Fast, simple, works well   ❌ "Dead neurons" (always 0)   │
│  ✅ No vanishing gradient      Use: Hidden layers (DEFAULT)    │
└────────────────────────────────────────────────────────────────┘
```

### 2. Sigmoid

$$\sigma(x) = \frac{1}{1 + e^{-x}}$$

```
┌────────────────────────────────────────────────────────────────┐
│  SIGMOID GRAPH                     DERIVATIVE                  │
│                                                                │
│  f(x)                              f'(x)                      │
│  1.0 ┤         ────────             0.25 ┤       ╱╲            │
│      │       ╱                           │     ╱    ╲          │
│  0.5 ┤     ╱                             │   ╱        ╲        │
│      │   ╱                               │ ╱            ╲      │
│  0.0 ┤──╱                                ┤╱              ╲     │
│      └──────────────► x                  └──────────────► x   │
│                                                                │
│  Output: always between 0 and 1 (probability!)                │
│  σ'(x) = σ(x) × (1 - σ(x))                                  │
│                                                                │
│  ✅ Outputs probability         ❌ Vanishing gradient          │
│  ✅ Good for binary output      ❌ Outputs not zero-centered  │
│  Use: Output layer (binary classification)                     │
└────────────────────────────────────────────────────────────────┘
```

### 3. Tanh (Hyperbolic Tangent)

$$\tanh(x) = \frac{e^x - e^{-x}}{e^x + e^{-x}}$$

```
┌────────────────────────────────────────────────────────────────┐
│  TANH GRAPH                                                    │
│                                                                │
│  f(x)                                                          │
│  +1.0 ┤          ────────                                      │
│       │        ╱                                               │
│   0.0 ┤──────●───────                                          │
│       │    ╱                                                   │
│  -1.0 ┤──╱                                                     │
│       └──────────────────► x                                   │
│                                                                │
│  Output: between -1 and +1 (zero-centered!)                   │
│  tanh'(x) = 1 - tanh²(x)                                     │
│                                                                │
│  ✅ Zero-centered output        ❌ Still has vanishing gradient│
│  Use: Hidden layers (less common now, ReLU preferred)         │
└────────────────────────────────────────────────────────────────┘
```

### 4. Softmax (For Multi-Class Output)

$$\text{Softmax}(z_i) = \frac{e^{z_i}}{\sum_{j=1}^{C} e^{z_j}}$$

```
┌────────────────────────────────────────────────────────────────┐
│  SOFTMAX — Converts scores to probabilities                    │
│                                                                │
│  Raw scores (logits):     After Softmax:                      │
│  ┌─────────────────┐     ┌─────────────────┐                 │
│  │ Cat:   2.0      │     │ Cat:   0.659     │                 │
│  │ Dog:   1.0      │ ──▶ │ Dog:   0.243     │                 │
│  │ Bird:  0.5      │     │ Bird:  0.098     │                 │
│  └─────────────────┘     └─────────────────┘                 │
│                           Sum = 1.000 ✓                       │
│                                                                │
│  Calculation:                                                  │
│  e^2.0 = 7.389,  e^1.0 = 2.718,  e^0.5 = 1.649              │
│  Sum = 7.389 + 2.718 + 1.649 = 11.756                        │
│  Cat = 7.389/11.756 = 0.659                                  │
│                                                                │
│  Use: Output layer for MULTI-CLASS classification             │
└────────────────────────────────────────────────────────────────┘
```

### Activation Function Summary

| Function | Range | Use Case | Formula |
|----------|-------|----------|---------|
| **ReLU** | [0, ∞) | Hidden layers (default) | $\max(0, x)$ |
| **Leaky ReLU** | (-∞, ∞) | Hidden layers (fixes dead neurons) | $\max(0.01x, x)$ |
| **Sigmoid** | (0, 1) | Binary output layer | $\frac{1}{1+e^{-x}}$ |
| **Tanh** | (-1, 1) | Hidden layers (RNNs) | $\frac{e^x-e^{-x}}{e^x+e^{-x}}$ |
| **Softmax** | (0, 1), sum=1 | Multi-class output layer | $\frac{e^{z_i}}{\sum e^{z_j}}$ |

### Quick Decision Guide

```
┌────────────────────────────────────────────────────────────────┐
│  WHICH ACTIVATION TO USE?                                      │
│                                                                │
│  Hidden layers?                                                │
│  └── Use ReLU (default, fast, works well)                     │
│      └── If dead neurons → Leaky ReLU or ELU                 │
│                                                                │
│  Output layer?                                                 │
│  ├── Binary classification (0 or 1) → Sigmoid                │
│  ├── Multi-class (one of N) → Softmax                        │
│  └── Regression (any number) → None (Linear)                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 3.4 Loss Functions

### What is a Loss Function?

A loss function measures **how wrong** the model's prediction is. Training = minimizing this loss.

### Classification Losses

#### Binary Cross-Entropy (2 classes)

$$L = -\frac{1}{N}\sum_{i=1}^{N}\left[y_i \log(\hat{y}_i) + (1-y_i)\log(1-\hat{y}_i)\right]$$

```
Example:
  Actual: y = 1 (positive)
  Predicted: ŷ = 0.9 (90% confident positive)

  L = -[1×log(0.9) + 0×log(0.1)]
  L = -log(0.9) = 0.105  ← small loss (good!)

  If ŷ = 0.1 (bad prediction):
  L = -log(0.1) = 2.303  ← large loss (bad!)
```

#### Categorical Cross-Entropy (multi-class)

$$L = -\sum_{i=1}^{C} y_i \log(\hat{y}_i)$$

```
Example: 3 classes [Cat, Dog, Bird]
  Actual:    [1, 0, 0]  (Cat)
  Predicted: [0.7, 0.2, 0.1]

  L = -[1×log(0.7) + 0×log(0.2) + 0×log(0.1)]
  L = -log(0.7) = 0.357
```

### Regression Losses

| Loss | Formula | When to Use |
|------|---------|-------------|
| **MSE** | $\frac{1}{N}\sum(y-\hat{y})^2$ | General regression (penalizes outliers) |
| **MAE** | $\frac{1}{N}\sum\|y-\hat{y}\|$ | Robust to outliers |
| **Huber** | MSE if small error, MAE if large | Best of both |

### Loss Function Selection Guide

```
┌────────────────────────────────────────────────────────────────┐
│  CHOOSING A LOSS FUNCTION                                      │
│                                                                │
│  Binary classification     → binary_crossentropy               │
│  Multi-class (one-hot)     → categorical_crossentropy          │
│  Multi-class (integer)     → sparse_categorical_crossentropy   │
│  Regression                → mse (mean_squared_error)          │
│  Regression (with outliers)→ mae or huber                      │
└────────────────────────────────────────────────────────────────┘
```

---

## 3.5 Weight Initialization

### Why It Matters

```
┌────────────────────────────────────────────────────────────────┐
│  BAD INITIALIZATION:                                           │
│  • All zeros → all neurons learn the same thing (symmetry)    │
│  • Too large → exploding gradients (values blow up)           │
│  • Too small → vanishing gradients (learning stops)           │
│                                                                │
│  GOOD INITIALIZATION:                                          │
│  • Random values with proper scale                            │
│  • Depends on activation function                             │
└────────────────────────────────────────────────────────────────┘
```

| Method | Formula | Use With |
|--------|---------|----------|
| **Xavier/Glorot** | $W \sim \mathcal{N}(0, \frac{2}{n_{in}+n_{out}})$ | Sigmoid, Tanh |
| **He** | $W \sim \mathcal{N}(0, \frac{2}{n_{in}})$ | ReLU (default in Keras) |

---

## 3.6 Practice & Assessment

### MCQs

**Q1.** A perceptron can solve:
- A) XOR problem
- B) AND, OR (linearly separable problems)
- C) Any classification problem
- D) Only regression problems

**Answer:** B — Perceptrons can only solve linearly separable problems. XOR needs hidden layers.

---

**Q2.** Which activation function is the default choice for hidden layers?
- A) Sigmoid
- B) Softmax
- C) ReLU
- D) Tanh

**Answer:** C — ReLU is fast, simple, avoids vanishing gradient, and works well in practice.

---

**Q3.** For a 3-class classification output layer, use:
- A) ReLU
- B) Sigmoid
- C) Softmax
- D) Tanh

**Answer:** C — Softmax outputs probabilities summing to 1 for multi-class problems.

---

**Q4.** A network: Input(100) → Dense(64) → Dense(32) → Dense(1). Total parameters?
- A) 100×64 + 64 + 64×32 + 32 + 32×1 + 1 = 8,545
- B) 100 + 64 + 32 + 1 = 197
- C) 100×64×32×1 = 204,800
- D) 8,481

**Answer:** A — Layer 1: 6400+64=6464, Layer 2: 2048+32=2080, Layer 3: 32+1=33. Total = 8,577. (Calculate: 6464+2080+33 = 8,577)

---

### Coding Exercise

```python
"""
Exercise: Implement activation functions from scratch
"""
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(-5, 5, 100)

# Implement
relu = np.maximum(0, x)
sigmoid = 1 / (1 + np.exp(-x))
tanh = np.tanh(x)

# Softmax example
logits = np.array([2.0, 1.0, 0.5])
softmax = np.exp(logits) / np.sum(np.exp(logits))
print(f"Softmax: {softmax} (sum = {softmax.sum():.4f})")

# Plot all activations
fig, axes = plt.subplots(1, 3, figsize=(15, 4))

axes[0].plot(x, relu, 'b-', linewidth=2)
axes[0].set_title('ReLU'); axes[0].grid(True); axes[0].axhline(0, color='k', lw=0.5)

axes[1].plot(x, sigmoid, 'r-', linewidth=2)
axes[1].set_title('Sigmoid'); axes[1].grid(True); axes[1].axhline(0.5, color='k', lw=0.5, ls='--')

axes[2].plot(x, tanh, 'g-', linewidth=2)
axes[2].set_title('Tanh'); axes[2].grid(True); axes[2].axhline(0, color='k', lw=0.5)

plt.tight_layout()
plt.show()
```

---

> **Next Topic:** [04 - Forward & Backpropagation](04-forward-backpropagation.md)
