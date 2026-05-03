# 01. Introduction to Java

## Table of Contents
- [1.1 What is Java?](#11-what-is-java)
- [1.2 Features of Java](#12-features-of-java)
- [1.3 JVM, JRE, JDK Architecture](#13-jvm-jre-jdk-architecture)
- [1.4 Compilation and Execution Process](#14-compilation-and-execution-process)
- [1.5 First Java Program](#15-first-java-program)
- [1.6 Practice & Assessment](#16-practice--assessment)

---

## 1.1 What is Java?

### Definition
**Java** is a high-level, object-oriented, platform-independent programming language developed by James Gosling at Sun Microsystems in 1995 (now owned by Oracle).

### Purpose
- Build desktop applications, web applications, mobile apps (Android), and enterprise systems
- "Write Once, Run Anywhere" (WORA) — compiled code runs on any platform with a JVM

### History Timeline
| Year | Event |
|------|-------|
| 1991 | James Gosling starts "Oak" project |
| 1995 | Renamed to Java, released publicly |
| 2006 | Java open-sourced |
| 2010 | Oracle acquires Sun Microsystems |
| 2014 | Java 8 (Lambdas, Streams) |
| 2017 | Java 9 (Modules) |
| 2021 | Java 17 LTS |
| 2023 | Java 21 LTS |

---

## 1.2 Features of Java

| Feature | Explanation |
|---------|-------------|
| **Platform Independent** | Bytecode runs on any OS with JVM |
| **Object-Oriented** | Everything is an object (except primitives) |
| **Simple** | No pointers, no manual memory management |
| **Robust** | Strong type checking, exception handling, garbage collection |
| **Secure** | No pointer arithmetic, bytecode verifier, security manager |
| **Multithreaded** | Built-in support for concurrent programming |
| **Portable** | Same bytecode on Windows, Linux, Mac |
| **High Performance** | JIT (Just-In-Time) compiler optimizes at runtime |
| **Distributed** | Built-in networking (RMI, sockets) |
| **Dynamic** | Classes loaded on demand at runtime |

### Java vs Other Languages

| Feature | Java | C++ | Python |
|---------|------|-----|--------|
| Platform | Independent | Dependent | Independent |
| Memory | Automatic (GC) | Manual | Automatic |
| Speed | Fast (JIT) | Fastest | Slower |
| Syntax | Moderate | Complex | Simple |
| OOP | Pure OOP | Multi-paradigm | Multi-paradigm |
| Compilation | Compiled + Interpreted | Compiled | Interpreted |

---

## 1.3 JVM, JRE, JDK Architecture

### Diagram

```
┌─────────────────────────────────────────────────────────┐
│                         JDK                             │
│  (Java Development Kit)                                 │
│  ┌───────────────────────────────────────────────────┐  │
│  │                      JRE                          │  │
│  │  (Java Runtime Environment)                       │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │                 JVM                          │  │  │
│  │  │  (Java Virtual Machine)                      │  │  │
│  │  │                                             │  │  │
│  │  │  • Class Loader                             │  │  │
│  │  │  • Bytecode Verifier                        │  │  │
│  │  │  • Execution Engine (JIT Compiler)          │  │  │
│  │  │  • Garbage Collector                        │  │  │
│  │  │  • Runtime Data Areas (Heap, Stack, etc.)   │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  │                                                   │  │
│  │  + Java Class Libraries (rt.jar)                  │  │
│  │  + java, javaw (runtime executables)              │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
│  + javac (compiler)                                     │
│  + jar (archive tool)                                   │
│  + javadoc (documentation generator)                    │
│  + jdb (debugger)                                       │
└─────────────────────────────────────────────────────────┘
```

### Definitions

| Component | What It Is | Who Needs It |
|-----------|-----------|--------------|
| **JVM** | Virtual machine that executes bytecode | Everyone running Java |
| **JRE** | JVM + class libraries (runtime only) | Users who only RUN Java apps |
| **JDK** | JRE + development tools (javac, jar, etc.) | Developers who WRITE Java code |

### Key Point
> **JDK ⊃ JRE ⊃ JVM** — JDK contains JRE, which contains JVM.

---

## 1.4 Compilation and Execution Process

### Flow Diagram

```
┌──────────┐     javac      ┌──────────────┐      JVM       ┌──────────┐
│ Hello.java│ ───────────► │ Hello.class   │ ────────────► │  Output   │
│(source code)│  (compile)   │ (bytecode)    │  (interpret/  │  on screen│
└──────────┘               └──────────────┘   JIT compile) └──────────┘
```

### Step-by-Step

```
Step 1: Write source code → Hello.java
Step 2: Compile with javac → Hello.class (bytecode)
Step 3: JVM loads bytecode
Step 4: Bytecode Verifier checks for security
Step 5: Execution Engine runs the code
        - Interpreter: line by line (slow)
        - JIT Compiler: compiles hot methods to native code (fast)
Step 6: Output displayed
```

### Why Platform Independent?

```
                    Hello.class (same bytecode)
                           │
            ┌──────────────┼──────────────┐
            ▼              ▼              ▼
    ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
    │ JVM (Windows)│ │ JVM (Linux)  │ │ JVM (Mac)    │
    └──────────────┘ └──────────────┘ └──────────────┘
            │              │              │
            ▼              ▼              ▼
      Native code    Native code    Native code
      (Windows)      (Linux)        (Mac)
```

> The JVM is **platform-dependent** (different JVM for each OS), but the **bytecode is platform-independent**.

---

## 1.5 First Java Program

```java
// File: Hello.java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

### Line-by-Line Explanation

| Line | Explanation |
|------|-------------|
| `public class Hello` | Declares a public class named Hello (must match filename) |
| `public` | Accessible from anywhere |
| `static` | Can be called without creating an object |
| `void` | Returns nothing |
| `main(String[] args)` | Entry point of the program; args = command-line arguments |
| `System.out.println(...)` | Prints text to console with newline |

### Compile and Run

```bash
# Compile
javac Hello.java
# Creates: Hello.class

# Run
java Hello
# Output: Hello, World!
```

### Common Mistakes

| Mistake | Error |
|---------|-------|
| File name ≠ class name | Compilation error |
| Missing `main` method | Runtime error: Main method not found |
| `Main` instead of `main` | Case sensitive — won't find main |
| Missing semicolon | Compilation error |
| `System.out.Println` | Wrong case — `println` not `Println` |

---

## 1.6 Practice & Assessment

### MCQs

**Q1.** Java is platform independent because:
- A) It uses pointers
- B) Bytecode runs on any JVM
- C) It compiles to machine code directly
- D) It doesn't need compilation

**Answer:** B — Bytecode is platform-independent; the JVM handles OS differences.

---

**Q2.** Which tool compiles Java source code?
- A) java
- B) javac
- C) jvm
- D) jar

**Answer:** B — `javac` is the Java compiler.

---

**Q3.** JRE contains:
- A) Only JVM
- B) JVM + Development tools
- C) JVM + Class libraries
- D) Only class libraries

**Answer:** C — JRE = JVM + Class libraries (no dev tools).

---

**Q4.** The extension of compiled Java bytecode is:
- A) .java
- B) .exe
- C) .class
- D) .byte

**Answer:** C — `.class` files contain bytecode.

---

### Short Questions

1. **What is the role of JIT compiler?**
   → JIT (Just-In-Time) converts frequently used bytecode into native machine code at runtime for faster execution.

2. **Why is `main` method `static`?**
   → So JVM can call it without creating an object of the class first.

3. **What happens if class name doesn't match file name?**
   → Compilation error (for public classes).

---

### Coding Tasks

**Task 1:** Write a program that prints your name, age, and city on separate lines.

```java
public class MyInfo {
    public static void main(String[] args) {
        System.out.println("Name: Alice");
        System.out.println("Age: 21");
        System.out.println("City: Mumbai");
    }
}
```

**Task 2:** Write a program that prints using `print` (no newline) and `println` (with newline).

```java
public class PrintDemo {
    public static void main(String[] args) {
        System.out.print("Hello ");      // No newline
        System.out.print("World");       // Same line
        System.out.println();            // Newline
        System.out.println("New line");  // Separate line
    }
}
// Output:
// Hello World
// New line
```

---

> **Next Topic:** [02 - Java Basics](02-java-basics.md)
