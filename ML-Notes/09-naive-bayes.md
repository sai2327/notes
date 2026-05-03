# 09. Naive Bayes

## Table of Contents
- [9.1 Intuition](#91-intuition)
- [9.2 Mathematical Foundation (Bayes' Theorem)](#92-mathematical-foundation-bayes-theorem)
- [9.3 Step-by-Step Working](#93-step-by-step-working)
- [9.4 Types of Naive Bayes](#94-types-of-naive-bayes)
- [9.5 Python Implementation](#95-python-implementation)
- [9.6 Advantages & Disadvantages](#96-advantages--disadvantages)
- [9.7 Practice & Assessment](#97-practice--assessment)

---

## 9.1 Intuition

### Definition
**Naive Bayes** is a probabilistic classifier based on **Bayes' Theorem** with the "naive" assumption that features are **conditionally independent** given the class.

> **Analogy:** A doctor diagnoses disease by considering each symptom independently — fever increases chance, cough increases chance — then combines the probabilities.

### Why "Naive"?
It assumes all features contribute **independently** to the prediction. In reality, features can be correlated (e.g., height and weight), but the algorithm works surprisingly well despite this simplification.

---

## 9.2 Mathematical Foundation (Bayes' Theorem)

### Bayes' Theorem

$$P(A|B) = \frac{P(B|A) \times P(A)}{P(B)}$$

| Term | Name | Meaning |
|------|------|---------|
| $P(A\|B)$ | **Posterior** | Probability of class A given features B |
| $P(B\|A)$ | **Likelihood** | Probability of features B given class A |
| $P(A)$ | **Prior** | Probability of class A (from training data) |
| $P(B)$ | **Evidence** | Probability of features B (constant for all classes) |

### For Classification

$$P(class|features) = \frac{P(features|class) \times P(class)}{P(features)}$$

With independence assumption:

$$P(class|x_1, x_2, \ldots, x_n) \propto P(class) \times \prod_{i=1}^{n} P(x_i|class)$$

We pick the class with the **highest posterior probability**.

---

## 9.3 Step-by-Step Working

### Dry Run: Spam Classification

```
Training Data:
┌────┬───────────┬──────────┬──────────┬───────┐
│ #  │ Contains  │ Contains │ Contains │ Class │
│    │ "free"    │ "money"  │ "hello"  │       │
├────┼───────────┼──────────┼──────────┼───────┤
│ 1  │   Yes     │   Yes    │   No     │ Spam  │
│ 2  │   Yes     │   No     │   No     │ Spam  │
│ 3  │   No      │   Yes    │   No     │ Spam  │
│ 4  │   No      │   No     │   Yes    │  Ham  │
│ 5  │   No      │   No     │   Yes    │  Ham  │
│ 6  │   Yes     │   No     │   Yes    │  Ham  │
│ 7  │   No      │   Yes    │   No     │ Spam  │
│ 8  │   No      │   No     │   Yes    │  Ham  │
└────┴───────────┴──────────┴──────────┴───────┘

Classify new email: Contains "free"=Yes, "money"=Yes, "hello"=No

Step 1: Calculate Priors
  P(Spam) = 4/8 = 0.5
  P(Ham)  = 4/8 = 0.5

Step 2: Calculate Likelihoods

  For Spam:
    P("free"=Yes | Spam)  = 2/4 = 0.50
    P("money"=Yes | Spam) = 3/4 = 0.75
    P("hello"=No | Spam)  = 4/4 = 1.00

  For Ham:
    P("free"=Yes | Ham)   = 1/4 = 0.25
    P("money"=Yes | Ham)  = 0/4 = 0.00 ← Problem! (Zero probability)
    P("hello"=No | Ham)   = 1/4 = 0.25

Step 3: Apply Laplace Smoothing (add 1 to avoid zero)
    P("money"=Yes | Ham) = (0+1)/(4+2) = 1/6 = 0.167

Step 4: Calculate Posterior (proportional)
  P(Spam | features) ∝ P(Spam) × P(free=Y|Spam) × P(money=Y|Spam) × P(hello=N|Spam)
                     = 0.5 × 0.50 × 0.75 × 1.00
                     = 0.1875

  P(Ham | features)  ∝ P(Ham) × P(free=Y|Ham) × P(money=Y|Ham) × P(hello=N|Ham)
                     = 0.5 × 0.25 × 0.167 × 0.25
                     = 0.0052

Step 5: Normalize
  P(Spam) = 0.1875 / (0.1875 + 0.0052) = 0.973
  P(Ham)  = 0.0052 / (0.1875 + 0.0052) = 0.027

Step 6: Predict → SPAM (97.3% probability)
```

### Laplace Smoothing

$$P(x_i|class) = \frac{count(x_i, class) + \alpha}{count(class) + \alpha \times |V|}$$

Where $\alpha = 1$ (default) and $|V|$ = number of possible values.

---

## 9.4 Types of Naive Bayes

| Type | Distribution | Use Case | Features |
|------|-------------|----------|----------|
| **Gaussian NB** | Gaussian (normal) | Continuous features | Iris flower measurements, medical data |
| **Multinomial NB** | Multinomial | Text classification (word counts) | Spam detection, document classification |
| **Bernoulli NB** | Bernoulli (binary) | Binary features (0/1) | Text (word present/absent) |

### Gaussian Naive Bayes

Assumes features follow a normal distribution:

$$P(x_i|class) = \frac{1}{\sqrt{2\pi\sigma_{class}^2}} \exp\left(-\frac{(x_i - \mu_{class})^2}{2\sigma_{class}^2}\right)$$

```python
from sklearn.naive_bayes import GaussianNB

# For continuous features
model = GaussianNB()
```

### Multinomial Naive Bayes

```python
from sklearn.naive_bayes import MultinomialNB

# For text data (word counts / TF-IDF)
model = MultinomialNB(alpha=1.0)  # alpha = Laplace smoothing
```

---

## 9.5 Python Implementation

### Example 1: Text Spam Classification

```python
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report

# Sample data
emails = [
    "Free money now! Win cash prize!", "Meeting tomorrow at 3pm",
    "Congratulations! You won lottery!", "Project deadline extended to Friday",
    "Buy cheap products discount sale!", "Can you review the attached report?",
    "Claim your free gift today!", "Team lunch at noon, join us",
    "Limited offer! Act now!", "Please update the spreadsheet",
    "Earn money from home free!", "Quarterly review meeting scheduled",
    "Click here for free download!", "The presentation is ready for review",
]
labels = [1,0,1,0,1,0,1,0,1,0,1,0,1,0]  # 1=Spam, 0=Ham

# Vectorize text (convert words to numbers)
vectorizer = TfidfVectorizer(stop_words='english')
X = vectorizer.fit_transform(emails)
y = np.array(labels)

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=42
)

# Train
model = MultinomialNB(alpha=1.0)
model.fit(X_train, y_train)

# Evaluate
y_pred = model.predict(X_test)
print(f"Accuracy: {accuracy_score(y_test, y_pred):.4f}")
print(f"\n{classification_report(y_test, y_pred, target_names=['Ham', 'Spam'])}")

# Predict new email
new_emails = [
    "Free money win big prize now!",
    "Can we reschedule tomorrow's meeting?"
]
new_X = vectorizer.transform(new_emails)
predictions = model.predict(new_X)
probas = model.predict_proba(new_X)

for email, pred, prob in zip(new_emails, predictions, probas):
    label = "SPAM" if pred == 1 else "HAM"
    print(f"\n'{email[:40]}...' → {label} (confidence: {max(prob):.2%})")
```

### Example 2: Gaussian NB with Iris Dataset

```python
from sklearn.datasets import load_iris
from sklearn.naive_bayes import GaussianNB
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import accuracy_score

iris = load_iris()
X_train, X_test, y_train, y_test = train_test_split(
    iris.data, iris.target, test_size=0.2, random_state=42
)

gnb = GaussianNB()
gnb.fit(X_train, y_train)

y_pred = gnb.predict(X_test)
print(f"Accuracy: {accuracy_score(y_test, y_pred):.4f}")

# Cross-validation
cv_scores = cross_val_score(gnb, iris.data, iris.target, cv=5)
print(f"CV Accuracy: {cv_scores.mean():.4f} ± {cv_scores.std():.4f}")

# Show learned parameters
for i, name in enumerate(iris.target_names):
    print(f"\nClass '{name}':")
    print(f"  Mean: {gnb.theta_[i].round(2)}")
    print(f"  Variance: {gnb.var_[i].round(2)}")
```

---

## 9.6 Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Very fast training and prediction | "Naive" independence assumption rarely true |
| Works well with high-dimensional data | Can be outperformed by complex models |
| Performs surprisingly well with small data | Zero probability problem (needs smoothing) |
| Excellent for text classification | Bad at capturing feature interactions |
| Not sensitive to irrelevant features | Assumes specific probability distribution |
| Outputs well-calibrated probabilities | Poor estimator of actual probabilities |
| No feature scaling needed | |

### Real-World Applications
- **Spam filtering** (Gmail, Outlook)
- **Sentiment analysis** (product reviews)
- **Medical diagnosis** (symptom-based classification)
- **Document categorization** (news topic classification)
- **Real-time prediction** (very fast inference)

---

## 9.7 Practice & Assessment

### MCQs

**Q1.** The "naive" in Naive Bayes refers to:
- A) The algorithm is too simple
- B) The assumption that features are conditionally independent
- C) The algorithm is naive about data quality
- D) It only works with small datasets

**Answer:** B — Features are assumed to be independent given the class.

---

**Q2.** Which Naive Bayes variant is best for text classification?
- A) Gaussian NB
- B) Multinomial NB
- C) Bernoulli NB
- D) All are equally good

**Answer:** B — Multinomial NB handles word count/frequency data well.

---

**Q3.** What does Laplace Smoothing solve?
- A) Overfitting
- B) Zero probability for unseen features
- C) Slow training
- D) Feature scaling

**Answer:** B — Adding α=1 prevents any feature from having zero probability.

---

### Algorithm Comparison (All 7 Supervised)

| Algorithm | Type | Scaling Needed | Speed | Interpretability | Best For |
|-----------|------|---------------|-------|-----------------|----------|
| **Linear Regression** | Regression | For regularization | Fast | High | Linear relationships |
| **Logistic Regression** | Classification | Yes | Fast | High | Binary classification |
| **KNN** | Both | Yes | Slow (predict) | Medium | Small datasets |
| **Decision Tree** | Both | No | Fast | Very High | Interpretable rules |
| **Random Forest** | Both | No | Medium | Low | General-purpose |
| **SVM** | Both | Yes | Slow (large data) | Low | High-dim, clear margins |
| **Naive Bayes** | Classification | No | Very Fast | Medium | Text, real-time |

---

> **Next Topic:** [10 - K-Means Clustering](10-kmeans-clustering.md)
