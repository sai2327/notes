# 📘 Chapter 5: Container Adapters — stack, queue, priority_queue

> **Restricted interfaces over other containers — understand when constraints are a feature, not a limitation.**

---

## Table of Contents

- [1. Overview](#1-overview)
- [2. std::stack](#2-stdstack)
- [3. std::queue](#3-stdqueue)
- [4. std::priority_queue](#4-stdpriority_queue)
- [5. Heap Behavior Deep Dive](#5-heap-behavior-deep-dive)
- [6. Custom Comparators for priority_queue](#6-custom-comparators-for-priority_queue)
- [7. Common Mistakes](#7-common-mistakes)
- [8. Interview Tips](#8-interview-tips)
- [9. Competitive Programming Tricks](#9-competitive-programming-tricks)
- [10. Edge Cases](#10-edge-cases)
- [11. Summary](#11-summary)
- [12. Practice Section](#12-practice-section)

---

## 1. Overview

Container adapters are **wrappers** that provide a restricted interface over an underlying container. They are NOT containers themselves — they adapt existing containers.

```
┌─────────────────────────────────────────────────────────────┐
│                    Container Adapters                         │
├───────────┬───────────────┬─────────────────────────────────┤
│  stack    │    queue      │      priority_queue              │
│  (LIFO)   │   (FIFO)     │     (Heap-based)                │
│           │              │                                   │
│  push()   │  push()      │  push()                          │
│  pop()    │  pop()       │  pop()                           │
│  top()    │  front()     │  top() ← always the max          │
│           │  back()      │                                   │
│           │              │                                   │
│  Default: │  Default:    │  Default:                         │
│  deque    │  deque       │  vector + make_heap              │
└───────────┴───────────────┴─────────────────────────────────┘

Key: NO iterators! NO random access! Only restricted operations.
```

---

## 2. std::stack

### 2.1 Concept Explanation

`std::stack` is a **LIFO** (Last In, First Out) adapter. Think of a stack of plates — you can only add/remove from the top.

```
push(3) → push(1) → push(4) → pop() → top()

    ┌───┐     ┌───┐     ┌───┐     ┌───┐     ┌───┐
    │ 3 │     │ 1 │     │ 4 │     │ 1 │     │ 1 │ ← top
    └───┘     │ 3 │     │ 1 │     │ 3 │     │ 3 │
              └───┘     │ 3 │     └───┘     └───┘
                        └───┘
              top=1     top=4     top=1     top=1
```

### 2.2 Internal Working

```cpp
// std::stack is just a wrapper around another container
// Default underlying container: std::deque

template <typename T, typename Container = std::deque<T>>
class stack {
    Container c;  // The underlying container
public:
    void push(const T& x) { c.push_back(x); }
    void pop() { c.pop_back(); }
    T& top() { return c.back(); }
    bool empty() { return c.empty(); }
    size_t size() { return c.size(); }
};
```

### 2.3 Time Complexity

| Operation | Complexity | Notes                      |
| --------- | ---------- | -------------------------- |
| `push()`  | **O(1)**   | Delegates to `push_back()` |
| `pop()`   | **O(1)**   | Delegates to `pop_back()`  |
| `top()`   | **O(1)**   | Delegates to `back()`      |
| `size()`  | **O(1)**   |                            |
| `empty()` | **O(1)**   |                            |

### 2.4 Syntax & All Functions

```cpp
#include <stack>

// ─────────────────────────── Construction ───────────────────────────
std::stack<int> s1;                              // Default (deque)
std::stack<int, std::vector<int>> s2;           // Using vector
std::stack<int, std::list<int>> s3;             // Using list

// From existing container
std::deque<int> d = {1, 2, 3};
std::stack<int> s4(d);  // Stack with 1,2,3 (top = 3)

// ─────────────────────────── Operations ─────────────────────────────
s.push(42);        // Add to top
s.emplace(42);     // Construct at top
s.pop();           // Remove from top (returns void!)
s.top();           // Access top element (reference)
s.size();          // Number of elements
s.empty();         // Whether stack is empty
s.swap(other);     // Swap with another stack

// ─────────────────────────── NO ITERATION! ──────────────────────────
// s.begin();      // ❌ Does not exist!
// s[0];           // ❌ Does not exist!
// for (auto x : s) // ❌ Does not work!
```

### 2.5 Underlying Container Requirements

The underlying container must support:
- `back()`
- `push_back()`
- `pop_back()`

Valid containers: `deque` (default), `vector`, `list`

```cpp
std::stack<int> s1;                            // deque (default, fastest for most uses)
std::stack<int, std::vector<int>> s2;         // vector (contiguous memory)
std::stack<int, std::list<int>> s3;           // list (stable references)
// std::stack<int, std::forward_list<int>> s4; // ❌ No push_back/back
```

### 2.6 Code Examples

#### Classic: Balanced Parentheses

```cpp
#include <iostream>
#include <stack>
#include <string>

bool isBalanced(const std::string& s) {
    std::stack<char> stk;
    
    for (char c : s) {
        if (c == '(' || c == '[' || c == '{') {
            stk.push(c);
        } else {
            if (stk.empty()) return false;
            char top = stk.top();
            stk.pop();
            if ((c == ')' && top != '(') ||
                (c == ']' && top != '[') ||
                (c == '}' && top != '{')) {
                return false;
            }
        }
    }
    return stk.empty();
}

int main() {
    std::cout << isBalanced("({[]})") << "\n";  // 1 (true)
    std::cout << isBalanced("([)]") << "\n";    // 0 (false)
    std::cout << isBalanced("((") << "\n";      // 0 (false)
    return 0;
}
```

#### Monotonic Stack

```cpp
#include <iostream>
#include <stack>
#include <vector>

// Next Greater Element for each position
std::vector<int> nextGreater(const std::vector<int>& arr) {
    int n = arr.size();
    std::vector<int> result(n, -1);
    std::stack<int> stk;  // Stack of indices
    
    for (int i = 0; i < n; i++) {
        while (!stk.empty() && arr[stk.top()] < arr[i]) {
            result[stk.top()] = arr[i];
            stk.pop();
        }
        stk.push(i);
    }
    return result;
}

int main() {
    auto res = nextGreater({4, 5, 2, 10, 8});
    for (int x : res) std::cout << x << " ";
    // Output: 5 10 10 -1 -1
    return 0;
}
```

---

## 3. std::queue

### 3.1 Concept Explanation

`std::queue` is a **FIFO** (First In, First Out) adapter. Think of a line at a store.

```
push(1) → push(2) → push(3) → pop() → front()

Front ← ┌───┬───┬───┐ ← Back
         │ 1 │ 2 │ 3 │
         └───┴───┴───┘

After pop():
Front ← ┌───┬───┐ ← Back
         │ 2 │ 3 │
         └───┴───┘
front() = 2, back() = 3
```

### 3.2 Internal Working

```cpp
template <typename T, typename Container = std::deque<T>>
class queue {
    Container c;
public:
    void push(const T& x) { c.push_back(x); }
    void pop() { c.pop_front(); }
    T& front() { return c.front(); }
    T& back() { return c.back(); }
    bool empty() { return c.empty(); }
    size_t size() { return c.size(); }
};
```

### 3.3 Time Complexity

| Operation | Complexity |
| --------- | ---------- |
| `push()`  | **O(1)**   |
| `pop()`   | **O(1)**   |
| `front()` | **O(1)**   |
| `back()`  | **O(1)**   |
| `size()`  | **O(1)**   |
| `empty()` | **O(1)**   |

### 3.4 Syntax & All Functions

```cpp
#include <queue>

// ─────────────────────────── Construction ───────────────────────────
std::queue<int> q1;                              // Default (deque)
std::queue<int, std::list<int>> q2;             // Using list

// ─────────────────────────── Operations ─────────────────────────────
q.push(42);        // Add to back
q.emplace(42);     // Construct at back
q.pop();           // Remove from front (returns void!)
q.front();         // Access front element
q.back();          // Access back element
q.size();          // Number of elements
q.empty();         // Whether queue is empty
q.swap(other);     // Swap

// ⚠️ pop() returns VOID — always read front() BEFORE popping!
int val = q.front();
q.pop();
```

### 3.5 Underlying Container Requirements

Must support: `front()`, `back()`, `push_back()`, `pop_front()`

Valid: `deque` (default), `list`
Invalid: `vector` (no `pop_front`)

### 3.6 Code Example: BFS

```cpp
#include <iostream>
#include <queue>
#include <vector>

void bfs(const std::vector<std::vector<int>>& adj, int start) {
    int n = adj.size();
    std::vector<bool> visited(n, false);
    std::queue<int> q;
    
    visited[start] = true;
    q.push(start);
    
    while (!q.empty()) {
        int node = q.front();
        q.pop();
        std::cout << node << " ";
        
        for (int neighbor : adj[node]) {
            if (!visited[neighbor]) {
                visited[neighbor] = true;
                q.push(neighbor);
            }
        }
    }
}

int main() {
    // Adjacency list for graph: 0-1-2, 0-3, 1-4
    std::vector<std::vector<int>> adj = {
        {1, 3},    // 0
        {0, 2, 4}, // 1
        {1},       // 2
        {0},       // 3
        {1}        // 4
    };
    
    std::cout << "BFS from 0: ";
    bfs(adj, 0);
    // Output: 0 1 3 2 4
    
    return 0;
}
```

---

## 4. std::priority_queue

### 4.1 Concept Explanation

`std::priority_queue` is a **max-heap** by default. The largest element is always at the top. It's the most complex adapter and one of the most useful in competitive programming.

```
push(3), push(1), push(4), push(1), push(5):

Internal max-heap (array representation):
              5
            /   \
           4     3
          / \
         1   1

top() = 5 (always the maximum)

Array: [5, 4, 3, 1, 1]
```

### 4.2 Internal Working

```
┌──────────────────────────────────────────────────────────────────┐
│              priority_queue Internal Working                      │
│                                                                   │
│  Underlying container: std::vector (default)                     │
│  Heap operations: std::make_heap, push_heap, pop_heap            │
│                                                                   │
│  Binary Heap stored as array:                                    │
│  ┌────┬────┬────┬────┬────┬────┬────┐                           │
│  │ 50 │ 30 │ 40 │ 10 │ 20 │ 35 │ 25 │    index: 0 1 2 3 4 5 6 │
│  └────┴────┴────┴────┴────┴────┴────┘                           │
│                                                                   │
│  Tree view:              50                                      │
│                        /    \                                    │
│                      30      40                                  │
│                     /  \    /  \                                 │
│                   10   20  35   25                               │
│                                                                   │
│  Parent of i:     (i - 1) / 2                                   │
│  Left child of i: 2 * i + 1                                     │
│  Right child of i: 2 * i + 2                                    │
│                                                                   │
│  Heap property: parent ≥ children (max-heap)                    │
└──────────────────────────────────────────────────────────────────┘
```

#### Push Operation (Sift Up)

```
push(45):
1. Add 45 at the end: [..., 25, 45]
2. Sift up: Compare 45 with parent (40)
3. 45 > 40 → swap
4. Compare 45 with parent (50)
5. 45 < 50 → stop

Time: O(log n)
```

#### Pop Operation (Sift Down)

```
pop(): (removes max = 50)
1. Swap root (50) with last element
2. Remove last element (the old root)
3. Sift down new root to restore heap property

Time: O(log n)
```

### 4.3 Time Complexity

| Operation               | Complexity   | Notes             |
| ----------------------- | ------------ | ----------------- |
| `push()`                | **O(log n)** | Sift up           |
| `pop()`                 | **O(log n)** | Sift down         |
| `top()`                 | **O(1)**     | Access root       |
| `size()`                | **O(1)**     |                   |
| `empty()`               | **O(1)**     |                   |
| Construction from range | **O(n)**     | Using `make_heap` |

### 4.4 Syntax & All Functions

```cpp
#include <queue>

// ─────────────────────────── Construction ───────────────────────────
// Max-heap (default)
std::priority_queue<int> pq1;

// Min-heap
std::priority_queue<int, std::vector<int>, std::greater<int>> pq2;

// From vector
std::vector<int> v = {3, 1, 4, 1, 5};
std::priority_queue<int> pq3(v.begin(), v.end());  // O(n) construction!

// Custom comparator
auto cmp = [](int a, int b) { return a > b; };  // min-heap
std::priority_queue<int, std::vector<int>, decltype(cmp)> pq4(cmp);

// ─────────────────────────── Operations ─────────────────────────────
pq.push(42);       // Add element (O(log n))
pq.emplace(42);    // Construct in-place (O(log n))
pq.pop();          // Remove top element (O(log n), returns void!)
pq.top();          // Access top element (O(1))
pq.size();         // Number of elements
pq.empty();        // Whether empty
pq.swap(other);    // Swap

// ⚠️ NO: find, erase, iterate, clear, operator[]
```

### 4.5 Max-Heap vs Min-Heap

```cpp
// MAX-HEAP (default): Largest element on top
std::priority_queue<int> max_pq;
max_pq.push(3);
max_pq.push(1);
max_pq.push(4);
max_pq.top();  // 4

// MIN-HEAP: Smallest element on top
std::priority_queue<int, std::vector<int>, std::greater<int>> min_pq;
min_pq.push(3);
min_pq.push(1);
min_pq.push(4);
min_pq.top();  // 1

// TRICK: Negate values to use max-heap as min-heap
std::priority_queue<int> trick_pq;
trick_pq.push(-3);
trick_pq.push(-1);
trick_pq.push(-4);
// trick_pq.top() = -1, negate to get 1 (minimum)
```

### 4.6 Code Examples

#### Example 1: K Largest Elements

```cpp
#include <iostream>
#include <queue>
#include <vector>

std::vector<int> kLargest(const std::vector<int>& arr, int k) {
    // Min-heap of size k: keeps the k largest elements
    std::priority_queue<int, std::vector<int>, std::greater<int>> min_pq;
    
    for (int x : arr) {
        min_pq.push(x);
        if (min_pq.size() > k) {
            min_pq.pop();  // Remove smallest
        }
    }
    
    std::vector<int> result;
    while (!min_pq.empty()) {
        result.push_back(min_pq.top());
        min_pq.pop();
    }
    return result;
}

int main() {
    auto res = kLargest({3, 1, 4, 1, 5, 9, 2, 6}, 3);
    for (int x : res) std::cout << x << " ";
    // Output: 5 6 9 (the 3 largest)
    return 0;
}
```

#### Example 2: Dijkstra's Algorithm

```cpp
#include <iostream>
#include <queue>
#include <vector>

using pii = std::pair<int, int>;  // {distance, node}

std::vector<int> dijkstra(const std::vector<std::vector<pii>>& adj, int src) {
    int n = adj.size();
    std::vector<int> dist(n, INT_MAX);
    
    // Min-heap: {distance, node}
    std::priority_queue<pii, std::vector<pii>, std::greater<pii>> pq;
    
    dist[src] = 0;
    pq.push({0, src});
    
    while (!pq.empty()) {
        auto [d, u] = pq.top();
        pq.pop();
        
        if (d > dist[u]) continue;  // Skip outdated entries
        
        for (auto [v, w] : adj[u]) {
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                pq.push({dist[v], v});
            }
        }
    }
    return dist;
}
```

#### Example 3: Merge K Sorted Lists

```cpp
#include <iostream>
#include <queue>
#include <vector>

std::vector<int> mergeKSorted(std::vector<std::vector<int>>& lists) {
    // Min-heap: {value, list_index, element_index}
    using T = std::tuple<int, int, int>;
    std::priority_queue<T, std::vector<T>, std::greater<T>> pq;
    
    // Initialize with first element of each list
    for (int i = 0; i < lists.size(); i++) {
        if (!lists[i].empty()) {
            pq.push({lists[i][0], i, 0});
        }
    }
    
    std::vector<int> result;
    while (!pq.empty()) {
        auto [val, li, ei] = pq.top();
        pq.pop();
        result.push_back(val);
        
        if (ei + 1 < lists[li].size()) {
            pq.push({lists[li][ei + 1], li, ei + 1});
        }
    }
    return result;
}
```

---

## 5. Heap Behavior Deep Dive

### 5.1 Binary Heap Properties

1. **Complete Binary Tree**: All levels filled except possibly the last (filled left to right)
2. **Heap Property**: Parent ≥ children (max-heap) or Parent ≤ children (min-heap)
3. **Array Storage**: No pointers needed — parent/child computed from index

### 5.2 Heap Operations Visualization

```
INSERT 45 into max-heap [50, 30, 40, 10, 20]:

Step 1: Add at end
[50, 30, 40, 10, 20, 45]
              50
            /    \
          30      40
         / \     /
       10   20  45     ← added here

Step 2: Sift up (45 > 40, swap)
[50, 30, 45, 10, 20, 40]
              50
            /    \
          30      45    ← swapped
         / \     /
       10   20  40

Step 3: 45 < 50, stop. Done!


REMOVE TOP from [50, 30, 45, 10, 20, 40]:

Step 1: Swap root with last
[40, 30, 45, 10, 20, 50]  → remove 50
[40, 30, 45, 10, 20]

Step 2: Sift down (40 < max(30, 45) = 45, swap with 45)
[45, 30, 40, 10, 20]

Step 3: 40 has no children violating heap property. Done!
```

### 5.3 STL Heap Functions (Low-Level)

```cpp
#include <algorithm>  // Heap functions
#include <vector>

std::vector<int> v = {3, 1, 4, 1, 5, 9, 2, 6};

// Build heap — O(n)
std::make_heap(v.begin(), v.end());
// v is now a valid max-heap: [9, 6, 4, 1, 5, 3, 2, 1]

// Check if heap
bool is = std::is_heap(v.begin(), v.end());  // true

// Push element to heap — must push_back first!
v.push_back(7);
std::push_heap(v.begin(), v.end());  // O(log n)
// Sifts up the last element

// Pop from heap — moves max to end!
std::pop_heap(v.begin(), v.end());   // O(log n)
// v.back() is now the max, heap is v[0..n-2]
int max_val = v.back();
v.pop_back();

// Sort heap — turns heap into sorted array
std::sort_heap(v.begin(), v.end());  // O(n log n)
// v is now sorted ascending
```

---

## 6. Custom Comparators for priority_queue

### 6.1 Using Struct Comparator

```cpp
// Sort by absolute value (smaller absolute value has higher priority)
struct AbsCompare {
    bool operator()(int a, int b) const {
        return std::abs(a) > std::abs(b);  // Note: REVERSED for priority_queue!
    }
};

std::priority_queue<int, std::vector<int>, AbsCompare> pq;
pq.push(-5);
pq.push(2);
pq.push(-1);
pq.push(4);
// top() = -1 (smallest absolute value)
```

### 6.2 Important: Comparator is REVERSED!

```
⚠️ CRITICAL CONCEPT:
The comparator for priority_queue works OPPOSITE to sort!

For std::sort:  comp(a, b) = true means a comes BEFORE b
For priority_queue: comp(a, b) = true means a has LOWER priority than b

So:
less<int>()     → max-heap (default) — "less priority if smaller"
greater<int>()  → min-heap          — "less priority if greater"
```

### 6.3 Using Lambda Comparator

```cpp
auto cmp = [](const std::pair<int,int>& a, const std::pair<int,int>& b) {
    return a.second > b.second;  // Smaller second → higher priority
};

std::priority_queue<
    std::pair<int,int>,
    std::vector<std::pair<int,int>>,
    decltype(cmp)
> pq(cmp);

pq.push({1, 30});
pq.push({2, 10});
pq.push({3, 20});
// top() = {2, 10} (smallest second value)
```

### 6.4 Custom Struct in priority_queue

```cpp
struct Task {
    std::string name;
    int priority;
    int timestamp;
};

struct TaskCompare {
    bool operator()(const Task& a, const Task& b) const {
        // Higher priority first; if tied, earlier timestamp first
        if (a.priority != b.priority) return a.priority < b.priority;
        return a.timestamp > b.timestamp;
    }
};

std::priority_queue<Task, std::vector<Task>, TaskCompare> task_queue;
task_queue.push({"Email", 2, 100});
task_queue.push({"Bug Fix", 5, 90});
task_queue.push({"Meeting", 5, 80});
// top() = {"Meeting", 5, 80} (highest priority, earliest timestamp)
```

---

## 7. Common Mistakes

### Mistake 1: pop() Returns void!

```cpp
std::stack<int> stk;
stk.push(42);

// ❌ pop() does NOT return the value!
// int val = stk.pop();  // COMPILE ERROR!

// ✅ Read top() first, then pop()
int val = stk.top();
stk.pop();

// Same for queue and priority_queue
std::queue<int> q;
q.push(42);
// int val = q.pop();    // ❌
int val2 = q.front();
q.pop();                 // ✅
```

### Mistake 2: Using pop() on Empty Container

```cpp
std::stack<int> stk;
// stk.pop();  // ❌ UNDEFINED BEHAVIOR!
// stk.top();  // ❌ UNDEFINED BEHAVIOR!

// ✅ Always check empty()
if (!stk.empty()) {
    int val = stk.top();
    stk.pop();
}
```

### Mistake 3: Thinking priority_queue is Min-Heap

```cpp
std::priority_queue<int> pq;
pq.push(3);
pq.push(1);
pq.push(4);

// ❌ Common mistake: assuming top() is minimum
// pq.top() == 4 (MAXIMUM, not minimum!)

// ✅ For min-heap:
std::priority_queue<int, std::vector<int>, std::greater<int>> min_pq;
```

### Mistake 4: Trying to Iterate Container Adapters

```cpp
std::stack<int> stk;
stk.push(1); stk.push(2); stk.push(3);

// ❌ No iterators!
// for (int x : stk) { }

// ✅ To "iterate": destructive traversal
while (!stk.empty()) {
    std::cout << stk.top() << " ";
    stk.pop();
}
// Stack is now empty!

// ✅ Or use vector as stack (allows iteration)
std::vector<int> v;
v.push_back(1); v.push_back(2); v.push_back(3);
for (int x : v) std::cout << x << " ";  // Iterate without destroying
```

### Mistake 5: No Decrease-Key in priority_queue

```cpp
// priority_queue does NOT support changing the priority of an element
// Common workaround: "lazy deletion"

std::priority_queue<std::pair<int,int>> pq;  // {priority, id}
std::vector<int> best(n, INT_MAX);

// Instead of decrease-key, just push a new entry
pq.push({new_priority, id});

// When popping, skip outdated entries
while (!pq.empty()) {
    auto [pri, id] = pq.top();
    pq.pop();
    if (pri != best[id]) continue;  // Outdated, skip
    // Process...
}
```

---

## 8. Interview Tips

### Must-Know Questions

**Q1: Why does `pop()` return void?**
> To be exception-safe. If `pop()` returned the value and the copy/move threw an exception, the element would be lost — already removed but not successfully copied. By separating `top()` and `pop()`, you can access the element, then remove it safely.

**Q2: What is the underlying container of `std::priority_queue`?**
> `std::vector` by default. The heap is maintained using `std::make_heap`, `std::push_heap`, and `std::pop_heap` algorithms on the vector.

**Q3: How do you implement a min-heap with `priority_queue`?**
> Use `std::priority_queue<int, std::vector<int>, std::greater<int>>` or negate all values when using the default max-heap.

**Q4: Can you efficiently remove an arbitrary element from `priority_queue`?**
> No. `priority_queue` only supports removing the top. For arbitrary removal, use `std::set` or implement lazy deletion.

**Q5: stack vs queue vs priority_queue — when to use each?**
> Stack: recursion simulation, DFS, expression evaluation, undo operations.
> Queue: BFS, scheduling, buffering.
> Priority Queue: Dijkstra, K-th largest, task scheduling, event processing.

---

## 9. Competitive Programming Tricks

### Trick 1: Vector as Stack (Recommended for CP)

```cpp
// Use vector instead of stack for more flexibility
vector<int> stk;
stk.push_back(x);     // push
stk.pop_back();       // pop
stk.back();           // top
stk.empty();          // empty

// Advantages:
// - Can iterate
// - Can access any element
// - Can clear
// - Can check size
// - Same performance
```

### Trick 2: Min-Heap Shorthand

```cpp
// Long form:
priority_queue<int, vector<int>, greater<int>> pq;

// With typedef:
typedef priority_queue<int, vector<int>, greater<int>> min_pq;
min_pq pq;

// Or just negate values:
priority_queue<int> pq;
pq.push(-x);  // Insert
int min_val = -pq.top();  // Get minimum
```

### Trick 3: Pair in priority_queue

```cpp
// Sort by first, then by second (both max by default)
priority_queue<pair<int,int>> pq;
pq.push({distance, node});

// For Dijkstra (min distance): negate or use greater<>
priority_queue<pair<int,int>, vector<pair<int,int>>, greater<pair<int,int>>> pq;
pq.push({0, source});
```

### Trick 4: Running Median

```cpp
// Maintain two heaps: max-heap for lower half, min-heap for upper half
priority_queue<int> lower;  // max-heap
priority_queue<int, vector<int>, greater<int>> upper;  // min-heap

void addNum(int num) {
    lower.push(num);
    upper.push(lower.top());
    lower.pop();
    
    if (upper.size() > lower.size()) {
        lower.push(upper.top());
        upper.pop();
    }
}

double getMedian() {
    if (lower.size() > upper.size()) return lower.top();
    return (lower.top() + upper.top()) / 2.0;
}
```

### Trick 5: Lazy Deletion

```cpp
// When you need to "remove" from priority_queue without O(n) rebuild
priority_queue<int> pq;
unordered_map<int, int> deleted;  // Tracks deleted counts

void lazy_push(int x) { pq.push(x); }

void lazy_delete(int x) { deleted[x]++; }

int lazy_top() {
    while (!pq.empty() && deleted[pq.top()] > 0) {
        deleted[pq.top()]--;
        pq.pop();
    }
    return pq.top();
}
```

### Trick 6: Monotonic Stack Templates

```cpp
// Next Greater Element (right)
vector<int> nge(vector<int>& a) {
    int n = a.size();
    vector<int> res(n, -1);
    stack<int> stk;
    for (int i = 0; i < n; i++) {
        while (!stk.empty() && a[stk.top()] < a[i]) {
            res[stk.top()] = a[i];
            stk.pop();
        }
        stk.push(i);
    }
    return res;
}

// Previous Smaller Element (left)
vector<int> pse(vector<int>& a) {
    int n = a.size();
    vector<int> res(n, -1);
    stack<int> stk;
    for (int i = 0; i < n; i++) {
        while (!stk.empty() && a[stk.top()] >= a[i]) stk.pop();
        if (!stk.empty()) res[i] = a[stk.top()];
        stk.push(i);
    }
    return res;
}

// Largest Rectangle in Histogram
int largestRectangleArea(vector<int>& heights) {
    stack<int> stk;
    int maxArea = 0;
    heights.push_back(0);  // Sentinel
    
    for (int i = 0; i < heights.size(); i++) {
        while (!stk.empty() && heights[stk.top()] > heights[i]) {
            int h = heights[stk.top()]; stk.pop();
            int w = stk.empty() ? i : (i - stk.top() - 1);
            maxArea = max(maxArea, h * w);
        }
        stk.push(i);
    }
    return maxArea;
}
```

---

## 10. Edge Cases

### Empty Container Operations

```cpp
std::stack<int> s;
// s.top();   // ❌ UB
// s.pop();   // ❌ UB

std::queue<int> q;
// q.front(); // ❌ UB
// q.back();  // ❌ UB
// q.pop();   // ❌ UB

std::priority_queue<int> pq;
// pq.top();  // ❌ UB
// pq.pop();  // ❌ UB
```

### Single Element

```cpp
std::priority_queue<int> pq;
pq.push(42);
pq.top();  // 42
pq.pop();  // Now empty
```

### Duplicate Values in priority_queue

```cpp
std::priority_queue<int> pq;
pq.push(5);
pq.push(5);
pq.push(5);
pq.size();   // 3
pq.top();    // 5
pq.pop();    // size = 2, top = 5
```

---

## 11. Summary

```
┌────────────────────────────────────────────────────────────────┐
│             CONTAINER ADAPTERS CHEAT SHEET                      │
├────────────┬──────────────────────────────────────────────────┤
│ stack      │ LIFO. push/pop/top. Default: deque.              │
│            │ Use for: DFS, parentheses, undo, monotonic stack │
├────────────┼──────────────────────────────────────────────────┤
│ queue      │ FIFO. push/pop/front/back. Default: deque.       │
│            │ Use for: BFS, scheduling, buffering.             │
├────────────┼──────────────────────────────────────────────────┤
│ priority_  │ Max-heap by default. push/pop/top. Uses vector.  │
│ queue      │ Use for: Dijkstra, K-th element, task scheduling │
│            │ Min-heap: greater<int> or negate values.         │
├────────────┼──────────────────────────────────────────────────┤
│ ALL        │ NO iterators! pop() returns void! Check empty()! │
└────────────┴──────────────────────────────────────────────────┘

GOLDEN RULES:
1. pop() returns VOID — read top()/front() first
2. Always check empty() before accessing
3. priority_queue is MAX-heap by default
4. Comparator logic is REVERSED in priority_queue
5. In CP, prefer vector as stack for flexibility
```

---

## 12. Practice Section

### Level 1 — Quick Concept Questions

1. **Q: What does LIFO stand for?**
   <details><summary>Answer</summary>Last In, First Out.</details>

2. **Q: What is the default underlying container for `std::stack`?**
   <details><summary>Answer</summary>`std::deque`</details>

3. **Q: Is `priority_queue` a max-heap or min-heap by default?**
   <details><summary>Answer</summary>Max-heap. The largest element is on top.</details>

4. **Q: Does `pop()` return the removed element?**
   <details><summary>Answer</summary>No, it returns `void`. You must read `top()`/`front()` before calling `pop()`.</details>

5. **Q: Can you iterate over a `std::stack`?**
   <details><summary>Answer</summary>No. Container adapters do not provide iterators.</details>

6. **Q: What is the time complexity of `priority_queue::push()`?**
   <details><summary>Answer</summary>O(log n) — heap sift-up operation.</details>

7. **Q: Can you use `std::vector` as the underlying container for `std::queue`?**
   <details><summary>Answer</summary>No. `queue` requires `pop_front()`, which `vector` doesn't have.</details>

8. **Q: How do you create a min-heap `priority_queue`?**
   <details><summary>Answer</summary>`std::priority_queue<int, std::vector<int>, std::greater<int>>`</details>

9. **Q: What is the time complexity of building a `priority_queue` from a vector?**
   <details><summary>Answer</summary>O(n) using `make_heap`.</details>

10. **Q: What happens if you call `top()` on an empty stack?**
    <details><summary>Answer</summary>Undefined behavior.</details>

---

### Level 2 — MCQs

**1. `std::stack` supports which operations?**
- A) push, pop, front
- B) push, pop, top ✅
- C) push, pop, at
- D) push, pop, begin

**2. What is the underlying data structure of `priority_queue`?**
- A) Linked list
- B) Binary Search Tree
- C) Binary heap (array-based) ✅
- D) Hash table

**3. After `push(3), push(1), push(5), pop()` on a max priority_queue, `top()` returns:**
- A) 1
- B) 3 ✅
- C) 5
- D) Undefined

