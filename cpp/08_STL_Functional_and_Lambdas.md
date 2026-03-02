# 📘 Chapter 8: Functors, Lambdas & std::function

> **From function pointers to modern lambdas — callable objects are the engine of generic programming.**

---

## Table of Contents

- [1. Function Objects (Functors)](#1-function-objects-functors)
- [2. Standard Library Functors](#2-standard-library-functors)
- [3. Lambda Expressions](#3-lambda-expressions)
- [4. Lambda Capture](#4-lambda-capture)
- [5. std::function](#5-stdfunction)
- [6. std::bind](#6-stdbind)
- [7. Predicates and Comparators](#7-predicates-and-comparators)
- [8. Common Mistakes](#8-common-mistakes)
- [9. Interview Tips](#9-interview-tips)
- [10. CP Tricks](#10-cp-tricks)
- [11. Edge Cases](#11-edge-cases)
- [12. Summary](#12-summary)
- [13. Practice Section](#13-practice-section)

---

## 1. Function Objects (Functors)

A **functor** is any object that can be called like a function — achieved by overloading `operator()`.

### 1.1 Basic Functor

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

struct Square {
    int operator()(int x) const {
        return x * x;
    }
};

int main() {
    Square sq;
    std::cout << sq(5);  // 25 — looks like a function call!
    
    // Use with algorithm:
    std::vector<int> v = {1, 2, 3, 4, 5};
    std::vector<int> result(5);
    std::transform(v.begin(), v.end(), result.begin(), Square());
    // result = {1, 4, 9, 16, 25}
    
    return 0;
}
```

### 1.2 Functor with State

**Key advantage over plain functions: functors can carry state!**

```cpp
struct Counter {
    int count = 0;
    
    void operator()(int x) {
        if (x > 0) count++;
    }
};

int main() {
    std::vector<int> v = {-3, 1, -1, 4, 0, 5, -2};
    
    Counter c = std::for_each(v.begin(), v.end(), Counter());
    std::cout << "Positive count: " << c.count;  // 3
    
    return 0;
}
```

### 1.3 Functor as Comparator

```cpp
struct AbsCompare {
    bool operator()(int a, int b) const {
        return std::abs(a) < std::abs(b);
    }
};

int main() {
    std::vector<int> v = {-5, 2, -1, 4, -3};
    
    // Sort by absolute value
    std::sort(v.begin(), v.end(), AbsCompare());
    // v = {-1, 2, -3, 4, -5}
    
    // Use in set
    std::set<int, AbsCompare> s;
    s.insert(5);
    s.insert(-3);
    s.insert(-5);  // Considered equal to 5 by AbsCompare!
    // s.size() == 2
    
    return 0;
}
```

### 1.4 Why Functors Over Function Pointers?

```
┌─────────────────────────┬─────────────────────┬───────────────────┐
│ Feature                 │ Function Pointer    │ Functor           │
├─────────────────────────┼─────────────────────┼───────────────────┤
│ Can hold state          │ ❌ No               │ ✅ Yes            │
│ Inlined by compiler     │ ❌ Usually not      │ ✅ Yes            │
│ Type-safe               │ ✅ Yes              │ ✅ Yes            │
│ Performance             │ Slower (indirect)   │ Faster (inlined)  │
│ Use in templates        │ ✅ Yes              │ ✅ Yes            │
│ Readability             │ Moderate            │ Verbose           │
└─────────────────────────┴─────────────────────┴───────────────────┘
```

---

## 2. Standard Library Functors

`#include <functional>`

### 2.1 Arithmetic Functors

```cpp
#include <functional>

std::plus<int>()(3, 5);         // 8
std::minus<int>()(10, 3);       // 7
std::multiplies<int>()(4, 5);   // 20
std::divides<int>()(10, 3);     // 3
std::modulus<int>()(10, 3);     // 1
std::negate<int>()(5);          // -5

// C++14: Transparent comparators (no need to specify type)
std::plus<>()(3, 5.0);    // Works with mixed types → 8.0
std::less<>()(3, 5);      // true
```

### 2.2 Comparison Functors

```cpp
std::less<int>()(3, 5);         // true  (3 < 5)
std::greater<int>()(3, 5);      // false (3 > 5)
std::less_equal<int>()(3, 3);   // true  (3 <= 3)
std::greater_equal<int>()(5, 3); // true (5 >= 3)
std::equal_to<int>()(3, 3);     // true  (3 == 3)
std::not_equal_to<int>()(3, 5); // true  (3 != 5)

// Common use: sorting descending
std::sort(v.begin(), v.end(), std::greater<int>());

// Min-heap priority_queue
std::priority_queue<int, std::vector<int>, std::greater<int>> min_pq;
```

### 2.3 Logical Functors

```cpp
std::logical_and<bool>()(true, false);  // false
std::logical_or<bool>()(true, false);   // true
std::logical_not<bool>()(true);         // false
```

---

## 3. Lambda Expressions

### 3.1 Syntax

```
┌──────────────────────────────────────────────────────────────────┐
│                    Lambda Expression Anatomy                      │
│                                                                   │
│  [capture](parameters) mutable -> return_type { body }           │
│   │          │           │          │             │               │
│   │          │           │          │             └─ Function body│
│   │          │           │          └─ Explicit return type       │
│   │          │           └─ Allows modifying captured copies     │
│   │          └─ Function parameters                              │
│   └─ Variables from enclosing scope                              │
└──────────────────────────────────────────────────────────────────┘
```

### 3.2 Basic Examples

```cpp
// Simplest lambda
auto greet = []() { std::cout << "Hello!"; };
greet();  // "Hello!"

// With parameters
auto add = [](int a, int b) { return a + b; };
std::cout << add(3, 5);  // 8

// With explicit return type
auto divide = [](int a, int b) -> double { return (double)a / b; };
std::cout << divide(7, 2);  // 3.5

// Inline in algorithm
std::vector<int> v = {3, 1, 4, 1, 5};
std::sort(v.begin(), v.end(), [](int a, int b) { return a > b; });
// v = {5, 4, 3, 1, 1} (descending)
```

### 3.3 Lambda vs Functor — They're the Same!

```cpp
// This lambda:
auto sq = [](int x) { return x * x; };

// Is roughly equivalent to this functor:
struct __lambda_1 {
    int operator()(int x) const { return x * x; }
};
auto sq2 = __lambda_1{};

// The compiler generates a unique unnamed class for each lambda.
// This is why lambdas are often inlined — the compiler sees the body.
```

---

## 4. Lambda Capture

### 4.1 All Capture Modes

```cpp
int x = 10, y = 20;

// ─────────────────────────── No capture ─────────────────────────────
auto f1 = []() { return 42; };                    // Only uses parameters/literals

// ─────────────────────────── Capture by value ───────────────────────
auto f2 = [x]() { return x * 2; };               // x copied (fixed at capture time)
// x = 999; f2() still returns 20!

// ─────────────────────────── Capture by reference ───────────────────
auto f3 = [&x]() { return x * 2; };              // x by reference
// x = 999; f3() returns 1998!

// ─────────────────────────── Capture all by value ───────────────────
auto f4 = [=]() { return x + y; };               // All variables by value

// ─────────────────────────── Capture all by reference ───────────────
auto f5 = [&]() { x = 99; y = 88; };             // All by reference (can modify)

// ─────────────────────────── Mixed capture ──────────────────────────
auto f6 = [x, &y]() { y = x * 2; };             // x by value, y by reference
auto f7 = [=, &y]() { y = x + 1; };             // All by value, except y by ref
auto f8 = [&, x]() { y = x + 1; };              // All by ref, except x by value
```

### 4.2 Capture Visualized

```
int x = 10;
auto by_val = [x]() { return x; };  // x is COPIED
x = 999;
by_val();  // Returns 10 (the copy from capture time)

auto by_ref = [&x]() { return x; }; // x is REFERENCED
x = 999;
by_ref();  // Returns 999 (sees current x)
```

### 4.3 Mutable Lambdas

By default, captured-by-value variables are `const` inside the lambda:

```cpp
int x = 10;

// ❌ Won't compile! x is const inside lambda
// auto f = [x]() { x++; return x; };

// ✅ Use mutable to allow modification of the copy
auto f = [x]() mutable { x++; return x; };
f();  // Returns 11
f();  // Returns 12 (state persists across calls!)
// But original x is still 10!
```

### 4.4 Init Capture (C++14)

```cpp
// Move-capture (can't do this with [x] or [&x])
auto ptr = std::make_unique<int>(42);
auto f = [p = std::move(ptr)]() { return *p; };
// ptr is now nullptr, ownership moved to lambda

// Rename capture
int data = 100;
auto f2 = [val = data * 2]() { return val; };
// val is 200 (computed at capture time)

// Capture expression
auto f3 = [s = std::string("hello")]() { return s.size(); };
```

### 4.5 Generic Lambdas (C++14)

```cpp
// auto parameters → template-like behavior
auto add = [](auto a, auto b) { return a + b; };

add(3, 5);          // int, returns 8
add(3.0, 5.0);      // double, returns 8.0
add("Hello"s, " World"s);  // string, returns "Hello World"

// Equivalent to a template functor:
// struct Add {
//     template<typename T, typename U>
//     auto operator()(T a, U b) const { return a + b; }
// };
```

### 4.6 Immediately Invoked Lambda (IIFE)

```cpp
// Call the lambda right away
const int result = [](int x) { return x * x; }(5);
// result = 25

// Useful for complex initialization of const variables
const auto config = [&]() {
    Config c;
    c.width = parseWidth(args);
    c.height = parseHeight(args);
    c.mode = parseMode(args);
    return c;
}();  // <-- Note the () for immediate invocation
```

---

## 5. std::function

`std::function` is a **type-erased** wrapper for any callable — function pointers, functors, lambdas, bind expressions.

### 5.1 Basic Usage

```cpp
#include <functional>

// Can store any callable that takes (int, int) and returns int
std::function<int(int, int)> func;

// Store a lambda
func = [](int a, int b) { return a + b; };
std::cout << func(3, 5);  // 8

// Store a function pointer
int multiply(int a, int b) { return a * b; }
func = multiply;
std::cout << func(3, 5);  // 15

// Store a functor
struct Divide {
    int operator()(int a, int b) const { return a / b; }
};
func = Divide();
std::cout << func(10, 3);  // 3
```

### 5.2 std::function as Parameter

```cpp
// Accept any callable
void applyToVector(std::vector<int>& v, std::function<int(int)> f) {
    for (auto& x : v) {
        x = f(x);
    }
}

int main() {
    std::vector<int> v = {1, 2, 3, 4, 5};
    
    applyToVector(v, [](int x) { return x * x; });
    // v = {1, 4, 9, 16, 25}
    
    applyToVector(v, [](int x) { return x + 1; });
    // v = {2, 5, 10, 17, 26}
    
    return 0;
}
```

### 5.3 std::function in Data Structures

```cpp
// Callback registry
std::map<std::string, std::function<void()>> commands;

commands["greet"] = []() { std::cout << "Hello!\n"; };
commands["quit"] = []() { std::exit(0); };

// Execute
commands["greet"]();
```

### 5.4 Performance Consideration

```
┌──────────────────────────────────────────────────────────────────┐
│ std::function has OVERHEAD compared to direct lambda/functor:    │
│                                                                   │
│ 1. Type erasure: virtual dispatch (indirect call)                │
│ 2. Heap allocation: for large callables (small buffer optimization│
│    may help for small ones)                                      │
│ 3. Cannot be inlined: the compiler can't see through type erasure│
│                                                                   │
│ RULE: Use templates for performance-critical code.               │
│       Use std::function for runtime polymorphism (callbacks,     │
│       storing in containers, etc.)                               │
└──────────────────────────────────────────────────────────────────┘

// ✅ Faster: template (compile-time, inlineable)
template<typename F>
void applyFast(std::vector<int>& v, F f) {
    for (auto& x : v) x = f(x);
}

// ⚠️ Slower: std::function (runtime, not inlineable)
void applySlow(std::vector<int>& v, std::function<int(int)> f) {
    for (auto& x : v) x = f(x);
}
```

---

## 6. std::bind

`std::bind` creates a new callable by fixing (binding) some arguments.

### 6.1 Basic Usage

```cpp
#include <functional>
using namespace std::placeholders;

int add(int a, int b) { return a + b; }

// Bind first argument to 10
auto add10 = std::bind(add, 10, _1);
add10(5);   // add(10, 5) = 15
add10(20);  // add(10, 20) = 30

// Swap argument order
auto sub = std::bind(add, _2, _1);  // Reverses arguments

// Bind all
auto always42 = std::bind(add, 20, 22);
always42();  // add(20, 22) = 42
```

### 6.2 bind vs Lambda — Lambda Preferred

```cpp
// bind:
auto f1 = std::bind(add, 10, std::placeholders::_1);

// Lambda (preferred, clearer):
auto f2 = [](int x) { return add(10, x); };

// Both do the same thing, but lambda is:
// - More readable
// - Better optimized (inlined)
// - More flexible (can have complex logic)
// - Safer (no placeholder ambiguity)

// In modern C++ (C++11+), prefer lambdas over bind in almost all cases.
```

---

## 7. Predicates and Comparators

### 7.1 Unary Predicates

```cpp
// A unary predicate returns bool for one argument
auto isEven = [](int x) { return x % 2 == 0; };
auto isPositive = [](int x) { return x > 0; };

std::vector<int> v = {1, -2, 3, -4, 5, -6};

// count_if with predicate
int c = std::count_if(v.begin(), v.end(), isEven);     // 3
int p = std::count_if(v.begin(), v.end(), isPositive);  // 3

// find_if
auto it = std::find_if(v.begin(), v.end(), isEven);     // Points to -2

// any_of / all_of / none_of
bool has_even = std::any_of(v.begin(), v.end(), isEven);
```

### 7.2 Binary Predicates / Comparators

```cpp
// A comparator returns bool for two arguments
// Must satisfy strict weak ordering:
// 1. Irreflexivity: comp(a, a) = false
// 2. Asymmetry: comp(a, b) → !comp(b, a)
// 3. Transitivity: comp(a,b) && comp(b,c) → comp(a,c)

auto cmp = [](int a, int b) { return a > b; };  // Descending

std::sort(v.begin(), v.end(), cmp);  // Sort descending

// ⚠️ Common mistake: using <= instead of <
// auto bad_cmp = [](int a, int b) { return a <= b; };
// ❌ Violates irreflexivity: bad_cmp(3, 3) = true!
// This causes UNDEFINED BEHAVIOR in sort!
```

### 7.3 Custom Comparator for Complex Types

```cpp
struct Student {
    std::string name;
    int grade;
    int age;
};

// Sort by grade (desc), then by name (asc), then by age (asc)
auto cmp = [](const Student& a, const Student& b) {
    if (a.grade != b.grade) return a.grade > b.grade;
    if (a.name != b.name) return a.name < b.name;
    return a.age < b.age;
};

std::vector<Student> students = {
    {"Alice", 90, 20}, {"Bob", 90, 19}, {"Charlie", 85, 21}
};
std::sort(students.begin(), students.end(), cmp);
```

### 7.4 Comparator for Containers

```cpp
// For set/map with custom ordering:
auto cmp = [](int a, int b) { return a > b; };
std::set<int, decltype(cmp)> s(cmp);
s.insert(3); s.insert(1); s.insert(4);
// Iteration order: 4, 3, 1 (descending)

// For priority_queue:
auto pq_cmp = [](int a, int b) { return a > b; };  // min-heap
std::priority_queue<int, std::vector<int>, decltype(pq_cmp)> pq(pq_cmp);
```

---

## 8. Common Mistakes

### Mistake 1: Dangling Reference Capture

```cpp
std::function<int()> createLambda() {
    int local = 42;
    // ❌ Captures local by reference — but local dies when function returns!
    return [&local]() { return local; };
}

auto f = createLambda();
f();  // UNDEFINED BEHAVIOR! local is destroyed!

// ✅ Capture by value
std::function<int()> createSafe() {
    int local = 42;
    return [local]() { return local; };  // Copy is safe
}
```

### Mistake 2: Forgetting mutable

```cpp
int counter = 0;
// ❌ Error: can't modify captured-by-value variable
// auto f = [counter]() { counter++; return counter; };

// ✅ Use mutable
auto f = [counter]() mutable { counter++; return counter; };
```

### Mistake 3: Comparator with <= (Not Strict)

```cpp
// ❌ Using <= violates strict weak ordering!
std::sort(v.begin(), v.end(), [](int a, int b) { return a <= b; });
// UNDEFINED BEHAVIOR! May crash, infinite loop, or wrong result.

// ✅ Use <
std::sort(v.begin(), v.end(), [](int a, int b) { return a < b; });
```

### Mistake 4: Storing Lambda in std::function When Not Needed

```cpp
// ❌ Unnecessary overhead
std::function<int(int)> f = [](int x) { return x * x; };
std::transform(v.begin(), v.end(), v.begin(), f);

// ✅ Use lambda directly or template
auto f2 = [](int x) { return x * x; };
std::transform(v.begin(), v.end(), v.begin(), f2);
```

### Mistake 5: Capture `this` Pointer Dangling

```cpp
struct Widget {
    int value = 42;
    
    auto getCallback() {
        // ⚠️ Captures this pointer — if Widget is destroyed, UB!
        return [this]() { return value; };
    }
};

Widget* w = new Widget();
auto cb = w->getCallback();
delete w;
cb();  // ❌ UB! this pointer is dangling!

// ✅ C++17: Capture *this (copy)
auto getCallbackSafe() {
    return [*this]() { return value; };  // Copy of entire Widget
}
```

---

## 9. Interview Tips

**Q1: What is a functor?**
> A functor (function object) is any object of a class that overloads `operator()`. It can be called like a function but can also carry state, unlike plain function pointers.

**Q2: What's the difference between `[=]` and `[&]` capture?**
> `[=]` captures all variables by value (copies them). `[&]` captures all by reference. `[=]` is safer (no dangling references) but may be more expensive (copying large objects). `[&]` is efficient but dangerous if the lambda outlives the captured variables.

**Q3: When would you use `std::function` over a template parameter?**
> Use `std::function` when you need runtime polymorphism (e.g., storing callbacks in a container, having a fixed function signature in an interface). Use templates when you want compile-time polymorphism and maximum performance (inlining).

**Q4: What does `mutable` do on a lambda?**
> By default, a lambda's `operator()` is `const`, so captured-by-value variables cannot be modified. `mutable` removes the `const`, allowing the lambda to modify its captured copies (but NOT the original variables).

**Q5: What is a strict weak ordering and why does sort need it?**
> A comparator `comp(a, b)` must satisfy: irreflexivity (comp(a,a) is false), asymmetry (comp(a,b) implies !comp(b,a)), and transitivity. Without these, `std::sort` has undefined behavior — it may infinite loop, crash, or produce wrong results.

---

## 10. CP Tricks

### Trick 1: Lambda Comparators (Short Syntax)

```cpp
// Sort pairs by second element
sort(v.begin(), v.end(), [](auto& a, auto& b) { return a.second < b.second; });

// Sort by custom priority
sort(events.begin(), events.end(), [](auto& a, auto& b) {
    return a.end < b.end;  // Activity selection: earliest end first
});
```

### Trick 2: Recursive Lambda

```cpp
// A lambda can't directly call itself — use std::function or pass as param

// Method 1: std::function (slower, heap allocation)
std::function<int(int)> fib = [&fib](int n) -> int {
    return n <= 1 ? n : fib(n-1) + fib(n-2);
};

// Method 2: Pass self (faster, no std::function overhead)
auto fib2 = [](auto& self, int n) -> int {
    return n <= 1 ? n : self(self, n-1) + self(self, n-2);
};
fib2(fib2, 10);  // 55

// Method 2 is preferred in CP for performance
```

### Trick 3: Lambda as Custom Hash

```cpp
auto hash = [](pair<int,int> p) -> size_t {
    return hash<long long>()(((long long)p.first << 32) | p.second);
};
unordered_map<pair<int,int>, int, decltype(hash)> mp(0, hash);
```

### Trick 4: Generic Lambda for Debug

```cpp
auto debug = [](auto... args) {
    ((std::cerr << args << " "), ...);
    std::cerr << "\n";
};

debug("x =", 42, "y =", 3.14);
// Output to stderr: x = 42 y = 3.14
```

### Trick 5: IIFE for Complex Const Init

```cpp
const int ans = [&]() {
    int res = 0;
    for (int i = 0; i < n; i++) {
        // complex computation
        res += dp[i];
    }
    return res;
}();
```

---

## 11. Edge Cases

### Empty Lambda

```cpp
auto f = []() {};
f();  // Does nothing, valid
```

### Lambda Capturing Nothing

```cpp
auto f = [](int x) { return x * 2; };
// Can be converted to function pointer if no capture:
int (*fp)(int) = f;  // ✅ Valid! No-capture lambda → function pointer
```

### Lambda with No Parameters

```cpp
auto f = [] { return 42; };  // () is optional if no params
// Same as: auto f = []() { return 42; };
```

### Multiple Calls to Mutable Lambda

```cpp
auto counter = [n = 0]() mutable { return ++n; };
counter();  // 1
counter();  // 2
counter();  // 3
// State persists across calls
```

---

## 12. Summary

```
┌──────────────────────────────────────────────────────────────────┐
│              FUNCTORS & LAMBDAS CHEAT SHEET                       │
├─────────────────┬────────────────────────────────────────────────┤
│ Functor         │ Class with operator(). Can hold state.         │
│ Lambda          │ Anonymous function object. Compiler-generated. │
│ std::function   │ Type-erased wrapper. Runtime polymorphism.     │
│ std::bind       │ Partial application. Prefer lambdas instead.  │
├─────────────────┼────────────────────────────────────────────────┤
│ Capture Modes   │ [x] by value | [&x] by ref | [=] all val     │
│                 │ [&] all ref  | [x, &y] mixed | [=, &y] mixed │
│                 │ [p = std::move(ptr)] init-capture (C++14)     │
├─────────────────┼────────────────────────────────────────────────┤
│ Performance     │ Lambda ≈ Functor > std::function > bind       │
│                 │ Template params > std::function for perf      │
├─────────────────┼────────────────────────────────────────────────┤
│ GOLDEN RULES    │                                                │
│  1. Prefer lambda over bind                                     │
│  2. Use [=] or [val] if lambda might outlive scope              │
│  3. Comparators must use <, NOT <=                              │
│  4. Use templates, not std::function, for hot paths             │
│  5. No-capture lambda converts to function pointer              │
│  6. Use mutable to modify captured copies                       │
└─────────────────┴────────────────────────────────────────────────┘
```

---

## 13. Practice Section

### Level 1 — Quick Concept Questions

1. **Q: What is a functor?**
   <details><summary>Answer</summary>An object of a class that overloads `operator()`, so it can be called like a function.</details>

2. **Q: What does `[&]` capture?**
   <details><summary>Answer</summary>All local variables from the enclosing scope by reference.</details>

3. **Q: Can a lambda modify captured-by-value variables?**
   <details><summary>Answer</summary>Not by default. You must mark the lambda `mutable` to modify copies.</details>

4. **Q: What does `std::greater<int>()` do?**
   <details><summary>Answer</summary>Creates a functor that compares with `>`. Used for descending sort or min-heap.</details>

5. **Q: What overhead does `std::function` have?**
   <details><summary>Answer</summary>Type erasure (virtual dispatch), potential heap allocation, prevents inlining.</details>

6. **Q: Can a lambda with no captures be converted to a function pointer?**
   <details><summary>Answer</summary>Yes. A captureless lambda can implicitly convert to a matching function pointer.</details>

7. **Q: What does `mutable` do on a lambda?**
   <details><summary>Answer</summary>Removes `const` from the generated `operator()`, allowing modification of captured-by-value variables.</details>

8. **Q: Why is `[&local]` dangerous for a returned lambda?**
   <details><summary>Answer</summary>If the lambda outlives the scope of `local`, the reference dangles — undefined behavior.</details>

9. **Q: What is strict weak ordering?**
   <details><summary>Answer</summary>A comparator must be irreflexive (comp(a,a)=false), asymmetric, and transitive. Required by STL sorting and ordered containers.</details>

10. **Q: How do you write a recursive lambda?**
    <details><summary>Answer</summary>Pass `auto& self` as the first parameter, or use `std::function` to name the lambda for self-reference.</details>

---

### Level 2 — MCQs

**1. `std::function<int(int)>` can store:**
- A) Only function pointers
- B) Only lambdas
- C) Any callable matching `int(int)` ✅
- D) Only functors

**2. `[=]` captures variables by:**
- A) Reference
- B) Value ✅
- C) Move
- D) Pointer

**3. A lambda with `mutable` keyword allows:**
- A) Capturing more variables
- B) Modifying captured copies ✅
- C) Returning different types
- D) Thread safety

**4. Which is faster for algorithms?**
- A) `std::function<int(int)>`
- B) Lambda / functor (direct) ✅
- C) `std::bind`
- D) Function pointer

