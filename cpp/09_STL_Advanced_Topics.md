# 📘 Chapter 9: Advanced STL Topics

> **Policy-based data structures, custom allocators, memory optimization, and STL debugging secrets.**

---

## Table of Contents

- [1. Custom Comparators — Advanced](#1-custom-comparators--advanced)
- [2. Custom Hash Functions — Advanced](#2-custom-hash-functions--advanced)
- [3. Policy-Based Data Structures (PBDS)](#3-policy-based-data-structures-pbds)
- [4. Memory Optimization](#4-memory-optimization)
- [5. STL Debugging Tricks](#5-stl-debugging-tricks)
- [6. Allocators](#6-allocators)
- [7. String Optimizations](#7-string-optimizations)
- [8. Move Semantics with STL](#8-move-semantics-with-stl)
- [9. emplace vs insert/push](#9-emplace-vs-insertpush)
- [10. Common Mistakes](#10-common-mistakes)
- [11. Interview Tips](#11-interview-tips)
- [12. Summary](#12-summary)
- [13. Practice Section](#13-practice-section)

---

## 1. Custom Comparators — Advanced

### 1.1 Three Ways to Define Custom Ordering

```cpp
// ─────── Method 1: operator< in struct (for set/map/sort) ──────────
struct Point {
    int x, y;
    bool operator<(const Point& p) const {
        if (x != p.x) return x < p.x;
        return y < p.y;
    }
};
std::set<Point> s;  // Uses operator< automatically

// ─────── Method 2: Functor ─────────────────────────────────────────
struct PointCmp {
    bool operator()(const Point& a, const Point& b) const {
        return a.x + a.y < b.x + b.y;  // Sort by sum
    }
};
std::set<Point, PointCmp> s2;

// ─────── Method 3: Lambda ──────────────────────────────────────────
auto cmp = [](const Point& a, const Point& b) {
    return a.x * a.x + a.y * a.y < b.x * b.x + b.y * b.y;  // By distance
};
std::set<Point, decltype(cmp)> s3(cmp);
```

### 1.2 Multi-Key Sorting

```cpp
struct Student {
    std::string name;
    int grade;
    int age;
};

// Sort by: grade DESC → name ASC → age ASC
std::sort(students.begin(), students.end(), [](const Student& a, const Student& b) {
    return std::tie(b.grade, a.name, a.age) < std::tie(a.grade, b.name, b.age);
});
// std::tie trick: creates tuples for lexicographic comparison
```

### 1.3 Comparator for priority_queue with Complex Types

```cpp
struct Edge {
    int u, v, weight;
};

// Min-heap by weight
auto cmp = [](const Edge& a, const Edge& b) {
    return a.weight > b.weight;  // REVERSED for priority_queue
};
std::priority_queue<Edge, std::vector<Edge>, decltype(cmp)> pq(cmp);
```

---

## 2. Custom Hash Functions — Advanced

### 2.1 Hash Combining

```cpp
struct PairHash {
    template<typename T1, typename T2>
    size_t operator()(const std::pair<T1, T2>& p) const {
        auto h1 = std::hash<T1>{}(p.first);
        auto h2 = std::hash<T2>{}(p.second);
        // Boost-style hash combine
        return h1 ^ (h2 * 0x9e3779b9 + (h1 << 6) + (h1 >> 2));
    }
};

std::unordered_map<std::pair<int,int>, int, PairHash> mp;
mp[{1, 2}] = 42;
```

### 2.2 Hash for Custom Structs

```cpp
struct Point3D {
    int x, y, z;
    
    bool operator==(const Point3D& o) const {
        return x == o.x && y == o.y && z == o.z;
    }
};

struct Point3DHash {
    size_t operator()(const Point3D& p) const {
        size_t h = 0;
        h ^= std::hash<int>{}(p.x) + 0x9e3779b9 + (h << 6) + (h >> 2);
        h ^= std::hash<int>{}(p.y) + 0x9e3779b9 + (h << 6) + (h >> 2);
        h ^= std::hash<int>{}(p.z) + 0x9e3779b9 + (h << 6) + (h >> 2);
        return h;
    }
};

std::unordered_set<Point3D, Point3DHash> points;
```

### 2.3 Safe Hash for Competitive Programming

```cpp
// splitmix64 — protects against hash collision attacks on Codeforces
struct SafeHash {
    static uint64_t splitmix64(uint64_t x) {
        x += 0x9e3779b97f4a7c15;
        x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
        x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
        return x ^ (x >> 31);
    }
    
    size_t operator()(uint64_t x) const {
        static const uint64_t FIXED_RANDOM = 
            std::chrono::steady_clock::now().time_since_epoch().count();
        return splitmix64(x + FIXED_RANDOM);
    }
};

std::unordered_map<int, int, SafeHash> safe_map;
```

---

## 3. Policy-Based Data Structures (PBDS)

### 3.1 What is PBDS?

**GCC-specific** data structures in `<ext/pb_ds/>` that provide operations not available in standard STL.

```cpp
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;

// ordered_set: like set but with ORDER STATISTICS
typedef tree<
    int,                      // Key type
    null_type,               // Mapped type (null = set, not map)
    less<int>,               // Comparator
    rb_tree_tag,             // Red-Black tree
    tree_order_statistics_node_update  // Enables order stats
> ordered_set;
```

### 3.2 Ordered Set Operations

```cpp
ordered_set os;
os.insert(1);
os.insert(3);
os.insert(5);
os.insert(7);
os.insert(9);

// ─────── find_by_order(k): k-th element (0-indexed) ─────────────
auto it = os.find_by_order(0);  // *it = 1 (smallest)
it = os.find_by_order(2);       // *it = 5 (3rd smallest)
it = os.find_by_order(4);       // *it = 9 (5th smallest)

// ─────── order_of_key(x): count of elements strictly less than x ─
int rank = os.order_of_key(5);   // 2 (elements < 5: {1, 3})
rank = os.order_of_key(6);       // 3 (elements < 6: {1, 3, 5})
rank = os.order_of_key(0);       // 0 (no elements < 0)

// Both operations are O(log n)!
```

### 3.3 Ordered Map

```cpp
typedef tree<
    int,                      // Key
    int,                      // Value (not null_type)
    less<int>,
    rb_tree_tag,
    tree_order_statistics_node_update
> ordered_map;

ordered_map om;
om.insert({1, 100});
om.insert({3, 300});
om.insert({5, 500});

auto it = om.find_by_order(1);  // Points to {3, 300}
std::cout << it->first << " " << it->second;  // 3 300
```

### 3.4 ordered_set with Duplicates

```cpp
// ordered_set uses set semantics (no duplicates)
// To handle duplicates: use pair<value, index>

typedef tree<
    std::pair<int, int>,         // {value, unique_id}
    null_type,
    less<std::pair<int, int>>,
    rb_tree_tag,
    tree_order_statistics_node_update
> ordered_multiset;

ordered_multiset oms;
int id = 0;
oms.insert({5, id++});
oms.insert({5, id++});  // Different pair, so it's inserted
oms.insert({3, id++});

// find_by_order and order_of_key work as expected
int rank = oms.order_of_key({5, 0});  // Elements < {5, 0} → 1 ({3,2})
```

### 3.5 PBDS vs STL Comparison

```
┌─────────────────┬───────────────────┬──────────────────────────────┐
│ Feature         │ std::set          │ ordered_set (PBDS)           │
├─────────────────┼───────────────────┼──────────────────────────────┤
│ Insert          │ O(log n) ✅       │ O(log n) ✅                  │
│ Erase           │ O(log n) ✅       │ O(log n) ✅                  │
│ Find            │ O(log n) ✅       │ O(log n) ✅                  │
│ K-th element    │ O(n) ❌           │ O(log n) ✅ find_by_order    │
│ Rank of element │ O(n) ❌           │ O(log n) ✅ order_of_key     │
│ Portability     │ ✅ Standard       │ ❌ GCC only                  │
└─────────────────┴───────────────────┴──────────────────────────────┘
```

---

## 4. Memory Optimization

### 4.1 vector::reserve

```cpp
std::vector<int> v;
v.reserve(1000000);  // Pre-allocate for 1M elements
// Avoids reallocations during push_back
// size() = 0, capacity() = 1000000

// ⚠️ reserve ≠ resize!
// reserve(n): allocates memory, does NOT create elements
// resize(n):  creates elements (default-initialized)
```

### 4.2 vector::shrink_to_fit

```cpp
std::vector<int> v(1000000);
v.resize(10);
// capacity is still ~1000000!

v.shrink_to_fit();
// Requests to reduce capacity to match size
// Not guaranteed but usually works
```

### 4.3 Container Capacity Comparison

```
┌────────────────┬───────────────────────────────────────────────┐
│ Container      │ Memory Overhead per Element                   │
├────────────────┼───────────────────────────────────────────────┤
│ vector<int>    │ ~0 bytes (contiguous, only unused capacity)  │
│ deque<int>     │ ~0 + chunk pointers                          │
│ list<int>      │ ~16 bytes (prev + next pointers)             │
│ set<int>       │ ~32 bytes (color, parent, L, R pointers)     │
│ unordered_set  │ ~8-16 bytes (hash bucket pointer + next)     │
│ map<int,int>   │ ~32+ bytes (same as set + value storage)     │
└────────────────┴───────────────────────────────────────────────┘

Rule: vector has best memory efficiency. Use it unless you 
      need specific container properties.
```

### 4.4 Flat Containers (C++23 / Manual)

```cpp
// Instead of map<int,int>, use sorted vector<pair<int,int>> + binary search
// Much better cache performance!

std::vector<std::pair<int,int>> flat_map;
flat_map.push_back({1, 100});
flat_map.push_back({3, 300});
flat_map.push_back({5, 500});
std::sort(flat_map.begin(), flat_map.end());

// Lookup:
auto it = std::lower_bound(flat_map.begin(), flat_map.end(),
    std::pair<int,int>{3, 0});
if (it != flat_map.end() && it->first == 3) {
    std::cout << it->second;  // 300
}
```

### 4.5 swap Trick (Clear and Free Memory)

```cpp
std::vector<int> v(1000000);
v.clear();  // size=0, but capacity still ~1000000!

// Free the memory:
std::vector<int>().swap(v);  // Swap with empty vector
// Now v.capacity() == 0
// Or in C++11:
// v = {};
// v.shrink_to_fit();
```

---

## 5. STL Debugging Tricks

### 5.1 Debug Mode (GCC)

```bash
# Compile with STL debug mode
g++ -D_GLIBCXX_DEBUG -g program.cpp -o program

# This enables bounds checking, iterator validation, etc.
# v[10] on a size-5 vector → runtime error instead of UB
# Using invalidated iterators → caught at runtime
```

### 5.2 Address Sanitizer

```bash
g++ -fsanitize=address -g program.cpp -o program
# Catches: out-of-bounds, use-after-free, memory leaks
```

### 5.3 Debug Print for Containers

```cpp
// Generic debug printer
template<typename T>
void debug(const T& container) {
    std::cerr << "[ ";
    for (const auto& x : container) {
        std::cerr << x << " ";
    }
    std::cerr << "]\n";
}

// For pairs/maps
template<typename K, typename V>
void debug(const std::map<K,V>& m) {
    std::cerr << "{ ";
    for (const auto& [k, v] : m) {
        std::cerr << k << ":" << v << " ";
    }
    std::cerr << "}\n";
}

#ifdef LOCAL
#define DBG(x) std::cerr << #x << " = "; debug(x);
#else
#define DBG(x)
#endif
```

### 5.4 Check Iterator Validity

```cpp
// In debug mode, GCC tracks iterator validity:
std::vector<int> v = {1, 2, 3};
auto it = v.begin();
v.push_back(4);  // Might invalidate it!

// With -D_GLIBCXX_DEBUG:
// *it;  // Runtime error: "attempt to dereference a singular iterator"

// In MSVC debug mode (_DEBUG):
// Similar checks are enabled by default
```

---

## 6. Allocators

### 6.1 What Are Allocators?

Allocators control how containers allocate and deallocate memory.

```cpp
// Default:
std::vector<int, std::allocator<int>> v;  // std::allocator is default

// Every STL container takes an allocator as template parameter:
// vector<T, Allocator = allocator<T>>
// set<key, Compare, Allocator = allocator<key>>
// map<Key, Value, Compare, Allocator = allocator<pair<const Key, Value>>>
```

### 6.2 Pool Allocator (Simple Custom)

```cpp
#include <vector>
#include <memory>

// Arena/Pool allocator — extremely fast for CP
template<typename T, size_t N = 1000000>
struct PoolAllocator {
    using value_type = T;
    
    T pool[N];
    size_t pos = 0;
    
    T* allocate(size_t n) {
        T* result = &pool[pos];
        pos += n;
        return result;
    }
    
    void deallocate(T*, size_t) {}  // No-op — pool lives forever
};
```

### 6.3 When to Care About Allocators

```
Most programmers never need custom allocators. Use them when:
1. You need extreme performance (game engines, HFT)
2. Memory fragmentation is a problem
3. You want pool/arena allocation for many small objects
4. Embedded systems with limited memory

For CP: Almost never needed. Standard allocator is fine.
```

---

## 7. String Optimizations

### 7.1 Short String Optimization (SSO)

```
┌──────────────────────────────────────────────────────────────────┐
│                  Short String Optimization (SSO)                  │
│                                                                   │
│ For short strings (typically ≤ 15-22 chars depending on impl):   │
│                                                                   │
│ LONG STRING (heap):      SHORT STRING (inline):                  │
│ ┌──────────────┐         ┌──────────────┐                       │
│ │ ptr ──────────┼──→ "A long str..."│                            │
│ │ size         │         │ "Hello"       │ ← stored inline!     │
│ │ capacity     │         │ size=5        │                       │
│ └──────────────┘         └──────────────┘                       │
│                                                                   │
│ SSO avoids heap allocation for small strings.                    │
│ This is why constructing a short string is nearly free.          │
└──────────────────────────────────────────────────────────────────┘
```

### 7.2 String Tips

```cpp
// ─────── Reserve for large concatenation ───────────────────────────
std::string result;
result.reserve(total_length);  // Avoid reallocations
for (const auto& s : strings) result += s;

// ─────── string_view (C++17) — no-copy reference ──────────────────
#include <string_view>

void process(std::string_view sv) {
    // O(1) to create — just a pointer + length
    // No copies! But sv must not outlive the original string.
}

std::string s = "Hello, World!";
process(s);                // No copy
process("literal");        // No copy
process(s.substr(0, 5));   // This still copies! Use string_view::substr instead

// ─────── string_view substring is O(1) ───────────────────────────
std::string_view sv = "Hello, World!";
auto sub = sv.substr(7, 5);  // O(1)! Just adjusts pointer and length
// sub = "World"

// ─────── Compare strings efficiently ──────────────────────────────
// string::compare is faster than == for early exit
if (s1.size() != s2.size()) { /* different */ }  // O(1) check first
```

---

## 8. Move Semantics with STL

### 8.1 Moving into Containers

```cpp
std::vector<std::string> v;

std::string s = "Hello, this is a long string that won't use SSO";

// Copy (expensive — allocates new memory):
v.push_back(s);

// Move (cheap — steals internals):
v.push_back(std::move(s));
// s is now in "valid but unspecified state" (probably empty)

// Best: construct in place
v.emplace_back("Hello, constructed directly");
```

### 8.2 Moving Entire Containers

```cpp
std::vector<int> v1 = {1, 2, 3, 4, 5};
std::vector<int> v2 = std::move(v1);  // O(1)! Just swaps internal pointers
// v1 is now empty, v2 has the data

// Moving map entries
std::map<int, std::vector<int>> m;
m[1] = {1, 2, 3};
auto vec = std::move(m[1]);  // Steals the vector from the map
// m[1] is now empty
```

### 8.3 Move Semantics Table

```
┌──────────────────┬──────────────────┬──────────────────┐
│ Operation        │ Copy             │ Move             │
├──────────────────┼──────────────────┼──────────────────┤
│ vector<int>      │ O(n)             │ O(1)             │
│ string (long)    │ O(n)             │ O(1)             │
│ string (short)   │ O(1) SSO         │ O(1) SSO         │
│ map<K,V>         │ O(n log n)       │ O(1)             │
│ unique_ptr       │ ❌ Not copyable  │ O(1)             │
└──────────────────┴──────────────────┴──────────────────┘
```

---

## 9. emplace vs insert/push

### 9.1 The Difference

```cpp
std::vector<std::pair<int, std::string>> v;

// push_back: creates pair, then copies/moves it into vector
v.push_back({1, "hello"});   // Construct pair → move into vector
v.push_back(std::make_pair(2, "world"));

// emplace_back: constructs pair directly in vector's memory
v.emplace_back(3, "direct");  // No temporary pair created!

// For simple types (int, double), difference is negligible.
// For complex types, emplace can avoid expensive copies.
```

### 9.2 emplace for Map

```cpp
std::map<int, std::string> m;

// insert: needs a pair
m.insert({1, "hello"});
m.insert(std::make_pair(2, "world"));

// emplace: constructs in place
m.emplace(3, "direct");

// try_emplace (C++17): doesn't move the value if key exists
m.try_emplace(3, "won't replace");  // Key 3 exists, value not touched
m.try_emplace(4, "will insert");    // Key 4 doesn't exist, inserted
```

### 9.3 When emplace Matters

```cpp
// Big win: expensive-to-copy objects
struct BigObject {
    std::array<int, 10000> data;
    BigObject(int val) { data.fill(val); }
};

std::vector<BigObject> v;

// ❌ Slow: creates BigObject, then copies/moves it
v.push_back(BigObject(42));

// ✅ Fast: constructs BigObject directly in vector's memory
v.emplace_back(42);
```

---

## 10. Common Mistakes

### Mistake 1: Forgetting reserve() for Known Sizes

```cpp
// ❌ Multiple reallocations as vector grows
std::vector<int> v;
for (int i = 0; i < 1000000; i++) v.push_back(i);

// ✅ Single allocation
std::vector<int> v;
v.reserve(1000000);
for (int i = 0; i < 1000000; i++) v.push_back(i);
```

### Mistake 2: Using PBDS Without Understanding Limitations

```cpp
// ordered_set doesn't support duplicates!
ordered_set os;
os.insert(5);
os.insert(5);  // Not inserted!
os.size();      // 1, not 2!

// ✅ Use pair<value, id> for duplicates
```

### Mistake 3: Misusing string_view

```cpp
// ❌ Dangling string_view
std::string_view bad_func() {
    std::string s = "temporary";
    return s;  // s destroyed → string_view dangles!
}

// ✅ Return string, not string_view
std::string good_func() {
    return "temporary";
}
```

### Mistake 4: Not Using emplace When It Matters

```cpp
// For map with complex values:
std::map<int, std::vector<int>> m;

// ❌ Creates temporary vector, then moves
m.insert({1, {1, 2, 3, 4, 5}});

// ✅ Constructs vector directly in map
m.emplace(std::piecewise_construct,
          std::forward_as_tuple(1),
          std::forward_as_tuple(5, 42));  // vector(5, 42)
// Or simpler:
m[1] = {1, 2, 3, 4, 5};
```

---

## 11. Interview Tips

**Q1: What is PBDS and when would you use it?**
> Policy-Based Data Structures (GCC extension). Provides `ordered_set` with O(log n) find-by-rank and rank-of-element, which standard `set` doesn't support. Used in competitive programming for order statistics.

**Q2: What is the Small String Optimization?**
> Short strings (typically ≤ 15-22 chars) are stored inline within the `std::string` object itself, avoiding heap allocation. This makes construction and copying of short strings very fast.

**Q3: When should you use `emplace_back` vs `push_back`?**
> Use `emplace_back` when constructing complex objects to avoid creating temporaries. For simple types (int, pointers), there's no difference. If you're passing an already-constructed object, `push_back` with `std::move` is equivalent.

**Q4: What does `shrink_to_fit` do?**
> It's a non-binding request to reduce `capacity()` to match `size()`, freeing excess memory. The implementation may ignore it, but typically it works.

**Q5: How do you debug iterator invalidation?**
> Compile with `-D_GLIBCXX_DEBUG` (GCC) or use MSVC debug mode. These enable runtime checks for invalid iterator operations. Also use AddressSanitizer (`-fsanitize=address`) for memory errors.

---

## 12. Summary

```
┌──────────────────────────────────────────────────────────────────┐
│                   ADVANCED STL CHEAT SHEET                        │
├──────────────────────────────────────────────────────────────────┤
│ Custom Comparators: operator< | functor | lambda                 │
│ Custom Hash: hash_combine pattern | splitmix64 for CP           │
│                                                                   │
│ PBDS ordered_set:                                                │
│   find_by_order(k)  — k-th element O(log n)                     │
│   order_of_key(x)   — rank of x O(log n)                        │
│   GCC only! Use pair<val,id> for duplicates                     │
│                                                                   │
│ Memory:                                                          │
│   reserve() — pre-allocate | shrink_to_fit() — free excess      │
│   vector > other containers for cache performance                │
│   swap trick to free memory: vector<T>().swap(v)                │
│                                                                   │
│ Move Semantics:                                                  │
│   std::move transfers ownership O(1)                             │
│   emplace > push/insert for complex types                       │
│                                                                   │
│ Debugging:                                                       │
│   -D_GLIBCXX_DEBUG | -fsanitize=address                         │
│   Use cerr + macros for debug output                             │
└──────────────────────────────────────────────────────────────────┘
```

---

## 13. Practice Section

### Level 1 — Quick Concept Questions

1. **Q: What is `ordered_set` in PBDS?**
   <details><summary>Answer</summary>A Red-Black tree from GCC's policy-based data structures that supports O(log n) find_by_order (k-th element) and order_of_key (rank).</details>

2. **Q: What does `find_by_order(3)` return?**
   <details><summary>Answer</summary>Iterator to the 4th smallest element (0-indexed).</details>

3. **Q: What does `order_of_key(x)` return?**
   <details><summary>Answer</summary>Number of elements strictly less than x.</details>

4. **Q: What is SSO?**
   <details><summary>Answer</summary>Short String Optimization. Strings shorter than ~15-22 chars are stored inline (no heap allocation).</details>

5. **Q: What does `vector::reserve(n)` do?**
   <details><summary>Answer</summary>Pre-allocates memory for n elements without changing size. Avoids reallocations.</details>

6. **Q: Difference between `reserve` and `resize`?**
   <details><summary>Answer</summary>`reserve(n)` only allocates memory (size unchanged). `resize(n)` changes size and creates/destroys elements.</details>

7. **Q: What is the splitmix64 hash used for?**
   <details><summary>Answer</summary>Protecting against hash collision attacks (anti-hack) in competitive programming, especially on Codeforces.</details>

8. **Q: `emplace_back` vs `push_back` — when is emplace better?**
   <details><summary>Answer</summary>When constructing complex objects in-place, avoiding temporary creation and copy/move.</details>

9. **Q: How do you free memory used by a cleared vector?**
   <details><summary>Answer</summary>`v.shrink_to_fit()` or `vector<T>().swap(v)` (swap trick).</details>

10. **Q: Is `ordered_set` part of the C++ standard?**
    <details><summary>Answer</summary>No. It's a GCC extension in `<ext/pb_ds/>`. Not available in MSVC/Clang without GCC headers.</details>

---

### Level 2 — MCQs

**1. `ordered_set::find_by_order(0)` returns:**
- A) End iterator
- B) Iterator to smallest element ✅
- C) Iterator to largest element
- D) Null

**2. PBDS `tree` tag `rb_tree_tag` means:**
- A) B-tree
- B) AVL tree
- C) Red-Black tree ✅
- D) Splay tree

**3. `vector::reserve(100)` sets:**
- A) size = 100, capacity = 100
- B) size = 0, capacity ≥ 100 ✅
- C) size = 100, capacity = 0
- D) size = capacity = 0

**4. SSO typically stores inline strings up to:**
- A) 3-5 characters
- B) 15-22 characters ✅
- C) 100 characters
- D) 1000 characters

