# 11. File Operations

## Table of Contents
- [11.1 Creating Files](#111-creating-files)
- [11.2 Viewing File Contents](#112-viewing-file-contents)
- [11.3 Copying Files (cp)](#113-copying-files-cp)
- [11.4 Moving/Renaming Files (mv)](#114-movingrenaming-files-mv)
- [11.5 Removing Files (rm)](#115-removing-files-rm)
- [11.6 File Information](#116-file-information)
- [11.7 Practice & Assessment](#117-practice--assessment)

---

## 11.1 Creating Files

### touch — Create Empty File / Update Timestamps

```bash
# Create empty file
touch newfile.txt

# Create multiple files
touch file1.txt file2.txt file3.txt

# If file exists, touch updates its modification timestamp
touch existing_file.txt    # Just updates timestamp, doesn't erase content
```

### echo — Write Text to File

```bash
# Write text to file (overwrite)
echo "Hello World" > greeting.txt

# Append text to file
echo "Another line" >> greeting.txt

# Create multi-line file
echo -e "Line 1\nLine 2\nLine 3" > multiline.txt
```

### cat — Create File with Content (Here Document)

```bash
# Create file with multiple lines
cat > notes.txt << EOF
This is line 1
This is line 2
This is the last line
EOF

# Append to existing file
cat >> notes.txt << EOF
This is appended
EOF
```

---

## 11.2 Viewing File Contents

### cat — Concatenate and Display

```bash
# Display entire file
$ cat file.txt
Hello World
This is line 2

# Display with line numbers
$ cat -n file.txt
     1  Hello World
     2  This is line 2

# Display multiple files
cat file1.txt file2.txt

# Display non-printing characters
cat -A file.txt    # Shows tabs (^I), line endings ($)
```

### less & more — Page Through Files

```bash
# less (preferred — allows scrolling up and down)
less /var/log/syslog

# Navigation in less:
#   Space / Page Down  → Next page
#   b / Page Up        → Previous page
#   /pattern           → Search forward
#   ?pattern           → Search backward
#   n                  → Next search result
#   q                  → Quit

# more (simpler — only forward)
more /var/log/syslog
```

### head & tail — View Beginning/End

```bash
# First 10 lines (default)
$ head file.txt

# First 5 lines
$ head -n 5 file.txt
$ head -5 file.txt

# Last 10 lines (default)
$ tail file.txt

# Last 3 lines
$ tail -n 3 file.txt

# Follow file in real-time (great for logs!)
$ tail -f /var/log/syslog
# Shows new lines as they are written (Ctrl+C to stop)

# Last 50 lines and follow
$ tail -n 50 -f /var/log/auth.log
```

### wc — Word Count

```bash
$ wc file.txt
  10   45  300 file.txt
# 10 lines, 45 words, 300 bytes

# Count only lines
$ wc -l file.txt
10 file.txt

# Count only words
$ wc -w file.txt
45 file.txt

# Count only characters/bytes
$ wc -c file.txt
300 file.txt
```

---

## 11.3 Copying Files (cp)

### Syntax
```bash
cp [options] source destination
```

### Examples

```bash
# Copy file
cp original.txt copy.txt

# Copy file to another directory
cp report.txt /home/john/Documents/

# Copy and rename
cp report.txt /home/john/Documents/report_backup.txt

# Copy directory (recursive)
cp -r project_folder/ backup_folder/

# Copy with preservation of attributes (permissions, timestamps)
cp -p original.txt copy.txt

# Interactive (ask before overwrite)
cp -i source.txt dest.txt
# cp: overwrite 'dest.txt'? y

# Verbose (show what's being copied)
cp -v file1.txt /tmp/
# 'file1.txt' -> '/tmp/file1.txt'

# Copy multiple files to directory
cp file1.txt file2.txt file3.txt /backup/
```

### Common Pitfalls

```bash
# WRONG: Copying directory without -r
cp mydir/ /backup/
# Error: omitting directory 'mydir/'

# CORRECT:
cp -r mydir/ /backup/
```

---

## 11.4 Moving/Renaming Files (mv)

### Syntax
```bash
mv [options] source destination
```

### Examples

```bash
# Rename file
mv oldname.txt newname.txt

# Move file to another directory
mv report.txt /home/john/Documents/

# Move and rename
mv draft.txt /final/report_v2.txt

# Move directory (no -r needed!)
mv project/ /backup/project/

# Interactive (ask before overwrite)
mv -i source.txt existing.txt
# mv: overwrite 'existing.txt'? y

# Move multiple files
mv file1.txt file2.txt file3.txt /destination/
```

### Key Difference: cp vs mv

| Operation | cp | mv |
|-----------|----|----|
| Original file | Kept (still exists) | Removed (moved) |
| Analogy | Photocopy | Pick up and place |

---

## 11.5 Removing Files (rm)

### Syntax
```bash
rm [options] file(s)
```

### Examples

```bash
# Remove single file
rm unwanted.txt

# Remove multiple files
rm file1.txt file2.txt file3.txt

# Interactive (ask confirmation)
rm -i important.txt
# rm: remove regular file 'important.txt'? y

# Force remove (no confirmation, no error for missing files)
rm -f file.txt

# Remove directory and all contents (DANGEROUS!)
rm -r directory_name/

# Remove directory forcefully (VERY DANGEROUS!)
rm -rf old_project/
# ⚠️ NEVER run: rm -rf /   (deletes EVERYTHING!)

# Remove empty directory (safer alternative)
rmdir empty_directory/
```

### Safety Tips

```bash
# ALWAYS double-check before rm -rf
# Use ls first to see what will be deleted:
ls directory_to_delete/

# Use -i for confirmation:
rm -ri directory/

# Create alias for safety:
alias rm='rm -i'    # Always ask before deleting
```

---

## 11.6 File Information

### file — Determine File Type

```bash
$ file document.pdf
document.pdf: PDF document, version 1.5

$ file image.png
image.png: PNG image data, 800 x 600, 8-bit/color RGBA

$ file script.sh
script.sh: Bourne-Again shell script, ASCII text executable

$ file /bin/ls
/bin/ls: ELF 64-bit LSB pie executable, x86-64
```

### stat — Detailed File Information

```bash
$ stat file.txt
  File: file.txt
  Size: 256       Blocks: 8          IO Block: 4096   regular file
Device: 801h/2049d   Inode: 1234567    Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/  john)   Gid: ( 1000/  john)
Access: 2024-01-15 10:00:00.000000000 +0530
Modify: 2024-01-15 09:45:00.000000000 +0530
Change: 2024-01-15 09:45:00.000000000 +0530
 Birth: 2024-01-10 08:00:00.000000000 +0530
```

### du — Disk Usage

```bash
# Size of file/directory
$ du -sh Documents/
45M    Documents/

# Size of each subdirectory
$ du -h --max-depth=1 /home/john/
12M    /home/john/Documents
5M     /home/john/Downloads
500K   /home/john/Desktop
18M    /home/john/

# Find largest files
du -ah /home/john/ | sort -rh | head -10
```

### df — Disk Free Space

```bash
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   25G   23G  53% /
/dev/sda2       100G   60G   35G  63% /home
tmpfs           3.9G     0  3.9G   0% /tmp
```

---

## 11.7 Practice & Assessment

### MCQs

**Q1.** `echo "hello" >> file.txt` does:
- A) Overwrites file with "hello"
- B) Appends "hello" to the file
- C) Creates a file named "hello"
- D) Prints "hello" to screen

**Answer:** B) Appends

---

**Q2.** To copy a directory with contents:
- A) `cp directory/ dest/`
- B) `cp -r directory/ dest/`
- C) `mv directory/ dest/`
- D) `cp -f directory/ dest/`

**Answer:** B) `cp -r`

---

**Q3.** `tail -f /var/log/syslog` does:
- A) Shows first 10 lines
- B) Follows file in real-time (shows new content)
- C) Deletes the file
- D) Counts lines

**Answer:** B) Follows in real-time

---

### Hands-On Tasks

**Task:** Write commands to:
1. Create a file `data.txt` containing "Hello Linux"
2. Copy it to `/tmp/data_backup.txt`
3. Rename original to `data_old.txt`
4. View the backup file contents
5. Delete the backup

```bash
echo "Hello Linux" > data.txt
cp data.txt /tmp/data_backup.txt
mv data.txt data_old.txt
cat /tmp/data_backup.txt
rm /tmp/data_backup.txt
```

---

> **Next Topic:** [12 - Permissions and Ownership](12-permissions-ownership.md)