**5. `auto f = [](int x) { return x; };` — what is `f`?**
- A) Function pointer
- B) `std::function<int(int)>`
- C) Unique unnamed type (closure) ✅
- D) Template

**6. `std::sort(v.begin(), v.end(), [](int a, int b) { return a <= b; });` is:**
- A) Correct ascending sort
- B) Correct descending sort
- C) Undefined behavior ✅
- D) Compile error

**7. `std::bind(add, 10, _1)` is equivalent to lambda:**
- A) `[](int x) { return add(x, 10); }`
- B) `[](int x) { return add(10, x); }` ✅
- C) `[10](int x) { return add(10, x); }`
- D) `[](int x) { return 10 + x; }`

**8. Init capture `[p = std::move(ptr)]` was introduced in:**
- A) C++11
- B) C++14 ✅
- C) C++17
- D) C++20

**9. Generic lambdas use which keyword for parameters?**
- A) `template`
- B) `auto` ✅
- C) `any`
- D) `generic`

**10. `std::less<>()` (transparent comparator) was introduced in:**
- A) C++11
- B) C++14 ✅
- C) C++17
- D) C++03

---

### Level 3 — Tricky Interview MCQs

**1. Which capture correctly moves a `unique_ptr` into a lambda?**
- A) `[ptr]`
- B) `[&ptr]`
- C) `[p = std::move(ptr)]` ✅
- D) `[std::move(ptr)]`