**4. Which container can NOT be used as underlying container for `std::stack`?**
- A) `deque`
- B) `vector`
- C) `list`
- D) `forward_list` ✅

**5. The comparator in `priority_queue<int, vector<int>, greater<int>>` makes it a:**
- A) Max-heap
- B) Min-heap ✅
- C) Stack
- D) Queue

**6. `std::queue::front()` returns the element that was added:**
- A) Most recently
- B) Earliest ✅ (FIFO)
- C) With highest priority
- D) At a random position

**7. Building a heap from n elements takes:**
- A) O(n log n)
- B) O(n) ✅
- C) O(log n)
- D) O(n²)

**8. In `priority_queue`, the comparator `comp(a, b) = true` means:**
- A) a has higher priority
- B) a has lower priority than b ✅
- C) a and b are equal
- D) a should be on top

**9. Which adapter is used for BFS?**
- A) stack
- B) queue ✅
- C) priority_queue
- D) deque

**10. `priority_queue` does NOT support:**
- A) push
- B) top
- C) find / erase ✅
- D) empty

---

### Level 3 — Tricky Interview MCQs

**1. Why does `stack::pop()` return `void` instead of the value?**
- A) For performance
- B) For exception safety ✅
- C) It's a design flaw
- D) To match C conventions

**2. Can `std::priority_queue` be used for Dijkstra's algorithm?**
- A) No, it's always a max-heap
- B) Yes, with `greater<>` comparator as min-heap ✅
- C) Only with a custom container
- D) No, it doesn't support decrease-key

