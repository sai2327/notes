# 📘 Chapter 10: OS Interview Preparation

> **"Master these concepts, and you'll be ready for any Operating Systems interview — from campus placements to FAANG."**

---

## 📑 Table of Contents

| # | Topic |
|---|-------|
| 1 | [Top 65 Interview Questions & Answers](#1-top-50-interview-questions--answers) |
| 2 | [Concept Comparison Cheat Sheets](#2-concept-comparison-cheat-sheets) |
| 3 | [Common Traps & Mistakes](#3-common-traps--mistakes) |
| 4 | [One-Liner Quick Recall](#4-one-liner-quick-recall) |
| 5 | [Numerical Problem Formulas](#5-numerical-problem-formulas) |
| 6 | [Scenario-Based Interview Questions](#6-scenario-based-interview-questions) |
| 7 | [Linux Interview Questions](#7-linux-interview-questions) |
| 8 | [Final Revision Checklist](#8-final-revision-checklist) |
| 9 | [FAANG-Style System Design Questions](#9-faang-style-system-design-questions-with-os-concepts) |

---

## 1. Top 50 Interview Questions & Answers

### OS Basics (Q1–Q10)

**Q1. What is an Operating System?**
> An OS is system software that manages hardware resources and provides an interface between users and hardware. It handles process management, memory management, file systems, I/O, and security.

**Q2. What are the main functions of an OS?**
> Process Management, Memory Management, File System Management, I/O Device Management, Security & Protection, User Interface (CLI/GUI).

**Q3. What is a kernel? What are its types?**
> The kernel is the core of the OS that directly manages hardware. Types:
> - **Monolithic**: All services in one large kernel (Linux)
> - **Microkernel**: Minimal kernel, services run in user space (Minix)
> - **Hybrid**: Mix of both (Windows NT, macOS)

**Q4. What is the difference between Kernel Mode and User Mode?**
> - **Kernel Mode**: Full hardware access, privileged instructions allowed
> - **User Mode**: Restricted access, must use system calls for hardware
> - Mode bit: 0 = kernel, 1 = user

**Q5. What is a System Call? Give examples.**
> A system call is the programmatic interface between a user process and the OS kernel. Examples: `fork()`, `exec()`, `read()`, `write()`, `open()`, `close()`, `wait()`, `exit()`.

**Q6. What is multiprogramming vs multitasking?**
> - **Multiprogramming**: Multiple programs in memory; CPU switches when one does I/O (no time sharing)
> - **Multitasking**: CPU time is shared among processes using time slicing (each gets a time quantum)

**Q7. What is a real-time operating system (RTOS)?**
> An OS with guaranteed response time for critical tasks. **Hard RTOS**: Missing deadline = system failure (missile systems). **Soft RTOS**: Missing deadline degrades quality (video streaming).

**Q8. Difference between 32-bit and 64-bit OS?**
> - 32-bit: Can address 2^32 = 4 GB RAM max
> - 64-bit: Can address 2^64 = 16 exabytes (theoretical), typically supports 128+ GB
> - 64-bit processes data in 64-bit chunks (faster for large data)

**Q9. What is a bootstrap program?**
> The first program that runs when a computer starts. Stored in ROM/EPROM (firmware). It initializes hardware and loads the OS kernel into memory.

**Q10. What is an interrupt? Types?**
> An interrupt is a signal that causes the CPU to stop current execution and handle an event.
> - **Hardware Interrupt**: External device signals (keyboard, disk)
> - **Software Interrupt (Trap)**: Program-generated (system calls, exceptions)

---

### Process Management (Q11–Q20)

**Q11. What is a process? How is it different from a program?**
> A **program** is passive code stored on disk. A **process** is an active instance of a program in execution, with its own memory space, program counter, registers, and stack.

**Q12. What are the states of a process?**
```
    New → Ready → Running → Waiting → Ready → Running → Terminated
    
    New:        Process is being created
    Ready:      Waiting for CPU allocation
    Running:    Instructions being executed
    Waiting:    Waiting for I/O or event
    Terminated: Process has finished
```

**Q13. What is a PCB (Process Control Block)?**
> A data structure maintained by the OS for each process, containing: Process ID, Process State, Program Counter, CPU Registers, Memory Management Info, I/O Status, Scheduling Information.

**Q14. What is context switching? Is it overhead?**
> Context switching saves the state (PCB) of the current process and loads the state of the next process. Yes, it's **pure overhead** — no useful work is done during a context switch. It typically takes 1-1000 microseconds.

**Q15. Difference between preemptive and non-preemptive scheduling?**
> - **Preemptive**: OS can forcibly take CPU from a process (SRTF, RR, Priority Preemptive)
> - **Non-preemptive**: Process keeps CPU until it finishes or voluntarily yields (FCFS, SJF, Priority Non-preemptive)

**Q16. Compare FCFS, SJF, SRTF, and Round Robin.**

| Feature | FCFS | SJF | SRTF | Round Robin |
|---------|------|-----|------|-------------|
| Type | Non-preemptive | Non-preemptive | Preemptive | Preemptive |
| Starvation | No | Yes (long jobs) | Yes (long jobs) | No |
| Convoy Effect | Yes | No | No | No |
| Optimal | No | Yes (min avg WT) | Yes (preemptive min avg WT) | No |
| Response Time | Poor | Poor | Good | Best |

**Q17. What is starvation? How to solve it?**
> Starvation occurs when a process waits indefinitely because other higher-priority/shorter processes keep getting CPU. **Solution**: **Aging** — gradually increase the priority of waiting processes.

**Q18. What is the convoy effect?**
> In FCFS, a long CPU-burst process blocks all shorter processes behind it, causing all to wait — like a slow truck blocking traffic on a single-lane road.

**Q19. What is a zombie process?**
> A process that has completed execution but still has an entry in the process table because its parent hasn't called `wait()` to read its exit status. It consumes no resources except the PID.

**Q20. What is an orphan process?**
> A process whose parent has terminated. The orphan is adopted by the `init` process (PID 1), which eventually calls `wait()` to clean it up.

---

### Threads (Q21–Q25)

**Q21. What is a thread? How does it differ from a process?**
> A thread is the smallest unit of execution within a process. Multiple threads share the same address space (code, data, heap) but have their own stack, registers, and PC. Thread creation is ~10-100x faster than process creation.

**Q22. What are User-Level Threads vs Kernel-Level Threads?**
> - **ULT**: Managed by user-space library; kernel is unaware; one thread blocks → all block
> - **KLT**: Managed by OS kernel; true parallelism possible; slower to create/manage

**Q23. What are multithreading models?**
> - **Many-to-One**: Many ULTs → 1 KLT (no parallelism)
> - **One-to-One**: 1 ULT → 1 KLT (good parallelism, high overhead)
> - **Many-to-Many**: M ULTs → N KLTs (best of both worlds)

**Q24. What is the difference between multiprocessing and multithreading?**
> - **Multiprocessing**: Multiple processes running on multiple CPUs
> - **Multithreading**: Multiple threads within a single process sharing memory
> Multithreading: faster communication (shared memory), lower overhead

**Q25. What is a thread pool?**
> A collection of pre-created threads that wait for tasks. Instead of creating/destroying threads for each request, tasks are assigned to existing threads. Used in web servers (e.g., Tomcat, Nginx).

---

### Synchronization (Q26–Q32)

**Q26. What is a race condition?**
> A race condition occurs when multiple processes/threads access shared data concurrently, and the final result depends on the execution order (which is non-deterministic).

**Q27. What is the Critical Section problem?**
> The critical section is code that accesses shared resources. The problem is to design a protocol ensuring: **Mutual Exclusion** (only one process at a time), **Progress** (no unnecessary blocking), **Bounded Waiting** (no infinite waiting).

**Q28. What is a mutex? How does it differ from a semaphore?**
> - **Mutex**: Binary lock (0 or 1). Only the thread that acquired it can release it. Used for mutual exclusion.
> - **Semaphore**: Integer counter. Any thread can signal. Can be binary (0/1) or counting (0 to N).

| Feature | Mutex | Semaphore |
|---------|-------|-----------|
| Ownership | Yes (owner releases) | No (any thread can signal) |
| Values | 0 or 1 | 0 to N |
| Purpose | Mutual exclusion | Synchronization & resource counting |

**Q29. What is a deadlock?**
> A situation where two or more processes are each waiting for a resource held by another, creating a circular wait. None can proceed.

**Q30. What are the four conditions for deadlock? (Coffman Conditions)**
> ALL four must hold simultaneously:
> 1. **Mutual Exclusion**: Resource can't be shared
> 2. **Hold and Wait**: Process holds resources while waiting for others
> 3. **No Preemption**: Resources can't be forcibly taken
> 4. **Circular Wait**: Circular chain of processes waiting for each other

**Q31. Explain Banker's Algorithm.**
> Banker's Algorithm is a deadlock **avoidance** technique. Before granting a resource request, it checks if the resulting state is "safe" (all processes can complete in some order). If safe → grant. If unsafe → deny and wait.

**Q32. What is priority inversion? How to solve it?**
> A high-priority task waits for a lock held by a low-priority task. A medium-priority task preempts the low-priority task, indirectly blocking the high-priority one.
> **Solutions**: Priority Inheritance (temporarily boost low-priority task), Priority Ceiling.

---

### Memory Management (Q33–Q40)

**Q33. What is the difference between logical and physical address?**
> - **Logical (Virtual) Address**: Generated by CPU; what the process sees
> - **Physical Address**: Actual location in RAM
> - **MMU**: Hardware that translates logical → physical

**Q34. What is paging? What problem does it solve?**
> Paging divides logical memory into fixed-size **pages** and physical memory into same-size **frames**. It eliminates **external fragmentation** since any page can go into any free frame (non-contiguous allocation).

**Q35. What is a page fault?**
> A page fault occurs when a process accesses a page that is not currently in physical memory (valid bit = 0 in page table). The OS must load the page from disk — this is expensive (~8ms).

**Q36. What is a TLB?**
> Translation Lookaside Buffer — a fast **hardware cache** for recent page table entries. TLB hit avoids page table memory access. EAT = hit_rate × 1_access + miss_rate × 2_accesses.

**Q37. Compare paging and segmentation.**

| Feature | Paging | Segmentation |
|---------|--------|--------------|
| Size | Fixed-size pages | Variable-size segments |
| External Frag. | No | Yes |
| Internal Frag. | Yes (last page) | No |
| Programmer View | Invisible | Visible (code, data, stack) |
| Address | Page# + Offset | Segment# + Offset |

**Q38. What is virtual memory?**
> Virtual memory allows processes to execute even when not fully loaded in RAM. Only needed pages are in memory; rest are on disk. Enables running programs larger than physical RAM.

**Q39. What is thrashing?**
> When a system spends MORE time swapping pages (page faults) than executing useful work. Caused by too many processes competing for too few frames. CPU utilization drops dramatically.

**Q40. Compare FIFO, LRU, and Optimal page replacement.**

| Algorithm | Looks At | Belady's Anomaly | Practical? |
|-----------|----------|-------------------|------------|
| FIFO | Oldest loaded | Yes | Yes (simple) |
| LRU | Least recently used | No | Yes (with HW support) |
| Optimal | Farthest future use | No | No (needs future knowledge) |

---

### File System & Disk (Q41–Q45)

**Q41. What is an inode?**
> An index node in Unix/Linux that stores file metadata (size, permissions, timestamps, owner) and pointers to data blocks. **The filename is NOT stored in the inode** — it's stored in the directory entry.

**Q42. What is the difference between hard link and soft link?**

| Feature | Hard Link | Soft (Symbolic) Link |
|---------|-----------|---------------------|
| Inode | Same as original | Different inode |
| Cross filesystem | No | Yes |
| Original deleted | Still works | Breaks (dangling) |
| Directory linking | No | Yes |

**Q43. Compare contiguous, linked, and indexed file allocation.**

| Feature | Contiguous | Linked | Indexed |
|---------|-----------|--------|---------|
| Direct Access | Yes | No | Yes |
| External Frag. | Yes | No | No |
| File Growth | Difficult | Easy | Easy |
| Example | CD-ROM | FAT | Unix inode |

**Q44. What is SCAN disk scheduling?**
> SCAN (Elevator Algorithm): The disk head moves in one direction servicing all requests until it reaches the end, then reverses direction. Prevents starvation. LOOK is optimized SCAN that stops at the last request.

**Q45. Why don't we need disk scheduling for SSDs?**
> SSDs have no moving parts (no mechanical arm). All locations are equally accessible in ~0.1 ms. Seek time ≈ 0, so optimizing seek order provides no benefit. Simple NOOP/FIFO schedulers work best.

---

### Linux (Q46–Q50)

**Q46. What does `chmod 755` mean?**
> Owner: rwx (7=4+2+1), Group: r-x (5=4+0+1), Others: r-x (5=4+0+1). Owner has full access, everyone else can read and execute but not write.

**Q47. What is the difference between `kill` and `kill -9`?**
> - `kill PID` sends SIGTERM (15) — asks process to terminate gracefully (can be caught/ignored)
> - `kill -9 PID` sends SIGKILL (9) — forces immediate termination (cannot be caught)

**Q48. How to find all files larger than 100MB?**
> `find / -type f -size +100M`

**Q49. What is the `/proc` filesystem?**
> A virtual filesystem that provides a window into the kernel. Contains real-time information about running processes, memory, CPU, etc. Each process has a directory `/proc/[PID]/` with status, maps, etc.

**Q50. What is the difference between `>` and `>>` in shell?**
> - `>` : Redirects output and **overwrites** the file
> - `>>` : Redirects output and **appends** to the file

---

### Advanced Topics (Q51–Q65)

**Q51. What is the difference between a monolithic kernel and a microkernel?**

| Feature | Monolithic Kernel | Microkernel |
|---------|------------------|-------------|
| Services in kernel space | All (FS, drivers, MM) | Minimal (IPC, scheduling) |
| Performance | Fast (direct calls) | Slower (message passing) |
| Stability | One crash = kernel crash | Isolated — service crash doesn't crash kernel |
| Example | Linux, Unix | Minix, QNX, L4 |
| Size | Large | Small |

> Linux is monolithic but **modular** — drivers can be loaded/unloaded as modules without recompiling.

**Q52. What is a hypervisor? Difference between Type 1 and Type 2?**

| Type | Name | Description | Example |
|------|------|-------------|---------|
| **Type 1** | Bare-metal | Runs directly on hardware; no host OS | VMware ESXi, Hyper-V, KVM |
| **Type 2** | Hosted | Runs on top of a host OS | VirtualBox, VMware Workstation |

> Type 1 is used in data centers (AWS EC2, Azure VMs). Type 2 for developer workstations.

**Q53. What is a container vs a virtual machine?**

| Feature | Container (Docker) | Virtual Machine |
|---------|-------------------|-----------------|
| OS isolation | Shares host kernel | Full OS per VM |
| Startup time | Milliseconds | Minutes |
| Size | Megabytes | Gigabytes |
| Performance | Near-native | 5-15% overhead |
| Isolation | Process-level (namespaces) | Full hardware-level |
| Use case | Microservices, DevOps | Full OS testing, legacy apps |

> Containers use Linux **namespaces** (isolation) + **cgroups** (resource limits). Not a separate OS!

**Q54. What is a socket? How does it relate to OS file descriptors?**
> A **socket** is an endpoint for network communication. In Unix/Linux, sockets are treated as file descriptors — you can use `read()`, `write()`, `close()` on them just like files. `socket()` returns an FD; `bind()`, `connect()`, `accept()` configure it.

**Q55. What is Copy-On-Write (COW) in `fork()`?**
> When a child process is created via `fork()`, both parent and child initially **share the same physical pages**. The OS marks them read-only. When either tries to **write** to a page, the OS makes a copy for the writer. This avoids copying all memory at fork time — critical performance optimization.

**Q56. What is the difference between `fork()` and `exec()`?**
> - `fork()`: Creates a **copy** of the current process (new PID, same code/data)
> - `exec()`: **Replaces** the current process's code/data with a new program (same PID, different code)
> - Together: `fork()` → child calls `exec("new_program")` = new process running new program

**Q57. What is IPC (Inter-Process Communication)? Name the methods.**

| IPC Method | Speed | Synchronization | Usage |
|-----------|-------|-----------------|-------|
| Shared Memory | Fastest | Manual (semaphores) | High-speed data sharing |
| Message Queues | Medium | Built-in | Asynchronous messaging |
| Pipes | Medium | Blocking read/write | Parent-child communication |
| Named Pipes (FIFO) | Medium | Blocking | Unrelated processes |
| Sockets | Variable | Any | Network communication |
| Signals | Fast (minimal data) | Asynchronous | Event notification |

**Q58. What is a page table hierarchy? Why do modern CPUs use multi-level page tables?**
> A 32-bit address space with 4KB pages needs $2^{20}$ page table entries = 4 MB per process. With 100 processes = 400 MB just for page tables! Multi-level (2 or 4-level) page tables allocate only the entries actually needed — sparse address spaces use much less memory.
>
> x86-64 uses 4-level page tables: PML4 → PDPT → PD → PT → Physical Frame.

**Q59. What is the difference between preemptive and non-preemptive kernel?**
> - **Non-preemptive kernel**: Once in kernel mode, a process runs until it exits kernel mode or blocks. Simpler, no race conditions in kernel code.
> - **Preemptive kernel**: Kernel code itself can be interrupted and preempted. Required for real-time responsiveness. Linux is a preemptive kernel (since 2.6).

**Q60. What is memory-mapped I/O vs port-mapped I/O?**

| Feature | Memory-Mapped I/O | Port-Mapped I/O |
|---------|------------------|-----------------|
| Device access | Via normal memory addresses | Via special I/O addresses (ports) |
| Instructions | Standard `load`/`store` | Special `IN`/`OUT` instructions |
| Address space | Shared with RAM | Separate I/O address space |
| Common usage | Modern devices (GPU, PCI) | Legacy devices (serial ports, PS/2) |
| Example | GPU registers mapped to 0xFD000000 | COM1 port mapped to I/O port 0x3F8 |

**Q61. What is a spinlock? When should you use it vs a mutex?**
> A **spinlock** is a lock where the waiting thread **continuously loops** (spins) checking if the lock is available — no context switch.
>
> | Situation | Use Spinlock | Use Mutex |
> |-----------|-------------|-----------|
> | Critical section is very short (< 1μs) | ✅ Yes | ❌ Overkill |
> | Critical section is long | ❌ Wastes CPU | ✅ Yes |
> | Interrupt context (can't sleep) | ✅ Yes | ❌ Illegal |
> | User-space code | ❌ Rarely | ✅ Typical |
>
> Kernel device drivers use spinlocks for protecting short critical sections in interrupt handlers.

**Q62. What is the working set model? How does it prevent thrashing?**
> The **working set** of a process is the set of pages actively used during a recent window of time (Δ accesses). If total working sets of all processes > available frames → **thrashing**. Solution: suspend some processes until total working sets fit in memory. Each process needs all its working set pages in memory to avoid excessive page faults.

**Q63. What is NUMA (Non-Uniform Memory Access)?**
> In multi-processor systems, CPUs have faster access to their **local** memory than to memory attached to other CPUs. The OS scheduler tries to run processes on the CPU closest to their data (NUMA-aware scheduling) to minimize memory latency. Linux has NUMA-aware allocations via `numactl`.

**Q64. What are Linux namespaces? Name all types.**

| Namespace | Isolates | Docker use |
|-----------|----------|-----------|
| **PID** | Process IDs (container sees its own PID 1) | Yes |
| **Network** | Network interfaces, routing, ports | Yes |
| **Mount** | Filesystem mount points | Yes |
| **UTS** | Hostname and domain name | Yes |
| **IPC** | Semaphores, message queues, shared memory | Yes |
| **User** | User and group IDs | Optional |
| **Cgroup** | cgroup root directory | Yes |
| **Time** | System clocks (Linux 5.6+) | No |

**Q65. Explain the meltdown and spectre vulnerabilities in terms of OS concepts.**
> **Meltdown** (2018): Exploited speculative execution — CPU reads privileged memory (kernel) speculatively before the access check fails. By measuring cache timing (side-channel), unprivileged user code could read kernel memory.
>
> **OS Fix (KPTI — Kernel Page Table Isolation)**: Kernel and user page tables are now **separate**. When in user mode, kernel memory is **unmapped** — speculative reads fail at the CPU level. Cost: 5-30% performance penalty for system-call-heavy workloads.
>
> **Spectre**: More general — poisons branch predictor to speculatively execute attacker-chosen code paths, leaking data via cache side-channels. Requires extensive compiler + firmware patches.

---

## 2. Concept Comparison Cheat Sheets

### Process vs Thread

```
    ┌──────────────────────┬───────────────────────┐
    │      PROCESS          │       THREAD           │
    ├──────────────────────┼───────────────────────┤
    │ Heavy weight          │ Light weight           │
    │ Own memory space      │ Shared memory space    │
    │ Slower creation       │ Faster creation        │
    │ IPC needed to comm.   │ Direct shared memory   │
    │ Crash = isolated      │ Crash = may kill proc  │
    │ More overhead         │ Less overhead          │
    │ Independent           │ Part of a process      │
    └──────────────────────┴───────────────────────┘
```

### Mutex vs Semaphore vs Monitor

```
    ┌──────────────┬──────────────┬──────────────┐
    │    MUTEX      │  SEMAPHORE   │   MONITOR    │
    ├──────────────┼──────────────┼──────────────┤
    │ Binary (0/1)  │ Integer (0-N)│ ADT with     │
    │               │              │ condition    │
    │ Ownership     │ No ownership │ vars         │
    │ (locker       │ (any can     │              │
    │  unlocks)     │  signal)     │ Automatic    │
    │               │              │ mutex        │
    │ Mutual        │ Counting +   │              │
    │ exclusion     │ Signaling    │ High-level   │
    │ only          │              │ construct    │
    └──────────────┴──────────────┴──────────────┘
```

### Deadlock Handling Summary

```
    ┌────────────────────────────────────────────────┐
    │           DEADLOCK HANDLING METHODS              │
    ├────────────────────────────────────────────────┤
    │                                                │
    │  1. PREVENTION (Break one of 4 conditions)     │
    │     - No mutual exclusion (use sharable res.)  │
    │     - No hold & wait (request all at once)     │
    │     - Allow preemption (take resources back)   │
    │     - No circular wait (impose ordering)       │
    │                                                │
    │  2. AVOIDANCE (Banker's Algorithm)             │
    │     - Check if state is "safe" before granting │
    │     - Requires advance knowledge of max needs  │
    │                                                │
    │  3. DETECTION + RECOVERY                       │
    │     - Allow deadlocks to occur                 │
    │     - Detect using wait-for graph              │
    │     - Recover: kill process or preempt resource│
    │                                                │
    │  4. IGNORANCE (Ostrich Algorithm)              │
    │     - Pretend deadlocks don't happen           │
    │     - Used by most OSes (Linux, Windows)       │
    │     - Deadlocks are rare; handling is expensive│
    │                                                │
    └────────────────────────────────────────────────┘
```

---

## 3. Common Traps & Mistakes

```
    ┌──────────────────────────────────────────────────────────────┐
    │               COMMON INTERVIEW TRAPS                          │
    ├──────────────────────────────────────────────────────────────┤
    │                                                              │
    │  ❌ "Paging eliminates ALL fragmentation"                     │
    │  ✅  Paging eliminates EXTERNAL frag, but has INTERNAL frag  │
    │                                                              │
    │  ❌ "SJF is always the best scheduling algorithm"             │
    │  ✅  SJF is optimal for avg waiting time, but causes          │
    │      starvation and requires knowing burst time in advance    │
    │                                                              │
    │  ❌ "More frames always means fewer page faults"              │
    │  ✅  Belady's Anomaly: FIFO can get MORE faults with MORE    │
    │      frames                                                  │
    │                                                              │
    │  ❌ "Deadlock prevention and avoidance are the same"          │
    │  ✅  Prevention: structurally impossible by breaking a        │
    │      condition. Avoidance: allow conditions but check safety. │
    │                                                              │
    │  ❌ "Mutex and binary semaphore are identical"                │
    │  ✅  Mutex has OWNERSHIP (only locker can unlock).            │
    │      Binary semaphore has NO ownership.                       │
    │                                                              │
    │  ❌ "SCAN goes only to the last request each way"             │
    │  ✅  SCAN goes to the END of the disk. LOOK stops at last    │
    │      request. Common confusion!                              │
    │                                                              │
    │  ❌ "Thread crash doesn't affect other threads"               │
    │  ✅  Threads share address space — one crash can bring down  │
    │      the entire process and all its threads.                  │
    │                                                              │
    │  ❌ "Inode stores the filename"                               │
    │  ✅  Filename is stored in the DIRECTORY, not the inode.      │
    │                                                              │
    │  ❌ "Virtual memory makes programs run faster"                │
    │  ✅  Virtual memory allows running larger programs, but       │
    │      page faults make it SLOWER. It trades speed for capacity.│
    │                                                              │
    │  ❌ "kill command always kills a process"                     │
    │  ✅  Default kill sends SIGTERM (can be caught/ignored).      │
    │      Only kill -9 (SIGKILL) guarantees termination.          │
    │                                                              │
    └──────────────────────────────────────────────────────────────┘
```

---

## 4. One-Liner Quick Recall

```
    ┌────────────────────────────────────────────────────────────────┐
    │   RAPID-FIRE ONE-LINERS (for last-minute revision)             │
    ├────────────────────────────────────────────────────────────────┤
    │                                                                │
    │  OS = Interface between user and hardware                      │
    │  Kernel = Core of OS, manages hardware directly                │
    │  System Call = User process → Kernel request                   │
    │  Process = Program in execution                                │
    │  PCB = Process's ID card (stores all info)                     │
    │  Context Switch = Save old PCB, load new PCB                   │
    │  Thread = Lightweight process (shares address space)           │
    │  Deadlock = Circular waiting for resources                     │
    │  Starvation = Indefinite waiting (not circular)                │
    │  Mutex = Lock with ownership                                   │
    │  Semaphore = Integer counter for synchronization               │
    │  Critical Section = Code accessing shared resources            │
    │  Page = Fixed-size block of logical memory                     │
    │  Frame = Fixed-size block of physical memory                   │
    │  TLB = Hardware cache for page table (speed up translation)    │
    │  Page Fault = Page not in RAM → load from disk                 │
    │  Thrashing = More paging than computing                        │
    │  Virtual Memory = Disk as extension of RAM                     │
    │  Inode = File metadata + block pointers (NOT filename!)        │
    │  Hard Link = Another name for same file (same inode)           │
    │  Soft Link = Shortcut to file path (different inode)           │
    │  FCFS Disk = Serve in order (simple, bad seek time)            │
    │  SSTF Disk = Nearest request first (good, may starve)          │
    │  SCAN = Elevator (sweep back and forth to ends)                │
    │  LOOK = Elevator but stops at last request (not end)           │
    │                                                                │
    └────────────────────────────────────────────────────────────────┘
```

---

## 5. Numerical Problem Formulas

### CPU Scheduling Formulas

```
    ┌──────────────────────────────────────────────────────────────┐
    │                CPU SCHEDULING FORMULAS                        │
    ├──────────────────────────────────────────────────────────────┤
    │                                                              │
    │  Turnaround Time (TAT) = Completion Time - Arrival Time      │
    │                                                              │
    │  Waiting Time (WT) = Turnaround Time - Burst Time            │
    │                                                              │
    │  Response Time (RT) = First CPU Time - Arrival Time          │
    │                                                              │
    │  Throughput = Number of processes / Total time                │
    │                                                              │
    │  CPU Utilization = (Busy Time / Total Time) × 100%           │
    │                                                              │
    └──────────────────────────────────────────────────────────────┘
```

### Memory Management Formulas

```
    ┌──────────────────────────────────────────────────────────────┐
    │               MEMORY MANAGEMENT FORMULAS                      │
    ├──────────────────────────────────────────────────────────────┤
    │                                                              │
    │  Number of Pages = Logical Address Space / Page Size         │
    │  Number of Frames = Physical Memory / Frame Size             │
    │  Page Size = Frame Size (always equal)                       │
    │                                                              │
    │  Logical Address bits = Page bits + Offset bits              │
    │  Physical Address bits = Frame bits + Offset bits            │
    │  Offset bits = log₂(Page Size)                               │
    │  Page bits = log₂(Number of Pages)                           │
    │                                                              │
    │  Page Table Size = Number of Pages × Entry Size              │
    │                                                              │
    │  Physical Address = (Frame # × Page Size) + Offset          │
    │                                                              │
    │  EAT = (1-p) × memory_access + p × page_fault_time          │
    │  where p = page fault rate                                   │
    │                                                              │
    │  EAT with TLB:                                               │
    │  = h × (t_tlb + t_mem) + (1-h) × (t_tlb + 2 × t_mem)      │
    │  where h = TLB hit rate, t_tlb ≈ 0 (often ignored)         │
    │  Simplified: = h × t_mem + (1-h) × 2t_mem                  │
    │                                                              │
    └──────────────────────────────────────────────────────────────┘
```

### Disk Scheduling

```
    ┌──────────────────────────────────────────────────────────────┐
    │                 DISK SCHEDULING FORMULAS                      │
    ├──────────────────────────────────────────────────────────────┤
    │                                                              │
    │  Disk Access Time = Seek Time + Rotational Latency           │
    │                     + Transfer Time                          │
    │                                                              │
    │  Avg Rotational Latency = (1/2) × (60/RPM) seconds          │
    │                                                              │
    │  Total Seek = Sum of |current_track - next_track|            │
    │  for all movements                                           │
    │                                                              │
    │  Avg Seek = Total Seek / Number of movements                 │
    │                                                              │
    └──────────────────────────────────────────────────────────────┘
```

### Banker's Algorithm Quick Reference

```
    Need[i][j] = Max[i][j] - Allocation[i][j]
    
    SAFETY ALGORITHM:
    1. Work = Available (copy)
    2. Find process i where:
       Finish[i] = false AND Need[i] ≤ Work
    3. Work = Work + Allocation[i]
       Finish[i] = true
    4. Repeat step 2
    5. If all Finish[i] = true → SAFE state
```

---

## 6. Scenario-Based Interview Questions

### Scenario 1: Design Question
**Q: How would you design a simple process scheduler?**

> **Answer:**
> 1. Maintain a **Ready Queue** (priority queue or FIFO)
> 2. When CPU is free, pick next process based on algorithm (RR for fairness)
> 3. Set a **timer interrupt** for the time quantum
> 4. On interrupt → **context switch**: save current PCB, load next PCB
> 5. Handle I/O-bound vs CPU-bound processes differently (MLFQ: interactive processes get higher priority)
> 6. Implement aging to prevent starvation

### Scenario 2: Debugging
**Q: A web server creates a new thread for each request. Users report it's crashing under load. What's wrong?**

> **Answer:**
> - Creating unlimited threads → memory exhaustion (each thread needs stack space ~1-8 MB)
> - **Solution**: Use a **thread pool** with a fixed number of worker threads
> - Incoming requests queue up; threads pick from queue
> - Limit: typically 100-500 threads depending on workload type

### Scenario 3: Real-World
**Q: Why does your computer slow down when you open many Chrome tabs?**

> **Answer:**
> - Each Chrome tab is a **separate process** (Chrome uses multi-process architecture)
> - Many tabs → RAM fills up → OS starts **swapping** pages to disk
> - This leads to **thrashing** — more time paging than computing
> - Also: context switching overhead increases with many processes
> - Solution: Close unused tabs, add RAM, or use a tab suspender extension

### Scenario 4: System Design
**Q: Database reads are slow. How does the OS help?**

> **Answer:**
> - **Page cache**: OS caches frequently accessed disk blocks in RAM
> - **Buffering**: Multiple small reads combined into one large read
> - **Memory-mapped files**: Map file directly into virtual address space
> - **Disk scheduling**: Reorder I/O requests to minimize seek time (LOOK/C-LOOK)
> - **Read-ahead**: OS pre-fetches sequential blocks expecting future reads

### Scenario 5: Troubleshooting
**Q: A Linux server is running but extremely slow. How do you diagnose?**

> **Answer:**
```bash
# 1. Check CPU usage
top                    # or htop — is one process using 100% CPU?

# 2. Check memory
free -h                # Is RAM full? Is swap being used heavily?

# 3. Check disk I/O
iostat -x 1            # High disk utilization? (iowait%)
iotop                  # Which process is doing heavy I/O?

# 4. Check processes
ps aux --sort=-%cpu    # Top CPU consumers
ps aux --sort=-%mem    # Top memory consumers

# 5. Check disk space
df -h                  # Is any partition full?

# 6. Check logs
tail -100 /var/log/syslog    # Any errors?
dmesg | tail                 # Kernel messages

# 7. Check network (if applicable)
ss -tuln               # Port connections
netstat -an | wc -l    # Total connections
```

---

## 7. Linux Interview Questions

### Top 20 Linux Questions

| # | Question | Key Answer |
|---|----------|------------|
| 1 | Difference between absolute & relative path? | Absolute starts from / (root). Relative starts from current directory. |
| 2 | What is `/dev/null`? | A special file that discards all data written to it. "Black hole" for output. |
| 3 | How to find your IP address? | `ip addr` or `hostname -I` or `ifconfig` |
| 4 | What is a daemon? | A background process (no terminal). Examples: sshd, httpd, cron. |
| 5 | What does `cron` do? | Schedules recurring tasks. `crontab -e` to edit. Format: min hour day month weekday command |
| 6 | How to check disk usage? | `df -h` (filesystem level), `du -sh dir/` (directory level) |
| 7 | What is swap space? | Disk area used as extended RAM when physical memory is full. |
| 8 | How to check which ports are open? | `ss -tuln` or `netstat -tuln` |
| 9 | What is `grep` used for? | Search for text patterns in files. `grep "pattern" file` |
| 10 | What is `awk` used for? | Text processing tool. `awk '{print $1}' file` prints first column. |
| 11 | How to make a script executable? | `chmod +x script.sh` |
| 12 | What is the difference between `&&` and `;`? | `&&` runs next ONLY if previous succeeds. `;` runs next regardless. |
| 13 | What is pipe (`\|`)? | Sends stdout of one command as stdin to the next. |
| 14 | How to run a process in background? | Append `&`: `command &`. Or use `nohup command &` to survive logout. |
| 15 | What does `nohup` do? | Makes process immune to hangup signal (continues after terminal closes). |
| 16 | How to see environment variables? | `env` or `printenv` or `echo $VARIABLE` |
| 17 | What is `/etc/passwd`? | Stores user account information (username, UID, home, shell). |
| 18 | What is umask? | Default permission mask. Files: 666-umask. Dirs: 777-umask. Default umask=022. |
| 19 | How to check system uptime? | `uptime` command |
| 20 | What is the `init` process? | First process (PID=1) started by kernel. Parent of all user processes. |

---

## 8. Final Revision Checklist

```
    ┌──────────────────────────────────────────────────────────────────┐
    │              FINAL EXAM / INTERVIEW CHECKLIST                      │
    ├──────────────────────────────────────────────────────────────────┤
    │                                                                  │
    │  OS BASICS:                                                      │
    │  □ Define OS, Kernel, System Call                                 │
    │  □ Kernel vs User Mode (mode bit)                                │
    │  □ Types of OS (Batch, Multi, RTOS)                              │
    │                                                                  │
    │  PROCESS MANAGEMENT:                                             │
    │  □ Process states (5-state diagram)                              │
    │  □ PCB contents                                                  │
    │  □ Context switching (overhead)                                  │
    │  □ ALL scheduling algorithms + calculations                      │
    │  □ Preemptive vs Non-preemptive                                  │
    │  □ Convoy effect, Starvation, Aging                              │
    │                                                                  │
    │  THREADS:                                                        │
    │  □ Process vs Thread differences                                 │
    │  □ ULT vs KLT                                                    │
    │  □ Multithreading models (M:1, 1:1, M:N)                        │
    │                                                                  │
    │  SYNCHRONIZATION:                                                │
    │  □ Race condition, Critical section (3 requirements)             │
    │  □ Peterson's Solution                                           │
    │  □ Mutex vs Semaphore (OWNERSHIP is key difference)              │
    │  □ Producer-Consumer, Dining Philosophers, Readers-Writers       │
    │  □ Monitor with condition variables                              │
    │                                                                  │
    │  DEADOCKS:                                                       │
    │  □ 4 Coffman Conditions (name all four!)                         │
    │  □ Resource Allocation Graph                                     │
    │  □ Prevention vs Avoidance vs Detection                          │
    │  □ Banker's Algorithm (MUST know step-by-step)                   │
    │  □ Safe state vs Unsafe state                                    │
    │                                                                  │
    │  MEMORY:                                                         │
    │  □ Logical vs Physical address, MMU                              │
    │  □ First/Best/Worst Fit                                          │
    │  □ Paging (page table, address translation, TLB)                 │
    │  □ Segmentation (base + limit, protection)                       │
    │  □ Paging vs Segmentation comparison                             │
    │  □ Virtual Memory (demand paging, page fault handling)           │
    │  □ FIFO, LRU, Optimal page replacement + calculations           │
    │  □ Belady's Anomaly (FIFO only!)                                 │
    │  □ Thrashing (definition, cause, solution)                       │
    │                                                                  │
    │  FILE SYSTEM:                                                    │
    │  □ Contiguous, Linked, Indexed allocation                        │
    │  □ Inode structure (12 direct + indirect)                        │
    │  □ Hard link vs Soft link                                        │
    │  □ FAT vs inode-based systems                                    │
    │  □ Free space management (bitmap, linked list)                   │
    │                                                                  │
    │  DISK SCHEDULING:                                                │
    │  □ FCFS, SSTF, SCAN, C-SCAN, LOOK, C-LOOK                      │
    │  □ Calculate total seek time for each                            │
    │  □ Know which causes starvation (SSTF)                           │
    │  □ SCAN vs LOOK difference                                       │
    │  □ Why SSDs don't need scheduling                                │
    │                                                                  │
    │  LINUX:                                                          │
    │  □ Directory structure (/, /home, /etc, /var, /proc)             │
    │  □ File commands (ls, cp, mv, rm, find, grep)                    │
    │  □ Permissions (chmod, chown, octal notation)                    │
    │  □ Process commands (ps, top, kill, nice)                        │
    │  □ Shell scripting basics (variables, loops, conditionals)       │
    │                                                                  │
    └──────────────────────────────────────────────────────────────────┘
```

---

## 📝 Final Practice Questions

### 🟢 Quick Fire Round (10 Questions — Answer in 10 seconds each)

| # | Question | Answer |
|---|----------|--------|
| 1 | Which scheduling algorithm is optimal for average waiting time? | SJF (Shortest Job First) |
| 2 | Paging has internal or external fragmentation? | Internal fragmentation |
| 3 | Name all 4 deadlock conditions. | Mutual Exclusion, Hold & Wait, No Preemption, Circular Wait |
| 4 | What does TLB cache? | Page table entries |
| 5 | SCAN goes to disk end. What does LOOK do? | Stops at last request |
| 6 | What is `chmod 600`? | rw------- (owner read+write only) |
| 7 | Which signal is `kill -9`? | SIGKILL |
| 8 | Mutex vs Semaphore: which has ownership? | Mutex |
| 9 | What causes Belady's Anomaly? | FIFO page replacement |
| 10 | What is PID 1 in Linux? | init (or systemd) process |

### 🔴 Tricky Conceptual (5 Questions)

**1.** Can deadlock occur with a single process?
> **No.** Deadlock requires circular wait among TWO or more processes.

**2.** If page size is doubled, what happens to page table size?
> Page table size is **halved** (fewer pages to track). But internal fragmentation increases.

**3.** Is Round Robin always better than FCFS?
> No. If all processes have the same burst time and arrive together, RR has the same average waiting time as FCFS but with MORE context switches.

**4.** Can a process be in both waiting and ready state simultaneously?
> **No.** A process is in exactly one state at any time. States are mutually exclusive.

**5.** What happens if the time quantum in Round Robin is set to infinity?
> It degenerates into **FCFS** — each process runs to completion before the next one starts.

---

## 9. FAANG-Style System Design Questions with OS Concepts

### Design Q1: Design a Thread-Safe LRU Cache

**Q: Design a thread-safe LRU Cache that can handle 10,000 concurrent requests.**

**Answer (OS concepts applied)**:

**Data structures**: HashMap (O(1) lookup) + Doubly Linked List (O(1) eviction)

**Synchronization strategy**:
```
Option 1: Single lock (mutex) — simple but bottleneck at high concurrency
Option 2: Read-Write lock — multiple readers, one writer (best for read-heavy)
Option 3: Striped locking — N mutexes for N hash buckets (reduces contention 16x)
Option 4: Lock-free with CAS (Compare-And-Swap) — highest performance, complex
```

**For 10,000 concurrent requests**:
- Use **striped locking** (16-64 stripes) for the HashMap
- Separate lock for the LRU linked list (eviction is less frequent)
- Thread pool of 100-500 threads (not 10,000 — thread creation overhead)

**OS concepts applied**:

| OS Concept | Applied Here |
|-----------|-------------|
| Mutex / RWLock | Protect cache state (Chapter 4) |
| Thread Pool | Reuse threads, avoid creation cost (Chapter 3) |
| Memory management | Cache entries in heap (Chapter 6) |
| LRU algorithm | Same as LRU page replacement! (Chapter 6) |

---

### Design Q2: Design a Task Scheduler (like cron)

**Q: Design a system task scheduler that runs jobs at specified times.**

**Answer**:
```
Components:
1. Job Store: Database/file storing (job_id, schedule, command, last_run)
2. Scheduler Thread: Wakes up every minute, checks which jobs are due
3. Worker Thread Pool: Executes jobs (fork/exec each job as separate process)
4. Job Queue: Bounded blocking queue (Producer-Consumer) between scheduler and workers

Process model:
Scheduler process (main)
  │
  ├── Scheduler thread: check DB, enqueue due jobs
  ├── Worker thread 1: dequeue, fork(), exec("job1")
  ├── Worker thread 2: dequeue, fork(), exec("job2")
  └── Monitor thread: collect exit codes, log results

Key OS concepts:
• fork() + exec() for job execution (Chapter 2)
• Mutex + Semaphore for bounded queue (Chapter 4)
• Signals for job cancellation — SIGTERM/SIGKILL (Chapter 9)
• Cgroup limits per job (Chapter 9 — Linux)
• File locking to prevent duplicate scheduler instances
```

---

### Design Q3: How does a web server handle 1 million requests/second?

**Q: Explain the OS mechanisms that enable Nginx to handle 1M RPS.**

**Answer**:

| Mechanism | OS Concept | How it helps |
|-----------|-----------|-------------|
| **Epoll** | I/O multiplexing (event-driven) | 1 thread watches 100K sockets simultaneously |
| **Non-blocking I/O** | Async I/O (never blocks) | No idle threads waiting for network |
| **Sendfile syscall** | Zero-copy (mmap concept) | File → network without user-space copy |
| **Multi-process** | Fork N workers (1 per CPU core) | Utilize all CPU cores |
| **SO_REUSEPORT** | Multiple processes bind same port | Kernel load-balances connections |
| **CPU affinity** | Pin processes to cores | Avoid cache thrashing from CPU migration |
| **Huge pages** | 2 MB pages instead of 4 KB | Fewer TLB misses for large memory usage |
| **NUMA awareness** | Local memory allocation | 50% faster memory access on multi-socket |

**Real numbers** (Nginx on modern hardware):
- 4 worker processes × 25,000 connections = 100,000 concurrent connections
- Each worker uses ONE thread with epoll (event-driven, non-blocking)
- Memory: ~2.5 MB per 10,000 connections = 25 MB for 100K connections

---

### Design Q4: How does `fork()` work with a 1 GB process?

**Q: A process with 1 GB of heap data calls fork(). Does the OS copy 1 GB of memory?**

**Answer**: **No!** Thanks to **Copy-On-Write (COW)**:

```
Before fork():
Parent process:
  VP 1 → Physical Frame 100
  VP 2 → Physical Frame 200
  ... (262,144 pages for 1 GB)

After fork() — INSTANT (microseconds):
Parent:                           Child:
  VP 1 → Frame 100 (READ-ONLY)     VP 1 → Frame 100 (READ-ONLY)
  VP 2 → Frame 200 (READ-ONLY)     VP 2 → Frame 200 (READ-ONLY)
  Both point to SAME physical frames!

When child writes to VP 1:
→ Page fault (R/O violation)
→ OS allocates new Frame 300, copies Frame 100 data
→ Child: VP 1 → Frame 300 (R/W)
→ Parent: VP 1 → Frame 100 (R/W again)
```

**Actual fork() cost** for a 1 GB process:

| Metric | Value |
|--------|-------|
| Extra RAM immediately | ~4 MB (page tables copy only) |
| Time for fork() itself | 1-10 milliseconds |
| Pages actually copied | Only pages the child writes to |
| If child calls exec() immediately | Almost no overhead (exec discards everything) |

---

### Design Q5: How does `ps aux` work internally?

**Q: At the OS level, how does `ps aux` gather information about all running processes?**

**Answer**:
```
ps reads from /proc filesystem (virtual filesystem in memory):

Step 1: ps opens /proc directory
        → opendir("/proc") system call

Step 2: List entries — each numeric directory = a PID
        → readdir() finds: 1, 42, 1234, 5678, ...

Step 3: For each PID X, read:
        /proc/X/stat     → PID, state, PPID, priority, etc.
        /proc/X/status   → Memory (VmRSS, VmSize, VmSwap)
        /proc/X/cmdline  → Full command line (argv[])
        /proc/X/exe      → Symlink to executable path

Step 4: Format and print in columns (USER, PID, %CPU, %MEM, ...)
```

**Key /proc/X/stat fields** (reading directly shows this):

| Field | Meaning |
|-------|---------|
| 1 | PID |
| 3 | State: R=Running, S=Sleeping, D=I/O Wait, Z=Zombie, T=Stopped |
| 4 | PPID (parent PID) |
| 13 | User CPU time (clock ticks) |
| 14 | System CPU time (clock ticks) |
| 23 | Virtual memory size (bytes) |
| 24 | Resident Set Size (pages) |

**Why /proc is fast**: It's a **virtual filesystem** — data is generated on-the-fly from kernel data structures. No disk I/O required. `cat /proc/1234/status` completes in ~1 μs.

---

### Design Q6: Design OS components for a game engine

**Q: A real-time game needs: 60 FPS rendering, physics simulation, audio, network, and AI. Design the OS interaction strategy.**

**Answer**:

```
Thread Architecture:
┌────────────────────────────────────────────────────┐
│  Main Thread (Game Loop — 60 Hz, 16.67ms budget)   │
│  Priority: SCHED_FIFO (real-time, highest)          │
├────────────────────────────────────────────────────┤
│  Render Thread (GPU commands)                       │
│  Priority: SCHED_RR, nice=-5                        │
├────────────────────────────────────────────────────┤
│  Physics Thread (simulation)                        │
│  Priority: SCHED_RR, nice=-3                        │
├────────────────────────────────────────────────────┤
│  Audio Thread (must never stutter!)                 │
│  Priority: SCHED_FIFO, mlockall() (no page faults)  │
├────────────────────────────────────────────────────┤
│  Network Thread (non-blocking I/O, epoll)           │
│  Priority: Normal, nice=0                           │
├────────────────────────────────────────────────────┤
│  AI Worker Thread Pool (background, CPU-bound)      │
│  Priority: Background, nice=+10                     │
└────────────────────────────────────────────────────┘
```

**OS tuning for game performance**:

| Technique | Command | Effect |
|-----------|---------|--------|
| Lock memory (no swap) | `mlockall(MCL_CURRENT)` | Audio/physics threads never page fault |
| CPU isolation | `isolcpus=2,3` (kernel param) | Dedicate cores 2,3 to game, no OS interference |
| Huge pages | `mmap(...MAP_HUGETLB)` | Reduce TLB misses for large textures |
| Real-time priority | `sched_setscheduler(SCHED_FIFO)` | Game loop can't be preempted |
| CPU affinity | `pthread_setaffinity_np()` | Pin threads to specific cores |

---

### 📊 Complete Study Guide Navigation

| Chapter | Topic | Link |
|---------|-------|------|
| 01 | OS Introduction | [01_OS_Introduction.md](01_OS_Introduction.md) |
| 02 | Process Management | [02_Process_Management.md](02_Process_Management.md) |
| 03 | Threads & CPU Scheduling | [03_Threads_and_CPU.md](03_Threads_and_CPU.md) |
| 04 | Process Synchronization | [04_Process_Synchronization.md](04_Process_Synchronization.md) |
| 05 | Deadlocks | [05_Deadlocks.md](05_Deadlocks.md) |
| 06 | Memory Management | [06_Memory_Management.md](06_Memory_Management.md) |
| 07 | File System | [07_File_System.md](07_File_System.md) |
| 08 | Disk Scheduling | [08_Disk_Scheduling.md](08_Disk_Scheduling.md) |
| 09 | Linux Operations | [09_Linux_Operations.md](09_Linux_Operations.md) |
| 10 | Interview Preparation | [10_OS_Interview_Preparation.md](10_OS_Interview_Preparation.md) |

---

> **← [Previous: 09 - Linux Operations](09_Linux_Operations.md)**
> 
> **🎯 You've completed the entire OS + Linux guide! Good luck with your exams & interviews!**
