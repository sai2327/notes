# 09. Introduction to Linux

## Table of Contents
- [9.1 What is Linux?](#91-what-is-linux)
- [9.2 Linux vs Unix vs Windows](#92-linux-vs-unix-vs-windows)
- [9.3 Linux Distributions](#93-linux-distributions)
- [9.4 Filesystem Hierarchy Standard (FHS)](#94-filesystem-hierarchy-standard-fhs)
- [9.5 The Linux Shell](#95-the-linux-shell)
- [9.6 Getting Help](#96-getting-help)
- [9.7 Practice & Assessment](#97-practice--assessment)

---

## 9.1 What is Linux?

### Definition
**Linux** is an open-source, Unix-like operating system kernel created by Linus Torvalds in 1991. Combined with GNU tools and other software, it forms a complete operating system.

```
Linux kernel + GNU tools + Package manager + Desktop = Linux Distribution

Examples of distributions:
  Ubuntu, Fedora, Debian, CentOS, Arch Linux, Kali Linux
```

### Key Features

| Feature | Description |
|---------|-------------|
| **Open Source** | Source code freely available; anyone can modify |
| **Multi-user** | Multiple users can use simultaneously |
| **Multitasking** | Run multiple processes concurrently |
| **Portable** | Runs on many architectures (x86, ARM, RISC-V) |
| **Secure** | Strong file permissions, SELinux, no viruses (mostly) |
| **Stable** | Servers run for years without reboot |

---

## 9.2 Linux vs Unix vs Windows

| Feature | Linux | Unix | Windows |
|---------|-------|------|---------|
| Cost | Free | Expensive (commercial) | Paid license |
| Source Code | Open source | Closed (mostly) | Closed |
| Kernel | Monolithic (modular) | Varies | Hybrid (NT) |
| File System | ext4, XFS, Btrfs | UFS, ZFS | NTFS, FAT32 |
| CLI | Bash, Zsh | sh, ksh, csh | PowerShell, CMD |
| Case Sensitive | Yes (File ≠ file) | Yes | No (File = file) |
| Path Separator | / (forward slash) | / | \ (backslash) |
| Root Directory | / | / | C:\ |
| Use Case | Servers, dev, embedded | Enterprise servers | Desktop, gaming |

---

## 9.3 Linux Distributions

| Distribution | Based On | Use Case | Package Manager |
|-------------|---------|----------|-----------------|
| **Ubuntu** | Debian | Desktop, beginners | apt |
| **Debian** | Independent | Servers, stability | apt |
| **Fedora** | Independent | Latest features, developers | dnf |
| **CentOS/Rocky** | RHEL | Enterprise servers | dnf/yum |
| **Arch Linux** | Independent | Advanced users, customization | pacman |
| **Kali Linux** | Debian | Penetration testing | apt |
| **Linux Mint** | Ubuntu | Desktop, ex-Windows users | apt |

---

## 9.4 Filesystem Hierarchy Standard (FHS)

### Directory Tree

```
/                          ← Root (top of everything)
├── bin/                   ← Essential user binaries (ls, cat, cp)
├── sbin/                  ← System binaries (fdisk, iptables)
├── boot/                  ← Boot loader files (kernel, GRUB)
├── dev/                   ← Device files (/dev/sda, /dev/null)
├── etc/                   ← Configuration files (/etc/passwd, /etc/ssh/)
├── home/                  ← User home directories (/home/john/)
│   ├── john/
│   └── alice/
├── lib/                   ← Shared libraries (like .dll in Windows)
├── media/                 ← Mount point for removable media (USB, CD)
├── mnt/                   ← Temporary mount points
├── opt/                   ← Optional/third-party software
├── proc/                  ← Virtual filesystem (process/system info)
├── root/                  ← Root user's home directory
├── run/                   ← Runtime variable data (PID files)
├── srv/                   ← Service data (web server files)
├── sys/                   ← Virtual filesystem (kernel/device info)
├── tmp/                   ← Temporary files (cleared on reboot)
├── usr/                   ← User programs and data
│   ├── bin/               ← User commands (less essential)
│   ├── lib/               ← Libraries for /usr/bin
│   ├── local/             ← Locally installed software
│   └── share/             ← Shared data (docs, man pages)
└── var/                   ← Variable data (logs, mail, databases)
    ├── log/               ← Log files
    ├── tmp/               ← Persistent temp files
    └── www/               ← Web server content (sometimes)
```

### Key Directories to Remember

| Directory | Purpose | Example |
|-----------|---------|---------|
| `/etc` | All configuration files | `/etc/passwd`, `/etc/hosts` |
| `/home` | User data | `/home/john/Documents/` |
| `/var/log` | System and service logs | `/var/log/syslog` |
| `/tmp` | Temporary files (anyone can write) | `/tmp/session_data` |
| `/proc` | Process information (virtual) | `/proc/cpuinfo` |
| `/dev` | Device files | `/dev/sda` (first hard disk) |

---

## 9.5 The Linux Shell

### What is a Shell?

```
Shell = Command-line interpreter
  User types commands → Shell interprets → Kernel executes

           ┌────────────┐
  User ──► │   SHELL    │ ──► Kernel ──► Hardware
  (cmds)   │ (Bash/Zsh) │     (executes)
           └────────────┘
```

### Common Shells

| Shell | Path | Description |
|-------|------|-------------|
| **bash** | /bin/bash | Most popular, default on most distros |
| **zsh** | /bin/zsh | Enhanced bash (default on macOS) |
| **sh** | /bin/sh | Original Bourne shell (minimal) |
| **fish** | /usr/bin/fish | User-friendly, auto-suggestions |

### Basic Shell Usage

```bash
# Check your current shell
echo $SHELL
# Output: /bin/bash

# Check available shells
cat /etc/shells

# Change shell
chsh -s /bin/zsh

# Shell prompt:
#   user@hostname:current_directory$
#   john@ubuntu:~$          ← ~ means home directory
#   root@server:/etc#       ← # means root user
```

---

## 9.6 Getting Help

```bash
# Man pages (manual) — most complete reference
man ls                # Full manual for ls command
man 5 passwd          # Section 5 (file format) of passwd

# Brief help
ls --help             # Most commands support --help
command -h            # Short help

# What is this command?
whatis ls
# Output: ls (1) - list directory contents

# Search for commands by keyword
apropos "copy files"
# Shows commands related to copying files

# Type of command
type ls
# Output: ls is aliased to 'ls --color=auto'

type cd
# Output: cd is a shell builtin
```

### Man Page Sections

| Section | Content |
|---------|---------|
| 1 | User commands (ls, cat, grep) |
| 2 | System calls (fork, open, read) |
| 3 | Library functions (printf, malloc) |
| 4 | Special files (/dev) |
| 5 | File formats (/etc/passwd) |
| 8 | System admin commands (mount, fdisk) |

---

## 9.7 Practice & Assessment

### MCQs

**Q1.** The Linux directory for configuration files is:
- A) /home
- B) /etc
- C) /bin
- D) /tmp

**Answer:** B) /etc

---

**Q2.** Which is NOT a Linux distribution?
- A) Ubuntu
- B) Fedora
- C) PowerShell
- D) Arch Linux

**Answer:** C) PowerShell (it's a shell/scripting language, not a distro)

---

**Q3.** The root user's home directory is:
- A) /home/root
- B) /root
- C) /
- D) /usr/root

**Answer:** B) /root

---

**Q4.** Linux file paths use which separator?
- A) Backslash (\)
- B) Forward slash (/)
- C) Colon (:)
- D) Dot (.)

**Answer:** B) Forward slash (/)

---

### Hands-On

**Task:** For each description, identify the correct directory:
1. System log files → `/var/log`
2. USB drive mount point → `/media`
3. User john's files → `/home/john`
4. SSH configuration → `/etc/ssh`
5. Temporary files cleared on reboot → `/tmp`

---

> **Next Topic:** [10 - File and Directory Navigation](10-file-directory-navigation.md)
