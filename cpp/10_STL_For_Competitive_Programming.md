# 📘 Chapter 10: STL for Competitive Programming — Tricks, Patterns & Templates

> **The ultimate competitive programmer's STL toolkit — patterns that win contests.**

---

## Table of Contents

- [1. CP Template Setup](#1-cp-template-setup)
- [2. Coordinate Compression](#2-coordinate-compression)
- [3. Frequency Counting](#3-frequency-counting)
- [4. Two Pointer Technique](#4-two-pointer-technique)
- [5. Sliding Window](#5-sliding-window)
- [6. Prefix Sums with STL](#6-prefix-sums-with-stl)
- [7. Heaps for Problems](#7-heaps-for-problems)
- [8. Set/Map Tricks](#8-setmap-tricks)
- [9. Bit Manipulation with STL](#9-bit-manipulation-with-stl)
- [10. Graph Patterns with STL](#10-graph-patterns-with-stl)
- [11. Common CP Patterns](#11-common-cp-patterns)
- [12. STL Speed Optimization](#12-stl-speed-optimization)
- [13. Summary](#13-summary)
- [14. Practice Section](#14-practice-section)

---

## 1. CP Template Setup

### 1.1 Comprehensive CP Template

```cpp
#include <bits/stdc++.h>
using namespace std;

// ─────────────────────────── Type Aliases ───────────────────────────
typedef long long ll;
typedef pair<int,int> pii;
typedef pair<ll,ll> pll;
typedef vector<int> vi;
typedef vector<ll> vll;
typedef vector<pii> vpii;

// ─────────────────────────── Constants ──────────────────────────────
const int MOD = 1e9 + 7;
const int INF = 1e9;
const ll LINF = 1e18;
const double EPS = 1e-9;

// ─────────────────────────── Macros ─────────────────────────────────
#define all(v) (v).begin(), (v).end()
#define rall(v) (v).rbegin(), (v).rend()
#define sz(v) (int)(v).size()
#define pb push_back
#define eb emplace_back
#define mp make_pair
#define F first
#define S second
#define rep(i,a,b) for(int i=(a);i<(b);i++)
#define per(i,a,b) for(int i=(a)-1;i>=(b);i--)

// ─────────────────────────── Debug ──────────────────────────────────
#ifdef LOCAL
#define dbg(x) cerr << #x << " = " << (x) << endl
#else
#define dbg(x)
#endif

// ─────────────────────────── Fast I/O ───────────────────────────────
void fast_io() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
}

int main() {
    fast_io();
    int t;
    cin >> t;
    while (t--) {
        // solve
    }
    return 0;
}
```

### 1.2 PBDS Template

```cpp
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;

template<typename T>
using ordered_set = tree<T, null_type, less<T>, rb_tree_tag,
    tree_order_statistics_node_update>;
// os.find_by_order(k) — k-th element (0-indexed)
// os.order_of_key(x)  — count of elements < x
```

---

## 2. Coordinate Compression

### 2.1 Standard Technique

```cpp
// Compress large values to small range [0, unique_count)
vector<int> compress(vector<int>& arr) {
    vector<int> sorted_unique = arr;
    sort(all(sorted_unique));
    sorted_unique.erase(unique(all(sorted_unique)), sorted_unique.end());
    
    vector<int> compressed(arr.size());
    for (int i = 0; i < sz(arr); i++) {
        compressed[i] = lower_bound(all(sorted_unique), arr[i]) 
                        - sorted_unique.begin();
    }
    return compressed;
}

// Example:
// arr = {100, 500, 200, 100, 500}
// sorted_unique = {100, 200, 500}
// compressed = {0, 2, 1, 0, 2}
```

### 2.2 Coordinate Compression for 2D

```cpp
// Compress x and y coordinates independently
vector<int> xs, ys;
for (auto& [x, y] : points) {
    xs.push_back(x);
    ys.push_back(y);
}

sort(all(xs)); xs.erase(unique(all(xs)), xs.end());
sort(all(ys)); ys.erase(unique(all(ys)), ys.end());

for (auto& [x, y] : points) {
    x = lower_bound(all(xs), x) - xs.begin();
    y = lower_bound(all(ys), y) - ys.begin();
}
```

### 2.3 Use Cases

```
When to use coordinate compression:
1. Values up to 10^9 but count ≤ 10^5
2. Segment tree / BIT on large ranges
3. Counting distinct values in ranges
4. Sweep line problems
```

---

## 3. Frequency Counting

### 3.1 With map/unordered_map

```cpp
// Count frequency of each element
unordered_map<int, int> freq;
for (int x : arr) freq[x]++;

// Find most frequent
auto it = max_element(all(freq), [](auto& a, auto& b) {
    return a.second < b.second;
});
cout << it->first << " appears " << it->second << " times\n";
```

### 3.2 With Array (When Values are Small)

```cpp
// Faster! O(1) per operation
int freq[1000001] = {};  // For values 0..10^6
for (int x : arr) freq[x]++;
```

### 3.3 Frequency-Based Problems

```cpp
// Group Anagrams — sort each string as key
map<string, vector<string>> groups;
for (string& s : words) {
    string key = s;
    sort(all(key));
    groups[key].push_back(s);
}

// Check if two strings are anagrams
bool isAnagram(const string& a, const string& b) {
    if (a.size() != b.size()) return false;
    int freq[26] = {};
    for (char c : a) freq[c - 'a']++;
    for (char c : b) freq[c - 'a']--;
    return all_of(freq, freq + 26, [](int x) { return x == 0; });
}
```

---

## 4. Two Pointer Technique

### 4.1 Two Sum on Sorted Array

```cpp
// Find pair with target sum in sorted array
pair<int,int> twoSum(vector<int>& v, int target) {
    int l = 0, r = sz(v) - 1;
    while (l < r) {
        int sum = v[l] + v[r];
        if (sum == target) return {l, r};
        else if (sum < target) l++;
        else r--;
    }
    return {-1, -1};
}
```

### 4.2 Remove Duplicates In-Place

```cpp
int removeDups(vector<int>& v) {
    if (v.empty()) return 0;
    int j = 0;
    for (int i = 1; i < sz(v); i++) {
        if (v[i] != v[j]) {
            v[++j] = v[i];
        }
    }
    return j + 1;  // New length
}
// Or use: v.erase(unique(all(v)), v.end());
```

### 4.3 Container Intersection

```cpp
// Find common elements in two sorted arrays
vector<int> intersection(vector<int>& a, vector<int>& b) {
    vector<int> result;
    int i = 0, j = 0;
    while (i < sz(a) && j < sz(b)) {
        if (a[i] < b[j]) i++;
        else if (a[i] > b[j]) j++;
        else {
            result.push_back(a[i]);
            i++; j++;
        }
    }
    return result;
}
// Or use: set_intersection(all(a), all(b), back_inserter(result));
```

### 4.4 Three Sum

```cpp
vector<vector<int>> threeSum(vector<int>& nums, int target) {
    sort(all(nums));
    vector<vector<int>> result;
    
    for (int i = 0; i < sz(nums) - 2; i++) {
        if (i > 0 && nums[i] == nums[i-1]) continue;  // Skip duplicate first element
        
        int l = i + 1, r = sz(nums) - 1;
        while (l < r) {
            int sum = nums[i] + nums[l] + nums[r];
            if (sum == target) {
                result.push_back({nums[i], nums[l], nums[r]});
                while (l < r && nums[l] == nums[l+1]) l++;
                while (l < r && nums[r] == nums[r-1]) r--;
                l++; r--;
            }
            else if (sum < target) l++;
            else r--;
        }
    }
    return result;
}
```

---

## 5. Sliding Window

### 5.1 Fixed-Size Window (Sum)

```cpp
// Maximum sum of subarray of size k
int maxSubarraySum(vector<int>& v, int k) {
    int sum = accumulate(v.begin(), v.begin() + k, 0);
    int maxSum = sum;
    
    for (int i = k; i < sz(v); i++) {
        sum += v[i] - v[i - k];  // Slide: add right, remove left
        maxSum = max(maxSum, sum);
    }
    return maxSum;
}
```

### 5.2 Variable-Size Window (At Most K Distinct)

```cpp
// Longest substring with at most k distinct characters
int longestKDistinct(string& s, int k) {
    unordered_map<char, int> freq;
    int maxLen = 0, left = 0;
    
    for (int right = 0; right < sz(s); right++) {
        freq[s[right]]++;
        
        while (sz(freq) > k) {
            freq[s[left]]--;
            if (freq[s[left]] == 0) freq.erase(s[left]);
            left++;
        }
        
        maxLen = max(maxLen, right - left + 1);
    }
    return maxLen;
}
```

### 5.3 Sliding Window Maximum (Monotonic Deque)

```cpp
vector<int> maxSlidingWindow(vector<int>& nums, int k) {
    deque<int> dq;  // Indices, maintaining decreasing order of values
    vector<int> result;
    
    for (int i = 0; i < sz(nums); i++) {
        // Remove elements outside window
        while (!dq.empty() && dq.front() <= i - k) dq.pop_front();
        
        // Maintain monotonic decreasing
        while (!dq.empty() && nums[dq.back()] <= nums[i]) dq.pop_back();
        
        dq.push_back(i);
        
        if (i >= k - 1) result.push_back(nums[dq.front()]);
    }
    return result;
}
// Time: O(n), Space: O(k)
```

### 5.4 Sliding Window with Multiset (Median)

```cpp
// Sliding window median
double getMedian(multiset<int>& window, int k) {
    auto mid = next(window.begin(), k / 2);
    if (k % 2 == 1) return *mid;
    return ((double)*mid + *prev(mid)) / 2.0;
}
```

---

## 6. Prefix Sums with STL

### 6.1 Basic Prefix Sum

```cpp
vector<int> v = {1, 3, 5, 7, 9};
vector<int> prefix(sz(v) + 1, 0);

partial_sum(all(v), prefix.begin() + 1);
// prefix = {0, 1, 4, 9, 16, 25}

// Range sum query [l, r] (0-indexed, inclusive):
int rangeSum = prefix[r + 1] - prefix[l];
```

### 6.2 2D Prefix Sum

```cpp
// Build 2D prefix sum
vector<vector<int>> grid(n, vector<int>(m));
vector<vector<int>> ps(n + 1, vector<int>(m + 1, 0));

for (int i = 0; i < n; i++)
    for (int j = 0; j < m; j++)
        ps[i+1][j+1] = grid[i][j] + ps[i][j+1] + ps[i+1][j] - ps[i][j];

// Query sum of rectangle (r1,c1) to (r2,c2) inclusive:
int rectSum = ps[r2+1][c2+1] - ps[r1][c2+1] - ps[r2+1][c1] + ps[r1][c1];
```

### 6.3 Prefix XOR

```cpp
vector<int> v = {3, 1, 4, 1, 5};
vector<int> px(sz(v) + 1, 0);
for (int i = 0; i < sz(v); i++) px[i+1] = px[i] ^ v[i];

// Range XOR [l, r]:
int rangeXor = px[r + 1] ^ px[l];
```

### 6.4 Difference Array (Reverse Prefix Sum)

```cpp
// Add value to range [l, r] efficiently
vector<int> diff(n + 1, 0);

// Add val to [l, r]:
diff[l] += val;
diff[r + 1] -= val;

// Reconstruct:
partial_sum(all(diff), diff.begin());
// diff[i] now contains the actual value at position i
```

---

## 7. Heaps for Problems

### 7.1 K-th Largest Element

```cpp
int kthLargest(vector<int>& v, int k) {
    // Min-heap of size k
    priority_queue<int, vector<int>, greater<int>> pq;
    for (int x : v) {
        pq.push(x);
        if (sz(pq) > k) pq.pop();
    }
    return pq.top();
}
// Time: O(n log k)
```

### 7.2 Median Maintenance

```cpp
struct MedianFinder {
    priority_queue<int> lo;                                    // max-heap (lower half)
    priority_queue<int, vector<int>, greater<int>> hi;        // min-heap (upper half)
    
    void add(int num) {
        lo.push(num);
        hi.push(lo.top()); lo.pop();
        if (sz(hi) > sz(lo)) { lo.push(hi.top()); hi.pop(); }
    }
    
    double median() {
        return sz(lo) > sz(hi) ? lo.top() : (lo.top() + hi.top()) / 2.0;
    }
};
```

### 7.3 Greedy with Heap

```cpp
// Minimum cost to connect ropes
ll connectRopes(vector<int>& ropes) {
    priority_queue<ll, vector<ll>, greater<ll>> pq(all(ropes));
    ll cost = 0;
    
    while (sz(pq) > 1) {
        ll a = pq.top(); pq.pop();
        ll b = pq.top(); pq.pop();
        cost += a + b;
        pq.push(a + b);
    }
    return cost;
}
```

### 7.4 Top K Frequent Elements

```cpp
vector<int> topKFrequent(vector<int>& nums, int k) {
    unordered_map<int, int> freq;
    for (int x : nums) freq[x]++;
    
    // Min-heap by frequency
    auto cmp = [](pii& a, pii& b) { return a.second > b.second; };
    priority_queue<pii, vpii, decltype(cmp)> pq(cmp);
    
    for (auto& [val, cnt] : freq) {
        pq.push({val, cnt});
        if (sz(pq) > k) pq.pop();
    }
    
    vector<int> result;
    while (!pq.empty()) {
        result.push_back(pq.top().first);
        pq.pop();
    }
    return result;
}
```

---

## 8. Set/Map Tricks

### 8.1 Ordered Set as Sorted Container

```cpp
// Maintain dynamic sorted sequence
set<int> s;
s.insert(5); s.insert(2); s.insert(8); s.insert(1);

// First/last element
int smallest = *s.begin();            // 1
int largest = *s.rbegin();            // 8

// Predecessor / Successor
auto it = s.find(5);
auto pred = prev(it);   // Points to 2
auto succ = next(it);   // Points to 8

// Lower/upper bound
auto lb = s.lower_bound(3);  // Points to 5 (first ≥ 3)
auto ub = s.upper_bound(5);  // Points to 8 (first > 5)
```

### 8.2 Multiset for Sorted Multisets

```cpp
multiset<int> ms;
ms.insert(5); ms.insert(3); ms.insert(5); ms.insert(1);
// ms = {1, 3, 5, 5}

// ⚠️ erase(value) removes ALL occurrences!
ms.erase(5);  // ms = {1, 3}

// Remove only ONE occurrence:
auto it = ms.find(5);
if (it != ms.end()) ms.erase(it);  // Removes one 5
```

### 8.3 Map as Counter with Custom Default

```cpp
map<string, int> counter;
// operator[] creates default (0 for int) if key doesn't exist
counter["apple"]++;
counter["banana"]++;
counter["apple"]++;
// {"apple": 2, "banana": 1}

// Check existence without creating:
if (counter.count("cherry") == 0) {
    // Key doesn't exist — and we didn't accidentally create it
}
```

### 8.4 Set for Interval Merging

```cpp
// Merge overlapping intervals
vector<pii> merge_intervals(vector<pii>& intervals) {
    sort(all(intervals));
    vector<pii> result;
    
    for (auto& [s, e] : intervals) {
        if (!result.empty() && result.back().second >= s) {
            result.back().second = max(result.back().second, e);
        } else {
            result.push_back({s, e});
        }
    }
    return result;
}
```

### 8.5 Set-based Dijkstra

```cpp
vector<ll> dijkstra(vector<vector<pii>>& adj, int src) {
    int n = sz(adj);
    vector<ll> dist(n, LINF);
    set<pair<ll,int>> pq;  // {dist, node}
    
    dist[src] = 0;
    pq.insert({0, src});
    
    while (!pq.empty()) {
        auto [d, u] = *pq.begin();
        pq.erase(pq.begin());
        
        for (auto [v, w] : adj[u]) {
            if (dist[u] + w < dist[v]) {
                pq.erase({dist[v], v});  // Remove old entry
                dist[v] = dist[u] + w;
                pq.insert({dist[v], v});  // Insert updated
            }
        }
    }
    return dist;
}
// Advantage over priority_queue: can "decrease key" by erase + insert
```

---

## 9. Bit Manipulation with STL

### 9.1 __builtin Functions (GCC)

```cpp
int x = 12;  // Binary: 1100

__builtin_popcount(x);       // 2 (number of set bits)
__builtin_clz(x);            // 28 (leading zeros in 32-bit)
__builtin_ctz(x);            // 2 (trailing zeros)
__builtin_parity(x);         // 0 (even number of set bits)

// For long long: add 'll' suffix
__builtin_popcountll(x);
__builtin_clzll(x);
__builtin_ctzll(x);

// Highest bit position:
int highest = 31 - __builtin_clz(x);  // 3 for x=12

// Lowest set bit:
int lowest = __builtin_ctz(x);        // 2 for x=12

// Is power of 2?
bool isPow2 = x && !(x & (x - 1));
// Or: __builtin_popcount(x) == 1;
```

### 9.2 bitset

```cpp
#include <bitset>

bitset<32> b1(42);              // From integer
bitset<8> b2("10110011");       // From string

// Operations
b1.count();     // Number of set bits
b1.test(3);     // Test bit at position 3
b1.set(5);      // Set bit 5
b1.reset(5);    // Clear bit 5
b1.flip(5);     // Toggle bit 5
b1.any();       // True if any bit set
b1.none();      // True if no bits set
b1.all();       // True if all bits set

// Bitwise operations
bitset<32> b3 = b1 & b2;
bitset<32> b4 = b1 | b2;
bitset<32> b5 = b1 ^ b2;
bitset<32> b6 = ~b1;

// Shift
bitset<32> b7 = b1 << 3;
bitset<32> b8 = b1 >> 2;

// Convert
unsigned long val = b1.to_ulong();
string s = b1.to_string();
```

### 9.3 Bitmask Subset Enumeration

```cpp
// Iterate over all subsets of a bitmask
int mask = 0b10110;  // Binary: 10110

for (int sub = mask; sub > 0; sub = (sub - 1) & mask) {
    cout << bitset<5>(sub) << "\n";
}
// Prints: 10110, 10100, 10010, 10000, 00110, 00100, 00010

// O(3^n) total for all masks — important for DP over subsets
```

---

## 10. Graph Patterns with STL

### 10.1 Adjacency List

```cpp
// Unweighted
vector<vector<int>> adj(n);
adj[u].push_back(v);
adj[v].push_back(u);  // Undirected

// Weighted
vector<vector<pair<int,int>>> adj(n);  // {neighbor, weight}
adj[u].push_back({v, w});
```

### 10.2 BFS Template

```cpp
vector<int> bfs(vector<vector<int>>& adj, int src) {
    int n = sz(adj);
    vector<int> dist(n, -1);
    queue<int> q;
    
    dist[src] = 0;
    q.push(src);
    
    while (!q.empty()) {
        int u = q.front(); q.pop();
        for (int v : adj[u]) {
            if (dist[v] == -1) {
                dist[v] = dist[u] + 1;
                q.push(v);
            }
        }
    }
    return dist;
}
```

### 10.3 DFS Template

```cpp
vector<bool> visited;
vector<vector<int>> adj;

void dfs(int u) {
    visited[u] = true;
    for (int v : adj[u]) {
        if (!visited[v]) dfs(v);
    }
}

// Iterative DFS (avoids stack overflow for large graphs)
void dfs_iterative(int src) {
    stack<int> stk;
    stk.push(src);
    visited[src] = true;
    
    while (!stk.empty()) {
        int u = stk.top(); stk.pop();
        for (int v : adj[u]) {
            if (!visited[v]) {
                visited[v] = true;
                stk.push(v);
            }
        }
    }
}
```

### 10.4 Topological Sort (Kahn's BFS)

```cpp
vector<int> topoSort(vector<vector<int>>& adj, int n) {
    vector<int> indegree(n, 0);
    for (int u = 0; u < n; u++)
        for (int v : adj[u])
            indegree[v]++;
    
    queue<int> q;
    for (int i = 0; i < n; i++)
        if (indegree[i] == 0) q.push(i);
    
    vector<int> order;
    while (!q.empty()) {
        int u = q.front(); q.pop();
        order.push_back(u);
        for (int v : adj[u])
            if (--indegree[v] == 0) q.push(v);
    }
    
    return order;  // If sz(order) < n, cycle exists!
}
```

### 10.5 DSU (Union-Find)

```cpp
struct DSU {
    vector<int> parent, rank_;
    int components;
    
    DSU(int n) : parent(n), rank_(n, 0), components(n) {
        iota(all(parent), 0);
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
        components--;
        return true;
    }
    
    bool connected(int x, int y) { return find(x) == find(y); }
};
```

---

## 11. Common CP Patterns

### 11.1 Binary Search on Answer

```cpp
// "Find minimum X such that condition(X) is true"
int lo = 0, hi = 1e9;
while (lo < hi) {
    int mid = lo + (hi - lo) / 2;
    if (condition(mid)) hi = mid;
    else lo = mid + 1;
}
// Answer: lo

// "Find maximum X such that condition(X) is true"
int lo = 0, hi = 1e9;
while (lo < hi) {
    int mid = lo + (hi - lo + 1) / 2;  // +1 to avoid infinite loop
    if (condition(mid)) lo = mid;
    else hi = mid - 1;
}
// Answer: lo
```

### 11.2 Meet in the Middle

```cpp
// Split array in half, enumerate all subsets for each half
// Combine using sorting + binary search or two pointers

void allSubsetSums(vector<int>& arr, int start, int end, vector<ll>& sums) {
    int n = end - start;
    for (int mask = 0; mask < (1 << n); mask++) {
        ll sum = 0;
        for (int i = 0; i < n; i++)
            if (mask & (1 << i)) sum += arr[start + i];
        sums.push_back(sum);
    }
}

// Find if any subset has sum = target
bool subsetSum(vector<int>& arr, ll target) {
    int n = sz(arr);
    vector<ll> left, right;
    allSubsetSums(arr, 0, n/2, left);
    allSubsetSums(arr, n/2, n, right);
    
    sort(all(right));
    for (ll s : left) {
        if (binary_search(all(right), target - s)) return true;
    }
    return false;
}
```

### 11.3 Sweep Line with multiset

```cpp
// Count maximum overlapping intervals
int maxOverlap(vector<pii>& intervals) {
    vector<pii> events;  // {time, +1/-1}
    for (auto& [s, e] : intervals) {
        events.push_back({s, +1});
        events.push_back({e, -1});
    }
    sort(all(events));
    
    int cur = 0, maxOvlp = 0;
    for (auto& [t, type] : events) {
        cur += type;
        maxOvlp = max(maxOvlp, cur);
    }
    return maxOvlp;
}
```

### 11.4 Sparse Table (with STL)

```cpp
// Range minimum query in O(1) after O(n log n) preprocessing
struct SparseTable {
    vector<vector<int>> table;
    vector<int> lg;
    
    SparseTable(vector<int>& arr) {
        int n = sz(arr);
        int K = __lg(n) + 1;
        table.assign(K, vector<int>(n));
        lg.resize(n + 1);
        
        for (int i = 2; i <= n; i++) lg[i] = lg[i/2] + 1;
        table[0] = arr;
        
        for (int k = 1; k < K; k++)
            for (int i = 0; i + (1 << k) <= n; i++)
                table[k][i] = min(table[k-1][i], 
                                  table[k-1][i + (1 << (k-1))]);
    }
    
    int query(int l, int r) {  // [l, r] inclusive
        int k = lg[r - l + 1];
        return min(table[k][l], table[k][r - (1 << k) + 1]);
    }
};
```

### 11.5 Sorting Events by Multiple Criteria

```cpp
// Activity selection: sort by end time
sort(all(events), [](auto& a, auto& b) {
    return a.end < b.end;
});

// Job scheduling: sort by deadline, then by profit (desc)
sort(all(jobs), [](auto& a, auto& b) {
    if (a.deadline != b.deadline) return a.deadline < b.deadline;
    return a.profit > b.profit;
});
```

---

## 12. STL Speed Optimization

### 12.1 Fast I/O

```cpp
// MUST have this for competitive programming:
ios_base::sync_with_stdio(false);
cin.tie(nullptr);

// Even faster: scanf/printf (C-style)
scanf("%d", &n);
printf("%d\n", ans);

// Fastest: read entire input at once
// (rarely needed, but for extremely tight TL)
```

### 12.2 Reserve Containers

```cpp
vector<int> v;
v.reserve(n);  // Preallocate when you know size

unordered_map<int,int> m;
m.reserve(n);      // Reserve buckets
m.max_load_factor(0.25);  // Reduce collisions
```

### 12.3 Use Array Instead of Map When Possible

```cpp
// ❌ Slow: unordered_map<int,int> freq;
// ✅ Fast: int freq[MAX_VAL];

// ❌ Slow: map<pair<int,int>, int> grid;
// ✅ Fast: int grid[MAX_N][MAX_M];
```

### 12.4 Avoid Unnecessary Copies

```cpp
// ❌ Copy in range-for
for (auto x : large_vector) { }

// ✅ Reference in range-for
for (auto& x : large_vector) { }
for (const auto& x : large_vector) { }

// ❌ Copy in function parameter
void process(vector<int> v) { }

// ✅ Reference
void process(const vector<int>& v) { }
```

### 12.5 Pragmas (GCC Speed Hacks)

```cpp
#pragma GCC optimize("O2")
#pragma GCC optimize("unroll-loops")
#pragma GCC target("avx2")

// These can speed up code significantly on Codeforces/SPOJ
// Use with caution — may cause issues on some judges
```

### 12.6 Performance Comparison

```
┌─────────────────────────────────┬─────────────────────────────┐
│ Slower                          │ Faster                      │
├─────────────────────────────────┼─────────────────────────────┤
│ map<int,int>                    │ unordered_map or array      │
│ set<int>                        │ unordered_set or sorted vec │
│ list<int>                       │ vector<int>                 │
│ endl                            │ "\n"                        │
│ cin/cout (no sync off)          │ scanf/printf or sync off    │
│ new/delete in loops             │ pre-allocated arrays        │
│ recursive DFS (deep graphs)     │ iterative with stack        │
│ std::function for recursion     │ auto& self lambda or global │
└─────────────────────────────────┴─────────────────────────────┘
```

---

## 13. Summary

```
┌──────────────────────────────────────────────────────────────────┐
│              CP STL TRICKS — MASTER CHEAT SHEET                   │
├──────────────────────────────────────────────────────────────────┤
│ SETUP: fast_io, #define macros, type aliases                     │
│                                                                   │
│ PATTERNS:                                                        │
│ • Coordinate Compression: sort + unique + lower_bound            │
│ • Frequency: unordered_map or freq[] array                       │
│ • Two Pointer: sorted array, l/r convergence                    │
│ • Sliding Window: fixed (sum tracking) or variable (map/set)    │
│ • Prefix Sum: partial_sum, 2D prefix, XOR prefix                │
│ • Binary Search on Answer: lo/hi + condition(mid)               │
│ • Monotonic Stack/Deque: NGE, sliding window max                │
│ • Heap: K-th element, median, greedy scheduling                 │
│ • PBDS: ordered_set for rank/select O(log n)                    │
│                                                                   │
│ GRAPHS:                                                          │
│ • BFS: queue + dist array                                        │
│ • DFS: recursion or explicit stack                               │
│ • Dijkstra: priority_queue or set                                │
│ • Topo sort: Kahn's BFS with indegree                           │
│ • DSU: path compression + union by rank                          │
│                                                                   │
│ SPEED:                                                           │
│ • sync_with_stdio(false)                                        │
│ • "\n" not endl                                                  │
│ • reserve() containers                                           │
│ • array > map when values are small                              │
│ • const auto& in loops                                           │
│ • Pragmas for GCC optimization                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## 14. Practice Section

### Level 1 — Quick Concept Questions

1. **Q: What does `ios_base::sync_with_stdio(false)` do?**
   <details><summary>Answer</summary>Disables synchronization between C and C++ I/O streams, making cin/cout much faster.</details>

2. **Q: How does coordinate compression work?**
   <details><summary>Answer</summary>Sort unique values, then replace each value with its index in the sorted array using lower_bound.</details>

3. **Q: What is the sliding window technique?**
   <details><summary>Answer</summary>Maintain a window [l, r] over an array, expanding r and shrinking l to satisfy conditions, processing in O(n).</details>

4. **Q: How do you build prefix sums using STL?**
   <details><summary>Answer</summary>`partial_sum(v.begin(), v.end(), prefix.begin())` from `<numeric>`.</details>

5. **Q: What is `__builtin_popcount(x)`?**
   <details><summary>Answer</summary>Returns the number of set bits (1s) in integer x. O(1) on modern CPUs.</details>

6. **Q: How do you do Dijkstra with `set` vs `priority_queue`?**
   <details><summary>Answer</summary>Set allows "decrease-key" by erasing and reinserting. Priority queue needs lazy deletion.</details>

7. **Q: What is DSU/Union-Find?**
   <details><summary>Answer</summary>Disjoint Set Union — tracks connected components with nearly O(1) amortized find and union operations.</details>

8. **Q: Why use `"\n"` instead of `endl`?**
   <details><summary>Answer</summary>`endl` flushes the output buffer, which is very slow. `"\n"` just adds a newline.</details>

9. **Q: What is binary search on answer?**
   <details><summary>Answer</summary>When the answer is monotonic (e.g., "minimum X such that f(X) is true"), binary search the answer space.</details>

10. **Q: How do you enumerate all subsets of a bitmask?**
    <details><summary>Answer</summary>`for (int sub = mask; sub > 0; sub = (sub - 1) & mask)` iterates over all non-empty subsets.</details>

---

### Level 2 — MCQs

**1. `partial_sum` computes:**
- A) Running maximum
- B) Prefix sums or prefix operations ✅
- C) Suffix sums
- D) Frequency counts

**2. `__builtin_clz(8)` returns (on 32-bit):**
- A) 3
- B) 28 ✅ (8 = 0000...1000, 28 leading zeros)
- C) 4
- D) 0

**3. For sliding window maximum, the optimal data structure is:**
- A) priority_queue
- B) set
- C) monotonic deque ✅
- D) stack

**4. Time complexity of DSU with path compression and union by rank:**
- A) O(log n)
- B) O(n)
- C) O(α(n)) ≈ O(1) ✅ (inverse Ackermann)
- D) O(√n)

**5. Coordinate compression is useful when:**
- A) Values are small but array is large
- B) Values are large but count is small ✅
- C) All values are unique
- D) The array is sorted

**6. `multiset::erase(value)` removes:**
- A) One occurrence
- B) All occurrences ✅
- C) Nothing
- D) Throws exception

**7. Which approach is faster for counting when values ≤ 10^6?**
- A) `unordered_map<int,int>`
- B) `map<int,int>`
- C) `int freq[1000001]` ✅
- D) `set<pair<int,int>>`

**8. Binary search on answer requires the function to be:**
- A) Linear
- B) Quadratic
- C) Monotonic ✅
- D) Continuous

**9. Kahn's algorithm produces:**
- A) Shortest path
- B) Minimum spanning tree
- C) Topological order ✅
- D) Strongly connected components

**10. `#pragma GCC optimize("O2")` should be placed:**
- A) Inside main()
- B) Before all includes ✅
- C) After main()
- D) Only in debug mode

---

### Level 3 — Tricky Interview MCQs

**1. Total time for enumerating all subsets of all n-bit masks is:**
- A) O(2^n)
- B) O(4^n)
- C) O(3^n) ✅
- D) O(n × 2^n)

**2. Why is set-based Dijkstra sometimes preferred over priority_queue?**
- A) Set is faster
- B) Set supports decrease-key via erase+insert ✅
- C) Priority queue can't handle negative weights
- D) Set uses less memory

**3. Meet in the Middle reduces 2^n to:**
- A) 2^(n/2) × log(2^(n/2)) ≈ n × 2^(n/2) ✅
- B) n^2
- C) n log n
- D) 2^(n-1)

