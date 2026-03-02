# 📦 Java Collections Framework & Interview Programs

> **Complete guide covering Collections, Java 8 Features, and must-know Interview Programs.**

---

## Table of Contents

- [Java Collections Framework](#java-collections-framework)
  - [What is Collections Framework?](#what-is-collections-framework)
  - [Collection Hierarchy](#collection-hierarchy)
  - [List Interface](#list-interface)
    - [ArrayList](#arraylist)
    - [LinkedList](#linkedlist)
    - [Vector](#vector)
    - [Stack](#stack)
  - [Set Interface](#set-interface)
    - [HashSet](#hashset)
    - [LinkedHashSet](#linkedhashset)
    - [TreeSet](#treeset)
  - [Map Interface](#map-interface)
    - [HashMap](#hashmap)
    - [LinkedHashMap](#linkedhashmap)
    - [TreeMap](#treemap)
    - [Hashtable](#hashtable)
  - [Iterator](#iterator)
  - [Comparable](#comparable)
  - [Comparator](#comparator)
- [Java 8 Features](#java-8-features)
  - [Lambda Expressions](#lambda-expressions)
  - [Functional Interfaces](#functional-interfaces)
  - [Streams API](#streams-api)
- [Important Interview Programs](#important-interview-programs)
- [Practice Sections](#practice-sections)

---

# Java Collections Framework

## What is Collections Framework?

### Concept Explanation

The **Java Collections Framework (JCF)** is a unified architecture for representing and manipulating groups of objects. It provides:

- **Interfaces** – Abstract data types (List, Set, Map, Queue)
- **Implementations** – Concrete classes (ArrayList, HashSet, HashMap, etc.)
- **Algorithms** – Utility methods (sorting, searching, shuffling)

> Before Collections Framework, Java used arrays, `Vector`, `Hashtable`, and `Dictionary`. These had no common interface and were hard to extend.

### Why Use Collections?

| Feature | Arrays | Collections |
|---------|--------|-------------|
| Size | Fixed | Dynamic |
| Type Safety | No generics (raw) | Generics supported |
| Data Structures | Only linear | List, Set, Map, Queue |
| Utility Methods | None | sort, search, reverse etc. |
| Performance | Fast for primitives | Slightly slower (boxing) |

### Collection Hierarchy

```
                     Iterable (interface)
                         |
                    Collection (interface)
                   /        |        \
                List       Set      Queue
               / | \      / | \       |
      ArrayList  |  Vector HashSet | TreeSet  PriorityQueue
          LinkedList  Stack  LinkedHashSet

                    Map (interface)  ← separate hierarchy
                   / |  \     \
            HashMap  |  TreeMap  Hashtable
         LinkedHashMap
```

### Visual Diagram

```
┌──────────────────────────────────────────────────────────────┐
│                    Collection Framework                       │
├──────────────────────┬───────────────────────────────────────┤
│   Collection (I)     │         Map (I)                       │
├──────┬───────┬───────┼──────┬──────────┬────────────────────┤
│ List │  Set  │ Queue │HashMap│LinkedHash│TreeMap│Hashtable   │
│  (I) │  (I)  │  (I)  │      │   Map    │      │            │
├──────┼───────┼───────┤      │          │      │            │
│Array │Hash   │Priority│      │          │      │            │
│List  │Set    │Queue  │      │          │      │            │
│Linked│Linked │       │      │          │      │            │
│List  │HashSet│       │      │          │      │            │
│Vector│TreeSet│       │      │          │      │            │
│Stack │       │       │      │          │      │            │
└──────┴───────┴───────┴──────┴──────────┴──────┴────────────┘
```

---

## List Interface

> **Ordered collection that allows duplicates.** Elements can be accessed by index.

### Key Features
- Maintains **insertion order**
- Allows **duplicate** elements
- Allows **null** values
- Elements accessed by **index** (0-based)

---

### ArrayList

#### Concept Explanation

`ArrayList` is a **resizable array** implementation of the `List` interface. Internally it uses a **dynamic array** that grows automatically when elements are added.

#### Internal Working

```
Initial capacity = 10 (default)
When full → new capacity = oldCapacity + (oldCapacity >> 1)  // 1.5x growth
Elements stored in Object[] elementData
```

```
Step 1: ArrayList created → Object[10] allocated
Step 2: Elements added at index 0, 1, 2...
Step 3: When array full → new array of size 15 created
Step 4: Old elements copied to new array (System.arraycopy)
Step 5: New element added
```

#### When to Use
- Frequent **read/access** operations
- Less frequent **insert/delete** in middle
- Random access needed

#### Syntax

```java
import java.util.ArrayList;

// Create ArrayList
ArrayList<String> list = new ArrayList<>();          // default capacity 10
ArrayList<Integer> nums = new ArrayList<>(20);       // initial capacity 20
ArrayList<String> copy = new ArrayList<>(otherList); // from another collection
```

#### Example Code

```java
import java.util.ArrayList;
import java.util.Collections;

public class ArrayListDemo {
    public static void main(String[] args) {
        // Creating ArrayList
        ArrayList<String> fruits = new ArrayList<>();

        // Adding elements
        fruits.add("Apple");       // [Apple]
        fruits.add("Banana");      // [Apple, Banana]
        fruits.add("Cherry");      // [Apple, Banana, Cherry]
        fruits.add(1, "Mango");    // [Apple, Mango, Banana, Cherry] — insert at index 1

        // Accessing elements
        System.out.println("Element at index 2: " + fruits.get(2)); // Banana

        // Modifying elements
        fruits.set(0, "Grapes");   // [Grapes, Mango, Banana, Cherry]

        // Removing elements
        fruits.remove("Banana");   // by value
        fruits.remove(0);          // by index

        // Size
        System.out.println("Size: " + fruits.size());

        // Check existence
        System.out.println("Contains Mango? " + fruits.contains("Mango"));

        // Sorting
        fruits.add("Apple");
        fruits.add("Banana");
        Collections.sort(fruits);  // Natural order
        System.out.println("Sorted: " + fruits);

        // Iterating
        System.out.println("\n--- For-each loop ---");
        for (String fruit : fruits) {
            System.out.println(fruit);
        }

        // Clear all
        fruits.clear();
        System.out.println("After clear, size: " + fruits.size()); // 0
    }
}
```

#### Output

```
Element at index 2: Banana
Size: 2
Contains Mango? true
Sorted: [Apple, Banana, Cherry, Mango]

--- For-each loop ---
Apple
Banana
Cherry
Mango
After clear, size: 0
```

#### Common Mistakes

| Mistake | Why It's Wrong |
|---------|---------------|
| `ArrayList<int> list` | Primitives not allowed; use `Integer` |
| `list.remove(1)` on Integer list | Removes by **index**, not value. Use `list.remove(Integer.valueOf(1))` |
| Modifying list during for-each | Causes `ConcurrentModificationException` |
| Not specifying generic type | Leads to raw type warnings and `ClassCastException` |

#### Interview Tips

- ArrayList is **not synchronized** (not thread-safe)
- Default capacity is **10**, grows by **50%**
- `get(index)` is **O(1)**, `add(element)` amortized **O(1)**, `add(index, element)` is **O(n)**
- Use `Collections.synchronizedList()` for thread safety
- `ArrayList` vs `Arrays.asList()`: latter returns **fixed-size** list

---

### LinkedList

#### Concept Explanation

`LinkedList` implements both `List` and `Deque` interfaces. Internally uses a **doubly linked list** — each element (node) stores data + reference to next and previous nodes.

#### Internal Working

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│ prev:null│◄───►│ prev: ●  │◄───►│ prev: ●  │
│ data: 10 │     │ data: 20 │     │ data: 30 │
│ next: ●  │     │ next: ●  │     │ next:null │
└──────────┘     └──────────┘     └──────────┘
    HEAD                              TAIL
```

#### When to Use
- Frequent **insertions/deletions** at beginning or middle
- Implementing **Queue** or **Deque**
- No random access needed

#### Example Code

```java
import java.util.LinkedList;

public class LinkedListDemo {
    public static void main(String[] args) {
        LinkedList<String> list = new LinkedList<>();

        // Add elements
        list.add("A");          // [A]
        list.addFirst("B");     // [B, A]
        list.addLast("C");      // [B, A, C]
        list.add(1, "D");       // [B, D, A, C]

        System.out.println("List: " + list);

        // Access
        System.out.println("First: " + list.getFirst());   // B
        System.out.println("Last: " + list.getLast());      // C
        System.out.println("Index 2: " + list.get(2));      // A

        // Remove
        list.removeFirst();     // [D, A, C]
        list.removeLast();      // [D, A]
        System.out.println("After removal: " + list);

        // As Queue (FIFO)
        LinkedList<Integer> queue = new LinkedList<>();
        queue.offer(10);   // enqueue
        queue.offer(20);
        queue.offer(30);
        System.out.println("Poll: " + queue.poll());   // 10 (dequeue)
        System.out.println("Peek: " + queue.peek());   // 20 (front element)
    }
}
```

#### Output

```
List: [B, D, A, C]
First: B
Last: C
Index 2: A
After removal: [D, A]
Poll: 10
Peek: 20
```

#### ArrayList vs LinkedList

| Feature | ArrayList | LinkedList |
|---------|-----------|------------|
| Internal Structure | Dynamic Array | Doubly Linked List |
| Random Access `get(i)` | O(1) ✅ | O(n) ❌ |
| Insert at beginning | O(n) ❌ | O(1) ✅ |
| Insert at end | O(1) amortized | O(1) |
| Memory | Less (contiguous) | More (node pointers) |
| Cache Performance | Better | Worse |
| Implements | List | List + Deque |

---

### Vector

#### Concept Explanation

`Vector` is the **legacy** synchronized version of `ArrayList`. It was part of Java 1.0, before the Collections Framework was introduced.

#### Key Differences from ArrayList

| Feature | ArrayList | Vector |
|---------|-----------|--------|
| Synchronization | Not synchronized | Synchronized |
| Growth | 50% | 100% (doubles) |
| Performance | Faster | Slower (due to sync) |
| Legacy | Modern | Legacy (Java 1.0) |

#### Example Code

```java
import java.util.Vector;

public class VectorDemo {
    public static void main(String[] args) {
        Vector<Integer> vec = new Vector<>();

        // Add elements
        vec.add(10);
        vec.add(20);
        vec.add(30);

        // Access
        System.out.println("Element at 1: " + vec.get(1));       // 20
        System.out.println("First: " + vec.firstElement());        // 10
        System.out.println("Last: " + vec.lastElement());          // 30

        // Capacity
        System.out.println("Size: " + vec.size());                 // 3
        System.out.println("Capacity: " + vec.capacity());         // 10 (default)

        // Enumeration (legacy way)
        java.util.Enumeration<Integer> e = vec.elements();
        while (e.hasMoreElements()) {
            System.out.print(e.nextElement() + " ");
        }
    }
}
```

> **Interview Tip:** Prefer `ArrayList` + `Collections.synchronizedList()` or `CopyOnWriteArrayList` over `Vector`.

---

### Stack

#### Concept Explanation

`Stack` extends `Vector` and represents a **LIFO (Last-In-First-Out)** data structure. It adds five operations: `push`, `pop`, `peek`, `empty`, `search`.

#### Visual Diagram

```
        ┌─────┐
push →  │  30 │  ← peek() / pop()
        ├─────┤
        │  20 │
        ├─────┤
        │  10 │
        └─────┘
        STACK (LIFO)
```

#### Example Code

```java
import java.util.Stack;

public class StackDemo {
    public static void main(String[] args) {
        Stack<Integer> stack = new Stack<>();

        // Push elements
        stack.push(10);
        stack.push(20);
        stack.push(30);
        System.out.println("Stack: " + stack);        // [10, 20, 30]

        // Peek (top element without removing)
        System.out.println("Peek: " + stack.peek());  // 30

        // Pop (remove top element)
        System.out.println("Pop: " + stack.pop());    // 30
        System.out.println("After pop: " + stack);     // [10, 20]

        // Search (1-based position from top)
        System.out.println("Search 10: " + stack.search(10)); // 2

        // Empty check
        System.out.println("Empty? " + stack.empty()); // false
    }
}
```

> **Interview Tip:** `Stack` is legacy. Prefer `Deque` (ArrayDeque) for stack operations:
> ```java
> Deque<Integer> stack = new ArrayDeque<>();
> stack.push(10);
> stack.pop();
> ```

---

### Quick Revision – List Interface

| Class | Order | Duplicates | Null | Thread-Safe | Internal Structure |
|-------|-------|------------|------|-------------|-------------------|
| ArrayList | Insertion | Yes | Yes | No | Dynamic Array |
| LinkedList | Insertion | Yes | Yes | No | Doubly Linked List |
| Vector | Insertion | Yes | Yes | Yes | Dynamic Array |
| Stack | LIFO | Yes | Yes | Yes | Dynamic Array |

---

## Set Interface

> **Unordered collection that does NOT allow duplicates.**

### Key Features
- No duplicate elements
- At most **one null** (HashSet/LinkedHashSet), **no null** (TreeSet)
- No index-based access

---

### HashSet

#### Concept Explanation

`HashSet` implements the `Set` interface. Internally it uses a **HashMap** – elements are stored as **keys** of the internal HashMap with a dummy constant value.

#### Internal Working

```
HashSet<String> set = new HashSet<>();
set.add("Apple");

// Internally:
// HashMap<String, Object> map = new HashMap<>();
// map.put("Apple", PRESENT);  // PRESENT = new Object()
```

```
Hashing Process:
1. hashCode() of element is calculated
2. Index = hashCode % capacity
3. Element stored in bucket at that index
4. If collision → linked list / tree (Java 8+)
```

#### When to Use
- Need **unique** elements
- Don't care about **order**
- Fast **lookup/add/remove** (O(1) average)

#### Example Code

```java
import java.util.HashSet;

public class HashSetDemo {
    public static void main(String[] args) {
        HashSet<String> set = new HashSet<>();

        // Add elements
        set.add("Java");
        set.add("Python");
        set.add("C++");
        set.add("Java");      // Duplicate — ignored
        set.add(null);         // One null allowed

        System.out.println("Set: " + set);              // Unordered
        System.out.println("Size: " + set.size());       // 4

        // Check existence
        System.out.println("Contains Java? " + set.contains("Java")); // true

        // Remove
        set.remove("C++");
        System.out.println("After removal: " + set);

        // Iterate
        for (String s : set) {
            System.out.println(s);
        }
    }
}
```

#### Output (order may vary)

```
Set: [null, Java, C++, Python]
Size: 4
Contains Java? true
After removal: [null, Java, Python]
```

---

### LinkedHashSet

#### Concept Explanation

`LinkedHashSet` extends `HashSet` and maintains **insertion order** using a **doubly-linked list** running through all entries.

#### Internal Working

```
┌───────┐    ┌───────┐    ┌───────┐
│  Java │───►│Python │───►│  C++  │   (Linked list maintains order)
└───┬───┘    └───┬───┘    └───┬───┘
    │            │            │
  bucket 3    bucket 7    bucket 1    (Hash table for fast access)
```

#### Example Code

```java
import java.util.LinkedHashSet;

public class LinkedHashSetDemo {
    public static void main(String[] args) {
        LinkedHashSet<String> set = new LinkedHashSet<>();

        set.add("Banana");
        set.add("Apple");
        set.add("Cherry");
        set.add("Apple");  // Duplicate — ignored

        System.out.println("Set: " + set);  // [Banana, Apple, Cherry] — insertion order
    }
}
```

---

### TreeSet

#### Concept Explanation

`TreeSet` implements `NavigableSet` interface. Internally uses a **Red-Black Tree** (self-balancing BST). Elements are stored in **sorted (natural) order**.

#### Internal Working

```
        ┌───┐
        │ 20│          Red-Black Tree
       / \
    ┌───┐ ┌───┐
    │ 10│ │ 30│
    └───┘ └───┘
       \
     ┌───┐
     │ 15│
     └───┘
```

#### When to Use
- Need **sorted** unique elements
- Range queries (`subSet`, `headSet`, `tailSet`)
- First/Last element access

#### Example Code

```java
import java.util.TreeSet;

public class TreeSetDemo {
    public static void main(String[] args) {
        TreeSet<Integer> set = new TreeSet<>();

        set.add(30);
        set.add(10);
        set.add(20);
        set.add(50);
        set.add(40);

        System.out.println("Sorted Set: " + set);         // [10, 20, 30, 40, 50]
        System.out.println("First: " + set.first());       // 10
        System.out.println("Last: " + set.last());          // 50
        System.out.println("Head (<30): " + set.headSet(30));     // [10, 20]
        System.out.println("Tail (>=30): " + set.tailSet(30));    // [30, 40, 50]
        System.out.println("Sub (20-40): " + set.subSet(20, 40)); // [20, 30]
        System.out.println("Floor (25): " + set.floor(25));       // 20
        System.out.println("Ceiling (25): " + set.ceiling(25));   // 30

        // TreeSet does NOT allow null (throws NullPointerException)
        // set.add(null); // ❌ NullPointerException
    }
}
```

#### Output

```
Sorted Set: [10, 20, 30, 40, 50]
First: 10
Last: 50
Head (<30): [10, 20]
Tail (>=30): [30, 40, 50]
Sub (20-40): [20, 30]
Floor (25): 20
Ceiling (25): 30
```

---

### Quick Revision – Set Interface

| Class | Order | Duplicates | Null | Thread-Safe | Internal Structure | Performance |
|-------|-------|------------|------|-------------|-------------------|-------------|
| HashSet | No order | No | 1 null | No | HashMap | O(1) |
| LinkedHashSet | Insertion | No | 1 null | No | HashMap + LinkedList | O(1) |
| TreeSet | Sorted | No | No null | No | Red-Black Tree | O(log n) |

---

## Map Interface

> **Stores key-value pairs. Keys must be unique.**

### Key Features
- No duplicate **keys** (values can duplicate)
- Each key maps to exactly one value
- Not part of `Collection` interface hierarchy

---

### HashMap

#### Concept Explanation

`HashMap` stores data in **key-value pairs** using **hashing**. Internally uses an **array of linked lists** (buckets). Since Java 8, when a bucket has more than 8 entries, the linked list converts to a **balanced tree**.

#### Internal Working

```
Bucket Array (Node<K,V>[]):
Index 0: null
Index 1: [Key="Apple", Value=1] → [Key="Grape", Value=5] (collision chain)
Index 2: null
Index 3: [Key="Banana", Value=2]
Index 4: null
...

Steps:
1. hash = key.hashCode()
2. index = hash & (capacity - 1)
3. Store/retrieve at that index
4. If collision → chain (linked list → tree if ≥ 8)
```

#### Key Properties
- Default capacity: **16**
- Load factor: **0.75** (rehash at 75% full)
- Allows **one null key** and **multiple null values**
- **Not synchronized**

#### Example Code

```java
import java.util.HashMap;
import java.util.Map;

public class HashMapDemo {
    public static void main(String[] args) {
        HashMap<String, Integer> map = new HashMap<>();

        // Put key-value pairs
        map.put("Java", 90);
        map.put("Python", 85);
        map.put("C++", 80);
        map.put("Java", 95);  // Overwrites previous value for "Java"

        System.out.println("Map: " + map);

        // Get value by key
        System.out.println("Java score: " + map.get("Java"));       // 95
        System.out.println("Ruby score: " + map.get("Ruby"));       // null

        // getOrDefault
        System.out.println("Ruby: " + map.getOrDefault("Ruby", 0)); // 0

        // Check key/value existence
        System.out.println("Has Java? " + map.containsKey("Java"));     // true
        System.out.println("Has value 80? " + map.containsValue(80));   // true

        // Remove
        map.remove("C++");

        // Size
        System.out.println("Size: " + map.size());   // 2

        // Iterate – Entry Set
        System.out.println("\n--- Iterating ---");
        for (Map.Entry<String, Integer> entry : map.entrySet()) {
            System.out.println(entry.getKey() + " = " + entry.getValue());
        }

        // Iterate – Keys only
        for (String key : map.keySet()) {
            System.out.println("Key: " + key);
        }

        // Iterate – Values only
        for (int value : map.values()) {
            System.out.println("Value: " + value);
        }
    }
}
```

#### Output

```
Map: {Java=95, C++=80, Python=85}
Java score: 95
Ruby score: null
Ruby: 0
Has Java? true
Has value 80? true
Size: 2

--- Iterating ---
Java = 95
Python = 85
Key: Java
Key: Python
Value: 95
Value: 85
```

#### Common Mistakes

| Mistake | Explanation |
|---------|------------|
| Using mutable key | If key's hashCode changes, entry becomes unretrievable |
| Not overriding `hashCode()` with `equals()` | Custom objects won't work correctly as keys |
| Assuming order | HashMap does NOT guarantee order |
| Thread-safe assumption | HashMap is NOT thread-safe |

---

### LinkedHashMap

#### Concept Explanation

`LinkedHashMap` extends `HashMap` and maintains **insertion order** (or optionally **access order**) using a doubly-linked list.

#### Example Code

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class LinkedHashMapDemo {
    public static void main(String[] args) {
        // Insertion-order (default)
        LinkedHashMap<String, Integer> map = new LinkedHashMap<>();
        map.put("Banana", 2);
        map.put("Apple", 1);
        map.put("Cherry", 3);

        System.out.println("Insertion order: " + map); // {Banana=2, Apple=1, Cherry=3}

        // Access-order (useful for LRU Cache)
        LinkedHashMap<String, Integer> lruMap = new LinkedHashMap<>(16, 0.75f, true);
        lruMap.put("A", 1);
        lruMap.put("B", 2);
        lruMap.put("C", 3);
        lruMap.get("A");  // Access A → moves to end
        System.out.println("Access order: " + lruMap); // {B=2, C=3, A=1}
    }
}
```

#### Interview Tip – LRU Cache using LinkedHashMap

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class LRUCache<K, V> extends LinkedHashMap<K, V> {
    private final int capacity;

    public LRUCache(int capacity) {
        super(capacity, 0.75f, true); // access-order = true
        this.capacity = capacity;
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
        return size() > capacity; // Remove oldest when capacity exceeded
    }

    public static void main(String[] args) {
        LRUCache<Integer, String> cache = new LRUCache<>(3);
        cache.put(1, "A");
        cache.put(2, "B");
        cache.put(3, "C");
        cache.get(1);       // Access key 1
        cache.put(4, "D");  // Evicts key 2 (least recently used)
        System.out.println(cache); // {3=C, 1=A, 4=D}
    }
}
```

---

### TreeMap

#### Concept Explanation

`TreeMap` implements `NavigableMap` interface. Internally uses a **Red-Black Tree**. Keys are stored in **sorted (natural) order** or by a provided `Comparator`.

#### Example Code

```java
import java.util.TreeMap;

public class TreeMapDemo {
    public static void main(String[] args) {
        TreeMap<String, Integer> map = new TreeMap<>();

        map.put("Banana", 2);
        map.put("Apple", 1);
        map.put("Cherry", 3);
        map.put("Date", 4);

        System.out.println("Sorted Map: " + map);
        // {Apple=1, Banana=2, Cherry=3, Date=4}

        System.out.println("First Key: " + map.firstKey());         // Apple
        System.out.println("Last Key: " + map.lastKey());           // Date
        System.out.println("Lower (Cherry): " + map.lowerKey("Cherry"));   // Banana
        System.out.println("Higher (Cherry): " + map.higherKey("Cherry")); // Date
        System.out.println("Head Map: " + map.headMap("Cherry"));          // {Apple=1, Banana=2}
        System.out.println("Tail Map: " + map.tailMap("Cherry"));          // {Cherry=3, Date=4}

        // TreeMap does NOT allow null key
        // map.put(null, 0); // ❌ NullPointerException
    }
}
```

---

### Hashtable

#### Concept Explanation

`Hashtable` is a **legacy** synchronized map. It was part of Java 1.0. It does **NOT allow null keys or null values**.

#### Hashtable vs HashMap

| Feature | HashMap | Hashtable |
|---------|---------|-----------|
| Null key | 1 allowed | ❌ Not allowed |
| Null value | Multiple allowed | ❌ Not allowed |
| Synchronized | No | Yes |
| Performance | Faster | Slower |
| Legacy | Modern | Legacy (Java 1.0) |
| Iterator | Fail-fast | Enumerator (not fail-fast) |

#### Example Code

```java
import java.util.Hashtable;

public class HashtableDemo {
    public static void main(String[] args) {
        Hashtable<String, Integer> table = new Hashtable<>();

        table.put("Java", 1);
        table.put("Python", 2);
        // table.put(null, 3);    // ❌ NullPointerException
        // table.put("Go", null); // ❌ NullPointerException

        System.out.println("Table: " + table);
        System.out.println("Java: " + table.get("Java"));
    }
}
```

> **Interview Tip:** Prefer `ConcurrentHashMap` over `Hashtable` for thread-safe operations — it uses **segment-level locking** instead of locking the entire map.

---

### Quick Revision – Map Interface

| Class | Order | Null Key | Null Value | Thread-Safe | Internal Structure |
|-------|-------|----------|------------|-------------|-------------------|
| HashMap | No order | 1 | Multiple | No | Hash Table |
| LinkedHashMap | Insertion/Access | 1 | Multiple | No | Hash Table + Linked List |
| TreeMap | Sorted | No | Multiple | No | Red-Black Tree |
| Hashtable | No order | No | No | Yes | Hash Table |

---

## Iterator

### Concept Explanation

`Iterator` is an interface that provides methods to traverse a collection one element at a time. It supports **safe removal** during iteration (unlike for-each loop).

### Methods

| Method | Description |
|--------|-------------|
| `hasNext()` | Returns `true` if more elements exist |
| `next()` | Returns the next element |
| `remove()` | Removes the last element returned by `next()` |

### Example Code

```java
import java.util.ArrayList;
import java.util.Iterator;
import java.util.ListIterator;

public class IteratorDemo {
    public static void main(String[] args) {
        ArrayList<String> list = new ArrayList<>();
        list.add("A");
        list.add("B");
        list.add("C");
        list.add("D");

        // Iterator — forward only
        System.out.println("--- Iterator ---");
        Iterator<String> it = list.iterator();
        while (it.hasNext()) {
            String val = it.next();
            if (val.equals("B")) {
                it.remove();  // Safe removal during iteration
            } else {
                System.out.println(val);
            }
        }
        System.out.println("After removal: " + list);

        // ListIterator — bidirectional
        System.out.println("\n--- ListIterator (backward) ---");
        ListIterator<String> lit = list.listIterator(list.size());
        while (lit.hasPrevious()) {
            System.out.println(lit.previous());
        }
    }
}
```

#### Output

```
--- Iterator ---
A
C
D
After removal: [A, C, D]

--- ListIterator (backward) ---
D
C
A
```

### Iterator vs For-each

| Feature | Iterator | For-each |
|---------|----------|----------|
| Remove during iteration | ✅ Yes | ❌ ConcurrentModificationException |
| Bidirectional | ✅ ListIterator | ❌ No |
| Works with | Collection | Collection + Array |

---

## Comparable

### Concept Explanation

`Comparable` interface defines **natural ordering** for objects of a class. The class itself implements Comparable and overrides `compareTo()`.

### Syntax

```java
public class Student implements Comparable<Student> {
    @Override
    public int compareTo(Student other) {
        // Return negative if this < other
        // Return 0 if this == other
        // Return positive if this > other
    }
}
```

### Example Code

```java
import java.util.ArrayList;
import java.util.Collections;

class Student implements Comparable<Student> {
    String name;
    int marks;

    Student(String name, int marks) {
        this.name = name;
        this.marks = marks;
    }

    @Override
    public int compareTo(Student other) {
        return this.marks - other.marks;  // Ascending by marks
    }

    @Override
    public String toString() {
        return name + "(" + marks + ")";
    }
}

public class ComparableDemo {
    public static void main(String[] args) {
        ArrayList<Student> students = new ArrayList<>();
        students.add(new Student("Alice", 85));
        students.add(new Student("Bob", 92));
        students.add(new Student("Charlie", 78));

        Collections.sort(students);  // Uses compareTo()
        System.out.println("Sorted by marks: " + students);
        // [Charlie(78), Alice(85), Bob(92)]
    }
}
```

---

## Comparator

### Concept Explanation

`Comparator` interface defines **custom ordering** that is external to the class. Useful when you want multiple ways to sort or can't modify the class.

### Syntax

```java
import java.util.Comparator;

Comparator<Student> byName = (s1, s2) -> s1.name.compareTo(s2.name);
```

### Example Code

```java
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

class Employee {
    String name;
    double salary;

    Employee(String name, double salary) {
        this.name = name;
        this.salary = salary;
    }

    @Override
    public String toString() {
        return name + "($" + salary + ")";
    }
}

public class ComparatorDemo {
    public static void main(String[] args) {
        ArrayList<Employee> emps = new ArrayList<>();
        emps.add(new Employee("Alice", 70000));
        emps.add(new Employee("Bob", 50000));
        emps.add(new Employee("Charlie", 60000));

        // Sort by salary (ascending)
        Comparator<Employee> bySalary = (e1, e2) -> Double.compare(e1.salary, e2.salary);
        Collections.sort(emps, bySalary);
        System.out.println("By Salary: " + emps);

        // Sort by name (alphabetical)
        Comparator<Employee> byName = (e1, e2) -> e1.name.compareTo(e2.name);
        Collections.sort(emps, byName);
        System.out.println("By Name: " + emps);

        // Sort by salary descending
        Collections.sort(emps, bySalary.reversed());
        System.out.println("By Salary Desc: " + emps);

        // Chained sort: by salary, then by name
        Comparator<Employee> chained = Comparator
                .comparingDouble((Employee e) -> e.salary)
                .thenComparing(e -> e.name);
        Collections.sort(emps, chained);
        System.out.println("Chained: " + emps);
    }
}
```

### Comparable vs Comparator

| Feature | Comparable | Comparator |
|---------|-----------|------------|
| Package | `java.lang` | `java.util` |
| Method | `compareTo(T o)` | `compare(T o1, T o2)` |
| Modifies class? | Yes | No |
| Sorting types | Single (natural) | Multiple (custom) |
| Usage | `Collections.sort(list)` | `Collections.sort(list, comparator)` |

---

### Quick Revision – Collections Framework

```
┌────────────────────────────────────────────────────────────┐
│ KEY POINTS TO REMEMBER                                      │
├────────────────────────────────────────────────────────────┤
│ • ArrayList → Dynamic array, fast random access             │
│ • LinkedList → Doubly linked, fast insert/delete            │
│ • HashSet → No duplicates, no order, uses HashMap           │
│ • TreeSet → Sorted, no duplicates, Red-Black tree           │
│ • HashMap → Key-value pairs, O(1) access, no order          │
│ • TreeMap → Sorted keys, O(log n) access                    │
│ • Iterator → Safe traversal with removal support            │
│ • Comparable → Natural ordering (class implements it)       │
│ • Comparator → Custom ordering (external to class)          │
│ • Legacy: Vector, Stack, Hashtable (synchronized)           │
│ • Modern thread-safe: ConcurrentHashMap, CopyOnWriteArrayList│
└────────────────────────────────────────────────────────────┘
```

---

## 📝 Practice Section – Collections Framework

### Level 1 – Very Simple Checks (10 Questions)

| # | Question | Answer |
|---|----------|--------|
| 1 | What interface does ArrayList implement? | `List` |
| 2 | Does HashSet allow duplicates? | No |
| 3 | What is the default capacity of HashMap? | 16 |
| 4 | Which Map allows null key? | HashMap (only one null key) |
| 5 | What data structure does TreeSet use internally? | Red-Black Tree |
| 6 | Is Hashtable synchronized? | Yes |
| 7 | What does `iterator.remove()` do? | Removes the last element returned by `next()` |
| 8 | Which interface is used for natural ordering? | Comparable |
| 9 | What is the growth factor of ArrayList? | 50% (1.5x) |
| 10 | Can TreeMap have null keys? | No |

### Level 2 – Concept MCQs (10 Questions)

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Which collection maintains insertion order? | A) HashSet B) LinkedHashSet C) TreeSet D) HashMap | **B** |
| 2 | What happens when you add a duplicate to HashSet? | A) Exception B) Replaces old C) Ignored D) Added at end | **C** |
| 3 | HashMap internally uses which data structure? | A) Array B) Linked List C) Array + Linked List/Tree D) BST | **C** |
| 4 | What is the load factor of HashMap? | A) 0.5 B) 0.75 C) 1.0 D) 0.25 | **B** |
| 5 | Which is fail-fast? | A) Hashtable Enumeration B) HashMap Iterator C) ConcurrentHashMap Iterator D) None | **B** |
| 6 | `Comparable` interface is in which package? | A) java.util B) java.lang C) java.io D) java.collection | **B** |
| 7 | Which allows bidirectional traversal? | A) Iterator B) Enumeration C) ListIterator D) Spliterator | **C** |
| 8 | ArrayList default capacity? | A) 0 B) 5 C) 10 D) 16 | **C** |
| 9 | Which does NOT allow null? | A) HashMap B) TreeMap C) LinkedHashMap D) Hashtable | **B and D** |
| 10 | Stack extends which class? | A) ArrayList B) LinkedList C) Vector D) AbstractList | **C** |

### Level 3 – Deep Understanding MCQs (5 Questions)

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | What happens if you modify an object used as HashMap key after insertion? | A) No effect B) Value updated C) Entry may become unretrievable D) Exception | **C** – The hash changes, so the lookup will use a different bucket |
| 2 | In Java 8+, when does HashMap bucket convert from linked list to tree? | A) 4 nodes B) 8 nodes C) 16 nodes D) When load factor exceeded | **B** – Threshold is TREEIFY_THRESHOLD = 8 |
| 3 | What does `Collections.unmodifiableList()` return? | A) A new copy B) A read-only view C) A synchronized list D) null | **B** – It's a wrapper; changes to original reflect in the view |
| 4 | If two objects are `equal()`, their `hashCode()` must be? | A) Different B) Same C) Any value D) Zero | **B** – Equal objects must have equal hashCodes (contract) |
| 5 | ConcurrentHashMap uses what for thread safety? | A) Synchronized methods B) Segment locking C) Full locking D) No locking | **B** – Uses bucket-level (segment) locking for better concurrency |

### Level 4 – Quick True/False (5 Questions)

| # | Statement | Answer |
|---|-----------|--------|
| 1 | HashMap is thread-safe | **False** |
| 2 | TreeSet allows null elements | **False** |
| 3 | LinkedList implements Deque interface | **True** |
| 4 | Comparator can sort objects in multiple ways | **True** |
| 5 | Vector grows by 50% when full | **False** (it doubles) |

### Level 5 – Small Coding Practice

**Exercise 1:** Remove all even numbers from an ArrayList using Iterator.

```java
import java.util.ArrayList;
import java.util.Iterator;

public class RemoveEvens {
    public static void main(String[] args) {
        ArrayList<Integer> list = new ArrayList<>();
        list.add(1); list.add(2); list.add(3); list.add(4); list.add(5);

        Iterator<Integer> it = list.iterator();
        while (it.hasNext()) {
            if (it.next() % 2 == 0) {
                it.remove();
            }
        }
        System.out.println(list); // [1, 3, 5]
    }
}
```

**Exercise 2:** Count frequency of each word in a string using HashMap.

```java
import java.util.HashMap;

public class WordFrequency {
    public static void main(String[] args) {
        String text = "java is great java is fun";
        String[] words = text.split(" ");

        HashMap<String, Integer> freq = new HashMap<>();
        for (String word : words) {
            freq.put(word, freq.getOrDefault(word, 0) + 1);
        }
        System.out.println(freq); // {java=2, is=2, great=1, fun=1}
    }
}
```

---

### 20 Tricky Interview MCQs – Collections Framework

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | What is returned by `map.put("a", 1)` if key "a" already maps to 5? | A) null B) 1 C) 5 D) Exception | **C** – `put()` returns previous value |
| 2 | Which Map implementation is best for LRU cache? | A) HashMap B) TreeMap C) LinkedHashMap D) Hashtable | **C** |
| 3 | `HashSet.add()` delegates to which HashMap method? | A) get() B) put() C) containsKey() D) remove() | **B** |
| 4 | What's the time complexity of `TreeMap.get()`? | A) O(1) B) O(n) C) O(log n) D) O(n log n) | **C** |
| 5 | Can you store different types in a raw ArrayList? | A) No B) Yes, but unsafe C) Compile error D) Runtime error | **B** |
| 6 | `Arrays.asList(1,2,3)` returns a list that is: | A) Resizable B) Fixed-size C) Unmodifiable D) Synchronized | **B** |
| 7 | Which Set gives O(1) for add, remove, and contains? | A) TreeSet B) LinkedHashSet C) HashSet D) Both B and C | **D** |
| 8 | What happens if `compareTo()` returns 0 in TreeSet? | A) Both stored B) Second ignored C) Exception D) Overwrites | **B** – TreeSet considers them equal |
| 9 | `ConcurrentHashMap` allows null keys? | A) Yes B) No C) Only one D) Only values | **B** |
| 10 | `Collections.synchronizedMap()` makes what thread-safe? | A) Iterator B) Entire map C) Only reads D) Only writes | **B** (but iterator still needs external sync) |
| 11 | Which is faster for frequent insertions at beginning? | A) ArrayList B) LinkedList C) Vector D) Stack | **B** |
| 12 | `IdentityHashMap` uses what for comparison? | A) equals() B) == C) hashCode() D) compareTo() | **B** |
| 13 | Default initial capacity of HashSet? | A) 10 B) 16 C) 32 D) 8 | **B** (backed by HashMap) |
| 14 | EnumSet internally uses: | A) HashMap B) Bit vector C) Array D) Tree | **B** |
| 15 | `WeakHashMap` entries are removed when: | A) Capacity reached B) Key garbage collected C) Value null D) Never | **B** |
| 16 | Which collection allows index-based access? | A) HashSet B) TreeSet C) ArrayList D) HashMap | **C** |
| 17 | `NavigableMap` is implemented by? | A) HashMap B) TreeMap C) LinkedHashMap D) Hashtable | **B** |
| 18 | What's the initial capacity when `new ArrayList<>()` is called? | A) 10 B) 0 C) 16 D) 1 | **B** (Java 8+ uses empty array, grows to 10 on first add) |
| 19 | `Deque` can be used as? | A) Stack only B) Queue only C) Both D) Neither | **C** |
| 20 | `PriorityQueue` ordering is based on? | A) Insertion order B) Natural order/Comparator C) Random D) LIFO | **B** |

---

# Java 8 Features

## Lambda Expressions

### Concept Explanation

A **lambda expression** is a concise way to represent an **anonymous function** (a function without a name). It enables **functional programming** in Java.

### Syntax

```java
// Full syntax
(parameters) -> { body }

// Single expression (no braces needed)
(parameters) -> expression

// Single parameter (no parentheses needed)
parameter -> expression

// No parameters
() -> expression
```

### Example Code

```java
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class LambdaDemo {
    public static void main(String[] args) {
        // Example 1: Runnable with lambda
        Runnable task = () -> System.out.println("Hello from Lambda!");
        new Thread(task).start();

        // Example 2: Comparator with lambda
        List<String> names = new ArrayList<>();
        names.add("Charlie");
        names.add("Alice");
        names.add("Bob");

        // Before Java 8
        // Collections.sort(names, new Comparator<String>() {
        //     public int compare(String a, String b) {
        //         return a.compareTo(b);
        //     }
        // });

        // With Lambda
        Collections.sort(names, (a, b) -> a.compareTo(b));
        System.out.println("Sorted: " + names);

        // Example 3: forEach with lambda
        names.forEach(name -> System.out.println("Name: " + name));

        // Example 4: Custom functional interface
        MathOperation add = (a, b) -> a + b;
        MathOperation multiply = (a, b) -> a * b;

        System.out.println("Add: " + add.operate(5, 3));        // 8
        System.out.println("Multiply: " + multiply.operate(5, 3)); // 15
    }
}

@FunctionalInterface
interface MathOperation {
    int operate(int a, int b);
}
```

#### Output

```
Hello from Lambda!
Sorted: [Alice, Bob, Charlie]
Name: Alice
Name: Bob
Name: Charlie
Add: 8
Multiply: 15
```

### Common Mistakes

| Mistake | Correct Way |
|---------|------------|
| Using lambda with non-functional interface | Interface must have exactly ONE abstract method |
| Modifying local variables inside lambda | Variables must be effectively final |
| Forgetting `@FunctionalInterface` | Not required but good practice for validation |

---

## Functional Interfaces

### Concept Explanation

A **Functional Interface** is an interface with exactly **one abstract method** (SAM – Single Abstract Method). It can have multiple default/static methods.

### Built-in Functional Interfaces (java.util.function)

| Interface | Method | Input | Output | Use Case |
|-----------|--------|-------|--------|----------|
| `Predicate<T>` | `test(T)` | T | boolean | Filtering |
| `Function<T,R>` | `apply(T)` | T | R | Transformation |
| `Consumer<T>` | `accept(T)` | T | void | Side effects |
| `Supplier<T>` | `get()` | none | T | Factory/Provider |
| `BiFunction<T,U,R>` | `apply(T,U)` | T, U | R | Two-input transform |
| `UnaryOperator<T>` | `apply(T)` | T | T | Same-type transform |
| `BinaryOperator<T>` | `apply(T,T)` | T, T | T | Reduce/combine |

### Example Code

```java
import java.util.function.*;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class FunctionalInterfaceDemo {
    public static void main(String[] args) {
        // Predicate — test condition
        Predicate<Integer> isEven = n -> n % 2 == 0;
        System.out.println("4 is even? " + isEven.test(4));   // true
        System.out.println("7 is even? " + isEven.test(7));   // false

        // Function — transform input to output
        Function<String, Integer> length = String::length;
        System.out.println("Length of Java: " + length.apply("Java")); // 4

        // Consumer — perform action, return nothing
        Consumer<String> printer = s -> System.out.println("Hello, " + s);
        printer.accept("World");   // Hello, World

        // Supplier — provide value, take no input
        Supplier<Double> randomNum = Math::random;
        System.out.println("Random: " + randomNum.get());

        // BinaryOperator — two inputs, same type output
        BinaryOperator<Integer> sum = Integer::sum;
        System.out.println("Sum: " + sum.apply(10, 20));   // 30

        // Chaining Predicates
        Predicate<Integer> isPositive = n -> n > 0;
        Predicate<Integer> isEvenAndPositive = isEven.and(isPositive);
        System.out.println("4 even & positive? " + isEvenAndPositive.test(4));   // true
        System.out.println("-2 even & positive? " + isEvenAndPositive.test(-2)); // false

        // Chaining Functions
        Function<Integer, Integer> doubleIt = n -> n * 2;
        Function<Integer, Integer> addThree = n -> n + 3;
        Function<Integer, Integer> doubleThenAdd = doubleIt.andThen(addThree);
        System.out.println("doubleThenAdd(5): " + doubleThenAdd.apply(5)); // 13
    }
}
```

---

## Streams API

### Concept Explanation

**Streams** provide a **declarative** way to process collections of data. They support functional-style operations like `filter`, `map`, `reduce`, `collect`.

> A Stream is **NOT a data structure** – it's a pipeline of operations on data.

### Stream Pipeline

```
Source → Intermediate Operations → Terminal Operation
  |            (lazy)                  (triggers execution)
  |              |                          |
Collection   filter, map,              collect, forEach,
Array        sorted, distinct           reduce, count
```

### Key Properties
- **Lazy evaluation** – Intermediate ops not executed until terminal op
- **Cannot be reused** – Once consumed, must create a new stream
- **Does not modify source** – Original collection unchanged
- **Supports parallelism** – `parallelStream()` for multi-threading

### Example Code

```java
import java.util.*;
import java.util.stream.*;

public class StreamDemo {
    public static void main(String[] args) {
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

        // 1. Filter — keep only even numbers
        List<Integer> evens = numbers.stream()
                .filter(n -> n % 2 == 0)
                .collect(Collectors.toList());
        System.out.println("Evens: " + evens);   // [2, 4, 6, 8, 10]

        // 2. Map — transform elements
        List<Integer> squares = numbers.stream()
                .map(n -> n * n)
                .collect(Collectors.toList());
        System.out.println("Squares: " + squares); // [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

        // 3. Reduce — combine to single value
        int sum = numbers.stream()
                .reduce(0, Integer::sum);
        System.out.println("Sum: " + sum);   // 55

        // 4. Count
        long count = numbers.stream()
                .filter(n -> n > 5)
                .count();
        System.out.println("Count > 5: " + count);   // 5

        // 5. Min and Max
        Optional<Integer> max = numbers.stream().max(Integer::compareTo);
        System.out.println("Max: " + max.orElse(0));  // 10

        // 6. Sorted
        List<Integer> desc = numbers.stream()
                .sorted(Comparator.reverseOrder())
                .collect(Collectors.toList());
        System.out.println("Descending: " + desc);

        // 7. Distinct
        List<Integer> dupes = Arrays.asList(1, 2, 2, 3, 3, 3);
        List<Integer> unique = dupes.stream()
                .distinct()
                .collect(Collectors.toList());
        System.out.println("Unique: " + unique);   // [1, 2, 3]

        // 8. flatMap — flatten nested collections
        List<List<Integer>> nested = Arrays.asList(
                Arrays.asList(1, 2), Arrays.asList(3, 4), Arrays.asList(5, 6));
        List<Integer> flat = nested.stream()
                .flatMap(Collection::stream)
                .collect(Collectors.toList());
        System.out.println("Flat: " + flat);   // [1, 2, 3, 4, 5, 6]

        // 9. Collectors — grouping
        List<String> words = Arrays.asList("hi", "hello", "hey", "world", "wow");
        Map<Character, List<String>> grouped = words.stream()
                .collect(Collectors.groupingBy(w -> w.charAt(0)));
        System.out.println("Grouped: " + grouped);
        // {h=[hi, hello, hey], w=[world, wow]}

        // 10. Joining
        String joined = words.stream()
                .collect(Collectors.joining(", "));
        System.out.println("Joined: " + joined);   // hi, hello, hey, world, wow

        // 11. Method References
        List<String> names = Arrays.asList("alice", "bob", "charlie");
        names.stream()
                .map(String::toUpperCase)
                .forEach(System.out::println);

        // 12. Parallel Stream
        long parallelSum = numbers.parallelStream()
                .mapToLong(Integer::longValue)
                .sum();
        System.out.println("Parallel Sum: " + parallelSum);
    }
}
```

### Common Stream Operations Summary

| Operation | Type | Returns | Example |
|-----------|------|---------|---------|
| `filter` | Intermediate | Stream | `.filter(x -> x > 5)` |
| `map` | Intermediate | Stream | `.map(x -> x * 2)` |
| `flatMap` | Intermediate | Stream | `.flatMap(Collection::stream)` |
| `sorted` | Intermediate | Stream | `.sorted()` |
| `distinct` | Intermediate | Stream | `.distinct()` |
| `limit` | Intermediate | Stream | `.limit(5)` |
| `skip` | Intermediate | Stream | `.skip(3)` |
| `peek` | Intermediate | Stream | `.peek(System.out::println)` |
| `forEach` | Terminal | void | `.forEach(System.out::println)` |
| `collect` | Terminal | Collection | `.collect(Collectors.toList())` |
| `reduce` | Terminal | Optional/T | `.reduce(0, Integer::sum)` |
| `count` | Terminal | long | `.count()` |
| `min/max` | Terminal | Optional | `.max(Comparator)` |
| `anyMatch` | Terminal | boolean | `.anyMatch(x -> x > 5)` |
| `allMatch` | Terminal | boolean | `.allMatch(x -> x > 0)` |
| `noneMatch` | Terminal | boolean | `.noneMatch(x -> x < 0)` |
| `findFirst` | Terminal | Optional | `.findFirst()` |
| `findAny` | Terminal | Optional | `.findAny()` |

---

### Quick Revision – Java 8 Features

```
┌────────────────────────────────────────────────────────────┐
│ KEY POINTS TO REMEMBER                                      │
├────────────────────────────────────────────────────────────┤
│ • Lambda = anonymous function: (params) -> expression       │
│ • Functional Interface = 1 abstract method (SAM)           │
│ • @FunctionalInterface annotation for compile-time check   │
│ • Built-in: Predicate, Function, Consumer, Supplier        │
│ • Stream = pipeline: source → intermediate → terminal      │
│ • Streams are lazy (only execute at terminal operation)     │
│ • Streams cannot be reused after terminal operation         │
│ • Method reference: Class::method (shorthand for lambda)   │
│ • parallelStream() for parallel processing                 │
│ • Collectors: toList, toSet, toMap, groupingBy, joining    │
└────────────────────────────────────────────────────────────┘
```

---

## 📝 Practice Section – Java 8 Features

### Level 1 – Very Simple Checks (10 Questions)

| # | Question | Answer |
|---|----------|--------|
| 1 | What is a lambda expression? | An anonymous function |
| 2 | How many abstract methods can a Functional Interface have? | Exactly one |
| 3 | What does `Predicate.test()` return? | `boolean` |
| 4 | What does `Consumer.accept()` return? | `void` |
| 5 | Is Stream a data structure? | No, it's a pipeline |
| 6 | What triggers stream execution? | Terminal operation |
| 7 | Can a stream be reused? | No |
| 8 | What does `map()` do? | Transforms each element |
| 9 | What is `::` called in Java? | Method reference operator |
| 10 | What does `filter()` take as argument? | A `Predicate` |

### Level 2 – Concept MCQs (10 Questions)

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Lambda expression requires? | A) Class B) Functional Interface C) Abstract class D) Enum | **B** |
| 2 | Which is NOT a terminal operation? | A) collect B) forEach C) filter D) count | **C** |
| 3 | `Function<String, Integer>` takes ___ returns ___? | A) Integer, String B) String, Integer C) Both String D) Both Integer | **B** |
| 4 | `stream().sorted()` is? | A) Terminal B) Intermediate C) Source D) Collector | **B** |
| 5 | Which creates a stream from a list? | A) list.stream() B) Stream.of(list) C) new Stream(list) D) list.toStream() | **A** |
| 6 | `Optional.orElse(default)` does what? | A) Throws exception B) Returns value or default C) Returns null D) Creates new Optional | **B** |
| 7 | `Collectors.groupingBy()` returns? | A) List B) Set C) Map D) Optional | **C** |
| 8 | Which functional interface has `get()` method? | A) Predicate B) Function C) Consumer D) Supplier | **D** |
| 9 | `flatMap()` is used to? | A) Sort B) Flatten nested streams C) Filter D) Count | **B** |
| 10 | Variables in lambda must be? | A) static B) final C) effectively final D) volatile | **C** |

### Level 3 – Deep Understanding MCQs (5 Questions)

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Why are streams lazy? | A) Bug B) Performance — skip unnecessary computation C) Thread safety D) Memory limit | **B** |
| 2 | What happens if `reduce()` has no identity and stream is empty? | A) Returns 0 B) Returns null C) Returns empty Optional D) Exception | **C** |
| 3 | `parallelStream()` uses which thread pool? | A) Custom B) ForkJoinPool.commonPool() C) ExecutorService D) SingleThread | **B** |
| 4 | Can a `@FunctionalInterface` extend another interface? | A) No B) Yes, if total abstract methods = 1 C) Yes always D) Only if no methods | **B** |
| 5 | Which method reference type is `String::length`? | A) Static B) Instance of particular object C) Instance of arbitrary object D) Constructor | **C** |

### Level 4 – Quick True/False (5 Questions)

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Lambda expressions were introduced in Java 7 | **False** (Java 8) |
| 2 | `peek()` is a terminal operation | **False** (intermediate) |
| 3 | `Runnable` is a functional interface | **True** |
| 4 | Streams modify the original collection | **False** |
| 5 | `BinaryOperator<T>` extends `BiFunction<T,T,T>` | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Using streams, find the sum of squares of even numbers from 1 to 10.

```java
import java.util.stream.IntStream;

public class StreamExercise1 {
    public static void main(String[] args) {
        int sum = IntStream.rangeClosed(1, 10)
                .filter(n -> n % 2 == 0)
                .map(n -> n * n)
                .sum();
        System.out.println("Sum of squares of evens: " + sum); // 220
    }
}
```

**Exercise 2:** Group a list of strings by their length using streams.

```java
import java.util.*;
import java.util.stream.Collectors;

public class StreamExercise2 {
    public static void main(String[] args) {
        List<String> words = Arrays.asList("hi", "hello", "hey", "world", "go", "java");

        Map<Integer, List<String>> grouped = words.stream()
                .collect(Collectors.groupingBy(String::length));

        grouped.forEach((len, list) ->
                System.out.println("Length " + len + ": " + list));
        // Length 2: [hi, go]
        // Length 5: [hello, world]
        // Length 3: [hey]
        // Length 4: [java]
    }
}
```

---

### 20 Tricky Interview MCQs – Java 8 Features

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Which is NOT a functional interface? | A) Runnable B) Callable C) Comparator D) Iterator | **D** – Iterator has `hasNext()` AND `next()` |
| 2 | `stream().peek(System.out::println).count()` – does peek execute? | A) Yes B) No C) Sometimes D) Depends on terminal op | **A** – `count()` is terminal, triggers peek |
| 3 | Default methods in interface were added in? | A) Java 7 B) Java 8 C) Java 9 D) Java 11 | **B** |
| 4 | `Stream.of(1,2,3)` creates? | A) IntStream B) Stream<int> C) Stream<Integer> D) List<Integer> | **C** |
| 5 | `mapToInt()` returns? | A) Stream<Integer> B) IntStream C) int[] D) List<Integer> | **B** |
| 6 | Which collector creates comma-separated string? | A) toList B) joining C) groupingBy D) toSet | **B** |
| 7 | `Optional.empty().get()` throws? | A) NullPointerException B) NoSuchElementException C) IllegalStateException D) Returns null | **B** |
| 8 | Can lambda access instance variables? | A) No B) Yes C) Only final D) Only static | **B** (no restriction on instance/static vars) |
| 9 | `IntStream.range(1,5)` produces? | A) 1,2,3,4,5 B) 1,2,3,4 C) 0,1,2,3,4 D) 2,3,4 | **B** (exclusive end) |
| 10 | Method reference `Integer::new` is? | A) Static ref B) Instance ref C) Constructor ref D) Invalid | **C** |
| 11 | Which is NOT an intermediate operation? | A) map B) filter C) reduce D) sorted | **C** – `reduce` is terminal |
| 12 | `findFirst()` on empty stream returns? | A) null B) Exception C) Optional.empty() D) 0 | **C** |
| 13 | Can `@FunctionalInterface` have static methods? | A) No B) Yes C) Only one D) Only private | **B** |
| 14 | `Predicate.negate()` does? | A) Returns null B) Reverses condition C) Throws error D) Returns new Predicate | **B** (and D — returns negated predicate) |
| 15 | `stream().limit(0)` produces? | A) Exception B) Empty stream C) Same stream D) null | **B** |
| 16 | `Collectors.partitioningBy()` returns? | A) List B) Set C) Map<Boolean, List> D) Optional | **C** |
| 17 | `UnaryOperator<T>` extends? | A) Consumer<T> B) Supplier<T> C) Function<T,T> D) Predicate<T> | **C** |
| 18 | `stream().forEach()` guarantees order? | A) Yes B) No C) Only for lists D) Only for sorted | **B** (for parallel streams, no guarantee; for sequential, encounter order) |
| 19 | `Comparator.naturalOrder()` returns? | A) Descending B) Ascending C) Random D) Insertion order | **B** |
| 20 | Can streams operate on primitive arrays? | A) No B) Yes via `Arrays.stream(arr)` C) Only wrappers D) Only via boxing | **B** |

---

# Important Interview Programs

## 1. Check Prime Number

### Concept

A prime number is divisible only by 1 and itself. Check divisibility up to √n for efficiency.

```java
public class PrimeCheck {
    // Method 1: Basic approach
    public static boolean isPrime(int n) {
        if (n <= 1) return false;
        if (n <= 3) return true;
        if (n % 2 == 0 || n % 3 == 0) return false;

        // Check from 5 to √n, skip even numbers
        for (int i = 5; i * i <= n; i += 6) {
            if (n % i == 0 || n % (i + 2) == 0)
                return false;
        }
        return true;
    }

    // Method 2: Using Java 8 Streams
    public static boolean isPrimeStream(int n) {
        if (n <= 1) return false;
        return java.util.stream.IntStream.rangeClosed(2, (int) Math.sqrt(n))
                .noneMatch(i -> n % i == 0);
    }

    public static void main(String[] args) {
        System.out.println("7 is prime? " + isPrime(7));       // true
        System.out.println("10 is prime? " + isPrime(10));     // false
        System.out.println("29 is prime? " + isPrimeStream(29)); // true

        // Print primes 1 to 50
        System.out.print("Primes: ");
        for (int i = 2; i <= 50; i++) {
            if (isPrime(i)) System.out.print(i + " ");
        }
    }
}
```

### Output
```
7 is prime? true
10 is prime? false
29 is prime? true
Primes: 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
```

#### Interview Tip
- Time complexity: O(√n) — not O(n)
- 1 is **not** prime, 2 is the **only even prime**

---

## 2. Palindrome Check

### Concept

A palindrome reads the same forward and backward (e.g., "madam", 121).

```java
public class PalindromeCheck {

    // String palindrome
    public static boolean isPalindromeString(String s) {
        s = s.toLowerCase().replaceAll("[^a-z0-9]", ""); // Remove non-alphanumeric
        int left = 0, right = s.length() - 1;
        while (left < right) {
            if (s.charAt(left) != s.charAt(right)) return false;
            left++;
            right--;
        }
        return true;
    }

    // Number palindrome
    public static boolean isPalindromeNumber(int num) {
        if (num < 0) return false;
        int original = num, reversed = 0;
        while (num > 0) {
            reversed = reversed * 10 + num % 10;
            num /= 10;
        }
        return original == reversed;
    }

    // Using StringBuilder
    public static boolean isPalindromeSB(String s) {
        return s.equals(new StringBuilder(s).reverse().toString());
    }

    public static void main(String[] args) {
        System.out.println("madam: " + isPalindromeString("madam"));           // true
        System.out.println("A man a plan a canal Panama: " +
                isPalindromeString("A man, a plan, a canal: Panama"));          // true
        System.out.println("121: " + isPalindromeNumber(121));                  // true
        System.out.println("123: " + isPalindromeNumber(123));                  // false
        System.out.println("racecar: " + isPalindromeSB("racecar"));            // true
    }
}
```

---

## 3. Fibonacci Series

### Concept

Each number is the sum of the two preceding ones: 0, 1, 1, 2, 3, 5, 8, 13, ...

```java
public class Fibonacci {

    // Method 1: Iterative (Best for most cases)
    public static void fibIterative(int n) {
        int a = 0, b = 1;
        System.out.print("Fibonacci: ");
        for (int i = 0; i < n; i++) {
            System.out.print(a + " ");
            int next = a + b;
            a = b;
            b = next;
        }
        System.out.println();
    }

    // Method 2: Recursive (Simple but slow — O(2^n))
    public static int fibRecursive(int n) {
        if (n <= 1) return n;
        return fibRecursive(n - 1) + fibRecursive(n - 2);
    }

    // Method 3: Dynamic Programming — Memoization (O(n))
    public static int fibMemo(int n, int[] memo) {
        if (n <= 1) return n;
        if (memo[n] != 0) return memo[n];
        memo[n] = fibMemo(n - 1, memo) + fibMemo(n - 2, memo);
        return memo[n];
    }

    // Method 4: Using Streams (Java 8)
    public static void fibStream(int n) {
        java.util.stream.Stream.iterate(new int[]{0, 1}, f -> new int[]{f[1], f[0] + f[1]})
                .limit(n)
                .map(f -> f[0])
                .forEach(x -> System.out.print(x + " "));
        System.out.println();
    }

    public static void main(String[] args) {
        fibIterative(10);
        // Fibonacci: 0 1 1 2 3 5 8 13 21 34

        System.out.println("Fib(7) Recursive: " + fibRecursive(7)); // 13

        int n = 10;
        System.out.println("Fib(10) Memo: " + fibMemo(n, new int[n + 1])); // 55

        System.out.print("Stream: ");
        fibStream(10);
    }
}
```

### Interview Tip

| Approach | Time | Space |
|----------|------|-------|
| Iterative | O(n) | O(1) |
| Recursive | O(2^n) | O(n) stack |
| Memoization | O(n) | O(n) |
| Tabulation | O(n) | O(n) |

---

## 4. Sorting Algorithms

### Bubble Sort

```java
public class BubbleSort {
    public static void bubbleSort(int[] arr) {
        int n = arr.length;
        boolean swapped;
        for (int i = 0; i < n - 1; i++) {
            swapped = false;
            for (int j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    // Swap
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                    swapped = true;
                }
            }
            if (!swapped) break; // Already sorted — optimization
        }
    }

    public static void main(String[] args) {
        int[] arr = {64, 34, 25, 12, 22, 11, 90};
        bubbleSort(arr);
        System.out.print("Sorted: ");
        for (int x : arr) System.out.print(x + " ");
        // Sorted: 11 12 22 25 34 64 90
    }
}
```

### Selection Sort

```java
public class SelectionSort {
    public static void selectionSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < n; j++) {
                if (arr[j] < arr[minIdx]) {
                    minIdx = j;
                }
            }
            // Swap minimum with current position
            int temp = arr[minIdx];
            arr[minIdx] = arr[i];
            arr[i] = temp;
        }
    }

    public static void main(String[] args) {
        int[] arr = {29, 10, 14, 37, 13};
        selectionSort(arr);
        System.out.print("Sorted: ");
        for (int x : arr) System.out.print(x + " ");
        // Sorted: 10 13 14 29 37
    }
}
```

### Insertion Sort

```java
public class InsertionSort {
    public static void insertionSort(int[] arr) {
        int n = arr.length;
        for (int i = 1; i < n; i++) {
            int key = arr[i];
            int j = i - 1;
            // Shift elements greater than key to the right
            while (j >= 0 && arr[j] > key) {
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = key;
        }
    }

    public static void main(String[] args) {
        int[] arr = {12, 11, 13, 5, 6};
        insertionSort(arr);
        System.out.print("Sorted: ");
        for (int x : arr) System.out.print(x + " ");
        // Sorted: 5 6 11 12 13
    }
}
```

### Merge Sort

```java
public class MergeSort {
    public static void mergeSort(int[] arr, int left, int right) {
        if (left < right) {
            int mid = left + (right - left) / 2;

            mergeSort(arr, left, mid);       // Sort left half
            mergeSort(arr, mid + 1, right);  // Sort right half
            merge(arr, left, mid, right);     // Merge sorted halves
        }
    }

    private static void merge(int[] arr, int left, int mid, int right) {
        int n1 = mid - left + 1;
        int n2 = right - mid;

        int[] L = new int[n1], R = new int[n2];

        for (int i = 0; i < n1; i++) L[i] = arr[left + i];
        for (int j = 0; j < n2; j++) R[j] = arr[mid + 1 + j];

        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2) {
            if (L[i] <= R[j]) arr[k++] = L[i++];
            else arr[k++] = R[j++];
        }
        while (i < n1) arr[k++] = L[i++];
        while (j < n2) arr[k++] = R[j++];
    }

    public static void main(String[] args) {
        int[] arr = {38, 27, 43, 3, 9, 82, 10};
        mergeSort(arr, 0, arr.length - 1);
        System.out.print("Sorted: ");
        for (int x : arr) System.out.print(x + " ");
        // Sorted: 3 9 10 27 38 43 82
    }
}
```

### Quick Sort

```java
public class QuickSort {
    public static void quickSort(int[] arr, int low, int high) {
        if (low < high) {
            int pi = partition(arr, low, high);
            quickSort(arr, low, pi - 1);   // Before pivot
            quickSort(arr, pi + 1, high);  // After pivot
        }
    }

    private static int partition(int[] arr, int low, int high) {
        int pivot = arr[high]; // Last element as pivot
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (arr[j] < pivot) {
                i++;
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }

        // Place pivot in correct position
        int temp = arr[i + 1];
        arr[i + 1] = arr[high];
        arr[high] = temp;
        return i + 1;
    }

    public static void main(String[] args) {
        int[] arr = {10, 7, 8, 9, 1, 5};
        quickSort(arr, 0, arr.length - 1);
        System.out.print("Sorted: ");
        for (int x : arr) System.out.print(x + " ");
        // Sorted: 1 5 7 8 9 10
    }
}
```

### Sorting Algorithms Comparison

| Algorithm | Best Case | Average | Worst Case | Space | Stable |
|-----------|-----------|---------|------------|-------|--------|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) | No |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) | No |

---

## 5. Searching Algorithms

### Linear Search

```java
public class LinearSearch {
    public static int linearSearch(int[] arr, int target) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == target) return i;  // Found at index i
        }
        return -1;  // Not found
    }

    public static void main(String[] args) {
        int[] arr = {10, 20, 30, 40, 50};
        int result = linearSearch(arr, 30);
        System.out.println(result != -1 ? "Found at index " + result : "Not found");
        // Found at index 2
    }
}
```

### Binary Search

```java
public class BinarySearch {
    // Iterative
    public static int binarySearch(int[] arr, int target) {
        int left = 0, right = arr.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;  // Avoid overflow
            if (arr[mid] == target) return mid;
            else if (arr[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        return -1;
    }

    // Recursive
    public static int binarySearchRecursive(int[] arr, int target, int left, int right) {
        if (left > right) return -1;
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return mid;
        else if (arr[mid] < target) return binarySearchRecursive(arr, target, mid + 1, right);
        else return binarySearchRecursive(arr, target, left, mid - 1);
    }

    public static void main(String[] args) {
        int[] arr = {2, 5, 8, 12, 16, 23, 38, 56, 72, 91};

        System.out.println("23 found at index: " + binarySearch(arr, 23));            // 5
        System.out.println("50 found at index: " + binarySearch(arr, 50));            // -1
        System.out.println("72 found at index: " +
                binarySearchRecursive(arr, 72, 0, arr.length - 1));                    // 8
    }
}
```

### Search Comparison

| Algorithm | Time Complexity | Requirement |
|-----------|-----------------|-------------|
| Linear Search | O(n) | None (works on unsorted) |
| Binary Search | O(log n) | Array must be **sorted** |

---

## 6. String Algorithms

### Reverse a String

```java
public class ReverseString {
    // Method 1: StringBuilder
    public static String reverse1(String s) {
        return new StringBuilder(s).reverse().toString();
    }

    // Method 2: Character array
    public static String reverse2(String s) {
        char[] chars = s.toCharArray();
        int left = 0, right = chars.length - 1;
        while (left < right) {
            char temp = chars[left];
            chars[left] = chars[right];
            chars[right] = temp;
            left++;
            right--;
        }
        return new String(chars);
    }

    // Method 3: Recursion
    public static String reverse3(String s) {
        if (s.isEmpty()) return s;
        return reverse3(s.substring(1)) + s.charAt(0);
    }

    public static void main(String[] args) {
        System.out.println(reverse1("Hello"));  // olleH
        System.out.println(reverse2("World"));  // dlroW
        System.out.println(reverse3("Java"));   // avaJ
    }
}
```

### Count Vowels and Consonants

```java
public class VowelConsonant {
    public static void count(String s) {
        int vowels = 0, consonants = 0;
        s = s.toLowerCase();
        for (char c : s.toCharArray()) {
            if (c >= 'a' && c <= 'z') {
                if ("aeiou".indexOf(c) != -1) vowels++;
                else consonants++;
            }
        }
        System.out.println("Vowels: " + vowels + ", Consonants: " + consonants);
    }

    public static void main(String[] args) {
        count("Hello World"); // Vowels: 3, Consonants: 7
    }
}
```

### Check Anagram

```java
import java.util.Arrays;

public class AnagramCheck {
    // Method 1: Sort and compare
    public static boolean isAnagram(String s1, String s2) {
        if (s1.length() != s2.length()) return false;
        char[] a = s1.toLowerCase().toCharArray();
        char[] b = s2.toLowerCase().toCharArray();
        Arrays.sort(a);
        Arrays.sort(b);
        return Arrays.equals(a, b);
    }

    // Method 2: Frequency count
    public static boolean isAnagram2(String s1, String s2) {
        if (s1.length() != s2.length()) return false;
        int[] freq = new int[26];
        for (char c : s1.toLowerCase().toCharArray()) freq[c - 'a']++;
        for (char c : s2.toLowerCase().toCharArray()) freq[c - 'a']--;
        for (int f : freq) {
            if (f != 0) return false;
        }
        return true;
    }

    public static void main(String[] args) {
        System.out.println(isAnagram("listen", "silent"));  // true
        System.out.println(isAnagram2("hello", "world"));   // false
    }
}
```

### Find Duplicates in a String

```java
import java.util.HashMap;
import java.util.Map;

public class DuplicateChars {
    public static void findDuplicates(String s) {
        HashMap<Character, Integer> map = new HashMap<>();
        for (char c : s.toCharArray()) {
            map.put(c, map.getOrDefault(c, 0) + 1);
        }
        System.out.println("Duplicate characters:");
        for (Map.Entry<Character, Integer> entry : map.entrySet()) {
            if (entry.getValue() > 1) {
                System.out.println(entry.getKey() + " → " + entry.getValue() + " times");
            }
        }
    }

    public static void main(String[] args) {
        findDuplicates("programming");
        // g → 2 times
        // r → 2 times
        // m → 2 times
    }
}
```

### First Non-Repeating Character

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class FirstNonRepeating {
    public static char firstNonRepeating(String s) {
        LinkedHashMap<Character, Integer> map = new LinkedHashMap<>();
        for (char c : s.toCharArray()) {
            map.put(c, map.getOrDefault(c, 0) + 1);
        }
        for (Map.Entry<Character, Integer> entry : map.entrySet()) {
            if (entry.getValue() == 1) return entry.getKey();
        }
        return '\0'; // No non-repeating character
    }

    public static void main(String[] args) {
        System.out.println(firstNonRepeating("aabbcdd")); // c
        System.out.println(firstNonRepeating("swiss"));    // w
    }
}
```

---

## 7. Collection-Based Problems

### Remove Duplicates from ArrayList

```java
import java.util.*;
import java.util.stream.Collectors;

public class RemoveDuplicates {
    public static void main(String[] args) {
        ArrayList<Integer> list = new ArrayList<>(Arrays.asList(1, 2, 3, 2, 4, 1, 5, 3));

        // Method 1: Using LinkedHashSet (preserves order)
        LinkedHashSet<Integer> set = new LinkedHashSet<>(list);
        ArrayList<Integer> unique1 = new ArrayList<>(set);
        System.out.println("LinkedHashSet: " + unique1); // [1, 2, 3, 4, 5]

        // Method 2: Using Streams
        List<Integer> unique2 = list.stream()
                .distinct()
                .collect(Collectors.toList());
        System.out.println("Stream: " + unique2);  // [1, 2, 3, 4, 5]
    }
}
```

### Sort HashMap by Value

```java
import java.util.*;
import java.util.stream.Collectors;

public class SortMapByValue {
    public static void main(String[] args) {
        HashMap<String, Integer> map = new HashMap<>();
        map.put("Alice", 85);
        map.put("Bob", 92);
        map.put("Charlie", 78);
        map.put("Dave", 90);

        // Sort by value ascending
        LinkedHashMap<String, Integer> sorted = map.entrySet().stream()
                .sorted(Map.Entry.comparingByValue())
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (e1, e2) -> e1,
                        LinkedHashMap::new));

        System.out.println("Sorted by value: " + sorted);
        // {Charlie=78, Alice=85, Dave=90, Bob=92}

        // Sort by value descending
        LinkedHashMap<String, Integer> sortedDesc = map.entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (e1, e2) -> e1,
                        LinkedHashMap::new));
        System.out.println("Sorted desc: " + sortedDesc);
    }
}
```

### Find Second Largest Element

```java
import java.util.Arrays;
import java.util.TreeSet;

public class SecondLargest {
    // Method 1: Sorting
    public static int secondLargest1(int[] arr) {
        Arrays.sort(arr);
        for (int i = arr.length - 2; i >= 0; i--) {
            if (arr[i] != arr[arr.length - 1]) return arr[i];
        }
        return -1; // All elements same
    }

    // Method 2: Single pass
    public static int secondLargest2(int[] arr) {
        int first = Integer.MIN_VALUE, second = Integer.MIN_VALUE;
        for (int num : arr) {
            if (num > first) {
                second = first;
                first = num;
            } else if (num > second && num != first) {
                second = num;
            }
        }
        return second;
    }

    // Method 3: TreeSet
    public static int secondLargest3(int[] arr) {
        TreeSet<Integer> set = new TreeSet<>();
        for (int num : arr) set.add(num);
        set.pollLast(); // Remove largest
        return set.last(); // Second largest
    }

    public static void main(String[] args) {
        int[] arr = {12, 35, 1, 10, 34, 1};
        System.out.println("Second largest: " + secondLargest1(arr)); // 34
        System.out.println("Second largest: " + secondLargest2(arr)); // 34
        System.out.println("Second largest: " + secondLargest3(arr)); // 34
    }
}
```

### Find Common Elements Between Two Lists

```java
import java.util.*;
import java.util.stream.Collectors;

public class CommonElements {
    public static void main(String[] args) {
        List<Integer> list1 = Arrays.asList(1, 2, 3, 4, 5);
        List<Integer> list2 = Arrays.asList(3, 4, 5, 6, 7);

        // Method 1: retainAll
        List<Integer> common1 = new ArrayList<>(list1);
        common1.retainAll(list2);
        System.out.println("Common: " + common1); // [3, 4, 5]

        // Method 2: Streams
        List<Integer> common2 = list1.stream()
                .filter(list2::contains)
                .collect(Collectors.toList());
        System.out.println("Common (stream): " + common2); // [3, 4, 5]

        // Method 3: HashSet
        Set<Integer> set = new HashSet<>(list1);
        set.retainAll(list2);
        System.out.println("Common (set): " + set); // [3, 4, 5]
    }
}
```

### Reverse a Linked List

```java
public class ReverseLinkedList {
    static class Node {
        int data;
        Node next;
        Node(int data) {
            this.data = data;
            this.next = null;
        }
    }

    // Iterative reversal
    public static Node reverse(Node head) {
        Node prev = null, current = head, next;
        while (current != null) {
            next = current.next;    // Save next
            current.next = prev;    // Reverse pointer
            prev = current;         // Move prev forward
            current = next;         // Move current forward
        }
        return prev;  // New head
    }

    public static void printList(Node head) {
        Node temp = head;
        while (temp != null) {
            System.out.print(temp.data + " → ");
            temp = temp.next;
        }
        System.out.println("null");
    }

    public static void main(String[] args) {
        Node head = new Node(1);
        head.next = new Node(2);
        head.next.next = new Node(3);
        head.next.next.next = new Node(4);

        System.out.print("Original: ");
        printList(head);   // 1 → 2 → 3 → 4 → null

        head = reverse(head);

        System.out.print("Reversed: ");
        printList(head);   // 4 → 3 → 2 → 1 → null
    }
}
```

### Two Sum Problem

```java
import java.util.HashMap;
import java.util.Arrays;

public class TwoSum {
    // O(n) using HashMap
    public static int[] twoSum(int[] nums, int target) {
        HashMap<Integer, Integer> map = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (map.containsKey(complement)) {
                return new int[]{map.get(complement), i};
            }
            map.put(nums[i], i);
        }
        return new int[]{-1, -1};
    }

    public static void main(String[] args) {
        int[] nums = {2, 7, 11, 15};
        int target = 9;
        int[] result = twoSum(nums, target);
        System.out.println("Indices: " + Arrays.toString(result)); // [0, 1]
    }
}
```

### Factorial

```java
public class Factorial {
    // Iterative
    public static long factIterative(int n) {
        long result = 1;
        for (int i = 2; i <= n; i++) {
            result *= i;
        }
        return result;
    }

    // Recursive
    public static long factRecursive(int n) {
        if (n <= 1) return 1;
        return n * factRecursive(n - 1);
    }

    public static void main(String[] args) {
        System.out.println("5! = " + factIterative(5));  // 120
        System.out.println("7! = " + factRecursive(7));  // 5040
    }
}
```

### Armstrong Number

```java
public class Armstrong {
    public static boolean isArmstrong(int num) {
        int original = num;
        int digits = String.valueOf(num).length();
        int sum = 0;

        while (num > 0) {
            int digit = num % 10;
            sum += Math.pow(digit, digits);
            num /= 10;
        }
        return sum == original;
    }

    public static void main(String[] args) {
        System.out.println("153: " + isArmstrong(153));  // true  (1³+5³+3³=153)
        System.out.println("370: " + isArmstrong(370));  // true
        System.out.println("123: " + isArmstrong(123));  // false
    }
}
```

---

## Quick Revision – Interview Programs

```
┌────────────────────────────────────────────────────────────┐
│ KEY ALGORITHMS TO REMEMBER                                  │
├────────────────────────────────────────────────────────────┤
│ • Prime: Check divisibility up to √n → O(√n)               │
│ • Palindrome: Two-pointer or reverse compare                │
│ • Fibonacci: Iterative O(n), Recursive O(2^n)              │
│ • Bubble Sort: Adjacent swap, O(n²)                         │
│ • Selection Sort: Find min, swap, O(n²)                     │
│ • Insertion Sort: Shift and insert, O(n²)                   │
│ • Merge Sort: Divide & merge, O(n log n), stable            │
│ • Quick Sort: Partition, O(n log n) avg, O(n²) worst       │
│ • Binary Search: Sorted array, O(log n)                     │
│ • Anagram: Sort and compare or frequency array              │
│ • Two Sum: HashMap for O(n) lookup                          │
│ • Reverse LinkedList: Three-pointer technique               │
│ • HashMap for frequency counting problems                   │
│ • LinkedHashMap for order-preserving problems               │
│ • TreeSet/TreeMap for sorted problems                       │
└────────────────────────────────────────────────────────────┘
```

---

## 📝 Practice Section – Interview Programs

### Level 1 – Very Simple Checks (10 Questions)

| # | Question | Answer |
|---|----------|--------|
| 1 | What is the time complexity of binary search? | O(log n) |
| 2 | Is 1 a prime number? | No |
| 3 | What is a palindrome? | A string/number that reads the same forwards and backwards |
| 4 | First two Fibonacci numbers? | 0 and 1 |
| 5 | Is bubble sort stable? | Yes |
| 6 | Best case of insertion sort? | O(n) — when already sorted |
| 7 | What data structure is best for Two Sum? | HashMap |
| 8 | What does Armstrong number check? | Sum of digits raised to power of digit count equals number |
| 9 | Binary search requires array to be? | Sorted |
| 10 | Quick sort average time complexity? | O(n log n) |

### Level 2 – Concept MCQs (10 Questions)

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Which sort has O(n log n) in worst case? | A) Quick B) Merge C) Bubble D) Selection | **B** |
| 2 | To find mid in binary search safely? | A) (l+r)/2 B) l+(r-l)/2 C) (l+r)>>1 D) r-l/2 | **B** |
| 3 | Recursive Fibonacci time complexity? | A) O(n) B) O(n²) C) O(2^n) D) O(log n) | **C** |
| 4 | Which is NOT a stable sort? | A) Bubble B) Merge C) Insertion D) Selection | **D** |
| 5 | Best approach for checking anagram? | A) Nested loops B) Frequency array C) Binary search D) Stack | **B** |
| 6 | Space complexity of merge sort? | A) O(1) B) O(n) C) O(log n) D) O(n²) | **B** |
| 7 | LinkedList reversal needs how many pointers? | A) 1 B) 2 C) 3 D) 4 | **C** (prev, current, next) |
| 8 | Quick sort worst case occurs when? | A) Random pivot B) Already sorted C) All same D) Both B & C | **D** |
| 9 | 153 is Armstrong because? | A) 1+5+3=9 B) 1³+5³+3³=153 C) 15+3=18 D) 1*5*3=15 | **B** |
| 10 | HashMap Two Sum approach time complexity? | A) O(n²) B) O(n log n) C) O(n) D) O(1) | **C** |

