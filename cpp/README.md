# 🚀 The Ultimate C++ STL Guide

## From Beginner → Intermediate → Competitive Programming → Expert

<p align="center">
  <strong>A comprehensive, deep-dive reference into the C++ Standard Template Library</strong><br>
  <em>Complete with internals, complexity analysis, practice problems, and competitive programming tricks</em>
</p>

---

```
  ╔══════════════════════════════════════════════════════════════╗
  ║              THE C++ STANDARD TEMPLATE LIBRARY              ║
  ║                                                              ║
  ║   Containers ──── Algorithms ──── Iterators ──── Functors   ║
  ║       │               │               │             │        ║
  ║   Sequence        Sorting         Input          Lambda      ║
  ║   Associative     Searching       Output         std::func   ║
  ║   Unordered       Modifying       Forward        Predicates  ║
  ║   Adapters        Numeric         Bidir/RA       Binders     ║
  ╚══════════════════════════════════════════════════════════════╝
```

---

## 📋 Table of Contents

| #   | Chapter                                                              | Topics Covered                                                               | Level                       |
| --- | -------------------------------------------------------------------- | ---------------------------------------------------------------------------- | --------------------------- |
| 01  | [**STL Fundamentals**](01_STL_Fundamentals.md)                       | STL Architecture, `pair`, `tuple`, Iterator Categories, Complexity Rules     | 🟢 Beginner                  |
| 02  | [**Sequence Containers**](02_STL_Sequence_Containers.md)             | `vector`, `deque`, `list`, `forward_list`, `array`, Internal Memory Layouts  | 🟢 Beginner → 🟡 Intermediate |
| 03  | [**Associative Containers**](03_STL_Associative_Containers.md)       | `set`, `multiset`, `map`, `multimap`, Red-Black Trees, Custom Comparators    | 🟡 Intermediate              |
| 04  | [**Unordered Containers**](04_Unordered_Containers.md)               | `unordered_set/map/multiset/multimap`, Hash Tables, Custom Hash, Load Factor | 🟡 Intermediate              |
| 05  | [**Container Adapters**](05_STL_Container_Adapters.md)               | `stack`, `queue`, `priority_queue`, Heap Internals, Monotonic Stack Patterns | 🟡 Intermediate → 🔴 Advanced |
| 06  | [**Algorithms**](06_STL_Algorithms.md)                               | Sort Variants, Binary Search, Permutations, Modifying Algos, Set Operations  | 🟡 Intermediate → 🔴 Advanced |
| 07  | [**Iterators**](07_STL_Iterators.md)                                 | Iterator Hierarchy, Invalidation Rules, Custom Iterators, C++20 Ranges       | 🟡 Intermediate → 🔴 Advanced |
| 08  | [**Functional & Lambdas**](08_STL_Functional_and_Lambdas.md)         | Functors, Lambdas, `std::function`, `std::bind`, Predicates, Capture Modes   | 🟡 Intermediate → 🔴 Advanced |
| 09  | [**Advanced Topics**](09_STL_Advanced_Topics.md)                     | PBDS, Memory Optimization, Debug Mode, Allocators, Move Semantics, SSO       | 🔴 Advanced → ⚫ Expert       |
| 10  | [**Competitive Programming**](10_STL_For_Competitive_Programming.md) | CP Templates, Graph Patterns, Two Pointer, Sliding Window, Bit Tricks        | 🔴 Advanced → ⚫ Expert       |

---

## 🎯 Who Is This For?

| Audience              | What You'll Get                                               |
| --------------------- | ------------------------------------------------------------- |
| **Beginners**         | Clear explanations of every STL component with code examples  |
| **Intermediate Devs** | Internal workings, memory layouts, and when-to-use guidance   |
| **Interview Prep**    | Tricky MCQs, common mistakes, interview tips in every chapter |
| **CP Contestants**    | Ready-to-use templates, tricks, and optimized patterns        |
| **Advanced/Expert**   | Allocators, PBDS, custom hash, move semantics deep dives      |

