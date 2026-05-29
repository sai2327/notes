# Sparse Table & Lowest Common Ancestor (LCA)

## Table of Contents
- [Sparse Table](#sparse-table)
- [Lowest Common Ancestor (LCA)](#lowest-common-ancestor-lca)
- [LCA Methods Comparison](#lca-methods-comparison)
- [Applications](#applications)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Cheat Sheet](#cheat-sheet)

---

## Sparse Table

### Theory

A **Sparse Table** is a data structure for answering **range queries** on a static array in O(1) time after O(N log N) preprocessing.

It works for **idempotent functions** (where f(a,a) = a):
- Range Minimum Query (RMQ): min(a, a) = a ✓
- Range Maximum Query: max(a, a) = a ✓  
- Range GCD: gcd(a, a) = a ✓
- Range sum: sum(a, a) ≠ a ✗ (can still use but O(log N) query)

### Key Idea

```
Store answers for ranges of length 2^k.

table[i][j] = answer for range [i, i + 2^j - 1]

For overlap-friendly functions (min, max, gcd):
  query(L, R) = f(table[L][k], table[R - 2^k + 1][k])
  where k = floor(log2(R - L + 1))

This works because overlapping intervals still give correct answer
for idempotent operations.
```

### Building the Sparse Table

```
Base case: table[i][0] = arr[i]  (range of length 1)

Recurrence: table[i][j] = f(table[i][j-1], table[i + 2^(j-1)][j-1])
  (merge two halves of length 2^(j-1))

Visual:
  table[i][j] covers range [i, i+2^j-1]
  = merge of [i, i+2^(j-1)-1] and [i+2^(j-1), i+2^j-1]
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class SparseTable {
    vector<vector<int>> table;
    vector<int> logTable;
    int n;
    
public:
    SparseTable(vector<int>& arr) {
        n = arr.size();
        int LOG = __lg(n) + 1;
        
        table.assign(n, vector<int>(LOG));
        logTable.resize(n + 1);
        
        // Precompute logs
        logTable[1] = 0;
        for (int i = 2; i <= n; i++)
            logTable[i] = logTable[i / 2] + 1;
        
        // Base case
        for (int i = 0; i < n; i++)
            table[i][0] = arr[i];
        
        // Build table
        for (int j = 1; j < LOG; j++) {
            for (int i = 0; i + (1 << j) - 1 < n; i++) {
                table[i][j] = min(table[i][j-1], 
                                  table[i + (1 << (j-1))][j-1]);
            }
        }
    }
    
    // O(1) Range Minimum Query
    int query(int L, int R) {
        int k = logTable[R - L + 1];
        return min(table[L][k], table[R - (1 << k) + 1][k]);
    }
};

// Generic Sparse Table (for any idempotent function)
template<typename T, typename F>
class GenericSparseTable {
    vector<vector<T>> table;
    vector<int> logTable;
    F func;
    int n;
    
public:
    GenericSparseTable(vector<T>& arr, F f) : func(f) {
        n = arr.size();
        int LOG = __lg(n) + 1;
        
        table.assign(n, vector<T>(LOG));
        logTable.resize(n + 1);
        
        logTable[1] = 0;
        for (int i = 2; i <= n; i++)
            logTable[i] = logTable[i / 2] + 1;
        
        for (int i = 0; i < n; i++)
            table[i][0] = arr[i];
        
        for (int j = 1; j < LOG; j++)
            for (int i = 0; i + (1 << j) - 1 < n; i++)
                table[i][j] = func(table[i][j-1], 
                                   table[i + (1 << (j-1))][j-1]);
    }
    
    T query(int L, int R) {
        int k = logTable[R - L + 1];
        return func(table[L][k], table[R - (1 << k) + 1][k]);
    }
};

int main() {
    vector<int> arr = {1, 3, 2, 7, 9, 11, 3, 5, 6, 2};
    SparseTable st(arr);
    
    cout << "min(0, 4) = " << st.query(0, 4) << endl; // 1
    cout << "min(3, 7) = " << st.query(3, 7) << endl; // 3
    cout << "min(5, 9) = " << st.query(5, 9) << endl; // 2
    
    return 0;
}
```

### Dry Run: Building Sparse Table

```
arr = [1, 3, 2, 7, 9, 11, 3, 5, 6, 2]
       0  1  2  3  4  5   6  7  8  9

j=0 (ranges of length 1):
  table[0][0]=1, table[1][0]=3, table[2][0]=2, table[3][0]=7
  table[4][0]=9, table[5][0]=11, table[6][0]=3, table[7][0]=5
  table[8][0]=6, table[9][0]=2

j=1 (ranges of length 2):
  table[0][1] = min(table[0][0], table[1][0]) = min(1,3) = 1  [0,1]
  table[1][1] = min(table[1][0], table[2][0]) = min(3,2) = 2  [1,2]
  table[2][1] = min(table[2][0], table[3][0]) = min(2,7) = 2  [2,3]
  table[3][1] = min(table[3][0], table[4][0]) = min(7,9) = 7  [3,4]
  table[4][1] = min(table[4][0], table[5][0]) = min(9,11) = 9 [4,5]
  table[5][1] = min(table[5][0], table[6][0]) = min(11,3) = 3 [5,6]
  table[6][1] = min(table[6][0], table[7][0]) = min(3,5) = 3  [6,7]
  table[7][1] = min(table[7][0], table[8][0]) = min(5,6) = 5  [7,8]
  table[8][1] = min(table[8][0], table[9][0]) = min(6,2) = 2  [8,9]

j=2 (ranges of length 4):
  table[0][2] = min(table[0][1], table[2][1]) = min(1,2) = 1  [0,3]
  table[1][2] = min(table[1][1], table[3][1]) = min(2,7) = 2  [1,4]
  table[2][2] = min(table[2][1], table[4][1]) = min(2,9) = 2  [2,5]
  table[3][2] = min(table[3][1], table[5][1]) = min(7,3) = 3  [3,6]
  table[4][2] = min(table[4][1], table[6][1]) = min(9,3) = 3  [4,7]
  table[5][2] = min(table[5][1], table[7][1]) = min(3,5) = 3  [5,8]
  table[6][2] = min(table[6][1], table[8][1]) = min(3,2) = 2  [6,9]

Query(3, 7):  // range [3,7], length=5
  k = log2(5) = 2
  answer = min(table[3][2], table[7-4+1][2]) = min(table[3][2], table[4][2])
         = min(3, 3) = 3 ✓
  (min of [3,6] and [4,7] with overlap, both cover [3,7])
```

### Complexity

| Operation | Time | Space |
|-----------|------|-------|
| Build | O(N log N) | O(N log N) |
| Query (idempotent) | O(1) | - |
| Query (non-idempotent) | O(log N) | - |

---

## Lowest Common Ancestor (LCA)

### Theory

The **Lowest Common Ancestor** of two nodes u and v in a rooted tree is the deepest node that is an ancestor of both u and v.

### Methods

| Method | Preprocess | Query | Space |
|--------|-----------|-------|-------|
| Naive (climb up) | O(N) | O(N) | O(N) |
| Binary Lifting | O(N log N) | O(log N) | O(N log N) |
| Euler Tour + RMQ | O(N log N) | O(1) | O(N log N) |
| Farach-Colton Bender | O(N) | O(1) | O(N) |
| Heavy-Light Decomposition | O(N) | O(log N) | O(N) |

---

### Method 1: Binary Lifting

### Theory

```
Key Idea: Store 2^k-th ancestor for each node.

up[v][k] = 2^k-th ancestor of v

Base: up[v][0] = parent[v]
Recurrence: up[v][k] = up[up[v][k-1]][k-1]
  (The 2^k-th ancestor = go 2^(k-1) up twice)

To find LCA(u, v):
1. Bring u and v to same depth (using binary lifting)
2. If they're same node → that's the LCA
3. Otherwise, jump both up until just before they meet
4. LCA = parent of where they meet
```

### C++ Implementation: Binary Lifting

```cpp
#include <bits/stdc++.h>
using namespace std;

class LCA {
    int n, LOG;
    vector<vector<int>> adj;
    vector<vector<int>> up;  // up[v][k] = 2^k-th ancestor of v
    vector<int> depth;
    
    void dfs(int v, int parent, int d) {
        depth[v] = d;
        up[v][0] = parent;
        
        for (int k = 1; k < LOG; k++) {
            if (up[v][k-1] != -1)
                up[v][k] = up[up[v][k-1]][k-1];
            else
                up[v][k] = -1;
        }
        
        for (int u : adj[v]) {
            if (u != parent) {
                dfs(u, v, d + 1);
            }
        }
    }
    
public:
    LCA(int n) : n(n), adj(n), depth(n) {
        LOG = __lg(n) + 1;
        up.assign(n, vector<int>(LOG, -1));
    }
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    void build(int root = 0) {
        dfs(root, -1, 0);
    }
    
    int lca(int u, int v) {
        // Step 1: Bring to same depth
        if (depth[u] < depth[v]) swap(u, v);
        
        int diff = depth[u] - depth[v];
        for (int k = 0; k < LOG; k++) {
            if ((diff >> k) & 1) {
                u = up[u][k];
            }
        }
        
        // Step 2: If same node, return
        if (u == v) return u;
        
        // Step 3: Jump both up
        for (int k = LOG - 1; k >= 0; k--) {
            if (up[u][k] != up[v][k]) {
                u = up[u][k];
                v = up[v][k];
            }
        }
        
        return up[u][0]; // Parent is the LCA
    }
    
    int distance(int u, int v) {
        return depth[u] + depth[v] - 2 * depth[lca(u, v)];
    }
    
    // k-th ancestor of v
    int kthAncestor(int v, int k) {
        for (int i = 0; i < LOG; i++) {
            if ((k >> i) & 1) {
                v = up[v][i];
                if (v == -1) return -1;
            }
        }
        return v;
    }
    
    // Check if u is ancestor of v
    bool isAncestor(int u, int v) {
        return lca(u, v) == u;
    }
};

int main() {
    /*
    Tree:
         0
        / \
       1   2
      / \   \
     3   4   5
    / \
   6   7
    */
    
    LCA lca(8);
    lca.addEdge(0, 1); lca.addEdge(0, 2);
    lca.addEdge(1, 3); lca.addEdge(1, 4);
    lca.addEdge(2, 5); lca.addEdge(3, 6);
    lca.addEdge(3, 7);
    
    lca.build(0);
    
    cout << "LCA(6, 7) = " << lca.lca(6, 7) << endl;  // 3
    cout << "LCA(6, 4) = " << lca.lca(6, 4) << endl;  // 1
    cout << "LCA(6, 5) = " << lca.lca(6, 5) << endl;  // 0
    cout << "LCA(4, 5) = " << lca.lca(4, 5) << endl;  // 0
    cout << "LCA(3, 4) = " << lca.lca(3, 4) << endl;  // 1
    cout << "Dist(6, 5) = " << lca.distance(6, 5) << endl; // 5
    
    return 0;
}
```

### Dry Run: Binary Lifting

```
Tree:       0
           / \
          1   2
         / \   \
        3   4   5
       / \
      6   7

Building (DFS from root 0):
  depth = [0, 1, 1, 2, 2, 2, 3, 3]
  
  up table (LOG = 3 since 2^3=8 > n=8):
       up[v][0] up[v][1] up[v][2]   (parent, grandparent, 4th ancestor)
  v=0:    -1      -1       -1
  v=1:     0      -1       -1
  v=2:     0      -1       -1
  v=3:     1       0       -1
  v=4:     1       0       -1
  v=5:     2       0       -1
  v=6:     3       1        0
  v=7:     3       1        0

Query: LCA(6, 4)
  depth[6]=3, depth[4]=2 → u=6, v=4
  
  Step 1: Bring to same depth
    diff = 3 - 2 = 1 = binary 01
    k=0: bit set → u = up[6][0] = 3
    Now depth[u]=depth[3]=2 = depth[v]=2 ✓

  Step 2: u=3, v=4. Are they same? NO

  Step 3: Jump both up
    k=2: up[3][2]=-1, up[4][2]=-1. Same(-1)? YES → skip
    k=1: up[3][1]=0, up[4][1]=0. Same? YES → skip
    k=0: up[3][0]=1, up[4][0]=1. Same? YES → skip

  Return up[3][0] = 1

LCA(6, 4) = 1 ✓ (vertex 1 is parent of both subtrees)
```

---

### Method 2: Euler Tour + RMQ (Sparse Table)

### Theory

```
1. Perform Euler Tour of tree (record vertex at each DFS step)
2. Record first occurrence of each vertex in the tour
3. LCA(u,v) = vertex with minimum depth in tour between 
   first[u] and first[v]
4. Use Sparse Table for O(1) RMQ

Why this works: Between first occurrence of u and first occurrence 
of v in the Euler tour, the LCA must appear (and it has minimum depth).
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class LCA_RMQ {
    int n;
    vector<vector<int>> adj;
    vector<int> euler, depth, first;
    vector<vector<int>> sparse; // Sparse table on euler tour (stores index)
    vector<int> logTable;
    int eulerSize;
    
    void dfs(int v, int parent, int d) {
        first[v] = euler.size();
        euler.push_back(v);
        depth[v] = d;
        
        for (int u : adj[v]) {
            if (u != parent) {
                dfs(u, v, d + 1);
                euler.push_back(v); // Return to v after visiting subtree
            }
        }
    }
    
    void buildSparse() {
        eulerSize = euler.size();
        int LOG = __lg(eulerSize) + 1;
        sparse.assign(eulerSize, vector<int>(LOG));
        logTable.resize(eulerSize + 1);
        
        logTable[1] = 0;
        for (int i = 2; i <= eulerSize; i++)
            logTable[i] = logTable[i/2] + 1;
        
        // Base case: each position stores itself
        for (int i = 0; i < eulerSize; i++)
            sparse[i][0] = i;
        
        // Build: compare depths
        for (int j = 1; j < LOG; j++) {
            for (int i = 0; i + (1 << j) - 1 < eulerSize; i++) {
                int left = sparse[i][j-1];
                int right = sparse[i + (1 << (j-1))][j-1];
                sparse[i][j] = (depth[euler[left]] <= depth[euler[right]]) 
                               ? left : right;
            }
        }
    }
    
public:
    LCA_RMQ(int n) : n(n), adj(n), depth(n), first(n) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    void build(int root = 0) {
        dfs(root, -1, 0);
        buildSparse();
    }
    
    int lca(int u, int v) {
        int L = first[u], R = first[v];
        if (L > R) swap(L, R);
        
        int k = logTable[R - L + 1];
        int left = sparse[L][k];
        int right = sparse[R - (1 << k) + 1][k];
        
        return (depth[euler[left]] <= depth[euler[right]]) 
               ? euler[left] : euler[right];
    }
    
    int dist(int u, int v) {
        return depth[u] + depth[v] - 2 * depth[lca(u, v)];
    }
};

int main() {
    LCA_RMQ lca(8);
    lca.addEdge(0, 1); lca.addEdge(0, 2);
    lca.addEdge(1, 3); lca.addEdge(1, 4);
    lca.addEdge(2, 5); lca.addEdge(3, 6);
    lca.addEdge(3, 7);
    
    lca.build(0);
    
    cout << "LCA(6, 7) = " << lca.lca(6, 7) << endl;  // 3
    cout << "LCA(6, 4) = " << lca.lca(6, 4) << endl;  // 1
    cout << "LCA(6, 5) = " << lca.lca(6, 5) << endl;  // 0
    cout << "Dist(6, 5) = " << lca.dist(6, 5) << endl; // 5
    
    return 0;
}
```

### Dry Run: Euler Tour

```
Tree:       0
           / \
          1   2
         / \   \
        3   4   5
       / \
      6   7

DFS from 0:
  Visit 0: euler=[0], first[0]=0, depth[0]=0
    Visit 1: euler=[0,1], first[1]=1, depth[1]=1
      Visit 3: euler=[0,1,3], first[3]=2, depth[3]=2
        Visit 6: euler=[0,1,3,6], first[6]=3, depth[6]=3
        Return to 3: euler=[0,1,3,6,3]
        Visit 7: euler=[0,1,3,6,3,7], first[7]=5, depth[7]=3
        Return to 3: euler=[0,1,3,6,3,7,3]
      Return to 1: euler=[0,1,3,6,3,7,3,1]
      Visit 4: euler=[0,1,3,6,3,7,3,1,4], first[4]=8, depth[4]=2
      Return to 1: euler=[0,1,3,6,3,7,3,1,4,1]
    Return to 0: euler=[0,1,3,6,3,7,3,1,4,1,0]
    Visit 2: euler=[0,1,3,6,3,7,3,1,4,1,0,2], first[2]=11, depth[2]=1
      Visit 5: euler=[...,2,5], first[5]=12, depth[5]=2
      Return to 2: euler=[...,2,5,2]
    Return to 0: euler=[...,2,5,2,0]

euler = [0, 1, 3, 6, 3, 7, 3, 1, 4, 1, 0, 2, 5, 2, 0]
depth = [0, 1, 2, 3, 2, 3, 2, 1, 2, 1, 0, 1, 2, 1, 0] (of euler entries)

Query LCA(6, 4):
  first[6]=3, first[4]=8
  Range [3, 8] in euler: [6, 3, 7, 3, 1, 4]
  Depths:                 [3, 2, 3, 2, 1, 2]
  Minimum depth = 1 at position 7 (euler[7] = 1)
  
LCA(6, 4) = 1 ✓
```

---

## LCA Methods Comparison

| Method | Preprocess | Query | Space | Ease |
|--------|-----------|-------|-------|------|
| Binary Lifting | O(N log N) | O(log N) | O(N log N) | Easy |
| Euler Tour + Sparse Table | O(N log N) | O(1) | O(N log N) | Medium |
| Euler Tour + Segment Tree | O(N) | O(log N) | O(N) | Medium |
| Farach-Colton Bender | O(N) | O(1) | O(N) | Hard |

### When to Use Which

```
Binary Lifting:
  ✓ Need k-th ancestor queries
  ✓ Need path queries (sum/max on path)
  ✓ Simple to implement
  
Euler Tour + RMQ:
  ✓ Need O(1) LCA queries
  ✓ Many LCA queries
  ✓ Online queries

Both work well for:
  • Distance queries: dist(u,v) = depth[u] + depth[v] - 2*depth[LCA]
  • Path queries: combine with prefix sums or HLD
```

---

## Applications

### 1. Distance Between Nodes

```cpp
int distance(int u, int v) {
    return depth[u] + depth[v] - 2 * depth[lca(u, v)];
}
```

### 2. Path Sum/Max Query

```cpp
// Using binary lifting with edge weights stored
// weight_up[v][k] = max edge weight from v to its 2^k-th ancestor
int maxOnPath(int u, int v) {
    int l = lca(u, v);
    return max(maxToAncestor(u, l), maxToAncestor(v, l));
}
```

### 3. Subtree Queries (Euler Tour)

```cpp
// Using entry/exit times from Euler tour
// Subtree of v = range [tin[v], tout[v]] in flattened array
// Use segment tree / BIT on this range
```

### 4. Weighted LCA (Kruskal's Reconstruction Tree)

For minimax path queries: the maximum edge on the minimum-bottleneck path between u and v equals the weight at their LCA in Kruskal's reconstruction tree.

---

## Pattern Recognition

### 30+ LCA/Sparse Table Patterns

| # | Pattern | Approach |
|---|---------|----------|
| 1 | Distance between tree nodes | LCA + depth |
| 2 | Path queries (sum/max) | LCA + prefix sums |
| 3 | Static RMQ | Sparse Table |
| 4 | K-th ancestor | Binary lifting |
| 5 | Is u ancestor of v? | tin[u] ≤ tin[v] ≤ tout[u] |
| 6 | Subtree queries | Euler tour + BIT/Segtree |
| 7 | Tree path update | LCA + difference array |
| 8 | Minimum bottleneck path | Kruskal tree + LCA |
| 9 | Tree isomorphism | Hashing with LCA |
| 10 | Virtual tree | Key nodes + LCA |
| 11 | Counting paths through edge | LCA + subtree sizes |
| 12 | Meeting point on tree | LCA + distance |
| 13 | Tree DP with queries | Euler tour + Segtree |
| 14 | Heavy path decomposition | LCA backbone |
| 15 | Centroid queries | LCA in centroid tree |
| 16 | Static range GCD | Sparse Table |
| 17 | Range OR/AND | Sparse Table |
| 18 | Sparse table on suffix array | LCP queries |
| 19 | LCA in DAG | Multiple parents |
| 20 | Offline LCA (Tarjan's) | DSU-based |

---

## Problem Solving

### Practice Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Company Queries I | CSES | K-th ancestor |
| 2 | Company Queries II | CSES | LCA |
| 3 | Distance Queries | CSES | LCA + depth |
| 4 | Counting Paths | CSES | LCA + diff array |
| 5 | Planets Queries I | CSES | Binary lifting (functional) |
| 6 | Planets Queries II | CSES | Functional graph + LCA |
| 7 | LCA of Binary Tree | LeetCode 236 | Basic LCA |
| 8 | LCA with Parent Pointers | LeetCode 1650 | Two pointer |
| 9 | Kth Ancestor of Tree Node | LeetCode 1483 | Binary lifting |
| 10 | Path Sum Queries | Various | LCA + prefix |
| 11 | Maximum Edge in Path | Various | Binary lifting with max |
| 12 | Static Range Minimum | Various | Sparse Table |
| 13 | RMQSQ | SPOJ | Sparse Table |
| 14 | LCA | SPOJ | Binary Lifting |
| 15 | Farthest Node Queries | Various | LCA + diameter endpoints |
| 16 | Subordinates | CSES | Euler tour + subtree |
| 17 | Path Queries | CSES | Euler tour + BIT |
| 18 | Path Queries II | CSES | HLD + Segtree |
| 19 | Tree Maximum | Various | Binary lifting |
| 20 | Network Repair | Various | LCA applications |

---

## Interview Preparation

### Top Questions

1. What is LCA? Why is it useful?
2. Explain binary lifting for LCA.
3. Time and space complexity of binary lifting?
4. How does Euler tour help with LCA?
5. What is a Sparse Table? When to use?
6. Can Sparse Table handle updates? (No, static only)
7. RMQ alternatives: Segment tree vs Sparse Table?
8. How to find distance between two nodes in a tree?
9. How to check if u is ancestor of v in O(1)?
10. What is the k-th ancestor problem?
11. How to find path sum between two tree nodes?
12. What is Heavy-Light Decomposition?
13. How to handle LCA queries offline? (Tarjan's offline LCA)
14. What is a functional graph? How does binary lifting apply?
15. How would you implement LCA for a forest (multiple trees)?

---

## Competitive Programming

### Binary Lifting Template

```cpp
#include <bits/stdc++.h>
using namespace std;

const int MAXN = 200005;
const int LOG = 18;

int up[MAXN][LOG];
int depth[MAXN];
vector<int> adj[MAXN];

void dfs(int v, int p, int d) {
    up[v][0] = p;
    depth[v] = d;
    for (int k = 1; k < LOG; k++)
        up[v][k] = (up[v][k-1] == -1) ? -1 : up[up[v][k-1]][k-1];
    for (int u : adj[v])
        if (u != p) dfs(u, v, d + 1);
}

int lca(int u, int v) {
    if (depth[u] < depth[v]) swap(u, v);
    int diff = depth[u] - depth[v];
    for (int k = 0; k < LOG; k++)
        if ((diff >> k) & 1) u = up[u][k];
    if (u == v) return u;
    for (int k = LOG - 1; k >= 0; k--)
        if (up[u][k] != up[v][k]) { u = up[u][k]; v = up[v][k]; }
    return up[u][0];
}

int dist(int u, int v) {
    return depth[u] + depth[v] - 2 * depth[lca(u, v)];
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    
    int n, q;
    cin >> n >> q;
    
    for (int i = 1; i < n; i++) {
        int p; cin >> p; p--;
        adj[p].push_back(i);
        adj[i].push_back(p);
    }
    
    memset(up, -1, sizeof(up));
    dfs(0, -1, 0);
    
    while (q--) {
        int u, v; cin >> u >> v; u--; v--;
        cout << lca(u, v) + 1 << "\n";
    }
    
    return 0;
}
```

### Sparse Table Template

```cpp
#include <bits/stdc++.h>
using namespace std;

int sparse[200005][18];
int lg[200005];

void buildSparse(vector<int>& a) {
    int n = a.size();
    lg[1] = 0;
    for (int i = 2; i <= n; i++) lg[i] = lg[i/2] + 1;
    
    for (int i = 0; i < n; i++) sparse[i][0] = a[i];
    for (int j = 1; (1 << j) <= n; j++)
        for (int i = 0; i + (1 << j) - 1 < n; i++)
            sparse[i][j] = min(sparse[i][j-1], sparse[i + (1 << (j-1))][j-1]);
}

int query(int l, int r) {
    int k = lg[r - l + 1];
    return min(sparse[l][k], sparse[r - (1 << k) + 1][k]);
}
```

---

## Cheat Sheet

```
SPARSE TABLE:
• Static array, O(N log N) build, O(1) query (idempotent ops)
• table[i][j] = f(range [i, i+2^j-1])
• query(L,R): k=log2(R-L+1), f(table[L][k], table[R-2^k+1][k])
• Works for: min, max, gcd, OR, AND
• Does NOT support updates (use segment tree instead)

LCA - BINARY LIFTING:
• up[v][k] = 2^k-th ancestor
• Build: O(N log N), Query: O(log N)
• Steps: equalize depth → jump both up → return parent

LCA - EULER TOUR + RMQ:
• Flatten tree with Euler tour
• LCA = minimum depth in range [first[u], first[v]]
• Build: O(N log N), Query: O(1) with sparse table

KEY FORMULAS:
• dist(u,v) = depth[u] + depth[v] - 2*depth[LCA(u,v)]
• path sum = prefix[u] + prefix[v] - 2*prefix[LCA]
• isAncestor(u,v): tin[u] ≤ tin[v] ≤ tout[u]

USE CASES:
• Tree distance queries → LCA
• K-th ancestor → Binary lifting
• Static RMQ → Sparse table
• Subtree queries → Euler tour + range DS
• Path queries → LCA + binary lifting or HLD
```