### Level 3 – Deep Understanding MCQs (5 Questions)

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Why is `left + (right-left)/2` preferred over `(left+right)/2`? | A) Faster B) Prevents integer overflow C) More readable D) No difference | **B** |
| 2 | Why is recursive Fibonacci exponential? | A) Stack overflow B) Redundant subproblems C) Loop error D) Memory leak | **B** — Same subproblems computed repeatedly |
| 3 | Quick sort space complexity O(log n) is for? | A) Array copy B) Recursion stack C) Temp variables D) Pivot storage | **B** |
| 4 | In merge sort, merging step is? | A) O(1) B) O(n) C) O(n²) D) O(log n) | **B** |
| 5 | Using LinkedHashMap for first non-repeating char works because? | A) It's sorted B) It maintains insertion order C) It's faster D) It removes duplicates | **B** |

### Level 4 – Quick True/False (5 Questions)

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Binary search can work on unsorted arrays | **False** |
| 2 | Merge sort is an in-place sorting algorithm | **False** (needs O(n) extra space) |
| 3 | 0 and 1 are not prime numbers | **True** |
| 4 | "listen" and "silent" are anagrams | **True** |
| 5 | Selection sort makes minimum swaps among O(n²) sorts | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Write a program to find the most frequent element in an array.

```java
import java.util.HashMap;
import java.util.Map;

public class MostFrequent {
    public static void main(String[] args) {
        int[] arr = {1, 3, 2, 1, 4, 1, 3, 2, 1};

        HashMap<Integer, Integer> freq = new HashMap<>();
        for (int num : arr) {
            freq.put(num, freq.getOrDefault(num, 0) + 1);
        }

        int maxFreq = 0, result = arr[0];
        for (Map.Entry<Integer, Integer> entry : freq.entrySet()) {
            if (entry.getValue() > maxFreq) {
                maxFreq = entry.getValue();
                result = entry.getKey();
            }
        }
        System.out.println("Most frequent: " + result + " (" + maxFreq + " times)");
        // Most frequent: 1 (4 times)
    }
}
```

