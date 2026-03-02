# 📘 Chapter 4: Unordered Containers — Hash-Powered Speed

> **Master hash tables, load factors, rehashing, collision handling, and custom hash functions.**

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. Hash Tables — The Engine](#2-hash-tables--the-engine)
- [3. std::unordered_set](#3-stdunordered_set)
- [4. std::unordered_multiset](#4-stdunordered_multiset)
- [5. std::unordered_map](#5-stdunordered_map)
- [6. std::unordered_multimap](#6-stdunordered_multimap)
- [7. Hash Functions Deep Dive](#7-hash-functions-deep-dive)
- [8. Load Factor & Rehashing](#8-load-factor--rehashing)
- [9. Collision Handling](#9-collision-handling)
- [10. Custom Hash Functions](#10-custom-hash-functions)
- [11. Performance Analysis](#11-performance-analysis)
- [12. Common Mistakes](#12-common-mistakes)
- [13. Interview Tips](#13-interview-tips)
- [14. Competitive Programming Tricks](#14-competitive-programming-tricks)
- [15. Edge Cases](#15-edge-cases)
- [16. Summary](#16-summary)
- [17. Practice Section](#17-practice-section)

---

## 1. Overview

Unordered containers use **hash tables** to provide **O(1) average-case** operations for insert, find, and erase.

```
┌───────────────────────────────────────────────────────────────┐
│                   Unordered Containers                         │
├───────────────┬─────────────────┬────────────────────────────┤
│ unordered_set │ unordered_map   │  Unique keys, O(1) avg     │
│ unordered_    │ unordered_      │  Duplicate keys, O(1) avg  │
│ multiset      │ multimap        │                            │
└───────────────┴─────────────────┴────────────────────────────┘

Introduced in C++11.
All use HASH TABLES internally.
Average O(1) insert, find, erase.
Worst case O(n) — all elements in same bucket.
NO ordering guarantee.
```

---

## 2. Hash Tables — The Engine

### 2.1 How Hash Tables Work

```
Key → Hash Function → Bucket Index → Linked List (chain)

Step 1: Compute hash      hash("Alice") = 2859483729
Step 2: Map to bucket     2859483729 % bucket_count = 3
Step 3: Store in chain    bucket[3] → "Alice" → "Dave" → null
```

### 2.2 Visual Representation

```
┌──────────────────────────────────────────────────────────┐
│               Hash Table Internal Layout                  │
│                                                           │
│  Bucket Array (std::vector<Node*>):                      │
│  ┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐     │
│  │  0  │  1  │  2  │  3  │  4  │  5  │  6  │  7  │     │
│  └──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┴──┬──┘     │
│     │     │     │     │     │     │     │     │          │
│    null   │    null   │    null   │    null  null        │
│           ▼           ▼           ▼                      │
│        ["bob"]    ["alice"]   ["eve"]                     │
│           │           │                                  │
│           ▼           ▼                                  │
│        ["dan"]    ["charlie"]                            │
│                                                           │
│  bucket_count() = 8                                      │
│  size() = 5                                              │
│  load_factor() = 5/8 = 0.625                            │
│  max_load_factor() = 1.0 (default)                      │
└──────────────────────────────────────────────────────────┘
```

### 2.3 Hash Table Components

| Component         | Description                                             |
| ----------------- | ------------------------------------------------------- |
| **Bucket array**  | Array of pointers to chains (vector of linked lists)    |
| **Hash function** | Converts key to integer (hash code)                     |
| **Bucket index**  | `hash(key) % bucket_count`                              |
| **Chain**         | Linked list of elements in a bucket (separate chaining) |
| **Load factor**   | `size() / bucket_count()` — measure of fullness         |
| **Rehashing**     | Resize bucket array when load factor exceeds threshold  |

### 2.4 Hash Table Operations

```
INSERT(key):
  1. hash_code = hash(key)
  2. bucket_idx = hash_code % bucket_count
  3. Search bucket[bucket_idx] chain for key
  4. If not found, insert at front of chain
  5. If load_factor > max_load_factor, REHASH

FIND(key):
  1. hash_code = hash(key)
  2. bucket_idx = hash_code % bucket_count
  3. Search bucket[bucket_idx] chain for key
  4. Return iterator if found, end() otherwise

ERASE(key):
  1. hash_code = hash(key)
  2. bucket_idx = hash_code % bucket_count
  3. Search and remove from chain
```

---

## 3. std::unordered_set

### 3.1 Concept Explanation

`std::unordered_set` stores **unique elements** with no particular order. Uses hash table for O(1) average operations.

### 3.2 Time Complexity

| Operation        | Average  | Worst Case | Notes                       |
| ---------------- | -------- | ---------- | --------------------------- |
| `insert(val)`    | **O(1)** | O(n)       | O(n) on rehash or bad hash  |
| `erase(val)`     | **O(1)** | O(n)       |                             |
| `find(val)`      | **O(1)** | O(n)       |                             |
| `count(val)`     | **O(1)** | O(n)       | Returns 0 or 1              |
| `contains(val)`  | **O(1)** | O(n)       | C++20                       |
| `size()`         | **O(1)** | O(1)       |                             |
| `bucket_count()` | **O(1)** | O(1)       |                             |
| `rehash(n)`      | **O(n)** | O(n)       | Resize bucket array         |
| `reserve(n)`     | **O(n)** | O(n)       | Pre-allocate for n elements |
| `clear()`        | **O(n)** | O(n)       |                             |

### 3.3 Memory Behavior

- Bucket array: `bucket_count * sizeof(pointer)`
- Each element: node overhead (next pointer + hash cache) + element size
- Total per element: ~40-64 bytes overhead on 64-bit systems
- Rehashing: entire hash table is rebuilt (all elements re-hashed)

### 3.4 Syntax & All Important Functions

```cpp
#include <unordered_set>

// ─────────────────────────── Construction ───────────────────────────
std::unordered_set<int> us1;                           // Empty
std::unordered_set<int> us2 = {3, 1, 4, 1, 5};       // {3, 1, 4, 5} (unique)
std::unordered_set<int> us3(us2);                     // Copy
std::unordered_set<int> us4(us2.begin(), us2.end()); // Range
std::unordered_set<int> us5(100);                     // 100 initial buckets

// ─────────────────────────── Capacity ───────────────────────────────
us.size();            // Number of elements
us.empty();           // Whether empty
us.max_size();        // Max possible elements

// ─────────────────────────── Modifiers ──────────────────────────────
auto [it, inserted] = us.insert(42);    // Returns {iterator, bool}
us.insert({1, 2, 3});                   // Insert multiple
us.emplace(42);                         // Construct in-place
us.erase(42);                           // Erase by value
us.erase(it);                           // Erase by iterator
us.clear();                             // Remove all
us.swap(other);

// ─────────────────────────── Lookup ─────────────────────────────────
us.find(42);           // Returns iterator or end()
us.count(42);          // 0 or 1
us.contains(42);       // C++20: true/false
us.equal_range(42);    // pair<iterator, iterator>

// ─────────────────────────── Bucket Interface ───────────────────────
us.bucket_count();            // Number of buckets
us.max_bucket_count();        // Max possible buckets
us.bucket_size(n);            // Elements in bucket n
us.bucket(42);                // Which bucket contains 42

// ─────────────────────────── Hash Policy ────────────────────────────
us.load_factor();              // size / bucket_count
us.max_load_factor();          // Get threshold (default: 1.0)
us.max_load_factor(0.5);      // Set threshold
us.rehash(100);                // Rehash to at least 100 buckets
us.reserve(100);               // Reserve for at least 100 elements

// ─────────────────────────── Observers ──────────────────────────────
us.hash_function();            // Returns the hash function object
us.key_eq();                   // Returns the equality comparison function
```

### 3.5 Code Example

```cpp
#include <iostream>
#include <unordered_set>

int main() {
    std::unordered_set<int> us = {5, 2, 8, 1, 9, 3, 7};
    
    // Iteration (NO guaranteed order!)
    for (int x : us) std::cout << x << " ";
    // Possible output: 7 3 9 1 8 2 5 (order varies!)
    
    // Insert
    auto [it, ok] = us.insert(4);
    std::cout << "\nInserted 4: " << ok << "\n";  // 1
    
    auto [it2, ok2] = us.insert(5);  // Already exists
    std::cout << "Inserted 5: " << ok2 << "\n";  // 0
    
    // Find — O(1) average
    if (us.find(8) != us.end()) {
        std::cout << "Found 8\n";
    }
    
    // C++20
    if (us.contains(8)) {
        std::cout << "Contains 8\n";
    }
    
    // Bucket info
    std::cout << "Buckets: " << us.bucket_count() << "\n";
    std::cout << "Load factor: " << us.load_factor() << "\n";
    std::cout << "8 is in bucket: " << us.bucket(8) << "\n";
    
    return 0;
}
```

### 3.6 When to Use

✅ **Use unordered_set when:**
- You need O(1) average lookup/insert/erase
- Order doesn't matter
- No need for lower_bound/upper_bound
- Key type has a good hash function

### 3.7 When NOT to Use

❌ **Don't use unordered_set when:**
- You need sorted order → use `set`
- You need lower_bound/upper_bound → use `set`
- Worst-case O(n) is unacceptable (adversarial inputs)
- Key type doesn't have a good hash function
- n is very small (< 20) → overhead not worth it

---

## 4. std::unordered_multiset

### 4.1 Concept

Like `unordered_set` but **allows duplicate elements**.

```cpp
#include <unordered_set>

std::unordered_multiset<int> ums = {1, 2, 2, 3, 3, 3};
// Contains all duplicates: {1, 2, 2, 3, 3, 3}

ums.count(3);  // 3
ums.count(2);  // 2

// ⚠️ erase(val) removes ALL occurrences
ums.erase(3);  // Removes all 3s
// ums = {1, 2, 2}

// Erase ONLY ONE occurrence
auto it = ums.find(2);
if (it != ums.end()) ums.erase(it);
// ums = {1, 2}
```

### 4.2 Key Differences from unordered_set

| Feature           | unordered_set    | unordered_multiset           |
| ----------------- | ---------------- | ---------------------------- |
| Duplicates        | ❌                | ✅                            |
| `insert()` return | `pair<it, bool>` | `iterator` (always succeeds) |
| `count(val)`      | 0 or 1           | 0 to n                       |
| `erase(val)`      | Removes 0 or 1   | Removes ALL occurrences      |

---

## 5. std::unordered_map

### 5.1 Concept Explanation

`std::unordered_map` stores **key-value pairs** with **unique keys**, using a hash table for O(1) average operations. This is arguably the **most commonly used** container after `vector`.

### 5.2 Time Complexity

| Operation            | Average  | Worst Case          |
| -------------------- | -------- | ------------------- |
| `operator[key]`      | **O(1)** | O(n)                |
| `at(key)`            | **O(1)** | O(n)                |
| `insert({key, val})` | **O(1)** | O(n)                |
| `emplace(key, val)`  | **O(1)** | O(n)                |
| `erase(key)`         | **O(1)** | O(n)                |
| `find(key)`          | **O(1)** | O(n)                |
| `count(key)`         | **O(1)** | O(n)                |
| Iteration            | **O(n)** | O(n + bucket_count) |

### 5.3 Syntax & All Important Functions

```cpp
#include <unordered_map>

// ─────────────────────────── Construction ───────────────────────────
std::unordered_map<std::string, int> um1;
std::unordered_map<std::string, int> um2 = {{"a", 1}, {"b", 2}};
std::unordered_map<std::string, int> um3(100);  // 100 initial buckets

// ─────────────────────────── Element Access ─────────────────────────
um["key"];          // Access OR INSERT default if not found!
um.at("key");       // Access, THROWS if not found

// ─────────────────────────── Modifiers ──────────────────────────────
um["key"] = 42;                            // Insert or update
um.insert({"key", 42});                   // Insert only (no update)
um.insert_or_assign("key", 42);          // C++17: Insert or update
um.try_emplace("key", 42);              // C++17: No construction if key exists
um.emplace("key", 42);                   // Construct in-place
um.erase("key");                          // Erase by key
um.erase(it);                             // Erase by iterator
um.clear();                               // Remove all

// ─────────────────────────── Lookup ─────────────────────────────────
um.find("key");        // Iterator or end()
um.count("key");       // 0 or 1
um.contains("key");    // C++20

// ─────────────────────────── Hash Policy ────────────────────────────
um.load_factor();
um.max_load_factor();
um.rehash(n);
um.reserve(n);           // Pre-allocate for n elements WITHOUT rehashing later
um.bucket_count();
um.bucket("key");

// ─────────────────────────── Node Operations (C++17) ────────────────
auto node = um.extract("key");
um.insert(std::move(node));
um.merge(other_map);
```

### 5.4 Code Examples

#### Example 1: Frequency Counter (Most Common Pattern)

```cpp
#include <iostream>
#include <unordered_map>
#include <vector>
#include <string>

int main() {
    std::vector<std::string> words = {"hello", "world", "hello", "cpp", "hello", "world"};
    
    std::unordered_map<std::string, int> freq;
    for (const auto& w : words) {
        freq[w]++;  // O(1) average per operation
    }
    
    // Find most frequent word
    std::string most_freq;
    int max_count = 0;
    for (const auto& [word, count] : freq) {
        if (count > max_count) {
            max_count = count;
            most_freq = word;
        }
    }
    
    std::cout << "Most frequent: " << most_freq << " (" << max_count << " times)\n";
    // Output: Most frequent: hello (3 times)
    
    return 0;
}
```

#### Example 2: Two Sum Problem

```cpp
#include <iostream>
#include <unordered_map>
#include <vector>

std::vector<int> twoSum(const std::vector<int>& nums, int target) {
    std::unordered_map<int, int> seen;  // value → index
    
    for (int i = 0; i < nums.size(); i++) {
        int complement = target - nums[i];
        auto it = seen.find(complement);
        if (it != seen.end()) {
            return {it->second, i};
        }
        seen[nums[i]] = i;
    }
    return {};
}

int main() {
    auto result = twoSum({2, 7, 11, 15}, 9);
    std::cout << result[0] << ", " << result[1] << "\n";  // 0, 1
    return 0;
}
```

#### Example 3: Grouping with unordered_map

```cpp
#include <iostream>
#include <unordered_map>
#include <vector>
#include <string>
#include <algorithm>

int main() {
    // Group anagrams
    std::vector<std::string> words = {"eat", "tea", "tan", "ate", "nat", "bat"};
    
    std::unordered_map<std::string, std::vector<std::string>> groups;
    
    for (const auto& word : words) {
        std::string key = word;
        std::sort(key.begin(), key.end());  // Sorted version as key
        groups[key].push_back(word);
    }
    
    for (const auto& [key, group] : groups) {
        for (const auto& w : group) std::cout << w << " ";
        std::cout << "\n";
    }
    // Output (order may vary):
    // eat tea ate
    // tan nat
    // bat
    
    return 0;
}
```

### 5.5 When to Use

✅ **Use unordered_map when:**
- You need the fastest possible key-value lookup
- Order doesn't matter
- Frequency counting
- Memoization / caching
- Two-sum style problems

### 5.6 When NOT to Use

❌ **Don't use unordered_map when:**
- You need sorted iteration → use `map`
- You need lower_bound/upper_bound → use `map`
- Adversarial input (competitive programming anti-hash tests)
- Key type is hard to hash (complex structs)

---

## 6. std::unordered_multimap

### 6.1 Concept

Like `unordered_map` but allows **duplicate keys**. No `operator[]` or `at()`.

```cpp
#include <unordered_map>

std::unordered_multimap<std::string, int> umm;
umm.insert({"Alice", 90});
umm.insert({"Alice", 95});  // Duplicate key OK
umm.insert({"Bob", 85});

// Access all values for a key
auto [lo, hi] = umm.equal_range("Alice");
for (auto it = lo; it != hi; ++it) {
    std::cout << it->second << " ";  // 90 95
}
```

---

## 7. Hash Functions Deep Dive

### 7.1 How std::hash Works

The standard library provides `std::hash<T>` specializations for built-in types:

```cpp
#include <functional>

std::hash<int> h1;
std::cout << h1(42) << "\n";           // Some integer (e.g., 42)

std::hash<std::string> h2;
std::cout << h2("hello") << "\n";      // Some large integer

std::hash<double> h3;
std::cout << h3(3.14) << "\n";         // Some integer

// Types with std::hash support:
// int, long, long long, unsigned variants
// float, double
// std::string, std::string_view
// pointer types
// bool, char
```

### 7.2 Types WITHOUT std::hash

```cpp
// These do NOT have std::hash by default:
// std::pair<T1, T2>        ❌
// std::tuple<T...>         ❌
// std::vector<T>           ❌
// User-defined types       ❌

// You must provide a custom hash for these!
```

### 7.3 Properties of a Good Hash Function

1. **Deterministic**: Same input → same output
2. **Uniform distribution**: Spread values across all buckets
3. **Fast to compute**: Hash computation should be O(1);
4. **Avalanche effect**: Small change in input → large change in output

### 7.4 Common Hash Combination Technique

```cpp
// Combine multiple hash values (e.g., for pair or struct)
struct PairHash {
    template <typename T1, typename T2>
    size_t operator()(const std::pair<T1, T2>& p) const {
        auto h1 = std::hash<T1>{}(p.first);
        auto h2 = std::hash<T2>{}(p.second);
        // Combine using XOR and bit shifting
        return h1 ^ (h2 << 1);
    }
};

// Better combination (Boost-style)
template <typename T>
inline void hash_combine(size_t& seed, const T& val) {
    seed ^= std::hash<T>{}(val) + 0x9e3779b9 + (seed << 6) + (seed >> 2);
}

struct PairHashBetter {
    template <typename T1, typename T2>
    size_t operator()(const std::pair<T1, T2>& p) const {
        size_t seed = 0;
        hash_combine(seed, p.first);
        hash_combine(seed, p.second);
        return seed;
    }
};

// Usage:
std::unordered_set<std::pair<int, int>, PairHash> ps;
ps.insert({1, 2});
ps.insert({3, 4});

std::unordered_map<std::pair<int, int>, std::string, PairHash> pm;
pm[{1, 2}] = "point";
```

---

## 8. Load Factor & Rehashing

### 8.1 What is Load Factor?

$$\text{load\_factor} = \frac{\text{size()}}{\text{bucket\_count()}}$$

| Load Factor | Meaning      | Effect                |
| ----------- | ------------ | --------------------- |
| < 0.5       | Underfull    | Wasted memory         |
| 0.5 - 0.75  | Optimal      | Good balance          |
| 0.75 - 1.0  | Getting full | More collisions       |
| > 1.0       | Overfull     | Many collisions, slow |

### 8.2 auto Rehashing

When `load_factor() > max_load_factor()`, the container automatically:

1. Allocates a new larger bucket array (typically 2× size)
2. Recomputes `hash(key) % new_bucket_count` for EVERY element
3. Moves every element to its new bucket
4. Deallocates old bucket array

**Cost: O(n)** — but amortized over many insertions, this is O(1) per insert.

### 8.3 Controlling Rehashing

```cpp
std::unordered_map<int, int> um;

// Set max load factor (default is 1.0)
um.max_load_factor(0.5);  // More memory, fewer collisions

// Pre-allocate buckets
um.rehash(100);  // At least 100 buckets

// Reserve for expected number of elements (best practice!)
um.reserve(1000);
// This calls rehash(ceil(1000 / max_load_factor()))
// So with max_load_factor 1.0, it creates ~1000 buckets
// This prevents ALL rehashing during insertion of up to 1000 elements!
```

### 8.4 Rehashing Visualization

```
Before rehash (4 buckets, 4 elements, LF = 1.0):
┌────┬────┬────┬────┐
│ 0  │ 1  │ 2  │ 3  │
│ ↓  │ ↓  │ ↓  │ ↓  │
│ 8  │ 1  │ 2  │ 7  │
│ ↓  │    │    │ ↓  │
│ 4  │    │    │ 3  │
└────┴────┴────┴────┘

Insert 5 → triggers rehash (LF would exceed 1.0):

After rehash (8 buckets, 5 elements, LF = 0.625):
┌────┬────┬────┬────┬────┬────┬────┬────┐
│ 0  │ 1  │ 2  │ 3  │ 4  │ 5  │ 6  │ 7  │
│ ↓  │ ↓  │ ↓  │ ↓  │ ↓  │ ↓  │    │ ↓  │
│ 8  │ 1  │ 2  │ 3  │ 4  │ 5  │    │ 7  │
└────┴────┴────┴────┴────┴────┴────┴────┘
```

---

## 9. Collision Handling

### 9.1 Separate Chaining (Used by STL)

The C++ STL uses **separate chaining**: each bucket contains a linked list of elements that hash to the same bucket.

```
Bucket 3: → [key1, val1] → [key2, val2] → [key3, val3] → null
```

**Pros:** Simple, works well for any load factor
**Cons:** Linked list traversal is cache-unfriendly

### 9.2 How Collisions Affect Performance

```
Perfect hash (no collisions):     O(1) for all operations
Few collisions (LF < 0.75):       O(1) average, short chains
Many collisions (LF > 1.0):       O(k) where k = average chain length
Worst case (all same bucket):     O(n) — degrades to linked list!
```

### 9.3 When Collisions Become a Problem

```cpp
// ADVERSARIAL EXAMPLE: All elements hash to same bucket
// This can happen if an attacker controls the input!

// In competitive programming, some problems have anti-hash tests:
std::unordered_map<int, int> um;  // Might TLE on crafted data!

// Solution: Use custom hash to randomize
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

std::unordered_map<int, int, SafeHash> safe_map;  // Resistant to anti-hash!
```

---

## 10. Custom Hash Functions

### 10.1 Hash for pair<int, int>

```cpp
struct PairHash {
    size_t operator()(const std::pair<int, int>& p) const {
        auto h1 = std::hash<int>{}(p.first);
        auto h2 = std::hash<int>{}(p.second);
        return h1 ^ (h2 * 2654435761);  // Better than simple XOR
    }
};

std::unordered_set<std::pair<int, int>, PairHash> point_set;
point_set.insert({1, 2});

std::unordered_map<std::pair<int, int>, std::string, PairHash> grid;
grid[{0, 0}] = "origin";
```

### 10.2 Hash for Custom Struct

```cpp
struct Point3D {
    int x, y, z;
    
    bool operator==(const Point3D& other) const {
        return x == other.x && y == other.y && z == other.z;
    }
};

struct Point3DHash {
    size_t operator()(const Point3D& p) const {
        size_t seed = 0;
        seed ^= std::hash<int>{}(p.x) + 0x9e3779b9 + (seed << 6) + (seed >> 2);
        seed ^= std::hash<int>{}(p.y) + 0x9e3779b9 + (seed << 6) + (seed >> 2);
        seed ^= std::hash<int>{}(p.z) + 0x9e3779b9 + (seed << 6) + (seed >> 2);
        return seed;
    }
};

std::unordered_set<Point3D, Point3DHash> points;
std::unordered_map<Point3D, std::string, Point3DHash> labels;
```

### 10.3 Hash for vector<int> (Use with Caution)

```cpp
struct VectorHash {
    size_t operator()(const std::vector<int>& v) const {
        size_t seed = v.size();
        for (auto x : v) {
            seed ^= std::hash<int>{}(x) + 0x9e3779b9 + (seed << 6) + (seed >> 2);
        }
        return seed;
    }
};

// Use case: group identical sequences
std::unordered_map<std::vector<int>, int, VectorHash> sequence_count;
```

### 10.4 Specializing std::hash (Alternative Approach)

```cpp
struct Point {
    int x, y;
    bool operator==(const Point& o) const { return x == o.x && y == o.y; }
};

// Specialize std::hash in the std namespace
namespace std {
    template <>
    struct hash<Point> {
        size_t operator()(const Point& p) const {
            return hash<int>()(p.x) ^ (hash<int>()(p.y) << 16);
        }
    };
}

// Now you can use Point directly without specifying hash:
std::unordered_set<Point> points;
std::unordered_map<Point, std::string> labels;
```

### 10.5 Competitive Programming Safe Hash

```cpp
// This is the GOLD STANDARD for competitive programming
// Resistant to anti-hash attacks

struct custom_hash {
    static uint64_t splitmix64(uint64_t x) {
        x += 0x9e3779b97f4a7c15;
        x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
        x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
        return x ^ (x >> 31);
    }
    
    size_t operator()(uint64_t x) const {
        static const uint64_t FIXED_RANDOM = 
            chrono::steady_clock::now().time_since_epoch().count();
        return splitmix64(x + FIXED_RANDOM);
    }
};

// Usage:
unordered_map<long long, int, custom_hash> safe_map;
// This prevents TLE from anti-hash test cases!
```

---

## 11. Performance Analysis

### 11.1 Unordered vs Ordered Containers

| Metric             | unordered_map  | map          |
| ------------------ | -------------- | ------------ |
| Average insert     | **O(1)**       | O(log n)     |
| Average find       | **O(1)**       | O(log n)     |
| Worst case         | O(n)           | **O(log n)** |
| Memory per element | ~50-70 bytes   | ~40 bytes    |
| Cache performance  | Moderate       | Poor         |
| Ordered iteration  | ❌              | ✅            |
| Lower/Upper bound  | ❌              | ✅            |
| Hash computation   | Yes (overhead) | No           |

### 11.2 When Each Container Wins

```
n < 50:           map often wins (hash overhead dominates)
50 < n < 10^6:    unordered_map usually wins
n > 10^6:         unordered_map significantly wins
Adversarial data: map always wins (guaranteed O(log n))
Need ordering:    map is the only choice
String keys:      map may win (hash(string) is expensive)
Int keys:         unordered_map wins big (hash(int) is trivial)
```

### 11.3 Practical Benchmarks

```
Approximate operations per second (modern CPU, n = 1M):

Operation           map        unordered_map
─────────────────────────────────────────────
insert (int)       ~5M/s       ~20M/s
find (int)         ~10M/s      ~50M/s
insert (string)    ~2M/s       ~5M/s
find (string)      ~3M/s       ~8M/s
iteration          ~30M/s      ~40M/s

With reserve():    unordered_map is ~30% faster (no rehashing)
```

---

## 12. Common Mistakes

### Mistake 1: Forgetting to Reserve

```cpp
// ❌ SLOW: Multiple rehashes as the map grows
std::unordered_map<int, int> um;
for (int i = 0; i < 1000000; i++) {
    um[i] = i;  // Triggers ~20 rehashes!
}

// ✅ FAST: One allocation
std::unordered_map<int, int> um;
um.reserve(1000000);  // Pre-allocate!
for (int i = 0; i < 1000000; i++) {
    um[i] = i;
}
```

### Mistake 2: Using pair as Key Without Hash

```cpp
// ❌ COMPILE ERROR: No std::hash for pair!
std::unordered_map<std::pair<int,int>, int> m;

// ✅ Provide custom hash
std::unordered_map<std::pair<int,int>, int, PairHash> m;
```

### Mistake 3: Relying on Iteration Order

```cpp
std::unordered_map<std::string, int> um = {{"c", 3}, {"a", 1}, {"b", 2}};

// ❌ DON'T assume any specific order
for (auto& [k, v] : um) {
    std::cout << k << " ";  // Could be "b a c" or "c a b" or anything!
}

// After rehashing, the order may completely change!
```

### Mistake 4: operator[] on const unordered_map

```cpp
const std::unordered_map<int, int> um = {{1, 10}};
// um[1];  // ❌ COMPILE ERROR! operator[] is non-const
um.at(1);  // ✅ Works on const
```

### Mistake 5: Not Handling Worst Case in CP

```cpp
// ❌ Can be hacked with anti-hash tests
unordered_map<int, int> um;

// ✅ Use custom hash
unordered_map<int, int, custom_hash> um;

// ✅ Or just use map (guaranteed O(log n))
map<int, int> m;
```

---

## 13. Interview Tips

### Must-Know Questions

**Q1: How does an unordered_map handle collisions?**
> Separate chaining: each bucket has a linked list. Elements hashing to the same bucket are appended to the list. On lookup, the chain is traversed to find the matching key.

**Q2: What is the worst case of unordered_map::find?**
> O(n), when all elements hash to the same bucket. The chain becomes a linked list of length n.

**Q3: When does rehashing occur?**
> When `load_factor()` exceeds `max_load_factor()` (default 1.0) after an insertion. The bucket array is resized (typically doubled) and all elements are re-hashed.

**Q4: How do you use a custom type as a key in unordered_map?**
> You need to provide: (1) a hash function (via template parameter or `std::hash` specialization), and (2) an equality operator (`operator==`).

**Q5: Why might unordered_map be slower than map for small n?**
> Hash computation has overhead. For small n, the constant cost of hashing may exceed the O(log n) cost of tree traversal. Also, tree nodes may fit in cache for small n.

**Q6: What is the difference between rehash(n) and reserve(n)?**
> `rehash(n)` sets the bucket count to at least n. `reserve(n)` sets the bucket count so that at least n elements can be inserted without rehashing — it calls `rehash(ceil(n / max_load_factor()))`.

---

## 14. Competitive Programming Tricks

### Trick 1: Safe Hash Map

```cpp
#include <bits/stdc++.h>
using namespace std;

struct custom_hash {
    static uint64_t splitmix64(uint64_t x) {
        x += 0x9e3779b97f4a7c15;
        x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
        x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
        return x ^ (x >> 31);
    }
    size_t operator()(uint64_t x) const {
        static const uint64_t FIXED_RANDOM = 
            chrono::steady_clock::now().time_since_epoch().count();
        return splitmix64(x + FIXED_RANDOM);
    }
};

// Always use this in competitive programming:
unordered_map<int, int, custom_hash> mp;
```

### Trick 2: gp_hash_table (Fastest Hash Map)

```cpp
#include <ext/pb_ds/assoc_container.hpp>
using namespace __gnu_pbds;

// Policy-based hash table: ~2-3x faster than unordered_map
gp_hash_table<int, int, custom_hash> mp;
// Uses open addressing (probing) instead of chaining
// Much better cache performance
```

### Trick 3: Frequency Counting

```cpp
unordered_map<int, int, custom_hash> freq;
for (int x : arr) freq[x]++;

// Find mode (most frequent element)
int mode = max_element(freq.begin(), freq.end(),
    [](auto& a, auto& b) { return a.second < b.second; })->first;
```

### Trick 4: Check If Array Has Duplicates

```cpp
bool hasDuplicates(vector<int>& v) {
    unordered_set<int> seen;
    for (int x : v) {
        if (!seen.insert(x).second) return true;
    }
    return false;
}
// O(n) average time
```

### Trick 5: Subarray Sum Equals K

```cpp
int subarraySumK(vector<int>& nums, int k) {
    unordered_map<int, int> prefix_count;
    prefix_count[0] = 1;
    int sum = 0, count = 0;
    
    for (int x : nums) {
        sum += x;
        count += prefix_count[sum - k];
        prefix_count[sum]++;
    }
    return count;
}
```

### Trick 6: Longest Consecutive Sequence

```cpp
int longestConsecutive(vector<int>& nums) {
    unordered_set<int> s(nums.begin(), nums.end());
    int best = 0;
    
    for (int x : s) {
        if (!s.count(x - 1)) {  // Start of a sequence
            int len = 1;
            while (s.count(x + len)) len++;
            best = max(best, len);
        }
    }
    return best;  // O(n) overall
}
```

---

## 15. Edge Cases

### Empty Container

```cpp
std::unordered_map<int, int> um;
um.find(1);            // Returns um.end()
um.count(1);           // Returns 0
um.bucket_count();     // Implementation-defined (often 1)
um.load_factor();      // 0.0
```

### Single Element

```cpp
std::unordered_set<int> us = {42};
us.bucket_count();     // At least 1
us.load_factor();      // 1.0 (or less if more buckets allocated)
```

### Negative Keys

```cpp
std::unordered_set<int> us;
us.insert(-1);   // ✅ Works fine
us.insert(-100); // ✅ Hash handles negative numbers
```

### Iteration After Rehash

```cpp
std::unordered_map<int, int> um;
auto it = um.begin();  // Save iterator

um.insert({1, 1});
um.insert({2, 2});
// ... many insertions causing rehash

// ❌ 'it' may be INVALIDATED by rehash!
// Always get fresh iterators after modifications
```

### Float/Double as Keys

```cpp
// ⚠️ DON'T use floating point as hash keys!
std::unordered_map<double, int> um;
um[0.1 + 0.2] = 1;
um[0.3] = 2;
// 0.1 + 0.2 != 0.3 due to floating point precision!
// These are TWO different entries!
```

---

## 16. Summary

```
┌────────────────────────────────────────────────────────────────┐
│            UNORDERED CONTAINERS CHEAT SHEET                     │
├────────────────┬──────────────────────────────────────────────┤
│ unordered_set  │ Unique elements, hash-based. O(1) avg.       │
│                │ No order. Need hash function for key type.    │
├────────────────┼──────────────────────────────────────────────┤
│ unordered_     │ Like unordered_set but allows duplicates.    │
│ multiset       │ erase(val) removes ALL — use erase(it)!     │
├────────────────┼──────────────────────────────────────────────┤
│ unordered_map  │ Key→Value, unique keys, hash-based.          │
│                │ operator[] inserts default! O(1) avg.        │
├────────────────┼──────────────────────────────────────────────┤
│ unordered_     │ Like unordered_map with duplicate keys.      │
│ multimap       │ No operator[]. Use equal_range().            │
├────────────────┼──────────────────────────────────────────────┤
│ ALL            │ Hash table. O(1) avg, O(n) worst. Forward    │
│                │ iterators. reserve() prevents rehashing.     │
└────────────────┴──────────────────────────────────────────────┘

GOLDEN RULES:
1. Always reserve() if you know the size
2. Use custom_hash in competitive programming
3. Never use float/double as keys
4. For pair/tuple keys, provide custom hash
5. Worst case is O(n) — can be exploited!
```

---

## 17. Practice Section

### Level 1 — Quick Concept Questions

1. **Q: What data structure underlies `unordered_map`?**
   <details><summary>Answer</summary>Hash table with separate chaining.</details>

2. **Q: What is the default `max_load_factor`?**
   <details><summary>Answer</summary>1.0</details>

3. **Q: What happens during rehashing?**
   <details><summary>Answer</summary>A larger bucket array is allocated, and all elements are re-hashed and moved to their new buckets. This is O(n).</details>

4. **Q: Can you use `std::pair<int,int>` as a key in `unordered_map` directly?**
   <details><summary>Answer</summary>No. You must provide a custom hash function because `std::hash` is not specialized for `std::pair`.</details>

5. **Q: What is the worst-case lookup time for `unordered_map`?**
   <details><summary>Answer</summary>O(n), when all elements hash to the same bucket.</details>

6. **Q: How does `reserve(n)` differ from `rehash(n)`?**
   <details><summary>Answer</summary>`reserve(n)` ensures n elements can be inserted without rehashing. `rehash(n)` sets the bucket count to at least n.</details>

7. **Q: Does `unordered_set` maintain insertion order?**
   <details><summary>Answer</summary>No. There is no ordering guarantee.</details>

8. **Q: What collision resolution does STL use?**
   <details><summary>Answer</summary>Separate chaining (linked lists per bucket).</details>

9. **Q: Can `unordered_map` use `lower_bound()`?**
   <details><summary>Answer</summary>No. Since elements are not ordered, lower_bound doesn't exist for unordered containers.</details>

10. **Q: What iterator type does `unordered_set` provide?**
    <details><summary>Answer</summary>Forward iterator (can only move forward, not backward).</details>

---

### Level 2 — MCQs

**1. What is the average time complexity of `unordered_map::find`?**
- A) O(log n)
- B) O(1) ✅
- C) O(n)
- D) O(n log n)

**2. Which container does NOT support `lower_bound`?**
- A) `set`
- B) `map`
- C) `unordered_map` ✅
- D) `multiset`

**3. What triggers a rehash?**
- A) When size exceeds capacity
- B) When load factor exceeds max_load_factor ✅
- C) When a collision occurs
- D) Every 100 insertions

**4. `unordered_set<int>` elements are ordered by:**
- A) Insertion order
- B) Sorted order
- C) Hash value
- D) No guaranteed order ✅

