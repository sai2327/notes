# 📘 Chapter 1: STL Fundamentals — The Complete Foundation

> **From Zero to Hero: Understanding the backbone of Modern C++**

---

## Table of Contents

- [1. What is STL?](#1-what-is-stl)
- [2. History of STL](#2-history-of-stl)
- [3. Why STL is Powerful](#3-why-stl-is-powerful)
- [4. Components of STL](#4-components-of-stl)
- [5. STL Architecture Deep Dive](#5-stl-architecture-deep-dive)
  - [5.1 Containers](#51-containers)
  - [5.2 Iterators](#52-iterators)
  - [5.3 Algorithms](#53-algorithms)
  - [5.4 Function Objects (Functors)](#54-function-objects-functors)
  - [5.5 Allocators](#55-allocators)
- [6. Important Basics](#6-important-basics)
  - [6.1 pair](#61-pair)
  - [6.2 tuple](#62-tuple)
  - [6.3 utility Header](#63-utility-header)
  - [6.4 Iterators in Detail](#64-iterators-in-detail)
  - [6.5 begin / end / rbegin / rend](#65-begin--end--rbegin--rend)
  - [6.6 Iterator Categories](#66-iterator-categories)
- [7. Complexity Rules in STL](#7-complexity-rules-in-stl)
- [8. STL Container Comparison Table](#8-stl-container-comparison-table)
- [9. Common Mistakes](#9-common-mistakes)
- [10. Interview Tips](#10-interview-tips)
- [11. Competitive Programming Tips](#11-competitive-programming-tips)
- [12. Edge Cases](#12-edge-cases)
- [13. Summary](#13-summary)
- [14. Practice Section](#14-practice-section)

---

## 1. What is STL?

The **Standard Template Library (STL)** is a collection of **generic classes and functions** that implement many popular and commonly used data structures and algorithms. It is part of the C++ Standard Library.

### Key Characteristics

| Feature           | Description                                |
| ----------------- | ------------------------------------------ |
| **Generic**       | Works with any data type via templates     |
| **Efficient**     | Designed with strict complexity guarantees |
| **Reusable**      | Write once, use with any type              |
| **Interoperable** | Components work seamlessly together        |
| **Standardized**  | Consistent across all compliant compilers  |

### The Core Idea

STL separates **data** (Containers) from **operations** (Algorithms) using an abstraction layer called **Iterators**. This decoupling is the genius of STL.

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Containers  │ ──► │  Iterators   │ ◄── │  Algorithms  │
│ (store data) │     │  (glue)      │     │ (process)    │
└──────────────┘     └──────────────┘     └──────────────┘
```

Without STL, if you had `M` containers and `N` algorithms, you would need `M × N` implementations. With STL iterators as an abstraction, you only need `M + N` implementations.

---

## 2. History of STL

| Year | Event                                                                            |
| ---- | -------------------------------------------------------------------------------- |
| 1979 | Alexander Stepanov begins work on generic programming concepts                   |
| 1987 | Stepanov and Musser publish early papers on generic programming                  |
| 1992 | Stepanov and Meng Lee develop the first STL at HP Labs                           |
| 1994 | STL accepted into the C++ Standard (C++98) by the ANSI/ISO committee             |
| 1998 | C++98 released — STL is officially part of the standard                          |
| 2003 | C++03 — minor corrections                                                        |
| 2011 | C++11 — massive STL additions: `unordered_map`, `array`, move semantics, lambdas |
| 2014 | C++14 — generic lambdas, `make_unique`                                           |
| 2017 | C++17 — `optional`, `variant`, `any`, `string_view`, parallel algorithms         |
| 2020 | C++20 — Ranges, Concepts, `std::span`, `std::format`                             |
| 2023 | C++23 — `std::flat_map`, `std::expected`, `std::mdspan`                          |

### Key People

- **Alexander Stepanov** — Father of STL, invented the concept of generic programming
- **Meng Lee** — Co-developer of the original STL at HP Labs
- **David Musser** — Co-researcher on generic programming foundations
- **Andrew Koenig** — Advocated STL inclusion in the C++ Standard

---

## 3. Why STL is Powerful

### 3.1 Performance Guarantees

Every STL operation has a **specified complexity** in the standard. This is not just a guideline — compiler vendors **must** meet these guarantees.

```cpp
// Guaranteed O(n log n) worst case
std::sort(v.begin(), v.end());

// Guaranteed O(log n) lookup
auto it = my_set.find(42);

// Guaranteed O(1) amortized push_back
v.push_back(10);
```

### 3.2 Type Safety with Templates

```cpp
std::vector<int> numbers;        // Only integers allowed
std::map<string, double> prices; // String keys, double values
// numbers.push_back("hello");   // COMPILE ERROR — type safety!
```

### 3.3 Zero-Cost Abstractions

STL uses templates which are **resolved at compile time**. There is no runtime overhead compared to hand-written C code.

```cpp
// This STL code:
std::sort(arr.begin(), arr.end());

// Compiles to assembly nearly identical to:
// A hand-written introsort implementation
```

### 3.4 Code Brevity

```cpp
// Without STL: Manual binary search (15+ lines)
// With STL: One line
bool found = std::binary_search(v.begin(), v.end(), target);
```

### 3.5 Portability

STL code compiles identically on GCC, Clang, MSVC, and any conforming compiler.

---

## 4. Components of STL

```
┌─────────────────────────────────────────────────────────┐
│                     STL Architecture                     │
├───────────┬───────────┬───────────┬──────────┬──────────┤
│ Containers│ Iterators │Algorithms │ Functors │Allocators│
│           │           │           │          │          │
│ vector    │ input     │ sort      │ less<>   │ default  │
│ list      │ output    │ find      │ greater<>│ custom   │
│ map       │ forward   │ count     │ plus<>   │ pool     │
│ set       │ bidir     │ transform │ lambda   │ arena    │
│ deque     │ random    │ accumulate│ bind     │          │
│ ...       │ access    │ ...       │ ...      │          │
└───────────┴───────────┴───────────┴──────────┴──────────┘
```

### 4.1 Containers (Store Data)

| Category        | Containers                                         | Key Property                               |
| --------------- | -------------------------------------------------- | ------------------------------------------ |
| **Sequence**    | `vector`, `deque`, `list`, `forward_list`, `array` | Ordered by insertion                       |
| **Associative** | `set`, `multiset`, `map`, `multimap`               | Sorted by key (Red-Black Tree)             |
| **Unordered**   | `unordered_set`, `unordered_map`, etc.             | Hash-based, O(1) average lookup            |
| **Adapters**    | `stack`, `queue`, `priority_queue`                 | Restricted interface over other containers |

### 4.2 Iterators (Access Data)

Generalized pointers that provide a uniform way to traverse containers.

### 4.3 Algorithms (Process Data)

Over 100+ algorithms: sorting, searching, transforming, accumulating, etc.

### 4.4 Function Objects / Functors

Objects that can be called like functions. Used to customize algorithms.

### 4.5 Allocators

Control memory allocation. Default allocator uses `new`/`delete`.

---

## 5. STL Architecture Deep Dive

### 5.1 Containers

Containers **own** their elements. When a container is destroyed, all its elements are destroyed.

#### Container Requirements

Every STL container provides:

```cpp
container::value_type      // Type of elements
container::iterator        // Iterator type
container::const_iterator  // Const iterator type
container::size_type       // Unsigned integer type (usually size_t)

container.begin()          // Iterator to first element
container.end()            // Iterator past last element
container.size()           // Number of elements
container.empty()          // Whether container is empty
container.clear()          // Remove all elements
```

#### Container Categories Diagram

```
                        Container
                       /    |     \
                      /     |      \
            Sequence  Associative  Unordered
            /  |  \      / | \       / | \
         vector| deque set | map  u_set| u_map
              list    mset mmap  u_mset u_mmap
           fwd_list
             array
```

### 5.2 Iterators

Iterators are the **bridge** between containers and algorithms.

```cpp
std::vector<int> v = {3, 1, 4, 1, 5};

// Iterator usage
for (auto it = v.begin(); it != v.end(); ++it) {
    std::cout << *it << " ";
}

// Algorithms use iterators
std::sort(v.begin(), v.end());  // Sorts [begin, end)
```

#### Iterator Hierarchy

```
        Random Access Iterator
              ↑
      Bidirectional Iterator
              ↑
        Forward Iterator
            ↑    ↑
    Input Iterator  Output Iterator
```

Each level **inherits** all capabilities of the level below it.

### 5.3 Algorithms

Algorithms are **function templates** that operate on ranges defined by iterators.

```cpp
#include <algorithm>  // Most algorithms
#include <numeric>    // accumulate, iota, etc.

std::vector<int> v = {5, 2, 8, 1, 9};

// Non-modifying
int cnt = std::count(v.begin(), v.end(), 5);         // count occurrences
auto it = std::find(v.begin(), v.end(), 8);           // find element

// Modifying
std::sort(v.begin(), v.end());                        // sort ascending
std::reverse(v.begin(), v.end());                     // reverse
std::fill(v.begin(), v.end(), 0);                     // fill with value

// Numeric
int sum = std::accumulate(v.begin(), v.end(), 0);     // sum elements
```

### 5.4 Function Objects (Functors)

A functor is a class/struct that overloads `operator()`.

```cpp
#include <functional>

// Built-in functors
std::less<int>()       // a < b
std::greater<int>()    // a > b
std::plus<int>()       // a + b
std::multiplies<int>() // a * b

// Usage: sort descending
std::sort(v.begin(), v.end(), std::greater<int>());

// Custom functor
struct AbsCompare {
    bool operator()(int a, int b) const {
        return std::abs(a) < std::abs(b);
    }
};
std::sort(v.begin(), v.end(), AbsCompare());

// Lambda (modern alternative)
std::sort(v.begin(), v.end(), [](int a, int b) {
    return std::abs(a) < std::abs(b);
});
```

### 5.5 Allocators

Allocators control how memory is allocated and deallocated for containers.

```cpp
// Default allocator (used implicitly)
std::vector<int, std::allocator<int>> v;  // Same as std::vector<int>

// How default allocator works internally:
// allocate(n)   → calls ::operator new(n * sizeof(T))
// deallocate(p) → calls ::operator delete(p)
// construct(p)  → calls placement new
// destroy(p)    → calls p->~T()
```

#### Custom Allocator Example

```cpp
template <typename T>
struct ArenaAllocator {
    using value_type = T;
    
    ArenaAllocator() = default;
    
    T* allocate(std::size_t n) {
        // Allocate from a pre-allocated memory pool
        return static_cast<T*>(arena_alloc(n * sizeof(T)));
    }
    
    void deallocate(T* p, std::size_t n) noexcept {
        // Arena deallocates all at once, so this is a no-op
    }
};
```

**When are custom allocators useful?**
- High-frequency trading systems (pool allocators)
- Game engines (stack allocators)
- Embedded systems (fixed-size allocators)
- Avoiding memory fragmentation

---

## 6. Important Basics

### 6.1 pair

`std::pair` stores **two heterogeneous values**.

#### Header
```cpp
#include <utility>  // or any container header that includes it
```

#### Internal Structure
```cpp
// Simplified internal implementation
template <typename T1, typename T2>
struct pair {
    T1 first;
    T2 second;
    
    pair() : first(), second() {}
    pair(const T1& a, const T2& b) : first(a), second(b) {}
};
```

#### Creation Methods

```cpp
// Method 1: Constructor
std::pair<int, string> p1(1, "hello");

// Method 2: make_pair (auto deduces types)
auto p2 = std::make_pair(1, "hello");

// Method 3: Brace initialization (C++11)
std::pair<int, string> p3 = {1, "hello"};

// Method 4: Structured bindings (C++17)
auto [id, name] = std::make_pair(1, "hello");
```

#### Key Operations

```cpp
std::pair<int, int> a = {3, 5};
std::pair<int, int> b = {3, 7};

// Access
a.first;    // 3
a.second;   // 5

// Comparison (lexicographic: first, then second)
a < b;      // true  (3==3, then 5 < 7)
a == b;     // false

// Swap
a.swap(b);  // Swaps contents

// Tie (unpack into variables)
int x, y;
std::tie(x, y) = a;  // x = 3, y = 5
```

#### Competitive Programming Usage

```cpp
// Storing edges: (weight, node)
std::vector<std::pair<int, int>> edges;
edges.push_back({5, 2});  // weight=5, to node 2

// Sorting by first, then second automatically
std::sort(edges.begin(), edges.end());

// Trick: To sort by second first, swap the order
// Store as (second_value, first_value)
std::vector<std::pair<int, int>> events;
events.push_back({end_time, start_time});
std::sort(events.begin(), events.end());  // Sorts by end_time
```

#### Memory Layout

```
┌─────────────────────────────┐
│        pair<int, int>       │
├──────────────┬──────────────┤
│    first     │   second     │
│   (4 bytes)  │  (4 bytes)   │
├──────────────┴──────────────┤
│      Total: 8 bytes         │
└─────────────────────────────┘

┌─────────────────────────────────┐
│     pair<int, double>           │
├──────────────┬──────────────────┤
│    first     │ (4 byte padding) │
│   (4 bytes)  │  + second(8 B)  │
├──────────────┴──────────────────┤
│   Total: 16 bytes (with padding)│
└─────────────────────────────────┘
```

---

### 6.2 tuple

`std::tuple` stores a **fixed-size collection of heterogeneous values**.

#### Header
```cpp
#include <tuple>
```

#### Creation

```cpp
// Method 1: Constructor
std::tuple<int, double, std::string> t1(1, 3.14, "hello");

// Method 2: make_tuple
auto t2 = std::make_tuple(1, 3.14, "hello");

// Method 3: Brace initialization (C++17 with deduction guides)
std::tuple t3(1, 3.14, "hello");  // CTAD
```

#### Access

```cpp
auto t = std::make_tuple(42, 3.14, "test");

// get<index>
std::get<0>(t);  // 42
std::get<1>(t);  // 3.14
std::get<2>(t);  // "test"

// get<type> (C++14, only if types are unique)
std::get<int>(t);         // 42
std::get<double>(t);      // 3.14
std::get<const char*>(t); // "test"

// Structured bindings (C++17)
auto [a, b, c] = t;  // a=42, b=3.14, c="test"

// tie (unpacking)
int x;
double y;
std::string z;
std::tie(x, y, z) = t;

// Ignore some values with std::ignore
std::tie(x, std::ignore, z) = t;  // Only get x and z
```

#### Tuple Operations

```cpp
// Size at compile time
constexpr auto sz = std::tuple_size<decltype(t)>::value;  // 3

// Element type at compile time
using T0 = std::tuple_element<0, decltype(t)>::type;  // int

// Comparison (lexicographic)
auto a = std::make_tuple(1, 2, 3);
auto b = std::make_tuple(1, 2, 4);
a < b;  // true

// Concatenation
auto combined = std::tuple_cat(a, b);  // (1,2,3,1,2,4)
```

#### Competitive Programming Usage

```cpp
// Storing 3D coordinates
std::vector<std::tuple<int, int, int>> points;
points.push_back({1, 2, 3});

// Sorting by multiple keys automatically (lexicographic)
std::sort(points.begin(), points.end());

// Using with maps
std::map<std::tuple<int, int>, int> grid;
grid[{x, y}] = value;

// Trick: tuple comparison for multi-key sorting
// Sort by: priority DESC, time ASC, id ASC
std::vector<std::tuple<int, int, int>> tasks;
// Store as (-priority, time, id) — negate to reverse sort order
for (auto& [p, t, id] : tasks_raw) {
    tasks.push_back({-p, t, id});
}
std::sort(tasks.begin(), tasks.end());
```

#### pair vs tuple

| Feature     | pair                | tuple           |
| ----------- | ------------------- | --------------- |
| Elements    | Exactly 2           | Any number      |
| Access      | `.first`, `.second` | `std::get<N>()` |
| Readability | More readable       | Less readable   |
| Performance | Slightly faster     | Slightly slower |
| Header      | `<utility>`         | `<tuple>`       |
| CP Usage    | Very common         | Less common     |

> **Tip:** Prefer `pair` when you have exactly 2 values. The `.first`/`.second` syntax is faster to type in competitive programming.

---

### 6.3 utility Header

The `<utility>` header provides several fundamental utilities:

```cpp
#include <utility>

// std::move — cast to rvalue reference
std::string s = "hello";
std::string s2 = std::move(s);  // s is now empty, s2 owns "hello"

// std::swap — swap two values
int a = 1, b = 2;
std::swap(a, b);  // a=2, b=1

// std::forward — perfect forwarding in templates
template <typename T>
void wrapper(T&& arg) {
    target(std::forward<T>(arg));
}

// std::exchange (C++14) — replace and return old value
int old = std::exchange(a, 5);  // old=2, a=5

// std::declval — get reference to type without constructing
// Used in SFINAE and type traits
using RetType = decltype(std::declval<MyClass>().method());

// std::as_const (C++17)
auto& const_ref = std::as_const(a);  // const int&

// Integer comparison (C++20)
std::cmp_less(-1, 1u);    // true (handles sign correctly)
std::cmp_greater(1u, -1); // true
// Note: (-1 < 1u) is FALSE in raw C++ due to implicit conversion!
```

---

### 6.4 Iterators in Detail

An **iterator** is a generalized pointer that provides a uniform interface to traverse containers.

#### Why Iterators?

```
Without iterators:
  sort_vector(), sort_list(), sort_deque() — N algorithms × M containers

With iterators:
  sort(begin, end) — works with ANY container that provides random access iterators
```

#### Basic Iterator Usage

```cpp
std::vector<int> v = {10, 20, 30, 40, 50};

// Forward traversal
for (auto it = v.begin(); it != v.end(); ++it) {
    std::cout << *it << " ";  // Dereference like a pointer
}

// Reverse traversal
for (auto it = v.rbegin(); it != v.rend(); ++it) {
    std::cout << *it << " ";
}

// Iterator arithmetic (random access only)
auto it = v.begin();
it += 3;           // Jump 3 positions
int dist = it - v.begin();  // Distance = 3
auto next_it = std::next(it);     // Next position
auto prev_it = std::prev(it);     // Previous position
auto adv_it = v.begin();
std::advance(adv_it, 3);          // Move 3 positions (modifies in place)
```

#### Iterator Operations Table

| Operation           | Input | Output | Forward | Bidirectional | Random Access |
| ------------------- | ----- | ------ | ------- | ------------- | ------------- |
| `*it` (read)        | ✅     |        | ✅       | ✅             | ✅             |
| `*it = val` (write) |       | ✅      | ✅       | ✅             | ✅             |
| `++it`              | ✅     | ✅      | ✅       | ✅             | ✅             |
| `--it`              |       |        |         | ✅             | ✅             |
| `it + n`            |       |        |         |               | ✅             |
| `it - n`            |       |        |         |               | ✅             |
| `it1 - it2`         |       |        |         |               | ✅             |
| `it[n]`             |       |        |         |               | ✅             |
| `it1 < it2`         |       |        |         |               | ✅             |
| `it1 == it2`        | ✅     |        | ✅       | ✅             | ✅             |
| Multi-pass          |       |        | ✅       | ✅             | ✅             |

---

### 6.5 begin / end / rbegin / rend

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};

// Forward iterators
v.begin();   // Points to first element (1)
v.end();     // Points PAST last element (after 5)

// Reverse iterators
v.rbegin();  // Points to last element (5)
v.rend();    // Points BEFORE first element (before 1)

// Const versions (cannot modify elements)
v.cbegin();  // const_iterator to first
v.cend();    // const_iterator past last
v.crbegin(); // const_reverse_iterator to last
v.crend();   // const_reverse_iterator before first
```

#### Visual Representation

```
            begin()                    end()
              ↓                          ↓
        ┌─────┬─────┬─────┬─────┬─────┬─────┐
        │  1  │  2  │  3  │  4  │  5  │  ?  │
        └─────┴─────┴─────┴─────┴─────┴─────┘
              ↑                    ↑
           rend()              rbegin()
```

#### Free Function Versions (C++11)

```cpp
// These work with arrays too!
int arr[] = {1, 2, 3, 4, 5};

std::begin(arr);   // &arr[0]
std::end(arr);     // &arr[5]

// Also work with containers
std::begin(v);     // v.begin()
std::end(v);       // v.end()

// Useful in templates that must work with both arrays and containers
template <typename Container>
void print(const Container& c) {
    for (auto it = std::begin(c); it != std::end(c); ++it) {
        std::cout << *it << " ";
    }
}
```

---

### 6.6 Iterator Categories

#### Hierarchy

```
┌─────────────────────────────────┐
│      Random Access Iterator     │  vector, deque, array
│  (all operations, O(1) jump)    │
├─────────────────────────────────┤
│    Bidirectional Iterator       │  list, set, map
│  (forward + backward)           │
├─────────────────────────────────┤
│       Forward Iterator          │  forward_list, unordered_set/map
│  (forward only, multi-pass)     │
├─────────────────────────────────┤
│  Input Iterator │ Output Iterator│  istream_iterator, ostream_iterator
│  (read once)    │ (write once)   │
└─────────────────────────────────┘
```

#### Which Container Gives Which Iterator?

| Container                         | Iterator Category | Key Implication                          |
| --------------------------------- | ----------------- | ---------------------------------------- |
| `vector`                          | Random Access     | Can use `sort()`, `[]`                   |
| `deque`                           | Random Access     | Can use `sort()`, `[]`                   |
| `array`                           | Random Access     | Can use `sort()`, `[]`                   |
| `list`                            | Bidirectional     | Cannot use `sort()` (use `list::sort()`) |
| `forward_list`                    | Forward           | Only `++`, no `--`                       |
| `set` / `map`                     | Bidirectional     | Can traverse both ways                   |
| `unordered_set` / `unordered_map` | Forward           | Only forward traversal                   |
| `stack` / `queue`                 | **None**          | No iterators!                            |

#### Why Does This Matter?

```cpp
std::list<int> lst = {5, 3, 1, 4, 2};

// COMPILE ERROR: std::sort needs Random Access iterators
// std::sort(lst.begin(), lst.end());

// Solution: use member function
lst.sort();  // Uses merge sort internally

// std::advance adapts to iterator type
std::list<int>::iterator it = lst.begin();
std::advance(it, 3);  // O(n) for list, O(1) for vector

// std::distance
auto d = std::distance(lst.begin(), lst.end());  // O(n) for list
```

---

## 7. Complexity Rules in STL

### The Standard's Guarantees

| Notation   | Meaning      | Example                         |
| ---------- | ------------ | ------------------------------- |
| O(1)       | Constant     | `vector::push_back` (amortized) |
| O(log n)   | Logarithmic  | `set::find`, `map::insert`      |
| O(n)       | Linear       | `vector::insert` at beginning   |
| O(n log n) | Linearithmic | `std::sort`                     |

### Container Operation Complexity Summary

| Operation     | vector     | deque      | list         | set/map      | unordered    |
| ------------- | ---------- | ---------- | ------------ | ------------ | ------------ |
| Access `[i]`  | O(1)       | O(1)       | O(n)         | O(log n)     | O(1) avg     |
| Insert front  | O(n)       | **O(1)**   | O(1)         | O(log n)     | O(1) avg     |
| Insert back   | **O(1)\*** | O(1)       | O(1)         | O(log n)     | O(1) avg     |
| Insert middle | O(n)       | O(n)       | **O(1)\*\*** | O(log n)     | O(1) avg     |
| Erase front   | O(n)       | O(1)       | O(1)         | O(log n)     | O(1) avg     |
| Erase back    | O(1)       | O(1)       | O(1)         | O(log n)     | O(1) avg     |
| Find          | O(n)       | O(n)       | O(n)         | **O(log n)** | **O(1)** avg |
| Sort          | O(n log n) | O(n log n) | O(n log n)   | N/A (sorted) | N/A          |

> `*` amortized  
> `**` O(1) if you have an iterator to the position; O(n) to find the position first

### Important Complexity Notes

1. **Amortized O(1)** for `vector::push_back` means most operations are O(1), but occasionally O(n) when reallocation happens. Over n operations, the total cost is O(n), so average per operation is O(1).

2. **Worst case for unordered containers** is O(n) — when all elements hash to the same bucket. This can be exploited in competitive programming (anti-hash tests).

3. **`std::sort`** uses **IntroSort** (hybrid of QuickSort + HeapSort + InsertionSort), guaranteeing O(n log n) worst case.

4. **Constant factors** matter! `unordered_map` has higher constant factors than `map` for small sizes due to hashing overhead.

### The Rule of Thumb

```
Need sorted order?        → set / map      O(log n)
Need fastest lookup?      → unordered_map  O(1) average
Need ordered sequence?    → vector         O(1) random access
Need fast front/back?     → deque          O(1) both ends
Need fast middle insert?  → list           O(1) with iterator
```

---

## 8. STL Container Comparison Table

### Complete Comparison

| Feature               | vector     | deque   | list       | forward_list | array      |
| --------------------- | ---------- | ------- | ---------- | ------------ | ---------- |
| Memory                | Contiguous | Chunked | Node-based | Node-based   | Contiguous |
| Random Access         | ✅ O(1)     | ✅ O(1)  | ❌ O(n)     | ❌ O(n)       | ✅ O(1)     |
| Push Front            | ❌ O(n)     | ✅ O(1)  | ✅ O(1)     | ✅ O(1)       | ❌ N/A      |
| Push Back             | ✅ O(1)*    | ✅ O(1)  | ✅ O(1)     | ❌ N/A        | ❌ N/A      |
| Insert Middle         | ❌ O(n)     | ❌ O(n)  | ✅ O(1)     | ✅ O(1)       | ❌ N/A      |
| Cache Friendly        | ✅✅✅        | ✅✅      | ❌          | ❌            | ✅✅✅        |
| Size Overhead         | Low        | Medium  | High       | Medium       | None       |
| Iterator Invalidation | On realloc | Complex | ✅ Stable   | ✅ Stable     | N/A        |
| Resizable             | ✅          | ✅       | ✅          | ✅            | ❌          |

| Feature           | set          | map          | unordered_set | unordered_map |
| ----------------- | ------------ | ------------ | ------------- | ------------- |
| Underlying        | RB Tree      | RB Tree      | Hash Table    | Hash Table    |
| Ordered           | ✅            | ✅            | ❌             | ❌             |
| Find              | O(log n)     | O(log n)     | O(1) avg      | O(1) avg      |
| Insert            | O(log n)     | O(log n)     | O(1) avg      | O(1) avg      |
| Memory            | Higher       | Higher       | Higher        | Higher        |
| Custom Order      | ✅ Comparator | ✅ Comparator | Custom Hash   | Custom Hash   |
| Lower/Upper Bound | ✅            | ✅            | ❌             | ❌             |

---

## 9. Common Mistakes

### Mistake 1: Modifying Container During Iteration

```cpp
// ❌ WRONG: Iterator invalidation
std::vector<int> v = {1, 2, 3, 4, 5};
for (auto it = v.begin(); it != v.end(); ++it) {
    if (*it % 2 == 0) {
        v.erase(it);  // Iterator invalidated!
    }
}

// ✅ CORRECT: Use return value of erase
for (auto it = v.begin(); it != v.end(); ) {
    if (*it % 2 == 0) {
        it = v.erase(it);  // erase returns next valid iterator
    } else {
        ++it;
    }
}

// ✅ BETTER: Use erase-remove idiom
v.erase(std::remove_if(v.begin(), v.end(), 
    [](int x) { return x % 2 == 0; }), v.end());

// ✅ BEST (C++20): std::erase_if
std::erase_if(v, [](int x) { return x % 2 == 0; });
```

### Mistake 2: Using `[]` on map Creates Elements

```cpp
std::map<string, int> m;
// ❌ This INSERTS a default entry!
if (m["key"] == 0) { /* ... */ }  // Now m has {"key": 0}

// ✅ Use find() or count()
if (m.find("key") != m.end()) { /* ... */ }
if (m.count("key")) { /* ... */ }

// ✅ Or contains() (C++20)
if (m.contains("key")) { /* ... */ }
```

### Mistake 3: Forgetting `end()` is Past-the-End

```cpp
std::vector<int> v = {1, 2, 3};
auto it = v.end();
// ❌ UNDEFINED BEHAVIOR: Dereferencing end()
// std::cout << *it;

// ✅ Always check before dereferencing
auto it2 = v.find(5);
if (it2 != v.end()) {
    std::cout << *it2;
}
```

### Mistake 4: Integer Overflow with size()

```cpp
std::vector<int> v;
// ❌ v.size() returns size_t (unsigned). If v is empty:
// v.size() - 1 = 18446744073709551615 (underflow!)
for (int i = 0; i < v.size() - 1; i++) { /* ... */ }

// ✅ Cast or use int
for (int i = 0; i + 1 < (int)v.size(); i++) { /* ... */ }
```

### Mistake 5: Invalidated References After push_back

```cpp
std::vector<int> v = {1, 2, 3};
int& ref = v[0];
v.push_back(4);    // May invalidate ref if reallocation happens!
// ❌ ref may be dangling now
std::cout << ref;   // UNDEFINED BEHAVIOR!
```

---

## 10. Interview Tips

### Top Questions

1. **Q: What's the difference between `map` and `unordered_map`?**
   - `map`: Red-Black Tree, O(log n), ordered, uses `<` operator
   - `unordered_map`: Hash Table, O(1) average, unordered, uses hash function

2. **Q: When would you choose `deque` over `vector`?**
   - When you need efficient insertion/removal at both front and back
   - When you don't need guaranteed contiguous memory
   - `deque` doesn't invalidate pointers on push_front/push_back (unless inserting in middle)

3. **Q: What is iterator invalidation?**
   - Operations that make existing iterators point to invalid memory
   - Vector: any reallocation invalidates ALL iterators
   - Map/Set: only erase invalidates the erased iterator
   - List: only erase invalidates the erased iterator

4. **Q: What's the complexity of `vector::push_back`?**
   - **Amortized O(1)**: The vector doubles capacity when full. The doubling strategy ensures that over n operations, total cost is O(n), giving O(1) amortized per operation.

5. **Q: How does `std::sort` work internally?**
   - **IntroSort**: Starts with QuickSort, switches to HeapSort if recursion depth exceeds 2*log(n), and uses InsertionSort for small ranges (< 16 elements).

---

## 11. Competitive Programming Tips

### Essential Setup

```cpp
#include <bits/stdc++.h>  // Include everything
using namespace std;

// Fast I/O
ios_base::sync_with_stdio(false);
cin.tie(NULL);

// Type aliases
typedef long long ll;
typedef pair<int, int> pii;
typedef vector<int> vi;
typedef vector<pii> vpii;

#define all(x) (x).begin(), (x).end()
#define sz(x) (int)(x).size()
#define pb push_back
#define mp make_pair
#define F first
#define S second
```

### Quick Tricks

```cpp
// 1. Read entire array quickly
int n;
cin >> n;
vector<int> a(n);
for (auto& x : a) cin >> x;

// 2. Sort + unique (remove duplicates)
sort(all(a));
a.erase(unique(all(a)), a.end());

// 3. Frequency counting
map<int, int> freq;
for (int x : a) freq[x]++;

// 4. Max element
int mx = *max_element(all(a));

// 5. Sum of elements
long long sum = accumulate(all(a), 0LL);  // Note: 0LL for long long

// 6. Check if sorted
bool sorted = is_sorted(all(a));

// 7. Binary search
sort(all(a));
bool found = binary_search(all(a), target);

// 8. Lower bound (first element >= target)
auto it = lower_bound(all(a), target);

// 9. Next permutation
sort(all(a));
do {
    // process permutation
} while (next_permutation(all(a)));

// 10. Rotate
rotate(a.begin(), a.begin() + k, a.end());  // Left rotate by k
```

---

## 12. Edge Cases

### Empty Container Operations

```cpp
std::vector<int> v;
v.front();    // ❌ UB on empty vector
v.back();     // ❌ UB on empty vector
v.pop_back(); // ❌ UB on empty vector
v[0];         // ❌ UB on empty vector
v.at(0);      // ✅ Throws std::out_of_range

// Always check
if (!v.empty()) {
    v.front();  // Safe
}
```

### Size/Capacity Confusion

```cpp
std::vector<int> v;
v.reserve(100);
v.size();      // 0 (number of elements)
v.capacity();  // >= 100 (allocated memory)
```

### Iterator to End

```cpp
std::set<int> s = {1, 2, 3};
auto it = s.end();
--it;           // ✅ Points to 3 (last element)
// But *s.end() is UB!
```

### Negative Values with size_t

```cpp
std::vector<int> v = {1, 2, 3};
// v.size() - 5 doesn't give -2, it gives a huge positive number!
// Always cast to int for arithmetic with potentially negative results
```

---

## 13. Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                        STL SUMMARY                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  STL = Containers + Iterators + Algorithms + Functors            │
│                                                                  │
│  CONTAINERS:                                                     │
│    Sequence:    vector, deque, list, forward_list, array         │
│    Associative: set, multiset, map, multimap                     │
│    Unordered:   unordered_set, unordered_map, ...               │
│    Adapters:    stack, queue, priority_queue                      │
│                                                                  │
│  ITERATORS: Input→Output→Forward→Bidirectional→Random Access    │
│                                                                  │
│  KEY UTILITIES: pair, tuple, move, swap                          │
│                                                                  │
│  COMPLEXITY GUARANTEES: Built into the standard!                 │
│                                                                  │
│  GOLDEN RULE: Know WHAT to use and WHEN to use it.              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 14. Practice Section

### Level 1 — Quick Concept Questions

1. **Q: What are the three main components of STL?**
   <details><summary>Answer</summary>Containers, Iterators, and Algorithms</details>

2. **Q: What does `v.end()` point to?**
   <details><summary>Answer</summary>One position PAST the last element (past-the-end iterator)</details>

3. **Q: What is the time complexity of `std::sort`?**
   <details><summary>Answer</summary>O(n log n) worst case (uses IntroSort)</details>

4. **Q: How do you access the first element of a pair `p`?**
   <details><summary>Answer</summary>`p.first`</details>

5. **Q: What header includes `std::pair`?**
   <details><summary>Answer</summary>`<utility>` (also included by most container headers)</details>

6. **Q: What iterator category does `std::vector` provide?**
   <details><summary>Answer</summary>Random Access Iterator</details>

7. **Q: What is the amortized complexity of `vector::push_back()`?**
   <details><summary>Answer</summary>O(1) amortized</details>

8. **Q: Can you use `std::sort()` on a `std::list`?**
   <details><summary>Answer</summary>No, `std::sort` requires Random Access iterators. Use `list::sort()` instead.</details>

9. **Q: What does `std::make_pair(1, 2)` return?**
   <details><summary>Answer</summary>`std::pair<int, int>{1, 2}`</details>

10. **Q: How do you access the 3rd element of a tuple `t`?**
    <details><summary>Answer</summary>`std::get<2>(t)` (0-indexed)</details>

---

### Level 2 — MCQs

**1. Which of the following containers provides O(1) random access?**
- A) `std::list`
- B) `std::set`
- C) `std::vector` ✅
- D) `std::forward_list`

**2. What happens when you call `m["key"]` on an empty `std::map<string, int> m`?**
- A) Compilation error
- B) Returns 0 without modifying the map
- C) Inserts `{"key", 0}` into the map ✅
- D) Throws an exception

**3. Which STL algorithm is NOT guaranteed O(n log n)?**
- A) `std::sort`
- B) `std::stable_sort`
- C) `std::partial_sort`
- D) `std::nth_element` ✅ (average O(n), but the question is about guarantee)

**4. What is the underlying data structure of `std::set`?**
- A) Hash Table
- B) AVL Tree
- C) Red-Black Tree ✅
- D) B-Tree

**5. What does `std::accumulate(v.begin(), v.end(), 0)` return for `v = {1, 2, 3}`?**
- A) 0
- B) 3
- C) 6 ✅
- D) Compilation error

**6. Which container does NOT support iterators?**
- A) `std::vector`
- B) `std::stack` ✅
- C) `std::set`
- D) `std::deque`

**7. `std::pair` comparison is:**
- A) Only by first element
- B) Only by second element
- C) Lexicographic (first, then second) ✅
- D) Not supported