**Exercise 2:** Write a program to check if a string has all unique characters.

```java
import java.util.HashSet;

public class UniqueChars {
    // Method 1: HashSet
    public static boolean hasAllUnique(String s) {
        HashSet<Character> set = new HashSet<>();
        for (char c : s.toCharArray()) {
            if (!set.add(c)) return false;  // add returns false if already exists
        }
        return true;
    }

    // Method 2: Bit manipulation (only for a-z)
    public static boolean hasAllUniqueBit(String s) {
        int checker = 0;
        for (char c : s.toCharArray()) {
            int bit = 1 << (c - 'a');
            if ((checker & bit) != 0) return false;
            checker |= bit;
        }
        return true;
    }

    public static void main(String[] args) {
        System.out.println("abcde: " + hasAllUnique("abcde"));   // true
        System.out.println("hello: " + hasAllUnique("hello"));   // false
        System.out.println("world: " + hasAllUniqueBit("world")); // true
    }
}
```

---

### 20 Tricky Interview MCQs – Interview Programs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | What happens if binary search array has duplicates? | A) Error B) Returns any matching index C) Returns first D) Returns last | **B** |
| 2 | Fibonacci of 0 is? | A) 0 B) 1 C) -1 D) Undefined | **A** |
| 3 | Best sorting algorithm for nearly sorted data? | A) Quick Sort B) Merge Sort C) Insertion Sort D) Selection Sort | **C** |
| 4 | Is 2 the only even prime number? | A) Yes B) No C) 4 is also prime D) No even primes | **A** |
| 5 | Which sort performs O(n) comparisons minimum? | A) Selection B) Bubble C) Insertion D) Quick | **C** (best case with optimization) |
| 6 | "abc" and "ABC" are anagrams? (case-insensitive check) | A) Yes B) No C) Depends D) Error | **A** |
| 7 | Quick sort is fastest when pivot is? | A) First element B) Last element C) Median D) Random | **C** |
| 8 | Palindrome "race a car" (ignoring spaces/symbols)? | A) Yes B) No C) Error D) Depends | **B** ("raceacar" is not a palindrome) |
| 9 | Time to reverse a linked list? | A) O(1) B) O(n) C) O(n²) D) O(log n) | **B** |
| 10 | Which data structure for LRU implementation? | A) Stack B) Queue C) LinkedHashMap D) TreeMap | **C** |
| 11 | Factorial of 0 is? | A) 0 B) 1 C) Undefined D) -1 | **B** |
| 12 | 9474 is a 4-digit Armstrong number because? | A) 9+4+7+4=24 B) 9⁴+4⁴+7⁴+4⁴=9474 C) Sum of digits=24 D) Not Armstrong | **B** |
| 13 | Merge sort for linked list is preferred because? | A) No random access needed B) Less memory C) Simpler D) Faster | **A** |
| 14 | HashMap Two Sum fails when? | A) Duplicates exist B) Array unsorted C) Negative numbers D) It handles all cases | **D** (works for all) |
| 15 | Which is NOT O(n²) worst case? | A) Bubble Sort B) Merge Sort C) Selection Sort D) Insertion Sort | **B** |
| 16 | In two-pointer palindrome check, pointers move? | A) Both right B) Both left C) Towards each other D) Away from each other | **C** |
| 17 | Recursion uses which data structure internally? | A) Queue B) Stack C) Heap D) Array | **B** |
| 18 | Count of Armstrong numbers from 1-999? | A) 5 B) 8 C) 10 D) 12 | **B** (1,2,3,4,5,6,7,8,9→one-digit, 153,370,371,407→three-digit = ~12 if counting single digits) Note: Actually 1-digit (1-9) are all Armstrong. Total depends on definition. |
| 19 | Best case time of bubble sort? | A) O(n²) B) O(n) C) O(n log n) D) O(1) | **B** (with swapped flag optimization) |
| 20 | To find frequency of characters, best approach? | A) Nested loops B) HashMap C) Two arrays D) Recursion | **B** |

