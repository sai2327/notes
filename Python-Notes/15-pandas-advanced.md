# 15. Pandas — Advanced (GroupBy, Merge, Apply, Missing Data, Time Series)

## Table of Contents
- [15.1 Filtering and Sorting](#151-filtering-and-sorting)
- [15.2 GroupBy Operations](#152-groupby-operations)
- [15.3 Merge, Join, Concat](#153-merge-join-concat)
- [15.4 Apply, Map, Transform](#154-apply-map-transform)
- [15.5 Missing Data Handling](#155-missing-data-handling)
- [15.6 Time Series](#156-time-series)
- [15.7 Practice & Assessment](#157-practice--assessment)

---

## 15.1 Filtering and Sorting

```python
import pandas as pd
import numpy as np

df = pd.DataFrame({
    "Name": ["Alice", "Bob", "Charlie", "Diana", "Eve"],
    "Age": [25, 30, 28, 35, 22],
    "Salary": [50000, 60000, 55000, 70000, 45000],
    "Department": ["IT", "HR", "IT", "Finance", "HR"]
})

# Sorting
print(df.sort_values("Salary", ascending=False))
print(df.sort_values(["Department", "Salary"], ascending=[True, False]))

# Filtering
print(df[df["Salary"] > 55000])
print(df[df["Department"].isin(["IT", "HR"])])
print(df[df["Name"].str.startswith("A")])

# query() — SQL-like filtering
print(df.query("Age > 25 and Salary > 50000"))

# Adding/Removing columns
df["Bonus"] = df["Salary"] * 0.1
df["Tax"] = df["Salary"].apply(lambda x: x * 0.3 if x > 55000 else x * 0.2)
df.drop("Tax", axis=1, inplace=True)

# Renaming columns
df.rename(columns={"Name": "Employee"}, inplace=True)
```

---

## 15.2 GroupBy Operations

### Concept

```
┌───────────────────────────────────────────────────────┐
│  GROUPBY: Split → Apply → Combine                     │
│                                                       │
│  Original       Split by        Apply        Combine  │
│  ┌──────┐      Department       (mean)       Result  │
│  │IT  50│ ─┐                                         │
│  │HR  60│  │   IT: [50,55]    IT: 52.5    ┌───────┐ │
│  │IT  55│ ─┘   HR: [60,45]   HR: 52.5    │IT 52.5│ │
│  │Fin 70│ ─┐   Fin: [70]     Fin: 70.0   │HR 52.5│ │
│  │HR  45│ ─┘                              │Fin 70 │ │
│  └──────┘                                 └───────┘ │
└───────────────────────────────────────────────────────┘
```

```python
df = pd.DataFrame({
    "Department": ["IT", "HR", "IT", "Finance", "HR", "IT"],
    "Name": ["Alice", "Bob", "Charlie", "Diana", "Eve", "Frank"],
    "Salary": [50000, 60000, 55000, 70000, 45000, 65000],
    "Experience": [2, 5, 3, 8, 1, 6]
})

# Basic groupby
grouped = df.groupby("Department")

# Aggregate functions
print(grouped["Salary"].mean())
# Department
# Finance    70000.0
# HR         52500.0
# IT         56666.7

print(grouped["Salary"].agg(["mean", "min", "max", "count"]))

# Multiple aggregations
print(grouped.agg({
    "Salary": ["mean", "sum"],
    "Experience": "max"
}))

# Custom aggregation with named_agg
result = grouped.agg(
    avg_salary=("Salary", "mean"),
    total_salary=("Salary", "sum"),
    headcount=("Name", "count"),
    max_exp=("Experience", "max")
)
print(result)

# Filter groups
high_salary_depts = grouped.filter(lambda g: g["Salary"].mean() > 55000)
print(high_salary_depts)
```

---

## 15.3 Merge, Join, Concat

### concat() — Stack DataFrames

```python
df1 = pd.DataFrame({"A": [1, 2], "B": [3, 4]})
df2 = pd.DataFrame({"A": [5, 6], "B": [7, 8]})

# Vertical stack (add rows)
print(pd.concat([df1, df2], ignore_index=True))
#    A  B
# 0  1  3
# 1  2  4
# 2  5  7
# 3  6  8

# Horizontal stack (add columns)
print(pd.concat([df1, df2], axis=1))
```

### merge() — SQL-like Joins

```
┌───────────────────────────────────────────────────────┐
│  JOIN TYPES                                            │
│                                                       │
│  LEFT JOIN:    All from left + matching from right    │
│  RIGHT JOIN:   All from right + matching from left   │
│  INNER JOIN:   Only matching rows from both          │
│  OUTER JOIN:   All rows from both (NaN for missing)  │
│                                                       │
│  Left     Right        Inner        Outer            │
│  ┌───┐   ┌───┐       ┌───┐       ┌───┐             │
│  │ A │   │ B │       │A∩B│       │A∪B│             │
│  │ ∩B│   │∩A │       └───┘       └───┘             │
│  └───┘   └───┘                                      │
└───────────────────────────────────────────────────────┘
```

```python
employees = pd.DataFrame({
    "emp_id": [1, 2, 3, 4],
    "name": ["Alice", "Bob", "Charlie", "Diana"],
    "dept_id": [101, 102, 101, 103]
})

departments = pd.DataFrame({
    "dept_id": [101, 102, 104],
    "dept_name": ["Engineering", "Marketing", "Sales"]
})

# Inner join (default)
print(pd.merge(employees, departments, on="dept_id"))
#    emp_id     name  dept_id    dept_name
# 0       1    Alice      101  Engineering
# 1       3  Charlie      101  Engineering
# 2       2      Bob      102    Marketing

# Left join
print(pd.merge(employees, departments, on="dept_id", how="left"))
# Diana shows up with NaN dept_name (103 not in departments)

# Outer join
print(pd.merge(employees, departments, on="dept_id", how="outer"))
# All rows, NaN where no match

# Merge on different column names
# pd.merge(df1, df2, left_on="emp_id", right_on="id")
```

---

## 15.4 Apply, Map, Transform

```python
df = pd.DataFrame({
    "Name": ["Alice", "Bob", "Charlie"],
    "Salary": [50000, 60000, 55000],
    "Age": [25, 30, 28]
})

# apply() — apply function to Series or DataFrame
df["Tax"] = df["Salary"].apply(lambda x: x * 0.3 if x > 55000 else x * 0.2)
print(df)

# apply() on entire row (axis=1)
df["Summary"] = df.apply(
    lambda row: f"{row['Name']} earns {row['Salary']}", axis=1
)

# map() — element-wise mapping (Series only)
dept_map = {"Alice": "IT", "Bob": "HR", "Charlie": "IT"}
df["Department"] = df["Name"].map(dept_map)

# replace() — replace specific values
df["Department"] = df["Department"].replace({"IT": "Engineering"})

# applymap() / map() — element-wise on entire DataFrame
numeric_df = df[["Salary", "Age"]]
formatted = numeric_df.map(lambda x: f"${x:,}" if x > 1000 else str(x))
print(formatted)
```

---

## 15.5 Missing Data Handling

```python
df = pd.DataFrame({
    "Name": ["Alice", "Bob", None, "Diana"],
    "Age": [25, np.nan, 28, 35],
    "Salary": [50000, 60000, np.nan, np.nan]
})

print(df)
#     Name   Age   Salary
# 0  Alice  25.0  50000.0
# 1    Bob   NaN  60000.0
# 2   None  28.0      NaN
# 3  Diana  35.0      NaN

# Detect missing values
print(df.isnull())         # True where NaN
print(df.isnull().sum())   # Count NaN per column
# Name      1
# Age       1
# Salary    2

print(df.isnull().sum().sum())  # Total NaN: 4

# Drop missing
print(df.dropna())              # Drop rows with ANY NaN
print(df.dropna(subset=["Age"]))  # Drop only if Age is NaN
print(df.dropna(thresh=2))     # Keep rows with at least 2 non-NaN

# Fill missing
print(df.fillna(0))                   # Fill all with 0
print(df["Age"].fillna(df["Age"].mean()))  # Fill with mean
print(df.fillna(method="ffill"))       # Forward fill (use previous value)
print(df.fillna(method="bfill"))       # Backward fill

# Interpolate
df["Age"] = df["Age"].interpolate()  # Linear interpolation
```

---

## 15.6 Time Series

```python
# Creating datetime index
dates = pd.date_range("2024-01-01", periods=10, freq="D")
ts = pd.Series(np.random.randn(10), index=dates)
print(ts)

# Convert column to datetime
df = pd.DataFrame({
    "date": ["2024-01-15", "2024-02-20", "2024-03-10"],
    "sales": [100, 150, 200]
})
df["date"] = pd.to_datetime(df["date"])

# Extract components
df["year"] = df["date"].dt.year
df["month"] = df["date"].dt.month
df["day_name"] = df["date"].dt.day_name()

# Resampling (like groupby for time)
# Daily data → Monthly average
daily = pd.Series(
    np.random.randint(50, 200, 90),
    index=pd.date_range("2024-01-01", periods=90)
)
monthly = daily.resample("M").mean()
print(monthly)

# Rolling window (moving average)
rolling_7 = daily.rolling(window=7).mean()
```

---

## 15.7 Practice & Assessment

### MCQs

**Q1.** What does `df.groupby("Dept")["Salary"].mean()` do?
- A) Groups by Salary
- B) Calculates mean salary per department
- C) Sorts by department
- D) Filters by department

**Answer:** B

---

**Q2.** Which merge type keeps all rows from both DataFrames?
- A) inner
- B) left
- C) right
- D) outer

**Answer:** D

---

### Coding Task

**Task:** Given sales data, find total sales per region and month.

```python
sales = pd.DataFrame({
    "Date": pd.date_range("2024-01-01", periods=100, freq="D"),
    "Region": np.random.choice(["North", "South", "East", "West"], 100),
    "Amount": np.random.randint(100, 1000, 100)
})

sales["Month"] = sales["Date"].dt.month_name()
result = sales.groupby(["Region", "Month"])["Amount"].sum().unstack()
print(result)
```

---

> **Next Topic:** [16 - Data Visualization](16-data-visualization.md)