**5. `string_view` is:**
- A) A mutable reference to a string
- B) An owning string with small buffer optimization
- C) A non-owning reference (pointer + length) ✅
- D) A copy of the string

**6. Moving a `vector<int>` is:**
- A) O(n) always
- B) O(1) — just pointer swap ✅
- C) O(n log n)
- D) Not allowed

**7. `emplace_back` constructs the object:**
- A) In a temporary location, then copies
- B) In a temporary location, then moves
- C) Directly in the container's memory ✅
- D) On the heap separately

**8. To debug iterator invalidation in GCC, compile with:**
- A) `-O2`
- B) `-D_GLIBCXX_DEBUG` ✅
- C) `-Wall`
- D) `-std=c++17`

**9. `try_emplace` (C++17) differs from `emplace` because it:**
- A) Doesn't exist for maps
- B) Doesn't move the value argument if key exists ✅
- C) Is faster for all cases
- D) Works only with strings

**10. The hash combine constant `0x9e3779b9` comes from:**
- A) MD5
- B) SHA-256
- C) Golden ratio (Fibonacci hashing) ✅
- D) Random number

---

### Level 3 — Tricky Interview MCQs

**1. Why can't PBDS `ordered_set` handle duplicates directly?**
- A) It uses a hash table
- B) It's a set (unique keys), not multiset ✅
- C) The comparator doesn't support equal elements
- D) It's a GCC bug

