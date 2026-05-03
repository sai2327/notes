# 13. Searching and Filtering

## Table of Contents
- [13.1 grep — Search Text Patterns](#131-grep--search-text-patterns)
- [13.2 find — Search Files](#132-find--search-files)
- [13.3 sort — Sort Lines](#133-sort--sort-lines)
- [13.4 uniq — Remove Duplicates](#134-uniq--remove-duplicates)
- [13.5 cut — Extract Columns](#135-cut--extract-columns)
- [13.6 Combining Commands (Pipes)](#136-combining-commands-pipes)
- [13.7 Practice & Assessment](#137-practice--assessment)

---

## 13.1 grep — Search Text Patterns

### Description
**grep** searches for patterns (text or regex) in files and prints matching lines.

### Syntax
```bash
grep [options] "pattern" file(s)
```

### Key Options

| Flag | Purpose | Example |
|------|---------|---------|
| `-i` | Case insensitive | `grep -i "error" log.txt` |
| `-n` | Show line numbers | `grep -n "TODO" code.py` |
| `-c` | Count matches | `grep -c "failed" auth.log` |
| `-r` | Recursive (search directories) | `grep -r "password" /etc/` |
| `-v` | Invert (show NON-matching lines) | `grep -v "#" config.txt` |
| `-l` | Show only filenames with matches | `grep -rl "bug" src/` |
| `-w` | Match whole word only | `grep -w "the" text.txt` |
| `-E` | Extended regex (egrep) | `grep -E "error|warning" log` |
| `-o` | Show only matching part | `grep -o "[0-9]*" data.txt` |
| `-A n` | Show n lines AFTER match | `grep -A 3 "error" log.txt` |
| `-B n` | Show n lines BEFORE match | `grep -B 2 "error" log.txt` |

### Examples

```bash
# Search for "error" in a file
$ grep "error" /var/log/syslog
Jan 15 10:23:15 server kernel: disk error on sda
Jan 15 10:25:30 server apache: error processing request

# Case insensitive search
$ grep -i "ERROR" /var/log/syslog

# Show line numbers
$ grep -n "def " functions.py
3:def calculate_sum(a, b):
15:def validate_input(data):
28:def main():

# Count occurrences
$ grep -c "Failed password" /var/log/auth.log
47

# Search recursively in directory
$ grep -rn "TODO" /home/john/project/
src/main.py:12:# TODO: fix this function
src/utils.py:5:# TODO: add error handling

# Invert match (show lines WITHOUT "comment")
$ grep -v "^#" /etc/ssh/sshd_config
# Shows config without comment lines

# Regex: lines starting with numbers
$ grep "^[0-9]" data.txt

# Regex: email addresses
$ grep -E "[a-zA-Z0-9.]+@[a-zA-Z]+\.[a-z]+" contacts.txt
```

### Common Regex Patterns with grep

| Pattern | Meaning | Example |
|---------|---------|---------|
| `^text` | Line starts with "text" | `grep "^Error" log` |
| `text$` | Line ends with "text" | `grep "done$" log` |
| `.` | Any single character | `grep "h.t" file` (hat, hit, hot) |
| `*` | Zero or more of previous | `grep "go*d" file` (gd, god, good) |
| `[abc]` | Any one of a, b, c | `grep "[Ee]rror" log` |
| `[0-9]` | Any digit | `grep "[0-9]" data` |
| `\b` | Word boundary | `grep "\berror\b" log` |

---

## 13.2 find — Search Files

### Description
**find** searches the filesystem for files/directories matching criteria (name, size, date, permissions, etc.).

### Syntax
```bash
find [path] [conditions] [actions]
```

### Examples

```bash
# Find by name
find /home -name "report.txt"
find / -name "*.log"

# Case insensitive name
find /home -iname "readme*"

# Find by type
find /home -type f              # Files only
find /home -type d              # Directories only
find /home -type l              # Symbolic links

# Find by size
find / -size +100M              # Larger than 100MB
find / -size -1k                # Smaller than 1KB
find /home -size +1G            # Larger than 1GB

# Find by modification time
find /home -mtime -1            # Modified in last 24 hours
find /home -mtime +30           # Modified more than 30 days ago
find /home -mmin -60            # Modified in last 60 minutes

# Find by permissions
find / -perm 777                # Exactly 777
find / -perm -u+x              # User has execute
find / -perm /o+w              # Others have write (security check!)

# Find by owner
find /home -user john
find /var -group www-data

# Find and execute command
find /tmp -name "*.tmp" -exec rm {} \;        # Delete found files
find /home -name "*.py" -exec grep "import" {} \;  # Search inside found files

# Find empty files/directories
find /home -empty

# Combine conditions
find /var/log -name "*.log" -size +10M -mtime +7
# Logs larger than 10MB, not modified in 7 days
```

### find vs grep

| Tool | Searches For | Where |
|------|-------------|-------|
| `find` | Files (by name, size, date, etc.) | Filesystem |
| `grep` | Text patterns | Inside files |

```bash
# Common combo: find files, then search inside them
find /project -name "*.java" -exec grep -l "deprecated" {} \;
# Finds .java files containing "deprecated"
```

---

## 13.3 sort — Sort Lines

```bash
# Alphabetical sort (default)
$ sort names.txt
Alice
Bob
Charlie
Dave

# Numeric sort
$ sort -n numbers.txt
1
5
10
100

# Reverse sort
$ sort -r names.txt

# Sort by specific field (column)
# File: employees.txt → "name:age:salary"
$ sort -t: -k3 -n employees.txt    # Sort by 3rd field (salary), numeric

# Remove duplicates while sorting
$ sort -u repeated.txt

# Case insensitive sort
$ sort -f mixed_case.txt
```

---

## 13.4 uniq — Remove Duplicates

```bash
# IMPORTANT: uniq only removes ADJACENT duplicates!
# Always sort first, then uniq.

# Remove adjacent duplicates
$ sort data.txt | uniq

# Count occurrences
$ sort data.txt | uniq -c
      3 apple
      1 banana
      2 cherry

# Show only duplicates
$ sort data.txt | uniq -d

# Show only unique lines (appearing once)
$ sort data.txt | uniq -u
```

---

## 13.5 cut — Extract Columns

```bash
# Cut by character position
$ echo "Hello World" | cut -c1-5
Hello

# Cut by delimiter and field
$ cat /etc/passwd | cut -d: -f1
root
john
alice

# -d: = delimiter is colon
# -f1 = first field (username)

# Multiple fields
$ cut -d: -f1,3 /etc/passwd     # Fields 1 and 3
root:0
john:1000
alice:1001

# Cut with space delimiter
$ echo "one two three" | cut -d' ' -f2
two
```

---

## 13.6 Combining Commands (Pipes)

### Power of Piping

```bash
# Find top 5 largest files in /var/log
du -ah /var/log | sort -rh | head -5

# Count unique IP addresses in access log
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Find users with bash shell
grep "/bin/bash" /etc/passwd | cut -d: -f1

# Count lines containing "error" (case insensitive)
grep -ic "error" application.log

# Find .py files modified today containing "TODO"
find . -name "*.py" -mtime 0 -exec grep -l "TODO" {} \;

# Process a CSV: extract 2nd column, sort, count unique
cut -d, -f2 data.csv | sort | uniq -c | sort -rn
```

---

## 13.7 Practice & Assessment

### MCQs

**Q1.** `grep -v "^#" file.conf` shows:
- A) Lines starting with #
- B) Lines NOT starting with #
- C) Lines containing #
- D) Line count

**Answer:** B) Lines NOT starting with # (comments removed)

---

**Q2.** `find / -size +100M -type f` finds:
- A) Directories larger than 100MB
- B) Files larger than 100MB
- C) Files exactly 100MB
- D) Files smaller than 100MB

**Answer:** B

---

**Q3.** Before using `uniq`, you should:
- A) Use grep
- B) Sort the data
- C) Use find
- D) Nothing, uniq works on unsorted data

**Answer:** B) Sort first (uniq only removes adjacent duplicates)

---

### Hands-On

**Task:** Write a one-liner pipeline to:
1. Find all failed SSH login attempts in auth.log
2. Extract the IP addresses
3. Count occurrences of each IP
4. Sort by count (highest first)
5. Show top 5 attackers

```bash
grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | head -5
```

---

> **Next Topic:** [14 - Process Management (Linux)](14-process-management.md)
