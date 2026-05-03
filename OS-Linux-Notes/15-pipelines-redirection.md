# 15. Pipelines and Redirection

## Table of Contents
- [15.1 Standard Streams](#151-standard-streams)
- [15.2 Output Redirection](#152-output-redirection)
- [15.3 Input Redirection](#153-input-redirection)
- [15.4 Pipes](#154-pipes)
- [15.5 Advanced Redirection](#155-advanced-redirection)
- [15.6 Practice & Assessment](#156-practice--assessment)

---

## 15.1 Standard Streams

Every Linux process has three standard I/O streams:

```
                    ┌──────────────┐
  stdin (0) ──────► │              │ ──────► stdout (1)
  (keyboard)        │   PROCESS    │
                    │              │ ──────► stderr (2)
                    └──────────────┘         (error messages)
```

| Stream | Number | Default | Purpose |
|--------|--------|---------|---------|
| **stdin** | 0 | Keyboard | Input to process |
| **stdout** | 1 | Screen | Normal output |
| **stderr** | 2 | Screen | Error messages |

---

## 15.2 Output Redirection

### Redirect stdout

```bash
# Overwrite file with output (creates if not exists)
echo "Hello" > output.txt

# Append to file
echo "World" >> output.txt

# Command output to file
ls -l > filelist.txt
date > timestamp.txt
```

### Redirect stderr

```bash
# Redirect ONLY errors to file
ls /nonexistent 2> errors.txt

# Append errors
command_that_fails 2>> error_log.txt

# Discard errors (send to /dev/null — the "black hole")
ls /nonexistent 2>/dev/null
```

### Redirect Both stdout and stderr

```bash
# Both to same file
command > output.txt 2>&1

# Modern syntax (bash 4+)
command &> output.txt

# Append both
command >> output.txt 2>&1
command &>> output.txt

# stdout to one file, stderr to another
command > success.txt 2> errors.txt

# Discard ALL output
command > /dev/null 2>&1
```

### /dev/null — The Black Hole

```bash
# Discard output you don't need
grep "pattern" huge_file.txt > /dev/null 2>&1
# Only care about exit code, not output

# Check if command succeeded without seeing output
if ping -c 1 google.com > /dev/null 2>&1; then
    echo "Internet is up"
fi
```

---

## 15.3 Input Redirection

### Redirect stdin from file

```bash
# Instead of typing input, read from file
sort < unsorted.txt

# wc reads from file via redirection
wc -l < data.txt

# Same result as: wc -l data.txt
# Difference: with < the command doesn't know the filename
```

### Here Document (<<)

```bash
# Multi-line input to a command
cat << EOF
This is line 1
This is line 2
Last line
EOF

# Useful for creating files in scripts
cat > config.txt << EOF
server=localhost
port=8080
debug=false
EOF

# Here string (<<<) — single line
grep "hello" <<< "hello world"
# Output: hello world
```

---

## 15.4 Pipes

### Definition
A **pipe** (`|`) connects the stdout of one command to the stdin of the next.

```bash
command1 | command2 | command3
# command1 output → command2 input → command3 input
```

### Examples

```bash
# Count files in directory
ls | wc -l

# Find large files and sort
du -ah /home | sort -rh | head -10

# Search running processes
ps aux | grep nginx

# Get unique sorted list
cat names.txt | sort | uniq

# Count lines containing "error"
cat log.txt | grep -c "error"
# Or simply: grep -c "error" log.txt

# Extract, filter, and count
cat /etc/passwd | cut -d: -f7 | sort | uniq -c | sort -rn
# Shows count of each shell used (bash, zsh, nologin, etc.)
```

### Common Pipeline Patterns

```bash
# Pattern 1: Filter and count
command | grep "pattern" | wc -l

# Pattern 2: Extract, sort, deduplicate
command | cut -d' ' -f1 | sort | uniq

# Pattern 3: Find top N
command | sort -rn | head -n 10

# Pattern 4: Real-time filtering
tail -f /var/log/syslog | grep --line-buffered "error"
```

---

## 15.5 Advanced Redirection

### tee — Write to File AND Screen

```bash
# tee copies stdin to both stdout AND a file
ls -l | tee filelist.txt
# Shows on screen AND saves to filelist.txt

# Append mode
echo "log entry" | tee -a logfile.txt

# Tee to multiple files
command | tee file1.txt file2.txt

# Common use: save output while still piping
ps aux | tee processes.txt | grep nginx
```

### xargs — Build Commands from Input

```bash
# Find and delete (alternative to -exec)
find /tmp -name "*.tmp" | xargs rm

# Run command for each line of input
cat urls.txt | xargs wget

# With confirmation (-p)
find . -name "*.log" | xargs -p rm

# Handle filenames with spaces (-0 with find -print0)
find . -name "*.txt" -print0 | xargs -0 grep "pattern"
```

---

## 15.6 Practice & Assessment

### MCQs

**Q1.** `command 2>/dev/null` discards:
- A) All output
- B) Only standard output
- C) Only error messages
- D) Input

**Answer:** C) Only stderr (error messages)

---

**Q2.** `ls | wc -l` outputs:
- A) List of files
- B) Number of files/directories listed
- C) File sizes
- D) Error messages

**Answer:** B) Count of lines in ls output

---

**Q3.** `tee` is useful because it:
- A) Deletes files
- B) Writes output to a file AND passes it to the next command
- C) Creates encrypted files
- D) Compresses output

**Answer:** B

---

### Hands-On

**Task:** Write a pipeline that:
1. Lists all running processes
2. Filters for python processes
3. Extracts just the PID (column 2)
4. Saves to a file AND displays on screen

```bash
ps aux | grep python | awk '{print $2}' | tee python_pids.txt
```

---

> **Next Topic:** [16 - Networking Commands](16-networking-commands.md)
