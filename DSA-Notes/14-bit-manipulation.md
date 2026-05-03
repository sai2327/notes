# 14. Bit Manipulation

## Table of Contents
- [14.1 Introduction](#141-introduction)
- [14.2 Bitwise Operators](#142-bitwise-operators)
- [14.3 Common Bit Tricks](#143-common-bit-tricks)
- [14.4 Problems & Techniques](#144-problems--techniques)
- [14.5 Practice & Assessment](#145-practice--assessment)

---

## 14.1 Introduction

### Why Bit Manipulation?
- **Speed**: Bitwise operations are among the fastest CPU operations.
- **Space**: Represent sets, flags, states compactly.
- **Competitive programming**: Many problems have elegant bit solutions.

### Binary Representation

```
Decimal 13 = Binary 1101
= 1×2³ + 1×2² + 0×2¹ + 1×2⁰
= 8 + 4 + 0 + 1 = 13
```

```cpp
// Print binary representation
void printBinary(int n) {
    for (int i = 31; i >= 0; i--)
        cout << ((n >> i) & 1);
    cout << "\n";
}
```

---

## 14.2 Bitwise Operators

| Operator | Symbol | Description | Example (a=5=101, b=3=011) |
|----------|--------|-------------|---------------------------|
| AND | `&` | 1 if both bits are 1 | `5 & 3 = 1` (001) |
| OR | `\|` | 1 if either bit is 1 | `5 \| 3 = 7` (111) |
| XOR | `^` | 1 if bits are different | `5 ^ 3 = 6` (110) |
| NOT | `~` | Flip all bits | `~5 = -6` |
| Left Shift | `<<` | Shift bits left (×2) | `5 << 1 = 10` (1010) |
| Right Shift | `>>` | Shift bits right (÷2) | `5 >> 1 = 2` (10) |

### Truth Tables

```
AND (&)     OR (|)      XOR (^)
0 & 0 = 0  0 | 0 = 0   0 ^ 0 = 0
0 & 1 = 0  0 | 1 = 1   0 ^ 1 = 1
1 & 0 = 0  1 | 0 = 1   1 ^ 0 = 1
1 & 1 = 1  1 | 1 = 1   1 ^ 1 = 0
```

### Key Properties

```
a ^ 0 = a         (XOR with 0 = identity)
a ^ a = 0         (XOR with self = 0)
a ^ b ^ a = b     (XOR cancels out)
a & 0 = 0         (AND with 0 = 0)
a | 0 = a         (OR with 0 = identity)
a << k = a × 2^k  (left shift = multiply by power of 2)
a >> k = a / 2^k   (right shift = divide by power of 2)
```

---

## 14.3 Common Bit Tricks

### Check Even/Odd — O(1)

```cpp
bool isOdd(int n) { return n & 1; }
bool isEven(int n) { return !(n & 1); }
// Last bit: even numbers end in 0, odd in 1
```

### Check if Power of Two — O(1)

```cpp
bool isPowerOfTwo(int n) {
    return n > 0 && (n & (n - 1)) == 0;
}
// Powers of 2 have exactly one bit set
// 8 = 1000, 7 = 0111 → 8 & 7 = 0
```

### Set, Unset, Toggle, Check Bit

```cpp
// Set ith bit (make it 1)
int setBit(int n, int i) { return n | (1 << i); }

// Unset ith bit (make it 0)
int unsetBit(int n, int i) { return n & ~(1 << i); }

// Toggle ith bit (flip it)
int toggleBit(int n, int i) { return n ^ (1 << i); }

// Check if ith bit is set
bool checkBit(int n, int i) { return (n >> i) & 1; }
```

**Example**: n = 13 (1101)

| Operation | i | Result | Binary |
|-----------|---|--------|--------|
| setBit(13, 1) | 1 | 15 | 1111 |
| unsetBit(13, 2) | 2 | 9 | 1001 |
| toggleBit(13, 0) | 0 | 12 | 1100 |
| checkBit(13, 3) | 3 | true | 1**1**01 |

### Swap Two Numbers Without Temp — O(1)

```cpp
void swapXOR(int &a, int &b) {
    a ^= b;
    b ^= a;
    a ^= b;
}
```

### Count Set Bits (Popcount) — O(log n)

```cpp
int countSetBits(int n) {
    int count = 0;
    while (n) {
        count += n & 1;
        n >>= 1;
    }
    return count;
}

// Brian Kernighan's Algorithm — O(number of set bits)
int countBits(int n) {
    int count = 0;
    while (n) {
        n &= (n - 1);  // removes lowest set bit
        count++;
    }
    return count;
}

// Built-in
int count = __builtin_popcount(n);      // for int
int count = __builtin_popcountll(n);    // for long long
```

### Get Lowest Set Bit

```cpp
int lowestSetBit(int n) { return n & (-n); }
// 12 = 1100, -12 = 0100 (two's complement), 12 & -12 = 0100 = 4
```

### Remove Lowest Set Bit

```cpp
int removeLowest(int n) { return n & (n - 1); }
// 12 = 1100, 11 = 1011, 12 & 11 = 1000 = 8
```

---

## 14.4 Problems & Techniques

### Single Number (XOR)

Find the element that appears once when all others appear twice.

```cpp
int singleNumber(vector<int>& nums) {
    int result = 0;
    for (int n : nums) result ^= n;
    return result;
}
// [4, 1, 2, 1, 2] → 4^1^2^1^2 = 4 (pairs cancel out)
```

### Generate All Subsets Using Bitmask

```cpp
void printSubsets(vector<int>& arr) {
    int n = arr.size();
    for (int mask = 0; mask < (1 << n); mask++) {
        cout << "{ ";
        for (int i = 0; i < n; i++) {
            if (mask & (1 << i))
                cout << arr[i] << " ";
        }
        cout << "}\n";
    }
}
// arr = {1, 2, 3}
// mask=000→{}, 001→{1}, 010→{2}, 011→{1,2}, 100→{3}, 101→{1,3}, 110→{2,3}, 111→{1,2,3}
```

### Two Numbers Appearing Once

```cpp
vector<int> singleNumberIII(vector<int>& nums) {
    int xorAll = 0;
    for (int n : nums) xorAll ^= n;
    
    int diffBit = xorAll & (-xorAll);  // lowest set bit
    int a = 0, b = 0;
    for (int n : nums) {
        if (n & diffBit) a ^= n;
        else b ^= n;
    }
    return {a, b};
}
```

### Reverse Bits

```cpp
uint32_t reverseBits(uint32_t n) {
    uint32_t result = 0;
    for (int i = 0; i < 32; i++) {
        result = (result << 1) | (n & 1);
        n >>= 1;
    }
    return result;
}
```

### Missing Number (XOR approach)

```cpp
int missingNumber(vector<int>& nums) {
    int n = nums.size();
    int result = n;
    for (int i = 0; i < n; i++)
        result ^= i ^ nums[i];
    return result;
}
```

### Bitmask DP Example: Traveling Salesman (Concept)

```cpp
// dp[mask][i] = min cost to visit cities in mask, ending at city i
// mask is a bitmask representing which cities have been visited
int tsp(int n, vector<vector<int>>& dist) {
    int full = (1 << n) - 1;
    vector<vector<int>> dp(1 << n, vector<int>(n, INT_MAX));
    dp[1][0] = 0;  // start at city 0
    
    for (int mask = 1; mask <= full; mask++) {
        for (int u = 0; u < n; u++) {
            if (!(mask & (1 << u)) || dp[mask][u] == INT_MAX) continue;
            for (int v = 0; v < n; v++) {
                if (mask & (1 << v)) continue;
                int newMask = mask | (1 << v);
                dp[newMask][v] = min(dp[newMask][v], dp[mask][u] + dist[u][v]);
            }
        }
    }
    
    int ans = INT_MAX;
    for (int i = 0; i < n; i++)
        ans = min(ans, dp[full][i] + dist[i][0]);
    return ans;
}
```

---

## 14.5 Practice & Assessment

### MCQs

**Q1.** What is `12 & 10` in decimal?
- A) 8
- B) 10
- C) 12
- D) 2

**Answer:** A) 8. 12=1100, 10=1010, AND=1000=8