**4. `bitset<N>` AND operation is:**
- A) O(N)
- B) O(N/64) ✅ (processes 64 bits at a time)
- C) O(1)
- D) O(N log N)

**5. Using `reserve` on `unordered_map` primarily helps by:**
- A) Reducing collisions
- B) Reducing rehashing overhead ✅
- C) Sorting elements
- D) Reducing memory usage

---

### Level 4 — True / False

| #   | Statement                                             | Answer                                 |
| --- | ----------------------------------------------------- | -------------------------------------- |
| 1   | `cin.tie(nullptr)` unties cin from cout               | **True**                               |
| 2   | `endl` is equivalent to `"\n"` in speed               | **False** (endl flushes)               |
| 3   | `__builtin_popcount` works on long long               | **False** (use `__builtin_popcountll`) |
| 4   | Coordinate compression is O(n log n)                  | **True**                               |
| 5   | DSU find with path compression is O(log n)            | **False** (O(α(n)) ≈ O(1))             |
| 6   | `bitset` is slower than manual bit operations         | **False** (often faster due to SIMD)   |
| 7   | `partial_sum` is in `<numeric>`                       | **True**                               |
| 8   | Difference array allows O(1) range updates            | **True**                               |
| 9   | `multiset` allows duplicate elements                  | **True**                               |
| 10  | Binary search on answer always replaces linear search | **False** (needs monotonic condition)  |