**8. Which is the correct way to check if a key exists in a `std::map`?**
- A) `m[key] != NULL`
- B) `m.contains(key)` ✅ (C++20)
- C) `m.exists(key)`
- D) `m.has(key)`

**9. What does `v.capacity()` represent?**
- A) Number of elements in the vector
- B) Maximum elements vector can ever hold
- C) Current allocated storage capacity ✅
- D) Size of each element

**10. Which iterator operation is NOT supported by bidirectional iterators?**
- A) `++it`
- B) `--it`
- C) `*it`
- D) `it + n` ✅

---

### Level 3 — Tricky Interview MCQs

**1. What is the output?**
```cpp
std::vector<int> v = {1, 2, 3};
v.reserve(100);
std::cout << v.size() << " " << v.capacity();
```
- A) `100 100`
- B) `3 3`
- C) `3 100` ✅
- D) `3 128` (possible but implementation-defined)

**2. What happens here?**
```cpp
std::vector<int> v;
std::cout << v.size() - 1;
```
- A) Prints `-1`
- B) Prints `18446744073709551615` (or similar huge number) ✅
- C) Throws exception
- D) Undefined behavior

**3. After this code, what is `s.size()`?**
```cpp
std::set<int> s = {1, 2, 2, 3, 3, 3};
```
- A) `6`
- B) `3` ✅
- C) `1`
- D) Compilation error

