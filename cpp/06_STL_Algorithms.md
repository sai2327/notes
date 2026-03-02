# 📘 Chapter 6: STL Algorithms — Sort, Search, Permutations, Heap & More

> **Master the algorithm library — the true power of STL lies here, not just in containers.**

---

## Table of Contents

- [1. Overview of STL Algorithms](#1-overview-of-stl-algorithms)
- [2. Sorting Algorithms](#2-sorting-algorithms)
- [3. Binary Search Algorithms](#3-binary-search-algorithms)
- [4. Permutation Algorithms](#4-permutation-algorithms)
- [5. Heap Algorithms](#5-heap-algorithms)
- [6. Searching & Finding](#6-searching--finding)
- [7. Counting & Accumulating](#7-counting--accumulating)
- [8. Modifying Algorithms](#8-modifying-algorithms)
- [9. Partitioning](#9-partitioning)
- [10. Merge & Set Algorithms](#10-merge--set-algorithms)
- [11. Min / Max Algorithms](#11-min--max-algorithms)
- [12. Common Mistakes](#12-common-mistakes)
- [13. Interview Tips](#13-interview-tips)
- [14. CP Tricks](#14-cp-tricks)
- [15. Summary](#15-summary)
- [16. Practice Section](#16-practice-section)

---

## 1. Overview of STL Algorithms

All algorithms live in `<algorithm>` and `<numeric>`.

```
┌──────────────────────────────────────────────────────────────┐
│                   STL Algorithm Categories                     │
├──────────────────────────────────────────────────────────────┤
│ Non-modifying:  find, count, search, equal, mismatch, any_of │
│ Modifying:      copy, fill, transform, replace, remove       │
│ Sorting:        sort, stable_sort, partial_sort, nth_element │
│ Binary Search:  lower_bound, upper_bound, binary_search      │
│ Partitioning:   partition, stable_partition, is_partitioned  │
│ Permutations:   next_permutation, prev_permutation           │
│ Heap:           make_heap, push_heap, pop_heap, sort_heap    │
│ Set Operations: set_union, set_intersection, set_difference  │
│ Numeric:        accumulate, partial_sum, iota, inner_product │
│ Min/Max:        min, max, minmax, min_element, max_element   │
└──────────────────────────────────────────────────────────────┘

KEY PRINCIPLE:
- Algorithms work on iterator ranges [first, last)
- They are container-agnostic — same algorithm works on vector, deque, array, etc.
- Most return iterators, not values
```

---

## 2. Sorting Algorithms

### 2.1 std::sort

**The workhorse sorting algorithm.** Uses Introsort = Quicksort + Heapsort + Insertion Sort.

```cpp
#include <algorithm>
#include <vector>
using namespace std;

vector<int> v = {5, 2, 8, 1, 9, 3};

// Default: ascending
sort(v.begin(), v.end());
// v = {1, 2, 3, 5, 8, 9}

// Descending
sort(v.begin(), v.end(), greater<int>());
// v = {9, 8, 5, 3, 2, 1}

// Custom comparator
sort(v.begin(), v.end(), [](int a, int b) {
    return abs(a) < abs(b);  // Sort by absolute value
});

// Sort only a subrange
sort(v.begin(), v.begin() + 3);  // Sort first 3 elements only
```

| Property                 | Value                                    |
| ------------------------ | ---------------------------------------- |
| **Average**              | O(n log n)                               |
| **Worst**                | O(n log n) — Introsort guarantee         |
| **Space**                | O(log n) — recursion stack               |
| **Stable?**              | **NO** — equal elements may be reordered |
| **In-place?**            | Yes                                      |
| **Iterator requirement** | RandomAccessIterator                     |

### 2.2 std::stable_sort

Preserves the relative order of equal elements.

```cpp
struct Student {
    string name;
    int grade;
};

vector<Student> students = {
    {"Alice", 90}, {"Bob", 90}, {"Charlie", 85}, {"Dave", 85}
};

// Stable sort by grade: Bob and Alice keep their relative order
stable_sort(students.begin(), students.end(),
    [](const Student& a, const Student& b) {
        return a.grade > b.grade;
    });
// Result: Alice(90), Bob(90), Charlie(85), Dave(85)
// If sort() was used, Alice and Bob might swap — unstable!
```

| Property    | Value                                         |
| ----------- | --------------------------------------------- |
| **Time**    | O(n log n) if extra memory; O(n log²n) if not |
| **Space**   | O(n) — uses merge sort                        |
| **Stable?** | **YES**                                       |

### 2.3 std::partial_sort

Sorts only the first k elements. The rest are in unspecified order.

```cpp
vector<int> v = {5, 2, 8, 1, 9, 3, 7};

// Get top 3 smallest elements sorted
partial_sort(v.begin(), v.begin() + 3, v.end());
// v = {1, 2, 3, ?, ?, ?, ?}  — first 3 sorted, rest unspecified

// Get top 3 largest
partial_sort(v.begin(), v.begin() + 3, v.end(), greater<int>());
// v = {9, 8, 7, ?, ?, ?, ?}
```

| Property     | Value                                                 |
| ------------ | ----------------------------------------------------- |
| **Time**     | **O(n log k)** — much faster than full sort if k << n |
| **Use case** | "Find top 10 scorers out of 1 million"                |

### 2.4 std::nth_element

Places the n-th smallest element at position n. Elements before n are ≤ it, elements after are ≥ it. **NOT sorted!**

```cpp
vector<int> v = {5, 2, 8, 1, 9, 3, 7};

// Find the median (3rd position in 0-indexed)
nth_element(v.begin(), v.begin() + 3, v.end());
// v[3] is now the 4th smallest element (which is 5)
// Elements before v[3] are ≤ 5, elements after are ≥ 5
// But they are NOT sorted within those halves

cout << v[3]; // The 4th smallest element
```

| Property     | Value                                     |
| ------------ | ----------------------------------------- |
| **Average**  | **O(n)** — uses Introselect               |
| **Worst**    | O(n) — Introselect guarantees             |
| **Use case** | Finding k-th element, quickselect, median |

### 2.5 Sorting Comparison Table

```
┌─────────────────────┬──────────────┬─────────┬─────────────────────┐
│ Algorithm           │ Time         │ Stable? │ Best Use Case       │
├─────────────────────┼──────────────┼─────────┼─────────────────────┤
│ sort                │ O(n log n)   │ No      │ General sorting     │
│ stable_sort         │ O(n log n)   │ Yes     │ Preserve order ties │
│ partial_sort        │ O(n log k)   │ No      │ Top-k elements      │
│ nth_element         │ O(n)         │ No      │ K-th element only   │
│ is_sorted           │ O(n)         │ —       │ Check if sorted     │
│ is_sorted_until     │ O(n)         │ —       │ Find first unsorted │
└─────────────────────┴──────────────┴─────────┴─────────────────────┘

Decision Guide:
- Need full sort?  → sort() or stable_sort()
- Need top k sorted?  → partial_sort()
- Need k-th element?  → nth_element()
- Need to keep equal order?  → stable_sort()
```

---

## 3. Binary Search Algorithms

> **REQUIREMENT:** The range MUST be sorted (or at least partitioned).

### 3.1 std::lower_bound

Returns iterator to the **first element ≥ value**.

```cpp
vector<int> v = {1, 2, 4, 4, 4, 7, 9};
//                0  1  2  3  4  5  6

auto it = lower_bound(v.begin(), v.end(), 4);
// Points to index 2 (first 4)

auto it2 = lower_bound(v.begin(), v.end(), 5);
// Points to index 5 (7, first element ≥ 5)

auto it3 = lower_bound(v.begin(), v.end(), 10);
// Points to v.end() (not found)

// Index calculation:
int idx = lower_bound(v.begin(), v.end(), 4) - v.begin();  // idx = 2
```

### 3.2 std::upper_bound

Returns iterator to the **first element > value**.

```cpp
vector<int> v = {1, 2, 4, 4, 4, 7, 9};

auto it = upper_bound(v.begin(), v.end(), 4);
// Points to index 5 (7, first element > 4)
```

### 3.3 Count of Value = upper_bound - lower_bound

```cpp
vector<int> v = {1, 2, 4, 4, 4, 7, 9};

int count = upper_bound(v.begin(), v.end(), 4) - 
            lower_bound(v.begin(), v.end(), 4);
// count = 3 (three 4s)
```

### 3.4 std::equal_range

Returns `pair<iterator, iterator>` = `{lower_bound, upper_bound}`.

```cpp
vector<int> v = {1, 2, 4, 4, 4, 7, 9};

auto [lo, hi] = equal_range(v.begin(), v.end(), 4);
// lo points to first 4, hi points to first element after last 4
int count = hi - lo;  // 3
```

### 3.5 std::binary_search

Returns `bool` — just checks if value exists.

```cpp
vector<int> v = {1, 2, 4, 4, 4, 7, 9};

bool found = binary_search(v.begin(), v.end(), 4);   // true
bool found2 = binary_search(v.begin(), v.end(), 5);  // false
// Does NOT return position!
```

### 3.6 Binary Search Visual Guide

```
v = {1, 2, 4, 4, 4, 7, 9}
     ↑  ↑  ↑  ↑  ↑  ↑  ↑

lower_bound(4): First element ≥ 4
                      ↑ here (index 2)

upper_bound(4): First element > 4
                               ↑ here (index 5)

equal_range(4): [lower_bound, upper_bound)
                      [───────)  3 elements

lower_bound(5): First ≥ 5
                               ↑ (index 5, points to 7)

upper_bound(5): First > 5
                               ↑ (also index 5, same as lower_bound)

equal_range(5): empty range → count = 0
```

### 3.7 Binary Search on Custom Types

```cpp
struct Event {
    int time;
    string name;
};

vector<Event> events = {{1, "A"}, {3, "B"}, {5, "C"}, {7, "D"}};

// Search by time using custom comparator
auto it = lower_bound(events.begin(), events.end(), 4,
    [](const Event& e, int val) {
        return e.time < val;
    });
// Points to {5, "C"} — first event at time ≥ 4
```

### 3.8 All Binary Search — Complexity

| Algorithm       | Time     | Returns                   |
| --------------- | -------- | ------------------------- |
| `lower_bound`   | O(log n) | Iterator to first ≥ value |
| `upper_bound`   | O(log n) | Iterator to first > value |
| `equal_range`   | O(log n) | Pair of iterators         |
| `binary_search` | O(log n) | bool                      |

---

## 4. Permutation Algorithms

### 4.1 std::next_permutation

Transforms the range into the next lexicographically greater permutation.

```cpp
vector<int> v = {1, 2, 3};

// Generate all permutations
sort(v.begin(), v.end());  // Start from smallest
do {
    for (int x : v) cout << x << " ";
    cout << "\n";
} while (next_permutation(v.begin(), v.end()));

/*
Output:
1 2 3
1 3 2
2 1 3
2 3 1
3 1 2
3 2 1
*/
```

### 4.2 std::prev_permutation

```cpp
vector<int> v = {3, 2, 1};  // Start from largest

do {
    for (int x : v) cout << x << " ";
    cout << "\n";
} while (prev_permutation(v.begin(), v.end()));
// Generates all permutations in reverse lexicographic order
```

### 4.3 Key Properties

```
next_permutation:
- Returns true if a next permutation exists
- Returns false if we wrapped around (to smallest)
- Modifies in-place
- Time: O(n) per call
- Total for all permutations: O(n! × n)

IMPORTANT: Must start from sorted order to generate ALL permutations!
```

---

## 5. Heap Algorithms

```cpp
#include <algorithm>
#include <vector>
using namespace std;

vector<int> v = {3, 1, 4, 1, 5, 9, 2, 6};

// ─────────────────────────── make_heap ─────────────────────────────
make_heap(v.begin(), v.end());      // O(n) — turns v into max-heap
// v[0] is now the maximum

// ─────────────────────────── push_heap ─────────────────────────────
v.push_back(7);                     // Add new element to end first
push_heap(v.begin(), v.end());      // O(log n) — sift up last element
// Heap property is restored

// ─────────────────────────── pop_heap ──────────────────────────────
pop_heap(v.begin(), v.end());       // O(log n) — move max to end
int max_val = v.back();             // Read the max
v.pop_back();                       // Remove it

// ─────────────────────────── sort_heap ─────────────────────────────
make_heap(v.begin(), v.end());
sort_heap(v.begin(), v.end());      // O(n log n) — sorts ascending
// v is now sorted, NO longer a heap

// ─────────────────────────── is_heap ──────────────────────────────
bool valid = is_heap(v.begin(), v.end());

auto it = is_heap_until(v.begin(), v.end());
// Returns iterator to first element that breaks heap property
```

---

## 6. Searching & Finding

### 6.1 std::find

```cpp
vector<int> v = {3, 1, 4, 1, 5, 9};

auto it = find(v.begin(), v.end(), 4);
if (it != v.end()) {
    cout << "Found at index " << (it - v.begin());  // 2
}

// find returns iterator to FIRST occurrence
// Time: O(n) — linear search
```

### 6.2 std::find_if / find_if_not

```cpp
vector<int> v = {3, 1, 4, 1, 5, 9};

// Find first even number
auto it = find_if(v.begin(), v.end(), [](int x) { return x % 2 == 0; });
// Points to 4

// Find first non-positive
auto it2 = find_if_not(v.begin(), v.end(), [](int x) { return x > 0; });
// Points to end() if all positive
```

### 6.3 std::search

Find a subsequence within a range.

```cpp
vector<int> haystack = {1, 2, 3, 4, 5, 6};
vector<int> needle = {3, 4, 5};

auto it = search(haystack.begin(), haystack.end(),
                 needle.begin(), needle.end());
// Points to position 2 (first occurrence of {3,4,5})
```

### 6.4 std::any_of / all_of / none_of

```cpp
vector<int> v = {2, 4, 6, 8};

bool all_even = all_of(v.begin(), v.end(), [](int x) { return x % 2 == 0; });
// true

bool any_neg = any_of(v.begin(), v.end(), [](int x) { return x < 0; });
// false

bool none_neg = none_of(v.begin(), v.end(), [](int x) { return x < 0; });
// true
```

---

## 7. Counting & Accumulating

### 7.1 std::count / count_if

```cpp
vector<int> v = {1, 2, 2, 3, 2, 4, 2};

int twos = count(v.begin(), v.end(), 2);  // 4

int evens = count_if(v.begin(), v.end(), [](int x) { return x % 2 == 0; });
// 5
```

### 7.2 std::accumulate

```cpp
#include <numeric>

vector<int> v = {1, 2, 3, 4, 5};

// Sum (init = 0)
int sum = accumulate(v.begin(), v.end(), 0);  // 15

// Product (init = 1)
int prod = accumulate(v.begin(), v.end(), 1, multiplies<int>());
// 120

// Custom: concatenate strings
vector<string> words = {"Hello", " ", "World"};
string result = accumulate(words.begin(), words.end(), string(""));
// "Hello World"

// ⚠️ Integer overflow: use 0LL for long long
long long big_sum = accumulate(v.begin(), v.end(), 0LL);
```

### 7.3 std::partial_sum

```cpp
#include <numeric>

vector<int> v = {1, 2, 3, 4, 5};
vector<int> prefix(v.size());

partial_sum(v.begin(), v.end(), prefix.begin());
// prefix = {1, 3, 6, 10, 15}
```

### 7.4 std::iota

```cpp
#include <numeric>

vector<int> v(5);
iota(v.begin(), v.end(), 1);
// v = {1, 2, 3, 4, 5}

iota(v.begin(), v.end(), 10);
// v = {10, 11, 12, 13, 14}
```

### 7.5 std::inner_product

```cpp
#include <numeric>

vector<int> a = {1, 2, 3};
vector<int> b = {4, 5, 6};

int dot = inner_product(a.begin(), a.end(), b.begin(), 0);
// 1*4 + 2*5 + 3*6 = 32
```

---

## 8. Modifying Algorithms

### 8.1 std::copy / copy_if

```cpp
vector<int> src = {1, 2, 3, 4, 5};
vector<int> dst(5);

copy(src.begin(), src.end(), dst.begin());
// dst = {1, 2, 3, 4, 5}

vector<int> evens;
copy_if(src.begin(), src.end(), back_inserter(evens),
    [](int x) { return x % 2 == 0; });
// evens = {2, 4}
```

### 8.2 std::transform

```cpp
vector<int> v = {1, 2, 3, 4, 5};

// Unary transform: square each element
transform(v.begin(), v.end(), v.begin(),
    [](int x) { return x * x; });
// v = {1, 4, 9, 16, 25}

// Binary transform: add two vectors
vector<int> a = {1, 2, 3}, b = {4, 5, 6}, c(3);
transform(a.begin(), a.end(), b.begin(), c.begin(),
    [](int x, int y) { return x + y; });
// c = {5, 7, 9}
```

### 8.3 std::fill / fill_n

```cpp
vector<int> v(5);
fill(v.begin(), v.end(), 42);
// v = {42, 42, 42, 42, 42}

fill_n(v.begin(), 3, 0);
// v = {0, 0, 0, 42, 42}
```

### 8.4 std::replace / replace_if

```cpp
vector<int> v = {1, 2, 3, 2, 4, 2};

replace(v.begin(), v.end(), 2, 99);
// v = {1, 99, 3, 99, 4, 99}

replace_if(v.begin(), v.end(), [](int x) { return x > 50; }, 0);
// Replace all >50 with 0
```

### 8.5 std::remove / remove_if (Erase-Remove Idiom)

**CRITICAL: `remove` does NOT actually remove elements! It moves unwanted elements to the end.**

```cpp
vector<int> v = {1, 2, 3, 2, 4, 2};

// ❌ Does NOT actually resize the vector!
remove(v.begin(), v.end(), 2);
// v = {1, 3, 4, ?, ?, ?}  (size still 6!)

// ✅ Erase-remove idiom
v.erase(remove(v.begin(), v.end(), 2), v.end());
// v = {1, 3, 4}  (size = 3)

// ✅ With condition
v.erase(remove_if(v.begin(), v.end(),
    [](int x) { return x % 2 == 0; }), v.end());

// ✅ C++20: std::erase / std::erase_if
// erase(v, 2);
// erase_if(v, [](int x) { return x % 2 == 0; });
```

### 8.6 std::unique

```cpp
// Removes CONSECUTIVE duplicates (sort first for all duplicates!)
vector<int> v = {1, 1, 2, 2, 3, 1, 1};

auto last = unique(v.begin(), v.end());
// v = {1, 2, 3, 1, ?, ?, ?}  — only consecutive dups removed
v.erase(last, v.end());
// v = {1, 2, 3, 1}

// For ALL duplicates:
sort(v.begin(), v.end());
v.erase(unique(v.begin(), v.end()), v.end());
// v = {1, 2, 3}
```

### 8.7 std::reverse / rotate

```cpp
vector<int> v = {1, 2, 3, 4, 5};

reverse(v.begin(), v.end());
// v = {5, 4, 3, 2, 1}

// Rotate: move element at position 2 to front
vector<int> v2 = {1, 2, 3, 4, 5};
rotate(v2.begin(), v2.begin() + 2, v2.end());
// v2 = {3, 4, 5, 1, 2}
// The element at position 2 becomes the new first element
```

### 8.8 std::swap_ranges

```cpp
vector<int> a = {1, 2, 3};
vector<int> b = {4, 5, 6};

swap_ranges(a.begin(), a.end(), b.begin());
// a = {4, 5, 6}, b = {1, 2, 3}
```

---

## 9. Partitioning

### 9.1 std::partition

Rearranges elements so that all elements satisfying the predicate come before those that don't.

```cpp
vector<int> v = {1, 7, 3, 8, 2, 6, 4, 5};

auto pivot = partition(v.begin(), v.end(),
    [](int x) { return x <= 4; });

// Elements ≤4 are before pivot, elements >4 are after
// v might be: {1, 4, 3, 2, 8, 6, 7, 5}
// pivot points to first element > 4

// Order within groups is NOT preserved
```

### 9.2 std::stable_partition

Same as partition but preserves relative order within each group.

```cpp
vector<int> v = {1, 7, 3, 8, 2, 6, 4, 5};

stable_partition(v.begin(), v.end(),
    [](int x) { return x <= 4; });
// v = {1, 3, 2, 4, 7, 8, 6, 5}
// Relative order preserved within each group
```

### 9.3 std::partition_point

```cpp
vector<int> v = {1, 3, 2, 4, 7, 8, 6, 5};  // Partitioned by ≤4

auto pp = partition_point(v.begin(), v.end(),
    [](int x) { return x <= 4; });
// Points to first element where predicate is false (7)
```

---

## 10. Merge & Set Algorithms

> All require sorted input ranges.

### 10.1 std::merge

```cpp
vector<int> a = {1, 3, 5, 7};
vector<int> b = {2, 4, 6, 8};
vector<int> result(8);

merge(a.begin(), a.end(), b.begin(), b.end(), result.begin());
// result = {1, 2, 3, 4, 5, 6, 7, 8}
// Time: O(n + m)
```

### 10.2 std::inplace_merge

```cpp
vector<int> v = {1, 3, 5, 2, 4, 6};
//              [sorted  ][sorted  ]

inplace_merge(v.begin(), v.begin() + 3, v.end());
// v = {1, 2, 3, 4, 5, 6}
```

### 10.3 Set Operations on Sorted Ranges

```cpp
vector<int> a = {1, 2, 3, 4, 5};
vector<int> b = {3, 4, 5, 6, 7};
vector<int> result;

// Union: {1, 2, 3, 4, 5, 6, 7}
set_union(a.begin(), a.end(), b.begin(), b.end(), back_inserter(result));

result.clear();
// Intersection: {3, 4, 5}
set_intersection(a.begin(), a.end(), b.begin(), b.end(), back_inserter(result));

result.clear();
// Difference (in a but not b): {1, 2}
set_difference(a.begin(), a.end(), b.begin(), b.end(), back_inserter(result));

result.clear();
// Symmetric difference (in a or b but not both): {1, 2, 6, 7}
set_symmetric_difference(a.begin(), a.end(), b.begin(), b.end(), back_inserter(result));

// All are O(n + m)
```

### 10.4 std::includes

```cpp
vector<int> a = {1, 2, 3, 4, 5, 6};
vector<int> b = {2, 4, 6};

bool is_subset = includes(a.begin(), a.end(), b.begin(), b.end());
// true — all elements of b are in a
```

---

## 11. Min / Max Algorithms

```cpp
#include <algorithm>

// ─────────────────────────── Simple min/max ─────────────────────────
int a = min(3, 5);       // 3
int b = max(3, 5);       // 5
auto [lo, hi] = minmax(3, 5);  // lo=3, hi=5

// Initializer list
int c = min({3, 1, 4, 1, 5});  // 1
int d = max({3, 1, 4, 1, 5});  // 5

// ─────────────────────────── Element iterators ──────────────────────
vector<int> v = {3, 1, 4, 1, 5, 9, 2, 6};

auto it_min = min_element(v.begin(), v.end());  // Points to 1
auto it_max = max_element(v.begin(), v.end());  // Points to 9
auto [it_lo, it_hi] = minmax_element(v.begin(), v.end());

int min_val = *it_min;  // 1
int max_val = *it_max;  // 9
int min_idx = it_min - v.begin();  // 1

// ─────────────────────────── clamp (C++17) ──────────────────────────
int val = clamp(15, 1, 10);   // 10 (clamped to max)
int val2 = clamp(-5, 1, 10);  // 1  (clamped to min)
int val3 = clamp(5, 1, 10);   // 5  (within range)
```

---

## 12. Common Mistakes

### Mistake 1: Binary Search on Unsorted Data

```cpp
vector<int> v = {5, 2, 8, 1, 3};

// ❌ Not sorted! Results are undefined.
bool found = binary_search(v.begin(), v.end(), 2);

// ✅ Sort first
sort(v.begin(), v.end());
found = binary_search(v.begin(), v.end(), 2);
```

### Mistake 2: remove() Doesn't Actually Erase

```cpp
vector<int> v = {1, 2, 3, 2, 4};

// ❌ Size stays the same!
remove(v.begin(), v.end(), 2);
// v.size() still 5!

// ✅ Use erase-remove
v.erase(remove(v.begin(), v.end(), 2), v.end());
```

### Mistake 3: accumulate with Wrong Init Type

```cpp
vector<int> v = {1000000, 1000000, 1000000};

// ❌ Int overflow! init value 0 is int
int result = accumulate(v.begin(), v.end(), 0);

// ✅ Use 0LL for long long
long long result2 = accumulate(v.begin(), v.end(), 0LL);
```

### Mistake 4: sort on List

```cpp
list<int> lst = {3, 1, 4, 1, 5};

// ❌ std::sort requires RandomAccessIterator!
// sort(lst.begin(), lst.end());  // COMPILE ERROR!

// ✅ Use member function
lst.sort();
```

### Mistake 5: Modifying Container While Iterating with Algorithms

```cpp
vector<int> v = {1, 2, 3, 4, 5};

// ❌ Don't modify the vector during transform to itself with size changes!
// Use proper output iterators or resize correctly
```

---

## 13. Interview Tips

**Q1: What's the difference between `sort()` and `stable_sort()`?**
> `sort()` uses Introsort (O(n log n), unstable). `stable_sort()` uses merge sort (O(n log n), stable but O(n) extra space). Use `stable_sort` when relative order of equal elements matters.

**Q2: How does `nth_element` work internally?**
> Uses Introselect (a variant of Quickselect with fallback). Average O(n), guaranteed O(n) worst case. Places the k-th element in its correct sorted position.

**Q3: Why use `lower_bound` instead of `find` for sorted data?**
> `find` is O(n) linear scan. `lower_bound` is O(log n) binary search. Always prefer `lower_bound`/`upper_bound` on sorted ranges.

**Q4: What does the erase-remove idiom solve?**
> `std::remove` doesn't actually remove — it moves unwanted elements to the end and returns an iterator to the new logical end. You must call `.erase()` with that iterator to actually shrink the container.

**Q5: Can you use `sort()` on a `std::list`?**
> No. `std::sort` requires RandomAccessIterators. Use `list::sort()` member function instead, which uses merge sort.

---

## 14. CP Tricks

### Trick 1: Coordinate Compression

```cpp
vector<int> arr = {100, 500, 200, 100, 500};

// Compress to {0, 2, 1, 0, 2}
vector<int> sorted_unique = arr;
sort(sorted_unique.begin(), sorted_unique.end());
sorted_unique.erase(unique(sorted_unique.begin(), sorted_unique.end()), 
                    sorted_unique.end());

for (int& x : arr) {
    x = lower_bound(sorted_unique.begin(), sorted_unique.end(), x) 
        - sorted_unique.begin();
}
// arr = {0, 2, 1, 0, 2}
```

### Trick 2: Next Permutation for Brute Force

```cpp
// Try all arrangements of a small array (n ≤ 8)
vector<int> v = {1, 2, 3, 4};
sort(v.begin(), v.end());
do {
    // Check some property...
    int sum = v[0] * v[1] + v[2] * v[3];
} while (next_permutation(v.begin(), v.end()));
```

### Trick 3: Custom Sort for Specific Order

```cpp
// Sort by frequency, then by value
vector<int> v = {4, 2, 2, 8, 3, 3, 1};
map<int, int> freq;
for (int x : v) freq[x]++;

sort(v.begin(), v.end(), [&](int a, int b) {
    if (freq[a] != freq[b]) return freq[a] > freq[b];  // More frequent first
    return a < b;  // Tie-break by value
});
```

### Trick 4: Merge Two Sorted Arrays In-Place

```cpp
vector<int> a = {1, 3, 5, 0, 0, 0};  // Extra space at end
vector<int> b = {2, 4, 6};
int m = 3, n = 3;

// Fill from back
int i = m - 1, j = n - 1, k = m + n - 1;
while (j >= 0) {
    if (i >= 0 && a[i] > b[j]) {
        a[k--] = a[i--];
    } else {
        a[k--] = b[j--];
    }
}
```

### Trick 5: Counting Inversions with merge sort

```cpp
long long mergeCount(vector<int>& arr, int l, int r) {
    if (r - l <= 1) return 0;
    int mid = (l + r) / 2;
    long long cnt = mergeCount(arr, l, mid) + mergeCount(arr, mid, r);
    
    vector<int> tmp;
    int i = l, j = mid;
    while (i < mid && j < r) {
        if (arr[i] <= arr[j]) {
            tmp.push_back(arr[i++]);
        } else {
            tmp.push_back(arr[j++]);
            cnt += mid - i;  // All remaining in left half are inversions
        }
    }
    while (i < mid) tmp.push_back(arr[i++]);
    while (j < r) tmp.push_back(arr[j++]);
    copy(tmp.begin(), tmp.end(), arr.begin() + l);
    return cnt;
}
```

### Trick 6: Rotate to Shift Array

```cpp
// Left rotate by k positions
vector<int> v = {1, 2, 3, 4, 5};
int k = 2;
rotate(v.begin(), v.begin() + k, v.end());
// v = {3, 4, 5, 1, 2}

// Right rotate by k
k = 2;
rotate(v.begin(), v.end() - k, v.end());
// v = {4, 5, 1, 2, 3}
```

---

## 15. Summary

```
┌────────────────────────────────────────────────────────────────┐
│                 STL ALGORITHMS CHEAT SHEET                      │
├─────────────────┬──────────────────────────────────────────────┤
│ SORTING         │ sort O(nlogn) | stable_sort | partial_sort  │
│                 │ nth_element O(n) for k-th element            │
├─────────────────┼──────────────────────────────────────────────┤
│ BINARY SEARCH   │ lower_bound (first≥) | upper_bound (first>) │
│                 │ equal_range (both) | binary_search (bool)    │
├─────────────────┼──────────────────────────────────────────────┤
│ PERMUTATIONS    │ next_permutation | prev_permutation          │
├─────────────────┼──────────────────────────────────────────────┤
│ SEARCHING       │ find | find_if | search | count | count_if  │
├─────────────────┼──────────────────────────────────────────────┤
│ MODIFYING       │ copy | transform | fill | replace | remove  │
│                 │ unique | reverse | rotate | swap_ranges      │
├─────────────────┼──────────────────────────────────────────────┤
│ NUMERIC         │ accumulate | partial_sum | iota | inner_prod│
├─────────────────┼──────────────────────────────────────────────┤
│ SET OPS         │ set_union | intersection | difference       │
├─────────────────┼──────────────────────────────────────────────┤
│ HEAP            │ make_heap | push_heap | pop_heap | sort_heap│
├─────────────────┼──────────────────────────────────────────────┤
│ MIN/MAX         │ min | max | minmax | min/max_element | clamp│
└─────────────────┴──────────────────────────────────────────────┘

KEY RULES:
1. Algorithms work on iterator ranges [first, last)
2. Binary search requires sorted data
3. remove() doesn't erase — use erase-remove idiom
4. accumulate init type determines result type
5. sort() needs RandomAccessIterator (not list)
```

---

## 16. Practice Section

### Level 1 — Quick Concept Questions

1. **Q: What sorting algorithm does `std::sort` use internally?**
   <details><summary>Answer</summary>Introsort — a hybrid of Quicksort, Heapsort, and Insertion Sort. Guarantees O(n log n) worst case.</details>

2. **Q: What does `lower_bound` return if the value is not found?**
   <details><summary>Answer</summary>Iterator to the first element greater than the value. If all elements are less, it returns `end()`.</details>

3. **Q: What is the difference between `find` and `binary_search`?**
   <details><summary>Answer</summary>`find` is O(n) linear search, works on unsorted data, returns iterator. `binary_search` is O(log n), requires sorted data, returns only bool.</details>

4. **Q: Does `std::remove` change the size of the container?**
   <details><summary>Answer</summary>No! It moves unwanted elements to the end and returns an iterator to the new logical end. You need `erase()` to actually resize.</details>

5. **Q: What does `std::unique` require to remove ALL duplicates?**
   <details><summary>Answer</summary>The range must be sorted first. `unique` only removes consecutive duplicates.</details>

6. **Q: What is the time complexity of `nth_element`?**
   <details><summary>Answer</summary>O(n) average and worst case (uses Introselect).</details>

7. **Q: Can you use `std::sort` on `std::list`?**
   <details><summary>Answer</summary>No. `std::sort` requires RandomAccessIterators. Use `list::sort()` member function.</details>

8. **Q: What does `std::iota(v.begin(), v.end(), 1)` produce?**
   <details><summary>Answer</summary>Fills v with sequential values: {1, 2, 3, 4, ...}</details>

9. **Q: How do you count occurrences of value 5 in a sorted vector efficiently?**
   <details><summary>Answer</summary>`upper_bound(v.begin(), v.end(), 5) - lower_bound(v.begin(), v.end(), 5)` — O(log n).</details>

10. **Q: What does `std::rotate(v.begin(), v.begin()+2, v.end())` do to {1,2,3,4,5}?**
    <details><summary>Answer</summary>Result is {3, 4, 5, 1, 2}. The element at the second argument becomes the first.</details>

---

### Level 2 — MCQs

**1. `std::stable_sort` uses which internal algorithm?**
- A) Quicksort
- B) Heapsort
- C) Merge sort ✅
- D) Insertion sort

**2. What is the time complexity of `std::partial_sort` to get top-k from n elements?**
- A) O(n log n)
- B) O(n log k) ✅
- C) O(k log n)
- D) O(n + k)

**3. `lower_bound({1,2,4,4,4,7}, 4)` returns iterator pointing to index:**
- A) 0
- B) 2 ✅
- C) 4
- D) 5

**4. After `remove(v.begin(), v.end(), 3)` on v = {1,3,5,3,7}:**
- A) v = {1, 5, 7} and size = 3
- B) v = {1, 5, 7, ?, ?} and size = 5 ✅
- C) v = {1, 5, 7} and size = 5
- D) Compile error