**5. What does `unordered_map::bucket(key)` return?**
- A) The value associated with key
- B) The bucket index where key is stored ✅
- C) The number of elements with that key
- D) A boolean

**6. Which requires a custom hash function?**
- A) `unordered_set<int>`
- B) `unordered_map<string, int>`
- C) `unordered_set<pair<int,int>>` ✅
- D) `unordered_set<double>`

**7. After `unordered_map<int,int> m; m.reserve(1000);`, what is true?**
- A) m.size() == 1000
- B) m can hold 1000 elements without rehashing ✅
- C) m.bucket_count() == 1000
- D) m has 1000 default elements

**8. The `0x9e3779b9` constant used in hash combining is related to:**
- A) Mersenne primes
- B) The golden ratio ✅ ($2^{32} / \phi$)
- C) Pi
- D) A random number

**9. `unordered_map` iteration order is:**
- A) Always the same across runs
- B) May change after rehashing ✅
- C) Always sorted
- D) Always reverse-sorted

**10. What type has NO default `std::hash` specialization?**
- A) `int`
- B) `std::string`
- C) `std::vector<int>` ✅
- D) `double`

---

### Level 3 — Tricky Interview MCQs

**1. What is the output?**
```cpp
std::unordered_map<int, int> m;
m.reserve(100);
std::cout << m.size() << " " << m.bucket_count();
```
- A) `0 100`
- B) `100 100`
- C) `0 >= 100` ✅ (bucket_count may be ≥ 100)
- D) `100 0`