---

### Level 5 — Coding Practice Problems

**Problem 1: Coordinate Compression + BIT**
```
Given n points with coordinates up to 10^9, answer queries:
"How many points have x-coordinate ≤ X?"
Compress coordinates and use a BIT/Fenwick tree.
```

**Problem 2: Sliding Window Median**
```
Given an array and window size k, find median of each window.
Use two multisets (or two heaps).
```

**Problem 3: Two Pointer — Subarray Sum**
```
Find the smallest subarray with sum ≥ target.
Use two pointer with running sum.
```

**Problem 4: All Subset Sums (Meet in the Middle)**
```
Given array of n ≤ 40 elements, count subsets with sum = target.
Split in half and use Meet in the Middle.
```

**Problem 5: DSU with Rollback**
```
Implement DSU that supports undo operations (union rollback).
Use union by rank (no path compression) + stack of operations.
```

---

---

## 15. Extended Examples with Test Cases

### Example 1 — coordinate compression + frequency query

```cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    vector<int> arr = {100, 500, 200, 100, 500, 300, 200};

    // Step 1: Coordinate compression
    vector<int> sorted_unique = arr;
    sort(sorted_unique.begin(), sorted_unique.end());
    sorted_unique.erase(unique(sorted_unique.begin(), sorted_unique.end()),
                        sorted_unique.end());
    // sorted_unique = {100, 200, 300, 500}

    auto compress = [&](int x) {
        return (int)(lower_bound(sorted_unique.begin(), sorted_unique.end(), x)
                     - sorted_unique.begin());
    };

    vector<int> comp;
    for (int x : arr) comp.push_back(compress(x));
    for (int x : comp) cout << x << " ";
    cout << "\n";  // 0 3 1 0 3 2 1

    // Step 2: Frequency array on compressed coords
    vector<int> freq(sorted_unique.size(), 0);
    for (int x : comp) freq[x]++;
    for (int x : freq) cout << x << " ";
    cout << "\n";  // 2 2 1 2

    return 0;
}
```

