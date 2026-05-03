# 12. Permissions and Ownership

## Table of Contents
- [12.1 Understanding Permissions](#121-understanding-permissions)
- [12.2 chmod — Change Permissions](#122-chmod--change-permissions)
- [12.3 chown & chgrp — Change Ownership](#123-chown--chgrp--change-ownership)
- [12.4 Special Permissions](#124-special-permissions)
- [12.5 Default Permissions (umask)](#125-default-permissions-umask)
- [12.6 Practice & Assessment](#126-practice--assessment)

---

## 12.1 Understanding Permissions

### Permission Format

```bash
$ ls -l file.txt
-rw-r--r-- 1 john developers 256 Jan 15 10:00 file.txt

Breakdown:
-  rw-  r--  r--
│  │    │    │
│  │    │    └── Others (everyone else)
│  │    └─────── Group (developers)
│  └──────────── Owner/User (john)
└─────────────── File type (- = file, d = directory, l = link)
```

### Permission Types

| Symbol | Permission | On File | On Directory |
|--------|-----------|---------|-------------|
| `r` (4) | Read | View contents | List contents (ls) |
| `w` (2) | Write | Modify contents | Create/delete files inside |
| `x` (1) | Execute | Run as program | Enter directory (cd) |
| `-` (0) | None | No access | No access |

### Numeric (Octal) Representation

```
r = 4, w = 2, x = 1

Examples:
  rwx = 4+2+1 = 7
  rw- = 4+2+0 = 6
  r-x = 4+0+1 = 5
  r-- = 4+0+0 = 4
  --- = 0+0+0 = 0

Common permissions:
  755 = rwxr-xr-x  (owner: all, group/others: read+execute)
  644 = rw-r--r--  (owner: read+write, group/others: read only)
  700 = rwx------  (owner: all, nobody else)
  600 = rw-------  (owner: read+write, nobody else)
  777 = rwxrwxrwx  (everyone: all — INSECURE!)
```

---

## 12.2 chmod — Change Permissions

### Symbolic Mode

```bash
# Syntax: chmod [who][operator][permission] file
# who: u(user/owner), g(group), o(others), a(all)
# operator: +(add), -(remove), =(set exactly)

# Add execute for owner
chmod u+x script.sh

# Remove write for group and others
chmod go-w file.txt

# Set exact permissions for all
chmod a=r file.txt       # Everyone gets read only

# Multiple changes
chmod u+rwx,g+rx,o-rwx file.txt

# Add execute for everyone
chmod +x script.sh       # Same as a+x
```

### Numeric Mode

```bash
# chmod [number] file

chmod 755 script.sh     # rwxr-xr-x
chmod 644 file.txt      # rw-r--r--
chmod 700 private/      # rwx------
chmod 600 secret.key    # rw-------
chmod 777 public.txt    # rwxrwxrwx (avoid this!)

# Recursive (apply to directory and all contents)
chmod -R 755 project/
```

### Quick Reference Table

| Numeric | Symbolic | Use Case |
|---------|----------|----------|
| 755 | rwxr-xr-x | Scripts, directories |
| 644 | rw-r--r-- | Regular files |
| 700 | rwx------ | Private scripts/directories |
| 600 | rw------- | Private files (SSH keys) |
| 444 | r--r--r-- | Read-only for everyone |
| 000 | --------- | No access (locked) |

---

## 12.3 chown & chgrp — Change Ownership

### chown — Change Owner

```bash
# Change owner
sudo chown alice file.txt
# file.txt now owned by alice

# Change owner and group
sudo chown alice:developers file.txt

# Change only group (with colon)
sudo chown :developers file.txt

# Recursive
sudo chown -R john:john /home/john/project/

# Verify
$ ls -l file.txt
-rw-r--r-- 1 alice developers 256 Jan 15 10:00 file.txt
```

### chgrp — Change Group

```bash
# Change group only
sudo chgrp developers project/

# Recursive
sudo chgrp -R webteam /var/www/

# Verify
$ ls -l project/
drwxr-xr-x 2 john developers 4096 Jan 15 10:00 project/
```

---

## 12.4 Special Permissions

### SUID (Set User ID) — 4

```bash
# When set on executable: runs as the FILE OWNER, not the user
# Example: /usr/bin/passwd has SUID set (runs as root to change /etc/shadow)

$ ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root 68208 Jan 10 09:00 /usr/bin/passwd
#  ^── 's' instead of 'x' means SUID is set

# Set SUID
chmod u+s program
chmod 4755 program    # 4 = SUID bit
```

### SGID (Set Group ID) — 2

```bash
# On file: runs as the file's GROUP
# On directory: new files inherit the directory's group

# Set SGID on directory (team collaboration)
chmod g+s /shared/project/
chmod 2775 /shared/project/

# Now any file created in /shared/project/ will have group = directory's group
```

### Sticky Bit — 1

```bash
# On directory: only file OWNER can delete their files
# (prevents users from deleting each other's files)

# /tmp has sticky bit set:
$ ls -ld /tmp
drwxrwxrwt 15 root root 4096 Jan 15 10:00 /tmp
#        ^── 't' = sticky bit

# Set sticky bit
chmod +t /shared/
chmod 1777 /shared/
```

### Summary

| Bit | Numeric | On File | On Directory |
|-----|---------|---------|-------------|
| SUID | 4xxx | Runs as owner | — |
| SGID | 2xxx | Runs as group | New files inherit group |
| Sticky | 1xxx | — | Only owner can delete own files |

---

## 12.5 Default Permissions (umask)

### What is umask?
`umask` defines permissions to **remove** from newly created files/directories.

```bash
# Check current umask
$ umask
0022

# Default permissions:
#   Files: 666 (rw-rw-rw-)       ← base
#   Dirs:  777 (rwxrwxrwx)       ← base

# With umask 0022:
#   File: 666 - 022 = 644 (rw-r--r--)
#   Dir:  777 - 022 = 755 (rwxr-xr-x)

# Set umask (more restrictive)
umask 077
# Files: 666 - 077 = 600 (rw-------)
# Dirs:  777 - 077 = 700 (rwx------)
```

---

## 12.6 Practice & Assessment

### MCQs

**Q1.** Permission `644` means:
- A) Owner: rwx, Group: r-x, Others: r--
- B) Owner: rw-, Group: r--, Others: r--
- C) Owner: rw-, Group: rw-, Others: r--
- D) Everyone: rw-

**Answer:** B

---

**Q2.** The sticky bit on `/tmp` prevents:
- A) Anyone from reading files
- B) Users from creating files
- C) Users from deleting others' files
- D) Root from accessing /tmp

**Answer:** C

---

**Q3.** `chmod 700 secret/` gives:
- A) Everyone full access
- B) Only the owner full access
- C) Read-only for everyone
- D) No access for anyone

**Answer:** B (rwx------)

---

### Hands-On

**Task:** A script `deploy.sh` needs:
- Owner (root): read, write, execute
- Group (devops): read, execute
- Others: no access

Write the chmod command (both ways):
```bash
chmod 750 deploy.sh         # Numeric
chmod u=rwx,g=rx,o= deploy.sh  # Symbolic
```

---

> **Next Topic:** [13 - Searching and Filtering](13-searching-filtering.md)