**5. `accumulate(v.begin(), v.end(), 1, multiplies<int>())` computes:**
- A) Sum of elements
- B) Product of elements ✅
- C) Maximum element
- D) Count of elements

**6. What does `next_permutation` return when called on the largest permutation?**
- A) true
- B) false ✅ (wraps to smallest permutation)
- C) Throws exception
- D) Undefined behavior

**7. Which algorithm works in O(n) time?**
- A) sort
- B) stable_sort
- C) nth_element ✅
- D) partial_sort

**8. `binary_search` returns:**
- A) Iterator to element
- B) Index of element
- C) bool ✅
- D) Pair of iterators

**9. `std::unique` removes:**
- A) All duplicates everywhere
- B) Consecutive duplicates only ✅
- C) The first occurrence of each element
- D) Elements not satisfying a predicate

**10. `std::partition` guarantees:**
- A) Elements are sorted
- B) Matching elements come first; order preserved
- C) Matching elements come first; order NOT preserved ✅
- D) Both groups are sorted

---

### Level 3 — Tricky Interview MCQs

**1. What happens if you call `sort()` with a comparator that is NOT a strict weak ordering?**
- A) Compiles but sorts incorrectly
- B) Undefined behavior ✅
- C) Throws an exception
- D) Runtime error on all platforms

