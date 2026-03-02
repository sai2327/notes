# 📘 Chapter 3: Associative Containers — Ordered Power

> **Master set, multiset, map, multimap — Red-Black Trees, custom comparators, and ordered iteration.**

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. Red-Black Tree — The Engine](#2-red-black-tree--the-engine)
- [3. std::set](#3-stdset)
- [4. std::multiset](#4-stdmultiset)
- [5. std::map](#5-stdmap)
- [6. std::multimap](#6-stdmultimap)
- [7. Custom Comparators](#7-custom-comparators)
- [8. Iterator Behavior](#8-iterator-behavior)
- [9. Performance Analysis](#9-performance-analysis)
- [10. Common Mistakes](#10-common-mistakes)
- [11. Interview Tips](#11-interview-tips)
- [12. Competitive Programming Tricks](#12-competitive-programming-tricks)
- [13. Edge Cases](#13-edge-cases)
- [14. Summary](#14-summary)
- [15. Practice Section](#15-practice-section)

---

## 1. Overview

Associative containers store elements in a **sorted order** (by key). They are implemented using **self-balancing binary search trees** (Red-Black Trees in all major implementations).

```
┌───────────────────────────────────────────────────────┐
│              Associative Containers                    │
├──────────┬──────────┬──────────┬──────────────────────┤
│   set    │ multiset │   map    │     multimap         │
│          │          │          │                      │
│ Unique   │ Allows   │ Key→Val  │ Key→Val              │
│ Keys     │ Dupes    │ Unique   │ Allows Dupe Keys     │
│          │          │ Keys     │                      │
│ {1,2,3}  │{1,1,2,3} │{a:1,b:2}│ {a:1,a:2,b:3}       │
└──────────┴──────────┴──────────┴──────────────────────┘

All use Red-Black Trees internally.
All provide O(log n) insert, find, erase.
All keep elements SORTED.
```

---

## 2. Red-Black Tree — The Engine

### 2.1 What is a Red-Black Tree?

A Red-Black Tree is a **self-balancing Binary Search Tree (BST)** that guarantees O(log n) operations by maintaining five invariants:

### 2.2 Red-Black Tree Properties

1. Every node is either **RED** or **BLACK**
2. The **root** is always **BLACK**
3. Every **leaf (NULL/NIL)** is **BLACK**
4. If a node is **RED**, both its children are **BLACK** (no two consecutive reds)
5. For every node, all paths from that node to its descendant leaves have the **same number of black nodes** (Black-Height)

### 2.3 Visual Representation

```
                    [13 B]
                   /       \
              [8 R]         [17 R]
             /    \         /     \
          [1 B]  [11 B]  [15 B]  [25 B]
            \                    /
           [6 R]              [22 R]

B = Black node, R = Red node
Black-height from root = 2 (count black nodes on any path to leaf)
```

### 2.4 Why Red-Black Trees?

| Property            | BST (unbalanced) | AVL Tree | Red-Black Tree |
| ------------------- | ---------------- | -------- | -------------- |
| Search              | O(n) worst       | O(log n) | O(log n)       |
| Insert              | O(n) worst       | O(log n) | O(log n)       |
| Delete              | O(n) worst       | O(log n) | O(log n)       |
| Rotations on insert | 0                | O(log n) | **≤ 2**        |
| Rotations on delete | 0                | O(log n) | **≤ 3**        |
| Balance strictness  | None             | Strict   | Relaxed        |

**Key advantage**: RB trees need at most **2 rotations for insert** and **3 rotations for delete**, making them faster in practice for frequent modifications.

### 2.5 Height Guarantee

For a Red-Black Tree with n nodes:

$$h \leq 2 \log_2(n + 1)$$

This means a tree with 1 million elements has height ≤ 40, so at most 40 comparisons for any operation.

### 2.6 Rotations

```
Left Rotation at x:          Right Rotation at y:

    x                            y
   / \          →               / \
  a   y                        x   c
     / \        ←              / \
    b   c                     a   b
```

### 2.7 Internal Node Structure

```cpp
// Simplified internal node of RB Tree
template <typename T>
struct RBNode {
    T data;
    RBNode* parent;
    RBNode* left;
    RBNode* right;
    bool is_red;  // true = red, false = black
    // Total: sizeof(T) + 3*8 + 1 = sizeof(T) + 25 bytes (+ padding)
};
```

---

## 3. std::set

### 3.1 Concept Explanation

`std::set` is an associative container that stores **unique elements** in **sorted order**. No duplicates allowed.

```cpp
#include <set>

std::set<int> s = {3, 1, 4, 1, 5, 9, 2, 6, 5};
// s = {1, 2, 3, 4, 5, 6, 9}  — sorted, unique
```

### 3.2 Internal Structure

```
std::set<int> s = {1, 3, 5, 7, 9};

Internal Red-Black Tree:

            [5 B]
           /     \
        [3 R]   [7 R]
        /  \    /  \
     [1 B] NIL NIL [9 B]

In-order traversal gives: 1, 3, 5, 7, 9 (sorted!)
```

### 3.3 Time Complexity

| Operation                | Complexity         | Notes                          |
| ------------------------ | ------------------ | ------------------------------ |
| `insert(val)`            | **O(log n)**       | Returns pair<iterator, bool>   |
| `emplace(val)`           | **O(log n)**       | Constructs in-place            |
| `erase(val)`             | **O(log n)**       | Returns number erased (0 or 1) |
| `erase(it)`              | **O(1)** amortized | Given iterator                 |
| `find(val)`              | **O(log n)**       | Returns iterator (or end)      |
| `count(val)`             | **O(log n)**       | Returns 0 or 1                 |
| `contains(val)`          | **O(log n)**       | C++20, returns bool            |
| `lower_bound(val)`       | **O(log n)**       | First element ≥ val            |
| `upper_bound(val)`       | **O(log n)**       | First element > val            |
| `equal_range(val)`       | **O(log n)**       | Range of equal elements        |
| `size()`                 | **O(1)**           |                                |
| `empty()`                | **O(1)**           |                                |
| `clear()`                | **O(n)**           |                                |
| Construction from range  | **O(n log n)**     |                                |
| Construction from sorted | **O(n)**           | Hint-based insertion           |

### 3.4 Memory Behavior

- Each element is stored in a **tree node** with parent, left, right pointers and color bit
- Memory overhead: **~32-40 bytes per element** (on 64-bit systems)
- Each insertion allocates a new node from the heap
- No contiguous memory guarantee

### 3.5 Syntax & All Important Functions

```cpp
#include <set>

// ─────────────────────────── Construction ───────────────────────────
std::set<int> s1;                            // Empty (default comparator: less<int>)
std::set<int> s2 = {3, 1, 4, 1, 5};        // {1, 3, 4, 5}
std::set<int> s3(s2);                       // Copy
std::set<int> s4(s2.begin(), s2.end());    // Range
std::set<int, std::greater<int>> s5;        // Descending order

// ─────────────────────────── Capacity ───────────────────────────────
s.size();          // Number of elements
s.empty();         // Whether set is empty
s.max_size();      // Maximum possible size

// ─────────────────────────── Modifiers ──────────────────────────────
auto [it, inserted] = s.insert(42);    // Insert element, returns {iterator, success}
s.insert({1, 2, 3});                   // Insert multiple via initializer list
s.insert(first, last);                 // Insert range
s.emplace(42);                         // Construct in-place
s.emplace_hint(it, 42);              // Construct with position hint (amortized O(1) if correct)
s.erase(42);                           // Erase by value: returns count erased (0 or 1)
s.erase(it);                           // Erase by iterator
s.erase(first, last);                 // Erase range
s.clear();                             // Remove all elements
s.swap(other);                         // Swap with another set

// ─────────────────────────── Lookup ─────────────────────────────────
s.find(42);                    // Iterator to element (or end())
s.count(42);                   // 0 or 1 (for set)
s.contains(42);                // C++20: true/false
s.lower_bound(42);             // Iterator to first element >= 42
s.upper_bound(42);             // Iterator to first element > 42
s.equal_range(42);             // pair<lower_bound, upper_bound>

// ─────────────────────────── Observers ──────────────────────────────
s.key_comp();                  // Returns the comparison function
s.value_comp();                // Same as key_comp() for set

// ─────────────────────────── Node Operations (C++17) ────────────────
auto node = s.extract(42);     // Remove and return node handle
s.insert(std::move(node));    // Insert node handle
s.merge(other_set);            // Move elements from other_set
```

### 3.6 Code Examples

#### Example 1: Basic Set Operations

```cpp
#include <iostream>
#include <set>

int main() {
    std::set<int> s = {5, 2, 8, 1, 9, 3, 7};
    
    // Iteration (always sorted)
    for (int x : s) std::cout << x << " ";
    // Output: 1 2 3 5 7 8 9
    
    // Insert
    auto [it, success] = s.insert(4);
    if (success) std::cout << "\nInserted " << *it;  // "Inserted 4"
    
    auto [it2, success2] = s.insert(5);  // Already exists
    if (!success2) std::cout << "\n5 already exists";
    
    // Find
    auto found = s.find(7);
    if (found != s.end()) {
        std::cout << "\nFound: " << *found;
    }
    
    // Lower bound: first element >= 6
    auto lb = s.lower_bound(6);
    std::cout << "\nLower bound of 6: " << *lb;  // 7
    
    // Upper bound: first element > 5
    auto ub = s.upper_bound(5);
    std::cout << "\nUpper bound of 5: " << *ub;  // 7
    
    return 0;
}
```

#### Example 2: Set Operations (Union, Intersection, Difference)

```cpp
#include <iostream>
#include <set>
#include <algorithm>
#include <vector>

int main() {
    std::set<int> a = {1, 2, 3, 4, 5};
    std::set<int> b = {3, 4, 5, 6, 7};
    
    // Union: A ∪ B
    std::set<int> union_set;
    std::set_union(a.begin(), a.end(), b.begin(), b.end(),
                   std::inserter(union_set, union_set.begin()));
    // {1, 2, 3, 4, 5, 6, 7}
    
    // Intersection: A ∩ B
    std::set<int> inter_set;
    std::set_intersection(a.begin(), a.end(), b.begin(), b.end(),
                          std::inserter(inter_set, inter_set.begin()));
    // {3, 4, 5}
    
    // Difference: A - B
    std::set<int> diff_set;
    std::set_difference(a.begin(), a.end(), b.begin(), b.end(),
                        std::inserter(diff_set, diff_set.begin()));
    // {1, 2}
    
    // Symmetric Difference: (A - B) ∪ (B - A)
    std::set<int> sym_diff;
    std::set_symmetric_difference(a.begin(), a.end(), b.begin(), b.end(),
                                  std::inserter(sym_diff, sym_diff.begin()));
    // {1, 2, 6, 7}
    
    return 0;
}
```

#### Example 3: Custom Comparator Set

```cpp
#include <iostream>
#include <set>
#include <string>

// Sort strings by length, then alphabetically
struct LengthCompare {
    bool operator()(const std::string& a, const std::string& b) const {
        if (a.length() != b.length()) return a.length() < b.length();
        return a < b;
    }
};

int main() {
    std::set<std::string, LengthCompare> words;
    words.insert("cat");
    words.insert("elephant");
    words.insert("dog");
    words.insert("hi");
    words.insert("ant");
    
    for (const auto& w : words) {
        std::cout << w << " ";
    }
    // Output: hi ant cat dog elephant
    
    return 0;
}
```

### 3.7 When to Use

✅ **Use set when:**
- You need unique elements in sorted order
- You need O(log n) insert, find, erase
- You need `lower_bound`/`upper_bound` queries
- You need to iterate in sorted order
- Elements need to be automatically deduplicated

### 3.8 When NOT to Use

❌ **Don't use set when:**
- You only need O(1) lookup → use `unordered_set`
- You need to store duplicates → use `multiset`
- You need key-value pairs → use `map`
- You need random access by index → use `vector` + `sort`
- Order doesn't matter and you need max speed → use `unordered_set`

---

## 4. std::multiset

### 4.1 Concept Explanation

`std::multiset` is like `set` but allows **duplicate elements**. All duplicates are stored and maintained in sorted order.

```cpp
#include <set>

std::multiset<int> ms = {3, 1, 4, 1, 5, 9, 2, 6, 5};
// ms = {1, 1, 2, 3, 4, 5, 5, 6, 9}  — sorted, with duplicates
```

### 4.2 Key Differences from set

| Operation     | set                      | multiset                                     |
| ------------- | ------------------------ | -------------------------------------------- |
| `insert(val)` | Returns `pair<it, bool>` | Returns `iterator` (always succeeds)         |
| `count(val)`  | 0 or 1                   | 0 to n                                       |
| `erase(val)`  | Erases 0 or 1            | **Erases ALL occurrences**                   |
| `find(val)`   | Returns one iterator     | Returns iterator to **any** matching element |
| Duplicates    | ❌ Not allowed            | ✅ Allowed                                    |

### 4.3 Time Complexity

| Operation          | Complexity         | Notes                       |
| ------------------ | ------------------ | --------------------------- |
| `insert(val)`      | **O(log n)**       | Always succeeds             |
| `erase(val)`       | **O(log n + k)**   | k = number of copies erased |
| `erase(it)`        | **O(1)** amortized | Erase single occurrence     |
| `find(val)`        | **O(log n)**       |                             |
| `count(val)`       | **O(log n + k)**   | k = number of occurrences   |
| `lower_bound(val)` | **O(log n)**       | First element ≥ val         |
| `upper_bound(val)` | **O(log n)**       | First element > val         |
| `equal_range(val)` | **O(log n)**       | Range of all equal elements |

### 4.4 Syntax & Important Functions

```cpp
#include <set>

std::multiset<int> ms;

// Insert (always succeeds, returns iterator)
auto it = ms.insert(42);

// Erase ALL occurrences of a value
ms.erase(42);  // Removes ALL 42s!

// Erase ONLY ONE occurrence
auto it = ms.find(42);
if (it != ms.end()) {
    ms.erase(it);  // Removes only ONE 42
}

// Count occurrences
int cnt = ms.count(42);  // Can be > 1

// Range of equal elements
auto [lo, hi] = ms.equal_range(42);
// [lo, hi) contains all elements equal to 42
for (auto it = lo; it != hi; ++it) {
    std::cout << *it << " ";
}
```

### 4.5 Code Examples

#### Multiset as a Sorted Collection with Duplicates

```cpp
#include <iostream>
#include <set>

int main() {
    std::multiset<int> ms;
    
    // Insert with duplicates
    ms.insert(5);
    ms.insert(3);
    ms.insert(5);
    ms.insert(1);
    ms.insert(3);
    ms.insert(5);
    // ms = {1, 3, 3, 5, 5, 5}
    
    std::cout << "Count of 5: " << ms.count(5) << "\n";  // 3
    std::cout << "Count of 3: " << ms.count(3) << "\n";  // 2
    
    // ⚠️ Erase by value removes ALL
    ms.erase(5);
    // ms = {1, 3, 3}
    
    // Erase only one occurrence
    ms.insert(3);
    // ms = {1, 3, 3, 3}
    auto it = ms.find(3);
    ms.erase(it);
    // ms = {1, 3, 3}
    
    // Iterate all occurrences of a value
    ms = {1, 2, 2, 3, 3, 3, 4};
    auto [lo, hi] = ms.equal_range(3);
    std::cout << "All 3s: ";
    for (auto it = lo; it != hi; ++it) std::cout << *it << " ";
    // Output: 3 3 3
    
    return 0;
}
```

#### Multiset as a Dynamic Sorted Array (Median Finding)

```cpp
#include <iostream>
#include <set>

// Find median of a stream of numbers
class MedianFinder {
    std::multiset<int> lower, upper;
    // lower: larger half stored in ascending order, we use rbegin for max
    // upper: smaller half
    // Actually, use a cleaner approach:
    
public:
    std::multiset<int> data;
    
    void addNum(int num) {
        data.insert(num);
    }
    
    double findMedian() {
        int n = data.size();
        auto it = data.begin();
        std::advance(it, (n - 1) / 2);
        
        if (n % 2 == 1) {
            return *it;
        } else {
            int a = *it;
            ++it;
            int b = *it;
            return (a + b) / 2.0;
        }
    }
};
```

### 4.6 When to Use

✅ **Use multiset when:**
- You need a sorted collection that allows duplicates
- You need O(log n) insert/find/erase
- You need to count occurrences efficiently
- Implementing a sliding window with sorted order

### 4.7 When NOT to Use

❌ **Don't use multiset when:**
- You don't need duplicates → use `set`
- You need O(1) lookup → use `unordered_multiset`
- You need key-value associations → use `multimap`

---

## 5. std::map

### 5.1 Concept Explanation

`std::map` stores **key-value pairs** in **sorted order by key**. Each key is unique. It's one of the most versatile containers in STL.

```cpp
#include <map>

std::map<std::string, int> age;
age["Alice"] = 30;
age["Bob"] = 25;
age["Charlie"] = 35;
// Stored sorted by key: Alice→30, Bob→25, Charlie→35
```

### 5.2 Internal Structure

```
std::map<string, int>:
{"alice":1, "bob":2, "charlie":3, "dave":4, "eve":5}

Internal Red-Black Tree (keys in sorted order):

              ["charlie":3 B]
              /               \
      ["bob":2 R]         ["eve":5 R]
      /        \          /         \
["alice":1 B]  NIL  ["dave":4 B]   NIL
```

Each node stores a `std::pair<const Key, Value>`.

### 5.3 Time Complexity

| Operation                    | Complexity         | Notes                           |
| ---------------------------- | ------------------ | ------------------------------- |
| `operator[key]`              | **O(log n)**       | Inserts default if not found!   |
| `at(key)`                    | **O(log n)**       | Throws if not found             |
| `insert({key, val})`         | **O(log n)**       | No-op if key exists             |
| `insert_or_assign(key, val)` | **O(log n)**       | C++17: insert or update         |
| `try_emplace(key, args)`     | **O(log n)**       | C++17: construct only if absent |
| `emplace(key, val)`          | **O(log n)**       | Construct in-place              |
| `erase(key)`                 | **O(log n)**       | Returns count erased            |
| `erase(it)`                  | **O(1)** amortized |                                 |
| `find(key)`                  | **O(log n)**       |                                 |
| `count(key)`                 | **O(log n)**       | Returns 0 or 1                  |
| `contains(key)`              | **O(log n)**       | C++20                           |
| `lower_bound(key)`           | **O(log n)**       |                                 |
| `upper_bound(key)`           | **O(log n)**       |                                 |
| Iteration                    | **O(n)**           | In sorted key order             |

### 5.4 Memory Behavior

- Each entry occupies a tree node: `pair<const Key, Value>` + 3 pointers + color
- Memory overhead: **~32-40 bytes per entry** plus key+value sizes
- Individual heap allocations per node (poor cache performance)

### 5.5 Syntax & All Important Functions

```cpp
#include <map>

// ─────────────────────────── Construction ───────────────────────────
std::map<std::string, int> m1;                              // Empty
std::map<std::string, int> m2 = {{"a", 1}, {"b", 2}};     // Initializer list
std::map<std::string, int> m3(m2);                         // Copy
std::map<std::string, int, std::greater<>> m4;              // Reverse order

// ─────────────────────────── Element Access ─────────────────────────
m["key"];          // Access or INSERT default value if not found!
m.at("key");       // Access, THROWS if not found

// ─────────────────────────── Modifiers ──────────────────────────────
m["key"] = 42;                         // Insert or update
m.insert({"key", 42});                // Insert only (no update if exists)
m.insert(std::make_pair("key", 42));  // Same
m.insert_or_assign("key", 42);       // C++17: Insert or update
m.try_emplace("key", 42);            // C++17: Insert only, avoids construction if key exists
m.emplace("key", 42);                // Construct in-place
m.erase("key");                       // Erase by key
m.erase(it);                          // Erase by iterator
m.erase(first, last);                // Erase range
m.clear();                            // Remove all
m.swap(other);                        // Swap

// ─────────────────────────── Lookup ─────────────────────────────────
m.find("key");             // Returns iterator (or end())
m.count("key");            // 0 or 1
m.contains("key");         // C++20: true/false
m.lower_bound("key");     // First element with key >= "key"
m.upper_bound("key");     // First element with key > "key"
m.equal_range("key");     // pair<lower_bound, upper_bound>

// ─────────────────────────── Node Operations (C++17) ────────────────
auto node = m.extract("key");   // Remove and return node handle
m.insert(std::move(node));     // Insert node handle
m.merge(other_map);            // Move elements from other map
```

### 5.6 Code Examples

#### Example 1: Frequency Counter

```cpp
#include <iostream>
#include <map>
#include <string>

int main() {
    std::string text = "hello world hello cpp hello world";
    std::map<std::string, int> freq;
    
    // Count word frequencies
    std::istringstream iss(text);
    std::string word;
    while (iss >> word) {
        freq[word]++;  // operator[] creates entry with 0 if not found, then increments
    }
    
    // Print in alphabetical order (map is sorted by key)
    for (const auto& [word, count] : freq) {
        std::cout << word << ": " << count << "\n";
    }
    // Output:
    // cpp: 1
    // hello: 3
    // world: 2
    
    return 0;
}
```

#### Example 2: operator[] vs find() vs at()

```cpp
#include <iostream>
#include <map>

int main() {
    std::map<std::string, int> m = {{"a", 1}, {"b", 2}};
    
    // operator[] — DANGEROUS: Creates entry if not found!
    std::cout << m["c"] << "\n";  // Prints 0, AND inserts {"c", 0}!
    std::cout << m.size() << "\n";  // 3 (not 2!)
    
    // find() — SAFE: Returns iterator
    auto it = m.find("d");
    if (it != m.end()) {
        std::cout << it->second << "\n";
    } else {
        std::cout << "Not found\n";
    }
    // m.size() still 3
    
    // at() — SAFE: Throws exception
    try {
        std::cout << m.at("e") << "\n";
    } catch (const std::out_of_range& e) {
        std::cout << "Exception: " << e.what() << "\n";
    }
    
    return 0;
}
```

#### Example 3: Map with Custom Key Type

```cpp
#include <iostream>
#include <map>

struct Point {
    int x, y;
    
    // Required: operator< for map key
    bool operator<(const Point& other) const {
        if (x != other.x) return x < other.x;
        return y < other.y;
    }
};

int main() {
    std::map<Point, std::string> labels;
    labels[{0, 0}] = "origin";
    labels[{1, 0}] = "right";
    labels[{0, 1}] = "up";
    
    for (const auto& [point, label] : labels) {
        std::cout << "(" << point.x << "," << point.y << "): " << label << "\n";
    }
    // Output (sorted by Point::operator<):
    // (0,0): origin
    // (0,1): up
    // (1,0): right
    
    return 0;
}
```

#### Example 4: C++17 Structured Bindings & insert_or_assign

```cpp
#include <iostream>
#include <map>

int main() {
    std::map<std::string, int> scores;
    
    // C++17: insert_or_assign
    scores.insert_or_assign("Alice", 90);   // Inserts
    scores.insert_or_assign("Alice", 95);   // Updates to 95
    
    // C++17: try_emplace (does NOT overwrite)
    scores.try_emplace("Alice", 100);  // Does NOT update (Alice already exists)
    scores.try_emplace("Bob", 85);     // Inserts Bob
    
    // C++17: Structured bindings
    for (const auto& [name, score] : scores) {
        std::cout << name << ": " << score << "\n";
    }
    // Alice: 95
    // Bob: 85
    
    // C++17: Node extraction and transfer
    std::map<std::string, int> other_scores;
    auto node = scores.extract("Alice");
    if (!node.empty()) {
        node.key() = "ALICE";  // Can modify the key!
        other_scores.insert(std::move(node));
    }
    
    return 0;
}
```

### 5.7 When to Use

✅ **Use map when:**
- You need key-value associations with sorted keys
- You need O(log n) ordered operations
- You need `lower_bound`/`upper_bound` on keys
- You need to iterate in key order
- Keys must be unique

### 5.8 When NOT to Use

❌ **Don't use map when:**
- You only need O(1) lookup → use `unordered_map`
- You need duplicate keys → use `multimap`
- You're doing simple frequency counting and order doesn't matter → use `unordered_map`
- Memory/cache performance is critical → consider `vector<pair>` + sort

---

## 6. std::multimap

### 6.1 Concept Explanation

`std::multimap` stores **key-value pairs** where **duplicate keys are allowed**. Elements are sorted by key.

```cpp
#include <map>

std::multimap<std::string, int> scores;
scores.insert({"Alice", 90});
scores.insert({"Alice", 95});  // Duplicate key allowed!
scores.insert({"Bob", 85});
// Stored: Alice→90, Alice→95, Bob→85
```

### 6.2 Key Differences from map

| Feature            | map      | multimap                   |
| ------------------ | -------- | -------------------------- |
| Duplicate keys     | ❌        | ✅                          |
| `operator[]`       | ✅        | ❌ (which value to return?) |
| `at()`             | ✅        | ❌                          |
| `insert()`         | May fail | Always succeeds            |
| `count(key)`       | 0 or 1   | 0 to n                     |
| `insert_or_assign` | ✅        | ❌                          |
| `try_emplace`      | ✅        | ❌                          |

### 6.3 Syntax & Functions

```cpp
#include <map>

std::multimap<std::string, int> mm;

// Insert (always succeeds)
mm.insert({"key", 42});
mm.emplace("key", 43);

// Count occurrences of a key
int cnt = mm.count("key");  // 2

// Find first element with key
auto it = mm.find("key");  // Iterator to first match

// Get ALL elements with a key
auto [lo, hi] = mm.equal_range("key");
for (auto it = lo; it != hi; ++it) {
    std::cout << it->first << ": " << it->second << "\n";
}

// Erase ALL with key
mm.erase("key");  // Erases all entries with this key

// Erase ONE
auto it = mm.find("key");
if (it != mm.end()) {
    mm.erase(it);  // Erases only one entry
}
```

### 6.4 Code Example

```cpp
#include <iostream>
#include <map>

int main() {
    std::multimap<std::string, std::string> phone_book;
    
    // A person can have multiple phone numbers
    phone_book.insert({"Alice", "555-0001"});
    phone_book.insert({"Alice", "555-0002"});
    phone_book.insert({"Bob", "555-0003"});
    phone_book.insert({"Alice", "555-0004"});
    
    // Find all numbers for Alice
    std::cout << "Alice's numbers:\n";
    auto [lo, hi] = phone_book.equal_range("Alice");
    for (auto it = lo; it != hi; ++it) {
        std::cout << "  " << it->second << "\n";
    }
    // 555-0001, 555-0002, 555-0004
    
    // Count
    std::cout << "Alice has " << phone_book.count("Alice") << " numbers\n";  // 3
    
    return 0;
}
```

### 6.5 When to Use

✅ One-to-many relationships, event scheduling (same time → multiple events), adjacency lists.

❌ If `unordered_multimap` suffices (no order needed), use it for better average performance.

---

## 7. Custom Comparators

### 7.1 Why Custom Comparators?

By default, associative containers use `std::less<Key>` (operator `<`). Custom comparators let you:
- Sort in descending order
- Sort by custom criteria (length, absolute value, etc.)
- Use types without `operator<`

### 7.2 Three Ways to Define Comparators

#### Method 1: Function Object (Functor)

```cpp
struct DescendingCompare {
    bool operator()(int a, int b) const {
        return a > b;  // Descending order
    }
};

std::set<int, DescendingCompare> s = {3, 1, 4, 1, 5};
// s = {5, 4, 3, 1}
```

#### Method 2: Lambda (C++20 for template, or with decltype trick)

```cpp
// C++20 (stateless lambda as template parameter)
auto cmp = [](int a, int b) { return a > b; };
std::set<int, decltype(cmp)> s(cmp);

// Alternative with std::function
std::set<int, std::function<bool(int, int)>> s2(
    [](int a, int b) { return a > b; }
);
```

#### Method 3: std::greater<> (Built-in)

```cpp
std::set<int, std::greater<int>> s = {3, 1, 4, 1, 5};
// s = {5, 4, 3, 1}

std::map<int, std::string, std::greater<int>> m;
// Keys in descending order
```

### 7.3 Comparator Rules (Strict Weak Ordering)

Your comparator **MUST** satisfy:

1. **Irreflexivity**: `comp(a, a)` must be `false`
2. **Asymmetry**: If `comp(a, b)` is `true`, then `comp(b, a)` must be `false`
3. **Transitivity**: If `comp(a, b)` and `comp(b, c)`, then `comp(a, c)` must be `true`
4. **Transitivity of equivalence**: If `!comp(a, b)` and `!comp(b, a)`, and `!comp(b, c)` and `!comp(c, b)`, then `!comp(a, c)` and `!comp(c, a)`

```cpp
// ❌ WRONG: Using <= instead of <
struct BadCompare {
    bool operator()(int a, int b) const {
        return a <= b;  // VIOLATES irreflexivity! comp(5,5) = true
    }
};
// This causes UNDEFINED BEHAVIOR in set/map!

// ✅ CORRECT: Use strict less-than
struct GoodCompare {
    bool operator()(int a, int b) const {
        return a < b;  // comp(5,5) = false ✓
    }
};
```

### 7.4 Advanced Comparator Examples

#### Case-insensitive String Map

```cpp
struct CaseInsensitiveCompare {
    bool operator()(const std::string& a, const std::string& b) const {
        return std::lexicographical_compare(
            a.begin(), a.end(), b.begin(), b.end(),
            [](char c1, char c2) { return std::tolower(c1) < std::tolower(c2); }
        );
    }
};

std::map<std::string, int, CaseInsensitiveCompare> m;
m["Hello"] = 1;
m["hello"] = 2;  // Overwrites! Same key case-insensitively
// m.size() = 1
```

#### Multi-field Comparison

```cpp
struct Employee {
    std::string department;
    int salary;
    std::string name;
};

struct EmployeeCompare {
    bool operator()(const Employee& a, const Employee& b) const {
        // Sort by: department ASC, salary DESC, name ASC
        if (a.department != b.department) return a.department < b.department;
        if (a.salary != b.salary) return a.salary > b.salary;  // DESC
        return a.name < b.name;
    }
};

std::set<Employee, EmployeeCompare> employees;
```

---

## 8. Iterator Behavior

### 8.1 Iterator Properties

- All associative containers provide **Bidirectional Iterators**
- Iteration order = sorted order
- Dereferencing gives `const Key` (set) or `pair<const Key, Value>` (map)

### 8.2 Iterator Invalidation Rules

```
┌─────────────────────────────────────────────────────────────┐
│        Iterator Invalidation Rules for set/map               │
├──────────────┬──────────────────────────────────────────────┤
│ Operation    │ Effect on Iterators                          │
├──────────────┼──────────────────────────────────────────────┤
│ insert()     │ NO invalidation (all iterators remain valid) │
│ emplace()    │ NO invalidation                              │
│ erase(it)    │ ONLY 'it' is invalidated                    │
│ erase(val)   │ ONLY iterators to erased elements           │
│ clear()      │ ALL invalidated                              │
│ swap()       │ Iterators swap containers (remain valid!)    │
└──────────────┴──────────────────────────────────────────────┘
```

This is a **huge advantage** over vector! You can insert and erase while iterating (carefully):

```cpp
std::set<int> s = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

// Erase all even numbers while iterating
for (auto it = s.begin(); it != s.end(); ) {
    if (*it % 2 == 0) {
        it = s.erase(it);  // C++11: erase returns next iterator
    } else {
        ++it;
    }
}
// s = {1, 3, 5, 7, 9}
```

### 8.3 Iterator Tricks

```cpp
std::set<int> s = {10, 20, 30, 40, 50};

// Get iterator to last element
auto last = std::prev(s.end());  // Points to 50

// Get min and max
int mn = *s.begin();              // 10 (smallest)
int mx = *s.rbegin();             // 50 (largest)

// Get k-th smallest element (O(k))
auto it = s.begin();
std::advance(it, k);  // 0-indexed

// Get predecessor/successor of a value
auto it2 = s.find(30);
if (it2 != s.begin()) {
    auto pred = std::prev(it2);  // Points to 20
}
auto succ = std::next(it2);     // Points to 40
```

---

## 9. Performance Analysis

### 9.1 set/map vs unordered_set/unordered_map

| Metric             | set / map   | unordered_set / unordered_map |
| ------------------ | ----------- | ----------------------------- |
| Average find       | O(log n)    | **O(1)**                      |
| Worst case find    | O(log n)    | **O(n)**                      |
| Insert             | O(log n)    | O(1) avg, O(n) worst          |
| Memory per element | ~40 bytes   | ~50-70 bytes                  |
| Cache performance  | Poor (tree) | Poor (hash table)             |
| Ordered iteration  | ✅ Yes       | ❌ No                          |
| lower_bound        | ✅ O(log n)  | ❌ N/A                         |
| Constant factor    | Lower       | Higher (hashing)              |

### 9.2 When is map Faster Than unordered_map?

1. **Small sizes** (n < 100): Map's O(log n) ≈ 7, hash overhead may exceed this
2. **String keys**: Hash computation on long strings is expensive
3. **Ordered iteration needed**: Map provides it for free
4. **Anti-hash attacks**: Competitive programming with crafted worst cases

### 9.3 Benchmark Guidelines

```
Typical operations per second (rough estimates):

set/map find:           ~20-50 million/sec (depends on key type)
unordered find:         ~50-100 million/sec (good hash, no collisions)
vector binary_search:   ~100-200 million/sec (cache friendly!)

For competitive programming:
- n ≤ 10^6: both set and unordered_set work
- n ≤ 10^7: prefer unordered_set (or sorted vector)
- n > 10^7: sorted vector + binary search is fastest
```

---

## 10. Common Mistakes

### Mistake 1: operator[] on map Inserts Default

```cpp
std::map<std::string, int> m;

// ❌ This INSERT a new entry with default value!
if (m["key"] == 0) {
    // "key" now exists in the map with value 0!
}

// ✅ Use find() or count()
if (m.count("key") == 0) {
    // Key truly doesn't exist
}

// ✅ C++20
if (!m.contains("key")) {
    // Key doesn't exist
}
```

### Mistake 2: Modifying Set Elements

```cpp
std::set<int> s = {1, 2, 3};
auto it = s.begin();
// *it = 10;  // ❌ COMPILE ERROR! Set elements are const!

// To "modify" an element:
// 1. Erase old element
// 2. Insert new element
s.erase(it);
s.insert(10);

// C++17: Extract and modify
auto node = s.extract(1);
if (!node.empty()) {
    node.value() = 10;
    s.insert(std::move(node));
}
```

### Mistake 3: Using Wrong Comparator (<=)

```cpp
// ❌ UNDEFINED BEHAVIOR!
std::set<int, std::less_equal<int>> s;
s.insert(1);
s.insert(1);
// The set thinks 1 != 1 (because !(1<=1) is false, but 1<=1 is true)
// This breaks the tree invariants → UB!

// ✅ Always use strict ordering (<, >)
std::set<int, std::less<int>> s;  // Correct
```

### Mistake 4: Erasing All vs One in multiset

```cpp
std::multiset<int> ms = {1, 2, 2, 2, 3};

// ❌ Erases ALL 2s
ms.erase(2);
// ms = {1, 3}

// ✅ To erase only ONE 2:
auto it = ms.find(2);
if (it != ms.end()) ms.erase(it);
```

### Mistake 5: Using std::find() Instead of member find()

```cpp
std::set<int> s = {1, 2, 3, 4, 5};

// ❌ SLOW: O(n) — uses linear search!
auto it = std::find(s.begin(), s.end(), 3);

// ✅ FAST: O(log n) — uses tree search!
auto it = s.find(3);
```

---

## 11. Interview Tips

### Must-Know Questions

**Q1: How does `std::map` handle collisions?**
> It doesn't — it's a tree, not a hash table. Each key is at a unique node. Key comparison uses `operator<`, not hashing.

**Q2: What's the difference between `map::operator[]` and `map::at()`?**
> `operator[]` inserts a default-constructed value if the key doesn't exist. `at()` throws `std::out_of_range`. Use `[]` for insert-or-access patterns, `at()` for read-only access to existing keys.

**Q3: Can you change a map's key?**
> Not directly. Keys are `const`. You must erase and re-insert, or use C++17 `extract()` to modify the key.

**Q4: How does `set::insert` determine if an element already exists?**
> Using equivalence, not equality: two elements `a` and `b` are equivalent if `!comp(a,b) && !comp(b,a)`. This is important when using custom comparators.

**Q5: What happens if two different objects are "equivalent" under the comparator?**
> They are treated as the same element. Only one will be stored in a set, or they'll be grouped together in multiset/multimap.

---

## 12. Competitive Programming Tricks

### Trick 1: Set as Sorted Container with O(log n) Min/Max

```cpp
std::set<int> s;
s.insert(5);
s.insert(2);
s.insert(8);

int min_val = *s.begin();    // 2 (O(1))
int max_val = *s.rbegin();   // 8 (O(1))

// Dynamic min/max: insert and remove elements, always have sorted order
```

### Trick 2: Find Predecessor/Successor

```cpp
std::set<int> s = {10, 20, 30, 40, 50};

// Successor of 25 (first element > 25)
auto it = s.upper_bound(25);  // Points to 30

// Predecessor of 25 (last element < 25)
auto it = s.lower_bound(25);
if (it != s.begin()) {
    --it;  // Points to 20
}

// Successor of 30 (first element > 30)
auto it = s.upper_bound(30);  // Points to 40

// Predecessor of 30 (last element < 30)
auto it = s.lower_bound(30);
if (it != s.begin()) {
    --it;  // Points to 20
}
```

### Trick 3: Coordinate Compression with Set

```cpp
std::vector<int> coords = {1000, 5, 999999, 5, 1000};

// Get unique sorted coordinates
std::set<int> sorted(coords.begin(), coords.end());
// {5, 1000, 999999}

// Map to compressed values
std::map<int, int> compress;
int idx = 0;
for (int c : sorted) compress[c] = idx++;
// 5→0, 1000→1, 999999→2

for (int& c : coords) c = compress[c];
// coords = {1, 0, 2, 0, 1}
```

### Trick 4: Multiset for Sliding Window with Removal

```cpp
// Maintain a sliding window where you can efficiently:
// - Add elements
// - Remove specific elements
// - Query min/max/median

std::multiset<int> window;
std::vector<int> a = {1, 3, -1, -3, 5, 3, 6, 7};
int k = 3;

for (int i = 0; i < a.size(); i++) {
    window.insert(a[i]);
    if (window.size() > k) {
        window.erase(window.find(a[i - k]));  // Remove ONE occurrence of oldest
    }
    if (window.size() == k) {
        std::cout << *window.begin() << " ";   // Min
        std::cout << *window.rbegin() << " ";  // Max
    }
}
```

### Trick 5: Map for Interval/Range Queries

```cpp
// "Which interval does point x belong to?"
// Store intervals as map: start → end

std::map<int, int> intervals;  // start → end
intervals[1] = 5;    // [1, 5]
intervals[10] = 15;  // [10, 15]
intervals[20] = 25;  // [20, 25]

int x = 12;
auto it = intervals.upper_bound(x);  // First interval starting after x
if (it != intervals.begin()) {
    --it;  // Last interval starting at or before x
    if (it->second >= x) {
        std::cout << "Point " << x << " is in interval [" 
                  << it->first << ", " << it->second << "]\n";
        // Point 12 is in interval [10, 15]
    }
}
```

### Trick 6: Using set for Graph Problems

```cpp
// Dijkstra's algorithm with set (alternative to priority_queue)
set<pair<int,int>> pq;  // {distance, node}
pq.insert({0, source});

while (!pq.empty()) {
    auto [dist, u] = *pq.begin();
    pq.erase(pq.begin());
    
    if (dist > d[u]) continue;
    
    for (auto [v, w] : adj[u]) {
        if (d[u] + w < d[v]) {
            pq.erase({d[v], v});  // Can remove old entry! (priority_queue can't!)
            d[v] = d[u] + w;
            pq.insert({d[v], v});
        }
    }
}
// Advantage over priority_queue: can DELETE entries
```

---

## 13. Edge Cases

### Empty Container

```cpp
std::set<int> s;
// s.begin() == s.end()
// *s.begin() → UB
// *s.rbegin() → UB

auto it = s.lower_bound(5);
// it == s.end() (nothing >= 5)

s.erase(5);  // No-op, returns 0
s.find(5);   // Returns s.end()
```

### Single Element

```cpp
std::set<int> s = {42};
s.begin() == std::prev(s.end());   // Both point to 42
s.rbegin() points to same element
```

### Lower/Upper Bound Edge Cases

```cpp
std::set<int> s = {10, 20, 30};

s.lower_bound(5);   // Points to 10 (first >= 5)
s.lower_bound(10);  // Points to 10 (first >= 10)
s.lower_bound(15);  // Points to 20 (first >= 15)
s.lower_bound(30);  // Points to 30 (first >= 30)
s.lower_bound(35);  // s.end() (nothing >= 35)

s.upper_bound(10);  // Points to 20 (first > 10)
s.upper_bound(30);  // s.end() (nothing > 30)
```

### Map with Mutable Values

```cpp
std::map<int, std::vector<int>> m;
m[1].push_back(10);  // Creates empty vector, then pushes 10
m[1].push_back(20);  // Adds 20 to existing vector
// m[1] = {10, 20}
```

---

## 14. Summary

```
┌────────────────────────────────────────────────────────────────┐
│           ASSOCIATIVE CONTAINERS CHEAT SHEET                    │
├────────────┬───────────────────────────────────────────────────┤
│ set        │ Unique sorted elements. O(log n) operations.      │
│            │ RB Tree. lower_bound/upper_bound available.       │
├────────────┼───────────────────────────────────────────────────┤
│ multiset   │ Like set but allows duplicates.                   │
│            │ erase(val) removes ALL copies — use erase(it)!   │
├────────────┼───────────────────────────────────────────────────┤
│ map        │ Key→Value with unique sorted keys.                │
│            │ operator[] inserts default! Use find()/at().     │
├────────────┼───────────────────────────────────────────────────┤
│ multimap   │ Like map but allows duplicate keys.               │
│            │ No operator[] or at(). Use equal_range().        │
├────────────┼───────────────────────────────────────────────────┤
│ ALL        │ Red-Black Tree. O(log n). Bidirectional iterators.│
│            │ Stable iterators (survive insert). Sorted order.  │
└────────────┴───────────────────────────────────────────────────┘

GOLDEN RULES:
1. Use member find(), not std::find() (O(log n) vs O(n))
2. Use < not <= in comparators
3. map::operator[] inserts — use find() for lookup
4. multiset::erase(val) removes ALL — use erase(find(val)) for one
```

---

## 15. Practice Section

### Level 1 — Quick Concept Questions

1. **Q: What data structure underlies `std::set`?**
   <details><summary>Answer</summary>Red-Black Tree (self-balancing BST)</details>

2. **Q: Can you store duplicate values in a `std::set`?**
   <details><summary>Answer</summary>No. Use `std::multiset` for duplicates.</details>

3. **Q: What does `map::operator[]` do if the key doesn't exist?**
   <details><summary>Answer</summary>Inserts a new entry with a default-constructed value and returns a reference to it.</details>

4. **Q: What iterator type do associative containers provide?**
   <details><summary>Answer</summary>Bidirectional iterators.</details>

5. **Q: How do you get the minimum element from a set?**
   <details><summary>Answer</summary>`*s.begin()` — the first element is always the smallest.</details>

6. **Q: What is the difference between `lower_bound(x)` and `upper_bound(x)`?**
   <details><summary>Answer</summary>`lower_bound(x)` returns iterator to first element ≥ x. `upper_bound(x)` returns iterator to first element > x.</details>

7. **Q: Does inserting into a set invalidate existing iterators?**
   <details><summary>Answer</summary>No. Insertion never invalidates any existing iterators in associative containers.</details>

8. **Q: What comparator does `std::set` use by default?**
   <details><summary>Answer</summary>`std::less<Key>`, which uses `operator<`.</details>

9. **Q: Can `std::multimap` use `operator[]`?**
   <details><summary>Answer</summary>No, because a key might have multiple values, so `[]` would be ambiguous.</details>

10. **Q: What is the height guarantee of a Red-Black Tree with n nodes?**
    <details><summary>Answer</summary>$h \leq 2\log_2(n+1)$, ensuring O(log n) operations.</details>

---

### Level 2 — MCQs

**1. `std::set<int> s = {5, 3, 1, 4, 2}; *s.rbegin()` returns:**
- A) 1
- B) 2
- C) 5 ✅
- D) Undefined

**2. What does `map.insert({"key", 42})` do if "key" already exists?**
- A) Updates the value to 42
- B) Does nothing (no-op) ✅
- C) Throws an exception
- D) Creates a duplicate entry

**3. `std::set<int> s = {1,2,3}; s.count(2)` returns:**
- A) 0
- B) 1 ✅
- C) 2
- D) 3

**4. Which operation is NOT O(log n) for `std::set`?**
- A) `insert`
- B) `find`
- C) `size` ✅ (O(1))
- D) `erase`