---

## 🎯 Final Quick Revision – Complete File Summary

```
┌─────────────────────────────────────────────────────────────────┐
│           JAVA COLLECTIONS & INTERVIEW PROGRAMS                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  COLLECTIONS:                                                    │
│  • List (ArrayList, LinkedList, Vector, Stack)                   │
│  • Set (HashSet, LinkedHashSet, TreeSet)                         │
│  • Map (HashMap, LinkedHashMap, TreeMap, Hashtable)              │
│  • Iterator for safe traversal                                   │
│  • Comparable = natural order, Comparator = custom order         │
│                                                                  │
│  JAVA 8:                                                         │
│  • Lambda: (params) -> expression                                │
│  • Functional Interface: 1 abstract method                       │
│  • Stream: filter → map → collect (lazy pipeline)               │
│                                                                  │
│  ALGORITHMS:                                                     │
│  • Search: Linear O(n), Binary O(log n)                          │
│  • Sort: Bubble/Selection/Insertion O(n²),                       │
│          Merge/Quick O(n log n)                                  │
│  • String: Reverse, Palindrome, Anagram, Frequency              │
│  • Numbers: Prime, Fibonacci, Factorial, Armstrong              │
│  • Collections: Two Sum, Duplicates, Sort by Value              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

> **📌 Tip:** Bookmark this file for quick revision before interviews. Practice each program by typing it out, not just reading!

---

# 🖼️ Visual Reference Diagrams – Collections

## 📌 Java Collections Framework Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│           JAVA COLLECTIONS FRAMEWORK HIERARCHY                   │
│                                                                  │
│                    Iterable<E>                                   │
│                        │                                         │
│                   Collection<E>                                  │
│           ┌────────────┼────────────┐                            │
│           │            │            │                            │
│         List<E>      Set<E>      Queue<E>                       │
│           │            │            │                            │
│  ┌────────┼───────┐  ┌─┼────────┐   └────┐                     │
│  │        │       │  │ │        │        │                      │
│ ArrayList LinkedList│ HashSet TreeSet  Deque<E>                 │
│  (index) (doubly   │  │ (hash) (sorted)   │                     │
│          linked)   │  │                LinkedList               │
│         Stack      │  LinkedHashSet   ArrayDeque                │
│                    │  (insertion order)                          │
│               Vector (legacy, synchronized)                      │
│                                                                  │
│                   Map<K,V> (separate hierarchy)                  │
│           ┌──────────┼──────────┐                                │
│           │          │          │                                │
│        HashMap   TreeMap   LinkedHashMap                         │
│         (hash)  (sorted)   (insertion order)                    │
│           │                                                      │
│     Hashtable (legacy, synchronized)                            │
│     ConcurrentHashMap (thread-safe, modern)                     │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 HashMap Internal Structure (Buckets)

```
┌─────────────────────────────────────────────────────────────────┐
│               HASHMAP INTERNAL STRUCTURE (Java 8+)              │
│                                                                  │
│  put("Alice", 100) → hashCode("Alice") → index in array         │
│                                                                  │
│  Internal Array (default capacity = 16):                        │
│  ┌─────┬─────┬─────┬─────┬─────┬─────┐                         │
│  │  0  │  1  │  2  │  3  │  4  │ ... │  (buckets)              │
│  └──┬──┴──┬──┴─────┴─────┴──┬──┴─────┘                         │
│     │     │                 │                                    │
│     ▼     ▼                 ▼                                    │
│  Node    Node             Node                                   │
│  "Alice"  "Bob"           "Dave"                                 │
│   =100    =200             =400                                  │
│            │                                                     │
│            ▼ (collision → linked list)                          │
│           Node                                                   │
│           "Eve"                                                  │
│            =500                                                  │
│            │                                                     │
│            ▼ (8+ entries → Red-Black Tree)                      │
│         (Tree node)                                              │
│                                                                  │
│  Key concepts:                                                   │
│  • hashCode() → bucket index                                    │
│  • equals() → compare within bucket                             │
│  • Load factor 0.75 → rehash when 75% full                     │
│  • Rehash: doubles capacity, re-inserts all entries             │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 ArrayList vs LinkedList Memory

