# 08. File Handling

## Table of Contents
- [8.1 Introduction to File Handling](#81-introduction-to-file-handling)
- [8.2 Reading Files](#82-reading-files)
- [8.3 Writing Files](#83-writing-files)
- [8.4 Working with CSV Files](#84-working-with-csv-files)
- [8.5 Working with JSON Files](#85-working-with-json-files)
- [8.6 OS and Path Operations](#86-os-and-path-operations)
- [8.7 Practice & Assessment](#87-practice--assessment)

---

## 8.1 Introduction to File Handling

### File Modes

| Mode | Description | Creates? | Overwrites? |
|------|-------------|----------|-------------|
| `'r'` | Read (default) | No | No |
| `'w'` | Write | Yes | Yes! |
| `'a'` | Append | Yes | No |
| `'x'` | Exclusive create | Yes (error if exists) | No |
| `'r+'` | Read + Write | No | No |
| `'w+'` | Write + Read | Yes | Yes! |
| `'a+'` | Append + Read | Yes | No |
| `'b'` | Binary mode | — | — |

### File Operation Flow

```
┌─────────────────────────────────────────────────┐
│              FILE HANDLING FLOW                   │
│                                                 │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   │
│  │  OPEN    │──►│  READ/   │──►│  CLOSE   │   │
│  │  file    │   │  WRITE   │   │  file    │   │
│  └──────────┘   └──────────┘   └──────────┘   │
│                                                 │
│  Best Practice: Use 'with' statement            │
│  (auto-closes file even if error occurs)        │
└─────────────────────────────────────────────────┘
```

### Opening and Closing

```python
# Manual open/close (NOT recommended)
f = open("data.txt", "r")
content = f.read()
f.close()  # Must remember to close!

# Using 'with' statement (RECOMMENDED)
with open("data.txt", "r") as f:
    content = f.read()
# File auto-closed here — even if exception occurs!
```

---

## 8.2 Reading Files

### read() — Read Entire File

```python
with open("example.txt", "r") as f:
    content = f.read()
    print(content)

# Read specific number of characters
with open("example.txt", "r") as f:
    first_10 = f.read(10)  # First 10 characters
    print(first_10)
```

### readline() — Read One Line

```python
with open("example.txt", "r") as f:
    line1 = f.readline()  # First line
    line2 = f.readline()  # Second line
    print(line1.strip())  # strip() removes \n
    print(line2.strip())
```

### readlines() — Read All Lines as List

```python
with open("example.txt", "r") as f:
    lines = f.readlines()  # Returns list of lines
    print(lines)
    # ['line 1\n', 'line 2\n', 'line 3\n']

# Remove newlines
with open("example.txt", "r") as f:
    lines = [line.strip() for line in f.readlines()]
    print(lines)  # ['line 1', 'line 2', 'line 3']
```

### Iterating Over Lines (Best for Large Files)

```python
# Memory efficient — reads one line at a time
with open("example.txt", "r") as f:
    for line in f:
        print(line.strip())
```

---

## 8.3 Writing Files

### write() — Write String

```python
# 'w' mode — creates or OVERWRITES
with open("output.txt", "w") as f:
    f.write("Hello, World!\n")
    f.write("Python file handling.\n")

# 'a' mode — creates or APPENDS
with open("output.txt", "a") as f:
    f.write("This line is appended.\n")
```

### writelines() — Write List of Strings

```python
lines = ["Line 1\n", "Line 2\n", "Line 3\n"]
with open("output.txt", "w") as f:
    f.writelines(lines)
```

### Complete Example: Copy File

```python
# Copy file content
with open("source.txt", "r") as source:
    with open("destination.txt", "w") as dest:
        for line in source:
            dest.write(line)
print("File copied!")
```

---

## 8.4 Working with CSV Files

```python
import csv

# Writing CSV
data = [
    ["Name", "Age", "City"],
    ["Alice", 25, "NYC"],
    ["Bob", 30, "London"],
    ["Charlie", 28, "Paris"]
]

with open("people.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(data)

# Reading CSV
with open("people.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)
# Output:
# ['Name', 'Age', 'City']
# ['Alice', '25', 'NYC']
# ['Bob', '30', 'London']
# ['Charlie', '28', 'Paris']

# DictReader — read as dictionaries
with open("people.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(f"{row['Name']} is {row['Age']} from {row['City']}")
```

---

## 8.5 Working with JSON Files

```python
import json

# Python dict → JSON file (serialize)
data = {
    "name": "Alice",
    "age": 25,
    "skills": ["Python", "SQL", "ML"],
    "active": True
}

with open("data.json", "w") as f:
    json.dump(data, f, indent=4)

# JSON file → Python dict (deserialize)
with open("data.json", "r") as f:
    loaded = json.load(f)
    print(loaded["name"])    # Alice
    print(loaded["skills"])  # ['Python', 'SQL', 'ML']

# String conversion
json_string = json.dumps(data, indent=2)  # dict → JSON string
python_obj = json.loads(json_string)       # JSON string → dict
```

---

## 8.6 OS and Path Operations

```python
import os
from pathlib import Path

# Current directory
print(os.getcwd())

# List files
print(os.listdir("."))

# Check existence
print(os.path.exists("data.txt"))   # True/False
print(os.path.isfile("data.txt"))   # True if file
print(os.path.isdir("folder"))      # True if directory

# Create directory
os.makedirs("new_folder/sub_folder", exist_ok=True)

# Rename/Move
os.rename("old_name.txt", "new_name.txt")

# Delete
os.remove("file.txt")       # Delete file
os.rmdir("empty_folder")    # Delete empty directory

# File info
size = os.path.getsize("data.txt")  # Size in bytes
print(f"Size: {size} bytes")

# pathlib (Modern — Python 3.4+)
p = Path("data.txt")
print(p.exists())     # True/False
print(p.stem)         # "data" (filename without extension)
print(p.suffix)       # ".txt"
print(p.parent)       # "." (parent directory)

# Read/Write with pathlib
content = Path("data.txt").read_text()
Path("output.txt").write_text("Hello!")
```

---

## 8.7 Practice & Assessment

### MCQs

**Q1.** What mode opens a file for writing and creates it if it doesn't exist?
- A) `'r'`
- B) `'w'`
- C) `'x'`
- D) Both B and C

**Answer:** D — `'w'` creates (or overwrites), `'x'` creates (error if exists).

---

**Q2.** What does the `with` statement do for files?
- A) Opens file faster
- B) Automatically closes the file
- C) Encrypts the file
- D) Reads file faster

**Answer:** B — Ensures file is closed even if an exception occurs.

---

### Coding Tasks

**Task 1:** Count words, lines, and characters in a file.

```python
def file_stats(filename):
    with open(filename, "r") as f:
        content = f.read()
    
    lines = content.count("\n") + 1
    words = len(content.split())
    chars = len(content)
    
    return {"lines": lines, "words": words, "characters": chars}

# Create test file
with open("test.txt", "w") as f:
    f.write("Hello World\nPython is great\nFile handling is easy")

stats = file_stats("test.txt")
print(stats)  # {'lines': 3, 'words': 9, 'characters': 50}
```

**Task 2:** Find and replace text in a file.

```python
def find_replace(filename, old_text, new_text):
    with open(filename, "r") as f:
        content = f.read()
    
    content = content.replace(old_text, new_text)
    
    with open(filename, "w") as f:
        f.write(content)
    
    print(f"Replaced '{old_text}' with '{new_text}'")

find_replace("test.txt", "great", "awesome")
```

---

> **Next Topic:** [09 - Exception Handling](09-exception-handling.md)
