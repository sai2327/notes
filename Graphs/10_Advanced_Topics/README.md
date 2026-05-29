# Advanced Graph Topics

## Table of Contents
- [Euler Tour](#euler-tour)
- [Travelling Salesman Problem](#travelling-salesman-problem)
- [DP on Trees](#dp-on-trees)
- [DP on Graphs](#dp-on-graphs)
- [Articulation Points & Bridges](#articulation-points--bridges)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Cheat Sheet](#cheat-sheet)

---

## Euler Tour

### Theory

An **Eulerian Path** visits every EDGE exactly once.
An **Eulerian Circuit** is an Eulerian Path that starts and ends at the same vertex.

### Existence Conditions

| Graph Type | Euler Circuit | Euler Path |
|------------|---------------|------------|
| Undirected | All vertices even degree | Exactly 0 or 2 vertices odd degree |
| Directed | in-degree = out-degree for all | At most 1 vertex with out-in=1, at most 1 with in-out=1 |

### Hierholzer's Algorithm

```
Finds Eulerian circuit/path in O(V + E):
1. Start at appropriate vertex
2. Follow edges (DFS-like), removing used edges
3. When stuck at a vertex, push to result
4. Result in reverse is the Euler tour

Key insight: When we get stuck, we've completed a sub-circuit.
We then backtrack to find unused edges from earlier vertices.
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

// Hierholzer's Algorithm for Euler Circuit (Undirected)
class EulerTourUndirected {
    int n;
    vector<vector<pair<int,int>>> adj; // {neighbor, edge_index}
    vector<bool> usedEdge;
    
public:
    EulerTourUndirected(int n, int m) : n(n), adj(n), usedEdge(m, false) {}
    
    void addEdge(int u, int v, int idx) {
        adj[u].push_back({v, idx});
        adj[v].push_back({u, idx});
    }
    
    vector<int> findEulerCircuit(int start) {
        vector<int> circuit;
        stack<int> st;
        vector<int> ptr(n, 0); // Current edge pointer for each vertex
        
        st.push(start);
        while (!st.empty()) {
            int v = st.top();
            bool found = false;
            
            while (ptr[v] < adj[v].size()) {
                auto [u, idx] = adj[v][ptr[v]];
                ptr[v]++;
                if (!usedEdge[idx]) {
                    usedEdge[idx] = true;
                    st.push(u);
                    found = true;
                    break;
                }
            }
            
            if (!found) {
                circuit.push_back(v);
                st.pop();
            }
        }
        
        reverse(circuit.begin(), circuit.end());
        return circuit;
    }
};

// Hierholzer's Algorithm for Euler Circuit (Directed)
class EulerTourDirected {
    int n;
    vector<vector<int>> adj;
    
public:
    EulerTourDirected(int n) : n(n), adj(n) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
    }
    
    vector<int> findEulerCircuit(int start) {
        vector<int> circuit;
        stack<int> st;
        vector<int> ptr(n, 0);
        
        st.push(start);
        while (!st.empty()) {
            int v = st.top();
            if (ptr[v] < adj[v].size()) {
                st.push(adj[v][ptr[v]++]);
            } else {
                circuit.push_back(v);
                st.pop();
            }
        }
        
        reverse(circuit.begin(), circuit.end());
        return circuit;
    }
};

int main() {
    // Directed Euler Circuit
    EulerTourDirected g(4);
    g.addEdge(0, 1);
    g.addEdge(1, 2);
    g.addEdge(2, 3);
    g.addEdge(3, 0);
    g.addEdge(0, 2);
    g.addEdge(2, 0);
    
    auto circuit = g.findEulerCircuit(0);
    cout << "Euler Circuit: ";
    for (int v : circuit) cout << v << " ";
    cout << endl;
    
    return 0;
}
```

### Dry Run

```
Directed graph:
0 → 1, 1 → 2, 2 → 3, 3 → 0, 0 → 2, 2 → 0

adj[0] = [1, 2], adj[1] = [2], adj[2] = [3, 0], adj[3] = [0]
Degrees: in=out for all: 0(2,2), 1(1,1), 2(2,2), 3(1,1) ✓

Stack: [0], ptr = [0,0,0,0]
  v=0, push adj[0][0]=1, ptr[0]=1. Stack: [0,1]
  v=1, push adj[1][0]=2, ptr[1]=1. Stack: [0,1,2]
  v=2, push adj[2][0]=3, ptr[2]=1. Stack: [0,1,2,3]
  v=3, push adj[3][0]=0, ptr[3]=1. Stack: [0,1,2,3,0]
  v=0, push adj[0][1]=2, ptr[0]=2. Stack: [0,1,2,3,0,2]
  v=2, push adj[2][1]=0, ptr[2]=2. Stack: [0,1,2,3,0,2,0]
  v=0, ptr[0]=2 ≥ size=2, pop, circuit=[0]. Stack: [0,1,2,3,0,2]
  v=2, ptr[2]=2 ≥ size=2, pop, circuit=[0,2]. Stack: [0,1,2,3,0]
  v=0, pop, circuit=[0,2,0]. Stack: [0,1,2,3]
  v=3, pop, circuit=[0,2,0,3]. Stack: [0,1,2]
  v=2, pop, circuit=[0,2,0,3,2]. Stack: [0,1]
  v=1, pop, circuit=[0,2,0,3,2,1]. Stack: [0]
  v=0, pop, circuit=[0,2,0,3,2,1,0]. Stack: []

Reverse: [0, 1, 2, 3, 0, 2, 0]
Euler circuit: 0→1→2→3→0→2→0 ✓
```

### Euler Tour on Trees (for LCA/queries)

```cpp
// Euler Tour flattening of a tree for range queries
vector<int> euler_tour;
vector<int> tin, tout;
int timer = 0;

void eulerDFS(int v, int parent, vector<vector<int>>& adj) {
    tin[v] = timer++;
    euler_tour.push_back(v);
    
    for (int u : adj[v]) {
        if (u != parent) {
            eulerDFS(u, v, adj);
        }
    }
    
    tout[v] = timer++;
    euler_tour.push_back(v);
}
```

---

## Travelling Salesman Problem

### Theory

**TSP**: Given a set of cities and distances between them, find the shortest tour that visits every city exactly once and returns to the starting city.

TSP is **NP-hard** — no known polynomial algorithm.

### Approaches

| Method | Time | Space | Notes |
|--------|------|-------|-------|
| Brute force | O(N!) | O(N) | Try all permutations |
| DP + Bitmask | O(N² × 2^N) | O(N × 2^N) | Exact, feasible for N≤20 |
| Greedy (nearest neighbor) | O(N²) | O(N) | Heuristic |
| MST approximation | O(E log E) | O(V+E) | 2-approximation (triangle ineq.) |
| Christofides | O(N³) | O(N²) | 1.5-approximation |

### C++ Implementation: DP + Bitmask (Held-Karp)

```cpp
#include <bits/stdc++.h>
using namespace std;

int tsp(vector<vector<int>>& dist) {
    int n = dist.size();
    int FULL = (1 << n) - 1;
    
    // dp[mask][i] = min cost to visit all cities in mask, ending at city i
    vector<vector<int>> dp(1 << n, vector<int>(n, INT_MAX));
    
    // Start at city 0
    dp[1][0] = 0;
    
    for (int mask = 1; mask <= FULL; mask++) {
        for (int last = 0; last < n; last++) {
            if (dp[mask][last] == INT_MAX) continue;
            if (!(mask & (1 << last))) continue;
            
            // Try to visit next unvisited city
            for (int next = 0; next < n; next++) {
                if (mask & (1 << next)) continue; // Already visited
                int newMask = mask | (1 << next);
                dp[newMask][next] = min(dp[newMask][next], 
                                        dp[mask][last] + dist[last][next]);
            }
        }
    }
    
    // Find minimum cost to return to start
    int ans = INT_MAX;
    for (int last = 1; last < n; last++) {
        if (dp[FULL][last] != INT_MAX) {
            ans = min(ans, dp[FULL][last] + dist[last][0]);
        }
    }
    
    return ans;
}

// With path reconstruction
pair<int, vector<int>> tspWithPath(vector<vector<int>>& dist) {
    int n = dist.size();
    int FULL = (1 << n) - 1;
    
    vector<vector<int>> dp(1 << n, vector<int>(n, INT_MAX));
    vector<vector<int>> parent(1 << n, vector<int>(n, -1));
    
    dp[1][0] = 0;
    
    for (int mask = 1; mask <= FULL; mask++) {
        for (int last = 0; last < n; last++) {
            if (dp[mask][last] == INT_MAX) continue;
            if (!(mask & (1 << last))) continue;
            
            for (int next = 0; next < n; next++) {
                if (mask & (1 << next)) continue;
                int newMask = mask | (1 << next);
                int newCost = dp[mask][last] + dist[last][next];
                if (newCost < dp[newMask][next]) {
                    dp[newMask][next] = newCost;
                    parent[newMask][next] = last;
                }
            }
        }
    }
    
    // Find optimal last city
    int ans = INT_MAX, lastCity = -1;
    for (int last = 1; last < n; last++) {
        if (dp[FULL][last] != INT_MAX) {
            int cost = dp[FULL][last] + dist[last][0];
            if (cost < ans) {
                ans = cost;
                lastCity = last;
            }
        }
    }
    
    // Reconstruct path
    vector<int> path;
    int mask = FULL, curr = lastCity;
    while (curr != -1) {
        path.push_back(curr);
        int prev = parent[mask][curr];
        mask ^= (1 << curr);
        curr = prev;
    }
    reverse(path.begin(), path.end());
    path.push_back(0); // Return to start
    
    return {ans, path};
}

int main() {
    vector<vector<int>> dist = {
        {0, 10, 15, 20},
        {10, 0, 35, 25},
        {15, 35, 0, 30},
        {20, 25, 30, 0}
    };
    
    cout << "Minimum TSP cost: " << tsp(dist) << endl; // 80
    
    auto [cost, path] = tspWithPath(dist);
    cout << "Path: ";
    for (int v : path) cout << v << " ";
    cout << "\nCost: " << cost << endl;
    
    return 0;
}
```

### Dry Run

```
Cities: 0, 1, 2, 3
dist = [[0,10,15,20], [10,0,35,25], [15,35,0,30], [20,25,30,0]]

dp[0001][0] = 0 (start at city 0)

From state (mask=0001, last=0):
  → city 1: dp[0011][1] = 0 + 10 = 10
  → city 2: dp[0101][2] = 0 + 15 = 15
  → city 3: dp[1001][3] = 0 + 20 = 20

From state (mask=0011, last=1, cost=10):
  → city 2: dp[0111][2] = min(?, 10+35) = 45
  → city 3: dp[1011][3] = min(?, 10+25) = 35

From state (mask=0101, last=2, cost=15):
  → city 1: dp[0111][1] = min(?, 15+35) = 50
  → city 3: dp[1101][3] = min(?, 15+30) = 45

From state (mask=1001, last=3, cost=20):
  → city 1: dp[1011][1] = min(?, 20+25) = 45
  → city 2: dp[1101][2] = min(?, 20+30) = 50

Continue for 3-city subsets:
dp[0111][2] = 45, from (0011, 1) → visit 2: 10+35
dp[0111][1] = 50, from (0101, 2) → visit 1: 15+35
dp[1011][3] = 35, from (0011, 1) → visit 3: 10+25
dp[1011][1] = 45, from (1001, 3) → visit 1: 20+25
dp[1101][3] = 45, from (0101, 2) → visit 3: 15+30
dp[1101][2] = 50, from (1001, 3) → visit 2: 20+30

Full mask (1111):
From dp[0111][2]=45: → city 3: dp[1111][3] = 45+30 = 75
From dp[0111][1]=50: → city 3: dp[1111][3] = min(75, 50+25) = 75
From dp[1011][3]=35: → city 2: dp[1111][2] = 35+30 = 65
From dp[1011][1]=45: → city 2: dp[1111][2] = min(65, 45+35) = 65
From dp[1101][3]=45: → city 1: dp[1111][1] = 45+25 = 70
From dp[1101][2]=50: → city 1: dp[1111][1] = min(70, 50+35) = 70

Return to start (city 0):
  dp[1111][1] + dist[1][0] = 70 + 10 = 80
  dp[1111][2] + dist[2][0] = 65 + 15 = 80
  dp[1111][3] + dist[3][0] = 75 + 20 = 95

Minimum = 80
Path: 0 → 1 → 3 → 2 → 0 (cost: 10+25+30+15 = 80) ✓
```

---

## DP on Trees

### Theory

Dynamic programming on trees exploits the tree structure (no cycles, unique paths) to solve optimization problems.

### Common Patterns

```
1. Root the tree, process children before parent (bottom-up)
2. dp[v] depends on dp[children of v]
3. Often uses post-order DFS
4. Sometimes need rerooting technique (two DFS passes)
```

### Problem: Maximum Independent Set on Tree

```cpp
#include <bits/stdc++.h>
using namespace std;

// dp[v][0] = max independent set in subtree of v, v NOT included
// dp[v][1] = max independent set in subtree of v, v included
vector<vector<int>> adj;
vector<array<long long, 2>> dp;
vector<int> value;

void dfs(int v, int parent) {
    dp[v][0] = 0;        // Don't take v
    dp[v][1] = value[v]; // Take v
    
    for (int u : adj[v]) {
        if (u == parent) continue;
        dfs(u, v);
        dp[v][0] += max(dp[u][0], dp[u][1]); // Children can be taken or not
        dp[v][1] += dp[u][0];                  // Children must NOT be taken
    }
}

int main() {
    int n;
    cin >> n;
    adj.resize(n);
    dp.resize(n);
    value.resize(n);
    
    for (int i = 0; i < n; i++) cin >> value[i];
    for (int i = 0; i < n - 1; i++) {
        int u, v; cin >> u >> v; u--; v--;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    dfs(0, -1);
    cout << max(dp[0][0], dp[0][1]) << endl;
    
    return 0;
}
```

### Problem: Tree Diameter (DP approach)

```cpp
#include <bits/stdc++.h>
using namespace std;

vector<vector<pair<int,int>>> adj;
int diameter = 0;

// Returns longest path from v going downward
int dfs(int v, int parent) {
    int max1 = 0, max2 = 0; // Two longest downward paths
    
    for (auto [u, w] : adj[v]) {
        if (u == parent) continue;
        int childLen = dfs(u, v) + w;
        
        if (childLen >= max1) {
            max2 = max1;
            max1 = childLen;
        } else if (childLen > max2) {
            max2 = childLen;
        }
    }
    
    diameter = max(diameter, max1 + max2); // Path through v
    return max1; // Longest single path from v
}

int main() {
    int n;
    cin >> n;
    adj.resize(n);
    
    for (int i = 0; i < n - 1; i++) {
        int u, v, w; cin >> u >> v >> w; u--; v--;
        adj[u].push_back({v, w});
        adj[v].push_back({u, w});
    }
    
    dfs(0, -1);
    cout << "Diameter: " << diameter << endl;
    
    return 0;
}
```

### Problem: Rerooting Technique

```cpp
#include <bits/stdc++.h>
using namespace std;

// Find sum of distances from each node to all other nodes
vector<vector<int>> adj;
vector<long long> subtreeSize, distSum, answer;
int n;

// First DFS: compute subtree sizes and distSum for root
void dfs1(int v, int parent, int depth) {
    subtreeSize[v] = 1;
    distSum[0] += depth;
    
    for (int u : adj[v]) {
        if (u == parent) continue;
        dfs1(u, v, depth + 1);
        subtreeSize[v] += subtreeSize[u];
    }
}

// Second DFS: reroot from parent to child
void dfs2(int v, int parent) {
    for (int u : adj[v]) {
        if (u == parent) continue;
        // When we move root from v to u:
        // Nodes in subtree(u): distance decreases by 1 (closer to new root)
        // Nodes NOT in subtree(u): distance increases by 1 (farther from new root)
        answer[u] = answer[v] - subtreeSize[u] + (n - subtreeSize[u]);
        dfs2(u, v);
    }
}

int main() {
    cin >> n;
    adj.resize(n);
    subtreeSize.resize(n);
    distSum.resize(n, 0);
    answer.resize(n);
    
    for (int i = 0; i < n - 1; i++) {
        int u, v; cin >> u >> v; u--; v--;
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    dfs1(0, -1, 0);
    answer[0] = distSum[0];
    dfs2(0, -1);
    
    for (int i = 0; i < n; i++)
        cout << answer[i] << " ";
    
    return 0;
}
```

---

## DP on Graphs

### Theory

DP on general graphs works when:
1. Graph is a DAG (topological order gives DP order)
2. State space forms a DAG (even if graph has cycles)
3. Using bitmask DP (exponential but exact)

### Longest Path in DAG

```cpp
#include <bits/stdc++.h>
using namespace std;

int longestPathDAG(int n, vector<vector<pair<int,int>>>& adj) {
    vector<int> indegree(n, 0);
    for (int u = 0; u < n; u++)
        for (auto [v, w] : adj[u])
            indegree[v]++;
    
    // Topological sort
    queue<int> q;
    for (int i = 0; i < n; i++)
        if (indegree[i] == 0) q.push(i);
    
    vector<int> topo;
    while (!q.empty()) {
        int v = q.front(); q.pop();
        topo.push_back(v);
        for (auto [u, w] : adj[v])
            if (--indegree[u] == 0) q.push(u);
    }
    
    // DP in topological order
    vector<long long> dp(n, 0); // dp[v] = longest path ending at v
    long long ans = 0;
    
    for (int v : topo) {
        for (auto [u, w] : adj[v]) {
            dp[u] = max(dp[u], dp[v] + w);
            ans = max(ans, dp[u]);
        }
    }
    
    return ans;
}
```

### Shortest Path in DAG (with negative weights)

```cpp
vector<long long> shortestPathDAG(int n, int src, 
    vector<vector<pair<int,int>>>& adj, vector<int>& topo) {
    
    vector<long long> dist(n, LLONG_MAX);
    dist[src] = 0;
    
    for (int v : topo) {
        if (dist[v] == LLONG_MAX) continue;
        for (auto [u, w] : adj[v]) {
            dist[u] = min(dist[u], dist[v] + w);
        }
    }
    
    return dist;
}
```

### Number of Paths in DAG

```cpp
vector<long long> countPaths(int n, int src, 
    vector<vector<int>>& adj, vector<int>& topo) {
    
    vector<long long> paths(n, 0);
    paths[src] = 1;
    
    for (int v : topo) {
        for (int u : adj[v]) {
            paths[u] += paths[v];
        }
    }
    
    return paths;
}
```

---

## Articulation Points & Bridges

### Theory

- **Articulation Point (Cut Vertex)**: A vertex whose removal disconnects the graph.
- **Bridge (Cut Edge)**: An edge whose removal disconnects the graph.

### Tarjan's Algorithm for Articulation Points

```
Uses DFS with discovery time (disc) and low value:
- disc[v]: when vertex v was first discovered
- low[v]: minimum disc reachable from subtree of v via back edges

Vertex u is articulation point if:
1. u is root of DFS tree AND has ≥ 2 children
2. u is not root AND has a child v where low[v] ≥ disc[u]
   (meaning v's subtree cannot reach above u)
```

### C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class ArticulationPoints {
    int n, timer = 0;
    vector<vector<int>> adj;
    vector<int> disc, low;
    vector<bool> visited, isAP;
    
    void dfs(int u, int parent) {
        visited[u] = true;
        disc[u] = low[u] = timer++;
        int children = 0;
        
        for (int v : adj[u]) {
            if (!visited[v]) {
                children++;
                dfs(v, u);
                low[u] = min(low[u], low[v]);
                
                // Condition 1: u is root with 2+ children
                if (parent == -1 && children > 1)
                    isAP[u] = true;
                
                // Condition 2: u is not root and child can't reach above
                if (parent != -1 && low[v] >= disc[u])
                    isAP[u] = true;
                    
            } else if (v != parent) {
                low[u] = min(low[u], disc[v]);
            }
        }
    }
    
public:
    ArticulationPoints(int n) : n(n), adj(n), disc(n), low(n), 
                                 visited(n, false), isAP(n, false) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    vector<int> findAPs() {
        for (int i = 0; i < n; i++)
            if (!visited[i]) dfs(i, -1);
        
        vector<int> result;
        for (int i = 0; i < n; i++)
            if (isAP[i]) result.push_back(i);
        return result;
    }
};

// Bridges
class Bridges {
    int n, timer = 0;
    vector<vector<pair<int,int>>> adj; // {neighbor, edge_id}
    vector<int> disc, low;
    vector<bool> visited;
    vector<pair<int,int>> bridges;
    
    void dfs(int u, int parentEdge) {
        visited[u] = true;
        disc[u] = low[u] = timer++;
        
        for (auto [v, edgeId] : adj[u]) {
            if (edgeId == parentEdge) continue; // Handle multi-edges
            
            if (!visited[v]) {
                dfs(v, edgeId);
                low[u] = min(low[u], low[v]);
                
                if (low[v] > disc[u]) {
                    bridges.push_back({u, v});
                }
            } else {
                low[u] = min(low[u], disc[v]);
            }
        }
    }
    
public:
    Bridges(int n) : n(n), adj(n), disc(n), low(n), visited(n, false) {}
    
    void addEdge(int u, int v, int id) {
        adj[u].push_back({v, id});
        adj[v].push_back({u, id});
    }
    
    vector<pair<int,int>> findBridges() {
        for (int i = 0; i < n; i++)
            if (!visited[i]) dfs(i, -1);
        return bridges;
    }
};

int main() {
    // Articulation Points
    ArticulationPoints ap(5);
    ap.addEdge(0, 1); ap.addEdge(1, 2);
    ap.addEdge(2, 0); ap.addEdge(1, 3);
    ap.addEdge(3, 4);
    
    auto aps = ap.findAPs();
    cout << "Articulation Points: ";
    for (int v : aps) cout << v << " ";
    cout << endl; // 1, 3
    
    return 0;
}
```

### Dry Run: Articulation Points

```
Graph:
0 -- 1 -- 3 -- 4
 \  /
  2

adj[0]=[1,2], adj[1]=[0,2,3], adj[2]=[0,1], adj[3]=[1,4], adj[4]=[3]

DFS from vertex 0 (parent=-1):
  disc[0]=0, low[0]=0
  Visit 1 (child):
    disc[1]=1, low[1]=1
    Visit 2 (child of 1):
      disc[2]=2, low[2]=2
      See 0 (back edge): low[2] = min(2, disc[0]) = 0
      See 1 (parent, skip)
    low[1] = min(1, low[2]) = min(1, 0) = 0
    Check: low[2]=0 >= disc[1]=1? NO → 1 is NOT AP from child 2
    
    Visit 3 (child of 1):
      disc[3]=3, low[3]=3
      Visit 4 (child of 3):
        disc[4]=4, low[4]=4
        No unvisited neighbors
      low[3] = min(3, low[4]) = min(3, 4) = 3
      Check: low[4]=4 >= disc[3]=3? YES → 3 IS AP
    low[1] = min(0, low[3]) = min(0, 3) = 0
    Check: low[3]=3 >= disc[1]=1? YES → 1 IS AP
    
  low[0] = min(0, low[1]) = 0
  See 2 (back edge): low[0] = min(0, disc[2]) = 0
  Root check: children=1, not >= 2, so 0 is NOT AP from root rule

Result: Articulation Points = {1, 3} ✓
  Removing 1 disconnects {0,2} from {3,4}
  Removing 3 disconnects {4} from {0,1,2}
```

---

## Pattern Recognition

### 30+ Advanced Graph Patterns

| # | Pattern | Approach |
|---|---------|----------|
| 1 | Euler circuit exists? | Check degrees |
| 2 | Find Euler path | Hierholzer's |
| 3 | TSP exact (N≤20) | Bitmask DP |
| 4 | TSP approximation | MST-based |
| 5 | Max independent set on tree | Tree DP |
| 6 | Tree diameter | Two BFS or DP |
| 7 | Tree center | Remove leaves or DP |
| 8 | Sum of distances in tree | Rerooting |
| 9 | Longest path in DAG | Topo sort + DP |
| 10 | Count paths in DAG | Topo sort + DP |
| 11 | Articulation points | Tarjan's |
| 12 | Bridges | Tarjan's (low > disc) |
| 13 | 2-edge connected components | Bridge finding |
| 14 | Biconnected components | AP finding |
| 15 | Block-cut tree | From biconnected |
| 16 | Hamiltonian path (N≤20) | Bitmask DP |
| 17 | Minimum vertex cover tree | Tree DP |
| 18 | Tree DP with rerooting | Two-pass DFS |
| 19 | DP on DAG | Topological order |
| 20 | Centroid decomposition | Divide & conquer tree |
| 21 | Heavy-light decomposition | Path queries |
| 22 | Virtual tree | Key vertices |
| 23 | Dominator tree | Advanced |
| 24 | 2-SAT | Implication graph SCC |
| 25 | Planar graph | Special properties |

---

## Problem Solving

### Practice Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Tree Distances I | CSES | Rerooting/Two BFS |
| 2 | Tree Distances II | CSES | Rerooting DP |
| 3 | Tree Diameter | CSES | BFS/DP |
| 4 | Company Queries I,II | CSES | LCA (Binary Lifting) |
| 5 | Subordinates | CSES | Subtree size |
| 6 | Tree Matching | CSES | Tree DP |
| 7 | Hamiltonian Flights | CSES | Bitmask DP |
| 8 | Mail Delivery | CSES | Euler circuit |
| 9 | Teleporters Path | CSES | Euler path |
| 10 | Network Breakdown | Various | Bridges |
| 11 | Critical Connections | LeetCode 1192 | Bridges |
| 12 | Articulation Points | GFG/SPOJ | Tarjan's |
| 13 | Longest Path (DAG) | CSES | DP on DAG |
| 14 | Shortest Routes Revisited | Various | DAG DP |
| 15 | Sum of Distances in Tree | LeetCode 834 | Rerooting |
| 16 | Binary Tree Cameras | LeetCode 968 | Tree DP |
| 17 | House Robber III | LeetCode 337 | Tree DP |
| 18 | Reconstruct Itinerary | LeetCode 332 | Euler path |
| 19 | Valid Arrangement of Pairs | LeetCode 2097 | Euler path |
| 20 | Shortest Hamiltonian Path | Various | Bitmask DP |

---

## Interview Preparation

### Top Questions

1. What is an Euler tour? Euler circuit vs path?
2. Conditions for Euler circuit/path existence?
3. Explain Hierholzer's algorithm.
4. What is TSP? Why is it NP-hard?
5. Explain bitmask DP for TSP.
6. What are articulation points? How to find them?
7. What are bridges? Difference from articulation points?
8. Explain Tarjan's algorithm for bridges/APs.
9. What is DP on trees? Common patterns?
10. Explain rerooting technique.
11. Longest path in a DAG vs general graph?
12. What is the tree diameter and how to find it?
13. Difference between DP on trees and DP on DAGs?
14. How would you solve TSP for 15 cities?
15. Real-world applications of Euler tours?

---

## Competitive Programming

### Bitmask DP Template (Hamiltonian Path)

```cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    int n, m;
    cin >> n >> m;
    
    vector<vector<int>> adj(n);
    for (int i = 0; i < m; i++) {
        int u, v; cin >> u >> v; u--; v--;
        adj[u].push_back(v);
    }
    
    // dp[mask][v] = number of paths visiting exactly vertices in mask, ending at v
    vector<vector<long long>> dp(1 << n, vector<long long>(n, 0));
    dp[1 << 0][0] = 1; // Start at vertex 0
    
    for (int mask = 1; mask < (1 << n); mask++) {
        for (int u = 0; u < n; u++) {
            if (!(mask & (1 << u)) || dp[mask][u] == 0) continue;
            for (int v : adj[u]) {
                if (mask & (1 << v)) continue;
                dp[mask | (1 << v)][v] += dp[mask][u];
            }
        }
    }
    
    long long ans = 0;
    int full = (1 << n) - 1;
    for (int v = 0; v < n; v++) ans += dp[full][v];
    // Or specific endpoint: dp[full][n-1]
    
    cout << ans << endl;
    return 0;
}
```

---

## Cheat Sheet

```
EULER TOUR:
• Circuit: all vertices even degree (undirected)
• Path: exactly 2 odd-degree vertices
• Algorithm: Hierholzer's O(V+E)

TSP:
• NP-hard, exact: O(N² × 2^N) bitmask DP
• Feasible for N ≤ 20
• dp[mask][last] = min cost visiting mask cities, ending at last

DP ON TREES:
• Bottom-up DFS (children before parent)
• dp[v] depends on dp[children]
• Rerooting: two passes (down then up)

DP ON GRAPHS (DAG):
• Process in topological order
• dp[v] = f(dp[predecessors])

ARTICULATION POINTS:
• Tarjan's: disc[] and low[] arrays
• AP if: root with 2+ children OR non-root with low[child] ≥ disc[v]

BRIDGES:
• Edge (u,v) is bridge if low[v] > disc[u]
• Means v's subtree has no back edge to u's ancestors
```
