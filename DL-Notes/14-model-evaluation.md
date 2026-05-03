# 14. Model Evaluation & Validation

## Table of Contents
- [14.1 Why Evaluation Matters](#141-why-evaluation-matters)
- [14.2 Train/Validation/Test Split](#142-trainvalidationtest-split)
- [14.3 Classification Metrics](#143-classification-metrics)
- [14.4 Regression Metrics](#144-regression-metrics)
- [14.5 Learning Curves](#145-learning-curves)
- [14.6 Cross-Validation for DL](#146-cross-validation-for-dl)
- [14.7 Python Implementation](#147-python-implementation)
- [14.8 Practice & Assessment](#148-practice--assessment)

---

## 14.1 Why Evaluation Matters

```
┌────────────────────────────────────────────────────────────────┐
│  GOOD MODEL vs DEPLOYED MODEL                                  │
│                                                                │
│  "My model has 99% accuracy!" → On WHAT data?                 │
│                                                                │
│  Training accuracy = How well model MEMORIZES training data   │
│  Validation accuracy = How well model GENERALIZES             │
│  Test accuracy = FINAL unbiased performance estimate          │
│                                                                │
│  99% on training, 60% on test = OVERFITTING (useless!)       │
│  85% on training, 83% on test = GOOD (generalizes well!)     │
│                                                                │
│  NEVER evaluate on training data alone!                       │
│  NEVER tune hyperparameters using test data!                  │
└────────────────────────────────────────────────────────────────┘
```

---

## 14.2 Train/Validation/Test Split

```
┌────────────────────────────────────────────────────────────────────┐
│  DATA SPLITTING                                                    │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐ │
│  │                    Full Dataset                              │ │
│  ├──────────────────┬──────────┬───────────┤                   │ │
│  │   Training (70%) │Val (15%) │Test (15%) │                   │ │
│  │   or (80%)       │(10%)     │(10%)      │                   │ │
│  └──────────────────┴──────────┴───────────┘                   │ │
│                                                                    │
│  Training Set:    Model learns from this                         │
│  Validation Set:  Tune hyperparameters, monitor overfitting      │
│  Test Set:        Final evaluation ONCE (never retrain on this)  │
│                                                                    │
│  In Keras:                                                        │
│  model.fit(X_train, y_train,                                     │
│            validation_split=0.2)    ← auto splits 20% for val   │
│                                                                    │
│  OR:                                                              │
│  model.fit(X_train, y_train,                                     │
│            validation_data=(X_val, y_val))  ← explicit split    │
│                                                                    │
│  model.evaluate(X_test, y_test)     ← final test evaluation     │
└────────────────────────────────────────────────────────────────────┘
```

---

## 14.3 Classification Metrics

### Confusion Matrix

```
┌────────────────────────────────────────────────────────────────┐
│  CONFUSION MATRIX (Binary Classification)                      │
│                                                                │
│                        Predicted                               │
│                   Positive    Negative                         │
│              ┌────────────┬────────────┐                      │
│  Actual  Pos │     TP     │     FN     │                      │
│              │  (correct) │ (missed!)  │                      │
│              ├────────────┼────────────┤                      │
│         Neg  │     FP     │     TN     │                      │
│              │ (false     │ (correct)  │                      │
│              │  alarm!)   │            │                      │
│              └────────────┴────────────┘                      │
│                                                                │
│  TP = True Positive:  Cancer patient correctly identified     │
│  TN = True Negative:  Healthy person correctly identified     │
│  FP = False Positive: Healthy person flagged as cancer        │
│  FN = False Negative: Cancer patient missed (DANGEROUS!)      │
└────────────────────────────────────────────────────────────────┘
```

### Key Metrics

| Metric | Formula | When to Use |
|--------|---------|-------------|
| **Accuracy** | $\frac{TP + TN}{TP + TN + FP + FN}$ | Balanced classes |
| **Precision** | $\frac{TP}{TP + FP}$ | Minimize false alarms (spam filter) |
| **Recall** | $\frac{TP}{TP + FN}$ | Minimize missed cases (cancer detection) |
| **F1 Score** | $2 \cdot \frac{Precision \cdot Recall}{Precision + Recall}$ | Imbalanced classes |
| **AUC-ROC** | Area under ROC curve | Overall ranking quality |

```
┌────────────────────────────────────────────────────────────────┐
│  ACCURACY TRAP — Why accuracy can be misleading                │
│                                                                │
│  Dataset: 950 healthy, 50 cancer patients                     │
│                                                                │
│  Dumb model: "Everyone is healthy!"                           │
│  Accuracy = 950/1000 = 95% ← looks great, but USELESS!      │
│  Recall = 0/50 = 0% ← misses ALL cancer patients!            │
│                                                                │
│  Use F1 Score or AUC-ROC for imbalanced datasets!             │
└────────────────────────────────────────────────────────────────┘
```

---

## 14.4 Regression Metrics

| Metric | Formula | Interpretation |
|--------|---------|----------------|
| **MAE** | $\frac{1}{n}\sum|y_i - \hat{y}_i|$ | Average absolute error |
| **MSE** | $\frac{1}{n}\sum(y_i - \hat{y}_i)^2$ | Penalizes large errors more |
| **RMSE** | $\sqrt{MSE}$ | Same unit as target |
| **R²** | $1 - \frac{\sum(y_i - \hat{y}_i)^2}{\sum(y_i - \bar{y})^2}$ | 1=perfect, 0=baseline |

---

## 14.5 Learning Curves

```
┌────────────────────────────────────────────────────────────────────┐
│  DIAGNOSING MODEL PROBLEMS WITH LEARNING CURVES                   │
│                                                                    │
│  GOOD FIT:                    OVERFITTING:                        │
│  Loss                         Loss                                │
│   │╲                           │╲                                  │
│   │ ╲ train                    │ ╲ train                           │
│   │  ╲╲                        │  ╲╲╲╲╲╲____________               │
│   │    ╲╲ val                  │     ╲                              │
│   │      ╲╲____                │      ╲  val                       │
│   │         ╲╲___              │       ╲  ╱──────                  │
│   │              (converge!)   │        ╲╱  (gap grows!)          │
│   └───────────────► Epoch      └───────────────► Epoch            │
│                                                                    │
│  UNDERFITTING:                HIGH VARIANCE:                      │
│  Loss                         Loss                                │
│   │                            │╲  ╱╲                              │
│   │────── train                │ ╲╱  ╲╱╲                           │
│   │                            │       ╲╱╲╱╲                       │
│   │────── val                  │           ╲╱╲ (oscillating!)     │
│   │ (both high, flat)          │                                   │
│   └───────────────► Epoch      └───────────────► Epoch            │
│                                                                    │
│  Diagnosis → Fix:                                                 │
│  Overfitting → Regularization, more data, simpler model          │
│  Underfitting → Bigger model, more features, train longer        │
│  High Variance → Lower learning rate, more data                  │
└────────────────────────────────────────────────────────────────────┘
```

---

## 14.6 Cross-Validation for DL

```
┌────────────────────────────────────────────────────────────────┐
│  K-FOLD CROSS-VALIDATION                                       │
│                                                                │
│  Split data into K folds, train K times:                      │
│                                                                │
│  Fold 1: [VAL] [Train] [Train] [Train] [Train] → acc₁       │
│  Fold 2: [Train] [VAL] [Train] [Train] [Train] → acc₂       │
│  Fold 3: [Train] [Train] [VAL] [Train] [Train] → acc₃       │
│  Fold 4: [Train] [Train] [Train] [VAL] [Train] → acc₄       │
│  Fold 5: [Train] [Train] [Train] [Train] [VAL] → acc₅       │
│                                                                │
│  Final = mean(acc₁, acc₂, acc₃, acc₄, acc₅)                 │
│                                                                │
│  ⚠️ Note: K-Fold is expensive for DL (train K models!)       │
│  Typically only used for small datasets or final evaluation.  │
│  For large DL models: just use train/val/test split.          │
└────────────────────────────────────────────────────────────────┘
```

---

## 14.7 Python Implementation

### Complete Evaluation Pipeline

```python
"""
Model Evaluation: Classification Metrics & Learning Curves
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Flatten, Dropout
from sklearn.metrics import (
    classification_report, confusion_matrix, roc_auc_score, roc_curve
)
import matplotlib.pyplot as plt
import numpy as np

# ============================================
# STEP 1: Load & Train Model
# ============================================
(X_train, y_train), (X_test, y_test) = tf.keras.datasets.fashion_mnist.load_data()
X_train, X_test = X_train / 255.0, X_test / 255.0

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

history = model.fit(X_train, y_train, epochs=20, batch_size=64,
                    validation_split=0.2, verbose=0)

# ============================================
# STEP 2: Learning Curves
# ============================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

ax1.plot(history.history['loss'], label='Train Loss')
ax1.plot(history.history['val_loss'], label='Val Loss')
ax1.set_xlabel('Epoch'); ax1.set_ylabel('Loss')
ax1.set_title('Loss Curves'); ax1.legend()

ax2.plot(history.history['accuracy'], label='Train Acc')
ax2.plot(history.history['val_accuracy'], label='Val Acc')
ax2.set_xlabel('Epoch'); ax2.set_ylabel('Accuracy')
ax2.set_title('Accuracy Curves'); ax2.legend()

plt.tight_layout(); plt.show()

# ============================================
# STEP 3: Test Evaluation
# ============================================
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"Test Loss: {test_loss:.4f}")
print(f"Test Accuracy: {test_acc:.4f}")

# ============================================
# STEP 4: Detailed Metrics
# ============================================
y_pred_probs = model.predict(X_test)
y_pred = np.argmax(y_pred_probs, axis=1)

# Class names for Fashion MNIST
class_names = ['T-shirt', 'Trouser', 'Pullover', 'Dress', 'Coat',
               'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']

# Classification Report
print("\n" + "="*60)
print("CLASSIFICATION REPORT")
print("="*60)
print(classification_report(y_test, y_pred, target_names=class_names))

# Confusion Matrix
cm = confusion_matrix(y_test, y_pred)
plt.figure(figsize=(10, 8))
plt.imshow(cm, cmap='Blues')
plt.colorbar()
plt.xticks(range(10), class_names, rotation=45, ha='right')
plt.yticks(range(10), class_names)
plt.xlabel('Predicted'); plt.ylabel('Actual')
plt.title('Confusion Matrix')
for i in range(10):
    for j in range(10):
        plt.text(j, i, str(cm[i,j]), ha='center', va='center',
                color='white' if cm[i,j] > cm.max()/2 else 'black')
plt.tight_layout(); plt.show()
```

---

## 14.8 Practice & Assessment

### MCQs

**Q1.** For a cancer detection system, the most important metric is:
- A) Accuracy
- B) Precision
- C) Recall (sensitivity)
- D) F1 Score

**Answer:** C — High recall means fewer missed cancer cases (low FN). Missing cancer (FN) is far worse than a false alarm (FP).

---

**Q2.** If training loss is low but validation loss is high, this indicates:
- A) Underfitting
- B) Overfitting
- C) Perfect model
- D) Need more epochs

**Answer:** B — Large gap between train and val loss means the model memorized training data but doesn't generalize.

---

**Q3.** The test set should be used:
- A) During training
- B) To tune hyperparameters
- C) Only for final evaluation after all tuning is done
- D) As additional training data

**Answer:** C — The test set provides an unbiased final estimate. Using it during development causes data leakage.

---

> **Next Topic:** [15 - Model Deployment](15-deployment.md)
