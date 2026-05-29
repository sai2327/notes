# Minimum Spanning Trees (MST)

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Core Theory](#core-theory)
- [Kruskal's Algorithm](#kruskals-algorithm)
- [Prim's Algorithm](#prims-algorithm)
- [Comparison](#comparison-kruskals-vs-prims)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Cheat Sheet](#cheat-sheet)

---

## Introduction

### What is a Minimum Spanning Tree?

A **Spanning Tree** of a connected, undirected graph is a subgraph that:
1. Includes ALL vertices
2. Is a tree (connected, acyclic)
3. Has exactly V-1 edges

A **Minimum Spanning Tree (MST)** is a spanning tree with the minimum total edge weight.

### Why MST Matters

| Application | Interpretation |
|-------------|---------------|
| Network cable routing | Minimum cable to connect all buildings |
| Circuit design | Minimum wiring to connect components |
| Road planning | Minimum cost road network |
| Cluster analysis | Hierarchical clustering |
| Image segmentation | Minimum boundary to separate regions |
| Approximation algorithms | TSP approximation uses MST |

---

## Prerequisites

- [01_Introduction](../01_Introduction/README.md) - Weighted graphs
- [02_Traversals](../02_Traversals/README.md) - BFS/DFS
- [05_Disjoint_Set](../05_Disjoint_Set/README.md) - DSU (essential for Kruskal's)
- Priority queue concept (for Prim's)

---

## Core Theory

### Key Properties of MST

1. **Cut Property**: For any cut of the graph, the minimum weight edge crossing the cut is in the MST.
2. **Cycle Property**: For any cycle, the maximum weight edge is NOT in the MST.
3. **Uniqueness**: If all edge weights are distinct, the MST is unique.
4. **Number of edges**: MST always has exactly V-1 edges.

### MST Existence

MST exists if and only if the graph is **connected**. For disconnected graphs, we get a **Minimum Spanning Forest** (MST for each component).

### Visual Example

```
Graph:                          MST (total weight = 16):
    1 ---4--- 2                     1 ---4--- 2
   /|         |\                    |         |
  8  |    7   | 2                    |    7   | 2
 /   11  / \  |  \                   11  /    |
0     | /   \ |   3                   | /     3
 \   |/  6  \|  /                    |/     
  7  8---2---6 /                     8---2---6
   \ |       |/                            |
    4---9---5                        4     5
        |                                 
       14                                 

MST edges: (0,1,4), (1,2,8)... wait let me use simpler example.

Simple Example:
Graph:                      MST (weight = 7):
    A --1-- B                   A --1-- B
    |     / |                   |       |
    4   3   2                   4       2
    | /     |                   |       |
    C --5-- D                   C       D

Edges: (A,B,1), (A,C,4), (B,C,3), (B,D,2), (C,D,5)
MST: (A,B,1) + (B,D,2) + (A,C,4) = 7
  or (A,B,1) + (B,D,2) + (B,C,3) = 6 ← Actually this is less!
  
Let me verify: 
  Sort: (A,B,1), (B,D,2), (B,C,3), (A,C,4), (C,D,5)
  Take (A,B,1): connects A-B ✓
  Take (B,D,2): connects D ✓
  Take (B,C,3): connects C ✓
  Done! All 4 vertices connected with 3 edges.
  MST weight = 1 + 2 + 3 = 6
```

---

## Kruskal's Algorithm

### Theory

Kruskal's algorithm builds MST by greedily selecting the smallest weight edge that doesn't create a cycle.

### Intuition

```
1. Sort ALL edges by weight (ascending)
2. For each edge (in order):
   - If adding this edge doesn't create a cycle → add it to MST
   - Otherwise → skip it
3. Stop when MST has V-1 edges

Why greedy works: Cut property guarantees that the lightest edge
crossing any cut must be in the MST. By processing lightest edges
first, we're always making the optimal local choice.
```

### Algorithm

```
Kruskal(graph):
    1. Sort all edges by weight
    2. Initialize DSU with V vertices
    3. mst_weight = 0, mst_edges = []
    4. For each edge (u, v, w) in sorted order:
        if find(u) != find(v):       // Not in same component
            union(u, v)               // Merge components
            mst_edges.add(edge)
            mst_weight += w
            if |mst_edges| == V-1:
                break                 // MST complete
    5. Return mst_weight, mst_edges
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Edge {
    int u, v, weight;
    bool operator<(const Edge& other) const {
        return weight < other.weight;
    }
};

struct DSU {
    vector<int> parent, rank_;
    DSU(int n) : parent(n), rank_(n, 0) {
        iota(parent.begin(), parent.end(), 0);
    }
    int find(int x) {
        return parent[x] == x ? x : parent[x] = find(parent[x]);
    }
    bool unite(int x, int y) {
        x = find(x); y = find(y);
        if (x == y) return false;
        if (rank_[x] < rank_[y]) swap(x, y);
        parent[y] = x;
        if (rank_[x] == rank_[y]) rank_[x]++;
        return true;
    }
};

pair<long long, vector<Edge>> kruskal(int n, vector<Edge>& edges) {
    sort(edges.begin(), edges.end());
    
    DSU dsu(n);
    long long mstWeight = 0;
    vector<Edge> mstEdges;
    
    for (auto& e : edges) {
        if (dsu.unite(e.u, e.v)) {
            mstWeight += e.weight;
            mstEdges.push_back(e);
            if (mstEdges.size() == n - 1) break;
        }
    }
    
    // Check if MST exists (graph is connected)
    if (mstEdges.size() != n - 1) {
        return {-1, {}}; // Graph not connected
    }
    
    return {mstWeight, mstEdges};
}

int main() {
    int n = 4; // vertices: 0, 1, 2, 3
    vector<Edge> edges = {
        {0, 1, 1}, {1, 3, 2}, {1, 2, 3}, {0, 2, 4}, {2, 3, 5}
    };
    
    auto [weight, mst] = kruskal(n, edges);
    
    cout << "MST Weight: " << weight << endl;
    cout << "MST Edges:" << endl;
    for (auto& e : mst) {
        cout << "  " << e.u << " -- " << e.v << " (w=" << e.weight << ")" << endl;
    }
    
    return 0;
}
```

### Dry Run

```
Vertices: 0, 1, 2, 3
Edges: (0,1,1), (1,3,2), (1,2,3), (0,2,4), (2,3,5)

Step 1: Sort edges by weight:
  (0,1,1), (1,3,2), (1,2,3), (0,2,4), (2,3,5)

Step 2: Initialize DSU: parent = [0,1,2,3]

Step 3: Process edges:

Edge (0,1,1): find(0)=0, find(1)=1 → Different! Unite.
  MST edges: [(0,1,1)], weight = 1
  Components: {0,1}, {2}, {3}

Edge (1,3,2): find(1)=0, find(3)=3 → Different! Unite.
  MST edges: [(0,1,1), (1,3,2)], weight = 3
  Components: {0,1,3}, {2}

Edge (1,2,3): find(1)=0, find(2)=2 → Different! Unite.
  MST edges: [(0,1,1), (1,3,2), (1,2,3)], weight = 6
  Components: {0,1,2,3}

We have V-1 = 3 edges → MST complete!

Edge (0,2,4): find(0)=0, find(2)=0 → Same! Skip (would create cycle).
Edge (2,3,5): Skip (already have MST).

Final MST: weight = 6, edges = {(0,1,1), (1,3,2), (1,2,3)}
```

### Complexity

| Aspect | Value |
|--------|-------|
| Time | O(E log E) for sorting + O(E α(V)) for DSU = **O(E log E)** |
| Space | O(V + E) |
| Note | O(E log E) = O(E log V) since E ≤ V² |

---

## Prim's Algorithm

### Theory

Prim's algorithm builds MST by growing a single tree, always adding the cheapest edge that connects a new vertex to the existing tree.

### Intuition

```
1. Start from any vertex (seed)
2. Maintain a "frontier" of edges connecting tree to non-tree vertices
3. Always pick the minimum weight edge from frontier
4. Add the new vertex and its edges to the frontier
5. Repeat until all vertices are in the tree

This is like growing a crystal: always attach the nearest atom.
```

### Algorithm

```
Prim(graph, source):
    1. Create min-heap/priority queue
    2. Add source to tree, add its edges to heap
    3. While heap not empty AND tree has < V vertices:
        a. Pop minimum edge (u, v, w) from heap
        b. If v is already in tree → skip
        c. Add v to tree, mst_weight += w
        d. Add all edges from v to non-tree vertices to heap
    4. Return mst_weight
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

// Prim's using Priority Queue (adjacency list)
long long primMST(int n, vector<vector<pair<int,int>>>& adj) {
    vector<bool> inMST(n, false);
    // {weight, vertex}
    priority_queue<pair<int,int>, vector<pair<int,int>>, greater<>> pq;
    
    long long mstWeight = 0;
    int edgesAdded = 0;
    
    // Start from vertex 0
    pq.push({0, 0});
    
    while (!pq.empty() && edgesAdded < n) {
        auto [w, u] = pq.top();
        pq.pop();
        
        if (inMST[u]) continue; // Already in MST
        
        inMST[u] = true;
        mstWeight += w;
        edgesAdded++;
        
        // Add all edges from u to non-MST vertices
        for (auto [v, weight] : adj[u]) {
            if (!inMST[v]) {
                pq.push({weight, v});
            }
        }
    }
    
    if (edgesAdded != n) return -1; // Graph not connected
    return mstWeight;
}

// Prim's with edge tracking
pair<long long, vector<pair<int,int>>> primMSTWithEdges(
    int n, vector<vector<pair<int,int>>>& adj) {
    
    vector<bool> inMST(n, false);
    // {weight, vertex, from}
    priority_queue<tuple<int,int,int>, vector<tuple<int,int,int>>, greater<>> pq;
    
    long long mstWeight = 0;
    vector<pair<int,int>> mstEdges;
    
    pq.push({0, 0, -1});
    
    while (!pq.empty()) {
        auto [w, u, from] = pq.top();
        pq.pop();
        
        if (inMST[u]) continue;
        inMST[u] = true;
        mstWeight += w;
        
        if (from != -1) {
            mstEdges.push_back({from, u});
        }
        
        for (auto [v, weight] : adj[u]) {
            if (!inMST[v]) {
                pq.push({weight, v, u});
            }
        }
    }
    
    return {mstWeight, mstEdges};
}

// Prim's O(V²) version (better for dense graphs)
long long primDense(int n, vector<vector<int>>& adjMatrix) {
    vector<int> minEdge(n, INT_MAX);
    vector<bool> inMST(n, false);
    long long mstWeight = 0;
    
    minEdge[0] = 0;
    
    for (int i = 0; i < n; i++) {
        // Find vertex with minimum edge weight not in MST
        int u = -1;
        for (int v = 0; v < n; v++) {
            if (!inMST[v] && (u == -1 || minEdge[v] < minEdge[u])) {
                u = v;
            }
        }
        
        inMST[u] = true;
        mstWeight += minEdge[u];
        
        // Update minimum edges for neighbors
        for (int v = 0; v < n; v++) {
            if (!inMST[v] && adjMatrix[u][v] < minEdge[v]) {
                minEdge[v] = adjMatrix[u][v];
            }
        }
    }
    
    return mstWeight;
}

int main() {
    int n = 4;
    vector<vector<pair<int,int>>> adj(n);
    
    // Add edges: {neighbor, weight}
    adj[0].push_back({1, 1}); adj[1].push_back({0, 1});
    adj[1].push_back({3, 2}); adj[3].push_back({1, 2});
    adj[1].push_back({2, 3}); adj[2].push_back({1, 3});
    adj[0].push_back({2, 4}); adj[2].push_back({0, 4});
    adj[2].push_back({3, 5}); adj[3].push_back({2, 5});
    
    long long weight = primMST(n, adj);
    cout << "MST Weight (Prim's): " << weight << endl; // 6
    
    return 0;
}
```

### Dry Run

```
Graph: adj list representation
0: [(1,1), (2,4)]
1: [(0,1), (3,2), (2,3)]
2: [(1,3), (0,4), (3,5)]
3: [(1,2), (2,5)]

Prim's from vertex 0:

Initial: inMST = [F,F,F,F], pq = [(0,0)]

Step 1: Pop (0,0) → add vertex 0 to MST
  inMST = [T,F,F,F], mstWeight = 0
  Add edges from 0: push (1,1), (4,2)
  pq = [(1,1), (4,2)]

Step 2: Pop (1,1) → add vertex 1 to MST
  inMST = [T,T,F,F], mstWeight = 1
  Add edges from 1: push (2,3), (3,2)
  (edge to 0 skipped - already in MST)
  pq = [(2,3), (3,2), (4,2)]

Step 3: Pop (2,3) → add vertex 3 to MST
  inMST = [T,T,F,T], mstWeight = 3
  Add edges from 3: push (5,2)
  pq = [(3,2), (4,2), (5,2)]

Step 4: Pop (3,2) → add vertex 2 to MST
  inMST = [T,T,T,T], mstWeight = 6
  All vertices in MST!

MST Weight = 6 ✓
```

### Complexity

| Version | Time | Best for |
|---------|------|----------|
| Priority Queue | O(E log V) | Sparse graphs |
| Dense (O(V²)) | O(V²) | Dense graphs (E ≈ V²) |
| Fibonacci Heap | O(E + V log V) | Theoretical best |

---

## Comparison: Kruskal's vs Prim's

| Feature | Kruskal's | Prim's |
|---------|-----------|--------|
| Approach | Edge-centric (sort all edges) | Vertex-centric (grow tree) |
| Data Structure | DSU | Priority Queue |
| Time Complexity | O(E log E) | O(E log V) or O(V²) |
| Better for | Sparse graphs | Dense graphs |
| Edge list input | ✅ Natural | Need adjacency list |
| Adjacency list input | Need edge list | ✅ Natural |
| Parallel-friendly | ❌ (sequential by weight) | ❌ |
| Can find MSF (forest) | ✅ Naturally | Need to handle disconnected |
| Simplicity | Very simple | Slightly more complex |

### Decision Guide

```
Use Kruskal's when:
• Graph is sparse (E << V²)
• Edges given as edge list
• Need MST edges explicitly
• Already have DSU implemented

Use Prim's when:
• Graph is dense (E ≈ V²)
• Graph given as adjacency list/matrix
• Starting from specific vertex
• Only need MST weight
```

---

## Pattern Recognition

### How To Identify MST Problems

1. "Minimum cost to connect all nodes/cities"
2. "Minimum total wire/cable length"
3. "Cheapest network"
4. "Minimum cost spanning tree"
5. "Connect all with minimum edges"
6. "Maximum/minimum bottleneck path" (related to MST)
7. "Second minimum spanning tree"
8. "Minimum cost to add edges to make connected"

### 30+ Patterns

9. "Lay minimum cable" → MST
10. "Build roads with min cost" → MST
11. "Minimum cost to repair all roads" → MST variant
12. "Maximum edge in minimum path" → MST property (minimax path)
13. "Second best MST" → Replace one edge
14. "MST with constraint" → Modified Kruskal's
15. "Water supply to all houses" → MST with virtual node
16. "Minimum cost to connect computers" → MST
17. "Cluster into K groups with max separation" → Stop Kruskal's at V-K edges
18. "Critical edges in MST" → Bridge/cut edge
19. "Pseudo-critical edges" → Try without/force include
20. "Maximum spanning tree" → Sort descending
21. "Minimum cost to make graph connected" → MST of missing edges
22. "Steiner tree" → NP-hard, MST approximation
23. "Minimum bottleneck spanning tree" → Same as MST!
24. "Optimize network latency" → MST variant
25. "Find minimum weight cycle" → MST + one non-MST edge
26. "K-th minimum spanning tree" → Advanced
27. "Online MST" → Incremental MST
28. "Directed MST" → Edmonds/Chu-Liu algorithm
29. "Degree-constrained MST" → NP-hard
30. "Euclidean MST" → Delaunay triangulation + MST

---

## Problem Solving

### Easy Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Min Cost to Connect All Points | LeetCode 1584 | Kruskal's/Prim's |
| 2 | Connecting Cities With Minimum Cost | LeetCode 1135 | MST |
| 3 | Minimum Spanning Tree | GFG | Basic MST |
| 4 | Road Reparation | CSES | MST |
| 5 | Roads and Libraries | HackerRank | MST concept |
| 6 | Building Roads | CSES | MST / components |
| 7 | Minimum Cost to Hire K Workers | Related | Sorting + greedy |
| 8 | Optimize Water Distribution | LeetCode 1168 | Virtual node MST |
| 9 | MST Weight | Various | Implementation |
| 10 | Cheapest Network | GFG | Kruskal's |

### Medium Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Min Cost to Connect Points | LeetCode 1584 | Complete graph MST |
| 2 | Find Critical/Pseudo-Critical Edges | LeetCode 1489 | MST edge analysis |
| 3 | Optimize Water Distribution | LeetCode 1168 | Virtual source MST |
| 4 | Minimum Cost to Reach City | Various | Modified MST |
| 5 | Network Connection Minimum Cost | GFG | Kruskal's |
| 6 | Minimum Spanning Forest | Various | MST for disconnected |
| 7 | Second Minimum Spanning Tree | SPOJ | MST + replacement |
| 8 | Maximum Spanning Tree | Various | Sort descending |
| 9 | Path With Minimum Effort | LeetCode 1631 | Minimax path (MST) |
| 10 | Swim in Rising Water | LeetCode 778 | Minimax (MST-like) |
| 11 | K-Group Clustering | Various | Kruskal stop early |
| 12 | Minimum Cost to Make Valid Path | LeetCode 1368 | 0-1 BFS / MST-like |
| 13 | Remove Max Number of Edges | LeetCode 1579 | MST / DSU |
| 14 | Checking Existence of Edge Length Paths | LeetCode 1697 | MST + queries |
| 15 | Minimum Cost of Edge Removal | Codeforces | MST property |

### Hard Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Find Critical Edges in MST | LeetCode 1489 | Edge criticality |
| 2 | Second Minimum Spanning Tree | SPOJ | Edge replacement |
| 3 | K-th Smallest MST | Various | Advanced |
| 4 | Minimum Spanning Arborescence | Various | Directed MST |
| 5 | Steiner Tree | Various | NP-hard approx |
| 6 | Online MST Maintenance | Codeforces | Dynamic MST |
| 7 | MST + LCA Queries | Codeforces | Kruskal rebuild tree |
| 8 | Minimum Spanning Subgraph | Various | MST variant |
| 9 | Minimax Path Queries | Various | MST + LCA |
| 10 | Borůvka's MST | Various | Parallel MST |

---

## Interview Preparation

### Top 50 Interview Questions

1. What is a spanning tree? MST?
2. Explain Kruskal's algorithm with example.
3. Explain Prim's algorithm with example.
4. Prove that Kruskal's gives optimal MST (cut property).
5. When would you use Kruskal's vs Prim's?
6. What is the time complexity of each?
7. Can MST have negative edge weights? (Yes!)
8. Is MST always unique? When is it unique?
9. How many edges does MST have?
10. What if graph is disconnected?
11. How does DSU help in Kruskal's?
12. What is the cut property? Prove it.
13. What is the cycle property?
14. Implement Kruskal's from scratch.
15. Implement Prim's from scratch.
16. What is the second-best MST? How to find it?
17. What are critical edges in MST?
18. What is Borůvka's algorithm?
19. How to find maximum spanning tree?
20. How to handle equal weight edges in MST?
21. What is the relationship between MST and shortest paths?
22. Can MST edge be the shortest path edge? (Yes, sometimes)
23. What is minimax path? Relation to MST?
24. How to cluster data points using MST?
25. What is Euclidean MST?
26. Solve "Min Cost to Connect All Points".
27. Solve "Optimize Water Distribution" (virtual node trick).
28. Find critical and pseudo-critical edges in MST.
29. How to handle directed graphs? (Edmonds' algorithm)
30. What is matroid theory connection to MST?
31-50: [Various coding and system design questions about MST applications]

---

## Competitive Programming

### Kruskal's Template

```cpp
#include <bits/stdc++.h>
using namespace std;

struct DSU {
    vector<int> p, sz;
    DSU(int n) : p(n), sz(n, 1) { iota(p.begin(), p.end(), 0); }
    int find(int x) { return p[x] == x ? x : p[x] = find(p[x]); }
    bool unite(int x, int y) {
        x = find(x); y = find(y);
        if (x == y) return false;
        if (sz[x] < sz[y]) swap(x, y);
        p[y] = x; sz[x] += sz[y];
        return true;
    }
};

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    
    int n, m;
    cin >> n >> m;
    
    vector<array<int,3>> edges(m); // {weight, u, v}
    for (int i = 0; i < m; i++) {
        cin >> edges[i][1] >> edges[i][2] >> edges[i][0];
    }
    sort(edges.begin(), edges.end());
    
    DSU dsu(n + 1);
    long long ans = 0;
    int cnt = 0;
    
    for (auto& [w, u, v] : edges) {
        if (dsu.unite(u, v)) {
            ans += w;
            if (++cnt == n - 1) break;
        }
    }
    
    if (cnt != n - 1) cout << "IMPOSSIBLE" << endl;
    else cout << ans << endl;
    
    return 0;
}
```

---

## Cheat Sheet

### One-Page Revision

```
MST: Minimum weight subgraph connecting all vertices (V-1 edges, acyclic)

KRUSKAL'S: Sort edges → greedily add if no cycle (DSU)
  Time: O(E log E), Best for sparse graphs

PRIM'S: Grow tree from seed → always add cheapest connection (Priority Queue)
  Time: O(E log V) or O(V²), Best for dense graphs

KEY PROPERTIES:
• Cut Property: min edge across any cut is in MST
• Cycle Property: max edge in any cycle is NOT in MST  
• MST has exactly V-1 edges
• Unique if all weights distinct

TRICKS:
• Maximum spanning tree: negate weights or sort descending
• Virtual node: add node 0 connected to all with special costs
• K clusters: stop Kruskal's at V-K edges
• Minimax path: maximum edge on path in MST
```
