# 12. Advanced Python (Decorators, Generators, Comprehensions)

## Table of Contents
- [12.1 Decorators](#121-decorators)
- [12.2 Generators](#122-generators)
- [12.3 Iterators](#123-iterators)
- [12.4 Context Managers](#124-context-managers)
- [12.5 Comprehensions (All Types)](#125-comprehensions-all-types)
- [12.6 Practice & Assessment](#126-practice--assessment)

---

## 12.1 Decorators

### Definition
A **decorator** is a function that modifies the behavior of another function without changing its source code.

### How Decorators Work

```
┌──────────────────────────────────────────────────────┐
│  DECORATOR FLOW                                       │
│                                                      │
│  @decorator       ← Syntactic sugar                  │
│  def function():                                     │
│      ...                                             │
│                                                      │
│  Is equivalent to:                                   │
│  function = decorator(function)                      │
│                                                      │
│  Flow:                                               │
│  ┌──────────┐    ┌──────────────┐    ┌──────────┐   │
│  │  Call     │───►│  Decorator   │───►│ Original │   │
│  │  func()  │    │  (wrapper)   │    │ Function │   │
│  └──────────┘    │  - before    │    └──────────┘   │
│                  │  - call func │                    │
│                  │  - after     │                    │
│                  └──────────────┘                    │
└──────────────────────────────────────────────────────┘
```

### Basic Decorator

```python
import time

def timer(func):
    """Measure execution time of a function."""
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.4f} seconds")
        return result
    return wrapper

@timer
def slow_function():
    time.sleep(1)
    return "Done!"

result = slow_function()
# Output: slow_function took 1.0012 seconds
print(result)  # Done!
```

### Decorator with Arguments

```python
def repeat(n):
    """Decorator that calls a function n times."""
    def decorator(func):
        def wrapper(*args, **kwargs):
            results = []
            for _ in range(n):
                results.append(func(*args, **kwargs))
            return results
        return wrapper
    return decorator

@repeat(3)
def greet(name):
    print(f"Hello, {name}!")
    return f"Greeted {name}"

greet("Alice")
# Hello, Alice!
# Hello, Alice!
# Hello, Alice!
```

### Practical Decorators

```python
from functools import wraps

# Login required decorator
def login_required(func):
    @wraps(func)  # Preserves function metadata
    def wrapper(user, *args, **kwargs):
        if not user.get("logged_in"):
            print("Access denied! Please log in.")
            return None
        return func(user, *args, **kwargs)
    return wrapper

@login_required
def view_dashboard(user):
    return f"Welcome to dashboard, {user['name']}!"

user1 = {"name": "Alice", "logged_in": True}
user2 = {"name": "Bob", "logged_in": False}

print(view_dashboard(user1))  # Welcome to dashboard, Alice!
print(view_dashboard(user2))  # Access denied! Please log in. → None

# Memoization (caching)
def memoize(func):
    cache = {}
    @wraps(func)
    def wrapper(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    return wrapper

@memoize
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(100))  # Instant! (without memoize would take forever)
```

---

## 12.2 Generators

### Definition
A **generator** is a function that yields values one at a time, maintaining state between calls. Uses `yield` instead of `return`.

### Why Generators?
- **Memory efficient:** Don't store all values in memory
- **Lazy evaluation:** Compute values only when needed
- **Infinite sequences:** Can represent infinite data

```python
# Regular function — stores ALL in memory
def get_squares_list(n):
    result = []
    for i in range(n):
        result.append(i ** 2)
    return result  # Returns entire list

# Generator — yields ONE at a time
def get_squares_gen(n):
    for i in range(n):
        yield i ** 2  # Pauses here, resumes on next()

# Comparison
import sys
list_result = get_squares_list(1000000)
gen_result = get_squares_gen(1000000)

print(sys.getsizeof(list_result))  # ~8 MB
print(sys.getsizeof(gen_result))   # 120 bytes! (just the generator object)
```

### Generator Execution Flow

```python
def countdown(n):
    print("Starting countdown!")
    while n > 0:
        yield n   # Pause and return n
        n -= 1
    print("Done!")

gen = countdown(3)
# Nothing printed yet! (lazy)

print(next(gen))  # Starting countdown! → 3
print(next(gen))  # 2
print(next(gen))  # 1
# next(gen)       # Done! → StopIteration
```

### Generator Expressions

```python
# Like list comprehension but with () — creates generator
squares_gen = (x**2 for x in range(10))
print(type(squares_gen))  # <class 'generator'>

# Iterate
for sq in squares_gen:
    print(sq, end=" ")
# 0 1 4 9 16 25 36 49 64 81

# Practical: sum of squares without storing list
total = sum(x**2 for x in range(1000000))
print(total)  # Memory efficient!
```

### Practical: Read Large File Line by Line

```python
def read_large_file(filepath):
    """Generator to read file line by line (memory efficient)."""
    with open(filepath, "r") as f:
        for line in f:
            yield line.strip()

# Process millions of lines without loading entire file
# for line in read_large_file("huge_file.txt"):
#     process(line)
```

---

## 12.3 Iterators

### Iterator Protocol

```python
class CountDown:
    """Custom iterator that counts down from n to 1."""
    def __init__(self, start):
        self.current = start
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self.current <= 0:
            raise StopIteration
        value = self.current
        self.current -= 1
        return value

# Usage
for num in CountDown(5):
    print(num, end=" ")
# Output: 5 4 3 2 1

# Manual iteration
it = iter([10, 20, 30])
print(next(it))  # 10
print(next(it))  # 20
print(next(it))  # 30
# next(it) → StopIteration
```

---

## 12.4 Context Managers

### Definition
Context managers handle setup and cleanup automatically using `with` statement.

```python
# Custom context manager using class
class FileManager:
    def __init__(self, filename, mode):
        self.filename = filename
        self.mode = mode
        self.file = None
    
    def __enter__(self):
        self.file = open(self.filename, self.mode)
        return self.file
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.file.close()
        if exc_type:
            print(f"Exception handled: {exc_val}")
        return False  # Don't suppress exceptions

with FileManager("test.txt", "w") as f:
    f.write("Hello!")

# Using contextlib (simpler)
from contextlib import contextmanager

@contextmanager
def timer_context(label):
    import time
    start = time.time()
    yield  # Code inside 'with' block runs here
    end = time.time()
    print(f"{label}: {end - start:.4f}s")

with timer_context("Processing"):
    total = sum(range(1000000))
# Output: Processing: 0.0312s
```

---

## 12.5 Comprehensions (All Types)

### All Four Types

```python
# LIST comprehension — produces list
squares = [x**2 for x in range(10)]

# DICT comprehension — produces dict
word_lengths = {w: len(w) for w in ["hello", "world", "python"]}
# {'hello': 5, 'world': 5, 'python': 6}

# SET comprehension — produces set (unique values)
unique_lengths = {len(w) for w in ["hi", "hello", "hey", "world"]}
# {2, 3, 5}

# GENERATOR expression — produces generator (lazy)
gen = (x**2 for x in range(10))
```

### Advanced Comprehensions

```python
# Nested comprehension
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
transposed = [[row[i] for row in matrix] for i in range(3)]
print(transposed)  # [[1, 4, 7], [2, 5, 8], [3, 6, 9]]

# Multiple conditions
filtered = [x for x in range(100) if x % 2 == 0 if x % 3 == 0]
print(filtered)  # [0, 6, 12, 18, 24, 30, ...]

# Walrus operator in comprehension (Python 3.8+)
data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
results = [y for x in data if (y := x**2) > 20]
print(results)  # [25, 36, 49, 64, 81, 100]
```

---

## 12.6 Practice & Assessment

### MCQs

**Q1.** What does `yield` do?
- A) Ends the function permanently
- B) Pauses function and returns a value
- C) Creates a list
- D) Raises an exception

**Answer:** B — `yield` pauses and returns; function resumes on next `next()` call.

---

**Q2.** What is the output?
```python
def gen():
    yield 1
    yield 2
    yield 3

g = gen()
print(next(g) + next(g))
```
- A) 1
- B) 3
- C) 6
- D) Error

**Answer:** B — `next(g)` returns 1, second `next(g)` returns 2. Sum = 3.

---

### Coding Tasks

**Task 1:** Create a decorator that logs function calls with arguments.

```python
from functools import wraps

def log_calls(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}({args}, {kwargs})")
        result = func(*args, **kwargs)
        print(f"{func.__name__} returned {result}")
        return result
    return wrapper

@log_calls
def add(a, b):
    return a + b

add(3, 5)
# Calling add((3, 5), {})
# add returned 8
```

**Task 2:** Create a generator for Fibonacci numbers.

```python
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# Get first 10 Fibonacci numbers
fib = fibonacci()
first_10 = [next(fib) for _ in range(10)]
print(first_10)  # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
```

---

> **Next Topic:** [13 - NumPy](13-numpy.md)