**4. What is the time complexity of `std::map::operator[]`?**
- A) O(1)
- B) O(log n) ✅
- C) O(n)
- D) O(n log n)

**5. Is this code valid?**
```cpp
std::vector<int> v = {3, 1, 4};
std::sort(v.rbegin(), v.rend());
```
- A) No, reverse iterators can't be used with sort
- B) Yes, sorts in descending order ✅
- C) Yes, sorts in ascending order
- D) Undefined behavior

---

### Level 4 — True / False

| #   | Statement                                                | Answer               |
| --- | -------------------------------------------------------- | -------------------- |
| 1   | `std::vector` elements are stored in contiguous memory   | **True**             |
| 2   | `std::list` supports random access                       | **False**            |
| 3   | `std::set` allows duplicate elements                     | **False**            |
| 4   | `std::unordered_map` maintains insertion order           | **False**            |
| 5   | `std::sort` works on `std::list` iterators               | **False**            |
| 6   | `pair::first` and `pair::second` are public members      | **True**             |
| 7   | `std::stack` provides iterator support                   | **False**            |
| 8   | `std::vector::reserve()` changes the size of the vector  | **False**            |
| 9   | `std::map` stores elements sorted by key                 | **True**             |
| 10  | `std::tuple` can hold only same-type elements            | **False**            |
| 11  | `std::priority_queue` is a min-heap by default           | **False** (max-heap) |
| 12  | `std::array` has a fixed size determined at compile time | **True**             |

