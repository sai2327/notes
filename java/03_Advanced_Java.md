# 📘 Advanced Java – Complete Guide

> **Exception Handling, Packages, File Handling, and Multithreading — explained with examples, diagrams, and interview prep.**

---

# Table of Contents

- [1. Exception Handling](#1-exception-handling)
- [2. Packages and Access Modifiers](#2-packages-and-access-modifiers)
- [3. File Handling](#3-file-handling)
- [4. Multithreading](#4-multithreading)

---

# 1. Exception Handling

## Concept Explanation

An **exception** is an unwanted or unexpected event that disrupts the normal flow of a program. Java provides a robust mechanism to **handle** runtime errors gracefully.

```
┌────────────────────────────────────────────────────────────┐
│                Exception Hierarchy                          │
│                                                             │
│                    java.lang.Object                          │
│                         │                                    │
│                   Throwable                                  │
│                    ┌────┴────┐                               │
│                    │         │                               │
│                 Error     Exception                          │
│                 (Don't    ┌────┴──────────┐                  │
│                  catch)   │               │                  │
│                        Checked       Unchecked               │
│                     (Compile-time)  (RuntimeException)       │
│                                                             │
│   Errors:              Checked:        Unchecked:            │
│   - StackOverflow      - IOException   - NullPointer         │
│   - OutOfMemory        - SQLException  - ArrayIndexOutOfBounds│
│   - VirtualMachineError- FileNotFound  - ArithmeticException │
│                        - ClassNotFound - ClassCastException   │
│                                       - NumberFormatException│
└────────────────────────────────────────────────────────────┘
```

### Checked vs Unchecked Exceptions

| Feature | Checked Exception | Unchecked Exception |
|---------|------------------|-------------------|
| **When detected** | Compile time | Runtime |
| **Handling** | Must handle (try-catch or throws) | Optional handling |
| **Extends** | `Exception` | `RuntimeException` |
| **Examples** | IOException, SQLException | NullPointerException, ArithmeticException |
| **Cause** | External factors (file, DB, network) | Programming bugs |

## Syntax

```java
try {
    // Code that may throw exception
} catch (ExceptionType1 e) {
    // Handle ExceptionType1
} catch (ExceptionType2 e) {
    // Handle ExceptionType2
} finally {
    // Always executes (cleanup code)
}
```

## Example Code – try, catch, finally

```java
public class ExceptionDemo {
    public static void main(String[] args) {
        // Example 1: ArithmeticException
        try {
            int result = 10 / 0;  // throws ArithmeticException
            System.out.println("Result: " + result);  // never reached
        } catch (ArithmeticException e) {
            System.out.println("Error: Cannot divide by zero!");
            System.out.println("Message: " + e.getMessage());
        } finally {
            System.out.println("Finally block always runs!");
        }

        // Example 2: Multiple catch blocks
        try {
            int[] arr = {1, 2, 3};
            System.out.println(arr[5]);  // ArrayIndexOutOfBoundsException
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Array index error: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("General exception: " + e.getMessage());
        }

        // Example 3: NumberFormatException
        try {
            int num = Integer.parseInt("abc");  // NumberFormatException
        } catch (NumberFormatException e) {
            System.out.println("Invalid number format!");
        }

        System.out.println("Program continues normally...");
    }
}
```

## Output

```
Error: Cannot divide by zero!
Message: / by zero
Finally block always runs!
Array index error: Index 5 out of bounds for length 3
Invalid number format!
Program continues normally...
```

## throw and throws

```java
public class ThrowDemo {

    // throws - declares exception in method signature
    static void validateAge(int age) throws IllegalArgumentException {
        if (age < 18) {
            // throw - explicitly throws an exception
            throw new IllegalArgumentException("Age must be 18+, got: " + age);
        }
        System.out.println("Valid age: " + age);
    }

    // Checked exception with throws
    static void readFile(String path) throws java.io.IOException {
        java.io.FileReader fr = new java.io.FileReader(path);
        // if file doesn't exist, throws FileNotFoundException
    }

    public static void main(String[] args) {
        // Handling thrown exception
        try {
            validateAge(15);
        } catch (IllegalArgumentException e) {
            System.out.println("Caught: " + e.getMessage());
        }

        // Handling checked exception
        try {
            readFile("nonexistent.txt");
        } catch (java.io.IOException e) {
            System.out.println("File error: " + e.getMessage());
        }
    }
}
```

### throw vs throws

| `throw` | `throws` |
|---------|----------|
| Used **inside** method body | Used **in method signature** |
| Throws **one** exception | Declares **multiple** exceptions |
| Followed by **object** | Followed by **class name** |
| `throw new Exception("msg")` | `void m() throws IOException, SQLException` |

## Custom Exceptions

```java
// Custom Checked Exception
class InsufficientBalanceException extends Exception {
    double balance;
    double amount;

    InsufficientBalanceException(double balance, double amount) {
        super("Cannot withdraw $" + amount + " from balance $" + balance);
        this.balance = balance;
        this.amount = amount;
    }
}

// Custom Unchecked Exception
class InvalidAccountException extends RuntimeException {
    InvalidAccountException(String msg) {
        super(msg);
    }
}

class BankAccount {
    private double balance;
    private String accountId;

    BankAccount(String accountId, double balance) {
        if (accountId == null || accountId.isEmpty()) {
            throw new InvalidAccountException("Account ID cannot be empty");
        }
        this.accountId = accountId;
        this.balance = balance;
    }

    void withdraw(double amount) throws InsufficientBalanceException {
        if (amount > balance) {
            throw new InsufficientBalanceException(balance, amount);
        }
        balance -= amount;
        System.out.println("Withdrawn: $" + amount + " | Balance: $" + balance);
    }
}

public class CustomExceptionDemo {
    public static void main(String[] args) {
        try {
            BankAccount acc = new BankAccount("ACC001", 1000);
            acc.withdraw(500);   // Works fine
            acc.withdraw(700);   // Throws InsufficientBalanceException
        } catch (InsufficientBalanceException e) {
            System.out.println("Error: " + e.getMessage());
        }

        try {
            BankAccount invalid = new BankAccount("", 500); // Throws InvalidAccountException
        } catch (InvalidAccountException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

## Output

```
Withdrawn: $500.0 | Balance: $500.0
Error: Cannot withdraw $700.0 from balance $500.0
Error: Account ID cannot be empty
```

## Visual Explanation – Exception Flow

```
Normal Flow:                  Exception Flow:
┌──────┐                      ┌──────┐
│ stmt1│                      │ stmt1│ ✅
│ stmt2│                      │ stmt2│ ✅
│ stmt3│  ← all execute       │ stmt3│ ❌ EXCEPTION!
│ stmt4│                      │ stmt4│ ← SKIPPED
│ stmt5│                      │ stmt5│ ← SKIPPED
└──────┘                      └──────┘
                                   │
                              ┌────▼────┐
                              │  catch   │ ← handles error
                              └────┬────┘
                              ┌────▼────┐
                              │ finally  │ ← always runs
                              └────┬────┘
                              ┌────▼────┐
                              │ Continue │ ← program goes on
                              └─────────┘
```

## try-with-resources (Java 7+)

```java
import java.io.*;

public class TryWithResources {
    public static void main(String[] args) {
        // Automatically closes resources
        try (BufferedReader br = new BufferedReader(new FileReader("file.txt"))) {
            String line;
            while ((line = br.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException e) {
            System.out.println("Error: " + e.getMessage());
        }
        // No need for finally block to close br!
    }
}
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Catching `Exception` before specific exceptions | Put specific catches first, general last |
| Empty catch block `catch(Exception e) {}` | Always handle or log exceptions |
| Not closing resources in finally | Use try-with-resources (Java 7+) |
| Using exceptions for control flow | Exceptions are for exceptional situations, not logic |
| Catching `Error` | Don't catch Errors (OutOfMemoryError, etc.) |

## Interview Tips

- **finally** always executes (except `System.exit()` or JVM crash)
- `finally` runs even if there's a `return` in try/catch
- **Multi-catch** (Java 7+): `catch (IOException | SQLException e)`
- `try-with-resources` auto-closes `AutoCloseable` resources
- Custom checked exception: `extends Exception`
- Custom unchecked exception: `extends RuntimeException`
- `finally` block CAN override a return value (bad practice)
- Catch blocks are checked top-to-bottom; subclass must come before superclass

## Quick Revision

> - `try` → risky code, `catch` → handle exception, `finally` → cleanup
> - `throw` → throw exception object, `throws` → declare in signature
> - Checked vs Unchecked: compile-time vs runtime
> - Custom exceptions: extend `Exception` or `RuntimeException`
> - `finally` ALWAYS runs (except `System.exit()`)
> - try-with-resources → auto-close (Java 7+)

---

## 📝 Practice – Exception Handling

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What is an exception? | Unwanted event disrupting program flow |
| 2 | What block handles exceptions? | `catch` block |
| 3 | Does `finally` always execute? | Yes (except System.exit() or JVM crash) |
| 4 | What is the parent of all exceptions? | `Throwable` |
| 5 | What is a checked exception? | Exception detected at compile time |
| 6 | What is an unchecked exception? | Exception at runtime (RuntimeException) |
| 7 | What does `throw` do? | Explicitly throws an exception |
| 8 | What does `throws` do? | Declares exceptions a method might throw |
| 9 | Can we have try without catch? | Yes, with `finally` |
| 10 | What is NullPointerException? | Accessing a method/field on a null reference |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `catch(Exception e)` should be placed? | A) First B) Last C) Anywhere D) Doesn't matter | **B) Last** (most general) |
| 2 | `finally` without `catch` is? | A) Error B) Valid C) Warning D) Depends | **B) Valid** (`try-finally` is okay) |
| 3 | Which is checked? | A) NullPointerException B) IOException C) ArithmeticException D) ClassCastException | **B) IOException** |
| 4 | `int x = 10/0;` throws? | A) IOException B) ArithmeticException C) NullPointer D) NumberFormat | **B) ArithmeticException** |
| 5 | Custom checked exception extends? | A) RuntimeException B) Error C) Exception D) Throwable | **C) Exception** |
| 6 | `throw new Exception();` is valid inside? | A) Any method B) Only try C) Only catch D) Only main | **A) Any method** (must be handled) |
| 7 | `try-with-resources` requires? | A) finally B) AutoCloseable C) catch D) throws | **B) AutoCloseable** interface |
| 8 | Multi-catch separator? | A) , B) & C) \| D) && | **C) \|** (pipe) |
| 9 | Can `finally` change return value? | A) No B) Yes C) Depends D) Error | **B) Yes** (but bad practice) |
| 10 | `Error` vs `Exception`? | A) Same B) Error = unrecoverable C) Error = checked D) No difference | **B) Error = unrecoverable** |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `try { return 1; } finally { return 2; }` returns? | A) 1 B) 2 C) Error D) Both | **B) 2** — finally's return overrides try's return |
| 2 | `try { } catch(IOException \| SQLException e) { e = new IOException(); }` — valid? | A) Yes B) No C) Warning D) Depends | **B) No** — multi-catch variable is implicitly final |
| 3 | Can a catch block throw exception? | A) No B) Yes C) Only RuntimeException D) Error | **B) Yes** |
| 4 | Can constructor throw checked exception? | A) No B) Yes C) Only unchecked D) Error | **B) Yes** |
| 5 | Method overriding: child throws broader checked exception? | A) Valid B) Error C) Warning D) Depends | **B) Compile Error** — can only throw same/narrower/none |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | `finally` runs after `System.exit(0)` | **False** |
| 2 | `RuntimeException` is unchecked | **True** |
| 3 | `try` block can be empty | **True** (but pointless) |
| 4 | You can catch `Error` | **True** (possible but not recommended) |
| 5 | `throws` can declare multiple exceptions | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Write a program that handles `ArrayIndexOutOfBoundsException` and `NumberFormatException`.

