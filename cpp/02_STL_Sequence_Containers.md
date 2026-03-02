# 📘 Chapter 2: Sequence Containers — The Workhorses of STL

> **Master vector, deque, list, forward_list, and array — from internals to competitive programming.**

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. std::vector](#2-stdvector)
- [3. std::deque](#3-stddeque)
- [4. std::list](#4-stdlist)
- [5. std::forward_list](#5-stdforward_list)
- [6. std::array](#6-stdarray)
- [7. Container Comparison](#7-container-comparison)
- [8. Common Mistakes](#8-common-mistakes)
- [9. Interview Tips](#9-interview-tips)
- [10. Competitive Programming Tricks](#10-competitive-programming-tricks)
- [11. Edge Cases](#11-edge-cases)
- [12. Summary](#12-summary)
- [13. Practice Section](#13-practice-section)

---

## 1. Overview

Sequence containers store elements in a **linear sequence** where each element has a specific position determined by the order of insertion.

```
┌─────────────────────────────────────────────────────────────┐
│                    Sequence Containers                       │
├──────────┬──────────┬──────────┬──────────────┬─────────────┤
│  vector  │  deque   │   list   │ forward_list │    array    │
│          │          │          │              │             │
│ Dynamic  │ Double-  │ Doubly   │   Singly     │   Fixed     │
│ Array    │ ended    │ Linked   │   Linked     │   Size      │
│          │ Queue    │ List     │   List       │   Array     │
│          │          │          │              │             │
│ [][][]   │ [][][][  │ ↔ ↔ ↔ ↔ │  → → → →    │ [][][][][]  │
│          │  ][][]   │          │              │             │
└──────────┴──────────┴──────────┴──────────────┴─────────────┘
```

---

## 2. std::vector

### 2.1 Concept Explanation

`std::vector` is a **dynamic array** that automatically manages its memory. It stores elements in **contiguous memory**, just like a C array, but can grow and shrink dynamically.

It is the **most commonly used** STL container — your **default choice** unless you have a specific reason to use something else.

### 2.2 Internal Working

```
┌──────────────────────────────────────────────────────────────┐
│                    vector Internal Layout                     │
│                                                              │
│  Stack (vector object):                                      │
│  ┌──────────┬──────────┬──────────┐                         │
│  │  _begin  │   _end   │  _cap    │  (3 pointers, 24 bytes)│
│  │  (ptr)   │  (ptr)   │  (ptr)   │                         │
│  └────┬─────┴────┬─────┴────┬─────┘                         │
│       │          │          │                                │
│       ▼          ▼          ▼                                │
│  Heap: ┌───┬───┬───┬───┬───┬───┬───┬───┐                   │
│        │ 1 │ 2 │ 3 │ 4 │ 5 │   │   │   │                   │
│        └───┴───┴───┴───┴───┴───┴───┴───┘                   │
│        ↑               ↑               ↑                     │
│     _begin           _end           _cap                     │
│                                                              │
│  size()     = _end - _begin     = 5                         │
│  capacity() = _cap - _begin     = 8                         │
└──────────────────────────────────────────────────────────────┘
```

#### Growth Strategy

When `size() == capacity()` and you call `push_back()`:

1. Allocate new memory block of size `2 * capacity()` (GCC/Clang) or `1.5 * capacity()` (MSVC)
2. Copy/move all existing elements to new block
3. Deallocate old block
4. Insert new element

```
Before push_back(6):
┌───┬───┬───┬───┬───┐
│ 1 │ 2 │ 3 │ 4 │ 5 │  size=5, capacity=5
└───┴───┴───┴───┴───┘

After push_back(6):
┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
│ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │   │   │   │   │  size=6, capacity=10
└───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
```

#### Why Double the Capacity?

If we grew by 1 each time: n push_backs → O(1 + 2 + 3 + ... + n) = **O(n²)**

With doubling: n push_backs → O(n) total → **O(1) amortized** per push_back

Proof: The total number of copies is at most $1 + 2 + 4 + 8 + \ldots + n = 2n - 1 = O(n)$.

### 2.3 Time Complexity

| Operation                  | Complexity         | Notes                             |
| -------------------------- | ------------------ | --------------------------------- |
| `push_back()`              | **O(1)** amortized | O(n) on reallocation              |
| `pop_back()`               | **O(1)**           |                                   |
| `operator[]` / `at()`      | **O(1)**           | `at()` has bounds check           |
| `front()` / `back()`       | **O(1)**           |                                   |
| `insert(pos, val)`         | **O(n)**           | Shifts elements right             |
| `erase(pos)`               | **O(n)**           | Shifts elements left              |
| `insert(pos, first, last)` | **O(n + m)**       | m = range size                    |
| `find()` (std::find)       | **O(n)**           | Linear search                     |
| `size()` / `empty()`       | **O(1)**           |                                   |
| `reserve(n)`               | **O(n)**           | One-time allocation               |
| `resize(n)`                | **O(n)**           | May construct/destroy elements    |
| `clear()`                  | **O(n)**           | Destroys elements, keeps capacity |
| `shrink_to_fit()`          | **O(n)**           | Reallocates to fit size           |

### 2.4 Memory Behavior

```cpp
std::vector<int> v;
// sizeof(v) = 24 bytes (3 pointers on 64-bit)
// v.capacity() = 0 initially

v.push_back(1);  // Allocates (typically 1 element)
v.push_back(2);  // Doubles to 2
v.push_back(3);  // Doubles to 4
v.push_back(4);  // No reallocation
v.push_back(5);  // Doubles to 8

// Memory overhead: capacity - size elements are wasted
// Worst case: ~50% waste (right after doubling)
```

#### Memory Management Functions

```cpp
v.reserve(100);       // Pre-allocate for 100 elements (no construction)
v.resize(50);         // Change size to 50 (constructs/destroys elements)
v.shrink_to_fit();    // Request to reduce capacity to size (non-binding!)
v.clear();            // Remove all elements (capacity unchanged!)

// To truly free memory:
std::vector<int>().swap(v);  // Swap with empty vector
// Or in C++11:
v = std::vector<int>();
v.shrink_to_fit();
```

### 2.5 Syntax & All Important Functions

```cpp
#include <vector>

// ─────────────────────────── Construction ───────────────────────────
std::vector<int> v1;                    // Empty vector
std::vector<int> v2(10);               // 10 elements, value-initialized (0)
std::vector<int> v3(10, 42);           // 10 elements, each = 42
std::vector<int> v4 = {1, 2, 3, 4};   // Initializer list
std::vector<int> v5(v4);              // Copy constructor
std::vector<int> v6(std::move(v4));   // Move constructor (v4 is now empty)
std::vector<int> v7(v5.begin(), v5.end()); // Range constructor

// 2D vector
std::vector<std::vector<int>> grid(n, std::vector<int>(m, 0));

// ─────────────────────────── Element Access ─────────────────────────
v[0];              // No bounds check (fastest)
v.at(0);           // Bounds check, throws std::out_of_range
v.front();         // First element (UB if empty)
v.back();          // Last element (UB if empty)
v.data();          // Returns raw pointer to underlying array

// ─────────────────────────── Capacity ───────────────────────────────
v.size();          // Number of elements
v.capacity();      // Allocated storage
v.empty();         // Returns true if size() == 0
v.max_size();      // Maximum possible size
v.reserve(n);      // Reserve capacity for n elements
v.shrink_to_fit(); // Reduce capacity to fit size

// ─────────────────────────── Modifiers ──────────────────────────────
v.push_back(42);         // Add element to end
v.emplace_back(42);      // Construct element in-place at end (faster!)
v.pop_back();            // Remove last element
v.insert(it, val);       // Insert before iterator position
v.insert(it, n, val);    // Insert n copies of val
v.insert(it, first, last); // Insert range
v.emplace(it, args...);  // Construct in-place before iterator
v.erase(it);             // Erase at position
v.erase(first, last);    // Erase range [first, last)
v.clear();               // Remove all elements
v.resize(n);             // Resize to n elements
v.resize(n, val);        // Resize, fill new elements with val
v.swap(other);           // Swap contents with other vector
v.assign(n, val);        // Replace contents with n copies of val
v.assign(first, last);   // Replace contents with range
v.assign({1,2,3});       // Replace contents with initializer list
```

### 2.6 Code Examples

#### Example 1: Basic Operations

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

int main() {
    std::vector<int> v = {5, 2, 8, 1, 9, 3};
    
    // Sort ascending
    std::sort(v.begin(), v.end());
    // v = {1, 2, 3, 5, 8, 9}
    
    // Binary search (requires sorted vector)
    bool found = std::binary_search(v.begin(), v.end(), 5);  // true
    
    // Lower bound: first element >= 4
    auto it = std::lower_bound(v.begin(), v.end(), 4);
    std::cout << *it << "\n";  // 5
    
    // Remove duplicates from sorted vector
    v.push_back(5);
    v.push_back(5);
    std::sort(v.begin(), v.end());
    v.erase(std::unique(v.begin(), v.end()), v.end());
    
    return 0;
}
```

#### Example 2: 2D Vector Operations

```cpp
#include <iostream>
#include <vector>

int main() {
    int n = 4, m = 5;
    
    // Create n x m grid initialized to 0
    std::vector<std::vector<int>> grid(n, std::vector<int>(m, 0));
    
    // Fill diagonal
    for (int i = 0; i < std::min(n, m); i++) {
        grid[i][i] = 1;
    }
    
    // Print grid
    for (const auto& row : grid) {
        for (int val : row) {
            std::cout << val << " ";
        }
        std::cout << "\n";
    }
    
    // Jagged array (rows of different sizes)
    std::vector<std::vector<int>> jagged;
    jagged.push_back({1, 2, 3});
    jagged.push_back({4, 5});
    jagged.push_back({6, 7, 8, 9});
    
    return 0;
}
```

#### Example 3: emplace_back vs push_back

```cpp
#include <iostream>
#include <vector>
#include <string>

struct Person {
    std::string name;
    int age;
    Person(std::string n, int a) : name(std::move(n)), age(a) {
        std::cout << "Constructed: " << name << "\n";
    }
    Person(const Person& p) : name(p.name), age(p.age) {
        std::cout << "Copied: " << name << "\n";
    }
    Person(Person&& p) noexcept : name(std::move(p.name)), age(p.age) {
        std::cout << "Moved: " << name << "\n";
    }
};

int main() {
    std::vector<Person> people;
    people.reserve(3);  // Prevent reallocation
    
    // push_back: Creates temporary, then moves/copies it
    std::cout << "=== push_back ===\n";
    people.push_back(Person("Alice", 30));
    // Output: Constructed: Alice
    //         Moved: Alice
    
    // emplace_back: Constructs directly in the vector's memory
    std::cout << "=== emplace_back ===\n";
    people.emplace_back("Bob", 25);
    // Output: Constructed: Bob
    // (No copy or move!)
    
    return 0;
}
```

### 2.7 When to Use

✅ **Use vector when:**
- You need a dynamic array (99% of the time)
- Random access by index is needed
- You iterate sequentially (cache-friendly)
- You mostly add/remove at the end
- You need contiguous memory (for C API interop)

### 2.8 When NOT to Use

❌ **Don't use vector when:**
- Frequent insertions/deletions at the front → use `deque`
- Frequent insertions/deletions in the middle → use `list`
- Fixed size known at compile time → use `array`
- Need O(log n) lookup → use `set` / `map`
- Need O(1) lookup → use `unordered_set` / `unordered_map`
- Iterator stability after insert/erase is critical → use `list`

### 2.9 Hidden Behaviors & Tricks

```cpp
// ⚠️ vector<bool> is SPECIAL — it's a bitset, NOT a real vector!
std::vector<bool> vb = {true, false, true};
// Each element uses 1 bit, not 1 byte
// Cannot take address: &vb[0] — INVALID!
// Use std::vector<char> or std::bitset instead if you need normal behavior

// Trick: Fast removal when order doesn't matter (O(1) instead of O(n))
void fast_erase(std::vector<int>& v, int index) {
    std::swap(v[index], v.back());
    v.pop_back();
}

// Trick: Reserve for known sizes
std::vector<int> v;
v.reserve(n);  // Prevents O(log n) reallocations
for (int i = 0; i < n; i++) v.push_back(i);

// Trick: Use assign for mass initialization
v.assign(100, -1);  // Fill with 100 copies of -1
```

---

## 3. std::deque

### 3.1 Concept Explanation

`std::deque` (Double-Ended Queue) supports **O(1) insertion and removal at both ends**. Unlike `vector`, it is NOT stored in a single contiguous memory block.

### 3.2 Internal Working

```
┌─────────────────────────────────────────────────────────────────┐
│                     deque Internal Layout                        │
│                                                                  │
│  Map (array of pointers to fixed-size blocks):                  │
│  ┌──────┬──────┬──────┬──────┬──────┬──────┐                   │
│  │ ptr1 │ ptr2 │ ptr3 │ ptr4 │ ptr5 │ ptr6 │                   │
│  └──┬───┴──┬───┴──┬───┴──┬───┴──┬───┴──┬───┘                   │
│     │      │      │      │      │      │                        │
│     ▼      ▼      ▼      ▼      ▼      ▼                        │
│  ┌─────┐┌─────┐┌─────┐┌─────┐┌─────┐┌─────┐                   │
│  │ ... ││ A B ││ C D ││ E F ││ G H ││ ... │  Fixed-size blocks │
│  │     ││     ││     ││     ││     ││     │  (typically 512B)  │
│  └─────┘└─────┘└─────┘└─────┘└─────┘└─────┘                   │
│                                                                  │
│  Random access: map[i / BLOCK_SIZE][i % BLOCK_SIZE]             │
│  Still O(1), but with higher constant than vector               │
└─────────────────────────────────────────────────────────────────┘
```

**Key implementation details:**
- Elements are stored in **fixed-size blocks** (chunks), typically 512 bytes
- A central **map** (array of pointers) tracks all blocks
- Front/back insertion: allocate a new block if needed, O(1)
- No full reallocation on growth (unlike vector)
- Random access: Two pointer dereferences → O(1) but slower constant factor than vector

### 3.3 Time Complexity

| Operation             | Complexity | Notes                       |
| --------------------- | ---------- | --------------------------- |
| `push_back()`         | **O(1)**   | Always O(1), not amortized  |
| `push_front()`        | **O(1)**   | Advantage over vector       |
| `pop_back()`          | **O(1)**   |                             |
| `pop_front()`         | **O(1)**   | Advantage over vector       |
| `operator[]` / `at()` | **O(1)**   | Slightly slower than vector |
| `insert(pos, val)`    | **O(n)**   | Shifts elements             |
| `erase(pos)`          | **O(n)**   | Shifts elements             |
| `size()`              | **O(1)**   |                             |
| `clear()`             | **O(n)**   | Destroys elements           |

### 3.4 Memory Behavior

- **No contiguous memory guarantee** — `data()` is NOT available
- **Less wasteful** than vector for large sizes — only allocates in chunks
- Each chunk is fixed-size (implementation-defined, often 512 bytes)
- Front expansion: allocates new chunk, no element copying
- Back expansion: allocates new chunk, no element copying

### 3.5 Syntax & All Important Functions

```cpp
#include <deque>

// ─────────────────────────── Construction ───────────────────────────
std::deque<int> d1;                    // Empty
std::deque<int> d2(10);               // 10 value-initialized elements
std::deque<int> d3(10, 42);           // 10 copies of 42
std::deque<int> d4 = {1, 2, 3, 4};   // Initializer list
std::deque<int> d5(d4);              // Copy
std::deque<int> d6(d4.begin(), d4.end()); // Range

// ─────────────────────────── Element Access ─────────────────────────
d[0];              // No bounds check
d.at(0);           // With bounds check
d.front();         // First element
d.back();          // Last element

// ─────────────────────────── Modifiers ──────────────────────────────
d.push_back(42);         // Add to back
d.push_front(10);        // Add to front (UNIQUE to deque vs vector)
d.emplace_back(42);      // Construct at back
d.emplace_front(10);     // Construct at front
d.pop_back();            // Remove from back
d.pop_front();           // Remove from front (UNIQUE to deque vs vector)
d.insert(it, val);       // Insert before position
d.erase(it);             // Erase at position
d.erase(first, last);    // Erase range
d.clear();               // Remove all
d.resize(n);             // Resize
d.swap(other);           // Swap
```

### 3.6 Code Examples

```cpp
#include <iostream>
#include <deque>

int main() {
    std::deque<int> dq;
    
    // Efficient front and back operations
    dq.push_back(3);    // [3]
    dq.push_front(1);   // [1, 3]
    dq.push_back(4);    // [1, 3, 4]
    dq.push_front(0);   // [0, 1, 3, 4]
    
    // Random access
    std::cout << dq[2] << "\n";  // 3
    
    // Use as sliding window
    int window_size = 3;
    std::deque<int> window;
    std::vector<int> data = {1, 3, -1, -3, 5, 3, 6, 7};
    
    for (int i = 0; i < data.size(); i++) {
        window.push_back(data[i]);
        if (window.size() > window_size) {
            window.pop_front();
        }
        if (window.size() == window_size) {
            // Process current window
            std::cout << "Window: ";
            for (int x : window) std::cout << x << " ";
            std::cout << "\n";
        }
    }
    
    return 0;
}
```

### 3.7 When to Use

✅ **Use deque when:**
- You need O(1) insertion at **both** front and back
- Used as underlying container for `stack` and `queue` (default)
- Sliding window problems with index-based access

### 3.8 When NOT to Use

❌ **Don't use deque when:**
- You need contiguous memory / `data()` pointer
- Cache performance is critical (vector is better)
- You only add/remove at one end (vector is simpler)

### 3.9 deque vs vector

| Feature               | vector         | deque              |
| --------------------- | -------------- | ------------------ |
| Memory                | Contiguous     | Chunked            |
| `push_front`          | O(n)           | **O(1)**           |
| `push_back`           | O(1) amortized | **O(1)**           |
| `data()`              | ✅ Available    | ❌ Not available    |
| Cache friendliness    | ✅✅✅            | ✅✅                 |
| Iterator invalidation | All on realloc | More complex rules |
| Memory overhead       | Lower          | Higher             |
| Random access speed   | Faster         | Slightly slower    |

---

## 4. std::list

### 4.1 Concept Explanation

`std::list` is a **doubly-linked list**. Each element (node) stores pointers to the previous and next elements. It allows O(1) insertion and deletion **anywhere** (given an iterator).

### 4.2 Internal Working

```
┌──────────────────────────────────────────────────────────────────┐
│                    list Internal Layout                           │
│                                                                   │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐   │
│  │   Node   │    │   Node   │    │   Node   │    │   Node   │   │
│  │  ┌─────┐ │    │  ┌─────┐ │    │  ┌─────┐ │    │  ┌─────┐ │   │
│  │  │prev ├─┼──┐ │  │prev ├─┼──┐ │  │prev ├─┼──┐ │  │prev ├─┼── │
│  │  ├─────┤ │  │ │  ├─────┤ │  │ │  ├─────┤ │  │ │  ├─────┤ │   │
│  │  │data │ │  │ │  │data │ │  │ │  │data │ │  │ │  │data │ │   │
│  │  │ =10 │ │  │ │  │ =20 │ │  │ │  │ =30 │ │  │ │  │ =40 │ │   │
│  │  ├─────┤ │  │ │  ├─────┤ │  │ │  ├─────┤ │  │ │  ├─────┤ │   │
│  │  │next ├─┼──┘ │  │next ├─┼──┘ │  │next ├─┼──┘ │  │next ├─┼── │
│  │  └─────┘ │    │  └─────┘ │    │  └─────┘ │    │  └─────┘ │   │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘   │
│      head                                             tail       │
│                                                                   │
│  Each node: sizeof(T) + 2 * sizeof(pointer) = T + 16 bytes      │
│  Memory overhead: 16 bytes per element (64-bit system)            │
└──────────────────────────────────────────────────────────────────┘
```

### 4.3 Time Complexity

| Operation         | Complexity     | Notes                         |
| ----------------- | -------------- | ----------------------------- |
| `push_back()`     | **O(1)**       |                               |
| `push_front()`    | **O(1)**       |                               |
| `pop_back()`      | **O(1)**       |                               |
| `pop_front()`     | **O(1)**       |                               |
| Access by index   | **O(n)**       | Must traverse                 |
| `insert(it, val)` | **O(1)**       | Given iterator                |
| `erase(it)`       | **O(1)**       | Given iterator                |
| `splice()`        | **O(1)**       | Move elements between lists   |
| `sort()`          | **O(n log n)** | Merge sort                    |
| `merge()`         | **O(n)**       | Merge two sorted lists        |
| `unique()`        | **O(n)**       | Remove consecutive duplicates |
| `remove(val)`     | **O(n)**       | Remove all occurrences        |
| `reverse()`       | **O(n)**       | Reverse the list              |
| `size()`          | **O(1)**       | Since C++11                   |

### 4.4 Memory Behavior

- **Very high memory overhead**: 16 bytes (two pointers) per element on 64-bit systems
- **No contiguous memory**: Terrible cache performance
- **Stable iterators**: Iterators, pointers, and references are NEVER invalidated (except for erased elements)
- Each `push_back`/`push_front` allocates a new node from the heap

### 4.5 Syntax & All Important Functions

```cpp
#include <list>

// ─────────────────────────── Construction ───────────────────────────
std::list<int> l1;                     // Empty
std::list<int> l2(10, 42);           // 10 copies of 42
std::list<int> l3 = {1, 2, 3, 4};   // Initializer list
std::list<int> l4(l3);              // Copy

// ─────────────────────────── Element Access ─────────────────────────
l.front();         // First element
l.back();          // Last element
// NO operator[] ! NO at() ! (No random access)

// ─────────────────────────── Modifiers ──────────────────────────────
l.push_back(42);         // Add to back
l.push_front(10);        // Add to front
l.emplace_back(42);      // Construct at back
l.emplace_front(10);     // Construct at front
l.pop_back();            // Remove from back
l.pop_front();           // Remove from front
l.insert(it, val);       // Insert before iterator O(1)
l.erase(it);             // Erase at iterator O(1)
l.clear();               // Remove all

// ─────────────────────────── List-specific Operations ───────────────
l.sort();                                // Merge sort: O(n log n)
l.sort(comp);                           // Sort with custom comparator
l.reverse();                             // Reverse list: O(n)
l.unique();                              // Remove consecutive duplicates: O(n)
l.unique(pred);                         // Remove with custom predicate
l.remove(val);                          // Remove all elements == val: O(n)
l.remove_if(pred);                      // Remove elements matching predicate
l.merge(other);                         // Merge sorted list into this: O(n)
l.merge(other, comp);                   // Merge with comparator
l.splice(pos, other);                   // Move ALL elements from other: O(1)
l.splice(pos, other, it);              // Move ONE element: O(1)
l.splice(pos, other, first, last);     // Move range: O(1) or O(n)
```

### 4.6 Code Examples

#### Splice: The Killer Feature

```cpp
#include <iostream>
#include <list>

int main() {
    std::list<int> l1 = {1, 2, 3};
    std::list<int> l2 = {10, 20, 30};
    
    // Move all elements from l2 into l1 at position after 1
    auto it = l1.begin();
    ++it;  // Points to 2
    
    l1.splice(it, l2);
    // l1 = {1, 10, 20, 30, 2, 3}
    // l2 = {} (empty now!)
    
    // This is O(1)! No copying, no allocation.
    // Just pointer manipulation.
    
    // Splice single element
    std::list<int> l3 = {100, 200, 300};
    auto elem = l3.begin();
    ++elem;  // Points to 200
    
    l1.splice(l1.begin(), l3, elem);
    // l1 = {200, 1, 10, 20, 30, 2, 3}
    // l3 = {100, 300}
    
    return 0;
}
```

### 4.7 When to Use

✅ **Use list when:**
- Frequent insertions/deletions at arbitrary positions (with iterator)
- Iterator/pointer/reference stability is critical
- You need `splice()` to move elements between lists in O(1)
- Large objects where move/copy is expensive

### 4.8 When NOT to Use

❌ **Don't use list when:**
- You need random access
- Cache performance matters (almost always)
- You're doing more reading than inserting/deleting
- Memory overhead per element is a concern

> **Reality check:** In practice, `std::vector` is almost always faster than `std::list` even for middle insertions, due to cache effects. Profile before choosing list!

---

## 5. std::forward_list

### 5.1 Concept Explanation

`std::forward_list` is a **singly-linked list**. Each node has only a `next` pointer (no `prev`). Introduced in C++11 as a minimal-overhead linked list.

### 5.2 Internal Working

```
┌─────────────────────────────────────────────────────────┐
│              forward_list Internal Layout                 │
│                                                          │
│  ┌────────┐    ┌────────┐    ┌────────┐    ┌────────┐  │
│  │  data  │    │  data  │    │  data  │    │  data  │  │
│  │  =10   │    │  =20   │    │  =30   │    │  =40   │  │
│  ├────────┤    ├────────┤    ├────────┤    ├────────┤  │
│  │  next ─┼───►│  next ─┼───►│  next ─┼───►│next=null│ │
│  └────────┘    └────────┘    └────────┘    └────────┘  │
│    head                                                  │
│                                                          │
│  Each node: sizeof(T) + sizeof(pointer) = T + 8 bytes   │
│  (Half the overhead of std::list!)                       │
└─────────────────────────────────────────────────────────┘
```

### 5.3 Time Complexity

| Operation          | Complexity     | Notes                     |
| ------------------ | -------------- | ------------------------- |
| `push_front()`     | **O(1)**       |                           |
| `pop_front()`      | **O(1)**       |                           |
| `insert_after(it)` | **O(1)**       |                           |
| `erase_after(it)`  | **O(1)**       |                           |
| Access by index    | **O(n)**       | Must traverse             |
| `sort()`           | **O(n log n)** |                           |
| `merge()`          | **O(n)**       |                           |
| `size()`           | **O(n)**       | NOT O(1)! No size stored! |

### 5.4 Key Differences from std::list

| Feature          | list          | forward_list            |
| ---------------- | ------------- | ----------------------- |
| Direction        | Bidirectional | Forward only            |
| Memory per node  | +16 bytes     | +8 bytes                |
| `push_back()`    | ✅ O(1)        | ❌ Not available         |
| `back()`         | ✅ O(1)        | ❌ Not available         |
| `size()`         | O(1)          | **O(n)**                |
| `insert`         | `insert(pos)` | `insert_after(pos)`     |
| `erase`          | `erase(pos)`  | `erase_after(pos)`      |
| `before_begin()` | ❌             | ✅ (for insert at front) |
| `--it`           | ✅             | ❌                       |

### 5.5 Syntax

```cpp
#include <forward_list>

std::forward_list<int> fl = {1, 2, 3, 4, 5};

// Access
fl.front();            // First element

// Modifiers (all relative to "after" position)
fl.push_front(0);              // Add to front
fl.emplace_front(0);           // Construct at front
fl.pop_front();                // Remove first
fl.insert_after(it, val);      // Insert AFTER iterator
fl.emplace_after(it, args);    // Construct AFTER iterator
fl.erase_after(it);            // Erase element AFTER iterator
fl.erase_after(first, last);   // Erase range (first, last)

// Special: before_begin()
// Returns iterator BEFORE the first element
fl.insert_after(fl.before_begin(), 99);  // Insert at front

// Operations
fl.sort();
fl.unique();
fl.merge(other);
fl.reverse();
fl.remove(val);
fl.remove_if(pred);
fl.splice_after(pos, other);
```

### 5.6 When to Use

✅ **Use forward_list when:**
- You need a linked list but want minimum memory overhead
- You only traverse forward
- You need `splice_after` operations
- Embedded systems where memory is critical

### 5.7 When NOT to Use

❌ Almost always prefer `vector` or `list` instead. `forward_list` is for very specialized use cases.

---

## 6. std::array

### 6.1 Concept Explanation

`std::array` is a **fixed-size container** that wraps a C-style array. Size is determined at **compile time**. Introduced in C++11.

### 6.2 Internal Working

```
┌────────────────────────────────────────────────────┐
│              array<int, 5> Internal Layout           │
│                                                      │
│  ┌─────┬─────┬─────┬─────┬─────┐                   │
│  │  1  │  2  │  3  │  4  │  5  │  (Stack allocated) │
│  └─────┴─────┴─────┴─────┴─────┘                   │
│                                                      │
│  sizeof(array<int, 5>) = 5 * sizeof(int) = 20 bytes │
│  NO heap allocation                                  │
│  NO size/capacity overhead                           │
│  ZERO overhead over raw C array                      │
└────────────────────────────────────────────────────┘
```

### 6.3 Time Complexity

| Operation             | Complexity                       |
| --------------------- | -------------------------------- |
| `operator[]` / `at()` | **O(1)**                         |
| `front()` / `back()`  | **O(1)**                         |
| `fill(val)`           | **O(n)**                         |
| `swap()`              | **O(n)**                         |
| `size()`              | **O(1)** (compile-time constant) |

### 6.4 Syntax & All Functions

```cpp
#include <array>

// ─────────────────────────── Construction ───────────────────────────
std::array<int, 5> a1;                    // Uninitialized (on stack)!
std::array<int, 5> a2 = {};              // Zero-initialized
std::array<int, 5> a3 = {1, 2, 3, 4, 5}; // Initialized
std::array<int, 5> a4 = {1, 2};          // {1, 2, 0, 0, 0}

// C++17 deduction guide
std::array a5 = {1, 2, 3, 4, 5};  // Deduces array<int, 5>

// ─────────────────────────── Element Access ─────────────────────────
a[0];              // No bounds check
a.at(0);           // With bounds check
a.front();         // First element
a.back();          // Last element
a.data();          // Raw pointer to underlying array

// ─────────────────────────── Capacity ───────────────────────────────
a.size();          // Number of elements (compile-time constant)
a.max_size();      // Same as size()
a.empty();         // Whether size() == 0

// ─────────────────────────── Operations ─────────────────────────────
a.fill(42);        // Set all elements to 42
a.swap(other);     // Swap with another array (O(n))

// ─────────────────────────── Iterators ──────────────────────────────
a.begin();  a.end();
a.cbegin(); a.cend();
a.rbegin(); a.rend();
```

### 6.5 Code Example

```cpp
#include <iostream>
#include <array>
#include <algorithm>

int main() {
    std::array<int, 5> a = {5, 2, 8, 1, 9};
    
    // Works with all STL algorithms
    std::sort(a.begin(), a.end());
    // a = {1, 2, 5, 8, 9}
    
    // Find
    auto it = std::find(a.begin(), a.end(), 5);
    if (it != a.end()) {
        std::cout << "Found at index: " << std::distance(a.begin(), it) << "\n";
    }
    
    // Can be used as function parameter with size
    auto print = [](const std::array<int, 5>& arr) {
        for (int x : arr) std::cout << x << " ";
        std::cout << "\n";
    };
    print(a);
    
    // Comparison (lexicographic)
    std::array<int, 3> b1 = {1, 2, 3};
    std::array<int, 3> b2 = {1, 2, 4};
    std::cout << (b1 < b2) << "\n";  // true
    
    return 0;
}
```

### 6.6 When to Use

✅ **Use array when:**
- Size is known at compile time
- You want all benefits of STL (iterators, algorithms) with zero overhead
- Stack allocation is preferred
- Replacing C-style arrays with safer alternative

### 6.7 When NOT to Use

❌ **Don't use array when:**
- Size is determined at runtime → use `vector`
- You need dynamic resizing → use `vector`
- Very large arrays that may overflow the stack → use `vector` (heap)

### 6.8 array vs C-style Array vs vector

| Feature        | C-style array     | std::array      | std::vector         |
| -------------- | ----------------- | --------------- | ------------------- |
| Size           | Fixed (compile)   | Fixed (compile) | Dynamic             |
| Memory         | Stack             | Stack           | Heap                |
| Bounds check   | ❌                 | ✅ `at()`        | ✅ `at()`            |
| Size known     | ❌                 | ✅ `.size()`     | ✅ `.size()`         |
| Copy/assign    | ❌                 | ✅               | ✅                   |
| Pass by value  | Decays to pointer | ✅ Full copy     | ✅ Full copy         |
| STL compatible | Partially         | ✅ Fully         | ✅ Fully             |
| Overhead       | 0                 | 0               | 24 bytes + capacity |

---

## 7. Container Comparison

### Performance Comparison (Relative)

```
Operation Speed Comparison (lower is faster):

Random Access:    vector ████░░░░░░  deque ██████░░░░  list ██████████  array ████░░░░░░
Sequential Read:  vector ███░░░░░░░  deque █████░░░░░  list █████████░  array ███░░░░░░░
Push Back:        vector ████░░░░░░  deque ████░░░░░░  list ██████░░░░  array N/A
Push Front:       vector ██████████  deque ████░░░░░░  list ████░░░░░░  array N/A
Insert Middle:    vector ████████░░  deque ████████░░  list ██░░░░░░░░  array N/A
Memory Usage:     vector ███░░░░░░░  deque █████░░░░░  list █████████░  array ██░░░░░░░░
```

### Decision Flowchart

```
Need a sequence container?
│
├─ Fixed size at compile time?
│  └─ YES → std::array
│
├─ Need random access?
│  ├─ YES
│  │  ├─ Need efficient front operations?
│  │  │  ├─ YES → std::deque
│  │  │  └─ NO → std::vector ⭐ (default choice)
│  │  │
│  └─ NO
│     ├─ Need bidirectional traversal?
│     │  ├─ YES → std::list
│     │  └─ NO → std::forward_list
│     │
│     └─ Need O(1) splice?
│        └─ YES → std::list
```

---

## 8. Common Mistakes

### Mistake 1: Not Reserving Vector Capacity

```cpp
// ❌ SLOW: Many reallocations
std::vector<int> v;
for (int i = 0; i < 1000000; i++) {
    v.push_back(i);  // ~20 reallocations!
}

// ✅ FAST: One allocation
std::vector<int> v;
v.reserve(1000000);
for (int i = 0; i < 1000000; i++) {
    v.push_back(i);
}
```

### Mistake 2: Using list for "Fast Middle Insertion"

```cpp
// "I'll use list because insert is O(1)!"
// But FINDING the position is O(n)...
std::list<int> l = {1, 2, 3, ..., 1000000};
auto it = l.begin();
std::advance(it, 500000);  // O(n) to find position!
l.insert(it, 42);          // O(1) to insert

// vector is actually faster due to cache effects!
// vector's O(n) insert with cache = list's O(n) traverse without cache
```

### Mistake 3: Assuming vector<bool> Works Like vector<T>

```cpp
std::vector<bool> vb = {true, false, true};
bool* ptr = &vb[0];  // ❌ COMPILE ERROR!
// vector<bool> is a bitset, not a real vector

// ✅ Use vector<char> or bitset instead
std::vector<char> vc = {1, 0, 1};
char* ptr = &vc[0];  // ✅ Works
```

### Mistake 4: Iterator Invalidation

```cpp
// Vector: push_back can invalidate ALL iterators
std::vector<int> v = {1, 2, 3};
auto it = v.begin();
v.push_back(4);  // If reallocation occurs, it is INVALID!
// *it; // UNDEFINED BEHAVIOR

// List: Only erased element's iterator is invalidated
std::list<int> l = {1, 2, 3};
auto it = l.begin();
auto next = std::next(it);
l.erase(it);  // Only it is invalidated
// *next; // ✅ Still valid!
```

### Mistake 5: Forgetting deque Iterator Invalidation

```cpp
std::deque<int> d = {1, 2, 3, 4, 5};
auto it = d.begin() + 2;  // Points to 3

d.push_back(6);   // ❌ Invalidates ALL iterators!
d.push_front(0);  // ❌ Invalidates ALL iterators!
// (But pointers and references to elements remain valid)

// Only pointers/references are safe after push_back/push_front
int& ref = d[2];
d.push_back(7);
// ref is still valid!
```

---

## 9. Interview Tips

### Top Interview Questions

**Q1: Why is vector's push_back amortized O(1)?**
> Because the vector doubles its capacity when full. The cost of copying n elements happens every n insertions, so the average cost per insertion is O(1). Mathematically, total copies = $1 + 2 + 4 + \ldots + n \leq 2n$, giving O(1) amortized.

**Q2: When is deque better than vector?**
> When you need O(1) operations at both front and back. Common use: BFS (queue), sliding window, undo/redo.

**Q3: Is std::list ever faster than std::vector?**
> Rarely in practice. Only when you have **many** inserts/deletes with **already-known iterator positions** and the elements are **large** (so copying is expensive). Due to cache effects, vector almost always wins.

**Q4: What's the memory overhead of std::list vs std::vector?**
> List: 16 bytes per element (prev + next pointers) + allocation overhead per node. Vector: 24 bytes total (3 pointers) + up to 50% unused capacity.

**Q5: Can you use std::sort on std::list?**
> No! `std::sort` requires random access iterators. Use `list::sort()` which implements merge sort.

---

## 10. Competitive Programming Tricks

### Trick 1: Fast Input into Vector

```cpp
int n;
scanf("%d", &n);
vector<int> a(n);
for (auto& x : a) scanf("%d", &x);
```

### Trick 2: Coordinate Compression with Vector

```cpp
vector<int> a = {100, 1, 50, 1, 100};
vector<int> sorted_a = a;
sort(sorted_a.begin(), sorted_a.end());
sorted_a.erase(unique(sorted_a.begin(), sorted_a.end()), sorted_a.end());

for (auto& x : a) {
    x = lower_bound(sorted_a.begin(), sorted_a.end(), x) - sorted_a.begin();
}
// a = {2, 0, 1, 0, 2}
```

### Trick 3: Vector as Stack

```cpp
vector<int> stk;       // Instead of stack<int>
stk.push_back(x);     // push
stk.pop_back();       // pop
stk.back();           // top
stk.empty();          // empty

// Advantages over stack<int>:
// - Can iterate
// - Can access any element
// - Can clear
```

### Trick 4: Preallocate 2D DP Table

```cpp
int n = 1000;
vector<vector<int>> dp(n + 1, vector<int>(n + 1, 0));
// Much cleaner than int dp[1001][1001] and handles large sizes
```

### Trick 5: Deque for Sliding Window Maximum

```cpp
// O(n) sliding window maximum using monotonic deque
vector<int> sliding_window_max(vector<int>& arr, int k) {
    deque<int> dq;  // Stores indices
    vector<int> result;
    
    for (int i = 0; i < arr.size(); i++) {
        // Remove elements outside window
        while (!dq.empty() && dq.front() <= i - k) {
            dq.pop_front();
        }
        // Remove smaller elements (maintain decreasing order)
        while (!dq.empty() && arr[dq.back()] <= arr[i]) {
            dq.pop_back();
        }
        dq.push_back(i);
        
        if (i >= k - 1) {
            result.push_back(arr[dq.front()]);
        }
    }
    return result;
}
```

### Trick 6: Swap to Free Memory

```cpp
vector<int> v(1000000);
// ... use v ...

// Wrong: clear() keeps capacity
v.clear();  // size=0, capacity=1000000 (memory NOT freed)

// Right: swap trick
vector<int>().swap(v);  // size=0, capacity=0 (memory freed)
```

---

## 11. Edge Cases

### Empty Vector Pitfalls

```cpp
vector<int> v;

// ❌ UB: Accessing elements of empty vector
v.front();     // UB
v.back();      // UB
v[0];          // UB
v.pop_back();  // UB

// ⚠️ size() - 1 underflow
for (int i = 0; i < v.size() - 1; i++) { }  // Infinite loop! (unsigned underflow)

// ✅ Safe version
for (int i = 0; i + 1 < (int)v.size(); i++) { }
```

### Large Vector on Stack

```cpp
// ❌ Stack overflow
// std::array<int, 10000000> huge;  // 40MB on stack! CRASH!

// ✅ Use vector (heap allocated)
std::vector<int> huge(10000000);  // 40MB on heap, OK
```

### Self-Assignment

```cpp
std::vector<int> v = {1, 2, 3};
v = v;  // ✅ Safe (STL handles self-assignment)
```

---

## 12. Summary

```
┌────────────────────────────────────────────────────────────────┐
│              SEQUENCE CONTAINERS CHEAT SHEET                    │
├────────────┬───────────────────────────────────────────────────┤
│ vector     │ Dynamic array. Default choice. Contiguous.        │
│            │ O(1) push_back, O(1) random access.              │
├────────────┼───────────────────────────────────────────────────┤
│ deque      │ Double-ended. O(1) push_front + push_back.       │
│            │ Chunked memory. Used for queue/stack.             │
├────────────┼───────────────────────────────────────────────────┤
│ list       │ Doubly-linked. O(1) insert/erase with iterator.  │
│            │ O(1) splice. High memory overhead. Bad cache.     │
├────────────┼───────────────────────────────────────────────────┤
│ forward_   │ Singly-linked. Half memory of list.              │
│ list       │ Forward only. Specialized use.                    │
├────────────┼───────────────────────────────────────────────────┤
│ array      │ Fixed size (compile time). Zero overhead.         │
│            │ Stack allocated. Drop-in for C arrays.            │
└────────────┴───────────────────────────────────────────────────┘

GOLDEN RULE: When in doubt, use std::vector.
```

---

## 13. Practice Section

### Level 1 — Quick Concept Questions

1. **Q: What is the default capacity of `std::vector` when created empty?**
   <details><summary>Answer</summary>0 — no memory is allocated until the first element is added.</details>

2. **Q: Can `std::deque` provide a `data()` pointer?**
   <details><summary>Answer</summary>No, because deque's memory is not contiguous.</details>

3. **Q: What is the memory overhead per element in `std::list`?**
   <details><summary>Answer</summary>16 bytes on 64-bit systems (two pointers: prev and next).</details>

4. **Q: Does `std::forward_list` have a `size()` function that runs in O(1)?**
   <details><summary>Answer</summary>No, `size()` was intentionally not O(1) — it runs in O(n) by traversing. By C++ standard, if a forward_list provides `size()`, it must be O(n).</details>

5. **Q: What is `std::array`'s advantage over a C-style array?**
   <details><summary>Answer</summary>Knows its size, supports copy/assignment, works with STL algorithms, provides bounds-checked access via `at()`.</details>

6. **Q: What happens when you `push_back` on a full vector?**
   <details><summary>Answer</summary>The vector allocates a new block (typically double the current capacity), copies/moves all elements, frees the old block, then inserts the new element.</details>

7. **Q: Which sequence container has stable iterators?**
   <details><summary>Answer</summary>`std::list` and `std::forward_list` — iterators are never invalidated except for erased elements.</details>

8. **Q: Can you sort a `std::list` with `std::sort`?**
   <details><summary>Answer</summary>No, because `std::sort` requires Random Access iterators. Use `list::sort()` instead.</details>

9. **Q: What is the `splice` operation?**
   <details><summary>Answer</summary>Moving elements from one list to another in O(1) by relinking pointers, without copying.</details>

10. **Q: Is `std::vector<bool>` a normal vector?**
    <details><summary>Answer</summary>No. It's a space-optimized specialization that stores bools as individual bits. It does not behave like a normal vector (no `data()`, no `bool&` references).</details>

---

### Level 2 — MCQs

**1. What is the time complexity of `vector::insert` at the beginning?**
- A) O(1)
- B) O(log n)
- C) O(n) ✅
- D) O(n log n)

**2. Which container uses a chunked memory layout?**
- A) vector
- B) deque ✅
- C) list
- D) array

**3. After `vector::clear()`, what is the capacity?**
- A) 0
- B) Same as before ✅
- C) 1
- D) Undefined

**4. What type of sort does `std::list::sort()` use internally?**
- A) QuickSort
- B) HeapSort
- C) Merge Sort ✅
- D) IntroSort

**5. Which container does NOT support `push_back()`?**
- A) vector
- B) deque
- C) forward_list ✅
- D) list

**6. What is the maximum number of reallocations for `n` push_backs on a vector?**
- A) n
- B) n/2
- C) log₂(n) ✅
- D) √n

**7. `std::array<int, 0>` is:**
- A) A compilation error
- B) Valid, with size 0 ✅
- C) Valid, with size 1
- D) Undefined behavior

**8. Which operation is O(1) for `std::list` but O(n) for `std::vector`?**
- A) `push_back()`
- B) `size()`
- C) `insert()` at arbitrary position ✅ (given iterator)
- D) `front()`

**9. What does `v.reserve(100)` do to a vector with 3 elements?**
- A) Makes size = 100
- B) Makes capacity ≥ 100, size remains 3 ✅
- C) Adds 97 default elements
- D) No effect

**10. Which container stores elements on the stack?**
- A) vector
- B) deque
- C) list
- D) array ✅

---

### Level 3 — Tricky Interview MCQs

**1. What is the output?**
```cpp
std::vector<int> v = {1, 2, 3, 4, 5};
v.erase(v.begin() + 1, v.begin() + 3);
for (int x : v) std::cout << x << " ";
```
- A) `1 4 5` ✅
- B) `1 2 5`
- C) `1 3 4 5`
- D) `1 2 3`

**2. Is this code valid?**
```cpp
std::deque<int> d = {1, 2, 3};
int* p = &d[1];
d.push_back(4);
std::cout << *p;  // Is this safe?
```
- A) Always safe ✅ (pointers/references survive push_back/push_front in deque)
- B) Always unsafe
- C) Implementation-defined
- D) Depends on capacity

**3. What happens here?**
```cpp
std::vector<int> v;
v.resize(5);
v.reserve(100);
std::cout << v.size() << " " << v.capacity();
```
- A) `5 5`
- B) `100 100`
- C) `5 100` ✅
- D) `0 100`

**4. What is `sizeof(std::vector<int>)`?**
- A) Depends on the number of elements
- B) 24 on 64-bit systems ✅ (3 pointers × 8 bytes)
- C) 12 on all systems
- D) Same as the capacity × sizeof(int)

**5. After this code, what is `v2.size()`?**
```cpp
std::vector<int> v1 = {1, 2, 3, 4, 5};
std::vector<int> v2 = std::move(v1);
```
- A) 0
- B) 5 ✅
- C) Undefined
- D) Same as v1.size()

---

### Level 4 — True / False

| #   | Statement                                              | Answer                                                |
| --- | ------------------------------------------------------ | ----------------------------------------------------- |
| 1   | `vector::reserve()` constructs elements                | **False** (only allocates memory)                     |
| 2   | `deque` supports random access iterators               | **True**                                              |
| 3   | `list::push_back` never invalidates existing iterators | **True**                                              |
| 4   | `forward_list` has a `back()` function                 | **False**                                             |
| 5   | `std::array` can be heap-allocated                     | **True** (using `new std::array<int,5>`)              |
| 6   | `vector::data()` returns nullptr for empty vectors     | **True** (or a valid pointer, implementation-defined) |
| 7   | `deque::push_front` is O(n)                            | **False** (it's O(1))                                 |
| 8   | `vector<bool>` stores each bool as 1 bit               | **True**                                              |
| 9   | `list` supports random access with `operator[]`        | **False**                                             |
| 10  | After `vector::clear()`, iterators remain valid        | **False** (they are invalidated)                      |

---

### Level 5 — Coding Practice Problems

**Problem 1: Implement a Circular Buffer using deque**
```cpp
// Implement a circular buffer that holds at most k elements.
// push(x): Add x. If full, remove oldest element.
// top(): Return most recent element.
// getAll(): Return all elements in order.
```

**Problem 2: Merge k Sorted Vectors**
```cpp
// Given k sorted vectors, merge them into a single sorted vector.
// Aim for O(N log k) where N is total elements.
// Hint: Use a min-heap of iterators.
```

**Problem 3: Sliding Window Maximum**
```cpp
// Given array of n integers and window size k,
// find the maximum in each window of size k.
// Input: [1, 3, -1, -3, 5, 3, 6, 7], k = 3
// Output: [3, 3, 5, 5, 6, 7]
// Hint: Use monotonic deque.
```

**Problem 4: Flatten Nested Vectors**
```cpp
// Given vector<vector<int>> v, return a flattened vector<int>.
// Example: {{1,2}, {3}, {4,5,6}} → {1,2,3,4,5,6}
```

**Problem 5: LRU Cache**
```cpp
// Implement an LRU Cache with O(1) get and put using:
// std::list + std::unordered_map
// This is a classic interview problem that demonstrates
// the power of list::splice().
```

---

---

## 14. Extended Examples with Test Cases

### Example 1 — vector growth and capacity

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> v;
    cout << "cap=" << v.capacity() << "\n";   // 0

    for (int i = 1; i <= 8; i++) {
        v.push_back(i);
        cout << "size=" << v.size() << " cap=" << v.capacity() << "\n";
    }
    // Typical GCC output (doubles each reallocation):
    // size=1 cap=1
    // size=2 cap=2
    // size=3 cap=4
    // size=4 cap=4
    // size=5 cap=8
    // size=6 cap=8
    // size=7 cap=8
    // size=8 cap=8

    v.shrink_to_fit();
    cout << "after shrink_to_fit: cap=" << v.capacity() << "\n"; // 8

    v.clear();
    cout << "after clear: size=" << v.size() << " cap=" << v.capacity() << "\n";
    // size=0 cap=8  (clear does NOT free memory)

    return 0;
}
```

---

### Example 2 — resize vs reserve

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> a, b;

    // reserve: allocates memory, does NOT create elements
    a.reserve(5);
    cout << "a size=" << a.size() << " cap=" << a.capacity() << "\n";
    // size=0 cap=5
    // a[0] = 1; // UNDEFINED BEHAVIOR — size is 0

    // resize: creates elements (default or specified value)
    b.resize(5, 42);
    cout << "b size=" << b.size() << " cap=" << b.capacity() << "\n";
    // size=5 cap=5
    cout << b[3] << "\n";  // 42 — element exists

    // resize DOWN
    b.resize(2);
    cout << "b size=" << b.size() << " cap=" << b.capacity() << "\n";
    // size=2 cap=5  (capacity unchanged)

    return 0;
}
```

**Expected Output:**
```
a size=0 cap=5
b size=5 cap=5
42
b size=2 cap=5
```

---

### Example 3 — list splice (O(1) move of elements)

```cpp
#include <iostream>
#include <list>
using namespace std;

int main() {
    list<int> l1 = {1, 2, 3, 4, 5};
    list<int> l2 = {10, 20, 30};

    auto it = l1.begin();
    advance(it, 2);  // points to 3

    // splice entire l2 BEFORE position it (before element 3)
    l1.splice(it, l2);
    // l1 = {1, 2, 10, 20, 30, 3, 4, 5}
    // l2 = {}  (elements moved, not copied)

    for (int x : l1) cout << x << " ";
    cout << "\n";           // 1 2 10 20 30 3 4 5
    cout << l2.size() << "\n";  // 0

    return 0;
}
```

---

### Example 4 — deque front/back operations

```cpp
#include <iostream>
#include <deque>
using namespace std;

int main() {
    deque<int> dq;
    dq.push_back(1);
    dq.push_back(2);
    dq.push_front(0);
    dq.push_front(-1);
    // dq = {-1, 0, 1, 2}

    cout << dq.front() << " " << dq.back() << "\n";  // -1 2

    dq.pop_front();
    dq.pop_back();
    // dq = {0, 1}

    for (int x : dq) cout << x << " ";
    cout << "\n";   // 0 1

    // Random access — O(1)
    cout << dq[1] << "\n";  // 1

    return 0;
}
```

---

### Example 5 — forward_list pitfalls

```cpp
#include <iostream>
#include <forward_list>
using namespace std;

int main() {
    forward_list<int> fl = {1, 2, 3, 4, 5};

    // insert_after — NOT insert_before
    auto it = fl.begin();   // points to 1
    advance(it, 1);         // points to 2
    fl.insert_after(it, 99);
    // fl = {1, 2, 99, 3, 4, 5}

    for (int x : fl) cout << x << " ";
    cout << "\n";  // 1 2 99 3 4 5

    // erase_after — erases element AFTER given position
    fl.erase_after(it);  // erases 99 (element after 2)
    for (int x : fl) cout << x << " ";
    cout << "\n";  // 1 2 3 4 5

    // forward_list has no size() and no back()
    // This does NOT compile:
    // fl.size();   // error
    // fl.back();   // error

    return 0;
}
```

---

### Example 6 — vector<bool> special behavior

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<bool> vb = {true, false, true, true};

    // vector<bool> is SPECIAL — stores bits, not bytes
    // sizeof element is NOT sizeof(bool)
    // auto& ref = vb[0];  // proxy object, not bool&

    vb[1] = true;
    cout << vb[1] << "\n";  // 1

    // Flip a bit
    vb[0].flip();
    cout << vb[0] << "\n";  // 0

    // Cannot take address of elements directly:
    // bool* p = &vb[0];  // COMPILE ERROR

    // Use vector<char> or vector<uint8_t> if you need real booleans
    return 0;
}
```

---

## 15. Tricky MCQs — Expert Level

**Q1. What is printed?**
```cpp
vector<int> v = {1, 2, 3, 4, 5};
v.erase(v.begin() + 1, v.begin() + 3);
cout << v.size() << " " << v[1];
```
- A) `5 2`
- B) `3 4` ✅
- C) `3 2`
- D) `4 3`

> **Why:** `erase([begin+1, begin+3))` removes elements at index 1 and 2 (values 2 and 3). Remaining: {1, 4, 5}. `v[1]=4`, `v.size()=3`.

---

**Q2. The amortized cost of n push_back operations on an empty vector is:**
- A) O(n²)
- B) O(n log n)
- C) O(n) ✅
- D) O(1)

> **Why:** Total copying work during doubly-exponential growth = 1+2+4+...+n = 2n = O(n). Amortized per op = O(1).

---

**Q3. What does this print?**
```cpp
vector<int> v = {10, 20, 30};
auto it = v.begin() + 1;
v.insert(v.begin(), 0);
cout << *it;
```
- A) 20
- B) 10
- C) Undefined behavior ✅
- D) 0

