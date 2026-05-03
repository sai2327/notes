# 14. Pandas — Basics (Series, DataFrame, Core Operations)

## Table of Contents
- [14.1 Introduction to Pandas](#141-introduction-to-pandas)
- [14.2 Series](#142-series)
- [14.3 DataFrame](#143-dataframe)
- [14.4 Reading and Writing Data](#144-reading-and-writing-data)
- [14.5 Exploring Data](#145-exploring-data)
- [14.6 Selecting Data (loc, iloc)](#146-selecting-data-loc-iloc)
- [14.7 Practice & Assessment](#147-practice--assessment)

---

## 14.1 Introduction to Pandas

### What is Pandas?
**Pandas** is Python's most powerful data manipulation library. It provides two main data structures: Series (1D) and DataFrame (2D table).

```
┌───────────────────────────────────────────────────────┐
│  PANDAS DATA STRUCTURES                                │
│                                                       │
│  Series (1D):           DataFrame (2D):               │
│  ┌───┬────────┐         ┌─────┬─────┬──────┐         │
│  │ 0 │ "Alice"│         │     │Name │ Age  │         │
│  │ 1 │ "Bob"  │         ├─────┼─────┼──────┤         │
│  │ 2 │ "Charlie"│       │  0  │Alice│  25  │         │
│  └───┴────────┘         │  1  │Bob  │  30  │         │
│  Index  Values           │  2  │Charlie│ 28│         │
│                          └─────┴─────┴──────┘         │
│                          Index  Columns                │
└───────────────────────────────────────────────────────┘
```

```python
import pandas as pd
import numpy as np
```

---

## 14.2 Series

### Definition
A **Series** is a one-dimensional labeled array.

```python
# Creating Series
s1 = pd.Series([10, 20, 30, 40, 50])
print(s1)
# 0    10
# 1    20
# 2    30
# 3    40
# 4    50
# dtype: int64

# Custom index
s2 = pd.Series([85, 90, 78], index=["Math", "Science", "English"])
print(s2)
# Math       85
# Science    90
# English    78

# From dictionary
s3 = pd.Series({"a": 1, "b": 2, "c": 3})

# Accessing
print(s2["Math"])       # 85
print(s2[0])            # 85 (positional)
print(s2[s2 > 80])     # Math 85, Science 90

# Operations (vectorized)
print(s2 + 10)          # Adds 10 to all values
print(s2.mean())        # 84.33
print(s2.max())         # 90
```

---

## 14.3 DataFrame

### Definition
A **DataFrame** is a two-dimensional table with labeled rows and columns.

```python
# From dictionary
data = {
    "Name": ["Alice", "Bob", "Charlie", "Diana"],
    "Age": [25, 30, 28, 35],
    "City": ["NYC", "London", "Paris", "Tokyo"],
    "Salary": [50000, 60000, 55000, 70000]
}
df = pd.DataFrame(data)
print(df)
#       Name  Age    City  Salary
# 0    Alice   25     NYC   50000
# 1      Bob   30  London   60000
# 2  Charlie   28   Paris   55000
# 3    Diana   35   Tokyo   70000

# From list of dicts
records = [
    {"name": "Alice", "score": 85},
    {"name": "Bob", "score": 92},
    {"name": "Charlie", "score": 78}
]
df2 = pd.DataFrame(records)

# From NumPy array
arr = np.random.randint(1, 100, size=(4, 3))
df3 = pd.DataFrame(arr, columns=["A", "B", "C"])
```

### DataFrame Attributes

```python
print(df.shape)      # (4, 4) — rows, cols
print(df.columns)    # Index(['Name', 'Age', 'City', 'Salary'])
print(df.index)      # RangeIndex(start=0, stop=4, step=1)
print(df.dtypes)     # Data type of each column
print(df.values)     # NumPy array of values
print(len(df))       # 4 (number of rows)
```

---

## 14.4 Reading and Writing Data

```python
# CSV
df = pd.read_csv("data.csv")
df.to_csv("output.csv", index=False)

# Excel
df = pd.read_excel("data.xlsx", sheet_name="Sheet1")
df.to_excel("output.xlsx", index=False)

# JSON
df = pd.read_json("data.json")
df.to_json("output.json", orient="records", indent=2)

# SQL
import sqlite3
conn = sqlite3.connect("database.db")
df = pd.read_sql("SELECT * FROM users", conn)
df.to_sql("users", conn, if_exists="replace", index=False)

# Clipboard
# df = pd.read_clipboard()  # Reads from system clipboard!
```

---

## 14.5 Exploring Data

```python
# Create sample DataFrame
df = pd.DataFrame({
    "Name": ["Alice", "Bob", "Charlie", "Diana", "Eve"],
    "Age": [25, 30, 28, 35, 22],
    "Salary": [50000, 60000, 55000, 70000, 45000],
    "Department": ["IT", "HR", "IT", "Finance", "HR"]
})

# head() — first n rows (default 5)
print(df.head(3))
#       Name  Age  Salary Department
# 0    Alice   25   50000         IT
# 1      Bob   30   60000         HR
# 2  Charlie   28   55000         IT

# tail() — last n rows
print(df.tail(2))

# info() — data types, non-null counts, memory
df.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 5 entries, 0 to 4
# Data columns (total 4 columns):
#  #   Column      Non-Null Count  Dtype
# ---  ------      --------------  -----
#  0   Name        5 non-null      object
#  1   Age         5 non-null      int64
#  2   Salary      5 non-null      int64
#  3   Department  5 non-null      object

# describe() — statistical summary (numeric columns)
print(df.describe())
#              Age        Salary
# count   5.000000      5.000000
# mean   28.000000  56000.000000
# std     4.743416   9354.143467
# min    22.000000  45000.000000
# 25%    25.000000  50000.000000
# 50%    28.000000  55000.000000
# 75%    30.000000  60000.000000
# max    35.000000  70000.000000

# value_counts() — frequency of unique values
print(df["Department"].value_counts())
# IT         2
# HR         2
# Finance    1

# nunique() — number of unique values
print(df.nunique())
```

---

## 14.6 Selecting Data (loc, iloc)

### Column Selection

```python
# Single column (returns Series)
print(df["Name"])

# Multiple columns (returns DataFrame)
print(df[["Name", "Salary"]])

# Using dot notation (only for valid identifiers)
print(df.Name)
```

### Row Selection

```python
# By condition (Boolean indexing)
print(df[df["Age"] > 25])
#       Name  Age  Salary Department
# 1      Bob   30   60000         HR
# 2  Charlie   28   55000         IT
# 3    Diana   35   70000    Finance

# Multiple conditions
print(df[(df["Age"] > 25) & (df["Salary"] > 55000)])
```

### loc[] — Label-based Selection

```python
# loc[row_label, column_label]
print(df.loc[0, "Name"])           # "Alice"
print(df.loc[0:2, "Name":"Salary"]) # Rows 0-2, Cols Name to Salary (INCLUSIVE!)
print(df.loc[df["Age"] > 25, ["Name", "Salary"]])  # Condition + columns
```

### iloc[] — Integer Position-based Selection

```python
# iloc[row_index, col_index]
print(df.iloc[0, 0])          # "Alice" (row 0, col 0)
print(df.iloc[0:3, 0:2])      # First 3 rows, first 2 cols (EXCLUSIVE end!)
print(df.iloc[[0, 2, 4], :])  # Specific rows
```

### loc vs iloc Comparison

| Feature | `loc` | `iloc` |
|---------|-------|--------|
| Selection by | Label/name | Integer position |
| End of slice | **Inclusive** | **Exclusive** |
| Accepts conditions | Yes | No |
| Example | `df.loc[0:2]` → rows 0,1,2 | `df.iloc[0:2]` → rows 0,1 |

---

## 14.7 Practice & Assessment

### MCQs

**Q1.** What does `df.shape` return?
- A) Number of rows
- B) (rows, columns)
- C) Column names
- D) Data types

**Answer:** B

---

**Q2.** What is the difference between `loc` and `iloc`?
- A) `loc` is faster
- B) `loc` uses labels, `iloc` uses positions
- C) They are the same
- D) `iloc` uses labels

**Answer:** B

---

### Coding Task

**Task:** Create a DataFrame of 5 students with Name, Math, Science, English scores. Calculate average, find topper, filter students scoring > 80 in all subjects.

```python
df = pd.DataFrame({
    "Name": ["Alice", "Bob", "Charlie", "Diana", "Eve"],
    "Math": [85, 72, 90, 88, 95],
    "Science": [92, 68, 85, 91, 88],
    "English": [78, 80, 82, 95, 90]
})

# Average score
df["Average"] = df[["Math", "Science", "English"]].mean(axis=1)
print(df)

# Topper
topper = df.loc[df["Average"].idxmax(), "Name"]
print(f"Topper: {topper}")

# All subjects > 80
mask = (df["Math"] > 80) & (df["Science"] > 80) & (df["English"] > 80)
print(df[mask])
```

---

> **Next Topic:** [15 - Pandas Advanced](15-pandas-advanced.md)
