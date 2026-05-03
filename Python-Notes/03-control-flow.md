# 03. Control Flow (Conditions and Loops)

## Table of Contents
- [3.1 Conditional Statements](#31-conditional-statements)
- [3.2 Loops](#32-loops)
- [3.3 Loop Control Statements](#33-loop-control-statements)
- [3.4 Pattern Programs](#34-pattern-programs)
- [3.5 Practice & Assessment](#35-practice--assessment)

---

## 3.1 Conditional Statements

### if Statement

```
┌─────────────────────────────────────┐
│         FLOWCHART: if               │
│                                     │
│         ┌─────────┐                 │
│         │  START  │                 │
│         └────┬────┘                 │
│              │                      │
│         ┌────▼────┐                 │
│         │condition│                 │
│         └────┬────┘                 │
│         Yes/ │ \No                  │
│         /    │   \                  │
│   ┌────▼──┐ │  (skip)              │
│   │ code  │ │                      │
│   │ block │ │                      │
│   └───┬───┘ │                      │
│       │     │                      │
│       └──►──┘                      │
│              │                      │
│         ┌────▼────┐                 │
│         │   END   │                 │
│         └─────────┘                 │
└─────────────────────────────────────┘
```

```python
age = 18

if age >= 18:
    print("You can vote!")
    print("You are an adult.")
# If condition is False, nothing happens

# Output: You can vote!
#         You are an adult.
```

### if-else Statement

```python
number = -5

if number >= 0:
    print("Positive number")
else:
    print("Negative number")

# Output: Negative number
```

### if-elif-else (Multiple Conditions)

```
┌─────────────────────────────────────┐
│    FLOWCHART: if-elif-else          │
│                                     │
│    ┌───────────┐                    │
│    │condition 1│──Yes──► Block 1    │
│    └─────┬─────┘                    │
│          │No                        │
│    ┌─────▼─────┐                    │
│    │condition 2│──Yes──► Block 2    │
│    └─────┬─────┘                    │
│          │No                        │
│    ┌─────▼─────┐                    │
│    │condition 3│──Yes──► Block 3    │
│    └─────┬─────┘                    │
│          │No                        │
│    ┌─────▼─────┐                    │
│    │   else    │──────► Block 4     │
│    └───────────┘                    │
└─────────────────────────────────────┘
```

```python
marks = 75

if marks >= 90:
    grade = "A+"
elif marks >= 80:
    grade = "A"
elif marks >= 70:
    grade = "B"
elif marks >= 60:
    grade = "C"
elif marks >= 50:
    grade = "D"
else:
    grade = "F"

print(f"Marks: {marks}, Grade: {grade}")
# Output: Marks: 75, Grade: B
```

### Nested if

```python
num = 15

if num > 0:
    if num % 2 == 0:
        print("Positive Even")
    else:
        print("Positive Odd")
else:
    print("Negative or Zero")

# Output: Positive Odd
```

### Ternary Operator (One-line if-else)

```python
age = 20
status = "Adult" if age >= 18 else "Minor"
print(status)  # Adult

# Nested ternary
x = 0
result = "Positive" if x > 0 else ("Negative" if x < 0 else "Zero")
print(result)  # Zero
```

### match-case (Python 3.10+)

```python
command = "start"

match command:
    case "start":
        print("Starting...")
    case "stop":
        print("Stopping...")
    case "restart":
        print("Restarting...")
    case _:
        print("Unknown command")

# Output: Starting...
```

---

## 3.2 Loops

### for Loop

```
┌─────────────────────────────────────┐
│      FLOWCHART: for loop            │
│                                     │
│      ┌──────────┐                   │
│      │  START   │                   │
│      └────┬─────┘                   │
│           │                         │
│      ┌────▼────────────┐            │
│      │ More items in   │──No──► END │
│      │  sequence?      │            │
│      └────┬────────────┘            │
│           │Yes                      │
│      ┌────▼─────┐                   │
│      │  Get next │                  │
│      │  item     │                  │
│      └────┬─────┘                   │
│           │                         │
│      ┌────▼─────┐                   │
│      │ Execute  │                   │
│      │  body    │                   │
│      └────┬─────┘                   │
│           │                         │
│           └──────────── (loop back) │
└─────────────────────────────────────┘
```

```python
# Iterating over a list
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(fruit)
# Output:
# apple
# banana
# cherry

# Iterating over a string
for char in "Python":
    print(char, end=" ")
# Output: P y t h o n
```

### range() Function

```python
# range(stop) — 0 to stop-1
for i in range(5):
    print(i, end=" ")
# Output: 0 1 2 3 4

# range(start, stop) — start to stop-1
for i in range(2, 7):
    print(i, end=" ")
# Output: 2 3 4 5 6

# range(start, stop, step)
for i in range(0, 20, 5):
    print(i, end=" ")
# Output: 0 5 10 15

# Counting backwards
for i in range(10, 0, -2):
    print(i, end=" ")
# Output: 10 8 6 4 2
```

### while Loop

```
┌─────────────────────────────────────┐
│      FLOWCHART: while loop          │
│                                     │
│      ┌──────────┐                   │
│      │  START   │                   │
│      └────┬─────┘                   │
│           │                         │
│      ┌────▼────────┐               │
│ ┌───►│  condition  │──False──► END  │
│ │    └────┬────────┘               │
│ │         │True                     │
│ │    ┌────▼─────┐                   │
│ │    │ Execute  │                   │
│ │    │  body    │                   │
│ │    └────┬─────┘                   │
│ │         │                         │
│ └─────────┘                         │
└─────────────────────────────────────┘
```

```python
# Count from 1 to 5
count = 1
while count <= 5:
    print(count, end=" ")
    count += 1
# Output: 1 2 3 4 5

# Sum until user enters 0
total = 0
while True:
    num = int(input("Enter number (0 to stop): "))
    if num == 0:
        break
    total += num
print(f"Total = {total}")
```

### for-else and while-else

```python
# else executes when loop completes WITHOUT break
for i in range(2, 10):
    if i == 6:
        print("Found 6!")
        break
else:
    print("6 not found")  # Won't execute (break happened)

# Output: Found 6!

# When no break occurs
for i in [1, 3, 5, 7]:
    if i == 6:
        break
else:
    print("6 not in list")  # Executes!

# Output: 6 not in list
```

### Nested Loops

```python
# Multiplication table
for i in range(1, 4):
    for j in range(1, 4):
        print(f"{i}x{j}={i*j}", end="\t")
    print()  # New line after each row

# Output:
# 1x1=1   1x2=2   1x3=3
# 2x1=2   2x2=4   2x3=6
# 3x1=3   3x2=6   3x3=9
```

---

## 3.3 Loop Control Statements

| Statement | Purpose |
|-----------|---------|
| `break` | Exit loop immediately |
| `continue` | Skip current iteration, go to next |
| `pass` | Do nothing (placeholder) |

### break

```python
# Find first even number
numbers = [1, 3, 7, 8, 5, 2]
for num in numbers:
    if num % 2 == 0:
        print(f"First even: {num}")
        break
# Output: First even: 8
```

### continue

```python
# Print odd numbers only
for i in range(1, 11):
    if i % 2 == 0:
        continue  # Skip even numbers
    print(i, end=" ")
# Output: 1 3 5 7 9
```

### pass

```python
# Placeholder for future code
for i in range(5):
    if i == 3:
        pass  # TODO: handle this case later
    print(i, end=" ")
# Output: 0 1 2 3 4  (pass does nothing)
```

### Dry Run: Loop with break and continue

```python
for i in range(1, 8):
    if i == 3:
        continue
    if i == 6:
        break
    print(i, end=" ")
```

| Iteration | i | i==3? | i==6? | Action | Output |
|-----------|---|-------|-------|--------|--------|
| 1 | 1 | No | No | Print | 1 |
| 2 | 2 | No | No | Print | 2 |
| 3 | 3 | Yes | — | continue (skip) | — |
| 4 | 4 | No | No | Print | 4 |
| 5 | 5 | No | No | Print | 5 |
| 6 | 6 | No | Yes | break (exit) | — |

**Final Output:** `1 2 4 5`

---

## 3.4 Pattern Programs

### Right Triangle

```python
n = 5
for i in range(1, n + 1):
    print("* " * i)

# Output:
# *
# * *
# * * *
# * * * *
# * * * * *
```

### Number Triangle

```python
n = 5
for i in range(1, n + 1):
    for j in range(1, i + 1):
        print(j, end=" ")
    print()

# Output:
# 1
# 1 2
# 1 2 3
# 1 2 3 4
# 1 2 3 4 5
```

### Pyramid

```python
n = 5
for i in range(1, n + 1):
    spaces = " " * (n - i)
    stars = "* " * i
    print(spaces + stars)

# Output:
#     *
#    * *
#   * * *
#  * * * *
# * * * * *
```

### Inverted Triangle

```python
n = 5
for i in range(n, 0, -1):
    print("* " * i)

# Output:
# * * * * *
# * * * *
# * * *
# * *
# *
```

---

## 3.5 Practice & Assessment

### MCQs

**Q1.** What is the output?
```python
for i in range(3):
    print(i, end=" ")
```
- A) 1 2 3
- B) 0 1 2
- C) 0 1 2 3
- D) 1 2

**Answer:** B — `range(3)` gives 0, 1, 2.

---

**Q2.** How many times does this loop run?
```python
i = 10
while i > 0:
    i -= 3
```
- A) 3 times
- B) 4 times
- C) 10 times
- D) Infinite

