# 01. Introduction to Python

## Table of Contents
- [1.1 What is Python?](#11-what-is-python)
- [1.2 History and Versions](#12-history-and-versions)
- [1.3 Features of Python](#13-features-of-python)
- [1.4 Python vs Other Languages](#14-python-vs-other-languages)
- [1.5 How Python Works (Execution Flow)](#15-how-python-works-execution-flow)
- [1.6 Installing Python](#16-installing-python)
- [1.7 First Python Program](#17-first-python-program)
- [1.8 Python IDEs and Editors](#18-python-ides-and-editors)
- [1.9 Python Applications](#19-python-applications)
- [1.10 Practice & Assessment](#110-practice--assessment)

---

## 1.1 What is Python?

### Definition
**Python** is a high-level, interpreted, general-purpose programming language created by **Guido van Rossum** in 1991. It emphasizes code readability and simplicity.

### Key Characteristics
- **Interpreted:** Code runs line by line (no compilation step needed)
- **Dynamically Typed:** No need to declare variable types
- **Object-Oriented:** Supports classes and objects
- **Open Source:** Free to use and distribute
- **Cross-Platform:** Runs on Windows, Linux, macOS

---

## 1.2 History and Versions

| Year | Version | Key Addition |
|------|---------|-------------|
| 1991 | Python 1.0 | First release |
| 2000 | Python 2.0 | List comprehensions, garbage collector |
| 2008 | Python 3.0 | Major redesign (not backward compatible) |
| 2020 | Python 3.9 | Dictionary merge operators |
| 2021 | Python 3.10 | Pattern matching (match-case) |
| 2022 | Python 3.11 | 10-60% faster, better errors |
| 2023 | Python 3.12 | Improved error messages, f-string improvements |

> ⚠️ **Important:** Python 2 is DEAD (end-of-life Jan 2020). Always use Python 3.

---

## 1.3 Features of Python

```
┌─────────────────────────────────────────────────────────┐
│                 PYTHON FEATURES                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐   │
│  │  Simple &   │  │ Interpreted │  │  Dynamically │   │
│  │  Readable   │  │  (line by   │  │    Typed     │   │
│  │  Syntax     │  │    line)    │  │  (no int x)  │   │
│  └─────────────┘  └─────────────┘  └──────────────┘   │
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐   │
│  │   Object    │  │   Large     │  │   Cross      │   │
│  │  Oriented   │  │  Standard   │  │  Platform    │   │
│  │  + Functional│  │  Library    │  │  Portable    │   │
│  └─────────────┘  └─────────────┘  └──────────────┘   │
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐   │
│  │  Open       │  │  Community  │  │  Extensible  │   │
│  │  Source     │  │  Support    │  │  (C/C++/Java)│   │
│  │  (Free)     │  │  (Huge)     │  │              │   │
│  └─────────────┘  └─────────────┘  └──────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 1.4 Python vs Other Languages

| Feature | Python | Java | C++ | JavaScript |
|---------|--------|------|-----|------------|
| **Typing** | Dynamic | Static | Static | Dynamic |
| **Syntax** | Very simple | Verbose | Complex | Moderate |
| **Compilation** | Interpreted | Compiled + JVM | Compiled | Interpreted |
| **Speed** | Slower | Fast | Fastest | Moderate |
| **Use Case** | AI/ML, Web, Scripting | Enterprise, Android | Systems, Games | Web Frontend/Backend |
| **Learning Curve** | Easiest | Moderate | Hard | Moderate |
| **Memory Mgmt** | Automatic (GC) | Automatic (GC) | Manual | Automatic (GC) |

### Syntax Comparison: Hello World

```python
# Python — 1 line
print("Hello, World!")
```

```java
// Java — 5 lines
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

```cpp
// C++ — 6 lines
#include <iostream>
using namespace std;
int main() {
    cout << "Hello, World!" << endl;
    return 0;
}
```

---

## 1.5 How Python Works (Execution Flow)

```
┌──────────────────────────────────────────────────────────┐
│              PYTHON EXECUTION FLOW                         │
│                                                          │
│  ┌──────────┐    ┌──────────┐    ┌──────────────────┐   │
│  │  Source  │    │  Byte    │    │   Python Virtual │   │
│  │  Code    │───►│  Code    │───►│   Machine (PVM)  │   │
│  │ (.py)    │    │ (.pyc)   │    │   Executes code  │   │
│  └──────────┘    └──────────┘    └──────────────────┘   │
│       │               │                    │             │
│  You write       Compiler             Interpreter        │
│  this            converts             runs bytecode      │
│                  automatically         line by line       │
└──────────────────────────────────────────────────────────┘
```

### Step-by-Step:
1. You write `hello.py` (source code)
2. Python compiler converts to bytecode (`hello.pyc` stored in `__pycache__/`)
3. PVM (Python Virtual Machine) interprets bytecode
4. Output displayed on screen

### Why is Python called "Interpreted"?
- The bytecode compilation happens **automatically** (invisible to user)
- Execution is **line by line** — errors found at runtime, not before
- No separate compilation step needed (unlike C/Java)

---

## 1.6 Installing Python

### Windows Installation
1. Go to [python.org](https://python.org)
2. Download latest Python 3.x
3. **✅ CHECK "Add Python to PATH"** during installation
4. Verify: Open terminal → `python --version`

### Verifying Installation

```bash
# Check version
python --version
# Output: Python 3.12.x

# Open interactive shell
python
>>> print("It works!")
It works!
>>> exit()
```

### pip (Package Manager)
```bash
# pip is included with Python 3.4+
pip --version
# Output: pip 23.x from ...

# Install a package
pip install numpy

# List installed packages
pip list
```

---

## 1.7 First Python Program

### Program: Hello World

```python
# This is a comment — ignored by Python
print("Hello, World!")
```

**Output:**
```
Hello, World!
```

### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 1 | `# This is a comment` | Starts with `#`, Python ignores it |
| 2 | `print("Hello, World!")` | `print()` is a built-in function that displays output |

### Program: User Input

```python
# Taking input from user
name = input("Enter your name: ")
print("Hello,", name, "! Welcome to Python.")
```

**Execution:**
```
Enter your name: Alice
Hello, Alice ! Welcome to Python.
```

### Step-by-Step Dry Run
```
Step 1: input() displays "Enter your name: " and waits
Step 2: User types "Alice" and presses Enter
Step 3: "Alice" is stored in variable 'name'
Step 4: print() displays "Hello," + "Alice" + "! Welcome to Python."
```

### Program: Basic Arithmetic

```python
a = 10
b = 3

print("Addition:", a + b)       # 13
print("Subtraction:", a - b)    # 7
print("Multiplication:", a * b) # 30
print("Division:", a / b)       # 3.3333...
print("Floor Division:", a // b) # 3
print("Modulus:", a % b)        # 1
print("Power:", a ** b)         # 1000
```

**Output:**
```
Addition: 13
Subtraction: 7
Multiplication: 30
Division: 3.3333333333333335
Floor Division: 3
Modulus: 1
Power: 1000
```

---

## 1.8 Python IDEs and Editors

| IDE/Editor | Best For | Features |
|-----------|----------|----------|
| **VS Code** | General development | Extensions, Git, Terminal |
| **PyCharm** | Professional Python | Debugging, Refactoring |
| **Jupyter Notebook** | Data Science, ML | Interactive, Visualization |
| **IDLE** | Beginners | Comes with Python |
| **Google Colab** | ML/DL (free GPU) | Cloud-based, no install |
| **Sublime Text** | Quick scripting | Lightweight, fast |

---

## 1.9 Python Applications

```
┌─────────────────────────────────────────────────────────┐
│            WHERE PYTHON IS USED                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  🌐 Web Development      → Django, Flask, FastAPI       │
│  🤖 AI / Machine Learning → TensorFlow, PyTorch, Sklearn│
│  📊 Data Science         → Pandas, NumPy, Matplotlib   │
│  🔧 Automation/Scripting → OS tasks, Web scraping      │
│  🎮 Game Development     → Pygame                      │
│  🔒 Cybersecurity        → Penetration testing tools   │
│  📱 Desktop Apps         → Tkinter, PyQt               │
│  ☁️ Cloud/DevOps         → AWS SDK, Ansible            │
│  🧬 Scientific Computing → SciPy, BioPython            │
│  💰 Finance              → Quantitative analysis       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Companies Using Python
| Company | Usage |
|---------|-------|
| Google | YouTube, Search algorithms |
| Netflix | Recommendation engine |
| Instagram | Backend (Django) |
| Spotify | Data analysis, ML |
| NASA | Scientific computing |
| Dropbox | Desktop client |

---

## 1.10 Practice & Assessment

### MCQs

**Q1.** Who created Python?
- A) Dennis Ritchie
- B) James Gosling
- C) Guido van Rossum
- D) Bjarne Stroustrup

**Answer:** C

---

**Q2.** Python is:
- A) Compiled language
- B) Interpreted language
- C) Assembly language
- D) Machine language

**Answer:** B

---

**Q3.** Which file extension does Python use?
- A) .java
- B) .py
- C) .cpp
- D) .pyt

**Answer:** B

---

**Q4.** What is the output of `print(type(10))`?
- A) int
- B) `<class 'int'>`
- C) integer
- D) number

**Answer:** B

---

### Coding Tasks

**Task 1:** Write a program that takes your name and age, then prints:
```
Hello [name], you will be [age+5] years old in 5 years.
```

**Solution:**
```python
name = input("Enter your name: ")
age = int(input("Enter your age: "))
future_age = age + 5
print(f"Hello {name}, you will be {future_age} years old in 5 years.")
```

---

**Task 2:** Write a program that converts temperature from Celsius to Fahrenheit.
Formula: `F = (C × 9/5) + 32`

**Solution:**
```python
celsius = float(input("Enter temperature in Celsius: "))
fahrenheit = (celsius * 9/5) + 32
print(f"{celsius}°C = {fahrenheit}°F")
```

---

### Common Mistakes for Beginners

| Mistake | Wrong | Correct |
|---------|-------|---------|
| Case sensitivity | `Print("Hi")` | `print("Hi")` |
| Indentation | No consistent spaces | Use 4 spaces consistently |
| String quotes | `print('Hello")` | `print('Hello')` or `print("Hello")` |
| Missing colon | `if x > 5` | `if x > 5:` |
| Integer input | `age = input()` then `age + 1` | `age = int(input())` |

---

> **Next Topic:** [02 - Variables, Data Types, and Operators](02-variables-datatypes-operators.md)