**5. After `std::multiset<int> ms = {1,1,1}; ms.erase(1);` what is `ms.size()`?**
- A) 0 ✅
- B) 1
- C) 2
- D) 3

**6. Which container does NOT support `lower_bound`?**
- A) `set`
- B) `map`
- C) `unordered_set` ✅
- D) `multiset`

**7. The default comparator for `std::set<std::string>` sorts strings:**
- A) By length
- B) Lexicographically ✅
- C) By hash value
- D) By insertion order

**8. What is the internal representation of `std::map<K,V>`'s elements?**
- A) Separate key and value arrays
- B) `std::pair<const K, V>` ✅
- C) `std::pair<K, V>`
- D) `std::tuple<K, V>`

**9. `std::set<int> s; s.insert(5); s.insert(5);` — what is `s.size()`?**
- A) 0
- B) 1 ✅
- C) 2
- D) Compilation error

**10. Which of these satisfies strict weak ordering?**
- A) `a <= b` ❌
- B) `a < b` ✅
- C) `a == b`
- D) `a != b`

---

### Level 3 — Tricky Interview MCQs

**1. What is the output?**
```cpp
std::map<int, int> m;
m[1] = 10;
m[2] = 20;
auto it = m.find(3);
std::cout << (it == m.end()) << " " << m.size();
```
- A) `1 2` ✅
- B) `1 3`
- C) `0 3`
- D) `0 2`

