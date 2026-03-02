# 📘 Chapter 9: Linux Operations

> **"Linux is a free, open-source operating system kernel that powers everything from smartphones (Android) to supercomputers (99% of top 500)."**

---

## 📑 Table of Contents

| # | Topic |
|---|-------|
| 1 | [Linux Introduction & Architecture](#1-linux-introduction--architecture) |
| 2 | [File System & Navigation](#2-file-system--navigation) |
| 3 | [File Operations Commands](#3-file-operations-commands) |
| 4 | [Viewing & Searching Files](#4-viewing--searching-files) |
| 5 | [File Permissions & Ownership](#5-file-permissions--ownership) |
| 6 | [User & Group Management](#6-user--group-management) |
| 7 | [Process Management](#7-process-management) |
| 8 | [Disk & Storage Commands](#8-disk--storage-commands) |
| 9 | [Networking Commands](#9-networking-commands) |
| 10 | [Package Management](#10-package-management) |
| 11 | [Shell Scripting Basics](#11-shell-scripting-basics) |
| 12 | [Quick Summary](#12-quick-summary) |
| 13 | [Practice Questions](#-practice-questions) |

---

## 1. Linux Introduction & Architecture

### 📖 What is Linux?

```
    ┌──────────────────────────────────────────────────────────┐
    │                     LINUX KEY FACTS                        │
    ├──────────────────────────────────────────────────────────┤
    │                                                          │
    │  Creator:    Linus Torvalds (1991)                        │
    │  Type:       Unix-like, open-source OS kernel            │
    │  License:    GNU GPL (free to use, modify, distribute)   │
    │  Language:   Primarily written in C                       │
    │  Mascot:     Tux (the penguin)                           │
    │                                                          │
    │  Popular Distributions (Distros):                         │
    │  ├── Ubuntu (beginner-friendly)                          │
    │  ├── CentOS / RHEL (enterprise servers)                  │
    │  ├── Fedora (cutting-edge features)                      │
    │  ├── Debian (stable, foundational)                        │
    │  ├── Arch Linux (advanced users)                         │
    │  └── Kali Linux (security/pentesting)                    │
    │                                                          │
    └──────────────────────────────────────────────────────────┘
```

### Linux Architecture

```
    ┌────────────────────────────────────────────────┐
    │              USER APPLICATIONS                  │
    │         (Firefox, vim, gcc, python)             │
    ├────────────────────────────────────────────────┤
    │               SHELL                             │
    │    (bash, zsh, fish — command interpreter)      │
    │    Accepts commands, passes to kernel            │
    ├────────────────────────────────────────────────┤
    │           SYSTEM LIBRARIES                      │
    │     (glibc — C library, system calls API)       │
    ├────────────────────────────────────────────────┤
    │              KERNEL                             │
    │    ┌────────────────────────────────────┐       │
    │    │  Process Mgmt | Memory Mgmt       │       │
    │    │  File System  | Device Drivers     │       │
    │    │  Network Stack| I/O Management     │       │
    │    └────────────────────────────────────┘       │
    ├────────────────────────────────────────────────┤
    │              HARDWARE                           │
    │       (CPU, RAM, Disk, Network, etc.)           │
    └────────────────────────────────────────────────┘
```

### Shell Types

```
    ┌────────────┬───────────────────────────────────────┐
    │   Shell    │ Description                           │
    ├────────────┼───────────────────────────────────────┤
    │ bash       │ Bourne Again Shell (default on most)  │
    │ sh         │ Original Bourne Shell                 │
    │ zsh        │ Z Shell (macOS default, feature-rich) │
    │ fish       │ Friendly Interactive Shell             │
    │ csh/tcsh   │ C Shell (C-like syntax)               │
    │ ksh        │ Korn Shell                            │
    └────────────┴───────────────────────────────────────┘
    
    Check your shell:  echo $SHELL
    List all shells:   cat /etc/shells
```

---

## 2. File System & Navigation

### Linux Directory Structure

```
    /                          ← ROOT directory (top of everything)
    ├── bin/                   ← Essential user binaries (ls, cp, cat)
    ├── sbin/                  ← System binaries (fdisk, reboot)
    ├── etc/                   ← Configuration files (passwd, fstab)
    ├── home/                  ← User home directories
    │   ├── alice/             ←   /home/alice
    │   └── bob/               ←   /home/bob
    ├── root/                  ← Root user's home directory
    ├── var/                   ← Variable data (logs, mail, spool)
    │   └── log/               ←   System log files
    ├── tmp/                   ← Temporary files (cleared on reboot)
    ├── usr/                   ← User programs and data
    │   ├── bin/               ←   User binaries
    │   ├── lib/               ←   Libraries
    │   └── share/             ←   Shared data
    ├── opt/                   ← Optional/third-party software
    ├── dev/                   ← Device files (sda, tty, null)
    ├── proc/                  ← Virtual FS — process info
    ├── sys/                   ← Virtual FS — system/hardware info
    ├── mnt/                   ← Mount point for temp filesystems
    ├── media/                 ← Mount point for removable media
    ├── lib/                   ← Essential shared libraries
    └── boot/                  ← Boot loader files (kernel, grub)
```

### Navigation Commands

```bash
    # PRINT WORKING DIRECTORY
    pwd                          # Show current directory

    # CHANGE DIRECTORY
    cd /home/alice               # Go to absolute path
    cd Documents                 # Go to relative path
    cd ..                        # Go up one level (parent directory)
    cd ../..                     # Go up two levels
    cd ~                         # Go to home directory
    cd -                         # Go to previous directory
    cd /                         # Go to root directory

    # LIST DIRECTORY CONTENTS
    ls                           # List files and folders
    ls -l                        # Long format (permissions, size, date)
    ls -la                       # Include hidden files (start with .)
    ls -lh                       # Human-readable sizes (KB, MB, GB)
    ls -lt                       # Sort by modification time
    ls -lS                       # Sort by size (largest first)
    ls -R                        # Recursive listing (include subdirs)
    ls -d */                     # List only directories
```

### ls -l Output Explained

```
    $ ls -l
    -rw-r--r-- 1 alice staff 4096 Jan 15 10:30 report.txt
    drwxr-xr-x 3 alice staff 4096 Jan 14 09:00 Documents
    
    BREAKDOWN:
    -rw-r--r--    1     alice  staff  4096    Jan 15 10:30   report.txt
    ──────────   ───   ─────  ─────  ────    ────────────   ──────────
    │             │      │      │      │         │              │
    │             │      │      │      │         │              └─ File name
    │             │      │      │      │         └─ Last modified date
    │             │      │      │      └─ File size (bytes)
    │             │      │      └─ Group owner
    │             │      └─ User owner
    │             └─ Number of hard links
    └─ File type & permissions
    
    File type (1st char):
      -  = regular file
      d  = directory
      l  = symbolic link
      c  = character device
      b  = block device
```

---

## 3. File Operations Commands

### Creating Files & Directories

```bash
    # CREATE FILES
    touch file.txt               # Create empty file (or update timestamp)
    touch file1.txt file2.txt    # Create multiple files
    echo "Hello" > file.txt      # Create file with content (overwrites)
    echo "More" >> file.txt      # Append content to file
    cat > file.txt               # Type content, press Ctrl+D to save

    # CREATE DIRECTORIES
    mkdir mydir                  # Create a directory
    mkdir -p a/b/c               # Create nested directories (parents too)
    mkdir dir1 dir2 dir3         # Create multiple directories
```

### Copying, Moving, Renaming

```bash
    # COPY
    cp file.txt backup.txt       # Copy file
    cp file.txt /tmp/            # Copy to another directory
    cp -r mydir/ backup_dir/     # Copy directory recursively
    cp -i file.txt dest.txt      # Interactive (ask before overwrite)
    cp -v file.txt dest.txt      # Verbose (show what's being copied)

    # MOVE / RENAME
    mv file.txt /tmp/            # Move file to /tmp
    mv old.txt new.txt           # Rename file
    mv mydir/ /opt/mydir/        # Move directory
    mv -i file.txt dest.txt      # Interactive (ask before overwrite)
```

### Deleting Files & Directories

```bash
    # DELETE FILES
    rm file.txt                  # Remove file
    rm -i file.txt               # Ask before deleting
    rm -f file.txt               # Force delete (no confirmation)
    rm *.txt                     # Delete all .txt files

    # DELETE DIRECTORIES
    rmdir emptydir               # Remove EMPTY directory only
    rm -r mydir/                 # Remove directory and all contents
    rm -rf mydir/                # Force remove recursively (DANGEROUS!)
    
    # ⚠️ WARNING: rm -rf / will DELETE EVERYTHING!
    # NEVER run: rm -rf /
    # NEVER run: rm -rf /*
```

### Linking Files

```bash
    # HARD LINK (same inode, same file on disk)
    ln original.txt hardlink.txt
    
    # SYMBOLIC LINK (soft link — pointer to file path)
    ln -s original.txt symlink.txt
    ln -s /home/alice/docs /tmp/docs_link    # Link to directory
    
    # DIFFERENCE:
    # Hard link:  shares inode, won't break if original deleted
    # Soft link:  separate file pointing to path, breaks if original deleted
    
    # View link info
    ls -li                       # Show inode numbers
    readlink symlink.txt         # Show where symlink points
```

---

## 4. Viewing & Searching Files

### Viewing File Contents

```bash
    # VIEW ENTIRE FILE
    cat file.txt                 # Print entire file
    cat -n file.txt              # Print with line numbers
    tac file.txt                 # Print in reverse (last line first)
    
    # VIEW LARGE FILES (pager)
    less file.txt                # Scroll through file (q to quit)
    more file.txt                # Similar but simpler than less
    
    # VIEW PARTS OF A FILE
    head file.txt                # First 10 lines
    head -n 20 file.txt          # First 20 lines
    head -c 100 file.txt         # First 100 bytes
    
    tail file.txt                # Last 10 lines
    tail -n 20 file.txt          # Last 20 lines
    tail -f logfile.log          # Follow file in real-time (live logs!)
    
    # WORD/LINE/CHAR COUNT
    wc file.txt                  # lines, words, characters
    wc -l file.txt               # Line count only
    wc -w file.txt               # Word count only
    wc -c file.txt               # Byte count only
```

### Searching with grep

```bash
    # BASIC SEARCH
    grep "error" logfile.txt           # Find lines containing "error"
    grep -i "error" logfile.txt        # Case-insensitive search
    grep -n "error" logfile.txt        # Show line numbers
    grep -c "error" logfile.txt        # Count matching lines
    grep -v "error" logfile.txt        # Invert (show non-matching lines)
    
    # RECURSIVE SEARCH
    grep -r "TODO" /home/alice/code/   # Search in all files recursively
    grep -rl "TODO" .                  # List only filenames with matches
    
    # REGEX SEARCH
    grep -E "^[0-9]+" file.txt         # Extended regex: lines starting with numbers
    grep -E "error|warning" file.txt   # Match "error" OR "warning"
    grep "^$" file.txt                 # Find empty lines
    
    # COMMON PATTERNS
    grep "^Start" file.txt             # Lines STARTING with "Start"
    grep "end$" file.txt               # Lines ENDING with "end"
    grep -w "the" file.txt             # Match whole word "the" only
```

### Finding Files

```bash
    # FIND FILES BY NAME
    find / -name "file.txt"              # Find exact filename from root
    find /home -name "*.txt"             # Find all .txt files in /home
    find . -iname "readme*"             # Case-insensitive search
    
    # FIND BY TYPE
    find . -type f                       # Files only
    find . -type d                       # Directories only
    find . -type l                       # Symbolic links only
    
    # FIND BY SIZE
    find . -size +100M                   # Files larger than 100 MB
    find . -size -1k                     # Files smaller than 1 KB
    find . -empty                        # Empty files and directories
    
    # FIND BY TIME
    find . -mtime -7                     # Modified in last 7 days
    find . -atime +30                    # Accessed more than 30 days ago
    
    # FIND AND ACT
    find . -name "*.tmp" -delete         # Find and delete
    find . -name "*.log" -exec rm {} \;  # Find and execute command
    find . -type f -exec chmod 644 {} \; # Find files and change permissions
    
    # LOCATE (faster, uses database)
    locate filename                      # Quick search using indexed database
    updatedb                             # Update the locate database
```

### Sorting & Text Processing

```bash
    # SORT
    sort file.txt                  # Sort lines alphabetically
    sort -n file.txt               # Sort numerically
    sort -r file.txt               # Reverse sort
    sort -u file.txt               # Sort and remove duplicates
    sort -k 2 file.txt             # Sort by 2nd column
    
    # UNIQUE
    uniq file.txt                  # Remove adjacent duplicate lines
    sort file.txt | uniq           # Sort then remove all duplicates
    sort file.txt | uniq -c        # Count occurrences of each line
    
    # CUT (extract columns)
    cut -d "," -f 1 data.csv       # Get first field, comma-delimited
    cut -d ":" -f 1,3 /etc/passwd  # Get fields 1 and 3
    cut -c 1-10 file.txt           # Get first 10 characters of each line
    
    # AWK (powerful text processing)
    awk '{print $1}' file.txt      # Print first column
    awk -F ":" '{print $1}' /etc/passwd  # Print usernames
    awk '{sum += $1} END {print sum}' numbers.txt  # Sum first column
    
    # SED (stream editor)
    sed 's/old/new/' file.txt      # Replace first occurrence per line
    sed 's/old/new/g' file.txt     # Replace ALL occurrences
    sed -i 's/old/new/g' file.txt  # Edit file in place
    sed '5d' file.txt              # Delete line 5
    sed '/pattern/d' file.txt      # Delete lines matching pattern
```

---

## 5. File Permissions & Ownership

### Understanding Permissions

```
    PERMISSION FORMAT:  rwxrwxrwx
    
    ┌─────┬─────┬─────┐
    │ rwx │ rwx │ rwx │
    │User │Group│Other│
    │Owner│     │     │
    └──┬──┴──┬──┴──┬──┘
       │     │     │
       │     │     └── Others: everyone else
       │     └── Group: members of file's group
       └── Owner: file's owner
    
    r = read    (4)  → Can view contents
    w = write   (2)  → Can modify contents
    x = execute (1)  → Can run as program
    - = no perm (0)  → Permission denied
    
    NUMERIC (OCTAL) REPRESENTATION:
    ┌─────────────────────────────────────────────┐
    │  rwx = 4+2+1 = 7  (full permissions)        │
    │  rw- = 4+2+0 = 6  (read + write)            │
    │  r-x = 4+0+1 = 5  (read + execute)          │
    │  r-- = 4+0+0 = 4  (read only)               │
    │  --- = 0+0+0 = 0  (no permissions)           │
    └─────────────────────────────────────────────┘
    
    COMMON PERMISSIONS:
    ┌────────┬──────────┬───────────────────────────┐
    │ Octal  │ Symbolic │ Meaning                   │
    ├────────┼──────────┼───────────────────────────┤
    │  755   │ rwxr-xr-x│ Owner:all, Others:r+x     │
    │  644   │ rw-r--r--│ Owner:rw, Others:read      │
    │  700   │ rwx------│ Owner only, full access    │
    │  777   │ rwxrwxrwx│ Everyone: full access ⚠️   │
    │  600   │ rw-------│ Owner:rw only              │
    │  444   │ r--r--r--│ Read-only for everyone     │
    └────────┴──────────┴───────────────────────────┘
```

### Changing Permissions & Ownership

```bash
    # CHMOD — Change Permissions
    
    # NUMERIC METHOD:
    chmod 755 script.sh          # rwxr-xr-x
    chmod 644 file.txt           # rw-r--r--
    chmod 700 secret/            # rwx------ (owner only)
    chmod 600 private.key        # rw------- (sensitive files)
    
    # SYMBOLIC METHOD:
    chmod u+x script.sh          # Add execute for user (owner)
    chmod g+w file.txt           # Add write for group
    chmod o-r file.txt           # Remove read for others
    chmod a+r file.txt           # Add read for all (a = all)
    chmod u+rwx,g+rx,o+rx file   # Same as 755
    chmod -R 755 mydir/          # Recursive (apply to all inside)
    
    # CHOWN — Change Ownership
    chown alice file.txt         # Change owner to alice
    chown alice:staff file.txt   # Change owner AND group
    chown :staff file.txt        # Change group only
    chown -R alice:staff dir/    # Recursive ownership change
    
    # CHGRP — Change Group
    chgrp developers file.txt    # Change group
    chgrp -R developers dir/     # Recursive group change
```

### Special Permissions

```
    ┌──────────────────────────────────────────────────────────┐
    │                 SPECIAL PERMISSIONS                       │
    ├──────────────────────────────────────────────────────────┤
    │                                                          │
    │  SUID (Set User ID) — 4xxx                              │
    │  When set on executable, it runs with OWNER's privileges │
    │  Example: /usr/bin/passwd has SUID → runs as root        │
    │  chmod 4755 program   →  -rwsr-xr-x                     │
    │  The 's' replaces 'x' in user position                   │
    │                                                          │
    │  SGID (Set Group ID) — 2xxx                             │
    │  File: runs with GROUP's privileges                      │
    │  Directory: new files inherit directory's group           │
    │  chmod 2755 dir/      →  drwxr-sr-x                     │
    │                                                          │
    │  STICKY BIT — 1xxx                                      │
    │  On directory: only file OWNER can delete their files    │
    │  Example: /tmp has sticky bit — users can't delete       │
    │  others' files                                           │
    │  chmod 1777 /tmp      →  drwxrwxrwt                     │
    │  The 't' replaces 'x' in other position                  │
    │                                                          │
    └──────────────────────────────────────────────────────────┘
```

---

## 6. User & Group Management

```bash
    # USER MANAGEMENT
    whoami                       # Show current username
    id                           # Show UID, GID, groups
    id alice                     # Show alice's info
    
    # CREATE/MODIFY/DELETE USERS (requires root/sudo)
    sudo useradd alice           # Create user (basic)
    sudo useradd -m -s /bin/bash alice  # Create with home dir & shell
    sudo usermod -aG sudo alice  # Add alice to sudo group
    sudo usermod -l newname old  # Rename user
    sudo userdel alice           # Delete user
    sudo userdel -r alice        # Delete user + home directory
    
    # PASSWORD
    passwd                       # Change own password
    sudo passwd alice            # Change alice's password (as root)
    
    # GROUP MANAGEMENT
    groups                       # Show current user's groups
    groups alice                 # Show alice's groups
    sudo groupadd developers     # Create group
    sudo groupdel developers     # Delete group
    sudo usermod -aG developers alice  # Add alice to developers group
    sudo gpasswd -d alice developers   # Remove alice from group
    
    # SWITCH USER
    su alice                     # Switch to alice (need alice's password)
    su -                         # Switch to root
    sudo command                 # Run single command as root
    sudo -i                      # Open root shell
    
    # IMPORTANT FILES
    cat /etc/passwd              # User accounts info
    cat /etc/shadow              # Encrypted passwords (root only)
    cat /etc/group               # Group info
```

### /etc/passwd Format

```
    alice:x:1001:1001:Alice Smith:/home/alice:/bin/bash
    ─────┬─┬────┬────┬───────────┬───────────┬─────────
         │ │    │    │           │           │
         │ │    │    │           │           └─ Login shell
         │ │    │    │           └─ Home directory
         │ │    │    └─ GECOS (full name/info)
         │ │    └─ GID (primary group ID)
         │ └─ UID (user ID)
         └─ Password (x = stored in /etc/shadow)
    Username
```

---

## 7. Process Management

```bash
    # VIEW PROCESSES
    ps                           # Show current user's processes
    ps aux                       # Show ALL processes (detailed)
    ps -ef                       # Another format for all processes
    ps aux | grep nginx          # Find specific process
    
    # TOP / HTOP (real-time process monitor)
    top                          # Real-time process viewer
    htop                         # Enhanced version (install separately)
    
    # PROCESS INFORMATION
    # ps aux output columns:
    # USER  PID  %CPU  %MEM  VSZ  RSS  TTY  STAT  START  TIME  COMMAND
    
    # BACKGROUND & FOREGROUND
    command &                    # Run in background
    jobs                         # List background jobs
    fg %1                        # Bring job 1 to foreground
    bg %1                        # Resume stopped job in background
    Ctrl+Z                       # Suspend (stop) current process
    Ctrl+C                       # Kill (interrupt) current process
    
    # KILL PROCESSES
    kill PID                     # Send SIGTERM (graceful stop)
    kill -9 PID                  # Send SIGKILL (force kill)
    kill -15 PID                 # Send SIGTERM (same as kill PID)
    killall process_name         # Kill all processes by name
    pkill -f "pattern"           # Kill by pattern match
    
    # SIGNAL REFERENCE
    # SIGHUP  (1)  — Hangup (terminal closed)
    # SIGINT  (2)  — Interrupt (Ctrl+C)
    # SIGKILL (9)  — Force kill (cannot be caught)
    # SIGTERM (15) — Graceful termination (default)
    # SIGSTOP (19) — Pause process (Ctrl+Z)
    # SIGCONT (18) — Resume paused process
    
    # PROCESS PRIORITY (NICE)
    nice -n 10 command           # Start with lower priority (10)
    nice -n -10 command          # Start with higher priority (-10, root only)
    renice -n 5 -p PID           # Change running process priority
    # Nice values: -20 (highest priority) to 19 (lowest priority)
    
    # SYSTEM INFO
    uptime                       # System uptime and load average
    free -h                      # Memory usage (human readable)
    vmstat                       # Virtual memory statistics
    lscpu                        # CPU information
    uname -a                     # System/kernel information
```

---

## 8. Disk & Storage Commands

```bash
    # DISK USAGE
    df -h                        # Disk space usage (human readable)
    df -hT                       # Include filesystem type
    du -sh /home/alice           # Directory size (summary)
    du -sh *                     # Size of each item in current dir
    du -h --max-depth=1          # Size of subdirectories (1 level)
    
    # DISK PARTITIONS
    lsblk                        # List block devices (disks & partitions)
    fdisk -l                     # Detailed partition info (root)
    blkid                        # Show UUIDs of partitions
    
    # MOUNT/UNMOUNT
    mount /dev/sdb1 /mnt/usb     # Mount USB drive
    umount /mnt/usb              # Unmount
    mount                        # Show all mounted filesystems
    cat /etc/fstab               # Auto-mount configuration
    
    # FILE SYSTEM OPERATIONS
    mkfs.ext4 /dev/sdb1          # Format partition as ext4
    fsck /dev/sda1               # Check & repair filesystem
    
    # ARCHIVE & COMPRESS
    tar -cvf archive.tar dir/       # Create tar archive
    tar -xvf archive.tar            # Extract tar archive
    tar -czvf archive.tar.gz dir/   # Create gzipped tar
    tar -xzvf archive.tar.gz        # Extract gzipped tar
    tar -cjvf archive.tar.bz2 dir/  # Create bzip2 tar
    
    gzip file.txt                # Compress (replaces original)
    gunzip file.txt.gz           # Decompress
    zip archive.zip file1 file2  # Create zip archive
    unzip archive.zip            # Extract zip archive
```

---

## 9. Networking Commands

```bash
    # NETWORK INFORMATION
    ip addr                      # Show IP addresses (modern)
    ifconfig                     # Show IP addresses (legacy)
    hostname                     # Show hostname
    hostname -I                  # Show IP address only
    
    # CONNECTIVITY
    ping google.com              # Test connectivity (Ctrl+C to stop)
    ping -c 4 google.com         # Send exactly 4 pings
    traceroute google.com        # Trace route to destination
    
    # DNS
    nslookup google.com          # DNS lookup
    dig google.com               # Detailed DNS lookup
    host google.com              # Simple DNS lookup
    
    # PORT & CONNECTION INFO
    netstat -tuln                # Show listening ports
    ss -tuln                     # Modern alternative to netstat
    ss -tp                       # Show established connections
    
    # DOWNLOAD
    wget https://example.com/file    # Download file
    wget -O output.txt URL           # Download with custom name
    curl https://example.com         # Fetch URL content
    curl -O https://example.com/file # Download file
    curl -I https://example.com      # Show HTTP headers only
    
    # REMOTE ACCESS
    ssh user@hostname                # Connect via SSH
    ssh -p 2222 user@hostname        # SSH on custom port
    scp file.txt user@host:/path/    # Copy file to remote
    scp user@host:/path/file.txt .   # Copy file from remote
    scp -r dir/ user@host:/path/     # Copy directory recursively
    
    # FIREWALL (ufw — Ubuntu)
    sudo ufw status              # Check firewall status
    sudo ufw enable              # Enable firewall
    sudo ufw allow 22            # Allow SSH port
    sudo ufw allow 80/tcp        # Allow HTTP
    sudo ufw deny 3306           # Block MySQL port
```

---

## 10. Package Management

```bash
    ┌─────────────────────────────────────────────────────────────┐
    │        DEBIAN/UBUNTU (apt)    │     RHEL/CentOS (yum/dnf)  │
    ├──────────────────────────────┼──────────────────────────────┤
    │ sudo apt update              │ sudo yum update              │
    │ (refresh package list)       │ (update all packages)        │
    ├──────────────────────────────┼──────────────────────────────┤
    │ sudo apt install nginx       │ sudo yum install nginx       │
    │ (install package)            │ (install package)            │
    ├──────────────────────────────┼──────────────────────────────┤
    │ sudo apt remove nginx        │ sudo yum remove nginx        │
    │ (remove package)             │ (remove package)             │
    ├──────────────────────────────┼──────────────────────────────┤
    │ sudo apt upgrade             │ sudo yum upgrade             │
    │ (upgrade all packages)       │ (upgrade all packages)       │
    ├──────────────────────────────┼──────────────────────────────┤
    │ apt search keyword           │ yum search keyword           │
    │ (search for package)         │ (search for package)         │
    ├──────────────────────────────┼──────────────────────────────┤
    │ apt show nginx               │ yum info nginx               │
    │ (show package info)          │ (show package info)          │
    ├──────────────────────────────┼──────────────────────────────┤
    │ dpkg -l                      │ rpm -qa                      │
    │ (list installed packages)    │ (list installed packages)    │
    └──────────────────────────────┴──────────────────────────────┘
```

---

## 11. Shell Scripting Basics

### Your First Script

```bash
    #!/bin/bash
    # This is a comment
    # The first line (shebang) tells the system which interpreter to use
    
    echo "Hello, World!"
    
    # Save as: hello.sh
    # Make executable: chmod +x hello.sh
    # Run: ./hello.sh
```

### Variables

```bash
    #!/bin/bash
    
    # VARIABLES (no spaces around =)
    name="Alice"
    age=25
    
    echo "Name: $name"
    echo "Age: $age"
    
    # READ USER INPUT
    echo "Enter your name:"
    read user_name
    echo "Hello, $user_name!"
    
    # COMMAND SUBSTITUTION
    current_date=$(date)
    file_count=$(ls | wc -l)
    echo "Date: $current_date"
    echo "Files in current dir: $file_count"
    
    # SPECIAL VARIABLES
    echo $0          # Script name
    echo $1          # First argument
    echo $#          # Number of arguments
    echo $?          # Exit status of last command (0=success)
    echo $$          # Current process ID
    echo $@          # All arguments
```

### Conditionals

```bash
    #!/bin/bash
    
    # IF-ELSE
    age=18
    
    if [ $age -ge 18 ]; then
        echo "Adult"
    elif [ $age -ge 13 ]; then
        echo "Teenager"
    else
        echo "Child"
    fi
    
    # COMPARISON OPERATORS:
    # -eq  equal           -ne  not equal
    # -gt  greater than    -lt  less than
    # -ge  greater/equal   -le  less/equal
    
    # STRING COMPARISON:
    # =   equal            !=  not equal
    # -z  empty string     -n  non-empty string
    
    # FILE TESTS:
    if [ -f "file.txt" ]; then echo "File exists"; fi
    if [ -d "mydir" ]; then echo "Directory exists"; fi
    if [ -r "file.txt" ]; then echo "File is readable"; fi
    if [ -w "file.txt" ]; then echo "File is writable"; fi
    if [ -x "script.sh" ]; then echo "File is executable"; fi
```

### Loops

```bash
    #!/bin/bash
    
    # FOR LOOP
    for i in 1 2 3 4 5; do
        echo "Number: $i"
    done
    
    # FOR LOOP (C-style)
    for ((i=1; i<=10; i++)); do
        echo "Count: $i"
    done
    
    # FOR LOOP (iterate files)
    for file in *.txt; do
        echo "Processing: $file"
    done
    
    # WHILE LOOP
    count=1
    while [ $count -le 5 ]; do
        echo "Count: $count"
        count=$((count + 1))
    done
    
    # READ FILE LINE BY LINE
    while IFS= read -r line; do
        echo "Line: $line"
    done < input.txt
```

### Functions

```bash
    #!/bin/bash
    
    # DEFINE FUNCTION
    greet() {
        local name=$1    # local variable
        echo "Hello, $name!"
    }
    
    # CALL FUNCTION
    greet "Alice"
    greet "Bob"
    
    # FUNCTION WITH RETURN VALUE
    add() {
        local result=$(( $1 + $2 ))
        echo $result     # Functions "return" via echo
    }
    
    sum=$(add 5 3)
    echo "Sum: $sum"     # Output: Sum: 8
```

### Piping & Redirection

```bash
    # OUTPUT REDIRECTION
    echo "Hello" > file.txt      # Overwrite file
    echo "World" >> file.txt     # Append to file
    command 2> error.log         # Redirect stderr to file
    command > out.txt 2>&1       # Redirect both stdout & stderr
    command &> all.log           # Shorthand for above
    
    # INPUT REDIRECTION
    sort < unsorted.txt          # Read input from file
    
    # PIPING (output of one → input of next)
    cat file.txt | grep "error" | wc -l
    #     ↓              ↓           ↓
    # read file → filter errors → count lines
    
    ps aux | grep "python" | awk '{print $2}' | xargs kill
    #   ↓          ↓              ↓                 ↓
    # all procs → find python → get PIDs → kill them
    
    # TEE (write to file AND stdout)
    command | tee output.txt     # Show on screen + save to file
    command | tee -a output.txt  # Append mode
```

---

## 12. Quick Summary

```
┌────────────────────────────────────────────────────────────────┐
│                 CHAPTER 9: QUICK REVISION                       │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  NAVIGATION: pwd, cd, ls                                       │
│  FILES: touch, cp, mv, rm, ln, cat, head, tail, less          │
│  SEARCH: grep, find, locate                                   │
│  TEXT: sort, uniq, cut, awk, sed, wc                          │
│                                                                │
│  PERMISSIONS:                                                  │
│  ★ rwxrwxrwx = User|Group|Other                               │
│  ★ r=4, w=2, x=1 → chmod 755 = rwxr-xr-x                    │
│  ★ chown user:group file — change ownership                    │
│  ★ SUID(4xxx), SGID(2xxx), Sticky(1xxx)                      │
│                                                                │
│  USERS: useradd, usermod, userdel, passwd, su, sudo           │
│  PROCESSES: ps, top, kill, nice, bg, fg, jobs                 │
│  DISK: df, du, mount, tar, gzip, fdisk, lsblk                │
│  NETWORK: ping, ssh, scp, curl, wget, ip, netstat, ss        │
│  PACKAGES: apt (Debian), yum/dnf (RHEL)                      │
│                                                                │
│  SHELL SCRIPTING:                                              │
│  ★ #!/bin/bash (shebang)                                      │
│  ★ Variables: name="value", $name                              │
│  ★ if [ condition ]; then ... fi                               │
│  ★ for/while loops                                             │
│  ★ > overwrite, >> append, | pipe, 2> stderr                  │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 📝 Practice Questions

### 🟢 Level 1: One-Line Answer Questions

| # | Question | Answer |
|---|----------|--------|
| 1 | What command shows your current directory? | `pwd` (print working directory) |
| 2 | How to list all files including hidden ones? | `ls -la` or `ls -a` |
| 3 | What does `chmod 755 file.sh` do? | Sets permissions to rwxr-xr-x (owner full, group & others read+execute). |
| 4 | How to search for "error" in a file? | `grep "error" filename` |
| 5 | What signal does `kill -9` send? | SIGKILL — forces immediate process termination (cannot be caught). |
| 6 | What does the `df -h` command show? | Disk space usage of all mounted filesystems in human-readable format. |
| 7 | How to create a symbolic link? | `ln -s target linkname` |
| 8 | What is the shebang line in a bash script? | `#!/bin/bash` — tells the system which interpreter to use. |
| 9 | What command downloads a file from the internet? | `wget URL` or `curl -O URL` |
| 10 | What does `tail -f logfile` do? | Continuously shows new lines appended to the file in real-time. |

---

### 🟡 Level 2: Multiple Choice Questions

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Which directory stores user home directories? | A) /root B) /usr C) **/home** D) /etc | **C** |
| 2 | `chmod 644 file.txt` gives: | A) rwxr--r-- B) **rw-r--r--** C) rw-rw-rw- D) rwxrwxrwx | **B** |
| 3 | To find files by name recursively: | A) grep B) **find** C) locate D) ls | **B** (find . -name "...") |
| 4 | The pipe operator `\|` does: | A) Redirects to file B) **Sends stdout to next command's stdin** C) Runs in background D) Creates alias | **B** |
| 5 | Which command shows real-time process info? | A) ps B) **top** C) ls D) df | **B** |
| 6 | To append text to a file: | A) > B) **>>** C) < D) \| | **B** |
| 7 | SUID permission is represented by: | A) 1xxx B) 2xxx C) **4xxx** D) 7xxx | **C** |
| 8 | Which command compresses a directory into tar.gz? | A) zip -r B) gzip C) **tar -czvf** D) compress | **C** |
| 9 | SSH uses port: | A) 80 B) 443 C) 21 D) **22** | **D** |
| 10 | To install a package on Ubuntu: | A) yum install B) **apt install** C) rpm -i D) pacman -S | **B** |

