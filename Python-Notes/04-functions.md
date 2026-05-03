# 04. Functions

## Table of Contents
- [4.1 What is a Function?](#41-what-is-a-function)
- [4.2 Function Arguments](#42-function-arguments)
- [4.3 Return Statement](#43-return-statement)
- [4.4 Scope and Lifetime](#44-scope-and-lifetime)
- [4.5 Recursion](#45-recursion)
- [4.6 Lambda Functions](#46-lambda-functions)
- [4.7 Higher-Order Functions](#47-higher-order-functions)
- [4.8 Practice & Assessment](#48-practice--assessment)

---

## 4.1 What is a Function?

### Definition
A **function** is a reusable block of code that performs a specific task. It runs only when called.

### Why Use Functions?
- **Reusability:** Write once, use many times
- **Modularity:** Break complex programs into small pieces
- **Readability:** Named functions describe what code does
- **Debugging:** Easier to find and fix bugs

### Syntax

```python
def function_name(parameters):
    """Docstring — describes the function"""
    # Body
    return value
```

### Simple Example

```python
def greet(name):
    """Greet a person by name."""
    print(f"Hello, {name}! Welcome!")

# Calling the function
greet("Alice")   # Hello, Alice! Welcome!
greet("Bob")     # Hello, Bob! Welcome!
```

### Function Execution Flow

```
┌─────────────────────────────────────────────────┐
│   EXECUTION FLOW                                 │
│                                                 │
│   Line 1: def greet(name):  ← Function DEFINED │
│   Line 2:     print(...)    ← NOT executed yet  │
│   Line 3:                                       │
│   Line 4: greet("Alice")   ← Function CALLED   │
│            │                                    │
│            └──► Jumps to line 1                  │
│                 name = "Alice"                   │
│                 Executes body                    │
│                 Returns to line 4               │
│   Line 5: greet("Bob")     ← Called again       │
└─────────────────────────────────────────────────┘
```

---

## 4.2 Function Arguments

### Types of Arguments

```
┌─────────────────────────────────────────────────────────┐
│              FUNCTION ARGUMENTS                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. Positional       →  greet("Alice", 25)              │
│  2. Keyword          →  greet(name="Alice", age=25)     │
│  3. Default          →  def greet(name, age=18)         │
│  4. *args            →  def func(*args) — variable pos  │
│  5. **kwargs         →  def func(**kwargs) — variable kw│
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Positional Arguments

```python
def power(base, exponent):
    return base ** exponent

print(power(2, 10))   # 1024 — base=2, exponent=10
print(power(10, 2))   # 100  — base=10, exponent=2 (ORDER MATTERS!)
```

### Keyword Arguments

```python
def describe_pet(animal, name):
    print(f"I have a {animal} named {name}.")

# Keyword arguments — order doesn't matter!
describe_pet(name="Max", animal="dog")
# Output: I have a dog named Max.
```

### Default Arguments

```python
def greet(name, greeting="Hello"):
    print(f"{greeting}, {name}!")

greet("Alice")              # Hello, Alice! (uses default)
greet("Bob", "Good morning") # Good morning, Bob!
```

> ⚠️ **Rule:** Default arguments must come AFTER non-default arguments.
> ```python
> # WRONG: def func(a=5, b):
> # RIGHT: def func(b, a=5):
> ```

### *args (Variable Positional Arguments)

```python
def add_all(*args):
    """Accept any number of positional arguments."""
    print(f"args = {args}")  # It's a TUPLE
    return sum(args)

print(add_all(1, 2, 3))        # args = (1, 2, 3) → 6
print(add_all(10, 20, 30, 40)) # args = (10, 20, 30, 40) → 100
```

### **kwargs (Variable Keyword Arguments)

```python
def print_info(**kwargs):
    """Accept any number of keyword arguments."""
    print(f"kwargs = {kwargs}")  # It's a DICTIONARY
    for key, value in kwargs.items():
        print(f"  {key}: {value}")

print_info(name="Alice", age=25, city="NYC")
# Output:
# kwargs = {'name': 'Alice', 'age': 25, 'city': 'NYC'}
#   name: Alice
#   age: 25
#   city: NYC
```

### Combining All Types

```python
def complex_func(a, b, *args, name="default", **kwargs):
    print(f"a={a}, b={b}")
    print(f"args={args}")
    print(f"name={name}")
    print(f"kwargs={kwargs}")

complex_func(1, 2, 3, 4, 5, name="test", x=10, y=20)
# Output:
# a=1, b=2
# args=(3, 4, 5)
# name=test
# kwargs={'x': 10, 'y': 20}
```

**Order Rule:** `positional` → `*args` → `keyword/default` → `**kwargs`

---

## 4.3 Return Statement

```python
# Single return
def square(x):
    return x ** 2

result = square(5)
print(result)  # 25

# Multiple returns (returns a tuple)
def min_max(numbers):
    return min(numbers), max(numbers)

low, high = min_max([3, 1, 7, 2, 9])
print(f"Min: {low}, Max: {high}")  # Min: 1, Max: 9

# Early return
def absolute(x):
    if x >= 0:
        return x
    return -x

print(absolute(-5))  # 5

# No return = returns None
def say_hello():
    print("Hello!")

result = say_hello()
print(result)  # None
```

---

## 4.4 Scope and Lifetime

### LEGB Rule (Name Resolution Order)

```
┌──────────────────────────────────────────┐
│  L — Local         (inside function)     │
│  ┌────────────────────────────────────┐  │
│  │  E — Enclosing  (outer function)   │  │
│  │  ┌──────────────────────────────┐  │  │
│  │  │  G — Global  (module level)  │  │  │
│  │  │  ┌────────────────────────┐  │  │  │
│  │  │  │  B — Built-in (Python) │  │  │  │
│  │  │  └────────────────────────┘  │  │  │
│  │  └──────────────────────────────┘  │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

```python
x = "global"  # Global scope

def outer():
    x = "enclosing"  # Enclosing scope
    
    def inner():
        x = "local"  # Local scope
        print(x)
    
    inner()
    print(x)

outer()
print(x)

# Output:
# local
# enclosing
# global
```

### global and nonlocal Keywords

```python
count = 0  # Global

def increment():
    global count  # Modify global variable
    count += 1

increment()
increment()
print(count)  # 2

# nonlocal — modify enclosing variable
def outer():
    x = 10
    def inner():
        nonlocal x
        x += 5
    inner()
    print(x)  # 15

outer()
```

---

## 4.5 Recursion

### Definition
A function that calls **itself** until a base condition is met.

```
┌─────────────────────────────────────────┐
│        RECURSION FLOW                    │
│                                         │
│  factorial(4)                           │
│    │                                    │
│    └─► 4 * factorial(3)                 │
│              │                          │
│              └─► 3 * factorial(2)       │
│                       │                 │
│                       └─► 2 * factorial(1)│
│                                │        │
│                                └─► 1 (BASE CASE)│
│                                         │
│  Unwinding:                             │
│  factorial(1) = 1                       │
│  factorial(2) = 2 * 1 = 2              │
│  factorial(3) = 3 * 2 = 6              │
│  factorial(4) = 4 * 6 = 24             │
└─────────────────────────────────────────┘
```

```python
def factorial(n):
    # Base case
    if n == 0 or n == 1:
        return 1
    # Recursive case
    return n * factorial(n - 1)

print(factorial(5))  # 120

# Dry run:
# factorial(5) = 5 * factorial(4)
# factorial(4) = 4 * factorial(3)
# factorial(3) = 3 * factorial(2)
# factorial(2) = 2 * factorial(1)
# factorial(1) = 1 (base case)
# Back: 2*1=2, 3*2=6, 4*6=24, 5*24=120
```

### Fibonacci (Recursive)

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

for i in range(10):
    print(fibonacci(i), end=" ")
# Output: 0 1 1 2 3 5 8 13 21 34
```

> ⚠️ **Warning:** Naive recursion for Fibonacci is O(2^n) — very slow. Use memoization or iteration for large n.

---

## 4.6 Lambda Functions

### Definition
A **lambda** is an anonymous (unnamed) one-line function.

```python
# Syntax: lambda arguments: expression

# Regular function
def square(x):
    return x ** 2

# Lambda equivalent
square = lambda x: x ** 2

print(square(5))  # 25

# Multiple arguments
add = lambda a, b: a + b
print(add(3, 7))  # 10

# With conditional
classify = lambda x: "Even" if x % 2 == 0 else "Odd"
print(classify(7))  # Odd
```

---

## 4.7 Higher-Order Functions

### map() — Apply function to each item

```python
numbers = [1, 2, 3, 4, 5]

# Square each number
squared = list(map(lambda x: x ** 2, numbers))
print(squared)  # [1, 4, 9, 16, 25]

# Convert strings to integers
str_nums = ["10", "20", "30"]
int_nums = list(map(int, str_nums))
print(int_nums)  # [10, 20, 30]
```

### filter() — Keep items that match condition

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Keep even numbers only
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(evens)  # [2, 4, 6, 8, 10]

# Keep strings longer than 3 characters
words = ["hi", "hello", "hey", "world", "ok"]
long_words = list(filter(lambda w: len(w) > 3, words))
print(long_words)  # ['hello', 'world']
```

### reduce() — Combine all items into one

```python
from functools import reduce

numbers = [1, 2, 3, 4, 5]

# Sum all numbers
total = reduce(lambda a, b: a + b, numbers)
print(total)  # 15

# Step-by-step: ((((1+2)+3)+4)+5) = 15

# Find maximum
maximum = reduce(lambda a, b: a if a > b else b, numbers)
print(maximum)  # 5
```

### sorted() with key

```python
students = [("Alice", 88), ("Bob", 92), ("Charlie", 75)]

# Sort by grade (second element)
by_grade = sorted(students, key=lambda s: s[1], reverse=True)
print(by_grade)
# [('Bob', 92), ('Alice', 88), ('Charlie', 75)]

# Sort strings by length
words = ["python", "is", "awesome", "language"]
by_length = sorted(words, key=len)
print(by_length)  # ['is', 'python', 'awesome', 'language']
```

### Comparison Table

| Function | Purpose | Returns |
|----------|---------|---------|
| `map(func, iterable)` | Apply func to each item | Iterator of results |
| `filter(func, iterable)` | Keep items where func returns True | Iterator of matching items |
| `reduce(func, iterable)` | Combine all items into one value | Single value |
| `sorted(iterable, key=func)` | Sort by custom criteria | New sorted list |

---

## 4.8 Practice & Assessment

### MCQs

**Q1.** What is the output?
```python
def func(a, b=10):
    return a + b
print(func(5))
```
- A) Error
- B) 15
- C) 5
- D) 10

**Answer:** B — `a=5`, `b=10` (default), so 5+10=15.

---

**Q2.** What does `*args` collect?
- A) Dictionary of keyword arguments
- B) Tuple of positional arguments
- C) List of all arguments
- D) Set of arguments