**2. What happens with this comparator?**
```cpp
struct Comp {
    bool operator()(int a, int b) const { return a <= b; }
};
std::set<int, Comp> s;
s.insert(1); s.insert(1);
std::cout << s.size();
```
- A) 1
- B) 2
- C) Undefined Behavior ✅
- D) Compilation error

**3. After this code, what is `m.size()`?**
```cpp
std::map<std::string, int> m;
if (m["test"] == 0) {
    m["test"] = 5;
}
```
- A) 0
- B) 1 ✅
- C) 2
- D) Undefined

**4. `std::set<int> s = {1,2,3,4,5}; auto it = s.find(3); s.erase(it); std::cout << *it;`**
- A) 3
- B) 4
- C) Undefined Behavior ✅ (iterator invalidated by erase)
- D) Compilation error

**5. Regarding `std::map::try_emplace` vs `std::map::emplace`:**
- A) They are identical
- B) `try_emplace` never constructs the value if key exists ✅
- C) `emplace` never constructs the value if key exists
- D) `try_emplace` always overwrites

---

### Level 4 — True / False

| #   | Statement                                                           | Answer                        |
| --- | ------------------------------------------------------------------- | ----------------------------- |
| 1   | `std::set` uses a hash table internally                             | **False** (Red-Black Tree)    |
| 2   | `std::map::operator[]` can be used on a const map                   | **False** (might insert)      |
| 3   | Inserting into a set invalidates all iterators                      | **False** (no invalidation)   |
| 4   | `std::multiset::count()` can return values > 1                      | **True**                      |
| 5   | `std::map` keys are always stored as `const`                        | **True** (`pair<const K, V>`) |
| 6   | Red-Black Trees guarantee O(log n) worst-case search                | **True**                      |
| 7   | `std::set::find()` is the same complexity as `std::find()` on a set | **False** (O(log n) vs O(n))  |
| 8   | `std::multimap` supports `operator[]`                               | **False**                     |
| 9   | `lower_bound(x)` on an empty set returns `end()`                    | **True**                      |
| 10  | A custom comparator using `<=` satisfies strict weak ordering       | **False**                     |

