# 📘 Java Basics – Complete Guide (Beginner Level)

> **From zero to confident Java programmer. Learn, revise, and ace interviews.**

---

# Table of Contents

- [1. Introduction to Java](#1-introduction-to-java)
- [2. Java Setup](#2-java-setup)
- [3. Variables](#3-variables)
- [4. Data Types](#4-data-types)
- [5. Type Casting](#5-type-casting)
- [6. Operators](#6-operators)
- [7. Scanner (User Input)](#7-scanner-user-input)
- [8. Comments](#8-comments)
- [9. Keywords](#9-keywords)
- [10. Naming Conventions](#10-naming-conventions)
- [11. Control Flow – if / else / nested if](#11-control-flow--if--else--nested-if)
- [12. Switch Statement](#12-switch-statement)
- [13. Loops – for / while / do-while](#13-loops--for--while--do-while)
- [14. Break and Continue](#14-break-and-continue)
- [15. Methods](#15-methods)
- [16. Arrays](#16-arrays)
- [17. Strings](#17-strings)

---

# 1. Introduction to Java

## Concept Explanation

Java is a **high-level, object-oriented, platform-independent** programming language developed by **James Gosling** at **Sun Microsystems** in **1995**. It was later acquired by **Oracle Corporation** in 2010.

Java follows the principle of **"Write Once, Run Anywhere" (WORA)** — code compiled on one platform runs on any platform that has a JVM.

### History

| Year | Event |
|------|-------|
| 1991 | James Gosling started the "Green Project" |
| 1995 | Java 1.0 released by Sun Microsystems |
| 1996 | JDK 1.0 released |
| 2004 | Java 5 (major update: generics, enums) |
| 2010 | Oracle acquired Sun Microsystems |
| 2014 | Java 8 (lambdas, streams) |
| 2017 | Java 9 (modules) |
| 2021+ | Java 17 LTS, Java 21 LTS |

### Features of Java

| Feature | Description |
|---------|-------------|
| **Platform Independent** | Bytecode runs on any OS via JVM |
| **Object-Oriented** | Everything is modeled as objects |
| **Robust** | Strong memory management, exception handling |
| **Secure** | No explicit pointers, bytecode verifier |
| **Multithreaded** | Built-in support for concurrent execution |
| **Distributed** | Supports RMI and EJB for distributed computing |
| **Portable** | Same bytecode runs everywhere |
| **Simple** | Removed complex features of C++ (pointers, operator overloading) |

### JVM vs JDK vs JRE

```
┌──────────────────────────────────────────────────┐
│                     JDK                          │
│  (Java Development Kit)                          │
│  ┌────────────────────────────────────────────┐  │
│  │                  JRE                       │  │
│  │  (Java Runtime Environment)                │  │
│  │  ┌──────────────────────────────────────┐  │  │
│  │  │              JVM                     │  │  │
│  │  │  (Java Virtual Machine)              │  │  │
│  │  │  - Loads bytecode                    │  │  │
│  │  │  - Verifies bytecode                 │  │  │
│  │  │  - Executes bytecode                 │  │  │
│  │  └──────────────────────────────────────┘  │  │
│  │  + Libraries (rt.jar, etc.)                │  │
│  └────────────────────────────────────────────┘  │
│  + Compiler (javac)                              │
│  + Debugger (jdb)                                │
│  + Other tools (jar, javadoc)                    │
└──────────────────────────────────────────────────┘
```

| Component | What It Contains | Purpose |
|-----------|-----------------|---------|
| **JVM** | Class Loader, Bytecode Verifier, Execution Engine | Runs Java bytecode |
| **JRE** | JVM + Libraries | Runs Java programs |
| **JDK** | JRE + Compiler + Dev Tools | Develops + Runs Java programs |

### How Java Works Internally

```
                    Compile Time              Runtime
┌──────────┐      ┌──────────────┐      ┌─────────────┐
│ Hello.java│ ──→ │   javac      │ ──→  │ Hello.class  │
│(Source)   │     │ (Compiler)   │      │ (Bytecode)   │
└──────────┘      └──────────────┘      └──────┬──────┘
                                               │
                                               ▼
                                        ┌─────────────┐
                                        │     JVM      │
                                        │ ┌─────────┐  │
                                        │ │ClassLoad│  │
                                        │ └────┬────┘  │
                                        │      ▼       │
                                        │ ┌─────────┐  │
                                        │ │Bytecode │  │
                                        │ │Verifier │  │
                                        │ └────┬────┘  │
                                        │      ▼       │
                                        │ ┌─────────┐  │
                                        │ │Execution│  │
                                        │ │Engine   │  │
                                        │ │(JIT)    │  │
                                        │ └─────────┘  │
                                        └─────────────┘
                                               │
                                               ▼
                                          OS / Hardware
```

**Step-by-step:**
1. Developer writes `.java` source file
2. `javac` compiler converts it to `.class` bytecode
3. JVM **loads** the bytecode (Class Loader)
4. JVM **verifies** the bytecode (Bytecode Verifier)
5. **Execution Engine** (JIT Compiler) converts bytecode to machine code
6. Machine code runs on OS/Hardware

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Confusing JDK with JRE | JDK = JRE + development tools |
| Thinking Java is interpreted only | Java is both compiled AND interpreted (JIT) |
| Java is same as JavaScript | Completely different languages |

## Interview Tips

- Always mention WORA when asked "Why Java?"
- JVM makes Java platform-independent, not the language itself
- JIT (Just-In-Time) compiler is part of JVM, not JDK
- Java is **not** 100% object-oriented (primitives exist)

## Quick Revision

> - Java = platform-independent, OOP, robust, secure
> - JDK ⊃ JRE ⊃ JVM
> - `.java` → `javac` → `.class` → JVM → Machine Code
> - WORA = Write Once, Run Anywhere

---

## 📝 Practice – Introduction to Java

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What is JVM? | Java Virtual Machine – runs bytecode |
| 2 | What is bytecode? | Intermediate code (.class file) generated by javac |
| 3 | Who developed Java? | James Gosling |
| 4 | What does WORA stand for? | Write Once, Run Anywhere |
| 5 | What is the file extension of compiled Java? | .class |
| 6 | Which tool compiles Java code? | javac |
| 7 | What does JDK stand for? | Java Development Kit |
| 8 | Is Java platform-independent? | Yes, because of JVM |
| 9 | What year was Java released? | 1995 |
| 10 | Which company currently owns Java? | Oracle Corporation |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Which component converts bytecode to machine code? | A) javac B) JIT C) JDK D) JRE | **B) JIT** |
| 2 | JRE contains? | A) JVM only B) JVM + Libraries C) JVM + Compiler D) Compiler only | **B) JVM + Libraries** |
| 3 | Java is which type of language? | A) Compiled B) Interpreted C) Both D) Neither | **C) Both** |
| 4 | Platform independence in Java is due to? | A) JDK B) JRE C) JVM D) OS | **C) JVM** |
| 5 | Which is NOT a Java feature? | A) Pointers B) Multithreading C) Robust D) Secure | **A) Pointers** |
| 6 | `.java` file contains? | A) Bytecode B) Machine code C) Source code D) Object code | **C) Source code** |
| 7 | JDK includes? | A) JRE + JVM B) JRE + Dev tools C) JVM only D) Libraries only | **B) JRE + Dev tools** |
| 8 | Java was originally called? | A) C++ B) Oak C) Green D) Coffee | **B) Oak** |
| 9 | Which is correct order? | A) .java→JVM→.class B) .java→javac→.class C) .class→javac→.java D) None | **B) .java→javac→.class** |
| 10 | Java programs run on? | A) Only Windows B) Only Linux C) Any OS with JVM D) Only Mac | **C) Any OS with JVM** |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Can Java run without JRE? | A) Yes B) No C) Only on Windows D) Only with JDK | **B) No** – JRE provides the runtime |
| 2 | Is JVM platform-dependent? | A) No B) Yes C) Depends D) Same everywhere | **B) Yes** – JVM itself is platform-specific, but bytecode is platform-independent |
| 3 | Why is Java not 100% OOP? | A) No classes B) Has primitives C) No inheritance D) No polymorphism | **B) Has primitives** (int, char, etc. are not objects) |
| 4 | Class Loader is part of? | A) JDK B) JRE C) JVM D) javac | **C) JVM** |
| 5 | What does JIT stand for and what does it do? | A) Java Internal Tool B) Just-In-Time compiler – converts bytecode to native code at runtime C) Java Integration Test D) None | **B)** |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Java is fully object-oriented | **False** (primitives are not objects) |
| 2 | JVM is platform-independent | **False** (JVM is platform-specific) |
| 3 | Bytecode is platform-independent | **True** |
| 4 | javac is part of JRE | **False** (javac is part of JDK) |
| 5 | Java supports pointers | **False** (Java removed explicit pointers) |

### Level 5 – Small Coding Practice

**Exercise 1:** Write a program that prints `Hello, Java!` to the console.

<details>
<summary>Solution</summary>

```java
public class HelloJava {
    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
```

**Output:** `Hello, Java!`
</details>

**Exercise 2:** Write a program that prints your name and age on separate lines.

<details>
<summary>Solution</summary>

```java
public class MyInfo {
    public static void main(String[] args) {
        System.out.println("Name: Sai");
        System.out.println("Age: 21");
    }
}
```

</details>

---

### 🔥 20 Tricky Interview MCQs – Introduction to Java

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | Can we run Java without main method? | A) Yes B) No C) Only in older versions D) Only with JDK | **C)** Before Java 7, static blocks could run without main; Java 7+ requires main |
| 2 | Which is loaded first in JVM? | A) Object class B) main class C) Bootstrap classes D) User classes | **C) Bootstrap classes** |
| 3 | JIT compiler improves? | A) Compilation speed B) Runtime performance C) Code readability D) Security | **B) Runtime performance** |
| 4 | Java bytecode is stored in? | A) .java B) .class C) .jar D) .exe | **B) .class** |
| 5 | What is the size of JVM? | A) Fixed B) Depends on OS C) Depends on program D) 1 MB | **B) Depends on OS** |
| 6 | Who is responsible for garbage collection? | A) Programmer B) OS C) JVM D) JDK | **C) JVM** |
| 7 | Is String a primitive type? | A) Yes B) No | **B) No** – String is a class |
| 8 | Can JVM run non-Java languages? | A) No B) Yes (Kotlin, Scala, etc.) C) Only Java D) Only with plugins | **B) Yes** |
| 9 | main() method must be? | A) private B) public C) protected D) default | **B) public** |
| 10 | Which memory area stores objects? | A) Stack B) Heap C) Register D) Cache | **B) Heap** |
| 11 | `static` in main means? | A) Object needed B) No object needed C) Private D) Final | **B) No object needed** |
| 12 | What happens if main() is not static? | A) Compiles, runs B) Compiles, runtime error C) Compile error D) Depends | **B) Compiles but RuntimeError** |
| 13 | Java supports? | A) Single inheritance B) Multiple (classes) C) Both D) Neither | **A) Single inheritance** (for classes) |
| 14 | Which is not a JDK tool? | A) javac B) javadoc C) JIT D) jar | **C) JIT** (JIT is part of JVM) |
| 15 | Java is? | A) Strongly typed B) Weakly typed C) Untyped D) Dynamically typed | **A) Strongly typed** |
| 16 | Bytecode verifier checks? | A) Syntax B) Security & format C) Speed D) Memory | **B) Security & format** |
| 17 | ClassNotFoundException occurs at? | A) Compile time B) Runtime C) Both D) Never | **B) Runtime** |
| 18 | `void` in main means? | A) Returns int B) Returns nothing C) Returns String D) Optional | **B) Returns nothing** |
| 19 | Java uses which memory model? | A) Stack only B) Heap only C) Stack + Heap D) Register only | **C) Stack + Heap** |
| 20 | Which is true? | A) JDK ⊂ JRE B) JRE ⊂ JVM C) JVM ⊂ JRE ⊂ JDK D) JDK ⊂ JVM | **C) JVM ⊂ JRE ⊂ JDK** |

---

# 2. Java Setup

## Concept Explanation

To write and run Java programs, you need the **JDK** (Java Development Kit) installed on your system.

## Installation Steps

