# 03. CPU Scheduling

## Table of Contents
- [3.1 What is CPU Scheduling?](#31-what-is-cpu-scheduling)
- [3.2 Scheduling Criteria](#32-scheduling-criteria)
- [3.3 FCFS (First-Come First-Served)](#33-fcfs-first-come-first-served)
- [3.4 SJF (Shortest Job First)](#34-sjf-shortest-job-first)
- [3.5 Round Robin (RR)](#35-round-robin-rr)
- [3.6 Priority Scheduling](#36-priority-scheduling)
- [3.7 Algorithm Comparison](#37-algorithm-comparison)
- [3.8 Common Mistakes & Interview Tips](#38-common-mistakes--interview-tips)
- [3.9 Practice & Assessment](#39-practice--assessment)

---

## 3.1 What is CPU Scheduling?

### Definition
**CPU Scheduling** is the process of selecting which process in the ready queue gets the CPU next. The **scheduler** is the OS component that makes this decision.

### Why It Matters
```
Only ONE process can use the CPU at a time (on single-core).
Multiple processes are waiting in the ready queue.
The scheduler decides WHO gets the CPU and for HOW LONG.

Good scheduling → Fast response, fair distribution, high throughput
Bad scheduling  → Starvation, poor response time, wasted CPU
```

### Types of Scheduling

| Type | When It Decides | Preemptive? |
|------|----------------|-------------|
| **Long-term** | Which jobs enter the ready queue (from disk) | — |
| **Short-term (CPU scheduler)** | Which ready process gets CPU next | Yes/No |
| **Medium-term** | Which process to swap in/out of memory | — |

### Preemptive vs Non-Preemptive

| Preemptive | Non-Preemptive |
|-----------|----------------|
| OS can take CPU away from running process | Process runs until it finishes or blocks |
| Needed for time-sharing systems | Simpler to implement |
| Example: Round Robin, Preemptive SJF | Example: FCFS, Non-preemptive SJF |

---

## 3.2 Scheduling Criteria

### Key Metrics

| Metric | Definition | Goal |
|--------|-----------|------|
| **CPU Utilization** | % of time CPU is busy | Maximize (100% ideal) |
| **Throughput** | Number of processes completed per time unit | Maximize |
| **Turnaround Time** | Total time from submission to completion | Minimize |
| **Waiting Time** | Total time spent in ready queue (not executing) | Minimize |
| **Response Time** | Time from submission to first response | Minimize |

### Formulas

```
Turnaround Time (TAT) = Completion Time - Arrival Time

Waiting Time (WT) = Turnaround Time - Burst Time
                  = Completion Time - Arrival Time - Burst Time

Response Time (RT) = First CPU time - Arrival Time

Average Waiting Time = Sum of all waiting times / Number of processes
```

---

## 3.3 FCFS (First-Come First-Served)

### Definition
Processes are executed in the order they arrive in the ready queue. **Non-preemptive.**

### Algorithm
```
1. Process that arrives first gets CPU first
2. No preemption — runs until completion
3. Simple FIFO queue
```

### Example

| Process | Arrival Time | Burst Time |
|---------|-------------|-----------|
| P1 | 0 | 6 |
| P2 | 1 | 4 |
| P3 | 2 | 2 |
| P4 | 3 | 3 |

### Gantt Chart

```
|   P1    |  P2   | P3 | P4  |
0         6      10   12    15
```

### Calculations

| Process | Arrival | Burst | Completion | Turnaround (CT-AT) | Waiting (TAT-BT) |
|---------|---------|-------|-----------|-------------------|------------------|
| P1 | 0 | 6 | 6 | 6-0 = 6 | 6-6 = 0 |
| P2 | 1 | 4 | 10 | 10-1 = 9 | 9-4 = 5 |
| P3 | 2 | 2 | 12 | 12-2 = 10 | 10-2 = 8 |
| P4 | 3 | 3 | 15 | 15-3 = 12 | 12-3 = 9 |

```
Average Waiting Time = (0 + 5 + 8 + 9) / 4 = 22/4 = 5.5 ms
Average Turnaround Time = (6 + 9 + 10 + 12) / 4 = 37/4 = 9.25 ms
```

### Convoy Effect
```
Problem: Short processes stuck behind long process

If P1 has burst = 100 and P2, P3, P4 have burst = 1:
  P2, P3, P4 must wait 100 units for P1 to finish!
  
This is called the "Convoy Effect" — the main disadvantage of FCFS.
```

---

## 3.4 SJF (Shortest Job First)

### Definition
Select the process with the **smallest burst time** next. Can be preemptive or non-preemptive.

### Non-Preemptive SJF

| Process | Arrival Time | Burst Time |
|---------|-------------|-----------|
| P1 | 0 | 7 |
| P2 | 2 | 4 |
| P3 | 4 | 1 |
| P4 | 5 | 4 |

**At time 0:** Only P1 available → P1 runs (burst=7, completes at 7)
**At time 7:** P2(4), P3(1), P4(4) available → Pick shortest: P3(1)
**At time 8:** P2(4), P4(4) available → Pick P2 (arrived earlier)
**At time 12:** P4(4) → P4 runs

### Gantt Chart (Non-Preemptive)

```
|    P1     | P3|   P2   |   P4   |
0           7   8       12       16
```

| Process | Completion | Turnaround | Waiting |
|---------|-----------|-----------|---------|
| P1 | 7 | 7-0=7 | 7-7=0 |
| P2 | 12 | 12-2=10 | 10-4=6 |
| P3 | 8 | 8-4=4 | 4-1=3 |
| P4 | 16 | 16-5=11 | 11-4=7 |

```
Average WT = (0+6+3+7)/4 = 4.0 ms
```

### Preemptive SJF (SRTF — Shortest Remaining Time First)

Same processes — but now, whenever a **new process arrives**, if its burst is shorter than the remaining time of the current process, it **preempts**.

| Process | Arrival | Burst |
|---------|---------|-------|
| P1 | 0 | 7 |
| P2 | 2 | 4 |
| P3 | 4 | 1 |
| P4 | 5 | 4 |

```
Time 0: P1 starts (remaining=7)
Time 2: P2 arrives (burst=4) < P1 remaining (5) → PREEMPT → P2 runs
Time 4: P3 arrives (burst=1) < P2 remaining (2) → PREEMPT → P3 runs
Time 5: P3 done. P4 arrives (burst=4). P2 remaining=2, P4=4, P1=5 → P2 runs
Time 7: P2 done. P4 remaining=4, P1=5 → P4 runs
Time 11: P4 done → P1 runs
Time 16: P1 done
```

### Gantt Chart (Preemptive SJF / SRTF)

```
| P1 | P2 |P3| P2 |  P4   |  P1   |
0    2    4  5    7      11      16
```

| Process | Completion | Turnaround | Waiting |
|---------|-----------|-----------|---------|
| P1 | 16 | 16-0=16 | 16-7=9 |
| P2 | 7 | 7-2=5 | 5-4=1 |
| P3 | 5 | 5-4=1 | 1-1=0 |
| P4 | 11 | 11-5=6 | 6-4=2 |

```
Average WT = (9+1+0+2)/4 = 3.0 ms   ← Better than non-preemptive!
```

---

## 3.5 Round Robin (RR)

### Definition
Each process gets a **fixed time quantum** (time slice). After the quantum expires, the process is preempted and placed at the end of the ready queue.

### Algorithm
```
1. Set time quantum (e.g., 4 ms)
2. Pick first process from queue, run for quantum
3. If process finishes before quantum → next process immediately
4. If quantum expires → preempt, put at end of queue
5. Repeat until all done
```

### Example (Time Quantum = 3)

| Process | Arrival Time | Burst Time |
|---------|-------------|-----------|
| P1 | 0 | 5 |
| P2 | 1 | 4 |
| P3 | 2 | 2 |
| P4 | 3 | 1 |

**Execution:**
```
Time 0-3:  P1 runs for 3 (remaining: 2). Queue: [P2, P3, P4]
Time 3-6:  P2 runs for 3 (remaining: 1). Queue: [P3, P4, P1]
Time 6-8:  P3 runs for 2 (DONE). Queue: [P4, P1, P2]
Time 8-9:  P4 runs for 1 (DONE). Queue: [P1, P2]
Time 9-11: P1 runs for 2 (DONE). Queue: [P2]
Time 11-12: P2 runs for 1 (DONE). Queue: []
```

### Gantt Chart

```
|  P1  |  P2  |P3 |P4|P1 |P2|
0      3      6   8  9  11 12
```

| Process | Completion | Turnaround | Waiting |
|---------|-----------|-----------|---------|
| P1 | 11 | 11-0=11 | 11-5=6 |
| P2 | 12 | 12-1=11 | 11-4=7 |
| P3 | 8 | 8-2=6 | 6-2=4 |
| P4 | 9 | 9-3=6 | 6-1=5 |

```
Average WT = (6+7+4+5)/4 = 5.5 ms
```

### Effect of Time Quantum Size

```
Large quantum (e.g., 100ms):
  → Behaves like FCFS (processes finish before preemption)
  → Convoy effect returns

Small quantum (e.g., 1ms):
  → Too many context switches (overhead dominates)
  → CPU spends more time switching than executing

Ideal quantum:
  → 10-100 ms typically
  → Rule of thumb: 80% of CPU bursts should be shorter than quantum
```

---

## 3.6 Priority Scheduling

### Definition
Each process is assigned a **priority**. The CPU is allocated to the process with the **highest priority** (lowest number = highest priority, typically).

### Types
- **Preemptive:** If a new process arrives with higher priority than running process → preempt
- **Non-preemptive:** Running process completes its burst regardless of new arrivals

### Example (Non-Preemptive, Lower number = Higher priority)

| Process | Arrival Time | Burst Time | Priority |
|---------|-------------|-----------|----------|
| P1 | 0 | 4 | 3 |
| P2 | 1 | 3 | 1 |
| P3 | 2 | 2 | 4 |
| P4 | 3 | 5 | 2 |

**At time 0:** Only P1 → P1 runs (non-preemptive, finishes at 4)
**At time 4:** P2(pri=1), P3(pri=4), P4(pri=2) → Highest priority: P2
**At time 7:** P3(pri=4), P4(pri=2) → Highest priority: P4
**At time 12:** P3 → runs

```
| P1  | P2  | P4    | P3 |
0     4     7      12    14
```

### Problem: Starvation

```
If high-priority processes keep arriving, low-priority processes 
may NEVER get the CPU. This is called STARVATION.

Solution: AGING
  → Gradually increase priority of waiting processes over time
  → Eventually, even lowest priority process will get CPU
```

---

## 3.7 Algorithm Comparison

| Algorithm | Preemptive? | Starvation? | Convoy Effect? | Optimal? |
|-----------|------------|-------------|---------------|----------|
| **FCFS** | No | No | Yes | No |
| **SJF (Non-preemptive)** | No | Yes (long jobs) | No | Yes (for non-preemptive) |
| **SRTF (Preemptive SJF)** | Yes | Yes (long jobs) | No | Yes (minimum avg WT) |
| **Round Robin** | Yes | No | No | No |
| **Priority** | Both | Yes | No | No |

| Algorithm | Best For | Worst For |
|-----------|---------|-----------|
| FCFS | Simple batch jobs | Interactive systems |
| SJF/SRTF | Minimizing average waiting time | When burst times unknown |
| Round Robin | Time-sharing, interactive systems | Long CPU-bound processes |
| Priority | Real-time systems, importance-based | Fairness (without aging) |

---

## 3.8 Common Mistakes & Interview Tips

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Forgetting to check arrival time in SJF | Only consider processes that have ARRIVED |
| Using wrong queue order in Round Robin | After preemption, process goes to END of queue |
| Confusing turnaround and waiting time | TAT = CT - AT; WT = TAT - BT |
| Priority direction confusion | Clarify: is 1 highest or lowest? (varies by problem) |

### Interview Tips

**Q: Which scheduling algorithm gives minimum average waiting time?**
> SJF (Shortest Job First) / SRTF gives the minimum average waiting time. However, it requires knowing burst times in advance, which is impractical.

**Q: What is starvation and how to solve it?**
> Starvation occurs when low-priority processes never get CPU because higher-priority processes keep arriving. Solution: Aging — gradually increasing priority of waiting processes.

**Q: What is the convoy effect?**
> In FCFS, when a long process occupies the CPU, all shorter processes must wait behind it. Like being stuck behind a slow truck on a single-lane road.

---

## 3.9 Practice & Assessment

### MCQs

**Q1.** SRTF stands for:
- A) Shortest Response Time First
- B) Shortest Remaining Time First
- C) Simple Real-Time Framework
- D) Shortest Ready Time First

**Answer:** B

---

**Q2.** Round Robin is best suited for:
- A) Batch processing
- B) Time-sharing / interactive systems
- C) Real-time systems only
- D) Single-user systems

**Answer:** B

---

**Q3.** Aging is a solution to:
- A) Deadlock
- B) Starvation
- C) Convoy effect
- D) Thrashing