---

**Q2.** What is `5 ^ 5`?
- A) 10
- B) 5
- C) 0
- D) 25

**Answer:** C) 0. XOR of a number with itself is 0.

---

**Q3.** `n & (n-1)` does what?
- A) Adds 1 to n
- B) Removes the lowest set bit
- C) Sets the lowest bit
- D) Counts set bits

**Answer:** B) Removes the lowest set bit

---

**Q4.** How many subsets can be generated from a set of size n using bitmasks?
- A) n
- B) n²
- C) 2ⁿ
- D) n!

**Answer:** C) 2ⁿ

---

**Q5.** `1 << 10` equals:
- A) 10
- B) 100
- C) 1024
- D) 1000

**Answer:** C) 1024 (2¹⁰)

---

### Output Prediction

**P1.**
```cpp
int x = 6;
cout << (x & 1) << " " << (x >> 1) << " " << (x << 1) << "\n";
```
**Answer:** `0 3 12` (6 is even→0, 6/2=3, 6×2=12)

**P2.**
```cpp
int n = 10;
cout << (n & (n - 1)) << "\n";
```
**Answer:** `8` (10=1010, 9=1001, AND=1000=8)

**P3.**
```cpp
int a = 5, b = 3;
a ^= b; b ^= a; a ^= b;
cout << a << " " << b << "\n";
```
**Answer:** `3 5` (swapped)