**2. Which is true about iterator invalidation in `unordered_map`?**
- A) insert never invalidates iterators
- B) insert can invalidate ALL iterators (on rehash) ✅
- C) erase invalidates all iterators
- D) find invalidates iterators

**3. What happens here?**
```cpp
std::unordered_set<int> s = {1, 2, 3};
for (auto it = s.begin(); it != s.end(); ++it) {
    s.insert(*it + 10);
}
```
- A) Works fine, adds 11, 12, 13
- B) Infinite loop
- C) Undefined behavior ✅ (inserting during iteration can cause rehash → iterator invalidation)
- D) Compilation error

**4. Why might `unordered_map<string, int>` be slower than `map<string, int>` for some workloads?**
- A) Because hash tables are always slower
- B) Because string hashing is O(n) in string length ✅ (so total is O(L) per operation, not O(1))
- C) Because maps don't use comparison
- D) Because unordered_map uses more memory

**5. In competitive programming, when should you prefer `map` over `unordered_map`?**
- A) Always, map is faster
- B) When you need O(1) operations
- C) When there might be anti-hash test cases ✅
- D) When you need to iterate in reverse

---

### Level 4 — True / False

| #   | Statement                                               | Answer                                          |
| --- | ------------------------------------------------------- | ----------------------------------------------- |
| 1   | `unordered_map` guarantees O(1) worst-case find         | **False** (O(n) worst)                          |
| 2   | `reserve()` prevents all future rehashing               | **False** (only up to reserved count)           |
| 3   | `unordered_set` provides bidirectional iterators        | **False** (forward only)                        |
| 4   | `float` can be used as `unordered_map` key              | **True** (but not recommended)                  |
| 5   | `unordered_map::operator[]` can insert elements         | **True**                                        |
| 6   | Hash table bucket count is always a power of 2          | **False** (implementation-defined, often prime) |
| 7   | `unordered_set` automatically removes duplicates        | **True**                                        |
| 8   | Rehashing invalidates all iterators                     | **True**                                        |
| 9   | `unordered_map` uses more memory than `map` per element | **True** (typically)                            |
| 10  | `load_factor()` can exceed `max_load_factor()`          | **False** (rehash occurs to prevent this)       |

