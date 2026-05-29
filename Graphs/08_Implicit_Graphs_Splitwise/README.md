# Implicit Graphs & Splitwise Algorithm

## Table of Contents
- [Introduction to Implicit Graphs](#introduction-to-implicit-graphs)
- [Splitwise App Introduction](#splitwise-app-introduction)
- [Splitwise Algorithm Theory](#splitwise-algorithm-theory)
- [Splitwise Algorithm Implementation](#splitwise-algorithm-implementation)
- [Variants & Optimizations](#variants--optimizations)
- [Pattern Recognition](#pattern-recognition)
- [Problem Solving](#problem-solving)
- [Interview Preparation](#interview-preparation)
- [Competitive Programming](#competitive-programming)
- [Cheat Sheet](#cheat-sheet)

---

## Introduction to Implicit Graphs

### What is an Implicit Graph?

An **implicit graph** is a graph that is not explicitly stored in memory but is defined by rules or relationships. The graph structure emerges from the problem constraints.

### Examples of Implicit Graphs

| Problem | Nodes | Edges |
|---------|-------|-------|
| Word Ladder | Words | Words differing by 1 char |
| 8-puzzle | Board states | Valid moves |
| Rubik's cube | Cube states | Rotations |
| Splitwise | People | Debt relationships |
| Chess (knight) | Grid cells | Knight moves |
| State machines | States | Transitions |
| Network routing | Routers | Connections |

### Key Characteristics

```
Implicit graphs:
1. Nodes represent "states" of a system
2. Edges represent "transitions" between states
3. Often the full graph is too large to store
4. Generated on-the-fly during traversal
5. BFS/Dijkstra explores only reachable states
```

### Generic Implicit Graph BFS Template

```cpp
#include <bits/stdc++.h>
using namespace std;

// Generic implicit graph BFS
// State can be any type (int, string, tuple, vector, etc.)
template<typename State>
int bfsImplicit(State start, State goal, 
                function<vector<State>(State)> getNeighbors) {
    unordered_map<State, int> dist;
    queue<State> q;
    
    dist[start] = 0;
    q.push(start);
    
    while (!q.empty()) {
        State curr = q.front();
        q.pop();
        
        if (curr == goal) return dist[curr];
        
        for (State next : getNeighbors(curr)) {
            if (dist.find(next) == dist.end()) {
                dist[next] = dist[curr] + 1;
                q.push(next);
            }
        }
    }
    
    return -1; // Not reachable
}
```

---

## Splitwise App Introduction

### The Problem

In a group of friends, multiple transactions happen:
- A pays for B's dinner ($30)
- B pays for C's movie ($20)
- A pays for group lunch ($60 split among A, B, C)

After many transactions, everyone owes different amounts. The question is:
**What is the minimum number of transactions to settle all debts?**

### Modeling as a Graph

```
Consider people as nodes and debts as directed weighted edges.

After all group expenses:
  A is owed $50 (net positive - creditor)
  B owes $20 (net negative - debtor)
  C owes $30 (net negative - debtor)

Naive approach: 
  B pays A $20 (1 transaction)
  C pays A $30 (1 transaction)
  Total: 2 transactions

But with more complex scenarios, finding minimum transactions
is actually NP-hard in general!
```

### Visual Example

```
Original transactions:        Net balances:       Simplified:
                              
A --$30--> B                  A: +50              B --$20--> A
A --$20--> C                  B: -20              C --$30--> A
B --$10--> C                  C: -30
A --$60--> (A,B,C shared)    (sum = 0 ✓)         Only 2 transactions!
  A pays $60, each owes $20
  So B owes A $20
  So C owes A $20

Original had 4+ transactions, simplified to 2.
```

---

## Splitwise Algorithm Theory

### Step 1: Calculate Net Balances

```
For each person, calculate:
  net_balance = (total money received) - (total money paid)

Properties:
• Sum of all net balances = 0 (money is conserved)
• Positive balance = creditor (is owed money)
• Negative balance = debtor (owes money)
• Zero balance = settled (can be ignored)
```

### Step 2: Greedy Matching

The **greedy approach** to minimizing transactions:

```
Strategy: Match the largest creditor with the largest debtor.

Algorithm:
1. Separate into creditors (positive balance) and debtors (negative balance)
2. Sort both lists
3. Match largest creditor with largest debtor
4. Transfer min(credit, |debt|)
5. Reduce both balances accordingly
6. Repeat until all settled

This gives a good (often optimal for 2 groups) solution,
but NOT always minimum transactions for general case.
```

### Step 3: Optimal Solution (NP-hard)

For the truly minimum number of transactions:

```
Observation: 
- If a subset of people has net balances summing to 0,
  they can settle among themselves independently.
- Minimum transactions = N - (maximum number of groups 
  that can independently settle to 0)

This requires finding maximum partition into zero-sum subsets,
which is NP-hard (subset sum variant).

For practical purposes, the greedy approach works well.
```

### Mathematical Insight

```
Given N people with non-zero balances:
- Maximum possible transactions = N - 1
- Minimum possible transactions = N - (number of independent zero-sum subsets)

Example:
  Balances: [+5, -5, +3, -3]
  Groups: {+5, -5} and {+3, -3} → 2 groups
  Min transactions = 4 - 2 = 2
  
  Without grouping: could need up to 3 transactions
```

---

## Splitwise Algorithm Implementation

### Implementation 1: Greedy (Two Pointer)

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Transaction {
    string from, to;
    double amount;
};

vector<Transaction> settleDebtsGreedy(
    vector<pair<string, double>>& balances) {
    
    // Separate creditors and debtors
    vector<pair<double, string>> creditors, debtors;
    
    for (auto& [name, balance] : balances) {
        if (balance > 0) creditors.push_back({balance, name});
        else if (balance < 0) debtors.push_back({-balance, name});
    }
    
    // Sort in descending order of amount
    sort(creditors.rbegin(), creditors.rend());
    sort(debtors.rbegin(), debtors.rend());
    
    vector<Transaction> result;
    int i = 0, j = 0;
    
    while (i < creditors.size() && j < debtors.size()) {
        double amount = min(creditors[i].first, debtors[j].first);
        
        result.push_back({debtors[j].second, creditors[i].second, amount});
        
        creditors[i].first -= amount;
        debtors[j].first -= amount;
        
        if (creditors[i].first < 1e-9) i++;
        if (debtors[j].first < 1e-9) j++;
    }
    
    return result;
}

int main() {
    // Example: Group expense tracking
    // Expenses: A paid 60 for group (A,B,C), B paid 30 for A's dinner
    // Net: A spent 60, got back 20 (share) + 30 = net: -10
    //      B spent 30, owes 20 to group = net: -10... 
    
    // Let's use simple net balances directly:
    vector<pair<string, double>> balances = {
        {"Alice", 50},    // Is owed $50
        {"Bob", -20},     // Owes $20
        {"Charlie", -30}  // Owes $30
    };
    
    auto transactions = settleDebtsGreedy(balances);
    
    cout << "Settlement Transactions:" << endl;
    for (auto& t : transactions) {
        cout << "  " << t.from << " pays " << t.to 
             << " $" << t.amount << endl;
    }
    
    return 0;
}
```

### Implementation 2: Using Max-Heap

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Transaction {
    int from, to;
    long long amount;
};

vector<Transaction> settleDebtsHeap(vector<long long>& balance, int n) {
    // Max-heap for creditors {amount, person_id}
    priority_queue<pair<long long, int>> creditors;
    // Max-heap for debtors {|amount|, person_id}
    priority_queue<pair<long long, int>> debtors;
    
    for (int i = 0; i < n; i++) {
        if (balance[i] > 0) creditors.push({balance[i], i});
        else if (balance[i] < 0) debtors.push({-balance[i], i});
    }
    
    vector<Transaction> result;
    
    while (!creditors.empty() && !debtors.empty()) {
        auto [creditAmt, creditor] = creditors.top(); creditors.pop();
        auto [debtAmt, debtor] = debtors.top(); debtors.pop();
        
        long long transfer = min(creditAmt, debtAmt);
        result.push_back({debtor, creditor, transfer});
        
        if (creditAmt > transfer) {
            creditors.push({creditAmt - transfer, creditor});
        }
        if (debtAmt > transfer) {
            debtors.push({debtAmt - transfer, debtor});
        }
    }
    
    return result;
}

int main() {
    int n = 4;
    // Net balances: person 0: +100, 1: -40, 2: -30, 3: -30
    vector<long long> balance = {100, -40, -30, -30};
    
    auto transactions = settleDebtsHeap(balance, n);
    
    cout << "Minimum transactions to settle:" << endl;
    for (auto& t : transactions) {
        cout << "  Person " << t.from << " → Person " << t.to 
             << ": $" << t.amount << endl;
    }
    
    return 0;
}
```

### Implementation 3: Optimal (Backtracking + Subset Sum)

```cpp
#include <bits/stdc++.h>
using namespace std;

// Find minimum number of transactions (NP-hard, exponential)
class SplitWiseOptimal {
    vector<int> balance;
    int n;
    
    int solve(int start) {
        // Skip settled people
        while (start < n && balance[start] == 0) start++;
        if (start == n) return 0;
        
        int result = INT_MAX;
        
        for (int i = start + 1; i < n; i++) {
            // Try settling start's debt with person i
            // Only if they have opposite signs (one owes, one is owed)
            if (balance[start] * balance[i] < 0) {
                balance[i] += balance[start]; // Transfer
                result = min(result, 1 + solve(start + 1));
                balance[i] -= balance[start]; // Backtrack
            }
        }
        
        return result;
    }
    
public:
    int minTransactions(vector<vector<int>>& transactions) {
        unordered_map<int, int> netBalance;
        
        for (auto& t : transactions) {
            netBalance[t[0]] -= t[2];
            netBalance[t[1]] += t[2];
        }
        
        balance.clear();
        for (auto& [person, bal] : netBalance) {
            if (bal != 0) balance.push_back(bal);
        }
        
        n = balance.size();
        return solve(0);
    }
};

int main() {
    // LeetCode 465: Optimal Account Balancing
    vector<vector<int>> transactions = {
        {0, 1, 10}, // Person 0 gives 10 to Person 1
        {2, 0, 5},  // Person 2 gives 5 to Person 0
        {1, 3, 5},  // Person 1 gives 5 to Person 3
    };
    
    SplitWiseOptimal solver;
    cout << "Minimum transactions: " << solver.minTransactions(transactions) << endl;
    
    return 0;
}
```

### Dry Run: Greedy Approach

```
Input balances: Alice=+50, Bob=-20, Charlie=-30

Step 1: Separate
  Creditors: [(50, Alice)]
  Debtors: [(30, Charlie), (20, Bob)]  (sorted desc)

Step 2: Match

Round 1:
  Largest creditor: Alice (+50)
  Largest debtor: Charlie (-30)
  Transfer: min(50, 30) = 30
  Transaction: Charlie → Alice: $30
  Remaining: Alice=+20, Bob=-20, Charlie=0
  
Round 2:
  Largest creditor: Alice (+20)
  Largest debtor: Bob (-20)
  Transfer: min(20, 20) = 20
  Transaction: Bob → Alice: $20
  Remaining: Alice=0, Bob=0, Charlie=0

Result: 2 transactions
  1. Charlie pays Alice $30
  2. Bob pays Alice $20
```

### Dry Run: Optimal Backtracking

```
Transactions: {0→1: 10}, {2→0: 5}, {1→3: 5}

Net balances:
  Person 0: received 5 (from 2), paid 10 (to 1) → net = -5
  Person 1: received 10 (from 0), paid 5 (to 3) → net = +5
  Person 2: paid 5 (to 0) → net = -5
  Person 3: received 5 (from 1) → net = +5

Non-zero balances: [-5, +5, -5, +5]

Backtracking:
  solve(0): balance[0] = -5
    Try i=1: balance[1]=5, opposite sign ✓
      balance[1] = 5 + (-5) = 0
      1 + solve(1): balance[1]=0, skip
        solve(2): balance[2]=-5
          Try i=3: balance[3]=5, opposite sign ✓
            balance[3] = 5 + (-5) = 0
            1 + solve(3): all zero → return 0
            Total: 1 + 0 = 1
          Result for solve(2) = 1
        Total: 1 + 1 = 2
      Backtrack: balance[1] = 5
      
    Try i=2: balance[2]=-5, same sign ✗ (both negative)
    
    Try i=3: balance[3]=5, opposite sign ✓
      balance[3] = 5 + (-5) = 0
      1 + solve(1): balance[1]=5
        Try i=2: balance[2]=-5, opposite sign ✓
          balance[2] = -5 + 5 = 0
          1 + solve(2): balance[2]=0, skip
            solve(3): balance[3]=0, skip → return 0
          Total: 1 + 0 = 1
        Result for solve(1) = 1
      Total: 1 + 1 = 2
      Backtrack

  Minimum: 2 transactions

Answer: 2 (can't do better for this case)
```

---

## Variants & Optimizations

### Variant 1: Group Expense Calculator

```cpp
#include <bits/stdc++.h>
using namespace std;

class ExpenseManager {
    int n; // number of people
    vector<string> names;
    vector<long long> balance;
    
public:
    ExpenseManager(vector<string>& people) : names(people), n(people.size()) {
        balance.assign(n, 0);
    }
    
    // Person 'payer' pays amount for a group of people
    void addExpense(int payer, vector<int>& group, long long amount) {
        long long share = amount / group.size();
        long long remainder = amount % group.size();
        
        balance[payer] += amount; // Payer is owed
        
        for (int i = 0; i < group.size(); i++) {
            long long owe = share + (i < remainder ? 1 : 0);
            balance[group[i]] -= owe;
        }
    }
    
    // Direct payment: from pays to
    void addPayment(int from, int to, long long amount) {
        balance[from] -= amount;
        balance[to] += amount;
    }
    
    void printBalances() {
        cout << "Net Balances:" << endl;
        for (int i = 0; i < n; i++) {
            cout << "  " << names[i] << ": " << balance[i] << endl;
        }
    }
    
    void settleAll() {
        priority_queue<pair<long long, int>> creditors;
        priority_queue<pair<long long, int>> debtors;
        
        for (int i = 0; i < n; i++) {
            if (balance[i] > 0) creditors.push({balance[i], i});
            else if (balance[i] < 0) debtors.push({-balance[i], i});
        }
        
        cout << "\nSettlement:" << endl;
        while (!creditors.empty() && !debtors.empty()) {
            auto [ca, ci] = creditors.top(); creditors.pop();
            auto [da, di] = debtors.top(); debtors.pop();
            
            long long transfer = min(ca, da);
            cout << "  " << names[di] << " → " << names[ci] 
                 << ": $" << transfer << endl;
            
            if (ca > transfer) creditors.push({ca - transfer, ci});
            if (da > transfer) debtors.push({da - transfer, di});
        }
    }
};

int main() {
    vector<string> people = {"Alice", "Bob", "Charlie", "Dave"};
    ExpenseManager mgr(people);
    
    // Alice pays $120 for dinner (split among all 4)
    vector<int> all = {0, 1, 2, 3};
    mgr.addExpense(0, all, 120);
    
    // Bob pays $40 for taxi (split among Bob, Charlie)
    vector<int> taxi = {1, 2};
    mgr.addExpense(1, taxi, 40);
    
    // Charlie pays $60 for movie (split among all)
    mgr.addExpense(2, all, 60);
    
    mgr.printBalances();
    mgr.settleAll();
    
    return 0;
}
```

### Variant 2: Graph-Based Debt Simplification

```cpp
#include <bits/stdc++.h>
using namespace std;

// Model debts as a directed weighted graph
// Simplify by finding net flows
class DebtGraph {
    int n;
    vector<vector<long long>> debt; // debt[i][j] = amount i owes j
    
public:
    DebtGraph(int n) : n(n), debt(n, vector<long long>(n, 0)) {}
    
    void addDebt(int from, int to, long long amount) {
        debt[from][to] += amount;
    }
    
    // Simplify: cancel opposite debts
    void simplify() {
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                long long net = debt[i][j] - debt[j][i];
                debt[i][j] = max(0LL, net);
                debt[j][i] = max(0LL, -net);
            }
        }
    }
    
    // Further simplification using net balances
    vector<tuple<int,int,long long>> getMinTransactions() {
        vector<long long> balance(n, 0);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                balance[i] -= debt[i][j]; // I owe
                balance[i] += debt[j][i]; // Others owe me
            }
        }
        
        // Greedy matching
        priority_queue<pair<long long,int>> creditors;
        priority_queue<pair<long long,int>> debtors;
        
        for (int i = 0; i < n; i++) {
            if (balance[i] > 0) creditors.push({balance[i], i});
            else if (balance[i] < 0) debtors.push({-balance[i], i});
        }
        
        vector<tuple<int,int,long long>> result;
        while (!creditors.empty()) {
            auto [ca, ci] = creditors.top(); creditors.pop();
            auto [da, di] = debtors.top(); debtors.pop();
            
            long long t = min(ca, da);
            result.push_back({di, ci, t});
            
            if (ca > t) creditors.push({ca - t, ci});
            if (da > t) debtors.push({da - t, di});
        }
        
        return result;
    }
};
```

---

## Pattern Recognition

### Implicit Graph Patterns

| # | Pattern | Example |
|---|---------|---------|
| 1 | State = configuration | 8-puzzle, Rubik's |
| 2 | State = position + metadata | Knight moves with constraints |
| 3 | State = bitmask | TSP, visited subset |
| 4 | State = (node, fuel) | Constrained shortest path |
| 5 | State = string | Word ladder |
| 6 | State = (row, col, dir) | Grid with directions |
| 7 | State = tuple | Multi-variable state |
| 8 | State = graph coloring | Constraint satisfaction |
| 9 | Debt simplification | Splitwise |
| 10 | Flow network | Max flow modeling |

### Debt/Transaction Patterns

| # | Pattern | Approach |
|---|---------|----------|
| 11 | Minimum transactions | Net balance + greedy |
| 12 | Fair splitting | Equal division |
| 13 | Weighted splitting | Proportional shares |
| 14 | Circular debts | Cancel cycles |
| 15 | Group expenses | Track per-person balance |
| 16 | Multi-currency | Convert to base currency |
| 17 | Partial settlements | Incremental balance update |
| 18 | Transaction limit | Constrained optimization |
| 19 | Priority debts | Weighted matching |
| 20 | Time-based interest | Dynamic balance |

---

## Problem Solving

### Practice Problems

| # | Problem | Platform | Key Concept |
|---|---------|----------|-------------|
| 1 | Optimal Account Balancing | LeetCode 465 | Backtracking NP-hard |
| 2 | Word Ladder | LeetCode 127 | Implicit graph BFS |
| 3 | Word Ladder II | LeetCode 126 | BFS + path reconstruction |
| 4 | Open the Lock | LeetCode 752 | Implicit graph BFS |
| 5 | Sliding Puzzle | LeetCode 773 | State-space BFS |
| 6 | Minimum Genetic Mutation | LeetCode 433 | Implicit graph |
| 7 | 8 Puzzle Problem | GFG | A* / BFS |
| 8 | Knight Minimum Moves | LeetCode 1197 | Implicit graph BFS |
| 9 | Shortest Path in Grid with Obstacles | LeetCode 1293 | BFS + state |
| 10 | Minimum Knight Moves | Various | BFS/math |
| 11 | Jump Game IV | LeetCode 1345 | Implicit graph BFS |
| 12 | Bus Routes | LeetCode 815 | Multi-source BFS |
| 13 | Escape a Large Maze | LeetCode 1036 | BFS with bound |
| 14 | Pacific Atlantic Water Flow | LeetCode 417 | Multi-source BFS |
| 15 | Snakes and Ladders | LeetCode 909 | Implicit graph |

---

## Interview Preparation

### Top Questions

1. What is an implicit graph? Give examples.
2. How does Splitwise minimize transactions?
3. Is minimum transactions always achievable with greedy? (No, NP-hard in general)
4. How do you model Splitwise as a graph problem?
5. What's the time complexity of the greedy approach? (O(N log N))
6. What's the time complexity of optimal solution? (Exponential)
7. How do you handle unequal splits?
8. How would you design Splitwise's backend?
9. What data structures would you use for real-time expense tracking?
10. How do you handle cycles in debt graphs?
11. Solve LeetCode 465 (Optimal Account Balancing).
12. How does BFS work on implicit graphs?
13. When is the state space too large for BFS?
14. How does A* improve upon BFS for implicit graphs?
15. Design a system for group expense management.

---

## Competitive Programming

### Template: Implicit Graph BFS

```cpp
#include <bits/stdc++.h>
using namespace std;

// BFS on implicit graph with string states
int bfs(string start, string target, 
        function<vector<string>(string)> getNext) {
    if (start == target) return 0;
    
    unordered_set<string> visited;
    queue<pair<string, int>> q;
    
    visited.insert(start);
    q.push({start, 0});
    
    while (!q.empty()) {
        auto [state, dist] = q.front();
        q.pop();
        
        for (string next : getNext(state)) {
            if (next == target) return dist + 1;
            if (!visited.count(next)) {
                visited.insert(next);
                q.push({next, dist + 1});
            }
        }
    }
    return -1;
}
```

---

## Cheat Sheet

```
IMPLICIT GRAPHS:
• Not stored explicitly, generated during traversal
• Nodes = states, Edges = transitions
• Solve with BFS/DFS/Dijkstra on state space

SPLITWISE ALGORITHM:
1. Calculate net balance for each person
2. Separate creditors (+) and debtors (-)
3. Match largest creditor with largest debtor
4. Transfer min(credit, |debt|)
5. Repeat until settled

COMPLEXITY:
• Greedy: O(N log N) - good enough in practice
• Optimal (min transactions): NP-hard (backtracking)

KEY INSIGHT:
• Min transactions = N - (max independent zero-sum subsets)
• Greedy gives at most N-1 transactions
• Sum of all balances = 0 (conservation)

WHEN TO USE:
• Debt simplification → Net balance approach
• State-space search → BFS on implicit graph
• Configuration puzzles → BFS with visited set
```