> **Why:** `insert` at `begin()` causes reallocation (possibly), invalidating `it`. Dereferencing it is UB.

---

**Q4. Which container keeps insertion-order iteration?**
- A) `std::set`
- B) `std::map`
- C) `std::vector` ✅
- D) `std::unordered_map`

> **Why:** `vector` iterates in insertion order (elements stay at their positions). The others reorder by sort key or hash.

---

**Q5. What is the output?**
```cpp
deque<int> d = {1, 2, 3};
int* p = &d[1];
d.push_back(4);
cout << *p;
```
- A) Undefined behavior
- B) 2 ✅
- C) 4
- D) Random garbage

> **Why:** Unlike `vector`, `deque::push_back` does NOT invalidate pointers/references to existing elements (but DOES invalidate all iterators).

---

**Q6. `vector::assign(5, 0)` will:**
- A) Append 5 zeros
- B) Replace all content with 5 zeros ✅
- C) Resize to 5 only
- D) Throw if size differs

---

**Q7. What's wrong with this code?**
```cpp
vector<int> v = {1, 2, 3, 4, 5};
for (auto it = v.begin(); it != v.end(); ++it) {
    if (*it % 2 == 0)
        v.erase(it);
}
```
- A) Nothing wrong
- B) Compile error
- C) Infinite loop
- D) Undefined behavior — `erase` invalidates `it`, then `++it` is UB ✅

