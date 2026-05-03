# 16. Data Visualization (Matplotlib & Seaborn)

## Table of Contents
- [16.1 Matplotlib Basics](#161-matplotlib-basics)
- [16.2 Plot Types](#162-plot-types)
- [16.3 Customization](#163-customization)
- [16.4 Subplots](#164-subplots)
- [16.5 Seaborn](#165-seaborn)
- [16.6 Practice & Assessment](#166-practice--assessment)

---

## 16.1 Matplotlib Basics

```python
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# Basic line plot
x = [1, 2, 3, 4, 5]
y = [2, 4, 6, 8, 10]

plt.plot(x, y)
plt.xlabel("X axis")
plt.ylabel("Y axis")
plt.title("My First Plot")
plt.show()
```

### Anatomy of a Plot

```
┌─────────────────────────────────────────────────┐
│  Figure                                          │
│  ┌───────────────────────────────────────────┐  │
│  │  Title: "Sales Over Time"                  │  │
│  │  ┌─────────────────────────────────────┐  │  │
│  │  │  Y-axis                              │  │  │
│  │  │  label    ┌─────────────────────┐   │  │  │
│  │  │   ↕      │     PLOT AREA       │   │  │  │
│  │  │          │  (data displayed)   │   │  │  │
│  │  │          │                     │   │  │  │
│  │  │          └─────────────────────┘   │  │  │
│  │  │               X-axis label ↔       │  │  │
│  │  └─────────────────────────────────────┘  │  │
│  │  Legend: ── Line1  -- Line2               │  │
│  └───────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

---

## 16.2 Plot Types

### Line Plot

```python
months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
sales = [120, 150, 180, 160, 200, 220]
expenses = [100, 110, 130, 120, 150, 140]

plt.figure(figsize=(10, 6))
plt.plot(months, sales, 'b-o', label='Sales', linewidth=2)
plt.plot(months, expenses, 'r--s', label='Expenses', linewidth=2)
plt.xlabel("Month")
plt.ylabel("Amount ($K)")
plt.title("Sales vs Expenses 2024")
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()
```

### Bar Chart

```python
categories = ['Python', 'Java', 'JavaScript', 'C++', 'Go']
popularity = [35, 25, 20, 12, 8]

plt.figure(figsize=(8, 5))
bars = plt.bar(categories, popularity, color=['#3776AB', '#f89820', '#F7DF1E', '#00599C', '#00ADD8'])
plt.xlabel("Language")
plt.ylabel("Popularity (%)")
plt.title("Programming Language Popularity")

# Add value labels on bars
for bar, val in zip(bars, popularity):
    plt.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.5,
             str(val) + '%', ha='center')
plt.show()
```

### Histogram

```python
data = np.random.randn(1000)

plt.figure(figsize=(8, 5))
plt.hist(data, bins=30, edgecolor='black', alpha=0.7, color='steelblue')
plt.xlabel("Value")
plt.ylabel("Frequency")
plt.title("Normal Distribution (1000 samples)")
plt.axvline(data.mean(), color='red', linestyle='--', label=f'Mean: {data.mean():.2f}')
plt.legend()
plt.show()
```

### Scatter Plot

```python
np.random.seed(42)
x = np.random.rand(100) * 100
y = x * 2.5 + np.random.randn(100) * 20

plt.figure(figsize=(8, 6))
plt.scatter(x, y, alpha=0.6, c=x, cmap='viridis', edgecolors='black', linewidth=0.5)
plt.colorbar(label="X value")
plt.xlabel("Hours Studied")
plt.ylabel("Exam Score")
plt.title("Study Hours vs Exam Score")
plt.show()
```

### Pie Chart

```python
sizes = [35, 25, 20, 12, 8]
labels = ['Python', 'Java', 'JS', 'C++', 'Go']
explode = (0.1, 0, 0, 0, 0)  # "explode" Python slice

plt.figure(figsize=(8, 8))
plt.pie(sizes, explode=explode, labels=labels, autopct='%1.1f%%',
        shadow=True, startangle=90, colors=['#3776AB', '#f89820', '#F7DF1E', '#00599C', '#00ADD8'])
plt.title("Language Popularity")
plt.show()
```

### Box Plot

```python
data = [np.random.normal(60, 10, 100),
        np.random.normal(70, 15, 100),
        np.random.normal(80, 8, 100)]

plt.figure(figsize=(8, 5))
bp = plt.boxplot(data, labels=['Group A', 'Group B', 'Group C'], patch_artist=True)
plt.ylabel("Score")
plt.title("Score Distribution by Group")
plt.show()
```

---

## 16.3 Customization

```python
# Style sheets
plt.style.use('seaborn-v0_8')  # Professional look
# Other styles: 'ggplot', 'dark_background', 'fivethirtyeight'

# Custom colors and markers
# Line styles: '-' solid, '--' dashed, '-.' dashdot, ':' dotted
# Markers: 'o' circle, 's' square, '^' triangle, 'D' diamond, '*' star

# Annotations
plt.figure(figsize=(10, 6))
x = np.linspace(0, 10, 100)
y = np.sin(x)
plt.plot(x, y)
plt.annotate('Maximum', xy=(np.pi/2, 1), xytext=(4, 0.8),
             arrowprops=dict(arrowstyle='->', color='red'),
             fontsize=12, color='red')
plt.title("Sine Wave with Annotation")
plt.show()

# Save figure
# plt.savefig("plot.png", dpi=300, bbox_inches='tight')
```

---

## 16.4 Subplots

```python
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# Top-left: Line plot
axes[0, 0].plot([1,2,3,4], [1,4,9,16], 'b-o')
axes[0, 0].set_title("Line Plot")

# Top-right: Bar chart
axes[0, 1].bar(['A', 'B', 'C'], [10, 20, 15], color='orange')
axes[0, 1].set_title("Bar Chart")

# Bottom-left: Scatter
axes[1, 0].scatter(np.random.rand(50), np.random.rand(50), color='green')
axes[1, 0].set_title("Scatter Plot")

# Bottom-right: Histogram
axes[1, 1].hist(np.random.randn(500), bins=20, color='purple', alpha=0.7)
axes[1, 1].set_title("Histogram")

plt.tight_layout()
plt.show()
```

---

## 16.5 Seaborn

### Definition
**Seaborn** is built on Matplotlib and provides beautiful statistical plots with less code.

```python
import seaborn as sns

# Load built-in dataset
tips = sns.load_dataset("tips")
print(tips.head())
```

### Distribution Plots

```python
# Histogram + KDE (kernel density estimate)
sns.histplot(tips["total_bill"], kde=True, bins=20)
plt.title("Distribution of Total Bill")
plt.show()

# KDE only
sns.kdeplot(data=tips, x="total_bill", hue="time")
plt.show()
```

### Categorical Plots

```python
# Box plot by category
plt.figure(figsize=(10, 6))
sns.boxplot(data=tips, x="day", y="total_bill", hue="sex")
plt.title("Bill Distribution by Day and Gender")
plt.show()

# Violin plot (box + KDE)
sns.violinplot(data=tips, x="day", y="total_bill")
plt.show()

# Bar plot (mean + confidence interval)
sns.barplot(data=tips, x="day", y="tip", hue="sex")
plt.show()

# Count plot
sns.countplot(data=tips, x="day", hue="sex")
plt.show()
```

### Relationship Plots

```python
# Scatter with regression line
sns.lmplot(data=tips, x="total_bill", y="tip", hue="smoker")
plt.show()

# Pair plot (all combinations)
sns.pairplot(tips, hue="sex", diag_kind="kde")
plt.show()

# Heatmap (correlation matrix)
plt.figure(figsize=(8, 6))
correlation = tips[["total_bill", "tip", "size"]].corr()
sns.heatmap(correlation, annot=True, cmap="coolwarm", center=0)
plt.title("Correlation Heatmap")
plt.show()
```

---

## 16.6 Practice & Assessment

### MCQs

**Q1.** Which library provides statistical plots with less code?
- A) Matplotlib
- B) Seaborn
- C) NumPy
- D) Plotly

**Answer:** B

---

**Q2.** What does `plt.subplot(2, 3, 4)` mean?
- A) 2 rows, 3 cols, 4th position
- B) 2nd figure
- C) 4 rows, 3 cols
- D) Error

**Answer:** A — Grid of 2 rows × 3 cols, currently on the 4th subplot.

---

### Coding Task

**Task:** Create a complete visualization dashboard for sales data.

```python
import matplotlib.pyplot as plt
import numpy as np

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle("Sales Dashboard 2024", fontsize=16, fontweight='bold')

months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
sales = [120, 150, 180, 160, 200, 220]

# Line: Monthly trend
axes[0,0].plot(months, sales, 'b-o', linewidth=2)
axes[0,0].set_title("Monthly Sales Trend")
axes[0,0].set_ylabel("Sales ($K)")

# Bar: By region
regions = ['North', 'South', 'East', 'West']
values = [250, 180, 210, 190]
axes[0,1].bar(regions, values, color=['#2196F3', '#4CAF50', '#FF9800', '#9C27B0'])
axes[0,1].set_title("Sales by Region")

# Pie: Product category
axes[1,0].pie([40, 30, 20, 10], labels=['Electronics', 'Clothing', 'Food', 'Other'],
             autopct='%1.0f%%', startangle=90)
axes[1,0].set_title("Category Breakdown")

# Histogram: Order values
orders = np.random.exponential(50, 500)
axes[1,1].hist(orders, bins=25, edgecolor='black', alpha=0.7)
axes[1,1].set_title("Order Value Distribution")
axes[1,1].set_xlabel("Order Value ($)")

plt.tight_layout()
plt.show()
```

---

> **Next Topic:** [17 - Flask Web Development](17-flask-web-development.md)
