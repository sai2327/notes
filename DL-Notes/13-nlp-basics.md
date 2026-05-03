# 13. NLP Basics with Deep Learning

## Table of Contents
- [13.1 What is NLP?](#131-what-is-nlp)
- [13.2 Text Preprocessing Pipeline](#132-text-preprocessing-pipeline)
- [13.3 Tokenization](#133-tokenization)
- [13.4 Word Embeddings](#134-word-embeddings)
- [13.5 Text Classification with LSTM](#135-text-classification-with-lstm)
- [13.6 Text Generation](#136-text-generation)
- [13.7 Practice & Assessment](#137-practice--assessment)

---

## 13.1 What is NLP?

```
┌────────────────────────────────────────────────────────────────┐
│  NLP (Natural Language Processing) TASKS                       │
│                                                                │
│  ┌─────────────────┬──────────────────────────────────┐       │
│  │ Task            │ Example                          │       │
│  ├─────────────────┼──────────────────────────────────┤       │
│  │ Sentiment       │ "Great movie!" → Positive (0.95) │       │
│  │ Analysis        │                                  │       │
│  ├─────────────────┼──────────────────────────────────┤       │
│  │ Text            │ News article → Sports/Politics   │       │
│  │ Classification  │                                  │       │
│  ├─────────────────┼──────────────────────────────────┤       │
│  │ Named Entity    │ "Apple launched iPhone" →        │       │
│  │ Recognition     │ Apple=ORG, iPhone=PRODUCT        │       │
│  ├─────────────────┼──────────────────────────────────┤       │
│  │ Machine         │ English → French                 │       │
│  │ Translation     │                                  │       │
│  ├─────────────────┼──────────────────────────────────┤       │
│  │ Text            │ Long article → Short summary     │       │
│  │ Summarization   │                                  │       │
│  ├─────────────────┼──────────────────────────────────┤       │
│  │ Question        │ Context + Question → Answer      │       │
│  │ Answering       │                                  │       │
│  ├─────────────────┼──────────────────────────────────┤       │
│  │ Chatbots        │ User query → AI response         │       │
│  └─────────────────┴──────────────────────────────────┘       │
└────────────────────────────────────────────────────────────────┘
```

---

## 13.2 Text Preprocessing Pipeline

```
┌────────────────────────────────────────────────────────────────┐
│  TEXT PREPROCESSING PIPELINE                                   │
│                                                                │
│  Raw Text: "I LOVED this Movie!!! It's the best 🎬"          │
│     │                                                          │
│     ▼                                                          │
│  1. Lowercase: "i loved this movie!!! it's the best"         │
│     │                                                          │
│     ▼                                                          │
│  2. Remove special chars: "i loved this movie its the best"  │
│     │                                                          │
│     ▼                                                          │
│  3. Tokenize: ["i", "loved", "this", "movie", "its",        │
│                 "the", "best"]                                 │
│     │                                                          │
│     ▼                                                          │
│  4. Remove stopwords: ["loved", "movie", "best"]             │
│     (optional — sometimes stopwords matter!)                   │
│     │                                                          │
│     ▼                                                          │
│  5. Convert to numbers: [45, 892, 23]                        │
│     (using vocabulary mapping)                                 │
│     │                                                          │
│     ▼                                                          │
│  6. Pad to same length: [45, 892, 23, 0, 0, 0, ... 0]       │
│     (all sequences must be same length for batching)           │
└────────────────────────────────────────────────────────────────┘
```

```python
import re
import numpy as np

def preprocess_text(text):
    """Basic text preprocessing."""
    text = text.lower()                              # Lowercase
    text = re.sub(r'[^a-zA-Z\s]', '', text)         # Remove special chars
    text = re.sub(r'\s+', ' ', text).strip()         # Remove extra spaces
    return text

# Example
raw = "I LOVED this Movie!!! It's the best 🎬 #awesome"
clean = preprocess_text(raw)
print(clean)  # "i loved this movie its the best awesome"
```

---

## 13.3 Tokenization

### Converting Text to Numbers

```
┌────────────────────────────────────────────────────────────────┐
│  TOKENIZATION — Neural networks need NUMBERS, not text!       │
│                                                                │
│  Step 1: Build vocabulary (word → integer mapping)            │
│  {"the": 1, "cat": 2, "sat": 3, "on": 4, "mat": 5, ...}    │
│                                                                │
│  Step 2: Convert text to sequences                            │
│  "the cat sat on the mat" → [1, 2, 3, 4, 1, 5]              │
│                                                                │
│  Step 3: Pad sequences (same length)                          │
│  [1, 2, 3, 4, 1, 5] → [1, 2, 3, 4, 1, 5, 0, 0, 0, 0]      │
│                                                                │
│  Step 4: Embedding (integer → dense vector)                   │
│  [1, 2, 3, ...] → [[0.2, 0.5, ...], [0.8, 0.1, ...], ...]  │
└────────────────────────────────────────────────────────────────┘
```

```python
import tensorflow as tf
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences

# Sample data
texts = [
    "I love deep learning",
    "Deep learning is amazing",
    "NLP with neural networks is fun",
    "I hate boring lectures"
]
labels = [1, 1, 1, 0]  # 1=positive, 0=negative

# Step 1: Create tokenizer
tokenizer = Tokenizer(num_words=1000, oov_token='<OOV>')
tokenizer.fit_on_texts(texts)

print("Vocabulary:", tokenizer.word_index)
# {'<OOV>': 1, 'i': 2, 'deep': 3, 'learning': 4, 'is': 5,
#  'love': 6, 'amazing': 7, 'nlp': 8, ...}

# Step 2: Text to sequences
sequences = tokenizer.texts_to_sequences(texts)
print("Sequences:", sequences)
# [[2, 6, 3, 4], [3, 4, 5, 7], [8, 9, 10, 11, 5, 12], [2, 13, 14, 15]]

# Step 3: Pad to same length
max_length = 10
padded = pad_sequences(sequences, maxlen=max_length, padding='post')
print("Padded:\n", padded)
# [[ 2  6  3  4  0  0  0  0  0  0]
#  [ 3  4  5  7  0  0  0  0  0  0]
#  [ 8  9 10 11  5 12  0  0  0  0]
#  [ 2 13 14 15  0  0  0  0  0  0]]
```

---

## 13.4 Word Embeddings

```
┌────────────────────────────────────────────────────────────────────┐
│  WORD EMBEDDINGS — Dense vector representations of words          │
│                                                                    │
│  One-Hot Encoding (BAD):     Embedding (GOOD):                    │
│  "king"  = [1,0,0,0,...0]    "king"  = [0.2, 0.8, -0.1, 0.5]   │
│  "queen" = [0,1,0,0,...0]    "queen" = [0.3, 0.7, -0.2, 0.6]   │
│  "cat"   = [0,0,1,0,...0]    "cat"   = [-0.5, 0.1, 0.9, -0.3]  │
│                                                                    │
│  One-hot problems:            Embedding benefits:                 │
│  ❌ Huge vectors (10000-dim)   ✅ Small (50-300 dim)              │
│  ❌ All words equidistant      ✅ Similar words → close vectors   │
│  ❌ No meaning captured        ✅ Captures semantics               │
│                                                                    │
│  Famous result:                                                    │
│  king - man + woman ≈ queen                                      │
│  [0.2, 0.8, ...] - [0.1, 0.3, ...] + [0.2, 0.4, ...] ≈ queen  │
│                                                                    │
│  Pre-trained Embeddings:                                          │
│  ┌──────────┬────────────────────────────────────┐               │
│  │ Name     │ Description                        │               │
│  ├──────────┼────────────────────────────────────┤               │
│  │ Word2Vec │ Google, skip-gram/CBOW, 300d       │               │
│  │ GloVe    │ Stanford, co-occurrence, 50-300d   │               │
│  │ FastText │ Facebook, subword-aware, 300d      │               │
│  └──────────┴────────────────────────────────────┘               │
└────────────────────────────────────────────────────────────────────┘
```

```python
from tensorflow.keras.layers import Embedding

# Embedding layer (learns during training)
Embedding(
    input_dim=10000,    # Vocabulary size
    output_dim=128,     # Embedding dimension
    input_length=200    # Sequence length
)
# Input:  (batch, 200)          → integer sequences
# Output: (batch, 200, 128)     → dense vectors
```

---

## 13.5 Text Classification with LSTM

### Complete Sentiment Analysis

```python
"""
Sentiment Analysis: IMDB Reviews with LSTM
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import (
    Embedding, LSTM, Bidirectional, Dense,
    Dropout, GlobalMaxPooling1D
)
import matplotlib.pyplot as plt

# ============================================
# STEP 1: Load & Preprocess Data
# ============================================
VOCAB_SIZE = 10000
MAX_LENGTH = 200
EMBEDDING_DIM = 128

(X_train, y_train), (X_test, y_test) = tf.keras.datasets.imdb.load_data(
    num_words=VOCAB_SIZE
)

# Pad sequences
X_train = tf.keras.preprocessing.sequence.pad_sequences(
    X_train, maxlen=MAX_LENGTH, padding='post'
)
X_test = tf.keras.preprocessing.sequence.pad_sequences(
    X_test, maxlen=MAX_LENGTH, padding='post'
)

print(f"Train: {X_train.shape}")  # (25000, 200)
print(f"Test:  {X_test.shape}")   # (25000, 200)

# ============================================
# STEP 2: Build Model
# ============================================
model = Sequential([
    # Word → Vector (learned)
    Embedding(VOCAB_SIZE, EMBEDDING_DIM, input_length=MAX_LENGTH),
    # (batch, 200) → (batch, 200, 128)

    # Bidirectional LSTM
    Bidirectional(LSTM(64, return_sequences=True)),
    # (batch, 200, 128)

    # Pool across sequence
    GlobalMaxPooling1D(),
    # (batch, 128)

    # Classifier
    Dense(64, activation='relu'),
    Dropout(0.5),
    Dense(1, activation='sigmoid')  # Positive / Negative
])

model.summary()

# ============================================
# STEP 3: Compile & Train
# ============================================
model.compile(
    optimizer='adam',
    loss='binary_crossentropy',
    metrics=['accuracy']
)

history = model.fit(
    X_train, y_train,
    epochs=10,
    batch_size=64,
    validation_split=0.2,
    callbacks=[
        tf.keras.callbacks.EarlyStopping(
            patience=3, restore_best_weights=True
        )
    ]
)

# ============================================
# STEP 4: Evaluate
# ============================================
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"\nTest Accuracy: {test_acc:.4f}")
# Expected: ~87-89%

# ============================================
# STEP 5: Predict on New Text
# ============================================
word_index = tf.keras.datasets.imdb.get_word_index()
reverse_index = {v: k for k, v in word_index.items()}

def predict_sentiment(text, model, tokenizer_index):
    """Predict sentiment of a review."""
    words = text.lower().split()
    sequence = [tokenizer_index.get(w, 0) for w in words]
    padded = tf.keras.preprocessing.sequence.pad_sequences(
        [sequence], maxlen=MAX_LENGTH, padding='post'
    )
    prediction = model.predict(padded, verbose=0)[0][0]
    sentiment = "Positive" if prediction > 0.5 else "Negative"
    print(f"'{text[:50]}...' → {sentiment} ({prediction:.4f})")

predict_sentiment("this movie was absolutely wonderful and amazing", model, word_index)
predict_sentiment("terrible film waste of time do not watch", model, word_index)

# ============================================
# STEP 6: Plot
# ============================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
ax1.plot(history.history['loss'], label='Train')
ax1.plot(history.history['val_loss'], label='Val')
ax1.set_title('Loss'); ax1.legend()
ax2.plot(history.history['accuracy'], label='Train')
ax2.plot(history.history['val_accuracy'], label='Val')
ax2.set_title('Accuracy'); ax2.legend()
plt.tight_layout(); plt.show()
```

---

## 13.6 Text Generation

### Character-Level Text Generation with LSTM

```python
"""
Simple Text Generation with LSTM
"""
import tensorflow as tf
import numpy as np

# Sample text corpus
text = "deep learning is a subset of machine learning that uses neural networks"

# Character-level tokenization
chars = sorted(set(text))
char_to_idx = {c: i for i, c in enumerate(chars)}
idx_to_char = {i: c for c, i in char_to_idx.items()}

# Create training sequences
SEQ_LENGTH = 10
X, y = [], []
for i in range(len(text) - SEQ_LENGTH):
    X.append([char_to_idx[c] for c in text[i:i+SEQ_LENGTH]])
    y.append(char_to_idx[text[i+SEQ_LENGTH]])

X = tf.keras.utils.to_categorical(X, num_classes=len(chars))
y = tf.keras.utils.to_categorical(y, num_classes=len(chars))

# Build model
model = tf.keras.Sequential([
    tf.keras.layers.LSTM(128, input_shape=(SEQ_LENGTH, len(chars))),
    tf.keras.layers.Dense(len(chars), activation='softmax')
])
model.compile(optimizer='adam', loss='categorical_crossentropy')
model.fit(X, y, epochs=100, batch_size=32, verbose=0)

# Generate text
def generate_text(seed_text, length=50):
    result = seed_text
    for _ in range(length):
        x = [char_to_idx.get(c, 0) for c in result[-SEQ_LENGTH:]]
        x = tf.keras.utils.to_categorical([x], num_classes=len(chars))
        pred = model.predict(x, verbose=0)[0]
        next_char = idx_to_char[np.argmax(pred)]
        result += next_char
    return result

print(generate_text("deep learn"))
```

---

## 13.7 Practice & Assessment

### MCQs

**Q1.** The Embedding layer converts:
- A) Images to vectors
- B) Word indices (integers) to dense vectors
- C) Vectors to words
- D) Labels to categories

**Answer:** B — Embedding maps each integer (word index) to a learnable dense vector (e.g., 128 dimensions).

---

**Q2.** Why do we pad sequences?
- A) To make text longer
- B) Neural networks need fixed-size inputs in a batch
- C) To improve accuracy
- D) To remove stopwords

**Answer:** B — All sequences in a batch must have the same length. Padding adds zeros to shorter sequences.

---

**Q3.** Word embeddings capture semantic relationships because:
- A) They use one-hot encoding
- B) Similar words have similar vector representations (close in vector space)
- C) They are random
- D) They use bag of words

**Answer:** B — Embeddings are learned such that semantically similar words have similar vectors (e.g., "king" close to "queen").

---

> **Next Topic:** [14 - Model Evaluation](14-model-evaluation.md)
