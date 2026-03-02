# 📘 Object-Oriented Programming in Java – Complete Guide

> **Master OOP concepts with real-world examples, diagrams, programs, and interview-focused practice.**

---

# Table of Contents

- [1. Classes and Objects](#1-classes-and-objects)
- [2. Constructors](#2-constructors)
- [3. this Keyword](#3-this-keyword)
- [4. static Keyword](#4-static-keyword)
- [5. Encapsulation](#5-encapsulation)
- [6. Inheritance](#6-inheritance)
- [7. Polymorphism](#7-polymorphism)
- [8. Abstraction](#8-abstraction)
- [9. Multiple Inheritance using Interfaces](#9-multiple-inheritance-using-interfaces)

---

# 1. Classes and Objects

## Concept Explanation

A **class** is a **blueprint/template** for creating objects. An **object** is an **instance** of a class — a real-world entity with state (fields) and behavior (methods).

```
Real World Analogy:
┌──────────────────────┐         ┌─────────────────────────┐
│   CLASS = Blueprint   │         │  OBJECT = Actual House  │
│   (House Design)      │   ──→   │  (Built from blueprint) │
│                       │         │                         │
│   - rooms (field)     │         │  - rooms = 3            │
│   - color (field)     │         │  - color = "White"      │
│   - openDoor() (method)│        │  - openDoor() works!    │
└──────────────────────┘         └─────────────────────────┘
```

## Syntax

```java
// Class definition
class ClassName {
    // Fields (attributes / state)
    dataType fieldName;

    // Methods (behavior)
    returnType methodName(parameters) {
        // method body
    }
}

// Creating object
ClassName obj = new ClassName();
obj.fieldName = value;
obj.methodName();
```

## Example Code

```java
// Class definition
class Student {
    // Fields (instance variables)
    String name;
    int age;
    double gpa;

    // Method
    void display() {
        System.out.println("Name: " + name);
        System.out.println("Age: " + age);
        System.out.println("GPA: " + gpa);
    }

    // Method with parameter and return
    boolean isPassed() {
        return gpa >= 2.0;
    }
}

// Main class
public class ClassDemo {
    public static void main(String[] args) {
        // Creating objects
        Student s1 = new Student();
        s1.name = "Alice";
        s1.age = 20;
        s1.gpa = 3.8;

        Student s2 = new Student();
        s2.name = "Bob";
        s2.age = 22;
        s2.gpa = 1.5;

        // Using methods
        s1.display();
        System.out.println("Passed: " + s1.isPassed()); // true

        System.out.println("---");

        s2.display();
        System.out.println("Passed: " + s2.isPassed()); // false
    }
}
```

## Output Explanation

```
Name: Alice
Age: 20
GPA: 3.8
Passed: true
---
Name: Bob
Age: 22
GPA: 1.5
Passed: false
```

- `s1` and `s2` are separate objects with their own copies of fields
- Methods operate on the specific object they're called on

## Visual Explanation – Object Memory

```
Stack                          Heap
┌─────────┐                   ┌─────────────────┐
│  s1 ─────┼──────────────→   │  Student Object  │
│          │                   │  name = "Alice"  │
│          │                   │  age = 20        │
│          │                   │  gpa = 3.8       │
│          │                   └─────────────────┘
│          │
│  s2 ─────┼──────────────→   ┌─────────────────┐
│          │                   │  Student Object  │
└─────────┘                   │  name = "Bob"    │
                               │  age = 22        │
                               │  gpa = 1.5       │
                               └─────────────────┘
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Forgetting `new` keyword | `Student s = new Student();` — `new` allocates memory |
| Accessing fields without object | Instance fields need an object reference |
| Confusing class with object | Class = blueprint, Object = instance |
| Null reference | `Student s; s.display()` → NullPointerException |

## Interview Tips

- Objects are stored in **Heap**, references in **Stack**
- Multiple objects can be created from one class
- Each object gets its own copy of instance variables
- `null` is the default value for object references
- `new` keyword → allocates memory + calls constructor + returns reference

## Quick Revision

> - Class = blueprint (fields + methods)
> - Object = instance (created with `new`)
> - Each object has its own copy of instance variables
> - Objects live in Heap, references live in Stack
> - `NullPointerException` = using a null reference

---

## 📝 Practice – Classes and Objects

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What is a class? | Blueprint/template for objects |
| 2 | What is an object? | Instance of a class |
| 3 | Where are objects stored? | Heap memory |
| 4 | What keyword creates an object? | `new` |
| 5 | What is the default value of an object reference? | `null` |
| 6 | Can a class have multiple objects? | Yes |
| 7 | What are fields? | Variables defined inside a class |
| 8 | What are methods? | Functions/behaviors defined inside a class |
| 9 | Can two objects have different field values? | Yes |
| 10 | What causes NullPointerException? | Using a null reference to call methods/access fields |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Objects are created in? | A) Stack B) Heap C) Method Area D) Register | **B) Heap** |
| 2 | `Student s;` creates? | A) Object B) Reference C) Both D) Neither | **B) Reference only** (no object yet) |
| 3 | `Student s = new Student();` creates? | A) 1 object B) 2 objects C) 0 D) 3 | **A) 1 object** |
| 4 | Can we have a class without methods? | A) No B) Yes C) Error D) Warning | **B) Yes** |
| 5 | Default value of `int` instance variable? | A) null B) 0 C) Error D) undefined | **B) 0** |
| 6 | Default value of `String` instance variable? | A) "" B) 0 C) null D) Error | **C) null** |
| 7 | Can an object reference point to `null`? | A) No B) Yes C) Error D) Warning | **B) Yes** |
| 8 | `obj1 == obj2` compares? | A) Content B) Reference C) Both D) Methods | **B) Reference** |
| 9 | How many classes can a `.java` file have? | A) 1 B) Many, but 1 public C) Unlimited public D) 0 | **B) Many classes, but only 1 public** |
| 10 | Object's behavior is defined by? | A) Fields B) Methods C) Constructor D) main | **B) Methods** |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `Student s1 = new Student(); Student s2 = s1; s2.name = "X";` What is `s1.name`? | A) null B) "X" C) Error D) Unchanged | **B) "X"** — both reference same object |
| 2 | Can a method return an object? | A) No B) Yes C) Only primitives D) Error | **B) Yes** |
| 3 | Is `Student[]` possible? | A) No B) Yes (array of objects) C) Error D) Only primitives | **B) Yes** |
| 4 | What does `System.out.println(obj)` print? | A) Fields B) ClassName@hashcode C) Error D) null | **B) ClassName@hashcode** (unless `toString()` overridden) |
| 5 | How does garbage collector know to collect an object? | A) Manual call B) No references point to it C) After main D) Never | **B) No references** |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | A class can exist without objects | **True** |
| 2 | Two references can point to the same object | **True** |
| 3 | Instance variables are shared across objects | **False** (each object gets its own copy) |
| 4 | `new` keyword calls the constructor | **True** |
| 5 | Object references are stored in Heap | **False** (references are in Stack, objects in Heap) |

### Level 5 – Small Coding Practice

**Exercise 1:** Create a `BankAccount` class with fields `accountHolder` and `balance`, and methods `deposit()` and `withdraw()`.

<details>
<summary>Solution</summary>

```java
class BankAccount {
    String accountHolder;
    double balance;

    void deposit(double amount) {
        balance += amount;
        System.out.println("Deposited: " + amount + ", Balance: " + balance);
    }

    void withdraw(double amount) {
        if (amount > balance) {
            System.out.println("Insufficient balance!");
        } else {
            balance -= amount;
            System.out.println("Withdrawn: " + amount + ", Balance: " + balance);
        }
    }
}

public class BankDemo {
    public static void main(String[] args) {
        BankAccount acc = new BankAccount();
        acc.accountHolder = "Sai";
        acc.balance = 1000;
        acc.deposit(500);   // Balance: 1500
        acc.withdraw(200);  // Balance: 1300
        acc.withdraw(2000); // Insufficient balance!
    }
}
```

</details>

**Exercise 2:** Create a `Rectangle` class with `length` and `width`, and methods to calculate area and perimeter.

<details>
<summary>Solution</summary>

```java
class Rectangle {
    double length, width;

    double area() {
        return length * width;
    }

    double perimeter() {
        return 2 * (length + width);
    }

    void display() {
        System.out.println("Length: " + length + ", Width: " + width);
        System.out.println("Area: " + area());
        System.out.println("Perimeter: " + perimeter());
    }
}

public class RectDemo {
    public static void main(String[] args) {
        Rectangle r = new Rectangle();
        r.length = 5;
        r.width = 3;
        r.display();
    }
}
```

</details>

---

# 2. Constructors

## Concept Explanation

A **constructor** is a special method called automatically when an object is created. It **initializes** the object's state.

```
┌────────────────────────────────────────────┐
│           Constructor Rules                 │
│                                             │
│  ✅ Same name as class                      │
│  ✅ No return type (not even void)          │
│  ✅ Called automatically on object creation  │
│  ✅ Can be overloaded                       │
│  ❌ Cannot be abstract, static, or final    │
└────────────────────────────────────────────┘
```

### Types of Constructors

```
┌─────────────────────────────────────────────────────────┐
│                  Constructors                            │
├──────────────────┬───────────────────┬──────────────────┤
│  Default         │  Parameterized    │  Copy            │
│  (No args)       │  (With args)      │  (Copy another   │
│  Provided by     │  Custom init      │   object)        │
│  compiler if     │  values           │                  │
│  none written    │                   │                  │
└──────────────────┴───────────────────┴──────────────────┘
```

## Syntax

```java
class MyClass {
    // Default constructor
    MyClass() {
        System.out.println("Default constructor");
    }

    // Parameterized constructor
    MyClass(int x, String y) {
        // initialize with parameters
    }

    // Copy constructor
    MyClass(MyClass other) {
        // copy fields from other object
    }
}
```

## Example Code

```java
class Car {
    String brand;
    int year;
    double price;

    // Default constructor
    Car() {
        brand = "Unknown";
        year = 2000;
        price = 0;
        System.out.println("Default constructor called");
    }

    // Parameterized constructor
    Car(String brand, int year, double price) {
        this.brand = brand;     // 'this' distinguishes field from parameter
        this.year = year;
        this.price = price;
        System.out.println("Parameterized constructor called");
    }

    // Copy constructor
    Car(Car other) {
        this.brand = other.brand;
        this.year = other.year;
        this.price = other.price;
        System.out.println("Copy constructor called");
    }

    void display() {
        System.out.println(brand + " | " + year + " | $" + price);
    }
}

public class ConstructorDemo {
    public static void main(String[] args) {
        Car c1 = new Car();                              // Default
        Car c2 = new Car("Tesla", 2024, 45000);          // Parameterized
        Car c3 = new Car(c2);                            // Copy

        c1.display();  // Unknown | 2000 | $0.0
        c2.display();  // Tesla | 2024 | $45000.0
        c3.display();  // Tesla | 2024 | $45000.0
    }
}
```

## Output Explanation

```
Default constructor called
Parameterized constructor called
Copy constructor called
Unknown | 2000 | $0.0
Tesla | 2024 | $45000.0
Tesla | 2024 | $45000.0
```

## Visual Explanation – Constructor Chaining

```
class A {
    A()             { this(10);          }  // calls A(int)
    A(int x)        { this(x, "hello");  }  // calls A(int, String)
    A(int x, String s) { /* actual init */ }
}

new A()  →  A()  →  A(10)  →  A(10, "hello")
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Adding return type to constructor | Constructor has NO return type (not even `void`) |
| Expecting default constructor when parameterized exists | Compiler doesn't add default if any constructor is written |
| `this()` not on first line | `this()` or `super()` must be the FIRST statement |
| Constructor = method | Not the same — constructors don't have return types |

## Interview Tips

- If **no** constructor is written → compiler adds a **default no-arg constructor**
- If **any** constructor is written → compiler does **NOT** add default
- `this()` calls another constructor of the same class (constructor chaining)
- `super()` calls parent class constructor (added by compiler if not written)
- Constructors are **not inherited**
- **Constructor overloading** is possible (same name, different params)
- Cannot have both `this()` and `super()` in same constructor

## Quick Revision

> - Constructor = same name as class, no return type
> - Called automatically with `new`
> - Types: Default, Parameterized, Copy
> - Compiler adds default only if no constructor exists
> - `this()` → chain constructors, `super()` → parent constructor
> - First line must be `this()` or `super()` (not both)

---

## 📝 Practice – Constructors

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What is a constructor? | Special method to initialize objects |
| 2 | Can a constructor have a return type? | No |
| 3 | When is a constructor called? | When an object is created with `new` |
| 4 | What is constructor overloading? | Multiple constructors with different parameters |
| 5 | What is the default constructor? | No-arg constructor provided by compiler |
| 6 | Does compiler add default constructor if parameterized exists? | No |
| 7 | Can a constructor call another constructor? | Yes, using `this()` |
| 8 | Can a constructor be `private`? | Yes (Singleton pattern) |
| 9 | What is a copy constructor? | Constructor that copies another object's fields |
| 10 | Can constructors be inherited? | No |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `void MyClass() {}` is? | A) Constructor B) Method C) Error D) Both | **B) Method** (has `void` return type) |
| 2 | Default constructor does? | A) Nothing B) Initializes defaults C) Calls super() D) B and C | **D) B and C** |
| 3 | `this()` must be on? | A) Last line B) Any line C) First line D) Second line | **C) First line** |
| 4 | Can we have `this()` and `super()` in same constructor? | A) Yes B) No C) Depends D) Error | **B) No** |
| 5 | `private` constructor is used for? | A) Security B) Singleton C) Nothing D) Error | **B) Singleton pattern** |
| 6 | Constructor name must be? | A) Any name B) Same as class C) Main D) Init | **B) Same as class** |
| 7 | Can constructors be `static`? | A) Yes B) No C) Sometimes D) Only in abstract | **B) No** |
| 8 | Can constructors throw exceptions? | A) No B) Yes C) Only unchecked D) Error | **B) Yes** |
| 9 | What does `new MyClass()` return? | A) void B) Reference to object C) null D) int | **B) Reference to object** |
| 10 | Multiple constructors = ? | A) Overriding B) Overloading C) Error D) Shadowing | **B) Overloading** |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `class A { A(int x) {} } class B extends A { B() {} }` — compiles? | A) Yes B) No C) Warning D) Depends | **B) No** — B() implicitly calls `super()`, but A has no no-arg constructor |
| 2 | `this(5)` inside `A(int x)` constructor? | A) Valid B) Infinite loop C) Error D) Recursive constructor | **C) Compile Error** — recursive constructor invocation |
| 3 | Can we call a constructor explicitly? | A) Yes like method B) Only with this() C) Only with new D) B and C | **D) B and C** |
| 4 | Is the default constructor `public`? | A) Always B) Same access as class C) Private D) Protected | **B) Same access as class** |
| 5 | What happens: `A a = new A(); A(){}` with `A(A obj){}`? | A) Calls default B) Calls copy C) Error D) Both | **A) Default constructor** — matches no-arg |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Constructor can be `abstract` | **False** |
| 2 | Constructor can be `final` | **False** |
| 3 | `super()` is added by compiler if not written | **True** |
| 4 | Constructor can have parameters | **True** |
| 5 | You can call a constructor using `this()` from a method | **False** (only from another constructor) |

