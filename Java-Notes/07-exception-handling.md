# 07. Exception Handling

## Table of Contents
- [7.1 What are Exceptions?](#71-what-are-exceptions)
- [7.2 Exception Hierarchy](#72-exception-hierarchy)
- [7.3 try-catch-finally](#73-try-catch-finally)
- [7.4 throw and throws](#74-throw-and-throws)
- [7.5 Custom Exceptions](#75-custom-exceptions)
- [7.6 Best Practices](#76-best-practices)
- [7.7 Practice & Assessment](#77-practice--assessment)

---

## 7.1 What are Exceptions?

### Definition
An **exception** is an event that disrupts the normal flow of program execution. Instead of crashing, Java provides a mechanism to handle errors gracefully.

### Without Exception Handling

```java
public class Main {
    public static void main(String[] args) {
        int a = 10, b = 0;
        int result = a / b;  // ArithmeticException → PROGRAM CRASHES
        System.out.println("This line never executes");
    }
}
// Output: Exception in thread "main" java.lang.ArithmeticException: / by zero
```

### With Exception Handling

```java
public class Main {
    public static void main(String[] args) {
        int a = 10, b = 0;
        try {
            int result = a / b;
        } catch (ArithmeticException e) {
            System.out.println("Cannot divide by zero!");
        }
        System.out.println("Program continues normally");
    }
}
// Output:
// Cannot divide by zero!
// Program continues normally
```

---

## 7.2 Exception Hierarchy

```
                    java.lang.Object
                         │
                    java.lang.Throwable
                    /                \
           Exception                Error
          /        \                  │
   Checked     Unchecked         OutOfMemoryError
   Exceptions  (RuntimeException) StackOverflowError
      │              │
 IOException    NullPointerException
 SQLException   ArrayIndexOutOfBoundsException
 FileNot...     ArithmeticException
                ClassCastException
                NumberFormatException
                IllegalArgumentException
```

### Checked vs Unchecked Exceptions

| Feature | Checked | Unchecked |
|---------|---------|-----------|
| When detected | Compile time | Runtime |
| Must handle? | Yes (try-catch or throws) | No (optional) |
| Inherits from | Exception (not Runtime) | RuntimeException |
| Examples | IOException, SQLException | NullPointerException, ArithmeticException |
| Cause | External factors (file, network) | Programming bugs |

### Common Exceptions

| Exception | When It Occurs |
|-----------|---------------|
| `ArithmeticException` | Division by zero |
| `NullPointerException` | Calling method on null reference |
| `ArrayIndexOutOfBoundsException` | Invalid array index |
| `NumberFormatException` | Invalid string to number conversion |
| `ClassCastException` | Invalid type casting |
| `FileNotFoundException` | File doesn't exist |
| `IOException` | I/O operation failure |
| `StackOverflowError` | Infinite recursion |

---

## 7.3 try-catch-finally

### Basic Syntax

```java
try {
    // Code that might throw exception
} catch (ExceptionType e) {
    // Handle the exception
} finally {
    // Always executes (cleanup code)
}
```

### Multiple catch Blocks

```java
public class Main {
    public static void main(String[] args) {
        try {
            int[] arr = {1, 2, 3};
            System.out.println(arr[5]);             // ArrayIndexOutOfBoundsException
            int result = 10 / 0;                    // ArithmeticException
            String s = null;
            s.length();                             // NullPointerException
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Invalid index: " + e.getMessage());
        } catch (ArithmeticException e) {
            System.out.println("Math error: " + e.getMessage());
        } catch (Exception e) {
            // Catch-all (must be LAST — from specific to general)
            System.out.println("Error: " + e.getMessage());
        }
    }
}
// Output: Invalid index: Index 5 out of bounds for length 3
// (Only first exception is caught — execution leaves try block immediately)
```

### Multi-catch (Java 7+)

```java
try {
    // code
} catch (ArithmeticException | NullPointerException | ArrayIndexOutOfBoundsException e) {
    System.out.println("Error: " + e.getMessage());
}
```

### finally Block

```java
public class Main {
    public static void main(String[] args) {
        try {
            System.out.println("Try block");
            int result = 10 / 0;
        } catch (ArithmeticException e) {
            System.out.println("Catch block");
        } finally {
            System.out.println("Finally block — ALWAYS executes");
        }
    }
}
// Output:
// Try block
// Catch block
// Finally block — ALWAYS executes
```

### When finally Doesn't Execute
- `System.exit(0)` is called
- JVM crashes
- Thread is killed

### try-with-resources (Java 7+)

```java
// Automatically closes resources (implements AutoCloseable)
try (FileReader fr = new FileReader("data.txt");
     BufferedReader br = new BufferedReader(fr)) {
    String line = br.readLine();
    System.out.println(line);
} catch (IOException e) {
    System.out.println("File error: " + e.getMessage());
}
// No finally needed — fr and br are auto-closed!
```

---

## 7.4 throw and throws

### throw — Manually Throw Exception

```java
public class Main {
    static void validateAge(int age) {
        if (age < 18) {
            throw new IllegalArgumentException("Age must be 18+. Got: " + age);
        }
        System.out.println("Valid age: " + age);
    }
    
    public static void main(String[] args) {
        try {
            validateAge(15);
        } catch (IllegalArgumentException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
// Output: Error: Age must be 18+. Got: 15
```

### throws — Declare Exception (Delegate to Caller)

```java
import java.io.*;

class FileHelper {
    // Method declares it MAY throw IOException
    // Caller must handle it
    static String readFile(String path) throws IOException {
        BufferedReader br = new BufferedReader(new FileReader(path));
        String content = br.readLine();
        br.close();
        return content;
    }
}

public class Main {
    public static void main(String[] args) {
        try {
            String data = FileHelper.readFile("notes.txt");
            System.out.println(data);
        } catch (IOException e) {
            System.out.println("Could not read file: " + e.getMessage());
        }
    }
}
```

### throw vs throws

| `throw` | `throws` |
|---------|----------|
| Used inside method body | Used in method signature |
| Throws one exception | Declares multiple possible exceptions |
| `throw new Exception()` | `void method() throws IOException, SQLException` |
| Followed by exception object | Followed by exception class names |

---

## 7.5 Custom Exceptions

```java
// Custom checked exception
class InsufficientFundsException extends Exception {
    private double amount;
    
    InsufficientFundsException(double amount) {
        super("Insufficient funds! Tried to withdraw: " + amount);
        this.amount = amount;
    }
    
    public double getAmount() {
        return amount;
    }
}

// Custom unchecked exception
class InvalidAccountException extends RuntimeException {
    InvalidAccountException(String message) {
        super(message);
    }
}

// Usage
class BankAccount {
    private double balance;
    
    BankAccount(double balance) {
        this.balance = balance;
    }
    
    void withdraw(double amount) throws InsufficientFundsException {
        if (amount > balance) {
            throw new InsufficientFundsException(amount);
        }
        balance -= amount;
        System.out.println("Withdrawn: " + amount + ", Remaining: " + balance);
    }
}

public class Main {
    public static void main(String[] args) {
        BankAccount acc = new BankAccount(1000);
        try {
            acc.withdraw(500);   // OK
            acc.withdraw(700);   // Exception!
        } catch (InsufficientFundsException e) {
            System.out.println(e.getMessage());
        }
    }
}
```

**Output:**
```
Withdrawn: 500.0, Remaining: 500.0
Insufficient funds! Tried to withdraw: 700.0
```

---

## 7.6 Best Practices

| Do | Don't |
|----|-------|
| Catch specific exceptions | Don't catch `Exception` generically |
| Include meaningful messages | Don't leave catch block empty |
| Use try-with-resources | Don't forget to close resources |
| Throw early, catch late | Don't use exceptions for flow control |
| Log exceptions | Don't swallow exceptions silently |
| Use custom exceptions for business logic | Don't throw generic RuntimeException |

### Anti-Pattern: Empty Catch

```java
// BAD — silently hides errors
try {
    riskyOperation();
} catch (Exception e) {
    // Empty! Bug will be invisible
}

// GOOD
try {
    riskyOperation();
} catch (SpecificException e) {
    System.err.println("Operation failed: " + e.getMessage());
    // Log, recover, or rethrow
}
```

---

## 7.7 Practice & Assessment

### MCQs

**Q1.** Which is a checked exception?
- A) NullPointerException
- B) ArithmeticException
- C) IOException
- D) ArrayIndexOutOfBoundsException

**Answer:** C — IOException must be handled at compile time.

---

**Q2.** `finally` block executes:
- A) Only when exception occurs
- B) Only when no exception occurs
- C) Always (with rare exceptions)
- D) Never