> **Correct pattern:** `it = v.erase(it);` (and skip `++it` in that branch).

---

**Q8. `std::array<int, 5> a;` — what are the element values?**
- A) All 0 (zero-initialized)
- B) Undefined (uninitialized) ✅ unless value-initialized
- C) Compilation error
- D) All -1

> **Why:** `std::array<int, 5> a;` default-initializes — local ints are indeterminate. Use `std::array<int, 5> a{};` for zero-init.

---

**Q9. What is the difference between `list::sort()` and `std::sort()` applied to a list?**
- A) No difference
- B) `std::sort` requires RandomAccessIterator; `list::sort` uses merge sort on node pointers ✅
- C) `list::sort` is unstable
- D) `std::sort` is faster on lists

---

**Q10. After `vector<int> v(10); v.resize(5);` then `v.resize(10);`, are the 5 new elements zero-initialized?**
- A) No — undefined values
- B) Yes — `resize` value-initializes new elements ✅
- C) Only if the vector was default-constructed
- D) Depends on the compiler

---

**Q11. What is `std::list::size()` complexity in C++11 and later?**
- A) O(n) for all implementations
- B) O(1) ✅ (mandated by C++11)
- C) O(log n)
- D) Implementation-defined

> **Why:** C++11 mandates O(1) `size()` for all containers.

---

**Q12. Which is faster for random insertion in the middle?**
- A) `vector` (contiguous memory, cache friendly) ✅ for small n due to cache
- B) `list` (O(1) node insert once iterator acquired) ✅ asymptotically
- C) They are always equivalent
- D) `deque`

> **Why:** In practice, for small-to-medium sizes `vector` is faster due to cache locality despite O(n) shift. For very large data, `list` wins.

---

> **Previous:** [01_STL_Fundamentals.md](01_STL_Fundamentals.md)  
> **Next:** [03_STL_Associative_Containers.md](03_STL_Associative_Containers.md)