### Level 5 – Small Coding Practice

**Exercise 1:** Create an `Employee` class with constructor chaining (default → parameterized).

<details>
<summary>Solution</summary>

```java
class Employee {
    String name;
    double salary;

    Employee() {
        this("Unknown", 30000); // chains to parameterized
    }

    Employee(String name, double salary) {
        this.name = name;
        this.salary = salary;
    }

    void display() {
        System.out.println(name + " earns $" + salary);
    }
}

public class EmpDemo {
    public static void main(String[] args) {
        Employee e1 = new Employee();
        Employee e2 = new Employee("Alice", 75000);
        e1.display(); // Unknown earns $30000.0
        e2.display(); // Alice earns $75000.0
    }
}
```

</details>

---

# 3. this Keyword

## Concept Explanation

`this` is a **reference variable** that refers to the **current object**. It is used to:

1. Distinguish instance variables from parameters (when names conflict)
2. Call another constructor (`this()`)
3. Pass current object as argument
4. Return current object

## Example Code

```java
class Person {
    String name;
    int age;

    // 1. Distinguish field from parameter
    Person(String name, int age) {
        this.name = name;  // this.name = instance variable
        this.age = age;    // name = constructor parameter
    }

    // 2. Constructor chaining
    Person() {
        this("Unknown", 0);  // calls parameterized constructor
    }

    // 3. Pass current object
    void show() {
        display(this);  // passing current object
    }

    static void display(Person p) {
        System.out.println(p.name + ", " + p.age);
    }

    // 4. Return current object (method chaining)
    Person setName(String name) {
        this.name = name;
        return this;  // returns current object
    }

    Person setAge(int age) {
        this.age = age;
        return this;
    }
}

public class ThisDemo {
    public static void main(String[] args) {
        Person p1 = new Person("Sai", 25);
        p1.show();  // Sai, 25

        // Method chaining using this
        Person p2 = new Person()
            .setName("Alice")
            .setAge(30);
        p2.show();  // Alice, 30
    }
}
```

## Visual Explanation

```
Person p = new Person("Sai", 25);

Inside constructor:
┌─────────────────────────────┐
│  this ──→ [Current Object]  │
│           name = "Sai"      │
│           age = 25          │
│                             │
│  this.name = name;          │
│  (field)    (parameter)     │
└─────────────────────────────┘
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Using `this` in `static` context | `this` cannot be used in static methods |
| `this()` not on first line of constructor | Must be the very first statement |
| Confusing `this` with class name | `this` = current object, not the class |

## Interview Tips

- `this` cannot be used in **static** methods (no object context)
- `this()` must be the **first statement** in a constructor
- `return this;` enables **method chaining** (Builder pattern)
- `this` is an implicit parameter in every instance method

## Quick Revision

> - `this` = reference to current object
> - Uses: distinguish fields, constructor chaining, pass/return object
> - Cannot use in static context
> - `this()` must be first line in constructor

---

# 4. static Keyword

## Concept Explanation

`static` means the member belongs to the **class**, not to any specific **object**. It is shared among all instances.

```
┌──────────────────────────────────────────────────┐
│           static vs non-static                    │
│                                                   │
│  Instance Member          Static Member           │
│  ─────────────────       ──────────────────       │
│  Belongs to OBJECT       Belongs to CLASS         │
│  Each object gets copy   Shared by ALL objects    │
│  Accessed via object     Accessed via class name  │
│  Stored in HEAP          Stored in METHOD AREA    │
│  Needs object to call    No object needed         │
└──────────────────────────────────────────────────┘
```

## Syntax

```java
class MyClass {
    static int count;              // static variable
    int id;                        // instance variable

    static void greet() {          // static method
        System.out.println("Hello");
    }

    static {                       // static block (runs once when class loads)
        count = 0;
        System.out.println("Static block executed");
    }
}
```

## Example Code

```java
class Counter {
    int instanceCount;        // separate for each object
    static int staticCount;   // shared across ALL objects

    Counter() {
        instanceCount++;
        staticCount++;
    }

    void display() {
        System.out.println("Instance: " + instanceCount +
                         ", Static: " + staticCount);
    }

    static void showTotal() {
        System.out.println("Total objects: " + staticCount);
        // System.out.println(instanceCount); // ERROR! Can't access instance
    }
}

public class StaticDemo {
    public static void main(String[] args) {
        Counter c1 = new Counter();
        c1.display();  // Instance: 1, Static: 1

        Counter c2 = new Counter();
        c2.display();  // Instance: 1, Static: 2

        Counter c3 = new Counter();
        c3.display();  // Instance: 1, Static: 3

        Counter.showTotal();  // Total objects: 3
    }
}
```

## Output Explanation

```
Instance: 1, Static: 1
Instance: 1, Static: 2
Instance: 1, Static: 3
Total objects: 3
```

- `instanceCount` resets to 0 for each new object, increments to 1
- `staticCount` is shared — keeps increasing across all objects

## Visual Explanation

```
                   Method Area
                   ┌────────────────┐
                   │ staticCount = 3 │
                   └────────────────┘
                       ↑  ↑  ↑
              ┌────────┘  │  └────────┐
              │           │           │
         ┌────┴────┐ ┌────┴────┐ ┌────┴────┐
  Heap:  │   c1     │ │   c2     │ │   c3     │
         │ inst=1   │ │ inst=1   │ │ inst=1   │
         └─────────┘ └─────────┘ └─────────┘

All three objects SHARE the same staticCount.
Each has its OWN instanceCount.
```

## Static Block

```java
class Config {
    static String dbUrl;

    // Static block runs ONCE when the class is loaded
    static {
        dbUrl = "jdbc:mysql://localhost:3306/mydb";
        System.out.println("Database config loaded!");
    }
}
```

- Static blocks execute **once** when the class is first loaded
- Multiple static blocks execute in order of appearance
- Used for complex static initialization

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Accessing instance variable from static method | Static can't access non-static directly |
| Using `this` in static method | `this` doesn't exist in static context |
| Thinking static methods can be overridden | They are **hidden**, not overridden |
| Creating object to access static member | Use `ClassName.member` directly |

## Interview Tips

- Static methods cannot access instance variables/methods directly
- Static methods **cannot** use `this` or `super`
- Static methods can be **hidden** (not overridden) in subclasses
- `main()` is static so JVM can call it without creating an object
- Static variables are initialized when the class is **loaded**
- Static inner classes exist, but static outer classes don't

## Quick Revision

> - `static` = belongs to class, shared by all objects
> - Static: variable, method, block, inner class
> - Cannot access instance members from static context
> - No `this` or `super` in static methods
> - Static block runs once when class loads
> - Static methods: hidden, not overridden

---

## 📝 Practice – this & static

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What does `this` refer to? | Current object |
| 2 | Can `this` be used in static methods? | No |
| 3 | What does `static` mean? | Belongs to class, not object |
| 4 | Are static variables shared? | Yes, across all objects |
| 5 | When does a static block run? | When the class is first loaded |
| 6 | Can static methods access instance variables? | No, not directly |
| 7 | What is `this()` used for? | Constructor chaining |
| 8 | Why is main() static? | So JVM can call it without an object |
| 9 | Where are static variables stored? | Method Area (class area) |
| 10 | Can static methods be overridden? | No, they are hidden |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `static int x;` default value? | A) null B) 0 C) Error D) undefined | **B) 0** |
| 2 | Can we access static method via object? | A) No B) Yes (but not recommended) C) Error D) Depends | **B) Yes** (but use class name) |
| 3 | How many static blocks can a class have? | A) 1 B) 2 C) Unlimited D) 0 | **C) Unlimited** |
| 4 | `this` in constructor refers to? | A) Class B) Object being constructed C) Parent D) null | **B) Object being constructed** |
| 5 | Static method calling instance method? | A) Direct B) Via object C) Error D) Via this | **B) Via object only** |
| 6 | `return this;` returns? | A) Class B) Copy C) Current object reference D) null | **C) Current object reference** |
| 7 | Static variable initialized when? | A) Object created B) Class loaded C) main runs D) Never | **B) Class loaded** |
| 8 | `this()` vs `super()` in same constructor? | A) Allowed B) Not allowed C) Depends D) Uses both | **B) Not allowed** |
| 9 | `this.x` vs `x` when no naming conflict? | A) Different B) Same C) Error D) Depends | **B) Same** |
| 10 | Can a local variable be static? | A) Yes B) No C) Depends D) Only final | **B) No** |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Order: static block, instance block, constructor? | A) instance→static→constructor B) static→instance→constructor C) constructor→static→instance D) Random | **B) static→instance→constructor** |
| 2 | `class A { static { print("1"); } { print("2"); } A() { print("3"); } }` — `new A()` prints? | A) 123 B) 213 C) 321 D) 132 | **A) "123"** |
| 3 | Two `new A()` calls — static block runs? | A) Twice B) Once C) Never D) Depends | **B) Once** |
| 4 | Can `this` be assigned? `this = null;`? | A) Yes B) No C) Depends D) Runtime error | **B) No** — `this` is a final reference |
| 5 | Static method in interface? | A) Not allowed B) Allowed (Java 8+) C) Only abstract D) Error | **B) Allowed** (Java 8+) |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | `this()` can be called from a regular method | **False** (only from constructor) |
| 2 | Static variables survive garbage collection | **True** (until class is unloaded) |
| 3 | Instance methods can access static variables | **True** |
| 4 | Static methods can access instance variables | **False** |
| 5 | `this` is available inside instance initializer block | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Create a class that tracks how many objects have been created using a `static` counter.

<details>
<summary>Solution</summary>

```java
class Tracker {
    static int count = 0;
    int id;