<details>
<summary>Solution</summary>

```java
public class MultiExceptionDemo {
    public static void main(String[] args) {
        String[] numbers = {"10", "20", "abc", "40"};

        for (int i = 0; i <= numbers.length; i++) {
            try {
                int num = Integer.parseInt(numbers[i]);
                System.out.println("Parsed: " + num);
            } catch (NumberFormatException e) {
                System.out.println("Invalid number at index " + i);
            } catch (ArrayIndexOutOfBoundsException e) {
                System.out.println("Index " + i + " out of bounds!");
            }
        }
    }
}
// Output:
// Parsed: 10
// Parsed: 20
// Invalid number at index 2
// Parsed: 40
// Index 4 out of bounds!
```

</details>

**Exercise 2:** Create a custom exception `InvalidAgeException` and use it.

<details>
<summary>Solution</summary>

```java
class InvalidAgeException extends Exception {
    InvalidAgeException(String msg) {
        super(msg);
    }
}

public class AgeValidator {
    static void validate(int age) throws InvalidAgeException {
        if (age < 0 || age > 150) {
            throw new InvalidAgeException("Invalid age: " + age);
        }
        System.out.println("Valid age: " + age);
    }

    public static void main(String[] args) {
        try {
            validate(25);    // Valid age: 25
            validate(-5);    // Throws InvalidAgeException
        } catch (InvalidAgeException e) {
            System.out.println(e.getMessage()); // Invalid age: -5
        }
    }
}
```

</details>

---

### 🔥 20 Tricky Interview MCQs – Exception Handling

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | `try { } finally { }` without catch? | A) Error B) Valid C) Warning D) Depends | **B) Valid** | catch is optional when finally exists |
| 2 | `catch(Exception e)` before `catch(IOException e)`? | A) Valid B) Error C) Warning D) Depends | **B) Compile Error** | More specific must come first |
| 3 | `finally` block purpose? | A) Handle exception B) Cleanup (close resources) C) Throw exception D) Log | **B) Cleanup** |
| 4 | `throw null;` is? | A) Error B) Throws NullPointerException C) Nothing D) Depends | **B) Throws NullPointerException** at runtime |
| 5 | Can `main()` throw exception? | A) No B) Yes C) Only unchecked D) Error | **B) Yes** — `main() throws Exception` is valid |
| 6 | Unreachable catch block? | A) Warning B) Compile Error C) Depends D) Runs | **B) Compile Error** |
| 7 | `String.charAt(-1)` throws? | A) IOException B) StringIndexOutOfBoundsException C) ArithmeticException D) NullPointer | **B) StringIndexOutOfBoundsException** |
| 8 | `Object o = null; o.toString();` throws? | A) IOException B) ArithmeticException C) NullPointerException D) None | **C) NullPointerException** |
| 9 | `int[] a = new int[-1];` throws? | A) ArrayIndexOutOfBoundsException B) NegativeArraySizeException C) Error D) null | **B) NegativeArraySizeException** |
| 10 | Which is NOT a `RuntimeException`? | A) NullPointer B) ArrayIndexOOB C) IOException D) ArithmeticException | **C) IOException** (it's checked) |
| 11 | `try { return; } finally { System.out.println("X"); }` | A) Prints X B) No output C) Error D) Depends | **A) Prints X** — finally runs before return |
| 12 | Can we rethrow an exception? | A) No B) Yes C) Error D) Only in finally | **B) Yes** — `catch(Ex e) { throw e; }` |
| 13 | `StackOverflowError` is? | A) Exception B) Error C) RuntimeException D) Checked | **B) Error** |
| 14 | `throws` in overriding method? | A) Can add new checked B) Cannot add new checked C) Must match D) Error | **B) Cannot add new/broader checked exceptions** |
| 15 | `try-with-resources` releases in what order? | A) FIFO B) LIFO C) Random D) Alphabetical | **B) LIFO** (last opened = first closed) |
| 16 | `finally { throw new RuntimeException(); }` + try returns value? | A) Returns value B) Throws exception C) Both D) Error | **B) Throws exception** — finally overrides |
| 17 | `Exception` is parent of `RuntimeException`? | A) No B) Yes C) Sibling D) Error | **B) Yes** |
| 18 | Suppressed exceptions in try-with-resources? | A) Lost B) Accessible via getSuppressed() C) Error D) Ignored | **B) getSuppressed()** |
| 19 | Can interface method have `throws`? | A) No B) Yes C) Only default D) Error | **B) Yes** |
| 20 | `ClassCastException` is? | A) Checked B) Unchecked C) Error D) Throwable | **B) Unchecked** (RuntimeException) |

---

# 2. Packages and Access Modifiers

## Concept Explanation

A **package** is a namespace that organizes classes and interfaces into groups, preventing naming conflicts and controlling access.

```
┌───────────────────────────────────────────┐
│          Java Package Structure            │
│                                            │
│  java                                      │
│   ├── lang    (auto-imported)              │
│   │   ├── String                           │
│   │   ├── Math                             │
│   │   ├── Object                           │
│   │   ├── System                           │
│   │   └── Integer, etc.                    │
│   ├── util                                 │
│   │   ├── Scanner                          │
│   │   ├── ArrayList                        │
│   │   ├── HashMap                          │
│   │   └── Collections                      │
│   ├── io                                   │
│   │   ├── File                             │
│   │   ├── FileReader                       │
│   │   └── BufferedReader                   │
│   └── math                                 │
│       └── BigDecimal, BigInteger           │
└───────────────────────────────────────────┘
```

### Built-in Packages

| Package | Description | Key Classes |
|---------|-------------|-------------|
| `java.lang` | Core classes (auto-imported) | String, Math, Object, System, Thread |
| `java.util` | Utilities & collections | Scanner, ArrayList, HashMap, Date |
| `java.io` | Input/Output | File, FileReader, BufferedReader |
| `java.math` | Big numbers | BigDecimal, BigInteger |
| `java.net` | Networking | Socket, URL, HttpURLConnection |
| `java.sql` | Database | Connection, Statement, ResultSet |
| `java.time` | Date/Time (Java 8+) | LocalDate, LocalTime, LocalDateTime |

## Syntax

```java
// Define package (first statement in file)
package com.myapp.utils;

// Import specific class
import java.util.ArrayList;

// Import all classes from a package
import java.util.*;

// Static import
import static java.lang.Math.PI;
import static java.lang.Math.sqrt;
```

## Custom Package Example

```
Project Structure:
src/
 └── com/
      └── myapp/
           ├── model/
           │    └── Student.java
           └── service/
                └── StudentService.java
```

```java
// File: com/myapp/model/Student.java
package com.myapp.model;

public class Student {
    private String name;
    private int age;

    public Student(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() { return name; }
    public int getAge() { return age; }

    @Override
    public String toString() {
        return name + " (" + age + ")";
    }
}
```

```java
// File: com/myapp/service/StudentService.java
package com.myapp.service;

import com.myapp.model.Student;  // import from another package

public class StudentService {
    public void displayStudent(Student s) {
        System.out.println("Student: " + s.getName() + ", Age: " + s.getAge());
    }
}
```

## Access Modifiers (Detailed)