---

### Level 5 — Coding Practice Problems

**Problem 1: Two Sum**
```cpp
// Given array and target, find two indices whose values sum to target.
// Return {i, j} or {} if not found.
// Must be O(n) average time.
// Hint: Use unordered_map<int, int> to map value → index
```

**Problem 2: Group Anagrams**
```cpp
// Given array of strings, group anagrams together.
// Input: ["eat", "tea", "tan", "ate", "nat", "bat"]
// Output: [["eat","tea","ate"], ["tan","nat"], ["bat"]]
// Hint: Sort each string as key in unordered_map
```

**Problem 3: Longest Consecutive Sequence**
```cpp
// Given unsorted array, find length of longest consecutive element sequence.
// Must be O(n).
// Input: [100, 4, 200, 1, 3, 2]
// Output: 4 (sequence: 1, 2, 3, 4)
// Hint: Use unordered_set, start only from sequence beginnings
```

**Problem 4: Implement LRU Cache**
```cpp
// Design a data structure with O(1) get and put:
// get(key): Return value, mark as recently used
// put(key, value): Insert or update, evict LRU if full
// Hint: unordered_map + doubly linked list
```

**Problem 5: Count Subarrays with Sum K**
```cpp
// Given integer array and integer k, count subarrays with sum exactly k.
// Must be O(n).
// Input: [1, 2, 3], k = 3
// Output: 2 (subarrays: [1,2] and [3])
// Hint: Use unordered_map with prefix sums
```