    Tracker() {
        count++;
        id = count;
    }

    void show() {
        System.out.println("Object #" + id + " | Total: " + count);
    }

    public static void main(String[] args) {
        Tracker a = new Tracker();
        Tracker b = new Tracker();
        Tracker c = new Tracker();
        a.show(); // Object #1 | Total: 3
        b.show(); // Object #2 | Total: 3
        c.show(); // Object #3 | Total: 3
    }
}
```

</details>

---

# 5. Encapsulation

## Concept Explanation

**Encapsulation** = wrapping data (fields) and code (methods) into a single unit (class) and **restricting direct access** to internal data using access modifiers.

```
┌────────────────────────────────────────────────┐
│               Encapsulation                     │
│                                                 │
│   ┌─────────────────────────┐                  │
│   │   Private Fields        │  ← Hidden        │
│   │   - name                │                  │
│   │   - balance             │                  │
│   └─────────────────────────┘                  │
│                                                 │
│   ┌─────────────────────────┐                  │
│   │   Public Getters/Setters│  ← Controlled    │
│   │   + getName()           │    Access         │
│   │   + setName()           │                  │
│   │   + getBalance()        │                  │
│   │   + deposit()           │                  │
│   └─────────────────────────┘                  │
│                                                 │
│   Data is PROTECTED, access is CONTROLLED       │
└────────────────────────────────────────────────┘
```

### Access Modifiers

| Modifier | Same Class | Same Package | Subclass | Other Package |
|----------|-----------|-------------|----------|--------------|
| `private` | ✅ | ❌ | ❌ | ❌ |
| `default` (no modifier) | ✅ | ✅ | ❌ | ❌ |
| `protected` | ✅ | ✅ | ✅ | ❌ |
| `public` | ✅ | ✅ | ✅ | ✅ |

## Example Code

```java
class Account {
    // Private fields - cannot be accessed directly from outside
    private String owner;
    private double balance;

    // Constructor
    public Account(String owner, double balance) {
        this.owner = owner;
        this.balance = balance;
    }

    // Getter - controlled read access
    public String getOwner() {
        return owner;
    }

    // Setter - controlled write access with validation
    public void setOwner(String owner) {
        if (owner != null && !owner.isEmpty()) {
            this.owner = owner;
        } else {
            System.out.println("Invalid name!");
        }
    }

    // Getter for balance
    public double getBalance() {
        return balance;
    }

    // No setter for balance — controlled through deposit/withdraw
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposited: $" + amount);
        } else {
            System.out.println("Invalid amount!");
        }
    }

    public void withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            System.out.println("Withdrawn: $" + amount);
        } else {
            System.out.println("Invalid or insufficient!");
        }
    }
}

public class EncapsulationDemo {
    public static void main(String[] args) {
        Account acc = new Account("Sai", 5000);

        // acc.balance = -1000;  // ERROR! balance is private
        // acc.owner = "";       // ERROR! owner is private

        acc.deposit(1000);           // Deposited: $1000
        acc.withdraw(500);           // Withdrawn: $500
        System.out.println("Balance: $" + acc.getBalance()); // $5500

        acc.setOwner("");            // Invalid name!
        acc.setOwner("Alice");       // Works
        System.out.println("Owner: " + acc.getOwner()); // Alice
    }
}
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Making fields `public` | Use `private` fields + public getters/setters |
| Setter without validation | Always validate input in setters |
| Exposing mutable objects via getter | Return copies of mutable objects |
| Thinking encapsulation = just using private | Also includes controlled access |

## Interview Tips

- Encapsulation = **data hiding** + **controlled access**
- Always make fields `private`
- Provide `public` getters and setters
- A class with all private fields and public getters/setters is a **POJO** (Plain Old Java Object)
- **JavaBeans** follow encapsulation conventions
- Advantage: change internal implementation without affecting external code

## Quick Revision

> - Private fields + public getters/setters
> - 4 access modifiers: `private`, `default`, `protected`, `public`
> - Encapsulation hides data and controls access
> - Validate data in setters
> - Enables flexibility and security

---

# 6. Inheritance

## Concept Explanation

**Inheritance** allows a class to inherit fields and methods from another class. It models an **IS-A** relationship.

```
┌─────────────────────────────────────────────────┐
│              Inheritance Types                    │
│                                                  │
│  1. Single:    A → B                             │
│  2. Multilevel: A → B → C                        │
│  3. Hierarchical: A → B, A → C                   │
│                                                  │
│  ❌ Multiple inheritance (classes): NOT in Java   │
│  ✅ Multiple inheritance (interfaces): Supported  │
└─────────────────────────────────────────────────┘
```

```
Real-world Example:
         ┌─────────┐
         │ Animal   │  ← Parent / Superclass
         │ - name   │
         │ + eat()  │
         └────┬────┘
              │ extends
     ┌────────┴────────┐
     │                  │
┌────┴────┐      ┌─────┴────┐
│  Dog     │      │  Cat      │  ← Child / Subclass
│ + bark() │      │ + meow()  │
└─────────┘      └──────────┘
```

## Syntax

```java
class Parent {
    // parent members
}

class Child extends Parent {
    // inherits parent members
    // can add its own members
}
```

## Example Code

```java
// Parent class
class Animal {
    String name;
    int age;

    Animal(String name, int age) {
        this.name = name;
        this.age = age;
    }

    void eat() {
        System.out.println(name + " is eating");
    }

    void sleep() {
        System.out.println(name + " is sleeping");
    }
}

// Child class
class Dog extends Animal {
    String breed;

    Dog(String name, int age, String breed) {
        super(name, age);        // calls parent constructor
        this.breed = breed;
    }

    void bark() {
        System.out.println(name + " says Woof!");
    }

    // Overriding parent method
    @Override
    void eat() {
        System.out.println(name + " is eating dog food");
    }
}

// Another child class
class Cat extends Animal {
    Cat(String name, int age) {
        super(name, age);
    }

    void meow() {
        System.out.println(name + " says Meow!");
    }
}

public class InheritanceDemo {
    public static void main(String[] args) {
        Dog dog = new Dog("Buddy", 3, "Labrador");
        dog.eat();      // Buddy is eating dog food (overridden)
        dog.sleep();    // Buddy is sleeping (inherited)
        dog.bark();     // Buddy says Woof! (own method)

        Cat cat = new Cat("Whiskers", 2);
        cat.eat();      // Whiskers is eating (inherited)
        cat.meow();     // Whiskers says Meow! (own method)

        // Parent reference, child object (upcasting)
        Animal a = new Dog("Max", 5, "Poodle");
        a.eat();        // Max is eating dog food (runtime polymorphism)
        // a.bark();    // ERROR! Animal reference doesn't know about bark()
    }
}
```

## Output

```
Buddy is eating dog food
Buddy is sleeping
Buddy says Woof!
Whiskers is eating
Whiskers says Meow!
Max is eating dog food
```

## Visual Explanation – super keyword

```
class Dog extends Animal:

  super.eat()  → calls Animal's eat()
  super(name, age) → calls Animal's constructor

  ┌──────────────┐
  │   Animal      │ ← super refers to this
  │   name, age   │
  │   eat()       │
  └──────┬───────┘
         │ extends
  ┌──────┴───────┐
  │   Dog         │ ← this refers to this
  │   breed       │
  │   bark()      │
  │   eat() @Override│
  └──────────────┘
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Calling parent constructor without `super()` | `super()` is added by compiler only if parent has no-arg constructor |
| Trying multiple inheritance with classes | Use interfaces instead |
| Not calling `super()` first in child constructor | Must be the first statement |
| Confusing inheritance with composition | Inheritance = IS-A, Composition = HAS-A |

## Interview Tips

- Java supports **single inheritance** for classes
- `super()` must be the **first statement** in child constructor
- If parent has no default constructor, child MUST explicitly call `super(args)`
- **Private members** are inherited but **not accessible** in child
- Constructor is **NOT inherited**
- `final` class cannot be extended
- `Object` class is the root of all classes in Java
- IS-A: Dog IS-A Animal | HAS-A: Car HAS-A Engine

## Quick Revision

> - `extends` keyword for inheritance
> - Child inherits parent's non-private members
> - `super` accesses parent's members/constructors
> - Single inheritance only (for classes)
> - `final` class can't be extended
> - Every class extends `Object` by default

---

## 📝 Practice – Encapsulation & Inheritance

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What is encapsulation? | Data hiding with controlled access |
| 2 | Which modifier hides data from outside? | `private` |
| 3 | What keyword is used for inheritance? | `extends` |
| 4 | What does `super` refer to? | Parent class |
| 5 | Can a private field be inherited? | Inherited but not directly accessible |
| 6 | What is a getter method? | Method that returns a private field's value |
| 7 | What is IS-A relationship? | Inheritance (Dog IS-A Animal) |
| 8 | Can a final class be extended? | No |
| 9 | What class does every Java class extend? | Object |
| 10 | Can constructors be inherited? | No |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Access modifier allowing same package only? | A) private B) default C) protected D) public | **B) default** |
| 2 | `protected` allows access from? | A) Same class only B) Same package + subclass C) Everywhere D) Nowhere | **B) Same package + subclass** |
| 3 | Java supports multiple inheritance via? | A) Classes B) Interfaces C) Both D) Neither | **B) Interfaces** |
| 4 | `super()` must be? | A) Last line B) First line C) Any line D) In main | **B) First line of constructor** |
| 5 | `final` method can be? | A) Overridden B) Overloaded C) Neither D) Error | **B) Overloaded** only |
| 6 | Which is NOT inherited? | A) Methods B) Fields C) Constructors D) Both A&B are inherited | **C) Constructors** |
| 7 | Can child access parent's private method? | A) Yes B) No C) With super D) With this | **B) No** |
| 8 | `class A { } class B extends A { }` — B is? | A) Parent B) Child C) Sibling D) Base | **B) Child/Subclass** |
| 9 | Encapsulation is achieved by? | A) Inheritance B) Private fields + public methods C) Static D) Final | **B) Private fields + public methods** |
| 10 | Diamond problem is related to? | A) Encapsulation B) Multiple inheritance C) Polymorphism D) Abstraction | **B) Multiple inheritance** |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `class A { A(int x) {} } class B extends A { }` — compiles? | A) Yes B) No C) Warning D) Depends | **B) No** — B needs to call `super(int)` explicitly |
| 2 | Can `protected` members be accessed from different package non-subclass? | A) Yes B) No C) Sometimes D) With import | **B) No** |
| 3 | `super.super.method()` — valid? | A) Yes B) No C) Depends D) Only in Java 11+ | **B) No** — can't chain super |
| 4 | Order of execution: parent static → child static → parent constructor → child constructor? | A) Correct B) Wrong C) Depends D) Random | **A) Correct** |
| 5 | Can a subclass narrowing access throw error? | A) No B) Yes C) Warning D) Runtime | **B) Yes** — overriding with more restrictive access modifier causes compile error |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Private methods can be overridden | **False** |
| 2 | `protected` is more restrictive than `default` | **False** (protected is less restrictive) |
| 3 | Multilevel inheritance is supported in Java | **True** |
| 4 | A child can have more methods than parent | **True** |
| 5 | `super()` is implicitly called if not written | **True** (no-arg super) |

### Level 5 – Small Coding Practice

**Exercise 1:** Create a `Shape` parent class and `Circle`, `Rectangle` child classes with `area()` method.

<details>
<summary>Solution</summary>

```java
class Shape {
    String color;
    Shape(String color) { this.color = color; }
    double area() { return 0; }
}