```
┌────────────┬────────────┬────────────┬────────────┬────────────┐
│  Modifier  │ Same Class │ Same Pkg   │ Subclass   │ Other Pkg  │
│            │            │            │ (diff pkg) │            │
├────────────┼────────────┼────────────┼────────────┼────────────┤
│  private   │     ✅     │     ❌     │     ❌     │     ❌     │
├────────────┼────────────┼────────────┼────────────┼────────────┤
│  default   │     ✅     │     ✅     │     ❌     │     ❌     │
│ (no mod)   │            │            │            │            │
├────────────┼────────────┼────────────┼────────────┼────────────┤
│ protected  │     ✅     │     ✅     │     ✅     │     ❌     │
├────────────┼────────────┼────────────┼────────────┼────────────┤
│  public    │     ✅     │     ✅     │     ✅     │     ✅     │
└────────────┴────────────┴────────────┴────────────┴────────────┘
```

```java
package com.demo;

public class AccessDemo {
    private int a = 1;       // only this class
    int b = 2;               // same package (default)
    protected int c = 3;     // same package + subclass
    public int d = 4;        // everywhere

    private void secretMethod() {
        System.out.println("Secret!");
    }

    public void publicMethod() {
        secretMethod();  // Can access private within same class
    }
}
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| `package` not on first line | Must be the very first statement |
| Importing `java.lang.*` explicitly | Auto-imported, not needed |
| Confusing default with public | Default = package-private (no keyword) |
| `import com.myapp.*` imports sub-packages? | No! Only imports classes in that exact package |

## Interview Tips

- `java.lang` is automatically imported
- `import com.pkg.*` does NOT import sub-package classes
- Compile with packages: `javac -d . MyClass.java`
- Run with packages: `java com.myapp.MyClass`
- `protected` allows subclass access even from different packages
- Top-level class can only be `public` or `default` (not `private` or `protected`)

## Quick Revision

> - Package = namespace for organizing classes
> - `package` → first statement, `import` → after package
> - 4 access modifiers: private → default → protected → public
> - `java.lang` auto-imported
> - `import pkg.*` doesn't include sub-packages
> - Top-level class: only `public` or default

---

## 📝 Practice – Packages & Access Modifiers

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What is a package? | Namespace for organizing classes |
| 2 | Which package is auto-imported? | `java.lang` |
| 3 | What is the default access modifier? | Package-private (no keyword) |
| 4 | What keyword imports a class? | `import` |
| 5 | Can `package` come after `import`? | No, package must be first |
| 6 | Is `private` visible in subclass? | No |
| 7 | Is `protected` visible in different package subclass? | Yes |
| 8 | Can a top-level class be `private`? | No |
| 9 | What does `static import` do? | Imports static members directly |
| 10 | What is `import java.util.*;`? | Wildcard import (all classes in java.util) |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Most restrictive modifier? | A) public B) protected C) default D) private | **D) private** |
| 2 | Least restrictive? | A) private B) default C) protected D) public | **D) public** |
| 3 | `protected` vs `default`? | A) Same B) protected includes subclass C) default includes subclass D) Error | **B) protected = default + subclass (diff pkg)** |
| 4 | `import java.util.*` imports? | A) All sub-packages B) All classes in util C) Everything D) Nothing | **B) All classes in java.util only** |
| 5 | Two `public` classes in one file? | A) Valid B) Error C) Warning D) Depends | **B) Compile Error** |
| 6 | File name must match? | A) Any class B) public class C) First class D) Main class | **B) public class name** |
| 7 | `static import` example? | A) import Math B) import static Math.PI C) static import Math D) Error | **B) `import static java.lang.Math.PI;`** |
| 8 | Innerclass can be `private`? | A) Yes B) No C) Only static D) Error | **A) Yes** |
| 9 | `protected` in same package non-subclass? | A) No B) Yes C) Error D) Depends | **B) Yes** (protected includes same package) |
| 10 | Default package is? | A) java.lang B) No package C) java.util D) Error | **B) No package** (unnamed package) |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `protected` member in different package non-subclass? | A) Accessible B) Not accessible C) Error D) Depends | **B) Not accessible** |
| 2 | Can `protected` constructor be called from different package subclass? | A) Yes B) No C) Only with super() D) Error | **C) Only with super()** |
| 3 | `import java.util.ArrayList; import java.util.*;` — redundant? | A) Yes B) No C) Error D) Warning | **A) First import is redundant** (wildcard covers it) |
| 4 | Two classes with same name from different packages? | A) Use full qualified name B) Error C) Import both D) Impossible | **A) Use `java.util.Date` and `java.sql.Date`** |
| 5 | `package` statement missing? | A) Error B) Default package C) java.lang D) Warning | **B) Goes to default (unnamed) package** |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | `import java.util.*` imports sub-packages | **False** |
| 2 | `java.lang.String` needs explicit import | **False** |
| 3 | A class can belong to multiple packages | **False** |
| 4 | `private` class members are inherited | **True** (but not accessible) |
| 5 | `protected` is more accessible than `default` | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Create two classes in different packages where one class accesses the other's `protected` method through inheritance.

<details>
<summary>Solution</summary>

```java
// File: com/base/Animal.java
package com.base;
public class Animal {
    protected void speak() {
        System.out.println("Animal speaks");
    }
}

// File: com/derived/Dog.java
package com.derived;
import com.base.Animal;

public class Dog extends Animal {
    public void bark() {
        speak();  // Can access protected method through inheritance
        System.out.println("Dog barks");
    }

    public static void main(String[] args) {
        Dog d = new Dog();
        d.bark();
    }
}
```

</details>

---

### 🔥 20 Tricky Interview MCQs – Packages & Access Modifiers

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | Can `public` class have `private` constructor? | A) No B) Yes C) Error D) Warning | **B) Yes** | Singleton pattern uses this |
| 2 | `import static java.lang.System.out;` then `out.println("Hi");`? | A) Error B) Valid C) Warning D) Depends | **B) Valid** | Static import of out field |
| 3 | Class without any modifier is? | A) public B) private C) default D) protected | **C) default** (package-private) |
| 4 | Can enum be `private`? | A) No B) Yes (inner) C) Always public D) Error | **B) Yes** (as inner enum) |
| 5 | Interface methods default access? | A) private B) default C) protected D) public | **D) public** |
| 6 | Can two files in same package have classes with same name? | A) Yes B) No C) Warning D) Depends | **B) No** — naming conflict |
| 7 | `private` method in interface? | A) Never B) Java 9+ C) Error D) Only abstract | **B) Java 9+** |
| 8 | `import java.lang.String;` — needed? | A) Yes B) No C) Depends D) Error | **B) No** — java.lang is auto-imported |
| 9 | Can we use class from default package in named package? | A) Yes B) No C) With import D) Error | **B) No** — can't import from default package |
| 10 | `protected` vs `public` for API design? | A) Same B) Protected limits to hierarchy C) Public is restricted D) No difference | **B) Protected limits to package + subclasses** |
| 11 | Overriding with more restrictive access? | A) Valid B) Compile Error C) Runtime Error D) Warning | **B) Compile Error** |
| 12 | `final` package? | A) Valid B) Not a concept C) Error D) Sealed | **B) Not a concept** — packages can't be final |
| 13 | Nested class access enclosing class's private? | A) No B) Yes C) Only static D) Error | **B) Yes** |
| 14 | `strictfp` keyword? | A) Package B) Strict floating-point C) Error D) Deprecated | **B) Strict floating-point** (consistent across platforms) |
| 15 | Can `abstract` class be in a package? | A) No B) Yes C) Error D) Only default | **B) Yes** |
| 16 | `javac -d . MyClass.java` does? | A) Compiles B) Creates package directory C) Both D) Error | **C) Both** — compiles and creates directory structure |
| 17 | Can interface be default (package-private)? | A) No B) Yes C) Error D) Only public | **B) Yes** |
| 18 | `import com.a.MyClass; import com.b.MyClass;` — result? | A) Error B) Valid C) Last wins D) Warning | **A) Compile Error** — ambiguous import |
| 19 | `protected` field in final class? | A) Error B) Valid but useless C) Warning D) Depends | **B) Valid** but no subclass can access from different package (final class can't be extended) |
| 20 | Can a `.java` file have no public class? | A) No B) Yes C) Error D) Warning | **B) Yes** — file name can be any class name in the file |

---

# 3. File Handling

## Concept Explanation

Java provides classes in `java.io` and `java.nio` packages for reading from and writing to files.

```
┌─────────────────────────────────────────────────────────┐
│                 File Handling Classes                     │
│                                                          │
│  ┌──────────┐   ┌────────────┐   ┌──────────────────┐   │
│  │  File     │   │ FileReader  │   │ BufferedReader    │   │
│  │ (metadata)│   │ (char read) │   │ (efficient read)  │   │
│  └──────────┘   └────────────┘   └──────────────────┘   │
│                                                          │
│  ┌──────────┐   ┌────────────┐   ┌──────────────────┐   │
│  │           │   │ FileWriter  │   │ BufferedWriter    │   │
│  │           │   │ (char write)│   │ (efficient write) │   │
│  └──────────┘   └────────────┘   └──────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

## File Class

```java
import java.io.File;

public class FileDemo {
    public static void main(String[] args) {
        File file = new File("test.txt");

        // File information
        System.out.println("Exists: " + file.exists());
        System.out.println("Name: " + file.getName());
        System.out.println("Path: " + file.getAbsolutePath());
        System.out.println("Is File: " + file.isFile());
        System.out.println("Is Directory: " + file.isDirectory());
        System.out.println("Size: " + file.length() + " bytes");
        System.out.println("Readable: " + file.canRead());
        System.out.println("Writable: " + file.canWrite());

        // Create new file
        try {
            if (file.createNewFile()) {
                System.out.println("File created!");
            } else {
                System.out.println("File already exists.");
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }

        // List files in directory
        File dir = new File(".");
        String[] files = dir.list();
        for (String f : files) {
            System.out.println(f);
        }

        // Delete file
        // file.delete();
    }
}
```

