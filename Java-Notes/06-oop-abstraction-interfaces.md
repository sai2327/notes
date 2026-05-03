# 06. Abstraction and Interfaces

## Table of Contents
- [6.1 Abstraction](#61-abstraction)
- [6.2 Abstract Classes](#62-abstract-classes)
- [6.3 Interfaces](#63-interfaces)
- [6.4 Abstract Class vs Interface](#64-abstract-class-vs-interface)
- [6.5 Multiple Inheritance with Interfaces](#65-multiple-inheritance-with-interfaces)
- [6.6 Practice & Assessment](#66-practice--assessment)

---

## 6.1 Abstraction

### Definition
**Abstraction** is the process of hiding implementation details and showing only the functionality to the user. You know WHAT it does, not HOW it does it.

### Real-World Example
```
ATM Machine:
  You know: Insert card → Enter PIN → Get money
  You don't know: How it connects to bank servers, validates, dispenses

TV Remote:
  You know: Press button → Change channel
  You don't know: Infrared signals, frequency encoding
```

### How to Achieve Abstraction in Java
1. **Abstract classes** (0-100% abstraction)
2. **Interfaces** (100% abstraction)

---

## 6.2 Abstract Classes

### Definition
An **abstract class** is a class that cannot be instantiated and may contain abstract methods (no body) that must be implemented by subclasses.

### Syntax

```java
abstract class Shape {
    String color;
    
    // Constructor
    Shape(String color) {
        this.color = color;
    }
    
    // Abstract method — NO body (subclass MUST implement)
    abstract double area();
    abstract double perimeter();
    
    // Concrete method — HAS body (inherited as-is)
    void display() {
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

public class Main {
    public static void main(String[] args) {
        // Shape s = new Shape("Red");  ← ERROR! Cannot instantiate abstract class
        
        Shape circle = new Circle("Red", 5);
        Shape rect = new Rectangle("Blue", 4, 6);
        
        circle.display();
        System.out.println("---");
        rect.display();
    }
}
```

**Output:**
```
Color: Red
Area: 78.53981633974483
Perimeter: 31.41592653589793
---
Color: Blue
Area: 24.0
Perimeter: 20.0
```

### Rules for Abstract Classes
1. Declared with `abstract` keyword
2. Cannot be instantiated (`new AbstractClass()` → Error)
3. Can have abstract AND concrete methods
4. Can have constructors (called via `super()`)
5. Can have fields (instance variables)
6. Subclass MUST implement all abstract methods (or be abstract itself)

---

## 6.3 Interfaces

### Definition
An **interface** is a completely abstract type that defines a contract — what methods a class must implement. Think of it as a "capability contract."

### Syntax (Pre-Java 8)

```java
interface Drawable {
    // All methods are implicitly public abstract
    void draw();
    void resize(double factor);
    
    // All fields are implicitly public static final (constants)
    String TYPE = "2D";  // constant
}

interface Printable {
    void print();
}

// Class implements interface (can implement multiple!)
class Circle implements Drawable, Printable {
    double radius;
    
    Circle(double radius) {
        this.radius = radius;
    }
    
    @Override
    public void draw() {
        System.out.println("Drawing circle with radius " + radius);
    }
    
    @Override
    public void resize(double factor) {
        radius *= factor;
        System.out.println("Resized to radius " + radius);
    }
    
    @Override
    public void print() {
        System.out.println("Printing circle...");
    }
}

public class Main {
    public static void main(String[] args) {
        Circle c = new Circle(5);
        c.draw();
        c.resize(2);
        c.print();
        
        // Interface as reference type
        Drawable d = new Circle(3);
        d.draw();      // OK
        // d.print();  ← ERROR: Drawable doesn't have print()
    }
}
```

### Java 8+ Interface Features

```java
interface Vehicle {
    // Abstract method (must implement)
    void start();
    
    // Default method (has body, optional to override)
    default void horn() {
        System.out.println("Beep beep!");
    }
    
    // Static method (called on interface, not object)
    static void info() {
        System.out.println("Vehicle interface v1.0");
    }
}

class Car implements Vehicle {
    @Override
    public void start() {
        System.out.println("Car started with key");
    }
    
    // horn() is inherited with default implementation
    // Can override if needed
}

public class Main {
    public static void main(String[] args) {
        Car c = new Car();
        c.start();           // Car started with key
        c.horn();            // Beep beep! (default)
        Vehicle.info();      // Vehicle interface v1.0 (static)
    }
}
```

---

## 6.4 Abstract Class vs Interface

| Feature | Abstract Class | Interface |
|---------|---------------|-----------|
| Keyword | `abstract class` | `interface` |
| Methods | Abstract + concrete | Abstract (+ default/static since Java 8) |
| Fields | Any type | Only `public static final` (constants) |
| Constructor | Yes | No |
| Inheritance | `extends` (single) | `implements` (multiple) |
| Access modifiers | Any | Methods are `public` by default |
| When to use | Shared code + IS-A relationship | Capability/contract (CAN-DO) |

### When to Use What?

```
Use ABSTRACT CLASS when:
  - Subclasses share common code
  - You need constructors or instance fields
  - IS-A relationship: "Dog IS-A Animal"
  
Use INTERFACE when:
  - Multiple unrelated classes need same capability
  - You need multiple inheritance
  - CAN-DO relationship: "Dog CAN Swim, CAN Fetch"
```

### Example: Both Together

```java
abstract class Animal {
    String name;
    Animal(String name) { this.name = name; }
    abstract void sound();
    void breathe() { System.out.println(name + " is breathing"); }
}

interface Swimmable {
    void swim();
}

interface Flyable {
    void fly();
}

class Duck extends Animal implements Swimmable, Flyable {
    Duck(String name) { super(name); }
    
    @Override
    void sound() { System.out.println("Quack!"); }
    
    @Override
    public void swim() { System.out.println(name + " is swimming"); }
    
    @Override
    public void fly() { System.out.println(name + " is flying"); }
}

class Dog extends Animal implements Swimmable {
    Dog(String name) { super(name); }
    
    @Override
    void sound() { System.out.println("Woof!"); }
    
    @Override
    public void swim() { System.out.println(name + " is swimming"); }
}
```

---

## 6.5 Multiple Inheritance with Interfaces

```java
interface A {
    default void hello() { System.out.println("Hello from A"); }
}

interface B {
    default void hello() { System.out.println("Hello from B"); }
}

// Class must resolve conflict
class C implements A, B {
    @Override
    public void hello() {
        A.super.hello();  // Choose A's version
        // or: B.super.hello();
        // or: provide own implementation
    }
}
```

### Functional Interface (Java 8+)

```java
// Interface with exactly ONE abstract method
@FunctionalInterface
interface MathOperation {
    int operate(int a, int b);
}

public class Main {
    public static void main(String[] args) {
        // Lambda expression
        MathOperation add = (a, b) -> a + b;
        MathOperation multiply = (a, b) -> a * b;
        
        System.out.println(add.operate(5, 3));      // 8
        System.out.println(multiply.operate(5, 3)); // 15
    }
}
```

---

## 6.6 Practice & Assessment

### MCQs

**Q1.** Which can be instantiated?
- A) Abstract class
- B) Interface
- C) Concrete class
- D) None of the above

**Answer:** C — Only concrete (non-abstract) classes can be instantiated.

---

**Q2.** An interface can contain (Java 8+):
- A) Only abstract methods
- B) Abstract + default + static methods
- C) Constructors
- D) Instance variables