class Circle extends Shape {
    double radius;
    Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }
    @Override
    double area() { return Math.PI * radius * radius; }
}

class RectangleShape extends Shape {
    double length, width;
    RectangleShape(String color, double l, double w) {
        super(color);
        this.length = l;
        this.width = w;
    }
    @Override
    double area() { return length * width; }
}

public class ShapeDemo {
    public static void main(String[] args) {
        Circle c = new Circle("Red", 5);
        System.out.println("Circle area: " + c.area()); // ~78.54

        RectangleShape r = new RectangleShape("Blue", 4, 6);
        System.out.println("Rectangle area: " + r.area()); // 24.0
    }
}
```

</details>

---

### 🔥 20 Tricky Interview MCQs – Encapsulation & Inheritance

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | Can we override `private` methods? | A) Yes B) No C) Only with super D) Depends | **B) No** | Private methods are not visible to subclass |
| 2 | `class Child extends Parent1, Parent2` — valid? | A) Yes B) No C) With interface D) Java 17+ | **B) No** | Multiple class inheritance not allowed |
| 3 | Can `static` method be inherited? | A) No B) Yes (but hidden, not overridden) C) Error D) Depends | **B) Yes** (hidden, not overridden) |
| 4 | `Object` class has how many methods? | A) 5 B) 11 C) 0 D) 3 | **B) ~11** (toString, equals, hashCode, etc.) |
| 5 | Overriding method can have wider access? | A) No B) Yes C) Same only D) Error | **B) Yes** (can be MORE accessible, not less) |
| 6 | `this()` and `super()` both in constructor? | A) Yes B) No C) Depends D) Only this | **B) No** |
| 7 | `A a = new B(); a.method();` — which method runs? | A) A's B) B's (if overridden) C) Error D) Both | **B) B's** (runtime polymorphism) |
| 8 | Can interface extend class? | A) Yes B) No C) Only abstract D) Depends | **B) No** (interface extends interface) |
| 9 | `class A { void m() {} } class B extends A { private void m() {} }` | A) Valid B) Error C) Warning D) Depends | **B) Error** — can't make access more restrictive |
| 10 | Is `toString()` inherited from? | A) JVM B) Object class C) String class D) main | **B) Object class** |
| 11 | `class A { int x=5; } class B extends A { int x=10; }` — `new B().x`? | A) 5 B) 10 C) Error D) 15 | **B) 10** — field hiding (variable resolved by reference type) |
| 12 | Constructor chaining from child to parent uses? | A) this() B) super() C) new D) extends | **B) super()** |
| 13 | Can abstract class have constructor? | A) No B) Yes C) Only default D) Error | **B) Yes** |
| 14 | `final` method purpose? | A) Speed B) Prevent overriding C) Static D) Private | **B) Prevent overriding** |
| 15 | Widening reference in inheritance: `Animal a = new Dog()`? | A) Downcasting B) Upcasting C) Error D) Both | **B) Upcasting** |
| 16 | `instanceof` keyword checks? | A) Type at compile time B) Type at runtime C) Both D) Neither | **B) Runtime type** |
| 17 | `private` constructor prevents? | A) Objects B) Inheritance C) Both D) Methods | **C) Both** (no external instantiation or subclassing) |
| 18 | Which is tighter coupling? | A) Inheritance B) Composition C) Same D) Depends | **A) Inheritance** |
| 19 | `class A { A(){print("A");} } class B extends A { B(){print("B");} }` new B() prints? | A) B B) A C) AB D) BA | **C) "AB"** — parent constructor first |
| 20 | Can we downcast without `instanceof`? | A) Yes (risky) B) No C) Auto D) Error | **A) Yes** but may throw ClassCastException |

---

# 7. Polymorphism

## Concept Explanation

**Polymorphism** = "many forms" — the same method name behaves differently depending on the context.

```
┌──────────────────────────────────────────────────────┐
│                 Polymorphism                          │
├────────────────────────┬─────────────────────────────┤
│  Compile-Time          │  Runtime                     │
│  (Static Binding)      │  (Dynamic Binding)           │
│  ─────────────────     │  ──────────────────          │
│  Method OVERLOADING    │  Method OVERRIDING            │
│  Same class            │  Parent-Child classes         │
│  Different parameters  │  Same signature               │
│  Resolved at compile   │  Resolved at runtime          │
│  time                  │  (JVM decides)                │
└────────────────────────┴─────────────────────────────┘
```

## Method Overloading (Compile-Time)

```java
class Calculator {
    // Same name, different parameters
    int add(int a, int b) {
        return a + b;
    }

    int add(int a, int b, int c) {
        return a + b + c;
    }

    double add(double a, double b) {
        return a + b;
    }

    // ❌ NOT valid overloading (only return type differs)
    // long add(int a, int b) { return a + b; }  // ERROR
}
```

### Overloading Rules

| Valid for Overloading | Not Valid |
|----------------------|----------|
| Different number of parameters | Different return type only |
| Different types of parameters | Different access modifier only |
| Different order of types | Different exception only |

## Method Overriding (Runtime)

```java
class Animal {
    void sound() {
        System.out.println("Some animal sound");
    }
}

class Dog extends Animal {
    @Override
    void sound() {
        System.out.println("Bark!");
    }
}

class Cat extends Animal {
    @Override
    void sound() {
        System.out.println("Meow!");
    }
}

public class PolymorphismDemo {
    public static void main(String[] args) {
        // Runtime polymorphism
        Animal a1 = new Dog();    // Upcasting
        Animal a2 = new Cat();    // Upcasting
        Animal a3 = new Animal();

        a1.sound();  // Bark!    (Dog's sound at runtime)
        a2.sound();  // Meow!   (Cat's sound at runtime)
        a3.sound();  // Some animal sound

        // Polymorphic array
        Animal[] animals = {new Dog(), new Cat(), new Animal()};
        for (Animal a : animals) {
            a.sound();  // Each calls its own version
        }
    }
}
```

## Output

```
Bark!
Meow!
Some animal sound
Bark!
Meow!
Some animal sound
```

### Overriding Rules

| Rule | Description |
|------|-------------|
| Same method signature | Name + parameters must match |
| IS-A relationship | Must be in parent-child classes |
| Access modifier | Can be same or wider, never narrower |
| Return type | Same or covariant (subtype) |
| `static` methods | Cannot be overridden (hidden instead) |
| `final` methods | Cannot be overridden |
| `private` methods | Cannot be overridden (not visible) |
| `@Override` annotation | Optional but recommended |

## Visual Explanation – Runtime Polymorphism

```
Compile Time:                    Runtime:
┌────────────────────┐          ┌────────────────────┐
│ Reference type:     │          │ Object type:        │
│ Animal a = new Dog()│          │ JVM checks actual   │
│                     │          │ object → Dog        │
│ Compiler sees:      │          │ Calls: Dog.sound()  │
│ a.sound() → valid   │          │ Output: "Bark!"     │
│ (Animal has sound)  │          │                     │
└────────────────────┘          └────────────────────┘

Which method to call? → Decided at RUNTIME based on actual object type.
```

## Upcasting and Downcasting

```java
// Upcasting (automatic) — Parent ref = Child obj
Animal a = new Dog();      // ✅ Safe
a.sound();                 // ✅ Dog's sound()
// a.bark();              // ❌ Compile error — Animal doesn't know bark()

// Downcasting (manual) — Child ref = Parent ref
Dog d = (Dog) a;           // ✅ Works because a actually points to Dog
d.bark();                  // ✅ Now bark() is accessible

// Risky downcast
Animal a2 = new Cat();
// Dog d2 = (Dog) a2;     // ❌ ClassCastException at runtime!

// Safe downcast with instanceof
if (a instanceof Dog) {
    Dog d3 = (Dog) a;
    d3.bark();             // Safe!
}
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Overloading = changing only return type | Parameters must differ |
| Overriding static methods | Static methods are hidden, not overridden |
| Forgetting `@Override` annotation | Always use it — catches typo errors |
| Narrowing access in overriding | Child access must be same or wider |
| Downcasting without `instanceof` | Always check with `instanceof` first |

## Interview Tips

- **Overloading** = compile-time polymorphism (static binding)
- **Overriding** = runtime polymorphism (dynamic binding)
- JVM uses **virtual method table (vtable)** for dynamic dispatch
- `@Override` helps compiler detect errors
- **Covariant return type**: overriding method can return a subtype
- `static`, `final`, `private` methods **cannot** be overridden
- Overloading can change return type IF parameters also differ

## Quick Revision

> - Polymorphism = one name, many forms
> - Overloading = same class, different params (compile-time)
> - Overriding = parent-child, same signature (runtime)
> - Upcasting = automatic, Downcasting = manual (use `instanceof`)
> - `@Override` annotation is best practice
> - static/final/private → cannot override

---

