# 05. Strings

## Table of Contents
- [5.1 What are Strings?](#51-what-are-strings)
- [5.2 String Indexing and Slicing](#52-string-indexing-and-slicing)
- [5.3 String Methods (Complete)](#53-string-methods-complete)
- [5.4 String Formatting](#54-string-formatting)
- [5.5 Escape Characters](#55-escape-characters)
- [5.6 Practice & Assessment](#56-practice--assessment)

---

## 5.1 What are Strings?

### Definition
A **string** is a sequence of characters enclosed in quotes. Strings are **immutable** (cannot be changed after creation).

```python
s1 = 'Hello'              # Single quotes
s2 = "World"              # Double quotes
s3 = '''Multi-line
string'''                  # Triple quotes
s4 = """Also
multi-line"""

# Strings are immutable
s = "Hello"
# s[0] = 'h'  → TypeError: 'str' object does not support item assignment
```

### String Memory (Immutability)

```
┌─────────────────────────────────────────────┐
│  s = "Hello"                                │
│  s = s + " World"                           │
│                                             │
│  Step 1:  s ──► "Hello"  (id: 100)         │
│                                             │
│  Step 2:  s ──► "Hello World" (id: 200)    │
│                  "Hello" (id: 100) → GC     │
│                                             │
│  A NEW object is created, old is abandoned  │
└─────────────────────────────────────────────┘
```

---

## 5.2 String Indexing and Slicing

### Indexing

```
  String:   P   y   t   h   o   n
  Index:    0   1   2   3   4   5
  Neg:     -6  -5  -4  -3  -2  -1
```

```python
s = "Python"
print(s[0])    # P
print(s[5])    # n
print(s[-1])   # n (last character)
print(s[-2])   # o (second last)
```

### Slicing: `s[start:stop:step]`

```python
s = "Hello World"

print(s[0:5])      # Hello (index 0 to 4)
print(s[6:])       # World (index 6 to end)
print(s[:5])       # Hello (start to index 4)
print(s[::2])      # HloWrd (every 2nd char)
print(s[::-1])     # dlroW olleH (REVERSE!)
print(s[2:8])      # llo Wo
print(s[-5:])      # World (last 5 chars)
```

### Slicing Visualization

```
 s = "Hello World"
      H  e  l  l  o     W  o  r  l  d
      0  1  2  3  4  5  6  7  8  9  10

 s[0:5]  → H e l l o          = "Hello"
 s[6:11] → W o r l d          = "World"
 s[::2]  → H _ l _ o _ W _ r _ d = "HloWrd"
 s[::-1] → d l r o W   o l l e H = "dlroW olleH"
```

---

## 5.3 String Methods (Complete)

### Case Methods

```python
s = "hello World PYTHON"

print(s.upper())       # HELLO WORLD PYTHON
print(s.lower())       # hello world python
print(s.capitalize())  # Hello world python (first char only)
print(s.title())       # Hello World Python (each word)
print(s.swapcase())    # HELLO wORLD python
print(s.casefold())    # hello world python (aggressive lowercase)
```

### Search Methods

```python
s = "Hello World Hello Python"

print(s.find("Hello"))      # 0 (first occurrence index)
print(s.find("Hello", 5))   # 12 (start searching from index 5)
print(s.find("Java"))       # -1 (not found)
print(s.rfind("Hello"))     # 12 (last occurrence)
print(s.index("World"))     # 6 (like find, but raises ValueError if not found)
print(s.count("Hello"))     # 2 (count occurrences)
```

### Check Methods (return True/False)

```python
print("hello".isalpha())      # True (only letters)
print("12345".isdigit())      # True (only digits)
print("hello123".isalnum())   # True (letters + digits)
print("   ".isspace())        # True (only whitespace)
print("Hello World".istitle()) # True (title case)
print("HELLO".isupper())     # True
print("hello".islower())     # True
print("hello".startswith("hel"))  # True
print("hello".endswith("llo"))    # True
```

### Modify Methods

```python
s = "  Hello World  "

print(s.strip())          # "Hello World" (remove both sides)
print(s.lstrip())         # "Hello World  " (remove left)
print(s.rstrip())         # "  Hello World" (remove right)

s = "Hello World"
print(s.replace("World", "Python"))  # Hello Python
print(s.replace("l", "L", 2))       # HeLLo World (replace first 2)

# center, ljust, rjust
print("Hi".center(10, "-"))   # ----Hi----
print("Hi".ljust(10, "."))    # Hi........
print("Hi".rjust(10, "."))    # ........Hi
print("Hi".zfill(5))          # 000Hi
```

### Split and Join

```python
# split() — string to list
s = "apple,banana,cherry"
fruits = s.split(",")
print(fruits)  # ['apple', 'banana', 'cherry']

s2 = "Hello World Python"
words = s2.split()  # Split by whitespace (default)
print(words)  # ['Hello', 'World', 'Python']

# splitlines() — split by newlines
text = "line1\nline2\nline3"
lines = text.splitlines()
print(lines)  # ['line1', 'line2', 'line3']

# join() — list to string
words = ['Hello', 'World', 'Python']
sentence = " ".join(words)
print(sentence)  # Hello World Python

csv = ",".join(["a", "b", "c"])
print(csv)  # a,b,c
```

### Complete Methods Table

| Method | Purpose | Example | Result |
|--------|---------|---------|--------|
| `upper()` | All uppercase | `"hi".upper()` | `"HI"` |
| `lower()` | All lowercase | `"HI".lower()` | `"hi"` |
| `capitalize()` | First char upper | `"hi there".capitalize()` | `"Hi there"` |
| `title()` | Each word capitalized | `"hi there".title()` | `"Hi There"` |
| `strip()` | Remove whitespace | `" hi ".strip()` | `"hi"` |
| `split(sep)` | Split to list | `"a,b".split(",")` | `['a','b']` |
| `join(list)` | Join list to string | `"-".join(['a','b'])` | `"a-b"` |
| `replace(old,new)` | Replace substring | `"hi".replace("hi","bye")` | `"bye"` |
| `find(sub)` | Find index (-1 if not found) | `"hello".find("ll")` | `2` |
| `count(sub)` | Count occurrences | `"hello".count("l")` | `2` |
| `startswith(s)` | Starts with? | `"hello".startswith("he")` | `True` |
| `endswith(s)` | Ends with? | `"hello".endswith("lo")` | `True` |
| `isdigit()` | All digits? | `"123".isdigit()` | `True` |
| `isalpha()` | All letters? | `"abc".isalpha()` | `True` |
| `encode()` | Encode to bytes | `"hi".encode("utf-8")` | `b'hi'` |

---

## 5.4 String Formatting

### f-strings (Best — Python 3.6+)

```python
name = "Alice"
age = 25
pi = 3.14159

# Basic
print(f"Name: {name}, Age: {age}")

# Expressions inside {}
print(f"Next year: {age + 1}")
print(f"Name uppercase: {name.upper()}")

# Format specifiers
print(f"Pi: {pi:.2f}")          # Pi: 3.14
print(f"Percentage: {0.85:.1%}") # Percentage: 85.0%
print(f"Number: {42:05d}")       # Number: 00042
print(f"Hex: {255:x}")          # Hex: ff
print(f"Binary: {10:b}")        # Binary: 1010

# Alignment
print(f"{'left':<10}|")    # left      |
print(f"{'right':>10}|")   #      right|
print(f"{'center':^10}|")  #   center  |
```

### .format() Method

```python
# Positional
print("{} is {} years old".format("Alice", 25))

# Indexed
print("{1} is {0} years old".format(25, "Alice"))

# Named
print("{name} is {age} years old".format(name="Alice", age=25))

# Format specifiers
print("{:.3f}".format(3.14159))  # 3.142
print("{:,}".format(1000000))    # 1,000,000
```

### % Formatting (Old Style)

```python
name = "Alice"
age = 25
print("Name: %s, Age: %d, GPA: %.2f" % (name, age, 3.856))
# Name: Alice, Age: 25, GPA: 3.86
```

---

## 5.5 Escape Characters

| Escape | Meaning | Example |
|--------|---------|---------|
| `\n` | Newline | `"Hello\nWorld"` |
| `\t` | Tab | `"Col1\tCol2"` |
| `\\` | Backslash | `"C:\\Users"` |
| `\'` | Single quote | `'It\'s fine'` |
| `\"` | Double quote | `"He said \"Hi\""` |
| `\0` | Null character | — |

```python
# Raw strings — ignore escape characters
path = r"C:\Users\name\folder"
print(path)  # C:\Users\name\folder (no \n interpretation)
```

---

## 5.6 Practice & Assessment

### MCQs

**Q1.** What is `"Python"[1:4]`?
- A) `"Pyt"`
- B) `"yth"`
- C) `"ytho"`
- D) `"Pyth"`

**Answer:** B — Characters at index 1, 2, 3.

---

**Q2.** What is `"hello" * 3`?
- A) `"hello3"`
- B) `"hellohellohello"`
- C) Error
- D) `"hello hello hello"`

