# Pillar 2: Operating Systems (Linux & Windows)

## Table of Contents
- [2.1 Core Theory](#21-core-theory)
- [2.2 Linux Fundamentals](#22-linux-fundamentals)
- [2.3 Linux File System & Permissions](#23-linux-file-system--permissions)
- [2.4 Linux Process & Service Management](#24-linux-process--service-management)
- [2.5 Windows Fundamentals](#25-windows-fundamentals)
- [2.6 Windows PowerShell](#26-windows-powershell)
- [2.7 Windows Security & Permissions](#27-windows-security--permissions)
- [2.8 The Hacker's View](#28-the-hackers-view)
- [2.9 Quick Reference Tables](#29-quick-reference-tables)
- [2.10 Hands-on Challenges](#210-hands-on-challenges)

---

## 2.1 Core Theory

### Why OS Knowledge is Critical for Security

The operating system is the **foundation** of every computing environment. It manages:
- **Hardware resources** (CPU, memory, disk, network)
- **User access** (who can log in, what they can do)
- **Process execution** (what software is running)
- **File storage** (where data lives, who can access it)

An attacker who compromises the OS has **full control**. A defender who understands the OS can:
- Detect unauthorized processes or services
- Identify permission misconfigurations
- Harden the system against exploitation
- Investigate breaches through logs and artifacts

### Real-World Analogy

Think of the OS as a **building's security system**:
- **Kernel** = Building foundation (controls everything)
- **User accounts** = Keycards (different access levels)
- **File permissions** = Locked rooms (who can enter)
- **Processes** = People working inside (some authorized, some not)
- **Logs** = Security cameras (recording what happens)
- **Firewall** = The building's front gate

---

## 2.2 Linux Fundamentals

### Why Linux for Security?

- Most **servers** run Linux (web servers, cloud, IoT)
- Most **hacking tools** are built for Linux (Kali, Parrot OS)
- The **terminal** gives full control with precision
- Linux is **open-source** — you can audit the code
- Understanding Linux = understanding the majority of attack surfaces

### Essential Linux Commands

#### Navigation & File Operations

| Command | Purpose | Example |
|---------|---------|---------|
| `pwd` | Print working directory | `pwd` → `/home/user` |
| `ls` | List files | `ls -la` (all files, long format) |
| `cd` | Change directory | `cd /var/log` |
| `mkdir` | Create directory | `mkdir project` |
| `rmdir` | Remove empty directory | `rmdir old_folder` |
| `rm` | Remove file/directory | `rm -rf folder` (recursive, force) |
| `cp` | Copy | `cp file.txt /backup/` |
| `mv` | Move/rename | `mv old.txt new.txt` |
| `touch` | Create empty file | `touch notes.txt` |
| `cat` | Display file contents | `cat /etc/passwd` |
| `less` | Paginated file viewing | `less large_log.txt` |
| `head/tail` | First/last lines | `tail -f /var/log/syslog` (live) |
| `find` | Search for files | `find / -name "*.conf" -type f` |
| `locate` | Fast file search (indexed) | `locate password.txt` |

#### Text Processing & Search

| Command | Purpose | Example |
|---------|---------|---------|
| `grep` | Search text patterns | `grep -i "error" /var/log/syslog` |
| `awk` | Column-based processing | `awk -F: '{print $1}' /etc/passwd` |
| `sed` | Stream editor (find/replace) | `sed 's/old/new/g' file.txt` |
| `wc` | Word/line/byte count | `wc -l file.txt` |
| `sort` | Sort lines | `sort -u names.txt` (unique) |
| `cut` | Extract columns | `cut -d: -f1,3 /etc/passwd` |
| `diff` | Compare files | `diff file1.txt file2.txt` |

#### Networking Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `ip a` | Show interfaces/IPs | `ip a show eth0` |
| `ping` | Test connectivity | `ping -c 4 google.com` |
| `ss` / `netstat` | Show sockets/connections | `ss -tuln` (listening ports) |
| `curl` | HTTP requests | `curl -I https://example.com` |
| `wget` | Download files | `wget https://example.com/file.zip` |
| `nmap` | Port scanning | `nmap -sV 192.168.1.1` |
| `tcpdump` | Packet capture | `tcpdump -i eth0 port 80` |
| `dig` | DNS queries | `dig example.com MX` |

#### System Information

| Command | Purpose | Example |
|---------|---------|---------|
| `uname -a` | Kernel/OS info | Shows version, architecture |
| `whoami` | Current user | `whoami` → `root` |
| `id` | User ID and groups | `id` → uid=1000(user) gid=1000... |
| `hostname` | System hostname | `hostname` |
| `df -h` | Disk space | Human-readable disk usage |
| `free -h` | Memory usage | RAM and swap |
| `uptime` | System uptime | Load averages |
| `lsb_release -a` | Distribution info | Ubuntu, Debian, CentOS |

---

## 2.3 Linux File System & Permissions

### Directory Hierarchy

```
/
├── bin/        → Essential user binaries (ls, cp, cat)
├── sbin/       → System binaries (fdisk, iptables)
├── etc/        → Configuration files ★ (passwd, shadow, ssh)
├── home/       → User home directories
├── root/       → Root user's home
├── var/        → Variable data (logs, web files)
│   ├── log/    → System logs ★
│   └── www/    → Web server files
├── tmp/        → Temporary files (world-writable) ★
├── usr/        → User programs and libraries
├── opt/        → Optional/third-party software
├── dev/        → Device files
├── proc/       → Process info (virtual filesystem)
└── mnt/        → Mount points
```

★ = Critical for security analysis

### File Permissions

```
-rwxr-xr-- 1 root staff 4096 Jan 15 10:30 script.sh
│└┬┘└┬┘└┬┘
│ │   │   │
│ │   │   └── Others: r-- (read only)
│ │   └────── Group:  r-x (read + execute)
│ └────────── Owner:  rwx (read + write + execute)
└──────────── File type: - (regular file), d (directory), l (link)
```

### Permission Values

| Permission | Symbol | Numeric | Meaning |
|-----------|--------|---------|---------|
| Read | r | 4 | View file contents / list directory |
| Write | w | 2 | Modify file / create/delete in directory |
| Execute | x | 1 | Run file as program / enter directory |

### chmod — Change Permissions

```bash
# Numeric method (Owner-Group-Others)
chmod 755 script.sh      # rwxr-xr-x
chmod 644 config.txt     # rw-r--r--
chmod 600 secret.key     # rw------- (only owner)
chmod 777 open_file      # rwxrwxrwx (DANGEROUS!)

# Symbolic method
chmod u+x script.sh      # Add execute for owner
chmod g-w file.txt       # Remove write for group
chmod o=r file.txt       # Set others to read only
chmod a+r file.txt       # Add read for all
```

### Special Permissions

| Permission | Numeric | Effect | Security Risk |
|-----------|---------|--------|---------------|
| **SUID** (Set User ID) | 4000 | File executes as the FILE OWNER | Privilege escalation if misconfigured |
| **SGID** (Set Group ID) | 2000 | File executes with file's group | Group privilege escalation |
| **Sticky Bit** | 1000 | Only file owner can delete (in shared dirs) | Protects /tmp |

```bash
# Find all SUID files (common privilege escalation check)
find / -perm -4000 -type f 2>/dev/null

# Set SUID
chmod 4755 /usr/bin/program
chmod u+s /usr/bin/program
```

### User & Group Management

```bash
# Key files
/etc/passwd    # User accounts (username:x:UID:GID:info:home:shell)
/etc/shadow    # Password hashes (restricted access)
/etc/group     # Group definitions

# Commands
useradd -m -s /bin/bash newuser    # Create user with home dir
passwd newuser                      # Set password
usermod -aG sudo newuser           # Add to sudo group
userdel -r olduser                 # Delete user and home
groups username                     # Show user's groups
```

---

## 2.4 Linux Process & Service Management

### Process Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `ps aux` | All running processes | Full details |
| `ps -ef` | All processes (different format) | Shows PPID |
| `top` / `htop` | Real-time process monitor | Interactive |
| `kill PID` | Terminate process | `kill 1234` |
| `kill -9 PID` | Force kill | `kill -9 1234` |
| `killall name` | Kill by process name | `killall firefox` |
| `bg` / `fg` | Background/foreground jobs | `bg %1` |
| `nohup` | Run immune to hangup | `nohup ./script.sh &` |
| `jobs` | List background jobs | `jobs -l` |

### Service Management (systemd)

```bash
# Control services
systemctl start nginx        # Start service
systemctl stop nginx         # Stop service
systemctl restart nginx      # Restart service
systemctl status nginx       # Check status
systemctl enable nginx       # Start on boot
systemctl disable nginx      # Don't start on boot

# List all services
systemctl list-units --type=service

# Check what's listening on ports
ss -tuln | grep LISTEN
```

### Cron Jobs (Scheduled Tasks)

```bash
# Edit crontab
crontab -e

# Format: minute hour day month weekday command
# ┌───── minute (0-59)
# │ ┌───── hour (0-23)
# │ │ ┌───── day of month (1-31)
# │ │ │ ┌───── month (1-12)
# │ │ │ │ ┌───── day of week (0-7, 0=Sun)
# │ │ │ │ │
  0 2 * * * /backup/run_backup.sh    # Daily at 2:00 AM
  */5 * * * * /scripts/check.sh      # Every 5 minutes

# Security: Check for malicious cron jobs
crontab -l                       # Current user's cron
cat /etc/crontab                 # System cron
ls /etc/cron.d/                  # Cron directory
```

---

## 2.5 Windows Fundamentals

### Key Windows Concepts for Security

| Concept | Description |
|---------|-------------|
| **Registry** | Centralized database for OS/application settings |
| **Active Directory (AD)** | Domain-based user/computer management |
| **Group Policy (GPO)** | Centralized security policy enforcement |
| **Windows Event Log** | Security, System, Application event records |
| **SAM Database** | Local password hash storage |
| **NTFS** | File system with ACLs and permissions |

### Important Windows Directories

```
C:\Windows\System32\          → Core OS files, CMD, drivers
C:\Windows\System32\config\   → Registry hives (SAM, SYSTEM, SECURITY)
C:\Users\<username>\          → User profiles
C:\Users\<username>\AppData\  → Application data (often hidden)
C:\ProgramData\               → Shared application data
C:\Windows\Temp\              → System temporary files
C:\Windows\Prefetch\          → Execution artifacts ★
```

### Essential CMD Commands

```cmd
:: System info
systeminfo                     :: Detailed system information
hostname                       :: Computer name
whoami /all                    :: Current user + privileges + groups

:: Network
ipconfig /all                  :: IP configuration
netstat -ano                   :: Active connections with PIDs
arp -a                         :: ARP cache
nslookup domain.com           :: DNS query
route print                    :: Routing table

:: Users and groups
net user                       :: List local users
net user username              :: User details
net localgroup administrators  :: Admin group members

:: Processes and services
tasklist                       :: Running processes
tasklist /svc                  :: Processes with services
taskkill /PID 1234 /F         :: Force kill process
sc query                       :: List services
wmic process list brief        :: Process info via WMI
```

---

## 2.6 Windows PowerShell

### Why PowerShell for Security?

PowerShell is **object-oriented** (not text-based like bash). It can:
- Query Active Directory
- Manage remote systems
- Parse event logs
- Automate incident response
- Execute attacks (used by adversaries too — "living off the land")

### Core PowerShell Commands (Cmdlets)

```powershell
# System Information
Get-ComputerInfo
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
Get-Service | Where-Object {$_.Status -eq "Running"}

# File Operations
Get-ChildItem -Path C:\ -Recurse -Filter "*.log"    # Find files
Get-Content .\file.txt                                # Read file
Get-FileHash .\file.exe -Algorithm SHA256            # Hash a file

# Network
Get-NetIPConfiguration                               # IP info
Get-NetTCPConnection | Where-Object {$_.State -eq "Established"}
Test-NetConnection google.com -Port 443              # Test connectivity
Resolve-DnsName example.com                          # DNS lookup

# User/Group Management
Get-LocalUser                                        # List users
Get-LocalGroupMember -Group "Administrators"         # Admin members
Get-ADUser -Filter * -Properties *                   # AD users (if on domain)

# Event Logs (Security Investigation)
Get-EventLog -LogName Security -Newest 50
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625} # Failed logins
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624} # Successful logins

# Registry
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
# ^ Shows programs that run at startup (persistence mechanism)
```

### PowerShell Pipeline Examples

```powershell
# Find processes using the most memory
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 Name, @{N='MB';E={[math]::Round($_.WorkingSet/1MB,2)}}

# Find all listening ports and their processes
Get-NetTCPConnection -State Listen | Select-Object LocalPort, OwningProcess, @{N='Process';E={(Get-Process -Id $_.OwningProcess).ProcessName}} | Sort-Object LocalPort

# Search for a string across files
Get-ChildItem -Path C:\Users -Recurse -Filter "*.txt" | Select-String "password"
```

---

## 2.7 Windows Security & Permissions

### NTFS Permissions

| Permission | Files | Folders |
|-----------|-------|---------|
| Full Control | All operations | All operations |
| Modify | Read, write, execute, delete | Same + create files |
| Read & Execute | Read + run programs | Same + traverse |
| Read | View contents | List contents |
| Write | Modify file | Create new files |

### Windows Security Identifiers (SIDs)

```
S-1-5-21-<domain>-500    → Administrator
S-1-5-21-<domain>-501    → Guest
S-1-5-18                  → SYSTEM (highest privilege)
S-1-5-32-544             → Administrators group
```

### Windows Event IDs to Know

| Event ID | Log | Meaning |
|----------|-----|---------|
| 4624 | Security | Successful login |
| 4625 | Security | Failed login |
| 4634 | Security | Logoff |
| 4648 | Security | Login with explicit credentials |
| 4672 | Security | Special privileges assigned (admin login) |
| 4688 | Security | New process created |
| 4720 | Security | User account created |
| 7045 | System | New service installed |
| 1102 | Security | Audit log cleared ★ (suspicious!) |

---

## 2.8 The Hacker's View

### Linux Privilege Escalation

An attacker gains initial access as a low-privilege user and escalates to **root**:

```
1. SUID Exploitation
   find / -perm -4000 -type f 2>/dev/null
   → If /usr/bin/vulnerable_program has SUID and is exploitable
   → Attacker executes it to get root shell

2. Writable /etc/passwd
   → If attacker can write to /etc/passwd
   → Add a new root user: hacker:password_hash:0:0::/root:/bin/bash

3. Sudo Misconfigurations
   sudo -l
   → Shows what current user can run as root
   → Example: (ALL) NOPASSWD: /usr/bin/vim
   → vim can spawn a shell: :!/bin/bash → root shell

4. Cron Job Abuse
   → If a cron job runs a writable script as root
   → Modify the script to add a reverse shell

5. Kernel Exploits
   uname -r → Check kernel version
   → Search for known exploits (e.g., DirtyCow, DirtyPipe)
```

### Windows Privilege Escalation

```
1. Unquoted Service Paths
   → Service path: C:\Program Files\My App\service.exe
   → If unquoted, Windows tries: C:\Program.exe first
   → Attacker places malicious Program.exe in C:\

2. Weak Service Permissions
   → If a regular user can modify a service's binary path
   → Replace with malicious executable → restart service → SYSTEM

3. AlwaysInstallElevated
   → Registry key allowing .msi files to install as SYSTEM
   → Attacker creates malicious .msi → instant SYSTEM

4. Token Impersonation
   → If user has SeImpersonatePrivilege
   → Tools like PrintSpoofer/JuicyPotato → SYSTEM shell

5. Credential Harvesting
   → Mimikatz: extracts passwords from memory (LSASS)
   → reg save HKLM\SAM sam.hive → offline password cracking
```

### Persistence Mechanisms

| Method | Linux | Windows |
|--------|-------|---------|
| Startup | `.bashrc`, cron, systemd service | Registry Run keys, Startup folder, Scheduled Tasks |
| Backdoor user | Add to /etc/passwd | `net user hacker P@ss /add` |
| SSH keys | Add to ~/.ssh/authorized_keys | — |
| Service | Malicious systemd unit | New Windows service |
| Rootkit | Kernel module (LKM) | Driver-level rootkit |

---

## 2.9 Quick Reference Tables

### Linux vs Windows Command Comparison

| Task | Linux | Windows CMD | PowerShell |
|------|-------|-------------|------------|
| List files | `ls -la` | `dir` | `Get-ChildItem` |
| Current directory | `pwd` | `cd` | `Get-Location` |
| Find files | `find / -name "*.txt"` | `dir /s *.txt` | `Get-ChildItem -Recurse -Filter *.txt` |
| Search text | `grep "error" file` | `findstr "error" file` | `Select-String "error" file` |
| Show processes | `ps aux` | `tasklist` | `Get-Process` |
| Kill process | `kill -9 PID` | `taskkill /PID n /F` | `Stop-Process -Id PID` |
| Network info | `ip a` | `ipconfig /all` | `Get-NetIPConfiguration` |
| Active connections | `ss -tuln` | `netstat -ano` | `Get-NetTCPConnection` |
| Current user | `whoami` | `whoami` | `whoami` |
| File permissions | `chmod 755 file` | `icacls file` | `Set-Acl` |
| View logs | `/var/log/syslog` | Event Viewer | `Get-WinEvent` |
| Hash file | `sha256sum file` | `certutil -hashfile file SHA256` | `Get-FileHash file` |

### Critical Files for Security Analysts

| Purpose | Linux | Windows |
|---------|-------|---------|
| User accounts | `/etc/passwd` | SAM (registry) |
| Password hashes | `/etc/shadow` | `C:\Windows\System32\config\SAM` |
| Group info | `/etc/group` | Local Groups (registry) |
| Network config | `/etc/network/interfaces` | Registry, `netsh` |
| DNS config | `/etc/resolv.conf` | Registry |
| Hosts file | `/etc/hosts` | `C:\Windows\System32\drivers\etc\hosts` |
| Startup programs | `/etc/rc.local`, cron, systemd | Registry Run keys |
| System logs | `/var/log/` | Event Viewer |
| SSH config | `/etc/ssh/sshd_config` | — |
| Firewall rules | `iptables -L` / `ufw status` | `netsh advfirewall` |

---

## 2.10 Hands-on Challenges

### Challenge 1: Linux Permission Audit

```bash
# 1. Create a test environment
mkdir /tmp/perm_lab && cd /tmp/perm_lab
touch secret.txt public.txt script.sh

# 2. Set permissions
chmod 600 secret.txt    # Only owner can read/write
chmod 644 public.txt    # Everyone can read, owner can write
chmod 755 script.sh     # Everyone can execute, owner can write

# 3. Verify with ls -la

# 4. Try accessing as different users
su - testuser
cat /tmp/perm_lab/secret.txt    # Should FAIL (Permission denied)
cat /tmp/perm_lab/public.txt    # Should SUCCEED

# 5. SECURITY AUDIT: Find world-writable files
find / -perm -o+w -type f 2>/dev/null

# 6. Find SUID binaries
find / -perm -4000 -type f 2>/dev/null
```

### Challenge 2: Windows Event Log Investigation

```powershell
# 1. Find failed login attempts (brute force detection)
Get-WinEvent -FilterHashtable @{
    LogName='Security'
    ID=4625
} -MaxEvents 20 | Format-Table TimeCreated, Message -Wrap

# 2. Find new processes created (malware execution detection)
Get-WinEvent -FilterHashtable @{
    LogName='Security'
    ID=4688
} -MaxEvents 10 | ForEach-Object {
    $_.Properties[5].Value  # New process name
}

# 3. Check for cleared logs (attacker covering tracks)
Get-WinEvent -FilterHashtable @{
    LogName='Security'
    ID=1102
}

# 4. Check startup programs
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
```

### Challenge 3: Process Investigation

```bash
# Linux: Find suspicious processes
# 1. Check for processes running as root
ps aux | grep "^root" | grep -v "\[" | less

# 2. Check network connections with process names
ss -tuln -p

# 3. Find processes with open network connections
lsof -i -P -n

# 4. Check if any process is connecting to suspicious IPs
ss -tp | grep ESTAB
```

---

## Quiz Questions

1. You find a file with permissions `-rwsr-xr-x` owned by root. What is the SUID bit, and why is this a potential security risk?
2. On Windows, Event ID 4625 is appearing 500 times in 10 minutes from the same source. What attack is this, and how would you respond?
3. Explain the difference between `chmod 644` and `chmod 755`. When would you use each?
4. An attacker has a low-privilege shell on a Linux box. Describe three techniques they might use for privilege escalation.
5. What is the Windows equivalent of Linux's `/etc/shadow`, and why is protecting it critical?

---

> **Next Pillar:** [03 - Basic Scripting](03-basic-scripting.md)
