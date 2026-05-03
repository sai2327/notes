# 14. Process Management (Linux)

## Table of Contents
- [14.1 Viewing Processes (ps, top)](#141-viewing-processes-ps-top)
- [14.2 Job Control (fg, bg, jobs)](#142-job-control-fg-bg-jobs)
- [14.3 Killing Processes (kill, killall)](#143-killing-processes-kill-killall)
- [14.4 Process Priority (nice, renice)](#144-process-priority-nice-renice)
- [14.5 Practice & Assessment](#145-practice--assessment)

---

## 14.1 Viewing Processes (ps, top)

### ps — Process Status (Snapshot)

```bash
# Show your processes
$ ps
  PID TTY          TIME CMD
 1234 pts/0    00:00:00 bash
 1250 pts/0    00:00:00 ps

# Show ALL processes (standard)
$ ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1 169344 13312 ?        Ss   Jan10   0:05 /sbin/init
root         2  0.0  0.0      0     0 ?        S    Jan10   0:00 [kthreadd]
john      1234  0.0  0.2  23456  5678 pts/0    Ss   10:00   0:00 bash
john      1250  0.1  1.5 456789 30000 pts/0    Sl   10:01   0:30 firefox

# Column meanings:
# USER    = Process owner
# PID     = Process ID
# %CPU    = CPU usage percentage
# %MEM    = Memory usage percentage
# VSZ     = Virtual memory size
# RSS     = Resident (physical) memory used
# TTY     = Terminal (? = no terminal, background)
# STAT    = Status (S=sleeping, R=running, Z=zombie, T=stopped)
# START   = Start time
# TIME    = Total CPU time consumed
# COMMAND = Command that started the process
```

```bash
# Show process tree
$ ps auxf
# or
$ pstree
init─┬─sshd───sshd───bash───vim
     ├─apache2─┬─apache2
     │         └─apache2
     └─cron

# Find specific process
$ ps aux | grep firefox
john  1250  0.1  1.5 456789 30000 pts/0 Sl 10:01 0:30 firefox

# Show by PID
$ ps -p 1234
```

### Process States (STAT column)

| Code | Meaning |
|------|---------|
| R | Running or runnable |
| S | Sleeping (waiting for event) |
| D | Uninterruptible sleep (usually I/O) |
| Z | Zombie (terminated, not cleaned up) |
| T | Stopped (Ctrl+Z or signal) |
| s | Session leader |
| l | Multi-threaded |
| + | Foreground process |

### top — Real-Time Process Monitor

```bash
$ top
top - 10:30:00 up 5 days,  3:22,  2 users,  load average: 0.15, 0.20, 0.18
Tasks: 195 total,   1 running, 194 sleeping,   0 stopped,   0 zombie
%Cpu(s):  2.3 us,  0.7 sy,  0.0 ni, 96.8 id,  0.2 wa,  0.0 hi,  0.0 si
MiB Mem :   7876.4 total,   2345.6 free,   3210.8 used,   2320.0 buff/cache
MiB Swap:   2048.0 total,   2048.0 free,      0.0 used.   4200.0 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
 1250 john      20   0  456789  30000  12000 S   5.0   1.5   0:30.45 firefox
 1300 root      20   0   98765  15000   8000 S   2.0   0.8   1:23.67 Xorg

# Key commands in top:
#   q       = Quit
#   k       = Kill a process (enter PID)
#   r       = Renice (change priority)
#   M       = Sort by memory usage
#   P       = Sort by CPU usage
#   1       = Show individual CPU cores
#   h       = Help
```

### htop — Enhanced Process Viewer

```bash
# Install
sudo apt install htop

# Run
htop

# Features over top:
# - Color-coded, visual CPU/memory bars
# - Mouse support
# - Tree view (F5)
# - Easy kill (F9)
# - Search (F3)
# - Filter (F4)
```

---

## 14.2 Job Control (fg, bg, jobs)

### Foreground vs Background

```bash
# Run command in background (add &)
$ sleep 100 &
[1] 5678          # Job number 1, PID 5678

# Suspend current foreground process (Ctrl+Z)
$ vim file.txt
^Z                # Ctrl+Z pressed
[1]+  Stopped     vim file.txt

# List jobs
$ jobs
[1]+  Stopped     vim file.txt
[2]-  Running     sleep 100 &

# Resume in foreground
$ fg %1           # Bring job 1 to foreground
$ fg              # Bring most recent job to foreground

# Resume in background
$ bg %1           # Resume job 1 in background

# Run long-running process and detach
$ nohup long_script.sh &
# nohup = won't be killed when terminal closes
# Output goes to nohup.out
```

---

## 14.3 Killing Processes (kill, killall)

### Signals

| Signal | Number | Meaning | Keyboard |
|--------|--------|---------|----------|
| SIGHUP | 1 | Hangup (reload config) | — |
| SIGINT | 2 | Interrupt (gentle stop) | Ctrl+C |
| SIGKILL | 9 | Force kill (cannot be caught) | — |
| SIGTERM | 15 | Terminate (default, graceful) | — |
| SIGSTOP | 19 | Pause process | Ctrl+Z |
| SIGCONT | 18 | Resume paused process | — |

### Commands

```bash
# Kill by PID (sends SIGTERM by default)
kill 1234

# Force kill (when process won't die)
kill -9 1234
kill -SIGKILL 1234

# Kill by name
killall firefox
killall -9 python3

# Kill processes matching pattern
pkill -f "python script.py"

# Kill all processes of a user
sudo pkill -u john

# Verify process is gone
ps aux | grep 1234
```

---

## 14.4 Process Priority (nice, renice)

### Understanding Priority

```
Priority range: -20 (highest) to +19 (lowest)
Default priority: 0
Only root can set negative (higher) priority

Lower number = Higher priority = More CPU time
```

### Commands

```bash
# Start process with specific priority
nice -n 10 ./heavy_script.sh      # Lower priority (background work)
nice -n -5 ./important_task       # Higher priority (needs root)

# Change priority of running process
renice 15 -p 1234                 # Set PID 1234 to priority 15
sudo renice -5 -p 1234           # Set higher priority (root only)
renice 10 -u john                 # All of john's processes to 10
```

---

## 14.5 Practice & Assessment

### MCQs

**Q1.** A zombie process (Z state) means:
- A) Process using too much CPU
- B) Process terminated but parent hasn't collected its exit status
- C) Process is sleeping
- D) Process is running in background

**Answer:** B

---

**Q2.** `kill -9 PID` sends:
- A) SIGTERM (graceful stop)
- B) SIGKILL (force kill, cannot be caught)
- C) SIGINT (interrupt)
- D) SIGHUP (reload)

**Answer:** B

---

**Q3.** `nice -n 19 ./task` runs the task with:
- A) Highest priority
- B) Lowest priority
- C) Default priority
- D) Real-time priority

**Answer:** B (19 = lowest user priority)

---

### Hands-On

**Task:** Write commands to:
1. Find the PID of a process named `nginx`
2. Check its CPU and memory usage
3. Gracefully stop it
4. If it doesn't stop, force kill it

```bash
# 1. Find PID
pidof nginx
# or
ps aux | grep nginx

# 2. Check usage
top -p $(pidof nginx)
# or
ps aux | grep nginx

# 3. Graceful stop
kill $(pidof nginx)
# or
kill -15 $(pidof nginx)

# 4. Force kill
kill -9 $(pidof nginx)
```

---

> **Next Topic:** [15 - Pipelines and Redirection](15-pipelines-redirection.md)