**3. What is the space complexity of `priority_queue` with n elements?**
- A) O(n log n)
- B) O(n) ✅
- C) O(n²)
- D) O(log n)

**4. How do you efficiently clear a `std::stack`?**
- A) `stk.clear()` — O(1)
- B) Pop all elements — O(n)
- C) Both work, A is faster
- D) Assign empty stack — O(1) ✅ (`stk = stack<int>();`)

**5. Which is NOT a valid use case for monotonic stack?**
- A) Next greater element
- B) Largest rectangle in histogram
- C) Shortest path in a graph ✅
- D) Stock span problem

---

### Level 4 — True / False

| #   | Statement                                                                          | Answer               |
| --- | ---------------------------------------------------------------------------------- | -------------------- |
| 1   | `std::stack` provides random access                                                | **False**            |
| 2   | `priority_queue::top()` always returns the largest element with default comparator | **True**             |
| 3   | `queue` uses `vector` as its default container                                     | **False** (deque)    |
| 4   | You can change the priority of an element in `priority_queue`                      | **False**            |
| 5   | Container adapters have iterators                                                  | **False**            |
| 6   | `priority_queue` can be built from a vector in O(n)                                | **True**             |
| 7   | `stack::push` is O(log n)                                                          | **False** (O(1))     |
| 8   | `queue::back()` returns the most recently added element                            | **True**             |
| 9   | `priority_queue` with `greater<int>` is a max-heap                                 | **False** (min-heap) |
| 10  | `std::list` can be used for both stack and queue                                   | **True**             |

