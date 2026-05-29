# Shortest Path Algorithms

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Single Source Shortest Path Overview](#single-source-shortest-path-overview)
- [Dijkstra's Algorithm](#dijkstras-algorithm)
- [Bellman-Ford Algorithm](#bellman-ford-algorithm)
- [Floyd-Warshall Algorithm](#floyd-warshall-algorithm)
- [Comparison Table](#comparison-of-algorithms)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Cheat Sheet](#cheat-sheet)

---

## Introduction

### What is the Shortest Path Problem?

Finding the path between two vertices in a graph such that the sum of edge weights along the path is minimized.

### Types of Shortest Path Problems

| Type | Description | Algorithm |
|------|-------------|-----------|
| Single Source (unweighted) | Distance from one source | BFS |
| Single Source (non-negative weights) | Distance from one source | Dijkstra's |
| Single Source (negative weights) | Distance from one source | Bellman-Ford |
| All Pairs | Distance between ALL pairs | Floyd-Warshall |
| Single Source (DAG) | Distance in DAG | Topological Sort + relaxation |

---

## Prerequisites

- [01_Introduction](../01_Introduction/README.md) - Weighted graphs
- [02_Traversals](../02_Traversals/README.md) - BFS shortest path (unweighted)
- [04_Directed_Graph](../04_Directed_Graph/README.md) - Topological sort for DAGs
- Priority Queue (min-heap) concept

---

## Single Source Shortest Path Overview

### The Relaxation Technique

All shortest path algorithms use **relaxation**: trying to improve the shortest distance to a vertex.

```
RELAX(u, v, w):
    if dist[v] > dist[u] + w:
        dist[v] = dist[u] + w
        parent[v] = u

Intuition: "Can we reach v faster by going through u?"
```

### When to Use Which Algorithm

```
┌─────────────────────────────────────────────────────┐
│ CHOOSING THE RIGHT ALGORITHM:                        │
│                                                      │
│ All weights = 1 (unweighted)?                        │
│   → BFS  O(V + E)                                   │
│                                                      │
│ All weights ≥ 0?                                     │
│   → Dijkstra's  O(E log V)                          │
│                                                      │
│ Negative weights (no negative cycle)?                │
│   → Bellman-Ford  O(V × E)                          │
│                                                      │
│ Need to detect negative cycles?                      │
│   → Bellman-Ford  O(V × E)                          │
│                                                      │
│ All pairs shortest path?                             │
│   → Floyd-Warshall  O(V³)                           │
│   → OR run Dijkstra V times O(V × E log V)          │
│                                                      │
│ DAG (directed acyclic graph)?                        │
│   → Topological Sort + Relax  O(V + E)              │
│                                                      │
│ Weights are 0 or 1?                                  │
│   → 0-1 BFS (deque)  O(V + E)                       │
└─────────────────────────────────────────────────────┘
```

---

## Dijkstra's Algorithm

### Theory

Dijkstra's algorithm finds shortest paths from a single source to all other vertices in a graph with **non-negative** edge weights.

### Intuition

```
Key Idea: Greedily process the unvisited vertex with minimum distance.

Why it works:
- The vertex with minimum distance among all unvisited vertices 
  has already found its shortest path.
- Because all weights are non-negative, no future path through 
  unvisited vertices can be shorter.
- This is the "greedy" property that makes Dijkstra's correct.

Analogy: Expanding a wavefront from the source.
  The wave reaches closer points first.
  Once reached, a point's distance is final.
```

### Why Dijkstra Fails with Negative Weights

```
Graph: A --1--> B --(-5)--> C
       A --------3---------> C

Dijkstra processes B first (dist=1), then C via B (dist=1-5=-4)
But Dijkstra might process C first with dist=3 and mark it final!
Once marked final, it won't update even though -4 < 3.

With non-negative weights, once a vertex is finalized, 
no shorter path can exist (because adding non-negative edges 
only increases distance).
```

### Algorithm

```
Dijkstra(graph, source):
    dist[source] = 0, dist[all others] = ∞
    priority_queue pq (min-heap by distance)
    pq.push({0, source})
    
    while pq not empty:
        {d, u} = pq.top(); pq.pop()
        if d > dist[u]: continue  // Stale entry
        
        for each neighbor (v, w) of u:
            if dist[u] + w < dist[v]:
                dist[v] = dist[u] + w
                parent[v] = u
                pq.push({dist[v], v})
    
    return dist, parent
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

typedef pair<long long, int> pli;  // {distance, vertex}

vector<long long> dijkstra(int n, vector<vector<pair<int,int>>>& adj, int source) {
    vector<long long> dist(n, LLONG_MAX);
    priority_queue<pli, vector<pli>, greater<pli>> pq;
    
    dist[source] = 0;
    pq.push({0, source});
    
    while (!pq.empty()) {
        auto [d, u] = pq.top();
        pq.pop();
        
        if (d > dist[u]) continue;  // Skip stale entries
        
        for (auto [v, w] : adj[u]) {
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                pq.push({dist[v], v});
            }
        }
    }
    
    return dist;
}

// With path reconstruction
pair<vector<long long>, vector<int>> dijkstraWithPath(
    int n, vector<vector<pair<int,int>>>& adj, int source) {
    
    vector<long long> dist(n, LLONG_MAX);
    vector<int> parent(n, -1);
    priority_queue<pli, vector<pli>, greater<pli>> pq;
    
    dist[source] = 0;
    pq.push({0, source});
    
    while (!pq.empty()) {
        auto [d, u] = pq.top();
        pq.pop();
        
        if (d > dist[u]) continue;
        
        for (auto [v, w] : adj[u]) {
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                parent[v] = u;
                pq.push({dist[v], v});
            }
        }
    }
    
    return {dist, parent};
}

vector<int> getPath(vector<int>& parent, int target) {
    vector<int> path;
    for (int v = target; v != -1; v = parent[v]) {
        path.push_back(v);
    }
    reverse(path.begin(), path.end());
    return path;
}

int main() {
    int n = 5;
    vector<vector<pair<int,int>>> adj(n);
    
    // Add edges: {to, weight}
    adj[0].push_back({1, 4});
    adj[0].push_back({2, 1});
    adj[1].push_back({3, 1});
    adj[2].push_back({1, 2});
    adj[2].push_back({3, 5});
    adj[3].push_back({4, 3});
    
    auto dist = dijkstra(n, adj, 0);
    
    cout << "Shortest distances from vertex 0:" << endl;
    for (int i = 0; i < n; i++) {
        cout << "  0 → " << i << ": ";
        if (dist[i] == LLONG_MAX) cout << "INF";
        else cout << dist[i];
        cout << endl;
    }
    
    return 0;
}
```

### Dry Run

```
Graph:
  0 --4--> 1 --1--> 3 --3--> 4
  |       ↑         ↑
  1      2         5
  |    /           |
  ↓  /             |
  2 ----------------

adj[0] = [(1,4), (2,1)]
adj[1] = [(3,1)]
adj[2] = [(1,2), (3,5)]
adj[3] = [(4,3)]

Dijkstra from source 0:

Initial: dist = [0, ∞, ∞, ∞, ∞], pq = [(0,0)]

Step 1: Pop (0, 0) → process vertex 0
  Relax edge 0→1: dist[1] = min(∞, 0+4) = 4, push (4,1)
  Relax edge 0→2: dist[2] = min(∞, 0+1) = 1, push (1,2)
  dist = [0, 4, 1, ∞, ∞], pq = [(1,2), (4,1)]

Step 2: Pop (1, 2) → process vertex 2 (closest unvisited)
  Relax edge 2→1: dist[1] = min(4, 1+2) = 3, push (3,1)
  Relax edge 2→3: dist[3] = min(∞, 1+5) = 6, push (6,3)
  dist = [0, 3, 1, 6, ∞], pq = [(3,1), (4,1), (6,3)]

Step 3: Pop (3, 1) → process vertex 1
  Relax edge 1→3: dist[3] = min(6, 3+1) = 4, push (4,3)
  dist = [0, 3, 1, 4, ∞], pq = [(4,1), (4,3), (6,3)]

Step 4: Pop (4, 1) → 4 > dist[1]=3, SKIP (stale entry)

Step 5: Pop (4, 3) → process vertex 3
  Relax edge 3→4: dist[4] = min(∞, 4+3) = 7, push (7,4)
  dist = [0, 3, 1, 4, 7], pq = [(6,3), (7,4)]

Step 6: Pop (6, 3) → 6 > dist[3]=4, SKIP

Step 7: Pop (7, 4) → process vertex 4
  No outgoing edges.
  dist = [0, 3, 1, 4, 7], pq = []

Final: dist = [0, 3, 1, 4, 7]
Shortest paths: 0→0: 0, 0→1: 3 (via 2), 0→2: 1, 0→3: 4 (via 2,1), 0→4: 7
```

### Complexity

| Aspect | Binary Heap | Fibonacci Heap |
|--------|-------------|----------------|
| Time | O((V + E) log V) | O(V log V + E) |
| Space | O(V + E) | O(V + E) |
| Practical | ✅ Used in practice | Rarely used (constant factor) |

---

## Bellman-Ford Algorithm

### Theory

Bellman-Ford finds shortest paths from a single source, works with **negative edge weights**, and can **detect negative cycles**.

### Intuition

```
Key Idea: Relax ALL edges V-1 times.

Why V-1 iterations?
- Shortest path has at most V-1 edges
- In iteration k, we find all shortest paths using at most k edges
- After V-1 iterations, all shortest paths (≤ V-1 edges) are found

Negative Cycle Detection:
- After V-1 iterations, do one more iteration
- If any distance improves → NEGATIVE CYCLE exists
  (because shortest "path" is actually -∞ through cycle)
```

### Algorithm

```
BellmanFord(graph, source, V, edges):
    dist[source] = 0, dist[others] = ∞
    
    // Relax all edges V-1 times
    for i = 1 to V-1:
        for each edge (u, v, w):
            if dist[u] + w < dist[v]:
                dist[v] = dist[u] + w
    
    // Check for negative cycles
    for each edge (u, v, w):
        if dist[u] + w < dist[v]:
            return "NEGATIVE CYCLE"
    
    return dist
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Edge {
    int from, to;
    long long weight;
};

// Returns distances or detects negative cycle
pair<vector<long long>, bool> bellmanFord(int n, vector<Edge>& edges, int source) {
    vector<long long> dist(n, LLONG_MAX);
    dist[source] = 0;
    
    // Relax all edges V-1 times
    for (int i = 0; i < n - 1; i++) {
        bool updated = false;
        for (auto& e : edges) {
            if (dist[e.from] != LLONG_MAX && 
                dist[e.from] + e.weight < dist[e.to]) {
                dist[e.to] = dist[e.from] + e.weight;
                updated = true;
            }
        }
        if (!updated) break; // Early termination
    }
    
    // Check for negative cycle
    for (auto& e : edges) {
        if (dist[e.from] != LLONG_MAX && 
            dist[e.from] + e.weight < dist[e.to]) {
            return {dist, true}; // Negative cycle exists
        }
    }
    
    return {dist, false};
}

// Find vertices affected by negative cycle
vector<long long> bellmanFordWithNegCycle(int n, vector<Edge>& edges, int source) {
    vector<long long> dist(n, LLONG_MAX);
    dist[source] = 0;
    
    // V-1 relaxations
    for (int i = 0; i < n - 1; i++) {
        for (auto& e : edges) {
            if (dist[e.from] != LLONG_MAX && 
                dist[e.from] + e.weight < dist[e.to]) {
                dist[e.to] = dist[e.from] + e.weight;
            }
        }
    }
    
    // V-th iteration: mark nodes reachable from negative cycle
    for (int i = 0; i < n; i++) { // Run N more times to propagate
        for (auto& e : edges) {
            if (dist[e.from] != LLONG_MAX && 
                dist[e.from] + e.weight < dist[e.to]) {
                dist[e.to] = LLONG_MIN; // Affected by negative cycle
            }
            if (dist[e.from] == LLONG_MIN) {
                dist[e.to] = LLONG_MIN;
            }
        }
    }
    
    return dist;
}

int main() {
    int n = 5;
    vector<Edge> edges = {
        {0, 1, 4}, {0, 2, 1}, {2, 1, 2},
        {1, 3, 1}, {2, 3, 5}, {3, 4, 3}
    };
    
    auto [dist, hasNegCycle] = bellmanFord(n, edges, 0);
    
    if (hasNegCycle) {
        cout << "Negative cycle detected!" << endl;
    } else {
        for (int i = 0; i < n; i++) {
            cout << "dist[" << i << "] = " << dist[i] << endl;
        }
    }
    
    return 0;
}
```

### Dry Run

```
Vertices: 0-4, Source: 0
Edges: (0,1,4), (0,2,1), (2,1,2), (1,3,1), (2,3,5), (3,4,3)

Initial: dist = [0, ∞, ∞, ∞, ∞]

Iteration 1 (relax all edges):
  (0,1,4): dist[1] = min(∞, 0+4) = 4
  (0,2,1): dist[2] = min(∞, 0+1) = 1
  (2,1,2): dist[1] = min(4, 1+2) = 3
  (1,3,1): dist[3] = min(∞, 3+1) = 4
  (2,3,5): dist[3] = min(4, 1+5) = 4 (no change)
  (3,4,3): dist[4] = min(∞, 4+3) = 7
  dist = [0, 3, 1, 4, 7]

Iteration 2:
  (0,1,4): dist[1] = min(3, 0+4) = 3 (no change)
  (0,2,1): no change
  (2,1,2): dist[1] = min(3, 1+2) = 3 (no change)
  (1,3,1): dist[3] = min(4, 3+1) = 4 (no change)
  No updates → early termination!

Final: dist = [0, 3, 1, 4, 7]
(Same as Dijkstra result ✓)
```

### Complexity

| Aspect | Value |
|--------|-------|
| Time | O(V × E) |
| Space | O(V + E) |
| With early termination | Can be faster in practice |

---

## Floyd-Warshall Algorithm

### Theory

Floyd-Warshall finds shortest paths between ALL pairs of vertices. It also handles negative weights and detects negative cycles.

### Intuition

```
Key Idea: Dynamic programming on intermediate vertices.

dist[i][j][k] = shortest path from i to j using only 
                vertices {0, 1, ..., k} as intermediate points.

Recurrence:
  dist[i][j][k] = min(
    dist[i][j][k-1],           // Don't use vertex k
    dist[i][k][k-1] + dist[k][j][k-1]  // Use vertex k
  )

We optimize space by using 2D array (in-place updates).

Intuition: For each "relay point" k, check if going through k
gives a shorter path from i to j.
```

### Algorithm

```
FloydWarshall(graph):
    // Initialize distance matrix
    dist[i][j] = weight(i,j) if edge exists, ∞ otherwise
    dist[i][i] = 0
    
    // For each intermediate vertex k
    for k = 0 to V-1:
        for i = 0 to V-1:
            for j = 0 to V-1:
                dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])
    
    // Check negative cycle: dist[i][i] < 0 for some i
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

const long long INF = 1e18;

vector<vector<long long>> floydWarshall(int n, vector<vector<long long>>& dist) {
    // dist should be initialized:
    // dist[i][j] = weight if edge exists, INF if not, 0 if i==j
    
    for (int k = 0; k < n; k++) {
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (dist[i][k] < INF && dist[k][j] < INF) {
                    dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j]);
                }
            }
        }
    }
    
    return dist;
}

// With path reconstruction
vector<vector<long long>> floydWarshallPath(
    int n, vector<vector<long long>>& dist, vector<vector<int>>& next) {
    
    // Initialize next matrix
    next.assign(n, vector<int>(n, -1));
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            if (dist[i][j] < INF && i != j)
                next[i][j] = j;
    
    for (int k = 0; k < n; k++) {
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (dist[i][k] < INF && dist[k][j] < INF &&
                    dist[i][k] + dist[k][j] < dist[i][j]) {
                    dist[i][j] = dist[i][k] + dist[k][j];
                    next[i][j] = next[i][k];
                }
            }
        }
    }
    
    return dist;
}

vector<int> getPath(vector<vector<int>>& next, int u, int v) {
    if (next[u][v] == -1) return {}; // No path
    vector<int> path = {u};
    while (u != v) {
        u = next[u][v];
        path.push_back(u);
    }
    return path;
}

// Detect negative cycle
bool hasNegativeCycle(vector<vector<long long>>& dist, int n) {
    for (int i = 0; i < n; i++) {
        if (dist[i][i] < 0) return true;
    }
    return false;
}

int main() {
    int n = 4;
    vector<vector<long long>> dist(n, vector<long long>(n, INF));
    
    // Initialize diagonal
    for (int i = 0; i < n; i++) dist[i][i] = 0;
    
    // Add edges
    dist[0][1] = 3; dist[0][3] = 7;
    dist[1][0] = 8; dist[1][2] = 2;
    dist[2][0] = 5; dist[2][3] = 1;
    dist[3][0] = 2;
    
    floydWarshall(n, dist);
    
    cout << "All-Pairs Shortest Distances:" << endl;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (dist[i][j] >= INF) cout << "INF ";
            else cout << dist[i][j] << "   ";
        }
        cout << endl;
    }
    
    return 0;
}
```

### Dry Run

```
n = 4, Initial distance matrix:
     0    1    2    3
0 [  0,   3, INF,   7 ]
1 [  8,   0,   2, INF ]
2 [  5, INF,   0,   1 ]
3 [  2, INF, INF,   0 ]

k = 0 (using vertex 0 as intermediate):
  dist[1][3] = min(INF, dist[1][0]+dist[0][3]) = min(INF, 8+7) = 15
  dist[2][1] = min(INF, dist[2][0]+dist[0][1]) = min(INF, 5+3) = 8
  dist[2][3] = min(1, dist[2][0]+dist[0][3]) = min(1, 5+7) = 1
  dist[3][1] = min(INF, dist[3][0]+dist[0][1]) = min(INF, 2+3) = 5
  dist[3][2] = min(INF, dist[3][0]+dist[0][2]) = min(INF, 2+INF) = INF

After k=0:
     0    1    2    3
0 [  0,   3, INF,   7 ]
1 [  8,   0,   2,  15 ]
2 [  5,   8,   0,   1 ]
3 [  2,   5, INF,   0 ]

k = 1 (using vertex 1 as intermediate):
  dist[0][2] = min(INF, 3+2) = 5
  dist[0][3] = min(7, 3+15) = 7
  dist[2][3] = min(1, 8+15) = 1
  dist[3][2] = min(INF, 5+2) = 7

After k=1:
     0    1    2    3
0 [  0,   3,   5,   7 ]
1 [  8,   0,   2,  15 ]
2 [  5,   8,   0,   1 ]
3 [  2,   5,   7,   0 ]

k = 2 (using vertex 2 as intermediate):
  dist[0][3] = min(7, 5+1) = 6
  dist[1][0] = min(8, 2+5) = 7
  dist[1][3] = min(15, 2+1) = 3
  dist[3][0] = min(2, 7+5) = 2
  dist[3][1] = min(5, 7+8) = 5

After k=2:
     0    1    2    3
0 [  0,   3,   5,   6 ]
1 [  7,   0,   2,   3 ]
2 [  5,   8,   0,   1 ]
3 [  2,   5,   7,   0 ]

k = 3 (using vertex 3 as intermediate):
  dist[0][0] = min(0, 6+2) = 0
  dist[1][0] = min(7, 3+2) = 5
  dist[2][0] = min(5, 1+2) = 3
  dist[2][1] = min(8, 1+5) = 6

Final:
     0    1    2    3
0 [  0,   3,   5,   6 ]
1 [  5,   0,   2,   3 ]
2 [  3,   6,   0,   1 ]
3 [  2,   5,   7,   0 ]
```

### Complexity

| Aspect | Value |
|--------|-------|
| Time | O(V³) |
| Space | O(V²) |
| Best for | V ≤ 400-500, all-pairs queries |

---

## Comparison of Algorithms

| Feature | BFS | Dijkstra | Bellman-Ford | Floyd-Warshall |
|---------|-----|----------|-------------|----------------|
| Type | SSSP | SSSP | SSSP | APSP |
| Weights | Unweighted | Non-negative | Any | Any |
| Negative weights | ❌ | ❌ | ✅ | ✅ |
| Negative cycle detect | ❌ | ❌ | ✅ | ✅ |
| Time | O(V+E) | O(E log V) | O(VE) | O(V³) |
| Space | O(V) | O(V+E) | O(V+E) | O(V²) |
| Data structure | Queue | Min-heap | Edge list | Matrix |
| Best for | Unweighted | Non-neg SSSP | Neg weights | All pairs |

---

## Pattern Recognition

### How To Identify Shortest Path Problems

1. "Minimum distance/cost from A to B"
2. "Cheapest route/flight"
3. "Minimum time to reach"
4. "Network delay time"
5. "Shortest transformation"
6. "Minimum operations"

### Algorithm Selection Guide (30+ patterns)

7. "Shortest path, all weights 1" → BFS
8. "Shortest path, positive weights" → Dijkstra
9. "Shortest path, negative weights possible" → Bellman-Ford
10. "All pairs distances" → Floyd-Warshall (V≤500) or V×Dijkstra
11. "Cheapest flights with K stops" → Modified Bellman-Ford/BFS
12. "Shortest path in DAG" → Topological sort + relax
13. "Minimum cost with constraints" → Modified Dijkstra with state
14. "Path with minimum maximum edge" → Binary search + BFS/MST
15. "Second shortest path" → Modified Dijkstra
16. "K-th shortest path" → Yen's algorithm
17. "Shortest path avoiding certain nodes" → Remove and run Dijkstra
18. "Shortest alternating path" → BFS with state
19. "0-1 weights" → 0-1 BFS (deque)
20. "Bidirectional search" → Bidirectional Dijkstra
21. "A* search" → Dijkstra with heuristic
22. "Negative cycle detection" → Bellman-Ford
23. "Maximum shortest path" → Binary search on answer
24. "Minimum cost to make all distances ≤ K" → Greedy/DP
25. "Shortest path in grid" → BFS/Dijkstra
26. "Minimum fuel cost" → Dijkstra with state
27. "Shortest path with portals/teleports" → Modified graph + Dijkstra
28. "Time-dependent shortest path" → Dijkstra on time-expanded graph
29. "Multi-objective shortest path" → Pareto-optimal paths
30. "Constrained shortest path" → Lagrangian relaxation
31. "Shortest path with must-pass edges" → Combine subpaths

---

## Problem Solving

### Easy Problems

| # | Problem | Platform | Algorithm |
|---|---------|----------|-----------|
| 1 | Network Delay Time | LeetCode 743 | Dijkstra |
| 2 | Path With Minimum Effort | LeetCode 1631 | Dijkstra/Binary search |
| 3 | Shortest Path in Binary Matrix | LeetCode 1091 | BFS |
| 4 | Shortest Routes I | CSES | Dijkstra |
| 5 | Shortest Routes II | CSES | Floyd-Warshall |
| 6 | Shortest Path | GFG | Dijkstra basic |
| 7 | Bellman Ford | GFG | Basic implementation |
| 8 | Floyd Warshall | GFG | Basic implementation |
| 9 | Cheapest Flights Within K Stops | LeetCode 787 | Bellman-Ford/BFS |
| 10 | Find City With Smallest Neighbors | LeetCode 1334 | Floyd-Warshall |

### Medium Problems

| # | Problem | Platform | Algorithm |
|---|---------|----------|-----------|
| 1 | Cheapest Flights Within K Stops | LeetCode 787 | Modified BF |
| 2 | Path With Maximum Probability | LeetCode 1514 | Modified Dijkstra |
| 3 | Minimum Cost to Reach Destination | LeetCode 1928 | Dijkstra |
| 4 | Number of Ways to Arrive | LeetCode 1976 | Dijkstra + counting |
| 5 | Design Graph With Shortest Path | LeetCode 2642 | Dijkstra |
| 6 | Minimum Obstacle Removal | LeetCode 2290 | 0-1 BFS |
| 7 | Minimum Cost to Make Valid Path | LeetCode 1368 | 0-1 BFS |
| 8 | Swim in Rising Water | LeetCode 778 | Dijkstra/BS+BFS |
| 9 | Minimum Cost to Cut Stick | LeetCode 1547 | DP (not direct graph) |
| 10 | Reachable Nodes in Subdivided Graph | LeetCode 882 | Dijkstra |
| 11 | High Score | CSES | Bellman-Ford neg cycle |
| 12 | Cycle Finding | CSES | Bellman-Ford |
| 13 | Flight Discount | CSES | Modified Dijkstra |
| 14 | Investigation | CSES | Dijkstra + counting |
| 15 | Minimum Weighted Subgraph With Required Paths | LeetCode 2203 | 3x Dijkstra |

### Hard Problems

| # | Problem | Platform | Algorithm |
|---|---------|----------|-----------|
| 1 | K-th Shortest Path | LeetCode/SPOJ | Yen's algorithm |
| 2 | Shortest Path with Obstacles | LeetCode 1293 | Dijkstra + state |
| 3 | Minimum Cost to Reach All Nodes | Various | Steiner tree |
| 4 | Shortest Path Visiting All Nodes | LeetCode 847 | BFS + bitmask |
| 5 | Second Shortest Path | Various | Modified Dijkstra |
| 6 | Negative Cycle Reachability | CSES | Bellman-Ford + BFS |
| 7 | Number of Shortest Paths | Various | Dijkstra + counting |
| 8 | Time-Dependent Shortest Path | Codeforces | Modified Dijkstra |
| 9 | Bi-criteria Shortest Path | Various | Multi-dim Dijkstra |
| 10 | Johnson's Algorithm | Various | BF + V×Dijkstra |

---

## Interview Preparation

### Top 50 Questions

1. Explain Dijkstra's algorithm.
2. Why doesn't Dijkstra work with negative weights?
3. Explain Bellman-Ford algorithm.
4. How does Bellman-Ford detect negative cycles?
5. Explain Floyd-Warshall algorithm.
6. When to use each algorithm?
7. What is the relaxation technique?
8. Implement Dijkstra using min-heap.
9. What is 0-1 BFS? When to use?
10. What is A* search? How does it improve Dijkstra?
11. What is bidirectional Dijkstra?
12. How to find K shortest paths?
13. How to handle shortest path with constraints?
14. What is Johnson's algorithm?
15. How to find second shortest path?
16. Time complexity comparison of all algorithms.
17. Can Dijkstra handle negative cycles? Why not?
18. What is SPFA? Is it reliable?
19. How to reconstruct the path?
20. What is the difference between shortest path and minimum spanning tree?

---

## Competitive Programming

### Dijkstra Template

```cpp
#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
typedef pair<ll,int> pli;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    
    int n, m;
    cin >> n >> m;
    
    vector<vector<pair<int,int>>> adj(n + 1);
    for (int i = 0; i < m; i++) {
        int u, v, w;
        cin >> u >> v >> w;
        adj[u].push_back({v, w});
        // adj[v].push_back({u, w}); // for undirected
    }
    
    vector<ll> dist(n + 1, LLONG_MAX);
    priority_queue<pli, vector<pli>, greater<pli>> pq;
    
    dist[1] = 0;
    pq.push({0, 1});
    
    while (!pq.empty()) {
        auto [d, u] = pq.top(); pq.pop();
        if (d > dist[u]) continue;
        for (auto [v, w] : adj[u]) {
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w;
                pq.push({dist[v], v});
            }
        }
    }
    
    for (int i = 1; i <= n; i++)
        cout << (dist[i] == LLONG_MAX ? -1 : dist[i]) << " ";
    
    return 0;
}
```

---

## Cheat Sheet

```
DIJKSTRA: Non-negative weights, SSSP
  O(E log V), uses min-heap
  FAILS with negative weights

BELLMAN-FORD: Any weights, SSSP, detects negative cycles
  O(V × E), relax all edges V-1 times
  Extra iteration to detect negative cycle

FLOYD-WARSHALL: Any weights, ALL-PAIRS
  O(V³), dp[i][j] = min(dp[i][j], dp[i][k]+dp[k][j])
  Negative cycle: dp[i][i] < 0

0-1 BFS: Weights are 0 or 1
  O(V + E), use deque (0-weight → front, 1-weight → back)

DECISION:
  Unweighted → BFS
  Non-negative → Dijkstra
  Negative weights → Bellman-Ford
  All pairs (V≤500) → Floyd-Warshall
  DAG → Topo sort + relax
```
