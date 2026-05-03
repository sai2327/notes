# 09. Collections Framework — Set and Map

## Table of Contents
- [9.1 Set Interface](#91-set-interface)
- [9.2 HashSet](#92-hashset)
- [9.3 TreeSet](#93-treeset)
- [9.4 LinkedHashSet](#94-linkedhashset)
- [9.5 Map Interface](#95-map-interface)
- [9.6 HashMap](#96-hashmap)
- [9.7 TreeMap](#97-treemap)
- [9.8 Collections Comparison](#98-collections-comparison)
- [9.9 Practice & Assessment](#99-practice--assessment)

---

## 9.1 Set Interface

### Definition
A **Set** is a collection that does NOT allow duplicate elements. Models the mathematical set abstraction.

### Key Features
- No duplicates
- At most one `null` element (HashSet allows it, TreeSet doesn't)
- No index-based access (no `get(i)`)

---

## 9.2 HashSet

### Definition
**HashSet** uses a hash table internally. Fastest set operations but no ordering guarantee.

```java
import java.util.HashSet;

HashSet<String> set = new HashSet<>();

// Add elements
set.add("Apple");
set.add("Banana");
set.add("Cherry");
set.add("Apple");       // Duplicate! Not added
set.add(null);          // null allowed (once)

System.out.println(set);        // [null, Apple, Cherry, Banana] — NO order!
System.out.println(set.size()); // 4

// Check existence
System.out.println(set.contains("Apple"));  // true

// Remove
set.remove("Banana");
System.out.println(set);  // [null, Apple, Cherry]

// Iterate
for (String item : set) {
    System.out.println(item);
}
```

### How HashSet Works (Internally)

```
HashSet uses HashMap internally!
Each element is stored as a KEY in the HashMap (value = dummy constant)

Element → hashCode() → bucket index → stored in that bucket

If two objects have same hashCode → collision → equals() checks if truly duplicate

That's why: to use custom objects in HashSet, you MUST override
both hashCode() and equals()
```

### Custom Objects in HashSet

```java
class Student {
    String name;
    int id;
    
    Student(String name, int id) {
        this.name = name;
        this.id = id;
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Student s = (Student) o;
        return id == s.id && name.equals(s.name);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(name, id);
    }
    
    @Override
    public String toString() {
        return name + "(" + id + ")";
    }
}

HashSet<Student> students = new HashSet<>();
students.add(new Student("Alice", 101));
students.add(new Student("Alice", 101));  // Duplicate — NOT added
students.add(new Student("Bob", 102));

System.out.println(students.size());  // 2
```

---

## 9.3 TreeSet

### Definition
**TreeSet** stores elements in **sorted order** (natural ordering or custom Comparator). Uses Red-Black tree internally.

```java
import java.util.TreeSet;

TreeSet<Integer> set = new TreeSet<>();
set.add(50);
set.add(20);
set.add(80);
set.add(10);
set.add(40);

System.out.println(set);        // [10, 20, 40, 50, 80] — SORTED!

// Navigation methods
System.out.println(set.first());        // 10 (smallest)
System.out.println(set.last());         // 80 (largest)
System.out.println(set.lower(40));      // 20 (strictly less than 40)
System.out.println(set.higher(40));     // 50 (strictly greater than 40)
System.out.println(set.floor(45));      // 40 (less than or equal)
System.out.println(set.ceiling(45));    // 50 (greater than or equal)

// Subsets
System.out.println(set.headSet(40));    // [10, 20] (less than 40)
System.out.println(set.tailSet(40));    // [40, 50, 80] (>= 40)
System.out.println(set.subSet(20, 50));// [20, 40] (>= 20 and < 50)

// Descending
System.out.println(set.descendingSet()); // [80, 50, 40, 20, 10]
```

> **Note:** TreeSet does NOT allow `null` (throws NullPointerException). Elements must be Comparable or a Comparator must be provided.

---

## 9.4 LinkedHashSet

### Definition
**LinkedHashSet** maintains **insertion order** while still preventing duplicates.

```java
import java.util.LinkedHashSet;

LinkedHashSet<String> set = new LinkedHashSet<>();
set.add("Banana");
set.add("Apple");
set.add("Cherry");
set.add("Apple");  // Duplicate — ignored

System.out.println(set);  // [Banana, Apple, Cherry] — insertion order preserved!
```

### Set Comparison

| Feature | HashSet | TreeSet | LinkedHashSet |
|---------|---------|---------|---------------|
| Ordering | None | Sorted | Insertion order |
| null | Allowed (1) | Not allowed | Allowed (1) |
| Performance | O(1) | O(log n) | O(1) |
| Internal | HashMap | Red-Black Tree | HashMap + LinkedList |

---

## 9.5 Map Interface

### Definition
A **Map** stores key-value pairs. Each key is unique; values can be duplicated.

### Key Methods

| Method | Description |
|--------|-------------|
| `put(key, value)` | Add/update entry |
| `get(key)` | Get value by key |
| `getOrDefault(key, default)` | Get value or default |
| `remove(key)` | Remove entry |
| `containsKey(key)` | Check key exists |
| `containsValue(value)` | Check value exists |
| `size()` | Number of entries |
| `keySet()` | Set of all keys |
| `values()` | Collection of all values |
| `entrySet()` | Set of key-value pairs |

---

## 9.6 HashMap

### Definition
**HashMap** stores key-value pairs using hash table. O(1) average for get/put. No ordering guarantee.

```java
import java.util.HashMap;
import java.util.Map;

HashMap<String, Integer> ages = new HashMap<>();

// Add entries
ages.put("Alice", 25);
ages.put("Bob", 30);
ages.put("Charlie", 28);
ages.put("Alice", 26);     // Updates existing key!
System.out.println(ages);  // {Alice=26, Bob=30, Charlie=28}

// Access
System.out.println(ages.get("Bob"));           // 30
System.out.println(ages.get("Dave"));          // null (not found)
System.out.println(ages.getOrDefault("Dave", 0));  // 0 (default)

// Check
System.out.println(ages.containsKey("Alice"));    // true
System.out.println(ages.containsValue(30));       // true

// Remove
ages.remove("Charlie");
System.out.println(ages);  // {Alice=26, Bob=30}

// Size
System.out.println(ages.size());  // 2
```

### Iterating HashMap

```java
HashMap<String, Integer> scores = new HashMap<>();
scores.put("Math", 95);
scores.put("Science", 88);
scores.put("English", 92);

// Method 1: keySet
for (String key : scores.keySet()) {
    System.out.println(key + " = " + scores.get(key));
}

// Method 2: entrySet (more efficient)
for (Map.Entry<String, Integer> entry : scores.entrySet()) {
    System.out.println(entry.getKey() + " = " + entry.getValue());
}

// Method 3: forEach lambda (Java 8+)
scores.forEach((key, value) -> System.out.println(key + " = " + value));
```

### Practical Example: Word Frequency Counter

```java
String text = "apple banana apple cherry banana apple";
String[] words = text.split(" ");

HashMap<String, Integer> freq = new HashMap<>();
for (String word : words) {
    freq.put(word, freq.getOrDefault(word, 0) + 1);
}

System.out.println(freq);
// {apple=3, banana=2, cherry=1}
```

---

## 9.7 TreeMap

### Definition
**TreeMap** stores key-value pairs in **sorted key order**. Uses Red-Black tree.

```java
import java.util.TreeMap;

TreeMap<String, Integer> map = new TreeMap<>();
map.put("Charlie", 3);
map.put("Alice", 1);
map.put("Bob", 2);

System.out.println(map);            // {Alice=1, Bob=2, Charlie=3} — sorted by key!
System.out.println(map.firstKey()); // Alice
System.out.println(map.lastKey());  // Charlie
```

### Map Comparison

| Feature | HashMap | TreeMap | LinkedHashMap |
|---------|---------|---------|---------------|
| Ordering | None | Sorted by key | Insertion order |
| null key | Allowed (1) | Not allowed | Allowed (1) |
| Performance | O(1) | O(log n) | O(1) |
| When to use | Default choice | Need sorted keys | Need order |

---

## 9.8 Collections Comparison

| Interface | Duplicates | Ordered | Sorted | null |
|-----------|:----------:|:-------:|:------:|:----:|
| **ArrayList** | Yes | Yes (index) | No | Yes |
| **LinkedList** | Yes | Yes (index) | No | Yes |
| **HashSet** | No | No | No | Yes (1) |
| **TreeSet** | No | Yes | Yes (natural) | No |
| **LinkedHashSet** | No | Yes (insertion) | No | Yes (1) |
| **HashMap** | Keys: No, Values: Yes | No | No | Key: 1, Values: Yes |
| **TreeMap** | Keys: No, Values: Yes | Yes | By key | Key: No, Values: Yes |

---

## 9.9 Practice & Assessment

### MCQs

**Q1.** Which allows duplicate values?
- A) HashSet
- B) TreeSet
- C) HashMap (values)
- D) Both A and B

**Answer:** C — Sets don't allow duplicates. Map values can be duplicated.

---

**Q2.** TreeSet elements are:
- A) Unordered
- B) In insertion order
- C) In sorted order
- D) In reverse order

**Answer:** C

---

**Q3.** `map.put("A", 1); map.put("A", 2);` The value for key "A" is:
- A) 1
- B) 2
- C) Error
- D) Both stored

**Answer:** B — Second put() replaces the value.

---

### Coding Tasks

**Task 1:** Find the first non-repeating character in a string.

```java
String str = "aabbcdeeff";
LinkedHashMap<Character, Integer> map = new LinkedHashMap<>();

for (char c : str.toCharArray()) {
    map.put(c, map.getOrDefault(c, 0) + 1);
}

for (Map.Entry<Character, Integer> entry : map.entrySet()) {
    if (entry.getValue() == 1) {
        System.out.println("First non-repeating: " + entry.getKey());
        break;
    }
}
// Output: First non-repeating: c
```

**Task 2:** Group students by grade using HashMap.

```java
HashMap<String, List<String>> gradeMap = new HashMap<>();
String[][] students = {{"Alice","A"}, {"Bob","B"}, {"Charlie","A"}, {"Dave","B"}};

for (String[] s : students) {
    gradeMap.computeIfAbsent(s[1], k -> new ArrayList<>()).add(s[0]);
}
System.out.println(gradeMap);
// {A=[Alice, Charlie], B=[Bob, Dave]}
```

---

> **Next Topic:** [10 - Multithreading](10-multithreading.md)