---

### Level 5 — Coding Practice Problems

**Problem 1: Valid Parentheses**
```cpp
// Given string s containing '(', ')', '{', '}', '[', ']',
// determine if the input string is valid.
// Hint: Use stack
```

**Problem 2: Implement Queue using Two Stacks**
```cpp
// Implement a queue that supports push, pop, peek, and empty
// using only two stacks.
```

**Problem 3: Sliding Window Maximum**
```cpp
// Given array and window size k, find max in each window.
// Use monotonic deque for O(n) solution.
```

**Problem 4: K-th Largest Element in Stream**
```cpp
// Design a class that finds the k-th largest element in a stream.
// add(val): Add element to stream.
// get(): Return k-th largest.
// Hint: Min-heap of size k.
```

**Problem 5: Task Scheduler**
```cpp
// Given tasks array and cooldown period n,
// find minimum time to execute all tasks.
// Hint: Use priority_queue (max-heap) for greedy scheduling.
```

---

---

## 13. Extended Examples with Test Cases

### Example 1 — stack: balanced parentheses

```cpp
#include <iostream>
#include <stack>
#include <string>
using namespace std;

bool isBalanced(const string& s) {
    stack<char> st;
    for (char c : s) {
        if (c == '(' || c == '[' || c == '{')
            st.push(c);
        else {
            if (st.empty()) return false;
            char top = st.top(); st.pop();
            if (c == ')' && top != '(') return false;
            if (c == ']' && top != '[') return false;
            if (c == '}' && top != '{') return false;
        }
    }
    return st.empty();
}

int main() {
    cout << isBalanced("({[]})") << "\n";  // 1
    cout << isBalanced("({[})") << "\n";   // 0
    cout << isBalanced("((())") << "\n";   // 0
    cout << isBalanced("") << "\n";        // 1 (empty is balanced)
    return 0;
}
```

