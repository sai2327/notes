# 06. Lists and Tuples

## Table of Contents
- [6.1 Lists](#61-lists)
- [6.2 List Methods (Complete)](#62-list-methods-complete)
- [6.3 List Comprehensions](#63-list-comprehensions)
- [6.4 Tuples](#64-tuples)
- [6.5 Lists vs Tuples](#65-lists-vs-tuples)
- [6.6 Practice & Assessment](#66-practice--assessment)

---

## 6.1 Lists

### Definition
A **list** is an ordered, mutable collection that can hold items of different types.

```python
# Creating lists
empty = []
numbers = [1, 2, 3, 4, 5]
mixed = [1, "hello", 3.14, True, None]
nested = [[1, 2], [3, 4], [5, 6]]

print(type(numbers))  # <class 'list'>
print(len(numbers))   # 5
```

### List Memory Model

```
┌────────────────────────────────────────────────┐
│  fruits = ["apple", "banana", "cherry"]        │
│                                                │
│  Variable    List Object (in Heap)             │
│  ┌────────┐  ┌─────┬─────┬────────┐           │
│  │ fruits │─►│ [0] │ [1] │  [2]   │           │
│  └────────┘  │  │  │  │  │   │    │           │
│              └──┼──┴──┼──┴───┼────┘           │
│                 ▼     ▼      ▼                 │
│              "apple" "banana" "cherry"          │
│                                                │
│  Lists store REFERENCES to objects             │
└────────────────────────────────────────────────┘
```

### Indexing and Slicing

```python
fruits = ["apple", "banana", "cherry", "date", "elderberry"]

# Indexing
print(fruits[0])     # apple
print(fruits[-1])    # elderberry
print(fruits[2])     # cherry

# Slicing
print(fruits[1:4])   # ['banana', 'cherry', 'date']
print(fruits[:3])    # ['apple', 'banana', 'cherry']
print(fruits[::2])   # ['apple', 'cherry', 'elderberry']
print(fruits[::-1])  # ['elderberry', 'date', 'cherry', 'banana', 'apple']

# Modify via slicing
fruits[1:3] = ["BANANA", "CHERRY"]
print(fruits)  # ['apple', 'BANANA', 'CHERRY', 'date', 'elderberry']
```

---

## 6.2 List Methods (Complete)

### Adding Elements

```python
fruits = ["apple", "banana"]

# append() — add to end
fruits.append("cherry")
print(fruits)  # ['apple', 'banana', 'cherry']

# insert() — add at specific index
fruits.insert(1, "avocado")
print(fruits)  # ['apple', 'avocado', 'banana', 'cherry']

# extend() — add multiple items
fruits.extend(["date", "elderberry"])
print(fruits)  # ['apple', 'avocado', 'banana', 'cherry', 'date', 'elderberry']

# + operator (creates NEW list)
new_list = fruits + ["fig", "grape"]
```

### Removing Elements

```python
fruits = ["apple", "banana", "cherry", "banana", "date"]

# remove() — remove first occurrence by VALUE
fruits.remove("banana")
print(fruits)  # ['apple', 'cherry', 'banana', 'date']

# pop() — remove by index (returns removed item)
removed = fruits.pop(1)    # Remove index 1
print(removed)             # cherry
print(fruits)              # ['apple', 'banana', 'date']

last = fruits.pop()        # Remove last item (default)
print(last)                # date

# del — delete by index or slice
nums = [10, 20, 30, 40, 50]
del nums[2]                # Remove index 2
print(nums)                # [10, 20, 40, 50]
del nums[1:3]              # Remove slice
print(nums)                # [10, 50]

# clear() — remove all items
nums.clear()
print(nums)                # []
```

### Searching and Counting

```python
nums = [10, 20, 30, 20, 40, 20]

print(nums.index(20))      # 1 (first occurrence)
print(nums.index(20, 2))   # 3 (search from index 2)
print(nums.count(20))      # 3 (how many times 20 appears)
print(30 in nums)          # True
```

### Sorting and Reversing

```python
nums = [3, 1, 4, 1, 5, 9, 2, 6]

# sort() — sorts IN-PLACE (modifies original)
nums.sort()
print(nums)  # [1, 1, 2, 3, 4, 5, 6, 9]

nums.sort(reverse=True)
print(nums)  # [9, 6, 5, 4, 3, 2, 1, 1]

# sorted() — returns NEW sorted list (original unchanged)
original = [3, 1, 4, 1, 5]
new_sorted = sorted(original)
print(original)    # [3, 1, 4, 1, 5] (unchanged)
print(new_sorted)  # [1, 1, 3, 4, 5]

# Custom sort
words = ["banana", "apple", "cherry", "date"]
words.sort(key=len)
print(words)  # ['date', 'apple', 'banana', 'cherry']

# reverse() — reverse in-place
nums = [1, 2, 3, 4, 5]
nums.reverse()
print(nums)  # [5, 4, 3, 2, 1]
```

### Copying Lists

```python
# WRONG — creates reference (alias)
a = [1, 2, 3]
b = a          # b points to SAME list!
b.append(4)
print(a)       # [1, 2, 3, 4] — a is also modified!

# CORRECT — shallow copy
a = [1, 2, 3]
b = a.copy()      # Method 1
b = a[:]          # Method 2
b = list(a)       # Method 3
b.append(4)
print(a)          # [1, 2, 3] — a unchanged

# Deep copy (for nested lists)
import copy
a = [[1, 2], [3, 4]]
b = copy.deepcopy(a)
b[0][0] = 99
print(a)  # [[1, 2], [3, 4]] — a unchanged
```

### Complete List Methods Table

| Method | Description | Returns |
|--------|-------------|---------|
| `append(x)` | Add x to end | None |
| `insert(i, x)` | Add x at index i | None |
| `extend(iterable)` | Add all items from iterable | None |
| `remove(x)` | Remove first x | None (ValueError if not found) |
| `pop(i)` | Remove and return item at i | Removed item |
| `clear()` | Remove all items | None |
| `index(x)` | First index of x | Index (ValueError if not found) |
| `count(x)` | Count occurrences of x | Integer |
| `sort()` | Sort in-place | None |
| `reverse()` | Reverse in-place | None |
| `copy()` | Shallow copy | New list |

---

## 6.3 List Comprehensions

### Definition
A concise way to create lists using a single line of code.

### Syntax
```python
new_list = [expression for item in iterable if condition]
```

```python
# Traditional way
squares = []
for x in range(10):
    squares.append(x ** 2)

# List comprehension (same result!)
squares = [x ** 2 for x in range(10)]
print(squares)  # [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

# With condition (filter)
evens = [x for x in range(20) if x % 2 == 0]
print(evens)  # [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]

# With transformation + condition
even_squares = [x**2 for x in range(10) if x % 2 == 0]
print(even_squares)  # [0, 4, 16, 36, 64]

# if-else in expression
labels = ["Even" if x % 2 == 0 else "Odd" for x in range(5)]
print(labels)  # ['Even', 'Odd', 'Even', 'Odd', 'Even']

# Nested comprehension (2D → 1D)
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [num for row in matrix for num in row]
print(flat)  # [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Create 2D matrix
matrix = [[i * 3 + j for j in range(3)] for i in range(3)]
print(matrix)  # [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
```

---

## 6.4 Tuples

### Definition
A **tuple** is an ordered, **immutable** collection. Once created, it cannot be changed.

```python
# Creating tuples
empty = ()
single = (42,)          # Comma needed for single item!
coords = (10, 20)
mixed = (1, "hello", 3.14, True)
nested = ((1, 2), (3, 4))

# Without parentheses (packing)
t = 1, 2, 3
print(type(t))  # <class 'tuple'>

# Unpacking
x, y, z = t
print(x, y, z)  # 1 2 3

# Extended unpacking
a, *rest = (1, 2, 3, 4, 5)
print(a)     # 1
print(rest)  # [2, 3, 4, 5]

first, *middle, last = (1, 2, 3, 4, 5)
print(first)   # 1
print(middle)  # [2, 3, 4]
print(last)    # 5
```

### Tuple Operations

```python
t = (10, 20, 30, 40, 50)

# Indexing and slicing (same as lists)
print(t[0])      # 10
print(t[-1])     # 50
print(t[1:4])    # (20, 30, 40)

# Concatenation
t2 = t + (60, 70)
print(t2)  # (10, 20, 30, 40, 50, 60, 70)

# Repetition
t3 = (1, 2) * 3
print(t3)  # (1, 2, 1, 2, 1, 2)

# Methods (only 2!)
nums = (1, 2, 3, 2, 4, 2)
print(nums.count(2))  # 3
print(nums.index(3))  # 2

# Membership
print(30 in t)   # True
print(99 in t)   # False
```

### Why Use Tuples?
1. **Immutability:** Data that shouldn't change (coordinates, DB records)
2. **Performance:** Faster than lists
3. **Dictionary keys:** Tuples can be dict keys; lists cannot
4. **Return multiple values:** Functions returning multiple values

```python
# Tuple as dict key
locations = {(28.6, 77.2): "Delhi", (40.7, -74.0): "New York"}
print(locations[(28.6, 77.2)])  # Delhi

# Named tuples (better readability)
from collections import namedtuple
Point = namedtuple('Point', ['x', 'y'])
p = Point(10, 20)
print(p.x, p.y)  # 10 20
```

---

## 6.5 Lists vs Tuples

| Feature | List | Tuple |
|---------|------|-------|
| Syntax | `[1, 2, 3]` | `(1, 2, 3)` |
| Mutable? | ✅ Yes | ❌ No |
| Speed | Slower | Faster |
| Memory | More | Less |
| Methods | 11+ | Only `count`, `index` |
| Dict key? | ❌ No (unhashable) | ✅ Yes |
| Use when | Data changes | Data is fixed |

```python
import sys

# Memory comparison
lst = [1, 2, 3, 4, 5]
tup = (1, 2, 3, 4, 5)
print(sys.getsizeof(lst))  # 104 bytes
print(sys.getsizeof(tup))  # 80 bytes (smaller!)
```

---

## 6.6 Practice & Assessment

### MCQs

**Q1.** What is `[1, 2, 3] + [4, 5]`?
- A) `[5, 7]`
- B) `[1, 2, 3, 4, 5]`
- C) Error
- D) `[[1,2,3], [4,5]]`

**Answer:** B — List concatenation.

---

**Q2.** What does `(1)` create?
- A) Tuple with one element
- B) Integer 1
- C) List
- D) Error

**Answer:** B — Need a comma: `(1,)` for a tuple.

---

**Q3.** What is the output?
```python
a = [1, 2, 3]
b = a
b.append(4)
print(a)
```
- A) `[1, 2, 3]`
- B) `[1, 2, 3, 4]`
- C) Error
- D) `[4]`

**Answer:** B — `b = a` creates a reference, not a copy. Both point to the same list.

---

### Coding Tasks

**Task 1:** Flatten a nested list.
```python
def flatten(nested):
    return [item for sublist in nested for item in sublist]

print(flatten([[1,2], [3,4], [5,6]]))  # [1, 2, 3, 4, 5, 6]
```

**Task 2:** Find the second largest number in a list.
```python
def second_largest(lst):
    unique = list(set(lst))
    unique.sort()
    return unique[-2] if len(unique) >= 2 else None

print(second_largest([10, 5, 8, 20, 20, 15]))  # 15
```

**Task 3:** Rotate a list by k positions.
```python
def rotate(lst, k):
    k = k % len(lst)
    return lst[k:] + lst[:k]

print(rotate([1, 2, 3, 4, 5], 2))  # [3, 4, 5, 1, 2]
```

---

> **Next Topic:** [07 - Sets and Dictionaries](07-sets-dictionaries.md)