### Windows
1. Go to [https://www.oracle.com/java/technologies/downloads/](https://www.oracle.com/java/technologies/downloads/)
2. Download JDK (LTS version recommended, e.g., JDK 21)
3. Run the installer
4. Set `JAVA_HOME` environment variable to JDK path
5. Add `%JAVA_HOME%\bin` to the `PATH` variable

### Verify Installation

```bash
java -version      # Check JRE version
javac -version     # Check compiler version
```

## Syntax – Compile and Run

```bash
# Step 1: Write code in a file (e.g., Hello.java)
# Step 2: Compile
javac Hello.java

# Step 3: Run (without .class extension)
java Hello
```

## Example Code – First Java Program (Line-by-Line)

```java
// 1. Class declaration - every Java program needs at least one class
public class Hello {

    // 2. Main method - entry point of the program
    //    public  → accessible from anywhere
    //    static  → no object needed to call
    //    void    → returns nothing
    //    main    → method name recognized by JVM
    //    String[] args → command-line arguments
    public static void main(String[] args) {

        // 3. Print statement
        //    System → built-in class
        //    out    → standard output stream
        //    println → print line (adds newline)
        System.out.println("Hello, World!");
    }
}
```

## Output Explanation

```
Hello, World!
```

- `System.out.println()` prints the text and moves cursor to next line
- `System.out.print()` prints without newline
- `System.out.printf()` prints formatted output

## Visual Explanation

```
Hello.java                    Terminal
┌─────────────────────┐      ┌────────────────────┐
│ public class Hello { │      │ > javac Hello.java │
│   public static void │ ───→ │ > java Hello       │
│   main(String[] args)│      │ Hello, World!      │
│   { ... }            │      └────────────────────┘
└─────────────────────┘
        │
        ▼
   Hello.class (bytecode)
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| File name ≠ class name | File name MUST match public class name |
| `java Hello.class` | Use `java Hello` (no .class extension) |
| Missing semicolon | Every statement ends with `;` |
| `Main` instead of `main` | Java is case-sensitive |
| `string` instead of `String` | Capital `S` for String |

## Interview Tips

- `public static void main(String[] args)` is the **exact** signature JVM looks for
- `String[] args` can also be `String args[]` or `String... args`
- Class name should start with an uppercase letter
- File must have `.java` extension

## Quick Revision

> - Install JDK → Write `.java` → `javac` compile → `java` run
> - File name = Public class name
> - `main` method = entry point
> - `System.out.println()` for output

---

# 3. Variables

## Concept Explanation

A **variable** is a named container that stores data in memory. In Java, every variable must have a **type** declared before use.

### Types of Variables

```
┌─────────────────────────────────────────────────┐
│               Java Variables                     │
├───────────────┬────────────────┬─────────────────┤
│  Local        │  Instance      │  Static/Class   │
│  (inside      │  (inside class,│  (shared across │
│   method)     │   outside      │   all objects)  │
│               │   method)      │                 │
│  - No default │  - Has default │  - Has default  │
│    value      │    value       │    value        │
│  - Stack      │  - Heap        │  - Method Area  │
└───────────────┴────────────────┴─────────────────┘
```

## Syntax

```java
// Declaration
dataType variableName;

// Initialization
variableName = value;

// Declaration + Initialization
dataType variableName = value;
```

## Example Code

```java
public class VariableDemo {
    // Instance variable (belongs to object)
    int age = 25;

    // Static variable (belongs to class)
    static String company = "Google";

    public static void main(String[] args) {
        // Local variable (belongs to method)
        String name = "Sai";
        double salary = 50000.50;

        System.out.println("Name: " + name);
        System.out.println("Salary: " + salary);
        System.out.println("Company: " + company);

        // Accessing instance variable via object
        VariableDemo obj = new VariableDemo();
        System.out.println("Age: " + obj.age);
    }
}
```

## Output Explanation

```
Name: Sai
Salary: 50000.5
Company: Google
Age: 25
```

- Local variable `name` is created inside `main()`
- Static variable `company` is accessed directly (no object needed)
- Instance variable `age` requires an object to access

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Using a local variable without initializing | Local variables have NO default value |
| Accessing instance variable without object in static context | Create an object first |
| Declaring variable inside a block and using outside | Scope is limited to the block `{}` |

## Interview Tips

- Local variables are stored in **Stack**, instance variables in **Heap**
- Static variables are shared among ALL objects
- Default values: `int = 0`, `boolean = false`, `String = null`
- `final` keyword makes a variable constant

## Quick Revision

> - 3 types: Local, Instance, Static
> - Local → no default value, must initialize
> - Instance → belongs to object, has default value
> - Static → belongs to class, shared by all objects

---

# 4. Data Types

## Concept Explanation

Java has two categories of data types:

```
┌────────────────────────────────────────────┐
│              Java Data Types               │
├──────────────────┬─────────────────────────┤
│  Primitive (8)   │  Non-Primitive           │
│  ─────────────   │  ──────────────          │
│  byte   (1B)     │  String                  │
│  short  (2B)     │  Array                   │
│  int    (4B)     │  Class                   │
│  long   (8B)     │  Interface               │
│  float  (4B)     │  Enum                    │
│  double (8B)     │                          │
│  char   (2B)     │                          │
│  boolean(1 bit)  │                          │
└──────────────────┴─────────────────────────┘
```

### Primitive Data Types Table

| Type | Size | Default | Range | Example |
|------|------|---------|-------|---------|
| `byte` | 1 byte | 0 | -128 to 127 | `byte b = 100;` |
| `short` | 2 bytes | 0 | -32,768 to 32,767 | `short s = 1000;` |
| `int` | 4 bytes | 0 | -2³¹ to 2³¹-1 | `int i = 100000;` |
| `long` | 8 bytes | 0L | -2⁶³ to 2⁶³-1 | `long l = 100000L;` |
| `float` | 4 bytes | 0.0f | ~7 decimal digits | `float f = 3.14f;` |
| `double` | 8 bytes | 0.0d | ~15 decimal digits | `double d = 3.14;` |
| `char` | 2 bytes | '\u0000' | 0 to 65,535 | `char c = 'A';` |
| `boolean` | 1 bit | false | true / false | `boolean b = true;` |

## Example Code

```java
public class DataTypeDemo {
    public static void main(String[] args) {
        byte age = 25;
        short year = 2026;
        int population = 1400000000;
        long distance = 9876543210L;      // L suffix for long
        float pi = 3.14f;                 // f suffix for float
        double gravity = 9.80665;
        char grade = 'A';
        boolean isJavaFun = true;

        System.out.println("byte: " + age);
        System.out.println("short: " + year);
        System.out.println("int: " + population);
        System.out.println("long: " + distance);
        System.out.println("float: " + pi);
        System.out.println("double: " + gravity);
        System.out.println("char: " + grade);
        System.out.println("boolean: " + isJavaFun);
    }
}
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| `float f = 3.14;` | Must use `f` suffix: `float f = 3.14f;` |
| `long l = 9876543210;` | Must use `L` suffix: `long l = 9876543210L;` |
| `char c = "A";` | Use single quotes: `char c = 'A';` |
| Using `==` for String comparison | Use `.equals()` for Strings |

## Interview Tips

- `char` in Java is **2 bytes** (Unicode), not 1 byte like C
- `boolean` cannot be converted to `int` (unlike C/C++)
- Default type for decimals is `double`, not `float`
- Default type for integers is `int`, not `long`

## Quick Revision

> - 8 primitives: byte, short, int, long, float, double, char, boolean
> - `float` needs `f`, `long` needs `L`
> - `char` uses single quotes, `String` uses double quotes
> - Non-primitive types store references, not values

---

# 5. Type Casting

## Concept Explanation

Type casting is converting one data type to another.

```
┌─────────────────────────────────────────────────────────────┐
│ Widening (Automatic)                                        │
│ byte → short → int → long → float → double                 │
│ (smaller → larger)  ✅ No data loss                         │
│                                                             │
│ Narrowing (Manual)                                          │
│ double → float → long → int → short → byte                 │
│ (larger → smaller)  ⚠️ Possible data loss                   │
└─────────────────────────────────────────────────────────────┘
```

## Syntax

```java
// Widening (implicit) – automatic
int num = 100;
double d = num;           // int → double automatically

// Narrowing (explicit) – requires cast
double d = 9.78;
int num = (int) d;        // double → int (loses .78)
```

## Example Code

```java
public class TypeCastDemo {
    public static void main(String[] args) {
        // Widening Casting (automatic)
        int myInt = 9;
        double myDouble = myInt;  // int to double
        System.out.println("Int value: " + myInt);          // 9
        System.out.println("Double value: " + myDouble);    // 9.0

        // Narrowing Casting (manual)
        double price = 99.99;
        int roundedPrice = (int) price;  // double to int
        System.out.println("Original: " + price);           // 99.99
        System.out.println("Rounded: " + roundedPrice);     // 99

        // char to int
        char letter = 'A';
        int ascii = letter;
        System.out.println("ASCII of A: " + ascii);         // 65

        // int to char
        int num = 66;
        char ch = (char) num;
        System.out.println("Char of 66: " + ch);            // B
    }
}
```

## Output Explanation

```
Int value: 9
Double value: 9.0
Original: 99.99
Rounded: 99
ASCII of A: 65
Char of 66: B
```

- Widening: `9` becomes `9.0` (no loss)
- Narrowing: `99.99` becomes `99` (decimal part lost, NOT rounded)

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Thinking narrowing rounds the value | It **truncates** (cuts off decimal) |
| `byte b = 130;` | Compile error: 130 > 127 (byte max) |
| Mixing `int` and `double` in division | `5/2 = 2` (int division), `5.0/2 = 2.5` |

## Interview Tips

- Widening is **automatic**, narrowing is **manual**
- `(int) 9.99` gives `9`, NOT `10` (truncation, not rounding)
- `byte + byte` = `int` in Java (integer promotion)
- `char` can be widened to `int`

## Quick Revision

> - Widening: small → large (automatic, safe)
> - Narrowing: large → small (manual cast required, data may be lost)
> - Truncation ≠ Rounding
> - `byte + byte` → `int` (integer promotion)

---

# 6. Operators

## Concept Explanation

Operators perform operations on variables and values.

### Operator Categories

| Category | Operators | Example |
|----------|-----------|---------|
| **Arithmetic** | `+  -  *  /  %` | `a + b` |
| **Assignment** | `=  +=  -=  *=  /=  %=` | `a += 5` |
| **Comparison** | `==  !=  >  <  >=  <=` | `a == b` |
| **Logical** | `&&  \|\|  !` | `a && b` |
| **Unary** | `++  --  +  -  !` | `a++` |
| **Bitwise** | `&  \|  ^  ~  <<  >>  >>>` | `a & b` |
| **Ternary** | `? :` | `a > b ? a : b` |
| **instanceof** | `instanceof` | `obj instanceof String` |

## Example Code

```java
public class OperatorDemo {
    public static void main(String[] args) {
        int a = 10, b = 3;

        // Arithmetic
        System.out.println("a + b = " + (a + b));    // 13
        System.out.println("a - b = " + (a - b));    // 7
        System.out.println("a * b = " + (a * b));    // 30
        System.out.println("a / b = " + (a / b));    // 3 (integer division)
        System.out.println("a % b = " + (a % b));    // 1

        // Unary: Pre vs Post increment
        int x = 5;
        System.out.println("x++ = " + x++);  // 5 (uses then increments)
        System.out.println("x   = " + x);    // 6
        System.out.println("++x = " + (++x)); // 7 (increments then uses)

        // Ternary
        int max = (a > b) ? a : b;
        System.out.println("Max = " + max);   // 10

        // Logical
        boolean result = (a > 5) && (b < 5);
        System.out.println("Logical AND: " + result); // true

        // Short-circuit evaluation
        int c = 0;
        boolean res = (a > 5) || (++c > 0);  // c won't increment!
        System.out.println("c = " + c);       // 0 (short-circuit)
    }
}
```

## Visual Explanation – Pre vs Post Increment

```
Post-increment (x++):         Pre-increment (++x):
┌──────────────────────┐      ┌──────────────────────┐
│ 1. USE current value │      │ 1. INCREMENT first   │
│ 2. Then INCREMENT    │      │ 2. Then USE new value│
└──────────────────────┘      └──────────────────────┘

x = 5;                        x = 5;
y = x++;                      y = ++x;
// y = 5, x = 6               // y = 6, x = 6
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| `10 / 3 = 3.33` | No! `10 / 3 = 3` (integer division). Use `10.0 / 3` for `3.33` |
| Confusing `=` with `==` | `=` assigns, `==` compares |
| Confusing `&` with `&&` | `&` is bitwise AND, `&&` is logical AND (short-circuit) |
| Not understanding short-circuit | `&&` stops if first is false; `\|\|` stops if first is true |

## Interview Tips

- **Short-circuit evaluation**: `&&` won't evaluate right side if left is `false`
- `x++` vs `++x` — classic interview question
- `%` (modulo) gives the remainder
- `>>>` is unsigned right shift (fills with 0s)
- Expression `a += b` is equivalent to `a = (type)(a + b)` (includes implicit cast!)

## Quick Revision

> - 8 operator types: Arithmetic, Assignment, Comparison, Logical, Unary, Bitwise, Ternary, instanceof
> - `x++` = use then increment, `++x` = increment then use
> - Integer division truncates: `10/3 = 3`
> - Short-circuit: `&&` and `||` may skip right operand

---

# 7. Scanner (User Input)

## Concept Explanation

The `Scanner` class (from `java.util` package) reads user input from the console.

## Syntax

```java
import java.util.Scanner;

Scanner sc = new Scanner(System.in);
int num = sc.nextInt();        // reads integer
String word = sc.next();       // reads a word (till space)
String line = sc.nextLine();   // reads full line
double d = sc.nextDouble();    // reads double
sc.close();                    // close scanner
```

### Scanner Methods Table

| Method | Reads |
|--------|-------|
| `nextInt()` | Integer |
| `nextLong()` | Long |
| `nextFloat()` | Float |
| `nextDouble()` | Double |
| `next()` | Single word |
| `nextLine()` | Full line |
| `nextBoolean()` | Boolean |
| `hasNext()` | Checks if more input exists |

## Example Code

```java
import java.util.Scanner;

public class ScannerDemo {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Enter your name: ");
        String name = sc.nextLine();

        System.out.print("Enter your age: ");
        int age = sc.nextInt();

        System.out.println("Hello " + name + ", you are " + age + " years old!");

        sc.close();
    }
}
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| `nextLine()` after `nextInt()` skips input | Add an extra `sc.nextLine()` after `nextInt()` to consume the leftover newline |
| Not importing Scanner | Add `import java.util.Scanner;` |
| Not closing Scanner | Always call `sc.close()` |