---

### Example 2 — two-pointer: max subarray of sum ≤ K

```cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    vector<int> arr = {1, 2, 3, 4, 5};
    int K = 7;

    int left = 0, sum = 0, maxLen = 0;
    for (int right = 0; right < (int)arr.size(); right++) {
        sum += arr[right];
        while (sum > K)
            sum -= arr[left++];
        maxLen = max(maxLen, right - left + 1);
    }
    cout << "Max length with sum <= " << K << ": " << maxLen << "\n";
    // Subarrays with sum ≤ 7: {1,2,3} len=3, {3,4} len=2, etc.
    // Max = 3

    return 0;
}
```

---

### Example 3 — sliding window using multiset (sliding window median)

```cpp
#include <bits/stdc++.h>
using namespace std;

double getMedian(multiset<int>& lo, multiset<int>& hi) {
    if (lo.size() == hi.size())
        return (*lo.rbegin() + *hi.begin()) / 2.0;
    return (lo.size() > hi.size()) ? *lo.rbegin() : *hi.begin();
}

void rebalance(multiset<int>& lo, multiset<int>& hi) {
    while (lo.size() > hi.size() + 1) {
        hi.insert(*lo.rbegin());
        lo.erase(lo.find(*lo.rbegin()));
    }
    while (hi.size() > lo.size()) {
        lo.insert(*hi.begin());
        hi.erase(hi.begin());
    }
    // Ensure max(lo) <= min(hi)
    while (!lo.empty() && !hi.empty() && *lo.rbegin() > *hi.begin()) {
        hi.insert(*lo.rbegin());
        lo.erase(lo.find(*lo.rbegin()));
        lo.insert(*hi.begin());
        hi.erase(hi.begin());
    }
}

int main() {
    vector<int> arr = {2, 7, 4, 3, 5, 1, 6};
    int k = 3;

    multiset<int> lo, hi;  // lo: max-heap half, hi: min-heap half

    for (int i = 0; i < (int)arr.size(); i++) {
        // Insert new element
        if (lo.empty() || arr[i] <= *lo.rbegin()) lo.insert(arr[i]);
        else hi.insert(arr[i]);

        // Remove outgoing element (window left side)
        if (i >= k) {
            int out = arr[i - k];
            if (lo.count(out)) lo.erase(lo.find(out));
            else hi.erase(hi.find(out));
        }

        rebalance(lo, hi);

        if (i >= k - 1)
            cout << getMedian(lo, hi) << " ";
    }
    cout << "\n";
    // Input: {2,7,4,3,5,1,6}, k=3
    // Windows: {2,7,4}→4, {7,4,3}→4, {4,3,5}→4, {3,5,1}→3, {5,1,6}→5
    // Output: 4 4 4 3 5

    return 0;
}
```

