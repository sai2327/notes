# Graph Data Structure - Introduction

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Core Theory](#core-theory)
- [Important Definitions](#important-definitions)
- [Graph Representation](#graph-representation)
- [Adjacency Matrix](#adjacency-matrix)
- [Adjacency List](#adjacency-list)
- [Comparison Table](#comparison-table)
- [Properties](#properties)
- [Intuition Building](#intuition-building)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Advanced Section](#advanced-section)
- [Cheat Sheet](#cheat-sheet)

---

## Introduction

### What is a Graph?

A **Graph** is a non-linear data structure consisting of a set of **vertices** (also called nodes) and a set of **edges** that connect pairs of vertices. It is one of the most fundamental and versatile data structures in computer science.

Formally, a graph G is defined as:
```
G = (V, E)
where:
  V = Set of vertices
  E = Set of edges, where each edge is a pair (u, v) with u, v ∈ V
```

### Why is it Important?

Graphs are everywhere in the real world and in computing:

1. **Social Networks**: Facebook, LinkedIn - users are nodes, friendships are edges
2. **Maps & Navigation**: Cities are nodes, roads are edges (Google Maps, GPS)
3. **Internet**: Web pages are nodes, hyperlinks are edges
4. **Computer Networks**: Devices are nodes, connections are edges
5. **Dependency Resolution**: Package managers, build systems
6. **Recommendation Systems**: Netflix, Amazon
7. **Biology**: Protein interaction networks, neural networks
8. **Chemistry**: Molecular structures

### Competitive Programming Applications

- Almost 30-40% of problems in contests involve graphs
- Graph problems appear in every competitive programming contest
- Understanding graphs is essential for Codeforces Div 1/2, ICPC, IOI
- Many dynamic programming problems are disguised graph problems

### Interview Relevance

- **FAANG Companies**: 40%+ of coding interviews involve graph problems
- **Amazon**: Frequently asks BFS/DFS, shortest path problems
- **Google**: Complex graph problems, network flow
- **Microsoft**: Tree and graph traversal problems
- **Meta**: Social network related graph problems

---

## Prerequisites

Before studying graphs, you should be comfortable with:

1. **Arrays and Vectors** - For storing graph data
2. **Linked Lists** - Concept of pointers and references
3. **Stacks and Queues** - Used in DFS and BFS
4. **Recursion** - DFS is fundamentally recursive
5. **Basic Mathematics** - Combinatorics, set theory
6. **Time/Space Complexity** - Big O notation
7. **C++ STL** - vectors, pairs, maps, sets, queues, priority queues

---

## Core Theory

### Mathematical Foundation

A graph G = (V, E) where:
- |V| = n (number of vertices)
- |E| = m (number of edges)

#### Types of Graphs

```
┌─────────────────────────────────────────────────────────────┐
│                    TYPES OF GRAPHS                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Based on Direction:                                         │
│  ├── Undirected Graph (edges have no direction)              │
│  └── Directed Graph (edges have direction)                   │
│                                                              │
│  Based on Weight:                                            │
│  ├── Unweighted Graph (all edges equal)                      │
│  └── Weighted Graph (edges have weights/costs)               │
│                                                              │
│  Based on Cycles:                                            │
│  ├── Cyclic Graph (contains at least one cycle)              │
│  └── Acyclic Graph (no cycles)                               │
│      └── DAG (Directed Acyclic Graph)                        │
│                                                              │
│  Based on Connectivity:                                      │
│  ├── Connected Graph (path exists between all pairs)         │
│  └── Disconnected Graph (some vertices unreachable)          │
│                                                              │
│  Special Graphs:                                             │
│  ├── Tree (connected acyclic undirected graph)               │
│  ├── Forest (collection of trees)                            │
│  ├── Complete Graph (every pair connected)                   │
│  ├── Bipartite Graph (2-colorable)                           │
│  ├── Planar Graph (can be drawn without edge crossing)       │
│  └── Sparse/Dense Graph                                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Visual Representation

#### Undirected Graph
```
    1 --- 2
    |   / |
    |  /  |
    | /   |
    3 --- 4
    
V = {1, 2, 3, 4}
E = {(1,2), (1,3), (2,3), (2,4), (3,4)}
```

#### Directed Graph
```
    1 --> 2
    |   ↗ |
    |  /  |
    ↓ /   ↓
    3 --> 4
    
V = {1, 2, 3, 4}
E = {(1,2), (1,3), (3,2), (2,4), (3,4)}
```

#### Weighted Graph
```
    1 --5-- 2
    |     / |
    3   2   7
    |  /    |
    3 --4-- 4
```

### Degree of a Vertex

**Undirected Graph:**
- **Degree(v)** = number of edges incident to v
- Sum of all degrees = 2 × |E| (Handshaking Lemma)

**Directed Graph:**
- **In-degree(v)** = number of edges coming INTO v
- **Out-degree(v)** = number of edges going OUT of v
- Sum of in-degrees = Sum of out-degrees = |E|

### Key Properties

| Property | Undirected | Directed |
|----------|-----------|----------|
| Max edges (simple) | n(n-1)/2 | n(n-1) |
| Max edges (with self-loops) | n(n+1)/2 | n² |
| Sum of degrees | 2m | m (in) + m (out) |
| Tree edges | n-1 | n-1 |
| Complete graph edges | n(n-1)/2 | n(n-1) |

---

## Important Definitions

### 1. Vertex (Node)
A fundamental unit of a graph. Each vertex can store data.
```
Example: In a social network, each person is a vertex.
```

### 2. Edge
A connection between two vertices.
```
Example: A friendship between two people.
```

### 3. Adjacent Vertices
Two vertices are adjacent if there's an edge between them.
```
In graph: 1 -- 2 -- 3
Vertex 1 and 2 are adjacent.
Vertex 1 and 3 are NOT adjacent.
```

### 4. Path
A sequence of vertices where each adjacent pair is connected by an edge.
```
In graph: 1 -- 2 -- 3 -- 4
Path from 1 to 4: [1, 2, 3, 4]
```

### 5. Simple Path
A path where no vertex is repeated.

### 6. Cycle
A path that starts and ends at the same vertex with no repeated edges.
```
    1 -- 2
    |    |
    4 -- 3
Cycle: 1 → 2 → 3 → 4 → 1
```

### 7. Connected Graph
An undirected graph where there's a path between every pair of vertices.

### 8. Strongly Connected (Directed)
A directed graph where there's a directed path from every vertex to every other vertex.

### 9. Component
A maximal connected subgraph.

### 10. Tree
A connected acyclic undirected graph with exactly n-1 edges.

### 11. Spanning Tree
A subgraph that is a tree and includes all vertices of the original graph.

### 12. Subgraph
G' = (V', E') is a subgraph of G = (V, E) if V' ⊆ V and E' ⊆ E.

### 13. Complete Graph (Kn)
A graph where every pair of distinct vertices is connected by an edge.

### 14. Bipartite Graph
A graph whose vertices can be divided into two disjoint sets such that every edge connects a vertex in one set to one in the other.

### 15. DAG (Directed Acyclic Graph)
A directed graph with no cycles.

---

## Graph Representation

There are multiple ways to represent a graph in computer memory. The two most common are:

1. **Adjacency Matrix**
2. **Adjacency List**

Other representations include:
3. Edge List
4. Incidence Matrix
5. Compressed Sparse Row (CSR)

---

## Adjacency Matrix

### Theory

An adjacency matrix is a 2D array of size V × V where V is the number of vertices. The element `matrix[i][j]` indicates whether there is an edge from vertex i to vertex j.

```
For unweighted graph:
  matrix[i][j] = 1  if edge exists from i to j
  matrix[i][j] = 0  otherwise

For weighted graph:
  matrix[i][j] = weight  if edge exists from i to j
  matrix[i][j] = 0 or ∞  otherwise
```

### Visual Example

```
Graph:
    0 --- 1
    |   / |
    |  /  |
    | /   |
    2 --- 3

Adjacency Matrix:
       0  1  2  3
    0 [0, 1, 1, 0]
    1 [1, 0, 1, 1]
    2 [1, 1, 0, 1]
    3 [0, 1, 1, 0]
```

### For Directed Graph
```
Graph:
    0 --> 1
    |     |
    ↓     ↓
    2 --> 3

Adjacency Matrix:
       0  1  2  3
    0 [0, 1, 1, 0]
    1 [0, 0, 0, 1]
    2 [0, 0, 0, 1]
    3 [0, 0, 0, 0]

Note: Matrix is NOT symmetric for directed graphs
```

### For Weighted Graph
```
Graph:
    0 --5-- 1
    |       |
    3       7
    |       |
    2 --2-- 3

Adjacency Matrix:
       0  1  2  3
    0 [0, 5, 3, 0]
    1 [5, 0, 0, 7]
    2 [3, 0, 0, 2]
    3 [0, 7, 2, 0]
```

### C++ Implementation - Adjacency Matrix

```cpp
#include <bits/stdc++.h>
using namespace std;

class GraphMatrix {
private:
    int V;                      // Number of vertices
    vector<vector<int>> adj;    // Adjacency matrix
    bool directed;

public:
    // Constructor
    GraphMatrix(int vertices, bool isDirected = false) {
        V = vertices;
        directed = isDirected;
        adj.assign(V, vector<int>(V, 0));
    }

    // Add edge (unweighted)
    void addEdge(int u, int v) {
        adj[u][v] = 1;
        if (!directed) {
            adj[v][u] = 1;
        }
    }

    // Add edge (weighted)
    void addEdge(int u, int v, int weight) {
        adj[u][v] = weight;
        if (!directed) {
            adj[v][u] = weight;
        }
    }

    // Remove edge
    void removeEdge(int u, int v) {
        adj[u][v] = 0;
        if (!directed) {
            adj[v][u] = 0;
        }
    }

    // Check if edge exists
    bool hasEdge(int u, int v) {
        return adj[u][v] != 0;
    }

    // Get degree of vertex (undirected)
    int degree(int v) {
        int deg = 0;
        for (int i = 0; i < V; i++) {
            if (adj[v][i] != 0) deg++;
        }
        return deg;
    }

    // Get in-degree (directed)
    int inDegree(int v) {
        int deg = 0;
        for (int i = 0; i < V; i++) {
            if (adj[i][v] != 0) deg++;
        }
        return deg;
    }

    // Get out-degree (directed)
    int outDegree(int v) {
        int deg = 0;
        for (int i = 0; i < V; i++) {
            if (adj[v][i] != 0) deg++;
        }
        return deg;
    }

    // Get all neighbors
    vector<int> getNeighbors(int v) {
        vector<int> neighbors;
        for (int i = 0; i < V; i++) {
            if (adj[v][i] != 0) {
                neighbors.push_back(i);
            }
        }
        return neighbors;
    }

    // Print the matrix
    void print() {
        cout << "Adjacency Matrix:" << endl;
        cout << "   ";
        for (int i = 0; i < V; i++) cout << i << " ";
        cout << endl;
        for (int i = 0; i < V; i++) {
            cout << i << ": ";
            for (int j = 0; j < V; j++) {
                cout << adj[i][j] << " ";
            }
            cout << endl;
        }
    }

    // Count edges
    int countEdges() {
        int count = 0;
        for (int i = 0; i < V; i++) {
            for (int j = 0; j < V; j++) {
                if (adj[i][j] != 0) count++;
            }
        }
        return directed ? count : count / 2;
    }
};

int main() {
    // Example: Undirected unweighted graph
    GraphMatrix g(5, false);
    g.addEdge(0, 1);
    g.addEdge(0, 4);
    g.addEdge(1, 2);
    g.addEdge(1, 3);
    g.addEdge(1, 4);
    g.addEdge(2, 3);
    g.addEdge(3, 4);

    g.print();
    cout << "Degree of vertex 1: " << g.degree(1) << endl;
    cout << "Edge between 0 and 1: " << g.hasEdge(0, 1) << endl;
    cout << "Edge between 0 and 2: " << g.hasEdge(0, 2) << endl;
    cout << "Number of edges: " << g.countEdges() << endl;

    return 0;
}
```

### Dry Run

```
Creating graph with 5 vertices (0-indexed):
Edges: (0,1), (0,4), (1,2), (1,3), (1,4), (2,3), (3,4)

Step 1: Initialize 5x5 matrix with all 0s
    0 1 2 3 4
0 [ 0 0 0 0 0 ]
1 [ 0 0 0 0 0 ]
2 [ 0 0 0 0 0 ]
3 [ 0 0 0 0 0 ]
4 [ 0 0 0 0 0 ]

Step 2: Add edge (0,1) → matrix[0][1] = 1, matrix[1][0] = 1
    0 1 2 3 4
0 [ 0 1 0 0 0 ]
1 [ 1 0 0 0 0 ]
2 [ 0 0 0 0 0 ]
3 [ 0 0 0 0 0 ]
4 [ 0 0 0 0 0 ]

Step 3: Add edge (0,4) → matrix[0][4] = 1, matrix[4][0] = 1
    0 1 2 3 4
0 [ 0 1 0 0 1 ]
1 [ 1 0 0 0 0 ]
2 [ 0 0 0 0 0 ]
3 [ 0 0 0 0 0 ]
4 [ 1 0 0 0 0 ]

... (continue for all edges)

Final Matrix:
    0 1 2 3 4
0 [ 0 1 0 0 1 ]
1 [ 1 0 1 1 1 ]
2 [ 0 1 0 1 0 ]
3 [ 0 1 1 0 1 ]
4 [ 1 1 0 1 0 ]
```

### Complexity Analysis

| Operation | Time Complexity | Space Complexity |
|-----------|----------------|-----------------|
| Add Edge | O(1) | - |
| Remove Edge | O(1) | - |
| Check Edge | O(1) | - |
| Get Neighbors | O(V) | O(V) |
| Get Degree | O(V) | O(1) |
| Storage | - | O(V²) |
| Initialize | O(V²) | O(V²) |

### Advantages of Adjacency Matrix
1. O(1) edge lookup - fastest possible
2. Simple to implement
3. Good for dense graphs (E ≈ V²)
4. Easy to check if edge exists
5. Matrix operations (matrix exponentiation for counting paths)

### Disadvantages of Adjacency Matrix
1. O(V²) space - wasteful for sparse graphs
2. O(V) to find all neighbors
3. Cannot store multiple edges between same pair
4. Adding a vertex requires recreating the entire matrix

---

## Adjacency List

### Theory

An adjacency list represents a graph as an array of lists. The index of the array represents a vertex, and each element in its list represents the vertices adjacent to it.

```
For vertex v, adj[v] = list of all vertices connected to v
```

### Visual Example

```
Graph:
    0 --- 1
    |   / |
    |  /  |
    | /   |
    2 --- 3

Adjacency List:
0 → [1, 2]
1 → [0, 2, 3]
2 → [0, 1, 3]
3 → [1, 2]
```

### For Directed Graph
```
Graph:
    0 --> 1
    |     |
    ↓     ↓
    2 --> 3

Adjacency List:
0 → [1, 2]
1 → [3]
2 → [3]
3 → []
```

### For Weighted Graph
```
Graph:
    0 --5-- 1
    |       |
    3       7
    |       |
    2 --2-- 3

Adjacency List (storing pairs):
0 → [(1, 5), (2, 3)]
1 → [(0, 5), (3, 7)]
2 → [(0, 3), (3, 2)]
3 → [(1, 7), (2, 2)]
```

### C++ Implementation - Adjacency List

```cpp
#include <bits/stdc++.h>
using namespace std;

class GraphList {
private:
    int V;
    vector<vector<int>> adj;        // For unweighted
    bool directed;

public:
    // Constructor
    GraphList(int vertices, bool isDirected = false) {
        V = vertices;
        directed = isDirected;
        adj.resize(V);
    }

    // Add edge (unweighted)
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        if (!directed) {
            adj[v].push_back(u);
        }
    }

    // Remove edge
    void removeEdge(int u, int v) {
        adj[u].erase(remove(adj[u].begin(), adj[u].end(), v), adj[u].end());
        if (!directed) {
            adj[v].erase(remove(adj[v].begin(), adj[v].end(), u), adj[v].end());
        }
    }

    // Check if edge exists
    bool hasEdge(int u, int v) {
        return find(adj[u].begin(), adj[u].end(), v) != adj[u].end();
    }

    // Get degree
    int degree(int v) {
        return adj[v].size();
    }

    // Get neighbors
    vector<int>& getNeighbors(int v) {
        return adj[v];
    }

    // Print the list
    void print() {
        cout << "Adjacency List:" << endl;
        for (int i = 0; i < V; i++) {
            cout << i << " → [";
            for (int j = 0; j < adj[i].size(); j++) {
                cout << adj[i][j];
                if (j < adj[i].size() - 1) cout << ", ";
            }
            cout << "]" << endl;
        }
    }

    // Count edges
    int countEdges() {
        int count = 0;
        for (int i = 0; i < V; i++) {
            count += adj[i].size();
        }
        return directed ? count : count / 2;
    }

    // Get number of vertices
    int getV() { return V; }
};

int main() {
    GraphList g(5, false);
    g.addEdge(0, 1);
    g.addEdge(0, 4);
    g.addEdge(1, 2);
    g.addEdge(1, 3);
    g.addEdge(1, 4);
    g.addEdge(2, 3);
    g.addEdge(3, 4);

    g.print();
    cout << "Degree of vertex 1: " << g.degree(1) << endl;
    cout << "Has edge (0,1): " << g.hasEdge(0, 1) << endl;
    cout << "Has edge (0,2): " << g.hasEdge(0, 2) << endl;

    return 0;
}
```

### Weighted Adjacency List

```cpp
#include <bits/stdc++.h>
using namespace std;

class WeightedGraph {
private:
    int V;
    vector<vector<pair<int, int>>> adj;  // pair<neighbor, weight>
    bool directed;

public:
    WeightedGraph(int vertices, bool isDirected = false) {
        V = vertices;
        directed = isDirected;
        adj.resize(V);
    }

    void addEdge(int u, int v, int weight) {
        adj[u].push_back({v, weight});
        if (!directed) {
            adj[v].push_back({u, weight});
        }
    }

    void print() {
        cout << "Weighted Adjacency List:" << endl;
        for (int i = 0; i < V; i++) {
            cout << i << " → [";
            for (int j = 0; j < adj[i].size(); j++) {
                cout << "(" << adj[i][j].first << ", w=" << adj[i][j].second << ")";
                if (j < adj[i].size() - 1) cout << ", ";
            }
            cout << "]" << endl;
        }
    }

    vector<vector<pair<int, int>>>& getAdj() { return adj; }
    int getV() { return V; }
};

int main() {
    WeightedGraph g(4, false);
    g.addEdge(0, 1, 5);
    g.addEdge(0, 2, 3);
    g.addEdge(1, 3, 7);
    g.addEdge(2, 3, 2);

    g.print();
    return 0;
}
```

### Competitive Programming Style (Most Common)

```cpp
#include <bits/stdc++.h>
using namespace std;

// Most common way to represent graphs in CP
int main() {
    int n, m;  // n = vertices, m = edges
    cin >> n >> m;

    // Unweighted graph
    vector<vector<int>> adj(n + 1);  // 1-indexed

    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v);
        adj[v].push_back(u);  // Remove for directed
    }

    // Weighted graph
    vector<vector<pair<int, int>>> wadj(n + 1);

    for (int i = 0; i < m; i++) {
        int u, v, w;
        cin >> u >> v >> w;
        wadj[u].push_back({v, w});
        wadj[v].push_back({u, w});  // Remove for directed
    }

    return 0;
}
```

### Dry Run - Adjacency List Construction

```
Input:
5 7
0 1
0 4
1 2
1 3
1 4
2 3
3 4

Step 1: Create adj[5] = [[], [], [], [], []]

Step 2: Edge (0,1)
adj[0] = [1]
adj[1] = [0]

Step 3: Edge (0,4)
adj[0] = [1, 4]
adj[4] = [0]

Step 4: Edge (1,2)
adj[1] = [0, 2]
adj[2] = [1]

Step 5: Edge (1,3)
adj[1] = [0, 2, 3]
adj[3] = [1]

Step 6: Edge (1,4)
adj[1] = [0, 2, 3, 4]
adj[4] = [0, 1]

Step 7: Edge (2,3)
adj[2] = [1, 3]
adj[3] = [1, 2]

Step 8: Edge (3,4)
adj[3] = [1, 2, 4]
adj[4] = [0, 1, 3]

Final:
0 → [1, 4]
1 → [0, 2, 3, 4]
2 → [1, 3]
3 → [1, 2, 4]
4 → [0, 1, 3]
```

### Complexity Analysis

| Operation | Time Complexity | Space Complexity |
|-----------|----------------|-----------------|
| Add Edge | O(1) | - |
| Remove Edge | O(V) | - |
| Check Edge | O(degree(u)) | - |
| Get Neighbors | O(1) | - |
| Get Degree | O(1) | - |
| Storage | - | O(V + E) |
| Initialize | O(V) | O(V + E) |

### Advantages of Adjacency List
1. O(V + E) space - efficient for sparse graphs
2. O(1) to get all neighbors (just iterate the list)
3. Adding vertex is easy
4. Better for most graph algorithms (BFS, DFS)
5. Real-world graphs are mostly sparse

### Disadvantages of Adjacency List
1. O(degree(v)) to check if edge exists
2. Slightly more complex than matrix
3. Not cache-friendly for dense graphs

---

## Comparison Table

| Feature | Adjacency Matrix | Adjacency List |
|---------|-----------------|----------------|
| Space | O(V²) | O(V + E) |
| Add Edge | O(1) | O(1) |
| Remove Edge | O(1) | O(V) |
| Check Edge | O(1) | O(degree) |
| Get All Neighbors | O(V) | O(degree) |
| Dense Graph | ✅ Better | ❌ |
| Sparse Graph | ❌ | ✅ Better |
| BFS/DFS | O(V²) | O(V + E) |
| Memory | More | Less |
| Implementation | Simple | Moderate |
| Matrix Operations | ✅ Possible | ❌ Not easy |
| Multiple Edges | ❌ Hard | ✅ Easy |

### When to Use What?

```
┌─────────────────────────────────────────────────────────┐
│ USE ADJACENCY MATRIX WHEN:                               │
│ • Graph is dense (E ≈ V²)                               │
│ • Need O(1) edge lookup frequently                       │
│ • V is small (≤ 1000)                                    │
│ • Need matrix operations (path counting, transitive     │
│   closure)                                               │
│ • Floyd-Warshall algorithm                               │
├─────────────────────────────────────────────────────────┤
│ USE ADJACENCY LIST WHEN:                                 │
│ • Graph is sparse (E << V²)                              │
│ • Need to iterate over neighbors frequently              │
│ • V is large (> 1000)                                    │
│ • BFS/DFS traversals                                     │
│ • Most competitive programming problems                  │
│ • Real-world applications                                │
└─────────────────────────────────────────────────────────┘
```

---

## Other Representations

### Edge List

```cpp
// Store all edges in a list
struct Edge {
    int u, v, weight;
};

vector<Edge> edges;
edges.push_back({0, 1, 5});
edges.push_back({1, 2, 3});

// Useful for: Kruskal's algorithm, Bellman-Ford
// Space: O(E)
```

### Implicit Graph

Sometimes the graph is not explicitly stored but defined by rules:
```cpp
// Grid graph - neighbors are adjacent cells
int dx[] = {0, 0, 1, -1};
int dy[] = {1, -1, 0, 0};

// For cell (x, y), neighbors are:
// (x+1, y), (x-1, y), (x, y+1), (x, y-1)
```

---

## Properties

### Handshaking Lemma
In an undirected graph, the sum of degrees of all vertices equals twice the number of edges.
```
Σ degree(v) = 2|E| for all v ∈ V
```

**Proof:** Each edge contributes exactly 2 to the total degree count (one for each endpoint).

**Corollary:** The number of vertices with odd degree is always even.

### Properties of Trees
- A tree with n vertices has exactly n-1 edges
- Adding any edge to a tree creates exactly one cycle
- Removing any edge from a tree disconnects it
- There is exactly one path between any two vertices in a tree

### Properties of Complete Graph (Kn)
- Number of edges = n(n-1)/2
- Degree of each vertex = n-1
- Number of spanning trees = n^(n-2) (Cayley's formula)

### Properties of Bipartite Graph
- A graph is bipartite iff it contains no odd-length cycle
- Maximum edges in bipartite graph with n₁ and n₂ vertices = n₁ × n₂

---

## Intuition Building

### How to Think About Graphs

1. **Identify entities** → These become vertices
2. **Identify relationships** → These become edges
3. **Determine direction** → Directed or undirected?
4. **Determine weights** → Weighted or unweighted?
5. **Choose representation** → Based on constraints

### Converting Real-World Problems to Graphs

| Problem | Vertices | Edges | Type |
|---------|----------|-------|------|
| Social Network | People | Friendships | Undirected, Unweighted |
| Web Crawling | Web Pages | Hyperlinks | Directed, Unweighted |
| Road Network | Cities | Roads | Undirected, Weighted |
| Flight Routes | Airports | Flights | Directed, Weighted |
| Course Prerequisites | Courses | Dependencies | Directed (DAG) |
| Maze Solving | Cells | Adjacent cells | Undirected, Unweighted |
| Circuit Design | Components | Wires | Undirected, Weighted |

### Grid as a Graph

Many problems involve 2D grids that are actually implicit graphs:

```
Grid:              Graph:
. . . .            (0,0)--(0,1)--(0,2)--(0,3)
. # . .              |      |      |      |
. . . .            (1,0)  (1,1) (1,2)--(1,3)
. . # .              |      |      |      |
                   (2,0)--(2,1)--(2,2)  (2,3)
                     |      |             |
                   (3,0)--(3,1)        (3,3)

# = blocked cell (no connections)
```

---

## Pattern Recognition

### How To Identify Graph Problems

#### Keywords That Suggest Graphs:
1. "Connected" / "Connectivity"
2. "Path" / "Route" / "Travel"
3. "Network" / "Graph"
4. "Shortest" / "Minimum distance"
5. "Reachable" / "Accessible"
6. "Cycle" / "Loop"
7. "Tree" / "Forest"
8. "Dependency" / "Order" / "Sequence"
9. "Flow" / "Capacity"
10. "Matching" / "Pairing"
11. "Coloring" / "Partition"
12. "Grid" / "Matrix" / "Maze"
13. "Nodes" / "Vertices" / "Edges"
14. "Adjacent" / "Neighbor"
15. "Component" / "Group" / "Cluster"

#### Constraints That Suggest Graphs:
- N, M ≤ 10⁵ (adjacency list with BFS/DFS)
- N ≤ 1000 (adjacency matrix possible)
- N ≤ 500, all-pairs needed (Floyd-Warshall)
- Grid problems (implicit graph)
- "Minimum operations to reach target" (BFS)

#### Decision Flowchart:

```
Is it a graph problem?
├── YES
│   ├── What type?
│   │   ├── Shortest Path → Dijkstra/BFS/Bellman-Ford
│   │   ├── Connectivity → DFS/BFS/Union-Find
│   │   ├── Cycle Detection → DFS coloring
│   │   ├── Ordering → Topological Sort
│   │   ├── Minimum Cost → MST (Kruskal/Prim)
│   │   ├── Maximum Flow → Ford-Fulkerson
│   │   └── Matching → Hungarian/Hopcroft-Karp
│   └── Choose representation based on constraints
└── NO → Consider other data structures
```

#### 30+ Recognition Patterns:

1. "Find if path exists between A and B" → BFS/DFS
2. "Minimum steps to reach target" → BFS
3. "Find all connected groups" → Connected Components (DFS/BFS/DSU)
4. "Detect cycle in relationships" → Cycle Detection
5. "Order tasks with dependencies" → Topological Sort
6. "Minimum cost to connect all nodes" → MST
7. "Shortest route between cities" → Dijkstra/Bellman-Ford
8. "Maximum water flow through pipes" → Network Flow
9. "Can we 2-color the graph?" → Bipartite Check
10. "Number of islands in grid" → Connected Components on Grid
11. "Flood fill a region" → BFS/DFS on Grid
12. "Word ladder transformation" → BFS
13. "Course schedule possible?" → Cycle Detection in Directed Graph
14. "Minimum spanning network" → MST
15. "Cheapest flights with K stops" → Modified Dijkstra/BFS
16. "Network delay time" → Dijkstra
17. "Redundant connection" → Union-Find
18. "Critical connections" → Bridges (Tarjan's)
19. "Strongly connected servers" → SCC (Kosaraju/Tarjan)
20. "Euler path/circuit" → Euler Tour
21. "Traveling salesman" → TSP (DP + Bitmask)
22. "Tree diameter/LCA" → Tree algorithms
23. "Negative cycle detection" → Bellman-Ford
24. "All pairs shortest path" → Floyd-Warshall
25. "Maximum bipartite matching" → Hungarian/Hopcroft-Karp
26. "Minimum cut" → Max-flow Min-cut
27. "Articulation points" → Tarjan's algorithm
28. "Bridges in network" → Bridge finding
29. "Shortest path in grid with obstacles" → BFS/Dijkstra
30. "Clone a graph" → BFS/DFS + HashMap
31. "Alien dictionary order" → Topological Sort
32. "Reconstruct itinerary" → Euler Path
33. "Parallel courses minimum time" → Topological Sort + DP

---

## Problem Solving

### Easy Problems

| # | Problem | Platform | Difficulty | Key Concept |
|---|---------|----------|-----------|-------------|
| 1 | Find if Path Exists in Graph | LeetCode 1971 | Easy | BFS/DFS basics |
| 2 | Find Center of Star Graph | LeetCode 1791 | Easy | Degree concept |
| 3 | Find the Town Judge | LeetCode 997 | Easy | In-degree/Out-degree |
| 4 | Number of Nodes in Sub-Tree Having Same Label | LeetCode 1519 | Easy | Tree traversal |
| 5 | Graph Representation | GFG | Easy | Implementation |
| 6 | Print Adjacency List | GFG | Easy | Implementation |
| 7 | BFS of Graph | GFG | Easy | BFS basics |
| 8 | DFS of Graph | GFG | Easy | DFS basics |
| 9 | Detect Cycle (Undirected) | GFG | Easy | Cycle detection |
| 10 | Connected Components | HackerRank | Easy | DFS/BFS |
| 11 | Roads and Libraries | HackerRank | Easy | MST concept |
| 12 | Breadth First Search: Shortest Reach | HackerRank | Easy | BFS |
| 13 | Number of Islands | LeetCode 200 | Medium | Connected components |
| 14 | Flood Fill | LeetCode 733 | Easy | Grid BFS/DFS |
| 15 | Max Area of Island | LeetCode 695 | Medium | Grid DFS |
| 16 | Surrounded Regions | LeetCode 130 | Medium | Border DFS |
| 17 | Graph Valid Tree | LeetCode 261 | Medium | Tree properties |
| 18 | Count Nodes in Complete Binary Tree | LeetCode 222 | Easy | Tree |
| 19 | Keys and Rooms | LeetCode 841 | Medium | DFS reachability |
| 20 | Find All Groups of Farmland | LeetCode 1992 | Medium | Grid components |

### Medium Problems

| # | Problem | Platform | Difficulty | Key Concept |
|---|---------|----------|-----------|-------------|
| 1 | Clone Graph | LeetCode 133 | Medium | Graph copy with BFS/DFS |
| 2 | Course Schedule | LeetCode 207 | Medium | Cycle in directed graph |
| 3 | Course Schedule II | LeetCode 210 | Medium | Topological sort |
| 4 | Number of Provinces | LeetCode 547 | Medium | Connected components |
| 5 | Rotting Oranges | LeetCode 994 | Medium | Multi-source BFS |
| 6 | 01 Matrix | LeetCode 542 | Medium | Multi-source BFS |
| 7 | Pacific Atlantic Water Flow | LeetCode 417 | Medium | Multi-source DFS |
| 8 | Word Ladder | LeetCode 127 | Hard | BFS shortest path |
| 9 | Evaluate Division | LeetCode 399 | Medium | Weighted graph |
| 10 | Redundant Connection | LeetCode 684 | Medium | Union-Find |
| 11 | Network Delay Time | LeetCode 743 | Medium | Dijkstra |
| 12 | Cheapest Flights Within K Stops | LeetCode 787 | Medium | Modified BFS |
| 13 | Is Graph Bipartite | LeetCode 785 | Medium | BFS coloring |
| 14 | Possible Bipartition | LeetCode 886 | Medium | Bipartite check |
| 15 | All Paths From Source to Target | LeetCode 797 | Medium | DFS paths |
| 16 | Minimum Height Trees | LeetCode 310 | Medium | Tree center |
| 17 | Graph Connectivity With Threshold | LeetCode 1627 | Hard | Union-Find |
| 18 | Snakes and Ladders | LeetCode 909 | Medium | BFS |
| 19 | Open the Lock | LeetCode 752 | Medium | BFS |
| 20 | Minimum Genetic Mutation | LeetCode 433 | Medium | BFS |
| 21 | Accounts Merge | LeetCode 721 | Medium | Union-Find |
| 22 | Most Stones Removed | LeetCode 947 | Medium | Union-Find |
| 23 | Satisfiability of Equations | LeetCode 990 | Medium | Union-Find |
| 24 | Number of Operations to Make Network Connected | LeetCode 1319 | Medium | Union-Find |
| 25 | Critical Connections in a Network | LeetCode 1192 | Hard | Bridges |
| 26 | Shortest Path in Binary Matrix | LeetCode 1091 | Medium | BFS |
| 27 | Jump Game III | LeetCode 1306 | Medium | BFS/DFS |
| 28 | Find Eventual Safe States | LeetCode 802 | Medium | Topological sort |
| 29 | Time Needed to Inform All Employees | LeetCode 1376 | Medium | BFS/DFS tree |
| 30 | Shortest Path with Alternating Colors | LeetCode 1129 | Medium | BFS states |

### Hard Problems

| # | Problem | Platform | Difficulty | Key Concept |
|---|---------|----------|-----------|-------------|
| 1 | Word Ladder II | LeetCode 126 | Hard | BFS + DFS |
| 2 | Alien Dictionary | LeetCode 269 | Hard | Topological sort |
| 3 | Bus Routes | LeetCode 815 | Hard | BFS |
| 4 | Swim in Rising Water | LeetCode 778 | Hard | Binary search + BFS |
| 5 | Minimum Cost to Make at Least One Valid Path | LeetCode 1368 | Hard | 0-1 BFS |
| 6 | Shortest Path Visiting All Nodes | LeetCode 847 | Hard | BFS + Bitmask |
| 7 | Cat and Mouse | LeetCode 913 | Hard | Game theory on graph |
| 8 | Frog Position After T Seconds | LeetCode 1377 | Hard | BFS probability |
| 9 | Parallel Courses III | LeetCode 2050 | Hard | Topological sort + DP |
| 10 | Count Paths | CSES | Hard | DAG DP |
| 11 | Longest Flight Route | CSES | Hard | DAG DP |
| 12 | Graph Coloring | CSES | Hard | Bipartite |
| 13 | Building Roads | CSES | Easy | Connected components |
| 14 | Message Route | CSES | Easy | BFS shortest path |
| 15 | Building Teams | CSES | Easy | Bipartite check |
| 16 | Round Trip | CSES | Medium | Cycle finding |
| 17 | Monsters | CSES | Medium | Multi-source BFS |
| 18 | Shortest Routes I | CSES | Medium | Dijkstra |
| 19 | Shortest Routes II | CSES | Medium | Floyd-Warshall |
| 20 | High Score | CSES | Medium | Bellman-Ford |

---

## Interview Preparation

### Top 50 Interview Questions on Graph Basics

#### Theory Questions:
1. What is a graph? How does it differ from a tree?
2. Explain directed vs undirected graphs with examples.
3. What is the difference between adjacency matrix and adjacency list?
4. When would you use an adjacency matrix over an adjacency list?
5. What is the Handshaking Lemma? Prove it.
6. What is a complete graph? How many edges does Kn have?
7. Define: path, cycle, connected component, strongly connected.
8. What is a DAG? Give real-world examples.
9. What is a bipartite graph? How to identify one?
10. What is the maximum number of edges in a simple undirected graph?
11. Explain sparse vs dense graphs.
12. What is a spanning tree? How many edges does it have?
13. Can a disconnected graph have a spanning tree?
14. What is degree, in-degree, and out-degree?
15. What is a multigraph? A pseudograph?

#### Coding Questions:
16. Implement a graph using adjacency matrix.
17. Implement a graph using adjacency list.
18. Convert adjacency matrix to adjacency list and vice versa.
19. Find if a path exists between two nodes.
20. Count the number of edges in a graph.
21. Find all vertices with degree > k.
22. Check if a graph is complete.
23. Find the complement of a graph.
24. Find isolated vertices (degree 0).
25. Implement graph traversal (BFS and DFS).
26. Find connected components.
27. Detect if the graph is a tree.
28. Find the degree sequence of a graph.
29. Check if two graphs are isomorphic (basic approach).
30. Find all vertices reachable from a given vertex.

#### Follow-up Questions:
31. How would you handle a graph that doesn't fit in memory?
32. How to represent a graph in a distributed system?
33. What data structure would you use for a social network graph?
34. How to efficiently store a sparse graph with 10⁹ nodes?
35. What is CSR (Compressed Sparse Row) format?
36. How would you parallelize graph operations?
37. Compare graph databases vs relational databases for graph data.
38. How does Google's PageRank use graph representation?

#### Tricky Cases:
39. Self-loops in adjacency matrix - what value at diagonal?
40. Multiple edges between same vertices - how to handle?
41. Negative weights - which representations support them?
42. Dynamic graphs - adding/removing vertices efficiently?
43. Implicit graphs - when NOT to build the explicit graph?
44. 0-indexed vs 1-indexed - common bugs?
45. Directed graph with both edges (u,v) and (v,u) - is it undirected?

#### FAANG Discussion Points:
46. Design a graph-based social network (System Design + DSA).
47. How would you store Google Maps road network?
48. Design a recommendation engine using graphs.
49. How does LinkedIn find "People You May Know"?
50. How would you implement a dependency resolver (like npm)?

---

## Competitive Programming

### Fast I/O Template

```cpp
#include <bits/stdc++.h>
using namespace std;

#define fast_io ios_base::sync_with_stdio(false); cin.tie(NULL);
#define endl '\n'

int main() {
    fast_io;
    
    int n, m;
    cin >> n >> m;
    
    vector<vector<int>> adj(n + 1);
    for (int i = 0; i < m; i++) {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    // Your algorithm here
    
    return 0;
}
```

### CP Tricks for Graph Representation

1. **Always use 1-indexed for competitive programming** (matches problem statements)
2. **Use `vector<vector<int>>` not `vector<list<int>>`** (cache-friendly)
3. **For weighted graphs**: `vector<vector<pair<int,int>>>` or `vector<vector<array<int,2>>>`
4. **Pre-allocate**: `adj.reserve(n)` if you know the size
5. **For edge indices**: Store edge index along with neighbor
6. **For multiple test cases**: Clear the adjacency list properly

```cpp
// Clearing graph between test cases
for (int i = 0; i <= n; i++) adj[i].clear();
// OR
adj.assign(n + 1, vector<int>());
```

### Memory Optimization

```cpp
// When V is large but E is small, avoid creating adj of size V
// Use map-based adjacency list
unordered_map<int, vector<int>> adj;

// Or use coordinate compression
// Map vertex labels to [0, n) range
```

### Common Mistakes in CP

1. **Off-by-one errors**: 0-indexed vs 1-indexed
2. **Not clearing graph between test cases**
3. **Integer overflow**: n*(n-1)/2 can overflow int for n > 65536
4. **Forgetting to add both directions** for undirected graphs
5. **Self-loops**: Check if u != v before adding edge
6. **Multiple edges**: Problem may have parallel edges
7. **Disconnected graph**: Don't assume graph is connected
8. **Memory limit**: V² matrix for V > 10⁴ will MLE

---

## Advanced Section

### Matrix Exponentiation on Graphs

The number of paths of length k from vertex u to v equals `A^k[u][v]` where A is the adjacency matrix.

```cpp
// Count paths of length k using matrix exponentiation
typedef vector<vector<long long>> Matrix;

Matrix multiply(Matrix& A, Matrix& B, int n) {
    Matrix C(n, vector<long long>(n, 0));
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            for (int k = 0; k < n; k++)
                C[i][j] += A[i][k] * B[k][j];
    return C;
}

Matrix matpow(Matrix A, int p, int n) {
    Matrix result(n, vector<long long>(n, 0));
    for (int i = 0; i < n; i++) result[i][i] = 1; // Identity
    while (p > 0) {
        if (p & 1) result = multiply(result, A, n);
        A = multiply(A, A, n);
        p >>= 1;
    }
    return result;
}
```

### Transitive Closure (Warshall's Algorithm)

```cpp
// Find if vertex i can reach vertex j (for all pairs)
void transitiveClosure(vector<vector<int>>& reach, int n) {
    for (int k = 0; k < n; k++)
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                reach[i][j] = reach[i][j] || (reach[i][k] && reach[k][j]);
}
```

### Graph Complement

```cpp
// Build complement graph
vector<vector<int>> complement(vector<vector<int>>& adj, int n) {
    // Convert to adjacency matrix, flip, convert back
    vector<vector<bool>> mat(n, vector<bool>(n, false));
    for (int u = 0; u < n; u++)
        for (int v : adj[u])
            mat[u][v] = true;
    
    vector<vector<int>> comp(n);
    for (int u = 0; u < n; u++)
        for (int v = 0; v < n; v++)
            if (u != v && !mat[u][v])
                comp[u].push_back(v);
    return comp;
}
```

### Connection to Future Topics

This foundational knowledge connects directly to:
- **02_Traversals**: BFS and DFS use adjacency list representation
- **03_Undirected_Graph**: Properties specific to undirected graphs
- **04_Directed_Graph**: DAGs and directed graph properties
- **05_Disjoint_Set**: Alternative way to handle connectivity
- **06_MST**: Requires weighted graph representation
- **07_Shortest_Paths**: Requires weighted graph representation

---

## Cheat Sheet

### One-Page Revision

```
GRAPH BASICS:
• G = (V, E), |V| = n, |E| = m
• Undirected: edge (u,v) = edge (v,u)
• Directed: edge (u,v) ≠ edge (v,u)
• Weighted: edges have associated costs

REPRESENTATIONS:
• Adjacency Matrix: O(V²) space, O(1) edge check
• Adjacency List: O(V+E) space, O(degree) edge check

KEY FORMULAS:
• Max edges (undirected, simple): n(n-1)/2
• Max edges (directed, simple): n(n-1)
• Tree edges: n-1
• Sum of degrees = 2m (undirected)
• Handshaking: vertices with odd degree count is even

WHEN TO USE WHAT:
• Dense + small V → Matrix
• Sparse + large V → List (99% of problems)
• Need edge list → Kruskal's, Bellman-Ford
```

### Formula Sheet

| Formula | Description |
|---------|-------------|
| n(n-1)/2 | Max edges in simple undirected graph |
| n(n-1) | Max edges in simple directed graph |
| n-1 | Edges in a tree |
| n^(n-2) | Spanning trees of Kn (Cayley's formula) |
| 2m | Sum of all degrees (undirected) |
| m | Sum of in-degrees = Sum of out-degrees (directed) |

### Complexity Table

| Operation | Matrix | List |
|-----------|--------|------|
| Space | O(V²) | O(V+E) |
| Add Edge | O(1) | O(1) |
| Remove Edge | O(1) | O(V) |
| Check Edge | O(1) | O(degree) |
| Neighbors | O(V) | O(degree) |
| BFS/DFS | O(V²) | O(V+E) |

### Common Pitfalls

1. ❌ Using matrix for V > 10⁴ → Memory Limit Exceeded
2. ❌ Forgetting to handle disconnected graphs
3. ❌ Off-by-one with 0-indexed vs 1-indexed
4. ❌ Not clearing adjacency list between test cases
5. ❌ Integer overflow when computing n*(n-1)/2
6. ❌ Assuming input is a simple graph (watch for multi-edges, self-loops)
7. ❌ Forgetting bidirectional edges in undirected graph

### Quick Interview Notes

- "Graph" in interview = usually adjacency list
- Always clarify: directed? weighted? cycles? connected?
- Start with the simplest approach, then optimize
- Know BFS (shortest path in unweighted) and DFS (connectivity, cycle detection)
- Practice: LeetCode 200, 207, 210, 133, 547, 743, 994

---

## Building Blocks for Next Topics

After mastering this introduction, you're ready for:

1. **Graph Traversals (BFS/DFS)** → Next chapter
2. Understanding how algorithms traverse the graph structure you just learned to build
3. Every subsequent topic builds upon this representation knowledge

**Key Takeaway**: The adjacency list is your default representation for 99% of problems. Master it thoroughly before moving to traversals.
