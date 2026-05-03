# 09. Exception Handling

## Table of Contents
- [9.1 What are Exceptions?](#91-what-are-exceptions)
- [9.2 try-except-else-finally](#92-try-except-else-finally)
- [9.3 Common Exceptions](#93-common-exceptions)
- [9.4 Raising Exceptions](#94-raising-exceptions)
- [9.5 Custom Exceptions](#95-custom-exceptions)
- [9.6 Practice & Assessment](#96-practice--assessment)

---

## 9.1 What are Exceptions?

### Definition
An **exception** is an error that occurs during program execution, disrupting the normal flow.

```
┌─────────────────────────────────────────────────────┐
│  Exception Hierarchy (simplified)                    │
│                                                     │
│  BaseException                                      │
│   ├── SystemExit                                    │
│   ├── KeyboardInterrupt                             │
│   └── Exception                                     │
│        ├── ValueError                               │
│        ├── TypeError                                │
│        ├── KeyError                                 │
│        ├── IndexError                               │
│        ├── FileNotFoundError                        │
│        ├── ZeroDivisionError                        │
│        ├── AttributeError                           │
│        ├── ImportError                              │
│        ├── NameError                                │
│        ├── RuntimeError                             │
│        └── OSError                                  │
│             ├── FileNotFoundError                   │
│             ├── PermissionError                     │
│             └── FileExistsError                     │
└─────────────────────────────────────────────────────┘
```

### Syntax Error vs Exception
| Type | When | Example |
|------|------|---------|
| **SyntaxError** | Before execution (parsing) | `if x > 5` (missing `:`) |
| **Exception** | During execution (runtime) | `10 / 0` |

---

## 9.2 try-except-else-finally

### Flow Diagram

```
┌──────────────────────────────────────────────────────┐
│  try:                                                │
│      code that might fail                            │
│          │                                           │
│     ┌────┴────┐                                      │
│     │ Error?  │                                      │
│     └────┬────┘                                      │
│    No /     \ Yes                                    │
│      /       \                                       │
│  else:     except:                                   │
│  (runs if    (handles                                │
│  no error)    the error)                             │
│      \       /                                       │
│       \     /                                        │
│     finally:                                         │
│     (ALWAYS runs — cleanup)                          │
└──────────────────────────────────────────────────────┘
```

### Basic try-except

```python
try:
    num = int(input("Enter a number: "))
    result = 10 / num
    print(f"Result: {result}")
except ZeroDivisionError:
    print("Error: Cannot divide by zero!")
except ValueError:
    print("Error: Invalid number!")

# Input: 0 → Error: Cannot divide by zero!
# Input: abc → Error: Invalid number!
# Input: 5 → Result: 2.0
```

### try-except-else-finally

```python
try:
    f = open("data.txt", "r")
    content = f.read()
except FileNotFoundError:
    print("File not found!")
else:
    # Runs ONLY if no exception occurred
    print(f"File has {len(content)} characters")
finally:
    # ALWAYS runs (cleanup)
    print("Operation complete.")
```

### Multiple Exceptions

```python
try:
    data = [1, 2, 3]
    index = int(input("Index: "))
    print(data[index])
except (ValueError, IndexError) as e:
    print(f"Error: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")
```

### Accessing Exception Details

```python
try:
    x = 1 / 0
except ZeroDivisionError as e:
    print(f"Error type: {type(e).__name__}")  # ZeroDivisionError
    print(f"Error message: {e}")              # division by zero
```

---

## 9.3 Common Exceptions

| Exception | Cause | Example |
|-----------|-------|---------|
| `ValueError` | Wrong value type | `int("abc")` |
| `TypeError` | Wrong operation for type | `"2" + 2` |
| `ZeroDivisionError` | Division by zero | `10 / 0` |
| `IndexError` | List index out of range | `[1,2,3][5]` |
| `KeyError` | Dict key not found | `d["missing"]` |
| `FileNotFoundError` | File doesn't exist | `open("x.txt")` |
| `AttributeError` | Object has no attribute | `5.append(1)` |
| `NameError` | Variable not defined | `print(xyz)` |
| `ImportError` | Module not found | `import xyz` |
| `StopIteration` | Iterator exhausted | `next(empty_iter)` |
| `RecursionError` | Max recursion depth | Infinite recursion |
| `MemoryError` | Out of memory | Very large list |

---

## 9.4 Raising Exceptions

```python
# raise — manually trigger an exception
def set_age(age):
    if age < 0:
        raise ValueError("Age cannot be negative!")
    if age > 150:
        raise ValueError("Age seems unrealistic!")
    return age

try:
    set_age(-5)
except ValueError as e:
    print(e)  # Age cannot be negative!

# Re-raising exceptions
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Logging error...")
    raise  # Re-raise the same exception
```

### assert — Debug Assertions

```python
# assert condition, "error message"
def calculate_average(numbers):
    assert len(numbers) > 0, "List cannot be empty!"
    return sum(numbers) / len(numbers)

print(calculate_average([10, 20, 30]))  # 20.0
# calculate_average([])  → AssertionError: List cannot be empty!
```

> ⚠️ `assert` statements are removed when Python runs with `-O` (optimize) flag. Don't use for input validation!

---

## 9.5 Custom Exceptions

```python
# Define custom exception classes
class InsufficientFundsError(Exception):
    def __init__(self, balance, amount):
        self.balance = balance
        self.amount = amount
        super().__init__(
            f"Cannot withdraw ${amount}. Balance: ${balance}"
        )

class InvalidAccountError(Exception):
    pass

# Using custom exceptions
class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance
    
    def withdraw(self, amount):
        if amount <= 0:
            raise ValueError("Amount must be positive")
        if amount > self.balance:
            raise InsufficientFundsError(self.balance, amount)
        self.balance -= amount
        return self.balance

# Usage
account = BankAccount("Alice", 100)

try:
    account.withdraw(150)
except InsufficientFundsError as e:
    print(e)  # Cannot withdraw $150. Balance: $100
    print(f"Short by: ${e.amount - e.balance}")  # Short by: $50
```

---

## 9.6 Practice & Assessment

### MCQs

**Q1.** Which block always executes?
- A) try
- B) except
- C) else
- D) finally

**Answer:** D — `finally` always runs regardless of exceptions.

---

**Q2.** What is the output?
```python
try:
    print("A")
    x = 1 / 0
    print("B")
except:
    print("C")
finally:
    print("D")
```
- A) A B C D
- B) A C D
- C) A D
- D) C D

**Answer:** B — "A" prints, error occurs (skips "B"), "C" prints in except, "D" always prints.

---

### Coding Task

**Task:** Write a safe division function with proper exception handling.

```python
def safe_divide(a, b):
    try:
        result = a / b
    except ZeroDivisionError:
        return "Error: Division by zero"
    except TypeError:
        return "Error: Invalid types"
    else:
        return round(result, 4)

print(safe_divide(10, 3))    # 3.3333
print(safe_divide(10, 0))    # Error: Division by zero
print(safe_divide("10", 2))  # Error: Invalid types
```

---

> **Next Topic:** [10 - OOP Basics](10-oop-basics.md)
