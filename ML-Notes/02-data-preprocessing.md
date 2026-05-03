# 02. Data Preprocessing

## Table of Contents
- [2.1 Why Data Preprocessing?](#21-why-data-preprocessing)
- [2.2 Handling Missing Values](#22-handling-missing-values)
- [2.3 Encoding Categorical Variables](#23-encoding-categorical-variables)
- [2.4 Feature Scaling](#24-feature-scaling)
- [2.5 Feature Engineering](#25-feature-engineering)
- [2.6 Feature Selection](#26-feature-selection)
- [2.7 Handling Outliers](#27-handling-outliers)
- [2.8 Complete Preprocessing Pipeline](#28-complete-preprocessing-pipeline)
- [2.9 Practice & Assessment](#29-practice--assessment)

---

## 2.1 Why Data Preprocessing?

### Definition
**Data Preprocessing** is the process of cleaning, transforming, and organizing raw data into a format suitable for ML algorithms.

```
┌────────────────────────────────────────────────────────────────┐
│  RAW DATA PROBLEMS                                              │
│                                                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │
│  │ Missing      │  │ Different    │  │ Categorical          │ │
│  │ Values       │  │ Scales       │  │ (Text) Data          │ │
│  │              │  │              │  │                      │ │
│  │ Age: NaN     │  │ Age: 25      │  │ Color: "Red"         │ │
│  │ Salary: NaN  │  │ Salary: 50K  │  │ City: "Mumbai"       │ │
│  └──────────────┘  └──────────────┘  └──────────────────────┘ │
│         │                 │                    │               │
│         ▼                 ▼                    ▼               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │
│  │ Imputation   │  │ Scaling      │  │ Encoding             │ │
│  │ (fill/drop)  │  │ (normalize)  │  │ (to numbers)         │ │
│  └──────────────┘  └──────────────┘  └──────────────────────┘ │
│                          │                                     │
│                          ▼                                     │
│                  CLEAN, NUMERICAL DATA                         │
│                  Ready for ML model                            │
└────────────────────────────────────────────────────────────────┘
```

> **Rule of thumb:** Data preprocessing takes 60-80% of a data scientist's time. Garbage in = Garbage out!

---

## 2.2 Handling Missing Values

### Step 1: Detect Missing Values

```python
import pandas as pd
import numpy as np

df = pd.DataFrame({
    "Name": ["Alice", "Bob", "Charlie", "Diana", "Eve"],
    "Age": [25, np.nan, 30, np.nan, 28],
    "Salary": [50000, 60000, np.nan, 55000, np.nan],
    "Department": ["IT", "HR", "IT", np.nan, "HR"]
})

print(df)
#       Name   Age   Salary Department
# 0    Alice  25.0  50000.0         IT
# 1      Bob   NaN  60000.0         HR
# 2  Charlie  30.0      NaN         IT
# 3    Diana   NaN  55000.0        NaN
# 4      Eve  28.0      NaN         HR

print(df.isnull().sum())
# Name          0
# Age           2
# Salary        2
# Department    1

print(f"Total missing: {df.isnull().sum().sum()}")
print(f"Missing %:\n{(df.isnull().sum() / len(df) * 100).round(1)}")
```

### Step 2: Handle Missing Values

```python
# METHOD 1: Drop rows with missing values
df_dropped = df.dropna()                    # Drop ANY row with NaN
df_dropped = df.dropna(subset=["Age"])       # Drop only if Age is NaN
df_dropped = df.dropna(thresh=3)             # Keep rows with ≥ 3 non-null

# METHOD 2: Fill with a constant
df["Age"].fillna(0, inplace=True)

# METHOD 3: Fill with mean / median / mode
df["Age"].fillna(df["Age"].mean(), inplace=True)        # Mean (numerical)
df["Salary"].fillna(df["Salary"].median(), inplace=True) # Median (resistant to outliers)
df["Department"].fillna(df["Department"].mode()[0], inplace=True)  # Mode (categorical)

# METHOD 4: Forward / Backward fill (time series)
df["Salary"].fillna(method="ffill", inplace=True)  # Use previous value
df["Salary"].fillna(method="bfill", inplace=True)  # Use next value

# METHOD 5: Interpolation
df["Salary"].interpolate(method="linear", inplace=True)
```

### Choosing the Right Strategy

```
┌─────────────────────────────────────────────────────────────┐
│  MISSING VALUE DECISION TREE                                 │
│                                                             │
│  Missing data?                                              │
│      │                                                      │
│      ├── < 5% missing ──► Drop rows (dropna)               │
│      │                                                      │
│      ├── 5-30% missing                                      │
│      │       │                                              │
│      │       ├── Numerical ──► Mean (normal) / Median (skew)│
│      │       └── Categorical ──► Mode / "Unknown"           │
│      │                                                      │
│      ├── > 30% missing ──► Drop entire column               │
│      │                                                      │
│      └── Time series ──► Forward fill / Interpolation       │
└─────────────────────────────────────────────────────────────┘
```

### Advanced: scikit-learn Imputers

```python
from sklearn.impute import SimpleImputer

# Numerical columns
num_imputer = SimpleImputer(strategy="mean")  # "median", "most_frequent", "constant"
df[["Age", "Salary"]] = num_imputer.fit_transform(df[["Age", "Salary"]])

# Categorical columns
cat_imputer = SimpleImputer(strategy="most_frequent")
df[["Department"]] = cat_imputer.fit_transform(df[["Department"]])
```

---

## 2.3 Encoding Categorical Variables

### Why Encode?
ML algorithms work with **numbers**, not text. We must convert categorical features to numerical form.

### Method 1: Label Encoding

```
Maps each unique category to an integer.

Color:  Red → 0,  Green → 1,  Blue → 2
Size:   S → 0,    M → 1,     L → 2
```

```python
from sklearn.preprocessing import LabelEncoder

df = pd.DataFrame({"Color": ["Red", "Green", "Blue", "Red", "Green"]})

le = LabelEncoder()
df["Color_encoded"] = le.fit_transform(df["Color"])
print(df)
#    Color  Color_encoded
# 0    Red              2
# 1  Green              1
# 2   Blue              0
# 3    Red              2
# 4  Green              1

# Decode back
print(le.inverse_transform([0, 1, 2]))  # ['Blue', 'Green', 'Red']
```

> ⚠️ **Problem:** Label Encoding implies order (Blue=0 < Green=1 < Red=2), which may mislead the model. Use ONLY for **ordinal** data (e.g., Size: S < M < L).

### Method 2: One-Hot Encoding (OHE)

```
Creates binary columns for each category — NO false ordering!

       Color_Blue  Color_Green  Color_Red
Red         0           0           1
Green       0           1           0
Blue        1           0           0
```

```python
# pandas get_dummies
df_encoded = pd.get_dummies(df, columns=["Color"], drop_first=True)
print(df_encoded)
#    Color_Green  Color_Red
# 0            0          1
# 1            1          0
# 2            0          0    ← Blue (reference category)
# 3            0          1
# 4            1          0

# scikit-learn
from sklearn.preprocessing import OneHotEncoder

ohe = OneHotEncoder(sparse_output=False, drop="first")
encoded = ohe.fit_transform(df[["Color"]])
print(encoded)
```

### When to Use Which?

| Method | Use When | Example |
|--------|----------|---------|
| **Label Encoding** | Ordinal categories (have natural order) | Education: High School < Bachelor < Master < PhD |
| **One-Hot Encoding** | Nominal categories (no order) | Color: Red, Blue, Green |
| **Ordinal Encoding** | Custom ordinal mapping | Rating: Bad=1, OK=2, Good=3 |
| **Target Encoding** | High-cardinality features | City (100+ unique values) |

---

## 2.4 Feature Scaling

### Why Scale?

```
Without scaling:                After scaling:
┌──────────────────────┐       ┌──────────────────────┐
│  Feature    Range    │       │  Feature    Range     │
│  Age        18-65    │  ──►  │  Age        0 to 1   │
│  Salary     20K-200K │       │  Salary     0 to 1   │
│  Experience 0-40     │       │  Experience 0 to 1   │
└──────────────────────┘       └──────────────────────┘

Salary (20K-200K) would DOMINATE Age (18-65) if not scaled!
Algorithms like KNN, SVM, Neural Networks are distance-based
and need features on the same scale.
```

### Method 1: Normalization (Min-Max Scaling)

**Formula:** $X_{norm} = \frac{X - X_{min}}{X_{max} - X_{min}}$

Scales values to **[0, 1]** range.

```python
from sklearn.preprocessing import MinMaxScaler

data = pd.DataFrame({
    "Age": [25, 30, 35, 40, 45],
    "Salary": [30000, 50000, 70000, 90000, 110000]
})

scaler = MinMaxScaler()
data_scaled = pd.DataFrame(
    scaler.fit_transform(data),
    columns=data.columns
)
print(data_scaled)
#    Age  Salary
# 0  0.00    0.00
# 1  0.25    0.25
# 2  0.50    0.50
# 3  0.75    0.75
# 4  1.00    1.00
```

### Method 2: Standardization (Z-Score)

**Formula:** $X_{std} = \frac{X - \mu}{\sigma}$

Centers around **mean = 0**, **std = 1**.

```python
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
data_scaled = pd.DataFrame(
    scaler.fit_transform(data),
    columns=data.columns
)
print(data_scaled)
#         Age    Salary
# 0 -1.414214 -1.414214
# 1 -0.707107 -0.707107
# 2  0.000000  0.000000
# 3  0.707107  0.707107
# 4  1.414214  1.414214
```

### Comparison

| | Normalization | Standardization |
|-|---------------|-----------------|
| **Range** | [0, 1] | No fixed range (centered at 0) |
| **Formula** | (X - Xmin) / (Xmax - Xmin) | (X - μ) / σ |
| **Sensitive to outliers** | Yes | Less sensitive |
| **Use when** | Neural Networks, KNN, image pixels | SVM, Logistic Regression, PCA |
| **Distribution** | Doesn't change shape | Assumes roughly normal |

> ⚠️ **Critical Rule:** Always `fit` on training data, then `transform` on both train AND test. Never fit on test data!

```python
# CORRECT
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)   # Fit + Transform
X_test_scaled  = scaler.transform(X_test)        # Transform ONLY

# WRONG — causes data leakage!
# scaler.fit_transform(X_test)  ← NEVER do this!
```

---

## 2.5 Feature Engineering

### Definition
**Feature Engineering** is creating new informative features from existing data to improve model performance.

```python
df = pd.DataFrame({
    "first_name": ["Alice", "Bob"],
    "last_name": ["Smith", "Jones"],
    "birth_year": [1995, 1988],
    "purchase_date": ["2024-03-15", "2024-07-20"],
    "length": [10, 15],
    "width": [5, 8],
    "price": [100, 250],
    "quantity": [3, 5]
})

# 1. Create new features from existing ones
df["full_name"] = df["first_name"] + " " + df["last_name"]
df["area"] = df["length"] * df["width"]
df["total_cost"] = df["price"] * df["quantity"]
df["price_per_sqft"] = df["price"] / df["area"]

# 2. Extract from datetime
df["purchase_date"] = pd.to_datetime(df["purchase_date"])
df["month"] = df["purchase_date"].dt.month
df["day_of_week"] = df["purchase_date"].dt.dayofweek
df["is_weekend"] = df["day_of_week"].isin([5, 6]).astype(int)

# 3. Age from birth year
df["age"] = 2024 - df["birth_year"]

# 4. Binning continuous variables
df["age_group"] = pd.cut(df["age"], bins=[0, 25, 35, 50, 100],
                          labels=["Young", "Adult", "Middle", "Senior"])

# 5. Log transform (reduce skewness)
df["log_price"] = np.log1p(df["price"])

# 6. Polynomial features
from sklearn.preprocessing import PolynomialFeatures
poly = PolynomialFeatures(degree=2, include_bias=False)
X_poly = poly.fit_transform(df[["length", "width"]])
# Creates: length, width, length², width², length×width
```

---

## 2.6 Feature Selection

### Why Select Features?
- Remove irrelevant/redundant features
- Reduce overfitting
- Faster training
- Better interpretability

```python
import pandas as pd
import numpy as np
from sklearn.datasets import load_iris
from sklearn.feature_selection import SelectKBest, f_classif, mutual_info_classif
from sklearn.ensemble import RandomForestClassifier

iris = load_iris()
X = pd.DataFrame(iris.data, columns=iris.feature_names)
y = iris.target

# METHOD 1: Correlation matrix
correlation = X.corr()
print(correlation)
# Drop features with correlation > 0.9 (redundant)

# METHOD 2: SelectKBest (statistical tests)
selector = SelectKBest(f_classif, k=2)
X_selected = selector.fit_transform(X, y)
selected_features = X.columns[selector.get_support()]
print(f"Best features: {list(selected_features)}")

# METHOD 3: Feature importance from tree models
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X, y)
importance = pd.Series(model.feature_importances_, index=X.columns)
print(importance.sort_values(ascending=False))

# METHOD 4: Variance Threshold
from sklearn.feature_selection import VarianceThreshold
selector = VarianceThreshold(threshold=0.5)
X_selected = selector.fit_transform(X)
```

### Feature Selection Methods Summary

```
┌───────────────────────────────────────────────────────────────┐
│  FEATURE SELECTION METHODS                                     │
│                                                               │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐  │
│  │   FILTER        │  │   WRAPPER       │  │  EMBEDDED    │  │
│  │                 │  │                 │  │              │  │
│  │ Before training │  │ Uses model      │  │ During       │  │
│  │                 │  │ performance     │  │ training     │  │
│  │ • Correlation   │  │                 │  │              │  │
│  │ • Chi-square    │  │ • Forward       │  │ • Lasso (L1) │  │
│  │ • Mutual Info   │  │ • Backward      │  │ • Ridge (L2) │  │
│  │ • Variance      │  │ • Recursive     │  │ • Tree       │  │
│  │                 │  │   (RFE)         │  │  importance  │  │
│  │ Fast but basic  │  │ Slow but good   │  │ Balanced     │  │
│  └─────────────────┘  └─────────────────┘  └──────────────┘  │
└───────────────────────────────────────────────────────────────┘
```

---

## 2.7 Handling Outliers

### Detection Methods

```python
import numpy as np

data = [10, 12, 14, 15, 16, 18, 20, 22, 100]  # 100 is outlier

# METHOD 1: IQR (Interquartile Range)
Q1 = np.percentile(data, 25)
Q3 = np.percentile(data, 75)
IQR = Q3 - Q1
lower = Q1 - 1.5 * IQR
upper = Q3 + 1.5 * IQR

outliers = [x for x in data if x < lower or x > upper]
print(f"IQR: {IQR}, Bounds: [{lower:.1f}, {upper:.1f}]")
print(f"Outliers: {outliers}")  # [100]

# METHOD 2: Z-Score
from scipy import stats
z_scores = np.abs(stats.zscore(data))
outliers = np.array(data)[z_scores > 3]
```

### Treatment

```python
# Option 1: Remove outliers
df_clean = df[(df["Salary"] >= lower) & (df["Salary"] <= upper)]

# Option 2: Cap/clip (winsorization)
df["Salary"] = df["Salary"].clip(lower=lower, upper=upper)

# Option 3: Log transform (reduce impact)
df["Salary_log"] = np.log1p(df["Salary"])
```

---

## 2.8 Complete Preprocessing Pipeline

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline

# Sample dataset
df = pd.DataFrame({
    "age": [25, 30, np.nan, 35, 28, 40, 22, np.nan, 33, 27],
    "salary": [30000, 50000, 40000, 60000, 35000, 70000, 25000, 45000, 55000, 32000],
    "department": ["IT", "HR", "IT", "Finance", "HR", "IT", "Finance", "HR", "IT", "Finance"],
    "education": ["Bachelor", "Master", "PhD", "Master", "Bachelor", "PhD", "Bachelor", "Master", "PhD", "Bachelor"],
    "promoted": [0, 1, 1, 1, 0, 1, 0, 0, 1, 0]  # Target
})

X = df.drop("promoted", axis=1)
y = df["promoted"]

# Define column types
numerical_features = ["age", "salary"]
categorical_features = ["department", "education"]

# Build preprocessing pipeline
numerical_pipeline = Pipeline([
    ("imputer", SimpleImputer(strategy="median")),
    ("scaler", StandardScaler())
])

categorical_pipeline = Pipeline([
    ("imputer", SimpleImputer(strategy="most_frequent")),
    ("encoder", OneHotEncoder(drop="first", sparse_output=False))
])

preprocessor = ColumnTransformer([
    ("num", numerical_pipeline, numerical_features),
    ("cat", categorical_pipeline, categorical_features)
])

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Fit and transform
X_train_processed = preprocessor.fit_transform(X_train)
X_test_processed = preprocessor.transform(X_test)

print(f"Before: {X_train.shape}")
print(f"After:  {X_train_processed.shape}")
```

```
┌──────────────────────────────────────────────────────────┐
│  PREPROCESSING PIPELINE FLOW                              │
│                                                          │
│  Raw Data                                                │
│     │                                                    │
│     ├── Numerical: age, salary                           │
│     │       │                                            │
│     │       ├── Impute (median)                          │
│     │       └── Scale (StandardScaler)                   │
│     │                                                    │
│     └── Categorical: department, education               │
│             │                                            │
│             ├── Impute (most_frequent)                   │
│             └── Encode (OneHotEncoder)                   │
│                                                          │
│     ──────────────────────────────                       │
│     Combined feature matrix → Ready for ML model        │
└──────────────────────────────────────────────────────────┘
```

---

## 2.9 Practice & Assessment

### MCQs

**Q1.** When should you use **median** instead of mean for imputation?
- A) When data is normally distributed
- B) When data has outliers or is skewed
- C) When data is categorical
- D) Always use median

**Answer:** B — Median is robust to outliers. Mean gets pulled by extreme values.

---

**Q2.** One-Hot Encoding is preferred over Label Encoding when:
- A) Categories have a natural order
- B) Categories have NO natural order (nominal data)
- C) There are only 2 categories
- D) Always

**Answer:** B — OHE avoids false ordinal relationships.

---

**Q3.** Why should you `fit` the scaler ONLY on training data?
- A) To save time
- B) To prevent data leakage (test data info leaking into training)
- C) Because test data is smaller
- D) No reason, it doesn't matter

**Answer:** B — Fitting on test data would give the model knowledge of the test distribution, leading to overly optimistic results.

---

### Coding Task

**Task:** Preprocess the Titanic-like dataset below.

```python
import pandas as pd
import numpy as np

data = pd.DataFrame({
    "age": [22, 38, 26, np.nan, 35, np.nan, 54, 2, 27, 14],
    "fare": [7.25, 71.28, 7.92, 53.10, 8.05, 8.46, 51.86, 21.07, 11.13, 30.07],
    "sex": ["male", "female", "female", "female", "male", "male", "male", "male", "female", "female"],
    "embarked": ["S", "C", "S", "S", "S", np.nan, "Q", "S", "S", "C"],
    "survived": [0, 1, 1, 1, 0, 0, 0, 0, 1, 1]
})

# Step 1: Handle missing values
data["age"].fillna(data["age"].median(), inplace=True)
data["embarked"].fillna(data["embarked"].mode()[0], inplace=True)

# Step 2: Encode categorical
data = pd.get_dummies(data, columns=["sex", "embarked"], drop_first=True)

# Step 3: Scale numerical
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
data[["age", "fare"]] = scaler.fit_transform(data[["age", "fare"]])

print(data.head())
print(f"\nShape: {data.shape}")
print(f"Missing: {data.isnull().sum().sum()}")
```

---

> **Next Topic:** [03 - Linear Regression](03-linear-regression.md)
