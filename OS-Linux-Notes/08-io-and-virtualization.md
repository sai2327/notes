# 08. I/O Systems and Virtualization

## Table of Contents
- [8.1 I/O Hardware](#81-io-hardware)
- [8.2 OS Role in I/O](#82-os-role-in-io)
- [8.3 Disk Scheduling](#83-disk-scheduling)
- [8.4 Virtualization](#84-virtualization)
- [8.5 Containers vs VMs](#85-containers-vs-vms)
- [8.6 Common Mistakes & Interview Tips](#86-common-mistakes--interview-tips)
- [8.7 Practice & Assessment](#87-practice--assessment)

---

## 8.1 I/O Hardware

### I/O Device Categories

| Category | Examples | Speed |
|----------|---------|-------|
| **Block devices** | Hard disk, SSD, USB drive | Medium-High |
| **Character devices** | Keyboard, mouse, serial port | Low |
| **Network devices** | Ethernet NIC, Wi-Fi adapter | High |

### I/O Communication Methods

| Method | How It Works | CPU Usage | Use Case |
|--------|-------------|-----------|----------|
| **Programmed I/O (Polling)** | CPU repeatedly checks device status | High (busy waiting) | Simple devices |
| **Interrupt-Driven I/O** | Device sends interrupt when ready | Medium | Most devices |
| **DMA (Direct Memory Access)** | Device transfers data directly to memory | Low | Disk, network (bulk transfers) |

### DMA (Direct Memory Access)

```
Without DMA:
  CPU reads byte from device → writes to memory → repeat
  (CPU busy for ENTIRE transfer)

With DMA:
  1. CPU tells DMA controller: source, destination, size
  2. DMA controller handles the transfer
  3. CPU is FREE to do other work
  4. DMA sends interrupt when done
  
  Used for: Disk I/O, network packets, any bulk data transfer
```

---

## 8.2 OS Role in I/O

### I/O Software Layers

```
┌─────────────────────────────────┐
│     User-Level I/O Software      │  printf(), fread()
├─────────────────────────────────┤
│  Device-Independent OS Layer     │  Buffering, caching, naming
├─────────────────────────────────┤
│       Device Drivers             │  Hardware-specific code
├─────────────────────────────────┤
│    Interrupt Handlers            │  Handle hardware interrupts
├─────────────────────────────────┤
│         HARDWARE                 │  Physical devices
└─────────────────────────────────┘
```

### Key Concepts

| Concept | Definition | Example |
|---------|-----------|---------|
| **Buffering** | Temporary storage for data during transfer | Keyboard buffer holds typed chars |
| **Caching** | Keep copy of frequently used data in fast storage | Disk cache in RAM |
| **Spooling** | Queue jobs for a device that handles one at a time | Print spooler (queue print jobs) |

---

## 8.3 Disk Scheduling

### Why Disk Scheduling?
Disk access time = **Seek time** (move head) + **Rotational latency** + **Transfer time**
Seek time dominates → minimize head movement!

### Algorithms

Given: Head at position 53, request queue: 98, 183, 37, 122, 14, 124, 65, 67

**FCFS (First Come First Served):**
```
Order: 53 → 98 → 183 → 37 → 122 → 14 → 124 → 65 → 67
Total head movement = |53-98| + |98-183| + |183-37| + |37-122| + 
                      |122-14| + |14-124| + |124-65| + |65-67|
                    = 45 + 85 + 146 + 85 + 108 + 110 + 59 + 2 = 640
```

**SSTF (Shortest Seek Time First):**
```
Always go to NEAREST request.
53 → 65 → 67 → 37 → 14 → 98 → 122 → 124 → 183
Total = 12 + 2 + 30 + 23 + 84 + 24 + 2 + 59 = 236

Better but can cause starvation of far requests!
```

**SCAN (Elevator Algorithm):**
```
Head moves in one direction, services all requests, then reverses.
(Like an elevator going up then down)

Direction: toward 0 first
53 → 37 → 14 → 0 → 65 → 67 → 98 → 122 → 124 → 183
Total = 16 + 23 + 14 + 65 + 2 + 31 + 24 + 2 + 59 = 236
```

---

## 8.4 Virtualization

### Definition
**Virtualization** creates a virtual version of hardware, allowing multiple operating systems to run on a single physical machine.

### Architecture

```
┌──────────┐ ┌──────────┐ ┌──────────┐
│  Guest   │ │  Guest   │ │  Guest   │
│  OS 1    │ │  OS 2    │ │  OS 3    │
│ (Ubuntu) │ │(Windows) │ │ (Fedora) │
├──────────┤ ├──────────┤ ├──────────┤
│  Virtual │ │  Virtual │ │  Virtual │
│ Hardware │ │ Hardware │ │ Hardware │
└────┬─────┘ └────┬─────┘ └────┬─────┘
     │             │             │
┌────┴─────────────┴─────────────┴────┐
│          HYPERVISOR                   │
│   (VMware, VirtualBox, KVM, Hyper-V) │
├─────────────────────────────────────┤
│        PHYSICAL HARDWARE             │
│   (CPU, RAM, Disk, NIC)             │
└─────────────────────────────────────┘
```

### Hypervisor Types

| Type | Description | Example |
|------|-------------|---------|
| **Type 1 (Bare-metal)** | Runs directly on hardware | VMware ESXi, KVM, Hyper-V |
| **Type 2 (Hosted)** | Runs on top of host OS | VirtualBox, VMware Workstation |

### Benefits of Virtualization

```
1. SERVER CONSOLIDATION: Run 10 VMs on 1 physical server
2. ISOLATION: One VM crash doesn't affect others
3. SNAPSHOTS: Save VM state, revert if something breaks
4. TESTING: Test in multiple OS without multiple machines
5. COST SAVINGS: Less physical hardware needed
6. SECURITY: Isolate applications in separate VMs
```

---

## 8.5 Containers vs VMs

```
Virtual Machine:                 Container:
┌─────────────────┐             ┌─────────────────┐
│   Application   │             │   Application   │
├─────────────────┤             ├─────────────────┤
│   Libraries     │             │   Libraries     │
├─────────────────┤             └────────┬────────┘
│   Guest OS      │                      │
├─────────────────┤             ┌────────┴────────┐
│   Hypervisor    │             │ Container Engine│
├─────────────────┤             │   (Docker)      │
│   Host OS       │             ├─────────────────┤
├─────────────────┤             │    Host OS      │
│   Hardware      │             ├─────────────────┤
└─────────────────┘             │   Hardware      │
                                └─────────────────┘
```

| Feature | VM | Container |
|---------|-------|-----------|
| Isolation | Full (separate kernel) | Process-level (shared kernel) |
| Startup | Minutes | Seconds |
| Size | GBs (includes full OS) | MBs (just app + libraries) |
| Performance | Near-native (small overhead) | Native (minimal overhead) |
| Use case | Different OS on same hardware | Microservices, deployment |
| Example | VirtualBox, VMware | Docker, Podman |

---

## 8.6 Common Mistakes & Interview Tips

### Interview Questions

**Q: What is DMA?**
> Direct Memory Access — a hardware mechanism that allows I/O devices to transfer data directly to/from memory without CPU involvement. The CPU initiates the transfer and is free to do other work until DMA signals completion via interrupt.

**Q: Difference between VM and container?**
> A VM runs a complete guest OS on virtualized hardware (strong isolation, heavy). A container shares the host OS kernel and only packages the application and its dependencies (lightweight, fast startup). VMs for different OS needs; containers for app deployment.

---

## 8.7 Practice & Assessment

### MCQs

**Q1.** DMA reduces:
- A) Disk size
- B) CPU involvement in data transfer
- C) RAM usage
- D) Number of devices

**Answer:** B) CPU involvement

---

**Q2.** A Type 1 hypervisor runs:
- A) Inside a container
- B) On top of a host OS
- C) Directly on hardware (bare-metal)
- D) In the cloud only

**Answer:** C) Directly on hardware

---

**Q3.** Containers are lighter than VMs because:
- A) They use less disk space
- B) They share the host OS kernel
- C) They don't need networking
- D) They can't run applications

**Answer:** B) They share the host OS kernel

---

> **Next Topic:** [09 - Introduction to Linux](09-introduction-to-linux.md)