**2. Which choice correctly creates a sorted range of unique elements from vector v?**
- A) `unique(v.begin(), v.end()); sort(v.begin(), v.end());`
- B) `sort(v.begin(), v.end()); v.erase(unique(v.begin(), v.end()), v.end());` ✅
- C) `v.erase(unique(v.begin(), v.end()), v.end()); sort(v.begin(), v.end());`
- D) `remove_if(v.begin(), v.end(), is_duplicate);`

**3. `nth_element(v.begin(), v.begin()+k, v.end())` guarantees:**
- A) First k elements are sorted
- B) Element at position k is correct; left ≤ it, right ≥ it ✅
- C) First k elements are the smallest k, sorted
- D) All elements are in their final sorted positions

**4. `accumulate(v.begin(), v.end(), 0)` on a `vector<double>` returns:**
- A) double
- B) int ✅ (init type determines result type!)
- C) long long
- D) Compile error

**5. Which has the best average complexity for finding the median of n unsorted elements?**
- A) sort + access middle → O(n log n)
- B) nth_element → O(n) ✅
- C) partial_sort → O(n log n/2)
- D) priority_queue → O(n log n)

---

### Level 4 — True / False

| #   | Statement                                                     | Answer                    |
| --- | ------------------------------------------------------------- | ------------------------- |
| 1   | `std::sort` guarantees O(n log n) worst case                  | **True** (Introsort)      |
| 2   | `std::sort` is stable                                         | **False**                 |
| 3   | `lower_bound` works on unsorted arrays                        | **False**                 |
| 4   | `std::remove` returns iterator to new logical end             | **True**                  |
| 5   | `nth_element` fully sorts the array                           | **False**                 |
| 6   | `partial_sum` computes prefix sums                            | **True**                  |
| 7   | `std::find` can work on unsorted data                         | **True**                  |
| 8   | `next_permutation` requires sorted input for all permutations | **True**                  |
| 9   | `set_union` works on unsorted ranges                          | **False**                 |
| 10  | `std::count` returns an iterator                              | **False** (returns count) |

