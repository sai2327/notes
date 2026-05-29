# Undirected Graph Algorithms

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Flood Fill Algorithm](#flood-fill-algorithm)
- [Cycle Detection in Undirected Graph](#cycle-detection-in-undirected-graph)
- [Bipartite Graph Check](#bipartite-graph-check)
- [Shortest Cycle in Undirected Graph](#shortest-cycle-in-undirected-graph)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Cheat Sheet](#cheat-sheet)

---

## Introduction

### What are Undirected Graph Problems?

Undirected graphs have edges with no direction - if there's an edge between u and v, you can traverse from u to v AND from v to u. This chapter covers the four most important algorithms specific to undirected graphs:

1. **Flood Fill** - Filling connected regions (grid-based)
2. **Cycle Detection** - Determining if the graph contains a cycle
3. **Bipartite Check** - Testing if graph is 2-colorable
4. **Shortest Cycle** - Finding the minimum length cycle (girth)

### Why are they Important?

- Flood fill is used in image processing, game development, and region filling
- Cycle detection determines if a graph is a tree or forest
- Bipartite check is foundational for matching algorithms
- Shortest cycle has applications in network analysis

### Real-World Applications

| Algorithm | Application |
|-----------|-------------|
| Flood Fill | Paint bucket tool, minesweeper, image segmentation |
| Cycle Detection | Deadlock detection, network redundancy, tree validation |
| Bipartite Check | Job assignment, graph coloring, conflict resolution |
| Shortest Cycle | Network reliability, circuit analysis |

---

## Prerequisites

- [01_Introduction](../01_Introduction/README.md) - Graph representation
- [02_Traversals](../02_Traversals/README.md) - BFS and DFS fundamentals
- Understanding of adjacency lists
- Queue and recursion

---

## Flood Fill Algorithm

### Theory

Flood Fill is an algorithm that determines the area connected to a given node in a multi-dimensional array. It's essentially a BFS/DFS on a grid where we "fill" all connected cells that match a certain criteria.

### Real-World Analogy

Think of the **paint bucket tool** in MS Paint:
- Click on a pixel
- All connected pixels of the same color get filled with the new color
- "Connected" means reachable through 4-directional (or 8-directional) movement without crossing a different color

### Visual Example

```
Before Flood Fill (starting at position (1,1), filling with color 2):

Grid:                After:
1 1 1 0 0           2 2 2 0 0
1 1 0 0 0           2 2 0 0 0
1 0 0 1 1    →      2 0 0 1 1
0 0 1 1 1           0 0 1 1 1
0 0 0 0 0           0 0 0 0 0

Only cells connected to (1,1) with value 1 are filled.
```

### Algorithm

```
FloodFill(grid, row, col, newColor):
    1. Store the original color at (row, col)
    2. If original color == new color, return (nothing to do)
    3. Start BFS/DFS from (row, col)
    4. For each cell visited:
        - Change its color to newColor
        - Add all 4-directional neighbors with original color to queue/stack
```

### C++ Implementation (BFS)

```cpp
#include <bits/stdc++.h>
using namespace std;

class Solution {
public:
    vector<vector<int>> floodFill(vector<vector<int>>& image, 
                                   int sr, int sc, int color) {
        int originalColor = image[sr][sc];
        if (originalColor == color) return image;  // Important edge case!
        
        int rows = image.size(), cols = image[0].size();
        int dx[] = {0, 0, 1, -1};
        int dy[] = {1, -1, 0, 0};
        
        queue<pair<int,int>> q;
        q.push({sr, sc});
        image[sr][sc] = color;
        
        while (!q.empty()) {
            auto [x, y] = q.front();
            q.pop();
            
            for (int d = 0; d < 4; d++) {
                int nx = x + dx[d];
                int ny = y + dy[d];
                
                if (nx >= 0 && nx < rows && ny >= 0 && ny < cols 
                    && image[nx][ny] == originalColor) {
                    image[nx][ny] = color;
                    q.push({nx, ny});
                }
            }
        }
        
        return image;
    }
};
```

### C++ Implementation (DFS - Recursive)

```cpp
class Solution {
public:
    void dfs(vector<vector<int>>& image, int x, int y, 
             int originalColor, int newColor) {
        int rows = image.size(), cols = image[0].size();
        
        if (x < 0 || x >= rows || y < 0 || y >= cols) return;
        if (image[x][y] != originalColor) return;
        
        image[x][y] = newColor;
        
        dfs(image, x + 1, y, originalColor, newColor);
        dfs(image, x - 1, y, originalColor, newColor);
        dfs(image, x, y + 1, originalColor, newColor);
        dfs(image, x, y - 1, originalColor, newColor);
    }
    
    vector<vector<int>> floodFill(vector<vector<int>>& image, 
                                   int sr, int sc, int color) {
        if (image[sr][sc] == color) return image;
        dfs(image, sr, sc, image[sr][sc], color);
        return image;
    }
};
```

### Dry Run

```
Grid:
1 1 1
1 1 0
1 0 1

FloodFill(grid, 1, 1, 2):
Original color = 1, New color = 2

Step 1: Change (1,1) to 2, push to queue
Grid:       Queue: [(1,1)]
1 1 1
1 2 0
1 0 1

Step 2: Process (1,1), check neighbors
  (0,1): value=1=original → change to 2, push
  (2,1): value=0≠original → skip
  (1,0): value=1=original → change to 2, push
  (1,2): value=0≠original → skip
Grid:       Queue: [(0,1), (1,0)]
1 2 1
2 2 0
1 0 1

Step 3: Process (0,1)
  (0,0): value=1 → change to 2, push
  (0,2): value=1 → change to 2, push
Grid:       Queue: [(1,0), (0,0), (0,2)]
1 2 2
2 2 0
1 0 1
Wait - let me redo this properly.

Actually after step 2:
Grid:
1 2 1
2 2 0
1 0 1
Queue: [(0,1), (1,0)]

Step 3: Process (0,1)
  (-1,1): out of bounds
  (1,1): value=2≠original(1) → skip
  (0,0): value=1=original → change to 2, push
  (0,2): value=1=original → change to 2, push
Grid:       Queue: [(1,0), (0,0), (0,2)]
2 2 2
2 2 0
1 0 1

Step 4: Process (1,0)
  (0,0): value=2≠original → skip
  (2,0): value=1=original → change to 2, push
  (1,1): value=2≠original → skip
Grid:       Queue: [(0,0), (0,2), (2,0)]
2 2 2
2 2 0
2 0 1

Step 5: Process (0,0) - all neighbors already 2 or out of bounds
Step 6: Process (0,2) - neighbor (1,2)=0 → skip
Step 7: Process (2,0) - neighbor (2,1)=0 → skip

Final Grid:
2 2 2
2 2 0
2 0 1
```

### Complexity Analysis

| Aspect | Value |
|--------|-------|
| Time | O(m × n) where m×n is grid size |
| Space | O(m × n) for BFS queue / DFS recursion stack |

### Edge Cases
1. **New color same as original** → Return immediately (infinite loop otherwise!)
2. **Single cell grid** → Just change that cell
3. **All cells same color** → Fill entire grid
4. **Starting cell is isolated** → Only that cell changes

### Variations

1. **8-directional flood fill** (include diagonals)
2. **Boundary flood fill** (fill only boundary of region)
3. **Flood fill with tolerance** (colors within range)
4. **Count region size** (don't actually fill, just count)

---

## Cycle Detection in Undirected Graph

### Theory

A cycle in an undirected graph is a path that starts and ends at the same vertex with at least 3 edges, where no edge is repeated.

**Key Property**: An undirected graph with n vertices and m edges has a cycle if and only if m ≥ n (for connected graph) or more precisely if m > n - (number of components).

**Tree Property**: A connected graph is a tree iff it has exactly n-1 edges and no cycles.

### Why Cycle Detection Matters

1. Determine if graph is a tree
2. Detect deadlocks in resource allocation
3. Prerequisite for many algorithms (spanning trees, etc.)
4. Network redundancy analysis

### Intuition: How DFS Detects Cycles

```
During DFS, if we encounter a visited vertex that is NOT the parent 
of the current vertex, we've found a cycle!

Why? In DFS of undirected graph:
- Every visited neighbor is either:
  1. The parent (we came from there) → NOT a cycle
  2. An ancestor in DFS tree → CYCLE (back edge)

Example:
    0 --- 1
    |     |
    3 --- 2

DFS from 0: 0 → 1 → 2 → 3
When processing 3, neighbor 0 is visited but NOT parent of 3 (parent is 2)
→ CYCLE detected: 0 → 1 → 2 → 3 → 0
```

### Visual Detection

```
Graph with cycle:          Graph without cycle (Tree):
    0 --- 1                    0 --- 1
    |     |                    |     
    3 --- 2                    3 --- 2 --- 4

DFS Tree:                  DFS Tree:
    0                          0
    ├── 1                      ├── 1
    │   └── 2                  └── 3
    │       └── 3                  └── 2
    │           └── (0) ← BACK EDGE!     └── 4
    └── (skipped, already visited)
```

### Algorithm (DFS-based)

```
hasCycle(graph):
    visited = [false] * V
    for each vertex v:
        if not visited[v]:
            if dfsCycleCheck(v, -1, visited, graph):
                return true
    return false

dfsCycleCheck(u, parent, visited, graph):
    visited[u] = true
    for each neighbor v of u:
        if not visited[v]:
            if dfsCycleCheck(v, u, visited, graph):
                return true
        else if v != parent:  // visited and NOT parent = CYCLE
            return true
    return false
```

### C++ Implementation (DFS)

```cpp
#include <bits/stdc++.h>
using namespace std;

class CycleDetection {
    int V;
    vector<vector<int>> adj;
    
public:
    CycleDetection(int v) : V(v), adj(v) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    // DFS-based cycle detection
    bool dfs(int u, int parent, vector<bool>& visited) {
        visited[u] = true;
        
        for (int v : adj[u]) {
            if (!visited[v]) {
                if (dfs(v, u, visited)) return true;
            } else if (v != parent) {
                return true;  // Back edge found = cycle!
            }
        }
        
        return false;
    }
    
    bool hasCycle() {
        vector<bool> visited(V, false);
        
        // Check all components
        for (int i = 0; i < V; i++) {
            if (!visited[i]) {
                if (dfs(i, -1, visited)) return true;
            }
        }
        
        return false;
    }
};

int main() {
    // Graph with cycle: 0-1-2-3-0
    CycleDetection g1(4);
    g1.addEdge(0, 1);
    g1.addEdge(1, 2);
    g1.addEdge(2, 3);
    g1.addEdge(3, 0);
    cout << "Graph 1 has cycle: " << g1.hasCycle() << endl; // 1 (true)
    
    // Tree (no cycle): 0-1, 0-2, 2-3
    CycleDetection g2(4);
    g2.addEdge(0, 1);
    g2.addEdge(0, 2);
    g2.addEdge(2, 3);
    cout << "Graph 2 has cycle: " << g2.hasCycle() << endl; // 0 (false)
    
    return 0;
}
```

### C++ Implementation (BFS - Kahn's Style)

```cpp
bool hasCycleBFS(vector<vector<int>>& adj, int n) {
    vector<bool> visited(n, false);
    
    for (int start = 0; start < n; start++) {
        if (visited[start]) continue;
        
        queue<pair<int,int>> q; // {vertex, parent}
        q.push({start, -1});
        visited[start] = true;
        
        while (!q.empty()) {
            auto [u, parent] = q.front();
            q.pop();
            
            for (int v : adj[u]) {
                if (!visited[v]) {
                    visited[v] = true;
                    q.push({v, u});
                } else if (v != parent) {
                    return true; // Cycle found
                }
            }
        }
    }
    
    return false;
}
```

### Handling Multiple Edges (Important Edge Case!)

```cpp
// When there are multiple edges between same pair of vertices,
// we need to track edge indices, not just parent vertex

bool dfsCycleMultiEdge(int u, int parentEdge, 
                       vector<vector<pair<int,int>>>& adj, // {neighbor, edgeIdx}
                       vector<bool>& visited) {
    visited[u] = true;
    
    for (auto [v, edgeIdx] : adj[u]) {
        if (!visited[v]) {
            if (dfsCycleMultiEdge(v, edgeIdx, adj, visited)) return true;
        } else if (edgeIdx != parentEdge) {
            return true;
        }
    }
    
    return false;
}
```

### Dry Run

```
Graph: 0---1---2---0 (triangle), plus vertex 3 connected to 2

adj[0] = [1, 2]
adj[1] = [0, 2]
adj[2] = [1, 0, 3]
adj[3] = [2]

DFS from 0, parent = -1:
  visited[0] = true
  Check neighbor 1: not visited
    DFS(1, parent=0):
      visited[1] = true
      Check neighbor 0: visited, but 0 == parent(0) → skip (not cycle)
      Check neighbor 2: not visited
        DFS(2, parent=1):
          visited[2] = true
          Check neighbor 1: visited, but 1 == parent(1) → skip
          Check neighbor 0: visited, and 0 ≠ parent(1) → CYCLE FOUND!
          return true
        return true
      return true
    return true

Result: Cycle exists!

The cycle is: 0 → 1 → 2 → 0
```

### Complexity Analysis

| Aspect | DFS | BFS |
|--------|-----|-----|
| Time | O(V + E) | O(V + E) |
| Space | O(V) | O(V) |

### Finding the Actual Cycle (Not Just Detection)

```cpp
#include <bits/stdc++.h>
using namespace std;

vector<int> findCycle(vector<vector<int>>& adj, int n) {
    vector<int> parent(n, -1);
    vector<bool> visited(n, false);
    int cycleStart = -1, cycleEnd = -1;
    
    function<bool(int, int)> dfs = [&](int u, int par) -> bool {
        visited[u] = true;
        parent[u] = par;
        
        for (int v : adj[u]) {
            if (!visited[v]) {
                if (dfs(v, u)) return true;
            } else if (v != par) {
                cycleStart = v;
                cycleEnd = u;
                return true;
            }
        }
        return false;
    };
    
    for (int i = 0; i < n; i++) {
        if (!visited[i] && dfs(i, -1)) break;
    }
    
    if (cycleStart == -1) return {}; // No cycle
    
    // Reconstruct cycle
    vector<int> cycle;
    cycle.push_back(cycleStart);
    for (int v = cycleEnd; v != cycleStart; v = parent[v]) {
        cycle.push_back(v);
    }
    cycle.push_back(cycleStart);
    reverse(cycle.begin(), cycle.end());
    
    return cycle;
}
```

---

## Bipartite Graph Check

### Theory

A graph is **bipartite** if its vertices can be divided into two disjoint sets U and V such that every edge connects a vertex in U to a vertex in V.

**Equivalent definitions:**
1. Graph is 2-colorable (can color vertices with 2 colors such that no two adjacent vertices have the same color)
2. Graph contains no odd-length cycle

### Visual Example

```
Bipartite Graph:              NOT Bipartite:
    1 --- 2                      1 --- 2
    |     |                      |   / |
    3 --- 4                      |  /  |
                                 3 --- 4
Set A = {1, 4}  (Red)
Set B = {2, 3}  (Blue)          Triangle 1-2-3 = odd cycle
                                 Cannot 2-color!

Color assignment:
    R --- B                      R --- B
    |     |                      |   / |
    B --- R                      B --- ? (needs R but adj to R)
✓ Valid!                         ✗ Invalid!
```

### Intuition: BFS Coloring

```
Algorithm Idea:
1. Start from any unvisited vertex, color it RED (0)
2. Color all its neighbors BLUE (1)
3. Color all their neighbors RED (0)
4. Continue alternating...
5. If at any point we need to color a vertex that's ALREADY 
   colored with the OPPOSITE color → NOT BIPARTITE

Why this works:
- In a bipartite graph, BFS levels alternate between sets
- Even levels → Set A, Odd levels → Set B
- If a vertex in level k is adjacent to another in level k,
  they're in the same set → NOT bipartite (odd cycle)
```

### Algorithm

```
isBipartite(graph):
    color = [-1] * V  // -1 means uncolored
    
    for each vertex v:
        if color[v] == -1:  // Unvisited component
            if not bfsColor(v, graph, color):
                return false
    return true

bfsColor(source, graph, color):
    queue Q
    color[source] = 0
    Q.push(source)
    
    while Q not empty:
        u = Q.front()
        Q.pop()
        for each neighbor v of u:
            if color[v] == -1:
                color[v] = 1 - color[u]  // Opposite color
                Q.push(v)
            else if color[v] == color[u]:
                return false  // Same color adjacent = NOT bipartite
    return true
```

### C++ Implementation (BFS)

```cpp
#include <bits/stdc++.h>
using namespace std;

class BipartiteCheck {
    int V;
    vector<vector<int>> adj;
    
public:
    BipartiteCheck(int v) : V(v), adj(v) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    // BFS-based bipartite check
    bool isBipartiteBFS() {
        vector<int> color(V, -1);
        
        for (int i = 0; i < V; i++) {
            if (color[i] != -1) continue;
            
            queue<int> q;
            color[i] = 0;
            q.push(i);
            
            while (!q.empty()) {
                int u = q.front();
                q.pop();
                
                for (int v : adj[u]) {
                    if (color[v] == -1) {
                        color[v] = 1 - color[u];
                        q.push(v);
                    } else if (color[v] == color[u]) {
                        return false;
                    }
                }
            }
        }
        
        return true;
    }
    
    // DFS-based bipartite check
    bool dfs(int u, int c, vector<int>& color) {
        color[u] = c;
        
        for (int v : adj[u]) {
            if (color[v] == -1) {
                if (!dfs(v, 1 - c, color)) return false;
            } else if (color[v] == c) {
                return false;
            }
        }
        
        return true;
    }
    
    bool isBipartiteDFS() {
        vector<int> color(V, -1);
        
        for (int i = 0; i < V; i++) {
            if (color[i] == -1) {
                if (!dfs(i, 0, color)) return false;
            }
        }
        
        return true;
    }
    
    // Get the two sets (if bipartite)
    pair<vector<int>, vector<int>> getSets() {
        vector<int> color(V, -1);
        vector<int> setA, setB;
        
        for (int i = 0; i < V; i++) {
            if (color[i] == -1) {
                queue<int> q;
                color[i] = 0;
                q.push(i);
                
                while (!q.empty()) {
                    int u = q.front(); q.pop();
                    if (color[u] == 0) setA.push_back(u);
                    else setB.push_back(u);
                    
                    for (int v : adj[u]) {
                        if (color[v] == -1) {
                            color[v] = 1 - color[u];
                            q.push(v);
                        }
                    }
                }
            }
        }
        
        return {setA, setB};
    }
};

int main() {
    // Bipartite: 0-1, 1-2, 2-3, 3-0 (even cycle)
    BipartiteCheck g1(4);
    g1.addEdge(0, 1);
    g1.addEdge(1, 2);
    g1.addEdge(2, 3);
    g1.addEdge(3, 0);
    cout << "Graph 1 bipartite: " << g1.isBipartiteBFS() << endl; // true
    
    // Not bipartite: triangle 0-1-2-0
    BipartiteCheck g2(3);
    g2.addEdge(0, 1);
    g2.addEdge(1, 2);
    g2.addEdge(2, 0);
    cout << "Graph 2 bipartite: " << g2.isBipartiteBFS() << endl; // false
    
    return 0;
}
```

### Dry Run

```
Graph: 0---1---2---3---0 (4-cycle)

adj[0] = [1, 3]
adj[1] = [0, 2]
adj[2] = [1, 3]
adj[3] = [2, 0]

BFS from vertex 0, color[0] = 0:
Queue: [0]

Step 1: Process 0 (color=0)
  Neighbor 1: uncolored → color[1] = 1, push
  Neighbor 3: uncolored → color[3] = 1, push
  Queue: [1, 3]
  Colors: [0, 1, -, 1]

Step 2: Process 1 (color=1)
  Neighbor 0: color[0]=0 ≠ color[1]=1 → OK
  Neighbor 2: uncolored → color[2] = 0, push
  Queue: [3, 2]
  Colors: [0, 1, 0, 1]

Step 3: Process 3 (color=1)
  Neighbor 2: color[2]=0 ≠ color[3]=1 → OK
  Neighbor 0: color[0]=0 ≠ color[3]=1 → OK
  Queue: [2]

Step 4: Process 2 (color=0)
  Neighbor 1: color[1]=1 ≠ color[2]=0 → OK
  Neighbor 3: color[3]=1 ≠ color[2]=0 → OK
  Queue: []

Result: BIPARTITE!
Set A (color 0): {0, 2}
Set B (color 1): {1, 3}

---

Non-bipartite example: Triangle 0-1-2

adj[0] = [1, 2]
adj[1] = [0, 2]
adj[2] = [0, 1]

BFS from 0, color[0] = 0:
Step 1: Process 0 → color[1]=1, color[2]=1
Step 2: Process 1 → check neighbor 2: color[2]=1 == color[1]=1 → CONFLICT!

Result: NOT BIPARTITE (odd cycle: 0-1-2-0, length 3)
```

### Complexity Analysis

| Aspect | Value |
|--------|-------|
| Time | O(V + E) |
| Space | O(V) for color array |

### Important Properties

1. A graph is bipartite ⟺ it contains no odd-length cycle
2. Every tree is bipartite
3. Every even-length cycle is bipartite
4. K₂,₃ (complete bipartite) is bipartite by definition
5. A graph with only even-length cycles is bipartite

### Common Applications
- **Job Assignment**: Workers and tasks form bipartite graph
- **Matching Problems**: Maximum bipartite matching
- **Graph Coloring**: 2-coloring is bipartite check
- **Conflict Resolution**: If conflicts can be separated into 2 groups

---

## Shortest Cycle in Undirected Graph

### Theory

The **girth** of a graph is the length of the shortest cycle. Finding the shortest cycle in an undirected graph is a classic problem.

### Approach 1: BFS from Every Vertex

**Key Idea**: For each vertex, run BFS. When we find a vertex that's already visited (and it's not the parent), we've found a cycle. The length of this cycle is `dist[u] + dist[v] + 1`.

```
For each vertex s:
    Run BFS from s
    If we find edge (u, v) where both are visited:
        cycle_length = dist[u] + dist[v] + 1
        (because the cycle goes: s → ... → u → v → ... → s)
```

### Visual Example

```
Graph:
    0 --- 1 --- 2
    |           |
    5 --- 4 --- 3

BFS from 0:
  dist[0]=0, dist[1]=1, dist[5]=1
  dist[2]=2, dist[4]=2
  dist[3]=3

When processing vertex 3 (dist=3), we find neighbor 2 (dist=2):
  This edge creates cycle of length: 2 + 3 + 1 = 6? No...
  
Actually: When we find that vertex 2 already has dist=2, and we're 
processing vertex 4 (dist=2), and they share edge through 3...

Let me be more precise. The correct approach:

BFS from 0:
  Level 0: {0}
  Level 1: {1, 5}
  Level 2: {2, 4}
  Level 3: {3}

When processing vertex 4 at level 2:
  Neighbor 3 not visited → push, dist[3] = 3
When processing vertex 2 at level 2:
  Neighbor 3... wait, let me redo.

Actually for cycle detection during BFS:
When we see edge (u,v) where v is already visited AND v ≠ parent[u]:
  cycle_length = dist[u] + dist[v] + 1

BFS from vertex 0:
  Process 0: push 1(d=1), push 5(d=1)
  Process 1: push 2(d=2)
  Process 5: push 4(d=2)
  Process 2: push 3(d=3)
  Process 4: neighbor 3... 
    - If 3 is already visited (dist[3]=3): cycle = dist[4] + dist[3] + 1 = 2+3+1 = 6
    - If not yet visited: push 3(d=3)... but 3 already visited!
  
The shortest cycle here is: 0-1-2-3-4-5-0 (length 6)
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

int shortestCycle(int n, vector<vector<int>>& adj) {
    int ans = INT_MAX;
    
    // BFS from each vertex
    for (int src = 0; src < n; src++) {
        vector<int> dist(n, -1);
        queue<int> q;
        dist[src] = 0;
        q.push(src);
        
        while (!q.empty()) {
            int u = q.front();
            q.pop();
            
            for (int v : adj[u]) {
                if (dist[v] == -1) {
                    dist[v] = dist[u] + 1;
                    q.push(v);
                } else if (dist[v] >= dist[u]) {
                    // Found a cycle!
                    // v was already visited at same or higher level
                    ans = min(ans, dist[u] + dist[v] + 1);
                }
            }
        }
    }
    
    return ans == INT_MAX ? -1 : ans;
}

// LeetCode 2608: Shortest Cycle in a Graph
class Solution {
public:
    int findShortestCycle(int n, vector<vector<int>>& edges) {
        vector<vector<int>> adj(n);
        for (auto& e : edges) {
            adj[e[0]].push_back(e[1]);
            adj[e[1]].push_back(e[0]);
        }
        
        int ans = INT_MAX;
        
        for (int i = 0; i < n; i++) {
            vector<int> dist(n, -1);
            vector<int> parent(n, -1);
            queue<int> q;
            dist[i] = 0;
            q.push(i);
            
            while (!q.empty()) {
                int u = q.front();
                q.pop();
                
                for (int v : adj[u]) {
                    if (dist[v] == -1) {
                        dist[v] = dist[u] + 1;
                        parent[v] = u;
                        q.push(v);
                    } else if (parent[u] != v && parent[v] != u) {
                        // Cross edge in BFS tree = cycle
                        ans = min(ans, dist[u] + dist[v] + 1);
                    }
                }
            }
        }
        
        return ans == INT_MAX ? -1 : ans;
    }
};

int main() {
    int n = 6;
    vector<vector<int>> adj(n);
    // Cycle: 0-1-2-3-4-5-0 (length 6) and 1-2-3-1 (length 3)
    vector<pair<int,int>> edges = {{0,1},{1,2},{2,3},{3,1},{3,4},{4,5},{5,0}};
    for (auto& [u, v] : edges) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    cout << "Shortest cycle length: " << shortestCycle(n, adj) << endl; // 3
    
    return 0;
}
```

### Approach 2: Remove Each Edge and Check

For each edge (u,v):
1. Remove it
2. Find shortest path from u to v using BFS
3. Cycle length = shortest_path + 1
4. Track minimum

```cpp
int shortestCycleEdgeRemoval(int n, vector<vector<int>>& adj) {
    int ans = INT_MAX;
    
    // For each edge, find shortest path without that edge
    for (int u = 0; u < n; u++) {
        for (int v : adj[u]) {
            if (u < v) { // Process each edge once
                // BFS from u to v, without using edge (u,v)
                vector<int> dist(n, -1);
                queue<int> q;
                dist[u] = 0;
                q.push(u);
                
                while (!q.empty()) {
                    int curr = q.front(); q.pop();
                    for (int next : adj[curr]) {
                        // Skip the edge we removed
                        if ((curr == u && next == v) || (curr == v && next == u)) {
                            // We should skip only ONE instance of this edge
                            continue; // Simplified - may skip both in multigraph
                        }
                        if (dist[next] == -1) {
                            dist[next] = dist[curr] + 1;
                            q.push(next);
                        }
                    }
                }
                
                if (dist[v] != -1) {
                    ans = min(ans, dist[v] + 1);
                }
            }
        }
    }
    
    return ans == INT_MAX ? -1 : ans;
}
```

### Complexity Analysis

| Approach | Time | Space |
|----------|------|-------|
| BFS from every vertex | O(V × (V + E)) | O(V) |
| Edge removal | O(E × (V + E)) | O(V) |

### Why O(V × (V + E))?
- We run BFS V times
- Each BFS takes O(V + E)
- Total: O(V × (V + E))

For sparse graphs (E ≈ V): O(V²)
For dense graphs (E ≈ V²): O(V³)

---

## Pattern Recognition

### How To Identify These Concepts In Problems

#### Flood Fill Indicators:
1. "Fill connected region" → Flood Fill
2. "Paint bucket" / "Color fill" → Flood Fill
3. "Count cells in region" → Flood Fill (count variant)
4. "Change all connected cells" → Flood Fill
5. "Island area" → Flood Fill
6. Grid-based with "spreading" → Multi-source Flood Fill

#### Cycle Detection Indicators:
7. "Is the graph a tree?" → n-1 edges AND no cycle
8. "Can we add an edge without creating cycle?" → Union-Find or DFS
9. "Redundant connection" → Find edge causing cycle
10. "Deadlock detection" → Cycle in dependency graph
11. "Is the graph a forest?" → No cycles
12. "Valid tree check" → Connected + no cycle

#### Bipartite Indicators:
13. "Divide into two groups" → Bipartite
14. "Two-coloring" → Bipartite
15. "No conflicts between same type" → Bipartite
16. "Teams/pairs assignment" → Bipartite
17. "Is graph 2-colorable?" → Bipartite
18. "Odd cycle exists?" → NOT bipartite

#### Shortest Cycle Indicators:
19. "Girth of graph" → Shortest cycle
20. "Minimum cycle length" → Shortest cycle
21. "Smallest loop" → Shortest cycle

#### Mixed Patterns:
22. "Connected regions in grid" → Flood Fill / BFS components
23. "Maximum area" → Flood Fill + count
24. "Number of islands" → Count flood fills needed
25. "Perimeter of island" → Flood Fill + boundary count
26. "Can partition into groups with no internal conflict" → Bipartite
27. "Minimum edges to remove to make tree" → m - (n-1) = extra edges (cycles)
28. "Extra edge in tree" → Find cycle, remove one edge
29. "Graph coloring with minimum colors" → Start with bipartite check
30. "Schedule without conflict" → Bipartite matching

---

## Problem Solving

### Easy Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Flood Fill | LeetCode 733 | Basic flood fill |
| 2 | Number of Islands | LeetCode 200 | Flood fill counting |
| 3 | Max Area of Island | LeetCode 695 | Flood fill + size |
| 4 | Island Perimeter | LeetCode 463 | Grid boundary |
| 5 | Count Sub Islands | LeetCode 1905 | Flood fill comparison |
| 6 | Number of Closed Islands | LeetCode 1254 | Border flood fill |
| 7 | Detect Cycle in Undirected Graph | GFG | Cycle detection |
| 8 | Is Graph Bipartite | LeetCode 785 | BFS coloring |
| 9 | Graph Valid Tree | LeetCode 261 | Cycle + connected |
| 10 | Coloring A Border | LeetCode 1034 | Flood fill variant |
| 11 | Number of Enclaves | LeetCode 1020 | Border flood fill |
| 12 | Surrounded Regions | LeetCode 130 | Border DFS/BFS |
| 13 | Connected Components in Graph | GFG | Flood fill |
| 14 | Find if Path Exists | LeetCode 1971 | BFS/DFS |
| 15 | Regions Cut By Slashes | LeetCode 959 | Grid expansion + flood fill |
| 16 | Making A Large Island | LeetCode 827 | Flood fill + union |
| 17 | Possible Bipartition | LeetCode 886 | Bipartite check |
| 18 | Number of Provinces | LeetCode 547 | Components |
| 19 | Image Overlap | LeetCode 835 | Grid comparison |
| 20 | Battleships in a Board | LeetCode 419 | Grid counting |

### Medium Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Redundant Connection | LeetCode 684 | Cycle detection |
| 2 | Pacific Atlantic Water Flow | LeetCode 417 | Multi-source flood fill |
| 3 | Shortest Bridge | LeetCode 934 | Flood fill + BFS |
| 4 | As Far from Land as Possible | LeetCode 1162 | Multi-source BFS |
| 5 | Walls and Gates | LeetCode 286 | Multi-source BFS |
| 6 | Shortest Cycle in Graph | LeetCode 2608 | Shortest cycle |
| 7 | Find Eventual Safe States | LeetCode 802 | Cycle detection |
| 8 | Graph Coloring | CSES (Building Teams) | Bipartite |
| 9 | Color Fill Game | Codeforces | Flood fill |
| 10 | Cycle Finding | CSES (Round Trip) | Find actual cycle |
| 11 | Odd Cycle | Codeforces | Bipartite violation |
| 12 | Grid Illumination | LeetCode 1001 | Grid + components |
| 13 | Map of Highest Peak | LeetCode 1765 | Multi-source BFS |
| 14 | Minimum Cost Homecoming | LeetCode 2049 | Grid path |
| 15 | Escape a Large Maze | LeetCode 1036 | BFS with constraints |
| 16 | Keys and Rooms | LeetCode 841 | DFS reachability |
| 17 | Check if Graph is Bipartite | CSES | Bipartite BFS |
| 18 | Minimum Spanning Subgraph | Codeforces | Cycle + MST |
| 19 | Undirected Cycle | CodeChef | Cycle detection |
| 20 | Two Colorable | AtCoder | Bipartite |
| 21 | Remove Max Number of Edges | LeetCode 1579 | Cycle + connectivity |
| 22 | Accounts Merge | LeetCode 721 | Components (flood fill concept) |
| 23 | Most Stones Removed | LeetCode 947 | Components |
| 24 | Number of Operations to Make Network Connected | LeetCode 1319 | Components + cycle |
| 25 | Detonate Maximum Bombs | LeetCode 2101 | DFS on directed graph |
| 26 | Count Unreachable Pairs | LeetCode 2316 | Components counting |
| 27 | Minimum Score of a Path | LeetCode 2492 | Components |
| 28 | Find All Groups of Farmland | LeetCode 1992 | Flood fill |
| 29 | Throne Inheritance | LeetCode 1600 | Tree DFS |
| 30 | Water Flow | CodeChef | Multi-source flood fill |

### Hard Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Shortest Cycle Containing Node | Codeforces | BFS cycle |
| 2 | Making A Large Island | LeetCode 827 | Flood fill + components |
| 3 | Escape the Spreading Fire | LeetCode 2258 | Multi-source BFS |
| 4 | Minimum Obstacle Removal | LeetCode 2290 | 0-1 BFS |
| 5 | K-Similar Strings | LeetCode 854 | BFS state space |
| 6 | Contains Cycle | LeetCode 1559 | Cycle in grid |
| 7 | Shortest Cycle in Weighted Graph | Codeforces | Modified Dijkstra |
| 8 | Chromatic Number | SPOJ | Beyond bipartite |
| 9 | Bipartite Verification | UVa | Bipartite + proof |
| 10 | Girth of Graph | SPOJ | Shortest cycle |
| 11 | Minimum Weight Cycle | Codeforces | Weighted shortest cycle |
| 12 | Maximum Bipartite Matching | GFG | Bipartite + matching |
| 13 | Cycle Basis | SPOJ | All independent cycles |
| 14 | Graph Destruction | Codeforces | Reverse + components |
| 15 | Painting Grid | AtCoder | Flood fill + DP |
| 16 | Connected Components on Complement | Codeforces | Complement BFS |
| 17 | Edge Connectivity | SPOJ | Min cut |
| 18 | Vertex Connectivity | SPOJ | Min cut vertices |
| 19 | Minimum Cut | Codeforces | Network flow |
| 20 | Planar Graph Check | UVa | Advanced |

---

## Interview Preparation

### Top 50+ Interview Questions

#### Theory:
1. How do you detect a cycle in an undirected graph?
2. What is the difference between cycle detection in directed vs undirected graphs?
3. Explain bipartite graph. How to check if a graph is bipartite?
4. What is flood fill? Where is it used?
5. What is the girth of a graph?
6. Prove: A graph is bipartite iff it has no odd cycle.
7. How many edges can an undirected graph have without a cycle? (n-1, i.e., a tree/forest)
8. Can a bipartite graph have cycles? (Yes, only even-length)
9. What is the relationship between trees and cycle-free graphs?
10. How does BFS detect back edges in undirected graphs?
11. What is a bridge? How does it relate to cycles?
12. What is an articulation point?
13. Explain the parent tracking issue in undirected cycle detection.
14. How to handle multi-edges in cycle detection?
15. What is chromatic number? Relationship with bipartiteness?

#### Coding:
16. Implement flood fill on a 2D grid.
17. Detect if an undirected graph has a cycle using DFS.
18. Detect if an undirected graph has a cycle using BFS.
19. Check if graph is bipartite using BFS.
20. Check if graph is bipartite using DFS.
21. Find the shortest cycle in an undirected graph.
22. Find the actual cycle path (not just detect).
23. Count the number of cycles in a graph.
24. Find redundant connection (extra edge creating cycle).
25. Determine if graph is a valid tree.
26. Number of Islands problem.
27. Rotting Oranges (multi-source flood fill).
28. Pacific Atlantic Water Flow.
29. Shortest Bridge between two islands.
30. Possible Bipartition problem.
31. Count connected components.
32. Maximum area of island.
33. Surrounded Regions.
34. Making A Large Island.
35. Accounts Merge.

#### Follow-ups:
36. Can you detect cycle in O(V) for sparse graphs?
37. How to find ALL cycles? (Cycle basis)
38. What if graph changes dynamically? (Online cycle detection)
39. How to count triangles efficiently?
40. What is the complexity of checking if a graph is planar?
41. How does bipartite check relate to graph coloring?
42. Can bipartite check be parallelized?
43. How to handle large grids that don't fit in memory?
44. What is the relationship between bipartiteness and matchings?
45. How to find the maximum independent set in a bipartite graph?

#### Tricky Cases:
46. Self-loops: Always create a cycle of length 1
47. Parallel edges: Two edges between same pair = cycle of length 2
48. Single vertex with self-loop: Is it a cycle?
49. Disconnected graph: Check ALL components
50. Empty graph (no edges): No cycle, always bipartite
51. Complete graph K₃: NOT bipartite (triangle)
52. Complete bipartite K₃,₃: IS bipartite

---

## Competitive Programming

### Template: Flood Fill + Component Counting

```cpp
#include <bits/stdc++.h>
using namespace std;

int dx[] = {0, 0, 1, -1};
int dy[] = {1, -1, 0, 0};

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    
    int n, m;
    cin >> n >> m;
    
    vector<string> grid(n);
    for (int i = 0; i < n; i++) cin >> grid[i];
    
    int components = 0;
    vector<vector<bool>> visited(n, vector<bool>(m, false));
    
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            if (!visited[i][j] && grid[i][j] == '.') {
                components++;
                // BFS flood fill
                queue<pair<int,int>> q;
                q.push({i, j});
                visited[i][j] = true;
                
                while (!q.empty()) {
                    auto [x, y] = q.front(); q.pop();
                    for (int d = 0; d < 4; d++) {
                        int nx = x + dx[d], ny = y + dy[d];
                        if (nx >= 0 && nx < n && ny >= 0 && ny < m 
                            && !visited[nx][ny] && grid[nx][ny] == '.') {
                            visited[nx][ny] = true;
                            q.push({nx, ny});
                        }
                    }
                }
            }
        }
    }
    
    cout << components << endl;
    return 0;
}
```

### Template: Cycle Detection + Bipartite Combined

```cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    
    int n, m;
    cin >> n >> m;
    
    vector<vector<int>> adj(n + 1);
    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    // Bipartite check (also detects odd cycles)
    vector<int> color(n + 1, -1);
    bool bipartite = true;
    
    for (int i = 1; i <= n; i++) {
        if (color[i] != -1) continue;
        
        queue<int> q;
        color[i] = 0;
        q.push(i);
        
        while (!q.empty() && bipartite) {
            int u = q.front(); q.pop();
            for (int v : adj[u]) {
                if (color[v] == -1) {
                    color[v] = 1 - color[u];
                    q.push(v);
                } else if (color[v] == color[u]) {
                    bipartite = false;
                    break;
                }
            }
        }
    }
    
    if (bipartite) {
        // Print two teams
        for (int i = 1; i <= n; i++) {
            cout << color[i] + 1 << " ";
        }
    } else {
        cout << "IMPOSSIBLE" << endl;
    }
    
    return 0;
}
```

### Common Mistakes

1. ❌ Flood fill: Not checking if newColor == originalColor (infinite loop)
2. ❌ Cycle detection: Not tracking parent (every edge looks like cycle in undirected)
3. ❌ Bipartite: Forgetting to handle disconnected components
4. ❌ Shortest cycle: Using DFS instead of BFS (DFS doesn't guarantee shortest)
5. ❌ Multi-edges: Using parent vertex instead of parent edge for cycle detection
6. ❌ Grid bounds: Off-by-one errors in boundary checks

---

## Cheat Sheet

### One-Page Revision

```
FLOOD FILL:
• BFS/DFS on grid from starting cell
• Fill all connected cells with same value
• Edge case: newColor == originalColor → return immediately
• Time: O(m×n), Space: O(m×n)

CYCLE DETECTION (Undirected):
• DFS: If neighbor is visited AND ≠ parent → CYCLE
• BFS: Same logic with parent tracking
• Tree check: connected + no cycle (or V vertices, V-1 edges)
• Time: O(V+E), Space: O(V)

BIPARTITE CHECK:
• BFS/DFS 2-coloring
• Assign opposite colors to neighbors
• Conflict (same color neighbors) → NOT bipartite
• Bipartite ⟺ No odd-length cycle
• Time: O(V+E), Space: O(V)

SHORTEST CYCLE:
• BFS from each vertex
• When cross-edge found: cycle_len = dist[u] + dist[v] + 1
• Time: O(V × (V+E)), Space: O(V)
```

### Quick Decision Table

| Problem Type | Algorithm | Key Check |
|-------------|-----------|-----------|
| Fill connected region | Flood Fill (BFS/DFS) | Boundary + color match |
| Is it a tree? | Cycle detection + connected check | parent ≠ neighbor |
| 2-colorable? | BFS coloring | color[u] ≠ color[v] |
| Minimum cycle | BFS from each vertex | dist[u] + dist[v] + 1 |
| Count regions | Multiple flood fills | Track visited |

### Common Pitfalls

1. Flood Fill infinite loop → Check newColor ≠ originalColor
2. Undirected cycle false positive → Track parent correctly
3. Bipartite on disconnected graph → Check ALL components
4. Shortest cycle using DFS → Wrong! Use BFS
5. Multi-edge in undirected → Use edge index, not parent vertex