**Answer:** B — `*args` collects extra positional arguments as a tuple.

---

**Q3.** What is the output?
```python
x = 10
def change():
    x = 20
change()
print(x)
```
- A) 10
- B) 20
- C) Error
- D) None

**Answer:** A — `x = 20` inside the function creates a LOCAL variable. The global `x` is unchanged.

---

### Coding Tasks

**Task 1:** Write a recursive function to find the sum of digits of a number.

```python
def digit_sum(n):
    if n < 10:
        return n
    return n % 10 + digit_sum(n // 10)

print(digit_sum(12345))  # 15 (1+2+3+4+5)
```

**Task 2:** Write a function that takes a list and returns a new list with duplicates removed (maintaining order).

```python
def remove_duplicates(lst):
    seen = set()
    result = []
    for item in lst:
        if item not in seen:
            seen.add(item)
            result.append(item)
    return result

print(remove_duplicates([1, 2, 2, 3, 4, 3, 5]))  # [1, 2, 3, 4, 5]
```

**Task 3:** Use `map` and `filter` to get squares of even numbers from a list.

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
result = list(map(lambda x: x**2, filter(lambda x: x % 2 == 0, numbers)))
print(result)  # [4, 16, 36, 64, 100]
```

---

> **Next Topic:** [05 - Strings](05-strings.md)
