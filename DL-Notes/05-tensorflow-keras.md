# 05. TensorFlow & Keras

## Table of Contents
- [5.1 What is TensorFlow?](#51-what-is-tensorflow)
- [5.2 Tensors and Operations](#52-tensors-and-operations)
- [5.3 Keras — High-Level API](#53-keras--high-level-api)
- [5.4 Sequential API](#54-sequential-api)
- [5.5 Functional API](#55-functional-api)
- [5.6 Model Compilation](#56-model-compilation)
- [5.7 Model Training](#57-model-training)
- [5.8 Complete Example](#58-complete-example)
- [5.9 Practice & Assessment](#59-practice--assessment)

---

## 5.1 What is TensorFlow?

```
┌────────────────────────────────────────────────────────────────────┐
│  TensorFlow STACK                                                  │
│                                                                    │
│  ┌──────────────────────────────────────────────────────┐         │
│  │  Keras (tf.keras)                                    │         │
│  │  High-level API — easy model building                │ ← YOU  │
│  ├──────────────────────────────────────────────────────┤         │
│  │  TensorFlow Core                                     │         │
│  │  Tensors, automatic differentiation, operations      │         │
│  ├──────────────────────────────────────────────────────┤         │
│  │  Backend: CPU / GPU / TPU execution                  │         │
│  │  CUDA, cuDNN (NVIDIA GPU acceleration)               │         │
│  └──────────────────────────────────────────────────────┘         │
│                                                                    │
│  TensorFlow = Google's open-source DL framework                   │
│  Keras = User-friendly interface built into TensorFlow            │
│  You write Keras code → TensorFlow handles GPU computation        │
└────────────────────────────────────────────────────────────────────┘
```

### Installation

```bash
pip install tensorflow
```

```python
import tensorflow as tf
print(f"TensorFlow version: {tf.__version__}")
print(f"GPU available: {len(tf.config.list_physical_devices('GPU')) > 0}")
```

---

## 5.2 Tensors and Operations

### Creating Tensors

```python
import tensorflow as tf
import numpy as np

# --- CREATING TENSORS ---

# From Python values
scalar = tf.constant(5)                              # shape: ()
vector = tf.constant([1, 2, 3])                      # shape: (3,)
matrix = tf.constant([[1, 2], [3, 4], [5, 6]])       # shape: (3, 2)

# From NumPy
np_array = np.array([[1.0, 2.0], [3.0, 4.0]])
tensor = tf.constant(np_array)                        # shape: (2, 2)

# Special tensors
zeros = tf.zeros((3, 4))                              # 3×4 of zeros
ones = tf.ones((2, 3))                                # 2×3 of ones
random_normal = tf.random.normal((3, 3), mean=0, stddev=1)
random_uniform = tf.random.uniform((2, 2), minval=0, maxval=1)

# Tensor properties
print(f"Shape: {matrix.shape}")         # (3, 2)
print(f"Dtype: {matrix.dtype}")         # int32
print(f"Rank:  {tf.rank(matrix)}")      # 2
print(f"Size:  {tf.size(matrix)}")      # 6
```

### Tensor Shape Transformations

```
┌────────────────────────────────────────────────────────────────────┐
│  TENSOR SHAPE OPERATIONS                                           │
│                                                                    │
│  Original: shape (2, 3)                                           │
│  ┌─────────────┐                                                  │
│  │ 1  2  3     │                                                  │
│  │ 4  5  6     │                                                  │
│  └─────────────┘                                                  │
│                                                                    │
│  Reshape to (3, 2):          Reshape to (6,):                     │
│  ┌─────────┐                 [1, 2, 3, 4, 5, 6]                  │
│  │ 1  2    │                                                      │
│  │ 3  4    │                 Reshape to (1, 6):                   │
│  │ 5  6    │                 [[1, 2, 3, 4, 5, 6]]                │
│  └─────────┘                                                      │
│                                                                    │
│  Expand dims: (2,3) → (1,2,3)   (add batch dimension)           │
│  Squeeze:     (1,2,3) → (2,3)   (remove size-1 dimensions)      │
└────────────────────────────────────────────────────────────────────┘
```

```python
x = tf.constant([[1,2,3], [4,5,6]])   # shape: (2, 3)

# Reshape
r1 = tf.reshape(x, (3, 2))            # (3, 2)
r2 = tf.reshape(x, (-1,))             # (6,)  -1 = auto-calculate
r3 = tf.reshape(x, (1, 2, 3))         # (1, 2, 3)

# Expand / Squeeze
expanded = tf.expand_dims(x, axis=0)   # (1, 2, 3) — add batch dim
squeezed = tf.squeeze(expanded)        # (2, 3) — remove size-1 dims

# Transpose
transposed = tf.transpose(x)           # (3, 2)
```

### Tensor Operations

```python
a = tf.constant([[1.0, 2.0], [3.0, 4.0]])
b = tf.constant([[5.0, 6.0], [7.0, 8.0]])

# Element-wise
add = a + b                        # or tf.add(a, b)
mul = a * b                        # or tf.multiply(a, b)

# Matrix multiplication (KEY operation in neural networks!)
matmul = a @ b                     # or tf.matmul(a, b)

# Reduction
total = tf.reduce_sum(a)           # 10.0
mean = tf.reduce_mean(a)           # 2.5
max_val = tf.reduce_max(a)         # 4.0

# Convert between TF and NumPy
np_arr = a.numpy()                 # tensor → numpy
tf_ten = tf.constant(np_arr)       # numpy → tensor

print(f"a + b = \n{add}")
print(f"a @ b = \n{matmul}")
```

### GradientTape (Automatic Differentiation)

```python
# TensorFlow automatically computes gradients!
x = tf.Variable(3.0)

with tf.GradientTape() as tape:
    y = x ** 2 + 2 * x + 1    # y = x² + 2x + 1

# dy/dx = 2x + 2 → at x=3: 2(3)+2 = 8
grad = tape.gradient(y, x)
print(f"y = {y.numpy()}, dy/dx = {grad.numpy()}")  # y=16, dy/dx=8
```

---

## 5.3 Keras — High-Level API

```
┌────────────────────────────────────────────────────────────────┐
│  KERAS WORKFLOW                                                 │
│                                                                │
│  1. DEFINE model architecture                                  │
│     model = keras.Sequential([...])                            │
│                                                                │
│  2. COMPILE (set optimizer, loss, metrics)                     │
│     model.compile(optimizer, loss, metrics)                    │
│                                                                │
│  3. TRAIN (fit on data)                                        │
│     model.fit(X_train, y_train, epochs, batch_size)           │
│                                                                │
│  4. EVALUATE (test performance)                                │
│     model.evaluate(X_test, y_test)                            │
│                                                                │
│  5. PREDICT (use the model)                                    │
│     model.predict(new_data)                                   │
└────────────────────────────────────────────────────────────────┘
```

---

## 5.4 Sequential API

Best for **simple stack of layers** (most common for beginners).

```python
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Dropout

# Method 1: Pass layers as list
model = Sequential([
    Dense(128, activation='relu', input_shape=(784,)),   # Layer 1
    Dropout(0.3),                                         # Regularization
    Dense(64, activation='relu'),                         # Layer 2
    Dropout(0.3),
    Dense(10, activation='softmax')                       # Output (10 classes)
])

# Method 2: Add layers one by one
model = Sequential()
model.add(Dense(128, activation='relu', input_shape=(784,)))
model.add(Dense(64, activation='relu'))
model.add(Dense(10, activation='softmax'))

# View architecture
model.summary()
```

**`model.summary()` output:**
```
Model: "sequential"
┌─────────────────────────────┬──────────────────┬──────────┐
│ Layer (type)                │ Output Shape     │ Param #  │
├─────────────────────────────┼──────────────────┼──────────┤
│ dense (Dense)               │ (None, 128)      │ 100,480  │
│ dense_1 (Dense)             │ (None, 64)       │ 8,256    │
│ dense_2 (Dense)             │ (None, 10)       │ 650      │
└─────────────────────────────┴──────────────────┴──────────┘
Total params: 109,386
Trainable params: 109,386
Non-trainable params: 0

Parameter count:
  Layer 1: 784 × 128 + 128 = 100,480
  Layer 2: 128 × 64  + 64  = 8,256
  Layer 3: 64  × 10  + 10  = 650
```

---

## 5.5 Functional API

For **complex architectures** (multiple inputs/outputs, skip connections).

```python
from tensorflow.keras import Model, Input
from tensorflow.keras.layers import Dense, Concatenate

# Define input
inputs = Input(shape=(784,))

# Build layers
x = Dense(128, activation='relu')(inputs)
x = Dense(64, activation='relu')(x)
outputs = Dense(10, activation='softmax')(x)

# Create model
model = Model(inputs=inputs, outputs=outputs)
model.summary()
```

### Multi-Input Model (Functional API)

```python
# Two separate inputs merged together
input_text = Input(shape=(100,), name='text_input')
input_meta = Input(shape=(5,), name='meta_input')

# Text branch
x1 = Dense(64, activation='relu')(input_text)
x1 = Dense(32, activation='relu')(x1)

# Meta branch
x2 = Dense(16, activation='relu')(input_meta)

# Merge
merged = Concatenate()([x1, x2])
x = Dense(32, activation='relu')(merged)
output = Dense(1, activation='sigmoid')(x)

model = Model(inputs=[input_text, input_meta], outputs=output)
```

```
┌────────────────────────────────────────────────────────────────┐
│  SEQUENTIAL vs FUNCTIONAL API                                   │
│                                                                │
│  Sequential:                    Functional:                    │
│  ┌────────────┐                ┌──────┐  ┌──────┐            │
│  │ Input      │                │Input1│  │Input2│            │
│  │     ↓      │                │  ↓   │  │  ↓   │            │
│  │ Dense(128) │                │Dense │  │Dense │            │
│  │     ↓      │                │  ↓   │  │  ↓   │            │
│  │ Dense(64)  │                │   ╲  │  │ ╱    │            │
│  │     ↓      │                │    Concatenate  │            │
│  │ Dense(10)  │                │       ↓         │            │
│  │     ↓      │                │    Dense(32)    │            │
│  │ Output     │                │       ↓         │            │
│  └────────────┘                │    Output       │            │
│                                └─────────────────┘            │
│  Simple stack                  Complex/branching              │
│  Use: 90% of cases            Use: advanced architectures    │
└────────────────────────────────────────────────────────────────┘
```

---

## 5.6 Model Compilation

```python
model.compile(
    optimizer='adam',                            # HOW to learn
    loss='sparse_categorical_crossentropy',      # WHAT to minimize
    metrics=['accuracy']                         # WHAT to track
)
```

### Compilation Parameters

| Parameter | Options | When to Use |
|-----------|---------|-------------|
| **Optimizer** | `'adam'` (default), `'sgd'`, `'rmsprop'` | Adam works for most cases |
| **Loss** | `'binary_crossentropy'` | Binary classification (sigmoid output) |
| | `'categorical_crossentropy'` | Multi-class (one-hot labels) |
| | `'sparse_categorical_crossentropy'` | Multi-class (integer labels) |
| | `'mse'` | Regression |
| **Metrics** | `['accuracy']` | Classification |
| | `['mae']` | Regression |

### Quick Reference: Output Layer + Loss

```
┌────────────────────────────────────────────────────────────────┐
│  MATCHING OUTPUT ACTIVATION + LOSS                             │
│                                                                │
│  Task                  Output Act.    Loss                     │
│  ─────────────────────────────────────────────                 │
│  Binary classification  sigmoid       binary_crossentropy      │
│  Multi-class (one-hot)  softmax       categorical_crossentropy │
│  Multi-class (int)      softmax       sparse_categorical_CE    │
│  Regression             None/linear   mse                      │
│  Regression (outliers)  None/linear   mae or huber             │
└────────────────────────────────────────────────────────────────┘
```

---

## 5.7 Model Training

```python
history = model.fit(
    X_train, y_train,
    epochs=50,                              # Full passes through data
    batch_size=32,                           # Samples per gradient update
    validation_split=0.2,                    # 20% for validation
    callbacks=[
        tf.keras.callbacks.EarlyStopping(
            monitor='val_loss', patience=5, restore_best_weights=True
        )
    ],
    verbose=1                                # Show progress
)
```

### Training Parameters Explained

| Parameter | Meaning | Typical Values |
|-----------|---------|---------------|
| `epochs` | Times to loop through entire dataset | 10-100+ |
| `batch_size` | Samples processed before weight update | 32, 64, 128, 256 |
| `validation_split` | Fraction of training data for validation | 0.1-0.3 |
| `callbacks` | Functions called during training | EarlyStopping, ModelCheckpoint |

### Batch Processing Visualization

```
┌────────────────────────────────────────────────────────────────┐
│  EPOCHS AND BATCHES                                            │
│                                                                │
│  Dataset: 1000 samples, batch_size=250                        │
│                                                                │
│  EPOCH 1:                                                      │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐                 │
│  │Batch 1 │ │Batch 2 │ │Batch 3 │ │Batch 4 │                 │
│  │ 250    │→│ 250    │→│ 250    │→│ 250    │                 │
│  │samples │ │samples │ │samples │ │samples │                 │
│  └────────┘ └────────┘ └────────┘ └────────┘                 │
│  update w   update w   update w   update w                    │
│                                                                │
│  EPOCH 2: same 4 batches again (shuffled)                     │
│  ...                                                           │
│  EPOCH N: repeat                                               │
│                                                                │
│  1 epoch  = 4 batches = 4 weight updates                      │
│  50 epochs = 200 total weight updates                         │
└────────────────────────────────────────────────────────────────┘
```

---

## 5.8 Complete Example

```python
"""
Complete TensorFlow/Keras Example: MNIST Digit Classification
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Flatten
import matplotlib.pyplot as plt

# ============================================
# STEP 1: Load Data
# ============================================
(X_train, y_train), (X_test, y_test) = tf.keras.datasets.mnist.load_data()

# Normalize pixels to [0, 1]
X_train = X_train / 255.0
X_test = X_test / 255.0

print(f"Train: {X_train.shape}, Test: {X_test.shape}")
# Train: (60000, 28, 28), Test: (10000, 28, 28)

# Visualize some samples
fig, axes = plt.subplots(1, 5, figsize=(12, 3))
for i, ax in enumerate(axes):
    ax.imshow(X_train[i], cmap='gray')
    ax.set_title(f"Label: {y_train[i]}")
    ax.axis('off')
plt.show()

# ============================================
# STEP 2: Build Model
# ============================================
model = Sequential([
    Flatten(input_shape=(28, 28)),      # 28×28 → 784 (flatten image)
    Dense(128, activation='relu'),       # Hidden layer 1
    Dense(64, activation='relu'),        # Hidden layer 2
    Dense(10, activation='softmax')      # Output (10 digits)
])

model.summary()

# ============================================
# STEP 3: Compile
# ============================================
model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# ============================================
# STEP 4: Train
# ============================================
history = model.fit(
    X_train, y_train,
    epochs=20,
    batch_size=32,
    validation_split=0.2,
    callbacks=[
        tf.keras.callbacks.EarlyStopping(
            monitor='val_loss', patience=3, restore_best_weights=True
        )
    ]
)

# ============================================
# STEP 5: Evaluate
# ============================================
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"\nTest Accuracy: {test_acc:.4f}")
print(f"Test Loss: {test_loss:.4f}")

# ============================================
# STEP 6: Plot Training History
# ============================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

ax1.plot(history.history['loss'], label='Train Loss')
ax1.plot(history.history['val_loss'], label='Val Loss')
ax1.set_xlabel('Epoch'); ax1.set_ylabel('Loss')
ax1.set_title('Loss vs Epochs'); ax1.legend()

ax2.plot(history.history['accuracy'], label='Train Accuracy')
ax2.plot(history.history['val_accuracy'], label='Val Accuracy')
ax2.set_xlabel('Epoch'); ax2.set_ylabel('Accuracy')
ax2.set_title('Accuracy vs Epochs'); ax2.legend()

plt.tight_layout()
plt.show()

# ============================================
# STEP 7: Predict
# ============================================
import numpy as np

predictions = model.predict(X_test[:5])
for i in range(5):
    pred_label = np.argmax(predictions[i])
    confidence = predictions[i][pred_label]
    print(f"Predicted: {pred_label} ({confidence:.2%}), Actual: {y_test[i]}")
```

---

## 5.9 Practice & Assessment

### MCQs

**Q1.** In Keras, `model.fit()` does:
- A) Defines the model architecture
- B) Trains the model on data
- C) Evaluates the model
- D) Saves the model

**Answer:** B — `fit()` trains the model by running forward/backward passes for specified epochs.

---

**Q2.** `Flatten()` layer converts:
- A) 1D to 2D
- B) 2D image (28×28) to 1D vector (784)
- C) Any shape to scalar
- D) Tensor to numpy

**Answer:** B — Flatten reshapes multi-dimensional input into a 1D vector for Dense layers.

---

**Q3.** For classifying images into 10 categories with integer labels, use:
- A) `loss='binary_crossentropy'`, activation='sigmoid'
- B) `loss='sparse_categorical_crossentropy'`, activation='softmax'
- C) `loss='mse'`, activation='relu'
- D) `loss='categorical_crossentropy'`, activation='sigmoid'

**Answer:** B — Softmax for multi-class output, sparse_categorical_CE for integer labels.

---

> **Next Topic:** [06 - ANN (Artificial Neural Networks)](06-ann.md)