**Expected Output:**
```
1
0
0
1
```

---

### Example 2 — queue: BFS level-order traversal

```cpp
#include <iostream>
#include <queue>
#include <vector>
using namespace std;

// Simple binary tree BFS
struct Node {
    int val;
    Node *left, *right;
    Node(int v) : val(v), left(nullptr), right(nullptr) {}
};

void bfs(Node* root) {
    if (!root) return;
    queue<Node*> q;
    q.push(root);
    while (!q.empty()) {
        int sz = q.size();
        while (sz--) {
            Node* cur = q.front(); q.pop();
            cout << cur->val << " ";
            if (cur->left)  q.push(cur->left);
            if (cur->right) q.push(cur->right);
        }
        cout << "\n";
    }
}

int main() {
    Node* root = new Node(1);
    root->left  = new Node(2);
    root->right = new Node(3);
    root->left->left  = new Node(4);
    root->left->right = new Node(5);
    bfs(root);
    // Output:
    // 1
    // 2 3
    // 4 5
    return 0;
}
```

---

### Example 3 — priority_queue: top-K elements

```cpp
#include <iostream>
#include <queue>
#include <vector>
using namespace std;

vector<int> topK(vector<int>& arr, int k) {
    // Min-heap of size k: keeps largest k elements
    priority_queue<int, vector<int>, greater<int>> pq;

    for (int x : arr) {
        pq.push(x);
        if ((int)pq.size() > k)
            pq.pop();  // remove smallest
    }

    vector<int> result;
    while (!pq.empty()) {
        result.push_back(pq.top());
        pq.pop();
    }
    return result;
}

int main() {
    vector<int> arr = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3};
    auto res = topK(arr, 3);
    for (int x : res) cout << x << " ";
    cout << "\n";  // 5 6 9 (or sorted differently — always top 3)
    return 0;
}
```

