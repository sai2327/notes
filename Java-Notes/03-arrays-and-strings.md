# 03. Arrays and Strings

## Table of Contents
- [3.1 Arrays — 1D](#31-arrays--1d)
- [3.2 Arrays — 2D](#32-arrays--2d)
- [3.3 String Class](#33-string-class)
- [3.4 String Methods](#34-string-methods)
- [3.5 StringBuilder and StringBuffer](#35-stringbuilder-and-stringbuffer)
- [3.6 Practice & Assessment](#36-practice--assessment)

---

## 3.1 Arrays — 1D

### Definition
An **array** is a fixed-size container that holds multiple values of the same data type in contiguous memory.

### Declaration and Initialization

```java
// Method 1: Declare then allocate
int[] arr;
arr = new int[5];  // [0, 0, 0, 0, 0] — default values

// Method 2: Declare and allocate
int[] arr = new int[5];

// Method 3: Declare and initialize
int[] arr = {10, 20, 30, 40, 50};

// Method 4: With new keyword
int[] arr = new int[]{10, 20, 30, 40, 50};
```

### Accessing Elements

```java
int[] arr = {10, 20, 30, 40, 50};

System.out.println(arr[0]);    // 10 (first element)
System.out.println(arr[4]);    // 50 (last element)
System.out.println(arr.length); // 5

arr[2] = 99;                   // Modify element
System.out.println(arr[2]);    // 99
```

### Traversing Array

```java
int[] arr = {10, 20, 30, 40, 50};

// Using for loop
for (int i = 0; i < arr.length; i++) {
    System.out.print(arr[i] + " ");
}
// Output: 10 20 30 40 50

// Using for-each
for (int num : arr) {
    System.out.print(num + " ");
}
// Output: 10 20 30 40 50
```

### Common Operations

```java
import java.util.Arrays;

int[] arr = {50, 10, 40, 20, 30};

// Sort
Arrays.sort(arr);
System.out.println(Arrays.toString(arr));  // [10, 20, 30, 40, 50]

// Binary search (array must be sorted)
int index = Arrays.binarySearch(arr, 30);
System.out.println(index);  // 2

// Fill
int[] filled = new int[5];
Arrays.fill(filled, 7);
System.out.println(Arrays.toString(filled));  // [7, 7, 7, 7, 7]

// Copy
int[] copy = Arrays.copyOf(arr, 3);
System.out.println(Arrays.toString(copy));  // [10, 20, 30]
```

### Common Mistake

```java
int[] arr = new int[5];
System.out.println(arr[5]);  // ArrayIndexOutOfBoundsException!
// Valid indices: 0 to 4 (length - 1)
```

---

## 3.2 Arrays — 2D

### Declaration

```java
// 2D array (matrix)
int[][] matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

// Accessing
System.out.println(matrix[0][0]);  // 1 (row 0, col 0)
System.out.println(matrix[1][2]);  // 6 (row 1, col 2)
System.out.println(matrix.length);      // 3 (rows)
System.out.println(matrix[0].length);   // 3 (columns in row 0)
```

### Traversing 2D Array

```java
int[][] matrix = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};

for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
        System.out.print(matrix[i][j] + " ");
    }
    System.out.println();
}
// Output:
// 1 2 3
// 4 5 6
// 7 8 9
```

### Jagged Array (Rows with different lengths)

```java
int[][] jagged = new int[3][];
jagged[0] = new int[]{1, 2};
jagged[1] = new int[]{3, 4, 5};
jagged[2] = new int[]{6};
```

---

## 3.3 String Class

### Definition
A **String** in Java is an immutable sequence of characters. Once created, it cannot be modified.

### Creating Strings

```java
// String literal (stored in String Pool)
String s1 = "Hello";
String s2 = "Hello";   // Same reference as s1 (from pool)

// Using new keyword (stored in heap)
String s3 = new String("Hello");  // Different object

// Comparison
System.out.println(s1 == s2);      // true (same pool reference)
System.out.println(s1 == s3);      // false (different objects!)
System.out.println(s1.equals(s3)); // true (same content)
```

### String Pool

```
┌──────────────────────────────────┐
│           Heap Memory            │
│  ┌────────────────────────────┐  │
│  │      String Pool           │  │
│  │   ┌─────────────────┐     │  │
│  │   │  "Hello"        │◄─── s1, s2 point here  │
│  │   └─────────────────┘     │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌─────────────────┐            │
│  │  "Hello"        │◄─── s3 points here (separate object)
│  └─────────────────┘            │
└──────────────────────────────────┘
```

> **Interview Tip:** `==` checks reference equality. `.equals()` checks content equality. Always use `.equals()` for String comparison!

---

## 3.4 String Methods

| Method | Description | Example | Output |
|--------|-------------|---------|--------|
| `length()` | String length | `"Hello".length()` | `5` |
| `charAt(i)` | Character at index | `"Hello".charAt(1)` | `'e'` |
| `substring(start)` | From start to end | `"Hello".substring(2)` | `"llo"` |
| `substring(s, e)` | From s to e-1 | `"Hello".substring(1,4)` | `"ell"` |
| `toUpperCase()` | Convert to uppercase | `"hello".toUpperCase()` | `"HELLO"` |
| `toLowerCase()` | Convert to lowercase | `"HELLO".toLowerCase()` | `"hello"` |
| `trim()` | Remove leading/trailing spaces | `" hi ".trim()` | `"hi"` |
| `contains(s)` | Check if contains | `"Hello".contains("ell")` | `true` |
| `startsWith(s)` | Starts with prefix | `"Hello".startsWith("He")` | `true` |
| `endsWith(s)` | Ends with suffix | `"Hello".endsWith("lo")` | `true` |
| `indexOf(s)` | First occurrence index | `"Hello".indexOf("l")` | `2` |
| `lastIndexOf(s)` | Last occurrence index | `"Hello".lastIndexOf("l")` | `3` |
| `replace(old,new)` | Replace characters | `"Hello".replace('l','x')` | `"Hexxo"` |
| `split(regex)` | Split into array | `"a,b,c".split(",")` | `["a","b","c"]` |
| `equals(s)` | Content comparison | `"Hi".equals("hi")` | `false` |
| `equalsIgnoreCase(s)` | Ignore case compare | `"Hi".equalsIgnoreCase("hi")` | `true` |
| `isEmpty()` | Check if empty | `"".isEmpty()` | `true` |
| `concat(s)` | Concatenate | `"Hello".concat(" World")` | `"Hello World"` |

### Detailed Examples

```java
String str = "Java Programming";

// Length
System.out.println(str.length());          // 16

// Character extraction
System.out.println(str.charAt(0));         // 'J'
System.out.println(str.charAt(5));         // 'P'

// Substring
System.out.println(str.substring(5));      // "Programming"
System.out.println(str.substring(0, 4));   // "Java"

// Search
System.out.println(str.indexOf("Pro"));    // 5
System.out.println(str.contains("gram"));  // true

// Replace
System.out.println(str.replace("Java", "Python")); // "Python Programming"

// Split
String csv = "apple,banana,cherry";
String[] fruits = csv.split(",");
for (String f : fruits) {
    System.out.println(f);
}
// Output: apple  banana  cherry

// String to char array
char[] chars = str.toCharArray();

// Char array to String
String fromChars = new String(chars);
```

### String Immutability

```java
String s = "Hello";
s.concat(" World");          // Creates new String, but s still points to "Hello"
System.out.println(s);       // "Hello" (unchanged!)

s = s.concat(" World");      // Now s points to new String
System.out.println(s);       // "Hello World"
```

---

## 3.5 StringBuilder and StringBuffer

### Why Not String for Frequent Modifications?

```java
// BAD: Creates many objects in memory
String s = "";
for (int i = 0; i < 1000; i++) {
    s += i;  // Creates new String object each time!
}

// GOOD: Uses single mutable object
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 1000; i++) {
    sb.append(i);  // Modifies same object
}
String result = sb.toString();
```

### StringBuilder Methods

```java
StringBuilder sb = new StringBuilder("Hello");

sb.append(" World");       // "Hello World"
sb.insert(5, ",");         // "Hello, World"
sb.replace(0, 5, "Hi");   // "Hi, World"
sb.delete(2, 4);           // "Hi World"
sb.reverse();              // "dlroW iH"
sb.deleteCharAt(0);        // "lroW iH"

String result = sb.toString();  // Convert to String
```

### String vs StringBuilder vs StringBuffer

| Feature | String | StringBuilder | StringBuffer |
|---------|--------|---------------|--------------|
| Mutable? | No (immutable) | Yes | Yes |
| Thread-safe? | Yes (immutable) | No | Yes (synchronized) |
| Performance | Slow (many objects) | Fast | Moderate |
| When to use | Few modifications | Single-threaded | Multi-threaded |

---

## 3.6 Practice & Assessment

### MCQs

**Q1.** What is the output?
```java
String s1 = "Java";
String s2 = new String("Java");
System.out.println(s1 == s2);
```
- A) true
- B) false
- C) Error
- D) null

**Answer:** B — `==` compares references. `s1` is in String Pool, `s2` is a new heap object.

---

**Q2.** What does `"Hello".substring(1, 3)` return?
- A) "Hel"
- B) "el"
- C) "ell"
- D) "ello"

