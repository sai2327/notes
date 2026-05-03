# 11. Overfitting & Regularization

## Table of Contents
- [11.1 Overfitting vs Underfitting](#111-overfitting-vs-underfitting)
- [11.2 Dropout](#112-dropout)
- [11.3 L1 and L2 Regularization](#113-l1-and-l2-regularization)
- [11.4 Early Stopping](#114-early-stopping)
- [11.5 Data Augmentation](#115-data-augmentation)
- [11.6 Batch Normalization](#116-batch-normalization)
- [11.7 Complete Example](#117-complete-example)
- [11.8 Practice & Assessment](#118-practice--assessment)

---

## 11.1 Overfitting vs Underfitting

```
┌────────────────────────────────────────────────────────────────────┐
│  THE BIAS-VARIANCE TRADEOFF                                       │
│                                                                    │
│  UNDERFITTING          JUST RIGHT           OVERFITTING           │
│  (High Bias)           (Good Fit)           (High Variance)       │
│                                                                    │
│    ──────              ╱╲   ╱╲              ╱╲╱╲╱╲╱╲             │
│      ╱                ╱  ╲╱  ╲             ╱        ╲            │
│   ──╱──               │         ╲          ╱ ╱╲  ╱╲  ╲           │
│                                                                    │
│  Too simple            Captures real       Memorizes noise        │
│  Model can't learn     pattern              + training data       │
│  the pattern                                                       │
│                                                                    │
│  Train acc: LOW ❌     Train acc: HIGH ✅   Train acc: VERY HIGH  │
│  Val acc:   LOW ❌     Val acc:   HIGH ✅   Val acc:   LOW ❌     │
│                                                                    │
│  Fix: More complex     Perfect!            Fix: Regularization    │
│  model, more features                                              │
└────────────────────────────────────────────────────────────────────┘
```

### How to Detect

```
Loss
 ▲
 │╲  Training loss keeps dropping
 │ ╲╲
 │   ╲╲╲______________________________
 │     ╲╲╲                              training
 │       ╲╲
 │         ╲╲   ╱────────────────────── validation  
 │           ╲╲╱
 │            ↑
 │      STOP HERE! (gap = overfitting)
 └──────────────────────────────────────► Epoch

 If train loss << val loss → OVERFITTING
 If both high            → UNDERFITTING
```

---

## 11.2 Dropout

```
┌────────────────────────────────────────────────────────────────┐
│  DROPOUT — Randomly "turn off" neurons during training        │
│                                                                │
│  Without Dropout:           With Dropout (rate=0.5):          │
│  All neurons active         50% randomly off each batch       │
│                                                                │
│  ○───○───○───○             ○───●───○───●                      │
│  │ ╲ │ ╲ │ ╲ │             │       │                           │
│  ○───○───○───○             ○───○───●───○                      │
│  │ ╲ │ ╲ │ ╲ │                 │       │                       │
│  ○───○───○───○             ●───○───○───○                      │
│                                                                │
│  ○ = active    ● = dropped (output = 0)                       │
│                                                                │
│  WHY it works:                                                 │
│  • Prevents co-adaptation (neurons can't rely on each other)  │
│  • Like training multiple "thin" networks                     │
│  • Acts as ensemble of many sub-networks                      │
│                                                                │
│  IMPORTANT: Dropout is ONLY active during TRAINING!           │
│  During inference/prediction: ALL neurons active              │
│  (outputs scaled by 1-rate automatically in TF/Keras)         │
└────────────────────────────────────────────────────────────────┘
```

```python
from tensorflow.keras.layers import Dropout

model = Sequential([
    Dense(256, activation='relu'),
    Dropout(0.3),    # Drop 30% of neurons
    Dense(128, activation='relu'),
    Dropout(0.3),
    Dense(10, activation='softmax')
])

# Typical rates:
# 0.2 - 0.3: Light regularization
# 0.5:       Standard (original paper recommendation)
# > 0.5:     Aggressive (may underfit)
```

---

## 11.3 L1 and L2 Regularization

### Concept

Add a penalty term to the loss function to discourage large weights:

$$L_{total} = L_{data} + \lambda \cdot R(w)$$

| Type | Penalty | Effect |
|------|---------|--------|
| **L1** (Lasso) | $\lambda \sum |w_i|$ | Pushes weights to exactly 0 (sparse) |
| **L2** (Ridge) | $\lambda \sum w_i^2$ | Pushes weights toward 0 (small, not zero) |
| **Elastic Net** | L1 + L2 combined | Both effects |

```
┌────────────────────────────────────────────────────────────────┐
│  L1 vs L2 EFFECT ON WEIGHTS                                   │
│                                                                │
│  L1 (Lasso):                 L2 (Ridge):                      │
│  Weights: [0, 0.5, 0, 0.3]  Weights: [0.1, 0.3, 0.05, 0.2] │
│  Many weights = exactly 0    All weights = small but nonzero  │
│  → Feature selection!         → Weight decay                   │
│                                                                │
│  λ (lambda) = regularization strength                         │
│  Higher λ → stronger penalty → simpler model                 │
│  Too high λ → underfitting                                    │
└────────────────────────────────────────────────────────────────┘
```

```python
from tensorflow.keras import regularizers

# L2 Regularization
Dense(128, activation='relu',
      kernel_regularizer=regularizers.l2(0.01))

# L1 Regularization
Dense(128, activation='relu',
      kernel_regularizer=regularizers.l1(0.01))

# L1 + L2 (Elastic Net)
Dense(128, activation='relu',
      kernel_regularizer=regularizers.l1_l2(l1=0.01, l2=0.01))
```

---

## 11.4 Early Stopping

```
┌────────────────────────────────────────────────────────────────┐
│  EARLY STOPPING — Stop training when validation stops improving│
│                                                                │
│  Loss                                                          │
│   ▲                                                            │
│   │╲                                                           │
│   │ ╲                                                          │
│   │  ╲   val_loss                                              │
│   │   ╲╲ ╱────                                                 │
│   │    ╲╱                                                      │
│   │     ↑ BEST model saved here                               │
│   │      ╲╲_______ train_loss                                  │
│   │                                                            │
│   └──────────────────────────────► Epoch                      │
│          ↑                                                     │
│   patience=5: wait 5 epochs after best,                       │
│   if no improvement → STOP and restore best weights           │
└────────────────────────────────────────────────────────────────┘
```

```python
from tensorflow.keras.callbacks import EarlyStopping

early_stop = EarlyStopping(
    monitor='val_loss',         # What to watch
    patience=5,                 # Wait 5 epochs with no improvement
    restore_best_weights=True,  # Go back to best model!
    min_delta=0.001             # Minimum change to count as improvement
)

model.fit(X_train, y_train,
          epochs=100,       # Set high, EarlyStopping will stop
          validation_split=0.2,
          callbacks=[early_stop])
```

---

## 11.5 Data Augmentation

```
┌────────────────────────────────────────────────────────────────┐
│  DATA AUGMENTATION — Create more training data from existing  │
│                                                                │
│  Original:   Flipped:    Rotated:    Zoomed:    Shifted:     │
│  ┌─────┐    ┌─────┐    ┌─────┐    ┌─────┐    ┌─────┐       │
│  │ 🐱  │    │  🐱 │    │  🐱 │    │ 🐱  │    │🐱   │       │
│  │     │    │     │    │  ╱  │    │     │    │     │       │
│  └─────┘    └─────┘    └─────┘    └─────┘    └─────┘       │
│                                                                │
│  Same cat, 5 different training samples!                      │
│  Model learns "cat" regardless of position/size/angle         │
│                                                                │
│  Common Augmentations:                                         │
│  • Horizontal/Vertical flip                                   │
│  • Rotation (±15°)                                            │
│  • Zoom (0.8x - 1.2x)                                        │
│  • Shift (translate)                                          │
│  • Brightness/Contrast change                                 │
│  • Random crop                                                │
└────────────────────────────────────────────────────────────────┘
```

```python
from tensorflow.keras.preprocessing.image import ImageDataGenerator

# Define augmentation pipeline
datagen = ImageDataGenerator(
    rotation_range=20,         # Rotate ±20°
    width_shift_range=0.2,     # Shift horizontally ±20%
    height_shift_range=0.2,    # Shift vertically ±20%
    horizontal_flip=True,      # Random horizontal flip
    zoom_range=0.2,            # Zoom ±20%
    fill_mode='nearest'        # Fill empty pixels
)

# Use with model.fit
model.fit(
    datagen.flow(X_train, y_train, batch_size=32),
    epochs=50,
    validation_data=(X_val, y_val)
)

# Modern tf.keras approach
data_augmentation = tf.keras.Sequential([
    tf.keras.layers.RandomFlip("horizontal"),
    tf.keras.layers.RandomRotation(0.1),
    tf.keras.layers.RandomZoom(0.1),
])
```

---

## 11.6 Batch Normalization

```
┌────────────────────────────────────────────────────────────────┐
│  BATCH NORMALIZATION — Normalize inputs to each layer         │
│                                                                │
│  Problem: Internal Covariate Shift                            │
│  As previous layer weights change, the distribution of inputs │
│  to the next layer shifts → training slows down               │
│                                                                │
│  Solution: Normalize each layer's inputs to μ=0, σ=1         │
│                                                                │
│  Before BatchNorm:           After BatchNorm:                 │
│  Activations: [50, -100,    Activations: [0.3, -0.7,        │
│   200, 5, ...]               0.9, 0.1, ...]                  │
│  (wide, unstable range)      (normalized, stable range)       │
│                                                                │
│  Formula:                                                      │
│  x̂ = (x - μ_batch) / √(σ²_batch + ε)                       │
│  y = γ · x̂ + β    ← learnable scale & shift                 │
│                                                                │
│  Benefits:                                                     │
│  ✅ Faster training (higher learning rates)                    │
│  ✅ Reduces sensitivity to initialization                     │
│  ✅ Acts as mild regularization                                │
└────────────────────────────────────────────────────────────────┘
```

```python
from tensorflow.keras.layers import BatchNormalization

model = Sequential([
    Dense(256, activation='relu'),
    BatchNormalization(),        # After activation (common)
    Dropout(0.3),
    Dense(128, activation='relu'),
    BatchNormalization(),
    Dropout(0.3),
    Dense(10, activation='softmax')
])
```

---

## 11.7 Complete Example

### All Regularization Techniques Combined

```python
"""
Overfitting Prevention: Comparing with and without regularization
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import (
    Dense, Dropout, BatchNormalization, Flatten
)
from tensorflow.keras import regularizers
from tensorflow.keras.callbacks import EarlyStopping
import matplotlib.pyplot as plt

# Load data
(X_train, y_train), (X_test, y_test) = tf.keras.datasets.fashion_mnist.load_data()
X_train, X_test = X_train / 255.0, X_test / 255.0

# ============ Model WITHOUT regularization ============
model_no_reg = Sequential([
    Flatten(input_shape=(28, 28)),
    Dense(512, activation='relu'),
    Dense(256, activation='relu'),
    Dense(128, activation='relu'),
    Dense(10, activation='softmax')
])

model_no_reg.compile(optimizer='adam',
                     loss='sparse_categorical_crossentropy',
                     metrics=['accuracy'])

history_no_reg = model_no_reg.fit(
    X_train, y_train, epochs=50, batch_size=64,
    validation_split=0.2, verbose=0
)

# ============ Model WITH regularization ============
model_reg = Sequential([
    Flatten(input_shape=(28, 28)),
    Dense(512, activation='relu', kernel_regularizer=regularizers.l2(0.001)),
    BatchNormalization(),
    Dropout(0.3),
    Dense(256, activation='relu', kernel_regularizer=regularizers.l2(0.001)),
    BatchNormalization(),
    Dropout(0.3),
    Dense(128, activation='relu', kernel_regularizer=regularizers.l2(0.001)),
    BatchNormalization(),
    Dropout(0.2),
    Dense(10, activation='softmax')
])

model_reg.compile(optimizer='adam',
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])

history_reg = model_reg.fit(
    X_train, y_train, epochs=50, batch_size=64,
    validation_split=0.2, verbose=0,
    callbacks=[EarlyStopping(patience=5, restore_best_weights=True)]
)

# ============ Compare ============
fig, axes = plt.subplots(1, 2, figsize=(14, 5))

# Loss
axes[0].plot(history_no_reg.history['loss'], 'r--', label='No Reg - Train')
axes[0].plot(history_no_reg.history['val_loss'], 'r-', label='No Reg - Val')
axes[0].plot(history_reg.history['loss'], 'b--', label='With Reg - Train')
axes[0].plot(history_reg.history['val_loss'], 'b-', label='With Reg - Val')
axes[0].set_title('Loss'); axes[0].legend()

# Accuracy
axes[1].plot(history_no_reg.history['accuracy'], 'r--', label='No Reg - Train')
axes[1].plot(history_no_reg.history['val_accuracy'], 'r-', label='No Reg - Val')
axes[1].plot(history_reg.history['accuracy'], 'b--', label='With Reg - Train')
axes[1].plot(history_reg.history['val_accuracy'], 'b-', label='With Reg - Val')
axes[1].set_title('Accuracy'); axes[1].legend()

plt.tight_layout()
plt.show()
```

### Regularization Decision Guide

```
┌────────────────────────────────────────────────────────────────┐
│  WHICH REGULARIZATION TO USE?                                  │
│                                                                │
│  Is train acc >> val acc?                                      │
│   ├── YES → OVERFITTING. Apply:                               │
│   │    ├── 1. Dropout (0.2-0.5) between Dense layers         │
│   │    ├── 2. EarlyStopping (patience=5-10)                  │
│   │    ├── 3. L2 regularization (0.001-0.01)                 │
│   │    ├── 4. Data augmentation (for images)                  │
│   │    └── 5. Reduce model size (fewer layers/neurons)       │
│   │                                                            │
│   └── NO, both low → UNDERFITTING. Apply:                     │
│        ├── 1. Bigger model (more layers/neurons)              │
│        ├── 2. Train longer (more epochs)                      │
│        ├── 3. Better features                                 │
│        └── 4. Lower learning rate                             │
│                                                                │
│  ALWAYS USE: EarlyStopping + BatchNormalization               │
└────────────────────────────────────────────────────────────────┘
```

---

## 11.8 Practice & Assessment

### MCQs

**Q1.** Dropout works by:
- A) Removing layers during training
- B) Randomly setting neuron outputs to 0 during training
- C) Reducing learning rate
- D) Adding noise to data

**Answer:** B — During each training batch, random neurons are "turned off" (output set to 0). At test time, all neurons are active.

---

**Q2.** L2 regularization adds _____ to the loss function:
- A) Sum of absolute weights
- B) Sum of squared weights times lambda
- C) Extra training data
- D) Dropout probability

**Answer:** B — $L_{total} = L_{data} + \lambda \sum w_i^2$, penalizing large weights.

---

**Q3.** EarlyStopping with `restore_best_weights=True` will:
- A) Continue training forever
- B) Stop when training loss stops decreasing
- C) Stop when monitored metric hasn't improved and restore the best model
- D) Remove all regularization

**Answer:** C — It watches val_loss, stops after `patience` epochs with no improvement, and loads the best weights.

---

> **Next Topic:** [12 - Computer Vision](12-computer-vision.md)
