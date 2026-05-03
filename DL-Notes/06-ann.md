# 06. ANN (Artificial Neural Networks)

## Table of Contents
- [6.1 What is an ANN?](#61-what-is-an-ann)
- [6.2 ANN Architecture Design](#62-ann-architecture-design)
- [6.3 ANN for Classification](#63-ann-for-classification)
- [6.4 ANN for Regression](#64-ann-for-regression)
- [6.5 Batch Normalization](#65-batch-normalization)
- [6.6 Keras Callbacks](#66-keras-callbacks)
- [6.7 Practice & Assessment](#67-practice--assessment)

---

## 6.1 What is an ANN?

### Definition
An **Artificial Neural Network (ANN)**, also called a **Feedforward Neural Network** or **Dense Network**, is a network where every neuron in one layer connects to every neuron in the next layer (fully connected).

```
┌────────────────────────────────────────────────────────────────────┐
│  ANN / FEEDFORWARD / DENSE NETWORK                                 │
│                                                                    │
│  Input Layer     Hidden Layer 1    Hidden Layer 2    Output        │
│                  (Dense/FC)        (Dense/FC)                      │
│                                                                    │
│    x₁ ○─────┬──○─────┬──○                                        │
│         ╲ ╱ │╲ │╱╲  ╱ │╲ │╲                                      │
│    x₂ ○──╳──┤──○──╳──┤──○──╳──○  ŷ                              │
│         ╱ ╲ │╱ │╲╱  ╲ │╱ │╱                                      │
│    x₃ ○─────┘──○─────┘──○                                        │
│                                                                    │
│   3 inputs    4 neurons    3 neurons   1 output                   │
│               ReLU         ReLU        Sigmoid                    │
│                                                                    │
│  "Fully Connected" = every neuron connected to ALL in next layer  │
│  "Feedforward" = data flows only LEFT → RIGHT (no loops)         │
│  Best for: Structured/tabular data                                │
└────────────────────────────────────────────────────────────────────┘
```

### When to Use ANN

| Use ANN For | Don't Use ANN For |
|------------|------------------|
| Tabular data (CSV, databases) | Images (use CNN) |
| Customer churn prediction | Text/sequences (use RNN/Transformer) |
| Price prediction | Time series (use LSTM) |
| Simple classification | Video/audio (use specialized architectures) |

---

## 6.2 ANN Architecture Design

### How Many Layers and Neurons?

```
┌────────────────────────────────────────────────────────────────┐
│  ARCHITECTURE GUIDELINES                                       │
│                                                                │
│  Input Layer:                                                  │
│  • Neurons = number of features in your data                  │
│  • No activation function                                     │
│                                                                │
│  Hidden Layers:                                                │
│  • Start with 1-2 layers (add more if needed)                 │
│  • Neurons: start with 64-256, reduce in deeper layers        │
│  • Common pattern: funnel shape (128 → 64 → 32)              │
│  • Activation: ReLU (default)                                 │
│                                                                │
│  Output Layer:                                                 │
│  • Binary classification: 1 neuron, sigmoid                   │
│  • Multi-class (N classes): N neurons, softmax                │
│  • Regression: 1 neuron, no activation (linear)               │
│                                                                │
│  Rule of Thumb:                                                │
│  Neurons per layer ≈ between input_size and output_size       │
│  Total params should be < 10× your training samples           │
└────────────────────────────────────────────────────────────────┘
```

---

## 6.3 ANN for Classification

### Complete Example: Customer Churn Prediction

```python
"""
ANN for Binary Classification: Customer Churn Prediction
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Dropout, BatchNormalization
from tensorflow.keras.callbacks import EarlyStopping
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.metrics import classification_report, confusion_matrix

# ============================================
# STEP 1: Create Sample Dataset
# ============================================
np.random.seed(42)
n = 2000

data = pd.DataFrame({
    'CreditScore': np.random.randint(350, 850, n),
    'Age': np.random.randint(18, 70, n),
    'Tenure': np.random.randint(0, 10, n),
    'Balance': np.random.uniform(0, 250000, n),
    'NumProducts': np.random.randint(1, 5, n),
    'IsActiveMember': np.random.randint(0, 2, n),
    'EstimatedSalary': np.random.uniform(20000, 200000, n),
})

# Create target (churn) with some logic
churn_prob = (
    (data['Age'] > 45).astype(int) * 0.3 +
    (data['Balance'] > 150000).astype(int) * 0.2 +
    (data['IsActiveMember'] == 0).astype(int) * 0.2 +
    np.random.uniform(0, 0.3, n)
)
data['Churn'] = (churn_prob > 0.5).astype(int)

print(f"Shape: {data.shape}")
print(f"Churn distribution:\n{data['Churn'].value_counts()}")

# ============================================
# STEP 2: Prepare Data
# ============================================
X = data.drop('Churn', axis=1)
y = data['Churn']

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

print(f"Train: {X_train.shape}, Test: {X_test.shape}")

# ============================================
# STEP 3: Build ANN
# ============================================
model = Sequential([
    # Input layer + Hidden layer 1
    Dense(128, activation='relu', input_shape=(X_train.shape[1],)),
    BatchNormalization(),
    Dropout(0.3),

    # Hidden layer 2
    Dense(64, activation='relu'),
    BatchNormalization(),
    Dropout(0.3),

    # Hidden layer 3
    Dense(32, activation='relu'),
    Dropout(0.2),

    # Output layer (binary classification)
    Dense(1, activation='sigmoid')
])

model.summary()

# ============================================
# STEP 4: Compile
# ============================================
model.compile(
    optimizer='adam',
    loss='binary_crossentropy',
    metrics=['accuracy']
)

# ============================================
# STEP 5: Train
# ============================================
history = model.fit(
    X_train, y_train,
    epochs=100,
    batch_size=32,
    validation_split=0.2,
    callbacks=[
        EarlyStopping(monitor='val_loss', patience=10, restore_best_weights=True)
    ],
    verbose=1
)

# ============================================
# STEP 6: Evaluate
# ============================================
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"\nTest Accuracy: {test_acc:.4f}")

y_pred = (model.predict(X_test) > 0.5).astype(int).flatten()
print(f"\n{classification_report(y_test, y_pred)}")

# ============================================
# STEP 7: Plot Training History
# ============================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

ax1.plot(history.history['loss'], label='Train')
ax1.plot(history.history['val_loss'], label='Validation')
ax1.set_title('Loss vs Epochs'); ax1.legend(); ax1.set_xlabel('Epoch')

ax2.plot(history.history['accuracy'], label='Train')
ax2.plot(history.history['val_accuracy'], label='Validation')
ax2.set_title('Accuracy vs Epochs'); ax2.legend(); ax2.set_xlabel('Epoch')

plt.tight_layout()
plt.show()
```

---

## 6.4 ANN for Regression

```python
"""
ANN for Regression: House Price Prediction
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Dropout
from sklearn.datasets import fetch_california_housing
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import numpy as np

# Load data
housing = fetch_california_housing()
X_train, X_test, y_train, y_test = train_test_split(
    housing.data, housing.target, test_size=0.2, random_state=42
)

# Scale features (IMPORTANT for neural networks!)
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

# Build model
model = Sequential([
    Dense(128, activation='relu', input_shape=(X_train.shape[1],)),
    Dense(64, activation='relu'),
    Dense(32, activation='relu'),
    Dense(1)                     # ← NO activation for regression!
])

model.compile(optimizer='adam', loss='mse', metrics=['mae'])

history = model.fit(
    X_train, y_train,
    epochs=100, batch_size=32,
    validation_split=0.2,
    callbacks=[tf.keras.callbacks.EarlyStopping(patience=10, restore_best_weights=True)],
    verbose=0
)

# Evaluate
test_loss, test_mae = model.evaluate(X_test, y_test)
print(f"Test MAE: {test_mae:.4f}")
print(f"Test RMSE: {np.sqrt(test_loss):.4f}")

# Predict
predictions = model.predict(X_test[:5]).flatten()
for pred, actual in zip(predictions, y_test[:5]):
    print(f"  Predicted: ${pred*100000:.0f}, Actual: ${actual*100000:.0f}")
```

---

## 6.5 Batch Normalization

### What and Why?

```
┌────────────────────────────────────────────────────────────────┐
│  BATCH NORMALIZATION                                           │
│                                                                │
│  Problem: As data flows through layers, the distribution     │
│  of activations shifts → training becomes unstable            │
│  (Internal Covariate Shift)                                   │
│                                                                │
│  Solution: Normalize activations within each mini-batch       │
│                                                                │
│  Without BatchNorm:        With BatchNorm:                    │
│  Activations drift         Activations stay normalized        │
│  ┌─────────────┐          ┌─────────────┐                    │
│  │   ╱╲  ╱╲    │          │    ╱╲       │                    │
│  │  ╱  ╲╱  ╲   │   →     │   ╱  ╲      │                    │
│  │ ╱        ╲  │          │  ╱    ╲     │                    │
│  │╱          ╲ │          │ ╱──────╲    │                    │
│  └─────────────┘          └─────────────┘                    │
│  Unstable                  Stable, faster training            │
│                                                                │
│  Place AFTER Dense, BEFORE activation (or after — both work) │
└────────────────────────────────────────────────────────────────┘
```

$$\hat{x}_i = \frac{x_i - \mu_B}{\sqrt{\sigma_B^2 + \epsilon}} \quad \rightarrow \quad y_i = \gamma \hat{x}_i + \beta$$

```python
from tensorflow.keras.layers import BatchNormalization

model = Sequential([
    Dense(128, input_shape=(10,)),
    BatchNormalization(),              # Normalize before activation
    tf.keras.layers.Activation('relu'),
    Dense(64),
    BatchNormalization(),
    tf.keras.layers.Activation('relu'),
    Dense(1, activation='sigmoid')
])
```

---

## 6.6 Keras Callbacks

| Callback | Purpose | Usage |
|----------|---------|-------|
| **EarlyStopping** | Stop when validation loss stops improving | Prevent overfitting |
| **ModelCheckpoint** | Save best model during training | Keep best weights |
| **ReduceLROnPlateau** | Reduce learning rate when stuck | Fine-tune training |
| **TensorBoard** | Visualize training in browser | Debugging |

```python
from tensorflow.keras.callbacks import (
    EarlyStopping, ModelCheckpoint, ReduceLROnPlateau
)

callbacks = [
    EarlyStopping(
        monitor='val_loss',
        patience=10,                    # Wait 10 epochs before stopping
        restore_best_weights=True       # Go back to best weights
    ),
    ModelCheckpoint(
        'best_model.keras',
        monitor='val_loss',
        save_best_only=True
    ),
    ReduceLROnPlateau(
        monitor='val_loss',
        factor=0.5,                     # Halve the learning rate
        patience=5,                      # After 5 epochs no improvement
        min_lr=1e-6
    )
]

history = model.fit(X_train, y_train, epochs=200,
                    validation_split=0.2, callbacks=callbacks)
```

---

## 6.7 Practice & Assessment

### MCQs

**Q1.** ANN is best suited for:
- A) Image recognition
- B) Text generation
- C) Tabular/structured data
- D) Video processing

**Answer:** C — ANNs with Dense layers work best on structured/tabular data.

---

**Q2.** For a regression task, the output layer should have:
- A) Softmax activation
- B) Sigmoid activation
- C) No activation (linear)
- D) ReLU activation

**Answer:** C — Regression outputs can be any number, so no activation constrains the output.

---

**Q3.** BatchNormalization helps by:
- A) Reducing the number of parameters
- B) Normalizing layer activations for stable training
- C) Adding more layers
- D) Removing outliers

**Answer:** B — BatchNorm normalizes intermediate activations to prevent internal covariate shift.

---

> **Next Topic:** [07 - CNN (Convolutional Neural Networks)](07-cnn.md)