## 📝 Practice – Polymorphism

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What is polymorphism? | One name, many forms |
| 2 | What is method overloading? | Same name, different parameters in same class |
| 3 | What is method overriding? | Redefining parent's method in child class |
| 4 | Overloading is which type of polymorphism? | Compile-time (static) |
| 5 | Overriding is which type? | Runtime (dynamic) |
| 6 | What annotation is used for overriding? | `@Override` |
| 7 | Can a final method be overridden? | No |
| 8 | What is upcasting? | Parent reference = Child object |
| 9 | What is downcasting? | Child reference = Parent reference (explicit cast) |
| 10 | What does `instanceof` check? | Whether an object is an instance of a class/interface |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Overloading requires different? | A) Name B) Parameters C) Return type D) Class | **B) Parameters** |
| 2 | Overriding requires? | A) Same class B) Inheritance C) Static D) Private | **B) Inheritance** |
| 3 | `Animal a = new Dog(); a.sound();` calls? | A) Animal's B) Dog's C) Error D) Both | **B) Dog's** (runtime polymorphism) |
| 4 | Can overriding change return type? | A) No B) Yes, any type C) Yes, covariant only D) Error | **C) Covariant return type** |
| 5 | Which cannot be overridden? | A) public B) final C) protected D) default | **B) final** |
| 6 | `@Override` is? | A) Required B) Optional C) Error D) Mandatory | **B) Optional** (but recommended) |
| 7 | Static method overriding? | A) Possible B) Method hiding C) Error D) Both | **B) Method hiding** (not true overriding) |
| 8 | Can constructors be overridden? | A) Yes B) No C) Depends D) Overloaded only | **B) No** (but can be overloaded) |
| 9 | Overloading in different classes (parent-child)? | A) Not possible B) Possible C) Error D) Warning | **B) Possible** |
| 10 | `Animal a = new Dog(); a.bark();`? | A) Works B) Error C) Depends D) Warning | **B) Compile Error** — Animal doesn't have bark() |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | `void m(int a)` and `void m(Integer a)` — overloaded? | A) Yes B) No C) Error D) Same | **A) Yes** — int vs Integer (autoboxing) |
| 2 | `void m(Object o)` and `void m(String s)` — `m(null)` calls? | A) Object B) String C) Ambiguous D) Error | **B) String** — most specific match |
| 3 | `void m(int... a)` and `void m(int a, int b)` — `m(1,2)` calls? | A) varargs B) two-param C) Error D) Ambiguous | **B) two-param** — exact match preferred over varargs |
| 4 | Can overriding method throw fewer exceptions? | A) No B) Yes C) Error D) Must throw same | **B) Yes** — can throw fewer/narrower, not more/broader checked exceptions |
| 5 | Overriding with `private` access on parent's `public` method? | A) Valid B) Compile Error C) Warning D) Runtime Error | **B) Compile Error** — access can't be narrowed |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Method overloading can differ by return type alone | **False** |
| 2 | Runtime polymorphism uses dynamic binding | **True** |
| 3 | Constructors can be overloaded | **True** |
| 4 | `private` methods can be overridden | **False** |
| 5 | Upcasting is always safe | **True** |

### Level 5 – Small Coding Practice

**Exercise 1:** Create a `Vehicle` class with `fuelType()` method. Override it in `ElectricCar` and `PetrolCar`.

<details>
<summary>Solution</summary>

```java
class Vehicle {
    void fuelType() {
        System.out.println("Unknown fuel");
    }
}

class ElectricCar extends Vehicle {
    @Override
    void fuelType() {
        System.out.println("Electric battery");
    }
}

class PetrolCar extends Vehicle {
    @Override
    void fuelType() {
        System.out.println("Petrol/Gasoline");
    }
}

public class VehicleDemo {
    public static void main(String[] args) {
        Vehicle v1 = new ElectricCar();
        Vehicle v2 = new PetrolCar();
        v1.fuelType(); // Electric battery
        v2.fuelType(); // Petrol/Gasoline
    }
}
```

</details>

---

### 🔥 20 Tricky Interview MCQs – Polymorphism

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | Can `main()` be overloaded? | A) No B) Yes C) Error D) Only overridden | **B) Yes** | But JVM only calls `main(String[])` |
| 2 | `void m(int a, long b)` vs `void m(long a, int b)` — `m(5, 5)` calls? | A) First B) Second C) Ambiguous D) Error | **C) Ambiguous error** | Both match with auto-widening |
| 3 | Overriding method access: parent `protected`, child `public`? | A) Error B) Valid C) Warning D) Depends | **B) Valid** | Widening access is allowed |
| 4 | Overriding method access: parent `public`, child `protected`? | A) Valid B) Error C) Warning D) Runtime | **B) Error** | Narrowing access not allowed |
| 5 | `class A { int m() { return 1; } } class B extends A { short m() { return 1; } }` | A) Valid B) Error C) Warning D) Depends | **B) Error** | short is not a subtype of int |
| 6 | Can we override `equals()`? | A) No B) Yes C) Final D) Static | **B) Yes** | equals() is from Object class, not final |
| 7 | Field polymorphism exists in Java? | A) Yes B) No C) Only methods D) Both | **B) No** | Fields are resolved by reference type (compile time) |
| 8 | `Animal a = new Dog(); a.x` vs `((Dog)a).x` — same? | A) Yes B) No C) Depends D) Error | **B) No** — fields use reference type, not object type |
| 9 | Can abstract method be overloaded? | A) No B) Yes C) Error D) Only overridden | **B) Yes** |
| 10 | Runtime polymorphism is also called? | A) Static dispatch B) Dynamic dispatch C) Overloading D) Hiding | **B) Dynamic dispatch** |
| 11 | What determines which overloaded method to call? | A) Object type B) Reference type C) Parameters D) Return type | **C) Parameters** (at compile time) |
| 12 | What determines which overridden method to call? | A) Reference type B) Object type C) Parameters D) Static | **B) Object type** (at runtime) |
| 13 | `final class A { }` can be? | A) Extended B) Overridden C) Neither D) Error | **C) Neither** — can't extend final class |
| 14 | `A a = new B(); a.method();` — `B.method()` is private? | A) B's method B) A's method C) Error D) Depends | **B) A's method** — private methods aren't overridden |
| 15 | `void m(Object o) {}` and `void m(String s) {}` — `m("hi")` calls? | A) Object B) String C) Both D) Error | **B) String** — most specific match |
| 16 | Compile-time polymorphism is also called? | A) Late binding B) Early binding C) Dynamic D) Virtual | **B) Early binding** |
| 17 | Covariant return type means? | A) Any return type B) Subtype of parent's return C) Same type D) void | **B) Subtype of parent's return type** |
| 18 | Can interface methods be overloaded? | A) No B) Yes C) Error D) Only default | **B) Yes** |
| 19 | `Object o = "Hello"; o.length()`? | A) 5 B) Error C) Depends D) 0 | **B) Compile Error** — Object doesn't have length() |
| 20 | Method resolution order for overloading: exact → widening → autoboxing → varargs? | A) Correct B) Wrong C) Only exact D) Random | **A) Correct** |

---

# 8. Abstraction

## Concept Explanation

**Abstraction** = hiding implementation details and showing only essential features. It answers "WHAT to do" not "HOW to do."

```
┌────────────────────────────────────────────────────┐
│                Abstraction in Java                  │
├──────────────────────┬─────────────────────────────┤
│  Abstract Classes     │  Interfaces                  │
│  ──────────────       │  ──────────                  │
│  0-100% abstraction   │  100% abstraction (pre-Java 8)│
│  Can have concrete    │  All methods abstract        │
│  methods              │  (default/static from Java 8) │
│  Can have fields      │  Only constants              │
│  Single inheritance   │  Multiple inheritance         │
│  `abstract class A`   │  `interface I`               │
│  `extends`            │  `implements`                │
└──────────────────────┴─────────────────────────────┘
```

## Abstract Classes

### Syntax

```java
abstract class Shape {
    String color;

    // Abstract method (no body)
    abstract double area();

    // Concrete method (has body)
    void display() {
        System.out.println("Color: " + color);
    }
}
```

### Example Code

```java
abstract class Shape {
    String color;

    Shape(String color) {
        this.color = color;
    }

    // Abstract method — subclass MUST implement
    abstract double area();
    abstract double perimeter();

    // Concrete method — inherited as-is
    void displayInfo() {
        System.out.println("Color: " + color);
        System.out.println("Area: " + area());
        System.out.println("Perimeter: " + perimeter());
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

    @Override
    double perimeter() {
        return 2 * Math.PI * radius;
    }
}

class Rectangle extends Shape {
    double length, width;

    Rectangle(String color, double length, double width) {
        super(color);
        this.length = length;
        this.width = width;
    }

    @Override
    double area() {
        return length * width;
    }

    @Override
    double perimeter() {
        return 2 * (length + width);
    }
}

public class AbstractDemo {
    public static void main(String[] args) {
        // Shape s = new Shape("Red");  // ERROR! Can't instantiate abstract
        Shape circle = new Circle("Red", 5);
        Shape rect = new Rectangle("Blue", 4, 6);

        circle.displayInfo();
        System.out.println("---");
        rect.displayInfo();
    }
}
```

## Output

```
Color: Red
Area: 78.53981633974483
Perimeter: 31.41592653589793
---
Color: Blue
Area: 24.0
Perimeter: 20.0
```

## Interfaces

### Syntax

```java
interface InterfaceName {
    // Constants (public static final by default)
    int MAX = 100;

    // Abstract method (public abstract by default)
    void method1();

    // Default method (Java 8+)
    default void method2() {
        System.out.println("Default implementation");
    }

    // Static method (Java 8+)
    static void method3() {
        System.out.println("Static interface method");
    }
}

class MyClass implements InterfaceName {
    @Override
    public void method1() {
        System.out.println("Implemented method1");
    }
}
```

### Interface Example

```java
interface Drawable {
    void draw();                   // abstract method
    default void fill() {          // default method (Java 8)
        System.out.println("Filling shape...");
    }
}

interface Resizable {
    void resize(double factor);
}

// Implementing multiple interfaces
class Square implements Drawable, Resizable {
    double side;

    Square(double side) {
        this.side = side;
    }

    @Override
    public void draw() {
        System.out.println("Drawing square with side " + side);
    }

    @Override
    public void resize(double factor) {
        side *= factor;
        System.out.println("Resized to side " + side);
    }
}

public class InterfaceDemo {
    public static void main(String[] args) {
        Square sq = new Square(5);
        sq.draw();      // Drawing square with side 5.0
        sq.fill();      // Filling shape... (default method)
        sq.resize(2);   // Resized to side 10.0

        // Interface reference
        Drawable d = new Square(3);
        d.draw();       // Drawing square with side 3.0
    }
}
```

## Abstract Class vs Interface

| Feature | Abstract Class | Interface |
|---------|---------------|-----------|
| Methods | Abstract + concrete | Abstract (+ default/static from Java 8) |
| Variables | Any type | Only `public static final` |
| Constructor | Can have | Cannot have |
| Multiple inheritance | No | Yes |
| Access modifiers | Any | Methods are `public` by default |
| Keyword | `extends` | `implements` |
| When to use | Common base with shared code | Contract/capability definition |

## Visual Explanation

```
Abstract Class:                    Interface:
┌─────────────────┐               ┌─────────────────────┐
│  abstract Shape  │               │  interface Drawable   │
│  ┌────────────┐  │               │  ┌────────────────┐  │
│  │ color      │  │               │  │ draw()         │  │
│  │ area()     │◄─── must override│  │ fill() default │  │
│  │ display()  │  │               │  └────────────────┘  │
│  └────────────┘  │               └─────────────────────┘
└────────┬────────┘                      ▲         ▲
         │ extends                       │         │
         ▼                       implements    implements
┌────────────────┐               ┌─────────┐ ┌─────────┐
│    Circle       │               │ Square   │ │ Triangle │
│  area() {...}   │               │ draw(){} │ │ draw(){} │
└────────────────┘               └─────────┘ └─────────┘
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Trying to instantiate abstract class | Can't use `new AbstractClass()` |
| Not implementing all abstract methods | Must implement all or declare subclass abstract |
| Interface variables are not constants | All interface variables are `public static final` |
| Using `extends` for interface | Classes use `implements` for interfaces |

## Interview Tips

- Abstract class: partial abstraction; Interface: full abstraction (pre-Java 8)
- Java 8 added `default` and `static` methods to interfaces
- Java 9 added `private` methods to interfaces
- Use abstract class when classes share common code
- Use interface to define a **contract** or **capability**
- An abstract class CAN have a constructor (called via `super()`)
- A class can extend ONE abstract class but implement MANY interfaces
- **Functional interface** = interface with exactly ONE abstract method (for lambdas)

## Quick Revision

> - Abstraction = hiding "how", showing "what"
> - Abstract class: `abstract class`, can have both abstract & concrete methods
> - Interface: `interface`, all methods abstract (default/static from Java 8)
> - Can't instantiate abstract class
> - Class: `extends` abstract class, `implements` interface
> - Interface allows multiple inheritance

---

# 9. Multiple Inheritance using Interfaces

## Concept Explanation

Java doesn't support multiple inheritance with classes (to avoid the **Diamond Problem**), but supports it through interfaces.

```
Diamond Problem with Classes (NOT allowed):
         ┌───────┐
         │   A    │
         └───┬───┘
         ┌───┴───┐
     ┌───┴──┐ ┌──┴───┐
     │   B   │ │   C   │
     └───┬──┘ └──┬───┘
         └───┬───┘
         ┌───┴───┐
         │   D    │  ← Which A's method? Ambiguous!
         └───────┘

