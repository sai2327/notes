# 05. Inheritance and Polymorphism

## Table of Contents
- [5.1 Inheritance](#51-inheritance)
- [5.2 Types of Inheritance](#52-types-of-inheritance)
- [5.3 Method Overriding](#53-method-overriding)
- [5.4 super Keyword](#54-super-keyword)
- [5.5 Polymorphism](#55-polymorphism)
- [5.6 Method Overloading vs Overriding](#56-method-overloading-vs-overriding)
- [5.7 Practice & Assessment](#57-practice--assessment)

---

## 5.1 Inheritance

### Definition
**Inheritance** is a mechanism where a new class (child/subclass) acquires properties and methods of an existing class (parent/superclass). Promotes code reusability.

### Syntax

```java
class Animal {
    String name;
    
    void eat() {
        System.out.println(name + " is eating");
    }
    
    void sleep() {
        System.out.println(name + " is sleeping");
    }
}

// Dog inherits from Animal using 'extends'
class Dog extends Animal {
    String breed;
    
    void bark() {
        System.out.println(name + " says Woof!");
    }
}

public class Main {
    public static void main(String[] args) {
        Dog d = new Dog();
        d.name = "Buddy";      // Inherited field
        d.breed = "Labrador";  // Own field
        d.eat();               // Inherited method
        d.sleep();             // Inherited method
        d.bark();              // Own method
    }
}
```

**Output:**
```
Buddy is eating
Buddy is sleeping
Buddy says Woof!
```

### IS-A Relationship
```
Dog IS-A Animal    → Dog extends Animal     ✓
Car IS-A Vehicle   → Car extends Vehicle    ✓
Cat IS-A Dog       → Cat extends Dog        ✗ (wrong hierarchy!)
```

---

## 5.2 Types of Inheritance

```
1. Single                2. Multilevel           3. Hierarchical
   A                        A                        A
   │                        │                       / \
   B                        B                      B   C
                            │
                            C

4. Multiple (NOT supported with classes — use interfaces)
   A    B
    \  /
     C          ← Not allowed in Java (Diamond Problem)
```

### Single Inheritance

```java
class Vehicle {
    void start() { System.out.println("Vehicle started"); }
}
class Car extends Vehicle {
    void drive() { System.out.println("Car driving"); }
}
```

### Multilevel Inheritance

```java
class Animal {
    void eat() { System.out.println("Eating"); }
}
class Dog extends Animal {
    void bark() { System.out.println("Barking"); }
}
class Puppy extends Dog {
    void play() { System.out.println("Playing"); }
}

// Puppy has: eat(), bark(), play()
```

### Hierarchical Inheritance

```java
class Shape {
    void draw() { System.out.println("Drawing shape"); }
}
class Circle extends Shape {
    void radius() { System.out.println("Circle radius"); }
}
class Rectangle extends Shape {
    void sides() { System.out.println("Rectangle sides"); }
}
```

---

## 5.3 Method Overriding

### Definition
**Method Overriding** occurs when a subclass provides its own implementation of a method that is already defined in the parent class.

```java
class Animal {
    void sound() {
        System.out.println("Animal makes a sound");
    }
}

class Dog extends Animal {
    @Override  // Annotation — helps compiler verify override
    void sound() {
        System.out.println("Dog barks");
    }
}

class Cat extends Animal {
    @Override
    void sound() {
        System.out.println("Cat meows");
    }
}

public class Main {
    public static void main(String[] args) {
        Animal a = new Animal();
        Dog d = new Dog();
        Cat c = new Cat();
        
        a.sound();  // Animal makes a sound
        d.sound();  // Dog barks
        c.sound();  // Cat meows
    }
}
```

### Rules for Overriding
1. Method name must be the same
2. Parameters must be the same
3. Return type must be the same (or covariant)
4. Access modifier cannot be more restrictive
5. Cannot override `final`, `static`, or `private` methods

---

## 5.4 super Keyword

### Purpose
`super` refers to the parent class — used to call parent constructor or methods.

```java
class Animal {
    String name;
    
    Animal(String name) {
        this.name = name;
        System.out.println("Animal constructor: " + name);
    }
    
    void sound() {
        System.out.println("Generic animal sound");
    }
}

class Dog extends Animal {
    String breed;
    
    Dog(String name, String breed) {
        super(name);  // Call parent constructor (MUST be first line)
        this.breed = breed;
        System.out.println("Dog constructor: " + breed);
    }
    
    @Override
    void sound() {
        super.sound();  // Call parent's version
        System.out.println("Dog barks!");  // Then add own behavior
    }
}

public class Main {
    public static void main(String[] args) {
        Dog d = new Dog("Rex", "German Shepherd");
        d.sound();
    }
}
```

**Output:**
```
Animal constructor: Rex
Dog constructor: German Shepherd
Generic animal sound
Dog barks!
```

### Constructor Chain
When creating a subclass object, constructors execute from **top to bottom** (parent first):

```
Object constructor → Animal constructor → Dog constructor
```

---

## 5.5 Polymorphism

### Definition
**Polymorphism** = "many forms" — same method/reference behaves differently depending on context.

### Two Types

| Type | Also Called | When Decided | How |
|------|------------|:------------:|-----|
| **Compile-time** | Static / Early binding | Compile time | Method Overloading |
| **Runtime** | Dynamic / Late binding | Runtime | Method Overriding |

### Compile-Time Polymorphism (Overloading)

```java
class Calculator {
    int add(int a, int b) {
        return a + b;
    }
    
    double add(double a, double b) {
        return a + b;
    }
    
    int add(int a, int b, int c) {
        return a + b + c;
    }
}

Calculator calc = new Calculator();
calc.add(5, 3);         // calls int version → 8
calc.add(2.5, 3.5);    // calls double version → 6.0
calc.add(1, 2, 3);     // calls three-param version → 6
```

### Runtime Polymorphism (Upcasting + Overriding)

```java
class Shape {
    void area() {
        System.out.println("Calculating area...");
    }
}

class Circle extends Shape {
    double radius;
    Circle(double r) { this.radius = r; }
    
    @Override
    void area() {
        System.out.println("Circle area: " + (3.14159 * radius * radius));
    }
}

class Rectangle extends Shape {
    double length, width;
    Rectangle(double l, double w) { length = l; width = w; }
    
    @Override
    void area() {
        System.out.println("Rectangle area: " + (length * width));
    }
}

public class Main {
    public static void main(String[] args) {
        // Parent reference → Child object (Upcasting)
        Shape s1 = new Circle(5);
        Shape s2 = new Rectangle(4, 6);
        
        s1.area();  // Circle area: 78.53975
        s2.area();  // Rectangle area: 24.0
        
        // JVM decides at RUNTIME which method to call
        // Based on actual object type, not reference type
        
        // Array of shapes (polymorphic array)
        Shape[] shapes = {new Circle(3), new Rectangle(2, 5), new Circle(7)};
        for (Shape s : shapes) {
            s.area();  // Each calls its own version
        }
    }
}
```

### Why Polymorphism Matters

```java
// Without polymorphism: need separate methods
void drawCircle(Circle c) { ... }
void drawRectangle(Rectangle r) { ... }
void drawTriangle(Triangle t) { ... }

// With polymorphism: ONE method handles all
void drawShape(Shape s) {
    s.draw();  // Calls correct draw() based on actual type
}
```

---

## 5.6 Method Overloading vs Overriding

| Feature | Overloading | Overriding |
|---------|-------------|------------|
| Definition | Same name, different parameters | Same name, same parameters in subclass |
| Where | Same class | Parent and child class |
| Parameters | Must be different | Must be same |
| Return type | Can be different | Must be same (or covariant) |
| Binding | Compile-time | Runtime |
| `static` methods | Can overload | Cannot override (hides) |
| Access modifier | No restriction | Cannot be more restrictive |

```java
// OVERLOADING (same class, different params)
class Printer {
    void print(int x) { System.out.println(x); }
    void print(String s) { System.out.println(s); }
    void print(int x, int y) { System.out.println(x + ", " + y); }
}

// OVERRIDING (parent-child, same signature)
class Parent {
    void greet() { System.out.println("Hello from Parent"); }
}
class Child extends Parent {
    @Override
    void greet() { System.out.println("Hello from Child"); }
}
```

---

## 5.7 Practice & Assessment

### MCQs

**Q1.** Java supports multiple inheritance through:
- A) Classes
- B) Interfaces
- C) Both
- D) Neither

**Answer:** B — Java doesn't allow multiple class inheritance (diamond problem), but allows multiple interface implementation.

---

**Q2.** What is the output?
```java
class A { void show() { System.out.println("A"); } }
class B extends A { void show() { System.out.println("B"); } }
A obj = new B();
obj.show();
```
- A) A
- B) B
- C) Error
- D) AB