**2. What does `v.shrink_to_fit()` guarantee?**
- A) capacity() == size()
- B) A non-binding request; capacity may or may not change ✅
- C) Memory is freed immediately
- D) The vector is cleared

**3. Which is true about `string_view::substr()`?**
- A) It copies the substring
- B) It returns a new `string_view` in O(1) ✅
- C) It modifies the original string
- D) It allocates memory

**4. `emplace_back` with an already-constructed object is:**
- A) Faster than push_back
- B) Same as push_back (both move/copy) ✅
- C) Compile error
- D) Slower due to forwarding overhead

**5. Using `-fsanitize=address` catches which of these?**
- A) Data races
- B) Use-after-free and buffer overflow ✅
- C) Deadlocks
- D) Type confusion

---

### Level 4 — True / False

| #   | Statement                                           | Answer                                        |
| --- | --------------------------------------------------- | --------------------------------------------- |
| 1   | PBDS is available in MSVC                           | **False** (GCC only)                          |
| 2   | `reserve()` changes `size()`                        | **False**                                     |
| 3   | Moving a vector is always O(1)                      | **True**                                      |
| 4   | `string_view` owns the string data                  | **False**                                     |
| 5   | `emplace_back` can take constructor arguments       | **True**                                      |
| 6   | SSO is guaranteed by the C++ standard               | **False** (QoI)                               |
| 7   | `order_of_key(x)` returns count of elements ≤ x     | **False** (strictly < x)                      |
| 8   | `-D_GLIBCXX_DEBUG` has zero runtime overhead        | **False** (significant overhead)              |
| 9   | `shrink_to_fit` on an empty vector frees all memory | **True** (typically)                          |
| 10  | `std::move` actually moves data                     | **False** (it just casts to rvalue reference) |