Solution with Interfaces:
     ┌──────────┐   ┌──────────┐
     │interface A│   │interface B│
     │  show()   │   │  show()   │
     └────┬─────┘   └─────┬────┘
          │   implements   │
          └───────┬───────┘
          ┌───────┴───────┐
          │    class C     │
          │  show() { }    │  ← C provides its own implementation
          └───────────────┘
```

## Example Code

```java
interface Flyable {
    void fly();
    default void takeOff() {
        System.out.println("Taking off...");
    }
}

interface Swimmable {
    void swim();
    default void takeOff() {  // Same default method name!
        System.out.println("Diving in...");
    }
}

// Implementing multiple interfaces
class Duck implements Flyable, Swimmable {
    @Override
    public void fly() {
        System.out.println("Duck is flying");
    }

    @Override
    public void swim() {
        System.out.println("Duck is swimming");
    }

    // MUST override takeOff() because both interfaces have it
    @Override
    public void takeOff() {
        // Can call specific interface's default method
        Flyable.super.takeOff();     // "Taking off..."
        Swimmable.super.takeOff();   // "Diving in..."
        System.out.println("Duck's own takeoff!");
    }
}

public class MultipleInheritanceDemo {
    public static void main(String[] args) {
        Duck duck = new Duck();
        duck.fly();      // Duck is flying
        duck.swim();     // Duck is swimming
        duck.takeOff();  // Taking off... / Diving in... / Duck's own takeoff!

        // Interface references
        Flyable f = duck;
        f.fly();         // Duck is flying

        Swimmable s = duck;
        s.swim();        // Duck is swimming
    }
}
```

## Interface Inheritance

```java
interface A {
    void methodA();
}

interface B extends A {    // Interface extends Interface
    void methodB();
}

interface C extends A {
    void methodC();
}

interface D extends B, C { // Interface can extend MULTIPLE interfaces
    void methodD();
}

class MyClass implements D {
    @Override
    public void methodA() { System.out.println("A"); }
    @Override
    public void methodB() { System.out.println("B"); }
    @Override
    public void methodC() { System.out.println("C"); }
    @Override
    public void methodD() { System.out.println("D"); }
}
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Not overriding conflicting default methods | Must override if two interfaces have same default method |
| `InterfaceName.super.method()` syntax wrong | Must use `InterfaceName.super.method()` correctly |
| Trying `class A extends B, C` | Not allowed for classes; use interfaces |

## Interview Tips

- Interface can extend **multiple interfaces** using `extends`
- Class can implement **multiple interfaces** using `implements`
- If two interfaces have same default method → class must override
- Use `InterfaceName.super.method()` to call specific default
- Functional interface (`@FunctionalInterface`) = exactly 1 abstract method
- Marker interface = empty interface (e.g., `Serializable`)

## Quick Revision

> - Java solves Diamond Problem using interfaces
> - `class C implements A, B` — multiple interface implementation
> - `interface D extends A, B` — interface extends multiple interfaces
> - Conflicting defaults → must override in implementing class
> - `InterfaceName.super.method()` to pick specific default

---

## 📝 Practice – Abstraction & Interfaces

### Level 1 – Very Simple Checks

| # | Question | Answer |
|---|----------|--------|
| 1 | What is abstraction? | Hiding implementation, showing functionality |
| 2 | Can we create an object of abstract class? | No |
| 3 | What keyword is used for interface? | `implements` |
| 4 | Can an interface have a constructor? | No |
| 5 | What is a default method in interface? | A method with body (Java 8+) |
| 6 | Can a class implement multiple interfaces? | Yes |
| 7 | What is a functional interface? | Interface with exactly 1 abstract method |
| 8 | What is a marker interface? | Interface with no methods (e.g., Serializable) |
| 9 | Can an abstract class have concrete methods? | Yes |
| 10 | Can interfaces have variables? | Yes, but only `public static final` |

### Level 2 – Concept MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Abstract class can have? | A) Constructor B) Abstract methods C) Concrete methods D) All | **D) All** |
| 2 | Interface variables are? | A) private B) public final C) public static final D) Any | **C) public static final** |
| 3 | `abstract void m() {}` — valid? | A) Yes B) No C) Depends D) Warning | **B) No** — abstract methods can't have body |
| 4 | Can abstract class be `final`? | A) Yes B) No C) Depends D) Error | **B) No** — contradictory |
| 5 | Java 8 added what to interfaces? | A) Constructors B) Fields C) default/static methods D) Abstract | **C) default/static methods** |
| 6 | A class can extend how many abstract classes? | A) 0 B) 1 C) Many D) Unlimited | **B) 1** |
| 7 | `interface A extends class B` — valid? | A) Yes B) No C) Sometimes D) With abstract | **B) No** — interface can only extend interface |
| 8 | Can interface methods be `protected`? | A) Yes B) No C) Only default D) Only abstract | **B) No** — interface methods are `public` |
| 9 | Which allows multiple inheritance? | A) Abstract class B) Interface C) Both D) Neither | **B) Interface** |
| 10 | `@FunctionalInterface` allows how many abstract methods? | A) 0 B) 1 C) 2 D) Unlimited | **B) Exactly 1** |

### Level 3 – Deep Understanding MCQs

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Abstract class with no abstract methods? | A) Error B) Valid C) Warning D) Must have at least 1 | **B) Valid** — class just can't be instantiated |
| 2 | Interface extending abstract class? | A) Valid B) Invalid C) Sometimes D) With implements | **B) Invalid** — interface extends interface, not class |
| 3 | `default` method conflict from two interfaces — not overridden? | A) Picks first B) Picks second C) Compile error D) Runtime error | **C) Compile error** |
| 4 | Can abstract method be `static`? | A) Yes B) No C) Depends D) Only in interface | **B) No** — abstract requires override, static can't be overridden |
| 5 | `abstract class A { abstract void m(); } class B extends A { }` — compiles? | A) Yes B) No C) Warning D) Depends | **B) No** — B must implement m() or be declared abstract |

### Level 4 – Quick True/False

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Interface can have `private` methods (Java 9+) | **True** |
| 2 | Abstract class can be instantiated with `new` | **False** |
| 3 | An interface can extend another interface | **True** |
| 4 | `default` keyword makes interface method optional to implement | **True** |
| 5 | Abstract methods can have a body | **False** |

### Level 5 – Small Coding Practice

**Exercise 1:** Create an interface `Payable` with method `calculatePay()`. Implement it in `FullTimeEmployee` and `PartTimeEmployee`.

<details>
<summary>Solution</summary>

```java
interface Payable {
    double calculatePay();
}

class FullTimeEmployee implements Payable {
    double monthlySalary;
    
    FullTimeEmployee(double salary) { this.monthlySalary = salary; }
    
    @Override
    public double calculatePay() { return monthlySalary; }
}

class PartTimeEmployee implements Payable {
    double hourlyRate;
    int hoursWorked;
    
    PartTimeEmployee(double rate, int hours) {
        this.hourlyRate = rate;
        this.hoursWorked = hours;
    }
    
    @Override
    public double calculatePay() { return hourlyRate * hoursWorked; }
}

public class PayDemo {
    public static void main(String[] args) {
        Payable ft = new FullTimeEmployee(5000);
        Payable pt = new PartTimeEmployee(25, 80);
        System.out.println("Full-time: $" + ft.calculatePay()); // 5000
        System.out.println("Part-time: $" + pt.calculatePay()); // 2000
    }
}
```

</details>

---

### 🔥 20 Tricky Interview MCQs – Abstraction & Interfaces

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | Abstract class without abstract methods? | A) Error B) Valid C) Warning D) Invalid | **B) Valid** | Just can't be instantiated |
| 2 | Interface with only `default` methods? | A) Error B) Valid C) Not functional D) Warning | **B) Valid** (Java 8+) |
| 3 | `interface I { int x = 5; }` — x is? | A) Instance variable B) public static final C) Private D) Mutable | **B) public static final** |
| 4 | Can we put `main()` in an interface? | A) No B) Yes (static, Java 8+) C) Error D) Only abstract | **B) Yes** (static method in interface) |
| 5 | `abstract final class A {}` | A) Valid B) Error C) Warning D) Depends | **B) Error** — contradictory |
| 6 | `abstract static void m();` | A) Valid B) Error C) Warning D) Depends | **B) Error** — abstract can't be static |
| 7 | Interface method without body? | A) Must be abstract B) Must be default C) Error D) Any | **A) Implicitly abstract** |
| 8 | Abstract class with all concrete methods? | A) Error B) Valid C) Warning D) Must have abstract | **B) Valid** |
| 9 | Functional interface example from JDK? | A) Runnable B) Comparable C) Both D) Neither | **C) Both** (each has exactly 1 abstract method) |
| 10 | `interface A { void m(); } interface B { void m(); } class C implements A, B {}` | A) Must implement m() once B) Twice C) Error D) Depends | **A) Once** — same signature |
| 11 | Can `enum` implement interface? | A) No B) Yes C) Error D) Only abstract | **B) Yes** |
| 12 | `abstract class A implements I1, I2` ? | A) Error B) Valid C) Warning D) Only one | **B) Valid** |
| 13 | Interface inside class? | A) Error B) Valid (nested) C) Warning D) Abstract only | **B) Valid** |
| 14 | Can interface have `protected` methods? | A) Yes B) No C) Only default D) Error | **B) No** (only public or private in Java 9+) |
| 15 | `class A extends abstract class B` needs to? | A) Nothing B) Implement all abstract C) Only some D) Error | **B) Implement all abstract methods** (or be abstract itself) |
| 16 | Why can't abstract have `final`? | A) No reason B) Final prevents override, abstract requires it C) Error D) Both can exist | **B)** |
| 17 | `Comparable` interface has how many methods? | A) 0 B) 1 C) 2 D) 5 | **B) 1** (compareTo()) |
| 18 | Can we have `static` abstract method? | A) Yes B) No C) Only in interface D) Depends | **B) No** |
| 19 | `abstract private void m();` is? | A) Valid B) Error C) Warning D) Depends | **B) Error** — private can't be abstract (can't be overridden) |
| 20 | Marker interface use? | A) Performance B) Type identification C) Storage D) Security | **B) Type identification** (at runtime) |

---

# 🖼️ Visual Reference Diagrams – OOP in Java

## 📌 Object Memory Anatomy