**Answer:** B — substring(1, 3) returns characters at index 1 and 2 (end is exclusive).

---

**Q3.** Arrays in Java are:
- A) Dynamic in size
- B) Fixed in size after creation
- C) Can hold different types
- D) Not objects

**Answer:** B — Array size is fixed once created.

---

### Coding Tasks

**Task 1:** Reverse a String without using built-in reverse.

```java
String str = "Hello";
String reversed = "";
for (int i = str.length() - 1; i >= 0; i--) {
    reversed += str.charAt(i);
}
System.out.println(reversed);  // "olleH"

// Better with StringBuilder:
String reversed2 = new StringBuilder(str).reverse().toString();
```

**Task 2:** Find duplicate characters in a String.

```java
String str = "programming";
for (int i = 0; i < str.length(); i++) {
    int count = 0;
    for (int j = 0; j < str.length(); j++) {
        if (str.charAt(i) == str.charAt(j)) {
            count++;
        }
    }
    if (count > 1 && str.indexOf(str.charAt(i)) == i) {
        System.out.println(str.charAt(i) + " = " + count);
    }
}
// Output: r = 2, g = 2, m = 2
```

**Task 3:** Find the largest element in an array.

```java
int[] arr = {23, 55, 12, 99, 47};
int max = arr[0];
for (int i = 1; i < arr.length; i++) {
    if (arr[i] > max) {
        max = arr[i];
    }
}
System.out.println("Max: " + max);  // Max: 99
```

---

> **Next Topic:** [04 - OOP Basics](04-oop-basics.md)
