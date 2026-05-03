# 03. Linear Regression

## Table of Contents
- [3.1 Intuition](#31-intuition)
- [3.2 Mathematical Formula](#32-mathematical-formula)
- [3.3 How It Works (Step by Step)](#33-how-it-works-step-by-step)
- [3.4 Cost Function & Gradient Descent](#34-cost-function--gradient-descent)
- [3.5 Multiple Linear Regression](#35-multiple-linear-regression)
- [3.6 Polynomial Regression](#36-polynomial-regression)
- [3.7 Python Implementation](#37-python-implementation)
- [3.8 Evaluation Metrics for Regression](#38-evaluation-metrics-for-regression)
- [3.9 Assumptions of Linear Regression](#39-assumptions-of-linear-regression)
- [3.10 Advantages & Disadvantages](#310-advantages--disadvantages)
- [3.11 Practice & Assessment](#311-practice--assessment)

---

## 3.1 Intuition

### Definition
**Linear Regression** finds the **best-fit straight line** through data points to predict a continuous output based on one or more input features.

### Visual Intuition

```
┌────────────────────────────────────────────────────────┐
│  BEST FIT LINE                                          │
│                                                        │
│  Price ($)                                              │
│   ▲          ·                                         │
│   │        ·  ╱ ← Best fit line                        │
│   │      · ╱·                                          │
│   │    · ╱ ·                                           │
│   │   ╱ ·                                              │
│   │ ╱·                                                 │
│   │╱  ·                                                │
│   └──────────────────────────────► Area (sqft)         │
│                                                        │
│  Goal: Find the line that MINIMIZES the total          │
│  distance between all points and the line              │
└────────────────────────────────────────────────────────┘
```

### Real-World Applications
- **House price prediction** from area, rooms, location
- **Salary prediction** from years of experience
- **Sales forecasting** from advertising spend
- **Temperature prediction** from historical data

---

## 3.2 Mathematical Formula

### Simple Linear Regression (1 feature)

$$\hat{y} = mx + b$$

Or in ML notation:

$$\hat{y} = w_1 x + w_0$$

| Symbol | Name | Meaning |
|--------|------|---------|
| $\hat{y}$ | Prediction | Predicted output |
| $x$ | Feature | Input variable |
| $w_1$ (or $m$) | Weight / Slope | How much $y$ changes per unit of $x$ |
| $w_0$ (or $b$) | Bias / Intercept | Value of $y$ when $x = 0$ |

### Example Dry Run

```
Given: y = 2x + 5  (slope=2, intercept=5)

When x = 0:  y = 2(0) + 5 = 5
When x = 1:  y = 2(1) + 5 = 7
When x = 3:  y = 2(3) + 5 = 11
When x = 10: y = 2(10) + 5 = 25

Interpretation:
  - For every 1 unit increase in x, y increases by 2
  - When x is 0, y starts at 5
```

---

## 3.3 How It Works (Step by Step)

### Finding the Best Line: Ordinary Least Squares (OLS)

The goal is to minimize the sum of squared errors (residuals).

**Residual** = Actual value − Predicted value = $y_i - \hat{y}_i$

```
┌────────────────────────────────────────────────────────┐
│  RESIDUALS (errors)                                     │
│                                                        │
│  y ▲       · (actual)                                  │
│    │       │ ← residual (error)                        │
│    │       ● (predicted on line)                       │
│    │     · ╱                                           │
│    │   · │╱ ← residual                                 │
│    │   ●╱                                              │
│    │  ╱                                                │
│    │ ╱ ·  ← residual                                   │
│    │╱  │                                               │
│    └──────────────────► x                              │
│                                                        │
│  Best line = line where sum of ALL residuals² is       │
│  MINIMUM (Ordinary Least Squares)                      │
└────────────────────────────────────────────────────────┘
```

### OLS Formulas

$$w_1 = \frac{n \sum x_i y_i - \sum x_i \sum y_i}{n \sum x_i^2 - (\sum x_i)^2}$$

$$w_0 = \bar{y} - w_1 \bar{x}$$

### Dry Run Example

```
Data: x = [1, 2, 3, 4, 5]
      y = [2, 4, 5, 4, 5]

Step 1: Calculate means
  x̄ = (1+2+3+4+5)/5 = 3
  ȳ = (2+4+5+4+5)/5 = 4

Step 2: Calculate slope (w₁)
  Σ(xi - x̄)(yi - ȳ):
    (1-3)(2-4) + (2-3)(4-4) + (3-3)(5-4) + (4-3)(4-4) + (5-3)(5-4)
    = (-2)(-2) + (-1)(0) + (0)(1) + (1)(0) + (2)(1)
    = 4 + 0 + 0 + 0 + 2 = 6

  Σ(xi - x̄)²:
    (-2)² + (-1)² + 0² + 1² + 2²
    = 4 + 1 + 0 + 1 + 4 = 10

  w₁ = 6 / 10 = 0.6

Step 3: Calculate intercept (w₀)
  w₀ = ȳ - w₁ × x̄ = 4 - 0.6 × 3 = 2.2

Step 4: Final equation
  ŷ = 0.6x + 2.2

Step 5: Predictions
  x=1: ŷ = 0.6(1) + 2.2 = 2.8   (actual=2, error=-0.8)
  x=2: ŷ = 0.6(2) + 2.2 = 3.4   (actual=4, error=0.6)
  x=3: ŷ = 0.6(3) + 2.2 = 4.0   (actual=5, error=1.0)
  x=4: ŷ = 0.6(4) + 2.2 = 4.6   (actual=4, error=-0.6)
  x=5: ŷ = 0.6(5) + 2.2 = 5.2   (actual=5, error=-0.2)
```

---

## 3.4 Cost Function & Gradient Descent

### Cost Function: Mean Squared Error (MSE)

$$MSE = \frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i)^2$$

```
From our dry run:
MSE = [(2-2.8)² + (4-3.4)² + (5-4.0)² + (4-4.6)² + (5-5.2)²] / 5
    = [0.64 + 0.36 + 1.00 + 0.36 + 0.04] / 5
    = 2.40 / 5 = 0.48
```

### Gradient Descent

**Definition:** An iterative optimization algorithm that adjusts weights to minimize the cost function by taking steps in the direction of steepest decrease.

```
┌────────────────────────────────────────────────────────┐
│  GRADIENT DESCENT VISUALIZATION                        │
│                                                        │
│  Cost                                                  │
│   ▲                                                    │
│   │  ╲                                                 │
│   │   ╲  ● Start (random weights)                     │
│   │    ╲                                               │
│   │     ╲ ● Step 1 (smaller error)                    │
│   │      ╲                                             │
│   │       ╲ ● Step 2                                  │
│   │        ╲                                           │
│   │         ╲● Step 3                                 │
│   │          ╲___●___ Minimum! (best weights)         │
│   │               ╱                                    │
│   │              ╱                                     │
│   └──────────────────────────► Weight                 │
│                                                        │
│  Learning Rate (α):                                    │
│  Too small → Very slow convergence                     │
│  Too large → May overshoot minimum                     │
│  Just right → Converges efficiently                    │
└────────────────────────────────────────────────────────┘
```

### Update Rules

$$w_1 = w_1 - \alpha \frac{\partial MSE}{\partial w_1}$$

$$w_0 = w_0 - \alpha \frac{\partial MSE}{\partial w_0}$$

Where $\alpha$ is the **learning rate** (typically 0.001 to 0.1).

### Gradient Descent from Scratch

```python
import numpy as np

def gradient_descent(X, y, lr=0.01, epochs=1000):
    n = len(X)
    w1 = 0  # slope
    w0 = 0  # intercept
    
    for epoch in range(epochs):
        y_pred = w1 * X + w0
        
        # Gradients
        dw1 = (-2/n) * np.sum(X * (y - y_pred))
        dw0 = (-2/n) * np.sum(y - y_pred)
        
        # Update weights
        w1 -= lr * dw1
        w0 -= lr * dw0
        
        if epoch % 200 == 0:
            mse = np.mean((y - y_pred)**2)
            print(f"Epoch {epoch}: MSE={mse:.4f}, w1={w1:.4f}, w0={w0:.4f}")
    
    return w1, w0

X = np.array([1, 2, 3, 4, 5], dtype=float)
y = np.array([2, 4, 5, 4, 5], dtype=float)
w1, w0 = gradient_descent(X, y)
print(f"\nFinal: y = {w1:.2f}x + {w0:.2f}")
```

---

## 3.5 Multiple Linear Regression

$$\hat{y} = w_0 + w_1 x_1 + w_2 x_2 + \ldots + w_n x_n$$

**Example:** House Price = $w_0$ + $w_1$(area) + $w_2$(bedrooms) + $w_3$(age)

```python
from sklearn.linear_model import LinearRegression
import numpy as np

# Multiple features
X = np.array([
    [1500, 3, 10],   # area, bedrooms, age
    [2000, 4, 5],
    [1200, 2, 20],
    [1800, 3, 8],
    [2500, 5, 2]
])
y = np.array([300000, 450000, 200000, 350000, 550000])

model = LinearRegression()
model.fit(X, y)

print(f"Coefficients: {model.coef_}")
print(f"Intercept: {model.intercept_:.2f}")
# Interpretation:
# coef[0] → for each sqft, price increases by coef[0]
# coef[1] → for each bedroom, price increases by coef[1]
# coef[2] → for each year older, price changes by coef[2]

# Predict
new_house = [[1600, 3, 12]]
print(f"Predicted price: ${model.predict(new_house)[0]:,.0f}")
```

---

## 3.6 Polynomial Regression

For non-linear relationships: $\hat{y} = w_0 + w_1 x + w_2 x^2 + w_3 x^3$

```
┌────────────────────────────────────────────────────────┐
│  LINEAR vs POLYNOMIAL                                   │
│                                                        │
│  Linear (degree=1)     Polynomial (degree=2)           │
│  y│     ╱              y│     ╱‾‾‾╲                    │
│   │   ╱·                │   ╱· ·   ╲·                  │
│   │ ╱· ·                │ ╱ ·       ╲                  │
│   │╱ · ·                │╱·                            │
│   └──────► x            └──────────► x                 │
│  Misses curve           Captures curve!                │
└────────────────────────────────────────────────────────┘
```

```python
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.pipeline import Pipeline

# Create polynomial pipeline
poly_model = Pipeline([
    ("poly", PolynomialFeatures(degree=2)),
    ("linear", LinearRegression())
])

X = np.array([1, 2, 3, 4, 5]).reshape(-1, 1)
y = np.array([1, 4, 9, 16, 25])  # y = x²

poly_model.fit(X, y)
print(f"Prediction for x=6: {poly_model.predict([[6]])[0]:.0f}")  # ~36
```

---

## 3.7 Python Implementation

### Complete Example: House Price Prediction

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

# Generate synthetic data
np.random.seed(42)
n = 200
X = pd.DataFrame({
    "area": np.random.randint(800, 3500, n),
    "bedrooms": np.random.randint(1, 6, n),
    "age": np.random.randint(0, 40, n)
})
y = (X["area"] * 150 + X["bedrooms"] * 20000 - X["age"] * 2000
     + np.random.randn(n) * 15000 + 50000)

# Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train
model = LinearRegression()
model.fit(X_train, y_train)

# Predict
y_pred = model.predict(X_test)

# Evaluate
mse = mean_squared_error(y_test, y_pred)
rmse = np.sqrt(mse)
r2 = r2_score(y_test, y_pred)

print(f"RMSE: ${rmse:,.0f}")
print(f"R² Score: {r2:.4f}")
print(f"\nCoefficients:")
for feature, coef in zip(X.columns, model.coef_):
    print(f"  {feature}: {coef:,.2f}")
print(f"  Intercept: {model.intercept_:,.2f}")

# Visualize: Actual vs Predicted
plt.figure(figsize=(8, 6))
plt.scatter(y_test, y_pred, alpha=0.5)
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--')
plt.xlabel("Actual Price")
plt.ylabel("Predicted Price")
plt.title("Actual vs Predicted House Prices")
plt.show()
```

---

## 3.8 Evaluation Metrics for Regression

| Metric | Formula | Interpretation |
|--------|---------|----------------|
| **MAE** | $\frac{1}{n}\sum\|y_i - \hat{y}_i\|$ | Average absolute error (same units as y) |
| **MSE** | $\frac{1}{n}\sum(y_i - \hat{y}_i)^2$ | Average squared error (penalizes large errors) |
| **RMSE** | $\sqrt{MSE}$ | Square root of MSE (same units as y) |
| **R² Score** | $1 - \frac{\sum(y_i - \hat{y}_i)^2}{\sum(y_i - \bar{y})^2}$ | Proportion of variance explained (0 to 1) |

### R² Score Interpretation

```
R² = 1.00  → Perfect prediction
R² = 0.90  → Model explains 90% of variance (Excellent)
R² = 0.70  → Model explains 70% of variance (Good)
R² = 0.50  → Model explains 50% of variance (Moderate)
R² = 0.00  → Model is no better than predicting the mean
R² < 0.00  → Model is worse than predicting the mean
```

---

## 3.9 Assumptions of Linear Regression

| # | Assumption | Check | Fix |
|---|-----------|-------|-----|
| 1 | **Linearity** — relationship between X and y is linear | Scatter plot | Polynomial features |
| 2 | **Independence** — observations are independent | Durbin-Watson test | Correct data collection |
| 3 | **Homoscedasticity** — constant variance of errors | Residual plot | Log transform, WLS |
| 4 | **Normality** — residuals are normally distributed | Q-Q plot, Shapiro test | More data, transforms |
| 5 | **No multicollinearity** — features not highly correlated | VIF, correlation matrix | Remove correlated features |

---

## 3.10 Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Simple and interpretable | Assumes linear relationship |
| Fast training and prediction | Sensitive to outliers |
| Works well for linear data | Cannot capture complex patterns |
| Feature importance from coefficients | Assumes feature independence |
| No hyperparameters to tune | Prone to underfitting on complex data |
| Good baseline model | Requires feature scaling for regularization |

---

## 3.11 Practice & Assessment

### MCQs

**Q1.** What does the slope ($w_1$) in simple linear regression represent?
- A) The starting point of the line
- B) The change in y for every unit change in x
- C) The error of the model
- D) The learning rate

**Answer:** B — Slope tells how much y changes when x increases by 1 unit.

---

**Q2.** An R² score of 0.85 means:
- A) 85% of predictions are correct
- B) The model explains 85% of the variance in the target variable
- C) 85% of data points lie on the line
- D) The error rate is 15%

**Answer:** B

---

**Q3.** Which cost function does OLS minimize?
- A) Mean Absolute Error
- B) Mean Squared Error (Sum of Squared Residuals)
- C) Cross-Entropy
- D) Hinge Loss

**Answer:** B — OLS minimizes the sum of squared residuals.

---

### Coding Task

**Task:** Predict salary from years of experience.

```python
import numpy as np
from sklearn.linear_model import LinearRegression

experience = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).reshape(-1, 1)
salary = np.array([35, 40, 45, 50, 55, 58, 62, 66, 70, 75])  # in thousands

model = LinearRegression()
model.fit(experience, salary)

print(f"Equation: Salary = {model.coef_[0]:.2f} × Experience + {model.intercept_:.2f}")
print(f"Prediction for 15 years: ${model.predict([[15]])[0]:.1f}K")
print(f"R² Score: {model.score(experience, salary):.4f}")
```

---

> **Next Topic:** [04 - Logistic Regression](04-logistic-regression.md)
