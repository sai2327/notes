# 07. Sets and Dictionaries

## Table of Contents
- [7.1 Sets](#71-sets)
- [7.2 Set Operations](#72-set-operations)
- [7.3 Dictionaries](#73-dictionaries)
- [7.4 Dictionary Methods (Complete)](#74-dictionary-methods-complete)
- [7.5 Dictionary Comprehensions](#75-dictionary-comprehensions)
- [7.6 Practice & Assessment](#76-practice--assessment)

---

## 7.1 Sets

### Definition
A **set** is an unordered, mutable collection of **unique** elements (no duplicates allowed).

```python
# Creating sets
fruits = {"apple", "banana", "cherry"}
numbers = {1, 2, 3, 4, 5}
empty_set = set()  # NOT {} — that creates an empty DICT!

# Duplicates are automatically removed
nums = {1, 2, 2, 3, 3, 3, 4}
print(nums)  # {1, 2, 3, 4}

# From list (remove duplicates)
my_list = [1, 2, 2, 3, 4, 4, 5]
unique = set(my_list)
print(unique)  # {1, 2, 3, 4, 5}
```

### Set Properties
- **Unordered:** No indexing (`s[0]` → Error!)
- **Mutable:** Can add/remove elements
- **Unique:** No duplicates
- **Elements must be hashable:** No lists or dicts inside sets

### Adding and Removing

```python
s = {1, 2, 3}

# add() — add one element
s.add(4)
print(s)  # {1, 2, 3, 4}

# update() — add multiple elements
s.update([5, 6, 7])
print(s)  # {1, 2, 3, 4, 5, 6, 7}

# remove() — remove element (KeyError if not found)
s.remove(3)
print(s)  # {1, 2, 4, 5, 6, 7}

# discard() — remove element (NO error if not found)
s.discard(99)  # No error
print(s)       # {1, 2, 4, 5, 6, 7}

# pop() — remove and return random element
item = s.pop()
print(f"Removed: {item}")

# clear() — remove all
s.clear()
print(s)  # set()
```

---

## 7.2 Set Operations

### Mathematical Set Operations

```
┌───────────────────────────────────────────────────────┐
│  A = {1, 2, 3, 4, 5}     B = {4, 5, 6, 7, 8}       │
│                                                       │
│  Union (A | B):        {1, 2, 3, 4, 5, 6, 7, 8}     │
│  Intersection (A & B): {4, 5}                         │
│  Difference (A - B):   {1, 2, 3}                     │
│  Symmetric Diff (A ^ B): {1, 2, 3, 6, 7, 8}         │
│                                                       │
│  Visual:                                              │
│       ┌─────────┬─────┬─────────┐                    │
│       │  A only │ A∩B │  B only │                    │
│       │ {1,2,3} │{4,5}│ {6,7,8} │                    │
│       └─────────┴─────┴─────────┘                    │
└───────────────────────────────────────────────────────┘
```

```python
A = {1, 2, 3, 4, 5}
B = {4, 5, 6, 7, 8}

# Union — all elements from both
print(A | B)              # {1, 2, 3, 4, 5, 6, 7, 8}
print(A.union(B))         # Same

# Intersection — common elements
print(A & B)              # {4, 5}
print(A.intersection(B))  # Same

# Difference — in A but not in B
print(A - B)              # {1, 2, 3}
print(A.difference(B))    # Same

# Symmetric Difference — in A or B but not both
print(A ^ B)                       # {1, 2, 3, 6, 7, 8}
print(A.symmetric_difference(B))   # Same
```

### Subset and Superset

```python
A = {1, 2, 3}
B = {1, 2, 3, 4, 5}

print(A.issubset(B))     # True (A ⊆ B)
print(B.issuperset(A))   # True (B ⊇ A)
print(A.isdisjoint({6, 7}))  # True (no common elements)
```

### frozenset (Immutable Set)

```python
fs = frozenset([1, 2, 3, 4])
# fs.add(5)  → AttributeError (can't modify!)

# Can be used as dict key or set element
my_dict = {frozenset({1, 2}): "pair"}
```

---

## 7.3 Dictionaries

### Definition
A **dictionary** is an unordered (ordered since 3.7+), mutable collection of **key:value** pairs.

```python
# Creating dictionaries
student = {
    "name": "Alice",
    "age": 20,
    "grades": [85, 90, 78],
    "active": True
}

# From dict() constructor
person = dict(name="Bob", age=25, city="NYC")

# From list of tuples
items = dict([("a", 1), ("b", 2), ("c", 3)])

# Empty dict
empty = {}
```

### Dictionary Memory Model

```
┌────────────────────────────────────────────────────┐
│  student = {"name": "Alice", "age": 20}            │
│                                                    │
│  Dict Object (Hash Table internally)               │
│  ┌──────────────┬────────────────┐                 │
│  │    KEY       │     VALUE      │                 │
│  ├──────────────┼────────────────┤                 │
│  │  "name"      │   "Alice"      │                 │
│  │  hash("name")│                │                 │
│  ├──────────────┼────────────────┤                 │
│  │  "age"       │     20         │                 │
│  │  hash("age") │                │                 │
│  └──────────────┴────────────────┘                 │
│                                                    │
│  Keys MUST be hashable (immutable): str, int, tuple│
│  Values can be anything                            │
└────────────────────────────────────────────────────┘
```

### Accessing Values

```python
student = {"name": "Alice", "age": 20, "grade": "A"}

# Using [] — raises KeyError if not found
print(student["name"])    # Alice
# print(student["phone"])  # KeyError!

# Using get() — returns None (or default) if not found
print(student.get("name"))       # Alice
print(student.get("phone"))      # None
print(student.get("phone", "N/A"))  # N/A (default value)
```

### Adding, Updating, Deleting

```python
student = {"name": "Alice", "age": 20}

# Add/Update
student["grade"] = "A"       # Add new key
student["age"] = 21          # Update existing
print(student)  # {'name': 'Alice', 'age': 21, 'grade': 'A'}

# update() — merge another dict
student.update({"city": "NYC", "age": 22})
print(student)  # {'name': 'Alice', 'age': 22, 'grade': 'A', 'city': 'NYC'}

# Delete
del student["city"]           # Remove specific key
removed = student.pop("grade")  # Remove and return value
print(removed)  # A

last = student.popitem()      # Remove last inserted pair
print(last)     # ('age', 22)
```

---

## 7.4 Dictionary Methods (Complete)

### Iteration Methods

```python
student = {"name": "Alice", "age": 20, "grade": "A"}

# keys()
print(student.keys())    # dict_keys(['name', 'age', 'grade'])

# values()
print(student.values())  # dict_values(['Alice', 20, 'A'])

# items() — key-value pairs
print(student.items())   # dict_items([('name', 'Alice'), ('age', 20), ('grade', 'A')])

# Iterate
for key in student:
    print(f"{key}: {student[key]}")

for key, value in student.items():
    print(f"{key} → {value}")
```

### Other Methods

```python
# setdefault() — get value or set default if key doesn't exist
d = {"a": 1, "b": 2}
d.setdefault("c", 3)   # Adds "c": 3 since "c" doesn't exist
d.setdefault("a", 99)  # Returns 1 (doesn't change existing)
print(d)  # {'a': 1, 'b': 2, 'c': 3}

# fromkeys() — create dict with same value for all keys
keys = ["a", "b", "c"]
d = dict.fromkeys(keys, 0)
print(d)  # {'a': 0, 'b': 0, 'c': 0}

# copy() — shallow copy
original = {"x": 1, "y": 2}
clone = original.copy()
```

### Merge Operators (Python 3.9+)

```python
d1 = {"a": 1, "b": 2}
d2 = {"b": 3, "c": 4}

# Merge (| operator) — creates new dict
merged = d1 | d2
print(merged)  # {'a': 1, 'b': 3, 'c': 4}  (d2 values win)

# Update in place (|= operator)
d1 |= d2
print(d1)  # {'a': 1, 'b': 3, 'c': 4}
```

### Complete Dictionary Methods Table

| Method | Description | Returns |
|--------|-------------|---------|
| `get(key, default)` | Get value safely | Value or default |
| `keys()` | All keys | dict_keys view |
| `values()` | All values | dict_values view |
| `items()` | All key-value pairs | dict_items view |
| `pop(key)` | Remove and return value | Value |
| `popitem()` | Remove last pair | (key, value) tuple |
| `update(dict)` | Merge another dict | None |
| `setdefault(k, v)` | Get or set default | Value |
| `clear()` | Remove all items | None |
| `copy()` | Shallow copy | New dict |
| `fromkeys(keys, val)` | Create from keys | New dict |

---

## 7.5 Dictionary Comprehensions

```python
# Basic comprehension
squares = {x: x**2 for x in range(1, 6)}
print(squares)  # {1: 1, 2: 4, 3: 9, 4: 16, 5: 25}

# With condition
even_squares = {x: x**2 for x in range(1, 11) if x % 2 == 0}
print(even_squares)  # {2: 4, 4: 16, 6: 36, 8: 64, 10: 100}

# Swap keys and values
original = {"a": 1, "b": 2, "c": 3}
swapped = {v: k for k, v in original.items()}
print(swapped)  # {1: 'a', 2: 'b', 3: 'c'}

# Word frequency counter
sentence = "hello world hello python hello"
word_count = {}
for word in sentence.split():
    word_count[word] = word_count.get(word, 0) + 1
print(word_count)  # {'hello': 3, 'world': 1, 'python': 1}
```

---

## 7.6 Practice & Assessment

### MCQs

**Q1.** What is `{1, 2, 3} & {2, 3, 4}`?
- A) `{1, 2, 3, 4}`
- B) `{2, 3}`
- C) `{1, 4}`
- D) `{}`

**Answer:** B — Intersection returns common elements.

---

**Q2.** Can a list be a dictionary key?
- A) Yes
- B) No

