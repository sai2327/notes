# 📘 Chapter 7: STL Iterators — Types, Invalidation Rules & Custom Iterators

> **Iterators are the glue between containers and algorithms — master them to master STL.**

---

## Table of Contents

- [1. What Are Iterators?](#1-what-are-iterators)
- [2. Iterator Categories](#2-iterator-categories)
- [3. Iterator Operations & Syntax](#3-iterator-operations--syntax)
- [4. Iterator Adaptors](#4-iterator-adaptors)
- [5. Iterator Invalidation Rules](#5-iterator-invalidation-rules)
- [6. Custom Iterators](#6-custom-iterators)
- [7. C++17 / C++20 Iterator Improvements](#7-c17--c20-iterator-improvements)
- [8. Common Mistakes](#8-common-mistakes)
- [9. Interview Tips](#9-interview-tips)
- [10. CP Tricks](#10-cp-tricks)
- [11. Edge Cases](#11-edge-cases)
- [12. Summary](#12-summary)
- [13. Practice Section](#13-practice-section)

---

## 1. What Are Iterators?

Iterators are **generalized pointers** that provide a uniform interface for traversing containers, regardless of the container's internal data structure.

```
┌─────────────────────────────────────────────────────────────────┐
│                     The Iterator Abstraction                     │
│                                                                  │
│  Container ←──── Iterator ────→ Algorithm                       │
│                                                                  │
│  vector      →  RandomAccess  →  sort, binary_search            │
│  list        →  Bidirectional →  reverse, merge                 │
│  forward_list→  Forward       →  find, for_each                 │
│  streams     →  Input/Output  →  copy, accumulate               │
│                                                                  │
│  Iterators decouple containers from algorithms.                 │
│  Same algorithm works on ANY container with compatible iterator.│
└─────────────────────────────────────────────────────────────────┘
```

### Key Concept

```cpp
#include <vector>
#include <list>
#include <algorithm>

// Same algorithm, different containers:
std::vector<int> v = {3, 1, 4};
std::list<int> lst = {3, 1, 4};

auto vit = std::find(v.begin(), v.end(), 4);    // Works!
auto lit = std::find(lst.begin(), lst.end(), 4); // Also works!

// The iterator abstraction lets find() work on both seamlessly
```

---

## 2. Iterator Categories

### 2.1 The Iterator Hierarchy

```
                    InputIterator          OutputIterator
                         ↑                       ↑
                         │                       │
                    ForwardIterator ──────────────┘
                         ↑
                         │
                  BidirectionalIterator
                         ↑
                         │
                  RandomAccessIterator
                         ↑
                         │
                  ContiguousIterator (C++17)

Each level adds capabilities to the previous one.
Higher iterator ⊃ Lower iterator capabilities.
```

### 2.2 Detailed Comparison

| Category          | Read | Write | Increment       | Decrement | Random Access         | Example Container               |
| ----------------- | ---- | ----- | --------------- | --------- | --------------------- | ------------------------------- |
| **Input**         | ✅    | ❌     | ✅ (single pass) | ❌         | ❌                     | `istream_iterator`              |
| **Output**        | ❌    | ✅     | ✅ (single pass) | ❌         | ❌                     | `ostream_iterator`              |
| **Forward**       | ✅    | ✅     | ✅ (multi pass)  | ❌         | ❌                     | `forward_list`, `unordered_set` |
| **Bidirectional** | ✅    | ✅     | ✅               | ✅         | ❌                     | `list`, `set`, `map`            |
| **RandomAccess**  | ✅    | ✅     | ✅               | ✅         | ✅                     | `vector`, `deque`, `array`      |
| **Contiguous**    | ✅    | ✅     | ✅               | ✅         | ✅ + contiguous memory | `vector`, `array`, `string`     |

### 2.3 Operations by Category

```
Input:          *it  ++it  it1==it2  it1!=it2
Output:         *it=val  ++it
Forward:        All of Input + Output + multi-pass
Bidirectional:  All of Forward + --it
RandomAccess:   All of Bidirectional + it+n  it-n  it[n]  it1<it2  it1-it2
Contiguous:     All of RandomAccess + guaranteed contiguous memory
```

### 2.4 Which Algorithms Need Which Iterators?

```
┌──────────────────────────────┬──────────────────────────────┐
│ Algorithm                    │ Minimum Iterator Required    │
├──────────────────────────────┼──────────────────────────────┤
│ find, count, for_each        │ InputIterator                │
│ copy, transform              │ InputIterator + OutputIter   │
│ replace, fill                │ ForwardIterator              │
│ reverse, next_permutation    │ BidirectionalIterator        │
│ sort, nth_element            │ RandomAccessIterator         │
│ binary_search, lower_bound   │ RandomAccessIterator (O(logn)│
│   (works with Forward too,   │  but O(n) with ForwardIter)  │
│    just slower)              │                              │
└──────────────────────────────┴──────────────────────────────┘
```

---

## 3. Iterator Operations & Syntax

### 3.1 Basic Operations

```cpp
#include <vector>
#include <iterator>

std::vector<int> v = {10, 20, 30, 40, 50};

// ─────────────────────────── begin / end ────────────────────────────
auto it = v.begin();    // Points to first element (10)
auto end = v.end();     // Points PAST last element

// ─────────────────────────── Dereference ────────────────────────────
int val = *it;          // 10
*it = 99;               // Modify: v[0] = 99

// ─────────────────────────── Increment / Decrement ──────────────────
++it;                   // Move forward (now points to 20)
--it;                   // Move backward (back to 10) — requires Bidirectional
it++;                   // Post-increment (prefer pre-increment for efficiency)

// ─────────────────────────── Random Access ──────────────────────────
it += 3;                // Jump forward 3 (points to 40)
it -= 2;                // Jump backward 2 (points to 20)
int x = it[2];          // Access 2 ahead: 40
auto diff = v.end() - v.begin();  // 5 (number of elements)

// ─────────────────────────── Comparison ─────────────────────────────
if (it == v.end()) { }   // Equality check
if (it < v.end()) { }    // Less-than (only RandomAccess)
if (it != v.end()) { }   // Not equal
```

### 3.2 std::advance, std::distance, std::next, std::prev

```cpp
#include <iterator>
#include <list>

std::list<int> lst = {10, 20, 30, 40, 50};

auto it = lst.begin();

// ─────────────────────────── advance ────────────────────────────────
// Moves iterator by n positions (modifies in place)
std::advance(it, 3);
// it now points to 40
// For RandomAccess: O(1). For others: O(n)

// ─────────────────────────── distance ───────────────────────────────
auto dist = std::distance(lst.begin(), lst.end());  // 5
// For RandomAccess: O(1). For others: O(n)

// ─────────────────────────── next / prev (C++11) ────────────────────
auto it2 = std::next(lst.begin(), 2);   // Returns iterator 2 ahead (30)
auto it3 = std::prev(lst.end(), 1);     // Returns iterator 1 before end (50)
// These do NOT modify the original iterator — they return a new one!

// ⚠️ Always use advance/distance/next/prev for non-RandomAccess iterators
// instead of + or - operators (which won't compile!)
```

### 3.3 Reverse Iterators

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

// ─────────────────────────── rbegin / rend ──────────────────────────
for (auto it = v.rbegin(); it != v.rend(); ++it) {
    std::cout << *it << " ";
}
// Output: 5 4 3 2 1

// ─────────────────────────── crbegin / crend (const) ────────────────
for (auto it = v.crbegin(); it != v.crend(); ++it) {
    // *it is read-only
}

// ─────────────────────────── Convert reverse ↔ forward ──────────────
auto rit = v.rbegin();         // Points to 5
auto fwd = rit.base();        // Points to end() (one past the reverse position)
// base() returns the forward iterator AFTER the reverse iterator's position

// Diagram:
// v:    [1] [2] [3] [4] [5]  end()
//                         ↑     ↑
//                       rbegin  rbegin.base()
```

### 3.4 Const Iterators

```cpp
std::vector<int> v = {1, 2, 3};

// Const iterator: can read, cannot modify
auto cit = v.cbegin();   // const_iterator
// *cit = 42;  // ❌ Compile error!

// Non-const: can read and modify
auto it = v.begin();
*it = 42;  // ✅ OK

// In range-based for loop:
for (const auto& x : v) { }  // Behaves like const_iterator
for (auto& x : v) { x = 0; } // Behaves like regular iterator
```

---

## 4. Iterator Adaptors

### 4.1 std::back_inserter

Wraps `push_back()` as an output iterator.

```cpp
#include <iterator>

std::vector<int> src = {1, 2, 3, 4, 5};
std::vector<int> dst;

// Without back_inserter: need to pre-allocate dst
// dst.resize(5);
// std::copy(src.begin(), src.end(), dst.begin());

// With back_inserter: automatically pushes back
std::copy(src.begin(), src.end(), std::back_inserter(dst));
// dst = {1, 2, 3, 4, 5}

// Common use: copy_if
std::vector<int> evens;
std::copy_if(src.begin(), src.end(), std::back_inserter(evens),
    [](int x) { return x % 2 == 0; });
// evens = {2, 4}
```

### 4.2 std::front_inserter

Wraps `push_front()` as an output iterator.

```cpp
std::deque<int> d;
std::vector<int> src = {1, 2, 3};

std::copy(src.begin(), src.end(), std::front_inserter(d));
// d = {3, 2, 1}  — Note: reversed! Each element is pushed to front.
```

### 4.3 std::inserter

Wraps `insert()` at a specific position.

```cpp
std::set<int> s = {1, 5, 9};
std::vector<int> to_add = {3, 7, 2};

std::copy(to_add.begin(), to_add.end(), std::inserter(s, s.end()));
// s = {1, 2, 3, 5, 7, 9}
```

### 4.4 Stream Iterators

```cpp
#include <iterator>
#include <iostream>
#include <sstream>
#include <vector>
#include <algorithm>

// ─────────────────────────── istream_iterator ───────────────────────
// Read integers from input stream
std::istringstream iss("10 20 30 40 50");
std::vector<int> v(
    std::istream_iterator<int>(iss),
    std::istream_iterator<int>()     // Default = end-of-stream
);
// v = {10, 20, 30, 40, 50}

// ─────────────────────────── ostream_iterator ───────────────────────
// Write to output stream
std::vector<int> out = {1, 2, 3, 4, 5};
std::copy(out.begin(), out.end(),
    std::ostream_iterator<int>(std::cout, ", "));
// Output: 1, 2, 3, 4, 5,

// ─────────────────────────── Stream to file ─────────────────────────
// Read all words from cin:
// vector<string> words(istream_iterator<string>(cin), 
//                      istream_iterator<string>());
```

### 4.5 std::move_iterator (C++11)

```cpp
#include <iterator>

std::vector<std::string> src = {"hello", "world", "foo"};
std::vector<std::string> dst;

// Move elements instead of copying
std::copy(std::make_move_iterator(src.begin()),
          std::make_move_iterator(src.end()),
          std::back_inserter(dst));
// dst = {"hello", "world", "foo"}
// src strings are now in moved-from state (empty)
```

---

## 5. Iterator Invalidation Rules

> **This is one of the most critical topics for interviews! Memorize this table.**

### 5.1 Master Invalidation Table

```
┌────────────────────┬─────────────────────┬──────────────────────┐
│ Container          │ Insert/Push         │ Erase/Pop            │
├────────────────────┼─────────────────────┼──────────────────────┤
│ vector             │ ALL invalidated if  │ At/after erased pos  │
│                    │ reallocation occurs.│ are invalidated.     │
│                    │ If no realloc: at/  │                      │
│                    │ after insert point. │                      │
├────────────────────┼─────────────────────┼──────────────────────┤
│ deque              │ ALL invalidated     │ ALL invalidated      │
│                    │ (always).           │ unless erasing at    │
│                    │ Exception: push_    │ front/back (only     │
│                    │ front/push_back     │ that iterator).      │
│                    │ invalidate no refs  │                      │
│                    │ but do invalidate   │                      │
│                    │ iterators.          │                      │
├────────────────────┼─────────────────────┼──────────────────────┤
│ list/forward_list  │ NONE invalidated!   │ Only erased element  │
│                    │ All iterators stay  │ is invalidated.      │
│                    │ valid.              │ Others stay valid.   │
├────────────────────┼─────────────────────┼──────────────────────┤
│ set/map            │ NONE invalidated!   │ Only erased element  │
│ multiset/multimap  │                     │ is invalidated.      │
├────────────────────┼─────────────────────┼──────────────────────┤
│ unordered_set/map  │ ALL invalidated if  │ Only erased element  │
│                    │ rehash occurs.      │ is invalidated.      │
│                    │ Otherwise none.     │                      │
└────────────────────┴─────────────────────┴──────────────────────┘
```

### 5.2 Vector Invalidation Details

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};
auto it = v.begin() + 2;  // Points to 3

// ─────── push_back with reallocation ──────
// If v.size() == v.capacity(), ALL iterators invalidated!
v.push_back(6);  
// it may be DANGLING if reallocation occurred!

// ─────── Safe pattern ──────
int idx = it - v.begin();  // Save index
v.push_back(6);
it = v.begin() + idx;      // Restore iterator

// ─────── insert ──────
v.insert(v.begin() + 1, 99);
// Iterators at or after position 1 are invalidated

// ─────── erase ──────
v.erase(v.begin() + 2);
// Iterators at or after position 2 are invalidated
```

### 5.3 Erasing While Iterating

```cpp
// ─────── WRONG way: ──────
std::vector<int> v = {1, 2, 3, 4, 5};
for (auto it = v.begin(); it != v.end(); ++it) {
    if (*it % 2 == 0) {
        v.erase(it);  // ❌ iterator invalidated after erase!
        // it is now dangling, ++it is undefined behavior
    }
}

// ─────── RIGHT way (vector, deque): ──────
for (auto it = v.begin(); it != v.end(); ) {
    if (*it % 2 == 0) {
        it = v.erase(it);  // erase returns iterator to next element
    } else {
        ++it;
    }
}

// ─────── RIGHT way (list, set, map): same pattern ──────
std::list<int> lst = {1, 2, 3, 4, 5};
for (auto it = lst.begin(); it != lst.end(); ) {
    if (*it % 2 == 0) {
        it = lst.erase(it);
    } else {
        ++it;
    }
}

// ─────── BEST way (C++20): ──────
// std::erase_if(v, [](int x) { return x % 2 == 0; });
```

---

## 6. Custom Iterators

### 6.1 Simple Range Iterator

```cpp
#include <iterator>

class Range {
    int start_, end_;
public:
    Range(int start, int end) : start_(start), end_(end) {}
    
    class Iterator {
        int current_;
    public:
        // Required type aliases
        using iterator_category = std::forward_iterator_tag;
        using value_type = int;
        using difference_type = std::ptrdiff_t;
        using pointer = const int*;
        using reference = const int&;
        
        Iterator(int val) : current_(val) {}
        
        int operator*() const { return current_; }
        Iterator& operator++() { ++current_; return *this; }
        Iterator operator++(int) { auto tmp = *this; ++current_; return tmp; }
        bool operator==(const Iterator& other) const { return current_ == other.current_; }
        bool operator!=(const Iterator& other) const { return current_ != other.current_; }
    };
    
    Iterator begin() { return Iterator(start_); }
    Iterator end() { return Iterator(end_); }
};

// Usage:
int main() {
    for (int x : Range(1, 6)) {
        std::cout << x << " ";
    }
    // Output: 1 2 3 4 5
    
    // Works with STL algorithms:
    Range r(1, 11);
    auto it = std::find(r.begin(), r.end(), 7);
    
    return 0;
}
```

### 6.2 Required Operators by Category

```
Forward Iterator must provide:
  - operator*         (dereference)
  - operator++        (pre-increment)
  - operator++(int)   (post-increment)
  - operator==        (equality)
  - operator!=        (inequality)
  - Type aliases: iterator_category, value_type, difference_type, pointer, reference

Bidirectional adds:
  - operator--        (pre-decrement)
  - operator--(int)   (post-decrement)

Random Access adds:
  - operator+, operator-  (arithmetic)
  - operator+=, operator-=
  - operator[]         (subscript)
  - operator<, <=, >, >= (comparison)
```

### 6.3 Iterator Over Linked Structure

```cpp
struct Node {
    int data;
    Node* next;
};

class LinkedListIterator {
    Node* ptr_;
public:
    using iterator_category = std::forward_iterator_tag;
    using value_type = int;
    using difference_type = std::ptrdiff_t;
    using pointer = int*;
    using reference = int&;
    
    LinkedListIterator(Node* p = nullptr) : ptr_(p) {}
    
    int& operator*() { return ptr_->data; }
    LinkedListIterator& operator++() { ptr_ = ptr_->next; return *this; }
    LinkedListIterator operator++(int) { auto tmp = *this; ptr_ = ptr_->next; return tmp; }
    bool operator==(const LinkedListIterator& o) const { return ptr_ == o.ptr_; }
    bool operator!=(const LinkedListIterator& o) const { return ptr_ != o.ptr_; }
};
```

---

## 7. C++17 / C++20 Iterator Improvements

### 7.1 Structured Bindings (C++17)

```cpp
std::map<std::string, int> m = {{"a", 1}, {"b", 2}};

for (auto& [key, value] : m) {
    std::cout << key << ": " << value << "\n";
}
```

### 7.2 std::size, std::empty, std::data (C++17)

```cpp
std::vector<int> v = {1, 2, 3};
auto sz = std::size(v);    // Works on containers AND C arrays
auto e = std::empty(v);    // Works on containers AND C arrays
auto d = std::data(v);     // Returns pointer to underlying data
```

### 7.3 C++20 Ranges and Views (Preview)

```cpp
// C++20 ranges make iterator pairs unnecessary
#include <ranges>
#include <vector>

std::vector<int> v = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

// Filter and transform with views (lazy evaluation!)
auto result = v 
    | std::views::filter([](int x) { return x % 2 == 0; })
    | std::views::transform([](int x) { return x * x; });

for (int x : result) {
    std::cout << x << " ";
}
// Output: 4 16 36 64 100

// std::ranges:: versions of algorithms
std::ranges::sort(v);  // No need for begin/end!
auto it = std::ranges::find(v, 5);
```

---

## 8. Common Mistakes

### Mistake 1: Using Invalidated Iterators

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};
auto it = v.begin() + 2;

v.push_back(6);  // Potential reallocation!
// ❌ *it is now undefined behavior if reallocation occurred

// ✅ Store index instead
int idx = 2;
v.push_back(6);
auto val = v[idx];  // Always safe
```

### Mistake 2: Off-by-One with end()

```cpp
std::vector<int> v = {1, 2, 3};

// ❌ Dereferencing end()
// *v.end() is UB!

// ✅ Check before dereferencing
auto it = std::find(v.begin(), v.end(), 42);
if (it != v.end()) {
    std::cout << *it;
}
```

### Mistake 3: Using + on Non-RandomAccess Iterators

```cpp
std::list<int> lst = {1, 2, 3, 4, 5};

// ❌ Won't compile! list has Bidirectional iterators
// auto it = lst.begin() + 3;

// ✅ Use std::advance or std::next
auto it = std::next(lst.begin(), 3);  // Points to 4
```

### Mistake 4: Comparing Iterators from Different Containers

```cpp
std::vector<int> v1 = {1, 2, 3};
std::vector<int> v2 = {1, 2, 3};

// ❌ Undefined behavior! Different containers!
// if (v1.begin() == v2.begin()) { }

// Only compare iterators from the SAME container.
```

### Mistake 5: Reverse Iterator Arithmetic

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

auto rit = v.rbegin();  // Points to 5
++rit;                   // Points to 4 (moves toward front!)

// rit.base() returns forward iterator ONE PAST rit's position
// If rit points to element at index 3, rit.base() points to index 4
```

---

## 9. Interview Tips

**Q1: What is iterator invalidation and why does it matter?**
> When a container is modified (insert/erase/resize), existing iterators may become dangling — pointing to freed or moved memory. Using invalidated iterators is undefined behavior. This is one of the most common sources of C++ bugs.

**Q2: Why does `vector::push_back` sometimes invalidate all iterators?**
> If `size() == capacity()`, the vector must reallocate to a larger buffer. All elements are moved/copied to the new memory, so all existing iterators, pointers, and references become dangling.

**Q3: Which containers never invalidate iterators on insertion?**
> `std::list`, `std::forward_list`, `std::set`, `std::map`, `std::multiset`, `std::multimap`. All node-based containers — because insertion doesn't move existing nodes.

**Q4: What's the difference between `std::advance` and `std::next`?**
> `advance(it, n)` modifies `it` in place and returns void. `next(it, n)` returns a new iterator without modifying the original. `next` is preferred when you want to keep the original.

**Q5: Why is `it++` slower than `++it` for complex iterators?**
> `it++` (post-increment) must create a copy of the iterator before incrementing, then return the copy. `++it` (pre-increment) modifies in place and returns a reference. For simple types (pointers) the compiler optimizes this, but for complex iterators (e.g., `std::map::iterator`), the copy can be expensive.

---

## 10. CP Tricks

### Trick 1: Iterate Backwards Quickly

```cpp
vector<int> v = {1, 2, 3, 4, 5};

// Using reverse iterators
for (auto it = v.rbegin(); it != v.rend(); ++it)
    cout << *it << " ";

// Using index (often clearer in CP)
for (int i = (int)v.size() - 1; i >= 0; i--)
    cout << v[i] << " ";
```

### Trick 2: Iterator to Index and Back

```cpp
vector<int> v = {10, 20, 30, 40, 50};

auto it = lower_bound(v.begin(), v.end(), 30);
int idx = it - v.begin();      // 2
auto it2 = v.begin() + idx;    // Back to iterator
```

### Trick 3: Read Input Until EOF

```cpp
#include <iterator>
#include <vector>

// Read all integers from stdin
vector<int> v(istream_iterator<int>(cin), istream_iterator<int>());

// Or with back_inserter
vector<int> v2;
copy(istream_iterator<int>(cin), istream_iterator<int>(),
     back_inserter(v2));
```

### Trick 4: Set Operations with Iterators

```cpp
set<int> a = {1, 2, 3, 4, 5};
set<int> b = {3, 4, 5, 6, 7};

vector<int> intersection;
set_intersection(a.begin(), a.end(), b.begin(), b.end(),
                 back_inserter(intersection));
// intersection = {3, 4, 5}
```

### Trick 5: Advance and Distance for List/Set

```cpp
set<int> s = {10, 20, 30, 40, 50};

// Get the 3rd element (0-indexed)
auto it = s.begin();
advance(it, 2);   // O(n) for set — no random access!
cout << *it;       // 30

// Distance from begin
auto it2 = s.find(40);
int pos = distance(s.begin(), it2);  // 3 (O(n) for set)
```

---

## 11. Edge Cases

### Empty Container

```cpp
std::vector<int> v;
// v.begin() == v.end()
// Do NOT dereference v.begin() when empty!

// Safe pattern:
if (!v.empty()) {
    auto it = v.begin();
    // safe to use *it
}
```

### Single Element

```cpp
std::vector<int> v = {42};
auto it = v.begin();
*it;    // 42
++it;   // Now it == v.end()
// Do not dereference!
```

### Iterator to Erased Element

```cpp
std::set<int> s = {1, 2, 3};
auto it = s.find(2);
s.erase(it);
// it is now invalid!
// ❌ *it is UB
// ❌ ++it is UB
```

---

## 12. Summary

```
┌──────────────────────────────────────────────────────────────────┐
│                    ITERATORS CHEAT SHEET                          │
├──────────────────────────────────────────────────────────────────┤
│ Categories: Input→Forward→Bidirectional→RandomAccess→Contiguous │
│                                                                   │
│ Key Functions:                                                    │
│   advance(it, n)  — move in place (void)                         │
│   next(it, n)     — return new iterator (+n)                     │
│   prev(it, n)     — return new iterator (-n)                     │
│   distance(a, b)  — count elements between a and b              │
│                                                                   │
│ Adaptors:                                                         │
│   back_inserter   — wraps push_back                              │
│   front_inserter  — wraps push_front                             │
│   inserter        — wraps insert at position                     │
│   istream/ostream — stream I/O as iterators                      │
│                                                                   │
│ GOLDEN RULES:                                                     │
│ 1. Never dereference end() or an invalidated iterator            │
│ 2. Check empty() before using begin()                            │
│ 3. Use it = container.erase(it) pattern for safe erasing         │
│ 4. Prefer ++it over it++ for non-trivial iterators              │
│ 5. Use next/prev instead of +/- for non-RandomAccess            │
│ 6. Iterators compare only within SAME container                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 13. Practice Section

### Level 1 — Quick Concept Questions

1. **Q: What are the 5 iterator categories in order?**
   <details><summary>Answer</summary>Input → Forward → Bidirectional → RandomAccess → Contiguous</details>

2. **Q: What type of iterator does `std::list` provide?**
   <details><summary>Answer</summary>Bidirectional iterator.</details>

3. **Q: What does `std::advance(it, 3)` do?**
   <details><summary>Answer</summary>Moves the iterator 3 positions forward. Modifies `it` in place. Returns void.</details>

4. **Q: What's the difference between `std::next` and `std::advance`?**
   <details><summary>Answer</summary>`next` returns a new iterator, `advance` modifies the iterator in place.</details>

5. **Q: Does `push_back` invalidate all `vector` iterators?**
   <details><summary>Answer</summary>Only if reallocation occurs (size == capacity). Otherwise, only `end()` is invalidated.</details>

6. **Q: Which containers NEVER invalidate iterators on insert?**
   <details><summary>Answer</summary>`list`, `forward_list`, `set`, `map`, `multiset`, `multimap`.</details>

7. **Q: What does `back_inserter(v)` do?**
   <details><summary>Answer</summary>Creates an output iterator that calls `v.push_back()` on assignment.</details>

8. **Q: Why prefer `++it` over `it++`?**
   <details><summary>Answer</summary>`it++` creates a copy before incrementing. For complex iterators, this copy is wasteful.</details>

9. **Q: What happens if you dereference `v.end()`?**
   <details><summary>Answer</summary>Undefined behavior. `end()` points past the last element.</details>

10. **Q: Which STL algorithm requires RandomAccess iterators?**
    <details><summary>Answer</summary>`std::sort`, `std::nth_element`, `std::partial_sort`.</details>

---

### Level 2 — MCQs

**1. `std::distance(v.begin(), v.end())` returns:**
- A) An iterator
- B) The number of elements ✅
- C) The capacity
- D) A pointer

**2. Which iterator type does `std::set` provide?**
- A) Forward
- B) Bidirectional ✅
- C) Random Access
- D) Input

**3. After `vector::erase(it)`, which iterators are invalidated?**
- A) All iterators
- B) Only iterators before `it`
- C) Iterators at and after `it` ✅
- D) None

**4. `std::back_inserter` wraps which operation?**
- A) `push_front`
- B) `push_back` ✅
- C) `insert`
- D) `emplace`

**5. `std::istream_iterator<int>()` (default constructed) represents:**
- A) Beginning of stream
- B) End-of-stream sentinel ✅
- C) Null iterator
- D) Error state

**6. Which is NOT a valid way to create a reverse iterator?**
- A) `v.rbegin()`
- B) `std::make_reverse_iterator(v.end())`
- C) `v.end() - 1` ❌ (this is a forward iterator, not reverse) ✅
- D) `std::reverse_iterator(v.end())`

**7. `list::insert` invalidates:**
- A) All iterators
- B) Nearby iterators
- C) No iterators ✅
- D) Only end()

**8. `std::next(it, 5)` is equivalent to:**
- A) `it += 5` for RandomAccess iterators, but returns a new iterator ✅
- B) `advance(it, 5)`
- C) `it + 5` (always the same)
- D) `it++; it++; it++; it++; it++;`

**9. `std::front_inserter` can be used with:**
- A) vector
- B) deque ✅
- C) array
- D) unordered_set

**10. Iterator category of `std::vector<int>::iterator` is:**
- A) Forward
- B) Bidirectional
- C) Random Access / Contiguous ✅
- D) Input

---

### Level 3 — Tricky Interview MCQs

**1. After `rit.base()` where `rit` is a reverse iterator pointing to element at index 3:**
- A) Returns forward iterator to index 3
- B) Returns forward iterator to index 4 ✅
- C) Returns forward iterator to index 2
- D) Returns reverse iterator to index 4

**2. `unordered_map::insert` invalidates iterators when:**
- A) Always
- B) Never
- C) When rehashing occurs ✅
- D) When the key already exists

**3. Which pattern is SAFE for erasing from a vector while iterating?**
- A) `for (auto it = v.begin(); it != v.end(); ++it) v.erase(it);`
- B) `for (auto it = v.begin(); it != v.end(); ) it = v.erase(it);`
- C) Erase-remove idiom ✅ (both B and C work, but C is idiomatic)
- D) B and C are both correct ✅

**4. Why can't `std::sort` work on `std::list`?**
- A) list elements can't be compared
- B) list doesn't have `operator[]`
- C) `sort` requires RandomAccessIterator; list provides Bidirectional ✅
- D) list is already sorted

**5. `std::distance` on ForwardIterator is:**
- A) O(1)
- B) O(n) ✅
- C) O(log n)
- D) Undefined

---

### Level 4 — True / False

| #   | Statement                                               | Answer                              |
| --- | ------------------------------------------------------- | ----------------------------------- |
| 1   | `set::iterator` supports `it + 3`                       | **False** (Bidirectional)           |
| 2   | `vector::push_back` always invalidates all iterators    | **False** (only when reallocation)  |
| 3   | `list::insert` never invalidates any existing iterators | **True**                            |
| 4   | `end()` returns an iterator that can be dereferenced    | **False**                           |
| 5   | `std::advance` returns a new iterator                   | **False** (modifies in place, void) |
| 6   | `back_inserter` can be used with `std::set`             | **False** (set has no `push_back`)  |
| 7   | `istream_iterator` is an Input iterator                 | **True**                            |
| 8   | Comparing iterators from different containers is UB     | **True**                            |
| 9   | `const_iterator` prevents modification of the element   | **True**                            |
| 10  | `std::next` works on all iterator categories            | **True** (Forward and above)        |

---

### Level 5 — Coding Practice Problems

**Problem 1: Custom Range Iterator**
```
Create a class that generates a range [start, end) with step,
supporting range-based for loop. Example: Range(0, 10, 2) → 0, 2, 4, 6, 8
```

**Problem 2: Safe Vector Erase**
```
Given a vector, remove all elements divisible by 3 using the
erase-iterator pattern. Do it without erase-remove idiom first,
then with erase-remove.
```

**Problem 3: Flatten Nested Vectors**
```
Given vector<vector<int>>, create a custom iterator that iterates
over all elements as if they were in a single flat array.
```

**Problem 4: Circular Buffer Iterator**
```
Implement a circular buffer with a custom iterator that wraps
around from end to beginning.
```

**Problem 5: Zip Iterator**
```
Create a zip_iterator that iterates over two containers simultaneously,
yielding pairs of elements. zip(v1, v2) where v1={1,2,3}, v2={a,b,c}
yields {1,a}, {2,b}, {3,c}.
```

---

---

## 14. Extended Examples with Test Cases

### Example 1 — iterator arithmetic and category comparison

```cpp
#include <iostream>
#include <vector>
#include <list>
#include <iterator>
using namespace std;

int main() {
    vector<int> v = {10, 20, 30, 40, 50};

    // RandomAccess: arithmetic directly
    auto it = v.begin() + 3;
    cout << *it << "\n";          // 40

    cout << it - v.begin() << "\n";   // 3   (distance via subtraction)

    // advance (works for all iterator categories)
    auto it2 = v.begin();
    advance(it2, 2);
    cout << *it2 << "\n";         // 30

    // next / prev (don't modify original)
    auto it3 = next(it2, 1);
    cout << *it3 << "\n";         // 40

    auto it4 = prev(it2, 1);
    cout << *it4 << "\n";         // 20

    // For a list (BidirectionalIterator) — NO arithmetic
    list<int> lst = {10, 20, 30};
    auto lit = lst.begin();
    // lit + 2;  // COMPILE ERROR for list!
    advance(lit, 2);              // OK — works for BidirectionalIterator
    cout << *lit << "\n";         // 30

    cout << distance(lst.begin(), lit) << "\n";  // 2  (O(n) for list)

    return 0;
}
```

**Expected Output:**
```
40
3
30
40
20
30
2
```

---

### Example 2 — reverse_iterator and base()

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> v = {1, 2, 3, 4, 5};

    // rbegin → rend goes backward
    cout << "Reverse: ";
    for (auto rit = v.rbegin(); rit != v.rend(); ++rit)
        cout << *rit << " ";
    cout << "\n";  // 5 4 3 2 1

    // reverse_iterator wrapping a forward iterator
    auto rit = v.rbegin() + 2;  // points to element 3
    cout << *rit << "\n";        // 3

    // base() returns the underlying forward iterator (one PAST the element)
    auto fwd = rit.base();
    cout << *fwd << "\n";         // 4  (one past 3, so points to 4)
    cout << *(fwd - 1) << "\n";   // 3  (the element rit pointed to)

    // Erase using reverse iterator base:
    // To erase element pointed to by rit:
    v.erase((rit + 1).base());   // equivalent to erasing *rit
    for (int x : v) cout << x << " ";
    cout << "\n";  // 1 2 4 5

    return 0;
}
```

---

### Example 3 — iterator adaptors (back_inserter, istream_iterator)

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <iterator>
#include <sstream>
using namespace std;

int main() {
    // back_inserter: auto push_back while copying
    vector<int> src = {1, 2, 3, 4, 5};
    vector<int> dst;

    copy(src.begin(), src.end(), back_inserter(dst));
    for (int x : dst) cout << x << " ";
    cout << "\n";  // 1 2 3 4 5

    // copy only evens
    vector<int> evens;
    copy_if(src.begin(), src.end(), back_inserter(evens),
            [](int x){ return x % 2 == 0; });
    for (int x : evens) cout << x << " ";
    cout << "\n";  // 2 4

    // istream_iterator: read from string stream
    istringstream iss("10 20 30 40");
    vector<int> nums(istream_iterator<int>(iss), istream_iterator<int>());
    for (int x : nums) cout << x << " ";
    cout << "\n";  // 10 20 30 40

    // ostream_iterator: write to output
    copy(nums.begin(), nums.end(), ostream_iterator<int>(cout, ", "));
    cout << "\n";  // 10, 20, 30, 40,

    return 0;
}
```

---

### Example 4 — iterator invalidation demo

```cpp
#include <iostream>
#include <vector>
#include <list>
using namespace std;

int main() {
    // VECTOR: invalidation on reallocation
    vector<int> v = {1, 2, 3};
    v.reserve(10);                  // ensure no reallocation next

    auto it = v.begin() + 1;       // points to 2
    v.push_back(4);                 // NO reallocation (capacity enough)
    cout << *it << "\n";            // 2 — still valid

    // Now force reallocation
    vector<int> v2 = {1, 2, 3};    // capacity = 3
    auto it2 = v2.begin() + 1;
    v2.push_back(4);               // REALLOCATION — it2 now INVALID!
    // cout << *it2;               // UNDEFINED BEHAVIOR — don't do this

    // LIST: never invalidated by insert/erase (except erased node)
    list<int> lst = {1, 2, 3};
    auto lit = lst.begin();
    ++lit;                          // points to 2
    lst.push_back(99);
    lst.push_front(0);
    cout << *lit << "\n";           // 2 — still valid!

    return 0;
}
```

---

### Example 5 — const_iterator and cbegin/cend

```cpp
#include <iostream>
#include <vector>
using namespace std;

void printRange(const vector<int>& v) {
    // const container → begin() returns const_iterator
    for (auto it = v.begin(); it != v.end(); ++it)
        cout << *it << " ";
    // *it = 99; // COMPILE ERROR — const_iterator prevents modification
    cout << "\n";
}

int main() {
    vector<int> v = {5, 3, 1, 4, 2};
    printRange(v);  // 5 3 1 4 2

    // Explicit const_iterator on non-const container
    for (auto it = v.cbegin(); it != v.cend(); ++it)
        cout << *it << " ";
    cout << "\n";  // 5 3 1 4 2

    // Why use cbegin? Prevents accidental modification
    // auto it = v.begin(); *it = 0;  // Compiles
    // auto it = v.cbegin(); *it = 0; // COMPILE ERROR

    return 0;
}
```

---

## 15. Tricky MCQs — Expert Level

**Q1. What is `*(v.rbegin())` for `vector<int> v = {1,2,3,4,5}`?**
- A) 1
- B) 5 ✅
- C) Undefined behavior
- D) Address of last element

---

**Q2. `advance(it, -3)` on a ForwardIterator:**
- A) Moves forward 3 steps
- B) Moves backward 3 steps
- C) Undefined behavior ✅ (ForwardIterator cannot move backward)
- D) Compilation error

> **Why:** Negative advance is only valid for BidirectionalIterator and RandomAccessIterator.

---

**Q3. What does `std::prev(v.end())` return for a non-empty vector?**
- A) Iterator before begin
- B) Iterator to last element ✅
- C) Copy of end iterator
- D) Undefined behavior

---

**Q4. Which iterator operation takes O(n) for `std::list`?**
- A) `++it` (increment)
- B) `--it` (decrement)
- C) `distance(it1, it2)` ✅
- D) `*it` (dereference)

---

**Q5. Inserting into a `vector` at position `it` invalidates:**
- A) Only `it`
- B) Only iterators after `it`
- C) All iterators if reallocation occurs; otherwise only `it` and after ✅
- D) No iterators

---

**Q6. Can a `const_iterator` and an `iterator` be compared with `==`?**
- A) No, type mismatch prevents comparison
- B) Yes, they are comparable ✅ (implicit conversion of iterator to const_iterator)
- C) Only with explicit cast
- D) Only on RandomAccess containers

---

**Q7. What is printed?**
```cpp
vector<int> v = {1,2,3,4,5};
auto it = v.begin();
cout << *(it + 2) << " " << *(2 + it);
```
- A) `3 3` ✅
- B) `2 3`
- C) Compilation error
- D) `3 4`

> **Why:** `it + 2` and `2 + it` are both pointer arithmetic — commutative for RandomAccess iterators.

---

**Q8. `back_inserter` works by calling:**
- A) `push_front()`
- B) `push_back()` ✅
- C) `insert(end(), ...)`
- D) `emplace_back()`

---

**Q9. Which statement is TRUE about erasing from a `std::set` while iterating?**
- A) Iterating and erasing in range-for is always safe
- B) You must use the iterator returned by `erase` ✅
- C) All iterators are invalidated after any erase
- D) Only `const_iterator` can be used for safe iteration

---

**Q10. `std::move_iterator` is used to:**
- A) Move the iterator to a different container
- B) Dereference returns an rvalue, enabling move semantics ✅
- C) Move elements physically to a different location
- D) Skip elements during iteration

---

**Q11. What is the difference between `v.end()` and `v.cend()`?**
- A) `cend()` points one element before `end()`
- B) They are identical for `const` containers
- C) `cend()` always returns `const_iterator`; `end()` returns `iterator` for non-const container ✅
- D) `cend()` is not a standard function

---

**Q12. The `Contiguous Iterator` category (C++17) adds which guarantee over RandomAccess?**
- A) O(1) `size()`
- B) That elements are stored in contiguous memory ✅
- C) That elements can be moved in O(1)
- D) That `++` is O(1) amortized

---

> **Previous:** [06_STL_Algorithms.md](06_STL_Algorithms.md)  
> **Next:** [08_STL_Functional_and_Lambdas.md](08_STL_Functional_and_Lambdas.md)
