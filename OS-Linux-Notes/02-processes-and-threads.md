# 02. Processes and Threads

## Table of Contents
- [2.1 What is a Process?](#21-what-is-a-process)
- [2.2 Process Control Block (PCB)](#22-process-control-block-pcb)
- [2.3 Process States](#23-process-states)
- [2.4 Process Operations](#24-process-operations)
- [2.5 Threads](#25-threads)
- [2.6 Context Switching](#26-context-switching)
- [2.7 Inter-Process Communication (IPC)](#27-inter-process-communication-ipc)
- [2.8 Common Mistakes & Interview Tips](#28-common-mistakes--interview-tips)
- [2.9 Practice & Assessment](#29-practice--assessment)

---

## 2.1 What is a Process?

### Definition
A **process** is a program in execution. It is the active entity (a program is passive — just a file on disk).

```
Program (passive):  /usr/bin/firefox    ← File on disk
Process (active):   Firefox running     ← Loaded in memory, using CPU
```

### Process vs Program

| Aspect | Program | Process |
|--------|---------|---------|
| Nature | Passive (stored on disk) | Active (running in memory) |
| Lifetime | Exists until deleted | Exists until terminated |
| Resources | None | CPU, memory, files, I/O |
| Instances | One file | Multiple processes from same program |

### Process Memory Layout

```
┌─────────────────────┐  High Address
│       STACK          │  ← Local variables, function calls
│         ↓            │    (grows downward)
├─────────────────────┤
│                     │
│    (free space)     │
│                     │
├─────────────────────┤
│         ↑            │
│        HEAP          │  ← Dynamically allocated memory (malloc)
│                     │    (grows upward)
├─────────────────────┤
│        DATA          │  ← Global/static variables
├─────────────────────┤
│        TEXT          │  ← Program code (instructions)
└─────────────────────┘  Low Address
```

---

## 2.2 Process Control Block (PCB)

### Definition
The **PCB** is a data structure maintained by the OS for every process. It contains all information needed to manage the process.

### PCB Contents

```
┌──────────────────────────────────┐
│      PROCESS CONTROL BLOCK        │
├──────────────────────────────────┤
│ Process ID (PID)         : 1234  │
│ Process State            : Ready │
│ Program Counter (PC)     : 0x4A2 │
│ CPU Registers            : ...   │
│ Memory Management Info   : ...   │
│ I/O Status               : ...   │
│ Scheduling Info          : ...   │
│ Parent Process ID        : 1200  │
│ Open Files List          : ...   │
│ Accounting Info          : ...   │
└──────────────────────────────────┘
```

| Field | Purpose |
|-------|---------|
| **PID** | Unique identifier for the process |
| **Process State** | Current state (new, ready, running, waiting, terminated) |
| **Program Counter** | Address of next instruction to execute |
| **CPU Registers** | Contents of all registers (saved during context switch) |
| **Memory Info** | Page tables, segment tables, base/limit registers |
| **I/O Status** | List of open files, allocated I/O devices |
| **Scheduling Info** | Priority, scheduling queue pointers |

---

## 2.3 Process States

### State Transition Diagram

```
                    ┌──────────────┐
         admitted   │              │   exit
  ┌────────────────►│  TERMINATED  │◄──────────────┐
  │                 │              │                │
  │                 └──────────────┘                │
  │                                                │
┌─┴────────┐    scheduler     ┌──────────┐        │
│           │   dispatch       │          │────────┘
│    NEW    │─────────────────►│ RUNNING  │
│           │                  │          │
└───────────┘                  └────┬─┬───┘
                                    │ │
              ┌─────────────────────┘ │
              │ I/O or event wait     │ interrupt
              ▼                       │ (preemption)
        ┌──────────┐                  │
        │          │                  ▼
        │ WAITING  │           ┌──────────┐
        │(Blocked) │           │  READY   │
        │          │           │          │
        └─────┬────┘           └──────────┘
              │                      ▲
              │ I/O or event         │
              │ completion           │
              └──────────────────────┘
```

### States Explained

| State | Description | Example |
|-------|-------------|---------|
| **New** | Process being created | Just clicked to open an app |
| **Ready** | Waiting for CPU assignment | Loaded in memory, waiting its turn |
| **Running** | Currently executing on CPU | Actively using the processor |
| **Waiting (Blocked)** | Waiting for I/O or event | Waiting for disk read to complete |
| **Terminated** | Finished execution | Process exited or was killed |

### Transitions

| Transition | Trigger | Example |
|-----------|---------|---------|
| New → Ready | Process admitted by OS | OS loads process into memory |
| Ready → Running | CPU scheduler selects process | Scheduler picks next process |
| Running → Ready | Time slice expired (preemption) | Round Robin timer interrupt |
| Running → Waiting | Process needs I/O | File read requested |
| Waiting → Ready | I/O operation completed | Disk data available |
| Running → Terminated | Process completes or killed | `exit()` called or `kill` signal |

---

## 2.4 Process Operations

### Process Creation

```
Parent process creates child process using fork():

Parent (PID: 100)
    │
    │── fork() ──► Child (PID: 101)
    │                   │
    │                   └── Can exec() different program
    │
    └── continues execution

In Linux:
  - init/systemd (PID 1) is the ancestor of ALL processes
  - Every process has a parent (except init)
  - Process tree: init → login → bash → your_program
```

### Process Termination

```
Normal termination:
  - Process calls exit(0)   → success
  - Process calls exit(1)   → error

Abnormal termination:
  - Parent kills child: kill(child_pid, SIGKILL)
  - OS kills process: out of memory, illegal operation
  
Zombie process: Child terminated but parent hasn't called wait()
Orphan process: Parent terminated before child → init adopts child
```

---

## 2.5 Threads

### Definition
A **thread** is the smallest unit of CPU execution within a process. A process can have multiple threads sharing the same memory space.

### Process vs Thread

| Aspect | Process | Thread |
|--------|---------|--------|
| Memory | Own address space | Shares process memory |
| Creation | Heavy (slow) | Light (fast) |
| Communication | IPC needed (pipes, sockets) | Direct shared memory |
| Crash impact | One process crash doesn't affect others | One thread crash can kill entire process |
| Context switch | Expensive | Cheap |
| Resource | Has own resources | Shares resources of process |

### Thread Memory Sharing

```
Process Address Space:
┌─────────────────────────────┐
│        SHARED:               │
│  - Code (Text)              │
│  - Data (Global variables)  │
│  - Heap                     │
│  - Open files               │
├─────────────────────────────┤
│   Thread 1    │   Thread 2  │  ← PRIVATE per thread:
│   Stack       │   Stack     │     - Stack
│   Registers   │   Registers │     - Program counter
│   PC          │   PC        │     - Register set
└─────────────────────────────┘
```

### Types of Threads

| Type | Description | Managed By | Example |
|------|-------------|-----------|---------|
| **User-Level Threads** | Created in user space | Thread library | POSIX pthreads (user-managed) |
| **Kernel-Level Threads** | Created by OS kernel | Kernel | Linux kernel threads |

### Multithreading Models

```
Many-to-One:
  Multiple user threads → One kernel thread
  Problem: One thread blocks → ALL block
  Example: Early Solaris

One-to-One:
  Each user thread → One kernel thread
  Advantage: True parallelism
  Disadvantage: Creating thread = creating kernel thread (overhead)
  Example: Linux (NPTL), Windows

Many-to-Many:
  Multiple user threads → Multiple kernel threads (flexible mapping)
  Advantage: Best of both worlds
  Example: Solaris (later versions)
```

### Benefits of Multithreading

```
1. RESPONSIVENESS: UI thread stays responsive while worker threads compute
2. RESOURCE SHARING: Threads share memory → no IPC overhead
3. ECONOMY: Thread creation is 30x faster than process creation
4. SCALABILITY: Threads can run on different CPU cores (parallelism)

Example: Web browser
  - Thread 1: Render page (display)
  - Thread 2: Download images
  - Thread 3: Handle user input
  - Thread 4: Run JavaScript
```

---

## 2.6 Context Switching

### Definition
**Context switching** is the process of saving the state of the currently running process and loading the state of the next process to run.

### Steps

```
Process A (Running)              Process B (Ready)
     │                                │
     │ 1. Interrupt/syscall           │
     │    occurs                      │
     ▼                                │
 Save state of A                      │
 (registers, PC, etc.                 │
  into PCB-A)                         │
     │                                │
     │ 2. Scheduler selects B         │
     │                                │
     │    Load state of B             │
     │    (from PCB-B into CPU)       │
     │                                ▼
     │                           Process B (Running)
     ▼
Process A (Ready)

Time spent in context switch = OVERHEAD (no useful work done)
```

### Cost of Context Switching

```
What happens during context switch:
  1. Save all CPU registers of current process
  2. Save program counter
  3. Update PCB of current process
  4. Move process to appropriate queue
  5. Select next process (scheduling decision)
  6. Update PCB of new process to "Running"
  7. Load saved registers of new process
  8. Load program counter of new process
  9. Flush TLB / update memory mapping (most expensive!)

Typical time: 1-10 microseconds (depends on hardware)

Why it's costly:
  - CPU does NO useful work during switch
  - Cache may be invalidated (cold cache for new process)
  - TLB entries flushed
```

---

## 2.7 Inter-Process Communication (IPC)

### Why IPC?
Processes need to communicate and share data. Since each process has its own address space, they can't directly access each other's memory.

### IPC Methods

| Method | Description | Use Case |
|--------|-------------|----------|
| **Pipes** | Unidirectional byte stream | Parent-child communication |
| **Named Pipes (FIFO)** | Pipe with name in filesystem | Unrelated processes |
| **Shared Memory** | Common memory region | High-speed data sharing |
| **Message Queues** | Send/receive messages | Structured communication |
| **Sockets** | Network communication | Between machines or localhost |
| **Signals** | Asynchronous notifications | Process control (SIGKILL, SIGTERM) |

### Pipe Example

```bash
# In Linux shell: pipe connects stdout of one process to stdin of another
ls -l | grep ".txt"

# ls -l writes to pipe → grep reads from pipe
```

---

## 2.8 Common Mistakes & Interview Tips

### Common Mistakes

| Mistake | Correction |
|---------|-----------|
| "Process and program are the same" | Program is passive (file), process is active (executing) |
| "Threads have separate memory" | Threads share process memory (code, data, heap) |
| "Context switch is free" | It has real overhead (save/load state, cache flush) |
| "More threads always = faster" | Too many threads → excessive context switching → slower |

### Interview Questions

**Q: What is the difference between a process and a thread?**
> A process is an independent executing program with its own memory space. A thread is a lightweight unit of execution within a process that shares memory with other threads in the same process. Thread creation is faster and context switching between threads is cheaper.

**Q: What is a zombie process?**
> A zombie process is a child process that has finished execution but whose exit status hasn't been read by its parent (parent hasn't called `wait()`). It still occupies a slot in the process table.

**Q: What is a PCB?**
> Process Control Block — a data structure the OS maintains for each process, containing PID, process state, program counter, CPU registers, memory info, and I/O status. It's used during context switching.

---

## 2.9 Practice & Assessment

### MCQs

**Q1.** A process that has finished but whose parent hasn't called wait() is:
- A) Orphan
- B) Zombie
- C) Daemon
- D) Blocked

**Answer:** B) Zombie

---

**Q2.** Threads within the same process share:
- A) Stack
- B) Program counter
- C) Heap and global data
- D) Register values

**Answer:** C) Heap and global data

---

**Q3.** During a context switch, which is saved into the PCB?
- A) Hard disk contents
- B) CPU registers and program counter
- C) Monitor resolution
- D) Network packets

**Answer:** B) CPU registers and program counter

---

**Q4.** Which process state means "waiting for I/O to complete"?
- A) Ready
- B) Running
- C) Waiting (Blocked)
- D) New

**Answer:** C) Waiting (Blocked)

---

### Hands-On Task

**Task:** Given the following scenario, trace the process states:
1. User double-clicks a program icon
2. OS loads program into memory
3. Process waits for CPU
4. Process gets CPU and starts running
5. Process requests file read from disk
6. Disk completes read
7. Process gets CPU again and finishes

**Answer:**
```
1. NEW (being created)
2. NEW → READY (loaded, waiting for CPU)
3. READY (in ready queue)
4. READY → RUNNING (scheduled by CPU)
5. RUNNING → WAITING (I/O request)
6. WAITING → READY (I/O done)
7. READY → RUNNING → TERMINATED (completes)
```

---

> **Next Topic:** [03 - CPU Scheduling](03-cpu-scheduling.md)