```
┌──────────────────────────────┬──────────────────────────────────┐
│        ARRAYLIST             │         LINKEDLIST               │
├──────────────────────────────┼──────────────────────────────────┤
│  Contiguous memory block     │  Scattered nodes with pointers   │
│                              │                                  │
│  [0][1][2][3][4][_][_][_]   │  H→[A]⟷[B]⟷[C]⟷[D]→T          │
│                              │  (each node: data+prev+next)     │
├──────────────────────────────┼──────────────────────────────────┤
│  get(i) → O(1) fast ✓       │  get(i) → O(n) slow ✗           │
│  add(end) → O(1) amortized  │  add(end) → O(1) fast ✓          │
│  add(middle) → O(n) slow    │  add(middle) → O(1) fast ✓       │
│  remove(i) → O(n) shift     │  remove(i) → O(1) fast ✓         │
├──────────────────────────────┼──────────────────────────────────┤
│  Use when: frequent GET/SET  │  Use when: frequent INSERT/DELETE │
│  (e.g., random access)       │  (e.g., queue, LRU cache)        │
└──────────────────────────────┴──────────────────────────────────┘
```

## 📌 Java 8 Stream Pipeline

```
┌─────────────────────────────────────────────────────────────────┐
│                STREAM PIPELINE                                   │
│                                                                  │
│  Source ──→ Intermediate Operations ──→ Terminal Operation       │
│                                                                  │
│  Collection.stream()     Lazy (not executed    Triggers execution│
│  Arrays.stream()         until terminal)       Returns result    │
│  Stream.of()                                                     │
│                                                                  │
│  ┌──────────┐  filter()   ┌──────────┐  collect()  ┌─────────┐ │
│  │[1,2,3,4, │ ──────────► │[2,4]     │ ──────────► │List[2,4]│ │
│  │  5,6,7,8]│  (evens)    │          │             └─────────┘ │
│  └──────────┘             └──────────┘                          │
│  Source (lazy)            Intermediate (lazy)   Terminal        │
│                                                                  │
│  Intermediate: filter, map, flatMap, distinct, sorted,          │
│               limit, skip, peek                                  │
│  Terminal:    collect, forEach, count, sum, min, max,           │
│               findFirst, anyMatch, allMatch, noneMatch, reduce   │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Comparable vs Comparator

```
┌──────────────────────────────┬──────────────────────────────────┐
│     COMPARABLE               │     COMPARATOR                   │
├──────────────────────────────┼──────────────────────────────────┤
│  Interface: java.lang        │  Interface: java.util            │
│  Method: compareTo(T other)  │  Method: compare(T o1, T o2)     │
├──────────────────────────────┼──────────────────────────────────┤
│  Built INTO the class        │  External / separate class       │
│  Defines natural order       │  Multiple sort orders possible   │
│  class Student               │                                  │
│    implements Comparable<Student>│ Comparator<Student> byName = │
│    int compareTo(Student o) {│   (a,b)->a.name.compareTo(b.name)│
│      return this.id - o.id;  │                                  │
│    }                         │  Comparator<Student> byGpa =     │
│  }                           │   Comparator.comparing(s->s.gpa);│
├──────────────────────────────┼──────────────────────────────────┤
│  Used in: Collections.sort() │  Used in: sort(list, comparator) │
│  TreeSet, TreeMap auto-sort  │  TreeSet(comparator)             │
└──────────────────────────────┴──────────────────────────────────┘
```

---

# 📚 Extra Examples – Collections

## Example: All List Operations

```java
import java.util.*;
import java.util.stream.*;