---

### Level 5 — Coding Practice Problems

**Problem 1: Pair Sorting**
Given n pairs of (score, name), sort by score descending; if equal, by name ascending.

```cpp
// Input: n pairs
// Output: sorted pairs
// Hint: Custom comparator or store as (-score, name)
```

**Problem 2: Frequency Counter**
Given an array of integers, find the element with the highest frequency. If tie, return the smallest.

```cpp
// Hint: Use std::map for counting, then iterate
```

**Problem 3: Remove Duplicates**
Given a vector, remove all duplicate elements while maintaining the original relative order.

```cpp
// Hint: Use std::set to track seen elements
```

**Problem 4: Iterator Practice**
Write a function that takes two iterators and returns the sum of all even elements in the range.

```cpp
template <typename Iterator>
int sumEvens(Iterator begin, Iterator end) {
    // Your code here
}
```

**Problem 5: Container Choice**
You need a data structure that:
- Supports O(log n) insertion
- Supports O(log n) finding the k-th smallest element
- Supports O(log n) deletion

Which STL container would you use? What if pure STL doesn't suffice?

<details><summary>Answer</summary>
No pure STL container supports O(log n) k-th element queries. You would need:
- Policy-based data structure (`__gnu_pbds::tree`) — provides `find_by_order(k)` and `order_of_key(k)`
- Or a Fenwick/Segment Tree with coordinate compression
</details>