---

### Level 5 — Coding Practice Problems

**Problem 1: K-th Smallest Element (Dynamic)**
```
Implement a data structure supporting: insert(x), delete(x), kth(k).
All in O(log n). Use PBDS ordered_set.
```

**Problem 2: Inversions Count (Online)**
```
Given elements arriving one by one, count inversions after each insertion.
Use ordered_set's order_of_key.
```

**Problem 3: Custom Allocator**
```
Implement a simple pool allocator and use it with std::vector<int>.
Benchmark against std::allocator.
```

**Problem 4: Flatten Nested Containers**
```
Write a generic function using templates to flatten vector<vector<vector<int>>>
into vector<int> using move semantics.
```

**Problem 5: LRU Cache with STL**
```
Implement an LRU cache using std::list + std::unordered_map
with O(1) get and put operations.
```

---

---

## 14. Extended Examples with Test Cases

### Example 1 — emplace_back vs push_back

```cpp
#include <iostream>
#include <vector>
#include <string>
using namespace std;

struct Point {
    int x, y;
    Point(int x, int y) : x(x), y(y) {
        cout << "Constructed(" << x << "," << y << ")\n";
    }
    Point(const Point& p) : x(p.x), y(p.y) {
        cout << "Copied(" << x << "," << y << ")\n";
    }
    Point(Point&& p) : x(p.x), y(p.y) {
        cout << "Moved(" << x << "," << y << ")\n";
    }
};

int main() {
    vector<Point> vp;
    vp.reserve(4);  // avoid reallocation noise

    cout << "--- push_back with temp ---\n";
    vp.push_back(Point(1, 2));
    // Output: Constructed(1,2) then Moved(1,2)

    cout << "--- emplace_back ---\n";
    vp.emplace_back(3, 4);
    // Output: Constructed(3,4) — NO copy or move!

    return 0;
}
```

