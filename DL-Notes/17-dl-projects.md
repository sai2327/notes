# 17. Deep Learning Projects

## Table of Contents
- [17.1 Project 1: Image Classifier (CNN)](#171-project-1-image-classifier-cnn)
- [17.2 Project 2: Sentiment Analysis (LSTM)](#172-project-2-sentiment-analysis-lstm)
- [17.3 Project 3: House Price Prediction (ANN)](#173-project-3-house-price-prediction-ann)
- [17.4 Project 4: Handwritten Digit Recognition (CNN + Deployment)](#174-project-4-handwritten-digit-recognition-cnn--deployment)
- [17.5 Project Ideas for Portfolio](#175-project-ideas-for-portfolio)

---

## 17.1 Project 1: Image Classifier (CNN)

### CIFAR-10 Image Classification with Data Augmentation

```python
"""
PROJECT 1: CIFAR-10 Image Classifier
Goal: Classify 32x32 color images into 10 categories
Dataset: 60,000 images (50K train, 10K test)
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import (
    Conv2D, MaxPooling2D, Dense, Flatten,
    Dropout, BatchNormalization, GlobalAveragePooling2D
)
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau
import matplotlib.pyplot as plt
import numpy as np

# ============================================
# 1. Load & Preprocess
# ============================================
(X_train, y_train), (X_test, y_test) = tf.keras.datasets.cifar10.load_data()
X_train, X_test = X_train / 255.0, X_test / 255.0

CLASS_NAMES = ['Airplane', 'Car', 'Bird', 'Cat', 'Deer',
               'Dog', 'Frog', 'Horse', 'Ship', 'Truck']

print(f"Training: {X_train.shape}, Labels: {y_train.shape}")
print(f"Testing:  {X_test.shape}")

# Visualize samples
fig, axes = plt.subplots(2, 5, figsize=(12, 5))
for i, ax in enumerate(axes.flat):
    ax.imshow(X_train[i])
    ax.set_title(CLASS_NAMES[y_train[i][0]])
    ax.axis('off')
plt.suptitle('CIFAR-10 Samples'); plt.show()

# ============================================
# 2. Data Augmentation
# ============================================
data_augmentation = Sequential([
    tf.keras.layers.RandomFlip("horizontal"),
    tf.keras.layers.RandomRotation(0.1),
    tf.keras.layers.RandomZoom(0.1),
    tf.keras.layers.RandomTranslation(0.1, 0.1),
])

# ============================================
# 3. Build CNN Model
# ============================================
model = Sequential([
    # Augmentation (only during training)
    data_augmentation,

    # Block 1
    Conv2D(32, (3, 3), activation='relu', padding='same', input_shape=(32, 32, 3)),
    BatchNormalization(),
    Conv2D(32, (3, 3), activation='relu', padding='same'),
    BatchNormalization(),
    MaxPooling2D((2, 2)),
    Dropout(0.25),

    # Block 2
    Conv2D(64, (3, 3), activation='relu', padding='same'),
    BatchNormalization(),
    Conv2D(64, (3, 3), activation='relu', padding='same'),
    BatchNormalization(),
    MaxPooling2D((2, 2)),
    Dropout(0.25),

    # Block 3
    Conv2D(128, (3, 3), activation='relu', padding='same'),
    BatchNormalization(),
    Conv2D(128, (3, 3), activation='relu', padding='same'),
    BatchNormalization(),
    MaxPooling2D((2, 2)),
    Dropout(0.25),

    # Classifier
    GlobalAveragePooling2D(),
    Dense(256, activation='relu'),
    BatchNormalization(),
    Dropout(0.5),
    Dense(10, activation='softmax')
])

model.summary()

# ============================================
# 4. Compile & Train
# ============================================
model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

callbacks = [
    EarlyStopping(patience=10, restore_best_weights=True),
    ReduceLROnPlateau(factor=0.5, patience=5, min_lr=1e-6)
]

history = model.fit(
    X_train, y_train,
    epochs=100,
    batch_size=64,
    validation_split=0.1,
    callbacks=callbacks
)

# ============================================
# 5. Evaluate
# ============================================
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"\n{'='*40}")
print(f"Test Accuracy: {test_acc:.4f}")
print(f"Test Loss:     {test_loss:.4f}")
print(f"{'='*40}")

# ============================================
# 6. Visualize Results
# ============================================
# Learning curves
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
ax1.plot(history.history['loss'], label='Train')
ax1.plot(history.history['val_loss'], label='Val')
ax1.set_title('Loss'); ax1.legend(); ax1.set_xlabel('Epoch')
ax2.plot(history.history['accuracy'], label='Train')
ax2.plot(history.history['val_accuracy'], label='Val')
ax2.set_title('Accuracy'); ax2.legend(); ax2.set_xlabel('Epoch')
plt.tight_layout(); plt.show()

# Sample predictions
predictions = model.predict(X_test[:10])
fig, axes = plt.subplots(2, 5, figsize=(15, 6))
for i, ax in enumerate(axes.flat):
    ax.imshow(X_test[i])
    pred = CLASS_NAMES[np.argmax(predictions[i])]
    true = CLASS_NAMES[y_test[i][0]]
    color = 'green' if pred == true else 'red'
    ax.set_title(f"P:{pred}\nT:{true}", color=color, fontsize=10)
    ax.axis('off')
plt.suptitle('Predictions (Green=Correct, Red=Wrong)'); plt.show()

# Save
model.save('cifar10_classifier.keras')
```

---

## 17.2 Project 2: Sentiment Analysis (LSTM)

### IMDB Movie Review Classifier

```python
"""
PROJECT 2: IMDB Sentiment Analysis with Bidirectional LSTM
Goal: Classify movie reviews as Positive or Negative
Dataset: 50,000 reviews (25K train, 25K test)
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import (
    Embedding, Bidirectional, LSTM, Dense,
    Dropout, GlobalMaxPooling1D
)
import numpy as np
import matplotlib.pyplot as plt

# ============================================
# 1. Load & Preprocess
# ============================================
VOCAB_SIZE = 10000
MAX_LENGTH = 250
EMBEDDING_DIM = 128

(X_train, y_train), (X_test, y_test) = tf.keras.datasets.imdb.load_data(
    num_words=VOCAB_SIZE
)

X_train = tf.keras.preprocessing.sequence.pad_sequences(
    X_train, maxlen=MAX_LENGTH, padding='post'
)
X_test = tf.keras.preprocessing.sequence.pad_sequences(
    X_test, maxlen=MAX_LENGTH, padding='post'
)

print(f"Train: {X_train.shape}, Test: {X_test.shape}")

# Decode a review to verify
word_index = tf.keras.datasets.imdb.get_word_index()
reverse_index = {v+3: k for k, v in word_index.items()}
reverse_index[0] = '<PAD>'; reverse_index[1] = '<START>'
reverse_index[2] = '<UNK>'; reverse_index[3] = '<UNUSED>'

sample = ' '.join([reverse_index.get(i, '?') for i in X_train[0][:50]])
print(f"Sample review: {sample}...")
print(f"Label: {'Positive' if y_train[0] else 'Negative'}")

# ============================================
# 2. Build Model
# ============================================
model = Sequential([
    Embedding(VOCAB_SIZE, EMBEDDING_DIM, input_length=MAX_LENGTH),
    Bidirectional(LSTM(64, return_sequences=True)),
    GlobalMaxPooling1D(),
    Dense(64, activation='relu'),
    Dropout(0.5),
    Dense(1, activation='sigmoid')
])

model.summary()

# ============================================
# 3. Train
# ============================================
model.compile(
    optimizer='adam',
    loss='binary_crossentropy',
    metrics=['accuracy']
)

history = model.fit(
    X_train, y_train,
    epochs=15,
    batch_size=64,
    validation_split=0.2,
    callbacks=[
        tf.keras.callbacks.EarlyStopping(patience=3, restore_best_weights=True)
    ]
)

# ============================================
# 4. Evaluate
# ============================================
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"\nTest Accuracy: {test_acc:.4f}")

# ============================================
# 5. Predict on Custom Text
# ============================================
def predict_review(text):
    words = text.lower().split()
    seq = [word_index.get(w, 2) + 3 for w in words]  # +3 for reserved tokens
    seq = [min(i, VOCAB_SIZE - 1) for i in seq]       # Cap to vocab size
    padded = tf.keras.preprocessing.sequence.pad_sequences(
        [seq], maxlen=MAX_LENGTH, padding='post'
    )
    score = model.predict(padded, verbose=0)[0][0]
    sentiment = "POSITIVE" if score > 0.5 else "NEGATIVE"
    print(f"Review: \"{text[:60]}...\"")
    print(f"Prediction: {sentiment} (confidence: {score:.4f})\n")

predict_review("This movie was absolutely wonderful and I loved every minute")
predict_review("Terrible waste of time, horrible acting and boring plot")
predict_review("The film was okay, nothing special but not bad either")

# Plot
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
ax1.plot(history.history['loss'], label='Train')
ax1.plot(history.history['val_loss'], label='Val')
ax1.set_title('Loss'); ax1.legend()
ax2.plot(history.history['accuracy'], label='Train')
ax2.plot(history.history['val_accuracy'], label='Val')
ax2.set_title('Accuracy'); ax2.legend()
plt.tight_layout(); plt.show()

model.save('sentiment_analyzer.keras')
```

---

## 17.3 Project 3: House Price Prediction (ANN)

### Regression with California Housing Dataset

```python
"""
PROJECT 3: House Price Prediction using ANN
Goal: Predict median house value from 8 features
Dataset: California Housing (20,640 samples)
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Dropout, BatchNormalization
from sklearn.datasets import fetch_california_housing
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import numpy as np
import matplotlib.pyplot as plt

# ============================================
# 1. Load & Preprocess
# ============================================
data = fetch_california_housing()
X, y = data.data, data.target

print(f"Features: {data.feature_names}")
print(f"Shape: {X.shape}, Target range: [{y.min():.2f}, {y.max():.2f}]")

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Scale features (CRITICAL for ANN!)
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

# ============================================
# 2. Build Model
# ============================================
model = Sequential([
    Dense(128, activation='relu', input_shape=(X_train.shape[1],)),
    BatchNormalization(),
    Dropout(0.3),

    Dense(64, activation='relu'),
    BatchNormalization(),
    Dropout(0.2),

    Dense(32, activation='relu'),

    Dense(1)  # Regression: no activation!
])

model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
    loss='mse',
    metrics=['mae']
)

model.summary()

# ============================================
# 3. Train
# ============================================
history = model.fit(
    X_train, y_train,
    epochs=100,
    batch_size=32,
    validation_split=0.2,
    callbacks=[
        tf.keras.callbacks.EarlyStopping(patience=10, restore_best_weights=True),
        tf.keras.callbacks.ReduceLROnPlateau(factor=0.5, patience=5)
    ],
    verbose=0
)

# ============================================
# 4. Evaluate
# ============================================
test_loss, test_mae = model.evaluate(X_test, y_test)
print(f"\nTest MSE:  {test_loss:.4f}")
print(f"Test MAE:  {test_mae:.4f}")
print(f"Test RMSE: {np.sqrt(test_loss):.4f}")

# ============================================
# 5. Visualize
# ============================================
# Learning curves
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
ax1.plot(history.history['loss'], label='Train')
ax1.plot(history.history['val_loss'], label='Val')
ax1.set_title('MSE Loss'); ax1.legend()
ax2.plot(history.history['mae'], label='Train')
ax2.plot(history.history['val_mae'], label='Val')
ax2.set_title('MAE'); ax2.legend()
plt.tight_layout(); plt.show()

# Predicted vs Actual
y_pred = model.predict(X_test, verbose=0).flatten()
plt.figure(figsize=(8, 8))
plt.scatter(y_test, y_pred, alpha=0.3, s=10)
plt.plot([0, 5], [0, 5], 'r--', label='Perfect prediction')
plt.xlabel('Actual Price ($100K)')
plt.ylabel('Predicted Price ($100K)')
plt.title('Predicted vs Actual House Prices')
plt.legend(); plt.show()

model.save('house_price_model.keras')
```

---

## 17.4 Project 4: Handwritten Digit Recognition (CNN + Deployment)

### End-to-End: Train → Save → Deploy

```python
"""
PROJECT 4: MNIST Digit Recognition — Train & Prepare for Deployment
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import (
    Conv2D, MaxPooling2D, Dense, Flatten, Dropout, BatchNormalization
)
import numpy as np
import matplotlib.pyplot as plt

# ============================================
# 1. Load Data
# ============================================
(X_train, y_train), (X_test, y_test) = tf.keras.datasets.mnist.load_data()
X_train = X_train.reshape(-1, 28, 28, 1) / 255.0
X_test = X_test.reshape(-1, 28, 28, 1) / 255.0

# ============================================
# 2. Build CNN
# ============================================
model = Sequential([
    Conv2D(32, (3, 3), activation='relu', input_shape=(28, 28, 1)),
    BatchNormalization(),
    MaxPooling2D((2, 2)),

    Conv2D(64, (3, 3), activation='relu'),
    BatchNormalization(),
    MaxPooling2D((2, 2)),

    Flatten(),
    Dense(128, activation='relu'),
    Dropout(0.5),
    Dense(10, activation='softmax')
])

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

# ============================================
# 3. Train
# ============================================
history = model.fit(
    X_train, y_train,
    epochs=15, batch_size=64,
    validation_split=0.1,
    callbacks=[tf.keras.callbacks.EarlyStopping(patience=3, restore_best_weights=True)]
)

# ============================================
# 4. Evaluate
# ============================================
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"\nTest Accuracy: {test_acc:.4f}")
# Expected: ~99.2%+

# ============================================
# 5. Save for Deployment
# ============================================
model.save('mnist_model.keras')
print("Model saved!")

# Convert to TFLite for mobile
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()
with open('mnist_model.tflite', 'wb') as f:
    f.write(tflite_model)
print(f"TFLite model: {len(tflite_model)/1024:.1f} KB")
```

### Flask API for This Model

```python
"""
app.py — Digit Recognition API
"""
from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
from PIL import Image
import io

app = Flask(__name__)
model = tf.keras.models.load_model('mnist_model.keras')

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file'}), 400

    file = request.files['file']
    img = Image.open(io.BytesIO(file.read())).convert('L').resize((28, 28))
    img_array = np.array(img).reshape(1, 28, 28, 1) / 255.0

    predictions = model.predict(img_array, verbose=0)
    digit = int(np.argmax(predictions[0]))
    confidence = float(np.max(predictions[0]))

    return jsonify({
        'digit': digit,
        'confidence': round(confidence, 4)
    })

if __name__ == '__main__':
    app.run(port=5000, debug=False)
```

---

## 17.5 Project Ideas for Portfolio

```
┌────────────────────────────────────────────────────────────────────┐
│  DL PROJECT IDEAS FOR YOUR PORTFOLIO                              │
│                                                                    │
│  BEGINNER:                                                        │
│  ├── MNIST Digit Classification (CNN) ✅                          │
│  ├── CIFAR-10 Image Classifier (CNN) ✅                           │
│  ├── IMDB Sentiment Analysis (LSTM) ✅                            │
│  └── House Price Prediction (ANN) ✅                              │
│                                                                    │
│  INTERMEDIATE:                                                    │
│  ├── Cat vs Dog Classifier (Transfer Learning)                   │
│  ├── Fake News Detection (LSTM / BERT)                           │
│  ├── Stock Price Prediction (LSTM time series)                   │
│  ├── Music Genre Classification (CNN on spectrograms)            │
│  └── Image Caption Generator (CNN + LSTM)                        │
│                                                                    │
│  ADVANCED:                                                        │
│  ├── Object Detection (YOLO / SSD)                               │
│  ├── Face Recognition System                                     │
│  ├── Neural Machine Translation (Transformer)                    │
│  ├── Chatbot (Seq2Seq / GPT fine-tune)                           │
│  ├── Image Super-Resolution (GAN)                                │
│  └── Medical Image Diagnosis (CNN + Grad-CAM)                    │
│                                                                    │
│  EACH PROJECT SHOULD INCLUDE:                                    │
│  ✅ Problem statement & dataset description                      │
│  ✅ Data preprocessing & EDA                                     │
│  ✅ Model architecture with justification                        │
│  ✅ Training with learning curves                                │
│  ✅ Evaluation metrics (not just accuracy!)                      │
│  ✅ Deployment (Flask API or Streamlit app)                      │
│  ✅ GitHub README with instructions                              │
└────────────────────────────────────────────────────────────────────┘
```

---

> **Congratulations! You've completed the Deep Learning Notes.**
> Go back to: [01 - DL Foundations](01-dl-foundations.md) | [16 - Cheat Sheet](16-dl-cheatsheet-interview.md)
