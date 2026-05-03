# 05. Deadlocks

## Table of Contents
- [5.1 What is a Deadlock?](#51-what-is-a-deadlock)
- [5.2 Necessary Conditions](#52-necessary-conditions)
- [5.3 Resource Allocation Graph](#53-resource-allocation-graph)
- [5.4 Deadlock Prevention](#54-deadlock-prevention)
- [5.5 Deadlock Avoidance (Banker's Algorithm)](#55-deadlock-avoidance-bankers-algorithm)
- [5.6 Deadlock Detection & Recovery](#56-deadlock-detection--recovery)
- [5.7 Common Mistakes & Interview Tips](#57-common-mistakes--interview-tips)
- [5.8 Practice & Assessment](#58-practice--assessment)

---

## 5.1 What is a Deadlock?

### Definition
A **deadlock** is a situation where two or more processes are waiting for each other to release resources, and none can proceed. They are stuck forever.

### Real-World Analogy

```
Two cars on a narrow bridge (one-lane):
  Car A going East → waiting for Car B to move
  Car B going West → waiting for Car A to move
  
  Neither can move. DEADLOCK!

In computing:
  Process A holds Resource 1, needs Resource 2
  Process B holds Resource 2, needs Resource 1
  
  Neither can proceed. DEADLOCK!
```

### Example

```
Process A:                    Process B:
  lock(Resource1);  ✓          lock(Resource2);  ✓
  lock(Resource2);  WAIT...    lock(Resource1);  WAIT...
  
  A holds R1, waiting for R2
  B holds R2, waiting for R1
  → DEADLOCK (circular wait)
```

---

## 5.2 Necessary Conditions

All **four conditions must hold simultaneously** for deadlock to occur:

| Condition | Description | Example |
|-----------|-------------|---------|
| **Mutual Exclusion** | Resource can be held by only one process | Printer: only one job at a time |
| **Hold and Wait** | Process holds resources while waiting for others | Holding R1, waiting for R2 |
| **No Preemption** | Resources can't be forcibly taken away | Can't snatch printer from a process |
| **Circular Wait** | Chain of processes, each waiting for next one's resource | A→B→C→A |

```
If ANY ONE of these conditions is broken → NO deadlock possible
```

---

## 5.3 Resource Allocation Graph

### Definition
A **Resource Allocation Graph (RAG)** visually shows which processes hold which resources and which resources they're requesting.

```
Notation:
  Process:  ○ (circle)
  Resource: □ (square, with dots for instances)
  
  Request edge: Process ──► Resource  (P is requesting R)
  Assignment edge: Resource ──► Process  (R is assigned to P)
```

### Example: Deadlock Detected

```
    ┌───┐          ┌───┐
    │ R1│──────────►│ P1│
    │ □ │          │ ○ │
    └───┘          └─┬─┘
      ▲              │
      │              │ requests R2
      │              ▼
    ┌─┴─┐          ┌───┐
    │ P2│◄──────────│ R2│
    │ ○ │          │ □ │
    └───┘          └───┘
    
  P1 holds R1, requests R2
  P2 holds R2, requests R1
  CYCLE detected → DEADLOCK!
```

### Rule
- If RAG has a **cycle** AND each resource has **only 1 instance** → **Deadlock**
- If resources have **multiple instances** → cycle is necessary but NOT sufficient for deadlock

---

## 5.4 Deadlock Prevention

Break ONE of the four necessary conditions:

| Condition | Prevention Strategy | Practical? |
|-----------|-------------------|-----------|
| **Mutual Exclusion** | Make resources sharable | Not always possible (printer can't be shared) |
| **Hold and Wait** | Request ALL resources at once before starting | Leads to low utilization, starvation |
| **No Preemption** | Allow OS to take resources away | Works for CPU/memory, not printers |
| **Circular Wait** | Impose ordering on resource requests | Most practical! |

### Breaking Circular Wait (Most Common)

```
Assign numbers to all resources: R1=1, R2=2, R3=3, ...

Rule: A process can only request resources in INCREASING order.

If P holds R2, it can only request R3, R4, ... (not R1)
This prevents cycles!

Example:
  Process A: lock(R1) then lock(R2)  ✓ (1 < 2)
  Process B: lock(R1) then lock(R2)  ✓ (1 < 2)
  
  B can't do lock(R2) then lock(R1) because 2 > 1 (violates order)
  → No circular wait possible → No deadlock!
```

---

## 5.5 Deadlock Avoidance (Banker's Algorithm)

### Concept
The OS **checks if granting a request leads to a safe state** before allocating resources. If unsafe → deny request (process must wait).

### Safe State vs Unsafe State

```
SAFE STATE: There exists at least one order (safe sequence) in which 
            ALL processes can finish without deadlock.

UNSAFE STATE: No safe sequence exists. Deadlock MAY occur.
              (Not guaranteed, but risk exists)

DEADLOCK: A special case of unsafe state where processes ARE stuck.

Safe ⊃ All possible states
Safe states → never deadlock
Unsafe states → might deadlock
```

### Banker's Algorithm — Step by Step

**Given:**
- n = number of processes
- m = number of resource types
- **Available[m]:** instances of each resource currently free
- **Max[n][m]:** maximum demand of each process
- **Allocation[n][m]:** currently allocated to each process
- **Need[n][m]:** remaining need = Max - Allocation

### Example

```
5 processes (P0-P4), 3 resource types (A, B, C)
Total instances: A=10, B=5, C=7
```

| Process | Allocation (A B C) | Max (A B C) | Need (A B C) |
|---------|-------------------|-------------|--------------|
| P0 | 0 1 0 | 7 5 3 | 7 4 3 |
| P1 | 2 0 0 | 3 2 2 | 1 2 2 |
| P2 | 3 0 2 | 9 0 2 | 6 0 0 |
| P3 | 2 1 1 | 2 2 2 | 0 1 1 |
| P4 | 0 0 2 | 4 3 3 | 4 3 1 |

**Available = Total - Sum(Allocation)**
```
Total:      10  5  7
Allocated:   7  2  5  (sum of Allocation column)
Available:   3  3  2
```

### Finding Safe Sequence

```
Step 1: Find a process whose Need ≤ Available
  Check P0: Need(7,4,3) ≤ Available(3,3,2)? NO (7>3)
  Check P1: Need(1,2,2) ≤ Available(3,3,2)? YES! ✓
  
Step 2: "Execute" P1 → release its resources
  Available = Available + Allocation[P1] = (3,3,2) + (2,0,0) = (5,3,2)
  
Step 3: Find next process
  Check P0: Need(7,4,3) ≤ (5,3,2)? NO
  Check P2: Need(6,0,0) ≤ (5,3,2)? NO (6>5)
  Check P3: Need(0,1,1) ≤ (5,3,2)? YES! ✓
  
Step 4: "Execute" P3
  Available = (5,3,2) + (2,1,1) = (7,4,3)

Step 5: Check P0: Need(7,4,3) ≤ (7,4,3)? YES! ✓
  Available = (7,4,3) + (0,1,0) = (7,5,3)

Step 6: Check P2: Need(6,0,0) ≤ (7,5,3)? YES! ✓
  Available = (7,5,3) + (3,0,2) = (10,5,5)

Step 7: Check P4: Need(4,3,1) ≤ (10,5,5)? YES! ✓

SAFE SEQUENCE: P1 → P3 → P0 → P2 → P4
System is in SAFE STATE ✓
```

---

## 5.6 Deadlock Detection & Recovery

### Detection
- Periodically run algorithm to check for cycles in resource allocation
- Similar to Banker's algorithm but checks current state

### Recovery Strategies

| Strategy | How | Disadvantage |
|----------|-----|-------------|
| **Process Termination** | Kill one or all deadlocked processes | Work lost |
| **Resource Preemption** | Take resource from one process, give to another | Process may need to restart |
| **Rollback** | Restart process from a checkpoint | Need checkpoint mechanism |

---

## 5.7 Common Mistakes & Interview Tips

### Common Mistakes

| Mistake | Correction |
|---------|-----------|
| "Unsafe state = deadlock" | Unsafe means deadlock is POSSIBLE, not certain |
| Forgetting one of the 4 conditions | All FOUR must hold for deadlock |
| Applying Banker's wrong | Need = Max - Allocation; compare Need with Available |

### Interview Questions

**Q: What are the four necessary conditions for deadlock?**
> Mutual Exclusion, Hold and Wait, No Preemption, Circular Wait. All four must hold simultaneously.

**Q: How does Banker's Algorithm prevent deadlock?**
> It checks before each allocation if the resulting state is safe (a sequence exists where all processes can finish). If not safe, the request is denied until resources are available.

**Q: Difference between deadlock prevention and avoidance?**
> Prevention: Structurally eliminates one of the four conditions (restrictive). Avoidance: Dynamically checks each request for safety (more flexible, like Banker's).

---

## 5.8 Practice & Assessment

### MCQs

**Q1.** Deadlock requires how many conditions simultaneously?
- A) 1
- B) 2
- C) 3
- D) 4

**Answer:** D) 4

---

**Q2.** Banker's Algorithm is used for deadlock:
- A) Prevention
- B) Avoidance
- C) Detection
- D) Recovery

**Answer:** B) Avoidance

---

**Q3.** Imposing an ordering on resource requests prevents:
- A) Mutual exclusion
- B) Hold and wait
- C) Circular wait
- D) No preemption

**Answer:** C) Circular wait

---

### Problem

Given: Available = (2, 1), 3 processes:

| Process | Allocation (A B) | Max (A B) | Need (A B) |
|---------|-----------------|-----------|------------|
| P0 | 1 0 | 3 2 | 2 2 |
| P1 | 1 1 | 2 2 | 1 1 |
| P2 | 0 1 | 1 1 | 1 0 |

**Task:** Is the system in a safe state? Find the safe sequence.

**Solution:**
```
Available = (2, 1)

Check P0: Need(2,2) ≤ Available(2,1)? NO (2>1)
Check P1: Need(1,1) ≤ Available(2,1)? YES ✓
  Execute P1: Available = (2,1)+(1,1) = (3,2)

Check P0: Need(2,2) ≤ (3,2)? YES ✓
  Execute P0: Available = (3,2)+(1,0) = (4,2)

Check P2: Need(1,0) ≤ (4,2)? YES ✓
  Execute P2.

Safe Sequence: P1 → P0 → P2 ✓ (SAFE STATE)
```

---

> **Next Topic:** [06 - Memory Management](06-memory-management.md)
