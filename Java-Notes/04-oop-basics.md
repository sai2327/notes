# 04. Object-Oriented Programming — Basics

## Table of Contents
- [4.1 Class and Object](#41-class-and-object)
- [4.2 Constructors](#42-constructors)
- [4.3 `this` Keyword](#43-this-keyword)
- [4.4 Encapsulation](#44-encapsulation)
- [4.5 Static Members](#45-static-members)
- [4.6 Practice & Assessment](#46-practice--assessment)

---

## 4.1 Class and Object

### Definition
- **Class:** A blueprint/template that defines properties (fields) and behaviors (methods).
- **Object:** An instance of a class — a real entity in memory.

### Analogy
```
Class = Blueprint of a House
Object = Actual House built from the blueprint

Class "Car":
  - Properties: color, brand, speed
  - Behaviors: start(), accelerate(), brake()

Object: myCar (color="Red", brand="Toyota", speed=0)
```

### Syntax

```java
// Defining a class
class Student {
    // Fields (properties)
    String name;
    int age;
    double gpa;
    
    // Method (behavior)
    void display() {
        System.out.println("Name: " + name);
        System.out.println("Age: " + age);
        System.out.println("GPA: " + gpa);
    }
}

// Creating objects
public class Main {
    public static void main(String[] args) {
        // Create object using 'new' keyword
        Student s1 = new Student();
        s1.name = "Alice";
        s1.age = 20;
        s1.gpa = 3.8;
        s1.display();
        
        Student s2 = new Student();
        s2.name = "Bob";
        s2.age = 22;
        s2.gpa = 3.5;
        s2.display();
    }
}
```

**Output:**
```
Name: Alice
Age: 20
GPA: 3.8
Name: Bob
Age: 22
GPA: 3.5
```

### Memory Model

```
Stack                          Heap
┌─────────┐                   ┌──────────────────┐
│ s1 ──────────────────────►  │ Student Object   │
│         │                   │ name = "Alice"   │
│         │                   │ age = 20         │
│         │                   │ gpa = 3.8        │
│         │                   └──────────────────┘
│ s2 ──────────────────────►  ┌──────────────────┐
│         │                   │ Student Object   │
│         │                   │ name = "Bob"     │
└─────────┘                   │ age = 22         │
                              │ gpa = 3.5        │
                              └──────────────────┘
```

---

## 4.2 Constructors

### Definition
A **constructor** is a special method that initializes an object when it is created. It has the same name as the class and no return type.

### Types of Constructors

```java
class Student {
    String name;
    int age;
    
    // 1. Default Constructor (no parameters)
    Student() {
        name = "Unknown";
        age = 0;
        System.out.println("Default constructor called");
    }
    
    // 2. Parameterized Constructor
    Student(String name, int age) {
        this.name = name;
        this.age = age;
        System.out.println("Parameterized constructor called");
    }
    
    // 3. Copy Constructor
    Student(Student other) {
        this.name = other.name;
        this.age = other.age;
        System.out.println("Copy constructor called");
    }
    
    void display() {
        System.out.println(name + ", " + age);
    }
}

public class Main {
    public static void main(String[] args) {
        Student s1 = new Student();              // Default
        Student s2 = new Student("Alice", 20);   // Parameterized
        Student s3 = new Student(s2);            // Copy
        
        s1.display();  // Unknown, 0
        s2.display();  // Alice, 20
        s3.display();  // Alice, 20
    }
}
```

### Constructor Rules
1. Name must match class name
2. No return type (not even `void`)
3. Called automatically when `new` is used
4. If you don't write any constructor, Java provides a default one
5. If you write a parameterized constructor, default is NOT provided automatically

### Constructor Overloading

```java
class Box {
    double length, width, height;
    
    Box() {
        length = width = height = 1.0;
    }
    
    Box(double side) {
        length = width = height = side;  // Cube
    }
    
    Box(double l, double w, double h) {
        length = l; width = w; height = h;
    }
    
    double volume() {
        return length * width * height;
    }
}
```

---

## 4.3 `this` Keyword

### Purpose
`this` refers to the **current object** — used when parameter names match field names.

```java
class Person {
    String name;
    int age;
    
    // Without 'this' — WRONG
    // name = name;  ← assigns parameter to itself!
    
    // With 'this' — CORRECT
    Person(String name, int age) {
        this.name = name;    // this.name = field, name = parameter
        this.age = age;
    }
    
    // Returning current object (method chaining)
    Person setName(String name) {
        this.name = name;
        return this;
    }
    
    Person setAge(int age) {
        this.age = age;
        return this;
    }
}

// Method chaining
Person p = new Person("Alice", 20);
p.setName("Bob").setAge(25);  // Chain calls
```

### `this()` — Call Another Constructor

```java
class Student {
    String name;
    int age;
    String course;
    
    Student() {
        this("Unknown", 0, "None");  // Calls parameterized constructor
    }
    
    Student(String name, int age, String course) {
        this.name = name;
        this.age = age;
        this.course = course;
    }
}
```

> **Rule:** `this()` must be the **first statement** in the constructor.

---

## 4.4 Encapsulation

### Definition
**Encapsulation** is wrapping data (fields) and methods into a single unit (class) and restricting direct access to the data using access modifiers.

### How: Private fields + Public getters/setters

```java
class BankAccount {
    // Private fields — cannot be accessed directly from outside
    private String owner;
    private double balance;
    
    // Constructor
    public BankAccount(String owner, double balance) {
        this.owner = owner;
        setBalance(balance);  // Use setter for validation
    }
    
    // Getter
    public String getOwner() {
        return owner;
    }
    
    // Getter
    public double getBalance() {
        return balance;
    }
    
    // Setter with validation
    public void setBalance(double balance) {
        if (balance >= 0) {
            this.balance = balance;
        } else {
            System.out.println("Error: Balance cannot be negative!");
        }
    }
    
    // Business method
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposited: " + amount);
        }
    }
    
    public void withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            System.out.println("Withdrawn: " + amount);
        } else {
            System.out.println("Insufficient funds!");
        }
    }
}

public class Main {
    public static void main(String[] args) {
        BankAccount acc = new BankAccount("Alice", 1000);
        
        // acc.balance = -500;  ← ERROR: balance is private!
        
        acc.deposit(500);
        acc.withdraw(200);
        System.out.println("Balance: " + acc.getBalance());
    }
}
```

**Output:**
```
Deposited: 500
Withdrawn: 200
Balance: 1300.0
```

### Access Modifiers

| Modifier | Class | Package | Subclass | World |
|----------|:-----:|:-------:|:--------:|:-----:|
| `private` | ✅ | ❌ | ❌ | ❌ |
| (default) | ✅ | ✅ | ❌ | ❌ |
| `protected` | ✅ | ✅ | ✅ | ❌ |
| `public` | ✅ | ✅ | ✅ | ✅ |

### Benefits of Encapsulation
1. **Data hiding** — internal details hidden from outside
2. **Validation** — control what values are set
3. **Flexibility** — change internal implementation without affecting users
4. **Maintainability** — easier to debug and modify

---

## 4.5 Static Members

### Definition
`static` members belong to the **class** itself, not to any specific object. Shared among all instances.

```java
class Counter {
    static int count = 0;  // Shared by ALL objects
    String name;
    
    Counter(String name) {
        this.name = name;
        count++;  // Incremented for every new object
    }
    
    static void showCount() {
        System.out.println("Total objects: " + count);
    }
}

public class Main {
    public static void main(String[] args) {
        Counter c1 = new Counter("A");
        Counter c2 = new Counter("B");
        Counter c3 = new Counter("C");
        
        Counter.showCount();  // Total objects: 3
        // Can also call via object: c1.showCount() (not recommended)
    }
}
```

### Static vs Instance

| Feature | Static | Instance |
|---------|--------|----------|
| Belongs to | Class | Object |
| Access | `ClassName.member` | `object.member` |
| Memory | One copy for class | One per object |
| Can access | Only static members | Both static and instance |

### Common Mistake

```java
class Demo {
    int x = 10;
    
    static void show() {
        // System.out.println(x);  ← ERROR! Static cannot access instance
        // Solution: make x static, or create an object
    }
}
```

---

## 4.6 Practice & Assessment

### MCQs

**Q1.** A constructor:
- A) Has a return type
- B) Must be named differently from the class
- C) Is called when an object is created
- D) Cannot be overloaded

**Answer:** C

---

**Q2.** Encapsulation is achieved by:
- A) Making all fields public
- B) Using private fields with public getters/setters
- C) Using only static methods
- D) Inheriting from another class