---

---

## 18. Extended Examples with Test Cases

### Example 1 — unordered_map basic usage and pitfalls

```cpp
#include <iostream>
#include <unordered_map>
using namespace std;

int main() {
    unordered_map<string, int> freq;

    string words[] = {"apple","banana","apple","cherry","banana","apple"};
    for (auto& w : words) freq[w]++;

    for (auto& [word, cnt] : freq)
        cout << word << ":" << cnt << " ";
    cout << "\n";
    // Output (order unspecified): apple:3 banana:2 cherry:1

    // Checking existence: use count() or find(), NOT operator[]
    if (freq.count("apple"))    // safe — no insertion
        cout << "apple found\n";

    if (freq.find("grape") == freq.end())
        cout << "grape not found\n";

    // Dangerous: operator[] INSERTS if key absent
    cout << freq["grape"] << "\n";  // 0 — now grape IS in map!
    cout << freq.size() << "\n";    // 4 — unexpectedly grew

    return 0;
}
```

---

### Example 2 — hash collision and bucket inspection

```cpp
#include <iostream>
#include <unordered_map>
using namespace std;

int main() {
    unordered_map<int,int> m;
    m.reserve(100);  // pre-size to avoid rehashing

    for (int i = 0; i < 10; i++) m[i] = i * i;

    cout << "size="         << m.size()          << "\n";   // 10
    cout << "bucket_count=" << m.bucket_count()  << "\n";   // >= 100
    cout << "load_factor="  << m.load_factor()   << "\n";   // 10 / bucket_count
    cout << "max_load_fct=" << m.max_load_factor()<< "\n";  // 1

    // Which bucket holds key 5?
    cout << "key 5 → bucket " << m.bucket(5) << "\n";

    // Inspect bucket
    int b = m.bucket(5);
    cout << "bucket " << b << " elements: ";
    for (auto it = m.begin(b); it != m.end(b); ++it)
        cout << it->first << " ";
    cout << "\n";

    return 0;
}
```