---

### Level 5 — Coding Practice Problems

**Problem 1: Inversions Count**
```
Given an array, count the number of inversions (i < j but a[i] > a[j]).
Use merge sort approach. Input: {2, 4, 1, 3, 5} → Output: 3
```

**Problem 2: K-th Smallest Element**
```
Find the k-th smallest element in an unsorted array in O(n) average time.
Use nth_element. Input: {7, 10, 4, 3, 20, 15}, k=3 → Output: 7
```

**Problem 3: Coordinate Compression**
```
Compress coordinates {100, 500, 200, 100, 500} to {0, 2, 1, 0, 2}.
Use sort + unique + lower_bound.
```

**Problem 4: First Missing Positive**
```
Given unsorted array, find smallest missing positive integer.
Use partition + iota check. Input: {3, 4, -1, 1} → Output: 2
```

**Problem 5: Custom Sort — Largest Number**
```
Given list of integers, arrange them to form the largest number.
Input: {3, 30, 34, 5, 9} → Output: "9534330"
Hint: Custom comparator comparing a+b vs b+a as strings.
```

---

---

## 17. Extended Examples with Test Cases

### Example 1 — sort with all variants

```cpp
#include <iostream>
#include <algorithm>
#include <vector>
#include <string>
using namespace std;

int main() {
    vector<int> v = {5, 2, 8, 1, 9, 3, 7, 4, 6};

    // 1) Default ascending sort
    sort(v.begin(), v.end());
    for (int x : v) cout << x << " ";
    cout << "\n";  // 1 2 3 4 5 6 7 8 9

    // 2) Descending
    sort(v.begin(), v.end(), greater<int>());
    for (int x : v) cout << x << " ";
    cout << "\n";  // 9 8 7 6 5 4 3 2 1

    // 3) Sort strings by length, then lexicographically
    vector<string> words = {"banana","fig","apple","kiwi","date"};
    sort(words.begin(), words.end(), [](const string& a, const string& b){
        return a.size() != b.size() ? a.size() < b.size() : a < b;
    });
    for (auto& s : words) cout << s << " ";
    cout << "\n";  // fig date kiwi apple banana

    // 4) partial_sort: find 3 smallest
    vector<int> v2 = {5, 2, 8, 1, 9, 3};
    partial_sort(v2.begin(), v2.begin() + 3, v2.end());
    for (int x : v2) cout << x << " ";
    cout << "\n";  // 1 2 3 9 8 5  (first 3 sorted, rest arbitrary)

    return 0;
}
```

