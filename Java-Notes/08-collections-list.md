# 08. Collections Framework — List

## Table of Contents
- [8.1 Collections Framework Overview](#81-collections-framework-overview)
- [8.2 List Interface](#82-list-interface)
- [8.3 ArrayList](#83-arraylist)
- [8.4 LinkedList](#84-linkedlist)
- [8.5 ArrayList vs LinkedList](#85-arraylist-vs-linkedlist)
- [8.6 Iterating Collections](#86-iterating-collections)
- [8.7 Sorting (Comparable & Comparator)](#87-sorting-comparable--comparator)
- [8.8 Practice & Assessment](#88-practice--assessment)

---

## 8.1 Collections Framework Overview

### Definition
The **Java Collections Framework** is a set of classes and interfaces that implement commonly used data structures (lists, sets, maps, queues).

### Hierarchy Diagram

```
                    Iterable
                       │
                   Collection
                  /    |    \
               List   Set   Queue
              /   \    |       \
      ArrayList  LinkedList  HashSet  PriorityQueue
                         TreeSet
                         LinkedHashSet

                      Map (separate hierarchy)
                     /    \
              HashMap    TreeMap
              LinkedHashMap
```

### Why Use Collections Over Arrays?
| Arrays | Collections |
|--------|-------------|
| Fixed size | Dynamic size (grows/shrinks) |
| Can hold primitives | Only objects (use wrapper classes) |
| No built-in methods | Rich API (add, remove, sort, search) |
| Type-unsafe (before generics) | Type-safe with generics |

---

## 8.2 List Interface

### Definition
**List** is an ordered collection that allows duplicates and provides index-based access.

### Key Methods

| Method | Description |
|--------|-------------|
| `add(element)` | Add to end |
| `add(index, element)` | Insert at index |
| `get(index)` | Get element at index |
| `set(index, element)` | Replace at index |
| `remove(index)` | Remove by index |
| `remove(object)` | Remove first occurrence |
| `size()` | Number of elements |
| `contains(object)` | Check if exists |
| `indexOf(object)` | First index of element |
| `isEmpty()` | Check if empty |
| `clear()` | Remove all elements |
| `subList(from, to)` | Get sub-list |

---

## 8.3 ArrayList

### Definition
**ArrayList** is a resizable array implementation of the List interface. Fast random access, slow insertions/deletions in the middle.

### Basic Operations

```java
import java.util.ArrayList;
import java.util.Collections;

public class Main {
    public static void main(String[] args) {
        // Create ArrayList
        ArrayList<String> fruits = new ArrayList<>();
        
        // Add elements
        fruits.add("Apple");
        fruits.add("Banana");
        fruits.add("Cherry");
        fruits.add("Apple");  // Duplicates allowed!
        System.out.println(fruits);  // [Apple, Banana, Cherry, Apple]
        
        // Access
        System.out.println(fruits.get(1));  // Banana
        
        // Modify
        fruits.set(1, "Blueberry");
        System.out.println(fruits);  // [Apple, Blueberry, Cherry, Apple]
        
        // Insert at index
        fruits.add(2, "Date");
        System.out.println(fruits);  // [Apple, Blueberry, Date, Cherry, Apple]
        
        // Remove
        fruits.remove("Apple");       // Removes FIRST occurrence
        System.out.println(fruits);  // [Blueberry, Date, Cherry, Apple]
        fruits.remove(0);            // Remove by index
        System.out.println(fruits);  // [Date, Cherry, Apple]
        
        // Size and search
        System.out.println("Size: " + fruits.size());          // 3
        System.out.println("Contains Cherry: " + fruits.contains("Cherry"));  // true
        System.out.println("Index of Apple: " + fruits.indexOf("Apple"));     // 2
        
        // Sort
        Collections.sort(fruits);
        System.out.println("Sorted: " + fruits);  // [Apple, Cherry, Date]
    }
}
```

### ArrayList with Integers

```java
import java.util.ArrayList;
import java.util.Collections;

ArrayList<Integer> numbers = new ArrayList<>();
numbers.add(50);
numbers.add(10);
numbers.add(40);
numbers.add(20);
numbers.add(30);

// Sort ascending
Collections.sort(numbers);
System.out.println(numbers);  // [10, 20, 30, 40, 50]

// Sort descending
Collections.sort(numbers, Collections.reverseOrder());
System.out.println(numbers);  // [50, 40, 30, 20, 10]

// Min and Max
System.out.println("Min: " + Collections.min(numbers));  // 10
System.out.println("Max: " + Collections.max(numbers));  // 50

// Frequency
numbers.add(30);
System.out.println("Count of 30: " + Collections.frequency(numbers, 30));  // 2
```

### Internal Working

```
Initial capacity: 10
When full: grows by 50% (new capacity = old * 1.5)

Index:    [0]     [1]     [2]     [3]     [4]    ...
Values:  [Apple] [Banana] [Cherry] [null]  [null] ...
           ↑ Fast random access: O(1)
           
Insert at index 1: shift all right elements → O(n)
```

---

## 8.4 LinkedList

### Definition
**LinkedList** implements both List and Deque interfaces. Uses doubly-linked nodes. Fast insertions/deletions, slow random access.

```java
import java.util.LinkedList;

LinkedList<String> list = new LinkedList<>();

// Add
list.add("B");
list.addFirst("A");     // Add at beginning
list.addLast("C");      // Add at end
System.out.println(list);  // [A, B, C]

// Access
System.out.println(list.getFirst());  // A
System.out.println(list.getLast());   // C

// Remove
list.removeFirst();
list.removeLast();
System.out.println(list);  // [B]

// As Stack (LIFO)
list.push("X");             // Add to front
String top = list.pop();    // Remove from front

// As Queue (FIFO)
list.offer("Y");            // Add to end
String head = list.poll();  // Remove from front
```

### Internal Structure

```
         ┌──────┐    ┌──────┐    ┌──────┐
null ←── │  A   │ ←→ │  B   │ ←→ │  C   │ ──→ null
         │ prev │    │ prev │    │ prev │
         │ next │    │ next │    │ next │
         └──────┘    └──────┘    └──────┘
           head                     tail
           
get(2): Must traverse from head → O(n)
addFirst(): Just update head pointer → O(1)
```

---

## 8.5 ArrayList vs LinkedList

| Feature | ArrayList | LinkedList |
|---------|-----------|------------|
| Internal structure | Dynamic array | Doubly linked list |
| Random access `get(i)` | O(1) — Fast | O(n) — Slow |
| Add at end | O(1) amortized | O(1) |
| Insert in middle | O(n) — shift elements | O(1) — if at node |
| Delete in middle | O(n) — shift elements | O(1) — if at node |
| Memory | Less (stores only data) | More (stores data + 2 pointers) |
| When to use | Frequent reads | Frequent inserts/deletes |

---

## 8.6 Iterating Collections

```java
ArrayList<String> list = new ArrayList<>(List.of("A", "B", "C", "D"));

// Method 1: for loop
for (int i = 0; i < list.size(); i++) {
    System.out.print(list.get(i) + " ");
}

// Method 2: for-each
for (String item : list) {
    System.out.print(item + " ");
}

// Method 3: Iterator
Iterator<String> it = list.iterator();
while (it.hasNext()) {
    String item = it.next();
    System.out.print(item + " ");
    // it.remove();  ← Safe removal during iteration
}

// Method 4: forEach with lambda (Java 8+)
list.forEach(item -> System.out.print(item + " "));

// Method 5: Stream
list.stream().forEach(System.out::println);
```

### Safe Removal During Iteration

```java
// WRONG — ConcurrentModificationException!
for (String item : list) {
    if (item.equals("B")) {
        list.remove(item);  // ERROR!
    }
}

// CORRECT — Use Iterator
Iterator<String> it = list.iterator();
while (it.hasNext()) {
    if (it.next().equals("B")) {
        it.remove();  // Safe!
    }
}
```

---

## 8.7 Sorting (Comparable & Comparator)

### Comparable — Natural Ordering (Class implements it)

```java
class Student implements Comparable<Student> {
    String name;
    double gpa;
    
    Student(String name, double gpa) {
        this.name = name;
        this.gpa = gpa;
    }
    
    // Define natural ordering (by GPA descending)
    @Override
    public int compareTo(Student other) {
        return Double.compare(other.gpa, this.gpa);  // Descending
    }
    
    @Override
    public String toString() {
        return name + "(" + gpa + ")";
    }
}

// Usage
ArrayList<Student> students = new ArrayList<>();
students.add(new Student("Alice", 3.8));
students.add(new Student("Bob", 3.5));
students.add(new Student("Charlie", 3.9));

Collections.sort(students);  // Uses compareTo
System.out.println(students);  // [Charlie(3.9), Alice(3.8), Bob(3.5)]
```

### Comparator — Custom Ordering (Separate class/lambda)

```java
import java.util.Comparator;

// Sort by name alphabetically
Comparator<Student> byName = (s1, s2) -> s1.name.compareTo(s2.name);

// Sort by GPA ascending
Comparator<Student> byGpaAsc = Comparator.comparingDouble(s -> s.gpa);

// Usage
students.sort(byName);
System.out.println(students);  // [Alice(3.8), Bob(3.5), Charlie(3.9)]

students.sort(byGpaAsc);
System.out.println(students);  // [Bob(3.5), Alice(3.8), Charlie(3.9)]

// Chaining comparators
students.sort(Comparator.comparingDouble(Student::getGpa).reversed()
                       .thenComparing(s -> s.name));
```

### Comparable vs Comparator

| Feature | Comparable | Comparator |
|---------|-----------|------------|
| Package | `java.lang` | `java.util` |
| Method | `compareTo(T o)` | `compare(T o1, T o2)` |
| Where | Inside the class itself | External class or lambda |
| Number | One natural ordering | Multiple custom orderings |
| Modifies class? | Yes | No |

---

## 8.8 Practice & Assessment

### MCQs

**Q1.** ArrayList internally uses:
- A) Linked list
- B) Dynamic array
- C) Binary tree
- D) Hash table

**Answer:** B

---

**Q2.** To safely remove elements while iterating:
- A) Use for-each loop
- B) Use Iterator with `remove()`
- C) Use `list.remove()` inside loop
- D) None of the above