---

### Example 3 — custom hash for pair key

```cpp
#include <iostream>
#include <unordered_map>
using namespace std;

struct PairHash {
    size_t operator()(const pair<int,int>& p) const {
        size_t h1 = hash<int>{}(p.first);
        size_t h2 = hash<int>{}(p.second);
        return h1 ^ (h2 * 0x9e3779b9 + (h1 << 6) + (h1 >> 2));
    }
};

int main() {
    unordered_map<pair<int,int>, string, PairHash> grid;

    grid[{0, 0}] = "origin";
    grid[{1, 2}] = "point A";
    grid[{-1, 3}] = "point B";

    cout << grid[{1, 2}] << "\n";   // point A
    cout << grid.count({5, 5}) << "\n"; // 0

    return 0;
}
```

---

### Example 4 — unordered_set for O(1) lookup

```cpp
#include <iostream>
#include <unordered_set>
#include <vector>
using namespace std;

int main() {
    // Find duplicate in array — O(n) using unordered_set
    vector<int> arr = {1, 3, 4, 2, 2};
    unordered_set<int> seen;

    for (int x : arr) {
        if (seen.count(x)) {
            cout << "Duplicate: " << x << "\n";  // Duplicate: 2
            break;
        }
        seen.insert(x);
    }

    // Intersection of two arrays — O(n+m)
    vector<int> a = {1, 2, 3, 4, 5};
    vector<int> b = {4, 5, 6, 7, 8};
    unordered_set<int> sa(a.begin(), a.end());

    vector<int> common;
    for (int x : b)
        if (sa.count(x)) common.push_back(x);

    for (int x : common) cout << x << " ";
    cout << "\n";  // 4 5

    return 0;
}
```

