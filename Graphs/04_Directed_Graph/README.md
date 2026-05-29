# Directed Graph Algorithms

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [DAG and Topological Sort (DFS)](#dag-and-topological-sort-dfs)
- [Topological Sort Using BFS (Kahn's Algorithm)](#topological-sort-using-bfs-kahns-algorithm)
- [Cycle Detection in Directed Graph](#cycle-detection-in-directed-graph)
- [Strongly Connected Components (Kosaraju's Algorithm)](#strongly-connected-components-kosarajus-algorithm)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Cheat Sheet](#cheat-sheet)

---

## Introduction

### What are Directed Graph Algorithms?

In directed graphs (digraphs), edges have a direction - edge (u, v) means you can go from u to v but NOT necessarily from v to u. This asymmetry gives rise to unique problems and algorithms that don't exist in undirected graphs.

### Key Concepts Covered

1. **DAGs & Topological Sort (DFS)** - Ordering vertices in dependency order
2. **Topological Sort (BFS/Kahn's)** - Alternative approach using in-degrees
3. **Cycle Detection (Directed)** - Different from undirected; uses coloring
4. **Strongly Connected Components** - Maximal sets of mutually reachable vertices

### Why Important?

- Task scheduling, build systems, course prerequisites → Topological Sort
- Deadlock detection → Cycle Detection
- Compiler optimization, circuit analysis → SCC

---

## Prerequisites

- [01_Introduction](../01_Introduction/README.md) - Graph basics
- [02_Traversals](../02_Traversals/README.md) - BFS and DFS
- [03_Undirected_Graph](../03_Undirected_Graph/README.md) - Undirected cycle detection (for comparison)

---

## DAG and Topological Sort (DFS)

### What is a DAG?

A **Directed Acyclic Graph (DAG)** is a directed graph with no directed cycles. DAGs are fundamental in representing dependencies.

```
DAG example:               NOT a DAG (has cycle):
    0 → 1 → 3                 0 → 1
    ↓   ↓                     ↑   ↓
    2 → 4                     3 ← 2

In the right graph: 0→1→2→3→0 forms a cycle
```

### What is Topological Sort?

A **topological ordering** of a DAG is a linear ordering of its vertices such that for every directed edge (u, v), vertex u comes before v in the ordering.

```
If there's edge u → v, then u appears BEFORE v in the ordering.
```

**Key Property**: Topological sort exists if and only if the graph is a DAG (no directed cycles).

### Why Does Topological Sort Matter?

| Application | Vertices | Edges (Dependencies) |
|-------------|----------|---------------------|
| Course scheduling | Courses | Prerequisites |
| Build systems (make) | Files/targets | Dependencies |
| Package managers (npm) | Packages | Dependencies |
| Task scheduling | Tasks | Must-do-before |
| Spreadsheet evaluation | Cells | Formula references |
| Compilation order | Source files | #include |

### Visual Example

```
Course prerequisites:
  Calculus I → Calculus II → Calculus III
  Linear Algebra → Machine Learning
  Calculus II → Machine Learning
  Programming → Data Structures → Algorithms

Graph:
  Calc1 → Calc2 → Calc3
              ↓
  LinAlg → ML
  
  Prog → DS → Algo

Valid topological orders:
  [Calc1, Prog, LinAlg, Calc2, DS, Calc3, ML, Algo]
  [Prog, Calc1, LinAlg, DS, Calc2, Algo, ML, Calc3]
  (Many valid orderings exist!)
```

### DFS-Based Topological Sort

**Intuition**: In DFS, when we finish processing a vertex (all descendants explored), we push it to a stack. The stack gives reverse topological order.

**Why it works**: A vertex is finished ONLY after all vertices reachable from it are finished. So it will appear BEFORE all its dependencies in the reversed stack.

### Algorithm

```
TopologicalSort(graph):
    stack S
    visited = [false] * V
    
    for each vertex v:
        if not visited[v]:
            dfs(v, visited, S, graph)
    
    while S not empty:
        print S.top()
        S.pop()

dfs(u, visited, stack, graph):
    visited[u] = true
    for each neighbor v of u:
        if not visited[v]:
            dfs(v, visited, stack, graph)
    stack.push(u)  // Push AFTER processing all neighbors
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class TopologicalSort {
    int V;
    vector<vector<int>> adj;
    
public:
    TopologicalSort(int v) : V(v), adj(v) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);  // Directed edge u → v
    }
    
    void dfs(int u, vector<bool>& visited, stack<int>& stk) {
        visited[u] = true;
        
        for (int v : adj[u]) {
            if (!visited[v]) {
                dfs(v, visited, stk);
            }
        }
        
        stk.push(u);  // Push after all descendants processed
    }
    
    vector<int> topSort() {
        vector<bool> visited(V, false);
        stack<int> stk;
        
        for (int i = 0; i < V; i++) {
            if (!visited[i]) {
                dfs(i, visited, stk);
            }
        }
        
        vector<int> order;
        while (!stk.empty()) {
            order.push_back(stk.top());
            stk.pop();
        }
        
        return order;
    }
};

int main() {
    TopologicalSort g(6);
    g.addEdge(5, 2);
    g.addEdge(5, 0);
    g.addEdge(4, 0);
    g.addEdge(4, 1);
    g.addEdge(2, 3);
    g.addEdge(3, 1);
    
    vector<int> order = g.topSort();
    
    cout << "Topological Order: ";
    for (int v : order) cout << v << " ";
    cout << endl;
    // Output: 5 4 2 3 1 0 (one valid ordering)
    
    return 0;
}
```

### Dry Run

```
Graph:
  5 → 2 → 3 → 1
  5 → 0
  4 → 0
  4 → 1

adj[0] = []
adj[1] = []
adj[2] = [3]
adj[3] = [1]
adj[4] = [0, 1]
adj[5] = [2, 0]

DFS Topological Sort:

Start i=0: not visited
  DFS(0): visited[0]=true, no neighbors, push 0
  Stack: [0]

i=1: not visited
  DFS(1): visited[1]=true, no neighbors, push 1
  Stack: [0, 1]

i=2: not visited
  DFS(2): visited[2]=true
    neighbor 3: not visited
    DFS(3): visited[3]=true
      neighbor 1: already visited, skip
      push 3
      Stack: [0, 1, 3]
    push 2
    Stack: [0, 1, 3, 2]

i=3: already visited, skip
i=4: not visited
  DFS(4): visited[4]=true
    neighbor 0: already visited, skip
    neighbor 1: already visited, skip
    push 4
    Stack: [0, 1, 3, 2, 4]

i=5: not visited
  DFS(5): visited[5]=true
    neighbor 2: already visited, skip
    neighbor 0: already visited, skip
    push 5
    Stack: [0, 1, 3, 2, 4, 5]

Pop from stack: 5, 4, 2, 3, 1, 0
Topological Order: [5, 4, 2, 3, 1, 0]

Verify: 
  5→2: 5 before 2 ✓
  5→0: 5 before 0 ✓
  4→0: 4 before 0 ✓
  4→1: 4 before 1 ✓
  2→3: 2 before 3 ✓
  3→1: 3 before 1 ✓
```

### Complexity

| Aspect | Value |
|--------|-------|
| Time | O(V + E) |
| Space | O(V) for visited + O(V) for stack + O(V) for recursion |

---

## Topological Sort Using BFS (Kahn's Algorithm)

### Theory

Kahn's algorithm uses the concept of **in-degree** (number of incoming edges) to find topological order.

**Key Insight**: A vertex with in-degree 0 has no prerequisites → it can be processed first.

### Intuition

```
1. Find all vertices with in-degree 0 (no dependencies)
2. Process them (they can go first)
3. Remove them from graph (reduce in-degrees of their neighbors)
4. Repeat: find new vertices with in-degree 0
5. If all vertices processed → valid topological order
6. If some vertices remain (in-degree never becomes 0) → CYCLE exists!
```

### Visual Walk-through

```
Graph:
  5 → 2 → 3 → 1
  5 → 0
  4 → 0
  4 → 1

In-degrees: [2, 2, 1, 1, 0, 0]
            (0  1  2  3  4  5)

Step 1: Vertices with in-degree 0: {4, 5}
  Process 4: reduce in-degree of 0 and 1
  Process 5: reduce in-degree of 2 and 0
  In-degrees: [0, 1, 0, 1, -, -]
  Order so far: [4, 5]

Step 2: Vertices with in-degree 0: {0, 2}
  Process 0: no outgoing edges
  Process 2: reduce in-degree of 3
  In-degrees: [-, 1, -, 0, -, -]
  Order so far: [4, 5, 0, 2]

Step 3: Vertices with in-degree 0: {3}
  Process 3: reduce in-degree of 1
  In-degrees: [-, 0, -, -, -, -]
  Order so far: [4, 5, 0, 2, 3]

Step 4: Vertices with in-degree 0: {1}
  Process 1: no outgoing edges
  Order so far: [4, 5, 0, 2, 3, 1]

All vertices processed! Valid topological order: [4, 5, 0, 2, 3, 1]
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class KahnTopSort {
    int V;
    vector<vector<int>> adj;
    
public:
    KahnTopSort(int v) : V(v), adj(v) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
    }
    
    // Returns topological order, or empty vector if cycle exists
    vector<int> topSort() {
        vector<int> inDegree(V, 0);
        
        // Calculate in-degrees
        for (int u = 0; u < V; u++) {
            for (int v : adj[u]) {
                inDegree[v]++;
            }
        }
        
        // Add all vertices with in-degree 0 to queue
        queue<int> q;
        for (int i = 0; i < V; i++) {
            if (inDegree[i] == 0) {
                q.push(i);
            }
        }
        
        vector<int> order;
        
        while (!q.empty()) {
            int u = q.front();
            q.pop();
            order.push_back(u);
            
            // Reduce in-degree of neighbors
            for (int v : adj[u]) {
                inDegree[v]--;
                if (inDegree[v] == 0) {
                    q.push(v);
                }
            }
        }
        
        // If not all vertices included, there's a cycle
        if (order.size() != V) {
            return {};  // Cycle detected!
        }
        
        return order;
    }
    
    // Check if topological sort is possible (i.e., graph is DAG)
    bool isDAG() {
        return topSort().size() == V;
    }
};

// LeetCode 210: Course Schedule II
class Solution {
public:
    vector<int> findOrder(int numCourses, vector<vector<int>>& prerequisites) {
        vector<vector<int>> adj(numCourses);
        vector<int> inDegree(numCourses, 0);
        
        for (auto& p : prerequisites) {
            adj[p[1]].push_back(p[0]);  // p[1] → p[0]
            inDegree[p[0]]++;
        }
        
        queue<int> q;
        for (int i = 0; i < numCourses; i++) {
            if (inDegree[i] == 0) q.push(i);
        }
        
        vector<int> order;
        while (!q.empty()) {
            int u = q.front(); q.pop();
            order.push_back(u);
            
            for (int v : adj[u]) {
                if (--inDegree[v] == 0) {
                    q.push(v);
                }
            }
        }
        
        return order.size() == numCourses ? order : vector<int>{};
    }
};

int main() {
    KahnTopSort g(6);
    g.addEdge(5, 2);
    g.addEdge(5, 0);
    g.addEdge(4, 0);
    g.addEdge(4, 1);
    g.addEdge(2, 3);
    g.addEdge(3, 1);
    
    vector<int> order = g.topSort();
    
    if (order.empty()) {
        cout << "Cycle detected! No topological order." << endl;
    } else {
        cout << "Topological Order (Kahn's): ";
        for (int v : order) cout << v << " ";
        cout << endl;
    }
    
    return 0;
}
```

### DFS vs Kahn's Comparison

| Feature | DFS-based | Kahn's (BFS) |
|---------|-----------|--------------|
| Data Structure | Stack + Recursion | Queue + In-degree array |
| Cycle Detection | Needs separate check | Built-in (incomplete order = cycle) |
| Implementation | Recursive | Iterative |
| Unique Sort | Uses priority queue for lexicographic | Use min-heap for lexicographic |
| Parallel Processing | Harder | Easy (all in-degree 0 nodes are parallel) |

### Lexicographically Smallest Topological Sort

```cpp
// Use priority_queue (min-heap) instead of regular queue
vector<int> lexSmallestTopSort(vector<vector<int>>& adj, int n) {
    vector<int> inDegree(n, 0);
    for (int u = 0; u < n; u++)
        for (int v : adj[u])
            inDegree[v]++;
    
    priority_queue<int, vector<int>, greater<int>> pq; // min-heap
    for (int i = 0; i < n; i++)
        if (inDegree[i] == 0) pq.push(i);
    
    vector<int> order;
    while (!pq.empty()) {
        int u = pq.top(); pq.pop();
        order.push_back(u);
        for (int v : adj[u])
            if (--inDegree[v] == 0) pq.push(v);
    }
    
    return order;
}
```

---

## Cycle Detection in Directed Graph

### Theory

Cycle detection in directed graphs is fundamentally different from undirected graphs. In undirected graphs, we check if a visited neighbor is not the parent. In directed graphs, we use a **three-color scheme**:

```
WHITE (0): Vertex not yet visited
GRAY  (1): Vertex is being processed (in current DFS path)
BLACK (2): Vertex is completely processed

A cycle exists if we encounter a GRAY vertex during DFS!
(GRAY vertex = ancestor in current path = back edge = cycle)
```

### Why is Directed Cycle Detection Different?

```
Consider:
    1 → 3
    2 → 3

In undirected graph: this has no cycle (it's a tree/forest)
In directed graph: this also has no cycle

But consider:
    1 → 2
    ↑   ↓
    3 ← 

If we DFS from 1: visit 1(gray), visit 2(gray), visit 3(gray), 
  neighbor of 3 is 1 which is GRAY → CYCLE!

vs:
    1 → 2 → 3
    ↓       
    4 → 3   

DFS from 1: visit 1(gray), visit 2(gray), visit 3(gray→black)
  Backtrack: 2(black), try 4(gray), neighbor 3 is BLACK not gray → NO cycle on this path

This is why we need 3 colors:
- Visiting a BLACK node (fully processed) is fine
- Visiting a GRAY node (in current path) means cycle
```

### Visual Example

```
Graph WITH cycle:           Graph WITHOUT cycle:
    0 → 1                      0 → 1
    ↑   ↓                      ↓   ↓
    3 ← 2                      2 → 3

DFS from 0:                 DFS from 0:
0(gray)→1(gray)→2(gray)    0(gray)→1(gray)→3(gray→black)
→3(gray)→0 is GRAY!CYCLE!  back→1(black)
                            →2(gray)→3 is BLACK, OK
                            →2(black)→0(black)
                            No cycle!
```

### C++ Implementation (DFS Three-Coloring)

```cpp
#include <bits/stdc++.h>
using namespace std;

class DirectedCycleDetection {
    int V;
    vector<vector<int>> adj;
    
    enum Color { WHITE, GRAY, BLACK };
    
public:
    DirectedCycleDetection(int v) : V(v), adj(v) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
    }
    
    // DFS with 3-color marking
    bool dfs(int u, vector<int>& color) {
        color[u] = GRAY;  // Currently being processed
        
        for (int v : adj[u]) {
            if (color[v] == GRAY) {
                return true;  // Back edge = CYCLE!
            }
            if (color[v] == WHITE) {
                if (dfs(v, color)) return true;
            }
            // BLACK vertices: already fully processed, skip
        }
        
        color[u] = BLACK;  // Done processing
        return false;
    }
    
    bool hasCycle() {
        vector<int> color(V, WHITE);
        
        for (int i = 0; i < V; i++) {
            if (color[i] == WHITE) {
                if (dfs(i, color)) return true;
            }
        }
        
        return false;
    }
    
    // Find one cycle (returns the cycle path)
    vector<int> findCycle() {
        vector<int> color(V, WHITE);
        vector<int> parent(V, -1);
        int cycleStart = -1, cycleEnd = -1;
        
        function<bool(int)> dfs = [&](int u) -> bool {
            color[u] = GRAY;
            for (int v : adj[u]) {
                if (color[v] == GRAY) {
                    cycleEnd = u;
                    cycleStart = v;
                    return true;
                }
                if (color[v] == WHITE) {
                    parent[v] = u;
                    if (dfs(v)) return true;
                }
            }
            color[u] = BLACK;
            return false;
        };
        
        for (int i = 0; i < V; i++) {
            if (color[i] == WHITE && dfs(i)) break;
        }
        
        if (cycleStart == -1) return {};
        
        vector<int> cycle;
        cycle.push_back(cycleStart);
        for (int v = cycleEnd; v != cycleStart; v = parent[v]) {
            cycle.push_back(v);
        }
        cycle.push_back(cycleStart);
        reverse(cycle.begin(), cycle.end());
        
        return cycle;
    }
};

// LeetCode 207: Course Schedule
class Solution {
public:
    bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
        vector<vector<int>> adj(numCourses);
        for (auto& p : prerequisites) {
            adj[p[1]].push_back(p[0]);
        }
        
        vector<int> color(numCourses, 0); // 0=white, 1=gray, 2=black
        
        function<bool(int)> hasCycle = [&](int u) -> bool {
            color[u] = 1;
            for (int v : adj[u]) {
                if (color[v] == 1) return true;
                if (color[v] == 0 && hasCycle(v)) return true;
            }
            color[u] = 2;
            return false;
        };
        
        for (int i = 0; i < numCourses; i++) {
            if (color[i] == 0 && hasCycle(i)) return false;
        }
        
        return true;
    }
};

int main() {
    // Graph with cycle: 0→1→2→0
    DirectedCycleDetection g1(3);
    g1.addEdge(0, 1);
    g1.addEdge(1, 2);
    g1.addEdge(2, 0);
    cout << "Graph 1 has cycle: " << g1.hasCycle() << endl; // true
    
    // DAG: 0→1→2, 0→2
    DirectedCycleDetection g2(3);
    g2.addEdge(0, 1);
    g2.addEdge(1, 2);
    g2.addEdge(0, 2);
    cout << "Graph 2 has cycle: " << g2.hasCycle() << endl; // false
    
    return 0;
}
```

### Cycle Detection Using Kahn's Algorithm

```cpp
// If Kahn's topological sort doesn't process all vertices → CYCLE exists
bool hasCycleKahns(vector<vector<int>>& adj, int n) {
    vector<int> inDegree(n, 0);
    for (int u = 0; u < n; u++)
        for (int v : adj[u])
            inDegree[v]++;
    
    queue<int> q;
    for (int i = 0; i < n; i++)
        if (inDegree[i] == 0) q.push(i);
    
    int processed = 0;
    while (!q.empty()) {
        int u = q.front(); q.pop();
        processed++;
        for (int v : adj[u])
            if (--inDegree[v] == 0) q.push(v);
    }
    
    return processed != n;  // true if cycle exists
}
```

### Dry Run (Three-Coloring)

```
Graph: 0→1→2→3→1 (cycle: 1→2→3→1)

adj[0] = [1]
adj[1] = [2]
adj[2] = [3]
adj[3] = [1]

DFS from 0:
  color[0] = GRAY
  Visit neighbor 1:
    color[1] = GRAY
    Visit neighbor 2:
      color[2] = GRAY
      Visit neighbor 3:
        color[3] = GRAY
        Visit neighbor 1:
          color[1] == GRAY → CYCLE DETECTED!
          Return true

Cycle found: 1 → 2 → 3 → 1
```

---

## Strongly Connected Components (Kosaraju's Algorithm)

### Theory

A **Strongly Connected Component (SCC)** of a directed graph is a maximal set of vertices such that there is a directed path from every vertex to every other vertex in the set.

```
Graph:
    0 → 1 → 2      7 → 8
    ↑   ↓   ↓      ↑
    3 ← 4   5 → 6 → 

SCCs: {0, 1, 3, 4}, {2, 5, 6}, {7, 8}

Within {0,1,3,4}: 0→1→4→3→0 (all can reach all)
Within {2,5,6}: 2→5→6→... (need to verify all paths exist)
```

### Why SCCs Matter

1. **Condensation Graph**: Replace each SCC with single node → DAG
2. **2-SAT**: Solve using SCC decomposition
3. **Reachability**: If two nodes are in same SCC, they can reach each other
4. **Network Analysis**: Find strongly connected clusters

### Kosaraju's Algorithm

**Three-step algorithm:**

```
Step 1: Perform DFS on original graph, store finish order in stack
Step 2: Create TRANSPOSE (reverse) of the graph
Step 3: Process vertices from stack, run DFS on transpose graph
        Each DFS from step 3 gives one SCC
```

### Why Kosaraju's Works (Intuition)

```
Key Insight:
- In step 1, vertices in a "later" SCC finish before vertices in an "earlier" SCC
- The transpose graph reverses all edges
- When we process in finish-order on transpose, each DFS stays within one SCC
  because:
  * Forward edges in original become backward in transpose
  * The SCC boundary edges only go one direction (after condensation is DAG)
  * Processing in reverse finish order ensures we start from "sink" SCCs

Formal: If SCC₁ has edge to SCC₂ in original graph:
  - Vertices in SCC₁ finish AFTER vertices in SCC₂
  - In transpose, edge goes SCC₂ → SCC₁
  - Processing SCC₁ first (higher finish time) won't reach SCC₂ in transpose
```

### Visual Walk-through

```
Original Graph:
    0 → 1
    ↑   ↓
    3 ← 2 → 4

Step 1: DFS on original, record finish times
  DFS from 0: 0→1→2→3(finish)→4(finish)→2(finish)→1(finish)→0(finish)
  Stack (bottom to top): [3, 4, 2, 1, 0]

Step 2: Transpose graph (reverse all edges)
    0 ← 1
    ↓   ↑
    3 → 2 ← 4

Step 3: Process stack on transpose
  Pop 0: DFS on transpose from 0
    0→3→2→1 (all reachable in transpose)
    SCC 1 = {0, 1, 2, 3}
  Pop 4: DFS on transpose from 4
    4 (only vertex reachable)
    SCC 2 = {4}

Result: Two SCCs: {0, 1, 2, 3} and {4}
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class Kosaraju {
    int V;
    vector<vector<int>> adj;
    vector<vector<int>> radj;  // Transpose graph
    
public:
    Kosaraju(int v) : V(v), adj(v), radj(v) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        radj[v].push_back(u);  // Reverse edge
    }
    
    // Step 1: DFS on original graph, fill stack with finish order
    void dfs1(int u, vector<bool>& visited, stack<int>& stk) {
        visited[u] = true;
        for (int v : adj[u]) {
            if (!visited[v]) {
                dfs1(v, visited, stk);
            }
        }
        stk.push(u);  // Push on finish
    }
    
    // Step 3: DFS on transpose graph
    void dfs2(int u, vector<bool>& visited, vector<int>& component) {
        visited[u] = true;
        component.push_back(u);
        for (int v : radj[u]) {
            if (!visited[v]) {
                dfs2(v, visited, component);
            }
        }
    }
    
    // Find all SCCs
    vector<vector<int>> findSCCs() {
        // Step 1: Fill stack with finish order
        vector<bool> visited(V, false);
        stack<int> stk;
        
        for (int i = 0; i < V; i++) {
            if (!visited[i]) {
                dfs1(i, visited, stk);
            }
        }
        
        // Step 2: Transpose is already built (radj)
        
        // Step 3: DFS on transpose in stack order
        fill(visited.begin(), visited.end(), false);
        vector<vector<int>> sccs;
        
        while (!stk.empty()) {
            int u = stk.top();
            stk.pop();
            
            if (!visited[u]) {
                vector<int> component;
                dfs2(u, visited, component);
                sccs.push_back(component);
            }
        }
        
        return sccs;
    }
    
    // Get SCC id for each vertex
    vector<int> getSCCIds() {
        auto sccs = findSCCs();
        vector<int> sccId(V);
        for (int i = 0; i < sccs.size(); i++) {
            for (int v : sccs[i]) {
                sccId[v] = i;
            }
        }
        return sccId;
    }
    
    // Build condensation graph (DAG of SCCs)
    vector<vector<int>> condensation() {
        auto sccId = getSCCIds();
        int numSCCs = *max_element(sccId.begin(), sccId.end()) + 1;
        
        set<pair<int,int>> edges;
        vector<vector<int>> dag(numSCCs);
        
        for (int u = 0; u < V; u++) {
            for (int v : adj[u]) {
                if (sccId[u] != sccId[v]) {
                    if (edges.insert({sccId[u], sccId[v]}).second) {
                        dag[sccId[u]].push_back(sccId[v]);
                    }
                }
            }
        }
        
        return dag;
    }
};

int main() {
    Kosaraju g(8);
    // SCC1: {0, 1, 2}
    g.addEdge(0, 1);
    g.addEdge(1, 2);
    g.addEdge(2, 0);
    // SCC2: {3, 4}
    g.addEdge(3, 4);
    g.addEdge(4, 3);
    // SCC3: {5, 6, 7}
    g.addEdge(5, 6);
    g.addEdge(6, 7);
    g.addEdge(7, 5);
    // Cross-SCC edges
    g.addEdge(2, 3);
    g.addEdge(4, 5);
    
    auto sccs = g.findSCCs();
    
    cout << "Number of SCCs: " << sccs.size() << endl;
    for (int i = 0; i < sccs.size(); i++) {
        cout << "SCC " << i << ": ";
        for (int v : sccs[i]) cout << v << " ";
        cout << endl;
    }
    
    return 0;
}
```

### Detailed Dry Run

```
Graph:
  0 → 1 → 2 → 0  (SCC: {0,1,2})
  2 → 3 → 4 → 3  (SCC: {3,4})
  4 → 5 → 6 → 7 → 5  (SCC: {5,6,7})

adj[0]=[1], adj[1]=[2], adj[2]=[0,3]
adj[3]=[4], adj[4]=[3,5]
adj[5]=[6], adj[6]=[7], adj[7]=[5]

radj[0]=[2], radj[1]=[0], radj[2]=[1]
radj[3]=[2,4], radj[4]=[3]
radj[5]=[4,7], radj[6]=[5], radj[7]=[6]

=== STEP 1: DFS on original, build finish-order stack ===

DFS(0):
  0→1→2→0(visited)
       2→3→4→3(visited)
            4→5→6→7→5(visited)
               7 finish → push 7
            6 finish → push 6
         5 finish → push 5
      4 finish → push 4
   3 finish → push 3
  2 finish → push 2
 1 finish → push 1
0 finish → push 0

Stack (top to bottom): [0, 1, 2, 3, 4, 5, 6, 7]

=== STEP 3: DFS on TRANSPOSE in stack order ===

Pop 0: DFS on transpose from 0
  radj[0] = [2]: visit 2
    radj[2] = [1]: visit 1
      radj[1] = [0]: already visited
    1 done
  2 done
  SCC 1 = {0, 2, 1}

Pop 1: already visited, skip
Pop 2: already visited, skip

Pop 3: DFS on transpose from 3
  radj[3] = [2, 4]: 2 visited, visit 4
    radj[4] = [3]: already visited
  SCC 2 = {3, 4}

Pop 4: already visited, skip

Pop 5: DFS on transpose from 5
  radj[5] = [4, 7]: 4 visited, visit 7
    radj[7] = [6]: visit 6
      radj[6] = [5]: already visited
  SCC 3 = {5, 7, 6}

Final SCCs: {0,1,2}, {3,4}, {5,6,7}
```

### Complexity Analysis

| Aspect | Value |
|--------|-------|
| Time | O(V + E) - two DFS passes |
| Space | O(V + E) - storing transpose graph |

### Tarjan's Algorithm (Alternative for SCC)

```cpp
// Tarjan's SCC - single pass, no transpose needed
class TarjanSCC {
    int V, timer_val = 0, sccCount = 0;
    vector<vector<int>> adj;
    vector<int> disc, low, sccId;
    vector<bool> onStack;
    stack<int> stk;
    
public:
    TarjanSCC(int v) : V(v), adj(v), disc(v, -1), low(v), sccId(v, -1), onStack(v, false) {}
    
    void addEdge(int u, int v) { adj[u].push_back(v); }
    
    void dfs(int u) {
        disc[u] = low[u] = timer_val++;
        stk.push(u);
        onStack[u] = true;
        
        for (int v : adj[u]) {
            if (disc[v] == -1) {
                dfs(v);
                low[u] = min(low[u], low[v]);
            } else if (onStack[v]) {
                low[u] = min(low[u], disc[v]);
            }
        }
        
        // If u is root of SCC
        if (low[u] == disc[u]) {
            while (true) {
                int v = stk.top(); stk.pop();
                onStack[v] = false;
                sccId[v] = sccCount;
                if (v == u) break;
            }
            sccCount++;
        }
    }
    
    vector<int> findSCCIds() {
        for (int i = 0; i < V; i++)
            if (disc[i] == -1) dfs(i);
        return sccId;
    }
};
```

---

## Pattern Recognition

### How To Identify Directed Graph Problems

#### Topological Sort Indicators:
1. "Order of tasks with dependencies"
2. "Course prerequisites schedule"
3. "Build order"
4. "Alien dictionary" (order of characters)
5. "Can all tasks be completed?"
6. "Longest path in DAG"
7. "Number of ways in DAG"

#### Directed Cycle Detection Indicators:
8. "Can all courses be finished?"
9. "Deadlock detection"
10. "Circular dependency"
11. "Valid schedule possible?"
12. "Is it a DAG?"

#### SCC Indicators:
13. "Mutually reachable vertices"
14. "Equivalent states"
15. "2-SAT problem"
16. "Condensation of graph"
17. "Can all nodes reach all others?" (single SCC)
18. "Minimum edges to make strongly connected"

#### 30+ Patterns:
19. "Sequence of courses" → Topological sort
20. "Parallel task scheduling" → Topological sort + levels
21. "Critical path" → Longest path in DAG (topological sort + DP)
22. "Minimum semesters" → Topological sort levels
23. "Recipe dependencies" → Topological sort
24. "Compilation order" → Topological sort
25. "Is permutation sortable?" → Cycle structure
26. "Find safe nodes" → Reverse topological order
27. "Redundant dependencies" → Transitive reduction
28. "Number of paths in DAG" → DP on topological order
29. "Shortest path in DAG" → Topological sort + relaxation
30. "Can reduce to 2-SAT?" → SCC on implication graph
31. "Minimum groups with no conflict" → SCC + bipartite
32. "Internet backbone analysis" → SCC
33. "Feedback arc set" → Remove edges to break all cycles

---

## Problem Solving

### Easy Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Course Schedule | LeetCode 207 | Cycle detection |
| 2 | Course Schedule II | LeetCode 210 | Topological sort |
| 3 | Find Eventual Safe States | LeetCode 802 | Reverse topo sort |
| 4 | All Ancestors of a Node | LeetCode 2192 | DFS/BFS on DAG |
| 5 | Longest Path in DAG | GFG | Topo sort + DP |
| 6 | Topological Sort | GFG | Basic implementation |
| 7 | Detect Cycle in Directed Graph | GFG | Three coloring |
| 8 | Prerequisite Tasks | GFG | Cycle detection |
| 9 | Minimum Time to Complete All Tasks | GFG | Topo + levels |
| 10 | BFS of Directed Graph | GFG | Basic BFS |
| 11 | DFS of Directed Graph | GFG | Basic DFS |
| 12 | Number of Paths | CSES (Count Paths) | DAG DP |
| 13 | Longest Flight Route | CSES | DAG DP |
| 14 | Game Routes | CSES | DAG DP |
| 15 | Restricted Walking | Codeforces | DAG traversal |
| 16 | Minimum Semesters | LeetCode 1136 | BFS levels |
| 17 | Parallel Courses | LeetCode 1136 | Kahn's + levels |
| 18 | Sort Items by Groups | LeetCode 1203 | Two-level topo sort |
| 19 | Keys and Rooms | LeetCode 841 | DFS directed |
| 20 | All Paths Source to Target | LeetCode 797 | DFS DAG paths |

### Medium Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Alien Dictionary | LeetCode 269 | Topological sort |
| 2 | Parallel Courses III | LeetCode 2050 | Topo sort + DP (max path) |
| 3 | Longest Increasing Path in Matrix | LeetCode 329 | DAG DP on grid |
| 4 | Minimum Height Trees | LeetCode 310 | Related concept |
| 5 | Sequence Reconstruction | LeetCode 444 | Unique topo sort |
| 6 | Course Schedule IV | LeetCode 1462 | Transitive closure |
| 7 | Build a Matrix With Conditions | LeetCode 2392 | Topological sort |
| 8 | Largest Color Value in Directed Graph | LeetCode 1857 | Topo + DP |
| 9 | All Paths Source to Target | LeetCode 797 | DAG DFS |
| 10 | Evaluate Division | LeetCode 399 | Weighted directed |
| 11 | Loud and Rich | LeetCode 851 | Reverse topo DFS |
| 12 | Number of Restricted Paths | LeetCode 1786 | Dijkstra + DP on DAG |
| 13 | Count Ways to Arrive at Destination | LeetCode 1976 | Dijkstra + counting |
| 14 | Minimum Cost to Reach Destination | LeetCode 1928 | DAG DP |
| 15 | Reachable Nodes in Subdivided Graph | LeetCode 882 | Dijkstra |
| 16 | Maximum Path Quality | LeetCode 2065 | DFS |
| 17 | Satisfiability of Equality | LeetCode 990 | Union-Find |
| 18 | Strongly Connected Component | GFG | Kosaraju's |
| 19 | Mother Vertex | GFG | Last finished in DFS |
| 20 | 2-SAT Problem | CSES | SCC |
| 21 | Planet Queries I | CSES | Functional graph |
| 22 | Round Trip II | CSES | Directed cycle |
| 23 | Coin Collector | CSES | SCC + DAG DP |
| 24 | Flight Routes Check | CSES | SCC (single SCC?) |
| 25 | Hamiltonian Flights | CSES | DP bitmask on DAG |
| 26 | Stamp Rally | AtCoder | Offline + DSU |
| 27 | Fox And Names | Codeforces | Topo sort |
| 28 | Learning Languages | Codeforces | Components |
| 29 | ABCD...| Codeforces | Topo sort |
| 30 | Directing Edges | CSES | DAG + orientation |

### Hard Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Parallel Courses III | LeetCode 2050 | Topo + DP |
| 2 | Longest Increasing Path in Matrix | LeetCode 329 | DAG DP |
| 3 | Largest Color Value in Graph | LeetCode 1857 | Topo + multi-DP |
| 4 | 2-SAT | CSES | SCC application |
| 5 | Coin Collector | CSES | SCC condensation + DP |
| 6 | Minimum Edges to Make Strongly Connected | Codeforces | SCC + condensation |
| 7 | Maximum Flow (using SCC) | Various | SCC application |
| 8 | Critical Edges | SPOJ | Bridges in condensation |
| 9 | Strongly Connected Digraph | UVa | SCC counting |
| 10 | Kingdom Division | HackerRank | SCC + tree DP |
| 11 | Dominator Tree | Codeforces | Advanced SCC |
| 12 | Finding Bridges Online | Codeforces | Dynamic SCC |
| 13 | Return of the Chores | Codeforces | Topo sort + greedy |
| 14 | Game on Graph | Codeforces | Game theory + cycles |
| 15 | Chef and Graph Queries | CodeChef | SCC + offline |
| 16 | Number of Topological Orderings | AtCoder | Counting (hard!) |
| 17 | Incremental SCC | Codeforces | Online algorithm |
| 18 | Feedback Vertex Set | Various | NP-hard approximation |
| 19 | Minimum Feedback Arc Set | SPOJ | NP-hard |
| 20 | DAG Reachability Queries | Various | LCA on DAG |

---

## Interview Preparation

### Top 50+ Interview Questions

1. What is a DAG? Give examples.
2. Explain topological sort. When is it possible?
3. What are the two methods of topological sort? Compare them.
4. How to detect cycle in a directed graph?
5. Why can't we use the same cycle detection as undirected graphs?
6. Explain the three-color DFS approach.
7. What is an SCC? How to find SCCs?
8. Explain Kosaraju's algorithm step by step.
9. What is the condensation graph? Why is it a DAG?
10. How is topological sort used in real-world applications?
11. Can a directed graph with a cycle have a topological sort? (No)
12. How many valid topological orderings can a DAG have?
13. What is the lexicographically smallest topological sort?
14. How to find longest path in a DAG?
15. How to count number of paths in a DAG?
16. What is 2-SAT? How does SCC help solve it?
17. What is a functional graph?
18. How to find mother vertex? (Last finished DFS vertex)
19. How to make a directed graph strongly connected with minimum edges?
20. Compare Kosaraju's vs Tarjan's SCC algorithms.
21. Implement Course Schedule (LeetCode 207).
22. Implement Course Schedule II (LeetCode 210).
23. Find the alien dictionary order.
24. Find longest increasing path in a matrix (as DAG DP).
25. Check if unique topological sort exists.
26. Find minimum number of semesters to take all courses.
27. Find all eventual safe states.
28. Implement SCC from scratch.
29. Find if all nodes can be reached from source (in directed graph).
30. Count number of SCCs.
31. How to handle topological sort when graph has multiple valid orderings?
32. What happens if Kahn's algorithm doesn't process all vertices?
33. In-degree and out-degree importance in directed graphs.
34. How to do topological sort on a disconnected DAG?
35. What is the time complexity of finding all topological orderings?
36. Can we modify BFS to work for shortest path in weighted DAG?
37. How does topological sort help in DP on DAGs?
38. What is a tournament graph? Properties?
39. What are bridges and articulation points in directed graphs?
40. How to find dominator tree?
41. Explain applications of condensation graph.
42. How to check if a given ordering is a valid topological sort?
43. What is the longest path problem? Why is it NP-hard in general but polynomial on DAGs?
44. How to find critical path in project scheduling (PERT/CPM)?
45. What is the minimum edge reversal to make graph strongly connected?
46. How does compiler use DAG for expression optimization?
47. What is the transitive closure of a directed graph?
48. How to find shortest path from source to all vertices in a DAG?
49. What is a Hamiltonian path in DAG?
50. How to check if topological sort is unique?

---

## Competitive Programming

### Template: Topological Sort + DP on DAG

```cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    
    int n, m;
    cin >> n >> m;
    
    vector<vector<int>> adj(n + 1);
    vector<int> inDeg(n + 1, 0);
    
    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v);
        inDeg[v]++;
    }
    
    // Kahn's + DP (e.g., longest path, count paths)
    queue<int> q;
    vector<long long> dp(n + 1, 0);  // dp[v] = longest path to v
    vector<long long> cnt(n + 1, 0); // cnt[v] = number of paths to v
    
    for (int i = 1; i <= n; i++) {
        if (inDeg[i] == 0) {
            q.push(i);
            cnt[i] = 1;
        }
    }
    
    vector<int> topo;
    while (!q.empty()) {
        int u = q.front(); q.pop();
        topo.push_back(u);
        
        for (int v : adj[u]) {
            // DP transition
            if (dp[u] + 1 > dp[v]) {
                dp[v] = dp[u] + 1;
            }
            cnt[v] += cnt[u];  // Count paths
            
            if (--inDeg[v] == 0) {
                q.push(v);
            }
        }
    }
    
    if (topo.size() != n) {
        cout << "IMPOSSIBLE" << endl;  // Cycle exists
    } else {
        // Print results
        cout << *max_element(dp.begin(), dp.end()) << endl;
    }
    
    return 0;
}
```

### Template: Kosaraju's SCC

```cpp
#include <bits/stdc++.h>
using namespace std;

const int MAXN = 2e5 + 5;
vector<int> adj[MAXN], radj[MAXN];
bool visited[MAXN];
int comp[MAXN];
stack<int> order;

void dfs1(int u) {
    visited[u] = true;
    for (int v : adj[u])
        if (!visited[v]) dfs1(v);
    order.push(u);
}

void dfs2(int u, int id) {
    visited[u] = true;
    comp[u] = id;
    for (int v : radj[u])
        if (!visited[v]) dfs2(v, id);
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    
    int n, m;
    cin >> n >> m;
    
    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v);
        radj[v].push_back(u);
    }
    
    // Step 1: DFS on original
    memset(visited, false, sizeof(visited));
    for (int i = 1; i <= n; i++)
        if (!visited[i]) dfs1(i);
    
    // Step 3: DFS on transpose
    memset(visited, false, sizeof(visited));
    int numSCC = 0;
    while (!order.empty()) {
        int u = order.top(); order.pop();
        if (!visited[u]) {
            dfs2(u, numSCC);
            numSCC++;
        }
    }
    
    cout << numSCC << endl;
    
    return 0;
}
```

---

## Cheat Sheet

### One-Page Revision

```
TOPOLOGICAL SORT:
• Linear ordering where u comes before v for every edge u→v
• Only possible on DAGs (no directed cycles)
• DFS: push to stack on finish → reverse gives topo order
• BFS (Kahn's): process in-degree 0 vertices first
• Time: O(V + E)

CYCLE DETECTION (DIRECTED):
• Three colors: WHITE (unvisited), GRAY (in progress), BLACK (done)
• Cycle exists iff we visit a GRAY vertex
• Kahn's: if topo sort doesn't include all vertices → cycle
• DIFFERENT from undirected (can't just check parent)

STRONGLY CONNECTED COMPONENTS:
• Maximal set where every vertex can reach every other
• Kosaraju's: DFS order → Transpose → DFS in reverse order
• Tarjan's: Single DFS with low-link values
• Condensation: Replace SCCs with single nodes → DAG
• Time: O(V + E)
```

### Key Formulas

| Concept | Formula/Property |
|---------|-----------------|
| DAG | Directed + No cycles |
| Topological sort exists | ⟺ Graph is DAG |
| # of valid topo sorts | Can be exponential |
| SCC condensation | Always a DAG |
| Minimum edges for strong connectivity | max(sources, sinks) in condensation |
| 2-SAT solvable | ⟺ no variable and its negation in same SCC |

### Common Pitfalls

1. ❌ Using undirected cycle detection for directed graphs
2. ❌ Forgetting to handle disconnected components in topo sort
3. ❌ Not building reverse graph for Kosaraju's
4. ❌ Confusing DFS finish time with discovery time in topo sort
5. ❌ Using adjacency matrix for large directed graphs (MLE)
6. ❌ Forgetting that Kahn's with incomplete processing = cycle
