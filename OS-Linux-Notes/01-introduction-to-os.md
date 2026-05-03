# 01. Introduction to Operating Systems

## Table of Contents
- [1.1 What is an Operating System?](#11-what-is-an-operating-system)
- [1.2 Functions of an OS](#12-functions-of-an-os)
- [1.3 Types of Operating Systems](#13-types-of-operating-systems)
- [1.4 OS Architecture](#14-os-architecture)
- [1.5 System Calls](#15-system-calls)
- [1.6 Common Mistakes & Interview Tips](#16-common-mistakes--interview-tips)
- [1.7 Practice & Assessment](#17-practice--assessment)

---

## 1.1 What is an Operating System?

### Definition
An **Operating System (OS)** is system software that manages computer hardware and software resources and provides common services for computer programs. It acts as an **intermediary between the user and the hardware**.

### Simple Analogy

```
Think of an OS like a MANAGER in a restaurant:
  - The customer (user/application) orders food
  - The manager (OS) communicates with the kitchen (hardware)
  - The kitchen prepares food (processing)
  - The manager delivers the food back to the customer

Without the manager → chaos, no coordination
Without the OS → programs can't use hardware properly
```

### Where OS Fits

```
┌─────────────────────────────────────┐
│           USER                       │
├─────────────────────────────────────┤
│     APPLICATION PROGRAMS            │
│   (Browser, Editor, Games)          │
├─────────────────────────────────────┤
│      OPERATING SYSTEM               │
│  (Windows, Linux, macOS)            │
├─────────────────────────────────────┤
│         HARDWARE                    │
│  (CPU, RAM, Disk, I/O Devices)      │
└─────────────────────────────────────┘
```

### Goals of an OS
1. **Convenience** — Make computer easy to use
2. **Efficiency** — Use hardware resources optimally
3. **Ability to Evolve** — Allow updates without breaking existing software

---

## 1.2 Functions of an OS

| Function | What It Does | Example |
|----------|-------------|---------|
| **Process Management** | Create, schedule, terminate processes | Running multiple apps simultaneously |
| **Memory Management** | Allocate/deallocate RAM to processes | Ensuring Chrome doesn't overwrite Word's memory |
| **File System Management** | Organize files on disk | Creating folders, reading/writing files |
| **I/O Management** | Control input/output devices | Sending data to printer, reading from keyboard |
| **Security & Protection** | Control access to resources | Login passwords, file permissions |
| **Networking** | Manage network connections | Sending packets over internet |
| **User Interface** | Provide CLI or GUI | Terminal (CLI) or Desktop (GUI) |

### Process Management (Brief)

```
OS handles:
  → Creating new processes (loading programs)
  → Scheduling CPU time to each process
  → Synchronizing processes (avoiding conflicts)
  → Handling inter-process communication (IPC)
  → Terminating processes when done or crashed
```

### Memory Management (Brief)

```
OS handles:
  → Tracking which parts of memory are used and by whom
  → Allocating memory to new processes
  → Deallocating memory when processes end
  → Implementing virtual memory (using disk as extension of RAM)
```

---

## 1.3 Types of Operating Systems

### Comparison Table

| Type | Description | Example | Key Feature |
|------|-------------|---------|-------------|
| **Batch OS** | Jobs collected in batches, no user interaction during execution | Early IBM mainframes | No direct user interaction |
| **Time-Sharing (Multitasking)** | CPU time shared among multiple users/tasks | Unix, Linux, Windows | Quick context switching |
| **Real-Time OS (RTOS)** | Strict time deadlines guaranteed | Aircraft systems, medical devices | Deterministic response time |
| **Distributed OS** | Multiple computers appear as single system | Google's infrastructure | Resource sharing across machines |
| **Network OS** | Manages network resources | Windows Server, Novell | File/print sharing |
| **Mobile OS** | Designed for mobile devices | Android, iOS | Touch input, power efficiency |
| **Embedded OS** | Built into specific hardware | Router firmware, smart TVs | Minimal footprint |

### Batch Operating System

```
How it works:
  User ──► Submit Job (on punch card/tape)
       ──► Operator batches similar jobs
       ──► OS executes batch without interruption
       ──► Output returned to user later

Advantages:
  ✓ Good for large repetitive tasks
  ✓ Less idle CPU time

Disadvantages:
  ✗ No user interaction during execution
  ✗ If one job fails, entire batch may be affected
  ✗ Long waiting time
```

### Time-Sharing OS

```
How it works:
  Multiple users connected simultaneously
  CPU rapidly switches between users (time slices)
  Each user feels like they have the whole computer

Example: 10 users on a Linux server
  → Each gets ~100ms of CPU time
  → Switching is so fast, appears simultaneous

Advantages:
  ✓ Interactive — users get immediate response
  ✓ Efficient CPU utilization

Disadvantages:
  ✗ Complex scheduling needed
  ✗ Security concerns (multiple users)
```

### Real-Time OS (RTOS)

```
Two types:
  Hard Real-Time: Missing deadline = system failure
    Example: Aircraft autopilot — must respond in microseconds
    
  Soft Real-Time: Missing deadline = degraded quality (not failure)
    Example: Video streaming — dropped frame is tolerable
```

---

## 1.4 OS Architecture

### Monolithic Kernel

```
┌─────────────────────────────────────┐
│           USER SPACE                 │
│    (Applications, Shell)            │
├─────────────────────────────────────┤
│          KERNEL SPACE                │
│  ┌─────────────────────────────┐    │
│  │ File System │ Scheduler     │    │
│  │ Memory Mgr  │ Device Drivers│    │
│  │ Networking  │ IPC           │    │
│  │ ALL in ONE big kernel       │    │
│  └─────────────────────────────┘    │
├─────────────────────────────────────┤
│          HARDWARE                    │
└─────────────────────────────────────┘

Example: Linux, Unix
Pros: Fast (everything in kernel space)
Cons: One bug can crash entire OS
```

### Microkernel

```
┌─────────────────────────────────────┐
│           USER SPACE                 │
│  ┌──────┐ ┌──────┐ ┌──────────┐   │
│  │File  │ │Device│ │Networking │   │
│  │Server│ │Driver│ │Server     │   │
│  └──────┘ └──────┘ └──────────┘   │
├─────────────────────────────────────┤
│         MICROKERNEL                  │
│   (Only: IPC, basic scheduling,     │
│    memory management)               │
├─────────────────────────────────────┤
│          HARDWARE                    │
└─────────────────────────────────────┘

Example: Minix, QNX
Pros: Stable (crash in one module doesn't kill OS)
Cons: Slower (communication between user-space services)
```

### Comparison

| Feature | Monolithic | Microkernel | Hybrid |
|---------|-----------|-------------|--------|
| Speed | Fast | Slower | Medium |
| Stability | Less stable | More stable | Medium |
| Size | Large kernel | Small kernel | Medium |
| Example | Linux | Minix, QNX | Windows NT, macOS |

---

## 1.5 System Calls

### Definition
A **system call** is the interface between a user program and the OS kernel. Programs use system calls to request services from the OS.

### How System Calls Work

```
User Program                    Kernel
     │                            │
     │──── open("file.txt") ─────►│  ← System Call
     │                            │  (switches to kernel mode)
     │                            │  (kernel opens file)
     │◄─── returns file descriptor│  ← Result
     │                            │  (switches back to user mode)
```

### Types of System Calls

| Category | System Calls | Purpose |
|----------|-------------|---------|
| **Process Control** | fork(), exec(), wait(), exit() | Create/manage processes |
| **File Management** | open(), read(), write(), close() | File operations |
| **Device Management** | ioctl(), read(), write() | Device I/O |
| **Information** | getpid(), alarm(), sleep() | Get system info |
| **Communication** | pipe(), shmget(), socket() | Inter-process communication |

### Example: fork() System Call

```c
#include <stdio.h>
#include <unistd.h>

int main() {
    int pid = fork();    // Creates a child process
    
    if (pid == 0) {
        printf("I am the child process (PID: %d)\n", getpid());
    } else {
        printf("I am the parent process (PID: %d)\n", getpid());
    }
    return 0;
}
```

**Output:**
```
I am the parent process (PID: 1234)
I am the child process (PID: 1235)
```

---

## 1.6 Common Mistakes & Interview Tips

### Common Mistakes

| Mistake | Correction |
|---------|-----------|
| "OS is just the GUI" | OS includes kernel, not just interface |
| Confusing kernel mode vs user mode | Kernel mode has full hardware access; user mode is restricted |
| "Linux is an OS" | Technically Linux is a kernel; Ubuntu/Fedora are OS distributions |
| Thinking all OS are time-sharing | Real-time and batch OS have different designs |

### Interview Tips

**Q: What is the difference between kernel mode and user mode?**
> Kernel mode has unrestricted access to hardware. User mode is restricted — programs must use system calls to access hardware. This separation protects the system from faulty programs.

**Q: What is a system call?**
> It's the programmatic way an application requests a service from the OS kernel. Example: `open()` to open a file, `fork()` to create a process.

**Q: Name the main functions of an OS.**
> Process management, memory management, file system management, I/O management, security/protection, and providing a user interface.

---

## 1.7 Practice & Assessment

### MCQs

**Q1.** The primary purpose of an operating system is:
- A) To make computers look nice
- B) To manage hardware and provide services to programs
- C) To connect to the internet
- D) To compile programs

**Answer:** B

---

**Q2.** Which OS type guarantees response within a strict time deadline?
- A) Batch OS
- B) Time-sharing OS
- C) Real-time OS
- D) Distributed OS

**Answer:** C

---

**Q3.** In a monolithic kernel, services run in:
- A) User space only
- B) Kernel space
- C) A separate server
- D) Cloud

**Answer:** B

---

**Q4.** fork() is an example of a:
- A) File management system call
- B) Process control system call
- C) Device management call
- D) User interface function

**Answer:** B

---

### Short Answer

**Q1.** Draw and label the layers from hardware to user (4 layers).
> Hardware → Operating System → Application Programs → User

**Q2.** Give two advantages of a microkernel over a monolithic kernel.
> 1. Better stability (crash in one service doesn't crash OS). 2. Easier to extend (add new services without modifying kernel).

---

> **Next Topic:** [02 - Processes and Threads](02-processes-and-threads.md)