---

### Example 5 — rehashing demonstration

```cpp
#include <iostream>
#include <unordered_map>
using namespace std;

int main() {
    unordered_map<int,int> m;
    cout << "Initial bucket_count: " << m.bucket_count() << "\n"; // 1 (or small)

    for (int i = 0; i < 20; i++) {
        m[i] = i;
        if (m.load_factor() > 0.75)
            cout << "Rehash at size=" << m.size()
                 << " bc=" << m.bucket_count() << "\n";
    }

    // Force rehash
    m.rehash(50);
    cout << "After rehash(50): bc=" << m.bucket_count() << "\n"; // >= 50

    // max_load_factor tuning
    m.max_load_factor(0.5);
    cout << "max_load_factor: " << m.max_load_factor() << "\n";  // 0.5

    return 0;
}
```

---

## 19. Tricky MCQs — Expert Level

**Q1. What is the output?**
```cpp
unordered_map<int,int> m;
m[1] = 10;
m[2] = 20;
m[1] = 30;
cout << m.size() << " " << m[1];
```
- A) `3 30`
- B) `2 30` ✅
- C) `2 10`
- D) `3 10`

> **Why:** `m[1]=30` overwrites the existing key. Size remains 2.

---

**Q2. Iterating over `unordered_map` while inserting new keys:**
```cpp
unordered_map<int,int> m = {{1,1},{2,2},{3,3}};
for (auto& [k,v] : m)
    m[k+10] = v;
```
- A) Inserts 11, 12, 13 safely
- B) Undefined behavior — insertion during range-for can trigger rehash → iterator invalidation ✅
- C) Compilation error
- D) Infinite loop