---

### 🔴 Level 3: Tricky Conceptual MCQs

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | `rm -rf /` will: | A) Remove root user B) **Delete all files on system** C) Restart system D) Nothing | **B** | Recursively force-deletes everything from root — catastrophic! |
| 2 | Hard link vs Soft link: if original is deleted, which breaks? | A) Hard link B) **Soft link** C) Both D) Neither | **B** | Hard link shares inode (survives deletion). Soft link points to path (becomes dangling). |
| 3 | What does `2>&1` mean? | A) Run 2 commands B) **Redirect stderr to stdout** C) Background process D) Pipe | **B** | File descriptor 2 (stderr) is redirected to where 1 (stdout) goes. |
| 4 | Sticky bit on /tmp means: | A) Files are read-only B) **Only file owner can delete their files** C) No one can write D) Root only | **B** | Prevents users from deleting other users' files in shared directories. |
| 5 | `find . -perm -4000` finds files with: | A) 4KB size B) **SUID bit set** C) 400 permissions D) Created 4000 days ago | **B** | -4000 means "at least SUID bit set" — important for security auditing. |

---

### 🔵 Level 4: True / False

| # | Statement | Answer | Explanation |
|---|-----------|--------|-------------|
| 1 | The root user's home directory is /home/root. | **False** | Root's home is `/root`, not `/home/root`. |
| 2 | `grep -r` searches recursively through directories. | **True** | -r flag enables recursive search through all subdirectories. |
| 3 | `kill` command always forcefully terminates a process. | **False** | Default `kill` sends SIGTERM (graceful). Only `kill -9` (SIGKILL) forces termination. |
| 4 | A symbolic link can point to a file on another filesystem. | **True** | Symbolic links store paths, so they work across filesystems (unlike hard links). |
| 5 | In bash, variable assignment requires spaces around `=`. | **False** | No spaces allowed: `name="Alice"` is correct. `name = "Alice"` is wrong. |
| 6 | `/etc/shadow` is readable by all users. | **False** | `/etc/shadow` stores encrypted passwords and is readable only by root. |
| 7 | The `nice` value -20 gives a process the HIGHEST priority. | **True** | Nice ranges from -20 (highest priority) to 19 (lowest priority). |
| 8 | `>>` overwrites file contents. | **False** | `>>` appends to file. `>` overwrites. |
| 9 | `apt` and `yum` are package managers for the same distro family. | **False** | `apt` is for Debian/Ubuntu. `yum` is for RHEL/CentOS/Fedora. |
| 10 | `chmod 777` is considered good security practice. | **False** | 777 gives everyone full access — it's a security risk and should be avoided. |