---

### Example 4 — binary search on answer (minimum capacity)

```cpp
#include <bits/stdc++.h>
using namespace std;

// Ship packages within D days with max capacity = cap
bool canShip(vector<int>& weights, int D, int cap) {
    int days = 1, load = 0;
    for (int w : weights) {
        if (w > cap) return false;
        if (load + w > cap) { days++; load = 0; }
        load += w;
    }
    return days <= D;
}

int main() {
    vector<int> weights = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int D = 5;

    int lo = *max_element(weights.begin(), weights.end());
    int hi = accumulate(weights.begin(), weights.end(), 0);

    while (lo < hi) {
        int mid = lo + (hi - lo) / 2;
        if (canShip(weights, D, mid)) hi = mid;
        else lo = mid + 1;
    }
    cout << "Min capacity: " << lo << "\n";  // 15

    return 0;
}
```

---

### Example 5 — BFS with distance tracking using queue

```cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    // Graph as adjacency list
    int n = 6;
    vector<vector<int>> adj(n);
    adj[0] = {1, 2};
    adj[1] = {0, 3, 4};
    adj[2] = {0, 4};
    adj[3] = {1, 5};
    adj[4] = {1, 2, 5};
    adj[5] = {3, 4};

    int source = 0;
    vector<int> dist(n, -1);
    queue<int> q;
    dist[source] = 0;
    q.push(source);

    while (!q.empty()) {
        int u = q.front(); q.pop();
        for (int v : adj[u]) {
            if (dist[v] == -1) {
                dist[v] = dist[u] + 1;
                q.push(v);
            }
        }
    }

    for (int i = 0; i < n; i++)
        cout << "dist[" << i << "] = " << dist[i] << "\n";
    // 0,1,1,2,2,3

    return 0;
}
```