---

**Q3. Which operation has O(n) worst-case in `unordered_map`?**
- A) `reserve`
- B) `count`
- C) `find` ✅ (due to hash collision, all keys in one bucket)
- D) `empty`

---

**Q4. What is the default `max_load_factor` for `unordered_map`?**
- A) 0.75
- B) 1.0 ✅
- C) 2.0
- D) 0.5

---

**Q5. Which is true about `unordered_set<float>`?**
- A) Will not compile
- B) Works correctly for all floats
- C) Works but not recommended — floating point hash/equality is fragile ✅
- D) Always throws at runtime

---

**Q6. What does `m.bucket_count()` return immediately after `m.reserve(100)` on an empty map?**
- A) 100 exactly
- B) At least enough buckets to hold 100 elements without exceeding max_load_factor ✅
- C) 0
- D) max_load_factor × 100

---

**Q7. After erasing an element from `unordered_map`, which iterators are invalidated?**
- A) All iterators
- B) Only the iterator to the erased element ✅
- C) All iterators in the same bucket
- D) The end iterator

---

**Q8. `unordered_map` vs `map` — when is `map` faster in practice?**
- A) Never — hash table is always O(1)
- B) When keys are long strings (hash is O(key_length)) ✅ or when cache effects favor tree
- C) When the map has fewer than 100 elements
- D) When keys are integers

---

**Q9. What is the complexity of constructing `unordered_set<int> s(v.begin(), v.end())` from a vector of n elements?**
- A) O(n log n)
- B) O(n) average ✅
- C) O(n²)
- D) O(1)

---

**Q10. To prevent anti-hash attacks in competitive programming, you should:**
- A) Use `map` instead
- B) Use a custom hash with a random seed ✅
- C) Use `multiset`
- D) Increase `max_load_factor`

---

**Q11. What is printed?**
```cpp
unordered_map<int,int> m = {{1,100},{2,200},{3,300}};
m.erase(2);
cout << m.count(2) << " " << m.size();
```
- A) `1 3`
- B) `0 2` ✅
- C) `0 3`
- D) Undefined

---

**Q12. `unordered_multimap` vs `unordered_map` — the key difference is:**
- A) Multimap is slower
- B) Multimap stores sorted keys
- C) Multimap allows multiple values for the same key ✅
- D) Multimap uses open addressing

---

> **Previous:** [03_STL_Associative_Containers.md](03_STL_Associative_Containers.md)  
> **Next:** [05_STL_Container_Adapters.md](05_STL_Container_Adapters.md)