### The `nextLine()` Bug Explained

```java
Scanner sc = new Scanner(System.in);
System.out.print("Enter age: ");
int age = sc.nextInt();        // User types: 25\n
// The \n (Enter key) is still in the buffer!

sc.nextLine();                 // ← This consumes the leftover \n

System.out.print("Enter name: ");
String name = sc.nextLine();   // Now this works correctly
```

## Quick Revision

> - `import java.util.Scanner;`
> - `nextInt()`, `next()`, `nextLine()`, `nextDouble()`
> - Always add `sc.nextLine()` after `nextInt()` to avoid skipping
> - Close Scanner with `sc.close()`

---

# 8. Comments

## Concept Explanation

Comments are ignored by the compiler and used to explain code.

## Syntax

```java
// Single-line comment

/* Multi-line
   comment */

/**
 * Javadoc comment
 * Used to generate documentation
 * @param name description
 * @return description
 */
```

## Quick Revision

> - `//` for single line
> - `/* */` for multi-line
> - `/** */` for Javadoc (documentation)
> - Comments don't affect performance

---

# 9. Keywords

## Concept Explanation

Keywords are **reserved words** in Java that have predefined meanings. You **cannot** use them as variable or class names.

### Important Java Keywords

| Category | Keywords |
|----------|----------|
| Data types | `byte, short, int, long, float, double, char, boolean` |
| Control flow | `if, else, switch, case, default, for, while, do, break, continue, return` |
| Access | `public, private, protected` |
| Class/Object | `class, interface, extends, implements, new, this, super` |
| Modifiers | `static, final, abstract, synchronized, volatile, transient` |
| Exception | `try, catch, finally, throw, throws` |
| Others | `void, null, true, false, instanceof, enum, import, package` |

> **Note:** `true`, `false`, and `null` are technically **literals**, not keywords — but they're still reserved.

## Quick Revision

> - ~50 keywords in Java
> - All keywords are **lowercase**
> - Cannot be used as identifiers
> - `goto` and `const` are reserved but unused

---

# 10. Naming Conventions

## Concept Explanation

| Element | Convention | Example |
|---------|-----------|---------|
| **Class** | PascalCase | `StudentRecord` |
| **Method** | camelCase | `calculateTotal()` |
| **Variable** | camelCase | `studentName` |
| **Constant** | UPPER_SNAKE_CASE | `MAX_SIZE` |
| **Package** | all lowercase | `com.myapp.utils` |
| **Interface** | PascalCase (adjective) | `Serializable`, `Runnable` |

## Quick Revision

> - Classes → PascalCase
> - Methods/Variables → camelCase
> - Constants → UPPER_SNAKE_CASE
> - Packages → lowercase

---

## 📝 Practice – Variables, Data Types, Type Casting, Operators, Scanner

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | How many primitive data types in Java? | 8 |
| 2 | What is the default value of `int`? | 0 |
| 3 | What is the default value of `boolean`? | false |
| 4 | What suffix does a `float` literal need? | `f` or `F` |
| 5 | What is the size of `char` in Java? | 2 bytes |
| 6 | What does `%` operator do? | Returns remainder |
| 7 | What class is used for user input? | Scanner |
| 8 | What is `x++` called? | Post-increment |
| 9 | What is the default value of a `String` instance variable? | null |
| 10 | What does `(int) 3.9` return? | 3 |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | What is `10 / 3` in Java? | A) 3.33 B) 3 C) 4 D) Error | **B) 3** |
| 2 | `byte b = 128;` will? | A) Compile B) Error C) b=128 D) b=-128 | **B) Compile Error** (max is 127) |
| 3 | `int x=5; int y=x++;` What is y? | A) 5 B) 6 C) 4 D) Error | **A) 5** |
| 4 | Which is wider? | A) int B) float C) double D) long | **C) double** |
| 5 | `true && false` is? | A) true B) false C) Error D) null | **B) false** |
| 6 | Default type of `3.14` is? | A) float B) double C) int D) long | **B) double** |
| 7 | `byte + byte` results in? | A) byte B) short C) int D) long | **C) int** |
| 8 | `String s; System.out.println(s);` in main? | A) null B) "" C) Error D) 0 | **C) Compile Error** (local not initialized) |
| 9 | What is `'A' + 1` in Java? | A) B B) 66 C) Error D) A1 | **B) 66** (char promoted to int) |
| 10 | `sc.nextInt()` reads? | A) String B) int C) double D) line | **B) int** |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `float f = 1.0;` causes? | A) f=1.0 B) Compile error C) f=1 D) Runtime error | **B) Compile error** – `1.0` is double, needs `1.0f` |
| 2 | `int i = (int) 1e20;` gives? | A) Error B) 0 C) Overflow value D) MAX_VALUE | **C) Overflow** – gives `2147483647` (MAX_VALUE of int) |
| 3 | `short s=10; s = s + 1;` causes? | A) s=11 B) Compile error C) Runtime error D) s=10 | **B) Compile error** – `s+1` is `int`, cannot assign to `short` without cast |
| 4 | `short s=10; s += 1;` causes? | A) s=11 B) Compile error C) Runtime error D) s=10 | **A) s=11** – `+=` includes implicit cast |
| 5 | `System.out.println(1 + 2 + "3")` prints? | A) 123 B) 33 C) 6 D) 15 | **B) "33"** – `1+2=3` then `3+"3"="33"` |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | `double` is larger than `float` | **True** |
| 2 | Local variables have default values | **False** |
| 3 | `boolean` can be cast to `int` | **False** |
| 4 | `+=` operator includes implicit casting | **True** |
| 5 | `char` can store Unicode characters | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Write a program that takes two numbers from the user and prints their sum, difference, product, and quotient.

<details>
<summary>Solution</summary>

```java
import java.util.Scanner;

public class Calculator {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter first number: ");
        double a = sc.nextDouble();
        System.out.print("Enter second number: ");
        double b = sc.nextDouble();

        System.out.println("Sum: " + (a + b));
        System.out.println("Difference: " + (a - b));
        System.out.println("Product: " + (a * b));
        System.out.println("Quotient: " + (a / b));
        sc.close();
    }
}
```

</details>

**Exercise 2:** Write a program to swap two numbers without a third variable.

<details>
<summary>Solution</summary>

```java
public class SwapNumbers {
    public static void main(String[] args) {
        int a = 10, b = 20;
        System.out.println("Before: a=" + a + ", b=" + b);

        a = a + b;  // a = 30
        b = a - b;  // b = 10
        a = a - b;  // a = 20

        System.out.println("After: a=" + a + ", b=" + b);
    }
}
```

</details>

---

### 🔥 20 Tricky Interview MCQs – Data Types, Casting & Operators

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | `System.out.println("5" + 3);` | A) 8 B) 53 C) Error D) 5.3 | **B) "53"** | String concatenation |
| 2 | `System.out.println(5 + 3 + "hello");` | A) 53hello B) 8hello C) hello53 D) Error | **B) "8hello"** | 5+3=8 then "8"+"hello" |
| 3 | `byte b = 50; b = b * 2;` | A) 100 B) Error C) 0 D) -56 | **B) Compile Error** | `b*2` is `int` |
| 4 | `int x = 5/0;` | A) 0 B) Infinity C) ArithmeticException D) Compile Error | **C) ArithmeticException** | Integer division by zero |
| 5 | `double x = 5.0/0;` | A) 0 B) Infinity C) Exception D) NaN | **B) Infinity** | Floating-point division by zero |
| 6 | `double x = 0.0/0;` | A) 0 B) Infinity C) Exception D) NaN | **D) NaN** | 0.0/0 is Not a Number |
| 7 | `char c = 'A' + 1;` | A) B B) 66 C) Error D) A1 | **A) 'B'** | 65+1=66='B', fits in char constant |
| 8 | `int i = 'A';` | A) Error B) 65 C) A D) null | **B) 65** | Widening char→int |
| 9 | `System.out.println((char)65);` | A) 65 B) A C) Error D) null | **B) A** | 65 is ASCII of 'A' |
| 10 | `int x = Integer.MAX_VALUE + 1;` | A) Error B) MAX_VALUE C) MIN_VALUE D) 0 | **C) MIN_VALUE** | Integer overflow wraps around |
| 11 | `boolean b = 1;` | A) true B) false C) Error D) 1 | **C) Compile Error** | Can't assign int to boolean in Java |
| 12 | `short s1=5, s2=10; short s3 = s1+s2;` | A) 15 B) Error C) 0 D) Runtime | **B) Compile Error** | `s1+s2` promoted to `int` |
| 13 | `float f = 3.14;` | A) 3.14 B) Error C) 3 D) 3.14f | **B) Compile Error** | 3.14 is double by default |
| 14 | `long l = 2147483648;` | A) Works B) Error C) 0 D) Overflow | **B) Compile Error** | Needs `L` suffix |
| 15 | `System.out.println(10 > 9 > 8);` | A) true B) false C) Error D) 1 | **C) Compile Error** | Can't compare boolean with int |
| 16 | `System.out.println('a' + 'b');` | A) ab B) 195 C) Error D) a+b | **B) 195** | 97 + 98 = 195 (char arithmetic) |
| 17 | `int x=10; x += ++x;` result? | A) 21 B) 22 C) 20 D) Error | **B) 22** | x += (++x) → x = 10 + 11 = 21... actually: x=10; ++x makes x=11; x += 11 means x = 11+11=22 |
| 18 | `String s = null + "hello";` | A) hello B) nullhello C) Error D) null | **B) "nullhello"** | null is converted to "null" |
| 19 | `double d = 10; int i = d;` | A) 10 B) Error C) 10.0 D) 0 | **B) Compile Error** | Narrowing needs explicit cast |
| 20 | `var x = 10;` in Java 10+? | A) Error B) x is int C) x is Object D) x is var | **B) x is int** | `var` infers type from right side |

---

# 11. Control Flow – if / else / nested if

## Concept Explanation

Control flow statements determine which blocks of code execute based on conditions.

## Syntax

```java
// Simple if
if (condition) {
    // executes if condition is true
}

// if-else
if (condition) {
    // true block
} else {
    // false block
}

// if-else if-else ladder
if (condition1) {
    // block 1
} else if (condition2) {
    // block 2
} else {
    // default block
}

// Nested if
if (condition1) {
    if (condition2) {
        // both conditions true
    }
}
```

## Example Code

```java
public class ControlFlowDemo {
    public static void main(String[] args) {
        int marks = 85;

        // if-else if ladder
        if (marks >= 90) {
            System.out.println("Grade: A+");
        } else if (marks >= 80) {
            System.out.println("Grade: A");
        } else if (marks >= 70) {
            System.out.println("Grade: B");
        } else if (marks >= 60) {
            System.out.println("Grade: C");
        } else {
            System.out.println("Grade: F");
        }

        // Nested if
        int age = 20;
        boolean hasLicense = true;

        if (age >= 18) {
            if (hasLicense) {
                System.out.println("You can drive!");
            } else {
                System.out.println("Get a license first.");
            }
        } else {
            System.out.println("Too young to drive.");
        }
    }
}
```

## Output

```
Grade: A
You can drive!
```

## Visual Explanation

```
        ┌─────────┐
        │condition?│
        └────┬────┘
        ┌────┴────┐
      true      false
        │         │
   ┌────▼───┐ ┌──▼────┐
   │if block│ │else   │
   │        │ │block  │
   └────────┘ └───────┘
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| `if (x = 5)` | Use `==` for comparison: `if (x == 5)` |
| Missing `{}` for multi-line if body | Always use braces |
| Unreachable else-if | Check condition ordering |

## Interview Tips

- `if (condition)` — condition must be `boolean` (unlike C where `if(1)` works)
- Ternary operator `?:` can replace simple if-else
- Nested ifs can often be replaced with `&&`

## Quick Revision

> - `if` → single condition
> - `if-else` → two branches
> - `else if` ladder → multiple conditions
> - Nested if → condition inside condition
> - Always use `==` for comparison, not `=`

---

# 12. Switch Statement

## Concept Explanation

`switch` is a cleaner alternative to long if-else-if chains when comparing one variable against multiple values.

## Syntax

```java
switch (expression) {
    case value1:
        // code
        break;
    case value2:
        // code
        break;
    default:
        // default code
}
```

## Example Code

```java
public class SwitchDemo {
    public static void main(String[] args) {
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
            case 4:
                System.out.println("Thursday");
                break;
            case 5:
                System.out.println("Friday");
                break;
            default:
                System.out.println("Weekend");
        }

        // Switch with String (Java 7+)
        String color = "RED";
        switch (color) {
            case "RED":
                System.out.println("Stop");
                break;
            case "GREEN":
                System.out.println("Go");
                break;
            case "YELLOW":
                System.out.println("Slow down");
                break;
            default:
                System.out.println("Invalid color");
        }
    }
}
```

## Output

```
Wednesday
Stop
```

## Visual Explanation – Fall-through

```
Without break:              With break:
case 1: ──→ code1           case 1: ──→ code1 ──→ EXIT
         │                           break;