---

### 🟣 Level 5: Scenario-Based Questions

**Scenario 1:**
> You need to find all `.log` files larger than 100MB in `/var/log`, compress them, and delete the originals. Write the commands.

**Answer:**
```bash
# Method 1: Step by step
find /var/log -name "*.log" -size +100M -exec gzip {} \;

# Method 2: Find, compress, and verify
find /var/log -name "*.log" -size +100M | while read f; do
    gzip "$f"
    echo "Compressed: $f"
done
```

---

**Scenario 2:**
> A process is consuming 95% CPU. How do you identify it and handle it?

**Answer:**
```bash
# Step 1: Identify the process
top                                  # Look at top CPU consumers
# or
ps aux --sort=-%cpu | head -5        # Top 5 CPU-consuming processes

# Step 2: Get more info about the process (e.g., PID 1234)
ps -p 1234 -o pid,ppid,cmd,%cpu,%mem

# Step 3: Option A — Lower its priority
sudo renice -n 19 -p 1234           # Set to lowest priority

# Step 3: Option B — Graceful stop
kill 1234                            # Send SIGTERM

# Step 3: Option C — Force kill (if unresponsive)
kill -9 1234                         # Send SIGKILL
```

---

**Scenario 3:**
> Set up a directory `/project` where: all files belong to group "devteam", new files automatically inherit the group, and users can only delete their own files.