**2. How many times is a captured-by-value variable copied?**
- A) Once (at lambda creation) ✅
- B) Once per lambda call
- C) Zero (always referenced)
- D) Depends on the compiler

**3. What happens if you call `std::function<void()>` that is empty (not holding a callable)?**
- A) Returns default value
- B) Does nothing
- C) Throws `std::bad_function_call` ✅
- D) Undefined behavior

**4. A mutable lambda can be passed to `std::transform` because:**
- A) transform takes callable by value and calls it by non-const reference
- B) transform's operator works with any callable ✅
- C) Mutable lambdas are always compatible
- D) Transform creates a copy

**5. `[*this]` capture (C++17) does what?**
- A) Captures `this` pointer by value
- B) Captures a copy of the entire object ✅
- C) Captures all members by reference
- D) Captures `this` pointer by reference

---

### Level 4 — True / False

| #   | Statement                                                  | Answer                                          |
| --- | ---------------------------------------------------------- | ----------------------------------------------- |
| 1   | Lambdas are syntactic sugar for functors                   | **True**                                        |
| 2   | `[=]` is always safe (no dangling)                         | **True** (for local values)                     |
| 3   | `std::function` can be inlined                             | **False** (type erasure prevents it)            |
| 4   | `std::bind` is deprecated in C++17                         | **False** (not deprecated, just less preferred) |
| 5   | A lambda with captures can convert to function pointer     | **False**                                       |
| 6   | Generic lambdas are C++14                                  | **True**                                        |
| 7   | `std::greater<int>()` creates a min-heap in priority_queue | **True**                                        |
| 8   | Comparator `<=` is a valid strict weak ordering            | **False**                                       |
| 9   | `std::function` uses small buffer optimization             | **True** (implementation-dependent)             |
| 10  | `for_each` returns the functor/lambda passed to it         | **True**                                        |