---

### Level 5 — Coding Practice Problems

**Problem 1: Count Distinct Elements in Sliding Window**
```cpp
// Given array of n integers and window size k,
// for each window output the number of distinct elements.
// Input: [1, 2, 1, 3, 4, 2, 3], k = 4
// Output: 3 4 4 3
// Hint: Use map for frequency counting in the window
```

**Problem 2: Implement a Self-Balancing BST Interface**
```cpp
// Using std::set, implement:
// insert(x), remove(x), find_min(), find_max(),
// predecessor(x), successor(x), count_less_than(x)
```

**Problem 3: Merge Overlapping Intervals**
```cpp
// Given a set of intervals, merge overlapping ones.
// Input: {[1,3], [2,6], [8,10], [15,18]}
// Output: {[1,6], [8,10], [15,18]}
// Hint: Use map<int, int> to store intervals sorted by start
```

**Problem 4: Implementing a Phonebook with Prefix Search**
```cpp
// Using std::map, implement a phonebook that supports:
// add(name, number), search(prefix) → returns all names with that prefix
// Hint: Use lower_bound and upper_bound
```

**Problem 5: Multiset Median Maintenance**
```cpp
// Given a stream of numbers, after each insertion output the current median.
// Use two multisets (lower half and upper half) to maintain O(log n) per insertion.
```