---

## 16. Tricky MCQs — Expert Level

**Q1. How many times does this print "yes"?**
```cpp
vector<int> v = {3, 1, 4, 1, 5, 9, 2, 6};
sort(v.begin(), v.end());
for (int x : {1, 3, 7}) {
    if (binary_search(v.begin(), v.end(), x))
        cout << "yes\n";
}
```
- A) 1
- B) 2 ✅ (1 and 3 found; 7 not found)
- C) 3
- D) 0

---

**Q2. In Dijkstra's algorithm with `priority_queue`, why add a visited check?**
- A) The PQ doesn't work otherwise
- B) A node might be in the PQ multiple times; skip outdated (higher-cost) entries ✅
- C) Priority queue doesn't support decrease-key
- D) Both B and C ✅

---

**Q3. Time complexity of coordinate compression for n elements with values up to M:**
- A) O(M log M)
- B) O(n log n) ✅
- C) O(n + M)
- D) O(n²)

---

**Q4. What is the output?**
```cpp
vector<int> v = {5, 3, 8, 1, 9, 2, 7, 4, 6};
nth_element(v.begin(), v.begin() + 4, v.end());
cout << v[4];
```
- A) 5 ✅ (the 5th smallest = 5)
- B) 9
- C) 1
- D) Undefined