case 2: ──→ code2           case 2: ──→ code2 ──→ EXIT
         │  (fall-through!)          break;
case 3: ──→ code3           case 3: ──→ code3 ──→ EXIT
                                     break;
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Forgetting `break` | Causes fall-through (all cases below execute) |
| Using `float`/`double` in switch | Not allowed. Use `int`, `char`, `String`, `enum` |
| Using `long` in switch | Not allowed |
| Duplicate case values | Compile error |

## Interview Tips

- Switch supports: `byte`, `short`, `int`, `char`, `String` (Java 7+), `enum`
- Switch does **NOT** support: `long`, `float`, `double`, `boolean`
- Fall-through can be used intentionally for grouping cases
- Java 14+ introduced **switch expressions**: `var result = switch(x) { case 1 -> "one"; ... };`

## Quick Revision

> - Use switch for fixed-value comparisons
> - Always use `break` unless fall-through is intended
> - Works with: int, char, String, enum
> - Does NOT work with: long, float, double, boolean

---

# 13. Loops – for / while / do-while

## Concept Explanation

Loops execute a block of code repeatedly until a condition is met.

```
┌────────────────────────────────────────────────────────┐
│                  Java Loops                            │
├──────────────┬──────────────┬──────────────────────────┤
│  for         │  while       │  do-while                │
│  Known       │  Unknown     │  Unknown iterations      │
│  iterations  │  iterations  │  Guaranteed 1 execution  │
│              │              │  (condition checked AFTER)│
└──────────────┴──────────────┴──────────────────────────┘
```

## Syntax

```java
// for loop
for (init; condition; update) {
    // body
}

// while loop
while (condition) {
    // body
}

// do-while loop
do {
    // body (executes at least once)
} while (condition);

// enhanced for-each loop
for (type variable : array) {
    // body
}
```

## Example Code

```java
public class LoopDemo {
    public static void main(String[] args) {
        // for loop
        System.out.println("--- for loop ---");
        for (int i = 1; i <= 5; i++) {
            System.out.print(i + " ");
        }
        System.out.println(); // 1 2 3 4 5

        // while loop
        System.out.println("--- while loop ---");
        int count = 5;
        while (count > 0) {
            System.out.print(count + " ");
            count--;
        }
        System.out.println(); // 5 4 3 2 1

        // do-while loop
        System.out.println("--- do-while loop ---");
        int num = 10;
        do {
            System.out.print(num + " ");
            num++;
        } while (num <= 12);
        System.out.println(); // 10 11 12

        // for-each loop
        System.out.println("--- for-each loop ---");
        int[] arr = {10, 20, 30, 40, 50};
        for (int val : arr) {
            System.out.print(val + " ");
        }
        System.out.println(); // 10 20 30 40 50
    }
}
```

## Visual Explanation

```
for loop flow:
┌──────┐     ┌─────────┐     ┌──────┐     ┌──────┐
│ init │ ──→ │condition?│ ──→ │ body │ ──→ │update│
└──────┘     └────┬────┘     └──────┘     └──┬───┘
                  │ false                     │
                  ▼                           │
                EXIT ◄────────────────────────┘

while loop flow:                do-while flow:
┌─────────┐                     ┌──────┐
│condition?│ ──→ body ──→ ↑    │ body │
└────┬────┘                     └──┬───┘
     │ false                       ▼
     ▼                        ┌─────────┐
   EXIT                       │condition?│
                              └────┬────┘
                                   │ false
                                   ▼
                                 EXIT
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Infinite loop: `for(;;)` | Ensure condition eventually becomes false |
| Off-by-one error | `< n` gives 0 to n-1, `<= n` gives 0 to n |
| Modifying loop variable inside for-each | For-each copies the value, modifying won't change array |
| `do-while` missing semicolon | `} while (condition);` ← needs `;` |

## Interview Tips

- `for` → when you know the count
- `while` → when count is unknown, condition checked first
- `do-while` → execute at least once, then check
- `for-each` → read-only traversal of arrays/collections
- Infinite loop: `while(true)` or `for(;;)`
- `for-each` cannot modify elements or access index

## Quick Revision

> - `for` = known iterations
> - `while` = condition first, then execute
> - `do-while` = execute first, then check (at least 1 run)
> - `for-each` = simplified array/collection traversal
> - Don't forget `;` after `do-while`

---

# 14. Break and Continue

## Concept Explanation

| Statement | Purpose |
|-----------|---------|
| `break` | Exits the loop entirely |
| `continue` | Skips current iteration, moves to next |

## Example Code

```java
public class BreakContinueDemo {
    public static void main(String[] args) {
        // break example
        System.out.println("--- break ---");
        for (int i = 1; i <= 10; i++) {
            if (i == 5) break;       // exit loop when i is 5
            System.out.print(i + " ");
        }
        System.out.println();        // 1 2 3 4

        // continue example
        System.out.println("--- continue ---");
        for (int i = 1; i <= 10; i++) {
            if (i % 2 == 0) continue; // skip even numbers
            System.out.print(i + " ");
        }
        System.out.println();        // 1 3 5 7 9

        // labeled break (exits outer loop)
        System.out.println("--- labeled break ---");
        outer:
        for (int i = 1; i <= 3; i++) {
            for (int j = 1; j <= 3; j++) {
                if (j == 2) break outer;
                System.out.println("i=" + i + " j=" + j);
            }
        }
        // prints only: i=1 j=1
    }
}
```

## Visual Explanation

```
break:                          continue:
for(i = 1 to 10)               for(i = 1 to 10)
  i=1 → print                    i=1 → print
  i=2 → print                    i=2 → SKIP ──→ next iteration
  i=3 → print                    i=3 → print
  i=4 → print                    i=4 → SKIP ──→ next iteration
  i=5 → EXIT LOOP ❌             i=5 → print
                                  ... (continue for all)
```

## Quick Revision

> - `break` = stop the loop
> - `continue` = skip this iteration
> - Labeled break: `outer: for(...)` + `break outer;` exits outer loop
> - Both work in `for`, `while`, `do-while`
> - `break` also works in `switch`

---

## 📝 Practice – Control Flow, Switch, Loops, Break/Continue

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What does `break` do in a loop? | Exits the loop |
| 2 | What does `continue` do? | Skips current iteration |
| 3 | Does `do-while` execute at least once? | Yes |
| 4 | Can `switch` use `String`? | Yes (Java 7+) |
| 5 | What is a `for-each` loop? | Simplified loop for arrays/collections |
| 6 | What happens without `break` in switch? | Fall-through |
| 7 | Can `switch` use `double`? | No |
| 8 | What does `else if` do? | Tests another condition if previous was false |
| 9 | Is `while(true)` valid? | Yes (creates infinite loop) |
| 10 | What is the for-each syntax? | `for (type var : array)` |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `for(int i=0; i<5; i++)` runs how many times? | A) 4 B) 5 C) 6 D) Error | **B) 5** |
| 2 | `do { } while(false);` runs how many times? | A) 0 B) 1 C) Infinite D) Error | **B) 1** |
| 3 | `switch(true)` is? | A) Valid B) Error C) Depends D) Runs default | **B) Error** (boolean not allowed in switch) |
| 4 | What type can't be used in switch? | A) int B) String C) long D) char | **C) long** |
| 5 | `for(;;)` creates? | A) Error B) Nothing C) Infinite loop D) Runs once | **C) Infinite loop** |
| 6 | `continue` in a `for` loop goes to? | A) Condition B) Update C) Init D) Exit | **B) Update step** then condition |
| 7 | `break` in nested loop exits? | A) All loops B) Innermost only C) Outermost D) Error | **B) Innermost only** |
| 8 | `if(5)` in Java? | A) true B) false C) Error D) 5 | **C) Compile Error** (condition must be boolean) |
| 9 | Default case in switch is? | A) Required B) Optional C) First only D) Error if missing | **B) Optional** |
| 10 | `while(1)` in Java? | A) Infinite loop B) Error C) Runs once D) Same as true | **B) Error** (int is not boolean) |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `for(int i=0; i<5; i++) { if(i==3) continue; print(i); }` | A) 0 1 2 4 B) 0 1 2 3 C) 0 1 2 D) 0 1 2 3 4 | **A) 0 1 2 4** |
| 2 | `int x=0; while(x++ < 3) {}` Final value of x? | A) 3 B) 4 C) 2 D) Error | **B) 4** – x increments to 4 before check fails |
| 3 | Can `default` appear anywhere in switch? | A) Only at end B) Only at start C) Anywhere D) Depends | **C) Anywhere** |
| 4 | `switch("Hello".length())` uses? | A) String B) int C) Error D) char | **B) int** – `.length()` returns int |
| 5 | `for(int i=0, j=10; i<j; i++, j--)` is? | A) Error B) Valid C) Infinite D) Syntax error | **B) Valid** – multiple init and updates allowed |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | `for-each` loop can modify array elements | **False** (copies value) |
| 2 | `switch` supports `boolean` | **False** |
| 3 | `do-while` checks condition before executing | **False** (checks after) |
| 4 | `break` works only in loops | **False** (also in switch) |
| 5 | You can use labeled `continue` | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Print all even numbers from 1 to 20 using a `for` loop.

<details>
<summary>Solution</summary>

```java
public class EvenNumbers {
    public static void main(String[] args) {
        for (int i = 2; i <= 20; i += 2) {
            System.out.print(i + " ");
        }
        // Output: 2 4 6 8 10 12 14 16 18 20
    }
}
```

</details>

**Exercise 2:** Print the multiplication table of 7 using a `while` loop.

<details>
<summary>Solution</summary>

```java
public class MultiTable {
    public static void main(String[] args) {
        int n = 7, i = 1;
        while (i <= 10) {
            System.out.println(n + " x " + i + " = " + (n * i));
            i++;
        }
    }
}
```

</details>

---

### 🔥 20 Tricky Interview MCQs – Control Flow & Loops

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | `int i=0; for(; i<5;) { i++; }` Final i? | A) 4 B) 5 C) Error D) 0 | **B) 5** | All parts of `for` are optional |
| 2 | `if(false); System.out.println("Hi");` | A) Error B) Nothing C) Prints Hi D) Depends | **C) Prints Hi** | Empty `if` body (semicolon), println always runs |
| 3 | `for(int i=0; i<5; i++); { }` | A) Runs 5 times B) Runs once C) Error D) Loop body is empty | **D) Loop body is empty** | `;` after for makes it empty-bodied |
| 4 | `switch(1) { case 1: case 2: print("X"); }` | A) Error B) Prints X C) Nothing D) Prints XX | **B) Prints X** | Fall-through from case 1 to case 2 then prints |
| 5 | `while(true) { break; } print("Done");` | A) Infinite B) Prints Done C) Error D) Nothing | **B) Prints Done** | break exits loop |
| 6 | `for(int i=0; i<0; i++) { print(i); }` | A) 0 B) Nothing C) Error D) Infinite | **B) Nothing** | Condition false from start |
| 7 | `int i=10; do { print(i); } while(i++<10);` | A) 10 B) 10 11 C) Nothing D) Error | **A) Prints 10** | Prints 10, then i becomes 11, 10<10 is false |
| 8 | `for(long l=0; l<5; l++)` in switch: `switch(l)` | A) Works B) Error C) Depends D) Converts | **B) Error** | switch doesn't support long |
| 9 | Can `return` be used inside a loop? | A) No B) Yes C) Only break D) Error | **B) Yes** | return exits the method |
| 10 | `continue` in switch? | A) Valid B) Error C) Depends D) Same as break | **B) Error** | continue only works in loops |
| 11 | `if(true) if(false) print("A"); else print("B");` | A) A B) B C) Nothing D) Error | **B) B** | else binds to nearest if |
| 12 | `for(int i=0; i<5; i++) { for(int i=0;...)  }` | A) Works B) Error C) Depends D) Shadows | **B) Error** | Variable `i` already defined in scope |
| 13 | `int x=1; switch(x) { default: print("D"); case 1: print("1"); }` | A) D B) 1 C) D1 D) 1 only | **D) Prints "1" only** | case 1 matches, no break, but nothing after case 1 |
| 14 | Empty switch: `switch(x) {}` | A) Error B) Valid C) Depends D) Warning | **B) Valid** | Empty switch is allowed |
| 15 | `while(false) { print("X"); }` | A) Nothing B) Error C) Prints X D) Infinite | **B) Compile Error** | Unreachable statement |
| 16 | `if(false) { print("X"); }` | A) Nothing B) Error C) Prints X D) Warning | **A) Nothing** | if(false) is allowed (unlike while(false)) |
| 17 | `for(int i=0; i<3; i++) { } print(i);` | A) 3 B) Error C) 0 D) 2 | **B) Error** | `i` scope is inside for loop |
| 18 | Nested loop total iterations: `for(i=0;i<3;i++) for(j=0;j<4;j++)` | A) 7 B) 12 C) 16 D) 3 | **B) 12** | 3 × 4 = 12 |
| 19 | `switch("abc") { case "abc": ... }` | A) Works in Java 7+ B) Error C) Only char D) Only int | **A) Works in Java 7+** | String in switch from Java 7 |
| 20 | `int x=5; if(x > 3 && x < 10)` vs `if(x > 3 & x < 10)` | A) Same result B) Different C) Error D) Only first works | **A) Same result** but `&&` is short-circuit (preferred) |

---

# 15. Methods

## Concept Explanation

A **method** is a block of code that performs a specific task. Methods promote **code reusability** and **modularity**.

```
┌──────────────────────────────────────────────┐
│           Method Structure                    │
│                                               │
│  accessModifier returnType methodName(params) │
│  {                                            │
│      // method body                           │
│      return value; // if not void             │
│  }                                            │
└──────────────────────────────────────────────┘
```

## Syntax

```java
// Method with return value
public static int add(int a, int b) {
    return a + b;
}