---

---

## 16. Extended Examples with Test Cases

### Example 1 — set operations and iteration

```cpp
#include <iostream>
#include <set>
using namespace std;

int main() {
    set<int> s = {5, 1, 3, 2, 4, 3, 2};
    // Stored sorted, duplicates removed: {1, 2, 3, 4, 5}

    cout << s.size() << "\n";       // 5

    // Insert and check success
    auto [it, inserted] = s.insert(3);
    cout << inserted << "\n";       // 0  (3 already exists)

    auto [it2, inserted2] = s.insert(6);
    cout << inserted2 << "\n";      // 1

    // lower_bound / upper_bound
    auto lb = s.lower_bound(3);     // iterator to 3
    auto ub = s.upper_bound(3);     // iterator to 4
    cout << *lb << " " << *ub << "\n";  // 3 4

    // Count elements in range [2, 4]
    int cnt = distance(s.lower_bound(2), s.upper_bound(4));
    cout << "count in [2,4]: " << cnt << "\n";  // 3  (2,3,4)

    // erase by value
    s.erase(3);
    for (int x : s) cout << x << " ";
    cout << "\n";  // 1 2 4 5 6

    return 0;
}
```

**Expected Output:**
```
5
0
1
3 4
count in [2,4]: 3
1 2 4 5 6
```