**Answer:** C

---

**Q3.** What is the output?
```java
try {
    System.out.print("A ");
    int x = 10 / 0;
    System.out.print("B ");
} catch (ArithmeticException e) {
    System.out.print("C ");
} finally {
    System.out.print("D ");
}
System.out.print("E");
```
- A) A B C D E
- B) A C D E
- C) A C E
- D) A D E

**Answer:** B — A prints, exception skips B, catch prints C, finally prints D, then E.

---

### Coding Tasks

**Task 1:** Write a method that converts String to int, handling NumberFormatException.

```java
static int safeParseInt(String s) {
    try {
        return Integer.parseInt(s);
    } catch (NumberFormatException e) {
        System.out.println("Invalid number: " + s);
        return 0;
    }
}

// Usage
safeParseInt("123");   // returns 123
safeParseInt("abc");   // prints error, returns 0
```

**Task 2:** Create a custom `InvalidGradeException` that is thrown when a grade is below 0 or above 100.

```java
class InvalidGradeException extends Exception {
    InvalidGradeException(int grade) {
        super("Invalid grade: " + grade + ". Must be 0-100.");
    }
}

class Student {
    void setGrade(int grade) throws InvalidGradeException {
        if (grade < 0 || grade > 100) {
            throw new InvalidGradeException(grade);
        }
        System.out.println("Grade set: " + grade);
    }
}
```

---

> **Next Topic:** [08 - Collections (List)](08-collections-list.md)
