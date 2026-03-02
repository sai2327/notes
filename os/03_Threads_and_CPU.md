# 📘 Chapter 3: Threads and CPU Scheduling Calculations

> **"A thread is the smallest unit of CPU execution — think of it as a lightweight process."**

---

## 📑 Table of Contents

| # | Topic |
|---|-------|
| 1 | [What is a Thread?](#1-what-is-a-thread) |
| 2 | [Process vs Thread](#2-process-vs-thread) |
| 3 | [User-Level vs Kernel-Level Threads](#3-user-level-vs-kernel-level-threads) |
| 4 | [Multithreading Models](#4-multithreading-models) |
| 5 | [Benefits of Multithreading](#5-benefits-of-multithreading) |
| 6 | [CPU Scheduling Calculations](#6-cpu-scheduling-calculations) |
| 7 | [Quick Summary](#7-quick-summary) |
| 8 | [Practice Questions](#-practice-questions) |

---

## 1. What is a Thread?

### 📖 Concept Explanation

A **Thread** (also called a **lightweight process**) is the smallest unit of execution within a process. A process can have **multiple threads**, all sharing the same address space but each executing independently.

```
    ┌──────────────────── PROCESS ────────────────────┐
    │                                                  │
    │  SHARED among all threads:                       │
    │  ┌────────────────────────────────────────────┐  │
    │  │  Code Section (Text)                       │  │
    │  │  Data Section (Global variables)           │  │
    │  │  Heap (Dynamic memory)                     │  │
    │  │  Open Files, Signals, etc.                 │  │
    │  └────────────────────────────────────────────┘  │
    │                                                  │
    │  PRIVATE to each thread:                         │
    │  ┌────────────┐ ┌────────────┐ ┌────────────┐   │
    │  │  Thread 1  │ │  Thread 2  │ │  Thread 3  │   │
    │  │            │ │            │ │            │   │
    │  │ • Thread ID│ │ • Thread ID│ │ • Thread ID│   │
    │  │ • PC       │ │ • PC       │ │ • PC       │   │
    │  │ • Registers│ │ • Registers│ │ • Registers│   │
    │  │ • Stack    │ │ • Stack    │ │ • Stack    │   │
    │  │            │ │            │ │            │   │
    │  └────────────┘ └────────────┘ └────────────┘   │
    │                                                  │
    └──────────────────────────────────────────────────┘
```

### 🏠 Real-World Analogy

Think of a **process as a house** and **threads as people living in it**:

| House (Process) | Person (Thread) |
|-----------------|-----------------|
| Shared kitchen, living room, bathroom | Shared code, data, heap, files |
| Each person has their own bedroom | Each thread has its own stack & registers |
| All share the same address (street, city) | All share the same address space |
| Creating a new person in the house = cheap | Creating a new thread = lightweight |
| Building a whole new house = expensive | Creating a new process = heavyweight |

### Why Threads?

```
    EXAMPLE: A Web Browser

    ┌────────────────── Browser Process ──────────────────┐
    │                                                      │
    │  Thread 1: Display page (render HTML/CSS)            │
    │  Thread 2: Download images from network              │
    │  Thread 3: Handle user input (clicks, typing)        │
    │  Thread 4: Run JavaScript                            │
    │  Thread 5: Check for notifications                   │
    │                                                      │
    │  All threads SHARE: DOM tree, page data, cache       │
    │  Each thread has its own: program counter, stack      │
    └──────────────────────────────────────────────────────┘
    
    Without threads: Browser freezes while downloading an image!
    With threads: All activities happen concurrently ✓
```

---

## 2. Process vs Thread

### 📊 Detailed Comparison

```
    PROCESS                                THREAD
    ───────                                ──────
    ┌───────────────────┐                  ┌───────────────────┐
    │    Process A       │                  │    Process A       │
    │                   │                  │                   │
    │ ┌──────────────┐  │                  │ ┌──────────────┐  │
    │ │ Code         │  │                  │ │ Code (shared)│  │
    │ ├──────────────┤  │                  │ ├──────────────┤  │
    │ │ Data         │  │                  │ │ Data (shared)│  │
    │ ├──────────────┤  │                  │ ├──────────────┤  │
    │ │ Heap         │  │                  │ │ Heap (shared)│  │
    │ ├──────────────┤  │                  │ ├───────┬──────┤  │
    │ │ Stack        │  │                  │ │Stack 1│Stack2│  │
    │ ├──────────────┤  │                  │ │(T1)   │(T2)  │  │
    │ │ PC, Registers│  │                  │ ├───────┼──────┤  │
    │ └──────────────┘  │                  │ │PC1,Reg│PC2,Rg│  │
    │                   │                  │ └───────┴──────┘  │
    │ Own address space │                  │ Shared addr space │
    └───────────────────┘                  └───────────────────┘
    
    Process B = completely                 Thread 2 = lightweight,
    separate copy                          shares Process A's memory
```

| Feature | Process | Thread |
|---------|---------|--------|
| **Definition** | Program in execution | Unit of execution within a process |
| **Address Space** | Own separate address space | Shares process's address space |
| **Creation Time** | Slow (heavy overhead) | Fast (lightweight) |
| **Context Switch** | Slow (need to switch address space) | Fast (same address space) |
| **Communication** | IPC needed (pipes, sockets, shared memory) | Direct (shared memory) |
| **Memory** | Each has own memory | Share code, data, heap; own stack |
| **Independence** | Independent — one crash doesn't affect others | Dependent — one thread crash can kill all |
| **Resource Usage** | More resources | Fewer resources |
| **Example** | Opening 2 separate Chrome windows | Multiple tabs in one Chrome window |
| **System Call (Linux)** | `fork()` | `pthread_create()` |

### ⚠️ Important Distinction

```
    When Thread 1 crashes in a process:
    ┌──────────────────────────────────┐
    │ Process A                        │
    │                                  │
    │  Thread 1: CRASHED! 💥           │
    │  Thread 2: ALSO DIES! ☠️         │
    │  Thread 3: ALSO DIES! ☠️         │
    │                                  │
    │  (All threads share address      │
    │   space — corruption affects all)│
    └──────────────────────────────────┘
    
    When Process A crashes:
    ┌──────────────┐  ┌──────────────┐
    │ Process A    │  │ Process B    │
    │ CRASHED! 💥  │  │ Still OK! ✓  │
    │              │  │              │
    └──────────────┘  └──────────────┘
    (Separate address spaces = isolation)
```

---

## 3. User-Level vs Kernel-Level Threads

### 📖 User-Level Threads (ULT)

Managed entirely by a **user-space thread library** (e.g., POSIX `pthreads`). The kernel is **not aware** of threads — it only sees the process.

```
    ┌────────────────── USER SPACE ──────────────────┐
    │                                                 │
    │   Application                                   │
    │   ┌─────────────────────────────────────┐       │
    │   │ Thread 1  Thread 2  Thread 3        │       │
    │   │    │         │         │            │       │
    │   │    └─────────┼─────────┘            │       │
    │   │              ▼                      │       │
    │   │    Thread Library                   │       │
    │   │    (creates, schedules,             │       │
    │   │     switches threads)              │       │
    │   └──────────────┬──────────────────────┘       │
    │                  │                               │
    ├──────────────────┼───────────────────────────────┤
    │              KERNEL                              │
    │                  ▼                               │
    │   ┌──────────────────────┐                      │
    │   │ Sees ONLY 1 process  │  (kernel-unaware)    │
    │   │ (doesn't know about  │                      │
    │   │  individual threads) │                      │
    │   └──────────────────────┘                      │
    └──────────────────────────────────────────────────┘
```

### 📖 Kernel-Level Threads (KLT)

Managed by the **OS kernel**. The kernel is **fully aware** of each thread and schedules them independently.

```
    ┌────────────────── USER SPACE ──────────────────┐
    │                                                 │
    │   Application                                   │
    │   ┌─────────────────────────────────────┐       │
    │   │ Thread 1  Thread 2  Thread 3        │       │
    │   └──────┬────────┬────────┬────────────┘       │
    │          │        │        │                     │
    ├──────────┼────────┼────────┼─────────────────────┤
    │          ▼        ▼        ▼    KERNEL           │
    │   ┌──────────────────────────────────────┐      │
    │   │ Kernel Thread 1  KT 2  KT 3         │      │
    │   │                                      │      │
    │   │ Kernel manages ALL threads           │      │
    │   │ independently                        │      │
    │   └──────────────────────────────────────┘      │
    └──────────────────────────────────────────────────┘
```

### Comparison

| Feature | User-Level Threads | Kernel-Level Threads |
|---------|-------------------|---------------------|
| **Managed by** | User-space thread library | Operating system kernel |
| **Kernel awareness** | Kernel unaware of threads | Kernel fully aware |
| **Creation/Switching** | Very fast (no kernel call) | Slower (requires system call) |
| **Blocking** | If one thread blocks, ALL block | Only blocking thread blocks |
| **Multiprocessor** | Cannot use multiple CPUs | Can run on multiple CPUs |
| **OS support** | Works on any OS | Needs OS thread support |
| **Example** | Green threads (Java early), GNU Pth | Linux pthreads, Windows threads |
| **Scheduling** | Thread library decides | OS scheduler decides |

### ⚠️ Key Problem with User-Level Threads

```
    USER-LEVEL THREAD BLOCKING PROBLEM:
    
    ┌──────────────────────────────┐
    │ Process A                    │
    │                              │
    │  Thread 1: read(file)        │ ← Blocks on I/O
    │  Thread 2: [wants to run]    │ ← Can't run!
    │  Thread 3: [wants to run]    │ ← Can't run!
    │                              │
    │  Kernel sees: Process A =    │
    │  BLOCKED (doesn't know about │
    │  Thread 2 and 3)             │
    └──────────────────────────────┘
    
    ENTIRE process is blocked even though Threads 2,3 could run!
    
    With KERNEL threads:
    ┌──────────────────────────────┐
    │ Process A                    │
    │                              │
    │  Thread 1: read(file)        │ ← Blocks on I/O
    │  Thread 2: [RUNNING] ✓       │ ← Kernel knows, schedules it
    │  Thread 3: [READY]           │ ← Can run next
    │                              │
    └──────────────────────────────┘
```

---

## 4. Multithreading Models

### 📖 How User Threads Map to Kernel Threads

There are three models for mapping user-level threads (ULT) to kernel-level threads (KLT):

### 4.1 Many-to-One Model

```
    ┌─────────────────────────────────────┐
    │          MANY-TO-ONE MODEL           │
    │                                     │
    │   User Threads    Kernel Thread     │
    │                                     │
    │      T1 ──┐                         │
    │      T2 ──┼──────► KT1              │
    │      T3 ──┤                         │
    │      T4 ──┘                         │
    │                                     │
    │  Many user threads → 1 kernel thread│
    │                                     │
    │  ✓ Fast creation/switching          │
    │  ✗ One block = all block            │
    │  ✗ No true parallelism              │
    │                                     │
    │  Example: Green Threads (Solaris)   │
    └─────────────────────────────────────┘
```

### 4.2 One-to-One Model

```
    ┌─────────────────────────────────────┐
    │          ONE-TO-ONE MODEL            │
    │                                     │
    │   User Threads    Kernel Threads    │
    │                                     │
    │      T1 ─────────► KT1             │
    │      T2 ─────────► KT2             │
    │      T3 ─────────► KT3             │
    │      T4 ─────────► KT4             │
    │                                     │
    │  Each user thread → 1 kernel thread │
    │                                     │
    │  ✓ True parallelism on multi-core   │
    │  ✓ One block doesn't block others   │
    │  ✗ Creating thread = kernel overhead│
    │  ✗ Limited by kernel thread count   │
    │                                     │
    │  Example: Linux pthreads, Windows   │
    └─────────────────────────────────────┘
```

### 4.3 Many-to-Many Model

```
    ┌─────────────────────────────────────┐
    │        MANY-TO-MANY MODEL            │
    │                                     │
    │   User Threads    Kernel Threads    │
    │                                     │
    │      T1 ──┬──────► KT1             │
    │      T2 ──┤                         │
    │      T3 ──┼──────► KT2             │
    │      T4 ──┤                         │
    │      T5 ──┴──────► KT3             │
    │                                     │
    │  M user threads → N kernel threads  │
    │  (M ≥ N)                            │
    │                                     │
    │  ✓ Best of both worlds              │
    │  ✓ True parallelism                 │
    │  ✓ No unnecessary kernel threads    │
    │  ✗ Complex to implement             │
    │                                     │
    │  Example: Solaris LWP, IRIX         │
    └─────────────────────────────────────┘
```

### 4.4 Two-Level Model

```
    ┌─────────────────────────────────────┐
    │         TWO-LEVEL MODEL              │
    │                                     │
    │   User Threads    Kernel Threads    │
    │                                     │
    │      T1 ──┬──────► KT1             │
    │      T2 ──┘                         │
    │      T3 ─────────► KT2 (bound)     │
    │      T4 ──┬──────► KT3             │
    │      T5 ──┘                         │
    │                                     │
    │  Like Many-to-Many BUT allows       │
    │  binding a thread to a specific     │
    │  kernel thread (for critical tasks) │
    │                                     │
    │  Example: HP-UX, Tru64 UNIX         │
    └─────────────────────────────────────┘
```

### Model Comparison Table

| Feature | Many-to-One | One-to-One | Many-to-Many |
|---------|-------------|------------|--------------|
| **Parallelism** | ❌ No | ✅ Yes | ✅ Yes |
| **Blocking** | All block | Only one blocks | Flexible |
| **Thread creation** | Fast | Slow (kernel call) | Medium |
| **Complexity** | Simple | Simple | Complex |
| **Scalability** | Poor | Limited by kernel | Good |
| **Modern usage** | Rare | ✅ Most common | Some UNIX |

---

## 5. Benefits of Multithreading

### 📖 Four Major Benefits

```
    ┌──────────────────────────────────────────────────────┐
    │            BENEFITS OF MULTITHREADING                  │
    ├──────────────┬──────────────┬────────────┬────────────┤
    │ Responsiveness │ Resource    │ Economy    │ Scalability│
    │              │ Sharing      │            │            │
    │ UI stays     │ Threads share│ Thread     │ Threads can│
    │ responsive   │ code, data,  │ creation   │ run on     │
    │ while work   │ files of     │ is 30x     │ multiple   │
    │ happens in   │ their process│ faster than│ cores      │
    │ background   │              │ process    │            │
    │              │              │ creation   │            │
    └──────────────┴──────────────┴────────────┴────────────┘
```

| Benefit | Description | Example |
|---------|-------------|---------|
| **Responsiveness** | Application remains responsive even if part is blocked | Word processor: typing while spell-check runs |
| **Resource Sharing** | Threads share process memory — no IPC needed | Web server: all threads share cached pages |
| **Economy** | Thread creation ~30x faster than process creation | Creating 1000 threads vs 1000 processes |
| **Scalability** | Threads can run on different CPU cores in parallel | Video encoding using all 8 cores |

### Thread Creation Time Comparison

```
    CREATION TIME (approximate):
    
    Process Creation:  █████████████████████████████████████  ~1ms
    Thread Creation:   █                                      ~33μs
    
    CONTEXT SWITCH TIME:
    
    Process Switch:    █████████████████████████████████████  ~10μs
    Thread Switch:     ████                                   ~1μs
    
    MEMORY:
    
    Process:           █████████████████████████████████████  ~10MB+
    Thread:            ████                                   ~1MB (stack)
```

---

## 6. CPU Scheduling Calculations

### 📖 Complete Worked Examples

This section provides detailed, step-by-step solutions for all scheduling algorithms using the **same set of processes** for easy comparison.

### Common Process Set

| Process | Arrival Time (AT) | Burst Time (BT) |
|---------|-------------------|------------------|
| P1 | 0 | 8 |
| P2 | 1 | 4 |
| P3 | 2 | 9 |
| P4 | 3 | 5 |

---

### 6.1 FCFS Solution

```
    Order: P1 → P2 → P3 → P4 (order of arrival)
    
    Gantt Chart:
    ┌────────────────┬──────────┬──────────────────┬──────────────┐
    │       P1       │    P2    │       P3         │     P4       │
    └────────────────┴──────────┴──────────────────┴──────────────┘
    0                8         12                 21             26
```

| Process | AT | BT | CT | TAT = CT-AT | WT = TAT-BT | RT = First-AT |
|---------|-----|-----|-----|-------------|-------------|---------------|
| P1 | 0 | 8 | 8 | 8 | 0 | 0 |
| P2 | 1 | 4 | 12 | 11 | 7 | 7 |
| P3 | 2 | 9 | 21 | 19 | 10 | 10 |
| P4 | 3 | 5 | 26 | 23 | 18 | 18 |

| Metric | Value |
|--------|-------|
| **Avg TAT** | (8+11+19+23)/4 = **15.25** |
| **Avg WT** | (0+7+10+18)/4 = **8.75** |
| **Avg RT** | (0+7+10+18)/4 = **8.75** |

---

### 6.2 SJF (Non-Preemptive) Solution

```
    Step 1: t=0, only P1 available → Run P1 (BT=8)
    Step 2: t=8, P2(4), P3(9), P4(5) available → Run P2 (shortest=4)
    Step 3: t=12, P3(9), P4(5) available → Run P4 (shortest=5)
    Step 4: t=17, P3(9) → Run P3
    
    Gantt Chart:
    ┌────────────────┬──────────┬──────────────┬──────────────────┐
    │       P1       │    P2    │     P4       │       P3         │
    └────────────────┴──────────┴──────────────┴──────────────────┘
    0                8         12             17                 26
```

| Process | AT | BT | CT | TAT | WT | RT |
|---------|-----|-----|-----|-----|-----|-----|
| P1 | 0 | 8 | 8 | 8 | 0 | 0 |
| P2 | 1 | 4 | 12 | 11 | 7 | 7 |
| P3 | 2 | 9 | 26 | 24 | 15 | 15 |
| P4 | 3 | 5 | 17 | 14 | 9 | 9 |

| Metric | Value |
|--------|-------|
| **Avg TAT** | (8+11+24+14)/4 = **14.25** |
| **Avg WT** | (0+7+15+9)/4 = **7.75** |

---

### 6.3 SRTF (Preemptive SJF) Solution

```
    t=0: P1(rem=8) → Run P1
    t=1: P1(rem=7), P2(rem=4) → P2 shorter, PREEMPT P1, Run P2
    t=2: P1(rem=7), P2(rem=3), P3(rem=9) → P2 still shortest, Run P2
    t=3: P1(rem=7), P2(rem=2), P3(rem=9), P4(rem=5) → P2 shortest, Run P2
    t=5: P2 DONE. P1(7), P3(9), P4(5) → P4 shortest, Run P4
    t=10: P4 DONE. P1(7), P3(9) → P1 shorter, Run P1
    t=17: P1 DONE. P3(9) → Run P3
    t=26: P3 DONE.
    
    Gantt Chart:
    ┌────┬──────────┬──────────────┬──────────────┬──────────────────┐
    │ P1 │    P2    │     P4       │     P1       │       P3         │
    └────┴──────────┴──────────────┴──────────────┴──────────────────┘
    0    1          5             10             17                 26
```

| Process | AT | BT | CT | TAT | WT | RT |
|---------|-----|-----|-----|-----|-----|-----|
| P1 | 0 | 8 | 17 | 17 | 9 | 0 |
| P2 | 1 | 4 | 5 | 4 | 0 | 0 |
| P3 | 2 | 9 | 26 | 24 | 15 | 15 |
| P4 | 3 | 5 | 10 | 7 | 2 | 2 |

| Metric | Value |
|--------|-------|
| **Avg TAT** | (17+4+24+7)/4 = **13.0** |
| **Avg WT** | (9+0+15+2)/4 = **6.5** |

---

### 6.4 Round Robin Solution (TQ = 3)

```
    Time Quantum = 3

    t=0:  Queue: [P1]  → Run P1 for 3. P1 rem=5
    t=3:  Queue: [P2, P3, P4, P1]  → Run P2 for 3. P2 rem=1
    t=6:  Queue: [P3, P4, P1, P2]  → Run P3 for 3. P3 rem=6
    t=9:  Queue: [P4, P1, P2, P3]  → Run P4 for 3. P4 rem=2
    t=12: Queue: [P1, P2, P3, P4]  → Run P1 for 3. P1 rem=2
    t=15: Queue: [P2, P3, P4, P1]  → Run P2 for 1. P2 DONE ✓
    t=16: Queue: [P3, P4, P1]      → Run P3 for 3. P3 rem=3
    t=19: Queue: [P4, P1, P3]      → Run P4 for 2. P4 DONE ✓
    t=21: Queue: [P1, P3]          → Run P1 for 2. P1 DONE ✓
    t=23: Queue: [P3]              → Run P3 for 3. P3 DONE ✓
    
    Gantt Chart:
    ┌─────┬─────┬─────┬─────┬─────┬──┬─────┬────┬────┬─────┐
    │ P1  │ P2  │ P3  │ P4  │ P1  │P2│ P3  │ P4 │ P1 │ P3  │
    │(0-3)│(3-6)│(6-9)│(9-12)│(12-15)│(15-16)│(16-19)│(19-21)│(21-23)│(23-26)│
    └─────┴─────┴─────┴─────┴─────┴──┴─────┴────┴────┴─────┘
    0     3     6     9    12    15 16   19   21   23   26
```

| Process | AT | BT | CT | TAT | WT | RT |
|---------|-----|-----|-----|-----|-----|-----|
| P1 | 0 | 8 | 23 | 23 | 15 | 0 |
| P2 | 1 | 4 | 16 | 15 | 11 | 2 |
| P3 | 2 | 9 | 26 | 24 | 15 | 4 |
| P4 | 3 | 5 | 21 | 18 | 13 | 6 |

| Metric | Value |
|--------|-------|
| **Avg TAT** | (23+15+24+18)/4 = **20.0** |
| **Avg WT** | (15+11+15+13)/4 = **13.5** |
| **Avg RT** | (0+2+4+6)/4 = **3.0** (Best response time!) |

---

### 6.5 Priority Scheduling Solution (Non-Preemptive)

Assume lower number = higher priority.

| Process | AT | BT | Priority |
|---------|-----|-----|----------|
| P1 | 0 | 8 | 3 |
| P2 | 1 | 4 | 1 (Highest) |
| P3 | 2 | 9 | 4 (Lowest) |
| P4 | 3 | 5 | 2 |

```
    t=0: Only P1 (Pri=3) → Run P1 (non-preemptive, so completes)
    t=8: P2(Pri=1), P3(Pri=4), P4(Pri=2) → Run P2 (highest priority)
    t=12: P3(Pri=4), P4(Pri=2) → Run P4 (higher priority)
    t=17: P3(Pri=4) → Run P3
    
    Gantt Chart:
    ┌────────────────┬──────────┬──────────────┬──────────────────┐
    │       P1       │    P2    │     P4       │       P3         │
    └────────────────┴──────────┴──────────────┴──────────────────┘
    0                8         12             17                 26
```

| Process | AT | BT | Pri | CT | TAT | WT |
|---------|-----|-----|------|-----|-----|-----|
| P1 | 0 | 8 | 3 | 8 | 8 | 0 |
| P2 | 1 | 4 | 1 | 12 | 11 | 7 |
| P3 | 2 | 9 | 4 | 26 | 24 | 15 |
| P4 | 3 | 5 | 2 | 17 | 14 | 9 |

| Metric | Value |
|--------|-------|
| **Avg TAT** | (8+11+24+14)/4 = **14.25** |
| **Avg WT** | (0+7+15+9)/4 = **7.75** |

---

### 6.6 Comparison of All Algorithms (Same Data)

```
    AVERAGE WAITING TIME COMPARISON:
    
    FCFS:         ████████████████████████████████████  8.75
    SJF:          ███████████████████████████████       7.75
    SRTF:         ██████████████████████████            6.50  ← BEST WT
    Priority:     ███████████████████████████████       7.75
    Round Robin:  ██████████████████████████████████████████████████████  13.50
    
    AVERAGE RESPONSE TIME COMPARISON:
    
    FCFS:         ████████████████████████████████████  8.75
    SJF:          ███████████████████████████████       7.75
    SRTF:         ██████████████████                    4.25
    Priority:     ███████████████████████████████       7.75
    Round Robin:  ████████████                          3.00  ← BEST RT
```

| Algorithm | Avg TAT | Avg WT | Avg RT | Best For |
|-----------|---------|--------|--------|----------|
| FCFS | 15.25 | 8.75 | 8.75 | Simple batch jobs |
| SJF | 14.25 | 7.75 | 7.75 | Known burst times |
| SRTF | 13.0 | **6.5** | 4.25 | Minimizing wait |
| Priority | 14.25 | 7.75 | 7.75 | Prioritized tasks |
| RR (TQ=3) | 20.0 | 13.5 | **3.0** | Interactive systems |

---

## 7. Quick Summary

```
┌────────────────────────────────────────────────────────────────┐
│                 CHAPTER 3: QUICK REVISION                       │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  THREADS:                                                      │
│  ★ Thread = Lightweight process, smallest unit of execution    │
│  ★ Threads SHARE: Code, Data, Heap, Files                      │
│  ★ Threads OWN: Stack, PC, Registers, Thread ID                │
│                                                                │
│  USER vs KERNEL THREADS:                                       │
│  ★ User-Level: Fast, but one block = all block                  │
│  ★ Kernel-Level: Slower creation, but true parallelism          │
│                                                                │
│  MULTITHREADING MODELS:                                        │
│  ★ Many-to-One: Many ULT → 1 KLT (no parallelism)             │
│  ★ One-to-One: 1 ULT → 1 KLT (most common, Linux/Windows)     │
│  ★ Many-to-Many: M ULT → N KLT (flexible, complex)            │
│                                                                │
│  CPU SCHEDULING TAKEAWAYS:                                     │
│  ★ SRTF gives best average waiting time                        │
│  ★ Round Robin gives best response time                        │
│  ★ FCFS and RR don't cause starvation                          │
│  ★ SJF/SRTF/Priority can cause starvation                     │
│                                                                │
│  FORMULAS:                                                     │
│  ★ TAT = CT - AT                                               │
│  ★ WT = TAT - BT                                               │
│  ★ RT = First run time - AT                                    │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 📝 Practice Questions

### 🟢 Level 1: One-Line Answer Questions

| # | Question | Answer |
|---|----------|--------|
| 1 | What is a thread? | A thread is the smallest unit of CPU execution within a process, sharing code/data but having its own stack. |
| 2 | What do threads within a process share? | Code section, data section, heap, open files, and signals. |
| 3 | What is private to each thread? | Thread ID, program counter, registers, and stack. |
| 4 | What is the most common multithreading model in modern OS? | One-to-One model (used by Linux and Windows). |
| 5 | Why is thread creation faster than process creation? | Threads share the parent process's address space; no need to duplicate memory. |
| 6 | What happens when a user-level thread blocks on I/O? | The entire process blocks because the kernel sees only one process. |
| 7 | Which model allows true parallelism on multi-core CPUs? | One-to-One and Many-to-Many models (not Many-to-One). |
| 8 | How fast is thread creation vs process creation? | Thread creation is approximately 30x faster than process creation. |
| 9 | Which scheduling algorithm gives the best average waiting time? | SRTF (Shortest Remaining Time First). |
| 10 | What does Round Robin scheduling degenerate to if TQ is very large? | FCFS (First Come First Served). |

---

### 🟡 Level 2: Multiple Choice Questions

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Threads within a process do NOT share: | A) Code B) Data C) **Stack** D) Files | **C** |
| 2 | Many-to-One model means: | A) 1 ULT → many KLT B) **Many ULT → 1 KLT** C) 1 ULT → 1 KLT D) None | **B** |
| 3 | In One-to-One model, if one thread blocks: | A) All threads block B) **Only that thread blocks** C) Process terminates D) Deadlock | **B** |
| 4 | Which is NOT a benefit of multithreading? | A) Responsiveness B) Resource sharing C) Economy D) **Increased memory isolation** | **D** |
| 5 | Kernel-level threads are managed by: | A) User library B) Compiler C) **OS kernel** D) Hardware | **C** |
| 6 | Which model cannot achieve true parallelism? | A) One-to-One B) Many-to-Many C) **Many-to-One** D) Two-Level | **C** |
| 7 | Thread context switch is faster than process context switch because: | A) Fewer registers B) **No address space switch** C) Fewer instructions D) Less I/O | **B** |
| 8 | In Linux, threads are created using: | A) fork() B) exec() C) **pthread_create()** D) clone() | **C** (also D is valid at kernel level) |
| 9 | Which scheduling gives best response time? | A) FCFS B) SJF C) SRTF D) **Round Robin** | **D** |
| 10 | A process with 3 threads has how many stacks? | A) 1 B) 2 C) **3** D) 0 | **C** |

---

### 🔴 Level 3: Tricky Conceptual MCQs

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | If a process has 4 user-level threads and uses the Many-to-One model, how many threads can run in parallel on a 4-core CPU? | A) 4 B) 2 C) **1** D) 0 | **C** | Many-to-One maps all user threads to 1 kernel thread, so only 1 can run at a time. |
| 2 | Thread T1 modifies a global variable `x`. Will Thread T2 (same process) see the change? | A) No B) **Yes, immediately** C) Only after synchronization D) Depends on OS | **B** | Threads share the data section (global variables). But this can cause race conditions! |
| 3 | A process with multiple kernel-level threads is executing. If one thread calls `exit()`, what happens? | A) Only that thread terminates B) **The entire process terminates** C) Only user threads terminate D) Nothing | **B** | `exit()` terminates the entire process, including all its threads. Use `pthread_exit()` to exit only one thread. |
| 4 | In SRTF, process P1 (remaining=5) is running. P2 arrives with BT=5. What happens? | A) P1 is preempted B) **P1 continues** C) Both run D) Error | **B** | P1 remaining = P2 remaining = 5 (tie). In ties, the current process continues running. |
| 5 | RR with TQ=1 and only 1 process in the queue. What is the overhead? | A) Maximum B) **Minimum (zero context switches)** C) Medium D) Infinite | **B** | With only 1 process, no context switch occurs. Timer fires but there's nothing to switch to. |

---

### 🔵 Level 4: True / False

| # | Statement | Answer | Explanation |
|---|-----------|--------|-------------|
| 1 | A thread can exist without a process. | **False** | Threads exist within processes. No process = no thread. |
| 2 | User-level threads can run on multiple CPUs simultaneously. | **False** | Kernel sees one process → one CPU. Only kernel-level threads can achieve true parallelism. |
| 3 | Context switching between threads of the same process is faster than between different processes. | **True** | No address space switch needed for same-process threads. |
| 4 | The One-to-One model is used by most modern operating systems. | **True** | Linux (NPTL), Windows, macOS all use One-to-One. |
| 5 | If one thread in a process crashes, other threads in that process are unaffected. | **False** | Threads share address space — one thread's crash corrupts shared memory, affecting all threads. |
| 6 | SRTF always gives better results than SJF. | **True** | SRTF is the preemptive version — it can react to new arrivals, always giving ≤ average WT than SJF. |
| 7 | Threads share the heap memory of their process. | **True** | Heap is shared among all threads in a process. |
| 8 | In Many-to-Many model, the number of kernel threads must equal the number of user threads. | **False** | M user threads map to N kernel threads where M ≥ N (not necessarily equal). |
| 9 | Round Robin scheduling is always better than FCFS. | **False** | For response time, yes. For throughput, RR has more overhead due to context switches. |
| 10 | `pthread_create()` creates a new process. | **False** | `pthread_create()` creates a new thread, not a process. `fork()` creates a new process. |

---

### 🟣 Level 5: Scenario-Based Questions

**Scenario 1:**
> A web server handles 1000 concurrent connections. Should it create 1000 processes or 1000 threads? Justify.

**Answer:** **1000 threads** is the better choice. Reasons:
1. Thread creation is ~30x faster than process creation
2. Threads share memory (server data, caches, connection pool) — no duplication
3. Thread context switches are faster (same address space)
4. 1000 processes would consume significantly more memory (~10MB each = 10GB vs ~1MB per thread stack = 1GB)
5. Inter-thread communication is simple (shared variables) vs IPC for processes

However, modern servers use **thread pools** to avoid creating/destroying threads repeatedly.

---

**Scenario 2:**
> Process P has 3 threads: T1 (downloading), T2 (rendering), T3 (user input). If T1 calls a blocking `read()` and the system uses Many-to-One threading model, what happens to T2 and T3?

**Answer:** **T2 and T3 will also block.** In Many-to-One model, all user threads map to a single kernel thread. When T1 makes a blocking system call, the kernel blocks the entire process (since it only sees one kernel thread). T2 (rendering) and T3 (user input) cannot run until T1's I/O completes. This is why Many-to-One is rarely used today — One-to-One (Linux/Windows) would allow T2 and T3 to continue.

---

**Scenario 3:**
> Given: P1(AT=0, BT=3), P2(AT=1, BT=6), P3(AT=2, BT=4), P4(AT=3, BT=2), Time Quantum=2. Calculate average WT for Round Robin.

**Answer:**
```
t=0-2:  P1(rem=1), Queue: [P2,P3,P1]     | P4 arrives at t=3
t=2-4:  P2(rem=4), Queue: [P3,P4,P1,P2]
t=4-6:  P3(rem=2), Queue: [P4,P1,P2,P3]
t=6-8:  P4(rem=0)✓, Queue: [P1,P2,P3]
t=8-9:  P1(rem=0)✓, Queue: [P2,P3]
t=9-11: P2(rem=2), Queue: [P3,P2]
t=11-13: P3(rem=0)✓, Queue: [P2]
t=13-15: P2(rem=0)✓
```
| Process | AT | BT | CT | TAT | WT |
|---------|-----|-----|-----|-----|-----|
| P1 | 0 | 3 | 9 | 9 | 6 |
| P2 | 1 | 6 | 15 | 14 | 8 |
| P3 | 2 | 4 | 13 | 11 | 7 |
| P4 | 3 | 2 | 8 | 5 | 3 |
Average WT = (6+8+7+3)/4 = **6.0**

---

**Scenario 4:**
> A game engine has a main thread, a physics thread, and an audio thread. Explain which threading model would be best and why.

**Answer:** The **One-to-One model** is best for a game engine. Reasons:
1. Physics calculations are CPU-intensive — they need a dedicated CPU core
2. Audio processing must not be blocked by physics or rendering
3. One-to-One ensures each thread can run on a separate core (true parallelism on multi-core CPUs)
4. If physics thread blocks (unlikely, but possible), audio and main threads continue
5. Modern game engines (Unreal, Unity) all use kernel-level threads with One-to-One mapping

---

**Scenario 5:**
> Compare: (a) Chrome opening each tab as a separate process vs (b) Firefox historically using threads for tabs. What are the trade-offs?

**Answer:**

| Aspect | Chrome (Processes) | Firefox (Threads) |
|--------|-------------------|-------------------|
| **Isolation** | ✅ One tab crash doesn't affect others | ❌ One tab can crash all tabs |
| **Memory** | ❌ Higher (each process duplicates code) | ✅ Lower (shared code/data) |
| **Security** | ✅ Sandboxed — compromised tab can't access others | ❌ Shared memory = security risk |
| **Communication** | ❌ Slower (IPC needed between tabs) | ✅ Faster (shared memory) |
| **RAM Usage** | ❌ Chrome is known for high RAM usage | ✅ More memory efficient |

Chrome chose **security and stability** over memory efficiency. Firefox later adopted a hybrid approach (Project Electrolysis) with multiple processes.

---

### 🟤 Level 6: Advanced Real-World Application Questions

**Q1. Java's thread model vs Python's GIL — how does the OS see these differently?**

| Aspect | Java (JVM Threads) | Python (CPython + GIL) |
|--------|---------------------|------------------------|
| **Thread model** | One-to-One (maps to OS threads) | One-to-One, but GIL serializes execution |
| **True parallelism** | Yes — runs on multiple CPU cores | No — GIL allows only 1 Python thread to run at a time |
| **OS visibility** | OS schedules each Java thread independently | OS creates real threads, but GIL is a lock in user space |
| **CPU-bound tasks** | Scales with cores (8 threads = 8x on 8 cores) | No speedup (GIL bottleneck) |
| **I/O-bound tasks** | Threads release lock during I/O | GIL released during I/O — threads can overlap |
| **Workaround** | N/A | Use `multiprocessing` module (separate processes) |

**Real-world impact**: A Python web server using `threading` for CPU-heavy tasks won't scale. Use `multiprocessing` or `asyncio`. Java Spring Boot scales naturally on multi-core.

---

**Q2. NodeJS uses a single thread with an event loop. How does it handle 10,000 concurrent connections?**

**Answer:** NodeJS's architecture:
```
Single JavaScript Thread
         │
         ▼
    Event Loop
    ┌──────────────────────────────────┐
    │  Check for pending callbacks     │
    │  → I/O callbacks → timers       │
    │  → setImmediate → close events   │
    └──────────────────────────────────┘
         │
         ▼
    libuv Thread Pool (4-128 threads)
    ┌─────────────────────────────────────┐
    │ File I/O  │ DNS  │ Crypto │ Others  │
    │ (thread 1)│ (t2) │ (t3)   │ (t4)   │
    └─────────────────────────────────────┘
```
- **Key**: All I/O is **non-blocking**. NodeJS registers a callback and immediately handles the next request.
- When I/O completes (OS sends interrupt), the callback is queued in the event loop.
- **10,000 connections** = 10,000 registered callbacks waiting for I/O — not 10,000 threads!
- **OS perspective**: NodeJS is 1 main thread + libuv pool. Far fewer context switches than a multi-threaded server with 10,000 threads.

---

**Q3. A database like PostgreSQL uses both processes and threads. Explain its architecture.**

**Answer:**

```
PostgreSQL Architecture:
┌─────────────────────────────────────────────┐
│  postmaster (master process - PID 1234)      │
│                                             │
│  Forks a new process per client connection: │
│  ├── backend process 1 (client A - PID 5001)│
│  ├── backend process 2 (client B - PID 5002)│
│  └── backend process 3 (client C - PID 5003)│
│                                             │
│  Background worker processes:               │
│  ├── autovacuum launcher                   │
│  ├── WAL writer (transaction log)           │
│  ├── checkpointer                           │
│  └── background writer                     │
│                                             │
│  Shared memory (between ALL processes):     │
│  └── shared_buffers (page cache for data)  │
└─────────────────────────────────────────────┘
```
**Why processes, not threads?** Crash isolation — one client's query crash doesn't kill the database. OS kills only that backend process. Contrast this with MySQL (which uses threads per connection) — a thread crash can corrupt shared state.

---

**Q4. Given P1(AT=0,BT=6), P2(AT=2,BT=4), P3(AT=4,BT=2), P4(AT=6,BT=8). TQ=3. Draw Gantt chart for Round Robin and calculate average response time.**

**Answer:**
```
Queue events:
t=0: P1 arrives → Queue:[P1]
t=0-3: P1 runs (rem=3)   → Queue:[P2(arr t=2),P3(arr t=4),P1]
t=3-6: P2 runs (rem=1)   → At t=4: P3 joins. At t=5: P2 done! Queue:[P3,P1,P4(arr t=6)]
       Wait: t=3-5: P2(rem=4-2=2 in 2 units → done at t=5). Queue at t=5:[P3,P1]
       At t=6 P4 joins.
t=5-7: P3 runs (rem=0) done at t=7. Queue:[P1,P4]
t=7-10: P1 runs (rem=3-3=0) done at t=10. Queue:[P4]
t=10-13: P4 runs (rem=5). Queue:[P4]
t=13-16: P4 runs (rem=2). Done at t=15.

Gantt: |P1(0-3)|P2(3-5)|P3(5-7)|P1(7-10)|P4(10-13)|P4(13-15)|
```

| Process | AT | BT | CT | TAT | WT | Response Time |
|---------|----|----|----|----|----|----|
| P1      |  0 |  6 | 10 | 10 |  4 | 0 (first run at t=0) |
| P2      |  2 |  4 |  5 |  3 | -1?| 1 (first run at t=3) |
| P3      |  4 |  2 |  7 |  3 |  1 | 1 (first run at t=5) |
| P4      |  6 |  8 | 15 |  9 |  1 | 4 (first run at t=10) |

**Response Time** = First CPU allocation time - Arrival Time  
Average Response Time = (0+1+1+4)/4 = **1.5** → RR excels at response time!

---

**Q5. How does Android manage thousands of app "processes" with only 4-8 GB RAM?**

**Answer:** Android's process management uses **Low Memory Killer (LMK)**:

```
Process Import Levels (highest to lowest):
1. Foreground process  (app user is using)      → Never killed
2. Visible process     (partially visible)       → Rarely killed  
3. Service process     (music player, sync)      → Killed if low memory
4. Cached process      (recently used, in background) → First to be killed
5. Empty process       (no active components)    → Killed immediately when needed
```

**Key mechanisms**:
- **Zygote**: A pre-forked template process — all Android apps are forked from Zygote. No full OS initialization needed for each app.
- **Sharing**: All apps share the same Android runtime (ART) libraries via copy-on-write pages
- **Swapping**: Android 11+ supports compressed RAM swap (ZRAM) — inactive pages compressed in memory
- **Inter-process**: Android uses **Binder IPC** (a custom kernel driver) for communication between app processes — far faster than standard Unix pipes

---

> **← [Previous: 02 - Process Management](02_Process_Management.md) | [Next: 04 - Process Synchronization →](04_Process_Synchronization.md)**