**Expected Output:**
```
--- push_back with temp ---
Constructed(1,2)
Moved(1,2)
--- emplace_back ---
Constructed(3,4)
```

---

### Example 2 — PBDS ordered_set operations

```cpp
#include <iostream>
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace std;
using namespace __gnu_pbds;

typedef tree<int, null_type, less<int>,
             rb_tree_tag, tree_order_statistics_node_update> ordered_set;

int main() {
    ordered_set os;
    os.insert(10);
    os.insert(20);
    os.insert(5);
    os.insert(15);
    os.insert(30);
    // Sorted: {5, 10, 15, 20, 30}

    // find_by_order(k): k-th element (0-indexed)
    cout << *os.find_by_order(0) << "\n";   // 5   (0th smallest)
    cout << *os.find_by_order(2) << "\n";   // 15  (2nd smallest)
    cout << *os.find_by_order(4) << "\n";   // 30  (4th smallest)

    // order_of_key(x): count of elements strictly less than x
    cout << os.order_of_key(15) << "\n";    // 2  (5 and 10 are less)
    cout << os.order_of_key(100) << "\n";   // 5  (all 5 elements are less)
    cout << os.order_of_key(5) << "\n";     // 0  (nothing is less than 5)

    return 0;
}
```

---

### Example 3 — move semantics with STL containers

