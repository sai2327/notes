# 02. Java Basics

## Table of Contents
- [2.1 Data Types](#21-data-types)
- [2.2 Variables and Scope](#22-variables-and-scope)
- [2.3 Operators](#23-operators)
- [2.4 Type Casting](#24-type-casting)
- [2.5 Control Statements](#25-control-statements)
- [2.6 Loops](#26-loops)
- [2.7 Practice & Assessment](#27-practice--assessment)

---

## 2.1 Data Types

### Primitive Data Types

| Type | Size | Default | Range | Example |
|------|------|---------|-------|---------|
| `byte` | 1 byte | 0 | -128 to 127 | `byte b = 100;` |
| `short` | 2 bytes | 0 | -32,768 to 32,767 | `short s = 30000;` |
| `int` | 4 bytes | 0 | -2³¹ to 2³¹-1 | `int x = 100000;` |
| `long` | 8 bytes | 0L | -2⁶³ to 2⁶³-1 | `long l = 99999L;` |
| `float` | 4 bytes | 0.0f | ~7 decimal digits | `float f = 3.14f;` |
| `double` | 8 bytes | 0.0d | ~15 decimal digits | `double d = 3.14159;` |
| `char` | 2 bytes | '\u0000' | 0 to 65,535 (Unicode) | `char c = 'A';` |
| `boolean` | 1 bit* | false | true or false | `boolean b = true;` |

### Non-Primitive (Reference) Types
- **String** — `String name = "Alice";`
- **Array** — `int[] arr = {1, 2, 3};`
- **Class** — `Scanner sc = new Scanner(System.in);`
- **Interface** — references to interface implementations

### Primitive vs Non-Primitive

| Primitive | Non-Primitive |
|-----------|--------------|
| Stores actual value | Stores memory address (reference) |
| Predefined by Java | Defined by programmer (except String) |
| Starts lowercase (`int`) | Starts uppercase (`String`) |
| Cannot be null | Can be null |
| Fixed size | Variable size |

```java
int x = 10;              // primitive — stores 10 directly
String s = "Hello";      // reference — stores address pointing to "Hello"
```

---

## 2.2 Variables and Scope

### Types of Variables

```java
public class VariableTypes {
    // Instance variable (belongs to object)
    int instanceVar = 10;
    
    // Static variable (belongs to class, shared by all objects)
    static int staticVar = 20;
    
    public void method() {
        // Local variable (exists only inside method)
        int localVar = 30;
        System.out.println(localVar);
    }
}
```

| Variable Type | Where Declared | Scope | Default Value |
|--------------|----------------|-------|---------------|
| Local | Inside method/block | That method/block only | None (must initialize) |
| Instance | Inside class, outside method | Entire object | Type default (0, null, false) |
| Static | With `static` keyword | Entire class | Type default |

### Naming Rules
- Start with letter, `_`, or `$`
- Cannot start with digit
- Cannot use Java keywords (`int`, `class`, etc.)
- Case-sensitive (`name` ≠ `Name`)
- Convention: camelCase (`firstName`, `totalAmount`)

### Common Mistake

```java
public void test() {
    System.out.println(x);  // ERROR: x not yet declared
    int x = 5;
}
```

---

## 2.3 Operators

### Arithmetic Operators

```java
int a = 10, b = 3;
System.out.println(a + b);   // 13 (addition)
System.out.println(a - b);   // 7  (subtraction)
System.out.println(a * b);   // 30 (multiplication)
System.out.println(a / b);   // 3  (integer division — truncates!)
System.out.println(a % b);   // 1  (modulus — remainder)
```

> ⚠️ **Common Mistake:** `10 / 3 = 3` (not 3.33)! For decimal result: `10.0 / 3 = 3.333...`

### Relational Operators

```java
int x = 5, y = 10;
System.out.println(x == y);  // false
System.out.println(x != y);  // true
System.out.println(x > y);   // false
System.out.println(x < y);   // true
System.out.println(x >= 5);  // true
System.out.println(x <= 4);  // false
```

### Logical Operators

```java
boolean a = true, b = false;
System.out.println(a && b);  // false (AND — both must be true)
System.out.println(a || b);  // true  (OR — at least one true)
System.out.println(!a);      // false (NOT — inverts)
```

### Assignment Operators

```java
int x = 10;
x += 5;   // x = x + 5 → 15
x -= 3;   // x = x - 3 → 12
x *= 2;   // x = x * 2 → 24
x /= 4;   // x = x / 4 → 6
x %= 4;   // x = x % 4 → 2
```

### Increment / Decrement

```java
int a = 5;
System.out.println(a++);  // 5 (prints THEN increments → a becomes 6)
System.out.println(++a);  // 7 (increments THEN prints)
System.out.println(a--);  // 7 (prints THEN decrements → a becomes 6)
System.out.println(--a);  // 5 (decrements THEN prints)
```

### Ternary Operator

```java
int age = 20;
String result = (age >= 18) ? "Adult" : "Minor";
System.out.println(result);  // Adult
```

---

## 2.4 Type Casting

### Widening (Automatic) — Small → Large

```java
int x = 100;
double d = x;    // Automatic: int → double
System.out.println(d);  // 100.0

// byte → short → int → long → float → double
```

### Narrowing (Manual) — Large → Small

```java
double d = 9.78;
int x = (int) d;    // Manual cast required
System.out.println(x);  // 9 (decimal part lost!)

// Potential data loss!
int big = 130;
byte b = (byte) big;  // b = -126 (overflow!)
```

---

## 2.5 Control Statements

### if / else if / else

```java
int marks = 75;

if (marks >= 90) {
    System.out.println("Grade: A");
} else if (marks >= 75) {
    System.out.println("Grade: B");
} else if (marks >= 60) {
    System.out.println("Grade: C");
} else {
    System.out.println("Grade: F");
}
// Output: Grade: B
```

### switch Statement

```java
int day = 3;

switch (day) {
    case 1:
        System.out.println("Monday");
        break;
    case 2:
        System.out.println("Tuesday");
        break;
    case 3:
        System.out.println("Wednesday");
        break;
    default:
        System.out.println("Other day");
}
// Output: Wednesday
```

### Enhanced switch (Java 14+)

```java
int day = 3;
String name = switch (day) {
    case 1 -> "Monday";
    case 2 -> "Tuesday";
    case 3 -> "Wednesday";
    default -> "Other";
};
System.out.println(name);  // Wednesday
```

### Common Mistake — Missing break

```java
int x = 2;
switch (x) {
    case 1:
        System.out.println("One");
    case 2:
        System.out.println("Two");    // Prints
    case 3:
        System.out.println("Three");  // Also prints! (fall-through)
}
// Output:
// Two
// Three
// ← Without break, execution "falls through" to next cases!
```

---

## 2.6 Loops

### for Loop

```java
// Print 1 to 5
for (int i = 1; i <= 5; i++) {
    System.out.println(i);
}
// Output: 1 2 3 4 5

// Structure:
// for (initialization; condition; update) { body }
```

### while Loop

```java
// Print 1 to 5
int i = 1;
while (i <= 5) {
    System.out.println(i);
    i++;
}
```

### do-while Loop

```java
// Executes at least ONCE (checks condition after)
int i = 10;
do {
    System.out.println(i);  // Prints 10 even though condition is false
    i++;
} while (i <= 5);
// Output: 10
```

### for-each (Enhanced for)

```java
int[] numbers = {10, 20, 30, 40, 50};
for (int num : numbers) {
    System.out.println(num);
}
// Output: 10 20 30 40 50
```

### Loop Comparison

| Loop | When to Use |
|------|-------------|
| `for` | Known number of iterations |
| `while` | Unknown iterations, check condition first |
| `do-while` | Execute at least once, then check |
| `for-each` | Iterate over array/collection |

### break and continue

```java
// break — exit loop
for (int i = 1; i <= 10; i++) {
    if (i == 5) break;
    System.out.print(i + " ");
}
// Output: 1 2 3 4

// continue — skip current iteration
for (int i = 1; i <= 5; i++) {
    if (i == 3) continue;
    System.out.print(i + " ");
}
// Output: 1 2 4 5
```

### Nested Loops — Pattern Example

```java
// Right triangle pattern
for (int i = 1; i <= 5; i++) {
    for (int j = 1; j <= i; j++) {
        System.out.print("* ");
    }
    System.out.println();
}
// Output:
// *
// * *
// * * *
// * * * *
// * * * * *
```

---

## 2.7 Practice & Assessment

### MCQs

**Q1.** What is the output of `System.out.println(10 / 3);`?
- A) 3.33
- B) 3
- C) 4
- D) Error

**Answer:** B — Integer division truncates the decimal.

---

**Q2.** What is the output?
```java
int x = 5;
System.out.println(x++ + ++x);
```
- A) 10
- B) 11
- C) 12
- D) 13