---

### Example 2 — binary search family

```cpp
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;

int main() {
    vector<int> v = {1, 2, 2, 3, 3, 3, 4, 5};

    // lower_bound: first position where value >= x
    auto lb = lower_bound(v.begin(), v.end(), 3);
    cout << "lb index: " << (lb - v.begin()) << "\n";  // 3

    // upper_bound: first position where value > x
    auto ub = upper_bound(v.begin(), v.end(), 3);
    cout << "ub index: " << (ub - v.begin()) << "\n";  // 6

    // Count occurrences of 3
    cout << "count of 3: " << (ub - lb) << "\n";  // 3

    // binary_search: just true/false
    cout << binary_search(v.begin(), v.end(), 4) << "\n";  // 1
    cout << binary_search(v.begin(), v.end(), 6) << "\n";  // 0

    // equal_range: returns {lower_bound, upper_bound}
    auto [lo, hi] = equal_range(v.begin(), v.end(), 2);
    cout << "2 appears " << (hi - lo) << " times\n";  // 2 times

    return 0;
}
```

---

### Example 3 — transform, accumulate, and numeric algorithms

```cpp
#include <iostream>
#include <algorithm>
#include <numeric>
#include <vector>
using namespace std;

int main() {
    vector<int> v = {1, 2, 3, 4, 5};

    // transform: square each element
    vector<int> sq(v.size());
    transform(v.begin(), v.end(), sq.begin(), [](int x){ return x * x; });
    for (int x : sq) cout << x << " ";
    cout << "\n";  // 1 4 9 16 25

    // accumulate: sum
    int sum = accumulate(v.begin(), v.end(), 0);
    cout << sum << "\n";  // 15

    // accumulate with custom op: product
    int prod = accumulate(v.begin(), v.end(), 1, multiplies<int>());
    cout << prod << "\n";  // 120

    // partial_sum: prefix sums
    vector<int> ps(v.size());
    partial_sum(v.begin(), v.end(), ps.begin());
    for (int x : ps) cout << x << " ";
    cout << "\n";  // 1 3 6 10 15

    // iota: fill with increasing sequence
    vector<int> seq(5);
    iota(seq.begin(), seq.end(), 10);
    for (int x : seq) cout << x << " ";
    cout << "\n";  // 10 11 12 13 14

    return 0;
}
```

