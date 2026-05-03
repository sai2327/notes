# 02. Variables, Data Types, and Operators

## Table of Contents
- [2.1 Variables](#21-variables)
- [2.2 Data Types](#22-data-types)
- [2.3 Type Conversion](#23-type-conversion)
- [2.4 Operators](#24-operators)
- [2.5 Input/Output](#25-inputoutput)
- [2.6 Practice & Assessment](#26-practice--assessment)

---

## 2.1 Variables

### Definition
A **variable** is a named container that stores data in memory. In Python, you don't need to declare the type — it's determined automatically.

### Rules for Variable Names
| Rule | Valid | Invalid |
|------|-------|---------|
| Start with letter or `_` | `name`, `_count` | `1name`, `@var` |
| Can contain letters, digits, `_` | `my_var2` | `my-var`, `my var` |
| Case sensitive | `Age` ≠ `age` | — |
| Cannot be keyword | `total` | `if`, `class`, `for` |

### Creating Variables

```python
# No type declaration needed!
name = "Alice"          # str
age = 25                # int
height = 5.6            # float
is_student = True       # bool

print(name)       # Alice
print(type(name)) # <class 'str'>
print(type(age))  # <class 'int'>
```

### Multiple Assignment

```python
# Assign same value to multiple variables
x = y = z = 0
print(x, y, z)  # 0 0 0

# Assign different values in one line
a, b, c = 10, 20, 30
print(a, b, c)  # 10 20 30

# Swap variables (Python magic!)
a, b = b, a
print(a, b)  # 20 10
```

### Variable Memory Model

```
┌──────────────────────────────────────────┐
│              MEMORY                        │
│                                          │
│   Variable       Value (Object)          │
│   ┌─────┐       ┌──────────┐            │
│   │  x  │──────►│   10     │ id: 140...│
│   └─────┘       └──────────┘            │
│                                          │
│   ┌─────┐       ┌──────────┐            │
│   │  y  │──────►│  "Hello" │ id: 139...│
│   └─────┘       └──────────┘            │
│                                          │
│   # After x = 20                         │
│   ┌─────┐       ┌──────────┐            │
│   │  x  │──────►│   20     │ (new obj) │
│   └─────┘       └──────────┘            │
│                  ┌──────────┐            │
│                  │   10     │ (garbage)  │
│                  └──────────┘            │
└──────────────────────────────────────────┘
```

> **Key Insight:** In Python, variables are **references** (labels) pointing to objects in memory. Reassignment creates a new object.

---

## 2.2 Data Types

### Python Data Types Overview

```
┌─────────────────────────────────────────────────────────┐
│                  PYTHON DATA TYPES                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Numeric          Sequence        Mapping               │
│  ├── int          ├── str         └── dict              │
│  ├── float        ├── list                              │
│  └── complex      └── tuple       Set                   │
│                                   ├── set               │
│  Boolean          Binary          └── frozenset         │
│  └── bool         ├── bytes                             │
│                   ├── bytearray   None                  │
│  None             └── memoryview  └── NoneType          │
│  └── NoneType                                           │
└─────────────────────────────────────────────────────────┘
```

### Numeric Types

```python
# Integer — whole numbers (unlimited size!)
x = 10
big = 99999999999999999999  # No overflow in Python!
print(type(x))  # <class 'int'>

# Float — decimal numbers
pi = 3.14159
scientific = 2.5e4  # 25000.0
print(type(pi))  # <class 'float'>

# Complex — real + imaginary
z = 3 + 4j
print(z.real)  # 3.0
print(z.imag)  # 4.0
print(type(z)) # <class 'complex'>
```

### Boolean Type

```python
is_active = True
is_empty = False
print(type(is_active))  # <class 'bool'>

# Booleans are actually integers!
print(True + True)   # 2
print(True * 10)     # 10
print(False + 5)     # 5

# Truthy and Falsy values
print(bool(0))       # False
print(bool(""))      # False
print(bool([]))      # False
print(bool(None))    # False
print(bool(1))       # True
print(bool("Hi"))    # True
print(bool([1,2]))   # True
```

### String Type

```python
# Strings — text data (immutable)
s1 = 'Hello'           # Single quotes
s2 = "World"           # Double quotes
s3 = '''Multi
line string'''          # Triple quotes
s4 = """Also multi
line"""

# f-strings (formatted — Python 3.6+)
name = "Alice"
age = 25
print(f"I am {name}, age {age}")  # I am Alice, age 25
```

### None Type

```python
# None — represents "nothing" or "no value"
result = None
print(result)        # None
print(type(result))  # <class 'NoneType'>

# Common use: function with no return
def greet():
    print("Hello")

x = greet()     # prints "Hello"
print(x)        # None (no return statement)
```

### Complete Data Types Table

| Type | Example | Mutable? | Ordered? |
|------|---------|----------|----------|
| `int` | `42` | ❌ | — |
| `float` | `3.14` | ❌ | — |
| `complex` | `3+4j` | ❌ | — |
| `bool` | `True` | ❌ | — |
| `str` | `"hello"` | ❌ | ✅ |
| `list` | `[1, 2, 3]` | ✅ | ✅ |
| `tuple` | `(1, 2, 3)` | ❌ | ✅ |
| `dict` | `{"a": 1}` | ✅ | ✅ (3.7+) |
| `set` | `{1, 2, 3}` | ✅ | ❌ |
| `frozenset` | `frozenset({1,2})` | ❌ | ❌ |
| `NoneType` | `None` | ❌ | — |

---

## 2.3 Type Conversion

### Implicit Conversion (Automatic)

```python
# Python automatically converts to avoid data loss
x = 10      # int
y = 3.5     # float
result = x + y
print(result)        # 13.5
print(type(result))  # <class 'float'>  ← int promoted to float
```

### Explicit Conversion (Casting)

```python
# int() — convert to integer
print(int(3.9))      # 3  (truncates, not rounds!)
print(int("42"))     # 42
print(int(True))     # 1

# float() — convert to float
print(float(10))     # 10.0
print(float("3.14")) # 3.14

# str() — convert to string
print(str(100))      # "100"
print(str(3.14))     # "3.14"
print(str(True))     # "True"

# bool() — convert to boolean
print(bool(0))       # False
print(bool(1))       # True
print(bool(""))      # False
print(bool("abc"))   # True

# list(), tuple(), set() — convert sequences
print(list("hello"))     # ['h', 'e', 'l', 'l', 'o']
print(tuple([1,2,3]))    # (1, 2, 3)
print(set([1,1,2,2,3]))  # {1, 2, 3}
```

### Common Conversion Errors

```python
# Cannot convert non-numeric string to int
# int("hello")  → ValueError: invalid literal for int()

# Cannot convert float string to int directly
# int("3.14")   → ValueError
# Fix: int(float("3.14"))  → 3
```

---

## 2.4 Operators

### Arithmetic Operators

| Operator | Name | Example | Result |
|----------|------|---------|--------|
| `+` | Addition | `10 + 3` | `13` |
| `-` | Subtraction | `10 - 3` | `7` |
| `*` | Multiplication | `10 * 3` | `30` |
| `/` | Division (float) | `10 / 3` | `3.333...` |
| `//` | Floor Division | `10 // 3` | `3` |
| `%` | Modulus | `10 % 3` | `1` |
| `**` | Power | `2 ** 10` | `1024` |

```python
# Division gotchas
print(10 / 2)    # 5.0  ← Always returns float!
print(10 // 2)   # 5    ← Returns int if both operands are int
print(-7 // 2)   # -4   ← Floors toward negative infinity!
print(-7 % 2)    # 1    ← Different from C/Java!
```

### Comparison Operators

| Operator | Meaning | Example | Result |
|----------|---------|---------|--------|
| `==` | Equal to | `5 == 5` | `True` |
| `!=` | Not equal | `5 != 3` | `True` |
| `>` | Greater than | `5 > 3` | `True` |
| `<` | Less than | `5 < 3` | `False` |
| `>=` | Greater or equal | `5 >= 5` | `True` |
| `<=` | Less or equal | `3 <= 5` | `True` |

```python
# Chained comparisons (Python special!)
x = 5
print(1 < x < 10)    # True  (same as: 1 < x and x < 10)
print(1 < x < 3)     # False
print(1 < x <= 5)    # True
```

### Logical Operators

| Operator | Meaning | Example | Result |
|----------|---------|---------|--------|
| `and` | Both True | `True and False` | `False` |
| `or` | At least one True | `True or False` | `True` |
| `not` | Negate | `not True` | `False` |

```python
# Short-circuit evaluation
x = 5
print(x > 0 and x < 10)   # True (both conditions met)
print(x > 10 or x < 20)   # True (second condition met)
print(not (x > 10))        # True

# Truthy/Falsy with logical operators
print("Hello" and "World")  # "World" (returns last truthy)
print("" and "World")       # "" (returns first falsy)
print("Hello" or "World")   # "Hello" (returns first truthy)
print("" or "World")        # "World" (returns first truthy)
print("" or 0 or None)      # None (all falsy, returns last)
```

### Assignment Operators

| Operator | Equivalent | Example |
|----------|-----------|---------|
| `=` | Assign | `x = 10` |
| `+=` | Add and assign | `x += 5` → `x = x + 5` |
| `-=` | Subtract and assign | `x -= 3` → `x = x - 3` |
| `*=` | Multiply and assign | `x *= 2` → `x = x * 2` |
| `/=` | Divide and assign | `x /= 4` → `x = x / 4` |
| `//=` | Floor divide and assign | `x //= 3` |
| `%=` | Modulus and assign | `x %= 2` |
| `**=` | Power and assign | `x **= 3` |

> ⚠️ Python does NOT have `++` or `--` operators. Use `x += 1` instead.

### Bitwise Operators

| Operator | Name | Example | Result |
|----------|------|---------|--------|
| `&` | AND | `5 & 3` | `1` |
| `\|` | OR | `5 \| 3` | `7` |
| `^` | XOR | `5 ^ 3` | `6` |
| `~` | NOT | `~5` | `-6` |
| `<<` | Left shift | `5 << 1` | `10` |
| `>>` | Right shift | `5 >> 1` | `2` |

```python
# Binary representation
# 5 = 101
# 3 = 011
# 5 & 3 = 001 = 1
# 5 | 3 = 111 = 7
# 5 ^ 3 = 110 = 6

print(bin(5))      # 0b101
print(bin(5 & 3))  # 0b1 (which is 1)
print(bin(5 | 3))  # 0b111 (which is 7)
```

### Identity and Membership Operators

```python
# Identity: is, is not (compare memory address)
a = [1, 2, 3]
b = [1, 2, 3]
c = a

print(a == b)    # True  (same content)
print(a is b)    # False (different objects!)
print(a is c)    # True  (same object)

# Membership: in, not in
fruits = ["apple", "banana", "cherry"]
print("apple" in fruits)      # True
print("grape" in fruits)      # False
print("grape" not in fruits)  # True

# Works with strings too
print("hell" in "hello")  # True
```

### Operator Precedence (Highest to Lowest)

| Priority | Operator | Description |
|----------|----------|-------------|
| 1 | `()` | Parentheses |
| 2 | `**` | Exponent |
| 3 | `~`, `+x`, `-x` | Unary |
| 4 | `*`, `/`, `//`, `%` | Multiplication/Division |
| 5 | `+`, `-` | Addition/Subtraction |
| 6 | `<<`, `>>` | Bitwise shifts |
| 7 | `&` | Bitwise AND |
| 8 | `^` | Bitwise XOR |
| 9 | `\|` | Bitwise OR |
| 10 | `==`, `!=`, `<`, `>`, `<=`, `>=`, `is`, `in` | Comparison |
| 11 | `not` | Logical NOT |
| 12 | `and` | Logical AND |
| 13 | `or` | Logical OR |

```python
# Precedence example
result = 2 + 3 * 4 ** 2
# Step 1: 4 ** 2 = 16
# Step 2: 3 * 16 = 48
# Step 3: 2 + 48 = 50
print(result)  # 50
```

---

## 2.5 Input/Output

### print() Function

```python
# Basic print
print("Hello")                    # Hello

# Multiple values (separated by space)
print("Age:", 25)                 # Age: 25

# Custom separator
print("A", "B", "C", sep="-")    # A-B-C

# Custom end (default is \n)
print("Hello", end=" ")
print("World")                    # Hello World (same line)

# Formatted output
name = "Alice"
score = 95.678

# f-string (recommended — Python 3.6+)
print(f"Name: {name}, Score: {score:.2f}")  # Name: Alice, Score: 95.68

# .format() method
print("Name: {}, Score: {:.2f}".format(name, score))

# % formatting (old style)
print("Name: %s, Score: %.2f" % (name, score))
```

### input() Function

```python
# input() always returns a STRING
name = input("Enter name: ")        # Returns str
age = int(input("Enter age: "))     # Convert to int
price = float(input("Enter price: "))  # Convert to float

# Multiple inputs on one line
a, b = input("Enter two numbers: ").split()
a, b = int(a), int(b)
print(f"Sum = {a + b}")

# Even shorter with map
x, y = map(int, input("Enter x y: ").split())
print(f"Product = {x * y}")
```

---

## 2.6 Practice & Assessment

### MCQs

**Q1.** What is the output of `type(5.0)`?
- A) `<class 'int'>`
- B) `<class 'float'>`
- C) `<class 'double'>`
- D) `<class 'number'>`

**Answer:** B

---

**Q2.** What is `10 // 3`?
- A) 3.33
- B) 3
- C) 4
- D) 3.0

**Answer:** B — Floor division returns integer when both operands are integers.

---

**Q3.** What is the output?
```python
x = "5"
y = 3
print(x * y)
```
- A) 15
- B) `555`
- C) Error
- D) `53`

**Answer:** B — String `*` int repeats the string.

---

**Q4.** Which is Falsy in Python?
- A) `"False"`
- B) `[0]`
- C) `0`
- D) `" "`

**Answer:** C — `0`, `""`, `[]`, `None`, `{}`, `set()` are Falsy.

---

### Coding Tasks

**Task 1:** Write a program to swap two numbers without a temporary variable.

```python
a = int(input("Enter a: "))
b = int(input("Enter b: "))
print(f"Before: a={a}, b={b}")
a, b = b, a
print(f"After: a={a}, b={b}")
```

**Task 2:** Write a program to calculate simple interest.
Formula: `SI = (P × R × T) / 100`

```python
p = float(input("Principal: "))
r = float(input("Rate: "))
t = float(input("Time (years): "))
si = (p * r * t) / 100
print(f"Simple Interest = {si}")
print(f"Total Amount = {p + si}")
```

---

> **Next Topic:** [03 - Control Flow](03-control-flow.md)
