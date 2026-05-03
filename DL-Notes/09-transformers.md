# 09. Transformers (Introduction)

## Table of Contents
- [9.1 Why Transformers?](#91-why-transformers)
- [9.2 Self-Attention Mechanism](#92-self-attention-mechanism)
- [9.3 Transformer Architecture](#93-transformer-architecture)
- [9.4 Key Innovations](#94-key-innovations)
- [9.5 Famous Transformer Models](#95-famous-transformer-models)
- [9.6 Using Pre-trained Transformers](#96-using-pre-trained-transformers)
- [9.7 Practice & Assessment](#97-practice--assessment)

---

## 9.1 Why Transformers?

### RNN Limitations

```
┌────────────────────────────────────────────────────────────────────┐
│  RNN PROBLEMS that Transformers solve:                             │
│                                                                    │
│  1. SEQUENTIAL processing (slow, can't parallelize):             │
│     word₁ → word₂ → word₃ → ... → word₁₀₀₀                     │
│     Must process one word at a time!                              │
│                                                                    │
│  2. LONG-RANGE dependencies still hard (even LSTM):              │
│     "The cat that sat on the mat near the dog ... was hungry"    │
│     200 words between "cat" and "hungry" = hard to connect       │
│                                                                    │
│  TRANSFORMER SOLUTIONS:                                            │
│  ✅ PARALLEL processing (all words at once — fast!)               │
│  ✅ Self-attention connects ANY two words directly                │
│  ✅ Scales to very long sequences                                 │
│  ✅ Powers: GPT, BERT, ChatGPT, DALL-E, etc.                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## 9.2 Self-Attention Mechanism

### Intuition

> **Attention** = "Which other words should I focus on when processing THIS word?"

```
┌────────────────────────────────────────────────────────────────────┐
│  SELF-ATTENTION EXAMPLE                                            │
│                                                                    │
│  Sentence: "The cat sat on the mat because it was tired"          │
│                                                                    │
│  When processing "it", attention asks:                             │
│  What does "it" refer to?                                         │
│                                                                    │
│  The   → attention: 0.02  (low)                                   │
│  cat   → attention: 0.45  (HIGH! "it" = "cat")                   │
│  sat   → attention: 0.05                                          │
│  on    → attention: 0.01                                          │
│  the   → attention: 0.02                                          │
│  mat   → attention: 0.10                                          │
│  because→ attention: 0.05                                         │
│  it    → attention: 0.10                                          │
│  was   → attention: 0.15                                          │
│  tired → attention: 0.05                                          │
│          ──────────────────                                        │
│          Sum = 1.00 (probability distribution!)                   │
│                                                                    │
│  The model LEARNS to attend to the right words!                   │
└────────────────────────────────────────────────────────────────────┘
```

### Query, Key, Value (Q, K, V)

$$\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right) V$$

```
┌────────────────────────────────────────────────────────────────────┐
│  QUERY, KEY, VALUE — The Attention Mechanism                      │
│                                                                    │
│  Analogy: YouTube Search                                          │
│  • Query (Q): Your search term ("cat videos")                    │
│  • Key (K):   Title of each video                                │
│  • Value (V): The actual video content                            │
│                                                                    │
│  Process:                                                          │
│  1. Compare Query with all Keys → similarity scores              │
│  2. Softmax → attention weights (probabilities)                   │
│  3. Weighted sum of Values → output                               │
│                                                                    │
│  For each word:                                                    │
│  ┌──────────┐                                                     │
│  │   Word   │──┬── × W_Q ──▶ Query (what am I looking for?)     │
│  │ Embedding│  ├── × W_K ──▶ Key   (what do I contain?)         │
│  │          │  └── × W_V ──▶ Value (what info do I provide?)     │
│  └──────────┘                                                     │
│                                                                    │
│  Scores = Q × K^T / √d_k                                        │
│  Weights = softmax(Scores)                                        │
│  Output = Weights × V                                             │
│                                                                    │
│  √d_k scaling prevents scores from being too large               │
│  (which would make softmax too peaked)                            │
└────────────────────────────────────────────────────────────────────┘
```

### Multi-Head Attention

```
┌────────────────────────────────────────────────────────────────┐
│  MULTI-HEAD ATTENTION                                          │
│                                                                │
│  Instead of one attention, run MULTIPLE in parallel:          │
│                                                                │
│  Head 1: "it" attends to grammatical subject                  │
│  Head 2: "it" attends to nearby context                       │
│  Head 3: "it" attends to semantic meaning                     │
│  ...                                                           │
│  Head 8: "it" attends to syntactic role                       │
│                                                                │
│  ┌────────┐ ┌────────┐ ┌────────┐     ┌────────┐            │
│  │ Head 1 │ │ Head 2 │ │ Head 3 │ ... │ Head 8 │            │
│  │  Q,K,V │ │  Q,K,V │ │  Q,K,V │     │  Q,K,V │            │
│  └───┬────┘ └───┬────┘ └───┬────┘     └───┬────┘            │
│      │          │          │              │                   │
│      └────┬─────┴──────────┴──────────────┘                   │
│           │ Concatenate                                       │
│           ▼                                                    │
│      ┌─────────┐                                              │
│      │ Linear  │ → Output                                    │
│      └─────────┘                                              │
│                                                                │
│  Each head can learn DIFFERENT attention patterns!            │
│  Typical: 8 or 12 heads                                       │
└────────────────────────────────────────────────────────────────┘
```

---

## 9.3 Transformer Architecture

```
┌────────────────────────────────────────────────────────────────────────┐
│  TRANSFORMER ARCHITECTURE ("Attention Is All You Need", 2017)         │
│                                                                        │
│          ENCODER                           DECODER                    │
│  ┌─────────────────────┐          ┌─────────────────────┐            │
│  │                     │          │                     │            │
│  │  ┌───────────────┐  │          │  ┌───────────────┐  │            │
│  │  │ Feed Forward  │  │          │  │ Feed Forward  │  │            │
│  │  │ Network       │  │          │  │ Network       │  │            │
│  │  └───────┬───────┘  │          │  └───────┬───────┘  │            │
│  │  ┌───────┴───────┐  │          │  ┌───────┴───────┐  │            │
│  │  │ Add & Norm    │  │          │  │ Add & Norm    │  │            │
│  │  └───────┬───────┘  │          │  └───────┬───────┘  │            │
│  │  ┌───────┴───────┐  │     ┌───▶│  ┌───────┴───────┐  │           │
│  │  │ Multi-Head    │  │     │    │  │ Cross-        │  │            │
│  │  │ Self-Attention│  │     │    │  │ Attention     │  │            │
│  │  └───────┬───────┘  │     │    │  └───────┬───────┘  │            │
│  │  ┌───────┴───────┐  │     │    │  ┌───────┴───────┐  │            │
│  │  │ Add & Norm    │  │     │    │  │ Masked Self-  │  │            │
│  │  └───────┬───────┘  │─────┘    │  │ Attention     │  │            │
│  │          │          │          │  └───────┬───────┘  │            │
│  │  ┌───────┴───────┐  │          │  ┌───────┴───────┐  │            │
│  │  │ Positional    │  │          │  │ Positional    │  │            │
│  │  │ Encoding      │  │          │  │ Encoding      │  │            │
│  │  └───────┬───────┘  │          │  └───────┬───────┘  │            │
│  │          │          │          │          │          │            │
│  │    Input Embedding  │          │   Output Embedding  │            │
│  └─────────────────────┘          └─────────────────────┘            │
│         ↑                                  ↑                         │
│  "The cat sat"                      "<start> Le chat"                │
│  (source language)                  (target language)                 │
│                                                                        │
│  × N layers (typically 6-12)                                         │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 9.4 Key Innovations

### Positional Encoding

Since transformers process all words in parallel (no recurrence), they need to know word **positions**:

$$PE_{(pos, 2i)} = \sin\left(\frac{pos}{10000^{2i/d}}\right)$$
$$PE_{(pos, 2i+1)} = \cos\left(\frac{pos}{10000^{2i/d}}\right)$$

```
┌────────────────────────────────────────────────────────────────┐
│  POSITIONAL ENCODING                                           │
│                                                                │
│  Word Embedding:    [0.2, 0.5, 0.1, ...]                     │
│       +                                                        │
│  Position Encoding: [0.0, 1.0, 0.0, ...]  (position 1)       │
│       =                                                        │
│  Final Input:       [0.2, 1.5, 0.1, ...]                     │
│                                                                │
│  Now the model knows word ORDER without recurrence!           │
└────────────────────────────────────────────────────────────────┘
```

### Residual Connections (Add & Norm)

```
x ──┬──▶ [Attention] ──┬──▶ [LayerNorm] ──▶ output
    │                   │
    └───── + ──────────┘  ← Skip connection (adds x back)

Helps gradients flow through deep networks (prevents vanishing gradient).
```

---

## 9.5 Famous Transformer Models

| Model | Type | By | Use Case |
|-------|------|-----|----------|
| **BERT** | Encoder only | Google | Understanding text (classification, Q&A) |
| **GPT-3/4** | Decoder only | OpenAI | Text generation (ChatGPT) |
| **T5** | Encoder-Decoder | Google | Any text task (translate, summarize) |
| **ViT** | Encoder | Google | Image classification (Vision Transformer) |
| **DALL-E** | Decoder | OpenAI | Text → Image generation |
| **Whisper** | Encoder-Decoder | OpenAI | Speech → Text |

```
┌────────────────────────────────────────────────────────────────┐
│  ENCODER vs DECODER MODELS                                     │
│                                                                │
│  ENCODER (BERT): Understands text                             │
│  "This movie is great" → Positive sentiment (0.95)            │
│  Sees ALL words at once (bidirectional)                        │
│                                                                │
│  DECODER (GPT): Generates text                                │
│  "Once upon a" → "time, there was a..."                       │
│  Sees only PAST words (autoregressive, left-to-right)         │
│                                                                │
│  ENCODER-DECODER (T5): Input → Output                         │
│  "Translate: The cat sat" → "Le chat s'est assis"             │
│  Encoder understands input, Decoder generates output          │
└────────────────────────────────────────────────────────────────┘
```

---

## 9.6 Using Pre-trained Transformers

### With Hugging Face (Most Popular)

```bash
pip install transformers
```

```python
from transformers import pipeline

# Sentiment Analysis (zero code!)
classifier = pipeline("sentiment-analysis")
result = classifier("I love deep learning, it's amazing!")
print(result)
# [{'label': 'POSITIVE', 'score': 0.9998}]

# Text Generation
generator = pipeline("text-generation", model="gpt2")
output = generator("Deep learning is", max_length=50, num_return_sequences=1)
print(output[0]['generated_text'])

# Question Answering
qa = pipeline("question-answering")
result = qa(
    question="What is TensorFlow?",
    context="TensorFlow is an open-source deep learning framework by Google."
)
print(f"Answer: {result['answer']} (score: {result['score']:.4f})")
```

### With TensorFlow/Keras

```python
import tensorflow as tf
from tensorflow.keras.layers import (
    MultiHeadAttention, LayerNormalization, Dense, Dropout
)

# Simple Transformer Encoder Block
class TransformerBlock(tf.keras.layers.Layer):
    def __init__(self, embed_dim, num_heads, ff_dim, dropout=0.1):
        super().__init__()
        self.attention = MultiHeadAttention(
            num_heads=num_heads, key_dim=embed_dim
        )
        self.ffn = tf.keras.Sequential([
            Dense(ff_dim, activation='relu'),
            Dense(embed_dim)
        ])
        self.norm1 = LayerNormalization()
        self.norm2 = LayerNormalization()
        self.dropout1 = Dropout(dropout)
        self.dropout2 = Dropout(dropout)

    def call(self, x, training=False):
        # Multi-head attention + residual
        attn_output = self.attention(x, x)
        attn_output = self.dropout1(attn_output, training=training)
        x = self.norm1(x + attn_output)

        # Feed-forward + residual
        ffn_output = self.ffn(x)
        ffn_output = self.dropout2(ffn_output, training=training)
        return self.norm2(x + ffn_output)
```

---

## 9.7 Practice & Assessment

### MCQs

**Q1.** The key advantage of Transformers over RNNs is:
- A) Fewer parameters
- B) Parallel processing and direct attention to any position
- C) Simpler architecture
- D) Works better on small data

**Answer:** B — Self-attention processes all positions simultaneously and connects any two words directly.

---

**Q2.** In self-attention, Q, K, V stand for:
- A) Question, Knowledge, Verification
- B) Query, Key, Value
- C) Quantize, Kernel, Vector
- D) Queue, Keep, Variable

**Answer:** B — Query = "what am I looking for?", Key = "what do I contain?", Value = "what info do I provide?"

---

**Q3.** BERT is an _____ model, while GPT is a _____ model:
- A) Decoder, Encoder
- B) Encoder, Decoder
- C) Both Encoder-Decoder
- D) Neither uses Transformers

**Answer:** B — BERT (encoder, understands text), GPT (decoder, generates text).

---

> **Next Topic:** [10 - Training & Optimization](10-training-optimization.md)
