# 📘 Chapter 5: Deadlocks

> **"A deadlock is a situation where a set of processes are blocked because each process is holding a resource and waiting for a resource held by another process."**

---

## 📑 Table of Contents

| # | Topic |
|---|-------|
| 1 | [What is a Deadlock?](#1-what-is-a-deadlock) |
| 2 | [Necessary Conditions for Deadlock](#2-necessary-conditions-for-deadlock) |
| 3 | [Resource Allocation Graph](#3-resource-allocation-graph) |
| 4 | [Deadlock Handling Methods](#4-deadlock-handling-methods) |
| 5 | [Deadlock Prevention](#5-deadlock-prevention) |
| 6 | [Deadlock Avoidance — Banker's Algorithm](#6-deadlock-avoidance--bankers-algorithm) |
| 7 | [Deadlock Detection and Recovery](#7-deadlock-detection-and-recovery) |
| 8 | [Quick Summary](#8-quick-summary) |
| 9 | [Practice Questions](#-practice-questions) |

---

## 1. What is a Deadlock?

### 📖 Concept Explanation

A **Deadlock** occurs when two or more processes are **permanently blocked**, each waiting for a resource held by another process in the set. No process can proceed, release resources, or be preempted.

```
    DEADLOCK: Two Processes, Two Resources
    
    Process P1                 Process P2
    ┌──────────────┐           ┌──────────────┐
    │ Holds: R1    │           │ Holds: R2    │
    │ Wants: R2  ──┼──────────►│              │
    │              │           │ Wants: R1  ──┼────┐
    └──────────────┘           └──────────────┘    │
          ▲                                        │
          │                                        │
          └────────────────────────────────────────┘
    
    P1 holds R1, needs R2 (held by P2)
    P2 holds R2, needs R1 (held by P1)
    NEITHER can proceed → DEADLOCK! 🔒
```

### 🏠 Real-World Analogy

```
    TRAFFIC DEADLOCK (4-way intersection):
    
                 │ Car B │
                 │   ↓   │
         ────────┤       ├────────
         Car A → │ STUCK │ ← Car D
         ────────┤       ├────────
                 │   ↑   │
                 │ Car C │
    
    Car A waits for Car B to move
    Car B waits for Car D to move
    Car D waits for Car C to move
    Car C waits for Car A to move
    → CIRCULAR WAIT → DEADLOCK!
    
    Other analogies:
    • Two trains on the same track coming from opposite directions
    • Two people in a narrow hallway, neither willing to step aside
    • Lawyers: "I'll sign if you sign first" — both wait forever
```

### ⚡ Important Points

- Deadlock is different from **starvation** (starvation = indefinite waiting, but the system is still making progress)
- Deadlock involves a **set of processes**, not just one
- Deadlocks can occur with any type of resource: CPU, memory, files, I/O devices, semaphores
- All modern OS must handle deadlocks in some way

---

## 2. Necessary Conditions for Deadlock

### 📖 The Four Coffman Conditions

A deadlock can occur **if and only if** ALL FOUR of the following conditions hold simultaneously:

```
    ┌────────────────────────────────────────────────────────────┐
    │          FOUR NECESSARY CONDITIONS FOR DEADLOCK             │
    │          (ALL must hold simultaneously)                     │
    ├────────────────────────────────────────────────────────────┤
    │                                                            │
    │  1. MUTUAL EXCLUSION                                       │
    │     ─────────────────                                      │
    │     At least one resource must be held in a                │
    │     non-sharable mode (only one process at a time)         │
    │                                                            │
    │     🏠 Only one person can use the bathroom               │
    │                                                            │
    │  2. HOLD AND WAIT                                          │
    │     ─────────────                                          │
    │     A process holding at least one resource is             │
    │     waiting to acquire additional resources held           │
    │     by other processes                                     │
    │                                                            │
    │     🏠 You hold the fork and wait for the knife           │
    │                                                            │
    │  3. NO PREEMPTION                                          │
    │     ─────────────                                          │
    │     Resources cannot be forcibly taken away from           │
    │     a process; they can only be released voluntarily       │
    │                                                            │
    │     🏠 Can't snatch the fork from someone's hand          │
    │                                                            │
    │  4. CIRCULAR WAIT                                          │
    │     ─────────────                                          │
    │     There exists a set {P0, P1, ..., Pn} such that:       │
    │     P0 waits for P1, P1 waits for P2, ...,                │
    │     Pn waits for P0                                        │
    │                                                            │
    │     🏠 A circle of people each waiting for the            │
    │        person next to them to return something             │
    │                                                            │
    └────────────────────────────────────────────────────────────┘
    
    If ANY ONE condition is broken → Deadlock CANNOT occur
```

### Visual Representation

```
    CONDITION CHECK:
    
    ┌──────────────────┐  ┌──────────────────┐
    │ Mutual Exclusion │  │ Hold and Wait    │
    │       ✓          │  │       ✓          │
    └────────┬─────────┘  └────────┬─────────┘
             │                     │
             └──────────┬──────────┘
                        │
                   DEADLOCK?
                        │
             ┌──────────┴──────────┐
             │                     │
    ┌────────┴─────────┐  ┌───────┴──────────┐
    │ No Preemption    │  │ Circular Wait    │
    │       ✓          │  │       ✓          │
    └──────────────────┘  └──────────────────┘
    
    All FOUR ✓ → DEADLOCK!
    Even ONE ✗ → No deadlock possible
```

---

## 3. Resource Allocation Graph

### 📖 Concept Explanation

A **Resource Allocation Graph (RAG)** is a directed graph used to visualize and detect deadlocks.

```
    RAG NOTATION:
    
    ┌─────┐
    │ Pi  │     Circle/Oval = PROCESS
    └─────┘
    
    ┌─────┐
    │ Rj  │     Rectangle/Square = RESOURCE TYPE
    │ • • │     Dots inside = Number of instances
    └─────┘
    
    Pi ──────► Rj    REQUEST EDGE: Pi is waiting for Rj
    
    Rj ──────► Pi    ASSIGNMENT EDGE: Rj is allocated to Pi
```

### Example: No Deadlock

```
    ┌────┐         ┌────┐
    │ P1 │────────►│ R1 │
    └────┘         │ •  │──────────►┌────┐
                   └────┘           │ P2 │
    ┌────┐                          └──┬─┘
    │ R2 │──────────►┌────┐            │
    │ •  │           │ P3 │            │
    └──┬─┘           └────┘            │
       │                               │
       └───────────────────────────────┘
    
    P1 requests R1
    R1 is assigned to P2
    R2 is assigned to P3
    P2 holds R1, requests R2... but R2 has instance assigned to P3
    
    No cycle → NO DEADLOCK ✓
```

### Example: Deadlock

```
    ┌────┐    request    ┌────┐
    │ P1 │──────────────►│ R1 │
    └────┘               │ •  │
      ▲                  └──┬─┘
      │ assigned            │ assigned
      │                     ▼
    ┌─┴──┐               ┌────┐
    │ R2 │◄──────────────│ P2 │
    │ •  │    request     └────┘
    └────┘
    
    P1 → R1 → P2 → R2 → P1   (CYCLE!)
    
    R1 and R2 each have 1 instance → DEADLOCK!
    
    
    IMPORTANT: Cycle with single-instance resources → ALWAYS deadlock
               Cycle with multi-instance resources → MAY or MAY NOT deadlock
```

### Multi-Instance Example (Cycle but NO Deadlock)

```
    ┌────┐    request    ┌──────┐
    │ P1 │──────────────►│  R1  │
    └────┘               │ •  • │ ← 2 instances
      ▲                  └┬───┬─┘
      │ assigned          │   │ assigned
      │                   │   ▼
    ┌─┴──┐               │ ┌────┐
    │ R2 │               │ │ P2 │
    │ •  │◄──────────────┘ └──┬─┘
    └────┘    assigned        │
                              │ request
    ┌────┐                    ▼
    │ P3 │◄──────── R1 instance 2 is assigned to P3
    └────┘
    
    Cycle: P1 → R1 → P2 → R2 → P1
    BUT: P3 holds R1 instance 2 and might release it
    → P1 can then acquire R1 → No deadlock!
```

---

## 4. Deadlock Handling Methods

### 📖 Four Approaches

```
    ┌────────────────────────────────────────────────────────────┐
    │            DEADLOCK HANDLING STRATEGIES                     │
    ├────────────────────────────────────────────────────────────┤
    │                                                            │
    │  1. DEADLOCK PREVENTION                                    │
    │     → Ensure at least one of the 4 conditions              │
    │       cannot hold (proactive)                              │
    │     → Example: Always request all resources at once        │
    │                                                            │
    │  2. DEADLOCK AVOIDANCE                                     │
    │     → Use information about future resource needs          │
    │       to avoid unsafe states (e.g., Banker's Algorithm)    │
    │     → Example: Bank doesn't loan more than deposits       │
    │                                                            │
    │  3. DEADLOCK DETECTION + RECOVERY                          │
    │     → Allow deadlocks to occur, detect them,              │
    │       then recover                                         │
    │     → Example: Kill a process or take resources back       │
    │                                                            │
    │  4. IGNORE THE PROBLEM (Ostrich Algorithm)                 │
    │     → Pretend deadlocks never happen                       │
    │     → Used by most general-purpose OS!                     │
    │     → If deadlock occurs, user reboots                     │
    │     → Example: Windows, Linux (for most resources)         │
    │                                                            │
    └────────────────────────────────────────────────────────────┘
```

### 🏠 Real-World Analogy

| Method | Analogy |
|--------|---------|
| Prevention | Remove all sharp objects from a room so no one can get cut |
| Avoidance | Check the weather before going out (avoid getting wet) |
| Detection + Recovery | Buy umbrella after it starts raining |
| Ignore | Hope it doesn't rain (Ostrich: head in sand) |

---

## 5. Deadlock Prevention

Break at least ONE of the four necessary conditions:

```
    ┌──────────────────────────────────────────────────────────────┐
    │                DEADLOCK PREVENTION                            │
    ├──────────────────┬───────────────────────────────────────────┤
    │ Condition        │ How to Prevent                            │
    ├──────────────────┼───────────────────────────────────────────┤
    │                  │                                           │
    │ 1. Mutual        │ Make resources SHARABLE                   │
    │    Exclusion     │ (impossible for many resources like       │
    │                  │ printers, but possible for read-only      │
    │                  │ files)                                    │
    │                  │                                           │
    │ 2. Hold and Wait │ Request ALL resources before starting     │
    │                  │ (or release all before requesting new)    │
    │                  │                                           │
    │                  │ Problem: Low resource utilization,        │
    │                  │ starvation possible                       │
    │                  │                                           │
    │ 3. No Preemption │ If a process can't get a resource,       │
    │                  │ RELEASE all its current resources         │
    │                  │                                           │
    │                  │ Or: OS can forcibly take resources from   │
    │                  │ a lower-priority process                  │
    │                  │                                           │
    │ 4. Circular Wait │ Force an ORDERING on resource types       │
    │                  │ (R1 < R2 < R3...). Request in order only │
    │                  │                                           │
    │                  │ If you hold R3, you can only request      │
    │                  │ R4, R5, ... (not R1, R2)                  │
    │                  │                                           │
    └──────────────────┴───────────────────────────────────────────┘
```

### Circular Wait Prevention — Resource Ordering

```
    RESOURCE ORDERING EXAMPLE:
    
    Assign numbers: R1=1, R2=2, R3=3, R4=4
    
    RULE: Always request resources in INCREASING order
    
    Process A: Needs R1, R3   → Request R1, then R3 ✓
    Process B: Needs R3, R1   → Must request R1 first, then R3 ✓
    
    Without ordering (Deadlock possible):
    A holds R1, wants R3
    B holds R3, wants R1  → CIRCULAR WAIT!
    
    With ordering (No circular wait):
    Both request R1 first → one gets it, other waits
    The one with R1 then gets R3
    No circular dependency! ✓
```

### Prevention Trade-offs

| Condition Broken | Method | Practicality | Cost |
|------------------|--------|-------------|------|
| Mutual Exclusion | Make resources sharable | ❌ Usually impossible | N/A |
| Hold and Wait | Request all at once | ⚠️ Low utilization | High |
| No Preemption | Forcibly take resources | ⚠️ Only for some resources | Medium |
| Circular Wait | Resource ordering | ✅ Most practical | Low |

---

## 6. Deadlock Avoidance — Banker's Algorithm

### 📖 Concept Explanation

**Deadlock Avoidance** allows the system to stay in a **safe state** at all times by checking every resource request before granting it. The key concept is the **Safe State**.

```
    ┌──────────────────────────────────────────────────────┐
    │                 STATE TYPES                            │
    ├──────────────────────────────────────────────────────┤
    │                                                      │
    │  SAFE STATE                                          │
    │  ──────────                                          │
    │  A state where there exists at least ONE SEQUENCE    │
    │  in which all processes can finish successfully.     │
    │                                                      │
    │  Example: Safe sequence <P1, P3, P2>                 │
    │  → P1 can finish, releases resources                 │
    │  → P3 uses released + its own, finishes              │
    │  → P2 uses released + its own, finishes              │
    │                                                      │
    │  UNSAFE STATE                                        │
    │  ────────────                                        │
    │  No guaranteed safe sequence exists.                  │
    │  Deadlock MAY (not necessarily will) occur.           │
    │                                                      │
    │         ┌──────────────────────────────────┐         │
    │         │         ALL STATES               │         │
    │         │  ┌────────────────────────────┐  │         │
    │         │  │       SAFE STATES          │  │         │
    │         │  │  (Guaranteed no deadlock)  │  │         │
    │         │  └────────────────────────────┘  │         │
    │         │  ┌────────────────────────────┐  │         │
    │         │  │   UNSAFE STATES            │  │         │
    │         │  │ ┌───────────────────────┐  │  │         │
    │         │  │ │  DEADLOCKED STATES    │  │  │         │
    │         │  │ │  (Subset of unsafe)   │  │  │         │
    │         │  │ └───────────────────────┘  │  │         │
    │         │  └────────────────────────────┘  │         │
    │         └──────────────────────────────────┘         │
    │                                                      │
    │  KEY: Safe → definitely no deadlock                  │
    │       Unsafe → might deadlock (not guaranteed)       │
    │       Deadlock ⊂ Unsafe                              │
    │                                                      │
    └──────────────────────────────────────────────────────┘
```

### 🏠 Real-World Analogy — The Banker

```
    THE BANKER'S ANALOGY:
    
    A banker has $10 total to lend.
    
    Customer A: Needs max $6, currently borrowed $3
    Customer B: Needs max $5, currently borrowed $2
    Customer C: Needs max $4, currently borrowed $2
    
    Money lent out: 3 + 2 + 2 = $7
    Available: 10 - 7 = $3
    
    SAFE SEQUENCE: <B, C, A>
    → B needs 5-2 = $3 more. Available=$3 → Grant! B finishes, returns $5
    → Available = $3 + $5 = $8
    → C needs 4-2 = $2 more. Available=$8 → Grant! C finishes, returns $4
    → Available = $8 + $4 = $12
    → A needs 6-3 = $3 more. Available=$12 → Grant! A finishes
    
    ✓ SAFE STATE — everyone can be satisfied!
```

### Banker's Algorithm — Data Structures

```
    Given: n processes, m resource types
    
    ┌──────────────────────────────────────────────────────────┐
    │                                                          │
    │  Available[m]:  Available instances of each resource type│
    │                 Available = [3, 3, 2]                    │
    │                            (A  B  C)                     │
    │                                                          │
    │  Max[n][m]:     Maximum demand of each process           │
    │                 Max[i][j] = max instances of Rj           │
    │                 that Pi may need                          │
    │                                                          │
    │  Allocation[n][m]: Currently allocated resources         │
    │                    Allocation[i][j] = instances of Rj     │
    │                    currently assigned to Pi               │
    │                                                          │
    │  Need[n][m]:   Remaining need of each process            │
    │                Need[i][j] = Max[i][j] - Allocation[i][j]  │
    │                                                          │
    └──────────────────────────────────────────────────────────┘
```

### 📝 Banker's Algorithm — Complete Solved Example

#### Problem Setup

```
    System has 3 resource types: A, B, C
    Total instances: A=10, B=5, C=7
    
    5 Processes: P0, P1, P2, P3, P4
```

| Process | Allocation (A B C) | Max (A B C) | Need (A B C) |
|---------|-------------------|-------------|--------------|
| P0 | 0 1 0 | 7 5 3 | 7 4 3 |
| P1 | 2 0 0 | 3 2 2 | 1 2 2 |
| P2 | 3 0 2 | 9 0 2 | 6 0 0 |
| P3 | 2 1 1 | 2 2 2 | 0 1 1 |
| P4 | 0 0 2 | 4 3 3 | 4 3 1 |

```
    Total Allocated = (0+2+3+2+0, 1+0+0+1+0, 0+0+2+1+2) = (7, 2, 5)
    Available = Total - Allocated = (10-7, 5-2, 7-5) = (3, 3, 2)
```

#### Step-by-Step Safety Algorithm

```
    SAFETY ALGORITHM:
    
    Work = Available = [3, 3, 2]
    Finish = [false, false, false, false, false]
    
    ITERATION 1: Find a process Pi where Need[i] ≤ Work and Finish[i]=false
    
    Check P0: Need=[7,4,3] ≤ Work=[3,3,2]? NO (7>3)
    Check P1: Need=[1,2,2] ≤ Work=[3,3,2]? YES ✓
    
    → Execute P1:
      Work = Work + Allocation[1] = [3,3,2] + [2,0,0] = [5, 3, 2]
      Finish[1] = true
      Safe sequence so far: <P1>
    
    ITERATION 2:
    Check P0: Need=[7,4,3] ≤ Work=[5,3,2]? NO (7>5)
    Check P2: Need=[6,0,0] ≤ Work=[5,3,2]? NO (6>5)
    Check P3: Need=[0,1,1] ≤ Work=[5,3,2]? YES ✓
    
    → Execute P3:
      Work = [5,3,2] + [2,1,1] = [7, 4, 3]
      Finish[3] = true
      Safe sequence: <P1, P3>
    
    ITERATION 3:
    Check P0: Need=[7,4,3] ≤ Work=[7,4,3]? YES ✓
    
    → Execute P0:
      Work = [7,4,3] + [0,1,0] = [7, 5, 3]
      Finish[0] = true
      Safe sequence: <P1, P3, P0>
    
    ITERATION 4:
    Check P2: Need=[6,0,0] ≤ Work=[7,5,3]? YES ✓
    
    → Execute P2:
      Work = [7,5,3] + [3,0,2] = [10, 5, 5]
      Finish[2] = true
      Safe sequence: <P1, P3, P0, P2>
    
    ITERATION 5:
    Check P4: Need=[4,3,1] ≤ Work=[10,5,5]? YES ✓
    
    → Execute P4:
      Work = [10,5,5] + [0,0,2] = [10, 5, 7]
      Finish[4] = true
      Safe sequence: <P1, P3, P0, P2, P4>
    
    ┌─────────────────────────────────────────────────────┐
    │  All processes finished! SAFE STATE ✓                │
    │  Safe Sequence: <P1, P3, P0, P2, P4>                │
    └─────────────────────────────────────────────────────┘
```

#### Resource Request Algorithm

When process Pi requests resources Request[i]:

```
    RESOURCE REQUEST ALGORITHM:
    
    1. If Request[i] ≤ Need[i], go to step 2
       Else: ERROR (exceeded maximum claim)
    
    2. If Request[i] ≤ Available, go to step 3
       Else: Pi must WAIT (resources not available)
    
    3. PRETEND to allocate (tentatively):
       Available = Available - Request[i]
       Allocation[i] = Allocation[i] + Request[i]
       Need[i] = Need[i] - Request[i]
    
    4. Run SAFETY ALGORITHM:
       If SAFE → Grant the request ✓
       If UNSAFE → Revert changes, Pi must WAIT ✗
```

#### Example: Can P1 request (1, 0, 2)?

```
    P1 requests: Request = [1, 0, 2]
    
    Step 1: Request=[1,0,2] ≤ Need[1]=[1,2,2]? YES ✓
    Step 2: Request=[1,0,2] ≤ Available=[3,3,2]? YES ✓
    
    Step 3: Tentatively allocate:
      Available = [3,3,2] - [1,0,2] = [2, 3, 0]
      Allocation[1] = [2,0,0] + [1,0,2] = [3, 0, 2]
      Need[1] = [1,2,2] - [1,0,2] = [0, 2, 0]
    
    Step 4: Run safety check with new state:
      Work = [2, 3, 0]
      
      Check P1: Need=[0,2,0] ≤ [2,3,0]? YES → Work=[5,3,2] ✓
      Check P3: Need=[0,1,1] ≤ [5,3,2]? YES → Work=[7,4,3] ✓
      Check P0: Need=[7,4,3] ≤ [7,4,3]? YES → Work=[7,5,3] ✓
      Check P2: Need=[6,0,0] ≤ [7,5,3]? YES → Work=[10,5,5] ✓
      Check P4: Need=[4,3,1] ≤ [10,5,5]? YES → Work=[10,5,7] ✓
      
      All finish → SAFE! → GRANT request ✓
      Safe sequence: <P1, P3, P0, P2, P4>
```

#### Example: Can P4 request (3, 3, 0)?

```
    P4 requests: Request = [3, 3, 0]
    
    Step 1: Request=[3,3,0] ≤ Need[4]=[4,3,1]? YES ✓
    Step 2: Request=[3,3,0] ≤ Available=[3,3,2]? YES ✓
    
    Step 3: Tentatively:
      Available = [3,3,2] - [3,3,0] = [0, 0, 2]
      Allocation[4] = [0,0,2] + [3,3,0] = [3, 3, 2]
      Need[4] = [4,3,1] - [3,3,0] = [1, 0, 1]
    
    Step 4: Safety check with Work = [0, 0, 2]:
      Check P0: Need=[7,4,3] ≤ [0,0,2]? NO
      Check P1: Need=[1,2,2] ≤ [0,0,2]? NO (1>0)
      Check P2: Need=[6,0,0] ≤ [0,0,2]? NO (6>0)
      Check P3: Need=[0,1,1] ≤ [0,0,2]? NO (1>0)
      Check P4: Need=[1,0,1] ≤ [0,0,2]? NO (1>0)
      
      No process can finish → UNSAFE! → DENY request ✗
      P4 must WAIT.
```

---

## 7. Deadlock Detection and Recovery

### 📖 Detection

Instead of preventing or avoiding deadlocks, allow them to happen, then **detect** and **recover**.

```
    DETECTION ALGORITHM (Similar to Safety Algorithm):
    
    1. Initialize Work = Available
    2. For each process Pi:
       If Allocation[i] ≠ 0 and Request[i] ≤ Work:
         Work = Work + Allocation[i]
         Finish[i] = true
    3. Repeat step 2 until no more changes
    4. If any Finish[i] == false → DEADLOCK (those processes are deadlocked)
    
    
    WHEN TO RUN DETECTION?
    ┌────────────────────────────────────────────────────┐
    │ • Every time a resource request is denied          │
    │   (accurate but expensive)                        │
    │                                                    │
    │ • Periodically (e.g., every 5 minutes)            │
    │   (less overhead but delayed detection)            │
    │                                                    │
    │ • When CPU utilization drops below threshold       │
    │   (sign of potential deadlock)                     │
    └────────────────────────────────────────────────────┘
```

### Recovery Methods

```
    ┌────────────────────────────────────────────────────────────┐
    │              DEADLOCK RECOVERY METHODS                      │
    ├────────────────────────────────────────────────────────────┤
    │                                                            │
    │  METHOD 1: PROCESS TERMINATION                             │
    │  ─────────────────────────────                             │
    │                                                            │
    │  Option A: Kill ALL deadlocked processes                   │
    │            ✓ Simple                                        │
    │            ✗ Expensive (lots of lost work)                 │
    │                                                            │
    │  Option B: Kill ONE process at a time until deadlock       │
    │            is resolved                                      │
    │            ✓ Preserves more work                           │
    │            ✗ Must check for deadlock after each kill       │
    │            ✗ Which process to kill? (selection criteria)   │
    │                                                            │
    │  Selection criteria:                                       │
    │  • Priority of the process                                 │
    │  • How long it has been running                            │
    │  • How many resources it holds                             │
    │  • How many resources it still needs                       │
    │  • Is it interactive or batch?                             │
    │                                                            │
    ├────────────────────────────────────────────────────────────┤
    │                                                            │
    │  METHOD 2: RESOURCE PREEMPTION                             │
    │  ─────────────────────────────                             │
    │                                                            │
    │  Take resources from some processes, give to others:       │
    │                                                            │
    │  Issues:                                                   │
    │  • Selecting a victim (which process to preempt)           │
    │  • Rollback (how far to roll back the victim process)      │
    │  • Starvation (same process always selected as victim)     │
    │                                                            │
    └────────────────────────────────────────────────────────────┘
```

---

## 8. Quick Summary

```
┌────────────────────────────────────────────────────────────────┐
│                 CHAPTER 5: QUICK REVISION                       │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ★ Deadlock = Set of processes each waiting for resources      │
│    held by another process in the set                          │
│                                                                │
│  ★ Four Necessary Conditions (ALL must hold):                  │
│    1. Mutual Exclusion   3. No Preemption                      │
│    2. Hold and Wait      4. Circular Wait                      │
│                                                                │
│  ★ RAG: Cycle with single-instance → Deadlock                 │
│         Cycle with multi-instance → Maybe deadlock             │
│                                                                │
│  ★ Handling Strategies:                                        │
│    Prevention: Break one condition (best: resource ordering)   │
│    Avoidance: Banker's Algorithm (safe state check)            │
│    Detection: Allow deadlock, then detect & recover            │
│    Ignore: Ostrich approach (Linux/Windows default)            │
│                                                                │
│  ★ Banker's Algorithm:                                         │
│    Need = Max - Allocation                                     │
│    Available = Total - Σ Allocation                            │
│    Safe = ∃ sequence where all processes can finish             │
│                                                                │
│  ★ Recovery: Kill processes or preempt resources               │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 📝 Practice Questions

### 🟢 Level 1: One-Line Answer Questions

| # | Question | Answer |
|---|----------|--------|
| 1 | What is a deadlock? | A situation where processes are permanently blocked, each waiting for resources held by others. |
| 2 | Name the four necessary conditions for deadlock. | Mutual Exclusion, Hold and Wait, No Preemption, Circular Wait. |
| 3 | What is a safe state? | A state where there exists at least one sequence in which all processes can finish. |
| 4 | What is the Banker's Algorithm used for? | Deadlock avoidance — it checks if granting a request keeps the system in a safe state. |
| 5 | How is Need calculated in Banker's Algorithm? | Need = Max - Allocation. |
| 6 | What does a cycle in a RAG with single-instance resources indicate? | Deadlock exists. |
| 7 | What is the Ostrich Algorithm? | Ignoring deadlocks and hoping they don't occur (used by most general-purpose OS). |
| 8 | How can circular wait be prevented? | By imposing a total ordering on resources and requiring processes to request in order. |
| 9 | What is resource preemption in deadlock recovery? | Forcibly taking resources from a process to break the deadlock. |
| 10 | Is an unsafe state the same as a deadlock? | No — unsafe means deadlock MAY occur; it doesn't guarantee deadlock. |

---

### 🟡 Level 2: Multiple Choice Questions

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Which is NOT a necessary condition for deadlock? | A) Mutual Exclusion B) Hold and Wait C) **Aging** D) Circular Wait | **C** |
| 2 | Banker's Algorithm is used for deadlock: | A) Prevention B) **Avoidance** C) Detection D) Recovery | **B** |
| 3 | If a RAG has no cycle, the system is in: | A) Deadlock B) **Safe state** C) Unsafe state D) Cannot determine | **B** |
| 4 | In Banker's Algorithm, Need[i] = ? | A) Max[i] + Allocation[i] B) **Max[i] - Allocation[i]** C) Available - Max[i] D) Allocation[i] | **B** |
| 5 | Breaking which condition is most practical for prevention? | A) Mutual Exclusion B) Hold and Wait C) No Preemption D) **Circular Wait** | **D** |
| 6 | Most general-purpose OS handle deadlocks by: | A) Prevention B) Avoidance C) Detection D) **Ignoring them** | **D** |
| 7 | A cycle in RAG with multiple-instance resources means: | A) Deadlock B) No deadlock C) **Possibly deadlock** D) Error | **C** |
| 8 | In deadlock recovery, selecting a victim means: | A) Creating new resource B) **Choosing which process to terminate** C) Adding more CPU D) Rebooting | **B** |
| 9 | Safe state guarantees: | A) No starvation B) **No deadlock** C) Fast execution D) No context switch | **B** |
| 10 | Hold and Wait can be prevented by: | A) **Requesting all resources at once** B) Adding more resources C) Killing processes D) Increasing priority | **A** |

---

### 🔴 Level 3: Tricky Conceptual MCQs

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | If we remove Mutual Exclusion, deadlock is prevented. Is this always feasible? | A) Yes B) **No — some resources are inherently non-sharable** C) Only on Linux D) Only for files | **B** | Printers, write-mode files, etc. cannot be shared. ME can't be eliminated for such resources. |
| 2 | A system is in an unsafe state. Which is true? | A) Deadlock has occurred B) **Deadlock may occur** C) Deadlock cannot occur D) System must reboot | **B** | Unsafe ≠ deadlock. It means there's no guaranteed safe sequence, but processes might still finish if they release resources. |
| 3 | Banker's Algorithm requires knowing Max needs in advance. This is: | A) Always possible B) Easy to determine C) **A significant practical limitation** D) Not required | **C** | In real systems, processes often don't know their maximum resource needs upfront, making Banker's impractical for general-purpose OS. |
| 4 | In the RAG, if all resources have single instances, the absence of a cycle means: | A) Deadlock B) **No deadlock** C) Unsafe state D) Cannot determine | **B** | For single-instance resources: cycle ↔ deadlock. No cycle = no deadlock. |
| 5 | A process requests resources in order R1→R3→R5. Another requests R2→R4→R5. Can circular wait occur? | A) Yes B) **No — both follow increasing order** C) Depends on timing D) Only if preemptive | **B** | Both follow increasing resource order (1<3<5 and 2<4<5). Resource ordering eliminates circular wait. |

---

### 🔵 Level 4: True / False

| # | Statement | Answer | Explanation |
|---|-----------|--------|-------------|
| 1 | Deadlock can occur if only three of the four necessary conditions hold. | **False** | ALL four conditions must hold simultaneously for deadlock. |
| 2 | Every unsafe state is a deadlock state. | **False** | Unsafe means deadlock MAY occur, not that it has occurred. |
| 3 | Banker's Algorithm is used in most commercial operating systems. | **False** | It's too restrictive and requires advance knowledge of max needs. Most OS use the Ostrich approach. |
| 4 | Resource ordering is the most practical method of deadlock prevention. | **True** | It's widely used and has low overhead compared to other prevention methods. |
| 5 | In a RAG, a request edge goes from a process to a resource. | **True** | Request edge: Process → Resource. Assignment edge: Resource → Process. |
| 6 | Killing all deadlocked processes always resolves the deadlock. | **True** | All resources are released, breaking all conditions. But it's the most expensive recovery. |
| 7 | Starvation can occur during deadlock recovery if the same process is always chosen as victim. | **True** | Without fairness, the same low-priority process may be killed repeatedly. |
| 8 | A safe sequence must be unique. | **False** | Multiple safe sequences can exist for a given state. |
| 9 | Deadlock can occur with only 1 process. | **False** | Deadlock requires at least 2 processes (circular wait needs ≥ 2). |
| 10 | Preempting resources from a process can help recover from deadlock. | **True** | Taking resources from a deadlocked process and giving to another breaks the cycle. |

---

### 🟣 Level 5: Scenario-Based Questions

**Scenario 1:**
> A system has 12 tape drives. Three processes P1, P2, P3 have maximum needs of 10, 4, 9 respectively. Currently P1 holds 5, P2 holds 2, P3 holds 2. Is the system in a safe state?

**Answer:**
```
Available = 12 - (5+2+2) = 3
Need: P1=10-5=5, P2=4-2=2, P3=9-2=7

Check: Can P2 finish? Need=2 ≤ Available=3 → YES
  Available = 3+2 = 5
Check: Can P1 finish? Need=5 ≤ Available=5 → YES
  Available = 5+5 = 10
Check: Can P3 finish? Need=7 ≤ Available=10 → YES

Safe sequence: <P2, P1, P3> ✓ SAFE STATE
```

---

**Scenario 2:**
> Two processes P1 and P2 each need two resources R1 and R2. P1 holds R1 and requests R2. P2 holds R2 and requests R1. Identify the deadlock conditions and suggest a fix.

**Answer:**
All four conditions hold:
1. **Mutual Exclusion:** R1, R2 are non-sharable ✓
2. **Hold and Wait:** P1 holds R1, waits for R2; P2 holds R2, waits for R1 ✓
3. **No Preemption:** Neither can be forcibly taken ✓
4. **Circular Wait:** P1→R2→P2→R1→P1 ✓

**Fix:** Resource ordering — both must request R1 before R2. P2 must release R2, request R1 first, then R2. This breaks circular wait.

---

**Scenario 3:**
> A system has Available=[1,1,2]. Process P1 has Need=[1,1,1] and P2 has Need=[1,1,2]. Is granting P1's request of [1,0,1] safe?

**Answer:**
```
After granting P1 [1,0,1]:
  Available = [1,1,2]-[1,0,1] = [0,1,1]
  P1 Need = [1,1,1]-[1,0,1] = [0,1,0]
  
Safety: Can P1 finish? Need=[0,1,0] ≤ [0,1,1]? YES
  Available = [0,1,1]+[1,0,1] (P1's allocation, assuming at least [1,0,1])
  
Can P2 finish? Need=[1,1,2] ≤ new Available?
This depends on P1's total allocation. Given information, P1 finishes, 
releases resources, then check P2.

If P2 can finish → SAFE. Grant request.
```

---

**Scenario 4:**
> A company has 3 conference rooms. 4 teams each need 2 rooms for a joint meeting but are each holding 1 room and waiting for another. Identify the deadlock and suggest recovery.

**Answer:** This is a deadlock: 4 teams each hold 1 room (total 4, but only 3 exist — wait, 4 teams × 1 room = 4, but only 3 rooms!). Actually, only 3 teams can hold a room. The 4th team is waiting. But among the 3 holding, each wants one more → circular wait possible.

**Recovery options:**
1. Force one team to release their room (resource preemption)
2. Cancel the lowest-priority team's booking (process termination)
3. Add a 4th conference room (add resources)

---

**Scenario 5:**
> A database system has 3 resource types: locks, buffers, and log entries. It uses resource ordering (locks=1, buffers=2, log=3). Can a transaction that holds a buffer (2) request a lock (1)?

**Answer:** **No!** Resource ordering requires requests in increasing order. Holding buffer (2) means the transaction can only request resources with numbers **greater than 2** (i.e., log entries=3). Requesting lock (1) would violate the ordering and is **not allowed**. The transaction must release the buffer first, then request lock, then buffer, then log in order. This prevents circular wait.

---

### 🟤 Level 6: Advanced Real-World Application Questions

**Q1. How does MySQL InnoDB detect and resolve deadlocks automatically?**

**Answer:** InnoDB uses a **wait-for graph** approach:

```
Wait-for graph:
T1 → T2 (T1 waits for a lock held by T2)
T2 → T3 (T2 waits for a lock held by T3)
T3 → T1 (T3 waits for a lock held by T1)
→ CYCLE DETECTED → DEADLOCK!

InnoDB Resolution:
1. Detect cycle in wait-for graph (background thread checks every lock wait)
2. Choose victim: transaction with fewest rows modified (cheapest to rollback)
3. Rollback victim transaction
4. Return error 1213 (ER_LOCK_DEADLOCK) to application
5. Application retries the transaction
```

**Real application code**:
```python
import mysql.connector
def transfer_funds(from_id, to_id, amount):
    retries = 3
    while retries > 0:
        try:
            cursor.execute("BEGIN")
            cursor.execute("UPDATE accounts SET balance=balance-? WHERE id=?", (amount, from_id))
            cursor.execute("UPDATE accounts SET balance=balance+? WHERE id=?", (amount, to_id))
            cursor.execute("COMMIT")
            return True
        except mysql.connector.errors.DatabaseError as e:
            if e.errno == 1213:  # Deadlock
                cursor.execute("ROLLBACK")
                retries -= 1
            else:
                raise
    return False
```

---

**Q2. Apply the Banker's Algorithm to this real-world scenario: A cloud provider has 10 VMs, 20 GB RAM, and 5 GPU units.**

```
State:
         Allocated         Maximum           Need
Process  VM  RAM  GPU    VM  RAM  GPU    VM  RAM  GPU
P1        2    4    1     4    8    2     2    4    1
P2        3    3    0     6    6    2     3    3    2
P3        1    2    1     3    5    2     2    3    1
P4        2    6    2     4   10    3     2    4    1

Available: VM=2, RAM=5, GPU=1
```

**Answer:**
```
Need matrix:
P1: VM=2, RAM=4, GPU=1
P2: VM=3, RAM=3, GPU=2
P3: VM=2, RAM=3, GPU=1
P4: VM=2, RAM=4, GPU=1

Available: [2, 5, 1]

Step 1: Can P1 finish? Need=[2,4,1] ≤ [2,5,1]? YES
  Available = [2,5,1] + [2,4,1] = [4,9,2]

Step 2: Can P3 finish? Need=[2,3,1] ≤ [4,9,2]? YES
  Available = [4,9,2] + [1,2,1] = [5,11,3]

Step 3: Can P4 finish? Need=[2,4,1] ≤ [5,11,3]? YES
  Available = [5,11,3] + [2,6,2] = [7,17,5]

Step 4: Can P2 finish? Need=[3,3,2] ≤ [7,17,5]? YES
  Available = [7,17,5] + [3,3,0] = [10,20,5]

Safe Sequence: <P1, P3, P4, P2> ✓ SAFE STATE
```
The cloud provider can safely allocate all requested resources — no deadlock risk.

---

**Q3. A Node.js application has this code pattern. Identify if deadlock is possible and fix it.**

```javascript
// Transaction 1: Transfer A→B
async function transferAtoB(amount) {
    await lockAccount(accountA);   // Lock A first
    await lockAccount(accountB);   // Then lock B
    accountA.balance -= amount;
    accountB.balance += amount;
    unlockAccount(accountA);
    unlockAccount(accountB);
}

// Transaction 2: Transfer B→A  
async function transferBtoA(amount) {
    await lockAccount(accountB);   // Lock B first
    await lockAccount(accountA);   // Then lock A
    accountB.balance -= amount;
    accountA.balance += amount;
    unlockAccount(accountB);
    unlockAccount(accountA);
}
```

**Answer:** **Yes, deadlock is possible!**
- T1 locks A, T2 locks B
- T1 tries to lock B (blocked — T2 holds it)
- T2 tries to lock A (blocked — T1 holds it)
- **Circular wait!**

**Fix using resource ordering** (always lock accounts in order of their ID):
```javascript
async function transfer(fromAccount, toAccount, amount) {
    // Always acquire locks in consistent order (lower ID first)
    const [first, second] = fromAccount.id < toAccount.id 
        ? [fromAccount, toAccount] 
        : [toAccount, fromAccount];
    
    await lockAccount(first);
    await lockAccount(second);
    fromAccount.balance -= amount;
    toAccount.balance += amount;
    unlockAccount(second);
    unlockAccount(first);
}
```

---

**Q4. Explain the "dining savants" problem — how does Kubernetes avoid resource deadlocks when scheduling pods?**

**Answer:** Kubernetes faces a distributed deadlock problem:
- Pod A needs 4 CPU cores + 8 GB RAM (has 4 CPU, waiting for RAM)
- Pod B needs 4 CPU cores + 8 GB RAM (has 8 GB RAM, waiting for CPU)
- **All resources consumed, neither pod can start — distributed deadlock!**

**Kubernetes Prevention Strategies**:

| Strategy | Mechanism |
|----------|-----------|
| **Resource Requests** | Pod declares minimum needs upfront (like Banker's Max) |
| **Resource Limits** | Hard cap prevents any pod taking more than declared |
| **Bin packing** | Scheduler allocates all resources atomically — no partial allocation |
| **Priority Classes** | High-priority pods preempt low-priority ones (breaks Hold & Wait) |
| **Pod Disruption Budgets** | Controls how many pods can be evicted simultaneously |

**Key principle**: Kubernetes never partially allocates — a pod gets ALL requested resources or waits. This prevents "hold and wait," the most dangerous deadlock condition in distributed systems.

---

**Q5. A multi-threaded Java application has the following lock hierarchy. Trace the deadlock and write the fix.**

```java
Object lockA = new Object();
Object lockB = new Object();

Thread t1 = new Thread(() -> {
    synchronized (lockA) {
        Thread.sleep(100);  // Simulates work
        synchronized (lockB) { /* critical work */ }
    }
});

Thread t2 = new Thread(() -> {
    synchronized (lockB) {
        Thread.sleep(100);  // Simulates work
        synchronized (lockA) { /* critical work */ }
    }
});
```

**Answer:** Deadlock trace:
1. T1 acquires `lockA`, sleeps 100ms
2. T2 acquires `lockB`, sleeps 100ms
3. T1 wakes, tries `lockB` → **BLOCKED** (T2 holds it)
4. T2 wakes, tries `lockA` → **BLOCKED** (T1 holds it)
5. **Circular wait → DEADLOCK!**

**Four Coffman conditions satisfied**:
- ME: Only one thread can hold each lock ✓
- Hold & Wait: T1 holds lockA, waits for lockB ✓
- No preemption: Java locks cannot be forcibly taken ✓
- Circular wait: T1→lockB→T2→lockA→T1 ✓

**Fix — consistent lock ordering**:
```java
// Both threads acquire locks in SAME order: lockA first, then lockB
Thread t1 = new Thread(() -> {
    synchronized (lockA) {
        synchronized (lockB) { /* critical work */ }
    }
});
Thread t2 = new Thread(() -> {
    synchronized (lockA) {  // Changed: lockA first (same as T1)
        synchronized (lockB) { /* critical work */ }
    }
});
```

**Alternative fix — tryLock with timeout**:
```java
if (lockA.tryLock(50, TimeUnit.MS)) {
    try {
        if (lockB.tryLock(50, TimeUnit.MS)) {
            try { /* critical work */ } finally { lockB.unlock(); }
        }
    } finally { lockA.unlock(); }
}
// If timeout: release everything and retry (breaks Hold & Wait)
```

---

> **← [Previous: 04 - Process Synchronization](04_Process_Synchronization.md) | [Next: 06 - Memory Management →](06_Memory_Management.md)**