---

### Level 5 — Coding Practice Problems

**Problem 1: Custom Sort with Lambda**
```
Sort strings by length; if equal length, sort alphabetically.
Input: {"banana", "fig", "apple", "kiwi", "date"}
```

**Problem 2: Counter Lambda**
```
Write a lambda that counts how many times it has been called.
Each call returns the current count.
```

**Problem 3: Pipeline of Transforms**
```
Create a function that takes a vector and a list of lambdas,
applies them in sequence. Example: square → add 1 → negate
```

**Problem 4: Memoized Fibonacci**
```
Write a lambda or function object that computes fibonacci
with memoization using captured state.
```

**Problem 5: Event System**
```
Create a simple event system using map<string, vector<function<void()>>>
that supports registering callbacks and firing events.
```

---

---

## 14. Extended Examples with Test Cases

### Example 1 — lambda capture modes — all variants

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    int x = 10, y = 20;

    // Capture by value — snapshot at creation
    auto f1 = [x, y]() { return x + y; };
    x = 99; y = 99;
    cout << f1() << "\n";  // 30  (captured old values)

    // Capture by reference — sees current value
    x = 10; y = 20;
    auto f2 = [&x, &y]() { return x + y; };
    x = 5; y = 5;
    cout << f2() << "\n";  // 10  (sees modified values)

    // [=]: capture all by value
    int a = 1, b = 2, c = 3;
    auto f3 = [=]() { return a + b + c; };
    cout << f3() << "\n";  // 6

    // [&]: capture all by reference
    auto f4 = [&]() { a = 100; };
    f4();
    cout << a << "\n";  // 100

    // Mixed: capture specific vars by different modes
    int counter = 0;
    auto f5 = [&counter, x]() mutable { counter++; x++; return x; };
    f5(); f5(); f5();
    cout << counter << "\n";  // 3 (reference: modified through lambda)
    cout << x << "\n";        // 5 (original x unchanged — captured by value)

    return 0;
}
```

**Expected Output:**
```
30
10
6
100
3
5
```

---

### Example 2 — std::function and type erasure cost

```cpp
#include <iostream>
#include <functional>
#include <chrono>
using namespace std;