### File Class Methods

| Method | Description |
|--------|-------------|
| `exists()` | Check if file exists |
| `getName()` | Get file name |
| `getAbsolutePath()` | Get full path |
| `isFile()` | Check if it's a file |
| `isDirectory()` | Check if it's a directory |
| `length()` | File size in bytes |
| `createNewFile()` | Create a new file |
| `mkdir()` | Create a directory |
| `delete()` | Delete file/directory |
| `list()` | List directory contents |
| `canRead()` / `canWrite()` | Check permissions |

## FileWriter & FileReader

```java
import java.io.*;

public class FileReadWriteDemo {
    public static void main(String[] args) {
        String fileName = "output.txt";

        // Writing to file
        try (FileWriter fw = new FileWriter(fileName)) {
            fw.write("Hello, Java File Handling!\n");
            fw.write("Line 2: Learning is fun.\n");
            fw.write("Line 3: Practice daily.\n");
            System.out.println("Written to file successfully!");
        } catch (IOException e) {
            System.out.println("Write error: " + e.getMessage());
        }

        // Appending to file (true = append mode)
        try (FileWriter fw = new FileWriter(fileName, true)) {
            fw.write("Line 4: Appended text.\n");
            System.out.println("Appended successfully!");
        } catch (IOException e) {
            System.out.println("Append error: " + e.getMessage());
        }

        // Reading from file
        try (FileReader fr = new FileReader(fileName)) {
            int ch;
            System.out.println("\nFile contents:");
            while ((ch = fr.read()) != -1) {
                System.out.print((char) ch);
            }
        } catch (IOException e) {
            System.out.println("Read error: " + e.getMessage());
        }
    }
}
```

## BufferedReader & BufferedWriter

```java
import java.io.*;

public class BufferedDemo {
    public static void main(String[] args) {
        String fileName = "buffered_output.txt";

        // Writing with BufferedWriter (more efficient)
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(fileName))) {
            bw.write("Line 1: Buffered writing is faster");
            bw.newLine();  // platform-independent newline
            bw.write("Line 2: Uses internal buffer");
            bw.newLine();
            bw.write("Line 3: Reduces disk I/O");
            System.out.println("Buffered write complete!");
        } catch (IOException e) {
            System.out.println("Error: " + e.getMessage());
        }

        // Reading with BufferedReader (more efficient)
        try (BufferedReader br = new BufferedReader(new FileReader(fileName))) {
            String line;
            System.out.println("\nReading with BufferedReader:");
            int lineNum = 1;
            while ((line = br.readLine()) != null) {
                System.out.println(lineNum++ + ": " + line);
            }
        } catch (IOException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

## Visual Explanation – Buffered vs Unbuffered

```
Unbuffered (FileReader/FileWriter):
  Program → Disk → Program → Disk → Program → Disk
  (Every read/write = disk access = SLOW)

Buffered (BufferedReader/BufferedWriter):
  Program → [Buffer] → Disk
  (Reads/writes large chunks at once = FAST)

  ┌──────────┐      ┌──────────┐      ┌──────┐
  │ Program   │ ──→ │  Buffer   │ ──→ │ Disk  │
  │ (many     │     │ (8KB      │     │(1 big │
  │  small    │     │  default) │     │ write)│
  │  writes)  │     │           │     │       │
  └──────────┘      └──────────┘      └──────┘
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Not closing file streams | Use try-with-resources |
| Not handling IOException | It's checked — must handle |
| Overwriting instead of appending | Use `FileWriter(file, true)` for append |
| Using FileReader for large files | Use BufferedReader for performance |
| Forgetting `flush()` | BufferedWriter auto-flushes on close |

## Interview Tips

- Always use **try-with-resources** for file handling
- `BufferedReader.readLine()` is more efficient than `FileReader.read()`
- `FileWriter(file, true)` → append mode
- `BufferedWriter.newLine()` → platform-independent line separator
- Default buffer size for BufferedReader/Writer is **8KB**
- `java.nio.file.Files` (Java 7+) provides modern alternatives
- `Files.readAllLines(Path)` reads entire file into `List<String>`

## Quick Revision

> - `File` → metadata (exists, name, size, delete)
> - `FileReader/FileWriter` → character-based read/write
> - `BufferedReader/BufferedWriter` → efficient (buffered) read/write
> - Always use try-with-resources
> - `FileWriter(file, true)` for append
> - `BufferedReader.readLine()` for line-by-line reading

---

## 📝 Practice – File Handling

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | Which class represents a file path? | `File` |
| 2 | Which class reads characters from a file? | `FileReader` |
| 3 | Which class writes characters to a file? | `FileWriter` |
| 4 | What makes reading faster? | `BufferedReader` |
| 5 | How to append to a file? | `new FileWriter(file, true)` |
| 6 | What exception do file operations throw? | `IOException` |
| 7 | What does `readLine()` return at end of file? | `null` |
| 8 | What is try-with-resources? | Auto-closes resources after try block |
| 9 | Method to add newline in BufferedWriter? | `newLine()` |
| 10 | What does `file.exists()` return? | `boolean` — true if file exists |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `FileReader` reads? | A) Bytes B) Characters C) Lines D) Objects | **B) Characters** |
| 2 | Default buffer size? | A) 1KB B) 4KB C) 8KB D) 16KB | **C) 8KB** |
| 3 | `File.delete()` returns? | A) void B) boolean C) int D) File | **B) boolean** |
| 4 | `IOException` is? | A) Unchecked B) Checked C) Error D) Runtime | **B) Checked** |
| 5 | Which is more efficient? | A) FileReader B) BufferedReader C) Same D) Scanner | **B) BufferedReader** |
| 6 | `file.mkdir()` creates? | A) File B) Directory C) Both D) Error | **B) Directory** |
| 7 | `flush()` does? | A) Clears buffer to target B) Closes file C) Deletes D) Reads | **A) Writes buffer contents to target** |
| 8 | `FileWriter` overwrites by default? | A) Yes B) No C) Asks D) Error | **A) Yes** (pass `true` for append) |
| 9 | `File.length()` returns? | A) int B) long C) double D) String | **B) long** (size in bytes) |
| 10 | Best for reading console input? | A) FileReader B) BufferedReader with InputStreamReader C) FileWriter D) Scanner | **B) or D)** Both work |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Can `File` class read file content? | A) Yes B) No C) Only text D) Depends | **B) No** — File only handles metadata |
| 2 | `new File("test.txt")` creates the file? | A) Yes B) No C) Only if exists D) Error | **B) No** — just creates File object (use createNewFile()) |
| 3 | `BufferedReader` wraps? | A) File B) FileReader C) FileWriter D) String | **B) FileReader** (decorator pattern) |
| 4 | What if BufferedWriter is not closed? | A) Nothing B) Data may be lost (buffer not flushed) C) Error D) Auto-closes | **B) Data may be lost** |
| 5 | `Files.readAllLines()` returns? | A) String B) List&lt;String&gt; C) String[] D) void | **B) List&lt;String&gt;** |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | `FileReader` can write to files | **False** |
| 2 | `BufferedWriter` needs `FileWriter` underneath | **True** |
| 3 | `readLine()` includes the newline character | **False** |
| 4 | `File.delete()` works on non-empty directories | **False** |
| 5 | try-with-resources calls `close()` automatically | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Write a program that counts the number of lines, words, and characters in a file.

<details>
<summary>Solution</summary>

```java
import java.io.*;

public class FileCounter {
    public static void main(String[] args) {
        int lines = 0, words = 0, chars = 0;

        try (BufferedReader br = new BufferedReader(new FileReader("input.txt"))) {
            String line;
            while ((line = br.readLine()) != null) {
                lines++;
                chars += line.length();
                String[] wordArr = line.trim().split("\\s+");
                if (!line.trim().isEmpty()) {
                    words += wordArr.length;
                }
            }
        } catch (IOException e) {
            System.out.println("Error: " + e.getMessage());
        }

        System.out.println("Lines: " + lines);
        System.out.println("Words: " + words);
        System.out.println("Characters: " + chars);
    }
}
```

</details>

---

# 4. Multithreading

## Concept Explanation

**Multithreading** allows concurrent execution of two or more threads. A **thread** is the smallest unit of execution within a process.

```
┌──────────────────────────────────────────────────────┐
│              Process vs Thread                        │
│                                                       │
│  Process:                Thread:                      │
│  - Independent program   - Lightweight sub-process    │
│  - Own memory space      - Shares process memory      │
│  - Heavyweight           - Lightweight                │
│  - Separate address      - Shared address space       │
│    space                                              │
│                                                       │
│     Process                                           │
│  ┌──────────────────────────────────────┐            │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐│            │
│  │  │Thread 1 │ │Thread 2 │ │Thread 3 ││            │
│  │  │         │ │         │ │         ││            │
│  │  └─────────┘ └─────────┘ └─────────┘│            │
│  │       Shared Memory (Heap)           │            │
│  └──────────────────────────────────────┘            │
└──────────────────────────────────────────────────────┘
```

### Thread Lifecycle

```
┌───────┐    start()   ┌──────────┐    run()    ┌─────────┐
│  NEW  │ ──────────→  │ RUNNABLE │ ─────────→  │ RUNNING │
└───────┘              └──────────┘              └────┬────┘
                            ↑                         │
                            │                    ┌────┴─────┐
                            │              ┌─────┤          ├─────┐
                            │              │     │          │     │
                            │              │sleep/wait     yield │
                            │              │     │          │     │
                            │         ┌────▼──┐  │    ┌─────▼──┐  │
                            │         │TIMED  │  │    │WAITING │  │
                            │         │WAITING│  │    │        │  │
                            │         └───┬───┘  │    └───┬────┘  │
                            │             │      │        │       │
                            └─────────────┘      │  notify/notifyAll
                                                 │        │
                                                 │   ┌────▼────┐
                                                 │   │RUNNABLE │
                                                 │   └─────────┘
                                                 │
                                            ┌────▼──────┐
                                            │TERMINATED │
                                            │ (Dead)    │
                                            └───────────┘
```

