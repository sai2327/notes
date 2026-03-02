# 📘 Chapter 2: Process Management & CPU Scheduling

> **"A process is a program in execution — it is the fundamental unit of work in an operating system."**

---

## 📑 Table of Contents

| # | Topic |
|---|-------|
| 1 | [Process Concept](#1-process-concept) |
| 2 | [Process States](#2-process-states) |
| 3 | [Process Control Block (PCB)](#3-process-control-block-pcb) |
| 4 | [Context Switching](#4-context-switching) |
| 5 | [CPU Scheduling Concepts](#5-cpu-scheduling-concepts) |
| 6 | [FCFS Scheduling](#6-fcfs---first-come-first-served) |
| 7 | [SJF Scheduling](#7-sjf---shortest-job-first) |
| 8 | [SRTF Scheduling](#8-srtf---shortest-remaining-time-first) |
| 9 | [Priority Scheduling](#9-priority-scheduling) |
| 10 | [Round Robin Scheduling](#10-round-robin-scheduling) |
| 11 | [Multilevel Queue Scheduling](#11-multilevel-queue-scheduling) |
| 12 | [Scheduling Comparison](#12-complete-scheduling-comparison) |
| 13 | [Quick Summary](#13-quick-summary) |
| 14 | [Practice Questions](#-practice-questions) |

---

## 1. Process Concept

### 📖 Concept Explanation

A **Process** is a **program in execution**. A program is a passive entity (a file on disk), while a process is an **active entity** with a program counter, allocated memory, and resources.

```
    PROGRAM (Passive)                    PROCESS (Active)
    ─────────────────                    ────────────────
    ┌────────────────┐     LOADING       ┌────────────────────────┐
    │                │     INTO          │  ┌──────────────────┐  │
    │   hello.c      │     MEMORY        │  │    STACK         │  │
    │   (source)     │ ──────────►      │  │ (function calls, │  │
    │                │                   │  │  local variables)│  │
    │   hello.exe    │                   │  ├──────────────────┤  │
    │   (binary)     │                   │  │    HEAP          │  │
    │                │                   │  │ (dynamic memory) │  │
    │  Stored on     │                   │  ├──────────────────┤  │
    │  DISK          │                   │  │    DATA          │  │
    │                │                   │  │ (global vars)    │  │
    └────────────────┘                   │  ├──────────────────┤  │
                                         │  │    TEXT (CODE)    │  │
    Same program can create              │  │ (instructions)   │  │
    MULTIPLE processes!                  │  └──────────────────┘  │
                                         │                        │
    chrome.exe → 10 tabs = 10 processes  │  Lives in RAM          │
                                         └────────────────────────┘
```

### Process Memory Layout (Detailed)

```
    HIGH ADDRESS
    ┌──────────────────────────────┐  ◄── 0xFFFFFFFF
    │                              │
    │         STACK                │  ← Function calls, local variables
    │         ↓ grows downward     │     return addresses, parameters
    │                              │
    ├──────────────────────────────┤
    │                              │
    │    (Free space between       │
    │     stack and heap)          │
    │                              │
    ├──────────────────────────────┤
    │         ↑ grows upward       │
    │         HEAP                 │  ← malloc(), new, dynamic allocation
    │                              │
    ├──────────────────────────────┤
    │    Uninitialized Data (BSS)  │  ← Global vars not initialized
    ├──────────────────────────────┤
    │    Initialized Data          │  ← Global vars with initial values
    │    (Data Segment)            │     e.g., int x = 5;
    ├──────────────────────────────┤
    │                              │
    │         TEXT (Code)          │  ← Machine instructions
    │         (Read Only)          │     Program counter points here
    │                              │
    └──────────────────────────────┘  ◄── 0x00000000
    LOW ADDRESS
```

### 🏠 Real-World Analogy

| Concept | Analogy |
|---------|---------|
| Program | A recipe book (instructions, stored on shelf) |
| Process | Actually cooking the recipe (active, using stove and ingredients) |
| Multiple processes from same program | Two chefs cooking the same recipe simultaneously in separate kitchens |

---

## 2. Process States

### 📖 The 5-State Process Model

A process goes through several states during its lifetime:

```
                          ┌──────────────────────────────────────────┐
                          │         PROCESS STATE DIAGRAM             │
                          └──────────────────────────────────────────┘
                                         
                                    admitted
            ┌─────────┐  ──────────►  ┌─────────┐
            │   NEW   │               │  READY  │◄────────────────┐
            └─────────┘               └────┬────┘                 │
                                           │                      │
                                 scheduler │              interrupt│
                                 dispatch  │              (preempt)│
                                           │                      │
                                           ▼                      │
                                      ┌─────────┐                │
                                      │ RUNNING │────────────────┘
                                      └────┬────┘
                                           │
                          ┌────────────────┤────────────────┐
                          │                │                │
                    I/O or│            exit │          timeout│
                    event │                │                │
                    wait  │                │                │
                          ▼                ▼                │
                    ┌──────────┐    ┌────────────┐         │
                    │ WAITING  │    │ TERMINATED │         │
                    │(BLOCKED) │    └────────────┘         │
                    └─────┬────┘                           │
                          │                                │
                          │  I/O or event                  │
                          │  completion                    │
                          └────────────────────────────────┘
                              (goes back to READY)
```

### State Descriptions

| State | Description | Example |
|-------|-------------|---------|
| **NEW** | Process is being created | `fork()` called, OS allocating resources |
| **READY** | Process loaded in memory, waiting for CPU | Process in ready queue, CPU is busy |
| **RUNNING** | Process is currently executing on CPU | CPU executing its instructions |
| **WAITING (BLOCKED)** | Process waiting for I/O or event | Waiting for disk read, user input, network response |
| **TERMINATED** | Process finished execution | `exit()` called, OS reclaiming resources |

### 🏠 Real-World Analogy

```
    RESTAURANT ANALOGY:
    
    NEW        → Customer enters restaurant, getting a table assigned
    READY      → Customer seated, menu given, waiting for waiter's attention
    RUNNING    → Waiter is taking order / serving food to this customer
    WAITING    → Customer ordered, waiting for food to be cooked (I/O)
    TERMINATED → Customer finished eating, paid bill, left restaurant
```

### 7-State Model (with Suspend States)

```
    ┌─────────┐     ┌─────────┐     ┌─────────┐
    │   NEW   │────►│  READY  │────►│ RUNNING │
    └─────────┘     └────┬────┘     └────┬────┘
                         │               │
                    Swap │          I/O   │
                    Out  │          Wait  │
                         ▼               ▼
                  ┌────────────┐   ┌──────────┐
                  │  READY     │   │ WAITING  │
                  │ SUSPENDED  │   │(BLOCKED) │
                  └────────────┘   └────┬─────┘
                         ▲              │
                         │         Swap │
                         │         Out  │
                         │              ▼
                         │       ┌────────────┐
                         │       │  BLOCKED   │
                         └───────│ SUSPENDED  │
                          I/O    └────────────┘
                          done
    
    Suspended = Swapped out to disk (not in RAM)
```

---

## 3. Process Control Block (PCB)

### 📖 Concept Explanation

The **PCB** (also called **Task Control Block**) is a data structure maintained by the OS for **every process**. It contains all information the OS needs to manage the process.

```
    ┌─────────────────────────────────────────┐
    │      PROCESS CONTROL BLOCK (PCB)         │
    │          (One per process)                │
    ├─────────────────────────────────────────┤
    │                                          │
    │  ┌─ Process ID (PID)          : 2847    │
    │  │                                       │
    │  ├─ Process State             : READY   │
    │  │                                       │
    │  ├─ Program Counter (PC)      : 0x0040  │
    │  │  (next instruction address)           │
    │  │                                       │
    │  ├─ CPU Registers                        │
    │  │  ├─ Accumulator            : 42      │
    │  │  ├─ Stack Pointer          : 0xFF80  │
    │  │  └─ General Registers      : {...}   │
    │  │                                       │
    │  ├─ CPU Scheduling Info                  │
    │  │  ├─ Priority               : 5       │
    │  │  └─ Queue Pointers         : {...}   │
    │  │                                       │
    │  ├─ Memory Management Info               │
    │  │  ├─ Page Table Base        : 0x1000  │
    │  │  ├─ Segment Table          : {...}   │
    │  │  └─ Memory Limits          : 64MB    │
    │  │                                       │
    │  ├─ I/O Status Info                      │
    │  │  ├─ Open Files List        : [3,7,9] │
    │  │  └─ I/O Devices            : [disk1] │
    │  │                                       │
    │  ├─ Accounting Info                      │
    │  │  ├─ CPU Time Used          : 2.3s    │
    │  │  ├─ Time Limits            : 10s     │
    │  │  └─ Process Start Time     : 14:30   │
    │  │                                       │
    │  └─ Parent Process ID (PPID)  : 1024    │
    │                                          │
    └─────────────────────────────────────────┘
```

### 🏠 Real-World Analogy

The PCB is like a **patient file in a hospital**:
- Patient ID → Process ID
- Current ward → Process State
- Medical history → Accounting Info
- Current medications → Open resources / files
- Doctor's notes → Program counter, registers
- Insurance info → Priority, scheduling info

### ⚡ Important Points

- The PCB is stored in **kernel memory** (inaccessible to user programs)
- Every process has **exactly one** PCB
- During a **context switch**, the outgoing process's state is **saved** to its PCB, and the incoming process's state is **loaded** from its PCB
- In Linux, the PCB is implemented as `struct task_struct` (defined in `<linux/sched.h>`)

---

## 4. Context Switching

### 📖 Concept Explanation

**Context Switching** is the process of saving the state of the currently running process and loading the state of the next process to be run. This is how the OS achieves multitasking.

```
    CONTEXT SWITCH: Process P1 → Process P2
    
    ┌──────────┐                              ┌──────────┐
    │Process P1│                              │Process P2│
    │ RUNNING  │                              │  READY   │
    └────┬─────┘                              └──────────┘
         │
    ①    │ Interrupt / System Call / Timer expires
         │
         ▼
    ┌─────────────────────────────────────────────────────┐
    │              OPERATING SYSTEM (Kernel)               │
    │                                                      │
    │  ② Save P1's state to PCB₁                          │
    │     ┌──────────────────────┐                        │
    │     │ PCB₁                 │                        │
    │     │ PC = 0x0040          │                        │
    │     │ Registers = {...}    │                        │
    │     │ State = READY        │ ← was RUNNING         │
    │     └──────────────────────┘                        │
    │                                                      │
    │  ③ Load P2's state from PCB₂                        │
    │     ┌──────────────────────┐                        │
    │     │ PCB₂                 │                        │
    │     │ PC = 0x0078          │                        │
    │     │ Registers = {...}    │                        │
    │     │ State = RUNNING      │ ← was READY           │
    │     └──────────────────────┘                        │
    │                                                      │
    └─────────────────────────────────────────────────────┘
         │
    ④    ▼
    ┌──────────┐                              ┌──────────┐
    │Process P1│                              │Process P2│
    │  READY   │                              │ RUNNING  │
    └──────────┘                              └────┬─────┘
                                                   │
                                              P2 resumes
                                              from where
                                              it left off
```

### ⚠️ Key Points about Context Switching

| Point | Detail |
|-------|--------|
| **Pure Overhead** | Context switching is pure overhead — no useful work is done during the switch |
| **Time Taken** | Typically 1-10 microseconds on modern hardware |
| **What is saved?** | PC, registers, stack pointer, memory maps, open files |
| **Hardware support** | Modern CPUs have special instructions to speed up context switches |
| **Too many switches?** | System thrashes — spends more time switching than doing useful work |

---

## 5. CPU Scheduling Concepts

### 📖 Why CPU Scheduling?

When multiple processes are in the **READY** state, the OS must decide which one gets the CPU next. This decision is made by the **CPU Scheduler** (also called **Short-Term Scheduler**).

### Types of Scheduling

```
    ┌────────────────────────────────────────────────────────┐
    │              TYPES OF SCHEDULING                        │
    ├────────────────────────────────────────────────────────┤
    │                                                        │
    │  NON-PREEMPTIVE                PREEMPTIVE              │
    │  ───────────────               ──────────              │
    │                                                        │
    │  Once a process gets           OS CAN forcibly remove  │
    │  the CPU, it keeps it          a process from CPU      │
    │  until it:                     when:                   │
    │  • Finishes                    • Time quantum expires  │
    │  • Voluntarily waits           • Higher priority       │
    │    for I/O                       process arrives       │
    │                                                        │
    │  Examples:                     Examples:               │
    │  • FCFS                        • Round Robin           │
    │  • SJF (non-preemptive)        • SRTF                 │
    │  • Priority (non-preemptive)   • Priority (preemptive)│
    │                                                        │
    │  Analogy: A polite speaker     Analogy: A teacher can  │
    │  finishes before giving        interrupt a student     │
    │  the mic to the next person    mid-sentence            │
    │                                                        │
    └────────────────────────────────────────────────────────┘
```

### Important Scheduling Metrics

```
    ┌──────────────── Turnaround Time (TAT) ────────────────┐
    │                                                        │
    │  Arrival                                   Completion  │
    │  Time            Burst Time                Time        │
    │    │    Wait │◄─────────────────►│            │        │
    │    ▼    Time ▼                   ▼            ▼        │
    │    ├────┼────┼───────────────────┼────────────┤        │
    │    │Wait│    │    Execution      │            │        │
    │    │    │    │                   │            │        │
    │    ◄────►                                             │
    │  Response Time                                        │
    │  (time until first execution)                         │
    └────────────────────────────────────────────────────────┘
```

| Metric | Formula | Goal |
|--------|---------|------|
| **Arrival Time (AT)** | Given | When process enters ready queue |
| **Burst Time (BT)** | Given | CPU time needed by process |
| **Completion Time (CT)** | Calculated | When process finishes execution |
| **Turnaround Time (TAT)** | TAT = CT - AT | Should be **minimized** |
| **Waiting Time (WT)** | WT = TAT - BT | Should be **minimized** |
| **Response Time (RT)** | RT = First execution time - AT | Should be **minimized** |
| **Throughput** | Processes completed / Total time | Should be **maximized** |
| **CPU Utilization** | (Busy time / Total time) × 100% | Should be **maximized** |

---

## 6. FCFS - First Come First Served

### 📖 Concept

The simplest scheduling algorithm. Processes are executed in the **order they arrive** in the ready queue. It is **non-preemptive** — once a process starts, it runs to completion.

```
    FCFS = First Come, First Served (like a queue at a ticket counter)
    
    READY QUEUE:
    ┌────┬────┬────┬────┐
    │ P1 │ P2 │ P3 │ P4 │ ──► CPU
    └────┴────┴────┴────┘
    (First in, first out)
```

### 📝 Solved Example

| Process | Arrival Time (AT) | Burst Time (BT) |
|---------|-------------------|------------------|
| P1 | 0 | 6 |
| P2 | 1 | 4 |
| P3 | 2 | 8 |
| P4 | 3 | 2 |

**Gantt Chart:**
```
    ┌──────────────┬───────────┬────────────────────┬──────┐
    │      P1      │    P2     │        P3          │  P4  │
    │   (0 - 6)    │ (6 - 10) │    (10 - 18)       │(18-20)│
    └──────────────┴───────────┴────────────────────┴──────┘
    0              6          10                    18     20
```

**Calculations:**

| Process | AT | BT | CT | TAT = CT-AT | WT = TAT-BT |
|---------|-----|-----|-----|-------------|-------------|
| P1 | 0 | 6 | 6 | 6-0 = **6** | 6-6 = **0** |
| P2 | 1 | 4 | 10 | 10-1 = **9** | 9-4 = **5** |
| P3 | 2 | 8 | 18 | 18-2 = **16** | 16-8 = **8** |
| P4 | 3 | 2 | 20 | 20-3 = **17** | 17-2 = **15** |

**Average TAT** = (6 + 9 + 16 + 17) / 4 = **48/4 = 12.0**

**Average WT** = (0 + 5 + 8 + 15) / 4 = **28/4 = 7.0**

### 🏠 Real-World Analogy
A **billing counter** at a grocery store — whoever comes first gets served first, regardless of how many items they have.

### Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Simplest to implement | **Convoy Effect**: Short process behind long process waits excessively |
| No starvation | Poor average waiting time |
| Fair (order of arrival) | Not suitable for time-sharing systems |
| Low scheduling overhead | Non-preemptive — not responsive |

### ⚠️ Convoy Effect (FCFS Problem)

```
    CONVOY EFFECT:
    
    P1 (BT=100)  P2 (BT=2)  P3 (BT=3)  P4 (BT=1)
    
    Gantt:
    ┌────────────────────────────────────────┬──┬───┬─┐
    │                P1                      │P2│P3 │P4│
    └────────────────────────────────────────┴──┴───┴─┘
    0                                       100 102 105 106
    
    P2 with BT=2 has to wait 99 time units! 😱
    
    Average WT = (0 + 99 + 100 + 102) / 4 = 75.25
    
    If P2, P3, P4 ran first:
    ┌──┬───┬─┬────────────────────────────────────────┐
    │P2│P3 │P4│                P1                      │
    └──┴───┴─┴────────────────────────────────────────┘
    0  2   5  6                                       106
    
    Average WT = (6 + 0 + 2 + 5) / 4 = 3.25  (MUCH better!)
```

---

## 7. SJF - Shortest Job First

### 📖 Concept

Among all processes in the ready queue, the one with the **shortest burst time** is selected next. This is **non-preemptive** — once a process starts, it runs to completion.

SJF is **provably optimal** for minimizing average waiting time (among non-preemptive algorithms).

```
    READY QUEUE (sorted by burst time):
    
    ┌──────┬──────┬──────┬──────┐
    │P4(2) │P2(4) │P1(6) │P3(8) │ ──► CPU picks P4 (shortest)
    └──────┴──────┴──────┴──────┘
```

### 📝 Solved Example

| Process | Arrival Time (AT) | Burst Time (BT) |
|---------|-------------------|------------------|
| P1 | 0 | 6 |
| P2 | 1 | 4 |
| P3 | 2 | 8 |
| P4 | 3 | 2 |

**Step-by-Step:**
1. At t=0: Only P1 has arrived → Run P1 (BT=6)
2. At t=6: P2(BT=4), P3(BT=8), P4(BT=2) are ready → Pick P4 (shortest)
3. At t=8: P2(BT=4), P3(BT=8) are ready → Pick P2
4. At t=12: P3(BT=8) → Run P3

**Gantt Chart:**
```
    ┌──────────────┬──────┬───────────┬────────────────────┐
    │      P1      │  P4  │    P2     │        P3          │
    │   (0 - 6)    │(6-8) │ (8 - 12) │    (12 - 20)       │
    └──────────────┴──────┴───────────┴────────────────────┘
    0              6      8          12                    20
```

**Calculations:**

| Process | AT | BT | CT | TAT = CT-AT | WT = TAT-BT |
|---------|-----|-----|-----|-------------|-------------|
| P1 | 0 | 6 | 6 | 6 | **0** |
| P2 | 1 | 4 | 12 | 11 | **7** |
| P3 | 2 | 8 | 20 | 18 | **10** |
| P4 | 3 | 2 | 8 | 5 | **3** |

**Average TAT** = (6 + 11 + 18 + 5) / 4 = **40/4 = 10.0**

**Average WT** = (0 + 7 + 10 + 3) / 4 = **20/4 = 5.0**

Compare with FCFS: TAT was 12.0, WT was 7.0 → SJF is better!

### Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Optimal average waiting time (non-preemptive) | **Starvation**: Long processes may never execute |
| Better than FCFS | Burst time must be known in advance (impractical) |
| Good throughput | Non-preemptive — not good for interactive systems |

### ⚠️ Starvation Problem
```
    If short processes keep arriving, a long process NEVER gets CPU:
    
    Time: 0   1   2   3   4   5   6   7   8  ...
          P1  P2  P3  P4  P5  P6  P7  P8  P9
         (2) (1) (1) (2) (1) (1) (2) (1) (1) ...
    
    P_long (BT=50) arrived at time 0 but short processes
    keep arriving → P_long STARVES indefinitely!
    
    Solution: AGING — gradually increase priority of waiting processes
```

---

## 8. SRTF - Shortest Remaining Time First

### 📖 Concept

SRTF is the **preemptive version of SJF**. At any point, the process with the **shortest remaining burst time** is run. If a new process arrives with a shorter remaining time than the current process, the current process is **preempted**.

```
    SRTF: Always run the process with SHORTEST REMAINING TIME
    
    At time 2:  P1 remaining = 4,  P2 remaining = 4,  P3 just arrived (BT=1)
                              → Run P3 (smallest remaining = 1)
```

### 📝 Solved Example

| Process | Arrival Time (AT) | Burst Time (BT) |
|---------|-------------------|------------------|
| P1 | 0 | 6 |
| P2 | 1 | 4 |
| P3 | 2 | 2 |
| P4 | 3 | 1 |

**Step-by-Step Execution:**

```
Time 0: P1 arrives (Remaining: P1=6)
        → Run P1

Time 1: P2 arrives (Remaining: P1=5, P2=4)
        → Preempt P1, Run P2 (shorter remaining)

Time 2: P3 arrives (Remaining: P1=5, P2=3, P3=2)
        → Preempt P2, Run P3 (shorter remaining)

Time 3: P4 arrives (Remaining: P1=5, P2=3, P3=1, P4=1)
        → P3 remaining=1, P4 remaining=1 (tie: continue P3)
        → Run P3

Time 4: P3 finishes (Remaining: P1=5, P2=3, P4=1)
        → Run P4 (shortest)

Time 5: P4 finishes (Remaining: P1=5, P2=3)
        → Run P2 (shorter)

Time 8: P2 finishes (Remaining: P1=5)
        → Run P1

Time 13: P1 finishes
```

**Gantt Chart:**
```
    ┌────┬────┬────┬────┬────┬─────────┬────────────────┐
    │ P1 │ P2 │ P3 │ P3 │ P4 │   P2    │       P1       │
    └────┴────┴────┴────┴────┴─────────┴────────────────┘
    0    1    2    3    4    5         8                 13
```

**Calculations:**

| Process | AT | BT | CT | TAT = CT-AT | WT = TAT-BT |
|---------|-----|-----|-----|-------------|-------------|
| P1 | 0 | 6 | 13 | 13 | **7** |
| P2 | 1 | 4 | 8 | 7 | **3** |
| P3 | 2 | 2 | 4 | 2 | **0** |
| P4 | 3 | 1 | 5 | 2 | **1** |

**Average TAT** = (13 + 7 + 2 + 2) / 4 = **24/4 = 6.0**

**Average WT** = (7 + 3 + 0 + 1) / 4 = **11/4 = 2.75**

### Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Optimal average waiting time (overall) | Starvation of long processes |
| Very responsive for short processes | High context switching overhead |
| Better than non-preemptive SJF | Burst time prediction is difficult |

---

## 9. Priority Scheduling

### 📖 Concept

Each process is assigned a **priority number**. The CPU is allocated to the process with the **highest priority** (lowest number = highest priority, typically).

Can be **preemptive** or **non-preemptive**.

```
    PRIORITY SCHEDULING:
    
    ┌──────────────┬──────────────┬──────────────┐
    │ P3 (Pri=1)   │ P1 (Pri=2)   │ P4 (Pri=4)   │
    │ HIGHEST      │              │ LOWEST       │
    │ (runs first) │              │ (runs last)  │
    └──────────────┴──────────────┴──────────────┘
    
    Lower number = Higher priority (convention)
```

### 📝 Solved Example (Non-Preemptive)

| Process | AT | BT | Priority |
|---------|-----|-----|----------|
| P1 | 0 | 4 | 3 |
| P2 | 1 | 3 | 1 (Highest) |
| P3 | 2 | 5 | 4 |
| P4 | 3 | 2 | 2 |

**Step-by-Step (Non-Preemptive):**
1. At t=0: Only P1 → Run P1 (BT=4)
2. At t=4: P2(Pri=1), P3(Pri=4), P4(Pri=2) → Run P2 (highest priority)
3. At t=7: P3(Pri=4), P4(Pri=2) → Run P4 (higher priority)
4. At t=9: P3 → Run P3

**Gantt Chart:**
```
    ┌───────────┬─────────┬──────┬──────────────┐
    │    P1     │   P2    │  P4  │     P3       │
    │  (0-4)    │ (4-7)   │(7-9) │   (9-14)     │
    └───────────┴─────────┴──────┴──────────────┘
    0           4         7      9             14
```

| Process | AT | BT | CT | TAT | WT |
|---------|-----|-----|-----|-----|-----|
| P1 | 0 | 4 | 4 | 4 | **0** |
| P2 | 1 | 3 | 7 | 6 | **3** |
| P3 | 2 | 5 | 14 | 12 | **7** |
| P4 | 3 | 2 | 9 | 6 | **4** |

**Average TAT** = (4 + 6 + 12 + 6) / 4 = **28/4 = 7.0**

**Average WT** = (0 + 3 + 7 + 4) / 4 = **14/4 = 3.5**

### ⚠️ Starvation and Aging

```
    PROBLEM: STARVATION
    ─────────────────────
    Low-priority processes may NEVER execute if high-priority
    processes keep arriving.
    
    SOLUTION: AGING
    ─────────────────
    Gradually INCREASE the priority of processes that have been
    waiting for a long time.
    
    Example:
    Time 0:  P_low priority = 50
    Time 10: P_low priority = 45  (aged by 5)
    Time 20: P_low priority = 40  (aged by 5)
    ...
    Time 90: P_low priority = 5   (now high priority! Gets CPU)
```

### Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| Important processes run first | **Starvation** of low-priority processes |
| Flexible — can model many policies | Priority must be assigned (subjective) |
| Used in real systems (RTOS, Linux) | **Priority Inversion** problem |
| Can be preemptive or non-preemptive | Complex with many priority levels |

---

## 10. Round Robin Scheduling

### 📖 Concept

Each process gets a **fixed time quantum** (time slice). After the quantum expires, the process is **preempted** and placed at the end of the ready queue. The next process in the queue gets the CPU.

**Round Robin = FCFS + Preemption (with time quantum)**

```
    ROUND ROBIN (Time Quantum = 3)
    
    Ready Queue (circular):
    
         ┌───── P1 ◄────┐
         │               │
         ▼               │
    P4 ─────► CPU ────► P2
         ▲               │
         │               │
         └───── P3 ◄────┘
    
    Each process gets max 3 time units, then goes to back of queue
```

### 📝 Solved Example

| Process | Arrival Time (AT) | Burst Time (BT) |
|---------|-------------------|------------------|
| P1 | 0 | 5 |
| P2 | 1 | 4 |
| P3 | 2 | 2 |
| P4 | 3 | 1 |

**Time Quantum (TQ) = 2**

**Step-by-Step Execution:**

```
Queue state at each step:

Time 0-2: Run P1 (2 units). P1 remaining = 3
          Queue after: [P2, P3, P1]   (P2,P3 arrived; P1 goes to back)

Time 2-4: Run P2 (2 units). P2 remaining = 2
          Queue after: [P3, P1, P4, P2]  (P4 arrived at t=3; P2 goes to back)

Time 4-6: Run P3 (2 units). P3 remaining = 0. P3 DONE ✓
          Queue after: [P1, P4, P2]

Time 6-8: Run P1 (2 units). P1 remaining = 1
          Queue after: [P4, P2, P1]

Time 8-9: Run P4 (1 unit). P4 remaining = 0. P4 DONE ✓
          Queue after: [P2, P1]

Time 9-11: Run P2 (2 units). P2 remaining = 0. P2 DONE ✓
           Queue after: [P1]

Time 11-12: Run P1 (1 unit). P1 remaining = 0. P1 DONE ✓
```

**Gantt Chart:**
```
    ┌──────┬──────┬──────┬──────┬────┬──────┬────┐
    │  P1  │  P2  │  P3  │  P1  │ P4 │  P2  │ P1 │
    │(0-2) │(2-4) │(4-6) │(6-8) │(8-9)│(9-11)│(11-12)│
    └──────┴──────┴──────┴──────┴────┴──────┴────┘
    0      2      4      6      8    9     11    12
```

**Calculations:**

| Process | AT | BT | CT | TAT = CT-AT | WT = TAT-BT |
|---------|-----|-----|-----|-------------|-------------|
| P1 | 0 | 5 | 12 | 12 | **7** |
| P2 | 1 | 4 | 11 | 10 | **6** |
| P3 | 2 | 2 | 6 | 4 | **2** |
| P4 | 3 | 1 | 9 | 6 | **5** |

**Average TAT** = (12 + 10 + 4 + 6) / 4 = **32/4 = 8.0**

**Average WT** = (7 + 6 + 2 + 5) / 4 = **20/4 = 5.0**

### Effect of Time Quantum Size

```
    ┌─────────────────────────────────────────────────────────────┐
    │              EFFECT OF TIME QUANTUM                          │
    ├─────────────────────────────────────────────────────────────┤
    │                                                             │
    │  Very SMALL quantum (TQ → 0)                                │
    │  ───────────────────────────                                │
    │  • Too many context switches → overhead increases           │
    │  • Called "Processor Sharing" (each process gets 1/n CPU)   │
    │  • Response time: excellent                                 │
    │  • Throughput: poor (too much switching)                     │
    │                                                             │
    │  Very LARGE quantum (TQ → ∞)                                │
    │  ───────────────────────────                                │
    │  • Behaves like FCFS                                        │
    │  • No preemption benefit                                    │
    │  • Response time: poor for short processes                  │
    │                                                             │
    │  OPTIMAL quantum: 10-100 milliseconds                       │
    │  Rule of thumb: 80% of bursts should be < quantum           │
    │                                                             │
    │         Context                                             │
    │         Switches  ▲                                         │
    │                   │\                                        │
    │                   │ \                                       │
    │                   │  \                                      │
    │                   │   \_______                              │
    │                   │                                         │
    │                   └────────────────► Time Quantum            │
    │                                                             │
    └─────────────────────────────────────────────────────────────┘
```

### Advantages & Disadvantages

| Advantages | Disadvantages |
|-----------|---------------|
| **No starvation** — every process gets CPU | Higher average WT than SJF |
| Fair allocation of CPU | Performance depends on quantum size |
| Good for time-sharing systems | Context switch overhead |
| Low response time | Not optimal for batch processing |

---

## 11. Multilevel Queue Scheduling

### 📖 Concept

Processes are classified into **groups** based on their type, and each group has its own **queue** with its own scheduling algorithm. Queues themselves are scheduled with a fixed priority or proportional sharing.

```
    ┌────────────────────────────────────────────────────────────┐
    │              MULTILEVEL QUEUE SCHEDULING                    │
    └────────────────────────────────────────────────────────────┘
    
    HIGHEST PRIORITY
    ┌──────────────────────────────────────────┐
    │ Queue 1: SYSTEM PROCESSES                │  ← Priority Scheduling
    │          (kernel, daemons)               │
    │          [P1] [P5]                       │
    └──────────────────┬───────────────────────┘
                       │ If empty, go to next queue
    ┌──────────────────▼───────────────────────┐
    │ Queue 2: INTERACTIVE PROCESSES           │  ← Round Robin (TQ=8)
    │          (text editors, browsers)        │
    │          [P2] [P6] [P9]                  │
    └──────────────────┬───────────────────────┘
                       │ If empty, go to next queue
    ┌──────────────────▼───────────────────────┐
    │ Queue 3: INTERACTIVE EDITING             │  ← Round Robin (TQ=16)
    │          (compilers, IDEs)               │
    │          [P3] [P7]                       │
    └──────────────────┬───────────────────────┘
                       │ If empty, go to next queue
    ┌──────────────────▼───────────────────────┐
    │ Queue 4: BATCH PROCESSES                 │  ← FCFS
    │          (payroll, backups)              │
    │          [P4] [P8] [P10]                 │
    └──────────────────────────────────────────┘
    LOWEST PRIORITY
    
    ★ A process is PERMANENTLY assigned to one queue
    ★ Higher queue is ALWAYS served before lower queue
    ★ Lower queue processes may STARVE
```

### Multilevel Feedback Queue (MLFQ)

The key improvement: processes can **move between queues** based on their behavior.

```
    ┌────────────────────────────────────────────────────────────┐
    │          MULTILEVEL FEEDBACK QUEUE (MLFQ)                   │
    └────────────────────────────────────────────────────────────┘
    
    ┌──────────────────────────────────────────┐
    │ Queue 0: HIGHEST PRIORITY                │  ← RR, TQ = 8ms
    │          New processes start here         │
    │          [P1] [P2] [P3]                  │
    └────────────┬──────────┬──────────────────┘
                 │          │
     Process     │          │ Process uses full
     finishes    │          │ quantum (CPU-bound)
     within      │          │ → DEMOTED ↓
     quantum     │          │
                 ▼          ▼
              DONE  ┌──────────────────────────────────┐
                    │ Queue 1: MEDIUM PRIORITY          │  ← RR, TQ = 16ms
                    │          [P4] [P5]                │
                    └───────────┬──────────┬────────────┘
                                │          │
                    Process     │          │ Uses full quantum
                    finishes    │          │ → DEMOTED ↓
                                │          │
                                ▼          ▼
                             DONE  ┌──────────────────────────────┐
                                   │ Queue 2: LOWEST PRIORITY     │  ← FCFS
                                   │          [P6]                │
                                   └──────────────────────────────┘
    
    RULES:
    ★ New process → Queue 0
    ★ If it uses full quantum → demote to lower queue
    ★ If it gives up CPU (I/O) → stays or promoted to higher queue
    ★ I/O-bound processes stay in high-priority queues
    ★ CPU-bound processes sink to lower queues
    ★ Aging: long-waiting processes get promoted
```

### 🏠 Real-World Analogy

**Multilevel Queue**: An airline with First Class, Business Class, and Economy. You're assigned a class when you buy your ticket and can't change.

**MLFQ**: A company with performance reviews. New employees start as Junior. Good performers get promoted, poor performers stay or get demoted.

---

## 12. Complete Scheduling Comparison

| Algorithm | Type | Preemptive? | Starvation? | Convoy Effect? | Optimal? |
|-----------|------|-------------|-------------|----------------|----------|
| **FCFS** | Non-preemptive | ❌ No | ❌ No | ✅ Yes | ❌ No |
| **SJF** | Non-preemptive | ❌ No | ✅ Yes | ❌ No | ✅ For non-preemptive |
| **SRTF** | Preemptive | ✅ Yes | ✅ Yes | ❌ No | ✅ Overall optimal |
| **Priority** | Both | Configurable | ✅ Yes | ❌ No | ❌ No |
| **Round Robin** | Preemptive | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **MLQ** | Both | Configurable | ✅ Yes (lower queues) | ❌ No | ❌ No |
| **MLFQ** | Both | ✅ Yes | ❌ No (aging) | ❌ No | ❌ No |

### When to Use What?

| Scenario | Best Algorithm |
|----------|---------------|
| Simple batch processing | FCFS |
| Minimizing average wait time | SJF / SRTF |
| Interactive / time-sharing | Round Robin |
| Critical tasks first | Priority |
| Mixed workloads | MLFQ |
| Real-time systems | Priority (with deadline-based) |

---

## 13. Quick Summary

```
┌────────────────────────────────────────────────────────────────┐
│                 CHAPTER 2: QUICK REVISION                       │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ★ Process = Program in execution (active entity)              │
│  ★ States: New → Ready → Running → Waiting → Terminated       │
│  ★ PCB stores all process info (PID, PC, registers, state)    │
│  ★ Context Switch = Save PCB of P1, Load PCB of P2            │
│                                                                │
│  SCHEDULING ALGORITHMS:                                        │
│  ───────────────────────                                       │
│  ★ FCFS: First come, first served. Simple. Convoy effect.      │
│  ★ SJF: Shortest burst first. Optimal non-preemptive. Starves.│
│  ★ SRTF: Preemptive SJF. Overall optimal. Starves.            │
│  ★ Priority: Highest priority first. Starves. Use aging.       │
│  ★ Round Robin: Time quantum. Fair. No starvation.             │
│  ★ MLFQ: Multiple queues. Processes move between them.         │
│                                                                │
│  FORMULAS:                                                     │
│  ─────────                                                     │
│  ★ TAT = CT - AT  (Turnaround Time)                           │
│  ★ WT  = TAT - BT (Waiting Time)                              │
│  ★ RT  = First Execution Time - AT (Response Time)             │
│                                                                │
│  KEY CONCEPTS:                                                 │
│  ─────────────                                                 │
│  ★ Preemptive: OS can forcibly take CPU from process           │
│  ★ Non-preemptive: Process keeps CPU till done or I/O          │
│  ★ Starvation: Process waits indefinitely                      │
│  ★ Aging: Gradually increase priority of waiting processes     │
│  ★ Convoy Effect: Short processes stuck behind long one (FCFS) │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 📝 Practice Questions

### 🟢 Level 1: One-Line Answer Questions

| # | Question | Answer |
|---|----------|--------|
| 1 | What is a process? | A process is a program in execution — an active entity with its own memory, PC, and resources. |
| 2 | Name the 5 states of a process. | New, Ready, Running, Waiting (Blocked), Terminated. |
| 3 | What is stored in a PCB? | PID, process state, program counter, registers, scheduling info, memory info, I/O status. |
| 4 | What is a context switch? | Saving the state of the current process and loading the state of the next process to run. |
| 5 | What is the convoy effect? | Short processes waiting behind a long process in FCFS scheduling, causing high average wait time. |
| 6 | Which algorithm is optimal for average waiting time? | SRTF (Shortest Remaining Time First) — preemptive version of SJF. |
| 7 | What is starvation? | When a process waits indefinitely because other processes keep getting priority. |
| 8 | What is aging? | Gradually increasing the priority of long-waiting processes to prevent starvation. |
| 9 | What happens if Round Robin quantum is very large? | It degenerates into FCFS (no preemption benefit). |
| 10 | What is the difference between preemptive and non-preemptive? | Preemptive: OS can take CPU away; Non-preemptive: process holds CPU until done/I/O. |

---

### 🟡 Level 2: Multiple Choice Questions

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Which scheduling algorithm suffers from the convoy effect? | A) SJF B) **FCFS** C) RR D) Priority | **B** |
| 2 | SRTF is the preemptive version of? | A) FCFS B) Priority C) **SJF** D) RR | **C** |
| 3 | In Round Robin, if quantum → ∞, it becomes? | A) SJF B) Priority C) **FCFS** D) SRTF | **C** |
| 4 | Which does NOT cause starvation? | A) SJF B) Priority C) SRTF D) **Round Robin** | **D** |
| 5 | TAT formula is? | A) CT + AT B) **CT - AT** C) BT - AT D) BT + AT | **B** |
| 6 | In which state is a process when it's waiting for I/O? | A) Ready B) Running C) **Waiting** D) New | **C** |
| 7 | PCB is stored in? | A) User memory B) **Kernel memory** C) Cache D) Disk | **B** |
| 8 | Context switch is? | A) Useful computation B) **Pure overhead** C) Always fast D) Optional | **B** |
| 9 | Which algorithm needs burst time prediction? | A) FCFS B) RR C) **SJF** D) MLQ | **C** |
| 10 | MLFQ differs from MLQ because? | A) more queues B) fewer queues C) **processes can move between queues** D) uses FCFS only | **C** |

---

### 🔴 Level 3: Tricky Conceptual MCQs

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | If all processes arrive at time 0 with equal burst time, which algorithm gives the SAME result as FCFS? | A) SRTF only B) Priority only C) **All of them** D) None | **C** | With same AT and BT, all algorithms produce the same schedule. |
| 2 | In a Round Robin system with quantum=4 and only one process in the queue, how does it behave? | A) Process gets preempted every 4 units B) **Process runs like FCFS** C) Error D) Process loops | **B** | No other process to switch to, so it runs continuously. |
| 3 | A process is in the READY state. Which state transition is NOT possible directly? | A) Ready→Running B) **Ready→Terminated** C) Ready→Suspended D) Ready→Ready | **B** | A process must RUN first before it can TERMINATE. It cannot go directly from Ready to Terminated. |
| 4 | Aging resolves which problem? | A) Convoy Effect B) Deadlock C) **Starvation** D) Thrashing | **C** | Aging increases priority of waiting processes, preventing starvation. |
| 5 | Which scheduling cannot be used in a time-sharing environment? | A) RR B) MLFQ C) **Non-preemptive FCFS** D) Preemptive Priority | **C** | Time-sharing requires preemption; non-preemptive FCFS doesn't support it. |

---

### 🔵 Level 4: True / False

| # | Statement | Answer | Explanation |
|---|-----------|--------|-------------|
| 1 | A process and a program are the same thing. | **False** | A program is passive (on disk); a process is active (in execution). |
| 2 | SJF is optimal for minimizing average waiting time among non-preemptive algorithms. | **True** | SJF minimizes average WT for non-preemptive scheduling. |
| 3 | Round Robin scheduling can cause starvation. | **False** | Every process gets a time quantum — no starvation. |
| 4 | Context switching involves saving and restoring the PCB. | **True** | The outgoing process's PCB is saved; incoming process's PCB is loaded. |
| 5 | In Priority scheduling, a higher number always means higher priority. | **False** | Convention varies — in many systems, lower number = higher priority. |
| 6 | FCFS scheduling is preemptive. | **False** | FCFS is non-preemptive. |
| 7 | SRTF guarantees the minimum average turnaround time. | **True** | SRTF is provably optimal for average WT and therefore TAT. |
| 8 | A process can move from Terminated to Running state. | **False** | Terminated is a final state — no transitions out of it. |
| 9 | In MLFQ, CPU-bound processes sink to lower queues over time. | **True** | CPU-bound processes use full quantum and get demoted. |
| 10 | The time quantum in Round Robin should be as small as possible. | **False** | Too small → excessive context switching overhead. |

---

### 🟣 Level 5: Scenario-Based Questions

**Scenario 1:**
> Given processes P1(BT=10), P2(BT=1), P3(BT=2), all arriving at time 0, in FCFS order. Calculate average waiting time and explain why SJF would be better.

**Answer:**
- FCFS: P1→P2→P3
  - WT: P1=0, P2=10, P3=11. Avg WT = 21/3 = **7.0**
- SJF: P2→P3→P1
  - WT: P2=0, P3=1, P1=3. Avg WT = 4/3 = **1.33**
- SJF is better because it runs short jobs first, reducing the waiting time for most processes. FCFS makes P2 and P3 wait behind the longest process (convoy effect).

---

**Scenario 2:**
> A system uses Round Robin with TQ=4. Process P1 (BT=3) and P2 (BT=7) arrive at time 0. Draw the Gantt chart and calculate average TAT.

**Answer:**
```
Gantt: |P1(0-3)|P2(3-7)|P2(7-10)|
```
- P1: CT=3, TAT=3
- P2: CT=10, TAT=10
- Average TAT = (3 + 10)/2 = **6.5**

Note: P1 finishes before its quantum (3 < 4), so P2 starts immediately.

---

**Scenario 3:**
> A system uses Priority Scheduling (non-preemptive). P1(AT=0, BT=5, Pri=3), P2(AT=1, BT=3, Pri=1), P3(AT=2, BT=4, Pri=2). P2 has the highest priority. Will P1 be preempted when P2 arrives?

**Answer:** **No.** In non-preemptive priority scheduling, P1 will NOT be preempted. Even though P2 has a higher priority, P1 was already running and will complete first. P2 will run after P1 finishes. This is the key difference between preemptive and non-preemptive priority scheduling.

---

**Scenario 4:**
> An OS uses MLFQ with 3 queues: Q0 (TQ=8, RR), Q1 (TQ=16, RR), Q2 (FCFS). A process P1 needs a total of 40ms CPU time. Trace its movement through the queues.

**Answer:**
1. P1 enters Q0, gets 8ms. Remaining = 32ms. Uses full quantum → **demoted to Q1**
2. P1 in Q1, gets 16ms. Remaining = 16ms. Uses full quantum → **demoted to Q2**
3. P1 in Q2, runs to completion (16ms, FCFS).
- Total time experiencing execution: 8 + 16 + 16 = 40ms.
- P1 was classified as a CPU-bound process since it used full quantum in each queue.

---

**Scenario 5:**
> In SJF scheduling, new short processes keep arriving every second. A process P_long (BT=100) has been waiting for 50 seconds. What problem is this, and how do you fix it?

**Answer:** This is **starvation** — P_long may never execute because shorter processes keep getting priority. The solution is **aging**: gradually increase P_long's effective priority. For example, decrease its effective burst time by 1 for every 5 seconds of waiting. After 50 seconds, its effective BT would be 100 - 10 = 90. Eventually, its effective BT becomes low enough that it gets scheduled.

---

### 🟤 Level 6: Advanced Real-World Application Questions

**Q1. How does the Linux kernel schedule processes on a modern multi-core CPU?**

**Answer:** Linux uses the **Completely Fair Scheduler (CFS)** since kernel 2.6.23:

| Feature | Description |
|---------|-------------|
| **Algorithm** | Weighted fair queuing using a red-black tree |
| **Time tracking** | Virtual runtime (vruntime) per process |
| **Priority** | Nice values (-20 to +19); lower = higher priority |
| **Preemption** | Fully preemptive — lower vruntime process always wins |
| **Multi-core** | Per-CPU run queues with periodic load balancing |
| **Real-time** | SCHED_FIFO and SCHED_RR for real-time tasks (bypasses CFS) |

**Real-World flow**: When you run a video game (CPU-intensive), it gets a high vruntime quickly and gets preempted. Background music player (low CPU) stays with low vruntime and gets scheduled proportionally. Both share CPU **fairly** relative to their nice values.

---

**Q2. Netflix processes 250 million user requests daily. How does process/thread scheduling affect video delivery?**

**Answer:** Netflix CDN (Content Delivery Network) uses:

```
User request → Load balancer (distributes to least-loaded server)
             → Web server process (handles HTTP — nginx uses event-driven I/O)
             → Transcoding service (separate process per video quality)
             → Storage service (reads from SSD/disk)
             → Response back to user

Scheduling impact:
• nginx: non-blocking I/O → one process handles thousands of connections
• Transcoding: CPU-bound → gets high priority, dedicated cores
• Monitoring: background process → low priority (nice +10)
```

**Key insight**: Netflix uses **cgroups** (Linux control groups) to guarantee CPU/memory to critical video-serving processes even under load. This is **OS-level resource partitioning** in production.

---

**Q3. Given the following processes, calculate and compare FCFS vs SJF vs SRTF:**

| Process | Arrival Time | Burst Time |
|---------|-------------|------------|
| P1      | 0           | 8          |
| P2      | 1           | 4          |
| P3      | 2           | 2          |
| P4      | 3           | 5          |

**Answer:**

**FCFS:**
```
|P1(0-8)|P2(8-12)|P3(12-14)|P4(14-19)|
```
| Process | CT | TAT | WT  |
|---------|----|-----|-----|
| P1      |  8 |   8 |   0 |
| P2      | 12 |  11 |   7 |
| P3      | 14 |  12 |  10 |
| P4      | 19 |  16 |  11 |

Avg WT = (0+7+10+11)/4 = **7.0**

**SJF (Non-preemptive):**
```
|P1(0-8)|P3(8-10)|P2(10-14)|P4(14-19)|
```
At t=8: P2(BT=4), P3(BT=2), P4(BT=5) are waiting. P3 is shortest → runs first.

| Process | CT | TAT | WT  |
|---------|----|-----|-----|
| P1      |  8 |   8 |   0 |
| P3      | 10 |   8 |   6 |
| P2      | 14 |  13 |   9 |
| P4      | 19 |  16 |  11 |

Avg WT = (0+6+9+11)/4 = **6.5**

**SRTF (Preemptive SJF):**
```
|P1(0-1)|P2(1-2)|P3(2-4)|P2(4-7)|P1(7-14)|P4(14-19)|
```
Timeline: At t=1 P2(4) arrives, P1 rem=7 > 4 → preempt. At t=2 P3(2) arrives, P2 rem=3 > 2 → preempt. At t=4 P3 done, P2 rem=3 < P1 rem=7 → P2 runs. At t=7 P2 done, P4 arrived at t=3 with BT=5, P1 rem=7 > P4 rem=5 → P4 runs. Wait — at t=7, P4(5) vs P1(7): P4 runs. At t=7: P4(5), P1(7). P4 runs to t=12. At t=12: P1(7) runs to t=19.

| Process | CT | TAT | WT  |
|---------|----|-----|-----|
| P1      | 19 |  19 |  11 |
| P2      |  7 |   6 |   2 |
| P3      |  4 |   2 |   0 |
| P4      | 12 |   9 |   4 |

Avg WT = (11+2+0+4)/4 = **4.25** ← Best!

---

**Q4. A Docker container starts 50 microservices on one Linux host. How does the OS manage all these processes?**

**Answer:**

| OS Mechanism | How it works for Docker |
|-------------|------------------------|
| **Namespaces** | Each container gets isolated PID, network, filesystem namespaces |
| **cgroups** | CPU shares, memory limits enforced per container by kernel |
| **Scheduling** | All container processes share the same Linux CFS scheduler |
| **Context switching** | OS switches between container processes transparently |
| **Process isolation** | Container sees its own PID 1; host sees real PIDs (e.g., 8432) |

**Real example**: `docker run --cpus=0.5 --memory=256m nginx` — the OS kernel enforces that this container never uses more than 50% of one CPU core and 256 MB RAM, no matter how many other containers or processes are running.

---

**Q5. Explain how a web browser uses all 5 process states in normal operation.**

**Answer:**

| Browser Activity | Process State | Reason |
|-----------------|---------------|--------|
| Tab loading JavaScript | **Running** | CPU actively executes JS engine |
| Tab waiting for network response | **Waiting (Blocked)** | Blocked on I/O (network socket) |
| Tab rendered, idle in background | **Ready** | In memory, waiting for CPU time |
| User opens new tab | **New** | Browser creates new renderer process |
| User closes tab | **Terminated** | OS reclaims all resources |

**Chrome architecture insight**: Chrome assigns each tab its own **process** (not just thread). This means one tab crash doesn't kill the browser. The OS manages 20-50 Chrome processes on a typical system, all going through these state transitions thousands of times per second.

---

**Q6. How does the Windows Task Manager's "CPU" and "Memory" graphs relate to scheduling concepts?**

**Answer:**

| Task Manager Display | Underlying OS Concept |
|--------------------|-----------------------|
| CPU% bar graph | **CPU utilization** — % of time CPU is not idle |
| Process list sorted by CPU | Processes currently in **Running/Ready** state |
| "Suspended" apps | Windows puts background apps in **frozen state** (a form of suspension) |
| Memory "In Use" | **Physical frames** currently allocated to processes |
| "Available" memory | Free frames available for allocation |
| Page faults/sec counter | **Page fault rate** — high = potential thrashing |
| Context switches/sec | Frequency of **context switches** — high = many short processes or heavy multitasking |

**Tip for interviews**: When Task Manager shows 100% CPU — it means the ready queue always has a process waiting. When it shows high page faults — virtual memory demand exceeds physical RAM.

---

## 📚 Key Terms Glossary

| Term | Definition |
|------|-----------|
| **Process** | Program in execution (active entity) |
| **PCB** | Data structure containing all process information |
| **Context Switch** | Saving/loading process state when switching CPU |
| **Burst Time** | CPU time needed by a process |
| **Turnaround Time** | Total time from arrival to completion (CT - AT) |
| **Waiting Time** | Time spent waiting in ready queue (TAT - BT) |
| **Preemption** | Forcibly removing a running process from CPU |
| **Starvation** | Process waits indefinitely for CPU |
| **Aging** | Increasing priority of long-waiting processes |
| **Convoy Effect** | Short processes stuck behind a long process in FCFS |
| **Time Quantum** | Fixed time slice in Round Robin |
| **Throughput** | Number of processes completed per time unit |

---

> **← [Previous: 01 - OS Introduction](01_OS_Introduction.md) | [Next: 03 - Threads and CPU →](03_Threads_and_CPU.md)**