---

---

## 15. Extended Examples with Test Cases

### Example 1 — pair and tuple manipulation

```cpp
#include <iostream>
#include <tuple>
#include <utility>
using namespace std;

int main() {
    // pair basics
    pair<int, string> p1 = {42, "hello"};
    pair<int, string> p2 = make_pair(42, "hello");
    cout << (p1 == p2) << "\n";   // 1  (true)

    // structured bindings (C++17)
    auto [num, str] = p1;
    cout << num << " " << str << "\n";  // 42 hello

    // tuple
    tuple<int, double, string> t = make_tuple(1, 3.14, "pi");
    cout << get<0>(t) << " " << get<1>(t) << " " << get<2>(t) << "\n";
    // Output: 1 3.14 pi

    // auto structured binding for tuple
    auto [a, b, c] = t;
    cout << a << " " << b << " " << c << "\n";
    // Output: 1 3.14 pi

    // Modifying via get
    get<0>(t) = 99;
    cout << get<0>(t) << "\n";  // 99

    return 0;
}
```

**Expected Output:**
```
1
42 hello
1 3.14 pi
1 3.14 pi
99
```

---

### Example 2 — Iterator arithmetic and distance

```cpp
#include <iostream>
#include <vector>
#include <iterator>
using namespace std;

int main() {
    vector<int> v = {10, 20, 30, 40, 50};

    auto it = v.begin();
    advance(it, 2);
    cout << *it << "\n";          // 30

    auto it2 = next(it, 1);
    cout << *it2 << "\n";         // 40

    auto it3 = prev(it, 1);
    cout << *it3 << "\n";         // 20

    cout << distance(v.begin(), it) << "\n";  // 2

    // rbegin / rend
    for (auto rit = v.rbegin(); rit != v.rend(); ++rit)
        cout << *rit << " ";
    // Output: 50 40 30 20 10
    cout << "\n";

    return 0;
}
```

