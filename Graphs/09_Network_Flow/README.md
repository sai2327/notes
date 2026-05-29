# Network Flow

## Table of Contents
- [Introduction](#introduction)
- [Network Flow Terminologies](#network-flow-terminologies)
- [Max-Flow Min-Cut Theorem](#max-flow-min-cut-theorem)
- [Ford-Fulkerson Algorithm](#ford-fulkerson-algorithm)
- [Edmonds-Karp Algorithm](#edmonds-karp-algorithm)
- [Dinic's Algorithm](#dinics-algorithm)
- [Applications](#applications)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Cheat Sheet](#cheat-sheet)

---

## Introduction

### What is Network Flow?

Network Flow models the problem of sending "flow" through a network (directed graph) from a **source** to a **sink**, subject to **capacity constraints** on edges.

### Real-World Analogies

| Analogy | Source | Sink | Edges | Capacity |
|---------|--------|------|-------|----------|
| Water pipes | Reservoir | City | Pipes | Pipe diameter |
| Road network | City A | City B | Roads | Lane capacity |
| Internet | Server | Client | Links | Bandwidth |
| Supply chain | Factory | Store | Routes | Truck capacity |

### The Maximum Flow Problem

**Given**: Directed graph with capacities, source s, sink t
**Find**: Maximum amount of flow from s to t without exceeding any edge capacity

```
Example:
    s --10--> A --5--> t
    s --8---> B --7--> t
    A --3---> B
    
Maximum flow from s to t = ?
```

---

## Network Flow Terminologies

### Key Definitions

| Term | Definition |
|------|-----------|
| **Source (s)** | Starting vertex (produces flow) |
| **Sink (t)** | Ending vertex (consumes flow) |
| **Capacity c(u,v)** | Maximum flow allowed on edge (u,v) |
| **Flow f(u,v)** | Actual flow on edge (u,v) |
| **Residual capacity** | c(u,v) - f(u,v) (remaining capacity) |
| **Residual graph** | Graph with residual capacities (includes reverse edges) |
| **Augmenting path** | Path from s to t in residual graph with positive capacity |
| **Bottleneck** | Minimum residual capacity along augmenting path |
| **Cut** | Partition of vertices into S (containing s) and T (containing t) |
| **Cut capacity** | Sum of capacities of edges from S to T |
| **Min-cut** | Cut with minimum capacity |

### Flow Conservation

```
For every vertex v (except s and t):
  ∑ f(u,v) = ∑ f(v,w)     (flow in = flow out)
  
Constraints:
  0 ≤ f(u,v) ≤ c(u,v)     (capacity constraint)
  f(u,v) = -f(v,u)         (skew symmetry)
```

### Residual Graph

```
Original edge: u --cap:10, flow:6--> v

Residual graph has TWO edges:
  u --4--> v    (forward: can send 4 more)
  v --6--> u    (backward: can "undo" 6 units)

The backward edge allows the algorithm to "reroute" flow.
```

### Visual Example

```
Original Graph (capacity):         With flow (flow/capacity):
    A                                   A
   /10\ 5                             6/10\ 5/5
  s     → t                          s       → t
   \8  / 7                            8/8  / 7/7
    B                                   B
    ↑3/                                ↑3/3
    from A                             from A

Residual Graph:
    A
   4→  ←6   5→  ←5
  s         ↔     t
   ←8  8→   ←7  7→
    B
```

---

## Max-Flow Min-Cut Theorem

### Statement

```
In any flow network:
  Maximum Flow = Minimum Cut Capacity

This is one of the most important theorems in combinatorial optimization.
```

### Proof Intuition

```
• Any flow must pass through any cut → flow ≤ cut capacity
• Ford-Fulkerson finds a flow equal to some cut → that cut is minimum
• Therefore max flow = min cut
```

### Finding Min-Cut

```
After finding max flow:
1. Build residual graph
2. BFS/DFS from source in residual graph
3. Reachable vertices = set S
4. Unreachable vertices = set T
5. Min-cut edges: edges from S to T in original graph that are saturated
```

---

## Ford-Fulkerson Algorithm

### Theory

The Ford-Fulkerson method repeatedly finds augmenting paths from s to t in the residual graph and sends flow along them.

### Algorithm

```
FordFulkerson(graph, s, t):
    Initialize flow f = 0 for all edges
    While there exists an augmenting path P from s to t in residual graph:
        bottleneck = min capacity along P
        For each edge (u,v) in P:
            f(u,v) += bottleneck     // Send flow
            f(v,u) -= bottleneck     // Update reverse
        max_flow += bottleneck
    Return max_flow
```

### C++ Implementation (DFS-based)

```cpp
#include <bits/stdc++.h>
using namespace std;

class FordFulkerson {
    int n;
    vector<vector<int>> capacity;
    vector<vector<int>> adj;
    
    int dfs(int u, int t, int pushed, vector<bool>& visited) {
        if (u == t) return pushed;
        visited[u] = true;
        
        for (int v : adj[u]) {
            if (!visited[v] && capacity[u][v] > 0) {
                int flow = dfs(v, t, min(pushed, capacity[u][v]), visited);
                if (flow > 0) {
                    capacity[u][v] -= flow;
                    capacity[v][u] += flow;
                    return flow;
                }
            }
        }
        return 0;
    }
    
public:
    FordFulkerson(int n) : n(n), capacity(n, vector<int>(n, 0)), adj(n) {}
    
    void addEdge(int u, int v, int cap) {
        capacity[u][v] += cap;
        adj[u].push_back(v);
        adj[v].push_back(u); // Reverse edge for residual
    }
    
    int maxFlow(int s, int t) {
        int flow = 0;
        while (true) {
            vector<bool> visited(n, false);
            int pushed = dfs(s, t, INT_MAX, visited);
            if (pushed == 0) break;
            flow += pushed;
        }
        return flow;
    }
};

int main() {
    int n = 4; // vertices: 0(s), 1(A), 2(B), 3(t)
    FordFulkerson ff(n);
    
    ff.addEdge(0, 1, 10); // s → A: 10
    ff.addEdge(0, 2, 8);  // s → B: 8
    ff.addEdge(1, 2, 3);  // A → B: 3
    ff.addEdge(1, 3, 5);  // A → t: 5
    ff.addEdge(2, 3, 7);  // B → t: 7
    
    cout << "Maximum Flow: " << ff.maxFlow(0, 3) << endl;
    
    return 0;
}
```

### Dry Run

```
Graph: s=0, t=3
Edges: (0,1,10), (0,2,8), (1,2,3), (1,3,5), (2,3,7)

Initial capacity matrix:
     0  1  2  3
0 [  0 10  8  0 ]
1 [  0  0  3  5 ]
2 [  0  0  0  7 ]
3 [  0  0  0  0 ]

Iteration 1: Find augmenting path (DFS)
  Path: 0 → 1 → 3, bottleneck = min(10, 5) = 5
  Update: cap[0][1] = 5, cap[1][0] = 5
          cap[1][3] = 0, cap[3][1] = 5
  flow = 5

Iteration 2: Find augmenting path
  Path: 0 → 1 → 2 → 3, bottleneck = min(5, 3, 7) = 3
  Update: cap[0][1] = 2, cap[1][2] = 0, cap[2][3] = 4
  flow = 5 + 3 = 8

Iteration 3: Find augmenting path
  Path: 0 → 2 → 3, bottleneck = min(8, 4) = 4
  Update: cap[0][2] = 4, cap[2][3] = 0
  flow = 8 + 4 = 12

Iteration 4: Find augmenting path
  Path: 0 → 1 → ... → can't reach t
  OR: 0 → 2 → ... cap[2][3]=0, can reach t via 2→1→3? 
  cap[2][1] exists (reverse edge = 3), cap[1][3] = 0...
  
  Let me re-check. After all updates:
  cap[0][1]=2, cap[0][2]=4, cap[1][2]=0, cap[1][3]=0, cap[2][3]=0
  Reverse: cap[1][0]=5, cap[2][0]=4, cap[2][1]=3, cap[3][1]=5, cap[3][2]=7
  
  Path: 0 → 1? cap[0][1]=2 ✓ → 1→3? cap=0 ✗
        1→2? cap=0 ✗ 
        Back. 0→2? cap[0][2]=4 ✓ → 2→3? cap=0 ✗
        2→1? cap[2][1]=3 ✓ → 1→3? cap=0 ✗
        No path found!

  Wait, let me redo more carefully with DFS.
  
  Actually the max flow = 12 (5 + 3 + 4)
  Verify: source output = f(0,1) + f(0,2) = 8 + 4 = 12
  But source capacity = 10 + 8 = 18, sink capacity = 5 + 7 = 12
  So max flow is limited by sink = 12 ✓

Maximum Flow = 12
```

### Complexity

| Aspect | Value |
|--------|-------|
| Time (integer capacities) | O(E × max_flow) |
| Problem | Can be exponential if bad paths chosen |
| Space | O(V²) for capacity matrix |

---

## Edmonds-Karp Algorithm

### Theory

Edmonds-Karp is Ford-Fulkerson with BFS to find augmenting paths (shortest path in terms of number of edges). This guarantees polynomial time.

### Why BFS Matters

```
Ford-Fulkerson with DFS: O(E × max_flow) - can be exponential
Ford-Fulkerson with BFS: O(V × E²) - always polynomial!

BFS finds shortest augmenting path, which guarantees:
- At most O(VE) augmentations
- Each BFS is O(E)
- Total: O(VE²)
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class EdmondsKarp {
    int n;
    vector<vector<int>> capacity;
    vector<vector<int>> adj;
    
    int bfs(int s, int t, vector<int>& parent) {
        fill(parent.begin(), parent.end(), -1);
        parent[s] = s;
        queue<pair<int,int>> q;
        q.push({s, INT_MAX});
        
        while (!q.empty()) {
            auto [u, flow] = q.front();
            q.pop();
            
            for (int v : adj[u]) {
                if (parent[v] == -1 && capacity[u][v] > 0) {
                    parent[v] = u;
                    int new_flow = min(flow, capacity[u][v]);
                    if (v == t) return new_flow;
                    q.push({v, new_flow});
                }
            }
        }
        return 0;
    }
    
public:
    EdmondsKarp(int n) : n(n), capacity(n, vector<int>(n, 0)), adj(n) {}
    
    void addEdge(int u, int v, int cap) {
        capacity[u][v] += cap;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    int maxFlow(int s, int t) {
        int flow = 0;
        vector<int> parent(n);
        
        while (int pushed = bfs(s, t, parent)) {
            flow += pushed;
            // Update capacities along the path
            int v = t;
            while (v != s) {
                int u = parent[v];
                capacity[u][v] -= pushed;
                capacity[v][u] += pushed;
                v = u;
            }
        }
        return flow;
    }
    
    // Find min-cut after computing max flow
    vector<pair<int,int>> minCut(int s) {
        // BFS from source in residual graph
        vector<bool> reachable(n, false);
        queue<int> q;
        q.push(s);
        reachable[s] = true;
        
        while (!q.empty()) {
            int u = q.front(); q.pop();
            for (int v : adj[u]) {
                if (!reachable[v] && capacity[u][v] > 0) {
                    reachable[v] = true;
                    q.push(v);
                }
            }
        }
        
        // Find cut edges (from reachable to non-reachable)
        vector<pair<int,int>> cutEdges;
        for (int u = 0; u < n; u++) {
            if (reachable[u]) {
                for (int v : adj[u]) {
                    if (!reachable[v] && capacity[u][v] == 0) {
                        cutEdges.push_back({u, v});
                    }
                }
            }
        }
        return cutEdges;
    }
};

int main() {
    EdmondsKarp ek(6);
    
    // s=0, t=5
    ek.addEdge(0, 1, 16);
    ek.addEdge(0, 2, 13);
    ek.addEdge(1, 2, 10);
    ek.addEdge(1, 3, 12);
    ek.addEdge(2, 1, 4);
    ek.addEdge(2, 4, 14);
    ek.addEdge(3, 2, 9);
    ek.addEdge(3, 5, 20);
    ek.addEdge(4, 3, 7);
    ek.addEdge(4, 5, 4);
    
    cout << "Maximum Flow: " << ek.maxFlow(0, 5) << endl; // 23
    
    return 0;
}
```

### Dry Run (Edmonds-Karp)

```
Graph: s=0, t=5
Edges with capacities as above.

BFS Iteration 1:
  BFS from 0: Queue = [(0, INF)]
  Visit 1: parent[1]=0, flow = min(INF, 16) = 16
  Visit 2: parent[2]=0, flow = min(INF, 13) = 13
  From 1: Visit 3, parent[3]=1, flow = min(16, 12) = 12
  From 2: Visit 4, parent[4]=2, flow = min(13, 14) = 13
  From 3: Visit 5! parent[5]=3, flow = min(12, 20) = 12
  
  Path: 0→1→3→5, bottleneck = 12
  Update: cap[0][1]: 16→4, cap[1][3]: 12→0, cap[3][5]: 20→8
  Total flow = 12

BFS Iteration 2:
  BFS from 0:
  Visit 1 (cap 4), Visit 2 (cap 13)
  From 1: can't go to 3 (cap=0), go to 2 (cap 10)
  From 2: Visit 4 (cap 14)
  From 4: Visit 3 (cap 7), Visit 5! flow = min(13, 14, 4) = 4
  
  Path: 0→2→4→5, bottleneck = 4
  Update: cap[0][2]: 13→9, cap[2][4]: 14→10, cap[4][5]: 4→0
  Total flow = 16

BFS Iteration 3:
  Path: 0→2→4→3→5, bottleneck = min(9, 10, 7, 8) = 7
  Total flow = 23

BFS Iteration 4:
  No augmenting path found.

Maximum Flow = 23
```

### Complexity

| Aspect | Value |
|--------|-------|
| Time | O(V × E²) |
| Space | O(V² + E) |
| Practical | Good for moderate graphs |

---

## Dinic's Algorithm

### Theory

Dinic's (Dinitz) algorithm improves upon Edmonds-Karp by using **level graphs** and **blocking flows**. It finds max flow in O(V²E) time.

### Key Ideas

```
1. Build LEVEL GRAPH using BFS (distance layers from source)
2. Find BLOCKING FLOW in level graph using DFS
3. Repeat until no path exists from s to t

A blocking flow saturates at least one edge on every s→t path
in the level graph.
```

### C++ Implementation (Efficient with Edge List)

```cpp
#include <bits/stdc++.h>
using namespace std;

struct FlowEdge {
    int to, rev;    // destination, index of reverse edge
    long long cap;  // residual capacity
};

class Dinic {
    int n;
    vector<vector<FlowEdge>> graph;
    vector<int> level, iter;
    
    bool bfs(int s, int t) {
        level.assign(n, -1);
        queue<int> q;
        level[s] = 0;
        q.push(s);
        
        while (!q.empty()) {
            int v = q.front(); q.pop();
            for (auto& e : graph[v]) {
                if (e.cap > 0 && level[e.to] < 0) {
                    level[e.to] = level[v] + 1;
                    q.push(e.to);
                }
            }
        }
        return level[t] >= 0;
    }
    
    long long dfs(int v, int t, long long pushed) {
        if (v == t) return pushed;
        for (int& i = iter[v]; i < graph[v].size(); i++) {
            FlowEdge& e = graph[v][i];
            if (e.cap > 0 && level[v] < level[e.to]) {
                long long d = dfs(e.to, t, min(pushed, e.cap));
                if (d > 0) {
                    e.cap -= d;
                    graph[e.to][e.rev].cap += d;
                    return d;
                }
            }
        }
        return 0;
    }
    
public:
    Dinic(int n) : n(n), graph(n), level(n), iter(n) {}
    
    void addEdge(int from, int to, long long cap) {
        graph[from].push_back({to, (int)graph[to].size(), cap});
        graph[to].push_back({from, (int)graph[from].size() - 1, 0});
    }
    
    long long maxFlow(int s, int t) {
        long long flow = 0;
        while (bfs(s, t)) {
            iter.assign(n, 0);
            long long pushed;
            while ((pushed = dfs(s, t, LLONG_MAX)) > 0) {
                flow += pushed;
            }
        }
        return flow;
    }
};

int main() {
    Dinic dinic(6);
    
    dinic.addEdge(0, 1, 16);
    dinic.addEdge(0, 2, 13);
    dinic.addEdge(1, 2, 10);
    dinic.addEdge(1, 3, 12);
    dinic.addEdge(2, 1, 4);
    dinic.addEdge(2, 4, 14);
    dinic.addEdge(3, 2, 9);
    dinic.addEdge(3, 5, 20);
    dinic.addEdge(4, 3, 7);
    dinic.addEdge(4, 5, 4);
    
    cout << "Maximum Flow (Dinic): " << dinic.maxFlow(0, 5) << endl; // 23
    
    return 0;
}
```

### Complexity

| Aspect | Value |
|--------|-------|
| Time (general) | O(V² × E) |
| Time (unit capacity) | O(E × √V) |
| Time (bipartite matching) | O(E × √V) |
| Space | O(V + E) |

---

## Applications

### 1. Bipartite Matching

```
Model: Source → left vertices → right vertices → sink
All edges have capacity 1.
Max flow = maximum matching.

     s --1--> L1 --1--> R1 --1--> t
     s --1--> L2 --1--> R2 --1--> t
     (with appropriate connections between L and R)
```

### 2. Minimum Cut Applications

```
• Image segmentation (foreground/background)
• Network reliability (minimum edges to disconnect)
• Project selection (max profit with dependencies)
```

### 3. Edge-Disjoint Paths

```
Max number of edge-disjoint s→t paths = max flow with unit capacities.
```

### 4. Vertex Capacity

```
Split vertex v into v_in and v_out with edge capacity = vertex capacity.
All incoming edges go to v_in, all outgoing from v_out.
```

---

## Pattern Recognition

### When to Use Network Flow

| # | Pattern | Modeling |
|---|---------|---------|
| 1 | Maximum matching in bipartite graph | Unit capacity flow |
| 2 | Minimum edge cut | Max flow = min cut |
| 3 | Maximum edge-disjoint paths | Unit capacity max flow |
| 4 | Maximum vertex-disjoint paths | Vertex splitting + flow |
| 5 | Assignment problem | Bipartite flow |
| 6 | Project selection | Min cut |
| 7 | Circulation with demands | Add super source/sink |
| 8 | Minimum path cover in DAG | N - max matching |
| 9 | Maximum closure | Min cut |
| 10 | Baseball elimination | Max flow modeling |
| 11 | Scheduling | Flow with constraints |
| 12 | Image segmentation | Min cut |
| 13 | Airline crew scheduling | Flow |
| 14 | Transportation problem | Flow network |
| 15 | Maximum flow with lower bounds | Circulation |

### Reduction Tricks

```
• Multiple sources/sinks: Add super source/sink
• Vertex capacity: Split vertex
• Undirected edge: Two directed edges
• Lower bound on flow: Circulation technique
• Minimum cost flow: Successive shortest path
```

---

## Problem Solving

### Practice Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Maximum Flow | CSES | Basic Edmonds-Karp |
| 2 | Minimum Cut | CSES | Max-flow min-cut |
| 3 | Download Speed | CSES | Max flow |
| 4 | Police Chase | CSES | Min cut, edge disjoint |
| 5 | School Dance | CSES | Bipartite matching via flow |
| 6 | Max Flow | SPOJ FASTFLOW | Dinic's |
| 7 | Soldiers | LeetCode/CF | Vertex cover |
| 8 | Network Flow | HackerRank | Implementation |
| 9 | Maximum Bipartite Matching | GFG | Flow-based matching |
| 10 | Project Selection | Codeforces | Min cut |
| 11 | Escape Problem | Various | Grid flow |
| 12 | Baseball Elimination | Princeton | Flow modeling |
| 13 | Minimum Path Cover | Various | DAG + matching |
| 14 | K-edge Connectivity | Various | Min cut |
| 15 | Airline Scheduling | Various | Flow |

---

## Interview Preparation

### Top Questions

1. What is network flow? Define max flow problem.
2. What is the max-flow min-cut theorem? Prove it.
3. Explain Ford-Fulkerson method.
4. Why do we need residual edges?
5. What's the difference between Ford-Fulkerson and Edmonds-Karp?
6. Explain Dinic's algorithm and its advantages.
7. How to model bipartite matching as flow?
8. How to handle multiple sources/sinks?
9. How to handle vertex capacities?
10. Time complexity comparison of flow algorithms.
11. What is a blocking flow?
12. What is a level graph?
13. How to find minimum cut from max flow?
14. Applications of network flow in real world.
15. How to handle undirected edges in flow networks?

---

## Competitive Programming

### Dinic's Template (Standard)

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Edge {
    int to, rev;
    long long cap;
};

struct Dinic {
    vector<vector<Edge>> graph;
    vector<int> level, iter;
    int n;
    
    Dinic(int n) : n(n), graph(n), level(n), iter(n) {}
    
    void addEdge(int from, int to, long long cap) {
        graph[from].push_back({to, (int)graph[to].size(), cap});
        graph[to].push_back({from, (int)graph[from].size() - 1, 0});
    }
    
    bool bfs(int s, int t) {
        level.assign(n, -1);
        queue<int> q;
        level[s] = 0;
        q.push(s);
        while (!q.empty()) {
            int v = q.front(); q.pop();
            for (auto& e : graph[v])
                if (e.cap > 0 && level[e.to] < 0)
                    level[e.to] = level[v] + 1, q.push(e.to);
        }
        return level[t] >= 0;
    }
    
    long long dfs(int v, int t, long long f) {
        if (v == t) return f;
        for (int& i = iter[v]; i < (int)graph[v].size(); i++) {
            Edge& e = graph[v][i];
            if (e.cap > 0 && level[v] < level[e.to]) {
                long long d = dfs(e.to, t, min(f, e.cap));
                if (d > 0) { e.cap -= d; graph[e.to][e.rev].cap += d; return d; }
            }
        }
        return 0;
    }
    
    long long maxflow(int s, int t) {
        long long flow = 0;
        while (bfs(s, t)) {
            iter.assign(n, 0);
            long long d;
            while ((d = dfs(s, t, LLONG_MAX)) > 0) flow += d;
        }
        return flow;
    }
};
```

---

## Cheat Sheet

```
NETWORK FLOW SUMMARY:
• Source s → Sink t through capacitated edges
• Max-Flow = Min-Cut (fundamental theorem)

ALGORITHMS:
• Ford-Fulkerson: DFS augmenting paths, O(E × maxflow)
• Edmonds-Karp: BFS augmenting paths, O(VE²)
• Dinic's: Level graph + blocking flow, O(V²E)

KEY MODELING TRICKS:
• Multiple sources/sinks → super source/sink
• Vertex capacity → split into v_in, v_out
• Undirected edge → two directed edges
• Bipartite matching → unit capacity flow

APPLICATIONS:
• Maximum bipartite matching
• Minimum edge/vertex cut
• Edge-disjoint paths
• Project selection (max closure)
• Image segmentation

MIN-CUT FINDING:
After max flow, BFS from source in residual graph.
Reachable = S, Unreachable = T.
Cut edges = saturated edges from S to T.
```