## Thread Creation – Two Ways

### Way 1: Extending Thread class

```java
class MyThread extends Thread {
    private String threadName;

    MyThread(String name) {
        this.threadName = name;
    }

    @Override
    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println(threadName + ": Count " + i);
            try {
                Thread.sleep(500);  // pause 500ms
            } catch (InterruptedException e) {
                System.out.println(threadName + " interrupted!");
            }
        }
        System.out.println(threadName + " finished!");
    }
}

public class ThreadDemo1 {
    public static void main(String[] args) {
        MyThread t1 = new MyThread("Thread-A");
        MyThread t2 = new MyThread("Thread-B");

        t1.start();  // starts thread (calls run() internally)
        t2.start();  // both run concurrently

        // t1.run();  // DON'T DO THIS! Runs in main thread, not new thread
    }
}
```

### Way 2: Implementing Runnable interface (Preferred)

```java
class MyRunnable implements Runnable {
    private String name;

    MyRunnable(String name) {
        this.name = name;
    }

    @Override
    public void run() {
        for (int i = 1; i <= 5; i++) {
            System.out.println(name + ": " + i);
            try {
                Thread.sleep(300);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

public class ThreadDemo2 {
    public static void main(String[] args) {
        Thread t1 = new Thread(new MyRunnable("Runnable-A"));
        Thread t2 = new Thread(new MyRunnable("Runnable-B"));

        t1.start();
        t2.start();

        // Using lambda (Java 8+)
        Thread t3 = new Thread(() -> {
            for (int i = 1; i <= 3; i++) {
                System.out.println("Lambda thread: " + i);
            }
        });
        t3.start();
    }
}
```

### Thread vs Runnable