```cpp
#include <iostream>
#include <vector>
#include <string>
using namespace std;

int main() {
    vector<string> v1 = {"hello", "world", "foo"};

    // Copy assignment — O(n)
    vector<string> v2 = v1;
    cout << v1.size() << " " << v2.size() << "\n";  // 3 3

    // Move assignment — O(1)
    vector<string> v3 = move(v1);
    cout << v1.size() << " " << v3.size() << "\n";  // 0 3 (v1 emptied!)

    // Move into function — avoids copy
    auto process = [](vector<string> v) {
        return v.size();
    };
    auto sz = process(move(v2));    // v2 moved into function
    cout << sz << " " << v2.size() << "\n";  // 3 0

    // std::move on individual elements
    string s1 = "expensive_string";
    string s2 = move(s1);
    cout << s1.empty() << "\n";  // 1 (s1 is in valid but unspecified state)
    cout << s2 << "\n";          // expensive_string

    return 0;
}
```

---

### Example 4 — string_view for zero-copy

```cpp
#include <iostream>
#include <string_view>
#include <string>
using namespace std;

// Takes string_view: works with both string literals and std::string WITHOUT copy
void printFirstN(string_view sv, int n) {
    cout << sv.substr(0, n) << "\n";  // O(1) — no allocation
}

int main() {
    string s = "hello world";
    const char* cs = "raw c-string";

    printFirstN(s, 5);     // hello  — no copy of s
    printFirstN(cs, 3);    // raw    — no copy of cs
    printFirstN("literal", 4);  // lite

    // string_view does NOT own data
    string_view sv;
    {
        string temp = "temporary";
        sv = temp;        // sv points into temp's data
    }
    // sv now DANGLING — temp destroyed!
    // cout << sv;  // UNDEFINED BEHAVIOR

    return 0;
}
```

