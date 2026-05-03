# 21. Cheat Sheet — Quick Reference

## Part A: Operating Systems Formulas & Key Concepts

---

### CPU Scheduling Formulas

| Metric | Formula |
|--------|---------|
| **Turnaround Time (TAT)** | Completion Time − Arrival Time |
| **Waiting Time (WT)** | Turnaround Time − Burst Time |
| **Response Time (RT)** | First CPU Time − Arrival Time |
| **Throughput** | Number of Processes / Total Time |
| **CPU Utilization** | (Busy Time / Total Time) × 100% |

### Scheduling Algorithms Comparison

| Algorithm | Preemptive? | Starvation? | Optimal? | Notes |
|-----------|:-----------:|:-----------:|:--------:|-------|
| FCFS | No | No | No | Convoy effect |
| SJF | No | Yes | Non-preemptive optimal | Needs burst prediction |
| SRTF | Yes | Yes | Yes (preemptive) | Best avg WT |
| Round Robin | Yes | No | No | Fair, time quantum matters |
| Priority | Both | Yes | No | Use aging to fix |

### Deadlock

```
4 Necessary Conditions (ALL must hold):
1. Mutual Exclusion
2. Hold and Wait
3. No Preemption
4. Circular Wait
```

**Banker's Algorithm:**
```
Need[i][j] = Max[i][j] − Allocation[i][j]
Available after P finishes = Available + Allocation[P]
Safe = can find sequence where all processes finish
```

### Memory Management

| Concept | Formula/Key |
|---------|-------------|
| **Page Number** | Logical Address ÷ Page Size |
| **Offset** | Logical Address mod Page Size |
| **Physical Address** | (Frame Number × Frame Size) + Offset |
| **External Fragmentation** | Free memory exists but not contiguous |
| **Internal Fragmentation** | Allocated block > needed (wasted inside) |

### Page Replacement Algorithms

| Algorithm | Description | Belady's Anomaly? |
|-----------|-------------|:-----------------:|
| **FIFO** | Replace oldest page | Yes |
| **LRU** | Replace least recently used | No |
| **Optimal** | Replace page not used longest in future | No (benchmark only) |

### File Allocation Methods

| Method | Pros | Cons |
|--------|------|------|
| Contiguous | Fast sequential & random access | External fragmentation |
| Linked | No fragmentation | Slow random access |
| Indexed | Fast random access | Index block overhead |

### Disk Scheduling

```
Seek Time = |Current Position − Requested Track|
Total Seek = Sum of all individual seeks
```

---

## Part B: Linux Commands Quick Reference

---

### Navigation & Info

| Command | Purpose |
|---------|---------|
| `pwd` | Print working directory |
| `ls -la` | List all files (detailed) |
| `cd /path` | Change directory |
| `cd ~` | Home directory |
| `cd -` | Previous directory |
| `whoami` | Current username |
| `hostname` | Machine name |
| `uname -a` | System info |
| `date` | Current date/time |
| `uptime` | System uptime |

### File Operations

| Command | Purpose |
|---------|---------|
| `touch file` | Create empty file |
| `cp src dest` | Copy file |
| `cp -r dir dest` | Copy directory |
| `mv src dest` | Move/rename |
| `rm file` | Delete file |
| `rm -rf dir` | Delete directory (force) |
| `mkdir -p a/b/c` | Create nested dirs |
| `cat file` | Display file content |
| `less file` | Paginated view |
| `head -n 20 file` | First 20 lines |
| `tail -f file` | Follow file in real-time |
| `wc -l file` | Count lines |

### Permissions

| Command | Purpose |
|---------|---------|
| `chmod 755 file` | rwxr-xr-x |
| `chmod 644 file` | rw-r--r-- |
| `chmod +x file` | Add execute |
| `chown user:group file` | Change ownership |
| `umask 022` | Default permission mask |

```
Permission Numbers:
  r = 4    w = 2    x = 1
  rwx = 7  rw- = 6  r-x = 5  r-- = 4
  
Special:
  SUID = 4xxx    SGID = 2xxx    Sticky = 1xxx
```

### Searching & Filtering

| Command | Purpose |
|---------|---------|
| `grep "pattern" file` | Search in file |
| `grep -r "pattern" dir/` | Recursive search |
| `grep -i` | Case insensitive |
| `grep -n` | Show line numbers |
| `grep -v` | Invert (exclude) |
| `find . -name "*.txt"` | Find files by name |
| `find . -size +100M` | Find large files |
| `find . -mtime -7` | Modified last 7 days |