```
┌─────────────────────────────────────────────────────────────────┐
│               HOW OBJECTS LIVE IN MEMORY                        │
│                                                                  │
│  class Car {                                                     │
│      String brand;   // instance field                          │
│      int speed;      // instance field                          │
│      static int totalCars; // class field                       │
│  }                                                               │
│                                                                  │
│  Stack                     Heap                                  │
│  ┌────────────┐            ┌───────────────────────────────┐    │
│  │ c1 ────────┼───────────►│  Car object @200              │    │
│  │            │            │  brand = "Toyota"             │    │
│  │ c2 ────────┼──────┐     │  speed = 120                  │    │
│  └────────────┘      │     └───────────────────────────────┘    │
│                      │                                           │
│                      │     ┌───────────────────────────────┐    │
│                      └────►│  Car object @300              │    │
│                            │  brand = "Honda"              │    │
│                            │  speed = 100                  │    │
│                            └───────────────────────────────┘    │
│                                                                  │
│  Method Area (Metaspace):                                        │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Car.class bytecode + static int totalCars = 2            │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                  │
│  Key: static fields → shared across ALL objects                 │
│       instance fields → each object has its OWN copy            │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Inheritance Chain & Constructor Call Order

```
┌─────────────────────────────────────────────────────────────────┐
│          INHERITANCE CONSTRUCTOR EXECUTION ORDER                 │
│                                                                  │
│  class Animal {               class Dog extends Animal {        │
│      Animal() {                   Dog() {                       │
│          print("Animal()");           print("Dog()");            │
│      }                            }                             │
│  }                            }                                 │
│                                                                  │
│  new Dog()  — What happens?                                      │
│                                                                  │
│  ┌──────────────────────────────────────────────────────┐       │
│  │  Step 1: Dog() starts                                │       │
│  │     └── implicit super() call first                  │       │
│  │             ↓                                        │       │
│  │  Step 2: Animal() runs → prints "Animal()"           │       │
│  │     └── Animal() finishes                            │       │
│  │             ↓                                        │       │
│  │  Step 3: Dog() continues → prints "Dog()"            │       │
│  └──────────────────────────────────────────────────────┘       │
│                                                                  │
│  Output:                                                         │
│  Animal()                                                        │
│  Dog()                                                           │
│                                                                  │
│  RULE: Parent constructor ALWAYS runs BEFORE child constructor   │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Method Overloading vs Method Overriding

```
┌──────────────────────────────┬──────────────────────────────────┐
│   METHOD OVERLOADING         │   METHOD OVERRIDING              │
├──────────────────────────────┼──────────────────────────────────┤
│  Same class, same name,      │  Parent+Child, same name,        │
│  different parameters        │  same parameters                 │
│                              │                                  │
│  class Calc {                │  class Animal {                  │
│    int add(int a, int b)     │    void speak() {                │
│    double add(double a,b)    │      print("...");               │
│    int add(int a,int b,int c)│    }                             │
│  }                           │  }                               │
│                              │  class Dog extends Animal {      │
│  Resolved at COMPILE time    │    @Override                     │
│  (Static polymorphism)       │    void speak() {                │
│                              │      print("Woof!");             │
│  Return type alone           │    }                             │
│  CANNOT distinguish overloads│  }                               │
│                              │                                  │
│                              │  Resolved at RUNTIME             │
│                              │  (Dynamic polymorphism)          │
│                              │                                  │
│                              │  @Override annotation            │
│                              │  catches errors at compile time  │
└──────────────────────────────┴──────────────────────────────────┘
```

## 📌 Access Modifier Visibility Matrix

```
┌─────────────────────────────────────────────────────────────────┐
│               ACCESS MODIFIER VISIBILITY                         │
│                                                                  │
│  Modifier     Same Class  Same Pkg  Subclass  Other Pkg         │
│  ─────────────────────────────────────────────────────          │
│  private         ✓          ✗         ✗          ✗              │
│  (default)       ✓          ✓         ✗          ✗              │
│  protected       ✓          ✓         ✓          ✗              │
│  public          ✓          ✓         ✓          ✓              │
│                                                                  │
│  Restrictiveness:  private >  default  > protected  > public    │
│  Accessibility:    private < (default) < protected  < public    │
│                                                                  │
│  Memory tip: "Please Don't Punish People"                       │
│              Private Default  Protected Public                   │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Polymorphism – Runtime Type Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│              DYNAMIC METHOD DISPATCH (Runtime)                   │
│                                                                  │
│                    Animal                                        │
│                  ┌─────────┐                                     │
│                  │speak()  │(abstract/overridable)               │
│                  └────┬────┘                                     │
│          ┌────────────┼────────────┐                             │
│          ▼            ▼            ▼                             │
│        Dog          Cat          Bird                            │
│      ┌──────┐    ┌──────┐    ┌──────┐                           │
│      │"Woof"│    │"Meow"│    │"Tweet│                           │
│      └──────┘    └──────┘    └──────┘                           │
│                                                                  │
│  Animal a;                                                       │
│  a = new Dog();  a.speak(); // "Woof"   → Dog's method          │
│  a = new Cat();  a.speak(); // "Meow"   → Cat's method          │
│  a = new Bird(); a.speak(); // "Tweet"  → Bird's method          │
│                                                                  │
│  Same reference (Animal a), different behavior at runtime!      │
│  This is POLYMORPHISM.                                           │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Abstract Class vs Interface Comparison

```
┌──────────────────────────────┬──────────────────────────────────┐
│     ABSTRACT CLASS           │     INTERFACE                    │
├──────────────────────────────┼──────────────────────────────────┤
│  abstract class Shape {      │  interface Drawable {            │
│      int color;              │    // no instance fields         │
│      abstract double area(); │    int MAX = 10; // constant     │
│      void display() {        │    void draw();  // abstract     │
│        print(color);         │    default void info() {         │
│      }                       │      print("Drawable");          │
│  }                           │    }                             │
│                              │  }                               │
├──────────────────────────────┼──────────────────────────────────┤
│  Can have: constructors,     │  Cannot have: constructors,      │
│  instance fields, concrete   │  instance fields (only static    │
│  and abstract methods        │  final), only abstract &         │
│                              │  default methods (Java 8+)       │
├──────────────────────────────┼──────────────────────────────────┤
│  extends (single only)       │  implements (multiple OK)        │
├──────────────────────────────┼──────────────────────────────────┤
│  Use: IS-A with shared state │  Use: CAN-DO contract            │
│  e.g., Vehicle→Car, Animal→Dog│  e.g., Flyable, Serializable    │
└──────────────────────────────┴──────────────────────────────────┘
```

## 📌 `this` and `super` Keyword Reference

```
┌─────────────────────────────────────────────────────────────────┐
│              THIS vs SUPER — At a Glance                        │
│                                                                  │
│  this                            super                          │
│  ──────────────────────────────────────────────────────         │
│  Refers to current object        Refers to parent class         │
│                                                                  │
│  this.field      → current field super.field    → parent field  │
│  this.method()   → current method super.method() → parent method│
│  this()          → call current  super()         → call parent  │
│                    constructor                     constructor   │
│                                                                  │
│  class Car {                                                     │
│    String brand;                                                 │
│    Car(String brand) {        class ElectricCar extends Car {   │
│      this.brand = brand;        int battery;                    │
│    }     │                      ElectricCar(String b, int bat) {│
│          │                        super(b);  // call Car()      │
│     disambiguate               → this.battery = bat;            │
│     field vs param               }                              │
│    }                          }                                 │
│                                                                  │
│  RULE: this() and super() must be FIRST statement in constructor!│
└─────────────────────────────────────────────────────────────────┘
```

## 📌 `final` Keyword Usage Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                   FINAL KEYWORD USES                             │
│                                                                  │
│  1. final VARIABLE → becomes constant (cannot reassign)         │
│     final int MAX = 100;                                         │
│     MAX = 200; // ← COMPILE ERROR                               │
│                                                                  │
│  2. final METHOD → cannot be overridden by subclass             │
│     class Animal {                                               │
│         final void breathe() { ... }  // locked                 │
│     }                                                            │
│     class Dog extends Animal {                                   │
│         void breathe() { ... } // ← COMPILE ERROR               │
│     }                                                            │
│                                                                  │
│  3. final CLASS → cannot be extended (subclassed)               │
│     final class String { ... }  // String is final!             │
│     class MyString extends String { } // ← COMPILE ERROR        │
│                                                                  │
│  final ≠ immutable (final reference can't change, but          │
│  object content CAN change):                                    │
│  final List<Integer> list = new ArrayList<>();                   │
│  list.add(1);  // OK — contents change                          │
│  list = new ArrayList<>(); // ERROR — reference change          │
└─────────────────────────────────────────────────────────────────┘
```

---

# 📚 Extra OOP Examples

## Example: Encapsulation with Full Validation

```java
public class BankAccount {
    private String owner;
    private double balance;
    private String accountNumber;

    // Constructor
    public BankAccount(String owner, double initialBalance) {
        this.owner = owner;
        if (initialBalance < 0)
            throw new IllegalArgumentException("Initial balance cannot be negative");
        this.balance = initialBalance;
        this.accountNumber = "ACC" + (int)(Math.random() * 10000);
    }

    // Getter
    public double getBalance() { return balance; }
    public String getOwner() { return owner; }
    public String getAccountNumber() { return accountNumber; }

    // Setter with validation
    public void deposit(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Deposit must be positive");
        balance += amount;
        System.out.printf("Deposited: %.2f | New balance: %.2f%n", amount, balance);
    }

    public void withdraw(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Amount must be positive");
        if (amount > balance) throw new IllegalArgumentException("Insufficient funds");
        balance -= amount;
        System.out.printf("Withdrawn: %.2f | New balance: %.2f%n", amount, balance);
    }

    @Override
    public String toString() {
        return String.format("Account[%s | Owner=%s | Balance=%.2f]",
                             accountNumber, owner, balance);
    }
}

public class BankDemo {
    public static void main(String[] args) {
        BankAccount acc = new BankAccount("Alice", 1000.0);
        acc.deposit(500.0);
        acc.withdraw(200.0);
        System.out.println(acc);
        // Output:
        // Deposited: 500.00 | New balance: 1500.00
        // Withdrawn: 200.00 | New balance: 1300.00
        // Account[ACC???? | Owner=Alice | Balance=1300.00]
    }
}
```

## Example: Multi-Level Inheritance

```java
class Vehicle {
    String brand;
    int year;
    Vehicle(String brand, int year) {
        this.brand = brand;
        this.year = year;
        System.out.println("Vehicle created: " + brand);
    }
    void startEngine() { System.out.println(brand + ": Engine starts..."); }
}

class Car extends Vehicle {
    int doors;
    Car(String brand, int year, int doors) {
        super(brand, year);    // calls Vehicle constructor
        this.doors = doors;
        System.out.println("Car created with " + doors + " doors");
    }
    void drive() { System.out.println(brand + ": Driving on road"); }
}

class ElectricCar extends Car {
    int batteryKWh;
    ElectricCar(String brand, int year, int doors, int battery) {
        super(brand, year, doors);   // calls Car constructor
        this.batteryKWh = battery;
        System.out.println("ElectricCar battery: " + battery + "kWh");
    }
    @Override
    void startEngine() { System.out.println(brand + ": Silent electric motor starts"); }
    void charge() { System.out.println(brand + ": Charging at station"); }
}

public class InheritanceDemo {
    public static void main(String[] args) {
        ElectricCar tesla = new ElectricCar("Tesla", 2024, 4, 100);
        // Prints (constructor chain):
        // Vehicle created: Tesla
        // Car created with 4 doors
        // ElectricCar battery: 100kWh

        tesla.startEngine(); // Tesla: Silent electric motor starts (overridden)
        tesla.drive();       // Tesla: Driving on road  (from Car)
        tesla.charge();      // Tesla: Charging at station (from ElectricCar)

        // Polymorphic reference
        Vehicle v = new ElectricCar("Rivian", 2024, 4, 135);
        v.startEngine(); // Uses ElectricCar's overridden version!
    }
}
```

## Example: Interface with Multiple Implementation

