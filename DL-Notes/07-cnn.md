# 07. CNN (Convolutional Neural Networks)

## Table of Contents
- [7.1 Why CNN?](#71-why-cnn)
- [7.2 Convolution Operation](#72-convolution-operation)
- [7.3 CNN Layers](#73-cnn-layers)
- [7.4 CNN Architecture](#74-cnn-architecture)
- [7.5 Complete CNN Example](#75-complete-cnn-example)
- [7.6 Transfer Learning](#76-transfer-learning)
- [7.7 Practice & Assessment](#77-practice--assessment)

---

## 7.1 Why CNN?

### Problem with ANN for Images

```
┌────────────────────────────────────────────────────────────────────┐
│  WHY NOT USE ANN (Dense) FOR IMAGES?                               │
│                                                                    │
│  Image: 224 × 224 × 3 (RGB) = 150,528 pixels                     │
│  Dense layer with 256 neurons: 150,528 × 256 = 38.5 MILLION      │
│  weights in JUST the first layer!                                  │
│                                                                    │
│  Problems:                                                         │
│  ❌ WAY too many parameters (overfitting, slow)                    │
│  ❌ No spatial awareness (doesn't know pixels are neighbors)       │
│  ❌ Not translation invariant (cat in corner ≠ cat in center)     │
│                                                                    │
│  Solution: CNN                                                     │
│  ✅ Parameter sharing (same filter slides across image)            │
│  ✅ Captures spatial patterns (edges, textures, shapes)           │
│  ✅ Translation invariant (finds cat anywhere in image)           │
│  ✅ Far fewer parameters                                          │
└────────────────────────────────────────────────────────────────────┘
```

---

## 7.2 Convolution Operation

### How a Filter/Kernel Works

```
┌────────────────────────────────────────────────────────────────────────┐
│  CONVOLUTION — Sliding a filter over the image                         │
│                                                                        │
│  Input Image (5×5):           Filter/Kernel (3×3):                    │
│  ┌─────────────────┐         ┌─────────┐                              │
│  │ 1  0  1  0  1   │         │ 1  0  1 │                              │
│  │ 0  1  0  1  0   │    *    │ 0  1  0 │                              │
│  │ 1  0  1  0  1   │         │ 1  0  1 │                              │
│  │ 0  1  0  1  0   │         └─────────┘                              │
│  │ 1  0  1  0  1   │                                                  │
│  └─────────────────┘                                                  │
│                                                                        │
│  Step 1: Place filter on top-left corner                              │
│  ┌─────────┐                                                          │
│  │[1  0  1]│ 0  1          1×1 + 0×0 + 1×1 +                        │
│  │[0  1  0]│ 1  0          0×0 + 1×1 + 0×0 +                        │
│  │[1  0  1]│ 0  1          1×1 + 0×0 + 1×1 = 5                      │
│  │ 0  1  0 │ 1  0                                                     │
│  │ 1  0  1 │ 0  1                                                     │
│  └─────────┘                                                          │
│                                                                        │
│  Step 2: Slide filter right by 1 (stride=1), repeat                   │
│                                                                        │
│  Output (Feature Map) (3×3):                                          │
│  ┌─────────┐                                                          │
│  │ 5  2  5 │  ← Each value = sum of element-wise multiplication     │
│  │ 2  5  2 │     of filter × image patch                             │
│  │ 5  2  5 │                                                          │
│  └─────────┘                                                          │
│                                                                        │
│  Output size = (5-3)/1 + 1 = 3                                       │
│  Formula: (Input - Filter) / Stride + 1                               │
└────────────────────────────────────────────────────────────────────────┘
```

### What Filters Detect

```
┌────────────────────────────────────────────────────────────────┐
│  DIFFERENT FILTERS DETECT DIFFERENT FEATURES                   │
│                                                                │
│  Vertical Edge:     Horizontal Edge:    Blur:                 │
│  ┌─────────┐       ┌───────────┐      ┌─────────────┐       │
│  │-1  0  1 │       │-1  -1  -1 │      │ 1/9 1/9 1/9 │       │
│  │-1  0  1 │       │ 0   0   0 │      │ 1/9 1/9 1/9 │       │
│  │-1  0  1 │       │ 1   1   1 │      │ 1/9 1/9 1/9 │       │
│  └─────────┘       └───────────┘      └─────────────┘       │
│                                                                │
│  Sharpen:           Corner:                                    │
│  ┌───────────┐     ┌───────────┐                              │
│  │ 0  -1   0 │     │-1  -1   0 │                              │
│  │-1   5  -1 │     │-1   0   1 │                              │
│  │ 0  -1   0 │     │ 0   1   1 │                              │
│  └───────────┘     └───────────┘                              │
│                                                                │
│  CNN LEARNS these filters automatically during training!      │
│  Early layers → edges, textures                               │
│  Deeper layers → shapes, objects, faces                       │
└────────────────────────────────────────────────────────────────┘
```

### Padding and Stride

```
┌────────────────────────────────────────────────────────────────┐
│  PADDING                                                       │
│                                                                │
│  'valid' (no padding):        'same' (zero padding):          │
│  Input: 5×5, Filter: 3×3     Input: 5×5, Filter: 3×3         │
│  Output: 3×3                   Output: 5×5 (same size!)       │
│                                                                │
│  ┌─────────────┐              0 0 0 0 0 0 0                  │
│  │ x x x x x   │              0 ┌─────────────┐ 0            │
│  │ x x x x x   │  →           0 │ x x x x x   │ 0            │
│  │ x x x x x   │              0 │ x x x x x   │ 0            │
│  │ x x x x x   │              0 │ x x x x x   │ 0            │
│  │ x x x x x   │              0 │ x x x x x   │ 0            │
│  └─────────────┘              0 │ x x x x x   │ 0            │
│  Shrinks!                      0 └─────────────┘ 0            │
│                                Preserved!                      │
│  STRIDE                                                        │
│  stride=1: move filter 1 pixel at a time (detailed)           │
│  stride=2: move filter 2 pixels (faster, smaller output)      │
└────────────────────────────────────────────────────────────────┘
```

---

## 7.3 CNN Layers

### 1. Convolutional Layer (Conv2D)

```python
from tensorflow.keras.layers import Conv2D

Conv2D(
    filters=32,           # Number of filters (output channels)
    kernel_size=(3, 3),   # Filter size
    strides=(1, 1),       # Step size
    padding='same',       # 'valid' or 'same'
    activation='relu',
    input_shape=(28, 28, 1)  # Height, Width, Channels
)
```

### 2. Pooling Layer (MaxPool2D)

```
┌────────────────────────────────────────────────────────────────┐
│  MAX POOLING (2×2, stride=2) — Reduces spatial dimensions     │
│                                                                │
│  Input (4×4):                     Output (2×2):               │
│  ┌──────┬──────┐                  ┌────┬────┐                 │
│  │ 1  3 │ 2  1 │                  │  6 │  8 │                 │
│  │ 5  6 │ 8  4 │   max of each   ├────┼────┤                 │
│  ├──────┼──────┤   ──────────▶   │  3 │  9 │                 │
│  │ 1  2 │ 3  9 │   2×2 block     └────┴────┘                 │
│  │ 3  1 │ 7  2 │                                              │
│  └──────┴──────┘                                              │
│                                                                │
│  MaxPool: takes MAX value from each block                     │
│  AvgPool: takes AVERAGE value from each block                 │
│  Effect: Halves the spatial size, keeps important features    │
└────────────────────────────────────────────────────────────────┘
```

```python
from tensorflow.keras.layers import MaxPooling2D, AveragePooling2D

MaxPooling2D(pool_size=(2, 2))    # Most common
AveragePooling2D(pool_size=(2, 2))
```

### 3. Flatten Layer

Converts 2D feature maps to 1D vector for Dense layers.

```
(batch, 7, 7, 64) → Flatten → (batch, 3136)
```

---

## 7.4 CNN Architecture

```
┌────────────────────────────────────────────────────────────────────────┐
│  TYPICAL CNN ARCHITECTURE                                              │
│                                                                        │
│  Input        Conv Block 1      Conv Block 2     Classifier           │
│  (Image)                                                               │
│                                                                        │
│  ┌──────┐   ┌──────┐ ┌────┐   ┌──────┐ ┌────┐   ┌──────┐ ┌──────┐  │
│  │28×28 │──▶│Conv2D│─▶│Pool│──▶│Conv2D│─▶│Pool│──▶│Flat- │─▶│Dense │  │
│  │  ×1  │   │32    │  │2×2 │   │64    │  │2×2 │   │ten   │  │128   │  │
│  └──────┘   └──────┘ └────┘   └──────┘ └────┘   └──────┘ └──────┘  │
│                                                         │            │
│  28×28×1    28×28×32  14×14×32  14×14×64  7×7×64  3136  │  128      │
│                                                         ▼            │
│                                                    ┌──────┐          │
│                                                    │Dense │          │
│  FEATURE EXTRACTION                                │ 10   │          │
│  (Conv + Pool layers)                              │softmax│         │
│                                                    └──────┘          │
│                                         CLASSIFICATION               │
│                                         (Dense layers)               │
└────────────────────────────────────────────────────────────────────────┘
```

### Shape Tracking Through CNN

```
Input:      (batch, 28, 28, 1)     ← grayscale image
Conv2D(32): (batch, 28, 28, 32)    ← 32 feature maps
MaxPool:    (batch, 14, 14, 32)    ← halved spatial dims
Conv2D(64): (batch, 14, 14, 64)    ← 64 feature maps
MaxPool:    (batch, 7, 7, 64)      ← halved again
Flatten:    (batch, 3136)           ← 7×7×64 = 3136
Dense(128): (batch, 128)            ← classification head
Dense(10):  (batch, 10)             ← 10 class probabilities
```

---

## 7.5 Complete CNN Example

```python
"""
CNN for Image Classification: CIFAR-10 (10 classes)
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import (
    Conv2D, MaxPooling2D, Flatten, Dense, Dropout, BatchNormalization
)
import matplotlib.pyplot as plt
import numpy as np

# ============================================
# STEP 1: Load CIFAR-10 Dataset
# ============================================
(X_train, y_train), (X_test, y_test) = tf.keras.datasets.cifar10.load_data()

# Normalize pixels to [0, 1]
X_train = X_train.astype('float32') / 255.0
X_test = X_test.astype('float32') / 255.0

class_names = ['airplane', 'automobile', 'bird', 'cat', 'deer',
               'dog', 'frog', 'horse', 'ship', 'truck']

print(f"Train: {X_train.shape}")   # (50000, 32, 32, 3)
print(f"Test:  {X_test.shape}")    # (10000, 32, 32, 3)

# Visualize
fig, axes = plt.subplots(2, 5, figsize=(12, 5))
for i, ax in enumerate(axes.flat):
    ax.imshow(X_train[i])
    ax.set_title(class_names[y_train[i][0]])
    ax.axis('off')
plt.tight_layout()
plt.show()

# ============================================
# STEP 2: Build CNN
# ============================================
model = Sequential([
    # Conv Block 1
    Conv2D(32, (3, 3), activation='relu', padding='same',
           input_shape=(32, 32, 3)),
    BatchNormalization(),
    Conv2D(32, (3, 3), activation='relu', padding='same'),
    MaxPooling2D((2, 2)),
    Dropout(0.25),

    # Conv Block 2
    Conv2D(64, (3, 3), activation='relu', padding='same'),
    BatchNormalization(),
    Conv2D(64, (3, 3), activation='relu', padding='same'),
    MaxPooling2D((2, 2)),
    Dropout(0.25),

    # Conv Block 3
    Conv2D(128, (3, 3), activation='relu', padding='same'),
    BatchNormalization(),
    MaxPooling2D((2, 2)),
    Dropout(0.25),

    # Classifier
    Flatten(),
    Dense(256, activation='relu'),
    Dropout(0.5),
    Dense(10, activation='softmax')
])

model.summary()

# ============================================
# STEP 3: Compile & Train
# ============================================
model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

history = model.fit(
    X_train, y_train,
    epochs=30,
    batch_size=64,
    validation_split=0.1,
    callbacks=[
        tf.keras.callbacks.EarlyStopping(
            monitor='val_loss', patience=5, restore_best_weights=True
        )
    ]
)

# ============================================
# STEP 4: Evaluate
# ============================================
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"\nTest Accuracy: {test_acc:.4f}")

# Plot training curves
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
ax1.plot(history.history['loss'], label='Train')
ax1.plot(history.history['val_loss'], label='Validation')
ax1.set_title('Loss'); ax1.legend()

ax2.plot(history.history['accuracy'], label='Train')
ax2.plot(history.history['val_accuracy'], label='Validation')
ax2.set_title('Accuracy'); ax2.legend()
plt.tight_layout()
plt.show()

# Predictions
predictions = model.predict(X_test[:10])
fig, axes = plt.subplots(2, 5, figsize=(15, 6))
for i, ax in enumerate(axes.flat):
    ax.imshow(X_test[i])
    pred = class_names[np.argmax(predictions[i])]
    actual = class_names[y_test[i][0]]
    color = 'green' if pred == actual else 'red'
    ax.set_title(f"P:{pred}\nA:{actual}", color=color)
    ax.axis('off')
plt.tight_layout()
plt.show()
```

---

## 7.6 Transfer Learning

### Use Pre-trained Models (VGG16, ResNet, etc.)

```
┌────────────────────────────────────────────────────────────────┐
│  TRANSFER LEARNING                                             │
│                                                                │
│  Instead of training from scratch, use a model pre-trained    │
│  on millions of images (ImageNet) and fine-tune it!           │
│                                                                │
│  Pre-trained CNN          Your Classifier                     │
│  (frozen weights)         (trainable)                         │
│  ┌──────────────────┐   ┌──────────────────┐                 │
│  │ Conv layers from  │──▶│ Dense(256, relu) │                 │
│  │ VGG16/ResNet      │   │ Dense(10, softmax)│                │
│  │ (feature extractor)│   │ (your task)       │                │
│  └──────────────────┘   └──────────────────┘                 │
│                                                                │
│  Benefits:                                                     │
│  ✅ Works with small datasets (100s of images)                │
│  ✅ Much faster training                                      │
│  ✅ Better accuracy (pre-learned features)                    │
└────────────────────────────────────────────────────────────────┘
```

```python
from tensorflow.keras.applications import VGG16
from tensorflow.keras import Model
from tensorflow.keras.layers import Dense, Flatten, Dropout, GlobalAveragePooling2D

# Load pre-trained VGG16 (without top classification layers)
base_model = VGG16(weights='imagenet', include_top=False, input_shape=(224, 224, 3))

# Freeze base model weights
base_model.trainable = False

# Add your own classifier
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dense(256, activation='relu')(x)
x = Dropout(0.5)(x)
outputs = Dense(10, activation='softmax')(x)

model = Model(inputs=base_model.input, outputs=outputs)

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

# Train only the new layers (base is frozen)
# model.fit(X_train, y_train, epochs=10, ...)

print(f"Base model params: {base_model.count_params():,} (frozen)")
print(f"Total params: {model.count_params():,}")
```

---

## 7.7 Practice & Assessment

### MCQs

**Q1.** A Conv2D layer with 64 filters and 3×3 kernel on input (28, 28, 3) has how many parameters?
- A) 64
- B) 3×3×3×64 + 64 = 1,792
- C) 28×28×64 = 50,176
- D) 3×3×64 = 576

**Answer:** B — Each filter: 3×3×3 (kernel×channels) weights + 1 bias = 28. Total: 28×64 = 1,792.

---

**Q2.** MaxPooling2D(2,2) on input (16, 16, 32) gives output shape:
- A) (16, 16, 16)
- B) (8, 8, 32)
- C) (8, 8, 16)
- D) (32, 32, 32)

**Answer:** B — Pooling halves spatial dimensions, channels stay the same.

---

**Q3.** Transfer learning is useful when:
- A) You have millions of images
- B) You have a small dataset and want good accuracy
- C) You want to train from scratch
- D) The task is completely different from ImageNet

**Answer:** B — Transfer learning leverages pre-trained features, excellent for small datasets.

---

> **Next Topic:** [08 - RNN, LSTM, GRU](08-rnn-lstm-gru.md)