public class ListOperations {
    public static void main(String[] args) {
        // ── ArrayList ──
        List<String> fruits = new ArrayList<>(Arrays.asList("Banana","Apple","Cherry","Mango"));
        System.out.println("Original: " + fruits);

        fruits.add("Grape");                     // add to end
        fruits.add(1, "Apricot");                // add at index
        fruits.remove("Apple");                  // remove by value
        fruits.remove(0);                        // remove by index
        fruits.set(0, "Blueberry");             // update

        System.out.println("size: " + fruits.size());
        System.out.println("contains Mango: " + fruits.contains("Mango"));
        System.out.println("index of Cherry: " + fruits.indexOf("Cherry"));

        Collections.sort(fruits);               // sort alphabetically
        Collections.reverse(fruits);            // reverse
        Collections.shuffle(fruits);            // random order
        System.out.println("Shuffled: " + fruits);

        // SubList
        List<String> sub = fruits.subList(0, 2);
        System.out.println("Sublist: " + sub);

        // Convert to array
        String[] arr = fruits.toArray(new String[0]);

        // Stream operations
        List<String> longNames = fruits.stream()
            .filter(f -> f.length() > 5)
            .sorted()
            .collect(Collectors.toList());
        System.out.println("Long names sorted: " + longNames);
    }
}
```

## Example: All Map Operations

```java
import java.util.*;
import java.util.stream.*;