**Answer:**
```bash
# Create directory and set group
sudo mkdir /project
sudo chgrp devteam /project

# Set SGID (new files inherit group) + Sticky bit (own files only)
sudo chmod 3770 /project
# 3 = SGID(2) + Sticky(1)
# 770 = rwxrwx---

# Verify
ls -ld /project
# drwxrws--T 2 root devteam 4096 ... /project
# s = SGID, T = sticky (no execute for others)
```

---

**Scenario 4:**
> Write a bash script that takes a directory as an argument and counts the number of files of each type (regular files, directories, symlinks).

**Answer:**
```bash
#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dir="$1"
files=$(find "$dir" -maxdepth 1 -type f | wc -l)
dirs=$(find "$dir" -maxdepth 1 -type d | wc -l)
dirs=$((dirs - 1))  # Subtract the directory itself
links=$(find "$dir" -maxdepth 1 -type l | wc -l)

echo "Directory: $dir"
echo "Regular files: $files"
echo "Directories: $dirs"  
echo "Symbolic links: $links"
```

---

**Scenario 5:**
> You need to monitor a web server's access log for any 500 errors in real-time and send an alert. Write the command pipeline.

**Answer:**
```bash
# Real-time monitoring for HTTP 500 errors
tail -f /var/log/nginx/access.log | grep --line-buffered " 500 " | while read line; do
    echo "[ALERT $(date)] 500 Error detected: $line" >> /tmp/alerts.log
    echo "$line" | mail -s "500 Error Alert" admin@example.com
done

# Simpler version (just watch for 500s):
tail -f /var/log/nginx/access.log | grep --color " 500 "
```