---

## 📖 What Each Chapter Contains

Every chapter follows a consistent, thorough structure:

```
📘 Chapter Structure
├── 1.  Concept Explanation (with ASCII diagrams)
├── 2.  Internal Working (memory layout, data structures)
├── 3.  Time Complexity (comprehensive tables)
├── 4.  Memory Behavior (allocation, growth, overhead)
├── 5.  Syntax (declaration, initialization patterns)
├── 6.  All Important Functions (with signatures)
├── 7.  Code Examples (beginner → advanced)
├── 8.  When to Use ✅
├── 9.  When NOT to Use ❌
├── 10. Common Mistakes & Pitfalls ⚠️
├── 11. Interview Tips 💡
├── 12. Competitive Programming Tricks 🏆
├── 13. Edge Cases 🔍
├── 14. Summary Table
│
└── 🏋️ Practice Section
    ├── Level 1: Concept Questions (10 Q&A)
    ├── Level 2: MCQs (10 questions)
    ├── Level 3: Tricky Interview MCQs (5 questions)
    ├── Level 4: True/False
    └── Level 5: Coding Problems
```

---

## 🛠️ Prerequisites

- **C++ Basics**: Variables, functions, loops, pointers, references
- **OOP Fundamentals**: Classes, objects, operator overloading, templates (basic)
- **Compiler**: Any C++17 compatible compiler (g++ 7+, clang 5+, MSVC 2017+)

```bash
# Recommended compilation flags
g++ -std=c++17 -O2 -Wall -Wextra -o program program.cpp

# With debug/sanitizer (for learning)
g++ -std=c++17 -g -fsanitize=address,undefined -D_GLIBCXX_DEBUG -o program program.cpp
```

---

## 🗺️ Learning Path

### Path 1: Complete Beginner
```
01 Fundamentals → 02 Sequence → 03 Associative → 04 Unordered
     → 05 Adapters → 06 Algorithms → 07 Iterators → 08 Lambdas
```

### Path 2: Interview Preparation
```
01 Fundamentals → 02 Sequence (vector focus) → 03 Associative
     → 06 Algorithms → 05 Adapters → 08 Lambdas → 09 Advanced
```

### Path 3: Competitive Programming Fast Track
```
01 Fundamentals → 02 Sequence (vector) → 03 Associative (set/map)
     → 05 Adapters (priority_queue) → 06 Algorithms → 10 CP Tricks
     → 09 Advanced (PBDS)
```

### Path 4: Deep Internals / Expert
```
01 Fundamentals → 02–05 (all containers) → 07 Iterators
     → 09 Advanced Topics → 08 Lambdas → 06 Algorithms
```

---

## ⚡ Quick Reference: Container Selection Guide

```
                    Need a container?
                         │
              ┌──────────┼──────────┐
              │          │          │
         Sequential   Key-Value   Adapter
              │          │          │
      ┌───────┼───┐   Ordered?   LIFO? → stack
      │       │   │     │  │     FIFO? → queue
   Random   Fast  List  Y  N    Priority? → priority_queue
   Access?  ends?  ops? │  │
      │       │    │    │  │
      Y       Y    Y   map unordered_map
      │       │    │
   vector   deque list
```

| Need                              | Container          | Why                               |
| --------------------------------- | ------------------ | --------------------------------- |
| Dynamic array, fast random access | `vector`           | Contiguous memory, cache-friendly |
| Fast insert/remove at both ends   | `deque`            | O(1) front and back               |
| Fast insert/remove in middle      | `list`             | O(1) splice/insert at iterator    |
| Sorted unique keys                | `set`              | Red-Black Tree, O(log n)          |
| Sorted key-value pairs            | `map`              | Red-Black Tree, O(log n)          |
| Fastest lookup (average case)     | `unordered_map`    | Hash table, O(1) average          |
| LIFO operations                   | `stack`            | Adapter over deque/vector         |
| FIFO operations                   | `queue`            | Adapter over deque                |
| Access to min/max element         | `priority_queue`   | Binary heap                       |
| Fixed-size array                  | `array`            | No overhead, stack allocated      |
| Order statistics (k-th element)   | PBDS `ordered_set` | O(log n) find_by_order            |