**Answer:** C — `x++` uses 5 (then x=6), `++x` makes x=7 and uses 7. So 5+7=12.

---

**Q3.** Which loop executes at least once?
- A) for
- B) while
- C) do-while
- D) for-each

**Answer:** C — do-while checks condition after execution.

---

### Output Prediction

```java
int a = 10;
if (a > 5)
    System.out.println("A");
    System.out.println("B");  // Not inside if! (no braces)
```
**Output:**
```
A
B
```
> Without braces, only the first statement is inside `if`. "B" always prints.

---

### Coding Tasks

**Task 1:** Print all even numbers from 1 to 50.

```java
for (int i = 2; i <= 50; i += 2) {
    System.out.print(i + " ");
}
```

**Task 2:** Find the factorial of a number.

```java
int n = 5;
long factorial = 1;
for (int i = 1; i <= n; i++) {
    factorial *= i;
}
System.out.println("Factorial of " + n + " = " + factorial);
// Output: Factorial of 5 = 120
```

**Task 3:** Check if a number is prime.

```java
int num = 17;
boolean isPrime = true;

if (num <= 1) {
    isPrime = false;
} else {
    for (int i = 2; i <= Math.sqrt(num); i++) {
        if (num % i == 0) {
            isPrime = false;
            break;
        }
    }
}
System.out.println(num + " is prime: " + isPrime);
// Output: 17 is prime: true
```

---

> **Next Topic:** [03 - Arrays and Strings](03-arrays-and-strings.md)
