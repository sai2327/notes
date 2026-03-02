# 📘 Chapter 4: Process Synchronization

> **"When multiple processes access shared data concurrently, the outcome depends on the order of execution — this is the race condition problem."**

---

## 📑 Table of Contents

| # | Topic |
|---|-------|
| 1 | [The Synchronization Problem](#1-the-synchronization-problem) |
| 2 | [Critical Section Problem](#2-critical-section-problem) |
| 3 | [Mutex (Mutual Exclusion Lock)](#3-mutex-locks) |
| 4 | [Semaphores](#4-semaphores) |
| 5 | [Monitors](#5-monitors) |
| 6 | [Classical Problems](#6-classical-synchronization-problems) |
| 7 | [Quick Summary](#7-quick-summary) |
| 8 | [Practice Questions](#-practice-questions) |

---

## 1. The Synchronization Problem

### 📖 Concept Explanation

When two or more processes (or threads) **access shared data concurrently**, and at least one is **writing**, the final result depends on the **order of execution**. This is called a **Race Condition**.

```
    RACE CONDITION EXAMPLE:
    
    Shared variable: balance = 1000
    
    Thread A (Deposit $200)          Thread B (Withdraw $100)
    ────────────────────             ────────────────────────
    1. Read balance (1000)           1. Read balance (1000)
    2. Add 200 → 1200               2. Subtract 100 → 900
    3. Write balance = 1200         3. Write balance = 900
    
    POSSIBLE OUTCOMES:
    
    Case 1: A completes before B starts
    balance = 1000 + 200 - 100 = 1100 ✓ (CORRECT)
    
    Case 2: B completes before A starts
    balance = 1000 - 100 + 200 = 1100 ✓ (CORRECT)
    
    Case 3: INTERLEAVED execution (RACE CONDITION!)
    ┌──────────────────────────────────────────────┐
    │ A reads balance = 1000                       │
    │ B reads balance = 1000   (before A writes!)  │
    │ A writes balance = 1200                      │
    │ B writes balance = 900   (overwrites A!)     │
    │                                              │
    │ Final balance = 900  ✗ WRONG!                │
    │ (Lost $200 deposit!)                         │
    └──────────────────────────────────────────────┘
```

### 🏠 Real-World Analogy

Two people simultaneously editing the **same Google Doc paragraph** without seeing each other's changes. One overwrites the other's edits.

Or: Two ATMs processing transactions on the same account at the same time — without synchronization, money can appear or disappear!

---

## 2. Critical Section Problem

### 📖 Concept Explanation

The **Critical Section** is the portion of code where a process accesses **shared resources** (variables, files, databases). The **Critical Section Problem** is ensuring that when one process is in its critical section, **no other process** is allowed in its critical section for the same resource.

```
    PROCESS STRUCTURE:
    
    ┌─────────────────────────┐
    │                         │
    │   ENTRY SECTION         │  ← Request permission to enter
    │   (acquire lock)        │
    │                         │
    ├─────────────────────────┤
    │                         │
    │   ★ CRITICAL SECTION ★  │  ← Access shared resource
    │   (shared data access)  │     (only ONE process at a time)
    │                         │
    ├─────────────────────────┤
    │                         │
    │   EXIT SECTION          │  ← Release permission
    │   (release lock)        │
    │                         │
    ├─────────────────────────┤
    │                         │
    │   REMAINDER SECTION     │  ← Rest of the code
    │   (non-critical code)   │
    │                         │
    └─────────────────────────┘
```

### Three Requirements for a Valid Solution

```
    ┌──────────────────────────────────────────────────────────────┐
    │          THREE REQUIREMENTS FOR CS SOLUTION                   │
    ├──────────────────────────────────────────────────────────────┤
    │                                                              │
    │  1. MUTUAL EXCLUSION                                         │
    │     ─────────────────                                        │
    │     If process Pi is in CS, NO other process                 │
    │     can be in CS simultaneously.                             │
    │                                                              │
    │     Pi in CS ──► All others BLOCKED from CS                  │
    │                                                              │
    │  2. PROGRESS                                                 │
    │     ────────                                                 │
    │     If NO process is in CS, and some processes               │
    │     want to enter, the decision of who enters                │
    │     cannot be postponed indefinitely.                        │
    │                                                              │
    │     CS empty + processes waiting ──► Someone MUST enter      │
    │     (No deadlock on entry)                                   │
    │                                                              │
    │  3. BOUNDED WAITING                                          │
    │     ───────────────                                          │
    │     After a process requests CS entry, there is a            │
    │     BOUND on the number of times other processes             │
    │     can enter CS before this process.                        │
    │                                                              │
    │     Request to enter ──► Guaranteed entry within             │
    │     finite time (No starvation)                              │
    │                                                              │
    └──────────────────────────────────────────────────────────────┘
```

### 🏠 Real-World Analogy

| CS Requirement | Bathroom Analogy |
|----------------|------------------|
| **Mutual Exclusion** | Only ONE person uses the bathroom at a time (door is locked) |
| **Progress** | If bathroom is empty and people are waiting, someone MUST enter (no one just stares at the door forever) |
| **Bounded Waiting** | Everyone waiting will eventually get a turn — no one waits forever |

### Peterson's Solution (Classical, Software-Based)

```c
// Peterson's Solution for 2 processes (P0 and P1)
// Shared variables:
int turn;           // Whose turn it is
bool flag[2];       // flag[i] = true means Pi wants to enter CS

// Process Pi (i = 0 or 1), j = 1-i
void process_i() {
    flag[i] = true;      // I want to enter CS
    turn = j;            // Give turn to other process (polite!)
    
    while (flag[j] && turn == j)
        ; // BUSY WAIT (spin lock)
    
    // ★ CRITICAL SECTION ★
    // ... access shared resource ...
    
    flag[i] = false;     // I'm done, leaving CS
    
    // REMAINDER SECTION
}
```

```
    PETERSON'S SOLUTION VISUALIZATION:
    
    P0 wants to enter:             P1 wants to enter:
    flag[0] = true                 flag[1] = true
    turn = 1                       turn = 0
    
    P0 checks: flag[1] && turn==1  P1 checks: flag[0] && turn==0
    
    If both try simultaneously:
    turn can only be 0 OR 1 (not both!)
    → One of them proceeds, other waits
    → MUTUAL EXCLUSION guaranteed ✓
```

### ⚠️ Limitations of Peterson's Solution
- Only works for **2 processes**
- Requires **busy waiting** (wastes CPU)
- May not work on modern hardware due to **instruction reordering** (memory barriers needed)
- Not practical for real-world use — use Mutex/Semaphore instead

---

## 3. Mutex Locks

### 📖 Concept Explanation

A **Mutex** (Mutual Exclusion) is the simplest synchronization tool. It's a **lock** that a process must **acquire** before entering the critical section and **release** when leaving.

```
    MUTEX LOCK:
    
    ┌──────────┐
    │  MUTEX   │     States: LOCKED / UNLOCKED
    │  (lock)  │
    └──────────┘
    
    acquire()                    release()
    ─────────                    ─────────
    If UNLOCKED:                 Set to UNLOCKED
      Set to LOCKED              Wake up waiting
      Enter CS                   processes
    If LOCKED:
      WAIT (block/spin)
    
    
    EXAMPLE FLOW:
    
    Process A                     Process B
    ─────────                     ─────────
    acquire(mutex) ✓              acquire(mutex) ✗ BLOCKED
    ┌──────────────┐              │ Waiting...
    │ CRITICAL     │              │ Waiting...
    │ SECTION      │              │ Waiting...
    └──────────────┘              │
    release(mutex)                │
                                  acquire(mutex) ✓ (now enters)
                                  ┌──────────────┐
                                  │ CRITICAL     │
                                  │ SECTION      │
                                  └──────────────┘
                                  release(mutex)
```

### Code Example

```c
// Mutex usage in pseudocode
mutex_t lock;

void deposit(int amount) {
    acquire(lock);           // Entry section
    
    // ★ CRITICAL SECTION ★
    balance = balance + amount;
    
    release(lock);           // Exit section
}

void withdraw(int amount) {
    acquire(lock);           // Entry section
    
    // ★ CRITICAL SECTION ★
    balance = balance - amount;
    
    release(lock);           // Exit section
}
```

### Spinlock vs Blocking Mutex

```
    SPINLOCK (Busy Wait)              BLOCKING MUTEX (Sleep Wait)
    ────────────────────              ───────────────────────────
    while (lock == LOCKED)            if (lock == LOCKED)
        ; // CPU spinning               put process to SLEEP
          // doing nothing               (doesn't waste CPU)
          // (wastes CPU!)               
                                      When lock released:
    When lock released:                 WAKE UP sleeping process
        exits loop
    
    ✓ Good for SHORT critical          ✓ Good for LONG critical
      sections (no context              sections
      switch overhead)                ✗ Context switch overhead
    ✗ Wastes CPU cycles                when sleeping/waking
    
    Used in: Kernel code,             Used in: User-space
    multiprocessor systems            applications
```

### 🏠 Real-World Analogy

**Mutex = Bathroom key at a gas station**
- Only ONE key exists
- You take the key (acquire) → enter bathroom (CS)
- When done, return key (release) → next person gets it
- If key is taken, you WAIT

---

## 4. Semaphores

### 📖 Concept Explanation

A **Semaphore** is a more powerful synchronization tool than a mutex. It's an integer variable accessed through two **atomic operations**: `wait()` (P) and `signal()` (V).

```
    SEMAPHORE:
    
    ┌──────────────────────────┐
    │  Semaphore S = value     │
    │                          │
    │  wait(S) / P(S):         │    signal(S) / V(S):
    │  ─────────────            │    ────────────────
    │  while (S <= 0)          │    S = S + 1
    │      ; // wait           │
    │  S = S - 1               │
    └──────────────────────────┘
    
    P = Proberen (Dutch: "to test")
    V = Verhogen (Dutch: "to increment")
```

### Two Types of Semaphores

```
    ┌────────────────────────────────────────────────────────┐
    │              TYPES OF SEMAPHORES                        │
    ├────────────────────────┬───────────────────────────────┤
    │   BINARY SEMAPHORE     │    COUNTING SEMAPHORE         │
    │                        │                               │
    │   Value: 0 or 1        │    Value: 0 to N              │
    │   (like a mutex)       │    (controls N resources)     │
    │                        │                               │
    │   Example:             │    Example:                   │
    │   One bathroom         │    Parking lot with           │
    │   (occupied/free)      │    N=50 spaces                │
    │                        │                               │
    │   S = 1 → available    │    S = 50 → spaces left      │
    │   S = 0 → in use       │    S = 0  → lot full         │
    │                        │                               │
    │   Used for:            │    Used for:                  │
    │   Mutual Exclusion     │    Resource allocation        │
    │                        │    (e.g., connection pool)    │
    └────────────────────────┴───────────────────────────────┘
```

### Semaphore Operations (Atomic)

```c
// WAIT (P operation) - Decrement
wait(S) {
    while (S <= 0)
        ; // busy wait (or block)
    S--;
}

// SIGNAL (V operation) - Increment
signal(S) {
    S++;
}
```

### Semaphore for Mutual Exclusion

```c
// Binary Semaphore for mutual exclusion (like mutex)
semaphore mutex = 1;  // Initially 1 (available)

// Process P1                    // Process P2
wait(mutex);   // S: 1→0        wait(mutex);   // BLOCKS (S=0)
// CS                            // waiting...
signal(mutex); // S: 0→1        // now enters (S was 1→0)
                                 // CS
                                 signal(mutex); // S: 0→1
```

### Semaphore for Process Ordering (Synchronization)

```c
// Ensure S1 (in P1) executes BEFORE S2 (in P2)
semaphore sync = 0;  // Initially 0

// Process P1                    // Process P2
execute S1;                      wait(sync);   // BLOCKS (S=0)
signal(sync);  // S: 0→1        execute S2;    // runs after S1
```

```
    ORDERING EXAMPLE:
    
    We want: P1's statement S1 to execute BEFORE P2's S2
    
    Semaphore sync = 0
    
    P1:                          P2:
    ┌──────────────┐             ┌──────────────┐
    │ Execute S1   │             │ wait(sync)   │ ← BLOCKS since sync=0
    │              │             │ (waiting...) │
    │ signal(sync) │───────────► │              │
    │ (sync: 0→1)  │             │ Execute S2   │ ← Now runs!
    └──────────────┘             └──────────────┘
    
    GUARANTEED: S1 happens before S2 ✓
```

### Counting Semaphore Example

```c
// Parking lot with 3 spaces
semaphore parking = 3;

void enter_parking() {
    wait(parking);     // parking-- (3→2→1→0)
    // park the car
}

void exit_parking() {
    signal(parking);   // parking++ (0→1→2→3)
    // car leaves
}

// If parking = 0 and new car arrives → BLOCKS until a car leaves
```

```
    COUNTING SEMAPHORE: PARKING LOT
    
    parking = 3 (3 spaces available)
    
    Car A enters: wait(parking) → parking = 2  ┌───┬───┬───┐
                                                │ A │   │   │
    Car B enters: wait(parking) → parking = 1  │ A │ B │   │
                                                │ A │ B │   │
    Car C enters: wait(parking) → parking = 0  │ A │ B │ C │
                                                └───┴───┴───┘
    Car D enters: wait(parking) → BLOCKED! 🚫 (parking = 0)
                  (waits until a car leaves)
    
    Car A leaves: signal(parking) → parking = 1
                  Car D can now enter!         │ D │ B │ C │
```

### Mutex vs Semaphore

| Feature | Mutex | Binary Semaphore | Counting Semaphore |
|---------|-------|------------------|--------------------|
| **Values** | Locked / Unlocked | 0 or 1 | 0 to N |
| **Ownership** | YES (only owner can release) | NO (any process can signal) | NO |
| **Purpose** | Mutual exclusion only | Mutual exclusion + ordering | Resource counting |
| **Resources** | 1 | 1 | N |
| **Who releases?** | Same process that acquired | Any process | Any process |

### ⚠️ Common Mistakes with Semaphores

```
    MISTAKE 1: Forgetting signal() → DEADLOCK
    ──────────────────────────────────────────
    wait(S);
    // CS
    // forgot signal(S)!  → S stays 0 forever → all others blocked
    
    MISTAKE 2: Swapping wait/signal order
    ─────────────────────────────────────
    signal(S);    // WRONG! S becomes 2
    // CS         // No mutual exclusion!
    wait(S);
    
    MISTAKE 3: Using same semaphore for wrong purpose
    ─────────────────────────────────────────────────
    Two different CSs using S1 and S2 → must use separate semaphores
```

---

## 5. Monitors

### 📖 Concept Explanation

A **Monitor** is a high-level synchronization construct that encapsulates **shared data**, **operations** on that data, and **synchronization** all in one object. Only **one process** can be active inside a monitor at any time.

```
    ┌─────────────────────────────────────────────────────┐
    │                   MONITOR                            │
    │                                                      │
    │   ┌─────────────────────────────────────────────┐   │
    │   │         Shared Data                          │   │
    │   │    (accessible ONLY through procedures)      │   │
    │   │    int balance;                              │   │
    │   │    queue waitingList;                         │   │
    │   └─────────────────────────────────────────────┘   │
    │                                                      │
    │   ┌─────────────────┐  ┌─────────────────┐          │
    │   │  procedure      │  │  procedure      │          │
    │   │  deposit()      │  │  withdraw()     │          │
    │   │  {              │  │  {              │          │
    │   │    balance += x; │  │    balance -= x;│          │
    │   │  }              │  │  }              │          │
    │   └─────────────────┘  └─────────────────┘          │
    │                                                      │
    │   ┌─────────────────────────────────────────────┐   │
    │   │  Condition Variables: x, y                   │   │
    │   │  x.wait()  → suspend calling process         │   │
    │   │  x.signal()→ resume ONE waiting process      │   │
    │   └─────────────────────────────────────────────┘   │
    │                                                      │
    │   ┌─────────────────────────────────────────────┐   │
    │   │  ENTRY QUEUE                                 │   │
    │   │  Processes waiting to enter the monitor      │   │
    │   │  [P3] [P4] [P5] → waiting                    │   │
    │   └─────────────────────────────────────────────┘   │
    │                                                      │
    │   ★ Only ONE process executes inside at a time ★     │
    │                                                      │
    └─────────────────────────────────────────────────────┘
    
    P1 is inside the monitor (executing deposit())
    P2, P3, P4 are in the entry queue (waiting)
```

### Condition Variables

```
    CONDITION VARIABLES in Monitors:
    
    x.wait()   → Suspend the calling process,
                 release the monitor,
                 place in condition queue
    
    x.signal() → Wake up ONE process waiting on x
                 (if no one waiting, signal is lost)
    
    
    EXAMPLE: Producer-Consumer with Monitor
    
    monitor BoundedBuffer {
        item buffer[N];
        int count = 0;
        condition notFull, notEmpty;
        
        procedure deposit(item) {
            if (count == N)
                notFull.wait();     // Buffer full → wait
            buffer[count] = item;
            count++;
            notEmpty.signal();       // Wake up consumer
        }
        
        procedure remove() {
            if (count == 0)
                notEmpty.wait();    // Buffer empty → wait
            item = buffer[count-1];
            count--;
            notFull.signal();        // Wake up producer
            return item;
        }
    }
```

### Monitor vs Semaphore

| Feature | Semaphore | Monitor |
|---------|-----------|---------|
| **Abstraction Level** | Low (programmer manages) | High (automatic mutual exclusion) |
| **Mutual Exclusion** | Programmer must code wait/signal | Automatic (built into monitor) |
| **Error Prone** | Yes (easy to forget signal) | Less error-prone |
| **Condition Variables** | Not built-in | Built-in (wait/signal) |
| **Language Support** | All languages | Java (synchronized), C# (lock) |
| **Complexity** | Manual synchronization | Encapsulated synchronization |

### 🏠 Real-World Analogy

**Monitor = A doctor's office**
- Only ONE patient is seen at a time (mutual exclusion)
- Other patients wait in the waiting room (entry queue)
- If the doctor needs test results, the patient waits in a special waiting area (condition wait)
- When results arrive, the patient is called back (condition signal)

---

## 6. Classical Synchronization Problems

### 6.1 Producer-Consumer Problem (Bounded Buffer)

#### 📖 Problem Description

A **Producer** produces items and puts them in a shared **buffer**. A **Consumer** consumes items from the buffer. The buffer has a **finite size N**.

```
    ┌──────────┐    ┌───┬───┬───┬───┬───┐    ┌──────────┐
    │ PRODUCER │───►│   │   │   │   │   │───►│ CONSUMER │
    │ (writes) │    │ 1 │ 2 │ 3 │   │   │    │ (reads)  │
    └──────────┘    └───┴───┴───┴───┴───┘    └──────────┘
                         BUFFER (size N=5)
    
    CONSTRAINTS:
    1. Producer MUST NOT write when buffer is FULL
    2. Consumer MUST NOT read when buffer is EMPTY
    3. Only ONE process accesses buffer at a time (mutual exclusion)
```

#### Solution using Semaphores

```c
// Shared variables
semaphore mutex = 1;     // For mutual exclusion
semaphore empty = N;     // Count of empty slots (initially N)
semaphore full = 0;      // Count of full slots (initially 0)

// PRODUCER
void producer() {
    while (true) {
        item = produce_item();
        
        wait(empty);        // Wait if buffer is FULL (empty=0)
        wait(mutex);        // Enter critical section
        
        add_to_buffer(item);
        
        signal(mutex);      // Leave critical section
        signal(full);       // Increment full count
    }
}

// CONSUMER
void consumer() {
    while (true) {
        wait(full);         // Wait if buffer is EMPTY (full=0)
        wait(mutex);        // Enter critical section
        
        item = remove_from_buffer();
        
        signal(mutex);      // Leave critical section
        signal(empty);      // Increment empty count
        
        consume_item(item);
    }
}
```

```
    EXECUTION TRACE (Buffer size N=3):
    
    Time │ Producer Action     │ Consumer Action    │ Buffer  │empty│full│mutex
    ─────┼─────────────────────┼────────────────────┼─────────┼─────┼────┼─────
      1  │ Produce item A      │                    │ [  ]    │  3  │ 0  │  1
      2  │ wait(empty)→2       │                    │ [  ]    │  2  │ 0  │  1
         │ wait(mutex)→0       │                    │         │  2  │ 0  │  0
         │ add A               │                    │ [A]     │  2  │ 0  │  0
         │ signal(mutex)→1     │                    │ [A]     │  2  │ 0  │  1
         │ signal(full)→1      │                    │ [A]     │  2  │ 1  │  1
      3  │                     │ wait(full)→0       │ [A]     │  2  │ 0  │  1
         │                     │ wait(mutex)→0      │ [A]     │  2  │ 0  │  0
         │                     │ remove A           │ [  ]    │  2  │ 0  │  0
         │                     │ signal(mutex)→1    │ [  ]    │  2  │ 0  │  1
         │                     │ signal(empty)→3    │ [  ]    │  3  │ 0  │  1
```

#### ⚠️ Common Mistake: Swapping wait() order

```c
// WRONG! Can cause DEADLOCK:
wait(mutex);    // Gets mutex (mutex=0)
wait(empty);    // If buffer is full → BLOCKS while holding mutex
                // Consumer can't get mutex to consume → DEADLOCK!

// CORRECT: Always wait on counting semaphore FIRST, then mutex
wait(empty);    // Wait for slot (doesn't hold mutex)
wait(mutex);    // Then get mutex
```

---

### 6.2 Dining Philosophers Problem

#### 📖 Problem Description

Five philosophers sit around a circular table. Each philosopher alternates between **thinking** and **eating**. Between each pair of philosophers is a **chopstick** (fork). To eat, a philosopher needs **BOTH** chopsticks (left and right).

```
    THE DINING PHILOSOPHERS (5 philosophers, 5 chopsticks)
    
                        P0
                      /    \
                   C4        C0
                  /            \
                P4      🍜      P1
                  \      ▲     /
                   C3    │   C1
                     \   │  /
                      P3 ─ P2
                          C2
    
    Pi = Philosopher i
    Ci = Chopstick i
    
    P0 needs: C4 (left) and C0 (right)
    P1 needs: C0 (left) and C1 (right)
    P2 needs: C1 (left) and C2 (right)
    P3 needs: C2 (left) and C3 (right)
    P4 needs: C3 (left) and C4 (right)
```

#### Naive Solution (CAUSES DEADLOCK!)

```c
// EACH chopstick is a semaphore initialized to 1
semaphore chopstick[5] = {1, 1, 1, 1, 1};

// Philosopher i:
void philosopher(int i) {
    while (true) {
        think();
        
        wait(chopstick[i]);           // Pick up LEFT chopstick
        wait(chopstick[(i+1) % 5]);   // Pick up RIGHT chopstick
        
        eat();
        
        signal(chopstick[i]);         // Put down LEFT
        signal(chopstick[(i+1) % 5]); // Put down RIGHT
    }
}
```

```
    DEADLOCK SCENARIO:
    
    All 5 philosophers simultaneously pick up their LEFT chopstick:
    
    P0 picks C4 ✓ → tries C0... BLOCKED (P1 has C0)
    P1 picks C0 ✓ → tries C1... BLOCKED (P2 has C1)
    P2 picks C1 ✓ → tries C2... BLOCKED (P3 has C2)
    P3 picks C2 ✓ → tries C3... BLOCKED (P4 has C3)
    P4 picks C3 ✓ → tries C4... BLOCKED (P0 has C4)
    
    ┌─────────────┐
    │  DEADLOCK!  │  Everyone waits for everyone else
    │  CIRCULAR   │  No one can eat
    │  WAIT       │  No one releases their chopstick
    └─────────────┘
```

#### Solutions to Dining Philosophers

```
    SOLUTION 1: Allow at most 4 philosophers to sit at once
    ─────────────────────────────────────────────────────────
    semaphore seats = 4;  // Only 4 can try to eat
    wait(seats);
    wait(chopstick[i]);
    wait(chopstick[(i+1)%5]);
    eat();
    signal(chopstick[i]);
    signal(chopstick[(i+1)%5]);
    signal(seats);
    
    SOLUTION 2: Odd picks left first, Even picks right first
    ────────────────────────────────────────────────────────
    if (i % 2 == 0) {          // Even philosopher
        wait(chopstick[i]);     // Left first
        wait(chopstick[(i+1)%5]); // Then right
    } else {                    // Odd philosopher
        wait(chopstick[(i+1)%5]); // Right first
        wait(chopstick[i]);     // Then left
    }
    
    SOLUTION 3: Use a monitor (automatic mutual exclusion)
    ──────────────────────────────────────────────────────
    Check both chopsticks are available before picking either.
    If not, wait on condition variable.
```

---

### 6.3 Readers-Writers Problem

#### 📖 Problem Description

A shared database is accessed by **Readers** (only read data) and **Writers** (modify data).

**Rules:**
1. Multiple readers can read simultaneously (no conflict)
2. Only ONE writer can write at a time (exclusive access)
3. No reader can read while a writer is writing
4. No writer can write while readers are reading

```
    ┌────────────────── DATABASE ──────────────────┐
    │                                              │
    │   ALLOWED:                                   │
    │   ┌──────┐ ┌──────┐ ┌──────┐                │
    │   │Reader│ │Reader│ │Reader│  ← Multiple     │
    │   │  1   │ │  2   │ │  3   │    readers OK   │
    │   └──────┘ └──────┘ └──────┘                │
    │                                              │
    │   ALLOWED:                                   │
    │   ┌──────┐                                   │
    │   │Writer│  ← Only ONE writer, NO readers    │
    │   │  1   │                                   │
    │   └──────┘                                   │
    │                                              │
    │   NOT ALLOWED:                               │
    │   ┌──────┐ ┌──────┐                          │
    │   │Writer│ │Reader│  ← Writer + Reader ✗     │
    │   └──────┘ └──────┘                          │
    │                                              │
    │   ┌──────┐ ┌──────┐                          │
    │   │Writer│ │Writer│  ← Two Writers ✗         │
    │   └──────┘ └──────┘                          │
    └──────────────────────────────────────────────┘
```

#### Solution: Readers-Priority (First Readers-Writers Problem)

```c
// Shared variables
semaphore rw_mutex = 1;    // Mutual exclusion for writers
semaphore mutex = 1;       // Protects read_count
int read_count = 0;        // Number of active readers

// WRITER
void writer() {
    wait(rw_mutex);        // Exclusive access to database
    
    // ★ WRITE to database ★
    
    signal(rw_mutex);      // Release database
}

// READER
void reader() {
    wait(mutex);           // Protect read_count
    read_count++;
    if (read_count == 1)   // First reader?
        wait(rw_mutex);    // Lock out writers
    signal(mutex);
    
    // ★ READ from database ★  (Multiple readers can be here)
    
    wait(mutex);           // Protect read_count
    read_count--;
    if (read_count == 0)   // Last reader leaving?
        signal(rw_mutex);  // Allow writers
    signal(mutex);
}
```

```
    EXECUTION TRACE:
    
    Time │ Action                    │ read_count │ rw_mutex │ Who's Reading/Writing
    ─────┼───────────────────────────┼────────────┼──────────┼─────────────────────
      1  │ R1: read_count++ → 1     │     1      │    0     │ R1 reading
         │ R1: wait(rw_mutex) ✓     │            │          │
      2  │ R2: read_count++ → 2     │     2      │    0     │ R1, R2 reading
         │ (not first reader, skip  │            │          │
         │  wait(rw_mutex))         │            │          │
      3  │ W1: wait(rw_mutex) BLOCK │     2      │    0     │ R1, R2 reading
         │ (writer can't enter!)    │            │          │ W1 waiting
      4  │ R1: read_count-- → 1     │     1      │    0     │ R2 reading
         │ (not last, don't signal) │            │          │
      5  │ R2: read_count-- → 0     │     0      │    1     │ (empty)
         │ R2: signal(rw_mutex) ✓   │            │          │
      6  │ W1: (unblocked!)         │     0      │    0     │ W1 writing
         │ ★ WRITING ★              │            │          │
      7  │ W1: signal(rw_mutex)     │     0      │    1     │ (empty)
```

#### ⚠️ Problem: Writer Starvation
In the Readers-Priority solution, if readers keep arriving, the writer may **never** get access. Solution: Writers-Priority or Fair Readers-Writers.

### 🏠 Real-World Analogy

| Concept | Analogy |
|---------|---------|
| Database | A whiteboard in a meeting room |
| Reader | People reading the whiteboard (multiple can read simultaneously) |
| Writer | Person erasing and rewriting (needs exclusive access) |
| Reader-writer conflict | Can't read while someone is rewriting — content is inconsistent |

---

## 7. Quick Summary

```
┌────────────────────────────────────────────────────────────────┐
│                 CHAPTER 4: QUICK REVISION                       │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ★ Race Condition = Unpredictable result due to concurrent     │
│    access to shared data                                       │
│                                                                │
│  ★ Critical Section = Code accessing shared resources          │
│    Requirements: Mutual Exclusion, Progress, Bounded Waiting   │
│                                                                │
│  ★ Mutex = Lock for mutual exclusion (owner releases)          │
│  ★ Semaphore = Integer with wait(P) and signal(V) operations   │
│    - Binary (0/1): like mutex                                  │
│    - Counting (0 to N): for N resources                        │
│  ★ Monitor = High-level construct with automatic ME            │
│                                                                │
│  CLASSICAL PROBLEMS:                                           │
│  ★ Producer-Consumer: Bounded buffer with empty/full counts    │
│    → Semaphores: mutex, empty=N, full=0                        │
│  ★ Dining Philosophers: 5 philosophers, 5 chopsticks           │
│    → Naive solution deadlocks! Use asymmetric/limit solutions  │
│  ★ Readers-Writers: Multiple readers OR one writer             │
│    → read_count tracks readers, first reader locks writers     │
│                                                                │
│  COMMON PITFALLS:                                              │
│  ★ Forgetting signal() → Deadlock                              │
│  ★ Wrong wait() order → Deadlock                               │
│  ★ Semaphore operations MUST be atomic                         │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 📝 Practice Questions

### 🟢 Level 1: One-Line Answer Questions

| # | Question | Answer |
|---|----------|--------|
| 1 | What is a race condition? | When multiple processes access shared data concurrently and the result depends on execution order. |
| 2 | What are the three requirements for a CS solution? | Mutual Exclusion, Progress, and Bounded Waiting. |
| 3 | What is a mutex? | A lock that provides mutual exclusion — only one process can hold it at a time. |
| 4 | What is a binary semaphore? | A semaphore with value 0 or 1, similar to a mutex. |
| 5 | What are the two operations on a semaphore? | wait() (P/down) to decrement and signal() (V/up) to increment. |
| 6 | What problem does the Dining Philosophers illustrate? | Deadlock — all philosophers pick up left chopstick and wait for right one forever. |
| 7 | In the Readers-Writers problem, can multiple readers read simultaneously? | Yes, multiple readers can access the shared data concurrently. |
| 8 | What is a monitor? | A high-level synchronization construct that encapsulates data and operations with automatic mutual exclusion. |
| 9 | What is a spinlock? | A lock where the waiting process continuously checks (spins) in a loop until the lock is available. |
| 10 | What is the Producer-Consumer problem? | Synchronizing a producer (adds items to buffer) and consumer (removes items) with a bounded buffer. |

---

### 🟡 Level 2: Multiple Choice Questions

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Which is NOT a requirement for CS solution? | A) Mutual Exclusion B) Progress C) **Speed** D) Bounded Waiting | **C** |
| 2 | A counting semaphore initialized to 5 means: | A) 5 processes waiting B) **5 resources available** C) 5 processes running D) Error | **B** |
| 3 | In Producer-Consumer, what causes consumer to wait? | A) mutex=0 B) empty=0 C) **full=0** D) mutex=1 | **C** |
| 4 | The Dining Philosophers can deadlock when: | A) All eat simultaneously B) **All pick up left chopstick** C) One philosopher eats D) No chopsticks | **B** |
| 5 | Mutex ownership means: | A) Any process can release B) **Only the acquirer can release** C) OS releases it D) It self-releases | **B** |
| 6 | Peterson's solution works for: | A) N processes B) **2 processes** C) 1 process D) Unlimited | **B** |
| 7 | In Readers-Writers, when can a writer write? | A) Always B) **When no readers and no other writers** C) When read_count < 5 D) Only at night | **B** |
| 8 | Signal operation on semaphore: | A) Decrements B) **Increments** C) Resets to 0 D) Doubles | **B** |
| 9 | Monitor ensures mutual exclusion: | A) Through semaphores B) Through busy wait C) **Automatically** D) Through priority | **C** |
| 10 | A spinlock wastes CPU because: | A) It sleeps B) **It loops checking the lock** C) It crashes D) It uses DMA | **B** |

---

### 🔴 Level 3: Tricky Conceptual MCQs

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | In Producer-Consumer, if we swap `wait(empty)` and `wait(mutex)` in producer, what happens? | A) Works fine B) Race condition C) **Deadlock possible** D) Faster execution | **C** | If buffer is full, producer holds mutex and blocks on empty. Consumer can't get mutex to consume → deadlock. |
| 2 | Binary semaphore and mutex are identical. | A) **False** B) True | **A** | Key difference: mutex has ownership — only the acquirer can release. Binary semaphore can be signaled by any process. |
| 3 | If signal() is called on a semaphore and no process is waiting, what happens? | A) Error B) Ignored C) **Semaphore value increments** D) System crash | **C** | The signal is "remembered" — the semaphore value increases, allowing a future wait() to succeed immediately. |
| 4 | Can a monitor's condition variable signal be lost? | A) No, always received B) **Yes, if no process is waiting** C) No, it's queued D) Depends on OS | **B** | Unlike semaphores, a monitor's signal() has no effect if no process is waiting on that condition — the signal is lost. |
| 5 | In Dining Philosophers, if one philosopher is left-handed (picks right first), deadlock is: | A) Guaranteed B) **Prevented** C) Unchanged D) Worse | **B** | Asymmetric picking breaks the circular wait condition, preventing deadlock. |

---

### 🔵 Level 4: True / False

| # | Statement | Answer | Explanation |
|---|-----------|--------|-------------|
| 1 | Race conditions can only occur in multiprocessor systems. | **False** | Race conditions can occur on single-processor systems with context switching. |
| 2 | Semaphore operations wait() and signal() must be atomic. | **True** | If not atomic, race conditions would occur on the semaphore itself! |
| 3 | A monitor can have multiple processes executing inside it simultaneously. | **False** | Only ONE process can be active inside a monitor at any time. |
| 4 | Starvation and deadlock are the same thing. | **False** | Deadlock: processes blocked forever waiting for each other. Starvation: one process waits indefinitely while others proceed. |
| 5 | The first reader in the Readers-Writers solution locks out all writers. | **True** | The first reader does `wait(rw_mutex)`, blocking all writers until the last reader signals. |
| 6 | Spinning (busy waiting) is always bad. | **False** | Spinlocks are efficient for very short critical sections (no context switch overhead). |
| 7 | Monitors use condition variables for waiting and signaling. | **True** | Condition variables (wait/signal) are the mechanism for process coordination inside monitors. |
| 8 | The Dining Philosophers problem has exactly one solution. | **False** | Multiple solutions exist: limit diners, asymmetric chopstick pickup, use monitor, etc. |
| 9 | A semaphore initialized to 0 means no resources are available. | **True** | Any process calling wait() on it will block until another process calls signal(). |
| 10 | In the Producer-Consumer problem, the producer waits when the buffer is empty. | **False** | The producer waits when the buffer is FULL. The consumer waits when the buffer is EMPTY. |

---

### 🟣 Level 5: Scenario-Based Questions

**Scenario 1:**
> Two bank ATM machines access the same account (balance = $1000). ATM-A deposits $500 and ATM-B withdraws $300. Without synchronization, what could go wrong? Design a solution.

**Answer:** Without synchronization (race condition):
- ATM-A reads balance = 1000, ATM-B reads balance = 1000
- ATM-A writes 1000+500 = 1500
- ATM-B writes 1000-300 = 700 (overwrites ATM-A's deposit!)
- Final balance: $700 instead of correct $1200

**Solution:** Use a mutex:
```
mutex_lock(account_lock);
balance = balance + amount;  // or balance - amount
mutex_unlock(account_lock);
```
This ensures only one ATM modifies the balance at a time.

---

**Scenario 2:**
> A print server has 3 printers. Multiple users submit print jobs. Describe the appropriate synchronization tool and its initialization.

**Answer:** Use a **counting semaphore** initialized to **3** (number of printers).
```
semaphore printers = 3;

void print_job(job) {
    wait(printers);    // printers-- ; blocks if printers=0
    // assign a printer, print the job
    signal(printers);  // printers++ ; release printer
}
```
When all 3 printers are busy (semaphore = 0), new jobs wait. When a printer finishes, signal() wakes up a waiting job.

---

**Scenario 3:**
> In a database system, 10 users are reading records while 1 user wants to update. Using the Readers-Writers solution, explain what happens to the writer.

**Answer:** The writer calls `wait(rw_mutex)` but rw_mutex is 0 (locked by the first reader). The writer **blocks** until all 10 readers finish. As each reader leaves, `read_count` decrements. When the last reader (read_count = 0) calls `signal(rw_mutex)`, the writer finally enters and performs the update. If new readers keep arriving before all 10 leave, the writer suffers **starvation**.

---

**Scenario 4:**
> In the Dining Philosophers problem, philosopher P0 picks up chopstick C4 (left) and then gets preempted. Then P1, P2, P3, P4 each pick up their left chopstick. Describe the system state.

**Answer:** **Deadlock!** The state is:
- P0 holds C4, waiting for C0
- P1 holds C0, waiting for C1
- P2 holds C1, waiting for C2
- P3 holds C2, waiting for C3
- P4 holds C3, waiting for C4 (held by P0)

This is a **circular wait** — one of the four necessary conditions for deadlock. No philosopher can proceed. The system is frozen.

---

**Scenario 5:**
> A programmer writes: `signal(S); /* CS */ wait(S);` instead of `wait(S); /* CS */ signal(S);`. What happens?

**Answer:** This is a **critical bug**:
1. `signal(S)` increments S beyond 1 (if S was initially 1, now S=2)
2. Critical Section executed without protection
3. `wait(S)` decrements S back

**Problem:** Multiple processes can enter the CS simultaneously because S > 1. **Mutual Exclusion is violated!** This defeats the entire purpose of the semaphore. Data corruption and race conditions will occur.

---

### 🟤 Level 6: Advanced Real-World Application Questions

**Q1. How does a database like MySQL handle concurrent transactions using locks?**

**Answer:** MySQL uses a **multi-level locking hierarchy** directly analogous to OS synchronization:

| Lock Type | OS Equivalent | MySQL Usage |
|-----------|--------------|-------------|
| Table lock | Mutex (coarse-grained) | `LOCK TABLES t WRITE` |
| Row lock | Fine-grained mutex | InnoDB row-level locking |
| Shared lock (S) | Reader lock (Readers-Writers) | `SELECT ... LOCK IN SHARE MODE` |
| Exclusive lock (X) | Writer lock | `UPDATE`, `DELETE`, `INSERT` |
| Gap lock | Predicate lock | Prevents phantom reads |
| Deadlock detection | Banker's algorithm equivalent | InnoDB detects cycles in wait-for graph |

**Real scenario**: Two transactions updating the same bank account simultaneously:
```sql
-- Transaction T1                 -- Transaction T2
BEGIN;                            BEGIN;
SELECT balance WHERE id=1;        SELECT balance WHERE id=1;
-- Both read balance=1000
UPDATE SET balance=1500 WHERE id=1; UPDATE SET balance=700 WHERE id=1;
COMMIT;                           COMMIT;  -- LOST UPDATE without locking!
```
InnoDB prevents this with row locks — T2's UPDATE blocks until T1 commits.

---

**Q2. Java's `synchronized` keyword — map it to OS synchronization primitives.**

**Answer:**

```java
// Java synchronized method → OS Mutex
public synchronized void deposit(int amount) {
    balance += amount;  // Critical Section
}

// Java synchronized block → OS Mutex with finer granularity
public void transfer(Account to, int amount) {
    synchronized(this) {        // Lock on 'this' object
        this.balance -= amount;
    }
    synchronized(to) {          // Lock on 'to' object  
        to.balance += amount;   // Danger: lock ordering matters!
    }
}

// Java ReentrantLock → OS Mutex with tryLock() (polling)
Lock lock = new ReentrantLock();
if (lock.tryLock(50, TimeUnit.MILLISECONDS)) {
    try { /* critical section */ } finally { lock.unlock(); }
}
```

**Deadlock risk in Java**: If Thread A holds `lock(accountA)` and tries `lock(accountB)`, while Thread B holds `lock(accountB)` and tries `lock(accountA)` — **deadlock**! Solution: always acquire locks in the same order (resource ordering).

---

**Q3. How does the Linux kernel implement mutexes differently from user-space mutexes (futex)?**

**Answer:**

```
USER-SPACE (futex — fast userspace mutex):
┌─────────────────────────────────────────────────────────┐
│  Fast path: Atomic compare-and-swap in user memory      │
│  If lock is FREE: acquire without any system call ✓     │
│  If lock is TAKEN: call Linux futex() syscall → wait    │
│                    (kernel puts thread to sleep)         │
│  Unlock: if no waiters → just clear in user memory      │
│          if waiters → futex() syscall to wake one        │
└─────────────────────────────────────────────────────────┘

KERNEL-SPACE (kernel mutex):
┌─────────────────────────────────────────────────────────┐
│  Always operates in kernel context                       │
│  Uses spinlock briefly to protect mutex state            │
│  Sleeping allowed (unlike spinlocks)                     │
│  Cannot be used from interrupt context                   │
└─────────────────────────────────────────────────────────┘
```

**Why futex is fast**: `pthread_mutex_lock()` in Linux uses futex — in the uncontended case (no other thread holds the lock), it's just an **atomic memory operation** — no kernel entry, zero system call overhead. Only when contended does it call the kernel. This makes mutex acquisition ~10ns vs ~1000ns for a full system call.

---

**Q4. The "Lost Update" problem in databases is identical to a race condition. Solve it using semaphores.**

**Answer:** 

**The problem**:
```
Thread A (Withdraw $200)        Thread B (Deposit $500)
1. read balance = 1000          1. read balance = 1000
2. balance = 1000 - 200 = 800   2. balance = 1000 + 500 = 1500
3. write balance = 800          3. write balance = 1500  ← WRONG!
Final: 1500, should be 1300
```

**Solution using semaphore**:
```
semaphore mutex = 1;

void withdraw(int amount):
    wait(mutex)           // P operation
    balance = balance - amount
    signal(mutex)         // V operation

void deposit(int amount):
    wait(mutex)
    balance = balance + amount
    signal(mutex)
```

**Industry solution**: Databases use **MVCC (Multi-Version Concurrency Control)** — readers don't block writers, each transaction sees a consistent snapshot. PostgreSQL, Oracle, MySQL InnoDB all use MVCC. This is far more efficient than simple mutex locking for read-heavy workloads.

---

**Q5. Explain how the OS prevents priority inversion in real-time systems (Mars Pathfinder bug).**

**Answer:** The **Mars Pathfinder** (1997) suffered a famous priority inversion bug:

```
Priority levels:
• High priority:   Meteorological data task (H)
• Medium priority: Communication task (M)  
• Low priority:    Information bus task (L) — holds shared mutex

Timeline:
1. L acquires mutex on shared bus
2. H preempts L (needs the bus mutex) → H BLOCKS
3. M preempts L (medium priority, doesn't need mutex)
4. M runs indefinitely → L never runs → Mutex never released → H waits forever!

This is PRIORITY INVERSION: High priority task blocked by medium priority task
```

**Solution — Priority Inheritance Protocol**:
```
When H blocks on mutex held by L:
→ OS temporarily raises L's priority to H's level
→ L now runs at H's priority (can't be preempted by M)
→ L releases mutex quickly
→ L's priority returns to normal
→ H acquires mutex and runs
```

This is implemented in FreeRTOS, VxWorks, and Linux's `PTHREAD_PRIO_INHERIT` mutex attribute. **The Pathfinder fix**: Enable VxWorks priority inheritance flag — a one-line configuration change that was patched remotely to a spacecraft 170 million km away.

---

**Q6. Design a thread-safe bounded blocking queue (like Java's `ArrayBlockingQueue`).**

**Answer:**

```
Semaphores needed:
• mutex = 1         (mutual exclusion on queue operations)
• empty = N         (slots available for producers; initially N = buffer size)
• full  = 0         (items available for consumers; initially 0)

ENQUEUE (Producer):
    wait(empty)        // Wait if buffer is full
    wait(mutex)        // Lock queue
    add item to queue
    signal(mutex)      // Unlock queue
    signal(full)       // Notify consumers

DEQUEUE (Consumer):
    wait(full)         // Wait if buffer is empty
    wait(mutex)        // Lock queue
    remove item from queue
    signal(mutex)      // Unlock queue
    signal(empty)      // Notify producers
```

**Real-world use**: Java's `ArrayBlockingQueue` is used in thread pools (`ExecutorService`). Producer threads submit tasks, consumer (worker) threads execute them. The bounded size prevents memory overflow when producers outpace consumers. This exact semaphore pattern is used internally.

---

> **← [Previous: 03 - Threads and CPU](03_Threads_and_CPU.md) | [Next: 05 - Deadlocks →](05_Deadlocks.md)**