public class MapOperations {
    public static void main(String[] args) {
        Map<String, Integer> scores = new HashMap<>();

        // Basic CRUD
        scores.put("Alice", 90);
        scores.put("Bob",   75);
        scores.put("Carol", 88);
        scores.put("Dave",  75);

        System.out.println("All: " + scores);
        System.out.println("Alice: " + scores.get("Alice"));
        System.out.println("Eve (default): " + scores.getOrDefault("Eve", -1));

        // Conditional operations
        scores.putIfAbsent("Eve", 60);   // only if not present
        scores.replace("Bob", 80);       // replace existing

        // Iteration
        for (Map.Entry<String, Integer> e : scores.entrySet()) {
            System.out.printf("%s → %d%n", e.getKey(), e.getValue());
        }

        // Functional operations
        scores.merge("Alice", 5, Integer::sum);   // Alice += 5 → 95
        scores.compute("Bob", (k, v) -> v + 10); // Bob += 10 → 90
        scores.computeIfAbsent("Frank", k -> 0); // Frank = 0 (new entry)

        // Remove
        scores.remove("Dave");
        scores.remove("Carol", 999);  // removes only if value matches — won't remove

        // Stream on map
        Optional<Map.Entry<String, Integer>> top = scores.entrySet()
            .stream()
            .max(Map.Entry.comparingByValue());
        top.ifPresent(e -> System.out.println("Top: " + e.getKey() + " = " + e.getValue()));

        // Sort map by value
        scores.entrySet()
            .stream()
            .sorted(Map.Entry.<String,Integer>comparingByValue().reversed())
            .forEach(e -> System.out.println(e.getKey() + ": " + e.getValue()));

        // Group by score range
        Map<Boolean, List<Map.Entry<String, Integer>>> partitioned =
            scores.entrySet().stream()
                .collect(Collectors.partitioningBy(e -> e.getValue() >= 85));
        System.out.println("Pass (≥85): " + partitioned.get(true));
    }
}
```

## Example: Deque as Stack and Queue

```java
import java.util.*;