// Method without return value
public static void greet(String name) {
    System.out.println("Hello, " + name);
}

// Method with no parameters
public static void sayHello() {
    System.out.println("Hello!");
}
```

## Example Code

```java
public class MethodDemo {
    // Method with parameters and return value
    public static int add(int a, int b) {
        return a + b;
    }

    // Method with no return value (void)
    public static void printResult(int result) {
        System.out.println("Result: " + result);
    }

    // Method Overloading - same name, different parameters
    public static int add(int a, int b, int c) {
        return a + b + c;
    }

    public static double add(double a, double b) {
        return a + b;
    }

    // Recursion - method calling itself
    public static int factorial(int n) {
        if (n <= 1) return 1;          // base case
        return n * factorial(n - 1);    // recursive case
    }

    public static void main(String[] args) {
        int sum = add(5, 3);           // calls add(int, int)
        printResult(sum);              // Result: 8

        int sum3 = add(1, 2, 3);       // calls add(int, int, int)
        printResult(sum3);             // Result: 6

        double dSum = add(1.5, 2.5);   // calls add(double, double)
        System.out.println("Double sum: " + dSum); // 4.0

        int fact = factorial(5);
        System.out.println("5! = " + fact); // 120
    }
}
```

## Output Explanation

```
Result: 8
Result: 6
Double sum: 4.0
5! = 120
```

## Visual Explanation – Method Overloading

```
add(int, int)          → add(5, 3)      → 8
add(int, int, int)     → add(1, 2, 3)   → 6
add(double, double)    → add(1.5, 2.5)  → 4.0

Compiler picks the right method based on:
1. Number of parameters
2. Type of parameters
3. Order of parameters
```

## Visual Explanation – Recursion

```
factorial(5)
  └→ 5 * factorial(4)
          └→ 4 * factorial(3)
                  └→ 3 * factorial(2)
                          └→ 2 * factorial(1)
                                  └→ return 1  (base case)
                          └→ return 2 * 1 = 2
                  └→ return 3 * 2 = 6
          └→ return 4 * 6 = 24
  └→ return 5 * 24 = 120
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Missing `return` in non-void method | Every code path must return a value |
| Overloading by changing only return type | Not valid — parameters must differ |
| Infinite recursion (no base case) | Always include a base case |
| Calling non-static method from static context | Use an object or make method static |

## Interview Tips

- **Overloading** = same name, different parameters (compile-time polymorphism)
- Overloading **cannot** be done by only changing return type
- Java passes primitives by **value** and objects by **reference value** (reference is copied)
- `varargs`: `method(int... nums)` — can accept variable number of args
- Recursion uses **stack memory** — too deep = `StackOverflowError`

## Quick Revision

> - Methods = reusable blocks of code
> - `void` = no return, `returnType` = must return
> - Overloading = same name, different parameters
> - Recursion = method calling itself (needs base case!)
> - Java is **pass-by-value** (even for objects — reference is copied)

---

## 📝 Practice – Methods

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What keyword means no return value? | `void` |
| 2 | What is method overloading? | Same name, different parameters |
| 3 | Can two methods differ only by return type? | No |
| 4 | What is recursion? | A method calling itself |
| 5 | What causes StackOverflowError? | Infinite/too deep recursion |
| 6 | What is a base case? | The stopping condition in recursion |
| 7 | What does `return` do? | Returns a value and exits the method |
| 8 | Is `static` required for `main` method? | Yes |
| 9 | Can methods have the same name as the class? | Yes (that's a constructor) |
| 10 | What is a parameter? | Variable declared in method signature |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `void test()` and `int test()` — valid overload? | A) Yes B) No C) Depends D) Runtime error | **B) No** — must differ in parameters |
| 2 | `add(int a, int b)` vs `add(int b, int a)` — overloaded? | A) Yes B) No C) Error D) Depends | **B) No** — same parameter types |
| 3 | Java uses which parameter passing? | A) Pass by reference B) Pass by value C) Both D) Neither | **B) Pass by value** |
| 4 | What is `varargs` syntax? | A) `int[] args` B) `int... args` C) `int* args` D) `int args...` | **B) `int... args`** |
| 5 | Can a method be called before it is defined in the file? | A) No B) Yes C) Only if static D) Error | **B) Yes** — Java doesn't require definition order |
| 6 | Maximum one `varargs` per method? | A) Yes, and must be last B) No C) Can be anywhere D) Max two | **A) Yes, and must be last parameter** |
| 7 | Factorial of 0 is? | A) 0 B) 1 C) Error D) Undefined | **B) 1** |
| 8 | What is the return type of `main()`? | A) int B) String C) void D) boolean | **C) void** |
| 9 | Can `main()` be overloaded? | A) No B) Yes C) Error D) Only static | **B) Yes** — but JVM calls `main(String[])` |
| 10 | `return;` in void method is? | A) Error B) Valid C) Warning D) Ignored | **B) Valid** — exits the method early |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `void test(int a, long b)` vs `void test(long a, int b)` — overloaded? | A) Yes B) No C) Error D) Ambiguous | **A) Yes** — different parameter order of different types |
| 2 | `test(5)` when both `test(int)` and `test(long)` exist? | A) Calls long B) Calls int C) Error D) Random | **B) Calls int** — exact match wins |
| 3 | `test(5)` when only `test(long)` exists? | A) Error B) Calls test(long) C) Depends D) Runtime error | **B) Calls test(long)** — auto-widening |
| 4 | `test(5, 5)` when `test(int, long)` and `test(long, int)` exist? | A) Calls first B) Calls second C) Ambiguity error D) Random | **C) Compile error** — ambiguous |
| 5 | Can `static` method call `non-static` method directly? | A) Yes B) No C) Depends D) Only in main | **B) No** — needs an object |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Method overloading is compile-time polymorphism | **True** |
| 2 | Recursion always uses less memory than iteration | **False** (uses more — stack frames) |
| 3 | A method can return multiple values in Java | **False** (only one; use arrays/objects for multiple) |
| 4 | `varargs` is internally treated as an array | **True** |
| 5 | Method signature includes return type | **False** (only name + parameters) |

### Level 5 – Small Coding Practice

**Exercise 1:** Write a method `isPrime(int n)` that returns `true` if n is prime.

<details>
<summary>Solution</summary>

```java
public class PrimeCheck {
    public static boolean isPrime(int n) {
        if (n <= 1) return false;
        for (int i = 2; i <= Math.sqrt(n); i++) {
            if (n % i == 0) return false;
        }
        return true;
    }

    public static void main(String[] args) {
        System.out.println(isPrime(7));  // true
        System.out.println(isPrime(10)); // false
    }
}
```

</details>

**Exercise 2:** Write a recursive method to find the nth Fibonacci number.

<details>
<summary>Solution</summary>

```java
public class Fibonacci {
    public static int fib(int n) {
        if (n <= 1) return n;
        return fib(n - 1) + fib(n - 2);
    }

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            System.out.print(fib(i) + " ");
        }
        // Output: 0 1 1 2 3 5 8 13 21 34
    }
}
```

</details>

---

### 🔥 20 Tricky Interview MCQs – Methods

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | Can constructors be overloaded? | A) No B) Yes C) Only default D) Error | **B) Yes** | Constructors follow same overloading rules |
| 2 | `static` method can access `this`? | A) Yes B) No C) Depends D) Sometimes | **B) No** | `this` refers to current object; static has no object |
| 3 | What is method hiding? | A) Overriding static methods B) Private methods C) Final methods D) Abstract methods | **A)** | Static methods are hidden, not overridden |
| 4 | `void test(int... a, int b)` is? | A) Valid B) Invalid C) Depends D) Warning | **B) Invalid** | varargs must be the last parameter |
| 5 | Can we overload main()? | A) No B) Yes C) Error D) Only once | **B) Yes** | JVM will still call `main(String[])` |
| 6 | `int add(int a, int b)` and `long add(int a, int b)` valid overload? | A) Yes B) No C) Depends D) Warning | **B) No** | Return type alone can't differentiate |
| 7 | What happens on calling `factorial(-1)` with no negative check? | A) Returns -1 B) StackOverflow C) Returns 0 D) Error | **B) StackOverflowError** | Infinite recursion, no base case match |
| 8 | `double test(int a)` vs `int test(double a)` — overloaded? | A) Yes B) No C) Error D) Same | **A) Yes** | Different parameter types |
| 9 | Method local variables are stored in? | A) Heap B) Stack C) Method Area D) Register | **B) Stack** | Local variables live on the stack frame |
| 10 | Can method parameters be `final`? | A) No B) Yes C) Error D) Only objects | **B) Yes** | `void test(final int x)` prevents reassignment |
| 11 | `void test() { return null; }` | A) Valid B) Error C) null D) Depends | **B) Compile Error** | void methods can't return a value |
| 12 | How many values can a method return? | A) 0 B) 1 C) Multiple D) Unlimited | **B) 1** | Return one value (use array/object for multiple) |
| 13 | Can a private method be overridden? | A) Yes B) No C) Depends D) Only in same class | **B) No** | Private methods are not visible to subclasses |
| 14 | `final` method can be? | A) Overridden B) Overloaded C) Both D) Neither | **B) Overloaded** | Final prevents override, not overload |
| 15 | Tail recursion optimization in Java? | A) Supported B) Not supported C) Depends D) JVM specific | **B) Not supported** | JVM doesn't optimize tail recursion |
| 16 | `test()` and `test(int... args)` — which runs for `test()`? | A) First B) Second C) Ambiguous D) Error | **A) First** | Exact match preferred over varargs |
| 17 | `void test(Object o)` vs `void test(String s)` — `test("hi")` calls? | A) Object B) String C) Error D) Random | **B) String** | Most specific match wins |
| 18 | Can abstract method have body? | A) Yes B) No C) Only default D) Depends | **B) No** | Abstract methods are declared, not defined |
| 19 | Method overriding vs method hiding? | A) Same B) Override=instance, hiding=static C) Both static D) Both instance | **B)** | Instance methods override, static methods hide |
| 20 | `void test(int a) { int a = 5; }` | A) Valid B) Error C) Shadows D) Overrides | **B) Compile Error** | Parameter `a` already defined |

---

# 16. Arrays

## Concept Explanation

An **array** is a fixed-size, indexed collection of elements of the **same data type**.

```
┌───────────────────────────────────────────┐
│          Array in Memory (Heap)           │
│                                           │
│  Index:   [0]   [1]   [2]   [3]   [4]    │
│  Values:  10    20    30    40    50       │
│                                           │
│  Length: 5                                │
│  First index: 0                           │
│  Last index: length - 1 = 4              │
└───────────────────────────────────────────┘
```

## Syntax

```java
// Declaration + Initialization
int[] arr = new int[5];             // default values: 0
int[] arr = {10, 20, 30, 40, 50};   // direct initialization

// Accessing elements
arr[0] = 100;                        // set value
int val = arr[2];                    // get value

// Length
int len = arr.length;                // 5 (no parentheses!)
```

## Example Code – 1D Array

```java
public class ArrayDemo {
    public static void main(String[] args) {
        // Declaration and initialization
        int[] numbers = {10, 20, 30, 40, 50};

        // Traversal using for loop
        System.out.println("Using for loop:");
        for (int i = 0; i < numbers.length; i++) {
            System.out.print(numbers[i] + " ");
        }
        System.out.println();

        // Traversal using for-each
        System.out.println("Using for-each:");
        for (int num : numbers) {
            System.out.print(num + " ");
        }
        System.out.println();

        // Find max element
        int max = numbers[0];
        for (int i = 1; i < numbers.length; i++) {
            if (numbers[i] > max) {
                max = numbers[i];
            }
        }
        System.out.println("Max: " + max);
    }
}
```

## Example Code – 2D Array

```java
public class Array2DDemo {
    public static void main(String[] args) {
        // 2D Array (matrix)
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };

        // Traversal
        System.out.println("Matrix:");
        for (int i = 0; i < matrix.length; i++) {         // rows
            for (int j = 0; j < matrix[i].length; j++) {  // columns
                System.out.print(matrix[i][j] + "\t");
            }
            System.out.println();
        }

        // Jagged array (rows with different lengths)
        int[][] jagged = new int[3][];
        jagged[0] = new int[]{1, 2};
        jagged[1] = new int[]{3, 4, 5};
        jagged[2] = new int[]{6};

        System.out.println("\nJagged array:");
        for (int[] row : jagged) {
            for (int val : row) {
                System.out.print(val + " ");
            }
            System.out.println();
        }
    }
}
```

## Output

```
Matrix:
1	2	3
4	5	6
7	8	9

Jagged array:
1 2 
3 4 5 
6 
```

## Visual Explanation – 2D Array