int directFunc(int x) { return x * 2; }

int main() {
    // std::function wraps any callable
    function<int(int)> f1 = directFunc;
    function<int(int)> f2 = [](int x){ return x * 2; };

    struct Doubler { int operator()(int x) const { return x * 2; } };
    function<int(int)> f3 = Doubler{};

    cout << f1(5) << " " << f2(5) << " " << f3(5) << "\n";  // 10 10 10

    // Empty function throws std::bad_function_call
    function<int(int)> empty;
    try {
        empty(5);
    } catch (const bad_function_call& e) {
        cout << "Caught: " << e.what() << "\n";  // bad_function_call
    }

    return 0;
}
```

---

### Example 3 — mutable lambda and stateful counter

```cpp
#include <iostream>
using namespace std;

int main() {
    // Lambda with mutable — modifies captured copies
    int count = 0;
    auto inc = [count]() mutable { return ++count; };

    cout << inc() << "\n";  // 1
    cout << inc() << "\n";  // 2
    cout << inc() << "\n";  // 3
    cout << count << "\n";  // 0 — original unchanged (captured by value)

    // Compare: by reference
    int count2 = 0;
    auto inc2 = [&count2]() { return ++count2; };
    inc2(); inc2(); inc2();
    cout << count2 << "\n";  // 3 — original modified

    return 0;
}
```

**Expected Output:**
```
1
2
3
0
3
```

---

### Example 4 — generic lambdas and transform

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

int main() {
    // Generic lambda (C++14) — auto parameters
    auto square = [](auto x) { return x * x; };
    cout << square(5) << "\n";      // 25
    cout << square(3.14) << "\n";   // 9.8596
    cout << square(2LL) << "\n";    // 4

    // Use with transform
    vector<int> vi = {1, 2, 3, 4, 5};
    vector<int> sq(vi.size());
    transform(vi.begin(), vi.end(), sq.begin(), square);
    for (int x : sq) cout << x << " ";
    cout << "\n";  // 1 4 9 16 25

    // Generic lambda for printing any container
    auto printAll = [](const auto& container) {
        for (const auto& x : container) cout << x << " ";
        cout << "\n";
    };
    printAll(vi);
    printAll(vector<string>{"hello", "world"});

    return 0;
}
```