---

### Example 2 — map operator[] vs insert vs try_emplace

```cpp
#include <iostream>
#include <map>
using namespace std;

int main() {
    map<string, int> m;

    // operator[]: inserts default if not found
    m["a"];              // inserts "a"→0
    m["b"] = 2;

    cout << m.size() << "\n";  // 2

    // insert: does NOT overwrite existing key
    m.insert({"b", 99});
    cout << m["b"] << "\n";   // 2 (not overwritten)

    // operator[] DOES overwrite
    m["b"] = 99;
    cout << m["b"] << "\n";   // 99

    // try_emplace: inserts only if key absent; does NOT construct value if key exists
    m.try_emplace("c", 3);
    m.try_emplace("c", 99);   // "c" exists, no-op
    cout << m["c"] << "\n";   // 3

    // emplace vs try_emplace: key difference
    // emplace MAY construct the value object even if key exists (then discards)
    // try_emplace does NOT construct if key exists (important for expensive types)

    for (auto& [k, v] : m)
        cout << k << ":" << v << " ";
    cout << "\n";  // a:0 b:99 c:3

    return 0;
}
```

**Expected Output:**
```
2
2
99
3
a:0 b:99 c:3
```

---

### Example 3 — multiset and equal_range

```cpp
#include <iostream>
#include <set>
using namespace std;

int main() {
    multiset<int> ms = {1, 2, 2, 3, 3, 3, 4};

    cout << ms.count(3) << "\n";   // 3

    // equal_range returns [first, last) for all '3's
    auto [lo, hi] = ms.equal_range(3);
    int cnt = distance(lo, hi);
    cout << cnt << "\n";           // 3

    // erase ONE occurrence of 3
    ms.erase(ms.find(3));          // erase only one 3
    cout << ms.count(3) << "\n";   // 2

    // erase ALL occurrences of 3
    ms.erase(3);
    cout << ms.count(3) << "\n";   // 0

    for (int x : ms) cout << x << " ";
    cout << "\n";  // 1 2 2 4

    return 0;
}
```