---

### Coding Exercises

| # | Problem | Difficulty | Source |
|---|---------|-----------|--------|
| 1 | Single Number | Easy | [LeetCode 136](https://leetcode.com/problems/single-number/) |
| 2 | Number of 1 Bits | Easy | [LeetCode 191](https://leetcode.com/problems/number-of-1-bits/) |
| 3 | Power of Two | Easy | [LeetCode 231](https://leetcode.com/problems/power-of-two/) |
| 4 | Counting Bits | Easy | [LeetCode 338](https://leetcode.com/problems/counting-bits/) |
| 5 | Reverse Bits | Easy | [LeetCode 190](https://leetcode.com/problems/reverse-bits/) |
| 6 | Missing Number | Easy | [LeetCode 268](https://leetcode.com/problems/missing-number/) |
| 7 | Single Number III | Medium | [LeetCode 260](https://leetcode.com/problems/single-number-iii/) |
| 8 | Subsets (bitmask approach) | Medium | [LeetCode 78](https://leetcode.com/problems/subsets/) |
| 9 | Sum of Two Integers (no +) | Medium | [LeetCode 371](https://leetcode.com/problems/sum-of-two-integers/) |
| 10 | Maximum XOR of Two Numbers | Medium | [LeetCode 421](https://leetcode.com/problems/maximum-xor-of-two-numbers-in-an-array/) |

---

### Interview Questions

1. **Explain the bitwise operators in C++.**
2. **How do you check if a number is a power of 2 using bits?**
3. **What does `n & (n-1)` do? Give an application.**
4. **How does XOR help find a single unique element?**
5. **Explain how bitmasks are used to represent subsets.**
6. **How would you count the number of set bits efficiently?**
7. **What is Brian Kernighan's algorithm?**
8. **How do you swap two numbers without a temporary variable?**
9. **What is bitmask DP? Give an example.**
10. **How do you find two unique numbers in an array where all others appear twice?**

---

> **Next Topic**: [15 - Advanced Data Structures](15-advanced-data-structures.md)