**Answer:** B

---

**Q3.** `this` keyword refers to:
- A) The parent class
- B) The current method
- C) The current object
- D) A static member

**Answer:** C

---

### Output Prediction

```java
class Test {
    int x;
    Test(int x) { this.x = x; }
}
public class Main {
    public static void main(String[] args) {
        Test t1 = new Test(10);
        Test t2 = t1;
        t2.x = 20;
        System.out.println(t1.x);
    }
}
```

**Output:** `20` — `t2 = t1` copies the reference, both point to same object.

---

### Coding Task

**Task:** Create a `Student` class with:
- Private fields: name, rollNo, marks[]
- Constructor to initialize
- Methods: getAverage(), getGrade(), display()

```java
class Student {
    private String name;
    private int rollNo;
    private double[] marks;
    
    public Student(String name, int rollNo, double[] marks) {
        this.name = name;
        this.rollNo = rollNo;
        this.marks = marks;
    }
    
    public double getAverage() {
        double sum = 0;
        for (double m : marks) sum += m;
        return sum / marks.length;
    }
    
    public String getGrade() {
        double avg = getAverage();
        if (avg >= 90) return "A";
        if (avg >= 75) return "B";
        if (avg >= 60) return "C";
        return "F";
    }
    
    public void display() {
        System.out.println("Name: " + name);
        System.out.println("Roll: " + rollNo);
        System.out.println("Average: " + getAverage());
        System.out.println("Grade: " + getGrade());
    }
}
```

---

> **Next Topic:** [05 - Inheritance & Polymorphism](05-oop-inheritance-polymorphism.md)
