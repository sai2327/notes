# 23. Python Interview Questions & Answers

## Table of Contents
- [23.1 Core Python](#231-core-python)
- [23.2 OOP](#232-oop)
- [23.3 Advanced Python](#233-advanced-python)
- [23.4 Data Structures & Algorithms](#234-data-structures--algorithms)
- [23.5 Libraries & Frameworks](#235-libraries--frameworks)
- [23.6 Coding Challenges](#236-coding-challenges)

---

## 23.1 Core Python

### Q1. What is the difference between a list and a tuple?

| Feature | List | Tuple |
|---------|------|-------|
| Mutable | Yes | No |
| Syntax | `[1, 2, 3]` | `(1, 2, 3)` |
| Speed | Slower | Faster |
| Memory | More | Less |
| Use as dict key | No | Yes |
| Methods | 11 | 2 (count, index) |

---

### Q2. What is the difference between `is` and `==`?

```python
a = [1, 2, 3]
b = [1, 2, 3]
c = a

print(a == b)  # True  — same value
print(a is b)  # False — different objects in memory
print(a is c)  # True  — same object (c references a)
```

- `==` compares **values** (calls `__eq__`)
- `is` compares **identity** (same memory address)

---

### Q3. What are `*args` and `**kwargs`?

```python
def demo(*args, **kwargs):
    print(f"args: {args}")       # Tuple of positional args
    print(f"kwargs: {kwargs}")   # Dict of keyword args

demo(1, 2, 3, name="Alice", age=25)
# args: (1, 2, 3)
# kwargs: {'name': 'Alice', 'age': 25}
```

- `*args` — collect extra positional arguments as a **tuple**
- `**kwargs` — collect extra keyword arguments as a **dict**

---

### Q4. Explain Python's GIL (Global Interpreter Lock).

The **GIL** is a mutex that allows only one thread to execute Python bytecode at a time.

- **Impact:** CPU-bound tasks don't benefit from threading
- **Solution:** Use `multiprocessing` for CPU tasks, `threading` for I/O tasks
- **Why it exists:** Simplifies memory management (reference counting)

---

### Q5. What is the difference between `deepcopy` and `copy`?

```python
import copy

original = [[1, 2], [3, 4]]
shallow = copy.copy(original)
deep = copy.deepcopy(original)

original[0][0] = 99
print(shallow[0][0])  # 99 — nested list shared!
print(deep[0][0])     # 1  — completely independent
```

---

### Q6. How does Python manage memory?

1. **Reference counting** — each object tracks how many references point to it
2. **Garbage collection** — cyclic reference detector runs periodically
3. **Memory pools** — small objects (<512 bytes) allocated from pools
4. **Interning** — small integers (-5 to 256) and short strings cached

---

## 23.2 OOP

### Q7. What are the four pillars of OOP?

1. **Encapsulation** — Bundle data + methods; hide internal state
2. **Inheritance** — Derive new classes from existing ones
3. **Polymorphism** — Same interface, different implementations
4. **Abstraction** — Show only essential features, hide complexity

---

### Q8. What is the MRO (Method Resolution Order)?

```python
class A:
    def show(self): print("A")

class B(A):
    def show(self): print("B")

class C(A):
    def show(self): print("C")

class D(B, C):
    pass

d = D()
d.show()  # "B"
print(D.__mro__)  # D → B → C → A → object
```

Python uses **C3 Linearization** to determine method lookup order.

---

### Q9. Difference between `@staticmethod` and `@classmethod`?

```python
class MyClass:
    count = 0
    
    @classmethod
    def get_count(cls):        # Receives class as first arg
        return cls.count
    
    @staticmethod
    def utility():             # No implicit first arg
        return "Just a function in class namespace"
```

| | @classmethod | @staticmethod |
|-|-------------|---------------|
| First arg | `cls` (class) | None |
| Access class | Yes | No |
| Access instance | No | No |
| Use case | Factory methods, class state | Utility functions |

---

### Q10. What are abstract classes?

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self):
        pass

# shape = Shape()  # TypeError: Can't instantiate abstract class
class Circle(Shape):
    def __init__(self, r):
        self.r = r
    def area(self):
        return 3.14 * self.r ** 2
```

- Cannot be instantiated directly
- Force subclasses to implement specific methods

---

## 23.3 Advanced Python

### Q11. What are decorators? Write a practical example.

```python
import time
from functools import wraps

def retry(max_attempts=3):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts:
                        raise
                    print(f"Attempt {attempt} failed: {e}. Retrying...")
                    time.sleep(1)
        return wrapper
    return decorator

@retry(max_attempts=3)
def fetch_data(url):
    # Might fail due to network issues
    pass
```

---

### Q12. Generators vs List Comprehensions — when to use which?

```python
# List comprehension — stores ALL in memory
squares_list = [x**2 for x in range(1_000_000)]  # ~8MB

# Generator — produces one at a time
squares_gen = (x**2 for x in range(1_000_000))   # ~120 bytes
```

| | List Comprehension | Generator |
|-|-------------------|-----------|
| Memory | All at once | One at a time |
| Speed (single pass) | Similar | Similar |
| Reusable | Yes | No (exhausted after one pass) |
| Use when | Need random access, small data | Large data, streaming |

---

### Q13. What is a closure?

```python
def multiplier(n):
    def multiply(x):
        return x * n   # 'n' is captured from enclosing scope
    return multiply

double = multiplier(2)
triple = multiplier(3)
print(double(5))   # 10
print(triple(5))   # 15
```

A **closure** is a function that remembers values from its enclosing scope even after that scope has finished executing.

---

### Q14. Explain `with` statement and context managers.

```python
# The with statement calls __enter__ on entry and __exit__ on exit
# Ensures cleanup happens even if exceptions occur

class DBConnection:
    def __enter__(self):
        self.conn = connect_to_db()
        return self.conn
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.close()
        return False  # Don't suppress exceptions

with DBConnection() as conn:
    conn.execute("SELECT ...")
# conn.close() called automatically
```

---

## 23.4 Data Structures & Algorithms

### Q15. Reverse a linked list.

```python
class Node:
    def __init__(self, val, next=None):
        self.val = val
        self.next = next

def reverse_list(head):
    prev = None
    current = head
    while current:
        next_node = current.next
        current.next = prev
        prev = current
        current = next_node
    return prev
```

---

### Q16. Find two numbers that sum to a target.

```python
def two_sum(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []

print(two_sum([2, 7, 11, 15], 9))  # [0, 1]
```

**Time:** O(n) | **Space:** O(n)

---

### Q17. Check if string has all unique characters.

```python
def all_unique(s):
    return len(s) == len(set(s))

# Without extra space:
def all_unique_no_extra(s):
    for i in range(len(s)):
        for j in range(i + 1, len(s)):
            if s[i] == s[j]:
                return False
    return True
```

---

## 23.5 Libraries & Frameworks

### Q18. Pandas: How do you handle missing data?

```python
import pandas as pd

df.isnull().sum()              # Count missing per column
df.dropna()                     # Remove rows with any NaN
df.dropna(subset=["col"])      # Remove if specific col is NaN
df["col"].fillna(df["col"].mean())  # Fill with mean
df.fillna(method="ffill")      # Forward fill
df.interpolate()                # Linear interpolation
```

---

### Q19. Explain the bias-variance tradeoff in ML.

- **Bias** — Error from oversimplified model (underfitting)
- **Variance** — Error from overcomplex model (overfitting)
- **Goal** — Find the sweet spot (low bias + low variance)

```
High Bias:  Model too simple → misses patterns
High Variance: Model too complex → memorizes noise
Solution: Cross-validation, regularization, ensemble methods
```

---

### Q20. What is the difference between Flask and Django?

| Feature | Flask | Django |
|---------|-------|--------|
| Philosophy | Micro, minimal | Batteries-included |
| ORM | External (SQLAlchemy) | Built-in |
| Admin | None | Auto-generated |
| Flexibility | Very flexible | More opinionated |
| Best for | APIs, microservices | Full web apps |
| Learning | Easy | Moderate |

---

## 23.6 Coding Challenges

### Q21. Fibonacci (multiple approaches)

```python
# Recursive (slow: O(2^n))
def fib_recursive(n):
    if n <= 1: return n
    return fib_recursive(n-1) + fib_recursive(n-2)

# Dynamic Programming (O(n))
def fib_dp(n):
    if n <= 1: return n
    dp = [0, 1]
    for i in range(2, n+1):
        dp.append(dp[-1] + dp[-2])
    return dp[n]

# Generator (memory efficient)
def fib_gen():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b
```

---

### Q22. Find the most frequent element in a list.

```python
from collections import Counter

def most_frequent(lst):
    return Counter(lst).most_common(1)[0][0]

# Without imports
def most_frequent_manual(lst):
    freq = {}
    for item in lst:
        freq[item] = freq.get(item, 0) + 1
    return max(freq, key=freq.get)
```

---

### Q23. Implement a LRU Cache.

```python
from collections import OrderedDict

class LRUCache:
    def __init__(self, capacity):
        self.cache = OrderedDict()
        self.capacity = capacity
    
    def get(self, key):
        if key not in self.cache:
            return -1
        self.cache.move_to_end(key)
        return self.cache[key]
    
    def put(self, key, value):
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value
        if len(self.cache) > self.capacity:
            self.cache.popitem(last=False)
```

---

### Q24. Flatten a nested list (any depth).

```python
def flatten(lst):
    result = []
    for item in lst:
        if isinstance(item, list):
            result.extend(flatten(item))
        else:
            result.append(item)
    return result

print(flatten([1, [2, [3, 4]], [5, 6]]))  # [1, 2, 3, 4, 5, 6]
```

---

### Q25. Check if two strings are anagrams.

```python
def is_anagram(s1, s2):
    return sorted(s1.lower()) == sorted(s2.lower())

# O(n) approach
from collections import Counter
def is_anagram_fast(s1, s2):
    return Counter(s1.lower()) == Counter(s2.lower())

print(is_anagram("listen", "silent"))  # True
```

---

> **Next Topic:** [24 - Mini Projects](24-mini-projects.md)