---

### Example 5 — std::bind use cases

```cpp
#include <iostream>
#include <functional>
#include <algorithm>
#include <vector>
using namespace std;

bool isGreaterThan(int threshold, int value) {
    return value > threshold;
}

int main() {
    // bind: fix first argument
    auto gt5 = bind(isGreaterThan, 5, placeholders::_1);
    cout << gt5(3) << "\n";  // 0
    cout << gt5(7) << "\n";  // 1

    vector<int> v = {1, 3, 5, 7, 9, 11};
    int cnt = count_if(v.begin(), v.end(), gt5);
    cout << "count > 5: " << cnt << "\n";  // 3  (7, 9, 11)

    // bind with member function
    auto add = [](int a, int b) { return a + b; };
    auto add10 = bind(add, 10, placeholders::_1);
    cout << add10(5) << "\n";   // 15
    cout << add10(20) << "\n";  // 30

    // In modern C++, prefer lambda over bind:
    auto add10_lambda = [](int x) { return 10 + x; };
    cout << add10_lambda(5) << "\n";  // 15

    return 0;
}
```

---

## 15. Tricky MCQs — Expert Level

**Q1. What is printed?**
```cpp
auto f = [](int x) { return x > 3; };
vector<int> v = {1, 5, 2, 8, 3, 7};
auto it = find_if(v.begin(), v.end(), f);
cout << *it;
```
- A) 1
- B) 5 ✅
- C) 8
- D) 3