**Answer:** B

---

### Problem: Solve This

Given processes (Time Quantum = 2 for RR):

| Process | Arrival | Burst |
|---------|---------|-------|
| P1 | 0 | 5 |
| P2 | 1 | 3 |
| P3 | 2 | 4 |

**Task:** Draw Gantt chart and calculate average waiting time for:
1. FCFS
2. Round Robin (TQ=2)

**FCFS Solution:**
```
|  P1   | P2  |  P3  |
0       5     8     12

WT: P1=0, P2=5-1=4-3=1? 
  P1: CT=5, TAT=5-0=5, WT=5-5=0
  P2: CT=8, TAT=8-1=7, WT=7-3=4
  P3: CT=12, TAT=12-2=10, WT=10-4=6
  Avg WT = (0+4+6)/3 = 3.33 ms
```

**Round Robin (TQ=2) Solution:**
```
Time 0-2: P1 (rem=3). Queue: [P2,P3]
Time 2-4: P2 (rem=1). Queue: [P3,P1]
Time 4-6: P3 (rem=2). Queue: [P1,P2]
Time 6-8: P1 (rem=1). Queue: [P2,P3]
Time 8-9: P2 (rem=0, DONE). Queue: [P3,P1]
Time 9-11: P3 (rem=0, DONE). Queue: [P1]
Time 11-12: P1 (rem=0, DONE).

|P1 |P2 |P3 |P1 |P2|P3 |P1|
0   2   4   6   8  9  11 12

P1: CT=12, TAT=12, WT=12-5=7
P2: CT=9, TAT=9-1=8, WT=8-3=5
P3: CT=11, TAT=11-2=9, WT=9-4=5
Avg WT = (7+5+5)/3 = 5.67 ms
```

---

> **Next Topic:** [04 - Process Synchronization](04-process-synchronization.md)