**Answer:** B

---

**Q3.** `Comparable` interface has the method:
- A) `compare()`
- B) `compareTo()`
- C) `equals()`
- D) `sort()`

**Answer:** B

---

### Coding Tasks

**Task 1:** Remove duplicates from an ArrayList while maintaining order.

```java
ArrayList<Integer> list = new ArrayList<>(List.of(1, 3, 2, 3, 4, 1, 5, 2));
ArrayList<Integer> unique = new ArrayList<>();

for (int num : list) {
    if (!unique.contains(num)) {
        unique.add(num);
    }
}
System.out.println(unique);  // [1, 3, 2, 4, 5]
```

**Task 2:** Sort a list of employees by salary, then by name.

```java
class Employee {
    String name;
    double salary;
    Employee(String n, double s) { name = n; salary = s; }
    public String toString() { return name + ": " + salary; }
}

List<Employee> emps = new ArrayList<>();
emps.add(new Employee("Alice", 50000));
emps.add(new Employee("Bob", 60000));
emps.add(new Employee("Charlie", 50000));

emps.sort(Comparator.comparingDouble((Employee e) -> e.salary)
                    .thenComparing(e -> e.name));
emps.forEach(System.out::println);
// Alice: 50000.0
// Charlie: 50000.0
// Bob: 60000.0
```

---

> **Next Topic:** [09 - Collections (Set & Map)](09-collections-set-map.md)