### Process Management

| Command | Purpose |
|---------|---------|
| `ps aux` | All processes |
| `top` / `htop` | Real-time monitor |
| `kill PID` | Terminate process |
| `kill -9 PID` | Force kill |
| `killall name` | Kill by name |
| `bg` / `fg` | Background/foreground |
| `nohup cmd &` | Run after logout |
| `nice -n 10 cmd` | Start with priority |

### Redirection & Pipes

| Syntax | Purpose |
|--------|---------|
| `>` | Redirect stdout (overwrite) |
| `>>` | Redirect stdout (append) |
| `2>` | Redirect stderr |
| `2>&1` | Stderr to stdout |
| `&>` | Both stdout+stderr |
| `<` | Input from file |
| `\|` | Pipe stdout to next command |
| `tee file` | Write to file AND stdout |

### Networking

| Command | Purpose |
|---------|---------|
| `ip a` | Show IP addresses |
| `ping -c 4 host` | Test connectivity |
| `ss -tlnp` | Show listening ports |
| `ssh user@host` | Remote login |
| `scp file user@host:path` | Secure copy |
| `rsync -avz src dest` | Efficient sync |
| `curl -O url` | Download file |
| `wget url` | Download file |
| `dig domain` | DNS lookup |

### Package Management (Debian/Ubuntu)

| Command | Purpose |
|---------|---------|
| `sudo apt update` | Refresh package list |
| `sudo apt upgrade` | Upgrade all packages |
| `sudo apt install pkg` | Install package |
| `sudo apt remove pkg` | Remove package |
| `sudo apt purge pkg` | Remove + config |
| `apt search term` | Search packages |
| `dpkg -l` | List installed |

### Services & Scheduling

| Command | Purpose |
|---------|---------|
| `systemctl start svc` | Start service |
| `systemctl stop svc` | Stop service |
| `systemctl enable svc` | Enable on boot |
| `systemctl status svc` | Check status |
| `journalctl -u svc` | View service logs |
| `crontab -e` | Edit cron jobs |
| `crontab -l` | List cron jobs |

```
Cron Format: MIN HOUR DOM MON DOW command
             *   *    *   *   *
             
Examples:
  */5 * * * *     = every 5 minutes
  0 2 * * *       = daily at 2 AM
  0 0 * * 0       = weekly (Sunday midnight)
  0 0 1 * *       = monthly (1st at midnight)
```

### Text Processing

| Command | Purpose |
|---------|---------|
| `sed 's/old/new/g' file` | Replace text |
| `sed -i 's/old/new/g' file` | Replace in-place |
| `sed '/pattern/d' file` | Delete matching lines |
| `awk '{print $1}' file` | Print 1st column |
| `awk -F: '{print $1}' /etc/passwd` | Custom delimiter |
| `sort file` | Sort lines |
| `sort -rn` | Reverse numeric sort |
| `uniq` | Remove duplicates |
| `cut -d: -f1` | Extract field |
| `tr 'a-z' 'A-Z'` | Translate characters |

### Bash Scripting Essentials

```bash
#!/bin/bash              # Shebang
set -euo pipefail        # Strict mode
$1, $2, ...              # Arguments
$#                       # Argument count
$?                       # Last exit code
$0                       # Script name
$(command)               # Command substitution
$((expr))                # Arithmetic
[ -f file ]              # File exists test
[ -d dir ]               # Directory exists test
[ -z "$var" ]            # Variable is empty
[ "$a" = "$b" ]          # String equality
[ $a -eq $b ]            # Numeric equality
```

---

## Part C: Key Differences

### Process vs Thread

| Process | Thread |
|---------|--------|
| Own memory space | Shared memory |
| Heavy context switch | Light context switch |
| IPC needed to communicate | Can share variables |
| fork() to create | pthread_create() |

### Hard Link vs Soft Link

| Hard Link | Soft Link |
|-----------|-----------|
| Same inode | Different inode |
| Can't cross filesystems | Can cross filesystems |
| Can't link directories | Can link directories |
| File persists if original deleted | Breaks if original deleted |
| `ln target link` | `ln -s target link` |

### Paging vs Segmentation

| Paging | Segmentation |
|--------|-------------|
| Fixed-size pages | Variable-size segments |
| Internal fragmentation | External fragmentation |
| No logical division | Logical division (code, data, stack) |
| Simple hardware | Complex hardware |

---

> **Next Topic:** [22 - Interview Questions](22-interview-questions-final.md)