---

### Example 4 — priority_queue with custom struct (Dijkstra pattern)

```cpp
#include <iostream>
#include <queue>
#include <vector>
using namespace std;

struct State {
    int cost, node;
    bool operator>(const State& o) const { return cost > o.cost; }
};

int main() {
    // Min-heap: process lowest-cost state first
    priority_queue<State, vector<State>, greater<State>> pq;

    pq.push({5, 1});
    pq.push({2, 3});
    pq.push({8, 2});
    pq.push({1, 4});

    while (!pq.empty()) {
        auto [c, n] = pq.top(); pq.pop();
        cout << "node=" << n << " cost=" << c << "\n";
    }
    // Output (min cost first):
    // node=4 cost=1
    // node=3 cost=2
    // node=1 cost=5
    // node=2 cost=8

    return 0;
}
```

---

### Example 5 — monotonic stack: next greater element

```cpp
#include <iostream>
#include <stack>
#include <vector>
using namespace std;

vector<int> nextGreater(vector<int>& arr) {
    int n = arr.size();
    vector<int> res(n, -1);
    stack<int> st;  // stores indices

    for (int i = 0; i < n; i++) {
        while (!st.empty() && arr[st.top()] < arr[i]) {
            res[st.top()] = arr[i];
            st.pop();
        }
        st.push(i);
    }
    return res;
}

int main() {
    vector<int> a = {4, 5, 2, 10, 8};
    auto res = nextGreater(a);
    for (int x : res) cout << x << " ";
    cout << "\n";  // 5 10 10 -1 -1

    return 0;
}
```