**Answer:** B — Lists are unhashable (mutable). Use tuples instead.

---

**Q3.** What is the output?
```python
d = {"a": 1, "b": 2}
d["c"] = d.get("c", 0) + 1
print(d["c"])
```
- A) 0
- B) 1
- C) Error
- D) None

**Answer:** B — `get("c", 0)` returns 0, then 0+1=1.

---

### Coding Tasks

**Task 1:** Find characters that appear more than once in a string.

```python
def find_duplicates(s):
    freq = {}
    for ch in s:
        freq[ch] = freq.get(ch, 0) + 1
    return {ch: count for ch, count in freq.items() if count > 1}

print(find_duplicates("programming"))  # {'r': 2, 'g': 2, 'm': 2}
```

**Task 2:** Two Sum — find two numbers in a list that add up to target.

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

**Task 3:** Group a list of words by their first letter.

```python
def group_by_first_letter(words):
    groups = {}
    for word in words:
        key = word[0].lower()
        groups.setdefault(key, []).append(word)
    return groups

words = ["apple", "banana", "avocado", "blueberry", "cherry", "apricot"]
print(group_by_first_letter(words))
# {'a': ['apple', 'avocado', 'apricot'], 'b': ['banana', 'blueberry'], 'c': ['cherry']}
```

---

> **Next Topic:** [08 - File Handling](08-file-handling.md)