```
matrix[3][3]:
             col 0   col 1   col 2
row 0  →  [   1   |   2   |   3   ]
row 1  →  [   4   |   5   |   6   ]
row 2  →  [   7   |   8   |   9   ]

matrix[1][2] = 6   (row 1, col 2)
matrix.length = 3  (number of rows)
matrix[0].length = 3  (number of columns in row 0)
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| `arr.length()` | Use `arr.length` (no parentheses — it's a field, not a method) |
| `ArrayIndexOutOfBoundsException` | Index must be 0 to length-1 |
| Printing array with `System.out.println(arr)` | Prints hash; use `Arrays.toString(arr)` |
| Confusing array size with last index | Size 5 → indices 0-4 |

## Interview Tips

- Arrays are **objects** in Java (stored in heap)
- Array size is **fixed** after creation
- `int[] arr` and `int arr[]` are both valid (first is preferred)
- Use `Arrays.sort()`, `Arrays.copyOf()`, `Arrays.fill()` from `java.util.Arrays`
- Default values: `int[] → 0`, `boolean[] → false`, `String[] → null`
- Multidimensional arrays are "arrays of arrays"
- Jagged arrays: rows can have different lengths

## Quick Revision

> - Fixed size, zero-indexed
> - `arr.length` (not `.length()`)
> - 1D: `int[] arr = new int[5];`
> - 2D: `int[][] arr = new int[3][4];`
> - Use `Arrays.toString()` to print
> - ArrayIndexOutOfBoundsException if index < 0 or >= length

---

# 17. Strings

## Concept Explanation

A **String** in Java is an **immutable** sequence of characters. It is a **class** (not primitive) stored in the **String Pool** (inside heap).

```
┌──────────────────────────────────────────┐
│              String Pool                  │
│  (Special area inside Heap)               │
│                                           │
│   ┌────────┐   ┌────────┐   ┌────────┐  │
│   │"Hello" │   │"World" │   │"Java"  │  │
│   └────────┘   └────────┘   └────────┘  │
│                                           │
│  Same literal = same reference            │
│  String s1 = "Hello";                     │
│  String s2 = "Hello";                     │
│  s1 == s2  → true (same pool object)      │
│                                           │
│  String s3 = new String("Hello");         │
│  s1 == s3  → false (different object)     │
│  s1.equals(s3) → true (same content)     │
└──────────────────────────────────────────┘
```

## Syntax

```java
// Using literal (goes to String Pool)
String s1 = "Hello";

// Using new keyword (goes to Heap, outside pool)
String s2 = new String("Hello");

// String is IMMUTABLE – every operation creates a new String
String s3 = s1 + " World";  // s1 is unchanged
```

## Important String Methods

| Method | Description | Example | Result |
|--------|-------------|---------|--------|
| `length()` | Returns length | `"Hello".length()` | 5 |
| `charAt(i)` | Char at index i | `"Hello".charAt(1)` | 'e' |
| `substring(i)` | From index i to end | `"Hello".substring(2)` | "llo" |
| `substring(i,j)` | From i to j-1 | `"Hello".substring(1,4)` | "ell" |
| `indexOf(str)` | First occurrence index | `"Hello".indexOf("ll")` | 2 |
| `lastIndexOf(str)` | Last occurrence index | `"abcabc".lastIndexOf("a")` | 3 |
| `contains(str)` | Checks if contains | `"Hello".contains("ell")` | true |
| `equals(str)` | Content comparison | `"Hi".equals("hi")` | false |
| `equalsIgnoreCase()` | Ignore case comparison | `"Hi".equalsIgnoreCase("hi")` | true |
| `toLowerCase()` | Convert to lowercase | `"HELLO".toLowerCase()` | "hello" |
| `toUpperCase()` | Convert to uppercase | `"hello".toUpperCase()` | "HELLO" |
| `trim()` | Remove leading/trailing spaces | `" Hi ".trim()` | "Hi" |
| `replace(a, b)` | Replace characters | `"Hello".replace('l','r')` | "Herro" |
| `split(regex)` | Split into array | `"a,b,c".split(",")` | ["a","b","c"] |
| `toCharArray()` | Convert to char[] | `"Hi".toCharArray()` | ['H','i'] |
| `isEmpty()` | Check if length is 0 | `"".isEmpty()` | true |
| `compareTo(str)` | Lexicographic comparison | `"a".compareTo("b")` | -1 |
| `startsWith(str)` | Check prefix | `"Hello".startsWith("He")` | true |
| `endsWith(str)` | Check suffix | `"Hello".endsWith("lo")` | true |
| `valueOf()` | Convert to String | `String.valueOf(123)` | "123" |

## Example Code

```java
public class StringDemo {
    public static void main(String[] args) {
        String s1 = "Hello";
        String s2 = "Hello";
        String s3 = new String("Hello");

        // == vs .equals()
        System.out.println(s1 == s2);        // true  (same pool reference)
        System.out.println(s1 == s3);        // false (different objects)
        System.out.println(s1.equals(s3));   // true  (same content)

        // String methods
        System.out.println(s1.length());           // 5
        System.out.println(s1.charAt(0));          // H
        System.out.println(s1.substring(1, 4));    // ell
        System.out.println(s1.toUpperCase());      // HELLO
        System.out.println(s1.concat(" World"));   // Hello World
        System.out.println(s1);                    // Hello (unchanged!)

        // String immutability
        String original = "Java";
        String modified = original.replace("Java", "Python");
        System.out.println(original);  // Java   (not changed)
        System.out.println(modified);  // Python  (new String)
    }
}
```

## StringBuilder vs StringBuffer

| Feature | String | StringBuilder | StringBuffer |
|---------|--------|--------------|-------------|
| **Mutability** | Immutable | Mutable | Mutable |
| **Thread Safety** | Yes (immutable) | No | Yes (synchronized) |
| **Performance** | Slow (creates new objects) | Fast | Slower than StringBuilder |
| **When to use** | Few modifications | Many modifications (single-thread) | Many modifications (multi-thread) |

### StringBuilder Example

```java
public class StringBuilderDemo {
    public static void main(String[] args) {
        StringBuilder sb = new StringBuilder("Hello");

        sb.append(" World");         // Hello World
        sb.insert(5, ",");          // Hello, World
        sb.replace(0, 5, "Hi");     // Hi, World
        sb.delete(2, 4);            // Hi World
        sb.reverse();               // dlroW iH

        System.out.println(sb);           // dlroW iH
        System.out.println(sb.length());  // 8
        System.out.println(sb.toString()); // dlroW iH
    }
}
```

### StringBuilder Methods

| Method | Description |
|--------|-------------|
| `append(str)` | Add to end |
| `insert(i, str)` | Insert at index |
| `replace(start, end, str)` | Replace range |
| `delete(start, end)` | Delete range |
| `reverse()` | Reverse the string |
| `charAt(i)` | Get char at index |
| `length()` | Get length |
| `toString()` | Convert to String |
| `capacity()` | Get current capacity |

## Visual Explanation – String Immutability

```
String s = "Hello";

Step 1: s → [ "Hello" ] in String Pool

s = s + " World";

Step 2: s → [ "Hello World" ] (NEW object)
         [ "Hello" ] still exists in pool (orphaned)

The original "Hello" object is NOT modified.
A brand new "Hello World" object is created.
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Using `==` to compare String content | Use `.equals()` |
| Thinking String methods modify the original | Strings are immutable — methods return NEW strings |
| `"Hello" + null` | Doesn't throw error — gives `"Hellonull"` |
| Not using StringBuilder for concatenation in loops | Huge performance penalty with `+` in loops |

## Interview Tips

- `String` = immutable, `StringBuilder` = mutable (not thread-safe), `StringBuffer` = mutable (thread-safe)
- String Pool saves memory by reusing identical literals
- `==` compares **references**, `.equals()` compares **content**
- `"Hello" + "World"` is optimized by compiler to `"HelloWorld"` at compile time
- `new String("Hello")` creates **two objects**: one in pool and one in heap
- `intern()` method forces a String into the pool
- Strings are `final` class — cannot be extended

## Quick Revision

> - String = immutable, stored in String Pool
> - `==` for reference, `.equals()` for content
> - StringBuilder = fast, mutable, not synchronized
> - StringBuffer = mutable, synchronized (thread-safe)
> - Use StringBuilder for string manipulation in loops
> - `new String()` creates object outside pool

---

## 📝 Practice – Arrays & Strings

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | How to get array length? | `arr.length` (field, no parentheses) |
| 2 | What index does an array start from? | 0 |
| 3 | Is String mutable in Java? | No, it's immutable |
| 4 | `==` for Strings compares? | References (not content) |
| 5 | How to compare String content? | `.equals()` |
| 6 | What is StringBuilder used for? | Mutable string operations |
| 7 | What is the default value of String array elements? | null |
| 8 | What does `trim()` do? | Removes leading and trailing spaces |
| 9 | What does `charAt(0)` return for "Hello"? | 'H' |
| 10 | What is a 2D array? | Array of arrays |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `String s = "Hi"; s.concat("!"); print(s);` | A) Hi! B) Hi C) Error D) null | **B) Hi** (String is immutable; concat returns new String) |
| 2 | `int[] a = new int[3]; print(a[0]);` | A) Error B) null C) 0 D) undefined | **C) 0** (default for int) |
| 3 | `String[] arr = new String[2]; print(arr[0]);` | A) Error B) "" C) null D) 0 | **C) null** |
| 4 | Which is thread-safe? | A) String B) StringBuilder C) StringBuffer D) A & C | **D) A & C** |
| 5 | `"abc".compareTo("abd")` returns? | A) 0 B) Positive C) Negative D) Error | **C) Negative** (-1, 'c' < 'd') |
| 6 | Array size can be changed after creation? | A) Yes B) No C) With resize() D) With Arrays.copy() | **B) No** |
| 7 | `"Hello".substring(5)` returns? | A) Error B) "" C) null D) "o" | **B) ""** (empty string) |
| 8 | `arr.length` vs `str.length()` | A) Same B) Field vs method C) Error D) Both fields | **B) Array=field, String=method** |
| 9 | StringBuilder default capacity? | A) 0 B) 10 C) 16 D) 32 | **C) 16** |
| 10 | `String s = null; s += "hi";` | A) Error B) "nullhi" C) "hi" D) NullPointerException | **B) "nullhi"** |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `String s1="abc"; String s2="abc"; s1==s2?` | A) true B) false C) Error D) Depends | **A) true** — same pool reference |
| 2 | `String s1=new String("abc"); String s2=new String("abc"); s1==s2?` | A) true B) false C) Error D) Depends | **B) false** — different heap objects |
| 3 | How many objects created: `String s = new String("Hello");`? | A) 1 B) 2 C) 0 D) 3 | **B) 2** — one in pool, one in heap |
| 4 | `int[][] a = new int[3][]; a[0] = new int[2]; a[1] = new int[4];` — Valid? | A) No B) Yes C) Error D) Depends | **B) Yes** — jagged array |
| 5 | `"" == new String("")` | A) true B) false C) Error D) Depends | **B) false** — different objects |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | String Pool is inside the Heap | **True** |
| 2 | StringBuilder is synchronized | **False** (StringBuffer is synchronized) |
| 3 | Arrays can hold different data types | **False** (homogeneous only) |
| 4 | `String.intern()` adds to the pool | **True** |
| 5 | `new int[-1]` throws NegativeArraySizeException | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Write a program to reverse a string without using built-in reverse methods.

<details>
<summary>Solution</summary>

```java
public class ReverseString {
    public static void main(String[] args) {
        String str = "Hello";
        String reversed = "";
        for (int i = str.length() - 1; i >= 0; i--) {
            reversed += str.charAt(i);
        }
        System.out.println(reversed); // olleH
    }
}
```

</details>

**Exercise 2:** Write a program to find the second largest element in an array.

<details>
<summary>Solution</summary>

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

</details>

---

