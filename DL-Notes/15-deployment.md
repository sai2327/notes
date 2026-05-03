# 15. Model Deployment

## Table of Contents
- [15.1 Deployment Overview](#151-deployment-overview)
- [15.2 Save & Load Models](#152-save--load-models)
- [15.3 TensorFlow SavedModel](#153-tensorflow-savedmodel)
- [15.4 TensorFlow Lite (Mobile)](#154-tensorflow-lite-mobile)
- [15.5 Flask REST API](#155-flask-rest-api)
- [15.6 FastAPI Deployment](#156-fastapi-deployment)
- [15.7 Docker Containerization](#157-docker-containerization)
- [15.8 Practice & Assessment](#158-practice--assessment)

---

## 15.1 Deployment Overview

```
┌────────────────────────────────────────────────────────────────────┐
│  FROM TRAINING TO PRODUCTION                                      │
│                                                                    │
│  Development                        Production                    │
│  ┌──────────────────┐              ┌──────────────────┐           │
│  │ 1. Train model   │              │ 5. REST API      │           │
│  │ 2. Evaluate      │ ─── Save ──▶│ 6. Serve requests│           │
│  │ 3. Tune          │    model     │ 7. Monitor       │           │
│  │ 4. Export        │              │ 8. Update        │           │
│  └──────────────────┘              └──────────────────┘           │
│                                                                    │
│  DEPLOYMENT OPTIONS:                                              │
│  ┌──────────────┬───────────────────────────────────┐             │
│  │ Platform     │ Best For                          │             │
│  ├──────────────┼───────────────────────────────────┤             │
│  │ Flask/FastAPI│ Custom REST API (your server)     │             │
│  │ TF Serving   │ High-performance production       │             │
│  │ TF Lite      │ Mobile & edge devices            │             │
│  │ TF.js        │ Browser-based inference          │             │
│  │ Docker       │ Containerized deployment          │             │
│  │ Cloud (AWS/  │ Scalable production              │             │
│  │  GCP/Azure)  │                                   │             │
│  └──────────────┴───────────────────────────────────┘             │
└────────────────────────────────────────────────────────────────────┘
```

---

## 15.2 Save & Load Models

### Three Methods

```python
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Flatten

# Build and train a model
model = Sequential([
    Flatten(input_shape=(28, 28)),
    Dense(128, activation='relu'),
    Dense(10, activation='softmax')
])
model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

(X_train, y_train), _ = tf.keras.datasets.mnist.load_data()
model.fit(X_train / 255.0, y_train, epochs=3, verbose=0)

# ============================================
# METHOD 1: Save Entire Model (Recommended)
# ============================================
# Keras format (default)
model.save('my_model.keras')
loaded_model = tf.keras.models.load_model('my_model.keras')

# HDF5 format (legacy)
model.save('my_model.h5')
loaded_model = tf.keras.models.load_model('my_model.h5')

# ============================================
# METHOD 2: Save Weights Only
# ============================================
model.save_weights('model_weights.weights.h5')

# To load: must build same architecture first!
new_model = Sequential([
    Flatten(input_shape=(28, 28)),
    Dense(128, activation='relu'),
    Dense(10, activation='softmax')
])
new_model.load_weights('model_weights.weights.h5')

# ============================================
# METHOD 3: Save During Training (Checkpoint)
# ============================================
checkpoint = tf.keras.callbacks.ModelCheckpoint(
    'best_model.keras',
    monitor='val_accuracy',
    save_best_only=True,    # Only save when val_acc improves
    mode='max'
)

model.fit(X_train / 255.0, y_train,
          epochs=10, validation_split=0.2,
          callbacks=[checkpoint])
```

```
┌────────────────────────────────────────────────────────────────┐
│  WHAT GETS SAVED?                                              │
│                                                                │
│  model.save():        Saves EVERYTHING                        │
│  ├── Architecture (layers, activations)                       │
│  ├── Trained weights                                          │
│  ├── Optimizer state                                          │
│  └── Compilation config (loss, metrics)                       │
│                                                                │
│  model.save_weights(): Saves ONLY weights                     │
│  └── Must rebuild architecture manually to load               │
│                                                                │
│  Recommendation: Use model.save('name.keras')                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 15.3 TensorFlow SavedModel

```python
# SavedModel format (for TF Serving, production)
model.save('saved_model_dir')
# Creates:
# saved_model_dir/
#   ├── saved_model.pb        (model architecture + weights)
#   ├── variables/
#   │   ├── variables.data-00000-of-00001
#   │   └── variables.index
#   └── assets/

# Load
loaded = tf.keras.models.load_model('saved_model_dir')

# Convert to TF Lite (for mobile)
converter = tf.lite.TFLiteConverter.from_saved_model('saved_model_dir')
tflite_model = converter.convert()
with open('model.tflite', 'wb') as f:
    f.write(tflite_model)
```

---

## 15.4 TensorFlow Lite (Mobile)

```python
# Convert Keras model to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)

# Optional: Quantize for smaller size and faster inference
converter.optimizations = [tf.lite.Optimize.DEFAULT]

tflite_model = converter.convert()

# Save
with open('model.tflite', 'wb') as f:
    f.write(tflite_model)

print(f"Model size: {len(tflite_model) / 1024:.1f} KB")

# Test TFLite model
import numpy as np

interpreter = tf.lite.Interpreter(model_path='model.tflite')
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Run inference
test_image = np.expand_dims(X_train[0] / 255.0, axis=0).astype(np.float32)
interpreter.set_tensor(input_details[0]['index'], test_image)
interpreter.invoke()
prediction = interpreter.get_tensor(output_details[0]['index'])
print(f"Predicted class: {np.argmax(prediction)}")
```

---

## 15.5 Flask REST API

### Project Structure

```
ml_api/
├── app.py              # Flask application
├── model.keras         # Saved model
├── requirements.txt    # Dependencies
└── templates/
    └── index.html      # Simple UI (optional)
```

### Flask API Code

```python
"""
app.py — Flask API for Image Classification
"""
from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
from PIL import Image
import io

app = Flask(__name__)

# Load model ONCE at startup
model = tf.keras.models.load_model('model.keras')
CLASS_NAMES = ['T-shirt', 'Trouser', 'Pullover', 'Dress', 'Coat',
               'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']

@app.route('/')
def home():
    return jsonify({'status': 'Model API is running', 'model': 'Fashion MNIST'})

@app.route('/predict', methods=['POST'])
def predict():
    """Accept image file, return prediction."""
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400

    file = request.files['file']
    # Read and preprocess image
    image = Image.open(io.BytesIO(file.read())).convert('L')  # Grayscale
    image = image.resize((28, 28))
    img_array = np.array(image) / 255.0
    img_array = img_array.reshape(1, 28, 28)

    # Predict
    predictions = model.predict(img_array, verbose=0)
    predicted_class = int(np.argmax(predictions[0]))
    confidence = float(np.max(predictions[0]))

    return jsonify({
        'class': CLASS_NAMES[predicted_class],
        'class_id': predicted_class,
        'confidence': round(confidence, 4),
        'all_probabilities': {
            name: round(float(prob), 4)
            for name, prob in zip(CLASS_NAMES, predictions[0])
        }
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
```

### Testing the API

```bash
# Install dependencies
pip install flask tensorflow pillow

# Run the server
python app.py

# Test with curl
curl -X POST -F "file=@test_image.png" http://localhost:5000/predict

# Test with Python
import requests
response = requests.post(
    'http://localhost:5000/predict',
    files={'file': open('test_image.png', 'rb')}
)
print(response.json())
# {'class': 'Sneaker', 'class_id': 7, 'confidence': 0.9823, ...}
```

---

## 15.6 FastAPI Deployment

```python
"""
FastAPI — Modern, faster alternative to Flask
"""
from fastapi import FastAPI, UploadFile, File
import tensorflow as tf
import numpy as np
from PIL import Image
import io

app = FastAPI(title="DL Model API")

model = tf.keras.models.load_model('model.keras')
CLASS_NAMES = ['T-shirt', 'Trouser', 'Pullover', 'Dress', 'Coat',
               'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert('L').resize((28, 28))
    img_array = np.array(image).reshape(1, 28, 28) / 255.0

    predictions = model.predict(img_array, verbose=0)
    predicted_class = int(np.argmax(predictions[0]))

    return {
        "class": CLASS_NAMES[predicted_class],
        "confidence": float(np.max(predictions[0]))
    }

# Run: uvicorn app:app --host 0.0.0.0 --port 8000
# Docs: http://localhost:8000/docs  (auto-generated Swagger UI!)
```

---

## 15.7 Docker Containerization

```dockerfile
# Dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

```
# requirements.txt
flask==3.0.0
tensorflow==2.15.0
pillow==10.0.0
numpy==1.24.0
```

```bash
# Build and run
docker build -t dl-model-api .
docker run -p 5000:5000 dl-model-api
```

---

## 15.8 Practice & Assessment

### MCQs

**Q1.** `model.save('model.keras')` saves:
- A) Only weights
- B) Only architecture
- C) Architecture + weights + optimizer state + compilation config
- D) Only the training data

**Answer:** C — `model.save()` saves everything needed to fully restore the model.

---

**Q2.** TensorFlow Lite is used for:
- A) Training large models
- B) Deploying models on mobile and edge devices
- C) Data preprocessing
- D) Model visualization

**Answer:** B — TFLite converts models to a smaller, optimized format for mobile/embedded inference.

---

**Q3.** In a Flask API, the model should be loaded:
- A) Inside each request handler
- B) Once at application startup (global scope)
- C) Never
- D) Only when the server shuts down

**Answer:** B — Loading the model once at startup avoids the overhead of loading for every request.

---

> **Next Topic:** [16 - DL Cheat Sheet & Interview Questions](16-dl-cheatsheet-interview.md)