**Answer:** B — Runtime polymorphism: actual object is B, so B's show() is called.

---

**Q3.** `super()` must be:
- A) Last statement in constructor
- B) First statement in constructor
- C) Called in main method
- D) Used with static methods

**Answer:** B — `super()` must be the first statement in a constructor.

---

### Output Prediction

```java
class Parent {
    Parent() { System.out.println("Parent"); }
}
class Child extends Parent {
    Child() { System.out.println("Child"); }
}
public class Main {
    public static void main(String[] args) {
        Child c = new Child();
    }
}
```

**Output:**
```
Parent
Child
```
> Parent constructor runs first (implicit `super()` call), then child constructor.

---

### Coding Task

**Task:** Create a class hierarchy:
- `Vehicle` (fields: brand, speed; method: describe())
- `Car extends Vehicle` (field: doors; override describe())
- `ElectricCar extends Car` (field: battery; override describe())

```java
class Vehicle {
    String brand;
    int speed;
    
    Vehicle(String brand, int speed) {
        this.brand = brand;
        this.speed = speed;
    }
    
    void describe() {
        System.out.println("Vehicle: " + brand + ", Speed: " + speed);
    }
}

class Car extends Vehicle {
    int doors;
    
    Car(String brand, int speed, int doors) {
        super(brand, speed);
        this.doors = doors;
    }
    
    @Override
    void describe() {
        System.out.println("Car: " + brand + ", " + doors + " doors, " + speed + " km/h");
    }
}

class ElectricCar extends Car {
    int battery;
    
    ElectricCar(String brand, int speed, int doors, int battery) {
        super(brand, speed, doors);
        this.battery = battery;
    }
    
    @Override
    void describe() {
        System.out.println("EV: " + brand + ", " + battery + " kWh battery, " + speed + " km/h");
    }
}
```

---

> **Next Topic:** [06 - Abstraction & Interfaces](06-oop-abstraction-interfaces.md)