---

## 14. Tricky MCQs — Expert Level

**Q1. What is printed?**
```cpp
stack<int> s;
s.push(1); s.push(2); s.push(3);
while (!s.empty()) {
    cout << s.top() << " ";
    s.pop();
}
```
- A) `1 2 3`
- B) `3 2 1` ✅
- C) `3 3 3`
- D) Undefined

---

**Q2. What is printed?**
```cpp
priority_queue<int> pq;
pq.push(5); pq.push(1); pq.push(3); pq.push(7); pq.push(2);
cout << pq.top();
pq.pop();
cout << pq.top();
```
- A) `7 5` ✅
- B) `5 3`
- C) `1 2`
- D) `7 7`

---

**Q3. Which statement about `stack::pop()` is correct?**
- A) Returns the removed element
- B) Returns void; use `top()` before `pop()` ✅
- C) Throws if stack is empty (well-defined exception)
- D) Returns an optional

---

**Q4. What is the default underlying container of `std::queue`?**
- A) `std::vector`
- B) `std::list`
- C) `std::deque` ✅
- D) `std::array`

---

**Q5. How do you create a min-heap `priority_queue` for integers?**
- A) `priority_queue<int, vector<int>, less<int>> pq;`
- B) `priority_queue<int, vector<int>, greater<int>> pq;` ✅
- C) `priority_queue<int, list<int>> pq;`
- D) `min_heap<int> pq;`