---

### Example 4 — remove/erase idiom

```cpp
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;

int main() {
    vector<int> v = {1, 2, 3, 2, 4, 2, 5};

    // WRONG approach — does NOT actually remove from vector:
    auto newEnd = remove(v.begin(), v.end(), 2);
    // v = {1, 3, 4, 5, _, _, _}  (logical end at newEnd)
    cout << "size before erase: " << v.size() << "\n";  // 7 (unchanged!)

    // CORRECT: couple with erase
    v.erase(newEnd, v.end());
    cout << "size after erase:  " << v.size() << "\n";  // 4

    for (int x : v) cout << x << " ";
    cout << "\n";  // 1 3 4 5

    // remove_if with lambda
    vector<int> v2 = {1, 2, 3, 4, 5, 6, 7, 8};
    v2.erase(remove_if(v2.begin(), v2.end(), [](int x){ return x % 2 == 0; }),
             v2.end());
    for (int x : v2) cout << x << " ";
    cout << "\n";  // 1 3 5 7

    return 0;
}
```

---

### Example 5 — permutations with expected output

```cpp
#include <iostream>
#include <algorithm>
#include <vector>
using namespace std;

int main() {
    vector<int> v = {1, 2, 3};

    // Print all permutations
    do {
        for (int x : v) cout << x << " ";
        cout << "\n";
    } while (next_permutation(v.begin(), v.end()));
    // 1 2 3
    // 1 3 2
    // 2 1 3
    // 2 3 1
    // 3 1 2
    // 3 2 1

    // Count permutations of duplicates
    vector<int> dup = {1, 1, 2};
    sort(dup.begin(), dup.end());  // must start from sorted!
    int cnt = 0;
    do { cnt++; } while (next_permutation(dup.begin(), dup.end()));
    cout << "permutations of {1,1,2}: " << cnt << "\n";  // 3

    return 0;
}
```