---

### Example 5 — custom allocator pool (simplified)

```cpp
#include <iostream>
#include <vector>
#include <memory>
using namespace std;

// Demonstration: tracking allocations with a wrapper
struct TrackingAllocator {
    static int alloc_count;
    using value_type = int;

    int* allocate(size_t n) {
        alloc_count++;
        cout << "Allocating " << n << " ints\n";
        return static_cast<int*>(::operator new(n * sizeof(int)));
    }
    void deallocate(int* p, size_t n) {
        cout << "Deallocating " << n << " ints\n";
        ::operator delete(p);
    }
};
int TrackingAllocator::alloc_count = 0;

int main() {
    vector<int, TrackingAllocator> v;
    v.reserve(4);
    v.push_back(1); v.push_back(2); v.push_back(3);
    // Prints: Allocating 4 ints  (only once — reserved)

    cout << "Total allocations: " << TrackingAllocator::alloc_count << "\n";

    return 0;
}
```

---

## 15. Tricky MCQs — Expert Level

**Q1. `std::move(v)` on a `vector<int>` leaves `v` in what state?**
- A) Empty (`size() == 0`) but the exact state is unspecified ✅ (valid but unspecified)
- B) Undefined behavior
- C) Exactly empty — `size()` guaranteed 0
- D) Unchanged — `std::move` only casts