public class DequeDemo {
    public static void main(String[] args) {
        // ── AS STACK (LIFO) ──
        Deque<Integer> stack = new ArrayDeque<>();
        stack.push(10);    // same as addFirst
        stack.push(20);
        stack.push(30);
        System.out.println("Stack peek: " + stack.peek());  // 30
        System.out.println("Stack pop: "  + stack.pop());   // 30
        System.out.println("Stack now: "  + stack);         // [20, 10]

        // ── AS QUEUE (FIFO) ──
        Deque<String> queue = new ArrayDeque<>();
        queue.offer("First");    // same as addLast
        queue.offer("Second");
        queue.offer("Third");
        System.out.println("Queue peek: " + queue.peek());  // First
        System.out.println("Queue poll: " + queue.poll());  // First
        System.out.println("Queue now: "  + queue);         // [Second, Third]

        // ── AS DOUBLE-ENDED ──
        Deque<Integer> deque = new ArrayDeque<>();
        deque.addFirst(1); deque.addLast(2);
        deque.addFirst(0); deque.addLast(3);
        System.out.println("Deque: " + deque);              // [0, 1, 2, 3]
        System.out.println("peekFirst: " + deque.peekFirst()); // 0
        System.out.println("peekLast: "  + deque.peekLast());  // 3
    }
}
```

## Example: Stream API Comprehensive

```java
import java.util.*;
import java.util.stream.*;
import java.util.function.*;

public class StreamComprehensive {
    record Student(String name, int age, double gpa) {}

    public static void main(String[] args) {
        List<Student> students = List.of(
            new Student("Alice", 20, 3.8),
            new Student("Bob",   22, 2.5),
            new Student("Carol", 21, 3.5),
            new Student("Dave",  20, 3.8),
            new Student("Eve",   23, 2.9)
        );

        // Filter + Map
        List<String> honorRoll = students.stream()
            .filter(s -> s.gpa() >= 3.5)
            .map(Student::name)
            .sorted()
            .collect(Collectors.toList());
        System.out.println("Honor roll: " + honorRoll);
        // [Alice, Carol, Dave]

        // Count
        long count = students.stream().filter(s -> s.age() <= 21).count();
        System.out.println("Students ≤ 21: " + count); // 3

        // Statistics
        DoubleSummaryStatistics stats = students.stream()
            .mapToDouble(Student::gpa)
            .summaryStatistics();
        System.out.printf("GPA stats: min=%.1f, max=%.1f, avg=%.2f%n",
                          stats.getMin(), stats.getMax(), stats.getAverage());

        // Group by age
        Map<Integer, List<Student>> byAge = students.stream()
            .collect(Collectors.groupingBy(Student::age));
        byAge.forEach((age, list) ->
            System.out.println("Age " + age + ": " + list.stream().map(Student::name).toList()));

        // Partition by gpa >= 3.0
        Map<Boolean, List<String>> partition = students.stream()
            .collect(Collectors.partitioningBy(
                s -> s.gpa() >= 3.0,
                Collectors.mapping(Student::name, Collectors.toList())
            ));
        System.out.println("GPA≥3: " + partition.get(true));
        System.out.println("GPA<3: " + partition.get(false));

        // Joining
        String names = students.stream()
            .map(Student::name)
            .collect(Collectors.joining(", ", "[", "]"));
        System.out.println("Names: " + names);

        // findFirst with filter
        Optional<Student> topStudent = students.stream()
            .max(Comparator.comparingDouble(Student::gpa));
        topStudent.ifPresent(s -> System.out.println("Top student: " + s.name()));
    }
}
```

---

# 📝 Extended Question Bank – Collections

## ✍️ Fill in the Blanks – Collections

| # | Statement | Answer |
|---|-----------|--------|
| 1 | `ArrayList` uses a _______ array internally. | **dynamic / resizable** |
| 2 | Default initial capacity of `ArrayList` is _______. | **10** |
| 3 | `HashMap` allows _______ null key(s) and _______ null value(s). | **one / multiple** |
| 4 | `TreeMap` stores keys in _______ order. | **sorted / natural** |
| 5 | `LinkedHashMap` maintains _______ order. | **insertion** |
| 6 | `HashSet` uses _______ internally to store elements. | **HashMap** |
| 7 | `TreeSet` elements must implement _______. | **Comparable** |
| 8 | `Deque` can work as both _______ and _______. | **Stack / Queue** |
| 9 | `PriorityQueue` is ordered by _______ priority (smallest first). | **natural** |
| 10 | `Collections.synchronizedList()` wraps a list to make it _______. | **thread-safe** |
| 11 | `Iterator.remove()` removes _______ element. | **last returned** |
| 12 | `ConcurrentModificationException` is thrown when modifying list _______ iteration. | **during** |
| 13 | Stream `filter()` takes a _______. | **Predicate** |
| 14 | Stream `map()` takes a _______. | **Function** |
| 15 | `Collectors.toSet()` result has no guaranteed _______. | **order** |

---

## 🔗 Match the Following – Collections

### Set A – Collection to Best Use Case

| Collection | Best Use Case |
|------------|---------------|
| 1. ArrayList | A. Maintain insertion order + no duplicates |
| 2. LinkedList | B. Fast key-value lookup |
| 3. HashMap | C. Frequent get by index |
| 4. TreeSet | D. Sorted unique elements |
| 5. LinkedHashSet | E. Frequent insert/delete from both ends |

**Answers:** 1→C, 2→E, 3→B, 4→D, 5→A

---

### Set B – Stream Operations

| Method | Type | What it does |
|--------|------|-------------|
| 1. `filter()` | A. Terminal | Transforms each element |
| 2. `map()` | B. Intermediate | Tests a condition, returns boolean |
| 3. `collect()` | C. Intermediate | Accumulates into container |
| 4. `forEach()` | D. Intermediate | Keeps elements matching predicate |
| 5. `count()` | E. Terminal | Returns number of elements |

**Answers:** 1→D, 2→A, 3→C (Terminal), 4→Terminal, 5→E

---

## 🐛 Error Spotting – Collections

### Bug 1
```java
List<Integer> list = Arrays.asList(1, 2, 3);
list.add(4);  // Bug!
```
**Bug:** `Arrays.asList()` returns a FIXED-SIZE list. `add()` throws `UnsupportedOperationException`. Use `new ArrayList<>(Arrays.asList(1,2,3))` instead.

---

### Bug 2
```java
Map<String, Integer> map = new HashMap<>();
map.put("a", 1);
map.put("b", 2);
for (String key : map.keySet()) {
    if (key.equals("a")) map.remove(key);  // Bug!
}
```
**Bug:** Modifying map during `for-each` loop causes `ConcurrentModificationException`. Use `Iterator` with `iter.remove()` or collect keys first.

---

### Bug 3
```java
List<Integer> nums = List.of(3, 1, 4, 1, 5);
nums.sort(null);   // Bug!
```
**Bug:** `List.of()` returns an immutable list — `sort()` throws `UnsupportedOperationException`. Use `new ArrayList<>(List.of(...))`.

---

### Bug 4
```java
Set<Person> set = new HashSet<>();
set.add(new Person("Alice"));
set.add(new Person("Alice"));
System.out.println(set.size()); // expects 1, gets 2
```
**Bug:** `Person` doesn't override `hashCode()` and `equals()` — HashSet treats them as different objects. Must override both.

---

### Bug 5
```java
Iterator<String> it = list.iterator();
while (it.hasNext()) {
    String s = it.next();
    list.remove(s);  // Bug - using list.remove, not it.remove()
}
```
**Bug:** Should use `it.remove()` not `list.remove()` — the latter causes `ConcurrentModificationException`.

---

## 🖥️ Output Prediction – Collections

### Q1
```java
List<Integer> list = new ArrayList<>(Arrays.asList(3, 1, 4, 1, 5, 9));
Collections.sort(list);
System.out.println(list);
System.out.println(Collections.binarySearch(list, 5));
```
**Output:**
```
[1, 1, 3, 4, 5, 9]
4
```
> Sorted first: [1,1,3,4,5,9]. BinarySearch for 5 returns index 4.

---

### Q2
```java
Map<String, Integer> map = new TreeMap<>();
map.put("banana", 2);
map.put("apple",  1);
map.put("cherry", 3);
System.out.println(map);
```
**Output:** `{apple=1, banana=2, cherry=3}`
> TreeMap always sorted by key.

---

### Q3
```java
List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5);
int sum = nums.stream()
    .filter(n -> n % 2 != 0)
    .mapToInt(Integer::intValue)
    .sum();
System.out.println(sum);
```
**Output:** `9`
> Odd numbers: 1, 3, 5 → sum = 9

---

### Q4
```java
Deque<Integer> dq = new ArrayDeque<>();
dq.push(1); dq.push(2); dq.push(3);
System.out.println(dq.pop());
System.out.println(dq.peek());
System.out.println(dq.size());
```
**Output:**
```
3
2
2
```
> push = addFirst (stack). pop removes first (3). peek sees next (2). size=2.

---

### Q5
```java
List<String> strs = List.of("cat","dog","elephant","ant","bear");
Map<Integer, List<String>> byLen = strs.stream()
    .collect(Collectors.groupingBy(String::length));
System.out.println(byLen.get(3));
```
**Output:** `[cat, dog, ant]`
> All strings of length 3: cat, dog, ant.

---

## 🧐 Short Answer – Collections

| # | Question | Answer |
|---|----------|--------|
| 1 | When does HashMap resize? | When size exceeds `capacity × load factor` (default 0.75) |
| 2 | Why must hashCode() and equals() be consistent? | Same objects must go to same bucket; equals must confirm match |
| 3 | Difference HashSet vs TreeSet ordering? | HashSet: unordered; TreeSet: natural/sorted order |
| 4 | What is fail-fast iterator? | Throws ConcurrentModificationException if collection modified during iteration |
| 5 | When to use `PriorityQueue`? | Need to always process the smallest (or highest priority) element first |
| 6 | What does `flatMap()` do vs `map()`? | map: one-to-one; flatMap: one-to-many, flattens Stream of Streams |
| 7 | Difference `Collection.remove()` vs `Iterator.remove()`? | Iterator.remove() is safe during iteration; Collection.remove() causes ConcurrentModificationException |
| 8 | Can TreeMap have null key? | No — TreeMap calls compareTo() on key which throws NPE for null |
| 9 | What is `EnumSet`? | Highly efficient Set for enum values; keeps natural enum order |
| 10 | Streams are lazy — what does that mean? | Intermediate operations aren't executed until a terminal operation is called |