---

### Example 4 — map with custom comparator (reverse order)

```cpp
#include <iostream>
#include <map>
using namespace std;

int main() {
    // Descending order map
    map<int, string, greater<int>> m;
    m[1] = "one";
    m[5] = "five";
    m[3] = "three";

    for (auto& [k, v] : m)
        cout << k << ":" << v << " ";
    cout << "\n";  // 5:five 3:three 1:one

    // Successor / predecessor
    auto it = m.find(3);
    ++it;
    cout << it->first << "\n";  // 1 (next in descending order)

    return 0;
}
```

---

### Example 5 — multimap range queries

```cpp
#include <iostream>
#include <map>
using namespace std;

int main() {
    multimap<string, int> mm;
    mm.insert({"alice", 90});
    mm.insert({"bob",   80});
    mm.insert({"alice", 95});
    mm.insert({"alice", 85});

    // All grades for "alice"
    auto [lo, hi] = mm.equal_range("alice");
    for (auto it = lo; it != hi; ++it)
        cout << it->second << " ";
    cout << "\n";  // 90 95 85 (order: insertion within equal keys)

    cout << mm.count("alice") << "\n";  // 3

    return 0;
}
```

---

## 17. Tricky MCQs — Expert Level

**Q1. What does this print?**
```cpp
map<int, int> m;
m[1]; m[2]; m[3];
cout << m.size();
```
- A) 0
- B) 3 ✅
- C) Undefined behavior
- D) Compilation error