---

### 🟤 Level 6: Advanced Real-World DevOps & SRE Questions

**Q1. A production Linux server is running out of disk space. Write a complete diagnostic and cleanup procedure.**

**Answer:**
```bash
# Step 1: Identify where space is consumed
df -h                              # Check disk usage by partition
du -sh /* 2>/dev/null | sort -hr | head -20   # Top 20 largest directories

# Step 2: Find large files
find / -type f -size +1G 2>/dev/null | xargs ls -lh | sort -k5 -hr

# Step 3: Find old log files
find /var/log -name "*.log" -mtime +30 -exec ls -lh {} \;

# Step 4: Check for deleted-but-open files (space not freed!)
lsof | grep deleted | awk '{print $7, $1, $2}' | sort -hr | head -10
# Files deleted but held open by processes won't free space until process closes them!

# Step 5: Cleanup actions
# Clear old journal logs (systemd)
sudo journalctl --vacuum-time=7d    # Keep only last 7 days

# Remove old kernels (Ubuntu/Debian)
sudo apt autoremove

# Clear package cache
sudo apt clean                      # Debian/Ubuntu
sudo yum clean all                  # RHEL/CentOS

# Truncate large log files safely
sudo truncate -s 0 /var/log/nginx/access.log   # Zero out (safer than delete)

# Step 6: Find and remove core dumps
find / -name "core" -type f 2>/dev/null | xargs ls -lh
```

