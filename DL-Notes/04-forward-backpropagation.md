# 04. Forward & Backpropagation (Step-by-Step)

## Table of Contents
- [4.1 Forward Propagation](#41-forward-propagation)
- [4.2 Loss Calculation](#42-loss-calculation)
- [4.3 Backpropagation](#43-backpropagation)
- [4.4 Complete Dry Run](#44-complete-dry-run)
- [4.5 Gradient Descent Weight Update](#45-gradient-descent-weight-update)
- [4.6 Python From Scratch](#46-python-from-scratch)
- [4.7 Practice & Assessment](#47-practice--assessment)

---

## 4.1 Forward Propagation

### Definition
**Forward propagation** is passing input data through the network **layer by layer** to get a prediction. Each layer computes: $a = f(Wx + b)$

```
┌────────────────────────────────────────────────────────────────────────┐
│  FORWARD PROPAGATION FLOW                                              │
│                                                                        │
│  Input (x)                                                            │
│    │                                                                   │
│    ▼                                                                   │
│  ┌──────────────────────────────────────┐                             │
│  │ Layer 1: z₁ = W₁·x + b₁            │                             │
│  │          a₁ = activation(z₁)         │  ← Hidden Layer 1          │
│  └──────────────┬───────────────────────┘                             │
│                 │                                                      │
│                 ▼                                                      │
│  ┌──────────────────────────────────────┐                             │
│  │ Layer 2: z₂ = W₂·a₁ + b₂           │                             │
│  │          a₂ = activation(z₂)         │  ← Hidden Layer 2          │
│  └──────────────┬───────────────────────┘                             │
│                 │                                                      │
│                 ▼                                                      │
│  ┌──────────────────────────────────────┐                             │
│  │ Output: z₃ = W₃·a₂ + b₃            │                             │
│  │         ŷ  = sigmoid(z₃)            │  ← Output Layer            │
│  └──────────────┬───────────────────────┘                             │
│                 │                                                      │
│                 ▼                                                      │
│             Prediction (ŷ)                                            │
│                 │                                                      │
│                 ▼                                                      │
│          Loss = L(y, ŷ)  ← Compare with true label                   │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 4.2 Loss Calculation

After forward pass, compute **how wrong** the prediction is:

$$L = -[y \cdot \log(\hat{y}) + (1-y) \cdot \log(1-\hat{y})]$$

---

## 4.3 Backpropagation

### Definition
**Backpropagation** computes the gradient of the loss with respect to **every weight** in the network, using the **chain rule**, working **backwards** from output to input.

```
┌────────────────────────────────────────────────────────────────────────┐
│  BACKPROPAGATION FLOW (Reverse Direction!)                             │
│                                                                        │
│  Input (x)         Hidden           Output          Loss              │
│    │                 │                 │               │               │
│    │     ┌───────────┤     ┌──────────┤     ┌────────┤               │
│    │     │           │     │          │     │        │               │
│    │     │  FORWARD  │     │ FORWARD  │     │        │               │
│    │  ──▶│  ──────▶  │  ──▶│ ──────▶  │  ──▶│  L     │               │
│    │     │           │     │          │     │        │               │
│    │     │           │     │          │     │        │               │
│    │     │  BACKWARD │     │ BACKWARD │     │        │               │
│    │  ◀──│  ◀──────  │  ◀──│ ◀──────  │  ◀──│  ∂L    │               │
│    │     │  ∂L/∂W₁   │     │ ∂L/∂W₂   │     │  ∂ŷ    │               │
│    │     └───────────┤     └──────────┤     └────────┤               │
│                                                                        │
│  Chain Rule: ∂L/∂W₁ = ∂L/∂ŷ × ∂ŷ/∂a₂ × ∂a₂/∂z₂ × ∂z₂/∂a₁ × ...  │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 4.4 Complete Dry Run

### Network Setup

```
Simple network: 2 inputs → 2 hidden neurons → 1 output

       x₁ ──w₁──┐   ┌──w₅──┐
                 h₁──┤      │
       x₂ ──w₂──┘   │      ├── o₁ → ŷ
                     │      │
       x₁ ──w₃──┐   └──w₆──┘
                 h₂──┘
       x₂ ──w₄──┘

  Activation: sigmoid everywhere
  Loss: binary cross-entropy

  Initial values:
  x₁ = 0.5,  x₂ = 0.3
  w₁ = 0.1,  w₂ = 0.2,  w₃ = 0.3,  w₄ = 0.4
  w₅ = 0.5,  w₆ = 0.6
  b₁ = 0.1,  b₂ = 0.1,  b₃ = 0.1
  y = 1 (true label)
```

### Step 1: Forward Pass

```
HIDDEN LAYER:
  h₁_in = w₁·x₁ + w₂·x₂ + b₁
        = 0.1(0.5) + 0.2(0.3) + 0.1
        = 0.05 + 0.06 + 0.1 = 0.21

  h₁_out = σ(0.21) = 1/(1+e^(-0.21)) = 0.5523

  h₂_in = w₃·x₁ + w₄·x₂ + b₂
        = 0.3(0.5) + 0.4(0.3) + 0.1
        = 0.15 + 0.12 + 0.1 = 0.37

  h₂_out = σ(0.37) = 1/(1+e^(-0.37)) = 0.5914

OUTPUT LAYER:
  o₁_in = w₅·h₁_out + w₆·h₂_out + b₃
        = 0.5(0.5523) + 0.6(0.5914) + 0.1
        = 0.2762 + 0.3548 + 0.1 = 0.7310

  ŷ = σ(0.7310) = 1/(1+e^(-0.7310)) = 0.6748
```

### Step 2: Calculate Loss

```
  L = -[y·log(ŷ) + (1-y)·log(1-ŷ)]
    = -[1·log(0.6748) + 0·log(0.3252)]
    = -log(0.6748)
    = 0.3934
```

### Step 3: Backpropagation (Calculate Gradients)

```
OUTPUT LAYER GRADIENTS:

  ∂L/∂ŷ = -y/ŷ + (1-y)/(1-ŷ)
         = -1/0.6748 + 0
         = -1.4820

  ∂ŷ/∂o₁_in = ŷ(1-ŷ) = 0.6748 × 0.3252 = 0.2194

  δ_output = ∂L/∂o₁_in = ∂L/∂ŷ × ∂ŷ/∂o₁_in
           = -1.4820 × 0.2194 = -0.3252

  (Note: For sigmoid + cross-entropy, this simplifies to: ŷ - y = 0.6748 - 1 = -0.3252)

  ∂L/∂w₅ = δ_output × h₁_out = -0.3252 × 0.5523 = -0.1796
  ∂L/∂w₆ = δ_output × h₂_out = -0.3252 × 0.5914 = -0.1923
  ∂L/∂b₃ = δ_output = -0.3252

HIDDEN LAYER GRADIENTS (Chain Rule continues!):

  δ_h₁ = δ_output × w₅ × h₁_out(1-h₁_out)
       = -0.3252 × 0.5 × 0.5523 × 0.4477
       = -0.3252 × 0.5 × 0.2473
       = -0.0402

  ∂L/∂w₁ = δ_h₁ × x₁ = -0.0402 × 0.5 = -0.0201
  ∂L/∂w₂ = δ_h₁ × x₂ = -0.0402 × 0.3 = -0.0121

  δ_h₂ = δ_output × w₆ × h₂_out(1-h₂_out)
       = -0.3252 × 0.6 × 0.5914 × 0.4086
       = -0.3252 × 0.6 × 0.2417
       = -0.0472

  ∂L/∂w₃ = δ_h₂ × x₁ = -0.0472 × 0.5 = -0.0236
  ∂L/∂w₄ = δ_h₂ × x₂ = -0.0472 × 0.3 = -0.0142
```

### Step 4: Update Weights

```
Learning rate: η = 0.5

w₁_new = w₁ - η × ∂L/∂w₁ = 0.1 - 0.5(-0.0201) = 0.1101
w₂_new = w₂ - η × ∂L/∂w₂ = 0.2 - 0.5(-0.0121) = 0.2060
w₃_new = w₃ - η × ∂L/∂w₃ = 0.3 - 0.5(-0.0236) = 0.3118
w₄_new = w₄ - η × ∂L/∂w₄ = 0.4 - 0.5(-0.0142) = 0.4071
w₅_new = w₅ - η × ∂L/∂w₅ = 0.5 - 0.5(-0.1796) = 0.5898
w₆_new = w₆ - η × ∂L/∂w₆ = 0.6 - 0.5(-0.1923) = 0.6962

All weights moved toward the correct direction!
Next forward pass will give a prediction CLOSER to y=1.
```

---

## 4.5 Gradient Descent Weight Update

$$w_{new} = w_{old} - \eta \cdot \frac{\partial L}{\partial w}$$

```
┌────────────────────────────────────────────────────────────────┐
│  GRADIENT DESCENT — Finding the Minimum                        │
│                                                                │
│  Loss                                                          │
│   ▲                                                            │
│   │    ╱╲                                                      │
│   │   ╱  ╲                                                     │
│   │  ╱    ╲  ● w₀ (initial)                                   │
│   │ ╱      ╲ │                                                 │
│   │╱        ╲▼ gradient points downhill                       │
│   │          ╲                                                 │
│   │           ╲● w₁ (after 1 update)                          │
│   │            ╲                                               │
│   │             ● w₂ (after 2 updates)                        │
│   │              ╲                                             │
│   │               ●  w* (minimum — optimal!)                  │
│   └──────────────────────────────────────► w                   │
│                                                                │
│  Learning Rate (η):                                            │
│  • Too small: converges very slowly                           │
│  • Too large: overshoots, may diverge!                        │
│  • Just right: converges efficiently                          │
│                                                                │
│  η too small:  ●..●..●..●..●..●..●..●..●..● (slow!)         │
│  η just right: ●....●.....●......● (good!)                   │
│  η too large:  ●..........●...........● ↗ (diverges!)       │
└────────────────────────────────────────────────────────────────┘
```

---

## 4.6 Python From Scratch

```python
"""
Complete Forward + Backward Pass from Scratch
A 2-input → 2-hidden → 1-output network
"""
import numpy as np

# Sigmoid and its derivative
def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def sigmoid_derivative(x):
    s = sigmoid(x)
    return s * (1 - s)

# --- NETWORK SETUP ---
np.random.seed(42)

# Training data (XOR problem)
X = np.array([[0,0], [0,1], [1,0], [1,1]])
y = np.array([[0], [1], [1], [0]])

# Initialize weights randomly
w_hidden = np.random.randn(2, 4) * 0.5   # 2 inputs → 4 hidden neurons
b_hidden = np.zeros((1, 4))
w_output = np.random.randn(4, 1) * 0.5   # 4 hidden → 1 output
b_output = np.zeros((1, 1))

learning_rate = 1.0
epochs = 10000

# --- TRAINING LOOP ---
losses = []
for epoch in range(epochs):

    # ===== FORWARD PASS =====
    z_hidden = np.dot(X, w_hidden) + b_hidden      # (4, 4)
    a_hidden = sigmoid(z_hidden)                     # (4, 4)

    z_output = np.dot(a_hidden, w_output) + b_output # (4, 1)
    a_output = sigmoid(z_output)                      # (4, 1) = ŷ

    # ===== LOSS =====
    loss = -np.mean(y * np.log(a_output + 1e-8) +
                    (1 - y) * np.log(1 - a_output + 1e-8))
    losses.append(loss)

    # ===== BACKWARD PASS =====
    # Output layer gradients
    d_output = a_output - y                                     # (4, 1)
    dw_output = np.dot(a_hidden.T, d_output) / len(X)          # (4, 1)
    db_output = np.mean(d_output, axis=0, keepdims=True)        # (1, 1)

    # Hidden layer gradients (chain rule!)
    d_hidden = np.dot(d_output, w_output.T) * sigmoid_derivative(z_hidden)  # (4, 4)
    dw_hidden = np.dot(X.T, d_hidden) / len(X)                              # (2, 4)
    db_hidden = np.mean(d_hidden, axis=0, keepdims=True)                     # (1, 4)

    # ===== UPDATE WEIGHTS =====
    w_output -= learning_rate * dw_output
    b_output -= learning_rate * db_output
    w_hidden -= learning_rate * dw_hidden
    b_hidden -= learning_rate * db_hidden

    if epoch % 2000 == 0:
        print(f"Epoch {epoch:>5}: Loss = {loss:.4f}")

# --- TEST ---
print("\nFinal Predictions:")
for i in range(len(X)):
    print(f"  Input: {X[i]} → Predicted: {a_output[i][0]:.4f}, Actual: {y[i][0]}")

# Plot loss
import matplotlib.pyplot as plt
plt.plot(losses)
plt.xlabel('Epoch'); plt.ylabel('Loss')
plt.title('Training Loss (XOR Network from Scratch)')
plt.show()
```

**Expected Output:**
```
Epoch     0: Loss = 0.7154
Epoch  2000: Loss = 0.0934
Epoch  4000: Loss = 0.0215
Epoch  6000: Loss = 0.0113
Epoch  8000: Loss = 0.0074

Final Predictions:
  Input: [0 0] → Predicted: 0.0102, Actual: 0
  Input: [0 1] → Predicted: 0.9876, Actual: 1
  Input: [1 0] → Predicted: 0.9881, Actual: 1
  Input: [1 1] → Predicted: 0.0157, Actual: 0
```

---

## 4.7 Practice & Assessment

### MCQs

**Q1.** Forward propagation computes:
- A) Gradients
- B) The prediction (output) from input
- C) The optimal learning rate
- D) Feature importance

**Answer:** B — Forward pass takes input through layers to produce a prediction.

---

**Q2.** Backpropagation uses which calculus rule?
- A) Product rule
- B) Quotient rule
- C) Chain rule
- D) Power rule

**Answer:** C — Chain rule lets us compute gradients through multiple composed layers.

---

**Q3.** If the loss is decreasing, it means:
- A) The model is overfitting
- B) The model's predictions are getting closer to actual values
- C) The learning rate is too high
- D) We need more layers

**Answer:** B — Decreasing loss = model is learning, predictions are improving.

---

**Q4.** What happens if the learning rate is too large?
- A) Training is slow
- B) The loss oscillates or diverges
- C) Perfect convergence
- D) No effect

**Answer:** B — Too large a learning rate causes the optimization to overshoot the minimum.

---

> **Next Topic:** [05 - TensorFlow & Keras](05-tensorflow-keras.md)