---

**Q6. Building a `priority_queue` from a vector of n elements is:**
- A) O(n log n)
- B) O(n) ✅ using the range constructor (uses `make_heap`)
- C) O(n²)
- D) O(log n)

---

**Q7. `std::priority_queue` does NOT natively support:**
- A) `push`
- B) `pop`
- C) `top`
- D) Updating priority of existing element ✅

---

**Q8. What is the time complexity of `push` on `priority_queue`?**
- A) O(1)
- B) O(log n) ✅
- C) O(n)
- D) O(n log n)

---

**Q9. Implementing a stack using a queue requires:**
- A) O(1) push and O(1) pop
- B) O(1) push and O(n) pop OR O(n) push and O(1) pop ✅
- C) Two priority queues
- D) O(log n) for both operations

---

**Q10. Can you use a `stack` for DFS without recursion?**
- A) No, DFS requires recursion
- B) Yes — explicit `stack` simulates the call stack ✅
- C) Only with `queue`
- D) Only with `priority_queue`

---

**Q11. What is printed?**
```cpp
queue<int> q;
q.push(1); q.push(2); q.push(3);
q.pop();
cout << q.front() << " " << q.back();
```
- A) `1 3`
- B) `2 3` ✅
- C) `1 2`
- D) `3 2`

---

**Q12. Which container adapter can be built on `std::list` as the underlying container?**
- A) `priority_queue` only
- B) Both `stack` and `queue` ✅
- C) `stack` only
- D) None — only `deque` is supported

> **Why:** `stack<int, list<int>>` and `queue<int, list<int>>` are both valid. `priority_queue` requires RandomAccess (so `list` is not valid for it).

---

> **Previous:** [04_Unordered_Containers.md](04_Unordered_Containers.md)  
> **Next:** [06_STL_Algorithms.md](06_STL_Algorithms.md)