---

**Q2. Write a script to automatically monitor Apache/Nginx and restart it if it crashes.**

**Answer:**
```bash
#!/bin/bash
# Service watchdog — monitors nginx and restarts on failure
# Save as: /usr/local/bin/watchdog.sh

SERVICE="nginx"
LOG_FILE="/var/log/watchdog.log"
CHECK_INTERVAL=30  # seconds

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

while true; do
    if ! systemctl is-active --quiet "$SERVICE"; then
        log "WARNING: $SERVICE is NOT running. Attempting restart..."
        
        if systemctl restart "$SERVICE"; then
            log "SUCCESS: $SERVICE restarted successfully"
        else
            log "ERROR: Failed to restart $SERVICE"
            # Send alert
            echo "$SERVICE restart failed on $(hostname)" | \
                mail -s "Service Alert" admin@example.com
        fi
    else
        log "OK: $SERVICE is running (PID: $(pgrep -x $SERVICE | head -1))"
    fi
    
    sleep "$CHECK_INTERVAL"
done
```

**Systemd service unit for the watchdog**:
```ini
# /etc/systemd/system/nginx-watchdog.service
[Unit]
Description=Nginx Watchdog Service
After=network.target nginx.service

[Service]
Type=simple
ExecStart=/usr/local/bin/watchdog.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

---

**Q3. Explain Linux file descriptor internals with a real-world example (web server handling 10,000 connections).**

**Answer:**

```
Linux File Descriptor Architecture:

Per-process file descriptor table (in PCB/task_struct):
┌────┬─────────────────────────────────────────────┐
│ FD │ Pointer to system-wide open file table       │
├────┼─────────────────────────────────────────────┤
│  0 │ → stdin  (terminal)                          │
│  1 │ → stdout (terminal)                          │
│  2 │ → stderr (terminal)                          │
│  3 │ → socket (connection from client 1)          │
│  4 │ → socket (connection from client 2)          │
│ ...|  ...                                         │
│ 9999│ → socket (connection from client 9997)      │
└────┴─────────────────────────────────────────────┘

System-wide open file table (kernel):
• Each entry: file position, access mode, ref count, inode pointer

Inode table:
• For sockets: no inode — kernel socket structure instead
```

**Practical limits and tuning for 10,000 connections**:
```bash
# Check current per-process FD limit
ulimit -n
# Default: 1024 — NOT enough for 10,000 connections!

# Increase for current shell
ulimit -n 65536

# Permanent system-wide increase
echo "nginx soft nofile 65536" >> /etc/security/limits.conf
echo "nginx hard nofile 65536" >> /etc/security/limits.conf

# Check system-wide maximum
cat /proc/sys/fs/file-max            # Total FDs across all processes

# Check current open FDs for nginx
ls /proc/$(pgrep nginx | head -1)/fd | wc -l
```

**Why this matters**: nginx handling 10,000 connections needs at least 10,003 FDs (3 standard + 10,000 sockets). The default limit of 1024 would cause `EMFILE: too many open files` error at the 1022nd connection.

---

**Q4. Write a bash script to analyze system performance and generate a health report.**

**Answer:**
```bash
#!/bin/bash
# System health report generator
# Usage: ./health_report.sh > report_$(date +%Y%m%d).txt