**Answer:** B — String repetition.

---

**Q3.** What method removes leading/trailing whitespace?
- A) `remove()`
- B) `trim()`
- C) `strip()`
- D) `clean()`

**Answer:** C

---

### Coding Tasks

**Task 1:** Count vowels and consonants in a string.

```python
def count_vc(s):
    vowels = consonants = 0
    for char in s.lower():
        if char.isalpha():
            if char in "aeiou":
                vowels += 1
            else:
                consonants += 1
    return vowels, consonants

v, c = count_vc("Hello World")
print(f"Vowels: {v}, Consonants: {c}")  # Vowels: 3, Consonants: 7
```

**Task 2:** Check if a string is a palindrome.

```python
def is_palindrome(s):
    s = s.lower().replace(" ", "")
    return s == s[::-1]

print(is_palindrome("racecar"))     # True
print(is_palindrome("hello"))       # False
print(is_palindrome("A man a plan a canal Panama".replace(" ", "")))  # True
```

**Task 3:** Reverse each word in a sentence.

```python
def reverse_words(sentence):
    words = sentence.split()
    reversed_words = [word[::-1] for word in words]
    return " ".join(reversed_words)

print(reverse_words("Hello World Python"))  # olleH dlroW nohtyP
```

---

> **Next Topic:** [06 - Lists and Tuples](06-lists-tuples.md)
