# 📋 Java Exam Preparation – Complete Revision & Practice Guide

> **Purpose:** This file is your one-stop exam prep sheet covering **all key Java topics** with theory revision, tricky MCQs, True/False, coding problems, and interview-level questions. Designed for last-minute revision and deep concept testing.

---

# Table of Contents

1. [Introduction to Java – Operators, Variables, Type Conversion, Command-Line Args](#1-introduction-to-java)
2. [Control Statements](#2-control-statements)
3. [Arrays](#3-arrays)
4. [Strings](#4-strings)
5. [Methods](#5-methods)
6. [Classes and Objects](#6-classes-and-objects)
7. [Constructors](#7-constructors)
8. [Method & Constructor Overloading](#8-method--constructor-overloading)
9. [Keywords – this, static, final, super](#9-keywords--this-static-final-super)
10. [Inheritance and Its Types](#10-inheritance-and-its-types)
11. [Method Overriding](#11-method-overriding)
12. [Abstract Class](#12-abstract-class)
13. [Interface](#13-interface)
14. [Dynamic Method Dispatch](#14-dynamic-method-dispatch)
15. [Collection Framework – All Classes & Methods](#15-collection-framework)
16. [Exception Handling](#16-exception-handling)
17. [JDBC – CRUD Operations](#17-jdbc--crud-operations)
18. [Mega Practice Section – Mixed MCQs & Programs](#18-mega-practice-section)

---

# 1. Introduction to Java

## 1.1 Operators

### Quick Revision

| Category | Operators |
|---|---|
| Arithmetic | `+  -  *  /  %` |
| Relational | `==  !=  >  <  >=  <=` |
| Logical | `&&  \|\|  !` |
| Bitwise | `&  \|  ^  ~  <<  >>  >>>` |
| Assignment | `=  +=  -=  *=  /=  %=` |
| Unary | `++  --  +  -  !` |
| Ternary | `condition ? val1 : val2` |
| instanceof | `obj instanceof ClassName` |

### Tricky Concepts

```java
// Post-increment vs Pre-increment
int a = 5;
int b = a++;  // b = 5, a = 6
int c = ++a;  // a = 7, c = 7

// Short-circuit evaluation
int x = 5;
if (x > 3 || ++x > 5) {
    // ++x is NEVER evaluated because x > 3 is true
    System.out.println(x); // Output: 5
}

// Bitwise vs Logical
// & evaluates BOTH sides, && short-circuits
int y = 0;
if (false & (++y > 0)) {} // y becomes 1
System.out.println(y); // 1

y = 0;
if (false && (++y > 0)) {} // y stays 0 (short-circuit)
System.out.println(y); // 0
```

### Operator Precedence (Important)

```
Highest → Lowest:
()  []  .
++  --  !  ~  (unary)
*  /  %
+  -
<<  >>  >>>
<  <=  >  >=  instanceof
==  !=
&
^
|
&&
||
?:
=  +=  -=  *=  /=
```

---

## 1.2 Types of Variables

### Quick Revision

| Variable Type | Where Declared | Default Value | Scope |
|---|---|---|---|
| Local | Inside method/block | No default (must init) | Within method/block |
| Instance | Inside class, outside method | Yes (0, null, false) | Per object |
| Static (Class) | Inside class with `static` | Yes (0, null, false) | Shared by all objects |

```java
public class VariableDemo {
    int instanceVar = 10;          // Instance variable
    static int staticVar = 20;     // Static variable

    void method() {
        int localVar = 30;         // Local variable
        // localVar MUST be initialized before use
        System.out.println(localVar);
    }
}
```

### Common Mistake

```java
void test() {
    int x;
    System.out.println(x); // ❌ COMPILE ERROR – local variable not initialized
}
```

> **Instance and static variables get default values. Local variables do NOT.**

---

## 1.3 Type Conversion (Casting)

### Widening (Implicit) – Automatic

```
byte → short → int → long → float → double
```

```java
int a = 100;
double b = a;  // Automatic – no data loss
System.out.println(b); // 100.0
```

### Narrowing (Explicit) – Manual Cast Required

```java
double x = 9.78;
int y = (int) x;  // Manual cast – data loss possible
System.out.println(y); // 9 (decimal part lost)
```

### Tricky Cases

```java
byte b = 50;
byte c = 60;
// byte d = b + c;  ❌ ERROR – result is int
int d = b + c;       // ✅ Correct
byte e = (byte)(b + c); // ✅ Explicit cast

char ch = 'A';
int ascii = ch;      // 65 – widening
char ch2 = (char) 66; // 'B' – narrowing
```

---

## 1.4 Command-Line Arguments

```java
public class CmdArgs {
    public static void main(String[] args) {
        // args is a String array
        System.out.println("Number of arguments: " + args.length);
        for (int i = 0; i < args.length; i++) {
            System.out.println("args[" + i + "] = " + args[i]);
        }

        // Convert to int
        if (args.length > 0) {
            int num = Integer.parseInt(args[0]);
            System.out.println("First arg as int: " + num);
        }
    }
}
// Run: java CmdArgs Hello 42
// Output:
// Number of arguments: 2
// args[0] = Hello
// args[1] = 42
// First arg as int: Error if "Hello" is first
```

> **Key Point:** All command-line arguments are **Strings**. Use `Integer.parseInt()`, `Double.parseDouble()` to convert.

---

## Practice Section – Introduction to Java

### Level 1 – Simple Checks (10 Questions)

| # | Question | Answer |
|---|---|---|
| 1 | What is the result of `10 % 3`? | `1` |
| 2 | What is the result of `10 / 3` (int division)? | `3` |
| 3 | What is the result of `10.0 / 3`? | `3.333...` |
| 4 | What does `++a` do? | Increments first, then uses value |
| 5 | What does `a++` do? | Uses value first, then increments |
| 6 | What is the default value of an `int` instance variable? | `0` |
| 7 | What is the default value of a `boolean` instance variable? | `false` |
| 8 | Do local variables get default values? | No |
| 9 | What type are command-line arguments? | `String` |
| 10 | What is `(int) 3.9`? | `3` |

### Level 2 – Concept MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `int a = 5; System.out.println(a++ + ++a);` | 10 | 11 | 12 | 13 | **C. 12** (5 + 7) |
| 2 | `System.out.println(5 > 3 && 8 > 5);` | true | false | error | null | **A. true** |
| 3 | `byte b = 127; b++; System.out.println(b);` | 128 | -128 | error | 0 | **B. -128** (overflow) |
| 4 | Which is NOT a primitive type? | int | String | char | boolean | **B. String** |
| 5 | `float f = 3.14;` compiles? | Yes | No | Warning | Depends | **B. No** (needs 3.14f) |
| 6 | `System.out.println('A' + 1);` | A1 | B | 66 | Error | **C. 66** |
| 7 | `int x = 010;` What is x? | 10 | 8 | 2 | Error | **B. 8** (octal) |
| 8 | `System.out.println(1 + 2 + "3");` | 123 | 33 | 6 | Error | **B. "33"** |
| 9 | `System.out.println("1" + 2 + 3);` | 123 | 6 | 15 | Error | **A. "123"** |
| 10 | Default value of `String` instance var? | "" | null | "null" | Error | **B. null** |

### Level 3 – Deep Understanding MCQs (5 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `int a=5; boolean b = (a=6) > 5;` What is a? | 5 | 6 | Error | true | **B. 6** (assignment in expression) |
| 2 | `short s=5; s = s + 1;` compiles? | Yes | No | Warning | Runtime error | **B. No** (s+1 is int) |
| 3 | `short s=5; s += 1;` compiles? | Yes | No | Warning | Runtime error | **A. Yes** (+= includes implicit cast) |
| 4 | `System.out.println(0.1 + 0.2 == 0.3);` | true | false | error | depends | **B. false** (floating-point precision) |
| 5 | `char c = 'A' + 1;` compiles? | Yes | No | Warning | Runtime error | **A. Yes** (constant expression fits in char) |

### Level 4 – True/False (5 Questions)

| # | Statement | Answer |
|---|---|---|
| 1 | `&&` evaluates both sides always | **False** (short-circuits) |
| 2 | `&` (single) always evaluates both sides | **True** |
| 3 | Local variables are stored on the heap | **False** (stored on stack) |
| 4 | `int` is 32 bits in Java regardless of OS | **True** |
| 5 | `char` in Java is 16-bit Unicode (UTF-16) | **True** |

### Level 5 – Coding (2 Problems)

**Problem 1: Swap two numbers without a third variable**

```java
public class Swap {
    public static void main(String[] args) {
        int a = 10, b = 20;
        System.out.println("Before: a=" + a + " b=" + b);
        a = a + b;  // a = 30
        b = a - b;  // b = 10
        a = a - b;  // a = 20
        System.out.println("After: a=" + a + " b=" + b);
    }
}
// Output:
// Before: a=10 b=20
// After: a=20 b=10
```

**Problem 2: Check if a number is even or odd using ternary operator**

```java
public class EvenOdd {
    public static void main(String[] args) {
        int num = 15;
        String result = (num % 2 == 0) ? "Even" : "Odd";
        System.out.println(num + " is " + result);
    }
}
// Output: 15 is Odd
```

---

# 2. Control Statements

### Quick Revision

```
┌─────────────────────────────────────────┐
│         Control Statements              │
├──────────────┬──────────────────────────┤
│ Selection    │ if, if-else, switch      │
│ Iteration    │ for, while, do-while     │
│ Jump         │ break, continue, return  │
└──────────────┴──────────────────────────┘
```

### Key Programs

```java
// Pattern: Right-angled triangle
for (int i = 1; i <= 5; i++) {
    for (int j = 1; j <= i; j++) {
        System.out.print("* ");
    }
    System.out.println();
}
/*
*
* *
* * *
* * * *
* * * * *
*/
```

```java
// Enhanced for loop (for-each)
int[] nums = {10, 20, 30, 40};
for (int n : nums) {
    System.out.println(n);
}
```

```java
// Switch with String (Java 7+)
String day = "MON";
switch (day) {
    case "MON":
    case "TUE":
    case "WED":
    case "THU":
    case "FRI":
        System.out.println("Weekday");
        break;
    case "SAT":
    case "SUN":
        System.out.println("Weekend");
        break;
    default:
        System.out.println("Invalid");
}
```

### Tricky: break vs continue in nested loops

```java
// Labeled break
outer:
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
        if (j == 1) break outer;  // exits BOTH loops
        System.out.println(i + " " + j);
    }
}
// Output: 0 0
```

---

## Practice Section – Control Statements

### Level 2 – MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | How many times does `for(int i=0; i<5; i++)` loop execute? | 4 | 5 | 6 | Error | **B. 5** |
| 2 | What happens if no `break` in switch case? | Error | Fall-through | Nothing | Compile error | **B. Fall-through** |
| 3 | `for(;;)` is? | Error | Infinite loop | Runs once | Won't compile | **B. Infinite loop** |
| 4 | `while(false) {}` compiles? | Yes | No | Warning | Depends | **B. No** (unreachable) |
| 5 | `do {} while(false);` runs how many times? | 0 | 1 | Infinite | Error | **B. 1** |
| 6 | `switch` supports `long`? | Yes | No | Only with cast | Depends on JDK | **B. No** |
| 7 | `switch` supports `String`? (Java 7+) | Yes | No | Only final | Error | **A. Yes** |
| 8 | `continue` in a `for` loop skips to? | next iteration | end of program | break | beginning | **A. next iteration** |
| 9 | Is `if(x = 5)` valid in Java? | Yes | No | Warning | Depends | **B. No** (assignment returns int, not boolean) |
| 10 | Can `switch` have duplicate case values? | Yes | No | Warning | Only at runtime | **B. No** (compile error) |

### Level 3 – Deep MCQs (5 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `for(int i=0; i<5; i++) { if(i==3) continue; System.out.print(i); }` | 01234 | 0124 | 0123 | 012 | **B. 0124** |
| 2 | `int i=0; while(i++ < 3) {} System.out.println(i);` | 3 | 4 | 2 | Error | **B. 4** |
| 3 | `for(int i=0; i<3; i++) for(int j=0; j<3; j++) if(j==1) break;` How many times is inner body entered? | 3 | 6 | 9 | Error | **B. 6** (each outer iteration: j=0,j=1→break) |
| 4 | `switch(1) { default: System.out.print("D"); case 1: System.out.print("1"); case 2: System.out.print("2"); }` | D | 1 | 12 | D12 | **C. 12** (matches case 1, falls through to 2) |
| 5 | Can you use `float` in switch? | Yes | No | Only with cast | Java 17+ | **B. No** |

### Level 4 – True/False

| # | Statement | Answer |
|---|---|---|
| 1 | `do-while` always executes at least once | **True** |
| 2 | `for-each` can modify array elements in place | **False** (modifies local copy only for primitives) |
| 3 | `break` inside `if` (not in loop/switch) is valid | **False** (compile error) |
| 4 | `switch` supports `byte, short, int, char, String, enum` | **True** |
| 5 | `continue` can be used inside a `switch` | **False** (only in loops) |

### Level 5 – Coding

**Problem 1: Print multiplication table**

```java
public class MultiTable {
    public static void main(String[] args) {
        int n = 7;
        for (int i = 1; i <= 10; i++) {
            System.out.println(n + " x " + i + " = " + (n * i));
        }
    }
}
```

**Problem 2: Find the largest of three numbers**

```java
public class Largest {
    public static void main(String[] args) {
        int a = 25, b = 47, c = 13;
        int max = a;
        if (b > max) max = b;
        if (c > max) max = c;
        System.out.println("Largest: " + max); // 47
    }
}
```

---

# 3. Arrays

### Quick Revision

```java
// Declaration and initialization
int[] arr = new int[5];           // Default values: 0
int[] arr2 = {10, 20, 30, 40};   // Inline initialization
int[][] matrix = new int[3][4];   // 2D array

// Array length
System.out.println(arr.length);   // 5 (NOT a method, it's a field)
```

### Key Programs

```java
// Find max in array
public class MaxInArray {
    public static void main(String[] args) {
        int[] arr = {45, 12, 89, 33, 67};
        int max = arr[0];
        for (int i = 1; i < arr.length; i++) {
            if (arr[i] > max) max = arr[i];
        }
        System.out.println("Max: " + max); // 89
    }
}
```

```java
// Sum of 2D array
public class Sum2D {
    public static void main(String[] args) {
        int[][] mat = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
        int sum = 0;
        for (int i = 0; i < mat.length; i++) {
            for (int j = 0; j < mat[i].length; j++) {
                sum += mat[i][j];
            }
        }
        System.out.println("Sum: " + sum); // 45
    }
}
```

```java
// Reverse an array
public class ReverseArray {
    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 4, 5};
        int left = 0, right = arr.length - 1;
        while (left < right) {
            int temp = arr[left];
            arr[left] = arr[right];
            arr[right] = temp;
            left++;
            right--;
        }
        for (int x : arr)
            System.out.print(x + " "); // 5 4 3 2 1
    }
}
```

---

## Practice Section – Arrays

### Level 2 – MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `int[] a = new int[3]; System.out.println(a[0]);` | Garbage | 0 | Error | null | **B. 0** |
| 2 | `int[] a = {1,2,3}; a.length;` returns? | 3 | 2 | Error | 4 | **A. 3** |
| 3 | Is `length` a method or field for arrays? | Method | Field | Both | Neither | **B. Field** |
| 4 | `int a[] = new int[-1];` | Compiles+runs | Compile error | NegativeArraySizeException | 0 | **C** |
| 5 | `int[][] a = new int[3][];` Is this valid? | Yes | No | Warning | Error | **A. Yes** (jagged array) |
| 6 | Array index starts at? | 0 | 1 | -1 | Depends | **A. 0** |
| 7 | Accessing `arr[arr.length]`? | Last element | Error | 0 | null | **B. ArrayIndexOutOfBoundsException** |
| 8 | `int[] a = {1,2}; int[] b = a; b[0]=99; a[0]?` | 1 | 99 | Error | null | **B. 99** (same reference) |
| 9 | Can array size be changed after creation? | Yes | No | Only ArrayList | With resize() | **B. No** |
| 10 | `String[] s = new String[3]; s[0]?` | "" | null | Error | "null" | **B. null** |

### Level 4 – True/False

| # | Statement | Answer |
|---|---|---|
| 1 | Arrays in Java are objects | **True** |
| 2 | `int a[] = new int[0];` is valid | **True** (zero-length array) |
| 3 | Array elements are stored in stack | **False** (heap) |
| 4 | `int[] a` and `int a[]` are both valid | **True** |
| 5 | Multidimensional arrays must be rectangular | **False** (jagged arrays allowed) |

---

# 4. Strings

### Quick Revision

| Feature | String | StringBuilder | StringBuffer |
|---|---|---|---|
| Mutable? | No (immutable) | Yes | Yes |
| Thread-safe? | Yes (immutable) | No | Yes (synchronized) |
| Performance | Slow for concat | Fast | Slower than StringBuilder |
| Pool? | Yes (String pool) | No | No |

### Important Methods

```java
String s = "Hello World";
s.length();            // 11
s.charAt(0);           // 'H'
s.indexOf("World");    // 6
s.substring(0, 5);     // "Hello"
s.toUpperCase();       // "HELLO WORLD"
s.toLowerCase();       // "hello world"
s.trim();              // removes leading/trailing spaces
s.replace('l', 'x');   // "Hexxo Worxd"
s.contains("World");   // true
s.equals("Hello World");    // true
s.equalsIgnoreCase("hello world"); // true
s.split(" ");          // {"Hello", "World"}
s.toCharArray();       // char array
String.valueOf(123);   // "123"
```

### Tricky Concept: String Pool & ==

```java
String s1 = "Hello";
String s2 = "Hello";
String s3 = new String("Hello");

System.out.println(s1 == s2);      // true  (same pool reference)
System.out.println(s1 == s3);      // false (different objects)
System.out.println(s1.equals(s3)); // true  (same content)
```

```
┌─────────────────────────────────┐
│         String Pool             │
│   ┌───────┐                     │
│   │"Hello"│ ← s1, s2 point here│
│   └───────┘                     │
└─────────────────────────────────┘
         Heap:
   ┌───────────┐
   │new String  │
   │  "Hello"   │ ← s3 points here
   └───────────┘
```

---

## Practice Section – Strings

### Level 2 – MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `"Hello".length()` is method or field? | Method | Field | Both | Neither | **A. Method** (unlike array) |
| 2 | `String s = "abc"; s.concat("def"); System.out.println(s);` | abcdef | abc | error | null | **B. abc** (strings are immutable) |
| 3 | Which creates object in pool? | new String() | literal | Both | Neither | **B. literal** |
| 4 | `"abc" == "abc"` | true | false | error | depends | **A. true** |
| 5 | `new String("abc") == new String("abc")` | true | false | error | depends | **B. false** |
| 6 | `StringBuilder` vs `StringBuffer`? | Same | SB is thread-safe | SBuf is thread-safe | Neither | **C. StringBuffer is synchronized** |
| 7 | `"Hello".charAt(5)` | 'o' | ' ' | Error | null | **C. StringIndexOutOfBoundsException** |
| 8 | `String s = null; s += "hi";` | "hi" | Error | "nullhi" | null | **C. "nullhi"** |
| 9 | `"abc".compareTo("abd")` returns? | 0 | negative | positive | error | **B. negative** (-1) |
| 10 | Can we extend String class? | Yes | No | With abstract | Depends | **B. No** (String is final) |

### Level 3 – Deep MCQs (5 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | How many objects: `String s = new String("test");` (first time) | 1 | 2 | 3 | 0 | **B. 2** (pool + heap) |
| 2 | `String s1="ab"; String s2="a"+"b"; s1==s2?` | true | false | error | depends | **A. true** (compile-time constant) |
| 3 | `String a="a"; String s2=a+"b"; s1==s2?` (s1="ab") | true | false | error | depends | **B. false** (runtime concat) |
| 4 | `"abc".intern() == "abc"` | true | false | error | depends | **A. true** |
| 5 | `String s = "Hello"; s = s + " World";` How many String objects? | 1 | 2 | 3 | 4 | **C. 3** ("Hello", " World", "Hello World") |

---

# 5. Methods

### Quick Revision

```java
// Method syntax
returnType methodName(parameters) {
    // body
    return value; // if not void
}

// Static method – called without object
static int add(int a, int b) { return a + b; }

// Instance method – needs object
void display() { System.out.println("Hello"); }
```

### Method Overloading

```java
class Calculator {
    int add(int a, int b)           { return a + b; }
    double add(double a, double b)  { return a + b; }
    int add(int a, int b, int c)    { return a + b + c; }
}
// Rules: Same name, different parameter list (type, number, or order)
// Return type alone is NOT enough to overload
```

### Recursion

```java
// Factorial using recursion
static int factorial(int n) {
    if (n == 0 || n == 1) return 1; // Base case
    return n * factorial(n - 1);     // Recursive call
}
// factorial(5) → 5 * 4 * 3 * 2 * 1 = 120
```

### Variable Arguments (Varargs)

```java
static int sum(int... nums) {
    int total = 0;
    for (int n : nums) total += n;
    return total;
}
// sum(1, 2, 3) → 6
// sum(1, 2, 3, 4, 5) → 15
// Rule: varargs must be LAST parameter
```

---

## Practice Section – Methods

### Level 2 – MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Can two methods have same name and same parameters but different return type? | Yes | No | Warning | Depends | **B. No** (not overloading) |
| 2 | `static` methods can access instance variables directly? | Yes | No | With cast | Sometimes | **B. No** |
| 3 | Can `main()` be overloaded? | Yes | No | Error | Sometimes | **A. Yes** |
| 4 | Is `main()` mandatory in every class? | Yes | No | Only in public | Depends | **B. No** |
| 5 | What happens if recursion has no base case? | Infinite loop | StackOverflowError | Nothing | Compile error | **B. StackOverflowError** |
| 6 | `void display(int... a, int b)` valid? | Yes | No | Warning | Depends | **B. No** (varargs must be last) |
| 7 | Method with `void` returns? | 0 | null | Nothing | Error | **C. Nothing** |
| 8 | Can we call a method before defining it (in same class)? | Yes | No | Only static | Depends on order | **A. Yes** (Java doesn't care about order) |
| 9 | `void test(int a, long b)` and `void test(long a, int b)` – ambiguous if called with `test(5,5)`? | Yes | No | Compile error | Runtime error | **C. Compile error** (ambiguous) |
| 10 | Can a method return an array? | Yes | No | Only ArrayList | Only Object | **A. Yes** |

---

# 6. Classes and Objects

### Quick Revision

```java
// Class = Blueprint, Object = Instance
class Student {
    String name;       // Instance variable
    int age;

    void display() {   // Instance method
        System.out.println(name + " - " + age);
    }
}

// Creating objects
Student s1 = new Student();
s1.name = "Rahul";
s1.age = 20;
s1.display(); // Rahul - 20
```

### Memory Diagram

```
Stack                    Heap
┌─────────┐        ┌─────────────────┐
│ s1 ──────────────→│ Student Object  │
│ (reference)│      │ name = "Rahul"  │
└─────────┘        │ age = 20        │
                   └─────────────────┘
```

> **Key:** Variables of reference types store addresses, not actual objects.

### Pass by Value in Java

```java
// Java is ALWAYS pass by value
// For objects, the reference (address) is passed by value
void change(Student s) {
    s.name = "Modified";  // Changes original (modifying through reference)
}

void reassign(Student s) {
    s = new Student();    // Does NOT change original (new local reference)
    s.name = "New";
}
```

---

## Practice Section – Classes and Objects

### Level 2 – MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | How many objects? `Student s;` | 1 | 0 | Depends | Error | **B. 0** (just a reference) |
| 2 | `s.equals(s2)` by default compares? | Content | Reference | Hashcode | Type | **B. Reference** (unless overridden) |
| 3 | Can a class have multiple public classes in same file? | Yes | No | With inner class | Depends | **B. No** (one public class per file) |
| 4 | File name must match? | Any class | Public class | Main class | Any | **B. Public class name** |
| 5 | `new Student()` does what? | Allocates memory on stack | Allocates on heap | Both | Neither | **B. Heap** |
| 6 | Java is pass by value or reference? | Value | Reference | Both | Depends | **A. Always pass by value** |
| 7 | Can a class have zero constructors written? | Yes | No | Error | Warning | **A. Yes** (compiler adds default) |
| 8 | `Student s = null; s.display();` | Runs | NullPointerException | Compile error | 0 | **B. NullPointerException** |
| 9 | Can a class extend itself? | Yes | No | With super | Depends | **B. No** |
| 10 | What is the parent of every class? | Main | Object | System | None | **B. Object** |

---

# 7. Constructors

### Quick Revision

| Feature | Constructor | Method |
|---|---|---|
| Name | Same as class name | Any name |
| Return type | NONE (not even void) | Must have one |
| Called | Automatically on `new` | Explicitly |
| Purpose | Initialize object | Perform action |
| Inheritance | NOT inherited | Inherited |

```java
class Student {
    String name;
    int age;

    // Default constructor
    Student() {
        name = "Unknown";
        age = 0;
    }

    // Parameterized constructor
    Student(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // Copy constructor
    Student(Student other) {
        this.name = other.name;
        this.age = other.age;
    }
}
```

### Constructor Chaining

```java
class Demo {
    Demo() {
        this(10); // must be first statement
        System.out.println("Default");
    }
    Demo(int x) {
        System.out.println("Parameterized: " + x);
    }
}
// new Demo() → "Parameterized: 10" then "Default"
```

---

## Practice Section – Constructors

### Level 2 – MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Can constructor be `private`? | Yes | No | Only abstract | Error | **A. Yes** (Singleton pattern) |
| 2 | Can constructor return a value? | Yes | No | Only void | Only int | **B. No** |
| 3 | Is constructor inherited? | Yes | No | Partially | Depends | **B. No** |
| 4 | `this()` must be? | Last statement | First statement | Anywhere | Only in main | **B. First statement** |
| 5 | Can a class have both default and parameterized? | Yes | No | One only | Depends | **A. Yes** |
| 6 | If you write any constructor, does compiler add default? | Yes | No | Sometimes | Warning | **B. No** |
| 7 | Can constructors be `abstract`? | Yes | No | Only with interface | Depends | **B. No** |
| 8 | Can we call constructor explicitly? | Yes with new | Yes without new | No | Depends | **A. Yes, with new** |
| 9 | `this()` and `super()` in same constructor? | Yes | No | With flag | Depends | **B. No** (both must be first line) |
| 10 | Can constructor throw exception? | Yes | No | Only checked | Only runtime | **A. Yes** |

---

# 8. Method & Constructor Overloading

### Quick Revision

> **Overloading = Same name, different parameters (type/number/order) in SAME class**

```java
class Calc {
    // Overloaded methods
    int add(int a, int b) { return a + b; }
    double add(double a, double b) { return a + b; }
    int add(int a, int b, int c) { return a + b + c; }

    // Overloaded constructors
    Calc() { }
    Calc(int x) { }
    Calc(int x, int y) { }
}
```

### Rules

1. **CAN change:** Parameter list (type, number, order)
2. **CANNOT decide overloading:** Return type alone
3. **CAN also change:** Access modifier, return type, exceptions (along with parameters)

### Tricky: Type Promotion in Overloading

```java
class Test {
    void show(int a)    { System.out.println("int"); }
    void show(double a) { System.out.println("double"); }
}
Test t = new Test();
t.show(5);      // "int" – exact match
t.show(5.0);    // "double" – exact match
t.show('A');    // "int" – char promoted to int
t.show(5L);     // "double" – long promoted to double (no long version)
```

```
Type Promotion Order:
byte → short → int → long → float → double
char → int
```

---

## Practice Section – Overloading

### Level 3 – Deep MCQs (5 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `void test(int a, float b)` and `void test(float a, int b)` → `test(5, 5)` | calls first | calls second | ambiguous error | runtime error | **C. Ambiguous compile error** |
| 2 | Can we overload `main()`? | Yes | No | Only once | Error | **A. Yes** (but JVM calls `main(String[])`) |
| 3 | `void foo(Object o)` and `void foo(String s)` → `foo("hi")` | Object version | String version | Error | Both | **B. String** (most specific) |
| 4 | `void foo(int... a)` and `void foo(int a)` → `foo(5)` | varargs | int | Error | Both | **B. int** (exact match preferred over varargs) |
| 5 | Can we overload by only changing `static` keyword? | Yes | No | Error | Warning | **B. No** (parameter list must differ) |

---

# 9. Keywords – this, static, final, super

## `this` Keyword

```java
class Student {
    String name;

    Student(String name) {
        this.name = name;     // Distinguish instance var from parameter
    }

    void show() {
        System.out.println(this.name); // refers to current object
    }

    Student getObj() {
        return this;          // return current object
    }
}
```

**Uses of `this`:**
1. Refer to instance variable when shadowed
2. Call another constructor: `this()`
3. Pass current object as argument
4. Return current object

## `static` Keyword

```java
class Counter {
    static int count = 0;  // Shared among all objects

    Counter() { count++; }

    static void showCount() {
        System.out.println("Count: " + count);
    }
}
// Counter.showCount(); – called without object
```

| Feature | static | non-static |
|---|---|---|
| Belongs to | Class | Object |
| Memory | Once (class loading) | Per object |
| Access | Without object | Needs object |
| Can access | Only static members directly | Both static and non-static |

## `final` Keyword

```java
final int MAX = 100;              // Final variable – constant
final void display() { }          // Final method – can't override
final class Utility { }           // Final class – can't extend
```

| Applied To | Effect |
|---|---|
| Variable | Value cannot be changed (constant) |
| Method | Cannot be overridden |
| Class | Cannot be inherited |

## `super` Keyword

```java
class Animal {
    String type = "Animal";
    Animal() { System.out.println("Animal constructor"); }
    void sound() { System.out.println("Some sound"); }
}

class Dog extends Animal {
    String type = "Dog";

    Dog() {
        super();  // Calls parent constructor (must be first line)
        System.out.println("Dog constructor");
    }

    void sound() {
        super.sound();   // Calls parent method
        System.out.println("Bark");
    }

    void showType() {
        System.out.println(super.type);  // "Animal"
        System.out.println(this.type);   // "Dog"
    }
}
```

---

## Practice Section – Keywords

### Level 2 – MCQs (20 Tricky Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Can `this` be used in static method? | Yes | No | Sometimes | With cast | **B. No** |
| 2 | Can `static` method access instance variable? | Yes | No | Via object | With this | **C. Via object reference** |
| 3 | `static` block runs when? | Object creation | Class loading | Method call | Never | **B. Class loading** |
| 4 | Can `final` variable be initialized later? | Yes (blank final) | No | Only in constructor | Error | **A. Yes** (blank final – in constructor) |
| 5 | Can `final` method be overloaded? | Yes | No | Error | Warning | **A. Yes** (overloaded, NOT overridden) |
| 6 | `this()` and `super()` in same constructor? | Yes | No | One only | Depends | **B. No** |
| 7 | Can `static` method be overridden? | Yes | No | It's hidden | Error | **C. It's hidden, not overridden** |
| 8 | `final static int X;` – valid? | Yes | No | Warning | Error | **A. Yes** (initialized in static block) |
| 9 | Can constructor be `static`? | Yes | No | Abstract only | Final only | **B. No** |
| 10 | `super()` is added by compiler if not written? | Yes | No | Sometimes | Only for Object | **A. Yes** |
| 11 | Can `this` be assigned? `this = new Obj()` | Yes | No | With cast | In constructor | **B. No** (`this` is implicitly final) |
| 12 | Can a `static` inner class access outer instance members? | Yes | No | Via outer object | With this | **C. Via outer object reference** |
| 13 | `final` reference variable – can we change the object's state? | Yes | No | Error | Warning | **A. Yes** (reference is final, not object) |
| 14 | Multiple `static` blocks – allowed? | Yes | No | One only | Error | **A. Yes** (executed in order) |
| 15 | `static` variable of one object changed affects others? | Yes | No | Sometimes | Only final | **A. Yes** (shared) |
| 16 | `super` keyword can be used in static context? | Yes | No | With cast | Sometimes | **B. No** |
| 17 | Can interface have `static` methods? (Java 8+) | Yes | No | Only abstract | Error | **A. Yes** |
| 18 | `final` class can have `final` methods? | Yes | No | Redundant but valid | Error | **C. Redundant but valid** |
| 19 | What is a blank final variable? | null variable | Uninitialized final | Static final | Error | **B. Uninitialized final** (initialized in constructor) |
| 20 | Order of execution: static block, instance block, constructor? | Constructor first | Static → Instance → Constructor | Instance → Static → Constructor | Random | **B. Static → Instance → Constructor** |

---

# 10. Inheritance and Its Types

### Quick Revision

```
Types of Inheritance in Java:
1. Single:      A → B
2. Multilevel:  A → B → C
3. Hierarchical: A → B, A → C
4. ❌ Multiple: NOT supported with classes (use interfaces)
5. ❌ Hybrid: NOT directly (use interfaces)
```

```java
// Single Inheritance
class Animal {
    void eat() { System.out.println("Eating"); }
}
class Dog extends Animal {
    void bark() { System.out.println("Barking"); }
}

// Multilevel Inheritance
class Animal { void eat() { System.out.println("Eating"); } }
class Dog extends Animal { void bark() { System.out.println("Barking"); } }
class Puppy extends Dog { void weep() { System.out.println("Weeping"); } }

// Hierarchical Inheritance
class Shape { void draw() { System.out.println("Drawing"); } }
class Circle extends Shape { }
class Square extends Shape { }
```

### IS-A Relationship

```java
Dog d = new Dog();
System.out.println(d instanceof Dog);    // true
System.out.println(d instanceof Animal); // true
System.out.println(d instanceof Object); // true
```

### What is inherited?

| Member | Inherited? |
|---|---|
| public members | Yes |
| protected members | Yes |
| default (package) | Yes (if same package) |
| private members | No |
| Constructors | No (but called via super) |

---

## Practice Section – Inheritance

### Level 2 – MCQs (20 Tricky Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Java supports multiple inheritance through? | Classes | Interfaces | Both | Neither | **B. Interfaces** |
| 2 | A class can extend how many classes? | 1 | 2 | Unlimited | 0 | **A. 1** |
| 3 | A class can implement how many interfaces? | 1 | 2 | Unlimited | 0 | **C. Unlimited** |
| 4 | `Object` class is parent of? | Only custom classes | All classes | Only String | None | **B. All classes** |
| 5 | Can a child access parent's private method? | Yes | No | With super | With protected | **B. No** |
| 6 | `protected` member accessible in subclass of different package? | Yes | No | Only public | With default | **A. Yes** |
| 7 | Constructor chaining order? | Child first | Parent first | Random | Same time | **B. Parent constructor first** |
| 8 | Can `final` class be extended? | Yes | No | With permission | Sometimes | **B. No** |
| 9 | `class A extends B, C` valid in Java? | Yes | No | With interface | Error | **B. No** |
| 10 | Subclass constructor always calls? | this() | super() | Both | Neither | **B. super()** (if no explicit this()) |
| 11 | Can subclass have more visibility than parent method? | Yes | No | Same only | Error | **A. Yes** (wider, not narrower) |
| 12 | `private` methods are inherited? | Yes | No | Hidden | Depends | **B. No** |
| 13 | What type of inheritance: A→B→C? | Single | Multilevel | Hierarchical | Multiple | **B. Multilevel** |
| 14 | `super.super.method()` valid? | Yes | No | With cast | Java 17+ | **B. No** |
| 15 | Can constructor call both `this()` and `super()`? | Yes | No | In sequence | Depends | **B. No** |
| 16 | When is parent static block executed? | When child object created | Before child static block | Never | After child constructor | **B. Before child static block** |
| 17 | Can an interface extend a class? | Yes | No | Only abstract | Only Object | **B. No** (interface extends interface) |
| 18 | Can an interface extend multiple interfaces? | Yes | No | Only one | Error | **A. Yes** |
| 19 | If parent has parameterized constructor only, child must? | Do nothing | Call super() | Call super(args) | Error | **C. Explicitly call super(args)** |
| 20 | `instanceof` returns what? | int | boolean | String | Object | **B. boolean** |

---

# 11. Method Overriding

### Quick Revision

| Feature | Overloading | Overriding |
|---|---|---|
| Where | Same class | Parent-Child |
| Method name | Same | Same |
| Parameters | Different | Same |
| Return type | Can differ | Same or covariant |
| Binding | Compile-time (static) | Runtime (dynamic) |
| Access | Can be any | Cannot be more restrictive |
| static | Can overload static | Cannot override static (hidden) |

### Rules for Overriding

```java
class Parent {
    protected Number getNumber() throws IOException {
        return 42;
    }
}

class Child extends Parent {
    @Override
    public Integer getNumber() throws FileNotFoundException {
        // ✅ Wider access (public > protected)
        // ✅ Covariant return (Integer extends Number)
        // ✅ Narrower exception (FileNotFoundException extends IOException)
        return 100;
    }
}
```

### Rules Summary:

1. Method name and parameters **must be same**
2. Return type: **same or covariant** (subtype)
3. Access modifier: **same or wider** (cannot reduce)
4. Exception: **same, subtype, or none** (cannot throw broader checked exception)
5. `final` methods **cannot** be overridden
6. `static` methods **cannot** be overridden (hidden)
7. `private` methods **cannot** be overridden (not inherited)

---

## Practice Section – Overriding

### Level 3 – Deep MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Parent: `public void show()` → Child: `protected void show()` | Valid | Compile error | Runtime error | Warning | **B. Compile error** (cannot reduce access) |
| 2 | Parent: `void show()` → Child: `public void show()` | Valid | Error | Warning | Depends | **A. Valid** (wider access OK) |
| 3 | Can `static` method be overridden? | Yes | No (hidden) | Error | Warning | **B. No (hidden)** |
| 4 | `@Override` annotation is? | Required | Optional | Error without | Depends | **B. Optional** (but recommended) |
| 5 | Parent: `Object get()` → Child: `String get()` – valid? | Yes (covariant) | No | Error | Depends | **A. Yes (covariant return)** |
| 6 | Parent: `int get()` → Child: `long get()` – valid? | Yes | No | Covariant | Warning | **B. No** (primitives don't support covariant) |
| 7 | Parent: throws `Exception` → Child: throws `IOException` | Valid | Error | Warning | Depends | **A. Valid** (narrower exception) |
| 8 | Parent: throws `IOException` → Child: throws `Exception` | Valid | Error | Warning | Depends | **B. Error** (broader checked exception) |
| 9 | Can constructor be overridden? | Yes | No | With super | Depends | **B. No** (not inherited) |
| 10 | Runtime polymorphism uses? | Early binding | Late binding | No binding | Static binding | **B. Late binding** |

---

# 12. Abstract Class

### Quick Revision

```java
abstract class Shape {
    String color;

    // Abstract method – no body
    abstract double area();

    // Concrete method – has body
    void display() {
        System.out.println("Shape with color: " + color);
    }

    // Constructor – YES, abstract class CAN have constructor
    Shape(String color) {
        this.color = color;
    }
}

class Circle extends Shape {
    double radius;

    Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }

    @Override
    double area() {
        return Math.PI * radius * radius;
    }
}
```

### Rules

1. Declared with `abstract` keyword
2. **Cannot be instantiated** (`new Shape()` ❌)
3. Can have **abstract and concrete** methods
4. Can have **constructors** (called via super)
5. Can have **static methods**
6. Can have **final methods** (but not abstract + final together)
7. Subclass **must override all abstract methods** (or be abstract itself)
8. Can have **instance variables** (interfaces can't until they have defaults)

---

## Practice Section – Abstract Class

### Level 2 – MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Can abstract class have constructor? | Yes | No | Only default | Error | **A. Yes** |
| 2 | Can abstract class have no abstract methods? | Yes | No | Error | Warning | **A. Yes** |
| 3 | `abstract final class X` valid? | Yes | No | Warning | Depends | **B. No** (contradictory) |
| 4 | `abstract static void m();` valid? | Yes | No | Warning | Depends | **B. No** (static can't be abstract) |
| 5 | Can abstract method have body? | Yes | No | Only for default | Error | **B. No** |
| 6 | Can we create object of abstract class? | Yes | No | With factory | Anonymous only | **B. No** (but anonymous class is possible) |
| 7 | Abstract class can implement interface? | Yes | No | Partially | Error | **A. Yes** |
| 8 | Abstract class extends another abstract class – must override? | Yes all | No | Only if concrete | Error | **B. No** (can stay abstract) |
| 9 | `abstract private void m();` valid? | Yes | No | Protected only | Error | **B. No** (can't override if private) |
| 10 | Can abstract class have `main()` method? | Yes | No | Only if concrete | Error | **A. Yes** (and can be run) |

---

# 13. Interface

### Quick Revision

```java
interface Drawable {
    // Variables are implicitly: public static final
    int VERSION = 1;

    // Methods are implicitly: public abstract (before Java 8)
    void draw();

    // Java 8+ : default method
    default void info() {
        System.out.println("Drawable interface");
    }

    // Java 8+ : static method
    static void version() {
        System.out.println("v" + VERSION);
    }
}

class Circle implements Drawable {
    @Override
    public void draw() {
        System.out.println("Drawing Circle");
    }
}
```

### Interface vs Abstract Class

| Feature | Interface | Abstract Class |
|---|---|---|
| Methods | Abstract + default + static | Abstract + concrete |
| Variables | public static final only | Any type |
| Constructor | No | Yes |
| Multiple inheritance | Yes | No |
| Access modifiers for methods | public only (before Java 9) | Any |
| extends/implements | interface extends interface | class extends class |

### Multiple Inheritance with Interfaces

```java
interface A { default void show() { System.out.println("A"); } }
interface B { default void show() { System.out.println("B"); } }

class C implements A, B {
    @Override
    public void show() {
        A.super.show();  // Resolve conflict explicitly
        B.super.show();
    }
}
```

---

## Practice Section – Interface

### Level 2 – MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Interface variables are? | public static final | private | protected | default | **A. public static final** |
| 2 | Can interface have constructor? | Yes | No | Only default | Error | **B. No** |
| 3 | Can interface extend class? | Yes | No | Only abstract | Error | **B. No** |
| 4 | Can interface extend multiple interfaces? | Yes | No | Only one | Error | **A. Yes** |
| 5 | `default` keyword in interface means? | access modifier | default method with body | package access | error | **B. default method with body** |
| 6 | Can we instantiate an interface? | Yes | No | Anonymous class | Both B&C | **D. No directly, but anonymous class yes** |
| 7 | Interface method without `default/static` is? | concrete | abstract | default | error | **B. abstract** |
| 8 | Class implements interface – must override? | All abstract | Only some | None | Depends | **A. All abstract methods** |
| 9 | Functional interface has? | 0 methods | 1 abstract method | Multiple | None | **B. 1 abstract method** |
| 10 | `@FunctionalInterface` is? | Required | Optional marker | Error without | Mandatory | **B. Optional marker** |

---

# 14. Dynamic Method Dispatch

### Concept

> **Dynamic Method Dispatch** = Runtime Polymorphism. The method to execute is determined at **runtime** based on the **actual object type**, not the reference type.

```java
class Animal {
    void sound() { System.out.println("Some sound"); }
}

class Dog extends Animal {
    @Override
    void sound() { System.out.println("Bark"); }
}

class Cat extends Animal {
    @Override
    void sound() { System.out.println("Meow"); }
}

public class Test {
    public static void main(String[] args) {
        Animal a;       // Reference type: Animal

        a = new Dog();
        a.sound();      // "Bark" – actual object is Dog

        a = new Cat();
        a.sound();      // "Meow" – actual object is Cat

        // a.fetch();   // ❌ Error – reference type Animal has no fetch()
    }
}
```

### Upcasting vs Downcasting

```java
// Upcasting (automatic)
Animal a = new Dog(); // Dog IS-A Animal ✅

// Downcasting (manual, risky)
Dog d = (Dog) a;      // ✅ works because a actually holds Dog

Animal a2 = new Cat();
// Dog d2 = (Dog) a2;  // ❌ ClassCastException at runtime!

// Safe downcasting
if (a2 instanceof Dog) {
    Dog d2 = (Dog) a2;
}
```

### Important Rules

1. **Overridden methods** → resolved at runtime (dynamic dispatch)
2. **Instance variables** → resolved at compile time (reference type)
3. **Static methods** → resolved at compile time (no dispatch)

```java
class Parent {
    int x = 10;
    static void greet() { System.out.println("Parent greet"); }
}
class Child extends Parent {
    int x = 20;
    static void greet() { System.out.println("Child greet"); }
}
Parent p = new Child();
System.out.println(p.x);  // 10 – Parent's x (compile time)
p.greet();                 // "Parent greet" – static (compile time)
```

---

## Practice Section – Dynamic Method Dispatch

### Level 2 – MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `Parent p = new Child(); p.method();` calls? | Parent method | Child method | Error | Depends | **B. Child method** (if overridden) |
| 2 | `Parent p = new Child(); p.x` refers to? | Parent x | Child x | Error | Depends | **A. Parent x** (variables not overridden) |
| 3 | Dynamic dispatch works with? | Variables | Static methods | Instance methods | All | **C. Instance methods only** |
| 4 | `Child c = new Parent();` valid? | Yes | No | With cast | Depends | **B. No** (Parent IS-NOT-A Child) |
| 5 | `Parent p = new Child(); ((Child)p).childMethod()` | Works | Error | Warning | Depends | **A. Works** (downcast) |
| 6 | `instanceof` is checked at? | Compile time | Runtime | Both | Neither | **B. Runtime** |
| 7 | Upcasting is? | Manual | Automatic | Error | Both | **B. Automatic** |
| 8 | Downcasting always safe? | Yes | No | With instanceof | Error | **B. No** (ClassCastException risk) |
| 9 | `Object o = "Hello"; String s = (String)o;` | Works | Error | Warning | Exception | **A. Works** (actual object is String) |
| 10 | Which binding: `overridden method()` | Static | Dynamic | Both | Neither | **B. Dynamic** |

---

# 15. Collection Framework

### Quick Revision Diagram

```
                    Collection (I)
                   /      |       \
                List (I)  Set (I)  Queue (I)
               / | \      / | \       |
     ArrayList  |  \  HashSet | \  PriorityQueue
     LinkedList |   \ LinkedHashSet TreeSet
     Vector     |
     Stack      |

                    Map (I)
                   / |  \  \
           HashMap  |  TreeMap  Hashtable
      LinkedHashMap |
```

### List Implementations

```java
import java.util.*;

// ArrayList – Dynamic array, fast random access
ArrayList<String> list = new ArrayList<>();
list.add("A");
list.add("B");
list.add(1, "C");       // Insert at index 1
list.get(0);             // "A"
list.set(0, "Z");        // Replace
list.remove(0);          // Remove by index
list.remove("B");        // Remove by object
list.size();             // Size
list.contains("C");      // true/false
list.isEmpty();          // true/false
list.indexOf("C");       // First occurrence
list.clear();            // Remove all
Collections.sort(list);  // Sort
```

| List Type | Backed By | Random Access | Insert/Delete | Thread-Safe |
|---|---|---|---|---|
| ArrayList | Dynamic Array | O(1) | O(n) | No |
| LinkedList | Doubly Linked List | O(n) | O(1) | No |
| Vector | Dynamic Array | O(1) | O(n) | Yes (synchronized) |
| Stack | Extends Vector | O(1) top | O(1) top | Yes |

```java
// LinkedList as List and Deque
LinkedList<Integer> ll = new LinkedList<>();
ll.add(1);
ll.addFirst(0);
ll.addLast(2);
ll.getFirst();    // 0
ll.getLast();     // 2
ll.removeFirst();
ll.removeLast();

// Stack
Stack<Integer> stack = new Stack<>();
stack.push(10);
stack.push(20);
stack.peek();     // 20 (doesn't remove)
stack.pop();      // 20 (removes)
stack.isEmpty();
```

### Set Implementations

```java
// HashSet – No duplicates, no order, allows null
HashSet<String> set = new HashSet<>();
set.add("Apple");
set.add("Banana");
set.add("Apple");  // Not added (duplicate)
set.add(null);     // Allowed (one null only)
// Internally uses HashMap

// LinkedHashSet – Insertion order maintained
LinkedHashSet<String> lhs = new LinkedHashSet<>();

// TreeSet – Sorted order, no null
TreeSet<Integer> ts = new TreeSet<>();
ts.add(30);
ts.add(10);
ts.add(20);
System.out.println(ts); // [10, 20, 30]
// ts.add(null);  ❌ NullPointerException
```

| Set Type | Ordering | Null | Internal Structure |
|---|---|---|---|
| HashSet | No order | 1 null allowed | HashMap |
| LinkedHashSet | Insertion order | 1 null allowed | LinkedHashMap |
| TreeSet | Sorted (natural/comparator) | No null | Red-Black Tree |

### Map Implementations

```java
// HashMap – Key-Value pairs, no order
HashMap<String, Integer> map = new HashMap<>();
map.put("Alice", 90);
map.put("Bob", 85);
map.put("Alice", 95);     // Updates value (key exists)
map.get("Alice");          // 95
map.containsKey("Bob");   // true
map.containsValue(85);    // true
map.remove("Bob");
map.size();
map.keySet();              // Set of keys
map.values();              // Collection of values
map.entrySet();            // Set of Map.Entry

// Iterating
for (Map.Entry<String, Integer> entry : map.entrySet()) {
    System.out.println(entry.getKey() + " = " + entry.getValue());
}
```

| Map Type | Ordering | Null Key | Null Value | Thread-Safe |
|---|---|---|---|---|
| HashMap | No order | 1 null key | Multiple null values | No |
| LinkedHashMap | Insertion order | 1 null key | Multiple null values | No |
| TreeMap | Sorted by key | No null key | Multiple null values | No |
| Hashtable | No order | No null key | No null value | Yes (synchronized) |

### HashMap vs Hashtable

| Feature | HashMap | Hashtable |
|---|---|---|
| Null key/value | Allowed | Not allowed |
| Synchronized | No | Yes |
| Performance | Faster | Slower |
| Introduced | Java 1.2 | Java 1.0 (legacy) |

### Iterator

```java
ArrayList<String> list = new ArrayList<>(Arrays.asList("A", "B", "C"));
Iterator<String> it = list.iterator();
while (it.hasNext()) {
    String s = it.next();
    if (s.equals("B")) {
        it.remove(); // Safe removal during iteration
    }
}
// list = [A, C]
```

### Comparable vs Comparator

```java
// Comparable – Natural ordering (implements in the class itself)
class Student implements Comparable<Student> {
    String name;
    int marks;

    Student(String name, int marks) {
        this.name = name;
        this.marks = marks;
    }

    @Override
    public int compareTo(Student other) {
        return this.marks - other.marks; // Ascending by marks
    }
}
Collections.sort(studentList); // Uses compareTo

// Comparator – Custom ordering (separate class or lambda)
Comparator<Student> byName = (s1, s2) -> s1.name.compareTo(s2.name);
Collections.sort(studentList, byName);

// Or using method reference
Collections.sort(studentList, Comparator.comparing(s -> s.name));
```

| Feature | Comparable | Comparator |
|---|---|---|
| Package | `java.lang` | `java.util` |
| Method | `compareTo(T o)` | `compare(T o1, T o2)` |
| Modifies class? | Yes (implements) | No (external) |
| Number of orderings | One (natural) | Multiple |
| Usage | `Collections.sort(list)` | `Collections.sort(list, comp)` |

---

### All Important Methods Summary

| Method | ArrayList | LinkedList | HashSet | HashMap |
|---|---|---|---|---|
| `add(E)` | ✅ | ✅ | ✅ | – |
| `add(index, E)` | ✅ | ✅ | – | – |
| `get(index)` | ✅ | ✅ | – | – |
| `set(index, E)` | ✅ | ✅ | – | – |
| `remove(index)` | ✅ | ✅ | – | – |
| `remove(Object)` | ✅ | ✅ | ✅ | – |
| `put(K, V)` | – | – | – | ✅ |
| `get(K)` | – | – | – | ✅ |
| `contains(E)` | ✅ | ✅ | ✅ | – |
| `containsKey(K)` | – | – | – | ✅ |
| `size()` | ✅ | ✅ | ✅ | ✅ |
| `isEmpty()` | ✅ | ✅ | ✅ | ✅ |
| `clear()` | ✅ | ✅ | ✅ | ✅ |
| `iterator()` | ✅ | ✅ | ✅ | – |
| `keySet()` | – | – | – | ✅ |
| `values()` | – | – | – | ✅ |
| `entrySet()` | – | – | – | ✅ |

---

## Practice Section – Collections

### Level 2 – MCQs (20 Tricky Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | ArrayList internally uses? | Linked List | Array | Tree | Hash | **B. Array** |
| 2 | Default capacity of ArrayList? | 5 | 8 | 10 | 16 | **C. 10** |
| 3 | ArrayList grows by? | Double | 50% | Triple | Fixed | **B. 50%** ((old * 3/2) + 1) |
| 4 | HashSet allows duplicates? | Yes | No | Only null | Depends | **B. No** |
| 5 | TreeSet allows null? | Yes | No | One null | Depends | **B. No** (NullPointerException) |
| 6 | HashMap allows null key? | Yes | No | Multiple | Depends | **A. Yes** (one null key) |
| 7 | Hashtable allows null key? | Yes | No | One null | Depends | **B. No** |
| 8 | Which is synchronized? | ArrayList | HashMap | Vector | TreeSet | **C. Vector** |
| 9 | `Iterator` can traverse? | Forward only | Both directions | Random | None | **A. Forward only** |
| 10 | `ListIterator` can traverse? | Forward | Backward | Both | None | **C. Both directions** |
| 11 | `Comparable` has method? | compare() | compareTo() | equals() | sort() | **B. compareTo()** |
| 12 | `Comparator` has method? | compareTo() | compare() | equals() | sort() | **B. compare()** |
| 13 | `HashMap` internal structure (Java 8+)? | Array | Array + LinkedList + Tree | Only Tree | Only LinkedList | **B. Array + LinkedList + Tree** |
| 14 | Initial capacity of HashMap? | 8 | 10 | 16 | 32 | **C. 16** |
| 15 | Load factor of HashMap? | 0.5 | 0.75 | 1.0 | 0.25 | **B. 0.75** |
| 16 | `ConcurrentModificationException` occurs when? | Modifying during iteration (without iterator.remove) | Always | Never | Compile time | **A** |
| 17 | `LinkedList` implements? | Only List | Only Deque | List + Deque | Only Queue | **C. List + Deque** |
| 18 | `Collections.unmodifiableList()` returns? | Copy | Read-only view | New list | null | **B. Read-only view** |
| 19 | Which preserves insertion order? | HashSet | HashMap | LinkedHashMap | TreeMap | **C. LinkedHashMap** |
| 20 | `Stack` extends? | ArrayList | LinkedList | Vector | Object | **C. Vector** |

---

# 16. Exception Handling

### Quick Revision

```
          Throwable
         /         \
    Exception     Error
    /      \         \
Checked  Unchecked   OutOfMemoryError
(IOException,  (RuntimeException   StackOverflowError
 SQLException)  ├─NullPointerException
                ├─ArrayIndexOutOfBoundsException
                ├─ArithmeticException
                ├─ClassCastException
                └─NumberFormatException)
```

### Syntax & Examples

```java
// try-catch-finally
try {
    int result = 10 / 0;
} catch (ArithmeticException e) {
    System.out.println("Cannot divide by zero: " + e.getMessage());
} catch (Exception e) {
    System.out.println("General exception");
} finally {
    System.out.println("Always executes");
}

// Multi-catch (Java 7+)
try {
    // code
} catch (IOException | SQLException e) {
    System.out.println(e.getMessage());
}
```

### throw vs throws

```java
// throw – used to explicitly throw an exception
void validate(int age) {
    if (age < 18) {
        throw new ArithmeticException("Not eligible");
    }
}

// throws – declares that method may throw exception
void readFile() throws IOException {
    FileReader fr = new FileReader("file.txt");
}
```

### Custom Exception

```java
// User-defined exception
class InvalidAgeException extends Exception {
    InvalidAgeException(String message) {
        super(message);
    }
}

class Test {
    static void validate(int age) throws InvalidAgeException {
        if (age < 18) {
            throw new InvalidAgeException("Age " + age + " is not valid for voting");
        }
        System.out.println("Welcome to vote!");
    }

    public static void main(String[] args) {
        try {
            validate(15);
        } catch (InvalidAgeException e) {
            System.out.println("Caught: " + e.getMessage());
        }
    }
}
// Output: Caught: Age 15 is not valid for voting
```

### Checked vs Unchecked

| Feature | Checked | Unchecked |
|---|---|---|
| Checked at | Compile time | Runtime |
| Must handle? | Yes (try-catch or throws) | No (optional) |
| Parent class | Exception | RuntimeException |
| Examples | IOException, SQLException | NullPointerException, ArithmeticException |

### try-with-resources (Java 7+)

```java
try (BufferedReader br = new BufferedReader(new FileReader("file.txt"))) {
    String line = br.readLine();
    System.out.println(line);
} catch (IOException e) {
    e.printStackTrace();
}
// br is automatically closed – implements AutoCloseable
```

---

## Practice Section – Exception Handling

### Level 2 – MCQs (20 Tricky Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `finally` block always executes? | Yes | No | Only on exception | Depends | **A. Yes** (except System.exit()) |
| 2 | Can `catch` come before `try`? | Yes | No | With finally | Depends | **B. No** |
| 3 | Can `try` exist without `catch`? | Yes (with finally) | No | Error | Warning | **A. Yes** (try-finally is valid) |
| 4 | `throw` is used for? | Declaring | Throwing explicitly | Both | Neither | **B. Throwing explicitly** |
| 5 | `throws` is used for? | Throwing | Declaring | Both | Neither | **B. Declaring** |
| 6 | `ArithmeticException` is? | Checked | Unchecked | Error | Neither | **B. Unchecked** |
| 7 | `IOException` is? | Checked | Unchecked | Error | Neither | **A. Checked** |
| 8 | Parent class of all exceptions? | Exception | Error | Throwable | Object | **C. Throwable** |
| 9 | Can we catch `Error`? | Yes | No | Only Exception | Depends | **A. Yes** (but not recommended) |
| 10 | Multiple catch – order matters? | Yes (specific first) | No | Random | Error | **A. Yes** (child before parent) |
| 11 | `return` in `try` and `finally` – which wins? | try | finally | Error | First one | **B. finally** |
| 12 | Custom exception usually extends? | Error | Exception | Throwable | Object | **B. Exception** |
| 13 | `throw new Exception();` – must handle? | Yes | No | Optional | Depends | **A. Yes** (checked exception) |
| 14 | `throw new RuntimeException();` – must handle? | Yes | No | Optional | Depends | **B. No** (unchecked) |
| 15 | Can `finally` have `return`? | Yes | No | Warning | Error | **A. Yes** (but bad practice) |
| 16 | `catch(Exception e)` catches unchecked too? | Yes | No | Only checked | Depends | **A. Yes** |
| 17 | Can we throw checked exception from main? | Yes with throws | No | Error | Depends | **A. Yes** (`main() throws Exception`) |
| 18 | `finally` runs after `System.exit(0)`? | Yes | No | Sometimes | Depends | **B. No** |
| 19 | Can we rethrow exception? | Yes | No | Only unchecked | Error | **A. Yes** (`throw e;` in catch) |
| 20 | try-with-resources requires? | Closeable | AutoCloseable | Serializable | Any | **B. AutoCloseable** |

### Level 4 – True/False

| # | Statement | Answer |
|---|---|---|
| 1 | `Error` should be caught in normal programs | **False** |
| 2 | `NullPointerException` is a checked exception | **False** (unchecked) |
| 3 | `finally` can be used without `catch` | **True** (try-finally) |
| 4 | An overriding method can throw broader checked exception | **False** |
| 5 | `throw` can throw any object | **False** (only Throwable or subclass) |

### Level 5 – Coding

**Problem 1: Handle multiple exceptions**

```java
public class MultiCatch {
    public static void main(String[] args) {
        try {
            int[] arr = {1, 2, 3};
            System.out.println(arr[5]);  // ArrayIndexOutOfBoundsException
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Array index error: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("General error: " + e.getMessage());
        } finally {
            System.out.println("Cleanup done");
        }
    }
}
// Output:
// Array index error: Index 5 out of bounds for length 3
// Cleanup done
```

**Problem 2: Custom exception for bank withdrawal**

```java
class InsufficientBalanceException extends Exception {
    InsufficientBalanceException(String msg) { super(msg); }
}

class BankAccount {
    double balance;

    BankAccount(double balance) { this.balance = balance; }

    void withdraw(double amount) throws InsufficientBalanceException {
        if (amount > balance) {
            throw new InsufficientBalanceException(
                "Cannot withdraw " + amount + ". Balance: " + balance
            );
        }
        balance -= amount;
        System.out.println("Withdrawn: " + amount + ", Remaining: " + balance);
    }

    public static void main(String[] args) {
        BankAccount acc = new BankAccount(5000);
        try {
            acc.withdraw(3000);  // Success
            acc.withdraw(5000);  // Exception
        } catch (InsufficientBalanceException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
// Output:
// Withdrawn: 3000.0, Remaining: 2000.0
// Error: Cannot withdraw 5000.0. Balance: 2000.0
```

---

# 17. JDBC – CRUD Operations

### Quick Revision

```
JDBC Steps:
1. Load Driver       → Class.forName("com.mysql.cj.jdbc.Driver");
2. Get Connection    → DriverManager.getConnection(url, user, pass);
3. Create Statement  → conn.createStatement();
4. Execute Query     → stmt.executeQuery() / stmt.executeUpdate();
5. Process Result    → ResultSet rs
6. Close Connection  → conn.close();
```

### Complete CRUD Program

```java
import java.sql.*;

public class JDBCDemo {
    static final String URL = "jdbc:mysql://localhost:3306/testdb";
    static final String USER = "root";
    static final String PASS = "password";

    public static void main(String[] args) {
        try {
            // 1. Load Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Establish Connection
            Connection conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("Connected successfully!");

            // CREATE (Insert)
            insertRecord(conn, 1, "Alice", 90);
            insertRecord(conn, 2, "Bob", 85);

            // READ (Select)
            readRecords(conn);

            // UPDATE
            updateRecord(conn, 1, 95);

            // DELETE
            deleteRecord(conn, 2);

            // Read again to verify
            readRecords(conn);

            // 6. Close Connection
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // INSERT using PreparedStatement
    static void insertRecord(Connection conn, int id, String name, int marks)
            throws SQLException {
        String sql = "INSERT INTO students (id, name, marks) VALUES (?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, id);
        pstmt.setString(2, name);
        pstmt.setInt(3, marks);
        int rows = pstmt.executeUpdate();
        System.out.println(rows + " row(s) inserted.");
        pstmt.close();
    }

    // SELECT
    static void readRecords(Connection conn) throws SQLException {
        String sql = "SELECT * FROM students";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        System.out.println("\n--- Student Records ---");
        while (rs.next()) {
            System.out.println("ID: " + rs.getInt("id")
                + ", Name: " + rs.getString("name")
                + ", Marks: " + rs.getInt("marks"));
        }
        rs.close();
        stmt.close();
    }

    // UPDATE
    static void updateRecord(Connection conn, int id, int newMarks)
            throws SQLException {
        String sql = "UPDATE students SET marks = ? WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, newMarks);
        pstmt.setInt(2, id);
        int rows = pstmt.executeUpdate();
        System.out.println(rows + " row(s) updated.");
        pstmt.close();
    }

    // DELETE
    static void deleteRecord(Connection conn, int id) throws SQLException {
        String sql = "DELETE FROM students WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, id);
        int rows = pstmt.executeUpdate();
        System.out.println(rows + " row(s) deleted.");
        pstmt.close();
    }
}
```

### Statement vs PreparedStatement vs CallableStatement

| Feature | Statement | PreparedStatement | CallableStatement |
|---|---|---|---|
| SQL | Plain text | Parameterized (?) | Stored procedures |
| SQL Injection | Vulnerable | Safe | Safe |
| Performance | Slower (parsed each time) | Faster (precompiled) | Fastest for SP |
| Use case | Simple queries | Dynamic queries | Stored procedures |

```java
// PreparedStatement – prevents SQL injection
String sql = "SELECT * FROM students WHERE name = ?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, userInput); // Safe!

// CallableStatement – calling stored procedure
CallableStatement cstmt = conn.prepareCall("{call getStudent(?)}");
cstmt.setInt(1, 1);
ResultSet rs = cstmt.executeQuery();
```

### Transaction Management

```java
try {
    conn.setAutoCommit(false); // Start transaction

    // Multiple operations
    pstmt1.executeUpdate();
    pstmt2.executeUpdate();

    conn.commit(); // All succeed → commit
} catch (SQLException e) {
    conn.rollback(); // Any failure → rollback
} finally {
    conn.setAutoCommit(true);
}
```

---

## Practice Section – JDBC

### Level 2 – MCQs (10 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | JDBC stands for? | Java Data Base Connection | Java Database Connectivity | Java DB Connector | Java Data Binding | **B** |
| 2 | Which class loads the driver? | DriverManager | Class.forName() | Connection | Statement | **B. Class.forName()** |
| 3 | `executeQuery()` is used for? | SELECT | INSERT | UPDATE | DELETE | **A. SELECT** |
| 4 | `executeUpdate()` returns? | ResultSet | int (rows affected) | boolean | void | **B. int** |
| 5 | Which prevents SQL injection? | Statement | PreparedStatement | Both | Neither | **B. PreparedStatement** |
| 6 | Default auto-commit in JDBC? | true | false | depends | null | **A. true** |
| 7 | `ResultSet.next()` returns? | Row data | boolean | int | void | **B. boolean** |
| 8 | Which interface for stored procedures? | Statement | PreparedStatement | CallableStatement | Connection | **C. CallableStatement** |
| 9 | `?` in PreparedStatement is called? | Wildcard | Placeholder | Variable | Marker | **B. Placeholder** |
| 10 | Connection pooling improves? | Security | Performance | Both | Neither | **B. Performance** |

---

# 18. Mega Practice Section – Mixed MCQs & Programs

> This section mixes all topics for comprehensive exam preparation.

## Mixed Tricky MCQs (30 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `String s = "abc"; s.toUpperCase(); System.out.println(s);` | ABC | abc | Abc | Error | **B. abc** (immutable) |
| 2 | `ArrayList<int> list;` compiles? | Yes | No | Warning | Depends | **B. No** (generics need wrapper: Integer) |
| 3 | `int[] a = {}; System.out.println(a.length);` | Error | 0 | null | -1 | **B. 0** |
| 4 | Which can hold duplicates? | HashSet | ArrayList | TreeSet | All | **B. ArrayList** |
| 5 | `HashMap` is ordered? | Yes | No | Insert order | Sorted | **B. No** |
| 6 | `Math.round(2.5)` returns? | 2 | 3 | 2.5 | Error | **B. 3** |
| 7 | `Math.round(-2.5)` returns? | -2 | -3 | -2.5 | Error | **A. -2** |
| 8 | Can interface have `private` methods? (Java 9+) | Yes | No | Only static | Error | **A. Yes** |
| 9 | `abstract void test() { }` valid? | Yes | No | Warning | Depends | **B. No** (abstract can't have body) |
| 10 | `final abstract class X` valid? | Yes | No | Warning | Depends | **B. No** |
| 11 | `System.out.println(1 + 2 + "3" + 4 + 5);` | 12345 | 3345 | 15 | 339 | **B. "3345"** |
| 12 | `Integer i1=127; Integer i2=127; i1==i2?` | true | false | error | depends | **A. true** (cached -128 to 127) |
| 13 | `Integer i1=128; Integer i2=128; i1==i2?` | true | false | error | depends | **B. false** (outside cache) |
| 14 | `null instanceof Object` | true | false | error | exception | **B. false** |
| 15 | Can `enum` extend a class? | Yes | No | Only abstract | Error | **B. No** (implicitly extends Enum) |
| 16 | `"hello" + null` | Error | "hellonull" | NullPointer | "hello" | **B. "hellonull"** |
| 17 | `int x = 5/0;` | 0 | Infinity | ArithmeticException | Error | **C. ArithmeticException** |
| 18 | `double x = 5.0/0;` | 0.0 | Infinity | Exception | Error | **B. Infinity** |
| 19 | `double x = 0.0/0;` | 0.0 | Infinity | NaN | Exception | **C. NaN** |
| 20 | How many objects: `String s1 = "a" + "b" + "c";` | 1 | 3 | 4 | 6 | **A. 1** (compile-time constant → "abc" in pool) |
| 21 | `List<Object> l = new ArrayList<String>();` compiles? | Yes | No | Warning | Depends | **B. No** (generics are invariant) |
| 22 | `HashMap` allows duplicate keys? | Yes | No | Overwrites | Error | **C. No – overwrites old value** |
| 23 | `TreeMap` is sorted by? | Values | Keys | Both | Insertion | **B. Keys** |
| 24 | `Vector` vs `ArrayList`? | Same | Vector is sync | ArrayList is sync | Neither | **B. Vector is synchronized** |
| 25 | `finally` block doesn't run when? | Exception | System.exit() | return | Always runs | **B. System.exit()** |
| 26 | Can static block throw checked exception? | Yes | No | Only runtime | With throws | **B. No** (must handle inside) |
| 27 | What is covariant return type? | Same return | Subtype return | Supertype | Any type | **B. Subtype return in overriding** |
| 28 | `List.of(1,2,3)` returns? | Mutable list | Immutable list | null | Error | **B. Immutable list** (Java 9+) |
| 29 | `var x = 10;` valid in Java? | Yes (10+) | No | Only in scripts | Error | **A. Yes** (Java 10+ local var inference) |
| 30 | `String[] args` in main can be `String... args`? | Yes | No | Error | Warning | **A. Yes** (varargs) |

---

## Important Interview Programs

### Program 1: Check Prime Number

```java
public class PrimeCheck {
    static boolean isPrime(int n) {
        if (n <= 1) return false;
        if (n <= 3) return true;
        if (n % 2 == 0 || n % 3 == 0) return false;
        for (int i = 5; i * i <= n; i += 6) {
            if (n % i == 0 || n % (i + 2) == 0) return false;
        }
        return true;
    }

    public static void main(String[] args) {
        System.out.println(isPrime(29)); // true
        System.out.println(isPrime(15)); // false
    }
}
```

### Program 2: Check Palindrome (String)

```java
public class Palindrome {
    static boolean isPalindrome(String s) {
        int left = 0, right = s.length() - 1;
        while (left < right) {
            if (s.charAt(left) != s.charAt(right)) return false;
            left++;
            right--;
        }
        return true;
    }

    public static void main(String[] args) {
        System.out.println(isPalindrome("madam"));   // true
        System.out.println(isPalindrome("hello"));   // false
    }
}
```

### Program 3: Palindrome Number

```java
public class PalindromeNumber {
    static boolean isPalindrome(int num) {
        int original = num, reversed = 0;
        while (num > 0) {
            reversed = reversed * 10 + num % 10;
            num /= 10;
        }
        return original == reversed;
    }

    public static void main(String[] args) {
        System.out.println(isPalindrome(121));  // true
        System.out.println(isPalindrome(123));  // false
    }
}
```

### Program 4: Fibonacci Series

```java
public class Fibonacci {
    // Iterative
    static void fibIterative(int n) {
        int a = 0, b = 1;
        System.out.print(a + " " + b);
        for (int i = 2; i < n; i++) {
            int c = a + b;
            System.out.print(" " + c);
            a = b;
            b = c;
        }
        System.out.println();
    }

    // Recursive
    static int fibRecursive(int n) {
        if (n <= 1) return n;
        return fibRecursive(n - 1) + fibRecursive(n - 2);
    }

    public static void main(String[] args) {
        fibIterative(10);
        // 0 1 1 2 3 5 8 13 21 34

        for (int i = 0; i < 10; i++) {
            System.out.print(fibRecursive(i) + " ");
        }
        // 0 1 1 2 3 5 8 13 21 34
    }
}
```

### Program 5: Factorial

```java
public class Factorial {
    // Iterative
    static long factIterative(int n) {
        long result = 1;
        for (int i = 2; i <= n; i++) {
            result *= i;
        }
        return result;
    }

    // Recursive
    static long factRecursive(int n) {
        if (n <= 1) return 1;
        return n * factRecursive(n - 1);
    }

    public static void main(String[] args) {
        System.out.println(factIterative(5));  // 120
        System.out.println(factRecursive(5));  // 120
    }
}
```

### Program 6: Bubble Sort

```java
import java.util.Arrays;

public class BubbleSort {
    static void bubbleSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            boolean swapped = false;
            for (int j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    // Swap
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                    swapped = true;
                }
            }
            if (!swapped) break; // Optimization: already sorted
        }
    }

    public static void main(String[] args) {
        int[] arr = {64, 34, 25, 12, 22, 11, 90};
        bubbleSort(arr);
        System.out.println(Arrays.toString(arr));
        // [11, 12, 22, 25, 34, 64, 90]
    }
}
```

### Program 7: Selection Sort

```java
import java.util.Arrays;

public class SelectionSort {
    static void selectionSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < n; j++) {
                if (arr[j] < arr[minIdx]) minIdx = j;
            }
            // Swap
            int temp = arr[minIdx];
            arr[minIdx] = arr[i];
            arr[i] = temp;
        }
    }

    public static void main(String[] args) {
        int[] arr = {29, 10, 14, 37, 13};
        selectionSort(arr);
        System.out.println(Arrays.toString(arr));
        // [10, 13, 14, 29, 37]
    }
}
```

### Program 8: Insertion Sort

```java
import java.util.Arrays;

public class InsertionSort {
    static void insertionSort(int[] arr) {
        for (int i = 1; i < arr.length; i++) {
            int key = arr[i];
            int j = i - 1;
            while (j >= 0 && arr[j] > key) {
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = key;
        }
    }

    public static void main(String[] args) {
        int[] arr = {12, 11, 13, 5, 6};
        insertionSort(arr);
        System.out.println(Arrays.toString(arr));
        // [5, 6, 11, 12, 13]
    }
}
```

### Program 9: Binary Search

```java
public class BinarySearch {
    static int binarySearch(int[] arr, int target) {
        int left = 0, right = arr.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (arr[mid] == target) return mid;
            else if (arr[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        return -1; // Not found
    }

    public static void main(String[] args) {
        int[] arr = {2, 5, 8, 12, 16, 23, 38, 56, 72};
        System.out.println("Found at index: " + binarySearch(arr, 23)); // 5
        System.out.println("Found at index: " + binarySearch(arr, 10)); // -1
    }
}
```

### Program 10: Linear Search

```java
public class LinearSearch {
    static int linearSearch(int[] arr, int target) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == target) return i;
        }
        return -1;
    }

    public static void main(String[] args) {
        int[] arr = {10, 20, 30, 40, 50};
        System.out.println("Found at: " + linearSearch(arr, 30)); // 2
        System.out.println("Found at: " + linearSearch(arr, 60)); // -1
    }
}
```

### Program 11: Reverse a String

```java
public class ReverseString {
    // Method 1: StringBuilder
    static String reverse1(String s) {
        return new StringBuilder(s).reverse().toString();
    }

    // Method 2: Character array
    static String reverse2(String s) {
        char[] chars = s.toCharArray();
        int left = 0, right = chars.length - 1;
        while (left < right) {
            char temp = chars[left];
            chars[left] = chars[right];
            chars[right] = temp;
            left++;
            right--;
        }
        return new String(chars);
    }

    // Method 3: Recursion
    static String reverse3(String s) {
        if (s.isEmpty()) return s;
        return reverse3(s.substring(1)) + s.charAt(0);
    }

    public static void main(String[] args) {
        System.out.println(reverse1("Hello")); // olleH
        System.out.println(reverse2("Hello")); // olleH
        System.out.println(reverse3("Hello")); // olleH
    }
}
```

### Program 12: Count Vowels and Consonants

```java
public class VowelConsonant {
    public static void main(String[] args) {
        String str = "Hello World";
        int vowels = 0, consonants = 0;
        str = str.toLowerCase();

        for (char ch : str.toCharArray()) {
            if (ch >= 'a' && ch <= 'z') {
                if ("aeiou".indexOf(ch) != -1)
                    vowels++;
                else
                    consonants++;
            }
        }
        System.out.println("Vowels: " + vowels);       // 3
        System.out.println("Consonants: " + consonants); // 7
    }
}
```

### Program 13: Find Duplicate Elements in Array

```java
import java.util.*;

public class FindDuplicates {
    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 4, 2, 7, 8, 8, 3};
        HashSet<Integer> seen = new HashSet<>();
        HashSet<Integer> duplicates = new HashSet<>();

        for (int num : arr) {
            if (!seen.add(num)) { // add() returns false if already exists
                duplicates.add(num);
            }
        }
        System.out.println("Duplicates: " + duplicates); // [2, 3, 8]
    }
}
```

### Program 14: Remove Duplicates from ArrayList

```java
import java.util.*;

public class RemoveDuplicates {
    public static void main(String[] args) {
        ArrayList<Integer> list = new ArrayList<>(Arrays.asList(1, 2, 3, 2, 4, 3, 5));

        // Method 1: Using LinkedHashSet (preserves order)
        LinkedHashSet<Integer> set = new LinkedHashSet<>(list);
        ArrayList<Integer> noDups = new ArrayList<>(set);
        System.out.println(noDups); // [1, 2, 3, 4, 5]

        // Method 2: Using Stream (Java 8+)
        List<Integer> noDups2 = list.stream().distinct().collect(java.util.stream.Collectors.toList());
        System.out.println(noDups2); // [1, 2, 3, 4, 5]
    }
}
```

### Program 15: Sort HashMap by Values

```java
import java.util.*;
import java.util.stream.*;

public class SortMapByValue {
    public static void main(String[] args) {
        HashMap<String, Integer> map = new HashMap<>();
        map.put("Alice", 85);
        map.put("Bob", 92);
        map.put("Charlie", 78);
        map.put("Diana", 95);

        // Sort by value ascending
        Map<String, Integer> sorted = map.entrySet()
            .stream()
            .sorted(Map.Entry.comparingByValue())
            .collect(Collectors.toMap(
                Map.Entry::getKey,
                Map.Entry::getValue,
                (e1, e2) -> e1,
                LinkedHashMap::new
            ));

        sorted.forEach((k, v) -> System.out.println(k + " = " + v));
        // Charlie = 78
        // Alice = 85
        // Bob = 92
        // Diana = 95
    }
}
```

### Program 16: Armstrong Number

```java
public class Armstrong {
    static boolean isArmstrong(int num) {
        int original = num, sum = 0;
        int digits = String.valueOf(num).length();
        while (num > 0) {
            int d = num % 10;
            sum += Math.pow(d, digits);
            num /= 10;
        }
        return sum == original;
    }

    public static void main(String[] args) {
        System.out.println(isArmstrong(153));  // true (1³+5³+3³ = 153)
        System.out.println(isArmstrong(370));  // true
        System.out.println(isArmstrong(123));  // false
    }
}
```

### Program 17: Second Largest in Array

```java
public class SecondLargest {
    public static void main(String[] args) {
        int[] arr = {12, 35, 1, 10, 34, 1};
        int first = Integer.MIN_VALUE, second = Integer.MIN_VALUE;

        for (int num : arr) {
            if (num > first) {
                second = first;
                first = num;
            } else if (num > second && num != first) {
                second = num;
            }
        }
        System.out.println("Second largest: " + second); // 34
    }
}
```

### Program 18: Check Anagram

```java
import java.util.Arrays;

public class Anagram {
    static boolean isAnagram(String s1, String s2) {
        if (s1.length() != s2.length()) return false;
        char[] a1 = s1.toLowerCase().toCharArray();
        char[] a2 = s2.toLowerCase().toCharArray();
        Arrays.sort(a1);
        Arrays.sort(a2);
        return Arrays.equals(a1, a2);
    }

    public static void main(String[] args) {
        System.out.println(isAnagram("listen", "silent")); // true
        System.out.println(isAnagram("hello", "world"));   // false
    }
}
```

### Program 19: Count Character Frequency

```java
import java.util.*;

public class CharFrequency {
    public static void main(String[] args) {
        String str = "programming";
        HashMap<Character, Integer> freq = new HashMap<>();

        for (char ch : str.toCharArray()) {
            freq.put(ch, freq.getOrDefault(ch, 0) + 1);
        }

        freq.forEach((k, v) -> System.out.println(k + " = " + v));
        // p=1, r=2, o=1, g=2, a=1, m=2, i=1, n=1
    }
}
```

### Program 20: Matrix Multiplication

```java
public class MatrixMultiply {
    public static void main(String[] args) {
        int[][] a = {{1, 2}, {3, 4}};
        int[][] b = {{5, 6}, {7, 8}};
        int rows = a.length, cols = b[0].length, inner = b.length;
        int[][] result = new int[rows][cols];

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                for (int k = 0; k < inner; k++) {
                    result[i][j] += a[i][k] * b[k][j];
                }
            }
        }

        // Print result
        for (int[] row : result) {
            for (int val : row) {
                System.out.print(val + " ");
            }
            System.out.println();
        }
        // 19 22
        // 43 50
    }
}
```

---

## Output Prediction Questions (15 Questions)

> These are the **most commonly asked** in exams. Predict the output.

### Q1
```java
String s1 = "Java";
String s2 = new String("Java");
System.out.println(s1 == s2);
System.out.println(s1.equals(s2));
```
**Output:**
```
false
true
```

### Q2
```java
int a = 10;
a += a -= a *= a;
System.out.println(a);
```
**Output:** `0`
> Explanation: `a *= a` → a=100, `a -= 100` → a=0, `a += 0` → a=0

### Q3
```java
class A {
    void show() { System.out.println("A"); }
}
class B extends A {
    void show() { System.out.println("B"); }
}
A obj = new B();
obj.show();
```
**Output:** `B` (runtime polymorphism)

### Q4
```java
try {
    System.out.println("try");
    return;
} finally {
    System.out.println("finally");
}
```
**Output:**
```
try
finally
```

### Q5
```java
System.out.println(10 + 20 + "30");
System.out.println("10" + 20 + 30);
```
**Output:**
```
3030
102030
```

### Q6
```java
String s = "Hello";
s.concat(" World");
System.out.println(s);
```
**Output:** `Hello` (String is immutable, concat returns new String)

### Q7
```java
int[] a = {1, 2, 3};
int[] b = a;
b[0] = 99;
System.out.println(a[0]);
```
**Output:** `99` (arrays are reference types)

### Q8
```java
ArrayList<String> list = new ArrayList<>();
list.add("A");
list.add("B");
list.add("C");
list.remove(1);
System.out.println(list);
```
**Output:** `[A, C]` (removes index 1 which is "B")

### Q9
```java
HashSet<Integer> set = new HashSet<>();
set.add(1); set.add(2); set.add(1); set.add(3);
System.out.println(set.size());
```
**Output:** `3` (duplicates not added)

### Q10
```java
HashMap<String, Integer> map = new HashMap<>();
map.put("a", 1);
map.put("b", 2);
map.put("a", 3);
System.out.println(map);
```
**Output:** `{a=3, b=2}` (key "a" value overwritten)

### Q11
```java
class Parent {
    int x = 10;
}
class Child extends Parent {
    int x = 20;
}
Parent p = new Child();
System.out.println(p.x);
```
**Output:** `10` (variables resolved at compile time by reference type)

### Q12
```java
System.out.println('a' + 'b');
System.out.println("" + 'a' + 'b');
```
**Output:**
```
195
ab
```

### Q13
```java
Integer x = null;
int y = x;
```
**Output:** `NullPointerException` (auto-unboxing null)

### Q14
```java
static int count = 0;
static { count++; }
static { count++; }
public static void main(String[] args) {
    System.out.println(count);
}
```
**Output:** `2` (both static blocks execute)

### Q15
```java
abstract class A {
    A() { System.out.println("A constructor"); }
}
class B extends A {
    B() { System.out.println("B constructor"); }
}
new B();
```
**Output:**
```
A constructor
B constructor
```
> Abstract class constructors ARE called during child object creation.

---

## Final Quick Revision Cheat Sheet

### Data Types Size

| Type | Size | Default | Range |
|---|---|---|---|
| byte | 1 byte | 0 | -128 to 127 |
| short | 2 bytes | 0 | -32,768 to 32,767 |
| int | 4 bytes | 0 | ~±2.1 billion |
| long | 8 bytes | 0L | Very large |
| float | 4 bytes | 0.0f | ~7 decimal digits |
| double | 8 bytes | 0.0d | ~15 decimal digits |
| char | 2 bytes | '\u0000' | 0 to 65,535 |
| boolean | ~1 bit | false | true/false |

### Access Modifiers

| Modifier | Class | Package | Subclass (diff pkg) | World |
|---|---|---|---|---|
| public | ✅ | ✅ | ✅ | ✅ |
| protected | ✅ | ✅ | ✅ | ❌ |
| default | ✅ | ✅ | ❌ | ❌ |
| private | ✅ | ❌ | ❌ | ❌ |

### OOP Pillars

| Pillar | Keyword/Mechanism | Purpose |
|---|---|---|
| Encapsulation | private + getters/setters | Data hiding |
| Inheritance | extends/implements | Code reuse |
| Polymorphism | Overloading/Overriding | Many forms |
| Abstraction | abstract/interface | Hide complexity |

### Collection Choice Guide

| Need | Use |
|---|---|
| Ordered + Duplicates + Fast access | ArrayList |
| Ordered + Duplicates + Fast insert/delete | LinkedList |
| No duplicates + No order | HashSet |
| No duplicates + Sorted | TreeSet |
| Key-Value + No order | HashMap |
| Key-Value + Sorted by key | TreeMap |
| Key-Value + Insertion order | LinkedHashMap |
| Thread-safe List | Vector / CopyOnWriteArrayList |
| Thread-safe Map | ConcurrentHashMap |

### Exception Handling Rules

```
1. try must have catch OR finally (or both)
2. catch blocks: specific before general
3. finally always runs (except System.exit())
4. throw = throw an exception object
5. throws = declare method may throw
6. Checked = must handle
7. Unchecked = optional to handle
```

### JDBC Quick Reference

```
1. Class.forName("com.mysql.cj.jdbc.Driver");
2. Connection conn = DriverManager.getConnection(url, user, pass);
3. PreparedStatement pstmt = conn.prepareStatement(sql);
4. pstmt.setXxx(index, value);
5. ResultSet rs = pstmt.executeQuery();  // SELECT
   int rows = pstmt.executeUpdate();     // INSERT/UPDATE/DELETE
6. conn.close();
```

---

> **Tip:** Before the exam, go through all the **Output Prediction Questions** and **Tricky MCQs** — these are the most commonly tested areas. Focus on understanding WHY the answer is what it is, not just memorizing it.

---

# 19. Additional Tricky MCQs – Topic-Wise (New Questions)

---

## 19.1 Operators & Expressions – Extra MCQs (20 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `System.out.println(5 >> 1);` | 10 | 2 | 3 | 1 | **B. 2** (5/2 = 2, right shift by 1) |
| 2 | `System.out.println(5 << 1);` | 2 | 10 | 5 | 3 | **B. 10** (5*2 = 10, left shift by 1) |
| 3 | `System.out.println(-1 >>> 1);` | -1 | 1 | 2147483647 | -2 | **C. 2147483647** (unsigned right shift) |
| 4 | `System.out.println(3 ^ 5);` | 6 | 2 | 15 | 8 | **A. 6** (011 XOR 101 = 110) |
| 5 | `System.out.println(~5);` | -4 | -5 | -6 | 4 | **C. -6** (~5 = -(5+1) = -6) |
| 6 | `System.out.println(7 & 3);` | 7 | 3 | 4 | 1 | **B. 3** (111 & 011 = 011 = 3) |
| 7 | `int a=10; a >>= 1; System.out.println(a);` | 20 | 10 | 5 | 2 | **C. 5** |
| 8 | `boolean b = true ^ true;` | true | false | Error | null | **B. false** (XOR: same=false) |
| 9 | `System.out.println(Integer.MAX_VALUE + 1);` | Error | MAX_VALUE | MIN_VALUE | 0 | **C. MIN_VALUE** (overflow) |
| 10 | `System.out.println(Integer.MIN_VALUE - 1);` | Error | MIN_VALUE | MAX_VALUE | 0 | **C. MAX_VALUE** (underflow) |
| 11 | `int x = 0; x = x++ + x++;` x after? | 0 | 1 | 2 | 3 | **B. 1** (0+1=1; x was 2 after increments but assignment is 1) |
| 12 | `System.out.println(2 * 3 + 4 * 5);` | 46 | 26 | 50 | 100 | **B. 26** (6 + 20) |
| 13 | `System.out.println(10 / 4 * 4 + 10 % 4);` | 10 | 12 | 8 | 11 | **A. 10** (2*4 + 2 = 10) |
| 14 | `System.out.println(true ? false : true);` | true | false | Error | null | **B. false** |
| 15 | `System.out.println(1 == 1.0);` | true | false | Error | Warning | **A. true** (int widened to double) |
| 16 | `char c='a'; c+=1; System.out.println(c);` | a | b | 98 | Error | **B. b** |
| 17 | `System.out.println(4/0.0);` | Error | Infinity | NaN | 0 | **B. Infinity** |
| 18 | `System.out.println(0/0.0);` | Error | Infinity | NaN | 0 | **C. NaN** |
| 19 | `System.out.println(Math.max(3, Math.min(5, 4)));` | 3 | 4 | 5 | Error | **B. 4** |
| 20 | `System.out.println((int)(char)(byte)-1);` | -1 | 255 | 65535 | Error | **C. 65535** (byte -1 → char 65535 → int 65535) |

---

## 19.2 Strings – Extra MCQs (20 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `"Hello".substring(1, 3)` returns? | "He" | "el" | "ell" | "elo" | **B. "el"** (from index 1, before index 3) |
| 2 | `"Hello".indexOf('l')` returns? | 2 | 3 | 1 | 4 | **A. 2** (first 'l') |
| 3 | `"Hello".lastIndexOf('l')` returns? | 2 | 3 | 1 | 4 | **B. 3** (last 'l') |
| 4 | `"  hi  ".trim().length()` returns? | 6 | 4 | 2 | 5 | **C. 2** |
| 5 | `"abc".replace("a", "xyz")` returns? | "xyzbc" | "axyzbc" | Error | "abc" | **A. "xyzbc"** |
| 6 | `"java".startsWith("ja")` returns? | true | false | Error | null | **A. true** |
| 7 | `String.valueOf(true)` returns? | "true" | true | 1 | Error | **A. "true"** |
| 8 | `"abc".compareTo("abd")` returns? | 0 | -1 | 1 | Error | **B. -1** ('c' - 'd' = -1) |
| 9 | `"Hello World".split(" ").length` | 1 | 2 | 3 | Error | **B. 2** |
| 10 | `"aabaa".replace("aa", "x")` returns? | "xbx" | "xbaa" | "aabx" | "xba" | **A. "xbx"** |
| 11 | `new StringBuilder("hello").reverse()` | "hello" | "olleh" | Error | null | **B. "olleh"** |
| 12 | `StringBuilder sb = new StringBuilder(); sb.append(1).append(2);` value? | "1" | "12" | 3 | Error | **B. "12"** |
| 13 | Can `String` be used in switch (Java 7)? | Yes | No | Only final | Error | **A. Yes** |
| 14 | `"5" + 5 - 5` compiles? | Yes = "50" | Yes = 55 | Compile error | "5" | **C. Compile error** (can't subtract String) |
| 15 | `"Hello".chars()` returns? | String | int[] | IntStream | char[] | **C. IntStream** |
| 16 | `"abc".isEmpty()` | true | false | Error | null | **B. false** |
| 17 | `"".isEmpty()` | true | false | Error | null | **A. true** |
| 18 | `"".isBlank()` (Java 11+) | true | false | Error | null | **A. true** |
| 19 | `"  ".isBlank()` (Java 11+) | true | false | Error | null | **A. true** |
| 20 | `String.format("%05d", 42)` returns? | "42000" | "00042" | "42" | Error | **B. "00042"** |

---

## 19.3 Arrays – Extra MCQs (20 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `int[][] a = new int[3][4]; a.length?` | 3 | 4 | 12 | Error | **A. 3** (outer dimension) |
| 2 | `int[][] a = new int[3][4]; a[0].length?` | 3 | 4 | 12 | Error | **B. 4** |
| 3 | Can array store mixed types? | Yes | No | Only Object[] | With cast | **C. Object[] can store mixed** |
| 4 | `Arrays.sort(arr)` uses? | Bubble sort | TimSort | QuickSort | MergeSort | **B. TimSort** (for objects), **QuickSort variant** (for primitives) |
| 5 | `Arrays.binarySearch()` requires? | Any array | Sorted array | Reverse sorted | Unique values | **B. Sorted array** |
| 6 | `int[] a = {3,1,2}; Arrays.sort(a); a[0]?` | 3 | 1 | 2 | Error | **B. 1** |
| 7 | `Arrays.copyOf(arr, 5)` when arr has 3 elements? | Error | Copies 3, pads 0 | Copies 3 only | Exception | **B. Copies 3, pads with 0** |
| 8 | `Arrays.equals(a, b)` vs `a.equals(b)`? | Same | Arrays.equals checks content | a.equals checks reference | Both content | **B.** Arrays.equals checks content; a.equals checks reference |
| 9 | `int[] a = new int[5]; a[5] = 10;` | Runs fine | ArrayIndexOutOfBounds | NullPointer | Error | **B. ArrayIndexOutOfBoundsException** |
| 10 | Array of String default value? | "" | null | "null" | Error | **B. null** |
| 11 | `int[] arr = {1,2,3}; arr = new int[]{4,5};` original arr? | {1,2,3} | {4,5} | Error | null | **B. {4,5}** (arr now points to new array) |
| 12 | Can we pass array to method? | No | Yes, by reference | Yes, by value | Yes, copy | **B. Yes** (reference is passed by value) |
| 13 | `System.arraycopy(src,0,dst,0,3)` — 3 means? | src index | dst index | elements count | both | **C. Number of elements** |
| 14 | `Arrays.fill(a, 7)` does? | Sorts | Fills all with 7 | Fills first 7 | Error | **B. Fills all elements with 7** |
| 15 | Which is fastest for search in sorted array? | Linear | Binary | Hash | Tree | **B. Binary** O(log n) |
| 16 | `int[] a; a = {1,2,3};` compiles? | Yes | No | Warning | Depends | **B. No** (array initializer not allowed in assignment) |
| 17 | `int[] a = {1,2,3}; int[] b = a.clone();` a == b? | true | false | Error | null | **B. false** (different objects) |
| 18 | `String[] s = {"a","b"}; s[0] = null;` valid? | Yes | No | Warning | Error | **A. Yes** |
| 19 | Array is what type in Java? | Primitive | Object | Wrapper | Enum | **B. Object** |
| 20 | `int a[] = new int[3]; System.out.println(a);` | [0,0,0] | Memory address | Error | null | **B. Memory address** (e.g., [I@6d06d69c) |

---

## 19.4 OOP – Classes, Objects, Constructors (20 Extra MCQs)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Object class methods include? | toString | equals | hashCode | All | **D. All** |
| 2 | `hashCode()` contract: equal objects must have? | Different hashCode | Same hashCode | Any hashCode | 0 | **B. Same hashCode** |
| 3 | Same hashCode means objects are? | Equal | Not necessarily equal | Always unequal | Error | **B. Not necessarily equal** |
| 4 | `clone()` is in? | Cloneable | Object | Serializable | Comparable | **B. Object** |
| 5 | Shallow copy vs deep copy: difference? | Same thing | Shallow copies refs, deep copies objects | Deep copies refs | Depends | **B.** Shallow copies references; deep copies actual objects |
| 6 | `toString()` default returns? | "null" | ClassName@hashcode | "" | Error | **B. ClassName@hashcodeHex** |
| 7 | `finalize()` is called by? | Programmer | GC before collecting | JVM on startup | Never | **B. GC before collecting** (deprecated Java 9+) |
| 8 | Can `finalize()` prevent GC? | Yes | No | Sometimes | Error | **A. Yes** (resurrection, but unreliable) |
| 9 | Inner class can access outer class? | Only static | All including private | Only public | With cast | **B. All including private** |
| 10 | Static nested class can access outer? | All | Only static members directly | All via object | Error | **B. Only static members directly** |
| 11 | Anonymous class can extend? | Any class | Only abstract | Only interface | Both A and C | **D. Any class OR interface** |
| 12 | Anonymous class can have? | Constructor | Method | Both | No, only implements | **B. Methods** (no explicit constructor) |
| 13 | `new Runnable() {}` is? | Lambda | Anonymous class | Interface | Abstract | **B. Anonymous class** |
| 14 | Local class is defined? | Inside method | Inside if block | Both | Outside class | **C. Inside any block/method** |
| 15 | `Object o = new int[3];` compiles? | Yes | No | Warning | Error | **A. Yes** (array IS-A Object) |
| 16 | Can an object be assigned to `Object` reference? | Yes | No | Only String | With cast | **A. Yes** (all objects extend Object) |
| 17 | `getClass()` returns? | String class name | Class object | this | null | **B. Class<T> object** |
| 18 | `getClass().getName()` returns? | Simple name | Fully qualified name | Package | Error | **B. Fully qualified name** |
| 19 | Two objects with same state must have same `==`? | Yes | No | Depends | Always | **B. No** (different heap addresses) |
| 20 | Which method must be overridden when overriding `equals()`? | toString | hashCode | compareTo | clone | **B. hashCode** |

---

## 19.5 Inheritance & Polymorphism – Extra MCQs (20 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Diamond problem solved in Java by? | Multiple class inheritance | Interfaces with `InterfaceName.super.method()` | Abstract class | Not solved | **B. Interfaces with explicit resolution** |
| 2 | `super.super.method()` is? | Valid | Invalid | Valid in Java 8+ | Depends | **B. Invalid** |
| 3 | Can a subclass reduce visibility of inherited method? | Yes | No | With override | Warning | **B. No** (compile error) |
| 4 | Covariant return type means? | Same return type | Return subtype in override | Return supertype | Any return | **B. Return subtype in overriding** |
| 5 | Which methods cannot be overridden? | public | private, static, final | protected | default | **B. private, static, final** |
| 6 | Is constructor chaining possible across files? | Yes via super() | No | Only same package | Error | **A. Yes via super()** |
| 7 | Dynamic binding applies to? | All methods | Instance methods only | Static methods | Variables | **B. Instance methods only** |
| 8 | `instanceOf` with null reference? | true | false | Exception | Error | **B. false** |
| 9 | Marker interface is? | Interface with one method | Empty interface | Interface with only static | Functional interface | **B. Empty interface** (e.g., Serializable) |
| 10 | `Serializable` is a? | Class | Interface | Abstract class | Annotation | **B. Interface** (marker) |
| 11 | `Cloneable` is a? | Class | Marker interface | Abstract | Functional | **B. Marker interface** |
| 12 | When is IS-A relationship violated? | Never | Casting wrong type | Always | With interfaces | **B. Casting wrong type** (ClassCastException) |
| 13 | Can an abstract class implement interface partially? | No | Yes | Only Java 8+ | Error | **B. Yes** (remaining methods stay abstract) |
| 14 | Can interface have instance variables? | Yes | No | Only final | Only static final | **D. Only public static final** |
| 15 | `class A implements B, C` where B and C have same default method? | Error | Must override in A | Picks first | Picks last | **B. Must override in A** |
| 16 | Can we override `hashCode()` without overriding `equals()`? | Yes | No | Error | Warning | **A. Yes** (but bad practice) |
| 17 | Overriding `equals()` without `hashCode()` breaks? | Nothing | Collections (HashMap/HashSet) | Inheritance | JDBC | **B. Collections** |
| 18 | `protected` method in parent — child in different package can access via? | Direct call | Only inheritance | Both | Object reference | **B. Only through inheritance** |
| 19 | Method hiding (static method "override") uses? | Runtime binding | Compile time binding | Both | None | **B. Compile time binding** |
| 20 | Polymorphism type used in method overloading? | Dynamic | Static (compile-time) | Both | None | **B. Static (compile-time)** |

---

## 19.6 Abstract Class & Interface – Extra MCQs (20 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Can interface have `static` initializer block? | Yes | No | Java 9+ | Error | **B. No** |
| 2 | Can abstract class have `static` fields? | Yes | No | Only final | Error | **A. Yes** |
| 3 | Interface default method can call abstract method? | Yes | No | Only static | Error | **A. Yes** |
| 4 | Interface `private` method (Java 9+) can be? | abstract | only concrete | static or instance | Error | **C. static or instance (concrete)** |
| 5 | Can we use `synchronized` on interface method? | Yes | No | Java 8+ | Error | **B. No** |
| 6 | Abstract class can extend another abstract class? | Yes | No | Only one | Error | **A. Yes** |
| 7 | Number of abstract methods a functional interface can have? | 0 | 1 | Multiple | Unlimited | **B. 1** |
| 8 | `Runnable` is a? | Abstract class | Functional interface | Class | Enum | **B. Functional interface** |
| 9 | `Comparator` is a? | Abstract class | Functional interface | Marker interface | Class | **B. Functional interface** |
| 10 | Can abstract class be instantiated with anonymous class? | Yes | No | Only with concrete | Error | **A. Yes** (anonymous class provides implementation) |
| 11 | Which is true about `default` method in interface? | Must be overridden | Optional to override | Cannot be overridden | Abstract by default | **B. Optional to override** |
| 12 | Can we call interface `static` method via implementing class? | Yes | No | Via object | Error | **B. No** (only via InterfaceName.method()) |
| 13 | An interface extending another interface must implement its methods? | Yes | No | Only abstract | Depends | **B. No** (remains abstract) |
| 14 | `abstract` method CAN have? | Body | Access modifier public/protected | Both | Neither | **B. Access modifier** |
| 15 | Interface variable `int MAX = 5;` is implicitly? | Instance variable | public static final | private | protected | **B. public static final** |
| 16 | `abstract class A { abstract void m(); }` — m() implicitly? | private | public | protected | package-private | **C. package-private** (no explicit modifier → default) Wait—abstract methods in abstract class can have any access except private. Default is package-private. | **C. package-private (default)** |
| 17 | Can an abstract class have 0 abstract methods? | Yes | No | Error | Warning | **A. Yes** (just prevents instantiation) |
| 18 | `interface A { int x = 5; }` — can we do `A.x = 10;`? | Yes | No (final) | With A.x=10 | Only via impl | **B. No** (implicitly final) |
| 19 | Default method conflict resolution rule priority? | Class > Interface (default) > Interface (parent) | All same priority | Interface wins | Error | **A. Class implementation > interface default** |
| 20 | Can `enum` implement interface? | Yes | No | Only marker | Error | **A. Yes** |

---

## 19.7 Exception Handling – Extra MCQs (20 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `catch(Exception e)` before `catch(IOException e)` — valid? | Yes | No (unreachable) | Warning | Depends | **B. No** (compile error — unreachable catch) |
| 2 | Can `try` block be empty? | Yes | No | Warning | Error | **A. Yes** (valid but meaningless) |
| 3 | `StackOverflowError` is? | Checked | Unchecked | Exception | Neither | **B. Unchecked (Error subclass)** |
| 4 | `OutOfMemoryError` is? | Checked | Error (unchecked) | Exception | RuntimeException | **B. Error** |
| 5 | Re-throwing caught exception: `throw e;` in catch — valid? | Yes | No | Only for checked | Runtime only | **A. Yes** |
| 6 | Can `finally` block throw exception? | Yes | No | Warning | Error | **A. Yes** (suppresses original exception) |
| 7 | If both `try` and `finally` throw, which propagates? | try | finally | Both | Neither | **B. finally** (it suppresses try's exception) |
| 8 | `try { } finally { }` — must have catch? | Yes | No | Java 7+ | Error | **B. No** |
| 9 | Checked vs unchecked — checked must be handled at? | Runtime | Compile time | Both | Never | **B. Compile time** (compiler enforces) |
| 10 | `throw null;` at runtime causes? | NullPointerException | Compiles and works | Error | Compile error | **A. NullPointerException** |
| 11 | Can we have multiple `finally` blocks for one `try`? | Yes | No | Java 9+ | Warning | **B. No** |
| 12 | `NumberFormatException` extends? | Exception | IOException | RuntimeException | Error | **C. RuntimeException** |
| 13 | Try-with-resources: resource close exception vs body exception? | Body wins | Resource close wins | Both | Neither | **A. Body exception propagates; close exception is suppressed** |
| 14 | Suppressed exceptions accessible via? | e.getMessage() | e.getSuppressed() | e.getCause() | e.list() | **B. getSuppressed()** |
| 15 | Can we declare custom exception as unchecked? | Yes (extend RuntimeException) | No | Only if final | Error | **A. Yes** |
| 16 | `assert` statement behavior when disabled? | Throws | Does nothing | Compiles error | Always runs | **B. Does nothing** (assertions disabled by default) |
| 17 | `ClassNotFoundException` is? | Checked | Unchecked | Error | RuntimeException | **A. Checked** |
| 18 | `ClassCastException` is? | Checked | Unchecked (RuntimeException) | Error | Neither | **B. Unchecked** |
| 19 | What does `e.getMessage()` return when no message given? | "" | null | "Error" | 0 | **B. null** |
| 20 | Multi-catch `catch (A | B e)` — `e` is? | mutable | effectively final | A type | B type | **B. Effectively final** (cannot reassign) |

---

## 19.8 Collections – Extra MCQs (20 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `PriorityQueue` ordering? | FIFO | LIFO | Natural ordering (min-heap) | Insertion | **C. Natural ordering** (smallest first) |
| 2 | `Deque` stands for? | Data queue | Double-ended queue | Dynamic queue | Default queue | **B. Double-ended queue** |
| 3 | `ArrayDeque` vs `LinkedList` for stack/queue? | Same | ArrayDeque faster | LinkedList faster | Both slow | **B. ArrayDeque is faster** (no node overhead) |
| 4 | `Collections.sort()` uses? | BubbleSort | TimSort | QuickSort | MergeSort | **B. TimSort** |
| 5 | `HashMap` `get()` worst case? | O(1) | O(log n) | O(n) | O(n²) | **C. O(n)** (all keys same bucket, Java 8 → O(log n) with tree) |
| 6 | `TreeMap` `get()` time complexity? | O(1) | O(log n) | O(n) | O(n log n) | **B. O(log n)** |
| 7 | `HashSet.contains()` time complexity? | O(1) average | O(log n) | O(n) | O(n²) | **A. O(1) average** |
| 8 | `LinkedList.get(index)` time complexity? | O(1) | O(log n) | O(n) | O(n²) | **C. O(n)** (traverse from head) |
| 9 | `ArrayList.add(element)` at end amortized? | O(1) | O(log n) | O(n) | O(n²) | **A. O(1) amortized** |
| 10 | `ArrayList.add(index, element)` at beginning? | O(1) | O(log n) | O(n) | O(n²) | **C. O(n)** (shift elements) |
| 11 | `Collections.unmodifiableMap()` throws on put? | Nothing | UnsupportedOperationException | NullPointerException | Error | **B. UnsupportedOperationException** |
| 12 | `Map.getOrDefault(key, default)` — key not found? | null | default value | Error | 0 | **B. default value** |
| 13 | `Map.computeIfAbsent(key, fn)` does? | Always computes | Computes only if key absent | Removes key | Error | **B. Computes only if key absent** |
| 14 | `List.subList(1, 3)` returns? | Indices 1,2,3 | Indices 1,2 | New list copy | Immutable view | **B. Indices 1, 2 (view of original)** |
| 15 | Modifying subList affects original? | No | Yes | Sometimes | Error | **B. Yes** (it's a view) |
| 16 | `Collections.frequency(list, obj)` returns? | true/false | Count of obj | Index | Error | **B. Count of occurrences** |
| 17 | `Collections.nCopies(3, "x")` returns? | ["x"] | ["x","x","x"] | ["xxx"] | Error | **B. ["x","x","x"]** |
| 18 | `EnumSet` is? | General purpose | High-performance set for enums | HashSet variant | TreeSet variant | **B. High-performance set for enums** |
| 19 | Which Map preserves access order? | HashMap | LinkedHashMap with accessOrder=true | TreeMap | Hashtable | **B. LinkedHashMap(initialCapacity, loadFactor, true)** |
| 20 | `CopyOnWriteArrayList` is best for? | Heavy writes | Heavy reads, rare writes | Mixed | Cache | **B. Heavy reads, rare writes** |

---

## 19.9 JDBC – Extra MCQs (15 Questions)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `ResultSet.TYPE_SCROLL_INSENSITIVE` allows? | Forward only | Scrollable, insensitive to changes | Sensitive to changes | Read-write | **B. Scrollable, insensitive** |
| 2 | `ResultSet.first()` moves to? | Row 0 | Row 1 | Last row | Error | **B. First row (row 1)** |
| 3 | `ResultSet.absolute(-1)` moves to? | First row | Last row | Error | Row -1 | **B. Last row** |
| 4 | `getInt("column")` vs `getInt(1)` — which is faster? | Named | Index | Same | Depends | **B. Index** |
| 5 | `execute()` method returns? | ResultSet | int | boolean | void | **C. boolean** (true=ResultSet, false=update count) |
| 6 | JDBC `Batch` processing improves? | Security | Performance (fewer round trips) | Reliability | Both | **B. Performance** |
| 7 | `addBatch()` + `executeBatch()` used for? | Single query | Multiple queries at once | Transaction | Connection | **B. Multiple queries at once** |
| 8 | Connection URL format for MySQL? | `mysql://localhost/db` | `jdbc:mysql://host:port/db` | `mysql:jdbc:db` | `db:mysql:host` | **B.** |
| 9 | `DataSource` is preferred over `DriverManager` because? | Simpler | Supports connection pooling | Newer | Faster single use | **B. Connection pooling** |
| 10 | `ResultSetMetaData` provides? | Row data | Column info (name, type, count) | Connection info | Transaction info | **B. Column info** |
| 11 | `DatabaseMetaData` provides? | Row data | Column info | DB details (version, driver) | ResultSet | **C. DB details** |
| 12 | `conn.setSavepoint()` is used for? | Commit | Partial rollback point | Close | Batch | **B. Partial rollback** |
| 13 | JDBC 4.0+ — need `Class.forName()`? | Yes always | No (auto-loaded) | Only for MySQL | Yes for non-standard | **B. No** (auto Service Provider) |
| 14 | `ResultSet` is closed when? | Manually or when Statement closes | Always open | Only on conn.close | Never auto | **B. When Statement closes or manually** |
| 15 | SQL `NULL` in Java via JDBC is? | 0 | "" | null | NullPointerException | **C. null** (but use `wasNull()` to confirm) |

---

# 20. More Output Prediction Questions (25 New Questions)

### Q16
```java
class A {
    static int x = 10;
}
class B extends A {
    static int x = 20;
}
A obj = new B();
System.out.println(obj.x);
```
**Output:** `10`
> **Reason:** Static variables use reference type (compile-time binding).

---

### Q17
```java
int i = 0;
for (; i < 3; ) {
    System.out.print(i++ + " ");
}
```
**Output:** `0 1 2 `
> **Reason:** init and update parts are empty; i incremented inside body.

---

### Q18
```java
String s = "Hello";
switch (s) {
    case "Hello":
        System.out.println("Hi");
    case "World":
        System.out.println("Hey");
        break;
    default:
        System.out.println("Who?");
}
```
**Output:**
```
Hi
Hey
```
> **Reason:** No break after "Hello" case → falls through to "World" case.

---

### Q19
```java
List<Integer> list = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
list.removeIf(n -> n % 2 == 0);
System.out.println(list);
```
**Output:** `[1, 3, 5]`

---

### Q20
```java
int[] arr = {5, 3, 1, 4, 2};
Arrays.sort(arr);
System.out.println(Arrays.binarySearch(arr, 3));
```
**Output:** `2`
> **Reason:** After sort → {1,2,3,4,5}. 3 is at index 2.

---

### Q21
```java
HashMap<Integer, String> map = new HashMap<>();
map.put(1, "A"); map.put(2, "B"); map.put(3, "C");
map.remove(2);
System.out.println(map.containsValue("B"));
```
**Output:** `false`

---

### Q22
```java
class Counter {
    int count = 0;
    Counter increment() { count++; return this; }
    void display() { System.out.println(count); }
}
new Counter().increment().increment().increment().display();
```
**Output:** `3`
> **Reason:** Method chaining — each `increment()` returns same object.

---

### Q23
```java
interface Greeting { default void greet() { System.out.println("Hello"); } }
interface Farewell { default void greet() { System.out.println("Bye"); } }
class Person implements Greeting, Farewell {
    public void greet() {
        Greeting.super.greet();
        Farewell.super.greet();
    }
}
new Person().greet();
```
**Output:**
```
Hello
Bye
```

---

### Q24
```java
try {
    System.out.println("A");
    throw new RuntimeException();
} catch (RuntimeException e) {
    System.out.println("B");
    throw e;
} finally {
    System.out.println("C");
}
```
**Output:**
```
A
B
C
```
Then exception propagates.

---

### Q25
```java
String[] arr = {"banana", "apple", "cherry"};
Arrays.sort(arr);
System.out.println(Arrays.toString(arr));
```
**Output:** `[apple, banana, cherry]`

---

### Q26
```java
int x = 5;
int y = ++x * x++;
System.out.println(x + " " + y);
```
**Output:** `7 36`
> `++x` → x=6, first operand=6. `x++` → operand=6, x becomes 7. y = 6*6 = 36.

---

### Q27
```java
List<String> list = List.of("a", "b", "c");
list.add("d");
```
**Output:** `UnsupportedOperationException`
> `List.of()` returns immutable list.

---

### Q28
```java
class A {
    void show() throws Exception { System.out.println("A"); }
}
class B extends A {
    @Override
    void show() { System.out.println("B"); }
}
A obj = new B();
obj.show();
```
**Output:** `B`
> Overriding method can reduce exceptions. Runtime dispatch calls B's show().

---

### Q29
```java
StringBuilder sb1 = new StringBuilder("hello");
StringBuilder sb2 = sb1;
sb2.append(" world");
System.out.println(sb1);
```
**Output:** `hello world`
> sb1 and sb2 point to same object (unlike String).

---

### Q30
```java
int a = 10, b = 20;
System.out.println(a > b ? "a" : b > a ? "b" : "equal");
```
**Output:** `b`
> `a > b` is false → evaluate `b > a ? "b" : "equal"` → true → "b"

---

### Q31
```java
int[] a = {1, 2, 3};
int[] b = Arrays.copyOfRange(a, 1, 4);
System.out.println(Arrays.toString(b));
```
**Output:** `[2, 3, 0]`
> index 1 to 3 (exclusive 4). Index 3 doesn't exist → padded with 0.

---

### Q32
```java
TreeSet<Integer> ts = new TreeSet<>();
ts.add(5); ts.add(1); ts.add(3); ts.add(2); ts.add(4);
System.out.println(ts.headSet(3));
System.out.println(ts.tailSet(3));
```
**Output:**
```
[1, 2]
[3, 4, 5]
```
> `headSet(3)` = elements < 3. `tailSet(3)` = elements >= 3.

---

### Q33
```java
Map<String, Integer> m = new HashMap<>();
m.put("a", 1); m.put("b", 2);
m.putIfAbsent("a", 99);
System.out.println(m.get("a"));
```
**Output:** `1`
> `putIfAbsent` doesn't overwrite existing key.

---

### Q34
```java
class A {
    int x;
    A(int x) { this.x = x; }
    A() { this(5); }
}
System.out.println(new A().x);
```
**Output:** `5`
> `new A()` → calls `this(5)` → sets x to 5.

---

### Q35
```java
class T implements Runnable {
    public void run() { System.out.println("Running"); }
}
Thread t = new Thread(new T());
t.start();
t.start();
```
**Output:** `Running` (once), then `IllegalThreadStateException`
> A thread cannot be started more than once.

---

### Q36
```java
Optional<String> opt = Optional.ofNullable(null);
System.out.println(opt.isPresent());
System.out.println(opt.orElse("default"));
```
**Output:**
```
false
default
```

---

### Q37
```java
int[] a = {10, 20, 30, 40};
System.out.println(Arrays.stream(a).sum());
System.out.println(Arrays.stream(a).average().getAsDouble());
```
**Output:**
```
100
25.0
```

---

### Q38
```java
class A { }
class B extends A { }
class C extends B { }
C obj = new C();
System.out.println(obj instanceof A);
System.out.println(obj instanceof B);
System.out.println(obj instanceof C);
```
**Output:**
```
true
true
true
```

---

### Q39
```java
String s = "abcdef";
System.out.println(s.substring(2));
System.out.println(s.substring(2, 4));
```
**Output:**
```
cdef
cd
```

---

### Q40
```java
List<Integer> nums = Arrays.asList(4, 2, 7, 1, 9, 3);
Collections.sort(nums);
System.out.println(Collections.binarySearch(nums, 7));
```
**Output:** `4`
> After sort: [1,2,3,4,7,9]. 7 is at index 4.

---

# 21. Tricky Short Programs – Must Know

### Program 21: Singleton Pattern

```java
// Singleton – only one object ever created
public class Singleton {
    private static Singleton instance = null; // Only one instance

    private Singleton() { } // Private constructor – no outside instantiation

    public static Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton(); // Create only once
        }
        return instance;
    }

    public void show() {
        System.out.println("Singleton instance: " + this.hashCode());
    }

    public static void main(String[] args) {
        Singleton s1 = Singleton.getInstance();
        Singleton s2 = Singleton.getInstance();
        s1.show();
        s2.show();
        System.out.println(s1 == s2); // true – same object
    }
}
```

---

### Program 22: Generic Method

```java
public class GenericDemo {
    // Generic method works with any type
    static <T extends Comparable<T>> T findMax(T[] arr) {
        T max = arr[0];
        for (T item : arr) {
            if (item.compareTo(max) > 0) max = item;
        }
        return max;
    }

    public static void main(String[] args) {
        Integer[] nums = {3, 1, 4, 1, 5, 9, 2};
        String[] words = {"banana", "apple", "cherry"};
        System.out.println(findMax(nums));  // 9
        System.out.println(findMax(words)); // cherry
    }
}
```

---

### Program 23: Lambda + Collections Sorting

```java
import java.util.*;

public class LambdaSort {
    public static void main(String[] args) {
        List<String> names = Arrays.asList("Charlie", "Alice", "Bob", "Diana");

        // Sort ascending by length, then alphabetically
        names.sort(Comparator.comparingInt(String::length)
                             .thenComparing(Comparator.naturalOrder()));

        names.forEach(System.out::println);
        // Bob
        // Alice
        // Charlie
        // Diana
    }
}
```

---

### Program 24: Stream API – Filter, Map, Collect

```java
import java.util.*;
import java.util.stream.*;

public class StreamDemo {
    public static void main(String[] args) {
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

        // Get sum of squares of even numbers
        int result = numbers.stream()
            .filter(n -> n % 2 == 0)          // Keep evens: 2,4,6,8,10
            .mapToInt(n -> n * n)              // Square: 4,16,36,64,100
            .sum();                            // Sum: 220
        System.out.println("Sum of squares of evens: " + result);

        // Collect names starting with 'A'
        List<String> names = Arrays.asList("Alice", "Bob", "Anna", "Charlie", "Amy");
        List<String> aNames = names.stream()
            .filter(s -> s.startsWith("A"))
            .sorted()
            .collect(Collectors.toList());
        System.out.println(aNames); // [Alice, Amy, Anna]
    }
}
```

---

### Program 25: Custom Comparator with TreeSet

```java
import java.util.*;

class Student {
    String name;
    int marks;

    Student(String name, int marks) {
        this.name = name;
        this.marks = marks;
    }

    public String toString() {
        return name + "=" + marks;
    }
}

public class TreeSetCustom {
    public static void main(String[] args) {
        // Sort by marks descending
        TreeSet<Student> ts = new TreeSet<>(
            (s1, s2) -> s2.marks - s1.marks
        );
        ts.add(new Student("Alice", 85));
        ts.add(new Student("Bob", 92));
        ts.add(new Student("Charlie", 78));
        ts.add(new Student("Diana", 95));

        ts.forEach(System.out::println);
        // Diana=95
        // Bob=92
        // Alice=85
        // Charlie=78
    }
}
```

---

### Program 26: Stack using Deque (Preferred over Stack class)

```java
import java.util.*;

public class StackUsingDeque {
    public static void main(String[] args) {
        Deque<Integer> stack = new ArrayDeque<>();

        stack.push(10);  // push
        stack.push(20);
        stack.push(30);

        System.out.println("Top: " + stack.peek()); // 30
        System.out.println("Popped: " + stack.pop()); // 30
        System.out.println("Size: " + stack.size()); // 2

        // Reverse a string using stack
        String str = "Hello";
        Deque<Character> charStack = new ArrayDeque<>();
        for (char c : str.toCharArray()) charStack.push(c);

        StringBuilder sb = new StringBuilder();
        while (!charStack.isEmpty()) sb.append(charStack.pop());
        System.out.println(sb.toString()); // olleH
    }
}
```

---

### Program 27: Check Balanced Parentheses

```java
import java.util.*;

public class BalancedParentheses {
    static boolean isBalanced(String s) {
        Deque<Character> stack = new ArrayDeque<>();
        for (char c : s.toCharArray()) {
            if (c == '(' || c == '{' || c == '[') {
                stack.push(c);
            } else if (c == ')' || c == '}' || c == ']') {
                if (stack.isEmpty()) return false;
                char top = stack.pop();
                if ((c == ')' && top != '(') ||
                    (c == '}' && top != '{') ||
                    (c == ']' && top != '[')) {
                    return false;
                }
            }
        }
        return stack.isEmpty();
    }

    public static void main(String[] args) {
        System.out.println(isBalanced("{[()]}"));   // true
        System.out.println(isBalanced("{[(])}"));   // false
        System.out.println(isBalanced("(("));       // false
    }
}
```

---

### Program 28: Find First Non-Repeating Character

```java
import java.util.*;

public class FirstNonRepeating {
    static char firstNonRepeating(String s) {
        LinkedHashMap<Character, Integer> map = new LinkedHashMap<>();
        for (char c : s.toCharArray()) {
            map.put(c, map.getOrDefault(c, 0) + 1);
        }
        for (Map.Entry<Character, Integer> entry : map.entrySet()) {
            if (entry.getValue() == 1) return entry.getKey();
        }
        return '_'; // No non-repeating char
    }

    public static void main(String[] args) {
        System.out.println(firstNonRepeating("aabbcde")); // c
        System.out.println(firstNonRepeating("aabb"));    // _
        System.out.println(firstNonRepeating("stress")); // t
    }
}
```

---

### Program 29: Word Frequency Count

```java
import java.util.*;
import java.util.stream.*;

public class WordFrequency {
    public static void main(String[] args) {
        String text = "the quick brown fox jumps over the lazy dog the fox";
        
        // Using streams
        Map<String, Long> freq = Arrays.stream(text.split(" "))
            .collect(Collectors.groupingBy(w -> w, Collectors.counting()));

        // Sort by frequency descending
        freq.entrySet().stream()
            .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
            .forEach(e -> System.out.println(e.getKey() + " : " + e.getValue()));
        // the : 3
        // fox : 2
        // quick : 1  ... etc.
    }
}
```

---

### Program 30: GCD and LCM

```java
public class GcdLcm {
    static int gcd(int a, int b) {
        while (b != 0) {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }

    static long lcm(int a, int b) {
        return (long) a / gcd(a, b) * b; // Avoid overflow
    }

    public static void main(String[] args) {
        int a = 12, b = 18;
        System.out.println("GCD: " + gcd(a, b)); // 6
        System.out.println("LCM: " + lcm(a, b)); // 36
    }
}
```

---

### Program 31: Custom Iterator Pattern

```java
import java.util.Iterator;

public class NumberRange implements Iterable<Integer> {
    private int start, end;

    NumberRange(int start, int end) {
        this.start = start;
        this.end = end;
    }

    @Override
    public Iterator<Integer> iterator() {
        return new Iterator<Integer>() {
            int current = start;

            public boolean hasNext() { return current <= end; }
            public Integer next() { return current++; }
        };
    }

    public static void main(String[] args) {
        for (int num : new NumberRange(1, 5)) {
            System.out.print(num + " "); // 1 2 3 4 5
        }
    }
}
```

---

### Program 32: Merge Two Sorted Arrays

```java
import java.util.Arrays;

public class MergeSortedArrays {
    static int[] merge(int[] a, int[] b) {
        int[] result = new int[a.length + b.length];
        int i = 0, j = 0, k = 0;
        while (i < a.length && j < b.length) {
            if (a[i] <= b[j]) result[k++] = a[i++];
            else result[k++] = b[j++];
        }
        while (i < a.length) result[k++] = a[i++];
        while (j < b.length) result[k++] = b[j++];
        return result;
    }

    public static void main(String[] args) {
        int[] a = {1, 3, 5, 7};
        int[] b = {2, 4, 6, 8};
        System.out.println(Arrays.toString(merge(a, b)));
        // [1, 2, 3, 4, 5, 6, 7, 8]
    }
}
```

---

### Program 33: FizzBuzz (Classic Interview)

```java
public class FizzBuzz {
    public static void main(String[] args) {
        for (int i = 1; i <= 30; i++) {
            if (i % 15 == 0)      System.out.println("FizzBuzz");
            else if (i % 3 == 0)  System.out.println("Fizz");
            else if (i % 5 == 0)  System.out.println("Buzz");
            else                   System.out.println(i);
        }
    }
}
// Key trick: check 15 (both 3 and 5) FIRST
```

---

### Program 34: Deep Copy of ArrayList

```java
import java.util.*;

class Box {
    int size;
    Box(int size) { this.size = size; }
    Box deepCopy() { return new Box(this.size); }
    public String toString() { return "Box(" + size + ")"; }
}

public class DeepCopyDemo {
    public static void main(String[] args) {
        ArrayList<Box> original = new ArrayList<>();
        original.add(new Box(10));
        original.add(new Box(20));

        // Shallow copy
        ArrayList<Box> shallow = new ArrayList<>(original);
        shallow.get(0).size = 99;
        System.out.println(original.get(0)); // Box(99) – AFFECTED!

        // Deep copy
        ArrayList<Box> deep = new ArrayList<>();
        for (Box b : original) deep.add(b.deepCopy());
        deep.get(0).size = 999;
        System.out.println(original.get(0)); // Still Box(99) – NOT affected
    }
}
```

---

### Program 35: Exception Chaining

```java
public class ExceptionChaining {
    static void level3() throws Exception {
        throw new Exception("Root cause");
    }

    static void level2() throws Exception {
        try { level3(); }
        catch (Exception e) {
            throw new Exception("Level 2 failed", e); // Chain it
        }
    }

    static void level1() {
        try { level2(); }
        catch (Exception e) {
            System.out.println("Caught: " + e.getMessage());
            System.out.println("Caused by: " + e.getCause().getMessage());
        }
    }

    public static void main(String[] args) { level1(); }
    // Caught: Level 2 failed
    // Caused by: Root cause
}
```

---

### Program 36: Parallel Streams

```java
import java.util.*;
import java.util.stream.*;

public class ParallelStream {
    public static void main(String[] args) {
        List<Integer> list = IntStream.rangeClosed(1, 10)
            .boxed().collect(Collectors.toList());

        // Sequential
        long seqSum = list.stream()
            .mapToLong(Integer::longValue).sum();
        System.out.println("Sequential sum: " + seqSum); // 55

        // Parallel – uses multiple threads
        long parSum = list.parallelStream()
            .mapToLong(Integer::longValue).sum();
        System.out.println("Parallel sum: " + parSum); // 55
    }
}
```

---

### Program 37: JDBC with ResultSetMetaData

```java
import java.sql.*;

public class MetaDataDemo {
    public static void main(String[] args) throws Exception {
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/testdb", "root", "password");

        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM students");

        // Get column information
        ResultSetMetaData meta = rs.getMetaData();
        int cols = meta.getColumnCount();
        System.out.println("Number of columns: " + cols);
        for (int i = 1; i <= cols; i++) {
            System.out.println("Column " + i + ": "
                + meta.getColumnName(i) + " ("
                + meta.getColumnTypeName(i) + ")");
        }

        // Print all rows dynamically
        while (rs.next()) {
            for (int i = 1; i <= cols; i++) {
                System.out.print(rs.getString(i) + "\t");
            }
            System.out.println();
        }
        conn.close();
    }
}
```

---

### Program 38: Number to Words (Interview Favorite)

```java
public class NumberToWords {
    static String[] ones = {"", "One", "Two", "Three", "Four", "Five",
        "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve",
        "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
        "Eighteen", "Nineteen"};
    static String[] tens = {"", "", "Twenty", "Thirty", "Forty", "Fifty",
        "Sixty", "Seventy", "Eighty", "Ninety"};

    static String convert(int n) {
        if (n == 0) return "Zero";
        if (n < 20) return ones[n];
        if (n < 100) return tens[n / 10] + (n % 10 != 0 ? " " + ones[n % 10] : "");
        if (n < 1000) return ones[n / 100] + " Hundred" +
            (n % 100 != 0 ? " " + convert(n % 100) : "");
        return ones[n / 1000] + " Thousand" +
            (n % 1000 != 0 ? " " + convert(n % 1000) : "");
    }

    public static void main(String[] args) {
        System.out.println(convert(0));    // Zero
        System.out.println(convert(15));   // Fifteen
        System.out.println(convert(105));  // One Hundred Five
        System.out.println(convert(999));  // Nine Hundred Ninety Nine
        System.out.println(convert(1234)); // One Thousand Two Hundred Thirty Four
    }
}
```

---

### Program 39: Bubble Sort on Objects with Comparable

```java
import java.util.*;

class Product implements Comparable<Product> {
    String name;
    double price;

    Product(String name, double price) {
        this.name = name;
        this.price = price;
    }

    @Override
    public int compareTo(Product other) {
        return Double.compare(this.price, other.price); // Ascending by price
    }

    public String toString() { return name + "=" + price; }
}

public class SortProducts {
    public static void main(String[] args) {
        List<Product> products = new ArrayList<>();
        products.add(new Product("Laptop", 800.0));
        products.add(new Product("Phone", 500.0));
        products.add(new Product("Tablet", 350.0));

        Collections.sort(products);
        products.forEach(System.out::println);
        // Tablet=350.0
        // Phone=500.0
        // Laptop=800.0
    }
}
```

---

### Program 40: Interface with Default + Abstract (Real Use-Case)

```java
import java.util.*;

interface Logger {
    // Abstract
    String getSource();

    // Default – uses abstract method
    default void log(String message) {
        System.out.println("[" + getSource() + "] " + message);
    }

    // Static utility
    static Logger console(String source) {
        return () -> source; // Lambda implements functional interface
    }
}

public class LoggerDemo {
    public static void main(String[] args) {
        Logger dbLogger = Logger.console("DATABASE");
        dbLogger.log("Connection established."); // [DATABASE] Connection established.

        Logger appLogger = Logger.console("APP");
        appLogger.log("Server started on port 8080."); // [APP] Server started on port 8080.
    }
}
```

---

# 22. Topic-Wise True/False Master Set (50 Questions)

| # | Statement | T/F | Reason |
|---|---|---|---|
| 1 | `int` and `Integer` are the same type | **F** | int is primitive, Integer is wrapper |
| 2 | Autoboxing converts `int` → `Integer` automatically | **T** | |
| 3 | `Integer.parseInt("abc")` throws NumberFormatException | **T** | |
| 4 | Wrappers are immutable | **T** | |
| 5 | `++` operator works on wrapper Integer directly | **T** | Auto-unbox, increment, re-box |
| 6 | `ArrayList` can store primitive `int` | **F** | Must use `Integer` |
| 7 | `HashMap` can have multiple null values | **T** | Multiple null values, one null key |
| 8 | `TreeMap` keys must implement `Comparable` (if no Comparator) | **T** | |
| 9 | `HashSet` is backed by `HashMap` | **T** | Values stored as HashMap keys |
| 10 | `LinkedHashMap` always iterates in insertion order | **T** | Default; access-order is optional |
| 11 | Interfaces can extend multiple interfaces | **T** | |
| 12 | Abstract class can have constructor | **T** | |
| 13 | `final` method can be overloaded | **T** | final only prevents overriding |
| 14 | `this()` and `super()` can be used in the same constructor | **F** | Both must be first line |
| 15 | `Object o = null; o instanceof Object` returns true | **F** | null instanceof anything = false |
| 16 | Static methods are polymorphic | **F** | They are hidden, not overridden |
| 17 | `enum` implicitly extends `java.lang.Enum` | **T** | |
| 18 | `enum` can implement interfaces | **T** | |
| 19 | `enum` can extend another class | **F** | Already extends Enum |
| 20 | `String` is thread-safe | **T** | Immutable = thread-safe |
| 21 | `StringBuilder` is thread-safe | **F** | Use StringBuffer for thread-safety |
| 22 | `System.out.println(null)` prints "null" | **T** | |
| 23 | You can catch `Error` in Java | **T** | But not recommended |
| 24 | `finally` runs after `System.exit(0)` | **F** | System.exit terminates JVM |
| 25 | A class can have only one static block | **F** | Multiple static blocks allowed |
| 26 | Static blocks run before constructors | **T** | |
| 27 | Instance initializer block runs before constructor body | **T** | |
| 28 | `abstract` and `final` can be combined on a class | **F** | Contradictory |
| 29 | `private` and `abstract` can be combined on a method | **F** | Private can't be overridden |
| 30 | `static` and `abstract` can be combined | **F** | Static can't be overridden |
| 31 | `default` methods in interface can be overridden | **T** | |
| 32 | `interface` can have `private` methods (Java 9+) | **T** | |
| 33 | `List.of()` (Java 9+) allows null elements | **F** | NullPointerException |
| 34 | `Collections.sort()` modifies original list | **T** | In-place sort |
| 35 | `Arrays.asList()` returns a fixed-size list | **T** | Can't add/remove, but can set |
| 36 | `ConcurrentModificationException` is a checked exception | **F** | It's unchecked (RuntimeException) |
| 37 | JDBC PreparedStatement prevents SQL injection | **T** | Parameters are escaped |
| 38 | `connection.commit()` needed when autoCommit is true | **F** | Auto-committed already |
| 39 | `ResultSet` rows start from index 0 | **F** | They start from 1 (`rs.getInt(1)`) |
| 40 | `executeQuery()` can be used for INSERT | **F** | Use executeUpdate() |
| 41 | Java supports multiple return values from a method | **F** | Return array/object instead |
| 42 | Lambda expressions can access local variables from enclosing scope | **T** | Must be effectively final |
| 43 | A lambda can modify a local variable from enclosing scope | **F** | Must be effectively final |
| 44 | Method reference `String::length` is same as `s -> s.length()` | **T** | |
| 45 | `Stream.forEach()` guarantees order for parallel streams | **F** | Order not guaranteed |
| 46 | `Streams` are reusable | **F** | Once consumed, can't reuse |
| 47 | `Optional.get()` on empty Optional throws exception | **T** | NoSuchElementException |
| 48 | `var` keyword infers type at compile time (Java 10+) | **T** | |
| 49 | `var` can be used for method parameters | **F** | Only for local variables |
| 50 | Java is 100% object-oriented | **F** | Primitives are not objects |

---

# 23. One-Liner Concept Questions (50 Questions)

> Answer each in ONE sentence or value.

| # | Question | Answer |
|---|---|---|
| 1 | What is the size of `long` in Java? | 8 bytes |
| 2 | What is autoboxing? | Automatic conversion of primitive to wrapper (int → Integer) |
| 3 | What does `==` compare for objects? | Memory addresses (references) |
| 4 | What is the difference between `equals()` and `==`? | `equals()` compares content (if overridden); `==` compares references |
| 5 | What is a static block? | Block executed once when class is loaded |
| 6 | What is method hiding? | When a subclass defines a static method with same signature as parent's |
| 7 | What is the diamond problem? | Ambiguity when a class inherits same method from two sources |
| 8 | What is covariant return type? | An overriding method returning a subtype of the parent's return type |
| 9 | What is a marker interface? | An empty interface used to mark/tag a class (e.g., Serializable) |
| 10 | What is the default capacity of ArrayList? | 10 |
| 11 | What happens when ArrayList is full? | New array of 1.5x size is created and elements copied |
| 12 | What is the load factor of HashMap? | 0.75 |
| 13 | What is a collision in HashMap? | Two keys mapped to same bucket |
| 14 | How is collision resolved in HashMap? | Chaining (LinkedList/Tree per bucket, Java 8+) |
| 15 | What is fail-fast iterator? | Throws ConcurrentModificationException if collection is modified during iteration |
| 16 | What is fail-safe iterator? | Works on a copy, no exception (e.g., CopyOnWriteArrayList) |
| 17 | What is the difference between `throw` and `throws`? | `throw` creates/throws exception; `throws` declares it in method signature |
| 18 | What is a checked exception? | Exception that must be handled at compile time |
| 19 | What is try-with-resources? | Auto-closes resources implementing AutoCloseable after try block |
| 20 | What is a functional interface? | Interface with exactly one abstract method |
| 21 | What is a lambda expression? | Short anonymous function implementing a functional interface |
| 22 | What does `::` (method reference) do? | References an existing method as a lambda |
| 23 | What is Stream in Java? | A pipeline for processing sequences of elements with functional operations |
| 24 | Difference between `map()` and `flatMap()`? | `map()` returns one stream element per element; `flatMap()` flattens nested streams |
| 25 | What is Optional? | A container that may or may not hold a non-null value |
| 26 | What is a `default` method in interface? | A concrete method in interface usable without overriding |
| 27 | What is serialization? | Converting object to byte stream for storage/transmission |
| 28 | What is `transient` keyword? | Fields marked transient are skipped during serialization |
| 29 | What is `volatile` keyword? | Ensures variable read/writes go directly to main memory (visibility) |
| 30 | What is `synchronized` keyword? | Ensures only one thread executes a block/method at a time |
| 31 | What is deadlock? | Two threads waiting on each other's locks forever |
| 32 | What is a daemon thread? | Background thread that dies when main thread dies |
| 33 | What is the difference between `wait()` and `sleep()`? | `wait()` releases lock; `sleep()` doesn't |
| 34 | What is `StringBuilder.reverse()`? | Reverses the characters in the StringBuilder |
| 35 | What is `String.intern()`? | Returns the String from the pool, adding if absent |
| 36 | What does `Collections.synchronizedList()` do? | Wraps list in thread-safe wrapper |
| 37 | What is `Arrays.asList()` limitation? | Fixed-size; cannot add or remove elements |
| 38 | What is JDBC `PreparedStatement`? | Pre-compiled SQL statement with placeholder parameters |
| 39 | What is connection pooling? | Reusing pre-established database connections for efficiency |
| 40 | What is `ResultSet.TYPE_FORWARD_ONLY`? | Cursor can only move forward (default) |
| 41 | What is `var` in Java 10+? | Local variable type inference keyword |
| 42 | What is `record` in Java 16+? | Immutable data class with auto-generated constructor, getters, equals, hashCode |
| 43 | What is `sealed` class? | Class that restricts which classes can extend it (Java 17+) |
| 44 | What is text block? | Multi-line String literal using `"""` (Java 15+) |
| 45 | What is the `instanceof` pattern matching? | `if (obj instanceof String s)` — auto casts (Java 16+) |
| 46 | What is `Math.floorDiv(-7, 2)`? | -4 (floor division, rounds toward negative infinity) |
| 47 | What does `Integer.toBinaryString(10)` return? | "1010" |
| 48 | What is a `WeakHashMap`? | Map where keys are weakly referenced; GC can collect them |
| 49 | What is the output of `"abc" == "abc"`? | true (same string pool reference) |
| 50 | What is the output of `new String("a") == new String("a")`? | false (different heap objects) |

---

# 24. Execution Order Questions (10 Questions)

> These test your understanding of Java's initialization order.

### Q1 – Which order?
```java
class A {
    static { System.out.println("1. Static block"); }
    { System.out.println("2. Instance block"); }
    A() { System.out.println("3. Constructor"); }
}
class B extends A {
    static { System.out.println("4. Child static block"); }
    { System.out.println("5. Child instance block"); }
    B() { System.out.println("6. Child constructor"); }
}
new B();
```
**Output:**
```
1. Static block
4. Child static block
2. Instance block
3. Constructor
5. Child instance block
6. Child constructor
```
> **Rule:** Parent static → Child static → Parent instance+constructor → Child instance+constructor

---

### Q2 – Static block with exception
```java
class Test {
    static int x = 10 / 0; // ArithmeticException during class loading
    public static void main(String[] args) {
        System.out.println("Main");
    }
}
```
**Output:** `ExceptionInInitializerError`

---

### Q3 – Multiple static blocks order
```java
class A {
    static int x;
    static { x = 10; System.out.println("Block 1: x=" + x); }
    static { x = 20; System.out.println("Block 2: x=" + x); }
}
new A(); new A(); new A();
```
**Output:**
```
Block 1: x=10
Block 2: x=20
```
> Static blocks run ONCE only, at class loading.

---

### Q4 – Instance block vs constructor
```java
class A {
    int x;
    { x = 5; System.out.print("IB:" + x + " "); }
    A() { x = 10; System.out.print("C:" + x + " "); }
    A(int y) { x = y; System.out.print("PC:" + x + " "); }
}
new A(); new A(99);
```
**Output:** `IB:5 C:10 IB:5 PC:99 `

---

### Q5 – Final variable initialization
```java
class A {
    final int x;
    { x = 10; }  // Blank final initialized in instance block
    void show() { System.out.println(x); }
}
new A().show();
```
**Output:** `10`

---

### Q6 – this() vs instance block
```java
class A {
    { System.out.println("instance block"); }
    A() { System.out.println("default constructor"); }
    A(int x) {
        this();  // calls default constructor
        System.out.println("parameterized: " + x);
    }
}
new A(5);
```
**Output:**
```
instance block
default constructor
parameterized: 5
```

---

### Q7 – Inheritance initialization
```java
class Parent {
    int x = getX();
    int getX() { return 10; }
}
class Child extends Parent {
    int x = 20;
    int getX() { return 30; } // Overrides Parent's getX()
}
Parent p = new Child();
System.out.println(p.x);
```
**Output:** `10`
> During Parent init, `getX()` is dynamically dispatched to Child's version → x=30. But `p.x` uses reference type (Parent.x = 30 set during init, but p.x returns Parent's field... wait:
> Actually Parent's `x` is set to `getX()` which dispatches to Child's `getX()` → 30. Then Child's x is set to 20. `p.x` references Parent's x = 30.

**Corrected Output:** `30`

---

### Q8 – Tricky autoboxing in collections
```java
List<Integer> list = new ArrayList<>();
list.add(1); list.add(2); list.add(3);
list.remove(1);           // removes by INDEX (1), not VALUE (1)
System.out.println(list);
```
**Output:** `[1, 3]`
> `remove(int index)` used. To remove value 1: `list.remove(Integer.valueOf(1))`

---

### Q9 – String switch fall-through
```java
String s = "A";
switch (s) {
    case "A":
    case "B":
        System.out.println("AB group");
        break;
    case "C":
        System.out.println("C group");
}
```
**Output:** `AB group`

---

### Q10 – Interface default method resolution
```java
interface X { default void greet() { System.out.println("X"); } }
interface Y extends X { default void greet() { System.out.println("Y"); } }
class Z implements X, Y { }
new Z().greet();
```
**Output:** `Y`
> More specific interface (Y extends X) wins — child interface > parent interface.

---

# 25. Advanced Tricky MCQs – Round 3 (Never-Seen-Before)

---

## 25.1 Java Memory & JVM Internals (20 MCQs)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Where are local variables stored? | Heap | Stack | Method area | Registers | **B. Stack** |
| 2 | Where are objects stored? | Stack | Heap | Method area | Code segment | **B. Heap** |
| 3 | Where are static variables stored? | Stack | Heap | Method area (Metaspace) | Both | **C. Method area (Metaspace)** |
| 4 | What is the String constant pool stored in? | Stack | Heap | Native method stack | Code segment | **B. Heap** (moved from PermGen in Java 7) |
| 5 | Which GC algorithm is default in Java 11+? | Serial GC | Parallel GC | G1 GC | ZGC | **C. G1 GC** |
| 6 | `System.gc()` guarantees GC? | Yes | No (suggestion only) | Yes in Java 11+ | Depends on OS | **B. No** |
| 7 | What causes `StackOverflowError`? | Too many objects | Infinite recursion | Too many threads | Large heap | **B. Infinite recursion** |
| 8 | What causes `OutOfMemoryError`? | Too deep recursion | Heap exhausted | Stack overflow | CPU overload | **B. Heap exhausted** |
| 9 | JIT compiler compiles? | Source to bytecode | Bytecode to machine code at runtime | Machine code to bytecode | All at once | **B. Bytecode to machine code at runtime** |
| 10 | `ClassLoader` loads classes from? | Stack | Bytecode (.class) | Source (.java) | RAM | **B. Bytecode (.class)** |
| 11 | Which area holds bytecode? | Stack | Heap | Method area | PC Register | **C. Method area** |
| 12 | PC Register holds? | Object reference | Next instruction address | Return value | Stack pointer | **B. Next instruction address** |
| 13 | How many JVM stacks per thread? | One shared | One per thread | Zero | Depends | **B. One per thread** |
| 14 | `intern()` on String places it in? | Heap | Stack | String pool | Method area | **C. String pool** |
| 15 | What is `Metaspace` (Java 8+)? | Replaces PermGen | Replaces Heap | Extra stack | Cache | **A. Replaces PermGen** |
| 16 | Which reference type allows GC even if referred? | Strong | Soft | Weak | Phantom | **C. Weak** (WeakReference) |
| 17 | Soft reference is collected? | Never | When memory is low | Immediately | On demand | **B. When memory is low** |
| 18 | `finalize()` is deprecated since? | Java 7 | Java 8 | Java 9 | Java 11 | **C. Java 9** |
| 19 | Bytecode file extension is? | .java | .class | .jar | .bc | **B. .class** |
| 20 | WORA stands for? | Write Once Read Anywhere | Write Once Run Anywhere | Work On Real Applications | None | **B. Write Once Run Anywhere** |

---

## 25.2 Wrapper Classes & Autoboxing Traps (15 MCQs)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `Integer.parseInt("10", 2)` returns? | 10 | 2 | Error | 1010 | **B. 2** (parse "10" as binary = 2) |
| 2 | `Integer.toBinaryString(255)` returns? | "ff" | "255" | "11111111" | Error | **C. "11111111"** |
| 3 | `Integer.toHexString(255)` returns? | "ff" | "255" | "11111111" | "0xff" | **A. "ff"** |
| 4 | `Integer.valueOf(127) == Integer.valueOf(127)` | true | false | Error | depends | **A. true** (cached -128 to 127) |
| 5 | `Integer.valueOf(200) == Integer.valueOf(200)` | true | false | Error | depends | **B. false** (outside cache range) |
| 6 | `Integer i = null; int x = i;` causes? | 0 | NullPointerException | Compile error | -1 | **B. NullPointerException** |
| 7 | `Double.isNaN(0.0/0.0)` returns? | false | true | Error | 0 | **B. true** |
| 8 | `Double.isInfinite(1.0/0.0)` returns? | false | true | Error | NaN | **B. true** |
| 9 | `Character.isDigit('5')` returns? | false | true | Error | 5 | **B. true** |
| 10 | `Character.toUpperCase('a')` returns? | 'a' | 'A' | "A" | 65 | **B. 'A'** |
| 11 | Autoboxing of `long` uses? | Long.valueOf() | new Long() | Both | Neither | **A. Long.valueOf()** |
| 12 | Which wrapper has no corresponding primitive? | Integer | Void | Double | Character | **B. Void** (sort of — `void` exists but Void is just a placeholder class) |
| 13 | `Integer.MAX_VALUE` is? | 2^31 | 2^31 - 1 | 2^32 | 2^32 - 1 | **B. 2^31 - 1** (2147483647) |
| 14 | `Integer.MIN_VALUE` is? | -2^31 | -2^31 + 1 | -2^32 | 0 | **A. -2^31** (-2147483648) |
| 15 | `Integer.compare(3, 5)` returns? | -1 | negative value | 0 | positive value | **B. negative value** (-2) |

---

## 25.3 Multithreading & Concurrency (20 MCQs)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Thread states in Java? | New, Running, Dead | New, Runnable, Blocked, Waiting, Timed Waiting, Terminated | New, Sleeping, Dead | Active, Inactive | **B. 6 states** |
| 2 | `thread.start()` calls? | run() directly | JVM schedules run() | main() | init() | **B. JVM schedules run()** |
| 3 | Calling `run()` directly? | Starts new thread | Runs in current thread | Error | Both | **B. Runs in current thread** (no new thread!) |
| 4 | `synchronized` on instance method locks? | Class object | Current instance (this) | Static object | Both | **B. Current instance (this)** |
| 5 | `synchronized` on static method locks? | Instance | Class object (Class<T>) | Both | Neither | **B. Class object** |
| 6 | `wait()` must be called inside? | Any method | synchronized block/method | static method | finally | **B. synchronized block/method** |
| 7 | `notify()` wakes? | All waiting threads | One randomly waiting thread | Current thread | All threads | **B. One randomly waiting thread** |
| 8 | `notifyAll()` wakes? | All waiting threads | One thread | Current thread | Nothing | **A. All waiting threads** |
| 9 | `Thread.sleep()` throws? | IOException | InterruptedException | RuntimeException | Nothing | **B. InterruptedException** |
| 10 | `volatile` keyword guarantees? | Atomicity | Visibility | Both | Ordering only | **B. Visibility** (not atomicity) |
| 11 | `AtomicInteger` provides? | Visibility only | Thread-safe atomic operations | Synchronization | Both A and B | **B. Thread-safe atomic operations** |
| 12 | Which class implements thread-safe counter? | Counter | AtomicInteger | SynchronizedCounter | VolatileCounter | **B. AtomicInteger** |
| 13 | `Callable` vs `Runnable`? | Same | Callable returns value and throws checked exception | Runnable returns value | Both | **B. Callable can return and throw** |
| 14 | `ExecutorService.submit()` returns? | void | Future | Thread | Runnable | **B. Future** |
| 15 | `Future.get()` blocks until? | Thread starts | Task completes | 1 second | Never | **B. Task completes** |
| 16 | `CountDownLatch` is used for? | Mutual exclusion | Wait for N events to happen | Semaphore | Thread pool | **B. Wait for N events** |
| 17 | `ReentrantLock` advantage over `synchronized`? | Simpler | Trylock, fairness, multiple conditions | Faster always | Auto-release | **B. More flexible (tryLock, fairness)** |
| 18 | Thread priority range in Java? | 0-9 | 1-10 | 0-10 | 1-100 | **B. 1-10** |
| 19 | Default thread priority? | 1 | 5 | 10 | 0 | **B. 5** (`Thread.NORM_PRIORITY`) |
| 20 | `join()` makes caller thread? | Sleep | Wait until called thread finishes | Start | Stop | **B. Wait until joined thread finishes** |

---

## 25.4 Java 8+ Features Deep Dive (20 MCQs)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `Stream.of(1,2,3).count()` returns? | int 3 | long 3 | 3.0 | Error | **B. long 3** |
| 2 | `Stream.distinct()` removes? | Nulls | Duplicates (using equals) | Sorted order | Empty | **B. Duplicates** |
| 3 | `Stream.limit(3)` on 10-element stream returns? | Last 3 | First 3 | Random 3 | Error | **B. First 3** |
| 4 | `Stream.skip(2)` skips? | Last 2 | First 2 | Every 2nd | Error | **B. First 2** |
| 5 | `Stream.reduce(0, Integer::sum)` on {1,2,3}? | 0 | 6 | Error | Optional | **B. 6** |
| 6 | `Collectors.joining(",")` on {a,b,c}? | "a b c" | "a,b,c" | [a,b,c] | Error | **B. "a,b,c"** |
| 7 | `Collectors.groupingBy()` returns? | List | Map | Set | Optional | **B. Map** |
| 8 | `Collectors.partitioningBy()` returns? | Map<Boolean,List> | List | Set | Two lists | **A. Map<Boolean, List>** |
| 9 | `Optional.map()` on empty Optional? | Throws | Returns empty Optional | Returns null | Error | **B. Returns empty Optional** |
| 10 | `Optional.flatMap()` difference from `map()`? | Same | flatMap avoids nested Optional | flatMap is terminal | None | **B. Avoids Optional<Optional<T>>** |
| 11 | `Predicate.and()` is? | OR logic | AND logic | NOT logic | XOR logic | **B. AND logic** |
| 12 | `Predicate.negate()` is? | AND | OR | NOT | XOR | **C. NOT** |
| 13 | `Function<T,R>` has method? | apply() | get() | accept() | test() | **A. apply()** |
| 14 | `Consumer<T>` has method? | apply() | get() | accept() | test() | **C. accept()** |
| 15 | `Supplier<T>` has method? | apply() | get() | accept() | test() | **B. get()** |
| 16 | `Predicate<T>` has method? | apply() | get() | accept() | test() | **D. test()** |
| 17 | `BiFunction<T,U,R>` takes? | 1 arg | 2 args | 3 args | 0 args | **B. 2 arguments** |
| 18 | `Stream.peek()` is? | Terminal | Intermediate | Both | Neither | **B. Intermediate** (for debugging) |
| 19 | `Stream.forEach()` is? | Terminal | Intermediate | Both | Neither | **A. Terminal** |
| 20 | `IntStream.range(1,5)` produces? | 1,2,3,4,5 | 1,2,3,4 | 2,3,4,5 | 0,1,2,3,4 | **B. 1,2,3,4** (exclusive end) |

---

## 25.5 Design Patterns MCQs (15 MCQs)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | Singleton ensures? | One method | One object ever | Multiple objects | Thread safety | **B. Only one object** |
| 2 | Factory pattern creates objects? | Directly with new | Through a factory method | Via constructor | Via clone | **B. Through factory method** |
| 3 | Observer pattern is also called? | Listener/Event | Factory | Singleton | Decorator | **A. Listener / Publish-Subscribe** |
| 4 | `Collections.unmodifiableList()` uses which pattern? | Factory | Decorator | Proxy | Observer | **C. Proxy** |
| 5 | Builder pattern is used for? | Thread safety | Creating complex objects step by step | Event handling | Caching | **B. Complex object creation** |
| 6 | Strategy pattern allows? | Class extension | Swapping algorithm at runtime | Thread safety | Logging | **B. Swapping algorithm at runtime** |
| 7 | Template method pattern uses? | Interface | Abstract class | Both | Enum | **B. Abstract class** |
| 8 | Decorator pattern wraps? | Class | Object to add behavior | Method | Field | **B. Object** |
| 9 | `InputStream` wrapping `FileInputStream` is? | Factory | Decorator pattern | Observer | Adapter | **B. Decorator** |
| 10 | Adapter pattern converts? | Objects | One interface to another | Data types | Runtime errors | **B. One interface to another** |
| 11 | Iterator pattern provides? | Random access | Sequential access without exposing internals | Sorted access | Filtered access | **B. Sequential access without internals** |
| 12 | `Comparable.compareTo()` returns? | boolean | int (negative/0/positive) | String | void | **B. int** |
| 13 | `Comparator` is typically? | Embedded in class | External, reusable | In Collection | Static only | **B. External** |
| 14 | `Immutable` class should have? | All setters | All final fields + no setters | Both | Open to extend | **B. Final fields, no setters, final class** |
| 15 | Which Java class exemplifies immutable? | ArrayList | String | StringBuilder | HashMap | **B. String** |

---

## 25.6 String Algorithms MCQs (10 MCQs)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | "racecar" reversed is? | "racecar" | "racecar" (same = palindrome) | "racecra" | Error | **B. "racecar"** (palindrome) |
| 2 | How to check if two strings are anagrams efficiently? | Compare directly | Sort both, compare | Reverse both | Hash both | **B. Sort both and compare** |
| 3 | KMP algorithm is used for? | Sorting | Pattern searching in string | Tree traversal | Graph | **B. Pattern searching** |
| 4 | `"hello world".split("\\s+")` — separator is? | single space | one or more whitespace | tab only | any char | **B. One or more whitespace** |
| 5 | Longest Common Substring uses? | Greedy | Dynamic Programming | Recursion only | Binary Search | **B. Dynamic Programming** |
| 6 | Which is faster: String concat in loop vs StringBuilder? | String concat | StringBuilder | Same | Depends | **B. StringBuilder** (O(n) vs O(n²)) |
| 7 | `"abc".compareTo("ABC")` returns? | 0 | positive | negative | Error | **B. positive** ('a' > 'A' by 32) |
| 8 | `char` comparison: `'z' - 'a'` returns? | 25 | 26 | 122 | 97 | **A. 25** |
| 9 | `"java".contains("")` returns? | false | true | Error | null | **B. true** (every string contains empty string) |
| 10 | Reversing words in "Hello World" gives? | "dlroW olleH" | "World Hello" | "hello world" | Error | **B. "World Hello"** |

---

## 25.7 Collections Deep Dive MCQs (15 MCQs)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `HashMap` stores keys using? | `equals()` only | `hashCode()` + `equals()` | `compareTo()` | `==` | **B. hashCode() + equals()** |
| 2 | `TreeMap` stores keys using? | `hashCode()` | `compareTo()` or `Comparator` | `equals()` | `==` | **B. Comparator or natural ordering** |
| 3 | `LinkedHashSet` orders by? | Natural order | Insertion order | Access order | Random | **B. Insertion order** |
| 4 | `Collections.reverse()` on a List? | Returns new reversed list | Reverses in-place | Error for immutable | Sorts descending | **B. Reverses in-place** |
| 5 | `Collections.swap(list, i, j)` does? | Sort | Swap elements at i and j | Shuffles | Error | **B. Swap at indices i and j** |
| 6 | `Collections.disjoint(c1, c2)` returns true when? | All common | No common elements | Partially common | Both empty | **B. No common elements** |
| 7 | `Collections.max(list)` requires? | Sorted list | Elements implement Comparable | Comparator | Both B and C | **B. Elements implement Comparable** |
| 8 | `TreeSet.floor(x)` returns? | Smallest > x | Largest ≤ x | Smallest ≥ x | Largest < x | **B. Largest ≤ x** |
| 9 | `TreeSet.ceiling(x)` returns? | Largest ≤ x | Smallest ≥ x | Largest < x | Smallest > x | **B. Smallest ≥ x** |
| 10 | `NavigableMap` extends? | Map | SortedMap | HashMap | TreeMap | **B. SortedMap** |
| 11 | `Deque.offerFirst()` equivalent stack method? | pop() | push() | peek() | poll() | **B. push()** |
| 12 | `PriorityQueue.peek()` returns? | Removes min | Views min without removing | Max | null | **B. Views min without removing** |
| 13 | `ConcurrentHashMap` segments (Java 7) for thread safety? | 1 | 16 | 32 | Entire map lock | **B. 16 segments** (Java 7; Java 8 uses CAS) |
| 14 | `Map.merge(key, value, fn)` with existing key does? | Ignores | Replaces | Applies fn to old+new | Removes | **C. Applies BiFunction to old and new value** |
| 15 | `Map.compute(key, fn)` with null result does? | Keeps null | Removes key | Throws | Do nothing | **B. Removes key** |

---

# 26. Hard Output Prediction – Brain Teasers (25 Questions)

### T1
```java
class A {
    void m() { System.out.println("A.m"); }
}
class B extends A {
    void m() { System.out.println("B.m"); }
    void test() {
        super.m();
        this.m();
        m();
    }
}
new B().test();
```
**Output:**
```
A.m
B.m
B.m
```

---

### T2
```java
interface I { int x = 10; }
class A implements I {
    int x = 20;
    void show() {
        System.out.println(x);
        System.out.println(I.x);
        System.out.println(((I)this).x);
    }
}
new A().show();
```
**Output:**
```
20
10
10
```
> Interface fields accessed via interface name.

---

### T3
```java
int x = 10;
int y = (x > 5) ? (x < 15 ? 1 : 2) : (x > 0 ? 3 : 4);
System.out.println(y);
```
**Output:** `1`
> x=10 → x>5 true → x<15 true → 1

---

### T4
```java
public static void main(String[] args) {
    System.out.println(test(1));
}
static String test(int x) {
    try {
        if (x == 1) throw new Exception();
        return "try";
    } catch (Exception e) {
        return "catch";
    } finally {
        return "finally"; // finally overrides return!
    }
}
```
**Output:** `finally`
> `finally` return overrides both try and catch returns.

---

### T5
```java
String a = "A";
String b = "B";
String c = a + b;
String d = "AB";
System.out.println(c == d);
System.out.println(c.equals(d));
```
**Output:**
```
false
true
```
> `c` = runtime concatenation → new object. `d` = literal → pool.

---

### T6
```java
int[] arr = {10, 20, 30, 40, 50};
for (int x : arr) {
    if (x == 30) continue;
    if (x == 40) break;
    System.out.print(x + " ");
}
```
**Output:** `10 20 `
> 30 skipped, loop breaks at 40.

---

### T7
```java
class A {
    A() {
        System.out.println(getClass().getSimpleName());
    }
}
class B extends A { }
new B();
```
**Output:** `B`
> `getClass()` returns the actual runtime class, even in parent constructor.

---

### T8
```java
List<Integer> list = new ArrayList<>(Arrays.asList(1,2,3,4,5));
for (int i = 0; i < list.size(); i++) {
    if (list.get(i) % 2 == 0) list.remove(i);
}
System.out.println(list);
```
**Output:** `[1, 3, 5]`

Wait — removing index 1 (value 2) shifts elements left — index 1 now has 3. i becomes 2, list.get(2)=4, remove it, now: [1,3,5]. i=3 > size=3, stops.

**Output:** `[1, 3, 5]`

---

### T9
```java
class Counter {
    private static int count = 0;
    Counter() { count++; }
    static int getCount() { return count; }
}
Counter c1 = new Counter();
Counter c2 = new Counter();
Counter c3 = c1;
Counter c4 = new Counter();
System.out.println(Counter.getCount());
```
**Output:** `3`
> `c3 = c1` doesn't create new object. Only 3 `new Counter()` calls.

---

### T10
```java
enum Color { RED, GREEN, BLUE }
System.out.println(Color.GREEN.ordinal());
System.out.println(Color.GREEN.name());
System.out.println(Color.values().length);
```
**Output:**
```
1
GREEN
3
```

---

### T11
```java
class A {
    static void greet() { System.out.println("A greet"); }
}
class B extends A {
    static void greet() { System.out.println("B greet"); }
}
A obj = new B();
obj.greet();
```
**Output:** `A greet`
> Static method is hidden, not overridden. Reference type decides.

---

### T12
```java
int i = 1;
switch (i) {
    case 1: System.out.print("one ");
    case 2: System.out.print("two ");
    case 3: System.out.print("three ");
    default: System.out.print("default");
}
```
**Output:** `one two three default`
> No break → falls through all cases.

---

### T13
```java
HashMap<String, Integer> map = new HashMap<>();
map.put("a", 1);
map.put("b", 2);
int sum = 0;
for (int v : map.values()) sum += v;
System.out.println(sum);
```
**Output:** `3`

---

### T14
```java
String s = "Hello";
s.replace('H', 'J');       // Returns new String, not assigned
s = s.replace('e', 'a');   // Assigned
System.out.println(s);
```
**Output:** `Hallo`
> First replace not saved. Second replace changes 'e' → 'a'.

---

### T15
```java
int[][] a = {{1,2},{3,4},{5,6}};
System.out.println(a.length);
System.out.println(a[1].length);
System.out.println(a[2][1]);
```
**Output:**
```
3
2
6
```

---

### T16
```java
abstract class Vehicle {
    abstract void start();
    void stop() { System.out.println("Vehicle stopped"); }
}
class Car extends Vehicle {
    void start() { System.out.println("Car started"); }
}
Vehicle v = new Car();
v.start();
v.stop();
```
**Output:**
```
Car started
Vehicle stopped
```

---

### T17
```java
class Box {
    int val;
    Box(int v) { val = v; }
    public boolean equals(Object o) {
        if (!(o instanceof Box)) return false;
        return this.val == ((Box) o).val;
    }
}
HashSet<Box> set = new HashSet<>();
set.add(new Box(1));
set.add(new Box(1));
System.out.println(set.size());
```
**Output:** `2`
> `equals()` overridden but `hashCode()` NOT overridden — HashSet uses hashCode first. Different hashCodes → different buckets → duplicates allowed!

---

### T18
```java
List<String> words = Arrays.asList("one", "two", "three", "four");
String result = words.stream()
    .filter(w -> w.length() > 3)
    .map(String::toUpperCase)
    .sorted()
    .collect(Collectors.joining(", "));
System.out.println(result);
```
**Output:** `FOUR, THREE`
> "three"(5), "four"(4) → filtered. Uppercased → FOUR, THREE. Sorted alphabetically → FOUR comes before THREE.

---

### T19
```java
int x = 5;
System.out.println(x++ + ++x);
```
**Output:** `12`
> `x++` = 5 (x becomes 6). `++x` = 7 (x becomes 7). 5+7=12.

---

### T20
```java
try {
    int[] arr = new int[-5];
} catch (NegativeArraySizeException e) {
    System.out.println("Caught: " + e.getMessage());
} finally {
    System.out.println("Finally");
}
```
**Output:**
```
Caught: -5
Finally
```

---

### T21
```java
String s = null;
System.out.println("Value: " + s);
System.out.println(s instanceof String);
```
**Output:**
```
Value: null
false
```

---

### T22
```java
class Test {
    int x = 5;
    void modify(Test t) { t.x = 99; }
    void replace(Test t) { t = new Test(); t.x = 100; }
}
Test obj = new Test();
obj.modify(obj);
System.out.println(obj.x); // ?
obj.replace(obj);
System.out.println(obj.x); // ?
```
**Output:**
```
99
99
```
> `modify` changes via reference → obj.x becomes 99. `replace` creates new local Test — original untouched.

---

### T23
```java
StringBuilder sb = new StringBuilder("hello");
sb.insert(2, "XY");
System.out.println(sb);
sb.delete(1, 3);
System.out.println(sb);
```
**Output:**
```
heXYllo
hYllo
```
> `insert(2,"XY")` inserts at index 2: "he" + "XY" + "llo" = "heXYllo". `delete(1,3)` removes indices 1..2 inclusive: removes "eX" → "hYllo".

---

### T24
```java
import java.util.*;
TreeSet<String> ts = new TreeSet<>(String.CASE_INSENSITIVE_ORDER);
ts.add("Banana");
ts.add("apple");
ts.add("Cherry");
ts.add("APPLE"); // duplicate with apple under case-insensitive
System.out.println(ts);
System.out.println(ts.size());
```
**Output:**
```
[apple, Banana, Cherry]
3
```
> APPLE is duplicate of apple under CASE_INSENSITIVE_ORDER. TreeSet deduplicates using comparator.

---

### T25
```java
for (int i = 0; i < 3; i++) {
    int j = i;
    new Thread(() -> System.out.println(j)).start();
}
```
**Output:** (any order) `0`, `1`, `2`
> Lambda captures `j` (effectively final local copy of i). Threads may run in any order.

---

# 27. Advanced Tricky Programs (Programs 41–65)

---

### Program 41: Detect Cycle in String Pattern

```java
public class StringPattern {
    // Check if s can be built by repeating a substring
    static boolean isRepeated(String s) {
        String doubled = s + s;
        // Remove first and last char, check if s is inside
        return doubled.substring(1, doubled.length() - 1).contains(s);
    }

    public static void main(String[] args) {
        System.out.println(isRepeated("abab"));   // true ("ab" repeated)
        System.out.println(isRepeated("abcabc")); // true ("abc" repeated)
        System.out.println(isRepeated("abcde"));  // false
        System.out.println(isRepeated("aaaa"));   // true
    }
}
```

---

### Program 42: Two Sum Problem (HashMap approach)

```java
import java.util.*;

public class TwoSum {
    static int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> map = new HashMap<>(); // value → index
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (map.containsKey(complement)) {
                return new int[]{map.get(complement), i};
            }
            map.put(nums[i], i);
        }
        return new int[]{};
    }

    public static void main(String[] args) {
        int[] result = twoSum(new int[]{2, 7, 11, 15}, 9);
        System.out.println(Arrays.toString(result)); // [0, 1]
        // nums[0] + nums[1] = 2 + 7 = 9 ✓
    }
}
```

---

### Program 43: Longest Substring Without Repeating Characters

```java
import java.util.*;

public class LongestSubstring {
    static int lengthOfLongest(String s) {
        Map<Character, Integer> map = new HashMap<>();
        int maxLen = 0, left = 0;
        for (int right = 0; right < s.length(); right++) {
            char c = s.charAt(right);
            if (map.containsKey(c) && map.get(c) >= left) {
                left = map.get(c) + 1; // Shrink window from left
            }
            map.put(c, right);
            maxLen = Math.max(maxLen, right - left + 1);
        }
        return maxLen;
    }

    public static void main(String[] args) {
        System.out.println(lengthOfLongest("abcabcbb")); // 3 ("abc")
        System.out.println(lengthOfLongest("bbbbb"));    // 1 ("b")
        System.out.println(lengthOfLongest("pwwkew"));   // 3 ("wke")
    }
}
```

---

### Program 44: Quick Sort

```java
import java.util.Arrays;

public class QuickSort {
    static void quickSort(int[] arr, int low, int high) {
        if (low < high) {
            int pivot = partition(arr, low, high);
            quickSort(arr, low, pivot - 1);
            quickSort(arr, pivot + 1, high);
        }
    }

    static int partition(int[] arr, int low, int high) {
        int pivot = arr[high]; // last element as pivot
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if (arr[j] <= pivot) {
                i++;
                int temp = arr[i]; arr[i] = arr[j]; arr[j] = temp;
            }
        }
        int temp = arr[i+1]; arr[i+1] = arr[high]; arr[high] = temp;
        return i + 1;
    }

    public static void main(String[] args) {
        int[] arr = {64, 25, 12, 22, 11};
        quickSort(arr, 0, arr.length - 1);
        System.out.println(Arrays.toString(arr)); // [11, 12, 22, 25, 64]
    }
}
```

---

### Program 45: Merge Sort

```java
import java.util.Arrays;

public class MergeSort {
    static void mergeSort(int[] arr, int left, int right) {
        if (left < right) {
            int mid = (left + right) / 2;
            mergeSort(arr, left, mid);
            mergeSort(arr, mid + 1, right);
            merge(arr, left, mid, right);
        }
    }

    static void merge(int[] arr, int left, int mid, int right) {
        int n1 = mid - left + 1, n2 = right - mid;
        int[] L = Arrays.copyOfRange(arr, left, mid + 1);
        int[] R = Arrays.copyOfRange(arr, mid + 1, right + 1);
        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2)
            arr[k++] = (L[i] <= R[j]) ? L[i++] : R[j++];
        while (i < n1) arr[k++] = L[i++];
        while (j < n2) arr[k++] = R[j++];
    }

    public static void main(String[] args) {
        int[] arr = {38, 27, 43, 3, 9, 82, 10};
        mergeSort(arr, 0, arr.length - 1);
        System.out.println(Arrays.toString(arr)); // [3, 9, 10, 27, 38, 43, 82]
    }
}
```

---

### Program 46: Check if Array is Sorted

```java
public class IsSorted {
    static boolean isSorted(int[] arr) {
        for (int i = 1; i < arr.length; i++) {
            if (arr[i] < arr[i - 1]) return false;
        }
        return true;
    }

    public static void main(String[] args) {
        System.out.println(isSorted(new int[]{1, 2, 3, 4, 5})); // true
        System.out.println(isSorted(new int[]{1, 3, 2, 4, 5})); // false
        System.out.println(isSorted(new int[]{5}));              // true
    }
}
```

---

### Program 47: Count Occurrences of Each Element

```java
import java.util.*;
import java.util.stream.*;

public class ElementCount {
    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 2, 1, 3, 3, 4};
        Map<Integer, Long> freq = Arrays.stream(arr)
            .boxed()
            .collect(Collectors.groupingBy(x -> x, Collectors.counting()));

        freq.entrySet().stream()
            .sorted(Map.Entry.comparingByKey())
            .forEach(e -> System.out.println(e.getKey() + " → " + e.getValue()));
        // 1 → 2
        // 2 → 2
        // 3 → 3
        // 4 → 1
    }
}
```

---

### Program 48: Rotate Array by K positions

```java
import java.util.Arrays;

public class RotateArray {
    static void rotate(int[] arr, int k) {
        k %= arr.length; // Handle k > length
        reverse(arr, 0, arr.length - 1);
        reverse(arr, 0, k - 1);
        reverse(arr, k, arr.length - 1);
    }

    static void reverse(int[] arr, int l, int r) {
        while (l < r) {
            int t = arr[l]; arr[l] = arr[r]; arr[r] = t;
            l++; r--;
        }
    }

    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 4, 5, 6, 7};
        rotate(arr, 3);
        System.out.println(Arrays.toString(arr)); // [5, 6, 7, 1, 2, 3, 4]
    }
}
```

---

### Program 49: Flatten Nested List using Recursion

```java
import java.util.*;

public class FlattenList {
    static List<Integer> flatten(List<?> nested) {
        List<Integer> result = new ArrayList<>();
        for (Object item : nested) {
            if (item instanceof List) {
                result.addAll(flatten((List<?>) item)); // Recurse
            } else {
                result.add((Integer) item);
            }
        }
        return result;
    }

    public static void main(String[] args) {
        List<Object> nested = Arrays.asList(1, Arrays.asList(2, 3, Arrays.asList(4, 5)), 6);
        System.out.println(flatten(nested)); // [1, 2, 3, 4, 5, 6]
    }
}
```

---

### Program 50: Producer-Consumer using wait/notify

```java
import java.util.LinkedList;

public class ProducerConsumer {
    static LinkedList<Integer> buffer = new LinkedList<>();
    static final int CAPACITY = 3;

    static class Producer extends Thread {
        public void run() {
            int value = 0;
            while (true) {
                synchronized (buffer) {
                    while (buffer.size() == CAPACITY) {
                        try { buffer.wait(); } catch (InterruptedException e) { break; }
                    }
                    buffer.add(value);
                    System.out.println("Produced: " + value++);
                    buffer.notifyAll();
                }
                if (value > 5) break;
            }
        }
    }

    static class Consumer extends Thread {
        public void run() {
            int received = 0;
            while (received < 6) {
                synchronized (buffer) {
                    while (buffer.isEmpty()) {
                        try { buffer.wait(); } catch (InterruptedException e) { break; }
                    }
                    System.out.println("Consumed: " + buffer.removeFirst());
                    buffer.notifyAll();
                    received++;
                }
            }
        }
    }

    public static void main(String[] args) throws InterruptedException {
        Thread p = new Producer();
        Thread c = new Consumer();
        p.start(); c.start();
        p.join(); c.join();
    }
}
```

---

### Program 51: Generic Stack Implementation

```java
public class GenericStack<T> {
    private Object[] data;
    private int top;

    GenericStack(int size) {
        data = new Object[size];
        top = -1;
    }

    void push(T item) {
        if (top == data.length - 1) throw new RuntimeException("Stack full");
        data[++top] = item;
    }

    @SuppressWarnings("unchecked")
    T pop() {
        if (top == -1) throw new RuntimeException("Stack empty");
        return (T) data[top--];
    }

    @SuppressWarnings("unchecked")
    T peek() {
        if (top == -1) throw new RuntimeException("Stack empty");
        return (T) data[top];
    }

    boolean isEmpty() { return top == -1; }
    int size() { return top + 1; }

    public static void main(String[] args) {
        GenericStack<Integer> stack = new GenericStack<>(10);
        stack.push(1); stack.push(2); stack.push(3);
        System.out.println(stack.peek()); // 3
        System.out.println(stack.pop());  // 3
        System.out.println(stack.size()); // 2
    }
}
```

---

### Program 52: LRU Cache using LinkedHashMap

```java
import java.util.*;

public class LRUCache<K, V> extends LinkedHashMap<K, V> {
    private final int capacity;

    LRUCache(int capacity) {
        // accessOrder=true: iterate from LRU to MRU
        super(capacity, 0.75f, true);
        this.capacity = capacity;
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
        return size() > capacity; // Remove LRU when full
    }

    public static void main(String[] args) {
        LRUCache<Integer, String> cache = new LRUCache<>(3);
        cache.put(1, "A");
        cache.put(2, "B");
        cache.put(3, "C");
        cache.get(1);          // Access 1 → makes 2 the LRU
        cache.put(4, "D");     // Evicts 2 (LRU)
        System.out.println(cache.containsKey(2)); // false (evicted)
        System.out.println(cache.containsKey(1)); // true
        System.out.println(cache); // {3=C, 1=A, 4=D}
    }
}
```

---

### Program 53: Count Distinct Elements in Window (Sliding Window)

```java
import java.util.*;

public class SlidingWindowDistinct {
    static int[] countDistinct(int[] arr, int k) {
        int n = arr.length;
        int[] result = new int[n - k + 1];
        HashMap<Integer, Integer> map = new HashMap<>();

        // Initialize first window
        for (int i = 0; i < k; i++)
            map.put(arr[i], map.getOrDefault(arr[i], 0) + 1);
        result[0] = map.size();

        for (int i = k; i < n; i++) {
            // Add new element
            map.put(arr[i], map.getOrDefault(arr[i], 0) + 1);
            // Remove outgoing element
            int outgoing = arr[i - k];
            map.put(outgoing, map.get(outgoing) - 1);
            if (map.get(outgoing) == 0) map.remove(outgoing);
            result[i - k + 1] = map.size();
        }
        return result;
    }

    public static void main(String[] args) {
        int[] arr = {1, 2, 1, 3, 4, 2, 3};
        System.out.println(Arrays.toString(countDistinct(arr, 4)));
        // Window: [1,2,1,3]=3, [2,1,3,4]=4, [1,3,4,2]=4, [3,4,2,3]=3
        // Output: [3, 4, 4, 3]
    }
}
```

---

### Program 54: Print All Permutations of a String

```java
import java.util.*;

public class StringPermutations {
    static List<String> permutations = new ArrayList<>();

    static void permute(char[] arr, int start) {
        if (start == arr.length - 1) {
            permutations.add(new String(arr));
            return;
        }
        for (int i = start; i < arr.length; i++) {
            swap(arr, start, i);
            permute(arr, start + 1);
            swap(arr, start, i); // backtrack
        }
    }

    static void swap(char[] arr, int i, int j) {
        char t = arr[i]; arr[i] = arr[j]; arr[j] = t;
    }

    public static void main(String[] args) {
        permute("ABC".toCharArray(), 0);
        permutations.forEach(System.out::println);
        // ABC, ACB, BAC, BCA, CAB, CBA
    }
}
```

---

### Program 55: Custom Exception Hierarchy

```java
// Custom exception hierarchy
class AppException extends RuntimeException {
    AppException(String msg) { super(msg); }
}

class DatabaseException extends AppException {
    DatabaseException(String msg) { super(msg); }
}

class ConnectionException extends DatabaseException {
    int retries;
    ConnectionException(String msg, int retries) {
        super(msg);
        this.retries = retries;
    }
    public String toString() {
        return getMessage() + " (retries=" + retries + ")";
    }
}

public class ExceptionHierarchy {
    static void connectDB() {
        throw new ConnectionException("Cannot reach DB server", 3);
    }

    public static void main(String[] args) {
        try {
            connectDB();
        } catch (ConnectionException e) {
            System.out.println("Connection failed: " + e);
        } catch (DatabaseException e) {
            System.out.println("DB error: " + e.getMessage());
        } catch (AppException e) {
            System.out.println("App error: " + e.getMessage());
        }
    }
}
// Output: Connection failed: Cannot reach DB server (retries=3)
```

---

### Program 56: Functional Interface Chaining

```java
import java.util.function.*;

public class FunctionChaining {
    public static void main(String[] args) {
        Function<String, String> trim = String::trim;
        Function<String, String> upper = String::toUpperCase;
        Function<String, Integer> length = String::length;

        // andThen: compose left to right
        Function<String, Integer> pipeline = trim.andThen(upper).andThen(length);
        System.out.println(pipeline.apply("  hello  ")); // 5

        // compose: right to left
        Function<Integer, Integer> times2 = x -> x * 2;
        Function<Integer, Integer> plus3 = x -> x + 3;
        System.out.println(times2.andThen(plus3).apply(5)); // 13 (5*2)+3
        System.out.println(times2.compose(plus3).apply(5)); // 16 (5+3)*2
    }
}
```

---

### Program 57: Thread-safe Singleton (Double-Checked Locking)

```java
public class ThreadSafeSingleton {
    // volatile prevents partial initialization visibility issue
    private static volatile ThreadSafeSingleton instance;
    private int value;

    private ThreadSafeSingleton() { value = 42; }

    public static ThreadSafeSingleton getInstance() {
        if (instance == null) {              // First check (no lock)
            synchronized (ThreadSafeSingleton.class) {
                if (instance == null) {      // Second check (with lock)
                    instance = new ThreadSafeSingleton();
                }
            }
        }
        return instance;
    }

    public static void main(String[] args) throws InterruptedException {
        // Test from multiple threads
        Runnable task = () -> {
            ThreadSafeSingleton s = ThreadSafeSingleton.getInstance();
            System.out.println(Thread.currentThread().getName() + ": " + s.hashCode());
        };
        Thread t1 = new Thread(task, "T1");
        Thread t2 = new Thread(task, "T2");
        t1.start(); t2.start();
        t1.join();  t2.join();
        // Both threads print SAME hashCode
    }
}
```

---

### Program 58: Matrix Transpose

```java
public class MatrixTranspose {
    static int[][] transpose(int[][] matrix) {
        int rows = matrix.length, cols = matrix[0].length;
        int[][] result = new int[cols][rows];
        for (int i = 0; i < rows; i++)
            for (int j = 0; j < cols; j++)
                result[j][i] = matrix[i][j];
        return result;
    }

    static void print(int[][] m) {
        for (int[] row : m) {
            for (int v : row) System.out.printf("%4d", v);
            System.out.println();
        }
    }

    public static void main(String[] args) {
        int[][] mat = {{1,2,3},{4,5,6}};
        System.out.println("Original:"); print(mat);
        System.out.println("Transposed:"); print(transpose(mat));
        // Original:   Transposed:
        // 1  2  3       1  4
        // 4  5  6       2  5
        //               3  6
    }
}
```

---

### Program 59: Validate Email with Regex

```java
import java.util.regex.*;

public class EmailValidator {
    static boolean isValidEmail(String email) {
        String pattern = "^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$";
        return Pattern.matches(pattern, email);
    }

    public static void main(String[] args) {
        System.out.println(isValidEmail("user@example.com"));    // true
        System.out.println(isValidEmail("user.name+tag@co.in")); // true
        System.out.println(isValidEmail("invalid@"));            // false
        System.out.println(isValidEmail("no-at-sign.com"));      // false
    }
}
```

---

### Program 60: Power of a Number (Fast Exponentiation)

```java
public class FastPower {
    // O(log n) using binary exponentiation
    static long power(long base, long exp, long mod) {
        long result = 1;
        base %= mod;
        while (exp > 0) {
            if ((exp & 1) == 1) result = result * base % mod; // odd exp
            exp >>= 1;      // divide exp by 2
            base = base * base % mod;
        }
        return result;
    }

    public static void main(String[] args) {
        System.out.println(power(2, 10, 1000000007)); // 1024
        System.out.println(power(3, 20, 1000000007)); // 3486784401 % MOD
        System.out.println(power(2, 0, 100));          // 1
    }
}
```

---

### Program 61: Observer Pattern (Event System)

```java
import java.util.*;

interface Observer {
    void update(String event, Object data);
}

class EventBus {
    private Map<String, List<Observer>> listeners = new HashMap<>();

    void subscribe(String event, Observer observer) {
        listeners.computeIfAbsent(event, k -> new ArrayList<>()).add(observer);
    }

    void publish(String event, Object data) {
        List<Observer> obs = listeners.getOrDefault(event, Collections.emptyList());
        obs.forEach(o -> o.update(event, data));
    }
}

public class ObserverDemo {
    public static void main(String[] args) {
        EventBus bus = new EventBus();

        bus.subscribe("LOGIN", (e, d) -> System.out.println("Logger: User logged in - " + d));
        bus.subscribe("LOGIN", (e, d) -> System.out.println("Notifier: Welcome, " + d));
        bus.subscribe("LOGOUT", (e, d) -> System.out.println("Logger: User logged out - " + d));

        bus.publish("LOGIN", "Alice");
        bus.publish("LOGOUT", "Alice");
    }
}
// Logger: User logged in - Alice
// Notifier: Welcome, Alice
// Logger: User logged out - Alice
```

---

### Program 62: Flatten Map with Nested Collections

```java
import java.util.*;
import java.util.stream.*;

public class FlatMapDemo {
    public static void main(String[] args) {
        Map<String, List<String>> courses = new HashMap<>();
        courses.put("Math", Arrays.asList("Algebra", "Calculus", "Statistics"));
        courses.put("Science", Arrays.asList("Physics", "Chemistry"));
        courses.put("Arts", Arrays.asList("Painting", "Music", "Dance"));

        // Flatten all subjects into one sorted list
        List<String> allSubjects = courses.values().stream()
            .flatMap(Collection::stream)
            .sorted()
            .collect(Collectors.toList());

        System.out.println(allSubjects);
        // [Algebra, Calculus, Chemistry, Dance, Music, Painting, Physics, Statistics]
    }
}
```

---

### Program 63: Count Paths in Grid (DP)

```java
public class GridPaths {
    // Count paths from top-left to bottom-right (only right/down moves)
    static int countPaths(int m, int n) {
        int[][] dp = new int[m][n];
        // First row and first column: only one way
        for (int i = 0; i < m; i++) dp[i][0] = 1;
        for (int j = 0; j < n; j++) dp[0][j] = 1;
        // Fill the rest
        for (int i = 1; i < m; i++)
            for (int j = 1; j < n; j++)
                dp[i][j] = dp[i-1][j] + dp[i][j-1];
        return dp[m-1][n-1];
    }

    public static void main(String[] args) {
        System.out.println(countPaths(3, 3)); // 6
        System.out.println(countPaths(3, 7)); // 28
        System.out.println(countPaths(1, 1)); // 1
    }
}
```

---

### Program 64: Builder Pattern

```java
public class Pizza {
    private final String size;
    private final String crust;
    private final boolean cheese;
    private final boolean topings;

    private Pizza(Builder b) {
        this.size = b.size;
        this.crust = b.crust;
        this.cheese = b.cheese;
        this.topings = b.topings;
    }

    public String toString() {
        return "Pizza[size=" + size + ", crust=" + crust +
               ", cheese=" + cheese + ", toppings=" + topings + "]";
    }

    static class Builder {
        private final String size;
        private String crust = "thin";
        private boolean cheese = false;
        private boolean topings = false;

        Builder(String size) { this.size = size; }

        Builder crust(String c) { this.crust = c; return this; }
        Builder cheese(boolean c) { this.cheese = c; return this; }
        Builder toppings(boolean t) { this.topings = t; return this; }
        Pizza build() { return new Pizza(this); }
    }

    public static void main(String[] args) {
        Pizza p = new Pizza.Builder("Large")
            .crust("thick")
            .cheese(true)
            .toppings(true)
            .build();
        System.out.println(p);
        // Pizza[size=Large, crust=thick, cheese=true, toppings=true]
    }
}
```

---

### Program 65: Simulate a Simple Bank System (OOP + Exception)

```java
import java.util.*;

class InsufficientFundsException extends Exception {
    double amount;
    InsufficientFundsException(double amount) {
        super("Insufficient funds. Short by: " + amount);
        this.amount = amount;
    }
}

class BankAccount {
    private final String owner;
    private double balance;
    private List<String> log = new ArrayList<>();

    BankAccount(String owner, double initialBalance) {
        this.owner = owner;
        this.balance = initialBalance;
    }

    void deposit(double amt) {
        if (amt <= 0) throw new IllegalArgumentException("Deposit must be positive");
        balance += amt;
        log.add(String.format("DEPOSIT  +%.2f  BAL: %.2f", amt, balance));
    }

    void withdraw(double amt) throws InsufficientFundsException {
        if (amt <= 0) throw new IllegalArgumentException("Withdrawal must be positive");
        if (amt > balance) throw new InsufficientFundsException(amt - balance);
        balance -= amt;
        log.add(String.format("WITHDRAW -%.2f  BAL: %.2f", amt, balance));
    }

    void transfer(BankAccount target, double amt) throws InsufficientFundsException {
        this.withdraw(amt);
        target.deposit(amt);
        log.add("TRANSFER to " + target.owner + " : " + amt);
    }

    void printStatement() {
        System.out.println("=== Statement for " + owner + " ===");
        log.forEach(System.out::println);
        System.out.printf("Current Balance: %.2f%n", balance);
    }
}

public class BankSystem {
    public static void main(String[] args) {
        BankAccount alice = new BankAccount("Alice", 1000.0);
        BankAccount bob = new BankAccount("Bob", 500.0);
        try {
            alice.deposit(500.0);
            alice.withdraw(200.0);
            alice.transfer(bob, 300.0);
            alice.withdraw(5000.0); // Should fail
        } catch (InsufficientFundsException e) {
            System.out.println("Error: " + e.getMessage());
        }
        alice.printStatement();
        bob.printStatement();
    }
}
```

---

# 28. Exam Day Quick-Fire MCQs (40 Questions — Mixed Difficulty)

| # | Question | A | B | C | D | Answer |
|---|---|---|---|---|---|---|
| 1 | `Object` class is in package? | java.util | java.lang | java.io | java.base | **B. java.lang** |
| 2 | `Iterable` interface has method? | iterator() | hasNext() | next() | forEach() | **A. iterator()** (forEach is default) |
| 3 | `List.copyOf(list)` returns? | Same list | Immutable copy | Sorted copy | null | **B. Immutable copy** |
| 4 | `Map.entry(k,v)` creates? | Mutable entry | Immutable entry | null | Error | **B. Immutable entry** |
| 5 | `String.chars()` returns stream of? | char | Character | int | byte | **C. int** (char codes as IntStream) |
| 6 | `Stream.toList()` (Java 16+) returns? | Mutable list | Immutable list | ArrayList | null | **B. Immutable list** |
| 7 | `record Point(int x, int y){}` — can it extend a class? | Yes | No (extends Record) | Only abstract | Error | **B. No** |
| 8 | `instanceof` pattern `if(o instanceof String s)` — s is? | Available everywhere | Only in if block | Static | Error | **B. Only in true branch** |
| 9 | `switch` expression (Java 14+) uses? | case: | case -> | Both | Neither | **B. case ->** (arrow syntax) |
| 10 | `sealed interface` limits? | Method count | Who implements it | Fields | Access | **B. Who can implement it** |
| 11 | `var x = List.of(1,2);` type of x is? | List | List<Object> | List<Integer> | ArrayList | **C. List<Integer>** (inferred) |
| 12 | `Comparator.reversed()` on `Comparator.naturalOrder()` gives? | Ascending | Descending | Random | Error | **B. Descending** |
| 13 | `String.repeat(3)` on "ab"? | "ababab" | "ab3" | Error | "aabbab" | **A. "ababab"** |
| 14 | `"hello".strip()` vs `"hello".trim()` difference? | Same | strip handles Unicode whitespace | trim handles Unicode | Both | **B. strip() handles Unicode whitespace** |
| 15 | `Map.ofEntries()` creates? | Mutable | Immutable | Sorted | Linked | **B. Immutable** |
| 16 | `Collectors.toUnmodifiableList()` — what Java version? | 8 | 9 | 10 | 11 | **C. Java 10** |
| 17 | `IntStream.rangeClosed(1,5).sum()` returns? | 10 | 15 | 14 | Error | **B. 15** (1+2+3+4+5) |
| 18 | `Stream.generate(() -> 1).limit(3).sum()` type? | Not valid | 3 | IntStream needed | Error | **C. Need mapToInt or IntStream** — on Object stream: `sum()` doesn't exist unless IntStream. Error if `Stream<Integer>`. Use `mapToInt(x->x).sum()` |
| 19 | `Files.readAllLines(path)` returns? | String | String[] | List<String> | Stream | **C. List<String>** |
| 20 | Can `try` block be nested? | Yes | No | Only Java 9+ | Error | **A. Yes** |
| 21 | `throw` keyword can throw? | Any object | Only Exception subclass | Only Throwable subclass | Only checked | **C. Only Throwable subclass** |
| 22 | Can `interface` have `protected` methods? | Yes | No | Java 9+ | Only default | **B. No** (interface methods are public or private) |
| 23 | `abstract class` without any `abstract` method is? | Error | Valid | Warning | Interface | **B. Valid** |
| 24 | Annotation `@Override` — checked at? | Runtime | Compile time | Both | Never | **B. Compile time** |
| 25 | `Math.ceil(2.1)` returns? | 2.0 | 3.0 | 2.1 | 3 | **B. 3.0** |
| 26 | `Math.floor(-2.1)` returns? | -2.0 | -3.0 | -2.1 | 3 | **B. -3.0** |
| 27 | `Math.abs(Integer.MIN_VALUE)` returns? | Positive max | Negative (overflow) | 0 | Error | **B. Negative** (Integer.MIN_VALUE — overflow) |
| 28 | `"123abc".matches("\\d+")` returns? | true | false | Error | null | **B. false** (must match entire string) |
| 29 | `Pattern.compile()` caches pattern? | Yes (use it) | No | JVM decides | Error | **A. Yes — reuse compiled pattern for performance** |
| 30 | `String.format("%.2f", 3.14159)` returns? | "3.14159" | "3.14" | "3.1" | Error | **B. "3.14"** |
| 31 | `System.identityHashCode(obj)` returns? | Overridden hashCode | Original Object hashCode | null | Class hash | **B. Original Object.hashCode()** |
| 32 | `Object.wait()` releases? | CPU | Object monitor lock | All locks | Nothing | **B. Object monitor lock** |
| 33 | `Thread.yield()` does? | Sleep 1ms | Hint to scheduler to give up CPU | Stop thread | Release lock | **B. Hint to yield CPU** |
| 34 | `ExecutorService.shutdown()` vs `shutdownNow()`? | Same | shutdown waits; shutdownNow interrupts | shutdownNow waits | shutdown interrupts | **B. shutdown completes running tasks; shutdownNow interrupts** |
| 35 | `Callable` is in package? | java.lang | java.util.concurrent | java.util | java.thread | **B. java.util.concurrent** |
| 36 | `CompletableFuture.supplyAsync()` runs on? | Main thread | ForkJoinPool | New thread always | Current thread | **B. ForkJoinPool** (default) |
| 37 | `HashMap.putIfAbsent()` returns? | null always | Old value if exists, null if absent | New value | boolean | **B. Old value if present, else null** |
| 38 | `Map.replace(key, oldVal, newVal)` — conditional replace? | Yes | No — always replaces | No — never | Error | **A. Yes — only if current value == oldVal** |
| 39 | `Collections.checkedList(list, String.class)` prevents? | Null addition | Wrong type insertion at runtime | Duplicates | Sorting | **B. Wrong type insertion** (type-safe wrapper) |
| 40 | `IdentityHashMap` uses for key comparison? | equals() | == (reference equality) | hashCode() | compareTo() | **B. == (reference equality)** |

---

# 29. Common Coding Patterns – Quick Reference

## Pattern 1: Sliding Window

```java
// Max sum of subarray of size k
static int maxSumWindow(int[] arr, int k) {
    int windowSum = 0, maxSum = 0;
    for (int i = 0; i < k; i++) windowSum += arr[i];
    maxSum = windowSum;
    for (int i = k; i < arr.length; i++) {
        windowSum += arr[i] - arr[i - k]; // slide
        maxSum = Math.max(maxSum, windowSum);
    }
    return maxSum;
}
// arr={2,3,4,1,5}, k=3 → max(9, 8, 10) = 10
```

## Pattern 2: Two Pointer

```java
// Check if sorted array has pair summing to target
static boolean hasPairSum(int[] sorted, int target) {
    int left = 0, right = sorted.length - 1;
    while (left < right) {
        int sum = sorted[left] + sorted[right];
        if (sum == target) return true;
        else if (sum < target) left++;
        else right--;
    }
    return false;
}
```

## Pattern 3: HashMap Frequency Counter

```java
// Count frequency of any element type
static <T> Map<T, Integer> frequency(T[] arr) {
    Map<T, Integer> map = new LinkedHashMap<>();
    for (T item : arr) map.merge(item, 1, Integer::sum);
    return map;
}
```

## Pattern 4: Recursive Backtracking Template

```java
static void backtrack(List<Integer> current, /* other params */) {
    if (/* base condition */) {
        // record solution
        return;
    }
    for (/* each choice */) {
        current.add(choice);       // choose
        backtrack(current, ...);   // explore
        current.remove(...);       // un-choose (backtrack)
    }
}
```

## Pattern 5: DP Memoization Template

```java
static Map<String, Integer> memo = new HashMap<>();

static int solve(int a, int b) {
    String key = a + "," + b;
    if (memo.containsKey(key)) return memo.get(key);
    int result = /* recursive computation */;
    memo.put(key, result);
    return result;
}
```

---

# 30. Interview Question Bank – Theory (30 Questions)

| # | Question | Answer Summary |
|---|---|---|
| 1 | Why is Java platform independent? | Compiled to bytecode run by JVM on any OS |
| 2 | What is JIT compiler? | Converts bytecode to native machine code at runtime for performance |
| 3 | Difference: Abstract class vs Interface? | Abstract can have state/constructors; interface for pure contract; multiple interface inheritance |
| 4 | When to use ArrayList vs LinkedList? | ArrayList for random access; LinkedList for frequent insert/delete at ends |
| 5 | What is the contract between equals() and hashCode()? | Equal objects MUST have same hashCode; same hashCode doesn't imply equality |
| 6 | What is immutability? How to create immutable class? | final class, final fields, no setters, deep copy in constructor/getters |
| 7 | What is fail-fast vs fail-safe iterator? | Fail-fast throws ConcurrentModificationException; fail-safe works on copy |
| 8 | What is autoboxing pitfall? | NullPointerException when unboxing null Integer; performance overhead in loops |
| 9 | What is String interning? | `intern()` returns canonical copy from pool; saves memory for repeated strings |
| 10 | Why override both equals() and hashCode()? | HashMap/HashSet reliability; Java contract requirement |
| 11 | What is diamond inheritance problem in Java? | Two parent interfaces have same default method; child must explicitly override |
| 12 | Explain dynamic dispatch | JVM calls overridden method of actual object type at runtime |
| 13 | What is covariant return type? | Subclass override can return subtype (e.g., return Dog instead of Animal) |
| 14 | Difference: throw vs throws? | throw: actual exception object; throws: method signature declaration |
| 15 | What is try-with-resources? | Auto-calls close() on AutoCloseable; cleaner than finally block |
| 16 | What is checked vs unchecked exception? | Checked: compile-time enforced; unchecked: RuntimeException subclasses |
| 17 | What is volatile? | Ensures fresh read from main memory; doesn't guarantee atomicity |
| 18 | Difference: synchronized vs ReentrantLock? | synchronized is simpler; ReentrantLock has tryLock, fairness, multiple conditions |
| 19 | What is deadlock? How to prevent? | Circular lock wait; prevent by consistent lock ordering or timeout |
| 20 | What is thread-local storage? | `ThreadLocal<T>` gives each thread its own variable copy |
| 21 | What is connection pooling in JDBC? | Reuse connections; avoids expensive Connection creation per request |
| 22 | PreparedStatement vs Statement? | PreparedStatement is precompiled, parameterized, SQL-injection safe, faster for repeat |
| 23 | What is lazy initialization? | Create object only when first accessed (Singleton pattern) |
| 24 | What is a functional interface? | Has exactly one abstract method; can use lambda/method reference |
| 25 | Difference: map() vs flatMap() in Streams? | map: one-to-one transform; flatMap: one-to-many, flattens nested stream |
| 26 | What is Optional? Why use it? | Container for nullable value; avoids NullPointerException explicitly |
| 27 | What is method reference? Types? | `::` operator — static, instance, constructor, arbitrary instance |
| 28 | What is HashMap internal structure (Java 8+)? | Array of buckets; each bucket is LinkedList that converts to Red-Black Tree at threshold 8 |
| 29 | What happens when HashMap exceeds load factor? | Rehashing: new array of double size, all entries re-inserted |
| 30 | What is `Comparable` vs `Comparator`? | Comparable: natural order built into class; Comparator: external, multiple orderings |

---

*This document is part of the Java Complete Learning Guide series.*
*Last updated: March 2026*