---

## 18. Tricky MCQs — Expert Level

**Q1. What is the output?**
```cpp
vector<int> v = {1, 2, 3, 4, 5};
auto it = remove(v.begin(), v.end(), 3);
cout << v.size() << " " << *it;
```
- A) `4 3`
- B) `5 4` ✅
- C) `4 4`
- D) `5 5`

> **Why:** `remove` shifts elements but doesn't resize. `size()` is still 5. `it` points to the new logical end (value `4` or whatever garbage is there — actually `4` since it shuffled). Let's verify: after remove of 3, v = {1,2,4,5,5}. `*it` = 5. Actually: `v = {1,2,4,5,[3]}` — the 5th element becomes a dup. `*it = 5`.

Wait, let me recalculate: `v = {1, 2, 3, 4, 5}`, remove 3. Elements != 3 in order: 1, 2, 4, 5. Placed at front: {1, 2, 4, 5, _}. The last element (index 4) retains its old value = 5. So v = {1, 2, 4, 5, 5}. `it` points to index 4 = 5. Actually `*it = 5`. Let me re-answer:

- A) `5 3`
- B) `5 5` ✅
- C) `4 4`
- D) `4 3`

> **Why:** `remove` doesn't change size (returns 5). The last element has value 5 (a copy). `*it = 5`.