### 🔥 20 Tricky Interview MCQs – Arrays & Strings

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | `String s = "abc"; s.toUpperCase(); print(s);` | A) ABC B) abc C) Error D) null | **B) abc** | Strings immutable; `toUpperCase()` returns new String |
| 2 | `int[] a = {1,2}; int[] b = a; b[0]=10; print(a[0]);` | A) 1 B) 10 C) Error D) 0 | **B) 10** | Arrays are objects — `b` is reference copy |
| 3 | `"abc" == "a" + "bc"` | A) true B) false C) Error D) Depends | **A) true** | Compile-time constant expression → pool |
| 4 | `String a="a"; "abc" == a + "bc"` | A) true B) false C) Error D) Depends | **B) false** | Runtime concatenation creates new object |
| 5 | `new String("abc").intern() == "abc"` | A) true B) false C) Error D) Depends | **A) true** | intern() returns pool reference |
| 6 | `int[] arr = new int[0];` | A) Valid B) Error C) Warning D) NullPointer | **A) Valid** | Zero-length arrays are legal |
| 7 | `String s = ""; s.isEmpty() && s.length()==0` | A) true B) false C) Error D) null | **A) true** | Empty string has length 0 |
| 8 | `"Hello".replace("l", "")` | A) Heo B) Hello C) He D) Error | **A) "Heo"** | Removes all 'l's |
| 9 | `String[] s = {"a", "b"}; s[0] = null;` — Valid? | A) Yes B) No C) Error D) NullPointer | **A) Yes** | Array elements can be null |
| 10 | `StringBuilder sb = new StringBuilder(); sb.capacity()` | A) 0 B) 16 C) 10 D) Error | **B) 16** | Default capacity is 16 |
| 11 | `"abc".substring(0,0)` | A) "a" B) "" C) Error D) null | **B) ""** | Empty string (from=0, to=0) |
| 12 | Can you extend String class? | A) Yes B) No C) Only StringBuilder D) Sometimes | **B) No** | String is `final` class |
| 13 | `char[] c = {'H','i'}; String.valueOf(c)` | A) "Hi" B) Error C) [H, i] D) Address | **A) "Hi"** | valueOf converts char array to String |
| 14 | Memory used by: `"cat" + "dog"` | A) 3 objects B) 1 object C) 2 objects D) 0 | **B) 1** | Compiler optimizes to "catdog" at compile time |
| 15 | `int[] a = null; a.length` | A) 0 B) NullPointerException C) Error D) -1 | **B) NullPointerException** | null reference |
| 16 | `"hello" + 5 + 3` | A) "hello8" B) "hello53" C) Error D) 8hello | **B) "hello53"** | Left-to-right: "hello"+"5"="hello5"+"3"="hello53" |
| 17 | `5 + 3 + "hello"` | A) "53hello" B) "8hello" C) Error D) "hello53" | **B) "8hello"** | Left-to-right: 5+3=8, then "8"+"hello" |
| 18 | StringBuffer vs StringBuilder speed? | A) Same B) StringBuffer faster C) StringBuilder faster D) Depends | **C) StringBuilder faster** | No synchronization overhead |
| 19 | `String s = null; print(s + "abc");` | A) NullPointer B) "nullabc" C) "abc" D) Error | **B) "nullabc"** | null converted to "null" in concatenation |
| 20 | `String s = "abc"; s = s + 'd'; print(s.length());` | A) 3 B) 4 C) Error D) 5 | **B) 4** | 'd' is char, promotes to String "d", result "abcd" |

---

# 🖼️ Visual Reference Diagrams – Java Basics

## 📌 Variable Scope Diagram

```
┌──────────────────────────────────────────────────────────────────┐
│                      JAVA VARIABLE SCOPE                         │
│                                                                  │
│  class MyClass {                                                 │
│  │                                                               │
│  │  static int classVar = 10;   ← CLASS SCOPE (everywhere)      │
│  │                                                               │
│  │  void method1() {                                             │
│  │  │  int localVar = 5;        ← METHOD SCOPE (only here)      │
│  │  │                                                            │
│  │  │  for (int i = 0; i < 5; i++) {                            │
│  │  │  │  int loopVar = i;      ← BLOCK SCOPE (only in loop)    │
│  │  │  │  // loopVar accessible here                            │
│  │  │  }                                                         │
│  │  │  // loopVar NOT accessible here (out of scope)            │
│  │  │  // localVar still accessible here                        │
│  │  }                                                            │
│  │                                                               │
│  │  void method2() {                                             │
│  │  │  // classVar accessible here                               │
│  │  │  // localVar NOT accessible here                           │
│  │  }                                                            │
│  }                                                               │
└──────────────────────────────────────────────────────────────────┘
```

## 📌 Java Data Types Memory Map

```
┌─────────────────────────────────────────────────────────────────┐
│                  PRIMITIVE DATA TYPES                            │
│                                                                  │
│   Type      Size      Range                   Default           │
│   ──────────────────────────────────────────────────────        │
│   byte      1 byte    -128 to 127             0                 │
│   short     2 bytes   -32,768 to 32,767        0                │
│   int       4 bytes   -2B to 2B                0                │
│   long      8 bytes   very large               0L               │
│   float     4 bytes   6-7 decimal digits       0.0f             │
│   double    8 bytes   15-16 decimal digits     0.0d             │
│   char      2 bytes   0 to 65,535 (Unicode)    '\u0000'         │
│   boolean   1 bit     true / false             false            │
│                                                                  │
│  Memory usage visualization for: int a=1; long b=2L;            │
│                                                                  │
│  Stack:                                                          │
│  ┌────┬────┬────┬────┐ ┌────┬────┬────┬────┬────┬────┬────┬────┐│
│  │ 00 │ 00 │ 00 │ 01 │ │ 00 │ 00 │ 00 │ 00 │ 00 │ 00 │ 00 │ 02 ││
│  └────┴────┴────┴────┘ └────┴────┴────┴────┴────┴────┴────┴────┘│
│       a = 1 (4 bytes)          b = 2 (8 bytes)                  │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Java Operator Precedence (High → Low)

```
┌─────────────────────────────────────────────────────────────────┐
│            OPERATOR PRECEDENCE (highest to lowest)              │
│                                                                  │
│  Level  Operators                     Associativity             │
│  ─────────────────────────────────────────────────────          │
│   1     ()  []  .                     Left to Right             │
│   2     ++  --  ~  !  (unary)         Right to Left             │
│   3     *  /  %                       Left to Right             │
│   4     +  -                          Left to Right             │
│   5     <<  >>  >>>                   Left to Right             │
│   6     <  <=  >  >=  instanceof      Left to Right             │
│   7     ==  !=                        Left to Right             │
│   8     &  (bitwise AND)              Left to Right             │
│   9     ^  (bitwise XOR)              Left to Right             │
│  10     |  (bitwise OR)               Left to Right             │
│  11     &&  (logical AND)             Left to Right             │
│  12     ||  (logical OR)              Left to Right             │
│  13     ?:  (ternary)                 Right to Left             │
│  14     =  +=  -=  *=  /=  %= ...    Right to Left             │
│                                                                  │
│  Example: 2 + 3 * 4                                             │
│           ═══════════                                           │
│           * has higher precedence than +                         │
│           = 2 + (3 * 4) = 2 + 12 = 14   ✓                     │
│           NOT: (2 + 3) * 4 = 20          ✗                     │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Array Memory Layout

```
┌─────────────────────────────────────────────────────────────────┐
│                   ARRAY MEMORY DIAGRAM                           │
│                                                                  │
│  int[] arr = {10, 20, 30, 40, 50};                              │
│                                                                  │
│  Stack                    Heap                                   │
│  ┌──────────┐             ┌──────────────────────────────────┐  │
│  │ arr ─────┼────────────►│  [0]  [1]  [2]  [3]  [4]        │  │
│  │(reference)│            │   10   20   30   40   50         │  │
│  └──────────┘             │  addr addr addr addr addr         │  │
│                           │  1000 1004 1008 1012 1016         │  │
│                           └──────────────────────────────────┘  │
│                                                                  │
│  arr.length = 5   (NOT arr.length())  ← no parentheses!         │
│  arr[0] = 10      (first element)                                │
│  arr[4] = 50      (last element = arr[arr.length-1])            │
│                                                                  │
│  2D Array: int[][] matrix = {{1,2,3},{4,5,6}};                  │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │      [0]    [1]    [2]                                   │    │
│  │ [0]   1      2      3                                    │    │
│  │ [1]   4      5      6                                    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
│  matrix[0][0]=1  matrix[1][2]=6                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 String Pool vs Heap Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                   STRING MEMORY DIAGRAM                          │
│                                                                  │
│  String a = "hello";          // String Pool                    │
│  String b = "hello";          // Same pool object               │
│  String c = new String("hello"); // New Heap object             │
│  String d = "hello";          // Same as a,b                    │
│                                                                  │
│  Heap Memory:                                                    │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                                                          │    │
│  │   ┌──────────────────┐     ┌──────────────────┐         │    │
│  │   │  String Pool     │     │   Heap Area      │         │    │
│  │   │  ┌────────────┐  │     │  ┌────────────┐  │         │    │
│  │   │  │  "hello"   │  │     │  │  "hello"   │  │         │    │
│  │   │  │  @100      │  │     │  │  @200      │  │         │    │
│  │   │  └────────────┘  │     │  └────────────┘  │         │    │
│  │   │   ↑  ↑  ↑        │     │   ↑              │         │    │
│  │   └───│──│──│────────┘     └───│──────────────┘         │    │
│  │       │  │  │                  │                         │    │
│  │   a───┘  │  └───d         c───┘                         │    │
│  │          └──────b                                        │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
│  a == b  → true   (same pool object @100)                       │
│  a == c  → false  (pool @100 vs heap @200)                      │
│  a.equals(c) → true  (same content)                             │
│  a == d  → true   (same pool object @100)                       │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Loop Comparison Flowchart

```
┌────────────────┐  ┌────────────────┐  ┌────────────────────────┐
│   for loop     │  │  while loop    │  │    do-while loop       │
│                │  │                │  │                         │
│   init         │  │   condition?   │  │   body executes FIRST  │
│     │          │  │    ↓      ↓   │  │        │               │
│   condition?   │  │  true   false  │  │   condition?           │
│    ↓      ↓   │  │    │      │   │  │    ↓          ↓         │
│  true   false  │  │   body   END  │  │  true       false       │
│    │      │   │  │    │           │  │    │           │        │
│   body   END   │  │  update       │  │   repeat    END        │
│    │           │  │    │           │  │                         │
│  update         │  │  loop back ←──┘  │  ← Executes MINIMUM   │
│    │           │                      │    ONCE even if false  │
│  loop back ←───┘                      └────────────────────────┘
│                                                                 
│  Use:                  Use:                  Use:              
│  Known iteration       Unknown iteration     Must run once     
│  count                 count                 (menu, login)     
```

## 📌 Type Casting Flowchart

```
┌─────────────────────────────────────────────────────────────────┐
│                    TYPE CASTING RULES                            │
│                                                                  │
│    Widening (Implicit − Automatic)                               │
│    ─────────────────────────────────                            │
│    byte → short → int → long → float → double                   │
│                                ↑                                │
│                              char                               │
│                                                                  │
│    No data loss, compiler handles automatically                  │
│    int i = 100;   long l = i;   // OK - widening                │
│                                                                  │
│    Narrowing (Explicit − Manual Cast Required)                   │
│    ──────────────────────────────────────────                   │
│    double → float → long → int → short → byte                   │
│                                                                  │
│    May lose data! You must cast explicitly                       │
│    double d = 99.9;  int i = (int) d;  // i = 99 (loses .9)    │
│                                                                  │
│    Risk zones:                                                   │
│    double to int  → decimal part lost                           │
│    int to byte    → overflow if > 127                           │
│    int to char    → takes Unicode value                          │
└─────────────────────────────────────────────────────────────────┘
```

---

# 📚 Extra Examples – Java Basics

## Example: All Operator Types in One Program

```java
public class AllOperators {
    public static void main(String[] args) {
        // Arithmetic
        System.out.println(10 + 3);   // 13
        System.out.println(10 - 3);   // 7
        System.out.println(10 * 3);   // 30
        System.out.println(10 / 3);   // 3  (integer division)
        System.out.println(10 % 3);   // 1  (remainder)
        System.out.println(10.0 / 3); // 3.3333 (double division)

        // Unary
        int x = 5;
        System.out.println(x++); // 5 (post-increment: use then increment)
        System.out.println(x);   // 6
        System.out.println(++x); // 7 (pre-increment: increment then use)

        // Relational
        System.out.println(5 > 3);   // true
        System.out.println(5 == 5);  // true
        System.out.println(5 != 4);  // true

        // Logical
        System.out.println(true && false); // false
        System.out.println(true || false); // true
        System.out.println(!true);         // false

        // Assignment
        int a = 10;
        a += 5;  System.out.println(a); // 15
        a -= 3;  System.out.println(a); // 12
        a *= 2;  System.out.println(a); // 24
        a /= 4;  System.out.println(a); // 6
        a %= 4;  System.out.println(a); // 2

        // Ternary
        int max = (10 > 5) ? 10 : 5;
        System.out.println("Max: " + max); // Max: 10

        // Bitwise
        System.out.println(5 & 3);  // 1  (0101 & 0011 = 0001)
        System.out.println(5 | 3);  // 7  (0101 | 0011 = 0111)
        System.out.println(5 ^ 3);  // 6  (0101 ^ 0011 = 0110)
        System.out.println(~5);     // -6 (flip all bits)
        System.out.println(5 << 1); // 10 (shift left = multiply by 2)
        System.out.println(10 >> 1);// 5  (shift right = divide by 2)
    }
}
```

## Example: Type Casting All Cases

```java
public class TypeCastingAll {
    public static void main(String[] args) {
        // Widening (implicit)
        byte b = 10;
        short s = b;   // byte → short
        int i = s;     // short → int
        long l = i;    // int → long
        float f = l;   // long → float
        double d = f;  // float → double
        System.out.println("Widened to double: " + d); // 10.0

        // Narrowing (explicit)
        double pi = 3.14159;
        int piInt = (int) pi;      // loses decimal
        System.out.println("double to int: " + piInt); // 3

        int bigNum = 130;
        byte smallByte = (byte) bigNum; // overflow!
        System.out.println("int to byte (overflow): " + smallByte); // -126

        // char ↔ int
        char ch = 'A';
        int code = ch;             // widening: char → int
        System.out.println("'A' as int: " + code); // 65
        char back = (char)(code + 1);
        System.out.println("65+1 as char: " + back); // B

        // String conversions
        int num = Integer.parseInt("100");     // String → int
        double dbl = Double.parseDouble("3.14"); // String → double
        String str = String.valueOf(42);        // int → String
        System.out.println(num + " " + dbl + " " + str);
    }
}
```

## Example: Pattern Printing (Nested Loops)

```java
public class Patterns {
    public static void main(String[] args) {
        int n = 5;

        // Pattern 1: Right triangle of *
        System.out.println("=== Pattern 1 ===");
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= i; j++) System.out.print("* ");
            System.out.println();
        }
        // *
        // * *
        // * * *
        // * * * *
        // * * * * *

        // Pattern 2: Inverted triangle
        System.out.println("=== Pattern 2 ===");
        for (int i = n; i >= 1; i--) {
            for (int j = 1; j <= i; j++) System.out.print("* ");
            System.out.println();
        }

        // Pattern 3: Number pyramid
        System.out.println("=== Pattern 3 ===");
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= i; j++) System.out.print(j + " ");
            System.out.println();
        }
        // 1
        // 1 2
        // 1 2 3
        // 1 2 3 4
        // 1 2 3 4 5

        // Pattern 4: Diamond
        System.out.println("=== Pattern 4: Diamond ===");
        // Upper half
        for (int i = 1; i <= n; i++) {
            for (int sp = 1; sp <= n - i; sp++) System.out.print(" ");
            for (int j = 1; j <= 2*i-1; j++) System.out.print("*");
            System.out.println();
        }
        // Lower half
        for (int i = n-1; i >= 1; i--) {
            for (int sp = 1; sp <= n - i; sp++) System.out.print(" ");
            for (int j = 1; j <= 2*i-1; j++) System.out.print("*");
            System.out.println();
        }
    }
}
```

## Example: All String Methods Demo

```java
public class StringMethodsDemo {
    public static void main(String[] args) {
        String s = "  Hello, World!  ";

        // Basic info
        System.out.println(s.length());            // 17
        System.out.println(s.isEmpty());           // false
        System.out.println("".isEmpty());          // true
        System.out.println(s.isBlank());           // false
        System.out.println("  ".isBlank());        // true (Java 11+)

        // Trimming
        System.out.println(s.trim());              // "Hello, World!"
        System.out.println(s.strip());             // "Hello, World!" (Unicode-aware)

        // Search
        String t = "Hello, World!";
        System.out.println(t.indexOf('o'));        // 4
        System.out.println(t.lastIndexOf('o'));    // 8
        System.out.println(t.contains("World"));  // true
        System.out.println(t.startsWith("Hello")); // true
        System.out.println(t.endsWith("!"));       // true

        // Extraction
        System.out.println(t.charAt(0));           // H
        System.out.println(t.substring(7));        // World!
        System.out.println(t.substring(7, 12));    // World

        // Transformation
        System.out.println(t.toUpperCase());       // HELLO, WORLD!
        System.out.println(t.toLowerCase());       // hello, world!
        System.out.println(t.replace(",", ";"));   // Hello; World!
        System.out.println(t.replaceAll("[aeiou]", "*")); // H*ll*, W*rld!

        // Splitting & Joining
        String[] parts = "a,b,c".split(",");
        for (String p : parts) System.out.print(p + " "); // a b c
        System.out.println();
        System.out.println(String.join("-", "a","b","c")); // a-b-c

        // Comparison
        System.out.println("abc".equals("abc"));          // true
        System.out.println("abc".equalsIgnoreCase("ABC")); // true
        System.out.println("abc".compareTo("abd"));       // -1

        // Conversion
        System.out.println(String.valueOf(123));           // "123"
        System.out.println("abc".toCharArray().length);   // 3
        System.out.println("hello".repeat(3));            // hellohellohello

        // StringBuilder
        StringBuilder sb = new StringBuilder("Java");
        sb.append(" is great");
        sb.insert(4, " really");
        sb.delete(4, 11);
        sb.reverse();
        System.out.println(sb); // taerg si avaJ -> check manually
    }
}
```

---

# 📝 Extended Question Bank – Java Basics

## ✍️ Fill in the Blanks

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Java was developed by _______ at Sun Microsystems. | **James Gosling** |
| 2 | The filename must match the _______ class name. | **public** |
| 3 | `_______ = JRE + Compiler + Dev Tools` | **JDK** |
| 4 | The default value of `int` is _______. | **0** |
| 5 | `byte` can hold values from _______ to _______. | **-128 to 127** |
| 6 | `_______ casting` is done automatically by compiler. | **Widening (implicit)** |
| 7 | `String` class is located in `java._______` package. | **lang** |
| 8 | The `switch` statement supports `byte`, `short`, `int`, `char`, `String`, and _______ (Java 5+). | **enum** |
| 9 | `do-while` loop always executes the body at least _______ time(s). | **once (1)** |
| 10 | `int[] arr = new int[5];` — `arr[0]` default value is _______. | **0** |
| 11 | `boolean[] b = new boolean[3];` — `b[0]` is _______. | **false** |
| 12 | `String` objects are _______ (cannot be changed after creation). | **immutable** |
| 13 | `StringBuilder` is _______ (can be changed). | **mutable** |
| 14 | `System.out._______("text")` adds a newline at end. | **println** |
| 15 | The operator `%` gives the _______ of a division. | **remainder / modulus** |
| 16 | `continue` skips the _______ iteration of a loop. | **current** |
| 17 | `break` exits the _______ loop/switch entirely. | **nearest enclosing** |
| 18 | A method that calls itself is called a _______ method. | **recursive** |
| 19 | `char` holds _______ character at a time. | **one** |
| 20 | `double d = 1.0 / 0;` results in _______. | **Infinity** |

---

## 🔗 Match the Following

### Set A – Keywords

| # | Term | → | Match |
|---|------|---|-------|
| 1 | `static` | | Used to create object |
| 2 | `new` | | Constants that can't change |
| 3 | `final` | | Belongs to class, not instance |
| 4 | `void` | | No return value |
| 5 | `this` | | Refers to current object |

**Answers:** 1→C, 2→A, 3→B, 4→D, 5→E

---

### Set B – Data Types & Sizes

| Type | Size |
|------|------|
| 1. `int` | A. 8 bytes |
| 2. `long` | B. 1 byte |
| 3. `byte` | C. 2 bytes |
| 4. `char` | D. 4 bytes |
| 5. `double` | E. 8 bytes |

**Answers:** 1→D, 2→A (or E), 3→B, 4→C, 5→E

---

### Set C – Operators

| Expression | Result |
|------------|--------|
| 1. `5 % 2` | A. `true` |
| 2. `"a" + "b"` | B. `1` |
| 3. `5 > 3` | C. `false` |
| 4. `5 == 6` | D. `"ab"` |
| 5. `!(true)` | E. `5` |

**Answers:** 1→B, 2→D, 3→A, 4→C, 5→C (false)

---

## 🐛 Error Spotting – Find the Bug

### Bug 1
```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello World!)   // Bug here
    }
}
```
**Bug:** Missing closing quote `"` after "World!". Should be `"Hello World!")`