**Expected Output:**
```
30
40
20
2
50 40 30 20 10
```

---

### Example 3 — Demonstrating M×N vs M+N design principle

```cpp
#include <iostream>
#include <vector>
#include <list>
#include <algorithm>
using namespace std;

// ONE generic function that works on ANY container
template<typename Container>
void printSorted(Container& c) {
    vector<typename Container::value_type> tmp(c.begin(), c.end());
    sort(tmp.begin(), tmp.end());
    for (auto& x : tmp) cout << x << " ";
    cout << "\n";
}

int main() {
    vector<int> v = {5, 2, 8, 1};
    list<int>   l = {9, 3, 7, 4};

    printSorted(v);  // 1 2 5 8
    printSorted(l);  // 3 4 7 9
    return 0;
}
```

**Expected Output:**
```
1 2 5 8
3 4 7 9
```

---

### Example 4 — STL size_type unsigned trap and edge case

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> v = {};

    // DANGER: size() returns size_t (unsigned)
    // v.size() - 1 → wraps to huge number, not -1
    cout << (v.size() - 1) << "\n";    // ~18446744073709551615

    // Safe check
    if (!v.empty()) {
        cout << v.size() - 1 << "\n";
    } else {
        cout << "Vector is empty\n";   // ← printed
    }

    // Comparison with signed int — compiler warning territory
    int n = -1;
    // cout << (n < v.size()); // always true! n promoted to unsigned
    cout << (n < (int)v.size()) << "\n";  // 0 (false: -1 < 0)

    return 0;
}
```

**Expected Output:**
```
18446744073709551615
Vector is empty
0
```

---

### Example 5 — Comparing containers for a frequency problem

```cpp
#include <iostream>
#include <vector>
#include <map>
#include <unordered_map>
using namespace std;

