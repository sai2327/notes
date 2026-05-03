# 02. Mathematical Foundations for Deep Learning

## Table of Contents
- [2.1 Why Math for Deep Learning?](#21-why-math-for-deep-learning)
- [2.2 Linear Algebra](#22-linear-algebra)
- [2.3 Calculus Basics](#23-calculus-basics)
- [2.4 Probability Basics](#24-probability-basics)
- [2.5 Putting It All Together](#25-putting-it-all-together)
- [2.6 Practice & Assessment](#26-practice--assessment)

---

## 2.1 Why Math for Deep Learning?

```
┌────────────────────────────────────────────────────────────────┐
│  MATH IN DEEP LEARNING                                         │
│                                                                │
│  Linear Algebra → Data representation & transformations       │
│                   (inputs, weights, layers are MATRICES)       │
│                                                                │
│  Calculus       → Learning (how to update weights)            │
│                   (gradients, backpropagation)                 │
│                                                                │
│  Probability    → Predictions & uncertainty                   │
│                   (softmax outputs, loss functions)            │
│                                                                │
│  You don't need a PhD — just intuition of these concepts!     │
└────────────────────────────────────────────────────────────────┘
```

---

## 2.2 Linear Algebra

### Scalars, Vectors, Matrices, Tensors

```
┌────────────────────────────────────────────────────────────────────┐
│  DATA STRUCTURES IN DL                                             │
│                                                                    │
│  SCALAR (0D):     5                    → single number            │
│                                                                    │
│  VECTOR (1D):     [1, 2, 3]            → list of numbers          │
│                                         → 1 data point's features │
│                                                                    │
│  MATRIX (2D):     ┌ 1  2  3 ┐          → table of numbers         │
│                   │ 4  5  6 │          → batch of data points     │
│                   └ 7  8  9 ┘          → layer weights            │
│                                                                    │
│  TENSOR (nD):     3D, 4D, 5D...        → multi-dimensional array  │
│                                         → images = 4D tensor      │
│                   ┌─────────┐                                      │
│                   │┌────────┤           → (batch, height,          │
│                   ││┌───────┤              width, channels)        │
│                   │││ image │                                      │
│                   │││ data  │                                      │
│                   └┘┘───────┘                                      │
└────────────────────────────────────────────────────────────────────┘
```

### Tensor Shapes in Deep Learning

| Data Type | Shape | Example |
|-----------|-------|---------|
| Single number | `()` or scalar | Loss value: 0.5 |
| 1D feature vector | `(n,)` | `[age, income, score]` → (3,) |
| Batch of data | `(batch, features)` | 32 samples, 10 features → (32, 10) |
| Grayscale image | `(H, W)` | 28×28 pixels → (28, 28) |
| Color image | `(H, W, C)` | 224×224 RGB → (224, 224, 3) |
| Batch of images | `(batch, H, W, C)` | 32 images → (32, 224, 224, 3) |
| Text sequence | `(batch, seq_len)` | 16 sentences of 100 words → (16, 100) |

```python
import numpy as np

scalar = np.array(5)                         # shape: ()
vector = np.array([1, 2, 3])                 # shape: (3,)
matrix = np.array([[1,2], [3,4], [5,6]])     # shape: (3, 2)
tensor_3d = np.random.randn(32, 28, 28)      # shape: (32, 28, 28)
tensor_4d = np.random.randn(32, 224, 224, 3) # shape: (32, 224, 224, 3)

print(f"Scalar: {scalar.shape}, ndim={scalar.ndim}")
print(f"Vector: {vector.shape}, ndim={vector.ndim}")
print(f"Matrix: {matrix.shape}, ndim={matrix.ndim}")
print(f"3D Tensor: {tensor_3d.shape}, ndim={tensor_3d.ndim}")
print(f"4D Tensor: {tensor_4d.shape}, ndim={tensor_4d.ndim}")
```

### Matrix Operations

#### Dot Product (Most Important!)

$$\mathbf{a} \cdot \mathbf{b} = \sum_{i=1}^{n} a_i b_i$$

```
┌────────────────────────────────────────────────────────────────┐
│  DOT PRODUCT — The Core of Neural Networks                     │
│                                                                │
│  inputs × weights = weighted sum                               │
│                                                                │
│  [x₁, x₂, x₃] · [w₁, w₂, w₃] = x₁w₁ + x₂w₂ + x₃w₃       │
│  [2, 3, 1]     · [0.5, -1, 2]  = 2(0.5) + 3(-1) + 1(2)     │
│                                = 1 + (-3) + 2                 │
│                                = 0                             │
│                                                                │
│  This is EXACTLY what a neuron does!                           │
└────────────────────────────────────────────────────────────────┘
```

#### Matrix Multiplication

$$C = A \times B \quad \text{where } C_{ij} = \sum_k A_{ik} B_{kj}$$

```
Rule: (m × n) × (n × p) = (m × p)
      Inner dimensions MUST match!

Example:
  ┌ 1  2 ┐     ┌ 5  6 ┐     ┌ 1×5+2×7  1×6+2×8 ┐     ┌ 19  22 ┐
  │ 3  4 │  ×  │ 7  8 │  =  │ 3×5+4×7  3×6+4×8 │  =  │ 43  50 │
  └      ┘     └      ┘     └                    ┘     └        ┘
  (2 × 2)      (2 × 2)           (2 × 2)

In a Neural Network Layer:
  output = input × weights + bias
  (32, 10) × (10, 64) + (64,) = (32, 64)
   ↑batch    ↑layer weights      ↑output
```

```python
import numpy as np

# Simulate a neural network layer
batch_input = np.random.randn(32, 10)    # 32 samples, 10 features
weights = np.random.randn(10, 64)         # 10 inputs → 64 neurons
bias = np.random.randn(64)                # 64 biases

output = np.dot(batch_input, weights) + bias  # (32, 64)
print(f"Input: {batch_input.shape} → Output: {output.shape}")
```

### Transpose

$$A^T_{ij} = A_{ji}$$

```
┌ 1  2  3 ┐  T    ┌ 1  4 ┐
│ 4  5  6 │  ──▶  │ 2  5 │
└         ┘       │ 3  6 │
(2 × 3)           └     ┘
                  (3 × 2)
```

---

## 2.3 Calculus Basics

### Derivatives — The Key to Learning

> **Definition:** A derivative tells you how much the output changes when you slightly change the input.

$$f'(x) = \frac{df}{dx} = \lim_{h \to 0} \frac{f(x+h) - f(x)}{h}$$

```
┌────────────────────────────────────────────────────────────────┐
│  DERIVATIVE = SLOPE OF THE CURVE                               │
│                                                                │
│  f(x)                                                          │
│   ▲         ╱                                                  │
│   │       ╱    slope = derivative = how steep?                 │
│   │     ╱╱                                                     │
│   │   ╱╱   ← steep = large derivative                        │
│   │  ╱                                                         │
│   │╱╱╱╱╱╱   ← flat = small derivative                        │
│   └────────────────────► x                                     │
│                                                                │
│  In DL: derivative tells us how to adjust weights!            │
│  • Large derivative → big weight update                       │
│  • Small derivative → small weight update                     │
│  • Zero derivative → we're at minimum (or maximum)           │
└────────────────────────────────────────────────────────────────┘
```

### Common Derivatives Used in DL

| Function $f(x)$ | Derivative $f'(x)$ | Used In |
|------------------|---------------------|---------|
| $x^n$ | $nx^{n-1}$ | Polynomial layers |
| $e^x$ | $e^x$ | Softmax, sigmoid |
| $\ln(x)$ | $1/x$ | Log loss |
| $\sigma(x) = \frac{1}{1+e^{-x}}$ | $\sigma(x)(1-\sigma(x))$ | Sigmoid activation |
| $\tanh(x)$ | $1 - \tanh^2(x)$ | Tanh activation |
| $\text{ReLU}(x) = \max(0,x)$ | $\begin{cases} 1 & x > 0 \\ 0 & x \leq 0 \end{cases}$ | ReLU activation |

### Chain Rule (Heart of Backpropagation)

$$\frac{dz}{dx} = \frac{dz}{dy} \times \frac{dy}{dx}$$

```
┌────────────────────────────────────────────────────────────────┐
│  CHAIN RULE EXAMPLE                                            │
│                                                                │
│  z = (2x + 1)²                                                │
│                                                                │
│  Let y = 2x + 1,  then z = y²                                │
│                                                                │
│  dz/dy = 2y        (outer derivative)                         │
│  dy/dx = 2         (inner derivative)                         │
│                                                                │
│  dz/dx = dz/dy × dy/dx = 2y × 2 = 2(2x+1) × 2 = 4(2x+1)   │
│                                                                │
│  At x = 1:  dz/dx = 4(2×1+1) = 4(3) = 12                    │
│                                                                │
│  IN NEURAL NETWORKS:                                           │
│  x ──▶ Layer 1 ──▶ Layer 2 ──▶ Loss                          │
│                                                                │
│  dLoss/dx = dLoss/dLayer2 × dLayer2/dLayer1 × dLayer1/dx     │
│             (chain rule through ALL layers = backpropagation)  │
└────────────────────────────────────────────────────────────────┘
```

### Gradient — Multi-Variable Derivative

$$\nabla f = \left[\frac{\partial f}{\partial x_1}, \frac{\partial f}{\partial x_2}, \ldots, \frac{\partial f}{\partial x_n}\right]$$

```
┌────────────────────────────────────────────────────────────────┐
│  GRADIENT DESCENT VISUALIZATION                                │
│                                                                │
│  Loss                                                          │
│   ▲                                                            │
│   │    ╱╲                                                      │
│   │   ╱  ╲        ← Start here (random weights)              │
│   │  ╱    ╲  ●                                                │
│   │ ╱      ╲ │ ← gradient points DOWNHILL                    │
│   │╱        ╲▼                                                │
│   │          ╲                                                 │
│   │           ╲● ← step toward minimum                       │
│   │            ╲                                               │
│   │             ●  ← minimum (optimal weights!)              │
│   └──────────────────────────────► weights                     │
│                                                                │
│  w_new = w_old - learning_rate × gradient                     │
│  (move in opposite direction of gradient)                      │
└────────────────────────────────────────────────────────────────┘
```

---

## 2.4 Probability Basics

### Why Probability in DL?

Neural network outputs are often **probabilities**:

```
┌────────────────────────────────────────────────────────────────┐
│  CLASSIFICATION OUTPUT                                         │
│                                                                │
│  Image → Neural Network → Probabilities:                      │
│                            Cat:  0.85  (85%)                  │
│                            Dog:  0.10  (10%)                  │
│                            Bird: 0.05  (5%)                   │
│                            ─────────────────                   │
│                            Sum:  1.00  (100%)                 │
│                                                                │
│  Prediction: Cat (highest probability)                        │
│  Softmax function produces these probabilities!               │
└────────────────────────────────────────────────────────────────┘
```

### Key Probability Concepts

| Concept | Formula | DL Usage |
|---------|---------|----------|
| **Probability** | $P(A)$ between 0 and 1 | Output layer predictions |
| **Conditional** | $P(A\|B)$ | "Probability of cat given this image" |
| **Bayes' Theorem** | $P(A\|B) = \frac{P(B\|A)P(A)}{P(B)}$ | Probabilistic models |
| **Expected Value** | $E[X] = \sum x_i P(x_i)$ | Loss function computation |
| **Cross-Entropy** | $-\sum y \log(\hat{y})$ | **THE** classification loss function |

### Cross-Entropy Loss (Most Important!)

$$\text{Cross-Entropy} = -\sum_{i=1}^{C} y_i \log(\hat{y}_i)$$

```
For binary classification (2 classes):
  L = -[y·log(ŷ) + (1-y)·log(1-ŷ)]

Example:
  Actual: Cat (y = 1)
  Predicted: P(Cat) = 0.9

  L = -[1·log(0.9) + 0·log(0.1)]
  L = -log(0.9)
  L = 0.105  ← small loss (good prediction!)

  If P(Cat) = 0.1 (bad prediction):
  L = -log(0.1) = 2.303  ← large loss (bad!)
```

---

## 2.5 Putting It All Together

```
┌────────────────────────────────────────────────────────────────────┐
│  HOW MATH CONNECTS IN A NEURAL NETWORK                             │
│                                                                    │
│  1. INPUT (Linear Algebra)                                        │
│     X = batch of data as a MATRIX                                 │
│                                                                    │
│  2. FORWARD PASS (Linear Algebra + Functions)                     │
│     z = X · W + b                (matrix multiplication)          │
│     a = activation(z)            (non-linear function)            │
│                                                                    │
│  3. LOSS CALCULATION (Probability)                                │
│     L = cross_entropy(y, ŷ)      (probability-based loss)        │
│                                                                    │
│  4. BACKPROPAGATION (Calculus)                                    │
│     ∂L/∂W = chain rule through all layers  (gradients)           │
│                                                                    │
│  5. WEIGHT UPDATE (Calculus + Linear Algebra)                     │
│     W = W - lr × ∂L/∂W          (gradient descent)              │
│                                                                    │
│  → REPEAT until loss converges                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## 2.6 Practice & Assessment

### MCQs

**Q1.** A batch of 64 color images (32×32 pixels) has shape:
- A) (64, 32, 32)
- B) (64, 32, 32, 3)
- C) (32, 32, 3, 64)
- D) (64, 3, 32, 32)

**Answer:** B — TensorFlow uses (batch, height, width, channels). 3 channels for RGB.

---

**Q2.** The chain rule is essential for:
- A) Data preprocessing
- B) Backpropagation (calculating gradients through layers)
- C) Data augmentation
- D) Feature engineering

**Answer:** B — Backpropagation uses the chain rule to compute gradients layer by layer.

---

**Q3.** Cross-entropy loss is small when:
- A) The prediction is wrong
- B) The prediction is confident and correct
- C) All probabilities are equal
- D) The learning rate is high

**Answer:** B — $-\log(0.95) = 0.05$ (small loss for high-confidence correct prediction).

---

**Q4.** Matrix multiplication (2,5) × (5,3) gives shape:
- A) (5, 5)
- B) (2, 5)
- C) (2, 3)
- D) (3, 2)

**Answer:** C — (m×n) × (n×p) = (m×p), so (2×5) × (5×3) = (2×3).

---

### Coding Exercise

```python
"""
Exercise: Simulate a single neuron manually
"""
import numpy as np

# Inputs (3 features)
x = np.array([2.0, 3.0, 1.0])

# Weights and bias (randomly initialized)
w = np.array([0.5, -1.0, 2.0])
b = 0.1

# Step 1: Weighted sum
z = np.dot(x, w) + b
print(f"Weighted sum: z = {z}")

# Step 2: Sigmoid activation
sigmoid = 1 / (1 + np.exp(-z))
print(f"Sigmoid output: σ(z) = {sigmoid:.4f}")

# Step 3: If true label y=1, calculate cross-entropy loss
y = 1
loss = -(y * np.log(sigmoid) + (1 - y) * np.log(1 - sigmoid))
print(f"Cross-entropy loss: L = {loss:.4f}")
```

---

> **Next Topic:** [03 - Neural Networks (Detailed)](03-neural-networks.md)