---

## 📊 Master Complexity Table

| Container           | Access         | Search   | Insert   | Delete   | Space |
| ------------------- | -------------- | -------- | -------- | -------- | ----- |
| `vector`            | O(1)           | O(n)     | O(n)*    | O(n)     | O(n)  |
| `deque`             | O(1)           | O(n)     | O(n)*    | O(n)     | O(n)  |
| `list`              | O(n)           | O(n)     | O(1)†    | O(1)†    | O(n)  |
| `set/map`           | —              | O(log n) | O(log n) | O(log n) | O(n)  |
| `unordered_set/map` | —              | O(1)‡    | O(1)‡    | O(1)‡    | O(n)  |
| `priority_queue`    | O(1) top       | —        | O(log n) | O(log n) | O(n)  |
| `stack/queue`       | O(1) top/front | —        | O(1)     | O(1)     | O(n)  |

*\* Amortized O(1) at end/back*  
*† O(1) with iterator, O(n) to find position*  
*‡ O(n) worst case due to hash collisions*

---

## 📝 How to Use This Guide

1. **Pick a chapter** from the Table of Contents based on your topic
2. **Read the concept** section for understanding
3. **Study the internals** for deeper knowledge
4. **Run the code examples** — copy-paste and experiment
5. **Attempt the practice section** — answers are in collapsible `<details>` tags
6. **Revisit the summary table** for quick revision

> 💡 **Tip**: Each chapter has navigation links at the top and bottom linking to the previous and next chapters. Read them in order for the best experience.

---

## 🔗 Additional Resources

| Resource               | Link                                                            |
| ---------------------- | --------------------------------------------------------------- |
| C++ Reference          | [cppreference.com](https://en.cppreference.com/)                |
| C++ Core Guidelines    | [isocpp.github.io](https://isocpp.github.io/CppCoreGuidelines/) |
| Compiler Explorer      | [godbolt.org](https://godbolt.org/)                             |
| CP Reference           | [cp-algorithms.com](https://cp-algorithms.com/)                 |
| Practice (Competitive) | [codeforces.com](https://codeforces.com/)                       |
| Practice (Interview)   | [leetcode.com](https://leetcode.com/)                           |

---

## 📜 C++ Standard Coverage

This guide primarily targets **C++17** with notes for:
- **C++11/14**: Where features were introduced
- **C++17**: Main target standard
- **C++20**: Previews (ranges, concepts, `contains()`, etc.)
- **GCC Extensions**: PBDS (Policy-Based Data Structures)

---

## 🏗️ Project Structure

```
cpp/
├── README.md                              ◄── You are here
├── 01_STL_Fundamentals.md                 — STL architecture & basics
├── 02_STL_Sequence_Containers.md          — vector, deque, list, array
├── 03_STL_Associative_Containers.md       — set, map & variants
├── 04_Unordered_Containers.md             — hash-based containers
├── 05_STL_Container_Adapters.md           — stack, queue, priority_queue
├── 06_STL_Algorithms.md                   — sorting, searching, modifying
├── 07_STL_Iterators.md                    — iterator types & patterns
├── 08_STL_Functional_and_Lambdas.md       — functors, lambdas, std::function
├── 09_STL_Advanced_Topics.md              — PBDS, memory, move semantics
└── 10_STL_For_Competitive_Programming.md  — CP templates & patterns
```

---

<p align="center">
  <strong>⭐ Star this repo if you find it helpful! ⭐</strong><br><br>
  <em>Built with ❤️ for the C++ community</em><br>
  <em>Happy Coding & Happy Competing! 🏆</em>
</p>

---

[**Start Learning → Chapter 01: STL Fundamentals**](01_STL_Fundamentals.md)
