# 19. Bash Scripting Basics

## Table of Contents
- [19.1 Script Structure](#191-script-structure)
- [19.2 Variables](#192-variables)
- [19.3 Input and Output](#193-input-and-output)
- [19.4 Conditionals (if/elif/else)](#194-conditionals-ifelifelse)
- [19.5 Case Statement](#195-case-statement)
- [19.6 Loops](#196-loops)
- [19.7 Functions](#197-functions)
- [19.8 Exit Status and Error Handling](#198-exit-status-and-error-handling)
- [19.9 Practical Scripts](#199-practical-scripts)
- [19.10 Practice & Assessment](#1910-practice--assessment)

---

## 19.1 Script Structure

```bash
#!/bin/bash
# ↑ Shebang line — tells OS to use bash interpreter

# This is a comment
# Script: greeting.sh
# Purpose: Demonstrate basic script structure

echo "Hello, World!"
echo "Today is $(date)"

# Exit with status 0 (success)
exit 0
```

### Running a Script

```bash
# Method 1: Make executable and run
chmod +x script.sh
./script.sh

# Method 2: Call with bash explicitly
bash script.sh

# Method 3: Source (runs in current shell)
source script.sh
# or
. script.sh
```

---

## 19.2 Variables

### Declaring Variables

```bash
#!/bin/bash
# NO spaces around = sign!

name="Alice"            # String
age=25                  # Number (still stored as string)
greeting="Hello, $name" # Variable expansion

echo $name              # Alice
echo "$greeting"        # Hello, Alice
echo "Age: ${age}"      # Age: 25 (braces for clarity)
```

### Common Mistake

```bash
# WRONG — spaces around =
name = "Alice"          # Error: command not found

# CORRECT
name="Alice"
```

### Variable Types

```bash
# Read-only variable (constant)
readonly PI=3.14159
PI=3.14              # Error: PI is read-only

# Unset (delete) variable
temp="value"
unset temp
echo "$temp"         # (empty)
```

### Special Variables

| Variable | Meaning |
|----------|---------|
| `$0` | Script name |
| `$1, $2, ...` | Positional parameters (arguments) |
| `$#` | Number of arguments |
| `$@` | All arguments (as separate words) |
| `$*` | All arguments (as single string) |
| `$?` | Exit status of last command |
| `$$` | PID of current script |
| `$!` | PID of last background process |

```bash
#!/bin/bash
# save as: args.sh
echo "Script name: $0"
echo "First arg: $1"
echo "Second arg: $2"
echo "Total args: $#"
echo "All args: $@"

# Run: ./args.sh hello world
# Output:
# Script name: ./args.sh
# First arg: hello
# Second arg: world
# Total args: 2
# All args: hello world
```

### Quoting

```bash
name="Alice"

echo "$name"    # Alice         (double quotes: variables expanded)
echo '$name'    # $name         (single quotes: literal, no expansion)
echo `date`     # Mon Jan 15... (backticks: command substitution — old style)
echo $(date)    # Mon Jan 15... (preferred command substitution)
```

---

## 19.3 Input and Output

```bash
#!/bin/bash
# Read user input
echo -n "Enter your name: "
read username
echo "Hello, $username!"

# Read with prompt (built-in)
read -p "Enter age: " age
echo "You are $age years old"

# Silent input (for passwords)
read -sp "Enter password: " password
echo    # Newline after silent input
echo "Password length: ${#password}"

# Read multiple values
read -p "Enter first and last name: " first last
echo "First: $first, Last: $last"
```

---

## 19.4 Conditionals (if/elif/else)

### Syntax

```bash
if [ condition ]; then
    # commands if true
elif [ condition2 ]; then
    # commands if condition2 true
else
    # commands if all false
fi
```

### String Comparisons

```bash
str1="hello"
str2="world"

if [ "$str1" = "$str2" ]; then     # Equal
    echo "Same"
elif [ "$str1" != "$str2" ]; then  # Not equal
    echo "Different"
fi

# Check if string is empty
if [ -z "$var" ]; then             # -z = zero length
    echo "Variable is empty"
fi

# Check if string is NOT empty
if [ -n "$var" ]; then             # -n = non-zero length
    echo "Variable has value: $var"
fi
```

### Numeric Comparisons

```bash
a=10
b=20

if [ $a -eq $b ]; then echo "Equal"; fi
if [ $a -ne $b ]; then echo "Not equal"; fi
if [ $a -lt $b ]; then echo "a < b"; fi
if [ $a -le $b ]; then echo "a <= b"; fi
if [ $a -gt $b ]; then echo "a > b"; fi
if [ $a -ge $b ]; then echo "a >= b"; fi

# With (( )) — arithmetic context (can use < > == directly)
if (( a < b )); then
    echo "$a is less than $b"
fi
```

### File Tests

```bash
file="/etc/passwd"

if [ -e "$file" ]; then echo "Exists"; fi
if [ -f "$file" ]; then echo "Is regular file"; fi
if [ -d "$file" ]; then echo "Is directory"; fi
if [ -r "$file" ]; then echo "Is readable"; fi
if [ -w "$file" ]; then echo "Is writable"; fi
if [ -x "$file" ]; then echo "Is executable"; fi
if [ -s "$file" ]; then echo "File is not empty"; fi
```

### Logical Operators

```bash
# AND
if [ $age -ge 18 ] && [ $age -le 65 ]; then
    echo "Working age"
fi

# OR
if [ "$day" = "Saturday" ] || [ "$day" = "Sunday" ]; then
    echo "Weekend!"
fi

# NOT
if [ ! -f "config.txt" ]; then
    echo "Config file missing!"
fi
```

### [[ ]] — Extended Test (preferred in bash)

```bash
# Supports pattern matching and regex
if [[ "$name" == A* ]]; then
    echo "Name starts with A"
fi

# Regex matching
if [[ "$email" =~ ^[a-z]+@[a-z]+\.[a-z]+$ ]]; then
    echo "Valid email format"
fi
```

---

## 19.5 Case Statement

```bash
#!/bin/bash
read -p "Enter fruit: " fruit

case $fruit in
    apple|Apple)
        echo "Red fruit"
        ;;
    banana|Banana)
        echo "Yellow fruit"
        ;;
    grape)
        echo "Purple fruit"
        ;;
    *)                          # Default case
        echo "Unknown fruit"
        ;;
esac
```

### Practical Example

```bash
#!/bin/bash
# Service control script
case "$1" in
    start)
        echo "Starting service..."
        ;;
    stop)
        echo "Stopping service..."
        ;;
    restart)
        echo "Restarting service..."
        ;;
    status)
        echo "Checking status..."
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
```

---

## 19.6 Loops

### for Loop

```bash
# Iterate over list
for name in Alice Bob Charlie; do
    echo "Hello, $name"
done

# Iterate over range
for i in {1..5}; do
    echo "Number: $i"
done

# C-style for loop
for ((i=0; i<10; i++)); do
    echo $i
done

# Iterate over files
for file in *.txt; do
    echo "Processing: $file"
    wc -l "$file"
done

# Iterate over command output
for user in $(cut -d: -f1 /etc/passwd); do
    echo "User: $user"
done
```

### while Loop

```bash
# Basic while
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Read file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < input.txt

# Infinite loop with break
while true; do
    read -p "Enter (q to quit): " input
    if [ "$input" = "q" ]; then
        break
    fi
    echo "You entered: $input"
done
```

### until Loop

```bash
# Run UNTIL condition is true (opposite of while)
count=1
until [ $count -gt 5 ]; do
    echo "Count: $count"
    ((count++))
done
```

### Loop Control

```bash
# break — exit loop entirely
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        break
    fi
    echo $i    # Prints 1 2 3 4
done

# continue — skip current iteration
for i in {1..5}; do
    if [ $i -eq 3 ]; then
        continue
    fi
    echo $i    # Prints 1 2 4 5
done
```

---

## 19.7 Functions

```bash
#!/bin/bash

# Define function
greet() {
    echo "Hello, $1!"
}

# Call function
greet "Alice"      # Hello, Alice!
greet "Bob"        # Hello, Bob!

# Function with return value
add() {
    local result=$(( $1 + $2 ))    # local variable
    echo $result                    # Return via echo
}

# Capture function output
sum=$(add 5 3)
echo "Sum: $sum"    # Sum: 8

# Function with return code
is_even() {
    if (( $1 % 2 == 0 )); then
        return 0    # Success (true)
    else
        return 1    # Failure (false)
    fi
}

if is_even 4; then
    echo "4 is even"
fi
```

### Local vs Global Variables

```bash
#!/bin/bash
global_var="I'm global"

my_function() {
    local local_var="I'm local"
    global_var="Modified inside function"
    echo "$local_var"
}

my_function
echo "$global_var"   # Modified inside function
echo "$local_var"    # (empty — local to function)
```

---

## 19.8 Exit Status and Error Handling

```bash
# Every command returns exit status
# 0 = success, non-zero = failure

ls /etc/passwd
echo $?              # 0 (success)

ls /nonexistent
echo $?              # 2 (error)

# Use in conditionals
if grep -q "root" /etc/passwd; then
    echo "root user exists"
fi

# set -e: Exit immediately on error
#!/bin/bash
set -e               # Script stops if any command fails

# set -u: Error on undefined variables
set -u               # Error if using unset variable

# set -o pipefail: Pipe failure detection
set -o pipefail      # Pipe returns failure if ANY command fails

# Best practice: combine all three
#!/bin/bash
set -euo pipefail

# Trap errors
trap 'echo "Error on line $LINENO"; exit 1' ERR
```

---

## 19.9 Practical Scripts

### Script 1: Backup Script

```bash
#!/bin/bash
set -euo pipefail

BACKUP_DIR="/backup"
SOURCE="/home/user/documents"
DATE=$(date +%Y-%m-%d)
FILENAME="backup_${DATE}.tar.gz"

echo "Starting backup..."
tar -czf "${BACKUP_DIR}/${FILENAME}" "$SOURCE"
echo "Backup complete: ${FILENAME}"

# Delete backups older than 30 days
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +30 -delete
echo "Old backups cleaned."
```

### Script 2: System Monitor

```bash
#!/bin/bash
echo "===== System Report ====="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"
echo ""
echo "--- Memory ---"
free -h | grep Mem
echo ""
echo "--- Disk ---"
df -h / | tail -1
echo ""
echo "--- Top 5 CPU Processes ---"
ps aux --sort=-%cpu | head -6
```

---

## 19.10 Practice & Assessment

### MCQs

**Q1.** What does `$?` contain?
- A) Current PID
- B) Script name
- C) Exit status of last command
- D) Number of arguments

**Answer:** C

---

**Q2.** `[ -d "/tmp" ]` tests if:
- A) /tmp exists as a file
- B) /tmp is a directory
- C) /tmp is readable
- D) /tmp is empty

**Answer:** B

---

**Q3.** In `for i in {1..5}`, the loop runs:
- A) 4 times
- B) 5 times
- C) 6 times
- D) Infinite

**Answer:** B (1, 2, 3, 4, 5)

---

### Hands-On

**Task:** Write a script that:
1. Takes a directory as argument
2. Checks if it exists
3. If yes, counts files inside
4. If no, creates it

```bash
#!/bin/bash
dir="$1"

if [ -z "$dir" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ -d "$dir" ]; then
    count=$(ls -1 "$dir" | wc -l)
    echo "Directory exists. Files: $count"
else
    mkdir -p "$dir"
    echo "Directory created: $dir"
fi
```

---

> **Next Topic:** [20 - Advanced Shell Topics](20-advanced-shell-topics.md)