---

**Q5. Which is the most efficient for frequency counting with values up to 10^6?**
- A) `map<int,int>`
- B) `unordered_map<int,int>`
- C) `int freq[1000001]` ✅ (direct array access — O(1) no hashing)
- D) `multiset<int>`

---

**Q6. Difference array technique allows:**
- A) O(log n) point queries
- B) O(1) range updates and O(n) range reconstruction ✅
- C) O(1) range sum queries
- D) O(log n) range updates

---

**Q7. `PBDS order_of_key(x)` in an ordered_set returns:**
- A) Number of elements ≤ x
- B) Number of elements strictly < x ✅
- C) Position of x (1-indexed)
- D) Undefined if x is not in the set

---

**Q8. To hash `pair<int,int>` in `unordered_map`, you need:**
- A) Nothing — it works by default
- B) A custom hash ✅ (no default hash for `pair`)
- C) Convert to string first
- D) Sort the pair before inserting

---

**Q9. For a problem with n ≤ 5000 and time limit 2s, which complexity is safe?**
- A) O(n³) — 125 × 10⁹ — too slow
- B) O(n² log n) — ~62 × 10⁶ — borderline ✅
- C) O(2^n) — astronomical
- D) O(n²) — 25 × 10⁶ — safe ✅

---

**Q10. `__builtin_popcount(x)` counts:**
- A) Number of bits in x
- B) Number of 1 bits in x ✅
- C) Highest set bit position
- D) Lowest set bit position

---

**Q11. Which is correct for iterating all submasks of a bitmask `mask`?**
- A) `for (int s = mask; s; s--)`
- B) `for (int s = mask; s > 0; s = (s - 1) & mask)` ✅
- C) `for (int s = 0; s <= mask; s++)`
- D) `for (int s = mask; s != 0; s >>= 1)`

> **Why:** `(s-1) & mask` clears the lowest set bit of `s` within `mask`, enumerating all submasks efficiently.

---

**Q12. `ios_base::sync_with_stdio(false); cin.tie(nullptr);` speeds up I/O because:**
- A) Disables error checking
- B) Unsync unties cin from cout (no forced flush before cin reads) and disables C stdio sync ✅
- C) Enables buffering for all streams
- D) Replaces stdin with a faster implementation

---

> **Previous:** [09_STL_Advanced_Topics.md](09_STL_Advanced_Topics.md)  
> **Back to Index:** [README.md](README.md)
