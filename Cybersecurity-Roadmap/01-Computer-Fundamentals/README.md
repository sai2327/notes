# 🖥️ Computer Fundamentals

## Understanding How Computers Work — The Foundation of All Cybersecurity

---

## 📌 Table of Contents

1. [Introduction](#introduction)
2. [Why This Matters for Cybersecurity](#why-this-matters-for-cybersecurity)
3. [How Computers Work — The Big Picture](#how-computers-work--the-big-picture)
4. [CPU — The Brain](#cpu--the-brain)
5. [RAM — Short-Term Memory](#ram--short-term-memory)
6. [Storage — Long-Term Memory](#storage--long-term-memory)
7. [Motherboard — The Nervous System](#motherboard--the-nervous-system)
8. [Operating Systems](#operating-systems)
9. [The Boot Process](#the-boot-process)
10. [Processes and Threads](#processes-and-threads)
11. [Memory Management](#memory-management)
12. [File Systems](#file-systems)
13. [System Calls](#system-calls)
14. [Virtualization](#virtualization)
15. [Binary and Number Systems](#binary-and-number-systems)
16. [Exercises](#exercises)
17. [Labs](#labs)
18. [Interview Questions](#interview-questions)
19. [Summary](#summary)

---

## Introduction

Before you can hack a computer, you must understand how one works. Before you can defend a system, you must know what the system does. This section teaches you everything about computer architecture from the ground up.

Think of it this way: A locksmith who doesn't understand how locks work mechanically can never truly master lock picking. Similarly, a cybersecurity professional who doesn't understand computer fundamentals will always be limited.

---

## Why This Matters for Cybersecurity

| Concept | Security Relevance |
|---------|-------------------|
| CPU Architecture | Buffer overflows, shellcode, exploit development |
| RAM/Memory | Memory forensics, heap exploitation, stack attacks |
| Storage | Disk forensics, data recovery, secure deletion |
| OS Internals | Privilege escalation, rootkits, malware analysis |
| Boot Process | Bootkits, secure boot bypass, firmware attacks |
| Processes | Process injection, hollowing, DLL hijacking |
| File Systems | File recovery, hidden data, timestamps |
| Virtualization | VM escape exploits, sandbox evasion |

**Every advanced attack targets one or more of these fundamentals.**

---

## How Computers Work — The Big Picture

### The Simple Analogy

Think of a computer like a kitchen:

```
┌─────────────────────────────────────────────────────────────┐
│                        COMPUTER                              │
│                                                             │
│   CPU = The Chef                                            │
│   ├── Follows recipes (instructions)                        │
│   ├── Works very fast                                       │
│   └── Can only do one thing at a time per core              │
│                                                             │
│   RAM = The Counter Space                                   │
│   ├── Where active work happens                             │
│   ├── Limited space                                         │
│   └── Gets cleared when you close the kitchen               │
│                                                             │
│   Storage (HDD/SSD) = The Pantry                            │
│   ├── Stores everything long-term                           │
│   ├── Lots of space                                         │
│   └── Slower to access than the counter                     │
│                                                             │
│   Motherboard = The Kitchen Floor Plan                      │
│   ├── Connects everything                                   │
│   └── Allows components to communicate                      │
│                                                             │
│   OS = The Restaurant Manager                               │
│   ├── Decides who uses what                                 │
│   ├── Manages resources                                     │
│   └── Handles customer (user) requests                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### The Technical View

```
┌────────────────────────────────────────────────────────────────┐
│                    APPLICATION LAYER                             │
│         (Web browsers, Word processors, Games)                  │
├────────────────────────────────────────────────────────────────┤
│                    OPERATING SYSTEM                              │
│         (Windows, Linux, macOS)                                  │
│    ┌──────────────────────────────────────────────┐             │
│    │           KERNEL                              │             │
│    │  ┌──────────┬──────────┬──────────────────┐  │             │
│    │  │ Process  │ Memory   │ File System      │  │             │
│    │  │ Manager  │ Manager  │ Manager          │  │             │
│    │  └──────────┴──────────┴──────────────────┘  │             │
│    │  ┌──────────┬──────────┬──────────────────┐  │             │
│    │  │ Device   │ Network  │ Security         │  │             │
│    │  │ Drivers  │ Stack    │ Module           │  │             │
│    │  └──────────┴──────────┴──────────────────┘  │             │
│    └──────────────────────────────────────────────┘             │
├────────────────────────────────────────────────────────────────┤
│                    HARDWARE                                      │
│    ┌──────┐  ┌──────┐  ┌──────────┐  ┌──────────┐             │
│    │ CPU  │  │ RAM  │  │ Storage  │  │ Network  │             │
│    │      │  │      │  │ (SSD/HDD)│  │ Card     │             │
│    └──────┘  └──────┘  └──────────┘  └──────────┘             │
└────────────────────────────────────────────────────────────────┘
```

---

## CPU — The Brain

### What is a CPU?

The **Central Processing Unit (CPU)** is the component that executes instructions. Every program you run, every command you type, every calculation — it all happens in the CPU.

### How a CPU Works

The CPU operates on a simple cycle called the **Fetch-Decode-Execute** cycle:

```
┌─────────────────────────────────────────────┐
│                                             │
│    ┌─────────┐                              │
│    │  FETCH  │ ← Get instruction from RAM   │
│    └────┬────┘                              │
│         │                                   │
│         ▼                                   │
│    ┌─────────┐                              │
│    │ DECODE  │ ← Understand the instruction │
│    └────┬────┘                              │
│         │                                   │
│         ▼                                   │
│    ┌─────────┐                              │
│    │ EXECUTE │ ← Perform the operation      │
│    └────┬────┘                              │
│         │                                   │
│         └──────── (Repeat billions/sec) ──→ │
│                                             │
└─────────────────────────────────────────────┘
```

### CPU Components

| Component | Function | Analogy |
|-----------|----------|---------|
| **ALU** (Arithmetic Logic Unit) | Math and logic operations | Calculator |
| **Control Unit** | Directs operations, manages timing | Orchestra conductor |
| **Registers** | Ultra-fast tiny storage | Sticky notes on your desk |
| **Cache** (L1, L2, L3) | Fast memory close to CPU | Drawer next to your desk |
| **Clock** | Synchronizes operations | Metronome |

### CPU Architecture — x86 vs x64 vs ARM

| Architecture | Description | Common Use | Security Note |
|-------------|-------------|------------|---------------|
| **x86** | 32-bit Intel/AMD | Older PCs | Legacy exploits |
| **x64** (AMD64) | 64-bit Intel/AMD | Modern PCs/Servers | Current exploit dev |
| **ARM** | Energy-efficient | Phones, M1/M2 Macs | IoT hacking |
| **RISC-V** | Open-source design | Embedded systems | Emerging target |

### Registers (Critical for Exploitation)

Registers are the CPU's built-in storage — incredibly fast but very small.

**x86 (32-bit) General Purpose Registers:**

| Register | Name | Common Use |
|----------|------|------------|
| EAX | Accumulator | Return values, math |
| EBX | Base | Memory addressing |
| ECX | Counter | Loop counting |
| EDX | Data | I/O operations |
| ESP | Stack Pointer | Top of stack |
| EBP | Base Pointer | Stack frame base |
| ESI | Source Index | String operations |
| EDI | Destination Index | String operations |
| EIP | Instruction Pointer | **Next instruction to execute** |

> **🔴 Security Critical:** The EIP/RIP register tells the CPU what to execute next. If an attacker can overwrite this register (via buffer overflow), they control program execution. This is the basis of most memory corruption exploits.

**x64 (64-bit) equivalents:** RAX, RBX, RCX, RDX, RSP, RBP, RSI, RDI, RIP + R8-R15

### CPU Modes

| Mode | Privilege Level | What Can Run | Also Called |
|------|----------------|--------------|-------------|
| Ring 0 | Highest | Kernel, drivers | Kernel Mode |
| Ring 1 | High | (Rarely used) | — |
| Ring 2 | Medium | (Rarely used) | — |
| Ring 3 | Lowest | Applications | User Mode |

```
┌─────────────────────────────────────┐
│         Ring 3 (User Mode)          │
│    Applications, Games, Browsers    │
│  ┌─────────────────────────────┐    │
│  │     Ring 2 (Unused)         │    │
│  │  ┌─────────────────────┐   │    │
│  │  │   Ring 1 (Unused)   │   │    │
│  │  │  ┌─────────────┐    │   │    │
│  │  │  │   Ring 0     │    │   │    │
│  │  │  │   KERNEL     │    │   │    │
│  │  │  └─────────────┘    │   │    │
│  │  └─────────────────────┘   │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

> **🔴 Security Relevance:** Privilege escalation attacks aim to move from Ring 3 (user) to Ring 0 (kernel). Kernel exploits grant complete system control.

---

## RAM — Short-Term Memory

### What is RAM?

**Random Access Memory (RAM)** is volatile memory where the CPU stores data it's actively using. "Volatile" means it loses everything when power is cut.

### Why RAM Matters for Security

| Attack | How RAM is Involved |
|--------|-------------------|
| Buffer Overflow | Overwriting adjacent memory in RAM |
| Memory Forensics | Extracting passwords/keys from RAM |
| Process Injection | Writing malicious code into another process's RAM |
| Cold Boot Attack | Physically extracting RAM contents |
| Heap Spray | Filling RAM with malicious data |

### Memory Layout of a Process

When a program runs, the OS gives it a memory space organized like this:

```
High Memory Address
┌─────────────────────────────────┐
│           STACK                  │ ← Local variables, function calls
│           ↓ (grows down)        │    Return addresses
├─────────────────────────────────┤
│                                 │
│         (free space)            │
│                                 │
├─────────────────────────────────┤
│           ↑ (grows up)          │
│           HEAP                  │ ← Dynamically allocated memory
├─────────────────────────────────┤
│           BSS                   │ ← Uninitialized global variables
├─────────────────────────────────┤
│           DATA                  │ ← Initialized global variables
├─────────────────────────────────┤
│           TEXT (Code)           │ ← Program instructions
└─────────────────────────────────┘
Low Memory Address
```

> **🔴 Critical Security Concept:** The STACK stores return addresses. A buffer overflow can overwrite these return addresses, redirecting execution to attacker-controlled code. This is the classic stack-based buffer overflow attack.

### Memory Hierarchy

```
Speed:     Fastest ──────────────────────────── Slowest
Cost:      Most Expensive ───────────────── Cheapest
Size:      Smallest ─────────────────────── Largest

┌──────────┐
│ Registers│ ← Bytes (inside CPU)
├──────────┤
│ L1 Cache │ ← KB (on CPU die)
├──────────┤
│ L2 Cache │ ← KB-MB
├──────────┤
│ L3 Cache │ ← MB
├──────────┤
│   RAM    │ ← GB
├──────────┤
│ SSD/HDD  │ ← TB
├──────────┤
│ Network  │ ← Unlimited (Cloud)
└──────────┘
```

---

## Storage — Long-Term Memory

### Types of Storage

| Type | Speed | Mechanism | Security Note |
|------|-------|-----------|---------------|
| HDD (Hard Disk Drive) | Slow | Spinning magnetic disks | Data recovery possible after deletion |
| SSD (Solid State Drive) | Fast | Flash memory chips | TRIM makes recovery harder |
| NVMe | Very Fast | Direct PCIe connection | Same as SSD |
| USB/External | Varies | Various | Common malware vector |

### How Data Deletion Works (Critical for Forensics)

```
When you "delete" a file:
┌────────────────────────────────────────┐
│                                        │
│  File: secret.txt                      │
│  Content: "Password is hunter2"        │
│                                        │
│  After "Delete":                       │
│  ├── File entry removed from index     │
│  ├── Data STILL EXISTS on disk         │
│  ├── Space marked as "available"       │
│  └── Recoverable until overwritten!    │
│                                        │
│  After Secure Delete (overwrite):      │
│  ├── Data overwritten with random      │
│  ├── Multiple passes for HDD           │
│  └── Much harder to recover            │
│                                        │
└────────────────────────────────────────┘
```

> **🔴 Forensics Insight:** "Deleted" files are often recoverable. This is why disk forensics can reveal evidence that suspects thought was destroyed. Tools like `Autopsy`, `FTK`, and `photorec` can recover "deleted" data.

---

## Motherboard — The Nervous System

The motherboard connects all components and allows them to communicate.

### Key Components

| Component | Function | Security Relevance |
|-----------|----------|-------------------|
| BIOS/UEFI Chip | Firmware, boots the system | BIOS rootkits, firmware attacks |
| Northbridge/Southbridge | Component communication | DMA attacks |
| PCI/PCIe Slots | Expansion cards | DMA attacks via malicious hardware |
| USB Headers | External connections | BadUSB attacks |
| TPM Chip | Hardware security | Secure Boot, BitLocker |
| Network Interface | Network connectivity | Hardware implants |

---

## Operating Systems

### What is an Operating System?

An **Operating System (OS)** is software that manages hardware resources and provides services to applications. It's the bridge between you and the machine.

### Kernel vs User Space

```
┌─────────────────────────────────────────────────┐
│                USER SPACE                         │
│                                                  │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐       │
│  │Chrome│  │Python│  │ Word │  │ Game │       │
│  └──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘       │
│     │         │         │         │             │
├─────┼─────────┼─────────┼─────────┼─────────────┤
│     │     SYSTEM CALL INTERFACE   │             │
├─────┼─────────┼─────────┼─────────┼─────────────┤
│     ▼         ▼         ▼         ▼             │
│                KERNEL SPACE                       │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │  Process Management                       │   │
│  │  Memory Management                        │   │
│  │  File System Management                   │   │
│  │  Device Drivers                           │   │
│  │  Network Stack                            │   │
│  │  Security (SELinux, AppArmor)             │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
├──────────────────────────────────────────────────┤
│                 HARDWARE                          │
└──────────────────────────────────────────────────┘
```

### Linux vs Windows Comparison

| Feature | Linux | Windows |
|---------|-------|---------|
| Kernel | Monolithic (Linux kernel) | Hybrid (NT kernel) |
| Source | Open source | Proprietary |
| File System | ext4, XFS, Btrfs | NTFS, FAT32 |
| Package Management | apt, yum, pacman | MSI, exe, Windows Store |
| Shell | Bash, Zsh | cmd, PowerShell |
| Privilege Model | root / sudo | Administrator / UAC |
| Security Model | DAC + MAC (SELinux) | DAC + Integrity Levels |
| Usage in Security | Primary offensive tool | Primary target |
| Server Market | ~80% | ~20% |
| Desktop Market | ~3% | ~75% |
| Cost | Free | Licensed |

### Common Operating Systems in Cybersecurity

| OS | Role in Security |
|----|-----------------|
| Kali Linux | Penetration testing |
| Parrot Security | Alternative to Kali |
| Ubuntu/Debian | Server administration |
| Windows 10/11 | Target environment |
| Windows Server | Active Directory labs |
| macOS | Endpoint security |
| REMnux | Malware analysis |
| SIFT | Digital forensics |
| Security Onion | Network security monitoring |

---

## The Boot Process

Understanding the boot process is essential for understanding bootkits, rootkits, and secure boot mechanisms.

### BIOS Boot Process (Legacy)

```
Power On
    │
    ▼
┌─────────────────┐
│   POST          │ ← Power-On Self Test (check hardware)
│   (BIOS)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   MBR           │ ← Master Boot Record (first 512 bytes of disk)
│   (Bootloader)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Boot Loader   │ ← GRUB (Linux) or Windows Boot Manager
│   Stage 2       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Kernel Load   │ ← OS kernel loaded into memory
│                 │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Init System   │ ← systemd (Linux) or Session Manager (Windows)
│                 │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   User Login    │ ← You see the login screen
│                 │
└─────────────────┘
```

### UEFI Boot Process (Modern)

```
Power On
    │
    ▼
┌─────────────────┐
│   UEFI          │ ← Unified Extensible Firmware Interface
│   Firmware      │   (Replaces BIOS)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Secure Boot   │ ← Verify digital signatures of boot components
│   Verification  │   (Prevents unsigned code from booting)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   EFI Boot      │ ← Boot from EFI System Partition (ESP)
│   Manager       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   OS Loader     │ ← Load operating system
│                 │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Kernel +      │ ← Full OS initialization
│   Services      │
└─────────────────┘
```

> **🔴 Security Attacks on Boot Process:**
> - **Bootkit:** Malware that infects the MBR/VBR, loads before the OS
> - **UEFI Rootkit:** Malware in UEFI firmware, survives OS reinstall
> - **Evil Maid Attack:** Physical access to modify boot process
> - **Secure Boot Bypass:** Exploiting vulnerabilities in UEFI implementation

---

## Processes and Threads

### What is a Process?

A **process** is a running program. When you open Chrome, that's a process. When you run a Python script, that's a process. Every process has:
- Its own memory space
- A Process ID (PID)
- A parent process
- Open files and network connections
- Security context (who owns it)

### What is a Thread?

A **thread** is a unit of execution within a process. A process can have multiple threads that share the same memory space.

```
┌─────────────────────────────────────────┐
│            PROCESS (Chrome)              │
│                                         │
│  PID: 1234                              │
│  User: john                             │
│  Memory: 500MB                          │
│                                         │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐  │
│  │ Thread 1│ │ Thread 2│ │ Thread 3│  │
│  │ (UI)    │ │ (Network│ │ (Render)│  │
│  │         │ │  reqs)  │ │         │  │
│  └─────────┘ └─────────┘ └─────────┘  │
│                                         │
│  Shared Memory Space                    │
│  Shared File Descriptors                │
│  Shared Network Connections             │
│                                         │
└─────────────────────────────────────────┘
```

### Process States

```
┌──────────┐    Schedule    ┌──────────┐
│          │ ─────────────→ │          │
│   READY  │                │ RUNNING  │
│          │ ←───────────── │          │
└────┬─────┘   Preempt     └─────┬────┘
     │                            │
     │                            │ Wait for I/O
     │                            │ or resource
     │                            ▼
     │                     ┌──────────┐
     │ I/O Complete        │          │
     └──────────────────── │ WAITING  │
                           │(Blocked) │
                           └──────────┘

New → Ready → Running → Terminated
                 ↕
              Waiting
```

### Security Relevance of Processes

| Attack Technique | Description |
|-----------------|-------------|
| **Process Injection** | Injecting code into another process's memory |
| **Process Hollowing** | Replacing a legitimate process's code with malware |
| **DLL Injection** | Loading malicious DLLs into a process |
| **Process Migration** | Meterpreter moving to a stable process |
| **Fork Bomb** | Creating infinite processes to crash the system |

---

## Memory Management

### Virtual Memory

Every process thinks it has access to all memory (e.g., full 4GB on 32-bit). In reality, the OS maps virtual addresses to physical RAM addresses.

```
Process A                    Physical RAM          Process B
┌──────────┐                ┌──────────┐          ┌──────────┐
│ 0x0000   │──────────┐    │ Frame 0  │    ┌─────│ 0x0000   │
│ 0x1000   │─────┐    └───→│ Frame 1  │    │     │ 0x1000   │
│ 0x2000   │──┐  └────────→│ Frame 2  │←───┘     │ 0x2000   │
│ ...      │  └───────────→│ Frame 3  │←─────────│ ...      │
└──────────┘               │ Frame 4  │          └──────────┘
                           │ ...      │
                           └──────────┘

Each process has its own virtual address space.
The OS's Memory Management Unit (MMU) translates virtual → physical.
```

### Paging

Memory is divided into fixed-size blocks called **pages** (typically 4KB). This allows:
- Efficient memory use
- Memory protection between processes
- Swapping to disk when RAM is full

### Security Concepts in Memory

| Concept | Description | Attack/Defense |
|---------|-------------|----------------|
| **ASLR** | Address Space Layout Randomization | Defense: randomizes memory addresses |
| **DEP/NX** | Data Execution Prevention | Defense: prevents executing data as code |
| **Stack Canaries** | Random values before return address | Defense: detects stack overflow |
| **KASLR** | Kernel ASLR | Defense: randomizes kernel addresses |
| **Heap Spray** | Fill heap with attacker data | Attack: increase exploit reliability |

---

## File Systems

### What is a File System?

A file system organizes how data is stored on and retrieved from storage devices. It's like a library's catalog system — without it, you'd never find your books.

### Common File Systems

| File System | OS | Max File Size | Features | Security Note |
|-------------|-------|---------------|----------|---------------|
| **ext4** | Linux | 16 TB | Journaling, fast | Permissions, ACLs |
| **NTFS** | Windows | 16 EB | Journaling, ADS | Alternate Data Streams hide data |
| **FAT32** | Universal | 4 GB | Simple, compatible | No permissions! |
| **APFS** | macOS | 8 EB | Encryption, snapshots | Full disk encryption |
| **XFS** | Linux | 8 EB | High performance | Large servers |
| **Btrfs** | Linux | 16 EB | Snapshots, compression | Modern alternative |

### Linux File System Hierarchy

```
/                       ← Root directory (everything starts here)
├── bin/                ← Essential user binaries (ls, cp, cat)
├── boot/               ← Boot loader files (kernel, grub)
├── dev/                ← Device files (hardware as files)
├── etc/                ← Configuration files (system-wide)
├── home/               ← User home directories
│   ├── alice/
│   └── bob/
├── lib/                ← Shared libraries
├── media/              ← Removable media mount points
├── mnt/                ← Temporary mount points
├── opt/                ← Optional software
├── proc/               ← Virtual filesystem (process info)
├── root/               ← Root user's home directory
├── run/                ← Runtime data
├── sbin/               ← System binaries (admin commands)
├── srv/                ← Service data
├── sys/                ← Virtual filesystem (hardware info)
├── tmp/                ← Temporary files (cleared on reboot)
├── usr/                ← User programs and data
│   ├── bin/            ← User binaries
│   ├── lib/            ← Libraries
│   ├── local/          ← Locally installed software
│   └── share/          ← Shared data
└── var/                ← Variable data (logs, databases)
    ├── log/            ← System logs
    ├── www/            ← Web server files
    └── tmp/            ← Temporary files (persistent)
```

### NTFS Special Features (Windows)

**Alternate Data Streams (ADS):**
```cmd
:: Hide data in an alternate data stream
echo "secret data" > normal.txt:hidden.txt

:: The file appears normal but contains hidden data
:: This is used by malware to hide payloads!

:: View ADS
dir /r normal.txt
```

> **🔴 Security Note:** Malware often uses NTFS Alternate Data Streams to hide malicious code alongside innocent files. Forensic tools can detect these hidden streams.

---

## System Calls

### What are System Calls?

System calls (syscalls) are the interface between user programs and the kernel. When a program needs to:
- Read a file
- Send network data
- Create a process
- Allocate memory

...it must ask the kernel via a system call.

```
┌──────────────────────────────────────────────┐
│  User Program                                │
│  printf("Hello");  →  write() syscall        │
└───────────────────────────┬──────────────────┘
                            │ System Call
                            │ (trap/interrupt)
┌───────────────────────────▼──────────────────┐
│  Kernel                                      │
│  Actually writes to screen/file              │
└──────────────────────────────────────────────┘
```

### Common Linux System Calls

| Syscall | Purpose | Security Relevance |
|---------|---------|-------------------|
| `open()` | Open a file | File access monitoring |
| `read()` | Read from file/socket | Data exfiltration |
| `write()` | Write to file/socket | Malware writing payload |
| `execve()` | Execute a program | Shellcode execution |
| `fork()` | Create new process | Process creation monitoring |
| `connect()` | Network connection | C2 communication |
| `mmap()` | Map memory | Shellcode loading |
| `ptrace()` | Debug a process | Anti-debugging, injection |

> **🔴 Security Tools:** Tools like `strace` (Linux) and API Monitor (Windows) can monitor system calls to analyze program behavior — essential for malware analysis.

---

## Virtualization

### What is Virtualization?

Virtualization creates virtual versions of hardware, allowing multiple operating systems to run on one physical machine.

```
┌────────────────────────────────────────────────┐
│              Physical Hardware                   │
├────────────────────────────────────────────────┤
│              Hypervisor                          │
│   (VMware, VirtualBox, Hyper-V, KVM)           │
├─────────┬──────────┬──────────┬────────────────┤
│  VM 1   │   VM 2   │   VM 3   │    VM 4       │
│ (Kali)  │(Windows) │ (Ubuntu) │  (Malware     │
│         │          │          │   Analysis)    │
└─────────┴──────────┴──────────┴────────────────┘
```

### Types of Hypervisors

| Type | Description | Examples | Use Case |
|------|-------------|----------|----------|
| **Type 1** (Bare Metal) | Runs directly on hardware | VMware ESXi, Hyper-V, Xen | Servers, cloud |
| **Type 2** (Hosted) | Runs on top of an OS | VirtualBox, VMware Workstation | Development, labs |

### Why Virtualization Matters for Security

| Use Case | Description |
|----------|-------------|
| **Safe Lab Environment** | Test exploits without affecting real systems |
| **Malware Analysis** | Run malware in isolated VMs |
| **Snapshots** | Save/restore VM state instantly |
| **Network Isolation** | Create isolated virtual networks |
| **Multiple OS** | Run Kali + Windows + targets simultaneously |

### Security Attacks on Virtualization

| Attack | Description |
|--------|-------------|
| **VM Escape** | Breaking out of a VM to the host system |
| **Side-Channel** | Extracting data from other VMs on same host |
| **Hypervisor Attack** | Exploiting the hypervisor itself |
| **Blue Pill** | Installing a rogue hypervisor beneath the OS |

---

## Binary and Number Systems

### Why This Matters

Computers think in binary (0s and 1s). Understanding number systems is critical for:
- Reading memory addresses
- Understanding exploits
- Analyzing network packets
- Reverse engineering

### Number Systems

| System | Base | Digits | Example | Use in Security |
|--------|------|--------|---------|-----------------|
| Binary | 2 | 0, 1 | 1010 | Raw data, flags |
| Octal | 8 | 0-7 | 12 | Linux permissions |
| Decimal | 10 | 0-9 | 10 | Human-readable |
| Hexadecimal | 16 | 0-9, A-F | 0xA | Memory addresses, hashes |

### Conversions

```
Decimal 10:
  Binary:      1010
  Octal:       12
  Hexadecimal: A (or 0x0A)

Decimal 255:
  Binary:      11111111
  Octal:       377
  Hexadecimal: FF (or 0xFF)

Decimal 192 (first octet of 192.168.1.1):
  Binary:      11000000
  Hexadecimal: C0
```

### ASCII and Character Encoding

| Char | Decimal | Hex | Binary |
|------|---------|-----|--------|
| A | 65 | 0x41 | 01000001 |
| a | 97 | 0x61 | 01100001 |
| 0 | 48 | 0x30 | 00110000 |
| Space | 32 | 0x20 | 00100000 |
| \n | 10 | 0x0A | 00001010 |

> **🔴 Security Use:** Shellcode is written in hex. Memory addresses are in hex. Understanding hex is non-negotiable for exploit development and reverse engineering.

---

## Exercises

### Exercise 1: System Exploration (Linux)
```bash
# View CPU information
cat /proc/cpuinfo
lscpu

# View memory information
free -h
cat /proc/meminfo

# View storage information
lsblk
df -h

# View running processes
ps aux
top

# View system information
uname -a
hostnamectl
```

### Exercise 2: Process Investigation
```bash
# List all processes
ps aux

# Find a specific process
ps aux | grep firefox

# View process tree
pstree

# View process memory map
cat /proc/[PID]/maps

# View process file descriptors
ls -la /proc/[PID]/fd/
```

### Exercise 3: Number Conversion Practice

Convert these yourself (then verify):

| Convert | From | To | Your Answer |
|---------|------|----|-------------|
| 192 | Decimal | Binary | _________ |
| 10101010 | Binary | Decimal | _________ |
| 0xFF | Hex | Decimal | _________ |
| 127 | Decimal | Hex | _________ |
| 777 | Octal | Decimal | _________ |

### Exercise 4: Boot Process Documentation
1. Reboot your VM
2. Enter BIOS/UEFI (press F2/DEL during boot)
3. Document all settings you see
4. Identify: boot order, secure boot status, virtualization settings
5. Exit without changes

---

## Labs

### Lab 1: Virtual Machine Setup
**Objective:** Install VirtualBox and create your first VM

1. Download VirtualBox from virtualbox.org
2. Download Ubuntu ISO
3. Create a new VM (2GB RAM, 20GB disk)
4. Install Ubuntu
5. Take a snapshot
6. Explore the system

### Lab 2: Memory and Process Exploration
**Objective:** Understand how processes use memory

```bash
# Write a simple C program
cat << 'EOF' > memory_demo.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int global_var = 42;          // DATA segment
int uninit_var;               // BSS segment
const char *str = "Hello";   // TEXT/RODATA

int main() {
    int stack_var = 100;     // STACK
    char *heap_var = malloc(50);  // HEAP
    strcpy(heap_var, "Heap data");
    
    printf("PID: %d\n", getpid());
    printf("Stack variable at: %p\n", &stack_var);
    printf("Heap variable at:  %p\n", heap_var);
    printf("Global variable at: %p\n", &global_var);
    printf("Function (text) at: %p\n", &main);
    
    printf("\nPress Enter to exit...\n");
    getchar();
    
    free(heap_var);
    return 0;
}
EOF

# Compile and run
gcc memory_demo.c -o memory_demo
./memory_demo

# In another terminal, examine the process:
# cat /proc/[PID]/maps
```

### Lab 3: File System Analysis
**Objective:** Understand file system artifacts

```bash
# Create a test file
echo "This is sensitive data" > secret.txt

# Check file metadata
stat secret.txt

# "Delete" the file
rm secret.txt

# The data may still exist on disk!
# Use 'strings' on the raw device to find remnants
# (Only on practice VMs, not production systems!)

# Secure deletion
shred -vfz -n 5 testfile.txt
```

---

## Interview Questions

### Beginner Level

1. **Q: What is the difference between RAM and storage?**
   A: RAM is volatile (loses data on power loss), fast, and used for active data. Storage (HDD/SSD) is non-volatile (persists data), slower, and used for long-term data.

2. **Q: What are the CPU privilege rings?**
   A: Ring 0 (kernel mode - highest privilege), Ring 1-2 (rarely used), Ring 3 (user mode - lowest privilege). Applications run in Ring 3, the OS kernel runs in Ring 0.

3. **Q: What is a process vs a thread?**
   A: A process is an independent running program with its own memory space. A thread is a unit of execution within a process that shares memory with other threads in the same process.

### Intermediate Level

4. **Q: Explain the boot process and where an attacker could inject malicious code.**
   A: The boot process goes: POST → BIOS/UEFI → Bootloader → Kernel → Init → Login. Attackers can inject at: firmware (UEFI rootkit), bootloader (bootkit), kernel (rootkit), or init (persistence).

5. **Q: What is ASLR and how does it protect against exploitation?**
   A: Address Space Layout Randomization randomizes where code and data are loaded in memory. This makes exploitation harder because attackers can't predict memory addresses for their shellcode or return-to-libc attacks.

6. **Q: How does virtual memory provide security isolation?**
   A: Each process gets its own virtual address space mapped by the MMU. Process A cannot directly access Process B's memory because they have separate page tables. The OS enforces this isolation.

### Advanced Level

7. **Q: Describe a scenario where understanding file system internals would help in a forensic investigation.**
   A: If a suspect deleted incriminating files, understanding that deletion only removes the file system entry (inode pointer) but not the data blocks allows forensic recovery. On ext4, the journal may contain file metadata. On NTFS, the MFT entry may still reference data clusters. Tools like Autopsy can carve these remnants.

8. **Q: How would you detect a rootkit that operates at Ring 0?**
   A: Ring 0 rootkits are difficult to detect from within the compromised OS. Methods include: booting from clean media and scanning, using hardware-based detection (UEFI integrity checking), comparing running kernel structures against known-good versions, cross-view detection (comparing OS-reported data vs raw hardware queries), and memory forensics from a hypervisor level.

---

## Summary

### Key Takeaways

| Concept | One-Line Summary |
|---------|-----------------|
| CPU | Executes instructions; registers are key to exploitation |
| RAM | Volatile working memory; target for memory forensics |
| Storage | Persistent; "deleted" doesn't mean gone |
| OS | Manages resources; privilege escalation targets |
| Boot | Sequential process; each stage is an attack surface |
| Processes | Isolated programs; injection bypasses isolation |
| Memory | Virtual addressing provides protection; bypasses exist |
| File Systems | Organize data; artifacts reveal evidence |
| Syscalls | User-kernel interface; monitoring reveals behavior |
| Virtualization | Isolation for safety; VM escape is the ultimate attack |

### What's Next?

You now understand how computers work at a fundamental level. Next, we'll dive deep into **Linux** — the primary operating system used in cybersecurity.

**Next:** → [02-Linux](../02-Linux/README.md)

---

## Additional Resources

| Resource | Type | URL |
|----------|------|-----|
| Computer Science Crash Course | Video Series | youtube.com/crashcourse |
| Operating Systems: Three Easy Pieces | Free Book | pages.cs.wisc.edu/~remzi/OSTEP/ |
| Ben Eater - Build a Computer | Video Series | youtube.com/beneater |
| Linux From Scratch | Book | linuxfromscratch.org |
| Code: The Hidden Language | Book | Charles Petzold |
| But How Do It Know? | Book | J. Clark Scott |

---

*"Understanding the machine is the first step to mastering its security."*
