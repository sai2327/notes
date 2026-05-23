# 🐧 Linux Mastery for Cybersecurity

## From First Boot to Linux Expert — The Complete Guide

---

## 📌 Table of Contents

1. [Introduction](#introduction)
2. [Why Linux for Cybersecurity](#why-linux-for-cybersecurity)
3. [Linux Architecture](#linux-architecture)
4. [Linux Distributions](#linux-distributions)
5. [File System Hierarchy](#file-system-hierarchy)
6. [Essential Commands — Deep Dive](#essential-commands--deep-dive)
7. [File Permissions](#file-permissions)
8. [Users and Groups](#users-and-groups)
9. [Process Management](#process-management)
10. [Package Management](#package-management)
11. [Networking Commands](#networking-commands)
12. [Bash Scripting](#bash-scripting)
13. [System Services](#system-services)
14. [Cron Jobs](#cron-jobs)
15. [SSH — Secure Shell](#ssh--secure-shell)
16. [Log Management](#log-management)
17. [System Monitoring](#system-monitoring)
18. [Linux Security Hardening](#linux-security-hardening)
19. [Exercises](#exercises)
20. [Labs](#labs)
21. [Interview Questions](#interview-questions)
22. [Common Mistakes](#common-mistakes)
23. [Summary](#summary)

---

## Introduction

Linux is the **backbone of cybersecurity**. Whether you're a penetration tester, SOC analyst, malware researcher, or cloud security engineer — Linux proficiency is non-negotiable.

This section takes you from "What is Linux?" to confidently administering systems, writing scripts, and understanding Linux internals that are critical for security work.

---

## Why Linux for Cybersecurity

| Reason | Explanation |
|--------|-------------|
| **Hacking tools run on Linux** | Kali, Parrot, and most security tools are Linux-native |
| **Servers run Linux** | ~80% of internet servers are Linux (your targets) |
| **Open source** | You can examine, modify, and understand the entire system |
| **Command-line power** | Automation, scripting, and efficiency |
| **Containers & Cloud** | Docker, Kubernetes, AWS — all Linux-based |
| **Forensics** | Most forensic tools run on Linux |
| **Customizable** | Build exactly the system you need |
| **Free** | No licensing costs for labs |

---

## Linux Architecture

```
┌────────────────────────────────────────────────────────────┐
│                    USER APPLICATIONS                         │
│          (Firefox, Python, Nmap, Metasploit)               │
├────────────────────────────────────────────────────────────┤
│                    SHELL (Bash/Zsh)                          │
│              Command interpreter interface                   │
├────────────────────────────────────────────────────────────┤
│                    SYSTEM LIBRARIES                          │
│              (glibc — GNU C Library)                        │
├────────────────────────────────────────────────────────────┤
│              SYSTEM CALL INTERFACE                           │
├────────────────────────────────────────────────────────────┤
│                    LINUX KERNEL                              │
│  ┌──────────┬──────────┬──────────┬────────────────────┐  │
│  │ Process  │ Memory   │  VFS     │  Network Stack     │  │
│  │ Scheduler│ Manager  │(Virtual  │  (TCP/IP, sockets) │  │
│  │          │          │File Sys) │                    │  │
│  ├──────────┼──────────┼──────────┼────────────────────┤  │
│  │ Device Drivers      │ Security │  IPC               │  │
│  │ (disk, network,USB) │(SELinux, │ (pipes, signals,   │  │
│  │                     │AppArmor) │  shared memory)    │  │
│  └─────────────────────┴──────────┴────────────────────┘  │
├────────────────────────────────────────────────────────────┤
│                    HARDWARE                                  │
│     (CPU, RAM, Disk, Network Card, USB, GPU)               │
└────────────────────────────────────────────────────────────┘
```

---

## Linux Distributions

| Distribution | Purpose | Best For |
|-------------|---------|----------|
| **Kali Linux** | Penetration testing | Offensive security |
| **Parrot Security** | Security + privacy | Alternative to Kali |
| **Ubuntu** | General purpose | Learning Linux, servers |
| **Debian** | Stability | Production servers |
| **CentOS/Rocky** | Enterprise | Corporate environments |
| **Arch Linux** | Customization | Advanced users |
| **REMnux** | Malware analysis | Reverse engineering |
| **SIFT** | Forensics | Digital forensics |
| **Security Onion** | Monitoring | Network security |

---

## File System Hierarchy

```
/                   Root — everything starts here
├── /bin            Essential binaries (ls, cp, cat, bash)
├── /boot           Kernel and bootloader files
├── /dev            Device files (hardware represented as files)
│   ├── /dev/sda    First hard disk
│   ├── /dev/null   Black hole (discards everything)
│   ├── /dev/zero   Infinite source of zeros
│   └── /dev/random Random number generator
├── /etc            System configuration files
│   ├── /etc/passwd User account information
│   ├── /etc/shadow Password hashes (restricted!)
│   ├── /etc/hosts  Static hostname resolution
│   └── /etc/ssh/   SSH configuration
├── /home           User home directories
│   └── /home/kali  Kali user's home
├── /lib            Shared libraries (like DLLs in Windows)
├── /media          Auto-mounted removable devices
├── /mnt            Manual mount points
├── /opt            Third-party software
├── /proc           Virtual filesystem — process information
│   ├── /proc/cpuinfo    CPU information
│   ├── /proc/meminfo    Memory information
│   └── /proc/[PID]/     Process-specific info
├── /root           Root user's home directory
├── /run            Runtime data (PIDs, sockets)
├── /sbin           System administration binaries
├── /srv            Service data (web, FTP)
├── /sys            Virtual filesystem — hardware info
├── /tmp            Temporary files (world-writable!)
├── /usr            User programs and libraries
│   ├── /usr/bin    User binaries
│   ├── /usr/lib    User libraries
│   ├── /usr/local  Locally compiled software
│   └── /usr/share  Architecture-independent data
└── /var            Variable data
    ├── /var/log    System logs (critical for forensics!)
    ├── /var/www    Web server document root
    └── /var/tmp    Persistent temporary files
```

> **🔴 Security-Critical Directories:**
> - `/etc/shadow` — Password hashes (privilege escalation target)
> - `/tmp` — World-writable (malware staging)
> - `/var/log` — Attacker evidence (often cleared by attackers)
> - `/proc` — Process information (enumeration)
> - `/dev/shm` — Shared memory (fileless malware)

---

## Essential Commands — Deep Dive

### Navigation Commands

#### `pwd` — Print Working Directory
```bash
# Shows your current location in the file system
pwd
# Output: /home/kali

# Security use: Verify you're in the correct directory before operations
```

#### `ls` — List Directory Contents
```bash
# Basic listing
ls

# Long format (permissions, owner, size, date)
ls -la

# Output explained:
# -rwxr-xr-x 1 root root 4096 Jan 15 10:30 filename
# │││ │││ │││ │    │     │    │            └── Name
# │││ │││ │││ │    │     │    └── Modified date
# │││ │││ │││ │    │     └── Size in bytes
# │││ │││ │││ │    └── Group owner
# │││ │││ │││ └── File owner
# │││ │││ │││
# │││ │││ └└└── Others: r-x (read+execute)
# │││ └└└── Group: r-x (read+execute)
# └└└── Owner: rwx (read+write+execute)
# └── File type: - (file) d (directory) l (link)

# Show hidden files
ls -la

# Sort by modification time (newest first)
ls -lt

# Sort by size (largest first)
ls -lS

# Recursive listing
ls -R

# Human-readable sizes
ls -lh

# Security use: Find SUID files
find / -perm -4000 -type f 2>/dev/null
```

#### `cd` — Change Directory
```bash
# Go to home directory
cd ~
cd

# Go to root
cd /

# Go up one level
cd ..

# Go to previous directory
cd -

# Go to absolute path
cd /etc/ssh

# Go to relative path
cd Documents/projects

# Security tip: Always know where you are!
```

### File Operations

#### `cat` — Concatenate and Display
```bash
# Display file contents
cat /etc/passwd

# Display with line numbers
cat -n /etc/passwd

# Display multiple files
cat file1.txt file2.txt

# Create a file (Ctrl+D to end)
cat > newfile.txt

# Append to a file
cat >> existingfile.txt

# Security use: Quick view of config files
cat /etc/ssh/sshd_config

# View password file (user enumeration)
cat /etc/passwd | cut -d: -f1
```

#### `grep` — Search Text Patterns
```bash
# Basic search
grep "root" /etc/passwd

# Case-insensitive search
grep -i "error" /var/log/syslog

# Recursive search in directory
grep -r "password" /etc/

# Show line numbers
grep -n "failed" /var/log/auth.log

# Invert match (show lines NOT matching)
grep -v "comment" config.txt

# Count matches
grep -c "error" /var/log/syslog

# Show context (3 lines before and after)
grep -B3 -A3 "error" /var/log/syslog

# Extended regex
grep -E "(error|warning|critical)" /var/log/syslog

# Security uses:
# Find passwords in files
grep -ri "password" /var/www/ 2>/dev/null

# Find failed login attempts
grep "Failed password" /var/log/auth.log

# Find SUID binaries
find / -perm -4000 2>/dev/null

# Search for IP addresses
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" access.log
```

#### `find` — Search for Files
```bash
# Find by name
find / -name "passwd"

# Find by name (case-insensitive)
find / -iname "*.conf"

# Find by type (f=file, d=directory)
find / -type f -name "*.log"

# Find by permissions
find / -perm -4000 -type f    # SUID files
find / -perm -2000 -type f    # SGID files
find / -perm -o+w -type d     # World-writable directories

# Find by owner
find / -user root -type f

# Find by modification time (last 24 hours)
find / -mtime -1

# Find by size (larger than 100MB)
find / -size +100M

# Find and execute command
find / -name "*.bak" -exec rm {} \;

# Security critical finds:
# SUID binaries (privilege escalation)
find / -perm -4000 -type f 2>/dev/null

# World-writable files
find / -perm -o+w -type f 2>/dev/null

# Files with no owner
find / -nouser -type f 2>/dev/null

# Recently modified files (last hour)
find / -mmin -60 -type f 2>/dev/null

# Hidden files
find / -name ".*" -type f 2>/dev/null

# Config files readable by all
find /etc -perm -o+r -type f 2>/dev/null
```

#### `awk` — Pattern Scanning and Processing
```bash
# Print specific columns
awk '{print $1}' file.txt          # First column
awk '{print $1, $3}' file.txt      # First and third columns

# Custom field separator
awk -F: '{print $1, $7}' /etc/passwd    # Username and shell

# Filter by condition
awk -F: '$3 >= 1000 {print $1}' /etc/passwd  # Users with UID >= 1000

# Sum a column
awk '{sum += $1} END {print sum}' numbers.txt

# Security uses:
# Extract usernames from passwd
awk -F: '{print $1}' /etc/passwd

# Find users with bash shell
awk -F: '$7 == "/bin/bash" {print $1}' /etc/passwd

# Parse Apache access log
awk '{print $1}' /var/log/apache2/access.log | sort | uniq -c | sort -rn

# Extract IP addresses with most requests
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -20
```

#### `sed` — Stream Editor
```bash
# Replace first occurrence per line
sed 's/old/new/' file.txt

# Replace ALL occurrences
sed 's/old/new/g' file.txt

# Replace in-place (modify file)
sed -i 's/old/new/g' file.txt

# Delete lines matching pattern
sed '/pattern/d' file.txt

# Print specific line range
sed -n '5,10p' file.txt

# Security uses:
# Remove comments from config
sed '/^#/d' config.file

# Sanitize log data
sed 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/[REDACTED]/g' log.txt
```

### File Manipulation

#### `cp` — Copy Files
```bash
# Copy file
cp source.txt destination.txt

# Copy directory recursively
cp -r /source/dir /dest/dir

# Preserve permissions and timestamps
cp -p important.conf backup.conf

# Interactive (confirm overwrite)
cp -i source.txt destination.txt

# Verbose
cp -v file.txt /backup/
```

#### `mv` — Move/Rename Files
```bash
# Move file
mv file.txt /new/location/

# Rename file
mv oldname.txt newname.txt

# Move multiple files to directory
mv file1.txt file2.txt /destination/

# Don't overwrite existing files
mv -n source.txt destination.txt
```

#### `rm` — Remove Files
```bash
# Remove file
rm file.txt

# Remove directory recursively
rm -r directory/

# Force remove (no confirmation)
rm -f file.txt

# Remove recursively with force
rm -rf directory/    # ⚠️ DANGEROUS — no recovery!

# Interactive (confirm each)
rm -i *.txt

# Security note: rm doesn't securely delete!
# Use shred for secure deletion:
shred -vfz -n 5 sensitive.txt
```

### Text Processing

#### `less` and `more` — Page Through Files
```bash
# View file with scrolling
less /var/log/syslog

# Navigation in less:
# Space/PgDn = next page
# b/PgUp = previous page
# /pattern = search forward
# ?pattern = search backward
# n = next match
# N = previous match
# g = go to beginning
# G = go to end
# q = quit
```

#### `head` and `tail` — View File Portions
```bash
# First 10 lines
head file.txt

# First N lines
head -n 20 file.txt

# Last 10 lines
tail file.txt

# Last N lines
tail -n 50 /var/log/auth.log

# Follow file in real-time (CRITICAL for monitoring!)
tail -f /var/log/syslog

# Follow multiple files
tail -f /var/log/auth.log /var/log/syslog

# Security use: Monitor login attempts in real-time
tail -f /var/log/auth.log | grep "Failed password"
```

#### `sort` and `uniq` — Organize Data
```bash
# Sort alphabetically
sort file.txt

# Sort numerically
sort -n numbers.txt

# Sort in reverse
sort -r file.txt

# Sort by specific column
sort -t: -k3 -n /etc/passwd    # Sort by UID

# Remove duplicates (requires sorted input)
sort file.txt | uniq

# Count occurrences
sort file.txt | uniq -c

# Sort by count (most frequent first)
sort file.txt | uniq -c | sort -rn

# Security use: Find most common source IPs in logs
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10
```

#### `wc` — Word Count
```bash
# Count lines, words, characters
wc file.txt

# Count only lines
wc -l file.txt

# Security use: Count failed login attempts
grep "Failed password" /var/log/auth.log | wc -l
```

---

## File Permissions

### Understanding Permission Notation

```
-rwxrw-r-- 1 alice developers 4096 Jan 15 10:30 script.sh
│ │││││││││
│ ││││││└└└── Others: r-- (read only)
│ │││└└└── Group: rw- (read + write)
│ └└└── Owner: rwx (read + write + execute)
└── Type: - (regular file)

File Types:
- = Regular file
d = Directory
l = Symbolic link
c = Character device
b = Block device
s = Socket
p = Named pipe (FIFO)
```

### Permission Values

| Permission | Symbol | Octal | Effect on File | Effect on Directory |
|-----------|--------|-------|----------------|-------------------|
| Read | r | 4 | View content | List contents |
| Write | w | 2 | Modify content | Create/delete files |
| Execute | x | 1 | Run as program | Enter directory |

### Octal Notation

```
rwx = 4+2+1 = 7
rw- = 4+2+0 = 6
r-x = 4+0+1 = 5
r-- = 4+0+0 = 4
--- = 0+0+0 = 0

Common permissions:
755 = rwxr-xr-x (programs, directories)
644 = rw-r--r-- (regular files)
600 = rw------- (private files)
777 = rwxrwxrwx (DANGEROUS — everyone can do anything)
```

### `chmod` — Change Permissions
```bash
# Octal notation
chmod 755 script.sh     # rwxr-xr-x
chmod 644 config.txt    # rw-r--r--
chmod 600 id_rsa        # rw------- (SSH private key)

# Symbolic notation
chmod u+x script.sh     # Add execute for owner
chmod g-w file.txt      # Remove write for group
chmod o-rwx secret.txt  # Remove all for others
chmod a+r file.txt      # Add read for all

# Recursive
chmod -R 755 /var/www/html/
```

### `chown` — Change Ownership
```bash
# Change owner
chown alice file.txt

# Change owner and group
chown alice:developers file.txt

# Recursive
chown -R www-data:www-data /var/www/

# Change group only
chgrp developers file.txt
```

### Special Permissions (CRITICAL for Security!)

| Permission | Octal | Symbol | Effect |
|-----------|-------|--------|--------|
| **SUID** | 4000 | `s` in owner execute | File runs as file owner |
| **SGID** | 2000 | `s` in group execute | File runs as file group |
| **Sticky Bit** | 1000 | `t` in others execute | Only owner can delete |

```bash
# SUID example (runs as root regardless of who executes)
-rwsr-xr-x 1 root root ... /usr/bin/passwd

# Set SUID
chmod u+s program
chmod 4755 program

# Find all SUID files (PRIVILEGE ESCALATION ENUMERATION!)
find / -perm -4000 -type f 2>/dev/null

# Common SUID binaries that can be abused:
# /usr/bin/find
# /usr/bin/vim
# /usr/bin/python3
# /usr/bin/nmap (old versions)
# /usr/bin/bash
```

> **🔴 SECURITY CRITICAL:** SUID binaries are a primary target for privilege escalation. If a SUID binary can be tricked into executing commands (like `find -exec`), an attacker gains root access. Always check GTFOBins (gtfobins.github.io) for exploitable SUID binaries.

---

## Users and Groups

### Important Files

| File | Purpose | Format |
|------|---------|--------|
| `/etc/passwd` | User account info | username:x:UID:GID:comment:home:shell |
| `/etc/shadow` | Password hashes | username:hash:lastchanged:min:max:warn:inactive:expire |
| `/etc/group` | Group info | groupname:x:GID:members |
| `/etc/sudoers` | Sudo privileges | user HOST=(RUNAS) COMMANDS |

### Reading /etc/passwd
```
root:x:0:0:root:/root:/bin/bash
│    │ │ │ │    │     └── Login shell
│    │ │ │ │    └── Home directory
│    │ │ │ └── Comment/Full name
│    │ │ └── Primary GID
│    │ └── UID (0 = root)
│    └── Password placeholder (actual in /etc/shadow)
└── Username
```

### Reading /etc/shadow
```
alice:$6$rounds=5000$salt$hash:18000:0:99999:7:::
│     │                        │     │ │     │
│     │                        │     │ │     └── Warning days
│     │                        │     │ └── Max password age
│     │                        │     └── Min password age
│     │                        └── Last changed (days since epoch)
│     └── Password hash ($6$ = SHA-512)
└── Username

Hash types:
$1$ = MD5 (weak!)
$5$ = SHA-256
$6$ = SHA-512
$y$ = yescrypt (modern)
$2b$ = bcrypt
```

### User Management Commands
```bash
# Add user
sudo useradd -m -s /bin/bash newuser
sudo passwd newuser

# Delete user
sudo userdel -r username    # -r removes home directory

# Modify user
sudo usermod -aG sudo username     # Add to sudo group
sudo usermod -s /bin/bash username # Change shell
sudo usermod -L username           # Lock account
sudo usermod -U username           # Unlock account

# View current user info
id
whoami
groups

# Switch user
su - username
sudo -u username command

# View logged-in users
who
w
last
lastlog
```

---

## Process Management

### Viewing Processes

```bash
# Snapshot of all processes
ps aux
# a = all users
# u = user-oriented format
# x = processes without terminal

# Real-time process monitor
top
htop    # Better version (may need to install)

# Process tree
pstree
pstree -p    # Show PIDs

# Find specific process
ps aux | grep apache2
pgrep -la apache2
```

### Understanding `ps aux` Output
```
USER    PID  %CPU %MEM    VSZ   RSS TTY   STAT START   TIME COMMAND
root      1   0.0  0.1 169572 13092 ?     Ss   Jan15   0:12 /sbin/init
www-data 841   0.1  0.5 274012 47124 ?     S    Jan15   1:23 apache2

STAT codes:
S = Sleeping (waiting for event)
R = Running
D = Uninterruptible sleep (usually I/O)
T = Stopped
Z = Zombie (finished but parent hasn't collected)
< = High priority
N = Low priority
s = Session leader
+ = Foreground process
```

### Process Control

```bash
# Kill by PID
kill PID           # Send SIGTERM (graceful)
kill -9 PID        # Send SIGKILL (force)
kill -15 PID       # SIGTERM explicitly

# Kill by name
killall process_name
pkill process_name

# Background/foreground
command &           # Run in background
Ctrl+Z             # Suspend current process
bg                 # Resume in background
fg                 # Bring to foreground
jobs               # List background jobs

# Signals
kill -l            # List all signals

# Common signals:
# SIGHUP (1)   = Hangup (reload config)
# SIGINT (2)   = Interrupt (Ctrl+C)
# SIGKILL (9)  = Force kill (cannot be caught)
# SIGTERM (15) = Graceful termination
# SIGSTOP (19) = Pause process
# SIGCONT (18) = Continue paused process
```

### Security-Relevant Process Commands

```bash
# Find processes running as root
ps aux | grep "^root"

# Find processes listening on network
ss -tlnp
netstat -tlnp

# Find process using a specific port
lsof -i :80
fuser 80/tcp

# View process environment variables (may contain secrets!)
cat /proc/[PID]/environ | tr '\0' '\n'

# View process command line
cat /proc/[PID]/cmdline | tr '\0' ' '

# View open files by process
lsof -p [PID]

# View process memory map
cat /proc/[PID]/maps
```

---

## Package Management

### Debian/Ubuntu (APT)

```bash
# Update package lists
sudo apt update

# Upgrade installed packages
sudo apt upgrade

# Install a package
sudo apt install nmap

# Remove a package
sudo apt remove nmap
sudo apt purge nmap      # Also remove config files

# Search for packages
apt search keyword

# Show package info
apt show nmap

# List installed packages
dpkg -l
apt list --installed

# Clean package cache
sudo apt autoremove
sudo apt clean

# Security: Check for security updates
sudo apt list --upgradable
```

### Red Hat/CentOS (YUM/DNF)

```bash
# Update all packages
sudo yum update
sudo dnf update

# Install
sudo yum install nmap
sudo dnf install nmap

# Remove
sudo yum remove nmap

# Search
yum search keyword
```

---

## Networking Commands

```bash
# View network interfaces
ip addr show
ip a
ifconfig         # Legacy but still common

# View routing table
ip route show
route -n         # Legacy

# DNS lookup
nslookup domain.com
dig domain.com
host domain.com

# View open connections
ss -tuln         # TCP/UDP listening ports
ss -tunap        # All connections with process info
netstat -tuln    # Legacy equivalent

# Test connectivity
ping -c 4 google.com
traceroute google.com
mtr google.com

# Download files
wget https://example.com/file.txt
curl -O https://example.com/file.txt

# Transfer files
scp file.txt user@host:/path/
rsync -avz /local/dir user@host:/remote/dir

# ARP table
arp -a
ip neigh

# Network statistics
ss -s            # Summary statistics
netstat -s       # Legacy

# Firewall (iptables)
sudo iptables -L -n          # List rules
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT  # Allow SSH

# Firewall (nftables/firewalld)
sudo nft list ruleset
sudo firewall-cmd --list-all

# Capture packets
sudo tcpdump -i eth0
sudo tcpdump -i eth0 port 80
sudo tcpdump -i eth0 -w capture.pcap
```

---

## Bash Scripting

### Script Basics

```bash
#!/bin/bash
# This is a comment
# The first line (shebang) tells the system which interpreter to use

# Variables
name="World"
echo "Hello, $name!"

# User input
read -p "Enter your name: " username
echo "Hello, $username"

# Command substitution
current_date=$(date)
echo "Today is: $current_date"

# Arithmetic
result=$((5 + 3))
echo "5 + 3 = $result"
```

### Control Structures

```bash
# If-else
if [ "$USER" = "root" ]; then
    echo "You are root!"
elif [ "$USER" = "kali" ]; then
    echo "You are kali!"
else
    echo "You are $USER"
fi

# Comparison operators
# -eq  equals
# -ne  not equals
# -lt  less than
# -gt  greater than
# -le  less than or equal
# -ge  greater than or equal
# =    string equals
# !=   string not equals
# -z   string is empty
# -n   string is not empty
# -f   file exists
# -d   directory exists
# -r   file is readable
# -w   file is writable
# -x   file is executable

# For loop
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# For loop with range
for i in $(seq 1 254); do
    echo "192.168.1.$i"
done

# While loop
counter=0
while [ $counter -lt 10 ]; do
    echo "Counter: $counter"
    counter=$((counter + 1))
done

# Case statement
case $1 in
    start)
        echo "Starting service..."
        ;;
    stop)
        echo "Stopping service..."
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        ;;
esac
```

### Security Scripts

```bash
#!/bin/bash
# Simple port scanner
echo "=== Simple Port Scanner ==="
read -p "Enter target IP: " target

for port in 21 22 23 25 53 80 110 143 443 445 3306 3389 8080; do
    (echo >/dev/tcp/$target/$port) 2>/dev/null && echo "[OPEN] Port $port"
done
```

```bash
#!/bin/bash
# System security audit script
echo "=== System Security Audit ==="
echo ""

echo "[*] System Information:"
uname -a
echo ""

echo "[*] Users with UID 0 (root equivalent):"
awk -F: '$3 == 0 {print $1}' /etc/passwd
echo ""

echo "[*] Users with login shell:"
awk -F: '$7 != "/usr/sbin/nologin" && $7 != "/bin/false" {print $1, $7}' /etc/passwd
echo ""

echo "[*] SUID files:"
find / -perm -4000 -type f 2>/dev/null
echo ""

echo "[*] World-writable files:"
find / -perm -o+w -type f 2>/dev/null | head -20
echo ""

echo "[*] Listening services:"
ss -tuln
echo ""

echo "[*] Failed login attempts (last 10):"
grep "Failed password" /var/log/auth.log 2>/dev/null | tail -10
echo ""

echo "[*] Cron jobs:"
for user in $(cut -f1 -d: /etc/passwd); do
    crontab -l -u $user 2>/dev/null | grep -v "^#"
done
echo ""

echo "=== Audit Complete ==="
```

---

## System Services

### systemd (Modern Linux)

```bash
# Start a service
sudo systemctl start apache2

# Stop a service
sudo systemctl stop apache2

# Restart a service
sudo systemctl restart apache2

# Enable at boot
sudo systemctl enable apache2

# Disable at boot
sudo systemctl disable apache2

# Check status
sudo systemctl status apache2

# List all services
systemctl list-units --type=service

# List enabled services
systemctl list-unit-files --type=service --state=enabled

# View service logs
journalctl -u apache2
journalctl -u apache2 --since today
journalctl -u apache2 -f    # Follow in real-time

# Security: Find running services that shouldn't be
systemctl list-units --type=service --state=running
```

---

## Cron Jobs

### Cron Format

```
┌───────────── minute (0-59)
│ ┌───────────── hour (0-23)
│ │ ┌───────────── day of month (1-31)
│ │ │ ┌───────────── month (1-12)
│ │ │ │ ┌───────────── day of week (0-7, 0 and 7 = Sunday)
│ │ │ │ │
* * * * * command_to_run

Examples:
0 * * * *     = Every hour at :00
*/5 * * * *   = Every 5 minutes
0 2 * * *     = Every day at 2:00 AM
0 0 * * 0     = Every Sunday at midnight
0 0 1 * *     = First of every month at midnight
```

### Cron Commands

```bash
# Edit current user's crontab
crontab -e

# View current user's crontab
crontab -l

# View another user's crontab (as root)
crontab -l -u username

# System-wide cron jobs
ls -la /etc/cron.d/
ls -la /etc/cron.daily/
ls -la /etc/cron.hourly/
ls -la /etc/cron.weekly/
ls -la /etc/cron.monthly/
cat /etc/crontab
```

> **🔴 Security Note:** Cron jobs are a common privilege escalation vector! If a cron job runs as root and references a writable script or uses wildcards, an attacker can exploit it for root access.

---

## SSH — Secure Shell

### SSH Basics

```bash
# Connect to remote server
ssh username@192.168.1.100

# Connect on non-standard port
ssh -p 2222 username@host

# Generate SSH key pair
ssh-keygen -t ed25519 -C "your_email@example.com"
# Creates: ~/.ssh/id_ed25519 (private) and ~/.ssh/id_ed25519.pub (public)

# Copy public key to server
ssh-copy-id username@host

# SSH with specific key
ssh -i ~/.ssh/custom_key username@host

# SCP - Secure copy
scp file.txt user@host:/remote/path/
scp user@host:/remote/file.txt ./local/path/
scp -r directory/ user@host:/remote/path/

# SSH tunneling (port forwarding)
# Local: Access remote service through local port
ssh -L 8080:localhost:80 user@host
# Now localhost:8080 connects to host's port 80

# Remote: Make local service available on remote
ssh -R 9090:localhost:3000 user@host
# Now host:9090 connects to your localhost:3000

# Dynamic (SOCKS proxy)
ssh -D 9050 user@host
# Creates SOCKS proxy on localhost:9050
```

### SSH Security Configuration

```bash
# /etc/ssh/sshd_config — Important settings:

# Disable root login
PermitRootLogin no

# Disable password authentication (key only)
PasswordAuthentication no

# Change default port
Port 2222

# Allow specific users only
AllowUsers alice bob

# Set login timeout
LoginGraceTime 30

# Limit authentication attempts
MaxAuthTries 3

# Restart SSH after changes
sudo systemctl restart sshd
```

---

## Log Management

### Important Log Files

| Log File | Contents |
|----------|----------|
| `/var/log/syslog` | General system messages |
| `/var/log/auth.log` | Authentication events (SSH, sudo) |
| `/var/log/kern.log` | Kernel messages |
| `/var/log/apache2/access.log` | Web server access |
| `/var/log/apache2/error.log` | Web server errors |
| `/var/log/mysql/error.log` | Database errors |
| `/var/log/faillog` | Failed login attempts |
| `/var/log/lastlog` | Last login per user |
| `/var/log/wtmp` | Login/logout history |
| `/var/log/btmp` | Failed login history |

### Log Analysis Commands

```bash
# View authentication logs
sudo cat /var/log/auth.log

# Find failed SSH logins
grep "Failed password" /var/log/auth.log

# Count failed attempts per IP
grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn

# Find successful logins
grep "Accepted" /var/log/auth.log

# View with journalctl
journalctl --since "2024-01-15"
journalctl --since "1 hour ago"
journalctl -p err    # Only errors
journalctl -f        # Follow real-time

# Last logins
last
lastb    # Failed logins
lastlog  # Last login per user
```

---

## System Monitoring

```bash
# CPU and memory real-time
top
htop

# Memory usage
free -h

# Disk usage
df -h         # Filesystem usage
du -sh *      # Directory sizes
du -sh /var/log/    # Specific directory

# Network connections
ss -tuln      # Listening ports
ss -tunap     # All connections with PIDs

# System load
uptime
cat /proc/loadavg

# I/O statistics
iostat
iotop

# Who is logged in
who
w

# System information
uname -a
hostnamectl
lsb_release -a
```

---

## Linux Security Hardening

### Hardening Checklist

```bash
# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Remove unnecessary services
sudo systemctl disable cups
sudo systemctl disable avahi-daemon

# 3. Configure firewall
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp    # SSH
sudo ufw status

# 4. Secure SSH
sudo nano /etc/ssh/sshd_config
# PermitRootLogin no
# PasswordAuthentication no
# MaxAuthTries 3
sudo systemctl restart sshd

# 5. Set strong password policy
sudo nano /etc/security/pwquality.conf
# minlen = 12
# dcredit = -1
# ucredit = -1
# ocredit = -1

# 6. Configure automatic updates
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades

# 7. Disable USB storage (if not needed)
echo "blacklist usb-storage" | sudo tee /etc/modprobe.d/disable-usb-storage.conf

# 8. Set proper file permissions
chmod 700 /root
chmod 600 /etc/shadow
chmod 644 /etc/passwd

# 9. Enable audit logging
sudo apt install auditd
sudo systemctl enable auditd

# 10. Install and configure fail2ban
sudo apt install fail2ban
sudo systemctl enable fail2ban
```

---

## Exercises

### Exercise 1: File System Navigation
1. Create a directory structure: `~/security/tools/`, `~/security/notes/`, `~/security/scripts/`
2. Create files in each directory
3. Navigate between them using only relative paths
4. List all files recursively with permissions

### Exercise 2: Permission Challenge
1. Create a script file
2. Make it executable only by the owner
3. Create a shared directory where group members can create files but not delete others' files (sticky bit)
4. Find all SUID files on your system

### Exercise 3: Process Investigation
1. Start a process in the background
2. Find its PID using three different methods
3. View its open files
4. View its network connections
5. Kill it gracefully, then forcefully

### Exercise 4: Log Analysis
1. Find all failed SSH login attempts in the last 24 hours
2. Identify the top 5 source IPs
3. Find all successful sudo commands
4. Count total unique users who logged in today

### Exercise 5: Write a Security Script
Create a bash script that:
1. Checks for SUID files
2. Lists all listening ports
3. Shows failed login attempts
4. Checks for world-writable files
5. Reports users with empty passwords

---

## Labs

### Lab 1: OverTheWire Bandit
**Platform:** overthewire.org/wargames/bandit/
**Objective:** Complete levels 0-20 to master Linux commands

### Lab 2: Build a Linux from Scratch
**Objective:** Compile a minimal Linux system to understand all components

### Lab 3: Linux Privilege Escalation Practice
**Platform:** TryHackMe "Linux PrivEsc" room
**Objective:** Exploit misconfigurations to gain root access

---

## Interview Questions

1. **Q: What is the difference between a hard link and a soft link?**
   A: A hard link is another name for the same inode (same data blocks). A soft link (symlink) is a pointer to a filename. Hard links can't cross filesystems or link to directories. Deleting the original file breaks a soft link but not a hard link.

2. **Q: Explain Linux file permissions and how SUID can be exploited.**
   A: Permissions define read/write/execute for owner/group/others. SUID (Set User ID) makes a program run with the file owner's privileges. If a SUID root binary has a vulnerability (like allowing command execution), an attacker can exploit it to execute commands as root.

3. **Q: How would you investigate a suspected compromise on a Linux server?**
   A: Check auth logs (`/var/log/auth.log`), look for unauthorized users, check crontabs, find recently modified files (`find / -mtime -1`), check running processes and network connections (`ss -tunap`), review bash history, check for rootkits (`rkhunter`, `chkrootkit`), and examine SUID binaries.

4. **Q: What is the purpose of `/proc` filesystem?**
   A: `/proc` is a virtual filesystem providing information about running processes and system state. Each process has a directory `/proc/[PID]/` containing its memory maps, environment variables, file descriptors, and command line. It's crucial for system monitoring and forensics.

---

## Common Mistakes

| Mistake | Impact | Fix |
|---------|--------|-----|
| Running as root all the time | Security risk | Use sudo for specific commands |
| chmod 777 on everything | No security | Use least privilege (755, 644) |
| Not backing up before changes | Data loss | Always snapshot/backup first |
| Ignoring log files | Missing attacks | Regular log review |
| Weak passwords | Easy compromise | Use strong, unique passwords |
| Not updating system | Known vulnerabilities | Regular apt update/upgrade |

---

## Summary

| Topic | Key Commands | Security Relevance |
|-------|-------------|-------------------|
| Navigation | ls, cd, pwd, find | System enumeration |
| Files | cat, grep, awk, sed | Log analysis, data extraction |
| Permissions | chmod, chown, find -perm | Privilege escalation |
| Processes | ps, top, kill, lsof | Process investigation |
| Network | ss, ip, dig, tcpdump | Network forensics |
| Services | systemctl, journalctl | Service enumeration |
| Users | useradd, passwd, id | User management |
| Logs | /var/log/, journalctl | Incident response |
| SSH | ssh, scp, ssh-keygen | Secure access |

**Next:** → [03-Networking](../03-Networking/README.md)

---

*"In Linux, everything is a file. In security, everything is a potential attack surface."*
