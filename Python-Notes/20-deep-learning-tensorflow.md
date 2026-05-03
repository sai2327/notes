# 20. Deep Learning with TensorFlow/Keras

## Table of Contents
- [20.1 Introduction to Deep Learning](#201-introduction-to-deep-learning)
- [20.2 TensorFlow and Keras Basics](#202-tensorflow-and-keras-basics)
- [20.3 Building Neural Networks](#203-building-neural-networks)
- [20.4 Training and Evaluation](#204-training-and-evaluation)
- [20.5 CNNs for Image Classification](#205-cnns-for-image-classification)
- [20.6 Practice & Assessment](#206-practice--assessment)

---

## 20.1 Introduction to Deep Learning

### What is Deep Learning?
**Deep Learning** is a subset of Machine Learning using neural networks with multiple layers to learn complex patterns from data.

### Neural Network Architecture

```
┌───────────────────────────────────────────────────────────────┐
│  NEURAL NETWORK STRUCTURE                                      │
│                                                               │
│  Input Layer      Hidden Layers       Output Layer            │
│                                                               │
│    (x1) ─────┐                                                │
│              ├───► (h1) ──┐                                   │
│    (x2) ─────┤           ├───► (h4) ──┐                      │
│              ├───► (h2) ──┤           ├───► (y)  Output      │
│    (x3) ─────┤           ├───► (h5) ──┘                      │
│              ├───► (h3) ──┘                                   │
│    (x4) ─────┘                                                │
│                                                               │
│  Features      Pattern Detection     Prediction               │
└───────────────────────────────────────────────────────────────┘
```

### Key Concepts

| Concept | Description |
|---------|-------------|
| Neuron | Basic unit — weighted sum + activation |
| Weight | Learnable parameter (strength of connection) |
| Bias | Offset value added to weighted sum |
| Activation | Non-linear function (ReLU, Sigmoid, Softmax) |
| Epoch | One complete pass through training data |
| Batch | Subset of data processed together |
| Loss | Error between prediction and actual |
| Optimizer | Algorithm to update weights (Adam, SGD) |

---

## 20.2 TensorFlow and Keras Basics

```python
# Install: pip install tensorflow
import tensorflow as tf
from tensorflow import keras
import numpy as np

print(f"TensorFlow version: {tf.__version__}")

# Tensors (multi-dimensional arrays)
scalar = tf.constant(5)                        # 0-D
vector = tf.constant([1, 2, 3])                # 1-D
matrix = tf.constant([[1, 2], [3, 4]])         # 2-D
tensor = tf.constant([[[1, 2], [3, 4]]])       # 3-D

print(f"Shape: {matrix.shape}")       # (2, 2)
print(f"Dtype: {matrix.dtype}")       # int32
print(f"Rank: {tf.rank(matrix)}")     # 2

# Operations
a = tf.constant([[1, 2], [3, 4]], dtype=tf.float32)
b = tf.constant([[5, 6], [7, 8]], dtype=tf.float32)

print(tf.add(a, b))         # Element-wise addition
print(tf.matmul(a, b))      # Matrix multiplication
print(tf.reduce_mean(a))    # Mean
```

---

## 20.3 Building Neural Networks

### Sequential API (Simple)

```python
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Dropout

# Build model
model = Sequential([
    Dense(128, activation='relu', input_shape=(784,)),  # Hidden layer 1
    Dropout(0.2),                                        # Regularization
    Dense(64, activation='relu'),                        # Hidden layer 2
    Dropout(0.2),
    Dense(10, activation='softmax')                      # Output (10 classes)
])

# Compile
model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# Summary
model.summary()
```

### Model Summary Output

```
Model: "sequential"
_________________________________________________________________
Layer (type)                Output Shape              Param #
=================================================================
dense (Dense)               (None, 128)              100480
dropout (Dropout)           (None, 128)              0
dense_1 (Dense)             (None, 64)               8256
dropout_1 (Dropout)         (None, 64)               0
dense_2 (Dense)             (None, 10)               650
=================================================================
Total params: 109,386
Trainable params: 109,386
Non-trainable params: 0
```

### Activation Functions

```
┌─────────────────────────────────────────────────────────┐
│  ACTIVATION FUNCTIONS                                    │
│                                                         │
│  ReLU: f(x) = max(0, x)    — Hidden layers (default)   │
│  Sigmoid: f(x) = 1/(1+e^-x) — Binary classification   │
│  Softmax: f(x) = e^xi/Σe^xj — Multi-class output      │
│  Tanh: f(x) = (e^x-e^-x)/(e^x+e^-x) — Hidden layers  │
│                                                         │
│  When to use:                                           │
│  Hidden layers → ReLU (fast, avoids vanishing gradient) │
│  Binary output → Sigmoid (0 or 1)                       │
│  Multi-class output → Softmax (probabilities sum to 1)  │
└─────────────────────────────────────────────────────────┘
```

---

## 20.4 Training and Evaluation

### MNIST Digit Classification

```python
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Flatten, Dropout

# Load data
(X_train, y_train), (X_test, y_test) = tf.keras.datasets.mnist.load_data()

# Normalize (0-255 → 0-1)
X_train = X_train / 255.0
X_test = X_test / 255.0

print(f"Train: {X_train.shape}")  # (60000, 28, 28)
print(f"Test: {X_test.shape}")    # (10000, 28, 28)

# Build model
model = Sequential([
    Flatten(input_shape=(28, 28)),     # 28x28 → 784
    Dense(128, activation='relu'),
    Dropout(0.2),
    Dense(64, activation='relu'),
    Dense(10, activation='softmax')
])

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

# Train
history = model.fit(X_train, y_train,
                    epochs=10,
                    batch_size=32,
                    validation_split=0.2,
                    verbose=1)

# Evaluate
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"\nTest Accuracy: {test_acc:.4f}")

# Predict
predictions = model.predict(X_test[:5])
for i in range(5):
    print(f"Predicted: {predictions[i].argmax()}, Actual: {y_test[i]}")
```

### Visualize Training

```python
import matplotlib.pyplot as plt

# Plot accuracy
plt.figure(figsize=(12, 4))

plt.subplot(1, 2, 1)
plt.plot(history.history['accuracy'], label='Train')
plt.plot(history.history['val_accuracy'], label='Validation')
plt.title('Model Accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.legend()

plt.subplot(1, 2, 2)
plt.plot(history.history['loss'], label='Train')
plt.plot(history.history['val_loss'], label='Validation')
plt.title('Model Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.legend()

plt.tight_layout()
plt.show()
```

---

## 20.5 CNNs for Image Classification

```python
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout

# Load CIFAR-10 (10 classes: airplane, car, bird, cat, etc.)
(X_train, y_train), (X_test, y_test) = tf.keras.datasets.cifar10.load_data()
X_train, X_test = X_train / 255.0, X_test / 255.0

# CNN Architecture
model = Sequential([
    # Feature extraction
    Conv2D(32, (3, 3), activation='relu', input_shape=(32, 32, 3)),
    MaxPooling2D((2, 2)),
    Conv2D(64, (3, 3), activation='relu'),
    MaxPooling2D((2, 2)),
    Conv2D(64, (3, 3), activation='relu'),
    
    # Classification
    Flatten(),
    Dense(64, activation='relu'),
    Dropout(0.5),
    Dense(10, activation='softmax')
])

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

model.summary()
# Train (takes a few minutes)
# history = model.fit(X_train, y_train, epochs=10, batch_size=64,
#                     validation_data=(X_test, y_test))
```

### CNN Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│  CNN PIPELINE                                                    │
│                                                                 │
│  Input        Conv+ReLU     Pool       Conv+ReLU     Pool       │
│  32x32x3  →  30x30x32  →  15x15x32 → 13x13x64 → 6x6x64      │
│                                                                 │
│             Flatten → Dense → Dropout → Dense (Softmax)         │
│             2304    → 64   → 0.5     → 10 classes              │
│                                                                 │
│  Conv: Detect features (edges, textures, shapes)                │
│  Pool: Reduce size, keep important features                     │
│  Dense: Classify based on extracted features                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 20.6 Practice & Assessment

### MCQs

**Q1.** Which activation function is best for multi-class output?
- A) ReLU
- B) Sigmoid
- C) Softmax
- D) Tanh

**Answer:** C — Softmax outputs probabilities summing to 1 for multi-class.

---

**Q2.** What does Dropout do?
- A) Removes layers
- B) Randomly disables neurons during training to prevent overfitting
- C) Speeds up training
- D) Increases model size

**Answer:** B — Dropout regularizes by randomly setting neurons to 0.

---

### Coding Task

**Task:** Build and train a model for Fashion-MNIST.

```python
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Flatten, Dropout

# Load Fashion-MNIST (10 clothing categories)
(X_train, y_train), (X_test, y_test) = tf.keras.datasets.fashion_mnist.load_data()
X_train, X_test = X_train / 255.0, X_test / 255.0

class_names = ['T-shirt', 'Trouser', 'Pullover', 'Dress', 'Coat',
               'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']

model = Sequential([
    Flatten(input_shape=(28, 28)),
    Dense(256, activation='relu'),
    Dropout(0.3),
    Dense(128, activation='relu'),
    Dropout(0.3),
    Dense(10, activation='softmax')
])

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

history = model.fit(X_train, y_train, epochs=15, batch_size=64,
                    validation_split=0.2)

test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"Test Accuracy: {test_acc:.4f}")
```

---

> **Next Topic:** [21 - Scripting & Automation](21-scripting-automation.md)