> **Why:** `m[1]`, `m[2]`, `m[3]` each INSERT a key with value 0 (default). Map now has 3 entries.

---

**Q2. Can you iterate a `std::set` in reverse?**
```cpp
set<int> s = {1, 2, 3, 4, 5};
for (auto it = s.rbegin(); it != s.rend(); ++it)
    cout << *it << " ";
```
- A) No, set doesn't support rbegin
- B) Yes, prints `5 4 3 2 1` ✅
- C) Prints `1 2 3 4 5`
- D) Undefined behavior

---

**Q3. What is the output?**
```cpp
set<int> s = {5, 3, 1, 4, 2};
auto it = s.end();
--it;
cout << *it;
```
- A) 5 ✅
- B) 4
- C) 1
- D) Undefined

> **Why:** `s.end()` decremented gives the last element in sorted order = 5.

---

**Q4. What happens when you do `m.at("missing")` where "missing" is not in the map?**
```cpp
map<string,int> m;
m["hello"] = 1;
cout << m.at("missing");
```
- A) Returns 0
- B) Inserts "missing" with value 0
- C) Throws `std::out_of_range` ✅
- D) Undefined behavior

---

**Q5. After erasing an element from `std::set`, which iterators are invalidated?**
- A) All iterators
- B) Only iterators to the erased element ✅
- C) Iterators before the erased element
- D) Iterators after the erased element

---

**Q6. What is the output?**
```cpp
multiset<int> ms = {3, 1, 4, 1, 5, 9, 2, 6};
auto it = ms.lower_bound(4);
ms.erase(it);
cout << ms.count(4);
```
- A) 1
- B) 0 ✅
- C) 2
- D) Undefined behavior

> **Why:** `lower_bound(4)` points to the single `4`. After erase, `count(4)=0`.

---

**Q7. Which comparator violates Strict Weak Ordering?**
- A) `return a < b;`
- B) `return a <= b;` ✅
- C) `return abs(a) < abs(b);`
- D) `return a > b;`

> **Why:** `<=` is not a strict weak ordering because `a <= a` is `true` (irreflexivity violated).

---

**Q8. Why is `map::operator[]` NOT usable on a `const map`?**
- A) `operator[]` is not defined for maps
- B) `const` prevents all iterator usage
- C) `operator[]` may insert a new key if absent, which is impossible on `const` ✅
- D) Maps don't support `operator[]`

---

**Q9. What does `s.find(x) != s.end()` check?**
- A) Whether x is the last element
- B) Whether x exists in the set ✅
- C) Whether x can be inserted
- D) Whether x equals the end sentinel

---

**Q10. How do you get all elements strictly between 3 and 7 from a `set<int>`?**
- A) `lower_bound(3)` to `upper_bound(7)` — includes 3, includes 7
- B) `upper_bound(3)` to `lower_bound(7)` ✅ — excludes 3, excludes 7
- C) `lower_bound(3)` to `lower_bound(7)`
- D) `find(3)` to `find(7)`

---

**Q11. What is printed?**
```cpp
map<int,int> m = {{1,10},{2,20},{3,30}};
for (auto& [k,v] : m) v *= 2;
cout << m[2];
```
- A) 20
- B) 40 ✅
- C) 0
- D) Undefined

> **Why:** Structured binding with `auto&` gives mutable references. All values doubled. `m[2]` = 40.

---

**Q12. `set<string> s; s.insert("abc"); s.insert("ab"); s.insert("abcd");`  Which is first when iterating?**
- A) `"abc"`
- B) `"ab"` ✅
- C) `"abcd"`
- D) Order is undefined

> **Why:** `set<string>` uses lexicographic order. `"ab" < "abc" < "abcd"`.

---

> **Previous:** [02_STL_Sequence_Containers.md](02_STL_Sequence_Containers.md)  
> **Next:** [04_Unordered_Containers.md](04_Unordered_Containers.md)
