# 08. RNN, LSTM, GRU

## Table of Contents
- [8.1 Why RNN?](#81-why-rnn)
- [8.2 RNN Architecture](#82-rnn-architecture)
- [8.3 Vanishing Gradient Problem](#83-vanishing-gradient-problem)
- [8.4 LSTM (Long Short-Term Memory)](#84-lstm-long-short-term-memory)
- [8.5 GRU (Gated Recurrent Unit)](#85-gru-gated-recurrent-unit)
- [8.6 Bidirectional RNN](#86-bidirectional-rnn)
- [8.7 Python Implementation](#87-python-implementation)
- [8.8 Practice & Assessment](#88-practice--assessment)

---

## 8.1 Why RNN?

### The Problem with ANN/CNN for Sequences

```
┌────────────────────────────────────────────────────────────────┐
│  ANN/CNN: Each input is INDEPENDENT                            │
│  "I love this movie" → processed as bag of words (no order!)  │
│                                                                │
│  But in sequences, ORDER MATTERS:                              │
│  "Dog bites man" ≠ "Man bites dog"                            │
│                                                                │
│  RNN: Processes inputs ONE AT A TIME, maintaining MEMORY      │
│  of previous inputs through a hidden state.                    │
│                                                                │
│  Use Cases:                                                    │
│  • Text (words come in sequence)                              │
│  • Time series (stock prices, sensor data)                    │
│  • Speech (audio samples in order)                            │
│  • Music (notes in sequence)                                  │
└────────────────────────────────────────────────────────────────┘
```

---

## 8.2 RNN Architecture

### Unrolled RNN

```
┌────────────────────────────────────────────────────────────────────────┐
│  RNN — UNROLLED THROUGH TIME                                          │
│                                                                        │
│  Folded view:                  Unrolled view:                         │
│  ┌───────────┐                                                        │
│  │     ┌──┐  │                t=0        t=1        t=2        t=3   │
│  │  ──▶│h │──┘                                                        │
│  │     └──┘                 ┌────┐     ┌────┐     ┌────┐     ┌────┐ │
│  │      ↑                   │ h₀ │──▶ │ h₁ │──▶ │ h₂ │──▶ │ h₃ │ │
│  │      x                   └─┬──┘     └─┬──┘     └─┬──┘     └─┬──┘ │
│  └───────────┘                 ↑          ↑          ↑          ↑    │
│                                x₀         x₁         x₂         x₃  │
│                              "I"       "love"     "this"     "movie" │
│                                                                        │
│  At each time step t:                                                 │
│  h_t = tanh(W_hh · h_{t-1} + W_xh · x_t + b)                       │
│                                                                        │
│  h_t = new hidden state (memory)                                     │
│  h_{t-1} = previous hidden state                                    │
│  x_t = current input                                                  │
│  W_hh, W_xh = weight matrices (SHARED across all time steps!)       │
└────────────────────────────────────────────────────────────────────────┘
```

### RNN Equation

$$h_t = \tanh(W_{hh} \cdot h_{t-1} + W_{xh} \cdot x_t + b_h)$$
$$y_t = W_{hy} \cdot h_t + b_y$$

| Symbol | Meaning |
|--------|---------|
| $h_t$ | Hidden state at time t (memory) |
| $x_t$ | Input at time t |
| $W_{hh}$ | Hidden-to-hidden weights (recurrent) |
| $W_{xh}$ | Input-to-hidden weights |
| $W_{hy}$ | Hidden-to-output weights |

### Types of RNN by Input/Output

```
┌────────────────────────────────────────────────────────────────┐
│  RNN TYPES                                                     │
│                                                                │
│  One-to-One:    One-to-Many:   Many-to-One:   Many-to-Many:  │
│  ┌──┐          ┌──┐──┐──┐    ┌──┐──┐──┐     ┌──┐──┐──┐     │
│  │  │──▶       │  │  │  │    │  │  │  │──▶  │  │  │  │──▶  │
│  └──┘          └──┘  ↑       └──┘  ↑         └──┘  ↑  ↑     │
│   ↑             ↑    │        ↑ ↑  ↑ ↑        ↑ ↑  ↑ ↑ ↑    │
│   x             x    │        x x  x x        x x  x x x    │
│                                                                │
│  Standard      Image→        Sentiment      Translation      │
│  classifier    Caption       Analysis       Seq-to-Seq       │
│                (generate     (text→score)                     │
│                 words)                                         │
└────────────────────────────────────────────────────────────────┘
```

---

## 8.3 Vanishing Gradient Problem

```
┌────────────────────────────────────────────────────────────────────┐
│  VANISHING GRADIENT — Why vanilla RNN fails on long sequences     │
│                                                                    │
│  Gradient flows BACKWARD through time:                            │
│                                                                    │
│  h₀ ← h₁ ← h₂ ← h₃ ← ... ← h₅₀ ← Loss                       │
│  │      │      │      │              │                            │
│  tiny  small  small  small          large                         │
│  grad  grad   grad   grad           grad                         │
│                                                                    │
│  At each step, gradient is multiplied by W_hh.                   │
│  If |W_hh| < 1: gradients shrink exponentially → VANISH          │
│  If |W_hh| > 1: gradients grow exponentially  → EXPLODE          │
│                                                                    │
│  Result: RNN can't learn LONG-RANGE dependencies                 │
│  "The cat, which sat on the mat, ... was ___"                    │
│  ← RNN forgets "cat" by the time it reaches the blank!          │
│                                                                    │
│  Solutions:                                                       │
│  ✅ LSTM (Long Short-Term Memory)                                 │
│  ✅ GRU (Gated Recurrent Unit)                                    │
│  ✅ Gradient clipping (cap gradient magnitude)                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## 8.4 LSTM (Long Short-Term Memory)

### Architecture

```
┌────────────────────────────────────────────────────────────────────────┐
│  LSTM CELL — The Memory Machine                                       │
│                                                                        │
│         c_{t-1} ───────────────────────────────────────── c_t         │
│                    │           │              │                        │
│                   (×)         (+)            (×)                       │
│                    │           │              │                        │
│                    │    ┌──────┴──────┐       │                        │
│                    │    │   tanh      │       │                        │
│                    │    │  (new info) │    ┌──┴──┐                    │
│                    │    └──────┬──────┘    │tanh │── h_t              │
│                    │           │           └──┬──┘                    │
│              ┌─────┴─────┐ ┌──┴──┐    ┌─────┴─────┐                 │
│              │  FORGET   │ │INPUT│    │  OUTPUT   │                 │
│              │   GATE    │ │GATE │    │   GATE    │                 │
│              │  f_t      │ │i_t  │    │  o_t      │                 │
│              │  σ        │ │σ    │    │  σ        │                 │
│              └─────┬─────┘ └──┬──┘    └─────┬─────┘                 │
│                    │          │              │                        │
│                    └────┬─────┴──────────────┘                        │
│                         │                                             │
│                   [h_{t-1}, x_t]                                     │
│                                                                        │
│  THREE GATES (all sigmoid = values between 0 and 1):                 │
│                                                                        │
│  1. FORGET gate: How much of OLD memory to KEEP?                     │
│     f_t = σ(W_f · [h_{t-1}, x_t] + b_f)                            │
│     f_t = 0 → forget everything                                      │
│     f_t = 1 → remember everything                                    │
│                                                                        │
│  2. INPUT gate: How much of NEW info to STORE?                       │
│     i_t = σ(W_i · [h_{t-1}, x_t] + b_i)                            │
│     c̃_t = tanh(W_c · [h_{t-1}, x_t] + b_c)   ← candidate memory  │
│                                                                        │
│  3. OUTPUT gate: How much of memory to OUTPUT?                       │
│     o_t = σ(W_o · [h_{t-1}, x_t] + b_o)                            │
│                                                                        │
│  Cell state update:                                                   │
│     c_t = f_t × c_{t-1} + i_t × c̃_t                               │
│           (forget old)    (add new)                                   │
│                                                                        │
│  Hidden state output:                                                 │
│     h_t = o_t × tanh(c_t)                                           │
└────────────────────────────────────────────────────────────────────────┘
```

### LSTM Intuition

> Think of LSTM like writing notes while reading a book:
> - **Forget gate:** Cross out irrelevant notes
> - **Input gate:** Write new important notes
> - **Cell state:** Your notebook (long-term memory)
> - **Output gate:** Decide what to say when asked

```python
from tensorflow.keras.layers import LSTM

# LSTM layer
LSTM(
    units=64,              # Number of LSTM units (hidden size)
    return_sequences=True, # True: output at every time step
                           # False: output only at last step
    input_shape=(100, 50)  # (sequence_length, features)
)
```

---

## 8.5 GRU (Gated Recurrent Unit)

### Simplified LSTM

```
┌────────────────────────────────────────────────────────────────────┐
│  GRU — Simplified version of LSTM                                  │
│                                                                    │
│  Only TWO gates instead of THREE:                                 │
│                                                                    │
│  1. RESET gate (r_t): How much past info to forget?              │
│     r_t = σ(W_r · [h_{t-1}, x_t] + b_r)                        │
│                                                                    │
│  2. UPDATE gate (z_t): How much to update? (combines forget+input)│
│     z_t = σ(W_z · [h_{t-1}, x_t] + b_z)                        │
│                                                                    │
│  New state:                                                       │
│     h̃_t = tanh(W · [r_t × h_{t-1}, x_t] + b)                  │
│     h_t = (1 - z_t) × h_{t-1} + z_t × h̃_t                    │
│                                                                    │
│  LSTM vs GRU:                                                     │
│  ┌───────────┬────────────┬─────────────┐                        │
│  │ Feature   │ LSTM       │ GRU         │                        │
│  ├───────────┼────────────┼─────────────┤                        │
│  │ Gates     │ 3          │ 2           │                        │
│  │ Memory    │ Separate   │ Combined    │                        │
│  │           │ cell state │ hidden state│                        │
│  │ Parameters│ More       │ Fewer (~25%)│                        │
│  │ Speed     │ Slower     │ Faster      │                        │
│  │ Long deps │ Better     │ Good        │                        │
│  │ Use when  │ Long seqs  │ Shorter seqs│                        │
│  │           │ complex    │ faster train│                        │
│  └───────────┴────────────┴─────────────┘                        │
└────────────────────────────────────────────────────────────────────┘
```

```python
from tensorflow.keras.layers import GRU

GRU(64, return_sequences=True, input_shape=(100, 50))
```

---

## 8.6 Bidirectional RNN

```
┌────────────────────────────────────────────────────────────────┐
│  BIDIRECTIONAL RNN — Reads sequence both directions            │
│                                                                │
│  Forward:   "I"  →  "love"  →  "this"  →  "movie"            │
│  Backward:  "I"  ←  "love"  ←  "this"  ←  "movie"            │
│                                                                │
│  ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐                   │
│  │ h→₁  │──▶│ h→₂  │──▶│ h→₃  │──▶│ h→₄  │  Forward         │
│  └──┬───┘   └──┬───┘   └──┬───┘   └──┬───┘                   │
│     │          │          │          │      Concatenated!      │
│  ┌──┴───┐   ┌──┴───┐   ┌──┴───┐   ┌──┴───┐                   │
│  │ h←₁  │◀──│ h←₂  │◀──│ h←₃  │◀──│ h←₄  │  Backward        │
│  └──────┘   └──────┘   └──────┘   └──────┘                   │
│     ↑          ↑          ↑          ↑                        │
│    "I"       "love"     "this"    "movie"                     │
│                                                                │
│  Output at each step: [h→, h←] concatenated                  │
│  If LSTM(64) → Bidirectional outputs 128-dim at each step     │
│                                                                │
│  Useful when FULL context matters (not just past):            │
│  "The ___ sat on the mat" → need future words too!            │
└────────────────────────────────────────────────────────────────┘
```

```python
from tensorflow.keras.layers import Bidirectional, LSTM

Bidirectional(LSTM(64, return_sequences=True), input_shape=(100, 50))
# Output shape: (batch, 100, 128)  ← 64*2 = 128
```

---

## 8.7 Python Implementation

### Sentiment Analysis with LSTM

```python
"""
LSTM for Sentiment Analysis: IMDB Movie Reviews
"""
import tensorflow as tf
from tensorflow.keras import Sequential
from tensorflow.keras.layers import (
    Embedding, LSTM, Bidirectional, Dense, Dropout, GlobalMaxPooling1D
)
import matplotlib.pyplot as plt

# ============================================
# STEP 1: Load IMDB Dataset
# ============================================
vocab_size = 10000
max_length = 200

(X_train, y_train), (X_test, y_test) = tf.keras.datasets.imdb.load_data(
    num_words=vocab_size
)

# Pad sequences to same length
X_train = tf.keras.preprocessing.sequence.pad_sequences(
    X_train, maxlen=max_length, padding='post', truncating='post'
)
X_test = tf.keras.preprocessing.sequence.pad_sequences(
    X_test, maxlen=max_length, padding='post', truncating='post'
)

print(f"Train: {X_train.shape}, Test: {X_test.shape}")
# Train: (25000, 200), Test: (25000, 200)

# ============================================
# STEP 2: Build LSTM Model
# ============================================
model = Sequential([
    # Embedding: converts word indices → dense vectors
    Embedding(input_dim=vocab_size, output_dim=128, input_length=max_length),
    # Shape: (batch, 200) → (batch, 200, 128)

    # Bidirectional LSTM
    Bidirectional(LSTM(64, return_sequences=True)),
    # Shape: (batch, 200, 128)

    GlobalMaxPooling1D(),
    # Shape: (batch, 128)

    Dense(64, activation='relu'),
    Dropout(0.5),
    Dense(1, activation='sigmoid')   # Binary: positive/negative
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
        tf.keras.callbacks.EarlyStopping(patience=3, restore_best_weights=True)
    ]
)

# ============================================
# STEP 4: Evaluate
# ============================================
test_loss, test_acc = model.evaluate(X_test, y_test)
print(f"\nTest Accuracy: {test_acc:.4f}")

# Plot
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
ax1.plot(history.history['loss'], label='Train')
ax1.plot(history.history['val_loss'], label='Val')
ax1.set_title('Loss'); ax1.legend()
ax2.plot(history.history['accuracy'], label='Train')
ax2.plot(history.history['val_accuracy'], label='Val')
ax2.set_title('Accuracy'); ax2.legend()
plt.show()
```

---

## 8.8 Practice & Assessment

### MCQs

**Q1.** The main problem with vanilla RNN is:
- A) Too many parameters
- B) Vanishing gradient (can't learn long-range dependencies)
- C) Too slow
- D) Only works on images

**Answer:** B — Gradients shrink exponentially through time, preventing learning of long-range patterns.

---

**Q2.** LSTM solves the vanishing gradient problem by:
- A) Using bigger weights
- B) Adding gates that control information flow and a cell state highway
- C) Using more layers
- D) Removing recurrence

**Answer:** B — The cell state acts as a highway for gradient flow, and gates selectively remember/forget.

---

**Q3.** `return_sequences=True` in LSTM means:
- A) Return only the last hidden state
- B) Return hidden state at EVERY time step
- C) Return the input sequence
- D) Return the cell state

**Answer:** B — True = output at every step (for stacking LSTMs). False = only last step (for classification).

---

**Q4.** GRU differs from LSTM in that:
- A) GRU has 3 gates, LSTM has 2
- B) GRU has 2 gates and no separate cell state (simpler, faster)
- C) GRU is always better
- D) GRU can't handle sequences

**Answer:** B — GRU combines forget and input gates into an update gate, no separate cell state.

---

> **Next Topic:** [09 - Transformers (Introduction)](09-transformers.md)