---

### Bug 2
```java
int x = 5;
if x > 3 {
    System.out.println("Greater");
}
```
**Bug:** Missing parentheses around condition. Should be `if (x > 3) {`

---

### Bug 3
```java
int[] arr = new int[5];
System.out.println(arr[5]);  // Access index 5
```
**Bug:** `ArrayIndexOutOfBoundsException` — valid indices are 0–4. Should be `arr[4]`

---

### Bug 4
```java
for (int i = 0; i < 5; i--) {
    System.out.println(i);
}
```
**Bug:** Infinite loop — `i--` decrements instead of incrementing. Should be `i++`

---

### Bug 5
```java
int result = 10 / 0;
System.out.println(result);
```
**Bug:** `ArithmeticException: / by zero`. Wrap in try-catch or avoid dividing by zero.

---

### Bug 6
```java
String s;
System.out.println(s.length());
```
**Bug:** `s` is declared but not initialized — compile error: "variable s might not have been initialized."

---

### Bug 7
```java
double d = 3.14;
int i = d;   // No explicit cast
```
**Bug:** Narrowing conversion needs explicit cast: `int i = (int) d;`

---

### Bug 8
```java
switch (day) {
    case "Monday":
        System.out.println("Start of week");
    case "Friday":
        System.out.println("End of week");
}
```
**Bug:** Missing `break` after first case — will fall through to "End of week" if day is "Monday"!

---

### Bug 9
```java
int sum = 0;
for (int i = 1; i = 10; i++) {   // = instead of <=
    sum += i;
}
```
**Bug:** `i = 10` is assignment not comparison. Should be `i <= 10`

---

### Bug 10
```java
String s = "Hello";
if (s == "Hello") {
    System.out.println("Equal");
}
```
**Bug (Logical):** Using `==` for String comparison checks reference, not content. Should use `s.equals("Hello")` — though this may work for literals, it's wrong practice.

---

## 🖥️ Output Prediction – Tricky Code

### Q1
```java
int a = 5, b = 10;
System.out.println(a++ + ++b);
```
**Output:** `16`
> `a++` = 5 (then a=6), `++b` = 11. 5 + 11 = 16.

---

### Q2
```java
for (int i = 0; i < 3; i++) {
    System.out.print(i + " ");
}
```
**Output:** `0 1 2 `

---

### Q3
```java
int x = 10;
if (x > 5)
    if (x > 8)
        System.out.println("Greater than 8");
    else
        System.out.println("Greater than 5");
```
**Output:** `Greater than 8`
> Dangling else attaches to nearest if. `x=10 > 8` so inner if is true.

---

### Q4
```java
int i = 0;
do {
    System.out.print(i + " ");
    i++;
} while (i < 0);
```
**Output:** `0 `
> do-while always runs once; condition false after.

---

### Q5
```java
System.out.println(1 + 2 + "3" + 4 + 5);
```
**Output:** `3345`
> `1+2=3`, then `3+"3"="33"`, then `"33"+4="334"`, then `"334"+5="3345"`

---

### Q6
```java
String s = "Java";
s.concat(" is fun");
System.out.println(s);
```
**Output:** `Java`
> String is immutable. `concat()` returns new String but it's not assigned.

---

### Q7
```java
int[] arr = {5, 10, 15};
for (int x : arr) {
    x = x * 2;  // modifying local copy
}
System.out.println(arr[0]);
```
**Output:** `5`
> Enhanced for-loop works on a copy. Original array unchanged.

---

### Q8
```java
int a = 5;
int b = a = 10;
System.out.println(a + " " + b);
```
**Output:** `10 10`
> `a = 10` assigns 10 to a, then b gets the result (10).

---

### Q9
```java
System.out.println(10 > 5 ? "yes" : "no");
System.out.println(10 < 5 ? "yes" : 10 > 3 ? "maybe" : "no");
```
**Output:**
```
yes
maybe
```

---

### Q10
```java
int x = 0;
x = x++ + x++;
System.out.println(x);
```
**Output:** `1`
> First `x++` returns 0, x becomes 1. Second `x++` returns 1, x becomes 2. So `x = 0 + 1 = 1`. x is then set to 1.

---

### Q11
```java
String s = "hello world java";
String[] words = s.split(" ");
System.out.println(words.length);
System.out.println(words[1]);
```
**Output:**
```
3
world
```

---

### Q12
```java
char c = 'A';
c += 3;
System.out.println(c);
```
**Output:** `D`
> `'A'` has ASCII 65. 65+3=68 = `'D'`

---

### Q13
```java
int num = 255;
System.out.println(Integer.toBinaryString(num));
System.out.println(Integer.toHexString(num));
System.out.println(Integer.toOctalString(num));
```
**Output:**
```
11111111
ff
377
```

---

### Q14
```java
for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
        if (i == j) System.out.print(i + " ");
    }
}
```
**Output:** `1 2 3 `

---

### Q15
```java
int n = 12345;
int sum = 0;
while (n > 0) {
    sum += n % 10;
    n /= 10;
}
System.out.println(sum);
```
**Output:** `15`
> Sum of digits: 1+2+3+4+5 = 15

---

## 🧐 Short Answer – Concept Questions

| # | Question | Answer |
|---|----------|--------|
| 1 | What happens if `main` method is not `public`? | Compiles but JVM can't call it — `Error: Main method not found` |
| 2 | Can we have multiple `main` methods in one class? | Yes (method overloading), but JVM calls `main(String[])` only |
| 3 | What is the difference between `print()` and `println()`? | `print()` — no newline; `println()` — adds newline at end |
| 4 | Can `String` be null? Can `int` be null? | String can be null (object ref); int cannot (primitive) |
| 5 | What is an infinite loop? Give example. | Loop that never terminates: `while(true) {}` |
| 6 | Explain `static` main method. | Static so JVM can call it without creating an object of the class |
| 7 | What is the range of `char` in Java? | 0 to 65,535 (Unicode, unsigned 16-bit) |
| 8 | What happens if `break` is not used in switch? | Falls through to next case (fall-through behavior) |
| 9 | Can `final` variable be declared without initialization? | Yes, but must be assigned exactly once before use (blank final) |
| 10 | Why use `StringBuilder` over `String` for loops? | String creates new object each concat (O(n²)); StringBuilder appends in-place (O(n)) |

---

> **🎉 End of File 1 – Java Basics Complete!**
> 
> Next: [02_OOP_in_Java.md](02_OOP_in_Java.md) – Object-Oriented Programming
