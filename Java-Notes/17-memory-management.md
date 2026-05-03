# 17. Java Memory Management

## Table of Contents
- [17.1 Memory Areas in JVM](#171-memory-areas-in-jvm)
- [17.2 Heap vs Stack](#172-heap-vs-stack)
- [17.3 Garbage Collection](#173-garbage-collection)
- [17.4 Memory Leaks](#174-memory-leaks)
- [17.5 Practice & Assessment](#175-practice--assessment)

---

## 17.1 Memory Areas in JVM

```
┌─────────────────────────────────────────────────────────┐
│                     JVM Memory                           │
│                                                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │                HEAP MEMORY                        │   │
│  │  (shared by all threads)                          │   │
│  │                                                   │   │
│  │  ┌─────────────────┐  ┌────────────────────────┐ │   │
│  │  │  Young Generation│  │    Old Generation      │ │   │
│  │  │  ┌─────┐ ┌────┐ │  │                        │ │   │
│  │  │  │Eden │ │S0│S1│ │  │  (long-lived objects)  │ │   │
│  │  │  │     │ │  │  │ │  │                        │ │   │
│  │  │  └─────┘ └────┘ │  └────────────────────────┘ │   │
│  │  └─────────────────┘                             │   │
│  └──────────────────────────────────────────────────┘   │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ Stack (T1)   │  │ Stack (T2)   │  │  Method Area │  │
│  │ (per thread) │  │ (per thread) │  │  (classes,   │  │
│  │              │  │              │  │   statics)   │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
```

| Memory Area | Stores | Shared? |
|-------------|--------|---------|
| **Heap** | Objects, instance variables | Yes (all threads) |
| **Stack** | Local variables, method calls, references | No (per thread) |
| **Method Area** | Class metadata, static variables, constants | Yes |
| **PC Register** | Current instruction address | No (per thread) |
| **Native Method Stack** | Native (C/C++) method calls | No (per thread) |

---

## 17.2 Heap vs Stack

### Stack Memory

```java
public class Main {
    public static void main(String[] args) {  // Frame 1: main
        int x = 10;                           // x stored in stack
        int y = 20;                           // y stored in stack
        int sum = add(x, y);                  // Frame 2: add() pushed
        System.out.println(sum);              // Frame 2 popped after return
    }                                         // Frame 1 popped
    
    static int add(int a, int b) {            // a, b in new stack frame
        int result = a + b;                   // result in stack
        return result;                        // frame destroyed after return
    }
}
```

```
Stack (grows downward):
┌─────────────────────┐
│  add() frame        │ ← popped after return
│    a = 10           │
│    b = 20           │
│    result = 30      │
├─────────────────────┤
│  main() frame       │
│    x = 10           │
│    y = 20           │
│    sum = 30         │
│    args (reference) │
└─────────────────────┘
```

### Heap Memory

```java
public class Main {
    public static void main(String[] args) {
        Student s1 = new Student("Alice", 20);
        Student s2 = new Student("Bob", 22);
        // s1, s2 are references on STACK
        // Student objects are on HEAP
    }
}
```

```
Stack                          Heap
┌─────────────┐               ┌──────────────────┐
│ s1 ─────────────────────►   │ Student Object   │
│             │               │ name → "Alice"    │
│ s2 ─────────────────────►   │ age = 20         │
│             │            │  └──────────────────┘
└─────────────┘            │  ┌──────────────────┐
                           └► │ Student Object   │
                              │ name → "Bob"      │
                              │ age = 22         │
                              └──────────────────┘
```

### Heap vs Stack Comparison

| Feature | Stack | Heap |
|---------|-------|------|
| Stores | Primitives, references, method frames | Objects |
| Size | Small (thread-specific) | Large (shared) |
| Speed | Very fast (LIFO) | Slower (dynamic allocation) |
| Lifetime | Until method returns | Until garbage collected |
| Thread-safe | Yes (private to thread) | No (shared, needs sync) |
| Error | StackOverflowError | OutOfMemoryError |
| Management | Automatic (method exit) | Garbage Collector |

---

## 17.3 Garbage Collection

### Definition
**Garbage Collection (GC)** is the automatic process of identifying and reclaiming memory occupied by objects that are no longer reachable.

### When is an Object Eligible for GC?

```java
// 1. Nulling reference
Student s = new Student("Alice", 20);
s = null;  // Object now unreachable → eligible for GC

// 2. Reassigning reference
Student s = new Student("Alice", 20);
s = new Student("Bob", 22);  // First object unreachable

// 3. Object created inside method (after method returns)
void createStudent() {
    Student s = new Student("Temp", 0);  // Eligible after method returns
}

// 4. Island of isolation
class Node {
    Node next;
}
Node a = new Node();
Node b = new Node();
a.next = b;
b.next = a;
a = null;
b = null;
// Both objects reference each other but no external reference exists
// BOTH are eligible for GC (island of isolation)
```

### Generational GC

```
Object Lifecycle:
  new Object() → Eden → Survivor 0 → Survivor 1 → ... → Old Generation
                  (if survives Minor GC, promoted)

Types of GC:
  Minor GC: Cleans Young Generation (fast, frequent)
  Major GC: Cleans Old Generation (slower, less frequent)
  Full GC:  Cleans entire heap (slowest, avoid if possible)
```

### Requesting GC (Not Guaranteed!)

```java
System.gc();            // Request (JVM may ignore)
Runtime.getRuntime().gc();  // Same — just a request
```

### finalize() Method (Deprecated)

```java
// Called before GC collects the object (deprecated since Java 9)
@Override
protected void finalize() throws Throwable {
    System.out.println("Object being garbage collected");
    super.finalize();
}
// DON'T rely on this — use try-with-resources instead
```

### GC Algorithms

| Algorithm | Description |
|-----------|-------------|
| **Serial GC** | Single-threaded, simple. For small apps. |
| **Parallel GC** | Multi-threaded. Good throughput. |
| **G1 GC** | Divides heap into regions. Default in Java 9+. |
| **ZGC** | Ultra-low pause times (< 10ms). Java 11+. |

---

## 17.4 Memory Leaks

### Definition
A **memory leak** occurs when objects are no longer needed but still referenced, preventing GC from collecting them.

### Common Causes

```java
// 1. Static collections that keep growing
class Cache {
    private static List<Object> cache = new ArrayList<>();
    
    static void add(Object obj) {
        cache.add(obj);  // Never removed! Grows forever!
    }
}

// 2. Unclosed resources
void readFile() {
    FileInputStream fis = new FileInputStream("data.txt");
    // If exception occurs here, fis never closed → leak!
    fis.close();
}
// Fix: use try-with-resources

// 3. Inner class holding outer class reference
class Outer {
    byte[] largeData = new byte[10_000_000];  // 10MB
    
    class Inner {
        // Inner class holds implicit reference to Outer
        // Even if Outer is no longer needed, it can't be GC'd
    }
}

// 4. Listeners not unregistered
button.addActionListener(listener);
// If button is removed but listener still referenced → leak
```

### Prevention

| Practice | Why |
|----------|-----|
| Use try-with-resources | Ensures streams/connections closed |
| Limit static collections | Prevent unbounded growth |
| Use WeakReference | Allow GC to collect if no strong refs |
| Unregister listeners | Remove references when not needed |
| Profile with tools | VisualVM, JProfiler, Eclipse MAT |

---

## 17.5 Practice & Assessment

### MCQs

**Q1.** Local variables are stored in:
- A) Heap
- B) Stack
- C) Method Area
- D) PC Register

**Answer:** B — Local variables and method frames are on the stack.

---

**Q2.** When is an object eligible for garbage collection?
- A) When created
- B) When no references point to it
- C) When `System.gc()` is called
- D) After 5 minutes

**Answer:** B — When no reachable reference exists.

---

**Q3.** `StackOverflowError` occurs due to:
- A) Too many objects
- B) Infinite recursion (too many method frames)
- C) Memory leak
- D) Thread deadlock

**Answer:** B — Each recursive call adds a frame; infinite recursion fills the stack.

---

### Output Prediction

```java
public class Main {
    public static void main(String[] args) {
        String s1 = "Hello";        // String Pool
        String s2 = new String("Hello");  // Heap
        String s3 = "Hello";        // Same pool reference as s1
        
        System.out.println(s1 == s3);      // ?
        System.out.println(s1 == s2);      // ?
        System.out.println(s1.equals(s2)); // ?
    }
}
```

**Output:**
```
true   ← Same String Pool reference
false  ← Different objects (pool vs heap)
true   ← Same content
```

---

### Coding Task

**Task:** Demonstrate stack overflow with infinite recursion, then fix it.

```java
// CAUSES StackOverflowError
static void infinite() {
    infinite();  // Never stops!
}

// FIXED with base case
static int factorial(int n) {
    if (n <= 1) return 1;  // Base case — stops recursion
    return n * factorial(n - 1);
}
```

---

> **Next Topic:** [18 - Cheat Sheet](18-cheat-sheet.md)
