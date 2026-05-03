# 10. Multithreading

## Table of Contents
- [10.1 What is Multithreading?](#101-what-is-multithreading)
- [10.2 Thread Lifecycle](#102-thread-lifecycle)
- [10.3 Creating Threads](#103-creating-threads)
- [10.4 Thread Methods](#104-thread-methods)
- [10.5 Synchronization](#105-synchronization)
- [10.6 Inter-Thread Communication](#106-inter-thread-communication)
- [10.7 Practice & Assessment](#107-practice--assessment)

---

## 10.1 What is Multithreading?

### Definition
**Multithreading** is the concurrent execution of two or more threads (lightweight processes) within a single program.

### Why Multithreading?
- **Better CPU utilization** — while one thread waits for I/O, another runs
- **Responsiveness** — UI thread stays responsive while background thread works
- **Parallel processing** — divide work among threads

### Process vs Thread

| Process | Thread |
|---------|--------|
| Heavy-weight | Light-weight |
| Own memory space | Shared memory (heap) |
| Slow context switch | Fast context switch |
| Inter-process communication | Can share variables directly |

---

## 10.2 Thread Lifecycle

```
        ┌───────────────────────────────────────────┐
        │                                           │
  ┌─────┴─────┐     start()     ┌──────────┐      │
  │    NEW     │ ──────────────► │  RUNNABLE │      │
  └───────────┘                  └─────┬────┘      │
                                       │            │
                              Scheduler picks       │
                                       │            │
                                       ▼            │
                                 ┌──────────┐       │
                                 │  RUNNING  │       │
                                 └──┬───┬───┘       │
                                    │   │           │
                    wait()/sleep()  │   │  run() completes
                    blocked on I/O  │   │           │
                                    │   │           │
                                    ▼   ▼           │
                            ┌──────────┐  ┌────────┴────┐
                            │ BLOCKED/ │  │  TERMINATED  │
                            │ WAITING  │  └─────────────┘
                            └────┬─────┘
                                 │
                     notify()/time expires
                                 │
                                 ▼
                          Back to RUNNABLE
```

| State | Description |
|-------|-------------|
| **NEW** | Thread object created, not started |
| **RUNNABLE** | Ready to run, waiting for CPU |
| **RUNNING** | Currently executing |
| **BLOCKED/WAITING** | Waiting for lock, I/O, or notification |
| **TERMINATED** | Finished execution |

---

## 10.3 Creating Threads

### Method 1: Extending Thread Class

```java
class MyThread extends Thread {
    @Override
    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println(Thread.currentThread().getName() + ": " + i);
            try {
                Thread.sleep(500);  // Pause 500ms
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

public class Main {
    public static void main(String[] args) {
        MyThread t1 = new MyThread();
        MyThread t2 = new MyThread();
        
        t1.setName("Thread-A");
        t2.setName("Thread-B");
        
        t1.start();  // Starts new thread, calls run()
        t2.start();  // Both run concurrently!
        
        // t1.run();  ← WRONG! This runs in main thread (no concurrency)
    }
}
```

**Output (may vary — threads run concurrently):**
```
Thread-A: 1
Thread-B: 1
Thread-A: 2
Thread-B: 2
...
```

### Method 2: Implementing Runnable Interface (Preferred)

```java
class MyTask implements Runnable {
    @Override
    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println(Thread.currentThread().getName() + ": " + i);
            try {
                Thread.sleep(300);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

public class Main {
    public static void main(String[] args) {
        Thread t1 = new Thread(new MyTask(), "Worker-1");
        Thread t2 = new Thread(new MyTask(), "Worker-2");
        
        t1.start();
        t2.start();
    }
}
```

### Method 3: Lambda (Java 8+)

```java
Thread t = new Thread(() -> {
    System.out.println("Running in: " + Thread.currentThread().getName());
});
t.start();
```

### Why Runnable is Preferred
1. Java allows only single class inheritance — using Runnable, you can still extend another class
2. Separates the task from the thread mechanism
3. Works with thread pools and executors

---

## 10.4 Thread Methods

| Method | Description |
|--------|-------------|
| `start()` | Start thread (calls run() in new thread) |
| `run()` | Contains the task code |
| `sleep(ms)` | Pause current thread for ms milliseconds |
| `join()` | Wait for this thread to finish |
| `isAlive()` | Check if thread is still running |
| `getName()` / `setName()` | Get/set thread name |
| `getPriority()` / `setPriority()` | Thread priority (1-10) |
| `yield()` | Suggest giving up CPU to other threads |
| `interrupt()` | Interrupt a waiting/sleeping thread |

### join() Example

```java
public class Main {
    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread(() -> {
            for (int i = 1; i <= 3; i++) {
                System.out.println("Thread: " + i);
                try { Thread.sleep(500); } catch (InterruptedException e) {}
            }
        });
        
        t1.start();
        t1.join();  // Main thread WAITS until t1 finishes
        
        System.out.println("Main thread continues after t1 done");
    }
}
// Output:
// Thread: 1
// Thread: 2
// Thread: 3
// Main thread continues after t1 done
```

---

## 10.5 Synchronization

### The Problem — Race Condition

```java
class Counter {
    int count = 0;
    
    void increment() {
        count++;  // NOT atomic! (read → modify → write)
    }
}

// Two threads incrementing same counter 1000 times each
// Expected: 2000. Actual: often less than 2000!
```

### Solution: synchronized Keyword

```java
class Counter {
    private int count = 0;
    
    // Synchronized method — only one thread can execute at a time
    synchronized void increment() {
        count++;
    }
    
    int getCount() {
        return count;
    }
}

public class Main {
    public static void main(String[] args) throws InterruptedException {
        Counter counter = new Counter();
        
        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) counter.increment();
        });
        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) counter.increment();
        });
        
        t1.start();
        t2.start();
        t1.join();
        t2.join();
        
        System.out.println("Count: " + counter.getCount());  // Always 2000!
    }
}
```

### Synchronized Block (Fine-grained)

```java
class BankAccount {
    private double balance;
    private final Object lock = new Object();
    
    void deposit(double amount) {
        synchronized (lock) {  // Only lock the critical section
            balance += amount;
        }
    }
    
    void withdraw(double amount) {
        synchronized (lock) {
            if (balance >= amount) {
                balance -= amount;
            }
        }
    }
}
```

---

## 10.6 Inter-Thread Communication

### wait(), notify(), notifyAll()

Used for producer-consumer type problems. Must be called inside `synchronized` block.

### Producer-Consumer Example

```java
class SharedBuffer {
    private int data;
    private boolean hasData = false;
    
    synchronized void produce(int value) throws InterruptedException {
        while (hasData) {
            wait();  // Wait until consumer takes data
        }
        data = value;
        hasData = true;
        System.out.println("Produced: " + value);
        notify();  // Wake up consumer
    }
    
    synchronized int consume() throws InterruptedException {
        while (!hasData) {
            wait();  // Wait until producer adds data
        }
        hasData = false;
        System.out.println("Consumed: " + data);
        notify();  // Wake up producer
        return data;
    }
}

public class Main {
    public static void main(String[] args) {
        SharedBuffer buffer = new SharedBuffer();
        
        // Producer thread
        Thread producer = new Thread(() -> {
            try {
                for (int i = 1; i <= 5; i++) {
                    buffer.produce(i);
                    Thread.sleep(200);
                }
            } catch (InterruptedException e) {}
        });
        
        // Consumer thread
        Thread consumer = new Thread(() -> {
            try {
                for (int i = 0; i < 5; i++) {
                    buffer.consume();
                    Thread.sleep(300);
                }
            } catch (InterruptedException e) {}
        });
        
        producer.start();
        consumer.start();
    }
}
```

**Output:**
```
Produced: 1
Consumed: 1
Produced: 2
Consumed: 2
Produced: 3
Consumed: 3
...
```

---

## 10.7 Practice & Assessment

### MCQs

**Q1.** Which method starts a new thread?
- A) `run()`
- B) `start()`
- C) `execute()`
- D) `begin()`

**Answer:** B — `start()` creates new thread and calls `run()`. Calling `run()` directly runs in current thread.

---

**Q2.** `synchronized` ensures:
- A) Thread runs faster
- B) Only one thread accesses critical section at a time
- C) Thread never sleeps
- D) Thread has highest priority

