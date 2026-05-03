# 04. Process Synchronization

## Table of Contents
- [4.1 The Synchronization Problem](#41-the-synchronization-problem)
- [4.2 Critical Section Problem](#42-critical-section-problem)
- [4.3 Mutex Locks](#43-mutex-locks)
- [4.4 Semaphores](#44-semaphores)
- [4.5 Classic Synchronization Problems](#45-classic-synchronization-problems)
- [4.6 Common Mistakes & Interview Tips](#46-common-mistakes--interview-tips)
- [4.7 Practice & Assessment](#47-practice--assessment)

---

## 4.1 The Synchronization Problem

### What is a Race Condition?

A **race condition** occurs when two or more processes/threads access shared data concurrently, and the final result depends on the order of execution.

### Example: Bank Account

```
Shared variable: balance = 1000

Thread A (Deposit $500):          Thread B (Withdraw $300):
  1. Read balance (1000)            1. Read balance (1000)
  2. Add 500 → 1500                 2. Subtract 300 → 700
  3. Write balance = 1500           3. Write balance = 700

PROBLEM: If both read balance BEFORE either writes:
  - Thread A writes 1500
  - Thread B overwrites with 700
  
  Final balance = 700 (wrong! should be 1200)
  We LOST the $500 deposit!
```

### Why Synchronization?

```
Without synchronization:
  → Race conditions → inconsistent data
  → Programs produce different results on each run
  → Bugs that are extremely hard to reproduce

With synchronization:
  → Controlled access to shared resources
  → Predictable, correct results every time
```

---

## 4.2 Critical Section Problem

### Definition
A **critical section** is a code segment where shared resources are accessed. Only ONE process should execute in its critical section at a time.

### Structure

```
Entry Section:     ← Request permission to enter critical section
  CRITICAL SECTION ← Access shared resource (only one at a time)
Exit Section:      ← Signal that you're leaving
  REMAINDER SECTION← Non-critical code
```

### Requirements for Solution

| Requirement | Description |
|-------------|-------------|
| **Mutual Exclusion** | Only one process in critical section at a time |
| **Progress** | If no one is in CS, a waiting process should be allowed in (no unnecessary blocking) |
| **Bounded Waiting** | A process shouldn't wait indefinitely (no starvation) |

---

## 4.3 Mutex Locks

### Definition
A **mutex** (mutual exclusion) is a lock that a process must acquire before entering the critical section and release when leaving.

### Pseudocode

```
mutex lock = UNLOCKED;

Process:
  acquire(lock);        // Wait until lock available, then take it
    // CRITICAL SECTION
    balance = balance + 500;
  release(lock);        // Release the lock for others
    // REMAINDER SECTION
```

### How It Works

```
Process A                   Process B
    │                           │
    ├─ acquire(lock) ✓          │
    │  (lock = LOCKED)          │
    │                           ├─ acquire(lock) ✗ WAIT...
    ├─ CRITICAL SECTION         │       (spinning/blocked)
    │  (reading/writing data)   │
    │                           │
    ├─ release(lock)            │
    │  (lock = UNLOCKED)        ├─ acquire(lock) ✓
    │                           │  (lock = LOCKED)
    │                           ├─ CRITICAL SECTION
    │                           ├─ release(lock)
```

### Spinlock vs Blocking Mutex

| Type | Behavior When Locked | Best For |
|------|---------------------|----------|
| **Spinlock** | Busy-wait (loop checking lock) | Very short critical sections |
| **Blocking Mutex** | Put process to sleep | Long critical sections |

---

## 4.4 Semaphores

### Definition
A **semaphore** is a synchronization tool — an integer variable accessed through two atomic operations: `wait()` (P) and `signal()` (V).

### Types

| Type | Value Range | Purpose |
|------|-------------|---------|
| **Binary Semaphore** | 0 or 1 | Same as mutex (one at a time) |
| **Counting Semaphore** | 0 to N | Allow N processes to access resource |

### Operations

```
wait(S):                    signal(S):
  while (S <= 0) wait;       S = S + 1;
  S = S - 1;
```

### Example: Binary Semaphore (mutex behavior)

```
Semaphore S = 1;    // Initially 1 (available)

Process A:                  Process B:
  wait(S);  → S becomes 0    wait(S);  → S is 0, WAIT...
  // Critical Section         // Blocked
  signal(S); → S becomes 1   // Now unblocked
                              wait(S);  → S becomes 0
                              // Critical Section
                              signal(S); → S becomes 1
```

### Example: Counting Semaphore (Resource Pool)

```
Scenario: 3 printers available, 5 processes want to print

Semaphore printers = 3;   // 3 resources available

Process wanting to print:
  wait(printers);          // Decrement (if > 0, proceed; else wait)
  // USE PRINTER
  signal(printers);        // Increment (release printer)

Process 1: wait → printers=2 (gets printer)
Process 2: wait → printers=1 (gets printer)
Process 3: wait → printers=0 (gets printer)
Process 4: wait → printers=0, BLOCKED (no printer available)
Process 5: wait → printers=0, BLOCKED

Process 1: signal → printers=1 → Process 4 unblocked
```

---

## 4.5 Classic Synchronization Problems

### Producer-Consumer Problem (Bounded Buffer)

```
Problem:
  Producer creates items and puts them in a buffer
  Consumer takes items from the buffer
  Buffer has limited size (N slots)
  
Rules:
  - Producer must wait if buffer is FULL
  - Consumer must wait if buffer is EMPTY
  - Only one can access buffer at a time (mutual exclusion)
```

### Solution with Semaphores

```
Semaphore mutex = 1;     // Mutual exclusion for buffer access
Semaphore empty = N;     // Count of empty slots (initially N)
Semaphore full = 0;      // Count of full slots (initially 0)

PRODUCER:                       CONSUMER:
  produce item                    wait(full);      // Wait if buffer empty
  wait(empty);    // Wait if      wait(mutex);     // Lock buffer
                     buffer full  
  wait(mutex);    // Lock buffer    remove item from buffer
  add item to buffer              signal(mutex);   // Unlock buffer
  signal(mutex);  // Unlock         signal(empty);   // One more empty slot
  signal(full);   // One more       consume item
                     full slot
```

### Dining Philosophers Problem

```
5 philosophers sit around a table.
Between each pair is ONE chopstick (5 total).
To eat, a philosopher needs BOTH left and right chopsticks.

       P0
    /      \
  C4        C0
  /          \
P4            P1
  \          /
  C3        C1
    \      /
       P2
      C2

Problem: If all 5 pick up left chopstick simultaneously → DEADLOCK!
         (each waiting for right chopstick, none available)
```

### Readers-Writers Problem

```
Shared data (e.g., database):
  - Multiple READERS can read simultaneously (no conflict)
  - Only ONE WRITER at a time (exclusive access)
  - Writers and readers cannot access simultaneously

Solution: Read-write lock
  - If no writer: multiple readers allowed
  - If writer waiting: new readers must wait
  - Writer gets exclusive access
```

---

## 4.6 Common Mistakes & Interview Tips

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Forgetting to release lock | Always release in EVERY code path (including error paths) |
| Wrong semaphore order → deadlock | Be consistent with lock ordering |
| Using spinlock for long operations | Use blocking mutex for long critical sections |
| Not making wait/signal atomic | Use hardware support (test-and-set, compare-and-swap) |

### Interview Questions

**Q: What is a race condition?**
> A race condition occurs when multiple processes access shared data concurrently and the result depends on execution order. It leads to inconsistent/incorrect results.

**Q: What is the difference between mutex and semaphore?**
> A mutex is a binary lock (locked/unlocked) owned by one thread. A semaphore is a counter that can allow multiple threads access (counting semaphore) or act like a mutex (binary semaphore). Mutex has ownership (only the locker can unlock); semaphore doesn't.

**Q: What are the three requirements for solving the critical section problem?**
> Mutual Exclusion (only one in CS), Progress (no unnecessary blocking), and Bounded Waiting (no starvation).

---

## 4.7 Practice & Assessment

### MCQs

**Q1.** A race condition occurs when:
- A) Two processes communicate via pipes
- B) Multiple processes access shared data without synchronization
- C) A process is terminated
- D) CPU is idle

**Answer:** B

---

**Q2.** A counting semaphore initialized to 5 means:
- A) 5 processes are waiting
- B) Up to 5 processes can access the resource simultaneously
- C) The resource is locked 5 times
- D) Only process #5 can access it

**Answer:** B

---

**Q3.** In the Producer-Consumer problem, the producer waits when:
- A) Buffer is empty
- B) Buffer is full
- C) Consumer is sleeping
- D) No processes are running

**Answer:** B

---

### Short Answer

**Q:** In the bank account example, how would you fix the race condition?

> Use a mutex lock around the read-modify-write operations:
```
acquire(account_lock);
  balance = balance + amount;
release(account_lock);
```
> This ensures only one thread modifies the balance at a time.

---

> **Next Topic:** [05 - Deadlocks](05-deadlocks.md)
