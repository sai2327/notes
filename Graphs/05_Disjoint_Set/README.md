# Disjoint Set Union (DSU / Union-Find)

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [DSU Introduction](#dsu-introduction)
- [DSU Union and Find](#dsu-union-and-find)
- [DSU Cycle Detection](#dsu-cycle-detection)
- [DSU Path Compression](#dsu-path-compression)
- [DSU Union by Rank/Size](#dsu-union-by-rank)
- [Complete Optimized Implementation](#complete-optimized-implementation)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Cheat Sheet](#cheat-sheet)

---

## Introduction

### What is Disjoint Set Union?

**Disjoint Set Union (DSU)**, also called **Union-Find**, is a data structure that tracks a set of elements partitioned into a number of disjoint (non-overlapping) subsets. It supports two primary operations:

1. **Find(x)**: Determine which set element x belongs to (find its representative/root)
2. **Union(x, y)**: Merge the sets containing x and y

### Why is DSU Important?

DSU is one of the most powerful and elegant data structures in competitive programming and interviews:

- Nearly O(1) amortized time per operation (with optimizations)
- Extremely simple to implement
- Solves connectivity problems efficiently
- Foundation for Kruskal's MST algorithm
- Used in offline query problems

### Real-World Applications

| Application | How DSU Helps |
|-------------|---------------|
| Network connectivity | Track connected computers |
| Image processing | Connected component labeling |
| Social networks | Group membership |
| Kruskal's MST | Efficiently check if edge creates cycle |
| Equivalence classes | Group equivalent elements |
| Percolation | Physics simulations |
| Game development | Region merging |

---

## Prerequisites

- [01_Introduction](../01_Introduction/README.md) - Graph basics
- [02_Traversals](../02_Traversals/README.md) - Connected components concept
- [03_Undirected_Graph](../03_Undirected_Graph/README.md) - Cycle detection (for comparison)
- Basic understanding of trees and arrays

---

## DSU Introduction

### Core Concept

Think of DSU as managing groups of friends:
- Initially, everyone is in their own group (alone)
- When two people become friends, their groups merge
- We can quickly check if two people are in the same friend group

```
Initial state (each person is their own group):
{0} {1} {2} {3} {4} {5}

Union(0, 1): {0, 1} {2} {3} {4} {5}
Union(2, 3): {0, 1} {2, 3} {4} {5}
Union(0, 2): {0, 1, 2, 3} {4} {5}
Union(4, 5): {0, 1, 2, 3} {4, 5}

Find(0) == Find(3)? YES (same group)
Find(0) == Find(4)? NO (different groups)
```

### Internal Representation

DSU uses a **forest** (collection of trees) where each tree represents one set:
- Each element points to a **parent**
- The **root** of each tree is the **representative** of that set
- Initially, each element is its own parent (root)

```
After Union(0,1), Union(2,3), Union(1,2):

Tree representation:
    0           4       5
   / \
  1   2
      |
      3

parent[0] = 0 (root)
parent[1] = 0
parent[2] = 0
parent[3] = 2
parent[4] = 4 (root)
parent[5] = 5 (root)

Find(3): 3 → 2 → 0 (root)
Find(1): 1 → 0 (root)
Same root → same set!
```

---

## DSU Union and Find

### Naive Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class DSU_Naive {
    vector<int> parent;
    
public:
    DSU_Naive(int n) {
        parent.resize(n);
        // Initially, each element is its own parent
        for (int i = 0; i < n; i++) {
            parent[i] = i;
        }
    }
    
    // Find the root/representative of x's set
    int find(int x) {
        while (parent[x] != x) {
            x = parent[x];
        }
        return x;
    }
    
    // Merge sets containing x and y
    void unite(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        
        if (rootX != rootY) {
            parent[rootX] = rootY;  // Make rootY the parent of rootX
        }
    }
    
    // Check if x and y are in the same set
    bool connected(int x, int y) {
        return find(x) == find(y);
    }
};
```

### Dry Run - Naive DSU

```
n = 6, Initial: parent = [0, 1, 2, 3, 4, 5]

Union(0, 1):
  find(0) = 0, find(1) = 1
  parent[0] = 1
  parent = [1, 1, 2, 3, 4, 5]
  
  Tree: 1    2  3  4  5
        |
        0

Union(2, 3):
  find(2) = 2, find(3) = 3
  parent[2] = 3
  parent = [1, 1, 3, 3, 4, 5]
  
  Tree: 1    3    4  5
        |    |
        0    2

Union(1, 3):
  find(1) = 1, find(3) = 3
  parent[1] = 3
  parent = [1, 3, 3, 3, 4, 5]
  
  Tree:   3      4  5
         /|\
        1  2
        |
        0

find(0): 0 → parent[0]=1 → parent[1]=3 → parent[3]=3 (root!)
  Answer: 3 (requires 3 hops!)

Problem: The tree can become a long chain!
  If we union 0,1 then 1,2 then 2,3 then 3,4...
  parent = [1, 2, 3, 4, 4]
  find(0): 0→1→2→3→4 = O(n) hops!
```

### Complexity of Naive DSU

| Operation | Worst Case |
|-----------|-----------|
| Find | O(n) - when tree degenerates to a chain |
| Union | O(n) - because of find |
| Connected | O(n) |

This is no better than BFS/DFS! We need optimizations...

---

## DSU Cycle Detection

### Theory

DSU can detect cycles in an undirected graph during edge insertion:

```
For each edge (u, v):
  If find(u) == find(v):
    → u and v are already connected → adding this edge creates a CYCLE!
  Else:
    → union(u, v) (safe to add, no cycle)
```

### Why This Works

- DSU tracks connected components
- If two endpoints of an edge are already in the same component, there's already a path between them
- Adding another edge would create an alternative path = cycle

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class DSU {
    vector<int> parent, rank_;
    
public:
    DSU(int n) : parent(n), rank_(n, 0) {
        iota(parent.begin(), parent.end(), 0);
    }
    
    int find(int x) {
        if (parent[x] != x)
            parent[x] = find(parent[x]); // Path compression
        return parent[x];
    }
    
    bool unite(int x, int y) {
        int rx = find(x), ry = find(y);
        if (rx == ry) return false; // Already connected = would create cycle
        
        if (rank_[rx] < rank_[ry]) swap(rx, ry);
        parent[ry] = rx;
        if (rank_[rx] == rank_[ry]) rank_[rx]++;
        return true;
    }
};

bool hasCycle(int n, vector<pair<int,int>>& edges) {
    DSU dsu(n);
    
    for (auto& [u, v] : edges) {
        if (!dsu.unite(u, v)) {
            return true; // Cycle detected!
        }
    }
    
    return false;
}

// LeetCode 684: Redundant Connection
vector<int> findRedundantConnection(vector<vector<int>>& edges) {
    int n = edges.size();
    DSU dsu(n + 1); // 1-indexed
    
    for (auto& e : edges) {
        if (!dsu.unite(e[0], e[1])) {
            return e; // This edge creates the cycle
        }
    }
    
    return {};
}

int main() {
    int n = 4;
    vector<pair<int,int>> edges = {{0,1}, {1,2}, {2,3}, {3,0}};
    
    cout << "Has cycle: " << hasCycle(n, edges) << endl; // true
    // Edge (3,0) creates cycle because 0 and 3 are already connected
    
    return 0;
}
```

### Dry Run - Cycle Detection

```
Edges: (0,1), (1,2), (2,3), (3,0)

Initial: parent = [0, 1, 2, 3]

Edge (0,1):
  find(0) = 0, find(1) = 1
  Different → unite(0,1), parent = [0, 0, 2, 3]
  No cycle.

Edge (1,2):
  find(1) = find(1)→parent[1]=0 = 0
  find(2) = 2
  Different → unite(0,2), parent = [0, 0, 0, 3]
  No cycle.

Edge (2,3):
  find(2) = find(2)→parent[2]=0 = 0
  find(3) = 3
  Different → unite(0,3), parent = [0, 0, 0, 0]
  No cycle.

Edge (3,0):
  find(3) = find(3)→parent[3]=0 = 0
  find(0) = 0
  SAME ROOT! → CYCLE DETECTED!
  Edge (3,0) is the redundant connection.
```

### Comparison: DFS vs DSU for Cycle Detection

| Feature | DFS | DSU |
|---------|-----|-----|
| Time | O(V + E) | O(E × α(V)) ≈ O(E) |
| Online (add edges one by one) | ❌ Need rebuild | ✅ Natural |
| Find which edge causes cycle | Complex | ✅ Immediate |
| Works for directed graphs | ✅ (3-color) | ❌ Only undirected |
| Memory | O(V) | O(V) |

---

## DSU Path Compression

### The Problem

Without optimization, `find()` can take O(n) in the worst case when the tree becomes a long chain.

### Path Compression Idea

When we call `find(x)`, we traverse the path from x to root. **Path compression** makes every node on this path point directly to the root.

```
Before find(0):          After find(0) with path compression:
    4                        4
    |                      / | \
    3                     3  2  1
    |                            |
    2                            0
    |
    1
    |
    0

find(0): traverse 0→1→2→3→4 (root)
  Then set: parent[0]=4, parent[1]=4, parent[2]=4, parent[3]=4
  
Next find(0): 0→4 (just 1 hop!)
```

### C++ Implementation

```cpp
// Recursive path compression
int find(int x) {
    if (parent[x] != x) {
        parent[x] = find(parent[x]);  // Recursively compress path
    }
    return parent[x];
}

// Iterative path compression (two-pass)
int find(int x) {
    // First pass: find root
    int root = x;
    while (parent[root] != root) {
        root = parent[root];
    }
    
    // Second pass: compress path
    while (parent[x] != root) {
        int next = parent[x];
        parent[x] = root;
        x = next;
    }
    
    return root;
}

// Path splitting (single pass, amortized same)
int find(int x) {
    while (parent[x] != x) {
        parent[x] = parent[parent[x]]; // Skip one level
        x = parent[x];
    }
    return x;
}
```

### Dry Run - Path Compression

```
parent = [1, 2, 3, 4, 4]  (chain: 0→1→2→3→4)

find(0):
  parent[0] ≠ 0, recurse find(1)
    parent[1] ≠ 1, recurse find(2)
      parent[2] ≠ 2, recurse find(3)
        parent[3] ≠ 3, recurse find(4)
          parent[4] == 4, return 4
        parent[3] = 4, return 4
      parent[2] = 4, return 4
    parent[1] = 4, return 4
  parent[0] = 4, return 4

After: parent = [4, 4, 4, 4, 4]  (all point directly to root!)

Next find(0): parent[0] = 4 = root. O(1)!
```

### Complexity with Path Compression Only

| Operation | Amortized |
|-----------|-----------|
| Find | O(log n) |
| Union | O(log n) |

Still not optimal alone. Combined with union by rank → nearly O(1).

---

## DSU Union by Rank

### The Problem

Without this optimization, `union` can create tall trees:

```
Naive union always attaches first root to second:
Union(0,1), Union(2,3), Union(4,5), Union(6,7)
Then Union(1,3), Union(5,7)
Then Union(3,7):

Could get: 7→5→4, 7→6, 7→3→2, 7→3→1→0
Height = 3 (not great)

With union by rank, we attach shorter tree under taller:
Result is more balanced → height ≤ log(n)
```

### Union by Rank

**Rank** approximates the height of the tree. When merging, attach the shorter tree under the taller tree.

```
Rule: 
  If rank[rootX] < rank[rootY]: parent[rootX] = rootY
  If rank[rootX] > rank[rootY]: parent[rootY] = rootX
  If equal: either way, and increment rank of new root
```

### Union by Size (Alternative)

Instead of rank, track the **size** of each set. Attach smaller set under larger set.

```
Rule:
  If size[rootX] < size[rootY]: parent[rootX] = rootY, size[rootY] += size[rootX]
  Else: parent[rootY] = rootX, size[rootX] += size[rootY]
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

// Union by Rank
class DSU_Rank {
    vector<int> parent, rank_;
    
public:
    DSU_Rank(int n) : parent(n), rank_(n, 0) {
        iota(parent.begin(), parent.end(), 0); // parent[i] = i
    }
    
    int find(int x) {
        if (parent[x] != x)
            parent[x] = find(parent[x]); // Path compression
        return parent[x];
    }
    
    void unite(int x, int y) {
        int rx = find(x), ry = find(y);
        if (rx == ry) return;
        
        // Attach smaller rank tree under bigger rank tree
        if (rank_[rx] < rank_[ry]) {
            parent[rx] = ry;
        } else if (rank_[rx] > rank_[ry]) {
            parent[ry] = rx;
        } else {
            parent[ry] = rx;
            rank_[rx]++;
        }
    }
    
    bool connected(int x, int y) {
        return find(x) == find(y);
    }
};

// Union by Size (often more useful - gives component sizes)
class DSU_Size {
    vector<int> parent, size_;
    int components;
    
public:
    DSU_Size(int n) : parent(n), size_(n, 1), components(n) {
        iota(parent.begin(), parent.end(), 0);
    }
    
    int find(int x) {
        if (parent[x] != x)
            parent[x] = find(parent[x]);
        return parent[x];
    }
    
    bool unite(int x, int y) {
        int rx = find(x), ry = find(y);
        if (rx == ry) return false;
        
        // Attach smaller tree under bigger tree
        if (size_[rx] < size_[ry]) swap(rx, ry);
        parent[ry] = rx;
        size_[rx] += size_[ry];
        components--;
        return true;
    }
    
    bool connected(int x, int y) {
        return find(x) == find(y);
    }
    
    int getSize(int x) {
        return size_[find(x)];
    }
    
    int getComponents() {
        return components;
    }
};
```

### Dry Run - Union by Rank

```
n = 8
parent = [0,1,2,3,4,5,6,7]
rank = [0,0,0,0,0,0,0,0]

Union(0,1): rank[0]=rank[1]=0 → parent[1]=0, rank[0]=1
  parent = [0,0,2,3,4,5,6,7], rank = [1,0,0,0,0,0,0,0]

Union(2,3): rank[2]=rank[3]=0 → parent[3]=2, rank[2]=1
  parent = [0,0,2,2,4,5,6,7], rank = [1,0,1,0,0,0,0,0]

Union(4,5): parent[5]=4, rank[4]=1
Union(6,7): parent[7]=6, rank[6]=1

Union(0,2): rank[0]=rank[2]=1 → parent[2]=0, rank[0]=2
  parent = [0,0,0,2,4,4,6,6], rank = [2,0,1,0,1,0,1,0]
  
  Tree:     0
           /|\
          1  2
             |
             3

Union(4,6): rank[4]=rank[6]=1 → parent[6]=4, rank[4]=2
Union(0,4): rank[0]=rank[4]=2 → parent[4]=0, rank[0]=3

Final tree:
         0
       / | \
      1  2  4
         |  |\
         3  5 6
              |
              7

Height = 3 (instead of potentially 7 without optimization!)
```

### Complexity with Both Optimizations

| Operation | Amortized Complexity |
|-----------|---------------------|
| Find | O(α(n)) |
| Union | O(α(n)) |
| Connected | O(α(n)) |

Where α(n) is the **inverse Ackermann function**, which is effectively ≤ 4 for all practical values of n (even n = 10^(10^(10^10))).

**For all practical purposes, DSU operations are O(1) amortized.**

---

## Complete Optimized Implementation

### Production-Ready DSU Template

```cpp
#include <bits/stdc++.h>
using namespace std;

struct DSU {
    vector<int> parent, rank_, size_;
    int components;
    
    DSU(int n) : parent(n), rank_(n, 0), size_(n, 1), components(n) {
        iota(parent.begin(), parent.end(), 0);
    }
    
    int find(int x) {
        if (parent[x] != x)
            parent[x] = find(parent[x]);
        return parent[x];
    }
    
    bool unite(int x, int y) {
        x = find(x); y = find(y);
        if (x == y) return false;
        
        if (rank_[x] < rank_[y]) swap(x, y);
        parent[y] = x;
        size_[x] += size_[y];
        if (rank_[x] == rank_[y]) rank_[x]++;
        components--;
        return true;
    }
    
    bool connected(int x, int y) { return find(x) == find(y); }
    int getSize(int x) { return size_[find(x)]; }
    int getComponents() { return components; }
};
```

### Weighted DSU (with Distance/Potential)

```cpp
struct WeightedDSU {
    vector<int> parent;
    vector<long long> weight; // weight[x] = distance from x to parent[x]
    vector<int> rank_;
    
    WeightedDSU(int n) : parent(n), weight(n, 0), rank_(n, 0) {
        iota(parent.begin(), parent.end(), 0);
    }
    
    pair<int, long long> find(int x) {
        if (parent[x] == x) return {x, 0};
        auto [root, w] = find(parent[x]);
        parent[x] = root;
        weight[x] += w;
        return {root, weight[x]};
    }
    
    // Unite with relation: dist(x) - dist(y) = w
    bool unite(int x, int y, long long w) {
        auto [rx, wx] = find(x);
        auto [ry, wy] = find(y);
        if (rx == ry) {
            return (wx - wy) == w; // Check consistency
        }
        // wx + weight from rx to ry should give the right relation
        if (rank_[rx] < rank_[ry]) {
            parent[rx] = ry;
            weight[rx] = wy - wx + w;
        } else {
            parent[ry] = rx;
            weight[ry] = wx - wy - w;
            if (rank_[rx] == rank_[ry]) rank_[rx]++;
        }
        return true;
    }
    
    // Get distance from x to y (assuming same component)
    long long dist(int x, int y) {
        auto [rx, wx] = find(x);
        auto [ry, wy] = find(y);
        if (rx != ry) return LLONG_MAX; // Different components
        return wx - wy;
    }
};
```

### Rollback DSU (for offline algorithms)

```cpp
struct RollbackDSU {
    vector<int> parent, rank_;
    vector<pair<int,int>> history; // (index, old_value) for rollback
    
    RollbackDSU(int n) : parent(n), rank_(n, 0) {
        iota(parent.begin(), parent.end(), 0);
    }
    
    int find(int x) {
        while (parent[x] != x) x = parent[x]; // NO path compression!
        return x;
    }
    
    bool unite(int x, int y) {
        x = find(x); y = find(y);
        if (x == y) return false;
        
        if (rank_[x] < rank_[y]) swap(x, y);
        history.push_back({y, parent[y]});
        parent[y] = x;
        if (rank_[x] == rank_[y]) {
            history.push_back({~x, rank_[x]});
            rank_[x]++;
        }
        return true;
    }
    
    int save() { return history.size(); }
    
    void rollback(int checkpoint) {
        while (history.size() > checkpoint) {
            auto [idx, val] = history.back();
            history.pop_back();
            if (idx < 0) rank_[~idx] = val;
            else parent[idx] = val;
        }
    }
};
```

---

## Pattern Recognition

### How To Identify DSU Problems

#### Keywords:
1. "Connected" / "Same group" / "Same component"
2. "Merge" / "Union" / "Combine groups"
3. "Number of components"
4. "Online connectivity" (edges added one by one)
5. "Redundant connection" / "Extra edge"
6. "Minimum spanning tree" (Kruskal's uses DSU)
7. "Equivalence classes"
8. "Friends of friends"
9. "Accounts merge"

#### When DSU is Better Than BFS/DFS:
- Edges added **incrementally** (online)
- Need to **count components** as edges are added
- **Kruskal's MST** algorithm
- Need component **sizes**
- Multiple queries about connectivity

#### When NOT to Use DSU:
- Need shortest path
- Need to traverse in order
- Edges are removed (DSU doesn't support deletion easily)
- Directed graph problems

#### 30+ Pattern Examples:

1. "Are nodes X and Y in same network?" → DSU connected()
2. "How many disconnected networks?" → DSU components count
3. "Extra cable in network" → Cycle detection with DSU
4. "Merge friend groups" → DSU union
5. "Minimum cost to connect all cities" → Kruskal's (DSU)
6. "Number of operations to make connected" → Components - 1
7. "Accounts with same email" → DSU merge
8. "Equivalent equations" → DSU
9. "Regions on grid" → DSU on cells
10. "Size of largest group" → DSU with size tracking
11. "Earliest time when all connected" → Process edges in order + DSU
12. "Maximum stones that can be removed" → n - components
13. "Percolation simulation" → DSU
14. "Dynamic connectivity" (offline) → DSU with rollback
15. "Swim in rising water" → Binary search + DSU
16. "Critical connection" → NOT DSU (need bridges)
17. "Number of islands II" → Online DSU
18. "Satisfiability of equations" → DSU for == constraints
19. "Smallest string with swaps" → DSU components
20. "Graph connectivity with threshold" → DSU
21. "Lexicographically smallest equivalent string" → DSU
22. "Remove max stones from grid" → DSU
23. "Minimize hamming distance" → DSU components
24. "Longest consecutive sequence" → DSU
25. "Process restricted friend requests" → DSU with constraints
26. "Count components as edges added" → DSU + counter
27. "Minimum cost to repair roads" → Kruskal's variant
28. "Number of good paths" → DSU + sorting
29. "Checking existence of edge-length limited paths" → Offline DSU
30. "Minimum degree of connected subgraph" → DSU with degree tracking

---

## Problem Solving

### Easy Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Number of Provinces | LeetCode 547 | Basic DSU |
| 2 | Redundant Connection | LeetCode 684 | Cycle detection |
| 3 | Number of Connected Components | LeetCode 323 | Count components |
| 4 | Satisfiability of Equality | LeetCode 990 | DSU for equations |
| 5 | Find if Path Exists | LeetCode 1971 | Connectivity |
| 6 | Longest Consecutive Sequence | LeetCode 128 | DSU grouping |
| 7 | Friend Circles | Various | Basic DSU |
| 8 | Disjoint Set Union (Rank/Size) | GFG | Implementation |
| 9 | Connected Components | HackerRank | Components |
| 10 | Union-Find | GFG | Basic operations |
| 11 | Graph Valid Tree | LeetCode 261 | DSU cycle + connected |
| 12 | Number of Islands | LeetCode 200 | DSU on grid |
| 13 | Early Access | LeetCode 2709 | Basic DSU |
| 14 | Minimum Cost to Connect Cities | GFG | Kruskal's |
| 15 | Detect Cycle using DSU | GFG | Cycle detection |
| 16 | Regions Cut By Slashes | LeetCode 959 | Grid DSU |
| 17 | Is Graph Connected | Various | Single component |
| 18 | Similar String Groups | LeetCode 839 | Group by similarity |
| 19 | Synonymous Sentences | LeetCode 1258 | DSU + strings |
| 20 | Find the Weakest Rows | LeetCode 1337 | Related concept |

### Medium Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Accounts Merge | LeetCode 721 | DSU with data |
| 2 | Most Stones Removed | LeetCode 947 | Components counting |
| 3 | Number of Operations to Connect | LeetCode 1319 | Components - 1 |
| 4 | Smallest String With Swaps | LeetCode 1202 | DSU + sorting |
| 5 | Evaluate Division | LeetCode 399 | Weighted DSU |
| 6 | Lexicographically Smallest Equivalent | LeetCode 1061 | DSU + ordering |
| 7 | Remove Max Stones | LeetCode 947 | n - components |
| 8 | Graph Connectivity Threshold | LeetCode 1627 | DSU + number theory |
| 9 | Minimize Hamming Distance | LeetCode 1722 | DSU components |
| 10 | Process Restricted Friend Requests | LeetCode 2076 | DSU + constraints |
| 11 | Number of Good Paths | LeetCode 2421 | DSU + sorting |
| 12 | Checking Existence of Edge-Length Limited Paths | LeetCode 1697 | Offline DSU |
| 13 | Swim in Rising Water | LeetCode 778 | Binary search + DSU |
| 14 | Earliest Moment When Everyone Becomes Friends | LeetCode 1101 | DSU + time |
| 15 | Number of Islands II | LeetCode 305 | Online DSU |
| 16 | Redundant Connection II | LeetCode 685 | DSU directed (tricky) |
| 17 | Minimum Cost to Reach City | Codeforces | DSU + Kruskal's |
| 18 | Road Construction | CSES | Online DSU |
| 19 | New Roads Queries | CSES | Offline DSU |
| 20 | Equalize Strings | Codeforces | DSU equivalence |
| 21 | Connection Optimization | AtCoder | DSU + optimization |
| 22 | Maximum Network Rank | LeetCode 1615 | DSU related |
| 23 | Couples Holding Hands | LeetCode 765 | DSU cycles |
| 24 | Bricks Falling When Hit | LeetCode 803 | Reverse DSU |
| 25 | Making A Large Island | LeetCode 827 | DSU + BFS |
| 26 | Minimum Cost to Make Valid Path | LeetCode 1368 | 0-1 BFS |
| 27 | Connecting Cities With Min Cost | LeetCode 1135 | Kruskal's |
| 28 | Path With Minimum Effort | LeetCode 1631 | Binary search + DSU |
| 29 | Count Pairs of Similar Strings | LeetCode 2506 | DSU grouping |
| 30 | Min Cost to Connect All Points | LeetCode 1584 | Kruskal's |

### Hard Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Number of Good Paths | LeetCode 2421 | DSU + value sorting |
| 2 | Bricks Falling When Hit | LeetCode 803 | Reverse time DSU |
| 3 | Minimize Malware Spread II | LeetCode 928 | DSU analysis |
| 4 | Checking Edge-Length Paths | LeetCode 1697 | Offline + sort + DSU |
| 5 | Largest Component by Common Factor | LeetCode 952 | Factor-based DSU |
| 6 | Maximum Employees Invited | LeetCode 2127 | DSU + cycle |
| 7 | Gcd Sort of Array | LeetCode 1998 | DSU + factorization |
| 8 | Dynamic Connectivity | Codeforces | Rollback DSU |
| 9 | Xor on Connected Components | Codeforces | Weighted DSU |
| 10 | Spanning Tree Queries | Codeforces | Kruskal's + LCA |
| 11 | Connection Queries | CSES | Offline DSU |
| 12 | Minimum Spanning Forest Queries | AtCoder | DSU + offline |
| 13 | Cat-Dog Network | Codeforces | Bipartite DSU |
| 14 | Making Palindromes | Codeforces | DSU + greedy |
| 15 | Array Destruction | Codeforces | DSU + binary search |
| 16 | Peaks and Valleys | USACO | DSU + sorting |
| 17 | Robot Navigation | IOI | DSU variant |
| 18 | Snow Clearing | SPOJ | Weighted DSU |
| 19 | Persistent DSU | Various | Persistence |
| 20 | Centroid Decomposition + DSU | Various | Advanced hybrid |

---

## Interview Preparation

### Top 50+ Interview Questions

1. What is Union-Find? Explain the two operations.
2. How does path compression work?
3. How does union by rank work?
4. What is the time complexity with both optimizations?
5. What is the inverse Ackermann function?
6. How to detect cycle using DSU?
7. Difference between DSU and BFS/DFS for connectivity?
8. When would you choose DSU over BFS/DFS?
9. How to track component sizes?
10. How to count connected components using DSU?
11. Implement DSU from scratch (without looking).
12. Solve "Redundant Connection" problem.
13. Solve "Number of Provinces" using DSU.
14. Solve "Accounts Merge" using DSU.
15. Solve "Satisfiability of Equality Equations".
16. How does Kruskal's algorithm use DSU?
17. Can DSU handle edge deletions? How?
18. What is weighted/potential DSU?
19. What is rollback DSU? When is it needed?
20. How to use DSU on a grid?
21. What is the space complexity of DSU?
22. Can DSU work for directed graphs?
23. How to find the representative of each component?
24. How to merge DSU with other data structures?
25. What happens if we use only path compression (no rank)?
26. What happens if we use only rank (no path compression)?
27. How to handle 1-indexed vs 0-indexed in DSU?
28. Explain the proof that union by rank gives O(log n) height.
29. How many union operations until all elements in one set?
30. What is the maximum height of DSU tree with rank?
31. Implement "Number of Islands II" (online version).
32. How to find minimum edges to add to connect graph?
33. How to solve "Earliest time all friends connected"?
34. Explain "Most Stones Removed" using DSU.
35. How to use DSU for string equivalence problems?
36. What is bipartite-checking DSU?
37. How to implement DSU with small-to-large merging?
38. What are persistent DSU and its applications?
39. How to handle "undo" operations in DSU?
40. Compare DSU implementations across languages.
41. How does DSU relate to equivalence relations in math?
42. Can you implement DSU using linked lists? Trade-offs?
43. What is the weighted quick-union algorithm?
44. How to parallelize DSU operations?
45. What is link-cut tree? How does it extend DSU?
46. How to use DSU in dynamic graphs?
47. Explain offline DSU technique for query problems.
48. How to solve problems where edges are added AND removed?
49. What is the relationship between DSU and MST?
50. Design a system using DSU (social network groups, etc.).

---

## Competitive Programming

### CP Template (Copy-Paste Ready)

```cpp
struct DSU {
    vector<int> p, sz;
    int comp;
    DSU(int n) : p(n), sz(n, 1), comp(n) { iota(p.begin(), p.end(), 0); }
    int find(int x) { return p[x] == x ? x : p[x] = find(p[x]); }
    bool unite(int x, int y) {
        x = find(x); y = find(y);
        if (x == y) return false;
        if (sz[x] < sz[y]) swap(x, y);
        p[y] = x; sz[x] += sz[y]; comp--;
        return true;
    }
    bool connected(int x, int y) { return find(x) == find(y); }
    int size(int x) { return sz[find(x)]; }
};
```

### CP Tricks

1. **Kruskal's MST**: Sort edges by weight, add each if doesn't create cycle
2. **Offline queries**: Sort queries/edges, process with DSU
3. **Grid DSU**: Map (row, col) to single index: `row * cols + col`
4. **Component count**: Start at n, decrement on each successful union
5. **Virtual nodes**: Create extra nodes for abstract grouping
6. **Complement graph components**: BFS on complement + DSU

### Common Mistakes

1. ❌ Forgetting `iota` / initialization
2. ❌ Not using `find()` before accessing `size[]`
3. ❌ Off-by-one with 0-indexed vs 1-indexed
4. ❌ Using DSU for directed graph connectivity
5. ❌ Forgetting to handle self-loops
6. ❌ Not checking `if (x == y) return` in unite

---

## Cheat Sheet

### One-Page Revision

```
DSU (UNION-FIND):
• Tracks disjoint sets (groups/components)
• Two operations: Find(x) → root, Union(x,y) → merge sets
• Two optimizations:
  1. Path Compression: make nodes point directly to root
  2. Union by Rank/Size: attach smaller tree under bigger
• Combined complexity: O(α(n)) ≈ O(1) per operation
• Cannot handle edge deletions (only additions)

APPLICATIONS:
• Cycle detection in undirected graphs
• Kruskal's MST
• Online connectivity queries
• Connected component counting
• Equivalence classes

IMPLEMENTATION (5 lines of logic):
  find(x): if p[x]≠x → p[x]=find(p[x]); return p[x]
  unite(x,y): x=find(x), y=find(y)
              if x==y return false
              if sz[x]<sz[y] swap
              p[y]=x, sz[x]+=sz[y]
              return true
```

### Complexity Table

| Optimization | Find | Union | Overall |
|-------------|------|-------|---------|
| None | O(n) | O(n) | O(n) |
| Path Compression only | O(log n) amortized | O(log n) | O(m log n) |
| Union by Rank only | O(log n) | O(log n) | O(m log n) |
| Both | O(α(n)) | O(α(n)) | O(m α(n)) ≈ O(m) |

### Common Pitfalls

1. Always call `find()` to get the root, not `parent[x]` directly
2. Update `size` of the NEW root (not the old one)
3. DSU only works for undirected connectivity
4. For directed graphs, use different approaches (SCC, etc.)
5. Remember: path compression invalidates rank (rank becomes upper bound only)
