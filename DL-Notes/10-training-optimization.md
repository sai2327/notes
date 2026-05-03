# 10. Training Deep Networks — Optimization

## Table of Contents
- [10.1 Gradient Descent Variants](#101-gradient-descent-variants)
- [10.2 Optimization Algorithms](#102-optimization-algorithms)
- [10.3 Learning Rate](#103-learning-rate)
- [10.4 Batch Size and Epochs](#104-batch-size-and-epochs)
- [10.5 Python Implementation](#105-python-implementation)
- [10.6 Practice & Assessment](#106-practice--assessment)

---

## 10.1 Gradient Descent Variants

### Three Types

```
┌────────────────────────────────────────────────────────────────────┐
│  GRADIENT DESCENT TYPES                                            │
│                                                                    │
│  Dataset: 10,000 samples                                         │
│                                                                    │
│  1. BATCH GD: Use ALL 10,000 samples → 1 update per epoch       │
│     ✅ Stable, smooth convergence                                  │
│     ❌ Very slow, needs all data in memory                        │
│                                                                    │
│  2. STOCHASTIC GD (SGD): Use 1 sample → 1 update per sample     │
│     ✅ Fast updates, can escape local minima                      │
│     ❌ Very noisy, oscillates a lot                               │
│                                                                    │
│  3. MINI-BATCH GD: Use 32-256 samples → 1 update per batch      │
│     ✅ Best of both! Fast + stable                                │
│     ✅ Fits GPU memory (parallel computation)                     │
│     → THIS IS WHAT WE ACTUALLY USE!                               │
│                                                                    │
│  Loss curve comparison:                                            │
│  Batch GD:     ╲                                                   │
│                  ╲╲_____ (smooth)                                  │
│  SGD:          ╱╲╱╲╱╲___  (very noisy)                            │
│  Mini-batch:   ╱╲╱╲____ (slightly noisy, good!)                  │
└────────────────────────────────────────────────────────────────────┘
```

---

## 10.2 Optimization Algorithms

### SGD (Stochastic Gradient Descent)

$$w = w - \eta \cdot \nabla L$$

Basic: just follow the gradient. Can get stuck in local minima.

### SGD with Momentum

$$v_t = \beta \cdot v_{t-1} + \eta \cdot \nabla L$$
$$w = w - v_t$$

```
┌────────────────────────────────────────────────────────────────┐
│  MOMENTUM — Like a ball rolling downhill                       │
│                                                                │
│  Without momentum:        With momentum:                      │
│  ●                        ●                                    │
│  │╲                       │╲                                   │
│  │  ╲  ╱╲                 │  ╲╲╲                               │
│  │   ╲╱  ╲  ← stuck!     │    ╲╲╲╲╲● ← builds speed,        │
│  │        ╲               │          rolls past bumps!        │
│  │         ●              │                                    │
│                                                                │
│  β = 0.9 (typical): keeps 90% of previous velocity           │
│  Helps: faster convergence, escapes local minima              │
└────────────────────────────────────────────────────────────────┘
```

### RMSprop (Root Mean Square Propagation)

$$s_t = \beta \cdot s_{t-1} + (1-\beta) \cdot (\nabla L)^2$$
$$w = w - \frac{\eta}{\sqrt{s_t + \epsilon}} \cdot \nabla L$$

Adapts learning rate per parameter: larger gradient → smaller step.

### Adam (Adaptive Moment Estimation) — THE DEFAULT

Combines **Momentum + RMSprop**: tracks both first moment (mean) and second moment (variance) of gradients.

$$m_t = \beta_1 \cdot m_{t-1} + (1-\beta_1) \cdot \nabla L \quad \text{(momentum)}$$
$$v_t = \beta_2 \cdot v_{t-1} + (1-\beta_2) \cdot (\nabla L)^2 \quad \text{(RMSprop)}$$
$$\hat{m}_t = \frac{m_t}{1-\beta_1^t}, \quad \hat{v}_t = \frac{v_t}{1-\beta_2^t} \quad \text{(bias correction)}$$
$$w = w - \frac{\eta}{\sqrt{\hat{v}_t} + \epsilon} \cdot \hat{m}_t$$

Default hyperparameters: $\beta_1 = 0.9$, $\beta_2 = 0.999$, $\epsilon = 10^{-7}$

### Optimizer Comparison

| Optimizer | Key Idea | Speed | When to Use |
|-----------|----------|-------|-------------|
| **SGD** | Basic gradient descent | Slow | Fine-tuning, simple problems |
| **SGD + Momentum** | Adds velocity | Faster | Computer vision tasks |
| **RMSprop** | Adaptive per-param LR | Fast | RNNs, non-stationary |
| **Adam** | Momentum + RMSprop | Fast | DEFAULT for most problems |
| **AdamW** | Adam + weight decay | Fast | Transformers, BERT fine-tuning |

```
┌────────────────────────────────────────────────────────────────┐
│  OPTIMIZER RECOMMENDATION:                                     │
│                                                                │
│  Don't know what to use?  → Adam (lr=0.001)                  │
│  Training Transformers?   → AdamW                             │
│  Fine-tuning pre-trained? → SGD (lr=0.01, momentum=0.9)     │
│  Simple problems?         → SGD with momentum                │
└────────────────────────────────────────────────────────────────┘
```

---

## 10.3 Learning Rate

### The Most Important Hyperparameter

```
┌────────────────────────────────────────────────────────────────┐
│  LEARNING RATE EFFECT                                          │
│                                                                │
│  Too Small (0.0001):       Just Right (0.001):                │
│  Loss                      Loss                               │
│   │╲                        │╲                                 │
│   │ ╲                       │ ╲                                │
│   │  ╲                      │  ╲╲                              │
│   │   ╲                     │    ╲╲___                         │
│   │    ╲                    │         ╲___●                    │
│   │     ╲...still going     └─────────────                     │
│   Converges eventually       Converges fast!                   │
│                                                                │
│  Too Large (0.1):          Way Too Large (1.0):               │
│  Loss                      Loss                               │
│   │  ╱╲ ╱╲                  │   ╱╲                             │
│   │ ╱  ╳  ╲                 │  ╱  ╲ ╱                         │
│   │╱  ╱ ╲  ╲               │ ╱    ╳   ╱                      │
│   │  ╱   ╲                  │╱    ╱ ╲ ╱  → DIVERGES!         │
│   Oscillates                 Never converges                   │
│                                                                │
│  Typical starting values:                                      │
│  Adam:  0.001 (default, usually works)                        │
│  SGD:   0.01 - 0.1                                            │
└────────────────────────────────────────────────────────────────┘
```

### Learning Rate Schedules

```python
import tensorflow as tf

# 1. Step Decay: Reduce by factor every N epochs
lr_schedule = tf.keras.optimizers.schedules.ExponentialDecay(
    initial_learning_rate=0.001,
    decay_steps=1000,
    decay_rate=0.9
)

# 2. ReduceLROnPlateau: Reduce when stuck
callback = tf.keras.callbacks.ReduceLROnPlateau(
    monitor='val_loss', factor=0.5, patience=5, min_lr=1e-6
)

# 3. Cosine Annealing
lr_schedule = tf.keras.optimizers.schedules.CosineDecay(
    initial_learning_rate=0.001,
    decay_steps=10000
)

# Use with optimizer
optimizer = tf.keras.optimizers.Adam(learning_rate=lr_schedule)
```

---

## 10.4 Batch Size and Epochs

### Batch Size

| Batch Size | Effect | Memory |
|-----------|--------|--------|
| Small (8-32) | More noise, better generalization, slower | Low |
| Medium (64-128) | Good balance | Medium |
| Large (256-1024) | Smoother, faster, may generalize worse | High |

```
Rule of thumb: Start with 32 or 64, increase if GPU has memory.
```

### Epochs

```
┌────────────────────────────────────────────────────────────────┐
│  EPOCHS: How many times to see the full dataset                │
│                                                                │
│  Too few epochs:    Model hasn't learned enough (underfitting) │
│  Just right:        Good training + validation performance     │
│  Too many epochs:   Model memorizes training data (overfitting)│
│                                                                │
│  Loss                                                          │
│   ▲                                                            │
│   │╲ train                                                     │
│   │ ╲╲                                                         │
│   │   ╲╲──── train loss keeps dropping                        │
│   │     ╲╲╲╲╲╲_____                                           │
│   │      ╲╲                                                    │
│   │       ╲  val loss ── starts INCREASING here!              │
│   │        ╲    ╱──                                            │
│   │         ╲──╱      ← STOP HERE (EarlyStopping!)           │
│   └──────────────────────────────────────► Epoch              │
│                                                                │
│  Solution: Use EarlyStopping callback!                         │
└────────────────────────────────────────────────────────────────┘
```

---

## 10.5 Python Implementation

### Comparing Optimizers

```python
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Flatten
import matplotlib.pyplot as plt

# Load MNIST
(X_train, y_train), (X_test, y_test) = tf.keras.datasets.mnist.load_data()
X_train, X_test = X_train / 255.0, X_test / 255.0

def build_model():
    return Sequential([
        Flatten(input_shape=(28, 28)),
        Dense(128, activation='relu'),
        Dense(64, activation='relu'),
        Dense(10, activation='softmax')
    ])

# Compare optimizers
optimizers = {
    'SGD': tf.keras.optimizers.SGD(learning_rate=0.01),
    'SGD+Momentum': tf.keras.optimizers.SGD(learning_rate=0.01, momentum=0.9),
    'RMSprop': tf.keras.optimizers.RMSprop(learning_rate=0.001),
    'Adam': tf.keras.optimizers.Adam(learning_rate=0.001),
}

histories = {}
for name, opt in optimizers.items():
    print(f"\nTraining with {name}...")
    model = build_model()
    model.compile(optimizer=opt,
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])
    history = model.fit(X_train, y_train, epochs=10, batch_size=64,
                       validation_split=0.1, verbose=0)
    histories[name] = history
    val_acc = history.history['val_accuracy'][-1]
    print(f"  Final val accuracy: {val_acc:.4f}")

# Plot comparison
plt.figure(figsize=(12, 5))
for name, h in histories.items():
    plt.plot(h.history['val_loss'], label=name)
plt.xlabel('Epoch'); plt.ylabel('Validation Loss')
plt.title('Optimizer Comparison'); plt.legend()
plt.show()
```

---

## 10.6 Practice & Assessment

### MCQs

**Q1.** The default optimizer for most deep learning tasks is:
- A) SGD
- B) RMSprop
- C) Adam
- D) Adagrad

**Answer:** C — Adam combines momentum and adaptive learning rates, works well out-of-the-box.

---

**Q2.** Mini-batch gradient descent uses:
- A) All samples per update
- B) One sample per update
- C) A subset (e.g., 32) samples per update
- D) Random number of samples

**Answer:** C — Mini-batch uses a fixed subset (batch_size) for each weight update.

---

**Q3.** If validation loss starts increasing while training loss decreases:
- A) Increase epochs
- B) The model is overfitting — stop training
- C) Increase learning rate
- D) Add more layers

**Answer:** B — Diverging train/val loss indicates overfitting. Use EarlyStopping.

---

> **Next Topic:** [11 - Overfitting & Regularization](11-overfitting-regularization.md)