> **Why:** `find_if` returns iterator to first element satisfying predicate. First element > 3 is 5.

---

**Q2. A lambda without captures can be converted to:**
- A) `std::function<...>` only
- B) A plain function pointer ✅ (and `std::function`)
- C) A functor only
- D) Nothing — lambdas are non-convertible

---

**Q3. What is the output?**
```cpp
int x = 5;
auto f = [=]() mutable { x = 99; return x; };
cout << f() << " " << x;
```
- A) `99 99`
- B) `99 5` ✅
- C) `5 5`
- D) Undefined behavior

> **Why:** `[=]` captures `x` by value. `mutable` allows modifying the local copy. Original `x` unchanged.

---

**Q4. What happens?**
```cpp
function<int()> f;
cout << (bool)f;
```
- A) Prints 0 ✅ (empty function is falsy)
- B) Prints 1
- C) Throws `bad_function_call`
- D) Compilation error

---

**Q5. Which is an advantage of functors over lambdas?**
- A) More concise syntax
- B) Can be stored in containers more efficiently
- C) Can be named, reused, and partial-specialized with templates ✅
- D) Always faster

---

**Q6. `std::for_each(v.begin(), v.end(), f)` returns:**
- A) void
- B) The last iterator
- C) The function object `f` (possibly modified) ✅
- D) Count of elements processed

