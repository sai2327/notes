# Graph Traversals - BFS and DFS

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Breadth First Search (BFS)](#breadth-first-search-bfs)
- [Single Source Shortest Path (BFS)](#single-source-shortest-path-using-bfs)
- [Snakes and Ladders BFS](#snakes-and-ladders-bfs)
- [Depth First Search (DFS)](#depth-first-search-dfs)
- [Connected Components](#connected-components)
- [Journey to the Moon](#journey-to-the-moon-problem)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Cheat Sheet](#cheat-sheet)

---

## Introduction

### What are Graph Traversals?

Graph traversal (also called graph search) refers to the process of visiting all vertices in a graph systematically. The two fundamental traversal algorithms are:

1. **BFS (Breadth-First Search)** - Explores level by level (uses Queue)
2. **DFS (Depth-First Search)** - Explores as deep as possible first (uses Stack/Recursion)

### Why are they Important?

- They form the **backbone** of almost every graph algorithm
- BFS finds shortest paths in unweighted graphs
- DFS is used for cycle detection, topological sort, SCC, and more
- Every graph algorithm you'll learn later builds upon BFS/DFS

### Real-World Applications

| Application | Algorithm | Why |
|-------------|-----------|-----|
| Google Maps (shortest route) | BFS | Finds shortest path in unweighted graphs |
| Web Crawling | BFS | Discovers pages level by level |
| Social Network (degrees of separation) | BFS | Finds shortest connection |
| Maze Solving | DFS/BFS | Explores paths |
| Garbage Collection | DFS | Mark and sweep |
| Topological Ordering | DFS | Dependency resolution |
| Finding Connected Components | Both | Network analysis |
| Puzzle Solving | BFS | Minimum moves |

### Interview Relevance

- BFS/DFS appear in **70%+** of graph interview questions
- Every FAANG company asks BFS/DFS problems
- Understanding when to use BFS vs DFS is critical

---

## Prerequisites

Before studying this topic, you must understand:
- [01_Introduction](../01_Introduction/README.md) - Graph representation (adjacency list)
- Queue data structure (for BFS)
- Stack data structure / Recursion (for DFS)
- Basic C++ STL (vector, queue, stack)

---

## Breadth First Search (BFS)

### Core Theory

BFS explores a graph **level by level**. Starting from a source vertex, it first visits all vertices at distance 1, then all vertices at distance 2, and so on.

**Key Insight**: BFS uses a **queue** (FIFO) to maintain the order of exploration.

### Visual Intuition

```
Starting from vertex 0:

Graph:
    0 --- 1 --- 4
    |     |
    2 --- 3 --- 5

Level 0: {0}           (distance 0 from source)
Level 1: {1, 2}        (distance 1 from source)
Level 2: {4, 3}        (distance 2 from source)  
Level 3: {5}           (distance 3 from source)

BFS Order: 0, 1, 2, 4, 3, 5
           (or 0, 2, 1, 3, 4, 5 depending on adj list order)
```

### Why BFS Works for Shortest Path

**Theorem**: In an unweighted graph, BFS finds the shortest path from source to all reachable vertices.

**Proof Intuition**: 
- BFS explores vertices in order of their distance from the source
- When we first reach a vertex, it must be via the shortest path
- Because any shorter path would have been explored earlier (queue is FIFO)

### Algorithm

```
BFS(graph, source):
    1. Create a queue Q
    2. Mark source as visited
    3. Enqueue source into Q
    4. While Q is not empty:
        a. Dequeue vertex u from Q
        b. Process u (print, store, etc.)
        c. For each neighbor v of u:
            - If v is not visited:
                * Mark v as visited
                * Enqueue v into Q
```

### Pseudocode Flowchart

```
┌─────────────────┐
│  Start BFS(s)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ visited[s] = T  │
│ queue.push(s)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     NO
│ queue empty?    │────────────┐
└────────┬────────┘            │
    YES  │                     ▼
         │           ┌─────────────────┐
         ▼           │ u = queue.front │
┌─────────────┐      │ queue.pop()     │
│    END      │      └────────┬────────┘
└─────────────┘               │
                              ▼
                    ┌─────────────────────┐
                    │ For each neighbor v  │
                    │ of u:               │
                    │  if !visited[v]:    │
                    │    visited[v] = T   │
                    │    queue.push(v)    │
                    └────────┬────────────┘
                             │
                             └──→ (back to queue empty check)
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

// Basic BFS - returns BFS order
vector<int> bfs(vector<vector<int>>& adj, int source, int n) {
    vector<int> order;
    vector<bool> visited(n, false);
    queue<int> q;
    
    visited[source] = true;
    q.push(source);
    
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        order.push_back(u);
        
        for (int v : adj[u]) {
            if (!visited[v]) {
                visited[v] = true;
                q.push(v);
            }
        }
    }
    
    return order;
}

int main() {
    int n = 6, m = 6;
    vector<vector<int>> adj(n);
    
    // Add edges
    vector<pair<int,int>> edges = {{0,1},{0,2},{1,3},{1,4},{2,3},{3,5}};
    for (auto& [u, v] : edges) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    vector<int> result = bfs(adj, 0, n);
    
    cout << "BFS Order: ";
    for (int v : result) cout << v << " ";
    cout << endl;
    
    return 0;
}
```

### Dry Run

```
Graph:
    0 --- 1 --- 4
    |     |
    2 --- 3 --- 5

adj[0] = [1, 2]
adj[1] = [0, 3, 4]
adj[2] = [0, 3]
adj[3] = [1, 2, 5]
adj[4] = [1]
adj[5] = [3]

Starting BFS from vertex 0:

Initial: visited = [T, F, F, F, F, F], queue = [0], order = []

Step 1: Dequeue 0
  - Process 0, order = [0]
  - Neighbors of 0: 1, 2
    - 1 not visited → visited[1] = T, queue = [1]
    - 2 not visited → visited[2] = T, queue = [1, 2]
  - visited = [T, T, T, F, F, F]

Step 2: Dequeue 1
  - Process 1, order = [0, 1]
  - Neighbors of 1: 0, 3, 4
    - 0 visited → skip
    - 3 not visited → visited[3] = T, queue = [2, 3]
    - 4 not visited → visited[4] = T, queue = [2, 3, 4]
  - visited = [T, T, T, T, T, F]

Step 3: Dequeue 2
  - Process 2, order = [0, 1, 2]
  - Neighbors of 2: 0, 3
    - 0 visited → skip
    - 3 visited → skip
  - queue = [3, 4]

Step 4: Dequeue 3
  - Process 3, order = [0, 1, 2, 3]
  - Neighbors of 3: 1, 2, 5
    - 1 visited → skip
    - 2 visited → skip
    - 5 not visited → visited[5] = T, queue = [4, 5]
  - visited = [T, T, T, T, T, T]

Step 5: Dequeue 4
  - Process 4, order = [0, 1, 2, 3, 4]
  - Neighbors of 4: 1
    - 1 visited → skip
  - queue = [5]

Step 6: Dequeue 5
  - Process 5, order = [0, 1, 2, 3, 4, 5]
  - Neighbors of 5: 3
    - 3 visited → skip
  - queue = [] (empty)

DONE! BFS Order: 0, 1, 2, 3, 4, 5
```

### Complexity Analysis

| Aspect | Complexity |
|--------|-----------|
| Time | O(V + E) |
| Space | O(V) for visited array + O(V) for queue |
| Total Space | O(V) |

**Why O(V + E)?**
- Each vertex is enqueued and dequeued exactly once: O(V)
- Each edge is examined exactly once (undirected: twice): O(E)
- Total: O(V + E)

---

## Single Source Shortest Path Using BFS

### Theory

In an **unweighted** graph, BFS naturally finds the shortest path from the source to all other vertices. The "shortest path" means the path with the minimum number of edges.

### Why BFS Gives Shortest Path

```
Key Property: When BFS visits a vertex v for the first time,
the distance from source to v is the MINIMUM possible distance.

Proof by contradiction:
- Suppose BFS assigns distance d to vertex v
- Suppose there exists a shorter path of length d' < d
- Then v would have been discovered at level d' (earlier)
- But BFS processes levels in order → contradiction!
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

// BFS Shortest Path - returns distance and parent arrays
pair<vector<int>, vector<int>> bfsShortestPath(
    vector<vector<int>>& adj, int source, int n) {
    
    vector<int> dist(n, -1);    // -1 means unreachable
    vector<int> parent(n, -1);  // For path reconstruction
    queue<int> q;
    
    dist[source] = 0;
    q.push(source);
    
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        
        for (int v : adj[u]) {
            if (dist[v] == -1) {  // Not visited
                dist[v] = dist[u] + 1;
                parent[v] = u;
                q.push(v);
            }
        }
    }
    
    return {dist, parent};
}

// Reconstruct path from source to target
vector<int> reconstructPath(vector<int>& parent, int source, int target) {
    if (parent[target] == -1 && target != source) {
        return {};  // No path exists
    }
    
    vector<int> path;
    for (int v = target; v != -1; v = parent[v]) {
        path.push_back(v);
    }
    reverse(path.begin(), path.end());
    return path;
}

int main() {
    int n = 8;
    vector<vector<int>> adj(n);
    
    // Build graph
    vector<pair<int,int>> edges = {
        {0,1},{0,3},{1,2},{3,4},{3,7},{4,5},{4,6},{4,7},{5,6},{6,7}
    };
    for (auto& [u, v] : edges) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    auto [dist, parent] = bfsShortestPath(adj, 0, n);
    
    cout << "Shortest distances from vertex 0:" << endl;
    for (int i = 0; i < n; i++) {
        cout << "  0 → " << i << " : " << dist[i] << endl;
    }
    
    // Print shortest path from 0 to 6
    vector<int> path = reconstructPath(parent, 0, 6);
    cout << "\nShortest path from 0 to 6: ";
    for (int v : path) cout << v << " ";
    cout << endl;
    
    return 0;
}
```

### Dry Run - Shortest Path

```
Graph:
    0 --- 1 --- 2
    |
    3 --- 4 --- 5
    |     |     |
    7 --- + --- 6

Find shortest path from 0 to 6.

BFS from 0:
  dist[0] = 0, parent[0] = -1
  
  Level 0: Process 0
    → Visit 1: dist[1] = 1, parent[1] = 0
    → Visit 3: dist[3] = 1, parent[3] = 0
    
  Level 1: Process 1, 3
    Process 1:
      → Visit 2: dist[2] = 2, parent[2] = 1
    Process 3:
      → Visit 4: dist[4] = 2, parent[4] = 3
      → Visit 7: dist[7] = 2, parent[7] = 3
      
  Level 2: Process 2, 4, 7
    Process 4:
      → Visit 5: dist[5] = 3, parent[5] = 4
      → Visit 6: dist[6] = 3, parent[6] = 4
      
  Level 3: Process 5, 6
    (all neighbors already visited)

Path from 0 to 6: Trace parent pointers
  6 → parent[6] = 4 → parent[4] = 3 → parent[3] = 0
  Path: 0 → 3 → 4 → 6 (length 3)
```

### Multi-Source BFS

When you need shortest distance from multiple sources simultaneously:

```cpp
// Multi-source BFS - e.g., "Rotting Oranges" problem
vector<vector<int>> multiSourceBFS(
    vector<vector<int>>& grid, vector<pair<int,int>>& sources) {
    
    int rows = grid.size(), cols = grid[0].size();
    vector<vector<int>> dist(rows, vector<int>(cols, -1));
    queue<pair<int,int>> q;
    
    // Add ALL sources to queue initially
    for (auto& [r, c] : sources) {
        dist[r][c] = 0;
        q.push({r, c});
    }
    
    int dx[] = {0, 0, 1, -1};
    int dy[] = {1, -1, 0, 0};
    
    while (!q.empty()) {
        auto [x, y] = q.front();
        q.pop();
        
        for (int d = 0; d < 4; d++) {
            int nx = x + dx[d];
            int ny = y + dy[d];
            
            if (nx >= 0 && nx < rows && ny >= 0 && ny < cols 
                && dist[nx][ny] == -1 && grid[nx][ny] != 0) {
                dist[nx][ny] = dist[x][y] + 1;
                q.push({nx, ny});
            }
        }
    }
    
    return dist;
}
```

---

## Snakes and Ladders BFS

### Problem Statement

Given a Snakes and Ladders board, find the minimum number of dice throws required to reach the last cell from cell 1.

### Intuition

This is a **shortest path problem on an implicit graph**:
- Each cell is a vertex
- From each cell, you can reach cells 1-6 steps ahead (dice throw)
- Snakes and ladders are like **teleportation edges**
- We want minimum moves → **BFS**

### Visual Example

```
Board (6x6 = 36 cells):
36 35 34 33 32 31
25 26 27 28 29 30
24 23 22 21 20 19
13 14 15 16 17 18
12 11 10  9  8  7
 1  2  3  4  5  6

Ladders: 2→21, 4→7, 10→25, 19→28
Snakes:  26→0, 20→8, 16→3, 18→6

Graph interpretation:
- From cell 1, you can go to cells 2,3,4,5,6,7
- If you land on cell 2 (ladder), you teleport to 21
- If you land on cell 26 (snake), you go back to 0
```

### C++ Implementation (LeetCode 909)

```cpp
#include <bits/stdc++.h>
using namespace std;

class Solution {
public:
    int snakesAndLadders(vector<vector<int>>& board) {
        int n = board.size();
        int target = n * n;
        
        // Convert 2D board to 1D array
        vector<int> moves(target + 1, -1);
        int label = 1;
        bool leftToRight = true;
        
        for (int row = n - 1; row >= 0; row--) {
            if (leftToRight) {
                for (int col = 0; col < n; col++) {
                    if (board[row][col] != -1) {
                        moves[label] = board[row][col];
                    }
                    label++;
                }
            } else {
                for (int col = n - 1; col >= 0; col--) {
                    if (board[row][col] != -1) {
                        moves[label] = board[row][col];
                    }
                    label++;
                }
            }
            leftToRight = !leftToRight;
        }
        
        // BFS
        vector<int> dist(target + 1, -1);
        queue<int> q;
        dist[1] = 0;
        q.push(1);
        
        while (!q.empty()) {
            int curr = q.front();
            q.pop();
            
            for (int dice = 1; dice <= 6; dice++) {
                int next = curr + dice;
                if (next > target) break;
                
                // If there's a snake or ladder, take it
                if (moves[next] != -1) {
                    next = moves[next];
                }
                
                if (next == target) return dist[curr] + 1;
                
                if (dist[next] == -1) {
                    dist[next] = dist[curr] + 1;
                    q.push(next);
                }
            }
        }
        
        return -1;  // Cannot reach target
    }
};

// Simpler version for understanding
int minDiceThrows(int n, vector<pair<int,int>>& snakesLadders) {
    vector<int> board(n + 1, -1);
    for (auto& [from, to] : snakesLadders) {
        board[from] = to;
    }
    
    vector<int> dist(n + 1, -1);
    queue<int> q;
    dist[1] = 0;
    q.push(1);
    
    while (!q.empty()) {
        int curr = q.front();
        q.pop();
        
        for (int dice = 1; dice <= 6; dice++) {
            int next = curr + dice;
            if (next > n) break;
            
            if (board[next] != -1) {
                next = board[next];
            }
            
            if (next == n) return dist[curr] + 1;
            
            if (dist[next] == -1) {
                dist[next] = dist[curr] + 1;
                q.push(next);
            }
        }
    }
    
    return -1;
}
```

### Dry Run

```
Board: n = 30
Ladders: (3, 22), (5, 8), (11, 26), (20, 29)
Snakes: (27, 1), (21, 9), (17, 4), (19, 7)

BFS from cell 1:

Step 0: dist[1] = 0, queue = [1]

Step 1: Process cell 1
  Dice 1 → cell 2: dist[2] = 1
  Dice 2 → cell 3 → LADDER → cell 22: dist[22] = 1
  Dice 3 → cell 4: dist[4] = 1
  Dice 4 → cell 5 → LADDER → cell 8: dist[8] = 1
  Dice 5 → cell 6: dist[6] = 1
  Dice 6 → cell 7: dist[7] = 1
  queue = [2, 22, 4, 8, 6, 7]

Step 2: Process cell 2
  Dice 1 → cell 3 → LADDER → 22 (already visited)
  Dice 2 → cell 4 (already visited)
  ...
  
Step 3: Process cell 22 (reached via ladder!)
  Dice 1 → cell 23: dist[23] = 2
  Dice 2 → cell 24: dist[24] = 2
  Dice 3 → cell 25: dist[25] = 2
  Dice 4 → cell 26: dist[26] = 2
  Dice 5 → cell 27 → SNAKE → 1 (already visited)
  Dice 6 → cell 28: dist[28] = 2

...continue until reaching cell 30

Answer: Minimum dice throws to reach cell 30
```

### Key Observations
1. Treat the board as a graph with cells as nodes
2. Each cell has edges to cells reachable by dice (1-6 steps)
3. Snakes/ladders are just redirections (don't count as extra moves)
4. BFS guarantees minimum moves

---

## Depth First Search (DFS)

### Core Theory

DFS explores a graph by going as **deep as possible** along each branch before backtracking. It uses a **stack** (explicitly or via recursion).

### Visual Intuition

```
Starting from vertex 0:

Graph:
    0 --- 1 --- 4
    |     |
    2 --- 3 --- 5

DFS explores: 0 → 1 → 3 → 2 (backtrack) → 5 (backtrack) → 4 (backtrack)
                (goes deep before exploring siblings)

DFS Tree:
    0
    ├── 1
    │   ├── 3
    │   │   ├── 2
    │   │   └── 5
    │   └── 4
```

### BFS vs DFS Visual Comparison

```
Graph:        0
            / | \
           1  2  3
          /|     |
         4  5    6

BFS Order: 0, 1, 2, 3, 4, 5, 6  (level by level)
DFS Order: 0, 1, 4, 5, 2, 3, 6  (branch by branch)

BFS explores like spreading water:
Level 0: ●
Level 1: ● ● ●
Level 2: ● ● ●

DFS explores like a maze walker:
Goes deep: ● → ● → ●
Backtracks: ↩
Goes next:  ● → ●
```

### Algorithm (Recursive)

```
DFS(graph, vertex, visited):
    1. Mark vertex as visited
    2. Process vertex
    3. For each neighbor v of vertex:
        - If v is not visited:
            * DFS(graph, v, visited)
```

### Algorithm (Iterative with Stack)

```
DFS_Iterative(graph, source):
    1. Create stack S
    2. Push source onto S
    3. While S is not empty:
        a. Pop vertex u from S
        b. If u is not visited:
            - Mark u as visited
            - Process u
            - For each neighbor v of u:
                * If v is not visited:
                    Push v onto S
```

### C++ Implementation (Recursive)

```cpp
#include <bits/stdc++.h>
using namespace std;

class Graph {
    int V;
    vector<vector<int>> adj;
    
public:
    Graph(int v) : V(v), adj(v) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    // Recursive DFS
    void dfsRecursive(int u, vector<bool>& visited, vector<int>& order) {
        visited[u] = true;
        order.push_back(u);
        
        for (int v : adj[u]) {
            if (!visited[v]) {
                dfsRecursive(v, visited, order);
            }
        }
    }
    
    // Iterative DFS
    vector<int> dfsIterative(int source) {
        vector<int> order;
        vector<bool> visited(V, false);
        stack<int> stk;
        
        stk.push(source);
        
        while (!stk.empty()) {
            int u = stk.top();
            stk.pop();
            
            if (visited[u]) continue;
            visited[u] = true;
            order.push_back(u);
            
            // Push neighbors in reverse order for consistent ordering
            for (int i = adj[u].size() - 1; i >= 0; i--) {
                if (!visited[adj[u][i]]) {
                    stk.push(adj[u][i]);
                }
            }
        }
        
        return order;
    }
    
    // DFS for all components
    vector<int> dfsAll() {
        vector<int> order;
        vector<bool> visited(V, false);
        
        for (int i = 0; i < V; i++) {
            if (!visited[i]) {
                dfsRecursive(i, visited, order);
            }
        }
        
        return order;
    }
};

int main() {
    Graph g(6);
    g.addEdge(0, 1);
    g.addEdge(0, 2);
    g.addEdge(1, 3);
    g.addEdge(1, 4);
    g.addEdge(2, 3);
    g.addEdge(3, 5);
    
    vector<bool> visited(6, false);
    vector<int> order;
    g.dfsRecursive(0, visited, order);
    
    cout << "DFS Order (Recursive): ";
    for (int v : order) cout << v << " ";
    cout << endl;
    
    vector<int> iterOrder = g.dfsIterative(0);
    cout << "DFS Order (Iterative): ";
    for (int v : iterOrder) cout << v << " ";
    cout << endl;
    
    return 0;
}
```

### Dry Run - DFS Recursive

```
Graph:
    0 --- 1 --- 4
    |     |
    2 --- 3 --- 5

adj[0] = [1, 2]
adj[1] = [0, 3, 4]
adj[2] = [0, 3]
adj[3] = [1, 2, 5]
adj[4] = [1]
adj[5] = [3]

DFS(0):
  visited[0] = true, order = [0]
  ├── Neighbor 1: not visited
  │   DFS(1):
  │     visited[1] = true, order = [0, 1]
  │     ├── Neighbor 0: visited → skip
  │     ├── Neighbor 3: not visited
  │     │   DFS(3):
  │     │     visited[3] = true, order = [0, 1, 3]
  │     │     ├── Neighbor 1: visited → skip
  │     │     ├── Neighbor 2: not visited
  │     │     │   DFS(2):
  │     │     │     visited[2] = true, order = [0, 1, 3, 2]
  │     │     │     ├── Neighbor 0: visited → skip
  │     │     │     └── Neighbor 3: visited → skip
  │     │     │     RETURN
  │     │     └── Neighbor 5: not visited
  │     │         DFS(5):
  │     │           visited[5] = true, order = [0, 1, 3, 2, 5]
  │     │           └── Neighbor 3: visited → skip
  │     │           RETURN
  │     │   RETURN
  │     └── Neighbor 4: not visited
  │         DFS(4):
  │           visited[4] = true, order = [0, 1, 3, 2, 5, 4]
  │           └── Neighbor 1: visited → skip
  │           RETURN
  │   RETURN
  └── Neighbor 2: visited → skip
  RETURN

Final DFS Order: 0, 1, 3, 2, 5, 4
```

### Complexity Analysis

| Aspect | Complexity |
|--------|-----------|
| Time | O(V + E) |
| Space (Recursive) | O(V) for visited + O(V) for recursion stack |
| Space (Iterative) | O(V) for visited + O(V) for explicit stack |
| Worst Case Stack Depth | O(V) - for a path graph |

### DFS Edge Classification

During DFS, edges can be classified as:

```
┌──────────────────────────────────────────────────┐
│ EDGE TYPES IN DFS:                                │
│                                                   │
│ 1. Tree Edge: Edge in the DFS tree               │
│    (leads to unvisited vertex)                    │
│                                                   │
│ 2. Back Edge: Edge to ancestor in DFS tree       │
│    (indicates CYCLE)                              │
│                                                   │
│ 3. Forward Edge: Edge to descendant              │
│    (only in directed graphs)                      │
│                                                   │
│ 4. Cross Edge: Edge to non-ancestor/descendant   │
│    (only in directed graphs)                      │
└──────────────────────────────────────────────────┘
```

### DFS with Entry/Exit Times

```cpp
#include <bits/stdc++.h>
using namespace std;

int timer_val = 0;

void dfsWithTimes(int u, vector<vector<int>>& adj, 
                  vector<bool>& visited,
                  vector<int>& entry, vector<int>& exit_time) {
    visited[u] = true;
    entry[u] = timer_val++;
    
    for (int v : adj[u]) {
        if (!visited[v]) {
            dfsWithTimes(v, adj, visited, entry, exit_time);
        }
    }
    
    exit_time[u] = timer_val++;
}

// Property: u is ancestor of v iff entry[u] < entry[v] && exit[u] > exit[v]
```

---

## Connected Components

### Theory

A **connected component** is a maximal set of vertices such that there exists a path between every pair of vertices in the set.

### Visual Example

```
Graph with 3 components:

Component 1:    Component 2:    Component 3:
  0 --- 1         3 --- 4         6
  |     |         |
  2               5

Vertices in each component:
  Component 1: {0, 1, 2}
  Component 2: {3, 4, 5}
  Component 3: {6}
```

### Algorithm

```
1. Initialize all vertices as unvisited
2. For each vertex v from 0 to V-1:
    - If v is not visited:
        * Start a new component
        * Run BFS/DFS from v
        * All vertices reached belong to this component
3. Return components
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class ConnectedComponents {
    int V;
    vector<vector<int>> adj;
    
public:
    ConnectedComponents(int v) : V(v), adj(v) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    // DFS to mark all vertices in a component
    void dfs(int u, vector<bool>& visited, vector<int>& component) {
        visited[u] = true;
        component.push_back(u);
        
        for (int v : adj[u]) {
            if (!visited[v]) {
                dfs(v, visited, component);
            }
        }
    }
    
    // Find all connected components
    vector<vector<int>> findComponents() {
        vector<vector<int>> components;
        vector<bool> visited(V, false);
        
        for (int i = 0; i < V; i++) {
            if (!visited[i]) {
                vector<int> component;
                dfs(i, visited, component);
                components.push_back(component);
            }
        }
        
        return components;
    }
    
    // Count connected components
    int countComponents() {
        return findComponents().size();
    }
    
    // Get component ID for each vertex
    vector<int> getComponentIds() {
        vector<int> compId(V, -1);
        vector<bool> visited(V, false);
        int id = 0;
        
        for (int i = 0; i < V; i++) {
            if (!visited[i]) {
                queue<int> q;
                q.push(i);
                visited[i] = true;
                
                while (!q.empty()) {
                    int u = q.front();
                    q.pop();
                    compId[u] = id;
                    
                    for (int v : adj[u]) {
                        if (!visited[v]) {
                            visited[v] = true;
                            q.push(v);
                        }
                    }
                }
                id++;
            }
        }
        
        return compId;
    }
};

// Number of Islands (Grid-based connected components)
int numIslands(vector<vector<char>>& grid) {
    int rows = grid.size(), cols = grid[0].size();
    int count = 0;
    
    int dx[] = {0, 0, 1, -1};
    int dy[] = {1, -1, 0, 0};
    
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] == '1') {
                count++;
                // BFS to mark entire island
                queue<pair<int,int>> q;
                q.push({i, j});
                grid[i][j] = '0';  // Mark visited
                
                while (!q.empty()) {
                    auto [x, y] = q.front();
                    q.pop();
                    
                    for (int d = 0; d < 4; d++) {
                        int nx = x + dx[d];
                        int ny = y + dy[d];
                        
                        if (nx >= 0 && nx < rows && ny >= 0 && ny < cols 
                            && grid[nx][ny] == '1') {
                            grid[nx][ny] = '0';
                            q.push({nx, ny});
                        }
                    }
                }
            }
        }
    }
    
    return count;
}

int main() {
    ConnectedComponents g(7);
    g.addEdge(0, 1);
    g.addEdge(0, 2);
    g.addEdge(1, 2);
    g.addEdge(3, 4);
    g.addEdge(3, 5);
    // Vertex 6 is isolated
    
    auto components = g.findComponents();
    
    cout << "Number of components: " << components.size() << endl;
    for (int i = 0; i < components.size(); i++) {
        cout << "Component " << i << ": ";
        for (int v : components[i]) cout << v << " ";
        cout << endl;
    }
    
    return 0;
}
```

### Dry Run

```
Graph: 7 vertices
Edges: (0,1), (0,2), (1,2), (3,4), (3,5)
Vertex 6 is isolated.

Finding Components:

i = 0: not visited
  DFS(0): visits 0, 1, 2
  Component 0 = {0, 1, 2}
  
i = 1: already visited (part of component 0) → skip
i = 2: already visited → skip

i = 3: not visited
  DFS(3): visits 3, 4, 5
  Component 1 = {3, 4, 5}

i = 4: already visited → skip
i = 5: already visited → skip

i = 6: not visited
  DFS(6): visits 6
  Component 2 = {6}

Result: 3 components
```

---

## Journey to the Moon Problem

### Problem Statement (HackerRank)

There are N astronauts numbered 0 to N-1. Some pairs of astronauts are from the same country. We need to find the number of ways to choose 2 astronauts from **different** countries for a journey to the moon.

### Key Insight

- Astronauts from the same country form connected components
- We need to count pairs (a, b) where a and b are in different components
- Total pairs - pairs within same component = answer

### Formula

```
Total pairs = N * (N-1) / 2
Pairs within same component = Σ (size_i * (size_i - 1) / 2) for each component
Answer = Total pairs - Pairs within same component

Alternative formula:
Answer = Total pairs - Σ (size_i choose 2)

OR equivalently:
If component sizes are s1, s2, ..., sk:
Answer = (Σ si) * (Σ si) - Σ (si * si)  ... divided by 2
       = (N² - Σ si²) / 2
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

long long journeyToMoon(int n, vector<pair<int,int>>& astronauts) {
    vector<vector<int>> adj(n);
    
    for (auto& [u, v] : astronauts) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    // Find connected component sizes
    vector<bool> visited(n, false);
    vector<long long> componentSizes;
    
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            // BFS to find component size
            long long size = 0;
            queue<int> q;
            q.push(i);
            visited[i] = true;
            
            while (!q.empty()) {
                int u = q.front();
                q.pop();
                size++;
                
                for (int v : adj[u]) {
                    if (!visited[v]) {
                        visited[v] = true;
                        q.push(v);
                    }
                }
            }
            
            componentSizes.push_back(size);
        }
    }
    
    // Calculate answer
    long long totalPairs = (long long)n * (n - 1) / 2;
    long long samePairs = 0;
    
    for (long long s : componentSizes) {
        samePairs += s * (s - 1) / 2;
    }
    
    return totalPairs - samePairs;
}

// Alternative approach using running sum
long long journeyToMoonAlt(int n, vector<pair<int,int>>& astronauts) {
    vector<vector<int>> adj(n);
    for (auto& [u, v] : astronauts) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    vector<bool> visited(n, false);
    vector<long long> sizes;
    
    for (int i = 0; i < n; i++) {
        if (!visited[i]) {
            long long sz = 0;
            queue<int> q;
            q.push(i);
            visited[i] = true;
            while (!q.empty()) {
                int u = q.front(); q.pop();
                sz++;
                for (int v : adj[u]) {
                    if (!visited[v]) {
                        visited[v] = true;
                        q.push(v);
                    }
                }
            }
            sizes.push_back(sz);
        }
    }
    
    // Count pairs from different components
    long long answer = 0;
    long long sumSoFar = 0;
    for (long long s : sizes) {
        answer += sumSoFar * s;
        sumSoFar += s;
    }
    
    return answer;
}

int main() {
    int n = 5;
    vector<pair<int,int>> pairs = {{0, 1}, {2, 3}, {0, 4}};
    
    cout << "Pairs from different countries: " << journeyToMoon(n, pairs) << endl;
    
    return 0;
}
```

### Dry Run

```
N = 5 astronauts, pairs: (0,1), (2,3), (0,4)

Build adjacency list:
adj[0] = [1, 4]
adj[1] = [0]
adj[2] = [3]
adj[3] = [2]
adj[4] = [0]

Find components:
Component 1: BFS from 0 → visits {0, 1, 4} → size = 3
Component 2: BFS from 2 → visits {2, 3} → size = 2

Component sizes: [3, 2]

Total pairs = 5 * 4 / 2 = 10
Same country pairs = 3*2/2 + 2*1/2 = 3 + 1 = 4
Answer = 10 - 4 = 6

Alternative calculation:
sumSoFar = 0, answer = 0
  Component size 3: answer += 0 * 3 = 0, sumSoFar = 3
  Component size 2: answer += 3 * 2 = 6, sumSoFar = 5
Answer = 6 ✓
```

---

## BFS vs DFS Comparison

| Feature | BFS | DFS |
|---------|-----|-----|
| Data Structure | Queue | Stack/Recursion |
| Exploration | Level by level | Branch by branch |
| Shortest Path (unweighted) | ✅ Yes | ❌ No |
| Memory | O(width of graph) | O(depth of graph) |
| Complete | Yes (finds all reachable) | Yes |
| Best for | Shortest path, level-order | Cycle detection, topological sort |
| Path finding | Shortest path | Any path |
| Implementation | Iterative (usually) | Recursive (usually) |
| Space (worst case) | O(V) | O(V) |
| Space (tree, branching factor b, depth d) | O(b^d) | O(d) |

### When to Use BFS
1. **Shortest path in unweighted graph**
2. **Level-order traversal**
3. **Finding nearest** (nearest exit, nearest food, etc.)
4. **Minimum operations/moves** to reach target
5. **Multi-source problems** (multiple starting points)
6. **When depth is very large** (avoid stack overflow)

### When to Use DFS
1. **Cycle detection**
2. **Topological sorting**
3. **Connected components** (either works, but DFS is simpler)
4. **Finding all paths**
5. **Backtracking problems**
6. **When solution is deep** in the search tree
7. **Strongly connected components**
8. **Bridges and articulation points**

---

## Pattern Recognition

### How To Identify BFS/DFS Problems

#### Keywords for BFS:
1. "Minimum number of steps/moves"
2. "Shortest path" (unweighted)
3. "Level by level" / "Layer by layer"
4. "Nearest" / "Closest"
5. "Minimum operations to transform"
6. "Spreading" / "Propagation" (fire, water, virus)
7. "Multi-source" / "Multiple starting points"

#### Keywords for DFS:
1. "Find all paths"
2. "Detect cycle"
3. "Connected" / "Reachable"
4. "Component"
5. "Topological order"
6. "Backtrack"
7. "Explore all possibilities"

#### 30+ Pattern Examples:

1. "Minimum moves to solve puzzle" → BFS
2. "Can you reach from A to B?" → BFS or DFS
3. "Find shortest transformation sequence" → BFS (Word Ladder)
4. "Count connected regions in grid" → DFS/BFS (Number of Islands)
5. "Minimum time for all oranges to rot" → Multi-source BFS
6. "Find if cycle exists" → DFS
7. "Prerequisite ordering" → DFS (Topological Sort)
8. "6 degrees of separation" → BFS
9. "Flood fill a region" → DFS/BFS
10. "Minimum jumps to reach end" → BFS
11. "Clone a graph" → BFS/DFS
12. "Is graph bipartite?" → BFS/DFS coloring
13. "Find all rooms you can visit" → DFS
14. "Nearest exit in maze" → BFS
15. "Minimum knight moves" → BFS
16. "Open the lock" → BFS (state space)
17. "Word ladder" → BFS
18. "Pacific Atlantic water flow" → Multi-source DFS
19. "Surrounded regions" → Border DFS/BFS
20. "Time to inform employees" → BFS/DFS from root
21. "Shortest bridge between islands" → BFS
22. "Number of enclaves" → Border DFS
23. "Walls and gates" → Multi-source BFS
24. "Minimum genetic mutation" → BFS
25. "Bus routes minimum transfers" → BFS on super-graph
26. "Evaluate division" → DFS/BFS weighted
27. "All ancestors in DAG" → DFS
28. "Parallel courses" → Topological BFS (Kahn's)
29. "Course schedule" → DFS cycle detection
30. "Minimum cost to reach destination in grid" → BFS/Dijkstra
31. "Find all groups/clusters" → Connected components
32. "Is graph a valid tree?" → DFS + properties check

---

## Problem Solving

### Easy Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Flood Fill | LeetCode 733 | BFS/DFS on grid |
| 2 | Number of Islands | LeetCode 200 | Connected components |
| 3 | Max Area of Island | LeetCode 695 | DFS + counting |
| 4 | Find if Path Exists | LeetCode 1971 | BFS/DFS basic |
| 5 | Keys and Rooms | LeetCode 841 | DFS reachability |
| 6 | Find the Town Judge | LeetCode 997 | Degree counting |
| 7 | Find Center of Star | LeetCode 1791 | Degree concept |
| 8 | Island Perimeter | LeetCode 463 | Grid traversal |
| 9 | Employees Importance | LeetCode 690 | BFS/DFS tree |
| 10 | Binary Tree Level Order | LeetCode 102 | BFS |
| 11 | Same Tree | LeetCode 100 | DFS |
| 12 | Symmetric Tree | LeetCode 101 | BFS/DFS |
| 13 | Maximum Depth of Binary Tree | LeetCode 104 | DFS |
| 14 | Minimum Depth of Binary Tree | LeetCode 111 | BFS |
| 15 | Path Sum | LeetCode 112 | DFS |
| 16 | Count Sub Islands | LeetCode 1905 | DFS |
| 17 | BFS of Graph | GFG | BFS basic |
| 18 | DFS of Graph | GFG | DFS basic |
| 19 | Connected Components | HackerRank | Components |
| 20 | Nearest Exit from Entrance in Maze | LeetCode 1926 | BFS |

### Medium Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Rotting Oranges | LeetCode 994 | Multi-source BFS |
| 2 | 01 Matrix | LeetCode 542 | Multi-source BFS |
| 3 | Snakes and Ladders | LeetCode 909 | BFS on implicit graph |
| 4 | Open the Lock | LeetCode 752 | BFS state space |
| 5 | Word Ladder | LeetCode 127 | BFS transformation |
| 6 | Clone Graph | LeetCode 133 | BFS/DFS + HashMap |
| 7 | Pacific Atlantic Water Flow | LeetCode 417 | Multi-source DFS |
| 8 | Surrounded Regions | LeetCode 130 | Border DFS |
| 9 | Number of Enclaves | LeetCode 1020 | Border BFS |
| 10 | Shortest Bridge | LeetCode 934 | DFS + BFS |
| 11 | As Far from Land as Possible | LeetCode 1162 | Multi-source BFS |
| 12 | Walls and Gates | LeetCode 286 | Multi-source BFS |
| 13 | Shortest Path in Binary Matrix | LeetCode 1091 | BFS |
| 14 | Jump Game III | LeetCode 1306 | BFS/DFS |
| 15 | Minimum Knight Moves | LeetCode 1197 | BFS |
| 16 | Number of Provinces | LeetCode 547 | Connected components |
| 17 | Is Graph Bipartite | LeetCode 785 | BFS coloring |
| 18 | Possible Bipartition | LeetCode 886 | BFS/DFS bipartite |
| 19 | All Paths Source to Target | LeetCode 797 | DFS paths |
| 20 | Time Needed to Inform Employees | LeetCode 1376 | BFS/DFS |
| 21 | Minimum Genetic Mutation | LeetCode 433 | BFS |
| 22 | Bus Routes | LeetCode 815 | BFS super-graph |
| 23 | Shortest Path Alternating Colors | LeetCode 1129 | BFS with states |
| 24 | Minimum Jumps to Reach Home | LeetCode 1654 | BFS |
| 25 | Map of Highest Peak | LeetCode 1765 | Multi-source BFS |
| 26 | Detonate Maximum Bombs | LeetCode 2101 | DFS/BFS |
| 27 | Reorder Routes | LeetCode 1466 | DFS/BFS directed |
| 28 | Shortest Cycle in Undirected | LeetCode 2608 | BFS from each vertex |
| 29 | Number of Closed Islands | LeetCode 1254 | DFS |
| 30 | Making A Large Island | LeetCode 827 | BFS/DFS + components |

### Hard Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Word Ladder II | LeetCode 126 | BFS + DFS backtrack |
| 2 | Shortest Path Visiting All Nodes | LeetCode 847 | BFS + bitmask |
| 3 | Swim in Rising Water | LeetCode 778 | Binary search + BFS |
| 4 | Minimum Cost Valid Path in Grid | LeetCode 1368 | 0-1 BFS |
| 5 | Cut Off Trees for Golf Event | LeetCode 675 | Multiple BFS |
| 6 | Sliding Puzzle | LeetCode 773 | BFS state space |
| 7 | Race Car | LeetCode 818 | BFS |
| 8 | Minimum Moves to Move Box | LeetCode 1263 | Double BFS |
| 9 | Shortest Path in Grid with Obstacles | LeetCode 1293 | BFS + states |
| 10 | Minimum Obstacle Removal to Reach Corner | LeetCode 2290 | 0-1 BFS |
| 11 | Journey to the Moon | HackerRank | Components + math |
| 12 | Building Roads | CSES | Connected components |
| 13 | Message Route | CSES | BFS path |
| 14 | Labyrinth | CSES | BFS path reconstruction |
| 15 | Monsters | CSES | Multi-source BFS |
| 16 | Grid Paths | AtCoder | DFS + pruning |
| 17 | Frog Position After T Seconds | LeetCode 1377 | BFS + probability |
| 18 | Escape the Spreading Fire | LeetCode 2258 | Binary search + BFS |
| 19 | K-Similar Strings | LeetCode 854 | BFS state space |
| 20 | Shortest Path to Get All Keys | LeetCode 864 | BFS + bitmask |

---

## Interview Preparation

### Top 50+ Interview Questions

#### Theory Questions:
1. Explain BFS and DFS with examples.
2. What data structures do BFS and DFS use?
3. Why does BFS find shortest path in unweighted graphs?
4. Can DFS find shortest path? Why/why not?
5. What is the time complexity of BFS and DFS?
6. When would you prefer BFS over DFS and vice versa?
7. Explain level-order traversal.
8. What is a connected component?
9. How do you handle disconnected graphs in traversal?
10. Explain DFS edge classification (tree, back, forward, cross edges).
11. What happens if we use DFS on a very deep graph?
12. How does BFS handle cycles? (visited array prevents infinite loops)
13. Can BFS/DFS work on directed graphs?
14. What is multi-source BFS? When is it used?
15. Explain the concept of implicit graphs with examples.

#### Coding Questions:
16. Implement BFS from scratch.
17. Implement DFS (both recursive and iterative).
18. Find connected components in an undirected graph.
19. Find shortest path between two nodes (unweighted).
20. Solve "Number of Islands" problem.
21. Solve "Rotting Oranges" (multi-source BFS).
22. Clone a graph using BFS/DFS.
23. Check if a path exists between two nodes.
24. Find all nodes at distance K from a given node.
25. Solve word ladder problem.
26. Implement Snakes and Ladders using BFS.
27. Find if graph is bipartite using BFS.
28. Find the shortest bridge between two islands.
29. Solve the maze problem (find shortest exit).
30. Count number of provinces/connected regions.
31. Solve "Pacific Atlantic Water Flow".
32. Find the nearest cell having 1 (0-1 Matrix).
33. Solve "Open the Lock" problem.
34. Solve "Surrounded Regions" using border DFS.
35. Find level order traversal of binary tree.

#### Follow-up Questions:
36. How would you modify BFS for weighted graphs? (leads to Dijkstra)
37. How would BFS change if graph doesn't fit in memory?
38. Can you do BFS without a queue? (using two arrays)
39. How to parallelize BFS?
40. What is bidirectional BFS? When is it useful?
41. How to find all shortest paths (not just one)?
42. What is 0-1 BFS? When to use it?
43. How to handle negative weights? (BFS doesn't work)
44. What is iterative deepening DFS? Advantages?
45. How to detect cycle during BFS?

#### Tricky Cases:
46. BFS on infinite graph (how to handle?)
47. Self-loops in BFS (visited check handles it)
48. Multiple edges between same pair (BFS still works)
49. Graph with 10⁹ nodes (implicit graph, don't build adj list)
50. BFS/DFS on trees vs general graphs (no visited needed for trees? Wrong - needed for non-root direction)
51. Stack overflow in DFS (use iterative for large graphs)
52. Memory limit in BFS (wide graphs can fill queue)

#### FAANG Discussion Points:
53. Design a web crawler (BFS).
54. How does Google's PageRank relate to graph traversal?
55. Social network "People You May Know" feature (BFS levels).
56. How would you implement Google Maps' shortest route? (BFS → Dijkstra).

---

## Competitive Programming

### BFS Template (CP-ready)

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
    
    // BFS shortest path from source 1
    vector<int> dist(n + 1, -1);
    vector<int> parent(n + 1, -1);
    queue<int> q;
    
    dist[1] = 0;
    q.push(1);
    
    while (!q.empty()) {
        int u = q.front(); q.pop();
        for (int v : adj[u]) {
            if (dist[v] == -1) {
                dist[v] = dist[u] + 1;
                parent[v] = u;
                q.push(v);
            }
        }
    }
    
    // Print shortest path from 1 to n
    if (dist[n] == -1) {
        cout << "IMPOSSIBLE" << endl;
    } else {
        vector<int> path;
        for (int v = n; v != -1; v = parent[v]) path.push_back(v);
        reverse(path.begin(), path.end());
        cout << path.size() << endl;
        for (int v : path) cout << v << " ";
        cout << endl;
    }
    
    return 0;
}
```

### DFS Template (CP-ready)

```cpp
#include <bits/stdc++.h>
using namespace std;

const int MAXN = 2e5 + 5;
vector<int> adj[MAXN];
bool visited[MAXN];
int comp[MAXN];  // component ID for each vertex

void dfs(int u, int id) {
    visited[u] = true;
    comp[u] = id;
    for (int v : adj[u]) {
        if (!visited[v]) {
            dfs(v, id);
        }
    }
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
        adj[v].push_back(u);
    }
    
    int numComponents = 0;
    for (int i = 1; i <= n; i++) {
        if (!visited[i]) {
            dfs(i, numComponents);
            numComponents++;
        }
    }
    
    cout << numComponents << endl;
    
    return 0;
}
```

### Grid BFS Template

```cpp
#include <bits/stdc++.h>
using namespace std;

int dx[] = {0, 0, 1, -1};
int dy[] = {1, -1, 0, 0};
// For 8-directional: add {1,1},{1,-1},{-1,1},{-1,-1}

int main() {
    int rows, cols;
    cin >> rows >> cols;
    
    vector<string> grid(rows);
    for (int i = 0; i < rows; i++) cin >> grid[i];
    
    // BFS from top-left to bottom-right
    vector<vector<int>> dist(rows, vector<int>(cols, -1));
    queue<pair<int,int>> q;
    
    dist[0][0] = 0;
    q.push({0, 0});
    
    while (!q.empty()) {
        auto [x, y] = q.front(); q.pop();
        
        for (int d = 0; d < 4; d++) {
            int nx = x + dx[d];
            int ny = y + dy[d];
            
            if (nx >= 0 && nx < rows && ny >= 0 && ny < cols 
                && grid[nx][ny] != '#' && dist[nx][ny] == -1) {
                dist[nx][ny] = dist[x][y] + 1;
                q.push({nx, ny});
            }
        }
    }
    
    cout << dist[rows-1][cols-1] << endl;
    
    return 0;
}
```

### CP Tricks

1. **0-1 BFS**: When edge weights are 0 or 1, use deque instead of priority queue
   ```cpp
   deque<int> dq;
   // Weight 0 edge → push_front
   // Weight 1 edge → push_back
   ```

2. **Bidirectional BFS**: Run BFS from both source and target simultaneously
   - Reduces search space from O(b^d) to O(b^(d/2))
   - Meet in the middle

3. **BFS with states**: When simple position isn't enough
   ```cpp
   // BFS with keys collected (bitmask)
   queue<tuple<int, int, int>> q; // (x, y, keys_bitmask)
   visited[x][y][keys] = true;
   ```

4. **Avoid recursion depth issues**: Use iterative DFS for graphs with depth > 10⁵

### Common Mistakes

1. ❌ Forgetting to mark visited BEFORE pushing to queue (leads to duplicates)
2. ❌ Marking visited AFTER popping from queue (leads to TLE)
3. ❌ Not handling disconnected graphs
4. ❌ Stack overflow with recursive DFS on large graphs
5. ❌ Using DFS for shortest path (gives wrong answer)
6. ❌ Forgetting boundary checks in grid BFS
7. ❌ Integer overflow in "journey to moon" style problems

---

## Advanced Section

### Bidirectional BFS

```cpp
int bidirectionalBFS(vector<vector<int>>& adj, int src, int dst, int n) {
    if (src == dst) return 0;
    
    vector<int> distS(n, -1), distD(n, -1);
    queue<int> qS, qD;
    
    distS[src] = 0; qS.push(src);
    distD[dst] = 0; qD.push(dst);
    
    while (!qS.empty() && !qD.empty()) {
        // Expand from source side
        int u = qS.front(); qS.pop();
        for (int v : adj[u]) {
            if (distS[v] == -1) {
                distS[v] = distS[u] + 1;
                if (distD[v] != -1) return distS[v] + distD[v];
                qS.push(v);
            }
        }
        
        // Expand from destination side
        u = qD.front(); qD.pop();
        for (int v : adj[u]) {
            if (distD[v] == -1) {
                distD[v] = distD[u] + 1;
                if (distS[v] != -1) return distS[v] + distD[v];
                qD.push(v);
            }
        }
    }
    
    return -1; // No path
}
```

### Iterative Deepening DFS (IDDFS)

Combines DFS's space efficiency with BFS's shortest-path guarantee:

```cpp
bool depthLimitedDFS(vector<vector<int>>& adj, int u, int target, 
                     int limit, vector<bool>& visited) {
    if (u == target) return true;
    if (limit <= 0) return false;
    
    visited[u] = true;
    for (int v : adj[u]) {
        if (!visited[v]) {
            if (depthLimitedDFS(adj, v, target, limit - 1, visited))
                return true;
        }
    }
    visited[u] = false; // Unmark for next iteration
    return false;
}

int iddfs(vector<vector<int>>& adj, int src, int target, int n) {
    for (int depth = 0; depth < n; depth++) {
        vector<bool> visited(n, false);
        if (depthLimitedDFS(adj, src, target, depth, visited))
            return depth;
    }
    return -1;
}
```

### Connection to Future Topics

- **03_Undirected_Graph**: Flood fill, cycle detection, bipartite check all use BFS/DFS
- **04_Directed_Graph**: Topological sort uses DFS, Kahn's uses BFS
- **05_Disjoint_Set**: Alternative to BFS/DFS for connectivity
- **07_Shortest_Paths**: Dijkstra is a "weighted BFS" using priority queue

---

## Cheat Sheet

### One-Page Revision

```
BFS:
• Uses QUEUE (FIFO)
• Explores level by level
• Finds shortest path in UNWEIGHTED graphs
• Time: O(V + E), Space: O(V)
• Mark visited BEFORE pushing to queue

DFS:
• Uses STACK / RECURSION
• Explores as deep as possible
• Does NOT find shortest path
• Time: O(V + E), Space: O(V)
• Used for: cycles, topological sort, components, SCC

CONNECTED COMPONENTS:
• Run DFS/BFS from each unvisited vertex
• Each run discovers one component
• Number of runs = number of components

GRID BFS:
• dx = {0, 0, 1, -1}, dy = {1, -1, 0, 0}
• Check boundaries before pushing
• Mark visited when pushing (not when popping)

MULTI-SOURCE BFS:
• Push ALL sources into queue initially with dist = 0
• Rest is same as normal BFS
• Used for: rotting oranges, nearest distance problems
```

### Complexity Table

| Algorithm | Time | Space | Finds Shortest Path? |
|-----------|------|-------|---------------------|
| BFS | O(V+E) | O(V) | Yes (unweighted) |
| DFS (recursive) | O(V+E) | O(V) call stack | No |
| DFS (iterative) | O(V+E) | O(V) | No |
| Multi-source BFS | O(V+E) | O(V) | Yes (from nearest source) |
| Bidirectional BFS | O(b^(d/2)) | O(b^(d/2)) | Yes |

### Common Pitfalls

1. ❌ Using DFS when shortest path is needed → Use BFS
2. ❌ Not marking visited before queue push → TLE/MLE
3. ❌ Stack overflow with DFS → Use iterative for large N
4. ❌ Forgetting disconnected components → Loop over all vertices
5. ❌ Wrong grid boundary check → Segfault
6. ❌ Modifying grid during BFS without proper visited → Bugs

### Quick Interview Notes

- Always ask: "Shortest path?" → BFS. "Just reachability?" → Either.
- Connected components = number of BFS/DFS calls needed
- Grid = implicit graph, cells = nodes, 4/8 directions = edges
- State-space BFS: when node = (position + some state)
- Multi-source BFS: add all sources at dist 0 simultaneously
