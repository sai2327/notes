# 20. Advanced Shell Topics

## Table of Contents
- [20.1 Command Substitution](#201-command-substitution)
- [20.2 Arithmetic Operations](#202-arithmetic-operations)
- [20.3 Arrays](#203-arrays)
- [20.4 sed — Stream Editor](#204-sed--stream-editor)
- [20.5 awk — Text Processing](#205-awk--text-processing)
- [20.6 Process Substitution](#206-process-substitution)
- [20.7 Regular Expressions in Bash](#207-regular-expressions-in-bash)
- [20.8 Practice & Assessment](#208-practice--assessment)

---

## 20.1 Command Substitution

```bash
# Modern syntax: $(command)
current_date=$(date +%Y-%m-%d)
echo "Today: $current_date"

# Old syntax: `command` (backticks) — avoid, harder to read/nest
files=`ls *.txt`

# Nesting (only works cleanly with $())
echo "Lines: $(wc -l $(find . -name '*.log'))"

# Common uses
username=$(whoami)
ip_address=$(hostname -I | awk '{print $1}')
file_count=$(ls | wc -l)
memory_usage=$(free -m | awk '/Mem:/ {print $3}')
```

---

## 20.2 Arithmetic Operations

```bash
# (( )) — arithmetic evaluation
a=10; b=3

echo $(( a + b ))     # 13
echo $(( a - b ))     # 7
echo $(( a * b ))     # 30
echo $(( a / b ))     # 3 (integer division!)
echo $(( a % b ))     # 1 (modulo)
echo $(( a ** 2 ))    # 100 (exponent)

# Increment/decrement
((a++))               # a = 11
((a--))               # a = 10
((a += 5))            # a = 15

# For floating point, use bc
echo "scale=2; 10 / 3" | bc       # 3.33
echo "scale=4; sqrt(2)" | bc -l   # 1.4142

# let command
let "x = 5 + 3"
echo $x               # 8
```

---

## 20.3 Arrays

```bash
# Declare array
fruits=("apple" "banana" "cherry" "date")

# Access elements (0-indexed)
echo ${fruits[0]}      # apple
echo ${fruits[2]}      # cherry

# All elements
echo ${fruits[@]}      # apple banana cherry date

# Array length
echo ${#fruits[@]}     # 4

# Add element
fruits+=("elderberry")

# Loop over array
for fruit in "${fruits[@]}"; do
    echo "Fruit: $fruit"
done

# Slice
echo ${fruits[@]:1:2}  # banana cherry (start at 1, take 2)

# Delete element
unset fruits[1]

# Associative array (dictionary/hashmap)
declare -A colors
colors[red]="#FF0000"
colors[green]="#00FF00"
colors[blue]="#0000FF"

echo ${colors[red]}    # #FF0000

# Loop associative array
for key in "${!colors[@]}"; do
    echo "$key = ${colors[$key]}"
done
```

---

## 20.4 sed — Stream Editor

### Definition
**sed** performs text transformations on input streams (files or piped text) — find and replace, delete lines, insert text.

### Substitution (Most Common)

```bash
# Replace first occurrence on each line
sed 's/old/new/' file.txt

# Replace ALL occurrences on each line (global)
sed 's/old/new/g' file.txt

# Case-insensitive replacement
sed 's/hello/Hi/gI' file.txt

# Edit file in-place
sed -i 's/old/new/g' file.txt

# With backup before modifying
sed -i.bak 's/old/new/g' file.txt

# Replace on specific line
sed '3s/old/new/' file.txt          # Only line 3

# Replace in range
sed '2,5s/old/new/g' file.txt       # Lines 2 to 5
```

### Delete Lines

```bash
# Delete specific line
sed '5d' file.txt              # Delete line 5

# Delete range
sed '2,4d' file.txt            # Delete lines 2-4

# Delete lines matching pattern
sed '/^#/d' file.txt           # Delete comment lines
sed '/^$/d' file.txt           # Delete empty lines

# Delete from pattern to end
sed '/END/,$d' file.txt
```

### Insert and Append

```bash
# Insert BEFORE line 3
sed '3i\New line inserted' file.txt

# Append AFTER line 3
sed '3a\New line appended' file.txt
```

### Practical Examples

```bash
# Remove leading whitespace
sed 's/^[[:space:]]*//' file.txt

# Remove trailing whitespace
sed 's/[[:space:]]*$//' file.txt

# Add line number prefix
sed '=' file.txt | sed 'N;s/\n/\t/'

# Replace between delimiters (useful for paths)
sed 's|/old/path|/new/path|g' file.txt

# Multiple operations
sed -e 's/foo/bar/g' -e 's/baz/qux/g' file.txt
```

---

## 20.5 awk — Text Processing

### Definition
**awk** is a powerful text processing language. It processes text line by line, splitting each line into fields.

### Basic Syntax

```bash
awk 'pattern { action }' file
```

### Field Access

```bash
# Default field separator: whitespace
# $0 = entire line, $1 = first field, $2 = second, etc.

$ echo "Alice 25 Engineer" | awk '{print $1}'
Alice

$ echo "Alice 25 Engineer" | awk '{print $1, $3}'
Alice Engineer

# NR = line number, NF = number of fields
awk '{print NR, $0}' file.txt         # Add line numbers
awk '{print NF}' file.txt             # Fields per line
awk '{print $NF}' file.txt            # Last field
```

### Custom Field Separator

```bash
# -F sets delimiter
awk -F: '{print $1, $7}' /etc/passwd
# Output: root /bin/bash
#         daemon /usr/sbin/nologin
#         ...

# Comma-separated
echo "Alice,25,NYC" | awk -F, '{print $1, $3}'
# Output: Alice NYC
```

### Patterns and Conditions

```bash
# Print lines matching pattern
awk '/error/' log.txt

# Print lines where field meets condition
awk '$3 > 100' data.txt              # 3rd field > 100
awk '$1 == "Alice"' data.txt         # 1st field is "Alice"
awk 'NR >= 5 && NR <= 10' file.txt   # Lines 5-10

# BEGIN and END blocks
awk 'BEGIN {print "Header"} {print $0} END {print "Footer"}' file.txt
```

### Calculations

```bash
# Sum a column
awk '{sum += $2} END {print "Total:", sum}' data.txt

# Average
awk '{sum += $3; count++} END {print "Average:", sum/count}' data.txt

# Max value
awk 'BEGIN {max=0} $2 > max {max=$2} END {print "Max:", max}' data.txt
```

### Formatting Output

```bash
# printf for formatted output
awk '{printf "%-10s %5d\n", $1, $2}' data.txt

# Output:
# Alice          25
# Bob            30
# Charlie        22
```

### Practical Examples

```bash
# Disk usage report (human readable)
df -h | awk 'NR>1 {print $5, $6}'

# Find users with bash shell
awk -F: '$7 ~ /bash/ {print $1}' /etc/passwd

# Sum file sizes in directory
ls -l | awk 'NR>1 {sum+=$5} END {print "Total bytes:", sum}'

# Extract IP addresses from log
awk '{print $1}' /var/log/apache2/access.log | sort | uniq -c | sort -rn | head
```

---

## 20.6 Process Substitution

```bash
# <(command) — treat command output as a file
# Useful when command expects filename input

# Compare output of two commands
diff <(ls dir1) <(ls dir2)

# Compare sorted vs unsorted
diff <(sort file1.txt) <(sort file2.txt)

# Feed multiple inputs to a command
paste <(cut -f1 file.txt) <(cut -f3 file.txt)

# >(command) — treat as output file
tee >(grep error > errors.txt) >(grep warning > warnings.txt) > /dev/null
```

---

## 20.7 Regular Expressions in Bash

### Common Patterns

| Pattern | Meaning | Example |
|---------|---------|---------|
| `.` | Any single character | `a.c` → abc, axc |
| `*` | Zero or more of previous | `ab*c` → ac, abc, abbc |
| `+` | One or more (extended) | `ab+c` → abc, abbc |
| `?` | Zero or one (extended) | `colou?r` → color, colour |
| `^` | Start of line | `^Hello` |
| `$` | End of line | `world$` |
| `[abc]` | Any char in set | `[aeiou]` → vowels |
| `[^abc]` | Any char NOT in set | `[^0-9]` → non-digit |
| `\d` | Digit (some tools) | `\d+` → one or more digits |
| `{n}` | Exactly n times | `a{3}` → aaa |
| `{n,m}` | Between n and m times | `a{2,4}` → aa, aaa, aaaa |

### Using in Scripts

```bash
#!/bin/bash
email="$1"

# Validate email format
if [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    echo "Valid email"
else
    echo "Invalid email"
fi

# Validate IP address (basic)
ip="$1"
if [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "Valid IP format"
fi
```

---

## 20.8 Practice & Assessment

### MCQs

**Q1.** `sed 's/foo/bar/g' file.txt` does:
- A) Replaces first "foo" with "bar"
- B) Replaces all "foo" with "bar" on every line
- C) Deletes all "foo"
- D) Appends "bar" after "foo"

**Answer:** B (g = global replacement)

---

**Q2.** In awk, `$3` refers to:
- A) The 3rd line
- B) The 3rd character
- C) The 3rd field (column)
- D) Variable number 3

**Answer:** C

---

**Q3.** `diff <(ls dir1) <(ls dir2)` uses:
- A) Input redirection
- B) Process substitution
- C) Command substitution
- D) Pipe

**Answer:** B

---

### Hands-On

**Task:** Using awk, extract usernames and shells from `/etc/passwd` for users with UID ≥ 1000:

```bash
awk -F: '$3 >= 1000 {print $1, $7}' /etc/passwd
```

**Task:** Using sed, replace all IP addresses in a log file with "REDACTED":

```bash
sed -E 's/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/REDACTED/g' access.log
```

---

> **Next Topic:** [21 - Cheat Sheet Quick Reference](21-cheat-sheet-quick-reference.md)