> **Why:** The standard says moved-from objects are in a "valid but unspecified state". In practice, `vector` is empty, but the standard only guarantees validity.

---

**Q2. `emplace_back` takes constructor arguments directly. The key benefit vs `push_back` is:**
- A) It's always faster
- B) It avoids constructing a temporary object ✅ (forwards args to constructor in-place)
- C) It has better exception safety
- D) It doesn't require copy constructor

---

**Q3. `string_view::substr()` returns:**
- A) `std::string` (new allocation)
- B) `string_view` (no allocation, O(1)) ✅
- C) `std::string_view*` pointer
- D) Compilation error

---

**Q4. What is SSO (Small String Optimization)?**
- A) A compiler flag for small strings
- B) Storing short strings directly in the string object's buffer (no heap allocation) ✅
- C) Reusing hash buckets for short keys
- D) A linking optimization

---

**Q5. `PBDS find_by_order(k)` where `k >= os.size()` returns:**
- A) A null pointer
- B) The last element's iterator
- C) `os.end()` ✅
- D) Throws `out_of_range`

---

**Q6. Which is true about `std::unique_ptr` stored in `std::vector`?**
- A) Cannot be stored — unique_ptr is not copyable ✅ (unless you use `std::move`)
- B) Works fine, automatically copies
- C) Must use `shared_ptr` instead
- D) Requires custom allocator

> **Note:** `push_back(std::move(ptr))` works correctly.

---

**Q7. What is the output?**
```cpp
vector<int> a = {1, 2, 3};
vector<int> b = a;             // copy
vector<int> c = std::move(a);  // move
cout << a.size() << " " << b.size() << " " << c.size();
```
- A) `3 3 3`
- B) `0 3 3` ✅
- C) `3 0 3`
- D) `0 0 3`

---

**Q8. `-fsanitize=address` helps detect:**
- A) Data races only
- B) Use-after-free, heap buffer overflow, stack overflow ✅
- C) Integer overflow
- D) Deadlocks

---

**Q9. `try_emplace` (C++17) avoids which problem of `emplace`?**
- A) Thread safety issues
- B) Unnecessary construction of the mapped value when key exists ✅
- C) Memory leaks on exception
- D) Hash collisions

---

**Q10. `shrink_to_fit()` on a vector guarantees:**
- A) `capacity() == size()`
- B) Memory is freed ✅ in practice (non-binding request; implementations typically comply)
- C) All iterators remain valid
- D) Nothing — purely advisory

---

**Q11. What is printed?**
```cpp
string s = "hello";
string_view sv = s;
s += " world";  // may reallocate s
cout << sv;
```
- A) `hello`
- B) `hello world`
- C) Undefined behavior ✅ — `sv` may point to freed memory after reallocation
- D) Compilation error

---

**Q12. `PBDS ordered_set` uses which tree internally?**
- A) AVL Tree
- B) Red-Black Tree ✅ (`rb_tree_tag`)
- C) B-Tree
- D) Skip List

---

> **Previous:** [08_STL_Functional_and_Lambdas.md](08_STL_Functional_and_Lambdas.md)  
> **Next:** [10_STL_For_Competitive_Programming.md](10_STL_For_Competitive_Programming.md)