**Answer:** B

---

**Q3.** A class can implement:
- A) Only one interface
- B) Multiple interfaces
- C) Only abstract classes
- D) None

**Answer:** B — `class X implements A, B, C { ... }`

---

### Output Prediction

```java
interface I {
    default void show() { System.out.println("Interface"); }
}
class A implements I {
    public void show() { System.out.println("Class A"); }
}
public class Main {
    public static void main(String[] args) {
        I obj = new A();
        obj.show();
    }
}
```

**Output:** `Class A` — The class override takes priority over default method.

---

### Coding Task

**Task:** Design a payment system:
- Interface `Payable` with method `pay(double amount)`
- Class `CreditCard` implements Payable
- Class `UPI` implements Payable
- Write a method that accepts `Payable` and processes payment

```java
interface Payable {
    void pay(double amount);
    String getMethod();
}

class CreditCard implements Payable {
    private String cardNumber;
    
    CreditCard(String cardNumber) {
        this.cardNumber = cardNumber;
    }
    
    @Override
    public void pay(double amount) {
        System.out.println("Paid ₹" + amount + " via Credit Card ending " 
                          + cardNumber.substring(cardNumber.length() - 4));
    }
    
    @Override
    public String getMethod() { return "Credit Card"; }
}

class UPI implements Payable {
    private String upiId;
    
    UPI(String upiId) { this.upiId = upiId; }
    
    @Override
    public void pay(double amount) {
        System.out.println("Paid ₹" + amount + " via UPI: " + upiId);
    }
    
    @Override
    public String getMethod() { return "UPI"; }
}

// Usage — polymorphism with interface
public class Main {
    static void processPayment(Payable payable, double amount) {
        System.out.println("Processing via " + payable.getMethod());
        payable.pay(amount);
    }
    
    public static void main(String[] args) {
        processPayment(new CreditCard("4111222233334444"), 999.0);
        processPayment(new UPI("alice@upi"), 500.0);
    }
}
```

---

> **Next Topic:** [07 - Exception Handling](07-exception-handling.md)