---

**Q2. `accumulate(v.begin(), v.end(), 0)` where `v = {1, 2, 3}` and `0` is an `int`. If `v` were `vector<double>`, the return type would be:**
- A) `double`
- B) `int` ✅ — the init type (0, an int) determines result type
- C) `long long`
- D) Compilation error

---

**Q3. What happens if you call `next_permutation` on `{3, 2, 1}`?**
- A) Returns the next permutation {3, 2, 1}
- B) Modifies to {1, 2, 3} and returns `false` ✅
- C) Throws an exception
- D) Modifies to {3, 2, 1} and returns `true`

> **Why:** `{3,2,1}` is the last permutation. `next_permutation` wraps to `{1,2,3}` (first permutation) and returns `false`.

---

**Q4. `nth_element(v.begin(), v.begin()+3, v.end())` guarantees:**
- A) `v[3]` is the 4th-smallest and v[0..2] ≤ v[3] ≤ v[4..] ✅
- B) First 4 elements are fully sorted
- C) All elements sorted
- D) Nothing — behavior undefined

---

**Q5. `stable_partition` vs `partition` — the key difference:**
- A) `stable_partition` is O(n log n) not O(n)
- B) `stable_partition` preserves relative order within each group ✅
- C) `partition` is stable for most implementations
- D) `stable_partition` works on sets

---

**Q6. Which algorithm can find the maximum element in O(n)?**
- A) `sort` then `back()`
- B) `max_element` ✅
- C) `lower_bound`
- D) `nth_element`

---

**Q7. `std::set_union` requires:**
- A) Unordered input ranges
- B) Sorted input ranges ✅
- C) The same container type for all ranges
- D) No preconditions

---

**Q8. `std::count(v.begin(), v.end(), x)` complexity:**
- A) O(1)
- B) O(log n)
- C) O(n) ✅
- D) O(n log n)

---

**Q9. Which function fills a range with sequentially increasing values?**
- A) `std::fill`
- B) `std::generate`
- C) `std::iota` ✅
- D) `std::transform`

---

**Q10. `copy_if` vs `remove_copy_if` — how do they differ?**
- A) They are equivalent
- B) `copy_if` copies elements satisfying predicate; `remove_copy_if` copies elements NOT satisfying it ✅
- C) `remove_copy_if` removes from source
- D) `copy_if` modifies the source range

---

**Q11. What does `std::unique` return?**
- A) A new container with unique elements
- B) Iterator to the new logical end of the range ✅
- C) Count of duplicates removed
- D) Iterator to the first duplicate

---

**Q12. Calling `std::sort` on `std::list::iterator` will:**
- A) Sort the list correctly
- B) Fail to compile ✅ — `sort` requires RandomAccessIterator; list provides BidirectionalIterator
- C) Sort but with O(n²) complexity
- D) Call `list::sort` automatically

---

> **Previous:** [05_STL_Container_Adapters.md](05_STL_Container_Adapters.md)  
> **Next:** [07_STL_Iterators.md](07_STL_Iterators.md)