```java
interface Flyable {
    int MAX_ALTITUDE = 40000; // implicitly public static final
    void fly();
    default void land() { System.out.println("Landing..."); }
}

interface Swimmable {
    void swim();
    default void dive() { System.out.println("Diving..."); }
}

interface Runnable2 { // avoid conflict with java.lang.Runnable
    void run();
}

// Duck can fly, swim AND run — multiple interfaces
class Duck implements Flyable, Swimmable, Runnable2 {
    String name;
    Duck(String name) { this.name = name; }

    @Override public void fly()  { System.out.println(name + " is flying!"); }
    @Override public void swim() { System.out.println(name + " is swimming!"); }
    @Override public void run()  { System.out.println(name + " is running!"); }
}

class Fish implements Swimmable {
    @Override public void swim() { System.out.println("Fish swimming silently"); }
}

public class InterfaceDemo {
    public static void main(String[] args) {
        Duck duck = new Duck("Donald");
        duck.fly();          // Donald is flying!
        duck.swim();         // Donald is swimming!
        duck.run();          // Donald is running!
        duck.land();         // Landing... (default method from Flyable)
        duck.dive();         // Diving...  (default method from Swimmable)
        System.out.println("Max altitude: " + Flyable.MAX_ALTITUDE); // 40000

        // Polymorphism with interface type
        Flyable f = duck;  f.fly();   // works
        Swimmable s = duck; s.swim(); // works

        System.out.println(duck instanceof Flyable);   // true
        System.out.println(duck instanceof Swimmable); // true
    }
}
```

## Example: Abstract Class — Shape Hierarchy

```java
abstract class Shape {
    String color;

    Shape(String color) { this.color = color; }

    // Abstract methods — MUST be overridden
    abstract double area();
    abstract double perimeter();

    // Concrete method — shared behavior
    void printInfo() {
        System.out.printf("Shape: %s | Color: %s | Area: %.2f | Perimeter: %.2f%n",
                          getClass().getSimpleName(), color, area(), perimeter());
    }
}

class Circle extends Shape {
    double radius;
    Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }
    @Override double area()      { return Math.PI * radius * radius; }
    @Override double perimeter() { return 2 * Math.PI * radius; }
}

class Rectangle extends Shape {
    double width, height;
    Rectangle(String color, double w, double h) {
        super(color);
        this.width = w; this.height = h;
    }
    @Override double area()      { return width * height; }
    @Override double perimeter() { return 2 * (width + height); }
}

class Triangle extends Shape {
    double a, b, c;
    Triangle(String color, double a, double b, double c) {
        super(color);
        this.a = a; this.b = b; this.c = c;
    }
    @Override double perimeter() { return a + b + c; }
    @Override double area() {
        double s = perimeter() / 2; // Heron's formula
        return Math.sqrt(s * (s-a) * (s-b) * (s-c));
    }
}

public class ShapeDemo {
    public static void main(String[] args) {
        Shape[] shapes = {
            new Circle("Red", 5),
            new Rectangle("Blue", 4, 6),
            new Triangle("Green", 3, 4, 5)
        };
        for (Shape s : shapes) s.printInfo();
        // Circle | Color: Red | Area: 78.54 | Perimeter: 31.42
        // Rectangle | Color: Blue | Area: 24.00 | Perimeter: 20.00
        // Triangle | Color: Green | Area: 6.00 | Perimeter: 12.00
    }
}
```

---

# 📝 Extended Question Bank – OOP in Java

## ✍️ Fill in the Blanks

| # | Statement | Answer |
|---|-----------|--------|
| 1 | An object is an _______ of a class. | **instance** |
| 2 | `_______` keyword creates a new object in heap. | **new** |
| 3 | The constructor has the same name as the _______ and no return type. | **class** |
| 4 | `this()` calls another constructor of the _______ class. | **same** |
| 5 | `super()` calls the _______ class constructor. | **parent** |
| 6 | `static` methods can be called without creating an _______. | **object** |
| 7 | `_______ class` cannot be instantiated directly. | **abstract** |
| 8 | `final class` cannot be _______. | **extended (subclassed)** |
| 9 | Method _______ is same name, same parameters, in parent-child class. | **overriding** |
| 10 | Method _______ is same name, different parameters, in same class. | **overloading** |
| 11 | All interface fields are implicitly `public static _______`. | **final** |
| 12 | `@Override` annotation is checked at _______ time. | **compile** |
| 13 | `instanceof` checks the _______ type of an object. | **runtime** |
| 14 | Hiding instance variable using same name in subclass is called _______ hiding. | **variable** |
| 15 | The process of binding method call to method body at runtime is called _______. | **dynamic dispatch** |

---

## 🔗 Match the Following – OOP

### Set A – OOP Pillars

| Term | Concept |
|------|---------|
| 1. Encapsulation | A. One interface, many behaviors |
| 2. Inheritance | B. Hide data using private + getters/setters |
| 3. Polymorphism | C. IS-A relationship, code reuse |
| 4. Abstraction | D. Show only essential features, hide implementation |

**Answers:** 1→B, 2→C, 3→A, 4→D

---

### Set B – Keywords

| Keyword | Purpose |
|---------|---------|
| 1. `abstract` | A. Call parent class method or constructor |
| 2. `super` | B. Prevent method override or class extension |
| 3. `final` | C. Class/method must be implemented by subclass |
| 4. `this` | D. Current object reference |
| 5. `static` | E. Belongs to class, not instance |

**Answers:** 1→C, 2→A, 3→B, 4→D, 5→E

---

### Set C – Class Types

| Class/Feature | Description |
|---------------|-------------|
| 1. Abstract class | A. Only constants and abstract/default methods |
| 2. Interface | B. Cannot be instantiated; has abstract+concrete methods |
| 3. Final class | C. Cannot have subclasses |
| 4. Concrete class | D. Normal, fully implemented, can be instantiated |
| 5. Inner class | E. Defined within another class |

**Answers:** 1→B, 2→A, 3→C, 4→D, 5→E

---

## 🐛 Error Spotting – OOP

### Bug 1
```java
abstract class Animal {
    abstract void sound();
}

Animal a = new Animal(); // line 5
```
**Bug:** Cannot instantiate abstract class. `new Animal()` at line 5 is a compile error.

---

### Bug 2
```java
class Parent {
    private int x = 10;
}
class Child extends Parent {
    void show() {
        System.out.println(x);  // accessing private field
    }
}
```
**Bug:** `x` is private in Parent — not accessible in Child. Use `getX()` getter or make it `protected`.

---

### Bug 3
```java
class A {
    A(int x) { System.out.println("A: " + x); }
}
class B extends A {
    B() {
        System.out.println("B");  // super() not called first!
    }
}
```
**Bug:** Class A has no default constructor. Compiler tries to insert `super()` in B but fails. Must call `super(value)` explicitly as first statement.

---

### Bug 4
```java
interface Printable {
    void print();
    int count = 0; // line 3
    count = 5;     // line 4
}
```
**Bug:** `count` is `public static final` in interface — cannot reassign. Line 4 causes compile error.

---

### Bug 5
```java
class Animal {
    void speak() { System.out.println("..."); }
}
class Dog extends Animal {
    @Override
    void speak(String sound) {  // different signature
        System.out.println(sound);
    }
}
```
**Bug:** `@Override` annotation is wrong — method signature differs (has parameter), so this is overloading, not overriding. `@Override` will cause compile error.

---

### Bug 6
```java
class Vehicle {
    static void honk() { System.out.println("Honk!"); }
}
class Car extends Vehicle {
    @Override
    static void honk() { System.out.println("Car Honk!"); }
}
```
**Bug:** Static methods cannot be overridden (they're hidden). `@Override` on static method causes compile error. Remove `@Override`.

---

### Bug 7
```java
final class Base {
    void show() { System.out.println("Base"); }
}
class Derived extends Base {  // extending final class
    void show() { System.out.println("Derived"); }
}
```
**Bug:** `Base` is `final` — cannot be extended. Compile error on `class Derived extends Base`.

---

### Bug 8
```java
class A {
    A() {
        super(); // line 3
        this();  // line 4
    }
}
```
**Bug:** `this()` must be the FIRST statement. Here `super()` is already at line 3 as first statement — `this()` on line 4 causes compile error. Cannot have both.

---

## 🖥️ Output Prediction – OOP

### Q1
```java
class Animal {
    Animal() { System.out.println("Animal"); }
}
class Dog extends Animal {
    Dog() { System.out.println("Dog"); }
}
class GuideDog extends Dog {
    GuideDog() { System.out.println("GuideDog"); }
}
new GuideDog();
```
**Output:**
```
Animal
Dog
GuideDog
```
> Constructor chain: GuideDog → Dog → Animal (parent first)

---

### Q2
```java
class A {
    int x = 10;
    void show() { System.out.println("A.show: " + x); }
}
class B extends A {
    int x = 20;  // hides A's x
    @Override
    void show() { System.out.println("B.show: " + x); }
}
A obj = new B();
obj.show();
System.out.println(obj.x);
```
**Output:**
```
B.show: 20
10
```
> Method: runtime type (B), so overridden method runs.
> Field: compile type (A), so A's x = 10.

---

### Q3
```java
class Counter {
    static int count = 0;
    Counter() { count++; }
}
new Counter(); new Counter(); new Counter();
System.out.println(Counter.count);
```
**Output:** `3`

---

### Q4
```java
class Test {
    int a;
    Test() { a = 1; }
    Test(int x) { this(); a += x; }
}
Test t = new Test(5);
System.out.println(t.a);
```
**Output:** `6`
> `Test(5)` calls `this()` (sets a=1), then `a += 5` → a=6.

---

### Q5
```java
class Parent { void display() { System.out.println("Parent"); } }
class Child extends Parent {
    @Override void display() { System.out.println("Child"); }
    void special() { System.out.println("Special"); }
}
Parent p = new Child();
p.display();
// p.special(); // Would cause compile error
((Child) p).special();
```
**Output:**
```
Child
Special
```

---

### Q6
```java
abstract class Num {
    abstract int square(int n);
    void print(int n) {
        System.out.println(n + "² = " + square(n));
    }
}
Num n = new Num() {
    int square(int x) { return x * x; }
};
n.print(5);
```
**Output:** `5² = 25`
> Anonymous inner class implementing the abstract method.

---

### Q7
```java
static int x = 10;
class Outer {
    int x = 20;
    class Inner {
        int x = 30;
        void show() {
            System.out.println(x);           // 30
            System.out.println(this.x);      // 30
            System.out.println(Outer.this.x);// 20
        }
    }
}
new Outer().new Inner().show();
```
**Output:**
```
30
30
20
```

---

### Q8
```java
interface A { default void greet() { System.out.println("A"); } }
interface B { default void greet() { System.out.println("B"); } }
class C implements A, B {
    @Override
    public void greet() {
        A.super.greet();
        B.super.greet();
        System.out.println("C");
    }
}
new C().greet();
```
**Output:**
```
A
B
C
```

---

## 🧐 Short Answer – OOP

| # | Question | Answer |
|---|----------|--------|
| 1 | Can abstract class have a constructor? | Yes — called when subclass is instantiated via super() |
| 2 | Can we override a private method? | No — private methods are not visible to subclasses |
| 3 | What is the default constructor? | No-arg constructor auto-added by compiler if no constructor exists |
| 4 | Can constructor be `final`? | No — constructors aren't inherited, so `final` is pointless |
| 5 | Difference between `==` and `.equals()` for objects? | `==` compares references; `.equals()` compares content |
| 6 | Why can't we instantiate an interface? | Interface has no implementation (no constructor, no state) |
| 7 | What is covariant return type? | Overriding method can return subtype of original return type |
| 8 | Can `static` method be overridden? | No — it's hidden (method hiding), not overriding |
| 9 | Can interface extend another interface? | Yes — using `extends` (multiple extends allowed) |
| 10 | What is `Object` class? | Root of all Java class hierarchy; every class implicitly extends it |

---

> **🎉 End of File 2 – OOP in Java Complete!**
> 
> Previous: [01_Java_Basics.md](01_Java_Basics.md)
> Next: [03_Advanced_Java.md](03_Advanced_Java.md)