| Feature | Extending Thread | Implementing Runnable |
|---------|-----------------|----------------------|
| Inheritance | Extends Thread (can't extend another class) | Implements Runnable (can extend another class) |
| Reusability | Less reusable | More reusable |
| Flexibility | Less flexible | More flexible |
| Preferred | No | **Yes** |

## Important Thread Methods

| Method | Description |
|--------|-------------|
| `start()` | Starts the thread (calls `run()` in new thread) |
| `run()` | Contains the thread's task |
| `sleep(ms)` | Pauses thread for milliseconds (static) |
| `join()` | Waits for thread to complete |
| `yield()` | Suggests scheduler give turn to other threads |
| `isAlive()` | Checks if thread is still running |
| `getName()` / `setName()` | Get/set thread name |
| `getPriority()` / `setPriority()` | Get/set priority (1-10) |
| `interrupt()` | Interrupts a sleeping/waiting thread |
| `currentThread()` | Returns reference to current thread (static) |

## Thread join() Example

```java
public class JoinDemo {
    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread(() -> {
            for (int i = 1; i <= 3; i++) {
                System.out.println("Thread 1: " + i);
                try { Thread.sleep(500); } catch (InterruptedException e) {}
            }
        });

        Thread t2 = new Thread(() -> {
            for (int i = 1; i <= 3; i++) {
                System.out.println("Thread 2: " + i);
                try { Thread.sleep(500); } catch (InterruptedException e) {}
            }
        });

        t1.start();
        t1.join();  // Main thread WAITS for t1 to finish

        t2.start();
        t2.join();  // Main thread WAITS for t2 to finish

        System.out.println("Both threads completed!");
    }
}
```

## Synchronization

When multiple threads access shared resources, **race conditions** can occur. `synchronized` ensures only one thread accesses the resource at a time.

```java
class Counter {
    private int count = 0;

    // Synchronized method - only one thread at a time
    public synchronized void increment() {
        count++;
    }

    public int getCount() {
        return count;
    }
}

public class SyncDemo {
    public static void main(String[] args) throws InterruptedException {
        Counter counter = new Counter();

        // Create 1000 threads, each incrementing counter
        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 10000; i++) counter.increment();
        });
        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 10000; i++) counter.increment();
        });

        t1.start();
        t2.start();
        t1.join();
        t2.join();

        System.out.println("Count: " + counter.getCount());
        // Without synchronized: may be < 20000 (race condition!)
        // With synchronized: always 20000
    }
}
```

### Synchronized Block

```java
class SharedResource {
    private int data = 0;
    private final Object lock = new Object();

    public void update() {
        // Only this critical section is synchronized
        synchronized (lock) {
            data++;
            System.out.println(Thread.currentThread().getName() + ": " + data);
        }
        // Other non-critical code runs without lock
    }
}
```

## Visual Explanation – Synchronization

```
Without synchronized:              With synchronized:
Thread 1: read count=5             Thread 1: LOCK → read=5 → write 6 → UNLOCK
Thread 2: read count=5             Thread 2: WAIT...
Thread 1: write count=6            Thread 2: LOCK → read=6 → write 7 → UNLOCK
Thread 2: write count=6  ← BUG!
Expected 7, got 6 (lost update)    Both updates preserved! ✅
```

## Thread Priority

```java
Thread t1 = new Thread(() -> { /* task */ });
t1.setPriority(Thread.MIN_PRIORITY);  // 1
t1.setPriority(Thread.NORM_PRIORITY); // 5 (default)
t1.setPriority(Thread.MAX_PRIORITY);  // 10
```

> **Note:** Priority is a **suggestion** to the scheduler, not a guarantee.

## Deadlock

```java
// Deadlock example - DO NOT DO THIS!
class DeadlockDemo {
    static Object lock1 = new Object();
    static Object lock2 = new Object();

    public static void main(String[] args) {
        Thread t1 = new Thread(() -> {
            synchronized (lock1) {
                System.out.println("T1: Holding lock1...");
                try { Thread.sleep(100); } catch (Exception e) {}
                synchronized (lock2) { // Waiting for lock2 (held by T2)
                    System.out.println("T1: Holding lock1 & lock2");
                }
            }
        });

        Thread t2 = new Thread(() -> {
            synchronized (lock2) {
                System.out.println("T2: Holding lock2...");
                try { Thread.sleep(100); } catch (Exception e) {}
                synchronized (lock1) { // Waiting for lock1 (held by T1)
                    System.out.println("T2: Holding lock2 & lock1");
                }
            }
        });

        t1.start();
        t2.start();
        // Both threads wait forever → DEADLOCK!
    }
}
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Calling `run()` instead of `start()` | `run()` runs in current thread; `start()` creates new thread |
| Not handling `InterruptedException` | `sleep()` and `join()` require try-catch |
| Over-synchronizing | Synchronize only critical sections |
| Not using `join()` when needed | Use `join()` to wait for thread completion |
| Thinking `sleep()` releases lock | `sleep()` does NOT release the lock |

## Interview Tips

- `start()` ≠ `run()` — start() creates new thread, run() runs in current
- `Runnable` is preferred over extending `Thread` (better flexibility)
- `synchronized` keyword ensures mutual exclusion
- **Deadlock** = two threads waiting for each other's locks
- `wait()` / `notify()` / `notifyAll()` are for inter-thread communication
- `volatile` keyword = variable visible to all threads immediately
- `sleep()` does NOT release locks; `wait()` DOES release locks
- Thread scheduler is OS-dependent; order isn't guaranteed
- Java provides `ExecutorService` for modern thread management
- A **daemon thread** runs in background (e.g., GC); program exits when only daemon threads remain

## Quick Revision

> - Thread = lightweight unit of execution
> - Create: extend `Thread` or implement `Runnable` (preferred)
> - `start()` creates new thread; `run()` runs in current thread
> - Lifecycle: NEW → RUNNABLE → RUNNING → TERMINATED
> - `synchronized` → prevent race conditions
> - `join()` → wait for thread to finish
> - `sleep()` → pause thread (doesn't release lock)
> - Deadlock = circular lock dependency

---

## 📝 Practice – Multithreading

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What is a thread? | Smallest unit of execution |
| 2 | How to create a thread? | Extend Thread or implement Runnable |
| 3 | What does `start()` do? | Creates a new thread and calls `run()` |
| 4 | What does `run()` contain? | The task to execute |
| 5 | What is synchronization? | Controlling access to shared resources |
| 6 | What is a deadlock? | Two threads waiting for each other's locks |
| 7 | What does `sleep()` do? | Pauses the thread for specified time |
| 8 | What does `join()` do? | Waits for a thread to complete |
| 9 | What is thread priority range? | 1 (MIN) to 10 (MAX), default 5 |
| 10 | What is the main thread? | The thread that runs `main()` |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `t.run()` vs `t.start()`? | A) Same B) run = current thread, start = new C) Start = current D) Error | **B) run() in current thread, start() in new thread** |
| 2 | Runnable has how many methods? | A) 0 B) 1 C) 2 D) Many | **B) 1** (`run()`) |
| 3 | `synchronized` prevents? | A) Deadlock B) Race condition C) Both D) Neither | **B) Race condition** |
| 4 | Can a thread call `start()` twice? | A) Yes B) No C) Depends D) Restarts | **B) No** — `IllegalThreadStateException` |
| 5 | Thread default priority? | A) 1 B) 5 C) 10 D) 0 | **B) 5** (NORM_PRIORITY) |
| 6 | `sleep()` is? | A) Instance method B) Static method C) Both D) Neither | **B) Static method** |
| 7 | `yield()` does? | A) Stops thread B) Suggests giving CPU to others C) Kills thread D) Error | **B) Suggests giving turn** |
| 8 | Which interface for thread task? | A) Callable B) Runnable C) Thread D) All | **B) Runnable** (Callable returns value) |
| 9 | Can main thread die before child threads? | A) No B) Yes C) Error D) Always | **B) Yes** (child threads continue) |
| 10 | `isAlive()` returns? | A) int B) String C) boolean D) void | **C) boolean** |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `sleep()` releases lock? | A) Yes B) No C) Depends D) Sometimes | **B) No** — `wait()` releases lock, `sleep()` doesn't |
| 2 | `wait()` must be called inside? | A) Any method B) synchronized block C) main D) Thread | **B) synchronized block** |
| 3 | Can a `synchronized` method be inherited? | A) No B) Yes C) Error D) Depends | **B) Yes** (but subclass method isn't synchronized by default) |
| 4 | Daemon thread example? | A) main B) Garbage Collector C) User thread D) None | **B) Garbage Collector** |
| 5 | `volatile` ensures? | A) Synchronization B) Visibility C) Atomicity D) Thread safety | **B) Visibility** (not atomicity) |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | `start()` can be called multiple times on same thread | **False** |
| 2 | `sleep()` throws checked `InterruptedException` | **True** |
| 3 | `Runnable` is preferred over `Thread` | **True** |
| 4 | Thread output order is deterministic | **False** |
| 5 | `synchronized` method locks the entire object | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Create two threads — one prints even numbers 2-10, other prints odd numbers 1-9.

<details>
<summary>Solution</summary>

```java
public class EvenOddThreads {
    public static void main(String[] args) {
        Thread evenThread = new Thread(() -> {
            for (int i = 2; i <= 10; i += 2) {
                System.out.println("Even: " + i);
                try { Thread.sleep(200); } catch (InterruptedException e) {}
            }
        });

        Thread oddThread = new Thread(() -> {
            for (int i = 1; i <= 9; i += 2) {
                System.out.println("Odd: " + i);
                try { Thread.sleep(200); } catch (InterruptedException e) {}
            }
        });

        evenThread.start();
        oddThread.start();
    }
}
```

</details>

**Exercise 2:** Create a synchronized counter that is incremented by 3 threads.

<details>
<summary>Solution</summary>

```java
class SafeCounter {
    private int count = 0;
    public synchronized void increment() { count++; }
    public int getCount() { return count; }
}

public class SyncCounterDemo {
    public static void main(String[] args) throws InterruptedException {
        SafeCounter counter = new SafeCounter();
        Runnable task = () -> {
            for (int i = 0; i < 1000; i++) counter.increment();
        };

        Thread t1 = new Thread(task);
        Thread t2 = new Thread(task);
        Thread t3 = new Thread(task);

        t1.start(); t2.start(); t3.start();
        t1.join(); t2.join(); t3.join();

        System.out.println("Final count: " + counter.getCount()); // Always 3000
    }
}
```

</details>

---

### 🔥 20 Tricky Interview MCQs – Multithreading

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | `new Thread().start(); new Thread().start();` — order guaranteed? | A) Yes B) No C) First always first D) Depends | **B) No** | Thread scheduling is OS-dependent |
| 2 | `synchronized(this)` locks? | A) Method B) Class C) Current object D) All objects | **C) Current object** |
| 3 | `synchronized static method` locks? | A) Object B) Class C) Method D) Nothing | **B) Class** (class-level lock) |
| 4 | Can `wait()` be called outside synchronized? | A) Yes B) No C) Depends D) Warning | **B) No** — throws `IllegalMonitorStateException` |
| 5 | `notify()` vs `notifyAll()`? | A) Same B) notify=one, notifyAll=all C) notify=all D) Error | **B)** notify wakes one, notifyAll wakes all waiting threads |
| 6 | `Thread.sleep(0)` — valid? | A) Error B) Valid C) No effect D) Depends | **B) Valid** — gives other threads a chance to run |
| 7 | Can thread priority guarantee execution order? | A) Yes B) No C) Sometimes D) Always | **B) No** — just a hint to scheduler |
| 8 | `t.start()` called twice? | A) Restarts B) IllegalThreadStateException C) Nothing D) New thread | **B) IllegalThreadStateException** |
| 9 | Daemon thread + main exits? | A) Daemon continues B) Daemon stops C) Error D) Depends | **B) Daemon stops** — JVM doesn't wait for daemon threads |
| 10 | `Callable` vs `Runnable`? | A) Same B) Callable returns value C) Runnable returns D) Both return | **B) Callable returns value and throws exception** |
| 11 | `volatile` replaces `synchronized`? | A) Yes B) No C) Sometimes D) Same | **B) No** — volatile only ensures visibility, not atomicity |
| 12 | `Thread.currentThread().getName()` returns? | A) Class name B) Thread name C) ID D) Priority | **B) Thread name** |
| 13 | Can `static` method be `synchronized`? | A) No B) Yes C) Error D) Depends | **B) Yes** — locks on class object |
| 14 | `InterruptedException` is? | A) Unchecked B) Checked C) Error D) Runtime | **B) Checked** |
| 15 | How to stop a thread safely? | A) stop() B) destroy() C) Use a boolean flag D) kill() | **C) Use a volatile boolean flag** (stop/destroy are deprecated) |
| 16 | `join(1000)` means? | A) Wait forever B) Wait max 1 second C) Wait min 1 second D) Error | **B) Wait at most 1000ms** |
| 17 | Thread pool advantages? | A) Reuse threads B) Limits resources C) Better performance D) All | **D) All of the above** |
| 18 | Can we synchronize a constructor? | A) Yes B) No C) Error D) Only static | **B) No** — constructors can't be synchronized (but can have synchronized blocks) |
| 19 | `ReentrantLock` vs `synchronized`? | A) Same B) ReentrantLock more flexible C) Synchronized better D) Error | **B) ReentrantLock is more flexible** (tryLock, fairness, etc.) |
| 20 | `ThreadLocal` provides? | A) Shared variable B) Thread-specific variable C) Global D) Static | **B) Thread-specific variable** |

---

### 🔥 20 Tricky Interview MCQs – File Handling

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | `new File("abc.txt")` creates file on disk? | A) Yes B) No C) Depends D) Only if exists | **B) No** — only creates File object in memory |
| 2 | `FileWriter` vs `PrintWriter`? | A) Same B) PrintWriter has print/println C) FileWriter has println D) Error | **B) PrintWriter has convenient print/println** |
| 3 | `BufferedReader` decorates? | A) Writer B) Reader C) Stream D) File | **B) Reader** |
| 4 | Can `File.delete()` delete non-empty directory? | A) Yes B) No C) Asks D) Error | **B) No** — must be empty |
| 5 | `FileInputStream` reads? | A) Characters B) Bytes C) Lines D) Objects | **B) Bytes** |
| 6 | `Scanner` vs `BufferedReader`? | A) Same B) Scanner parses, BR is faster C) BR parses D) Error | **B)** Scanner has parsing; BufferedReader is faster |
| 7 | `try-with-resources` requires? | A) AutoCloseable B) Serializable C) Cloneable D) Runnable | **A) AutoCloseable** |
| 8 | `Path` vs `File`? | A) Same B) Path is newer (NIO) C) File is newer D) Error | **B) Path is Java NIO (newer, preferred)** |
| 9 | `Files.write()` overwrites by default? | A) No B) Yes C) Appends D) Error | **B) Yes** — use `StandardOpenOption.APPEND` for append |
| 10 | Encoding issues caused by? | A) FileReader B) FileWriter C) Both (default encoding) D) Neither | **C) Both** — use InputStreamReader with explicit charset |
| 11 | `ObjectOutputStream` writes? | A) Text B) Binary objects C) JSON D) XML | **B) Serialized binary objects** |
| 12 | Serializable interface has? | A) 1 method B) 0 methods (marker) C) 5 methods D) 2 methods | **B) 0 methods** — marker interface |
| 13 | `transient` keyword means? | A) Error B) Not serialized C) Final D) Static | **B) Field is not serialized** |
| 14 | `System.out` is a? | A) FileWriter B) PrintStream C) BufferedWriter D) Scanner | **B) PrintStream** |
| 15 | `System.in` is a? | A) FileReader B) Scanner C) InputStream D) BufferedReader | **C) InputStream** |
| 16 | Best for reading large files? | A) FileReader B) Scanner C) BufferedReader D) readAllLines | **C) BufferedReader** (memory efficient, line by line) |
| 17 | `File.separator` gives? | A) "/" always B) "\\" always C) Platform-specific D) Error | **C) Platform-specific** — "/" on Unix, "\\" on Windows |
| 18 | `RandomAccessFile` allows? | A) Only read B) Only write C) Both read and write D) Error | **C) Both read and write** (random access) |
| 19 | NIO stands for? | A) New I/O B) Network I/O C) Non-blocking I/O D) A and C | **D) New I/O (also supports non-blocking)** |
| 20 | Can you read from a URL using Java IO? | A) No B) Yes (URL.openStream()) C) Only with sockets D) Error | **B) Yes** |

---

# 🖼️ Visual Reference Diagrams – Advanced Java

## 📌 Exception Flow in try-catch-finally

```
┌─────────────────────────────────────────────────────────────────┐
│              EXCEPTION EXECUTION FLOW                            │
│                                                                  │
│  try block starts                                                │
│       │                                                          │
│       ▼                                                          │
│  Exception thrown? ──NO──► try block completes normally         │
│       │                            │                            │
│      YES                           ▼                            │
│       │                     finally block runs                  │
│       ▼                            │                            │
│  Does matching catch exist?        ▼                            │
│    YES ──► catch block runs ──► finally block runs              │
│    NO  ──► exception propagates up call stack                   │
│             finally runs THEN propagates                        │
│                                                                  │
│  IMPORTANT RULES:                                                │
│  • finally ALWAYS runs (even if return in try/catch)            │
│  • ONLY exception: System.exit() prevents finally               │
│  • catch(Exception e) should be LAST (most general)             │
│  • Multi-catch Java 7+: catch(A | B e) {}                       │
│  • try-with-resources closes AutoCloseable automatically        │
└─────────────────────────────────────────────────────────────────┘

  Code Flow Example:

  ┌─────────────────────────────────────────────────────────────┐
  │  try {                                                       │
  │     step 1 ✓                                                │
  │     step 2 ✓                                                │
  │     int x = 10/0; ← EXCEPTION HERE                         │
  │     step 4 ✗ SKIPPED                                        │
  │  }                                                           │
  │  catch(ArithmeticException e) {                             │
  │     step 5 ✓ CAUGHT HERE                                    │
  │  }                                                           │
  │  finally {                                                   │
  │     step 6 ✓ ALWAYS RUNS                                    │
  │  }                                                           │
  └─────────────────────────────────────────────────────────────┘
```

## 📌 Java Exception Hierarchy (Comprehensive)

```
┌─────────────────────────────────────────────────────────────────┐
│                 FULL EXCEPTION HIERARCHY                         │
│                                                                  │
│                   Throwable                                      │
│                ┌─────┴─────┐                                     │
│             Error        Exception                               │
│          (Don't catch)   ┌──────┴────────────────┐              │
│                          │                        │              │
│          ┌───────────────┤                   RuntimeException    │
│          │               │               (Unchecked)             │
│       Checked            │    ┌──────────────────────────┐      │
│    (Must handle)         │    NullPointerException        │      │
│                          │    ArrayIndexOutOfBoundsException│    │
│    IOException           │    ClassCastException          │      │
│    SQLException          │    ArithmeticException         │      │
│    FileNotFoundException │    NumberFormatException       │      │
│    ClassNotFoundException│    IllegalArgumentException    │      │
│    InterruptedException  │    StackOverflowError (Error!) │      │
│                          └──────────────────────────────────┘   │
│                                                                  │
│   Error examples:                                                │
│   - OutOfMemoryError         (heap full)                        │
│   - StackOverflowError       (infinite recursion)               │
│   - VirtualMachineError      (JVM crash)                        │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Thread Lifecycle State Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                  THREAD LIFECYCLE                                │
│                                                                  │
│                   new Thread()                                   │
│                       │                                          │
│                       ▼                                          │
│                  ┌─────────┐                                     │
│                  │   NEW   │                                     │
│                  └────┬────┘                                     │
│                       │ start()                                  │
│                       ▼                                          │
│                  ┌──────────┐    CPU available                   │
│          ┌──────►│ RUNNABLE │◄─────────────────┐                │
│          │       └────┬─────┘                  │                │
│          │            │ CPU assigned           │                 │
│    notify/           ▼               sleep/wait/join            │
│   notifyAll    ┌──────────┐               │                     │
│          │     │ RUNNING  │───────────────┘                     │
│          │     └────┬─────┘                                     │
│          │          │ wait()                                     │
│    ┌─────┴────┐     │           ┌───────────────────┐           │
│    │ WAITING  │◄────┘           │  TIMED_WAITING     │          │
│    │(indefinite)                │  sleep(ms)/join(ms)│          │
│    └──────────┘                 └───────────────────┘           │
│          │                             │                         │
│          └──────────────┬──────────────┘                        │
│                         │ task complete / stop()                 │
│                         ▼                                        │
│                  ┌────────────┐                                  │
│                  │ TERMINATED │                                  │
│                  └────────────┘                                  │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Java I/O Stream Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│                  I/O STREAM HIERARCHY                            │
│                                                                  │
│   Input Streams (Reading)           Output Streams (Writing)    │
│   ──────────────────────            ───────────────────────     │
│                                                                  │
│   InputStream (abstract)            OutputStream (abstract)     │
│   ├── FileInputStream               ├── FileOutputStream        │
│   ├── BufferedInputStream           ├── BufferedOutputStream    │
│   ├── DataInputStream               ├── DataOutputStream        │
│   └── ObjectInputStream             └── ObjectOutputStream      │
│                                                                  │
│   Reader (text/char)                Writer (text/char)          │
│   ──────────────────                ───────────────────         │
│   Reader (abstract)                 Writer (abstract)           │
│   ├── FileReader                    ├── FileWriter              │
│   ├── BufferedReader ←── FAVORITE   ├── BufferedWriter ← FAV   │
│   ├── InputStreamReader             ├── OutputStreamWriter      │
│   └── StringReader                  └── PrintWriter             │
│                                                                  │
│   Key difference:                                                │
│   InputStream/OutputStream → binary (bytes, images, audio)     │
│   Reader/Writer            → text (characters, files)           │
│                                                                  │
│   Buffered classes wrap others for efficiency:                  │
│   BufferedReader br = new BufferedReader(new FileReader("f.txt"))│
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Custom Exception Design Pattern

```
┌─────────────────────────────────────────────────────────────────┐
│              CUSTOM EXCEPTION HIERARCHY PATTERN                  │
│                                                                  │
│   Exception                                                      │
│   └── AppException (your base)                                  │
│       ├── ValidationException                                   │
│       │   ├── EmptyFieldException                               │
│       │   └── InvalidFormatException                            │
│       ├── BusinessException                                      │
│       │   ├── InsufficientFundsException                        │
│       │   └── ItemNotFoundException                             │
│       └── DatabaseException                                     │
│           ├── ConnectionException                               │
│           └── QueryException                                    │
│                                                                  │
│  Best Practices:                                                 │
│  • Extend RuntimeException for unchecked (business logic flows) │
│  • Extend Exception for checked (must handle cases)             │
│  • Include helpful message + original cause in constructor      │
│  • Name ends in "Exception"                                     │
└─────────────────────────────────────────────────────────────────┘
```

---

# 📚 Extra Examples – Advanced Java

## Example: Multi-catch and Exception Chaining

```java
public class ExceptionHandlingFull {
    static void riskyMethod(int choice) throws Exception {
        switch (choice) {
            case 1 -> throw new NullPointerException("Null reference");
            case 2 -> throw new ArithmeticException("Math error");
            case 3 -> {
                // Exception chaining: wrap original cause
                try {
                    int[] arr = new int[-1];
                } catch (NegativeArraySizeException e) {
                    throw new Exception("Array creation failed", e); // chaining
                }
            }
        }
    }

    public static void main(String[] args) {
        // Multi-catch (Java 7+)
        for (int i = 1; i <= 3; i++) {
            try {
                riskyMethod(i);
            } catch (NullPointerException | ArithmeticException e) {
                System.out.println("Caught NPE or Arithmetic: " + e.getMessage());
            } catch (Exception e) {
                System.out.println("General: " + e.getMessage());
                System.out.println("Caused by: " + e.getCause());
            } finally {
                System.out.println("--- finally for i=" + i + " ---");
            }
        }
    }
}
// Output:
// Caught NPE or Arithmetic: Null reference
// --- finally for i=1 ---
// Caught NPE or Arithmetic: Math error
// --- finally for i=2 ---
// General: Array creation failed
// Caused by: java.lang.NegativeArraySizeException: -1
// --- finally for i=3 ---
```

## Example: try-with-resources (File Reading)

```java
import java.io.*;
import java.nio.file.*;

public class FileReadingDemo {
    // Method 1: try-with-resources (modern, preferred)
    static void readFileModern(String path) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            int lineNum = 1;
            while ((line = br.readLine()) != null) {
                System.out.printf("Line %d: %s%n", lineNum++, line);
            }
        } catch (FileNotFoundException e) {
            System.out.println("File not found: " + path);
        } catch (IOException e) {
            System.out.println("IO Error: " + e.getMessage());
        }
        // BufferedReader automatically closed — no finally needed!
    }

    // Method 2: Write to file
    static void writeFile(String path, String content) {
        try (PrintWriter pw = new PrintWriter(new FileWriter(path, true))) {
            pw.println(content);
            System.out.println("Written: " + content);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Method 3: NIO (Java 7+) — simplest for small files
    static void readFileNIO(String path) throws IOException {
        List<String> lines = Files.readAllLines(Path.of(path));
        lines.forEach(System.out::println);
    }

    public static void main(String[] args) throws IOException {
        writeFile("demo.txt", "First line");
        writeFile("demo.txt", "Second line");
        writeFile("demo.txt", "Third line");
        readFileModern("demo.txt");
    }
}
```

## Example: Thread — All Creation Methods

```java
public class ThreadCreationMethods {
    // Method 1: Extend Thread
    static class MyThread extends Thread {
        String name;
        MyThread(String name) { this.name = name; }
        @Override
        public void run() {
            for (int i = 1; i <= 3; i++) {
                System.out.println(name + " - " + i);
                try { Thread.sleep(100); } catch (InterruptedException e) {}
            }
        }
    }

    // Method 2: Implement Runnable
    static class MyRunnable implements Runnable {
        @Override
        public void run() {
            System.out.println("Runnable running on: " + Thread.currentThread().getName());
        }
    }

    public static void main(String[] args) throws InterruptedException {
        // Method 1: Thread subclass
        MyThread t1 = new MyThread("Thread-A");
        t1.start();  // MUST call start(), not run()!

        // Method 2: Runnable
        Thread t2 = new Thread(new MyRunnable(), "Thread-B");
        t2.start();

        // Method 3: Lambda (Java 8+) — most concise
        Thread t3 = new Thread(() -> {
            System.out.println("Lambda thread: " + Thread.currentThread().getName());
        }, "Thread-C");
        t3.start();

        // Method 4: Anonymous class
        Thread t4 = new Thread() {
            public void run() {
                System.out.println("Anonymous: " + getName());
            }
        };
        t4.setName("Thread-D");
        t4.start();

        // Wait for all
        t1.join(); t2.join(); t3.join(); t4.join();
        System.out.println("All threads done");
    }
}
```

## Example: Synchronized (Thread Safety)

```java
public class BankSynchronized {
    private int balance;

    BankSynchronized(int initial) { this.balance = initial; }

    // synchronized ensures only one thread can withdraw at a time
    synchronized void withdraw(String name, int amount) {
        if (balance >= amount) {
            System.out.println(name + " is withdrawing " + amount);
            try { Thread.sleep(100); } catch (InterruptedException e) {}
            balance -= amount;
            System.out.println(name + " done. Balance: " + balance);
        } else {
            System.out.println(name + ": Insufficient funds!");
        }
    }

    public static void main(String[] args) throws InterruptedException {
        BankSynchronized account = new BankSynchronized(1000);

        Thread t1 = new Thread(() -> account.withdraw("Alice", 700));
        Thread t2 = new Thread(() -> account.withdraw("Bob", 700));

        t1.start(); t2.start();
        t1.join();  t2.join();
        // One succeeds, one fails — not both!
    }
}
```

## Example: Custom Checked & Unchecked Exceptions

```java
// Unchecked custom exception
class AgeInvalidException extends RuntimeException {
    int age;
    AgeInvalidException(int age) {
        super("Invalid age: " + age + " (must be 0-150)");
        this.age = age;
    }
}

// Checked custom exception
class UserNotFoundException extends Exception {
    String userId;
    UserNotFoundException(String id) {
        super("User not found: " + id);
        this.userId = id;
    }
}

class UserService {
    static void validateAge(int age) {
        if (age < 0 || age > 150) throw new AgeInvalidException(age); // no throws needed
    }

    static String findUser(String id) throws UserNotFoundException { // must declare
        if (!id.startsWith("U")) throw new UserNotFoundException(id);
        return "User: " + id;
    }
}

public class CustomExceptionDemo {
    public static void main(String[] args) {
        // Unchecked — no try-catch forced
        try {
            UserService.validateAge(200);
        } catch (AgeInvalidException e) {
            System.out.println(e.getMessage()); // Invalid age: 200 (must be 0-150)
        }

        // Checked — must handle
        try {
            System.out.println(UserService.findUser("U001")); // User: U001
            System.out.println(UserService.findUser("X999")); // throws!
        } catch (UserNotFoundException e) {
            System.out.println(e.getMessage()); // User not found: X999
            System.out.println("User ID was: " + e.userId);
        }
    }
}
```

---

# 📝 Extended Question Bank – Advanced Java

## ✍️ Fill in the Blanks – Advanced Java

| # | Statement | Answer |
|---|-----------|--------|
| 1 | `_______` exceptions must be declared with `throws` or handled. | **Checked** |
| 2 | `RuntimeException` subclasses are called _______ exceptions. | **unchecked** |
| 3 | `finally` block always runs unless `_______` is called. | **System.exit()** |
| 4 | `throw` is used to _______ an exception; `throws` is a method _______ declaration. | **throw / signature** |
| 5 | `try-with-resources` requires the resource to implement _______. | **AutoCloseable** |
| 6 | Two or more exceptions in one catch block is called _______ catch. | **multi-catch** |
| 7 | `e.getMessage()` returns the _______. | **exception message string** |
| 8 | `e.getCause()` returns the _______ exception. | **original / wrapped cause** |
| 9 | Thread method `_______` must be called to start a new thread (not `run()`). | **start()** |
| 10 | Thread states: NEW, _______, BLOCKED, WAITING, TIMED_WAITING, TERMINATED. | **RUNNABLE** |
| 11 | `synchronized` keyword provides _______ exclusion. | **mutual** |
| 12 | `Thread.sleep(1000)` throws _______ exception. | **InterruptedException** |
| 13 | To make a thread wait for another to finish, use _______ method. | **join()** |
| 14 | `BufferedReader.readLine()` returns _______ when end of file is reached. | **null** |
| 15 | `FileNotFoundException` is thrown when a file _______ not exist. | **does** |

---

## 🔗 Match the Following – Exception Types

### Set A – Exception to Real-World Cause

| Exception | Cause |
|-----------|-------|
| 1. NullPointerException | A. `int x = 5/0;` |
| 2. ArithmeticException | B. `arr[10]` when arr has 5 elements |
| 3. ArrayIndexOutOfBoundsException | C. `int x = Integer.parseInt("abc")` |
| 4. NumberFormatException | D. `String s = null; s.length()` |
| 5. ClassCastException | E. `(String) new Integer(5)` |

**Answers:** 1→D, 2→A, 3→B, 4→C, 5→E

---

### Set B – Thread Terms

| Term | Meaning |
|------|---------|
| 1. start() | A. Makes current thread wait for another to die |
| 2. run() | B. JVM picks thread to execute |
| 3. join() | C. Releases lock and waits for notify |
| 4. wait() | D. Method containing thread's task |
| 5. notify() | E. Wakes one waiting thread |

**Answers:** 1→B, 2→D, 3→A, 4→C, 5→E

---

## 🐛 Error Spotting – Advanced Java

### Bug 1
```java
try {
    int result = 10 / 0;
} catch (Exception e) {
    System.out.println("General");
} catch (ArithmeticException e) {  // Bug!
    System.out.println("Arithmetic");
}
```
**Bug:** More general exception `Exception` before specific `ArithmeticException` — unreachable catch block. Specific exceptions must come FIRST.

---

### Bug 2
```java
class MyThread extends Thread {
    public void run() { System.out.println("Running"); }
}
MyThread t = new MyThread();
t.run();   // Bug: calls run() directly, not start()!
```
**Bug:** `t.run()` doesn't create a new thread — runs in current thread. Should be `t.start()`.

---

### Bug 3
```java
try {
    FileReader fr = new FileReader("file.txt");
    // use fr...
} catch (IOException e) {
    e.printStackTrace();
}
// fr not closed!
```
**Bug:** `FileReader` not closed — resource leak. Use try-with-resources: `try (FileReader fr = new FileReader("file.txt")) {...}`

---

### Bug 4
```java
void readFile() {
    BufferedReader br = new BufferedReader(new FileReader("test.txt"));
    System.out.println(br.readLine());
}
```
**Bug:** `FileReader` and `readLine()` throw `IOException` (checked) — must either `throws IOException` in method signature or wrap in try-catch.

---

### Bug 5
```java
class MyException extends Exception {
    MyException() { super(); }
}
throw MyException();  // Bug!
```
**Bug:** Missing `new`. Should be `throw new MyException();`

---

## 🖥️ Output Prediction – Advanced Java

### Q1
```java
try {
    System.out.println("try");
    if (true) throw new RuntimeException("oops");
    System.out.println("after throw");
} catch (RuntimeException e) {
    System.out.println("catch: " + e.getMessage());
} finally {
    System.out.println("finally");
}
```
**Output:**
```
try
catch: oops
finally
```

---

### Q2
```java
static String test() {
    try {
        return "try";
    } finally {
        return "finally";  // overrides try's return!
    }
}
System.out.println(test());
```
**Output:** `finally`
> `finally` return value OVERRIDES the try block's return value.

---

### Q3
```java
try {
    try {
        int[] a = new int[-1];
    } catch (NegativeArraySizeException e) {
        System.out.println("inner catch");
        throw new RuntimeException("wrapped", e);
    }
} catch (RuntimeException e) {
    System.out.println("outer catch: " + e.getMessage());
}
```
**Output:**
```
inner catch
outer catch: wrapped
```

---

### Q4 – Thread Output
```java
Thread t1 = new Thread(() -> System.out.println("T1"));
Thread t2 = new Thread(() -> System.out.println("T2"));
t1.start(); t2.start();
```
**Output:** `T1` and `T2` in any order (non-deterministic — depends on OS scheduler)

---

### Q5
```java
class A implements AutoCloseable {
    public void close() { System.out.println("A closed"); }
}
class B implements AutoCloseable {
    public void close() { System.out.println("B closed"); }
}
try (A a = new A(); B b = new B()) {
    System.out.println("In try");
}
```
**Output:**
```
In try
B closed
A closed
```
> Resources closed in REVERSE order of declaration.

---

## 🧐 Short Answer – Advanced Java

| # | Question | Answer |
|---|----------|--------|
| 1 | What is the difference between `Error` and `Exception`? | Error: JVM-level unrecoverable; Exception: program-level recoverable |
| 2 | Can `finally` block be skipped? | Only with `System.exit()` or JVM crash |
| 3 | Why is `calling run()` wrong? | It executes in the current thread — no new thread is created |
| 4 | What does `synchronized` prevent? | Race conditions; ensures only one thread executes a block at a time |
| 5 | What is deadlock? | Two threads each waiting for a lock held by the other — both stuck |
| 6 | Difference `InputStream` vs `Reader`? | InputStream reads raw bytes; Reader reads characters (handles encoding) |
| 7 | What is `transient` keyword? | Field marked transient is not included in serialization |
| 8 | Difference `FileWriter(f)` vs `FileWriter(f, true)`? | First overwrites file; second appends to existing content |
| 9 | What does `Thread.join()` do? | Calling thread waits until the specified thread finishes execution |
| 10 | What is `volatile`? | Ensures variable is read from main memory, not thread's local cache |

---

> **🎉 End of File 3 – Advanced Java Complete!**
> 
> Previous: [02_OOP_in_Java.md](02_OOP_in_Java.md)
> Next: [04_Collections_and_Interview_Programs.md](04_Collections_and_Interview_Programs.md)