**Answer:** B — i values: 10→7→4→1→-2 (4 iterations)

---

**Q3.** What is the output?
```python
for i in range(5):
    if i == 3:
        break
    print(i, end=" ")
```
- A) 0 1 2 3
- B) 0 1 2
- C) 0 1 2 4
- D) 1 2

**Answer:** B — break exits BEFORE printing 3.

---

### Coding Tasks

**Task 1:** Print all prime numbers between 1 and 50.

```python
for num in range(2, 51):
    is_prime = True
    for i in range(2, int(num**0.5) + 1):
        if num % i == 0:
            is_prime = False
            break
    if is_prime:
        print(num, end=" ")
# Output: 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
```

**Task 2:** FizzBuzz — Print 1 to 20. For multiples of 3 print "Fizz", multiples of 5 print "Buzz", both print "FizzBuzz".

```python
for i in range(1, 21):
    if i % 3 == 0 and i % 5 == 0:
        print("FizzBuzz")
    elif i % 3 == 0:
        print("Fizz")
    elif i % 5 == 0:
        print("Buzz")
    else:
        print(i)
```

**Task 3:** Print Fibonacci sequence up to n terms.

```python
n = 10
a, b = 0, 1
for _ in range(n):
    print(a, end=" ")
    a, b = b, a + b
# Output: 0 1 1 2 3 5 8 13 21 34
```

---

> **Next Topic:** [04 - Functions](04-functions.md)
