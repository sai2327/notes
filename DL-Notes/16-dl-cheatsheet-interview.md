# 16. Deep Learning Cheat Sheet & Interview Questions

## Table of Contents
- [16.1 Quick Reference Tables](#161-quick-reference-tables)
- [16.2 Code Cheat Sheet](#162-code-cheat-sheet)
- [16.3 Common Mistakes](#163-common-mistakes)
- [16.4 Interview Questions — Beginner](#164-interview-questions--beginner)
- [16.5 Interview Questions — Intermediate](#165-interview-questions--intermediate)
- [16.6 Interview Questions — Advanced](#166-interview-questions--advanced)

---

## 16.1 Quick Reference Tables

### Activation Functions

| Function | Formula | Range | Use For |
|----------|---------|-------|---------|
| ReLU | max(0, x) | [0, ∞) | Hidden layers (default) |
| Sigmoid | 1/(1+e⁻ˣ) | (0, 1) | Binary output |
| Tanh | (eˣ-e⁻ˣ)/(eˣ+e⁻ˣ) | (-1, 1) | Hidden layers (RNN) |
| Softmax | eˣⁱ/Σeˣʲ | (0, 1) | Multi-class output |
| Leaky ReLU | max(0.01x, x) | (-∞, ∞) | If ReLU has dead neurons |

### Loss Functions

| Loss | Use Case | Output Activation |
|------|----------|-------------------|
| Binary Crossentropy | Binary classification | Sigmoid |
| Categorical Crossentropy | Multi-class (one-hot labels) | Softmax |
| Sparse Categorical Crossentropy | Multi-class (integer labels) | Softmax |
| MSE | Regression | None (linear) |
| MAE | Regression (robust to outliers) | None (linear) |

### Optimizers

| Optimizer | Learning Rate | When to Use |
|-----------|--------------|-------------|
| Adam | 0.001 | Default for everything |
| SGD + Momentum | 0.01, β=0.9 | Fine-tuning, CV tasks |
| RMSprop | 0.001 | RNNs |
| AdamW | 0.001 | Transformers |

### Architecture Selection

| Data Type | Architecture | Example |
|-----------|-------------|---------|
| Tabular | ANN (Dense) | Price prediction |
| Images | CNN | Image classification |
| Sequences/Text | RNN/LSTM/GRU | Sentiment analysis |
| Text (modern) | Transformer | ChatGPT, BERT |
| Sequences + context | Bidirectional LSTM | Named entity recognition |
| Image generation | GAN / Diffusion | DALL-E |

### Layer Output Shapes

```
Dense(64):            input (batch, n) → output (batch, 64)
Conv2D(32, 3):        input (batch, h, w, c) → output (batch, h-2, w-2, 32)
MaxPool2D(2):         input (batch, h, w, c) → output (batch, h/2, w/2, c)
Flatten():            input (batch, h, w, c) → output (batch, h*w*c)
LSTM(64):             input (batch, steps, feat) → output (batch, 64)
LSTM(64, ret_seq=T):  input (batch, steps, feat) → output (batch, steps, 64)
Embedding(V, D):      input (batch, seq_len) → output (batch, seq_len, D)
```

---

## 16.2 Code Cheat Sheet

### Model Building (5 lines)

```python
model = tf.keras.Sequential([
    tf.keras.layers.Flatten(input_shape=(28, 28)),
    tf.keras.layers.Dense(128, activation='relu'),
    tf.keras.layers.Dense(10, activation='softmax')
])
```

### Compile + Train + Evaluate (6 lines)

```python
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
history = model.fit(X_train, y_train, epochs=10, validation_split=0.2,
                    callbacks=[tf.keras.callbacks.EarlyStopping(patience=3, restore_best_weights=True)])
model.evaluate(X_test, y_test)
```

### Save + Load (2 lines)

```python
model.save('model.keras')
model = tf.keras.models.load_model('model.keras')
```

### Transfer Learning (6 lines)

```python
base = tf.keras.applications.MobileNetV2(include_top=False, weights='imagenet', input_shape=(160,160,3))
base.trainable = False
model = tf.keras.Sequential([base, tf.keras.layers.GlobalAveragePooling2D(),
                             tf.keras.layers.Dense(1, activation='sigmoid')])
model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
```

### Data Augmentation (4 lines)

```python
aug = tf.keras.Sequential([
    tf.keras.layers.RandomFlip("horizontal"), tf.keras.layers.RandomRotation(0.1),
    tf.keras.layers.RandomZoom(0.1)
])
```

---

## 16.3 Common Mistakes

```
┌────────────────────────────────────────────────────────────────┐
│  TOP 10 DL MISTAKES                                            │
│                                                                │
│  1. ❌ Not normalizing data (pixels [0,255] → [0,1])          │
│  2. ❌ Wrong loss function (softmax + binary_crossentropy)     │
│  3. ❌ Forgetting to set trainable=False for transfer learning │
│  4. ❌ Too high learning rate (loss explodes or NaN)           │
│  5. ❌ No validation split (can't detect overfitting)          │
│  6. ❌ Evaluating on training data (inflated accuracy)         │
│  7. ❌ Wrong input shape (check with model.summary())          │
│  8. ❌ Not using EarlyStopping (overtrains the model)          │
│  9. ❌ Sigmoid output with sparse_categorical_crossentropy     │
│ 10. ❌ Training with too few epochs (model hasn't converged)   │
│                                                                │
│  ALWAYS CHECK:                                                 │
│  ✅ Data normalization                                          │
│  ✅ Output activation + loss function match                    │
│  ✅ model.summary() for shape errors                           │
│  ✅ Learning curves for overfitting                            │
└────────────────────────────────────────────────────────────────┘
```

### Activation + Loss Matching Guide

| Task | Output Neurons | Activation | Loss |
|------|---------------|------------|------|
| Binary class. | 1 | sigmoid | binary_crossentropy |
| Multi-class (one-hot) | N | softmax | categorical_crossentropy |
| Multi-class (int) | N | softmax | sparse_categorical_crossentropy |
| Multi-label | N | sigmoid | binary_crossentropy |
| Regression | 1 | none/linear | mse or mae |

---

## 16.4 Interview Questions — Beginner

**Q1. What is deep learning?**
> Deep learning is a subset of machine learning that uses artificial neural networks with multiple layers (hence "deep") to automatically learn hierarchical representations from data. Unlike traditional ML, DL learns features automatically without manual feature engineering.

**Q2. What is the difference between ML and DL?**
> ML requires manual feature extraction and works well on smaller datasets. DL automatically learns features from raw data and excels on large datasets (images, text, audio). DL needs more compute (GPUs) and data but achieves state-of-the-art results on complex tasks.

**Q3. What is an activation function and why is it needed?**
> An activation function introduces non-linearity into the network. Without it, stacking linear layers produces just another linear function (no matter how many layers). Common ones: ReLU (hidden layers), Sigmoid (binary output), Softmax (multi-class output).

**Q4. What is the difference between a parameter and a hyperparameter?**
> Parameters are learned during training (weights, biases). Hyperparameters are set before training by the engineer (learning rate, batch size, number of layers, dropout rate).

**Q5. Explain forward propagation.**
> Forward propagation passes input data through the network layer by layer: at each layer, compute weighted sum + bias, apply activation function, pass output to next layer. The final layer produces predictions.

**Q6. What is backpropagation?**
> Backpropagation computes the gradient of the loss with respect to each weight using the chain rule. These gradients tell us how to adjust weights to reduce the loss. It works backward from the output layer to the input layer.

---

## 16.5 Interview Questions — Intermediate

**Q7. What is the vanishing gradient problem?**
> In deep networks, gradients can become exponentially small as they're propagated backward through many layers (especially with sigmoid/tanh). This means early layers learn very slowly or not at all. Solutions: ReLU activation, LSTM/GRU for sequences, residual connections (ResNet), batch normalization.

**Q8. Explain the difference between CNN and RNN.**
> CNN processes spatial data (images) using convolutional filters that detect local patterns (edges, textures). It shares weights across spatial positions. RNN processes sequential data (text, time series) by maintaining a hidden state that captures temporal dependencies. CNN is parallel; RNN is sequential.

**Q9. What is dropout and how does it prevent overfitting?**
> Dropout randomly sets a fraction of neuron outputs to zero during training. This prevents neurons from co-adapting and forces the network to learn redundant representations. It acts like training an ensemble of many sub-networks. Dropout is only active during training, not inference.

**Q10. Explain the LSTM architecture.**
> LSTM has three gates: Forget gate (what to discard from memory), Input gate (what new info to store), Output gate (what to output). Plus a cell state (long-term memory highway). The cell state allows gradients to flow uninterrupted, solving the vanishing gradient problem for sequences.

**Q11. What is transfer learning?**
> Transfer learning uses a model pre-trained on a large dataset (e.g., ImageNet) as a starting point for a new task. The pre-trained layers extract general features (edges, textures) that are useful across tasks. We freeze these layers and train only a new classifier head on our specific data.

**Q12. What is batch normalization?**
> Batch normalization normalizes the inputs to each layer to have zero mean and unit variance across the current mini-batch. It reduces internal covariate shift, allows higher learning rates, and acts as mild regularization. Formula: x̂ = (x - μ_batch) / √(σ²_batch + ε), then scale and shift with learnable parameters.

---

## 16.6 Interview Questions — Advanced

**Q13. Explain the transformer architecture and self-attention.**
> Transformers replace recurrence with self-attention, processing all positions in parallel. Self-attention computes Query, Key, Value from each input, calculates attention scores (Q·Kᵀ/√d_k), applies softmax to get weights, then produces weighted sum of Values. Multi-head attention runs multiple attention operations in parallel to capture different relationships. This allows O(1) path length between any two positions (vs O(n) for RNNs).

**Q14. Why does Adam optimizer work well?**
> Adam combines two ideas: momentum (exponential moving average of gradients, first moment) and RMSprop (exponential moving average of squared gradients, second moment). Momentum helps accelerate in consistent gradient directions. RMSprop adapts learning rate per-parameter (smaller steps for frequently updated parameters). Bias correction handles initialization. Result: fast convergence with adaptive per-parameter learning rates.

**Q15. How would you handle class imbalance in deep learning?**
> (1) Class weights: pass `class_weight={0: 1, 1: 10}` to `model.fit()` to penalize minority class errors more. (2) Oversampling: duplicate or augment minority class samples (SMOTE). (3) Undersampling: reduce majority class. (4) Focal loss: down-weight easy examples, focus on hard ones. (5) Data augmentation for minority class.

**Q16. Explain the bias-variance tradeoff in DL context.**
> High bias = underfitting (model too simple, can't capture patterns). High variance = overfitting (model too complex, memorizes noise). In DL, we typically build complex models (low bias) and then regularize to reduce variance (dropout, L2, early stopping, data augmentation). The "double descent" phenomenon in DL shows that very large models can sometimes overcome this tradeoff.

**Q17. What are residual connections and why are they important?**
> Residual connections (skip connections) add the input of a block directly to its output: y = F(x) + x. This creates a "gradient highway" allowing gradients to flow directly through the network without degradation. It enabled training of very deep networks (ResNet with 152+ layers). Without them, adding more layers can actually hurt performance due to optimization difficulties.

**Q18. How does learning rate affect training?**
> Too small: slow convergence, may get stuck in local minima. Too large: oscillation, may diverge (loss increases or NaN). Optimal: converges quickly to good minimum. Strategies: start with default (Adam=0.001), use learning rate schedulers (cosine decay, reduce on plateau), warm-up for transformers. The learning rate is arguably the most important hyperparameter.

---

> **Next Topic:** [17 - DL Projects](17-dl-projects.md)
