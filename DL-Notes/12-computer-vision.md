# 12. Computer Vision with Deep Learning

## Table of Contents
- [12.1 What is Computer Vision?](#121-what-is-computer-vision)
- [12.2 Image Basics for DL](#122-image-basics-for-dl)
- [12.3 Image Preprocessing Pipeline](#123-image-preprocessing-pipeline)
- [12.4 CNN for Image Classification](#124-cnn-for-image-classification)
- [12.5 Transfer Learning for Vision](#125-transfer-learning-for-vision)
- [12.6 Object Detection & Segmentation](#126-object-detection--segmentation)
- [12.7 Complete Project: Image Classifier](#127-complete-project-image-classifier)
- [12.8 Practice & Assessment](#128-practice--assessment)

---

## 12.1 What is Computer Vision?

```
┌────────────────────────────────────────────────────────────────┐
│  COMPUTER VISION TASKS                                         │
│                                                                │
│  1. IMAGE CLASSIFICATION:                                     │
│     "What is this?" → "Cat" (one label for whole image)       │
│                                                                │
│  2. OBJECT DETECTION:                                          │
│     "Where are things?" → Bounding boxes + labels             │
│     [Cat: (x,y,w,h)] [Dog: (x,y,w,h)]                       │
│                                                                │
│  3. SEMANTIC SEGMENTATION:                                     │
│     "Label every pixel" → Pixel-level classification          │
│     Sky=blue, Road=gray, Car=red                              │
│                                                                │
│  4. INSTANCE SEGMENTATION:                                     │
│     "Separate each object" → Each object gets unique mask     │
│     Car1=red, Car2=green, Person1=blue                        │
│                                                                │
│  5. FACE RECOGNITION:                                          │
│     "Who is this person?"                                     │
│                                                                │
│  6. IMAGE GENERATION:                                          │
│     "Create a new image" → GANs, Diffusion models            │
└────────────────────────────────────────────────────────────────┘
```

---

## 12.2 Image Basics for DL

```
┌────────────────────────────────────────────────────────────────┐
│  HOW COMPUTERS SEE IMAGES                                      │
│                                                                │
│  Grayscale Image (28×28):     Color Image (224×224×3):        │
│  ┌──────────────────┐         ┌──────────────────┐            │
│  │ 0   0  50 200 255│         │ R Channel (224×224)│           │
│  │ 0  30 150 230 255│         │ G Channel (224×224)│           │
│  │10  80 200 240 250│         │ B Channel (224×224)│           │
│  │50 120 210 245 255│         └──────────────────┘            │
│  │100 180 230 250 255│                                         │
│  └──────────────────┘        Shape: (224, 224, 3)             │
│  Shape: (28, 28, 1)          Values: 0-255 per channel        │
│  Values: 0 (black) - 255 (white)                              │
│                                                                │
│  NORMALIZATION: Divide by 255 → [0.0, 1.0]                   │
│  Why? Neural networks work better with small values           │
│                                                                │
│  Common Input Sizes:                                           │
│  MNIST:     28×28×1                                           │
│  CIFAR-10:  32×32×3                                           │
│  ImageNet:  224×224×3                                         │
│  Medical:   512×512×1 or ×3                                   │
└────────────────────────────────────────────────────────────────┘
```

---

## 12.3 Image Preprocessing Pipeline

```python
import tensorflow as tf
import numpy as np

# ============================================
# Loading Images
# ============================================

# From directory (most common in real projects)
train_ds = tf.keras.utils.image_dataset_from_directory(
    'data/train/',           # Folder with subfolders per class
    image_size=(224, 224),   # Resize all images
    batch_size=32,
    label_mode='categorical' # One-hot encoding
)
# data/train/
#   ├── cats/
#   │   ├── cat1.jpg
#   │   └── cat2.jpg
#   └── dogs/
#       ├── dog1.jpg
#       └── dog2.jpg

# ============================================
# Preprocessing Layers
# ============================================
preprocessing = tf.keras.Sequential([
    tf.keras.layers.Rescaling(1./255),           # Normalize
    tf.keras.layers.RandomFlip("horizontal"),     # Augmentation
    tf.keras.layers.RandomRotation(0.1),
    tf.keras.layers.RandomZoom(0.1),
])

# ============================================
# Pre-trained Model Preprocessing
# ============================================
from tensorflow.keras.applications import vgg16, resnet50

# Each model has its own preprocessing!
preprocessed = vgg16.preprocess_input(images)      # Scales to [-1,1] or [0,255]
preprocessed = resnet50.preprocess_input(images)    # Caffe-style preprocessing
```

---

## 12.4 CNN for Image Classification

### Architecture Patterns

```
┌────────────────────────────────────────────────────────────────────┐
│  CNN ARCHITECTURE PATTERN FOR CLASSIFICATION                      │
│                                                                    │
│  Input (224×224×3)                                                │
│    │                                                               │
│    ├── FEATURE EXTRACTION (learn patterns)                        │
│    │   ┌─────────────────────────────────────┐                   │
│    │   │ Conv2D(32) → BatchNorm → ReLU       │                   │
│    │   │ Conv2D(32) → BatchNorm → ReLU       │  Block 1          │
│    │   │ MaxPool(2×2) → Dropout(0.25)        │  112×112×32      │
│    │   ├─────────────────────────────────────┤                   │
│    │   │ Conv2D(64) → BatchNorm → ReLU       │                   │
│    │   │ Conv2D(64) → BatchNorm → ReLU       │  Block 2          │
│    │   │ MaxPool(2×2) → Dropout(0.25)        │  56×56×64        │
│    │   ├─────────────────────────────────────┤                   │
│    │   │ Conv2D(128) → BatchNorm → ReLU      │                   │
│    │   │ Conv2D(128) → BatchNorm → ReLU      │  Block 3          │
│    │   │ MaxPool(2×2) → Dropout(0.25)        │  28×28×128       │
│    │   └─────────────────────────────────────┘                   │
│    │                                                               │
│    ├── CLASSIFIER (make decision)                                 │
│    │   ┌─────────────────────────────────────┐                   │
│    │   │ Flatten or GlobalAveragePooling2D   │                   │
│    │   │ Dense(256) → Dropout(0.5)           │                   │
│    │   │ Dense(num_classes, softmax)          │                   │
│    │   └─────────────────────────────────────┘                   │
│    │                                                               │
│  Output: [0.01, 0.02, 0.95, 0.02]  → Class 2                    │
│                                                                    │
│  PATTERN: Increase filters, decrease spatial size!                │
│  32 → 64 → 128 → 256  (filters double)                          │
│  224 → 112 → 56 → 28  (size halves with pooling)                │
└────────────────────────────────────────────────────────────────────┘
```

---

## 12.5 Transfer Learning for Vision

```
┌────────────────────────────────────────────────────────────────────┐
│  TRANSFER LEARNING — Use pre-trained models as starting point    │
│                                                                    │
│  Instead of training from scratch on YOUR data,                  │
│  use a model already trained on ImageNet (1.2M images, 1000 cls)│
│                                                                    │
│  Pre-trained Model         Your Task                              │
│  (trained on ImageNet)     (e.g., 200 cat vs dog images)         │
│  ┌─────────────────┐      ┌─────────────────┐                   │
│  │ Conv layers      │      │ Conv layers      │ ← FROZEN         │
│  │ (learned edges,  │  ──▶ │ (reuse features!)│ (don't train)   │
│  │  textures, etc.) │      │                  │                   │
│  │ Dense layers     │      │ YOUR Dense layers│ ← TRAINABLE     │
│  │ (1000 classes)   │      │ (2 classes)      │ (train these!)  │
│  └─────────────────┘      └─────────────────┘                   │
│                                                                    │
│  Strategy depends on YOUR data size:                              │
│  ┌──────────────┬────────────────────────────┐                   │
│  │ Data Size    │ Strategy                   │                   │
│  ├──────────────┼────────────────────────────┤                   │
│  │ Very Small   │ Freeze ALL conv, train     │                   │
│  │ (<1000)      │ only classifier head       │                   │
│  ├──────────────┼────────────────────────────┤                   │
│  │ Medium       │ Freeze early conv, fine-   │                   │
│  │ (1000-10000) │ tune last few conv layers  │                   │
│  ├──────────────┼────────────────────────────┤                   │
│  │ Large        │ Fine-tune entire model     │                   │
│  │ (>10000)     │ with small learning rate   │                   │
│  └──────────────┴────────────────────────────┘                   │
└────────────────────────────────────────────────────────────────────┘
```

### Popular Pre-trained Models

| Model | Year | Params | Top-5 Acc | Use Case |
|-------|------|--------|-----------|----------|
| VGG16 | 2014 | 138M | 92.7% | Simple, educational |
| ResNet50 | 2015 | 25M | 93.3% | Good balance |
| InceptionV3 | 2015 | 24M | 93.7% | Multi-scale features |
| MobileNetV2 | 2018 | 3.4M | 90.1% | Mobile/edge devices |
| EfficientNet | 2019 | 5-66M | 97.1% | Best accuracy/size ratio |

---

## 12.6 Object Detection & Segmentation

```
┌────────────────────────────────────────────────────────────────┐
│  BEYOND CLASSIFICATION                                         │
│                                                                │
│  OBJECT DETECTION Models:                                     │
│  ┌───────────┬──────────────────────────────────┐             │
│  │ Model     │ Description                      │             │
│  ├───────────┼──────────────────────────────────┤             │
│  │ YOLO      │ Real-time, single pass detection │             │
│  │ SSD       │ Single Shot Detector, fast       │             │
│  │ Faster    │ Two-stage: region proposal +     │             │
│  │ R-CNN     │ classification, more accurate    │             │
│  └───────────┴──────────────────────────────────┘             │
│                                                                │
│  SEGMENTATION Models:                                         │
│  ┌───────────┬──────────────────────────────────┐             │
│  │ Model     │ Description                      │             │
│  ├───────────┼──────────────────────────────────┤             │
│  │ U-Net     │ Medical imaging (encoder-decoder)│             │
│  │ Mask      │ Instance segmentation            │             │
│  │ R-CNN     │ (detect + segment each object)   │             │
│  │ DeepLab   │ Semantic segmentation (Google)   │             │
│  └───────────┴──────────────────────────────────┘             │
└────────────────────────────────────────────────────────────────┘
```

---

## 12.7 Complete Project: Image Classifier

### Transfer Learning with MobileNetV2

```python
"""
Complete Image Classifier: Cats vs Dogs using Transfer Learning
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import (
    Dense, Dropout, GlobalAveragePooling2D
)
from tensorflow.keras.applications import MobileNetV2
import matplotlib.pyplot as plt

# ============================================
# STEP 1: Load Data from Directory
# ============================================
IMG_SIZE = (160, 160)
BATCH_SIZE = 32

# Option A: From directory structure
# train_ds = tf.keras.utils.image_dataset_from_directory(
#     'data/cats_vs_dogs/train', image_size=IMG_SIZE, batch_size=BATCH_SIZE
# )

# Option B: Using TF Datasets (for demo)
import tensorflow_datasets as tfds

(raw_train, raw_val, raw_test), metadata = tfds.load(
    'cats_vs_dogs',
    split=['train[:80%]', 'train[80%:90%]', 'train[90%:]'],
    with_info=True,
    as_supervised=True
)

def preprocess(image, label):
    image = tf.image.resize(image, IMG_SIZE)
    image = image / 255.0
    return image, label

train_ds = raw_train.map(preprocess).batch(BATCH_SIZE).prefetch(tf.data.AUTOTUNE)
val_ds = raw_val.map(preprocess).batch(BATCH_SIZE).prefetch(tf.data.AUTOTUNE)
test_ds = raw_test.map(preprocess).batch(BATCH_SIZE).prefetch(tf.data.AUTOTUNE)

# ============================================
# STEP 2: Data Augmentation
# ============================================
data_augmentation = tf.keras.Sequential([
    tf.keras.layers.RandomFlip('horizontal'),
    tf.keras.layers.RandomRotation(0.2),
    tf.keras.layers.RandomZoom(0.2),
])

# ============================================
# STEP 3: Load Pre-trained MobileNetV2
# ============================================
base_model = MobileNetV2(
    input_shape=(160, 160, 3),
    include_top=False,        # Remove original classifier
    weights='imagenet'        # Pre-trained on ImageNet
)
base_model.trainable = False  # FREEZE all layers

# ============================================
# STEP 4: Build Complete Model
# ============================================
model = tf.keras.Sequential([
    data_augmentation,
    base_model,
    GlobalAveragePooling2D(),
    Dropout(0.3),
    Dense(1, activation='sigmoid')  # Binary: cat or dog
])

model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
    loss='binary_crossentropy',
    metrics=['accuracy']
)

model.summary()

# ============================================
# STEP 5: Train (Frozen Base)
# ============================================
history = model.fit(
    train_ds,
    epochs=10,
    validation_data=val_ds,
    callbacks=[
        tf.keras.callbacks.EarlyStopping(patience=3, restore_best_weights=True)
    ]
)

# ============================================
# STEP 6: Fine-tune (Unfreeze Top Layers)
# ============================================
base_model.trainable = True

# Freeze all except last 20 layers
for layer in base_model.layers[:-20]:
    layer.trainable = False

model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=1e-5),  # Very small LR!
    loss='binary_crossentropy',
    metrics=['accuracy']
)

history_fine = model.fit(
    train_ds,
    epochs=10,
    validation_data=val_ds,
    callbacks=[
        tf.keras.callbacks.EarlyStopping(patience=3, restore_best_weights=True)
    ]
)

# ============================================
# STEP 7: Evaluate
# ============================================
test_loss, test_acc = model.evaluate(test_ds)
print(f"\nTest Accuracy: {test_acc:.4f}")

# Plot training history
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
ax1.plot(history.history['loss'] + history_fine.history['loss'], label='Train')
ax1.plot(history.history['val_loss'] + history_fine.history['val_loss'], label='Val')
ax1.axvline(x=len(history.history['loss']), color='r', linestyle='--', label='Fine-tune start')
ax1.set_title('Loss'); ax1.legend()
ax2.plot(history.history['accuracy'] + history_fine.history['accuracy'], label='Train')
ax2.plot(history.history['val_accuracy'] + history_fine.history['val_accuracy'], label='Val')
ax2.axvline(x=len(history.history['accuracy']), color='r', linestyle='--', label='Fine-tune start')
ax2.set_title('Accuracy'); ax2.legend()
plt.tight_layout()
plt.show()
```

---

## 12.8 Practice & Assessment

### MCQs

**Q1.** The standard preprocessing step for images before feeding to a neural network is:
- A) Multiply by 255
- B) Divide by 255 to normalize to [0, 1]
- C) Convert to grayscale
- D) Resize to 28×28

**Answer:** B — Normalizing pixel values from [0, 255] to [0, 1] helps neural networks train faster and converge better.

---

**Q2.** In transfer learning, "freezing" layers means:
- A) Deleting the layers
- B) Setting trainable=False so weights don't update
- C) Making layers run faster
- D) Adding more layers

**Answer:** B — Frozen layers retain their pre-trained weights, only the new classifier head is trained.

---

**Q3.** Data augmentation helps prevent overfitting by:
- A) Removing training samples
- B) Artificially increasing training data diversity via transforms
- C) Making the model simpler
- D) Increasing the learning rate

**Answer:** B — Random flips, rotations, zooms, etc. create varied versions of training images.

---

> **Next Topic:** [13 - NLP Basics](13-nlp-basics.md)