int main() {
    vector<int> arr = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5};

    // Count frequencies using unordered_map (O(n) avg)
    unordered_map<int, int> freq;
    for (int x : arr) freq[x]++;

    // Find max frequency element
    int maxFreq = 0, maxElem = INT_MAX;
    for (auto& [val, cnt] : freq) {
        if (cnt > maxFreq || (cnt == maxFreq && val < maxElem)) {
            maxFreq = cnt;
            maxElem = val;
        }
    }
    cout << "Most frequent: " << maxElem << " (count=" << maxFreq << ")\n";
    // Output: Most frequent: 5 (count=3)

    return 0;
}
```

**Expected Output:**
```
Most frequent: 5 (count=3)
```

---

## 16. Tricky MCQs — Expert Level

**Q1. What does this print?**
```cpp
pair<int, int> p = {1, 2};
auto q = p;
q.first = 99;
cout << p.first;
```
- A) 99
- B) 1 ✅
- C) Undefined behavior
- D) Compilation error

> **Why:** `auto q = p` copies `p`. Modifying `q` does NOT affect `p`.

---

**Q2. What is the output?**
```cpp
tuple<int, int> t = make_tuple(1, 2);
get<0>(t) += get<1>(t);
get<1>(t) += get<0>(t);
cout << get<0>(t) << " " << get<1>(t);
```
- A) `1 2`
- B) `3 5` ✅
- C) `3 3`
- D) `2 3`

> **Why:** After step 1: `get<0>=3, get<1>=2`. After step 2: `get<1>=3+2=5`.

---

**Q3. What does this evaluate to?**
```cpp
vector<int> v;
cout << typeid(v.size()).name();
```
- A) `int`
- B) `long`
- C) Something like `m` or `y` (stands for `size_t` / `unsigned long`) ✅
- D) `ptrdiff_t`

> **Why:** `v.size()` returns `size_type` which is `std::size_t` (an unsigned type). Its `typeid` name is implementation-defined.

---

**Q4. How many elements will this set contain?**
```cpp
std::set<pair<int,int>> s;
s.insert({1, 2});
s.insert({2, 1});
s.insert({1, 2});
cout << s.size();
```
- A) 1
- B) 2 ✅
- C) 3
- D) Compilation error

> **Why:** `{1,2}` and `{2,1}` are different pairs. `{1,2}` inserted twice — only kept once. So size = 2.

---

**Q5. What is printed?**
```cpp
vector<int> a = {1, 2, 3};
vector<int> b = a;
a.push_back(4);
cout << a.size() << " " << b.size();
```
- A) `4 4`
- B) `4 3` ✅
- C) `3 3`
- D) Undefined behavior

> **Why:** `b = a` is a **deep copy**. Modifying `a` afterwards doesn't affect `b`.

---

**Q6. Which line causes undefined behavior?**
```cpp
vector<int> v = {1, 2, 3};   // (A)
auto it = v.end();             // (B)
v.push_back(4);                // (C)
cout << *it;                   // (D)
```
- A) Line A
- B) Line B
- C) Line C — causes iterator invalidation ✅
- D) Line D — dereferencing invalid iterator (UB)

> **Why:** `push_back` may reallocate the vector, invalidating `it`. Dereferencing it is undefined behavior.

---

**Q7. Can `std::tuple` hold references?**
```cpp
int x = 10;
auto t = make_tuple(ref(x));
get<0>(t) = 99;
cout << x;
```
- A) 10 (copy, no effect)
- B) 99 ✅ (reference_wrapper modifies x)
- C) Compilation error
- D) Undefined behavior

> **Why:** `std::ref(x)` creates a `reference_wrapper<int>`. Assigning to `get<0>(t)` writes through the reference.

---

**Q8. What is the complexity of `std::distance` on `std::list`?**
- A) O(1)
- B) O(log n)
- C) O(n) ✅
- D) O(n log n)

> **Why:** `std::list` provides only BidirectionalIterators, so `distance` must step one at a time.

---

**Q9. What is printed?**
```cpp
auto f = [](int x) { return x * 2; };
auto g = [](int x) { return x + 3; };
cout << f(g(4));
```
- A) 11
- B) 14 ✅
- C) 8
- D) Compilation error

> **Why:** `g(4)=7`, `f(7)=14`.

---

**Q10. In the context of the STL's M+N design: if you have 5 containers and 20 algorithms, how many implementations are needed WITH iterators vs WITHOUT?**
- A) 25 vs 100 ✅
- B) 100 vs 25
- C) 20 vs 100
- D) 5 vs 100

> **Why:** With STL: M+N = 5+20 = 25. Without: M×N = 5×20 = 100.

---

**Q11. What happens here?**
```cpp
vector<int> v(5, 0);
fill(v.begin(), v.end(), 7);
cout << v[3];
```
- A) 0
- B) 7 ✅
- C) Undefined behavior
- D) Compilation error

---

**Q12. Which assertion is CORRECT about `std::pair` comparison?**
```cpp
pair<int,int> a = {1, 5};
pair<int,int> b = {2, 3};
cout << (a < b);
```
- A) 0 (false: 5 > 3)
- B) 1 ✅ (true: first elements compared first, 1 < 2)
- C) Compilation error
- D) Undefined behavior

> **Why:** `pair::operator<` compares `first` first. Since `1 < 2`, result is `true`.

---

> **Next Chapter:** [02_STL_Sequence_Containers.md](02_STL_Sequence_Containers.md) — Deep dive into vector, deque, list, forward_list, and array.
