# 22. Python Cheat Sheet

## Quick Reference — All Topics

---

## Data Types

```python
# Numbers
x = 10          # int
y = 3.14        # float
z = 2 + 3j      # complex

# Strings
s = "hello"
f = f"Value: {x}"

# Boolean
flag = True     # or False

# Collections
lst = [1, 2, 3]           # list (mutable, ordered)
tup = (1, 2, 3)           # tuple (immutable, ordered)
st = {1, 2, 3}            # set (mutable, unordered, unique)
d = {"a": 1, "b": 2}     # dict (mutable, ordered 3.7+)
```

---

## String Methods

```python
s = "Hello World"
s.upper()          # "HELLO WORLD"
s.lower()          # "hello world"
s.strip()          # Remove whitespace
s.split(" ")       # ["Hello", "World"]
s.replace("H","J") # "Jello World"
s.startswith("He") # True
s.find("World")    # 6
"_".join(["a","b"])# "a_b"
f"{3.14:.1f}"      # "3.1"
```

---

## List Operations

```python
lst = [1, 2, 3, 4, 5]
lst.append(6)       # [1,2,3,4,5,6]
lst.insert(0, 0)    # [0,1,2,3,4,5,6]
lst.pop()           # removes last → 6
lst.remove(3)       # removes first 3
lst.sort()          # in-place sort
lst.reverse()       # in-place reverse
lst[1:3]            # slice [2,3]
len(lst)            # length
lst + [7, 8]        # concatenate
```

---

## Dictionary Operations

```python
d = {"name": "Alice", "age": 25}
d["email"] = "a@b.com"    # add/update
d.get("phone", "N/A")     # safe access
d.pop("age")               # remove key
d.keys()                   # dict_keys
d.values()                 # dict_values
d.items()                  # key-value pairs
{k: v for k, v in d.items() if v}  # comprehension
```

---

## Control Flow

```python
# If-elif-else
if x > 0:
    print("positive")
elif x == 0:
    print("zero")
else:
    print("negative")

# Ternary
result = "even" if x % 2 == 0 else "odd"

# For loop
for i in range(5):          # 0,1,2,3,4
for i, v in enumerate(lst): # index + value
for k, v in d.items():      # dict iteration

# While
while condition:
    pass

# Comprehensions
squares = [x**2 for x in range(10)]
evens = [x for x in range(20) if x % 2 == 0]
```

---

## Functions

```python
def func(a, b=10, *args, **kwargs):
    return a + b

# Lambda
add = lambda x, y: x + y

# Map, Filter, Reduce
list(map(lambda x: x*2, [1,2,3]))        # [2,4,6]
list(filter(lambda x: x>2, [1,2,3,4]))   # [3,4]

from functools import reduce
reduce(lambda a,b: a+b, [1,2,3,4])       # 10
```

---

## OOP

```python
class Animal:
    def __init__(self, name):
        self.name = name
    
    def speak(self):
        raise NotImplementedError

class Dog(Animal):
    def speak(self):
        return f"{self.name} says Woof!"

# Magic methods
__init__    # Constructor
__str__     # str(obj)
__repr__    # repr(obj)
__len__     # len(obj)
__getitem__ # obj[key]
__eq__      # obj1 == obj2
```

---

## File Handling

```python
# Read
with open("file.txt", "r") as f:
    content = f.read()
    # or: lines = f.readlines()

# Write
with open("file.txt", "w") as f:
    f.write("Hello\n")

# CSV
import csv
with open("data.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(row)

# JSON
import json
data = json.loads('{"key": "value"}')
json_str = json.dumps(data, indent=2)
```

---

## Exception Handling

```python
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"Error: {e}")
except (TypeError, ValueError):
    print("Type or Value error")
else:
    print("No error")
finally:
    print("Always runs")

# Raise
raise ValueError("Invalid input")

# Custom
class MyError(Exception):
    pass
```

---

## Advanced Python

```python
# Decorator
def timer(func):
    def wrapper(*args, **kwargs):
        import time
        start = time.time()
        result = func(*args, **kwargs)
        print(f"{func.__name__}: {time.time()-start:.4f}s")
        return result
    return wrapper

# Generator
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# Context Manager
from contextlib import contextmanager

@contextmanager
def managed_resource():
    print("Setup")
    yield "resource"
    print("Cleanup")
```

---

## NumPy

```python
import numpy as np

a = np.array([1, 2, 3])
np.zeros((3, 3))            # 3x3 of zeros
np.ones((2, 4))             # 2x4 of ones
np.arange(0, 10, 2)         # [0, 2, 4, 6, 8]
np.linspace(0, 1, 5)        # 5 evenly spaced

a.reshape(3, 1)             # Reshape
a.mean(), a.std(), a.sum()  # Aggregates
np.dot(a, b)                # Dot product
a[a > 2]                    # Boolean indexing
```

---

## Pandas

```python
import pandas as pd

df = pd.read_csv("data.csv")
df.head()                    # First 5 rows
df.info()                    # Column types
df.describe()                # Statistics
df.shape                     # (rows, cols)

# Selection
df["col"]                    # Single column
df[["col1", "col2"]]        # Multiple columns
df.loc[0:5, "col"]          # Label-based
df.iloc[0:5, 0:3]           # Position-based
df[df["col"] > 50]          # Filter

# Operations
df.groupby("col").mean()
df.sort_values("col", ascending=False)
df.fillna(0)
df.dropna()
df.merge(df2, on="key")
```

---

## Matplotlib & Seaborn

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Line plot
plt.plot(x, y, 'b-o', label="data")
plt.xlabel("X"); plt.ylabel("Y")
plt.title("Title"); plt.legend()
plt.show()

# Bar, Scatter, Histogram
plt.bar(categories, values)
plt.scatter(x, y, c=colors)
plt.hist(data, bins=30)

# Seaborn
sns.boxplot(data=df, x="cat", y="num")
sns.heatmap(df.corr(), annot=True)
sns.pairplot(df, hue="target")
```

---

## Flask

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello!"

@app.route("/api/data", methods=["GET", "POST"])
def data():
    if request.method == "POST":
        return jsonify(request.get_json()), 201
    return jsonify({"msg": "ok"})

app.run(debug=True)
```

---

## Machine Learning (sklearn)

```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

model = RandomForestClassifier()
model.fit(X_train, y_train)
y_pred = model.predict(X_test)
print(accuracy_score(y_test, y_pred))
```

---

## TensorFlow/Keras

```python
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Dense, Dropout

model = Sequential([
    Dense(128, activation='relu', input_shape=(n_features,)),
    Dropout(0.2),
    Dense(64, activation='relu'),
    Dense(n_classes, activation='softmax')
])

model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
model.fit(X_train, y_train, epochs=10, batch_size=32, validation_split=0.2)
model.evaluate(X_test, y_test)
```

---

## Common One-Liners

```python
# Swap
a, b = b, a

# Flatten list
flat = [x for sub in nested for x in sub]

# Count frequency
from collections import Counter
Counter("hello")  # {'l': 2, 'h': 1, 'e': 1, 'o': 1}

# Remove duplicates (preserve order)
list(dict.fromkeys(lst))

# Read file to list
lines = Path("file.txt").read_text().splitlines()

# Merge dicts
merged = {**dict1, **dict2}   # or dict1 | dict2 (3.9+)

# Conditional assignment
x = value if condition else default
```

---

> **Next Topic:** [23 - Interview Questions](23-interview-questions.md)