echo "============================================"
echo "SYSTEM HEALTH REPORT - $(date)"
echo "Host: $(hostname) | OS: $(uname -r)"
echo "============================================"

echo ""
echo "=== CPU INFORMATION ==="
echo "CPU Model: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)"
echo "CPU Cores: $(nproc)"
echo "Load Average (1/5/15 min): $(uptime | awk -F'load average:' '{print $2}')"
echo "CPU Usage: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')% used"

echo ""
echo "=== MEMORY INFORMATION ==="
free -h | awk '
NR==1 {print "           " $0}
NR==2 {printf "RAM:       %s total | %s used | %s free\n", $2, $3, $4}
NR==3 {printf "Swap:      %s total | %s used | %s free\n", $2, $3, $4}'

echo ""
echo "=== DISK USAGE ==="
df -h | awk 'NR==1 || $5+0 >= 70 {
    if (NR==1) print $0
    else printf "%-20s %6s %6s %6s %5s  %s\n", $1, $2, $3, $4, $5, $6
}'
echo "(Showing partitions ≥ 70% full)"

echo ""
echo "=== TOP 5 CPU-CONSUMING PROCESSES ==="
ps aux --sort=-%cpu | head -6 | awk '{printf "%-8s %-6s %-5s %-5s %s\n", $1, $2, $3, $4, $11}'

echo ""
echo "=== TOP 5 MEMORY-CONSUMING PROCESSES ==="
ps aux --sort=-%mem | head -6 | awk '{printf "%-8s %-6s %-5s %-5s %s\n", $1, $2, $3, $4, $11}'

echo ""
echo "=== NETWORK CONNECTIONS ==="
echo "Established: $(ss -s | grep 'estab' | awk '{print $4}')"
echo "Listening: $(ss -tlnp | grep LISTEN | wc -l) services"

echo ""
echo "=== RECENT ERRORS (last 20 from syslog) ==="
journalctl -p err --since "1 hour ago" --no-pager | tail -20

echo ""
echo "=== REPORT COMPLETE ==="
```

---

**Q5. How does Linux `cgroups` (control groups) work, and how does Docker use it?**

**Answer:**

```
cgroup hierarchy (v1):
/sys/fs/cgroup/
├── cpu/                    ← CPU scheduler control
│   ├── cpu.shares          ← Relative CPU priority (default: 1024)
│   ├── cpu.cfs_quota_us    ← Maximum CPU in microseconds per period
│   ├── cpu.cfs_period_us   ← Period for quota (default: 100ms)
│   └── docker/
│       └── <container_id>/
│           ├── cpu.shares = 512   ← This container gets half default priority
│           └── tasks = 1234, 1235  ← PIDs in this cgroup
├── memory/                  ← Memory limits
│   └── docker/<id>/
│       ├── memory.limit_in_bytes = 268435456  ← 256 MB limit
│       └── memory.usage_in_bytes = 134217728  ← Currently using 128 MB
├── blkio/                   ← Block I/O limits
└── net_cls/                 ← Network traffic classification
```

**Docker run command mapped to cgroups**:
```bash
docker run \
    --cpus=0.5 \             # cpu.cfs_quota_us = 50000 (50ms per 100ms period)
    --memory=256m \           # memory.limit_in_bytes = 268435456
    --memory-swap=512m \      # memory.memsw.limit_in_bytes = 536870912
    --blkio-weight=300 \      # blkio.weight = 300 (default 500)
    nginx

# Verify cgroup settings
cat /sys/fs/cgroup/memory/docker/<containerid>/memory.limit_in_bytes
# 268435456

# See resource usage live
cat /sys/fs/cgroup/cpu/docker/<containerid>/cpuacct.usage
```

**Real-world impact**: Without cgroup limits, a single runaway container could consume all CPU/RAM on a node, crashing all other containers. cgroups prevent this — each container is guaranteed its stated resources and cannot exceed them.

---

**Q6. Linux interview: Write a one-liner to find the top 3 most-connected IP addresses to your web server.**

**Answer:**
```bash
# Method 1: From active TCP connections
ss -tn | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -3

# Method 2: From nginx access log
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head -3

# Method 3: netstat version
netstat -tn 2>/dev/null | grep :80 | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -3

# Example output:
#   1523 192.168.1.100    ← Potential DoS attacker!
#    342 10.0.0.5
#     89 172.16.0.12

# Block top attacker with iptables
iptables -A INPUT -s 192.168.1.100 -j DROP
```

**Real-world context**: During a DDoS (Distributed Denial of Service) attack, this one-liner quickly identifies attack sources. Combine with `fail2ban` to automatically block IPs making excessive requests.

---

> **← [Previous: 08 - Disk Scheduling](08_Disk_Scheduling.md) | [Next: 10 - Interview Preparation →](10_OS_Interview_Preparation.md)**