---

**Q7. What does `[this]` capture in a lambda inside a class method?**
- A) A copy of the object
- B) A pointer to the current object ✅
- C) All member variables by value
- D) Nothing — `this` cannot be captured

---

**Q8. `std::less<>` (no type argument, C++14) differs from `std::less<int>` because:**
- A) It's slower
- B) It's transparent — can compare different types via heterogeneous lookup ✅
- C) It doesn't support `operator<`
- D) It only works with pointers

---

**Q9. What is the output?**
```cpp
auto add = [](int a, int b) { return a + b; };
auto add5 = bind(add, placeholders::_1, 5);
cout << add5(3);
```
- A) 5
- B) 8 ✅
- C) 3
- D) Undefined

---

**Q10. A `std::function<int(int)>` storing a lambda captures performance cost because:**
- A) Lambdas are always slow
- B) `std::function` uses heap allocation and virtual dispatch (type erasure overhead) ✅
- C) `bind` is always involved
- D) There is no extra cost

---

**Q11. In `[x = std::move(ptr)]` (C++14 init-capture):**
- A) `ptr` is copied into `x`
- B) `ptr` is moved into `x`; `ptr` is left empty ✅
- C) `ptr` and `x` share ownership
- D) Compilation error

---

**Q12. What is printed?**
```cpp
int n = 3;
auto f = [n]() mutable { return n++; };
cout << f() << f() << f() << " " << n;
```
- A) `345 6`
- B) `012 3`
- C) `345 3` ✅
- D) `3 3 3 3`

> **Why:** `f()` modifies its own local copy of `n`, starting from 3→4→5. The original `n=3` unchanged. Output: `3` then `4` then `5` then space then `3`.

---

> **Previous:** [07_STL_Iterators.md](07_STL_Iterators.md)  
> **Next:** [09_STL_Advanced_Topics.md](09_STL_Advanced_Topics.md)
