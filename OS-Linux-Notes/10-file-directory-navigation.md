# 10. File and Directory Navigation

## Table of Contents
- [10.1 pwd — Print Working Directory](#101-pwd--print-working-directory)
- [10.2 ls — List Directory Contents](#102-ls--list-directory-contents)
- [10.3 cd — Change Directory](#103-cd--change-directory)
- [10.4 mkdir & rmdir — Create/Remove Directories](#104-mkdir--rmdir--createremove-directories)
- [10.5 Paths: Absolute vs Relative](#105-paths-absolute-vs-relative)
- [10.6 Practice & Assessment](#106-practice--assessment)

---

## 10.1 pwd — Print Working Directory

### Description
Shows the full path of your current location in the filesystem.

```bash
$ pwd
/home/john/Documents

# You are currently inside /home/john/Documents
```

---

## 10.2 ls — List Directory Contents

### Syntax
```bash
ls [options] [path]
```

### Key Options

| Flag | Purpose | Example |
|------|---------|---------|
| `-l` | Long format (permissions, size, date) | `ls -l` |
| `-a` | Show hidden files (starting with .) | `ls -a` |
| `-h` | Human-readable sizes (KB, MB) | `ls -lh` |
| `-R` | Recursive (show subdirectories too) | `ls -R` |
| `-t` | Sort by modification time (newest first) | `ls -lt` |
| `-S` | Sort by size (largest first) | `ls -lS` |
| `-r` | Reverse sort order | `ls -lr` |
| `-d` | Show directory itself, not contents | `ls -ld /etc` |

### Examples and Output

```bash
# Basic listing
$ ls
Desktop  Documents  Downloads  file.txt  script.sh

# Long format
$ ls -l
total 16
drwxr-xr-x 2 john john 4096 Jan 10 09:00 Desktop
drwxr-xr-x 3 john john 4096 Jan 12 14:30 Documents
-rw-r--r-- 1 john john  256 Jan 15 10:15 file.txt
-rwxr-xr-x 1 john john  128 Jan 14 08:00 script.sh

# Breakdown of ls -l output:
# -rw-r--r--  1  john  john  256  Jan 15 10:15  file.txt
# │           │  │     │     │    │              │
# Permissions │  Owner Group Size  Date Modified  Name
#          Links
```

```bash
# Show hidden files
$ ls -a
.  ..  .bashrc  .profile  Desktop  Documents  file.txt

# . = current directory
# .. = parent directory
# .bashrc = hidden file (starts with dot)

# Combine flags
$ ls -lah
total 32K
drwxr-xr-x  5 john john 4.0K Jan 15 10:15 .
drwxr-xr-x  3 root root 4.0K Jan  5 08:00 ..
-rw-r--r--  1 john john  220 Jan  5 08:00 .bashrc
drwxr-xr-x  2 john john 4.0K Jan 10 09:00 Desktop
-rw-r--r--  1 john john  256 Jan 15 10:15 file.txt

# List specific directory without entering it
$ ls -l /etc/ssh
total 12
-rw-r--r-- 1 root root 1580 Jan 10 09:00 ssh_config
-rw------- 1 root root 3243 Jan 10 09:00 sshd_config
```

---

## 10.3 cd — Change Directory

### Syntax
```bash
cd [path]
```

### Examples

```bash
# Go to home directory (3 ways)
cd
cd ~
cd /home/john

# Go to specific directory
cd /var/log
cd Documents

# Go up one level (parent directory)
cd ..

# Go up two levels
cd ../..

# Go to previous directory (toggle)
cd -
# Output: /home/john/Documents (shows where you went)

# Go to root
cd /
```

### Navigation Shortcuts

| Shortcut | Meaning |
|----------|---------|
| `~` | Home directory (/home/username) |
| `.` | Current directory |
| `..` | Parent directory |
| `-` | Previous directory |
| `/` | Root directory |

---

## 10.4 mkdir & rmdir — Create/Remove Directories

### mkdir (Make Directory)

```bash
# Create single directory
mkdir projects

# Create nested directories (-p creates parents)
mkdir -p projects/web/frontend
# Creates: projects/ → web/ → frontend/
# Without -p, this would fail if projects/ doesn't exist

# Create multiple directories
mkdir dir1 dir2 dir3

# Create with specific permissions
mkdir -m 755 secure_folder
```

### rmdir (Remove Empty Directory)

```bash
# Remove empty directory
rmdir old_folder
# ERROR if directory is not empty!

# Remove nested empty directories
rmdir -p a/b/c
# Removes c, then b, then a (only if all empty)

# To remove directory with contents, use rm -r (covered in File Operations)
```

---

## 10.5 Paths: Absolute vs Relative

### Absolute Path
Starts from root `/` — full path to the target.

```bash
/home/john/Documents/report.txt
/etc/ssh/sshd_config
/var/log/syslog
```

### Relative Path
Starts from your current location.

```bash
# If you're in /home/john:
Documents/report.txt      # same as /home/john/Documents/report.txt
./script.sh               # same as /home/john/script.sh
../alice/file.txt         # same as /home/alice/file.txt
```

### Example Navigation

```bash
# Starting at /home/john
$ pwd
/home/john

$ cd Documents
$ pwd
/home/john/Documents

$ cd ../Downloads
$ pwd
/home/john/Downloads

$ cd /etc
$ pwd
/etc

$ cd ~
$ pwd
/home/john
```

---

## 10.6 Practice & Assessment

### MCQs

**Q1.** `ls -la` shows:
- A) Only directories
- B) Long format including hidden files
- C) Only hidden files
- D) Files sorted by size

**Answer:** B

---

**Q2.** `cd ..` moves you to:
- A) Home directory
- B) Root directory
- C) Parent directory
- D) Previous directory

**Answer:** C

---

**Q3.** `mkdir -p a/b/c` creates:
- A) Only directory c
- B) All three directories (a, a/b, a/b/c)
- C) An error
- D) A file named a/b/c

**Answer:** B

---

### Hands-On Tasks

**Task 1:** You are in `/home/user`. Write commands to:
1. Create directory structure: `projects/python/basics`
2. Navigate into `basics`
3. Go back to home in one command

```bash
mkdir -p projects/python/basics
cd projects/python/basics
cd ~
```

**Task 2:** What is the output of `ls -ld /etc`?
```bash
drwxr-xr-x 128 root root 12288 Jan 15 10:00 /etc
# Shows info about /etc directory ITSELF (not its contents)
```

---

> **Next Topic:** [11 - File Operations](11-file-operations.md)