**Answer:** B

---

**Q3.** `join()` does:
- A) Merges two threads
- B) Waits for the thread to finish
- C) Kills the thread
- D) Creates a new thread

**Answer:** B

---

### Output Prediction

```java
Thread t = new Thread(() -> System.out.println("Hello"));
t.run();  // Not start()!
System.out.println("World");
```

**Output:**
```
Hello
World
```
> `run()` executes in the main thread (no new thread created). Always sequential.

---

### Coding Task

**Task:** Create 3 threads that print their names 5 times each, with a 100ms delay. Use `join()` to ensure all finish before printing "All done!".

```java
public class Main {
    public static void main(String[] args) throws InterruptedException {
        Runnable task = () -> {
            for (int i = 0; i < 5; i++) {
                System.out.println(Thread.currentThread().getName() + ": " + i);
                try { Thread.sleep(100); } catch (InterruptedException e) {}
            }
        };
        
        Thread t1 = new Thread(task, "Alpha");
        Thread t2 = new Thread(task, "Beta");
        Thread t3 = new Thread(task, "Gamma");
        
        t1.start();
        t2.start();
        t3.start();
        
        t1.join();
        t2.join();
        t3.join();
        
        System.out.println("All done!");
    }
}
```

---

> **Next Topic:** [11 - File Handling](11-file-handling.md)
