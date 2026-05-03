# 16. Design Patterns

## Table of Contents
- [16.1 What are Design Patterns?](#161-what-are-design-patterns)
- [16.2 Singleton Pattern](#162-singleton-pattern)
- [16.3 Factory Pattern](#163-factory-pattern)
- [16.4 MVC Pattern](#164-mvc-pattern)
- [16.5 Observer Pattern](#165-observer-pattern)
- [16.6 Practice & Assessment](#166-practice--assessment)

---

## 16.1 What are Design Patterns?

### Definition
**Design patterns** are reusable solutions to commonly occurring problems in software design. They are templates, not code.

### Categories

| Category | Purpose | Examples |
|----------|---------|----------|
| **Creational** | Object creation mechanisms | Singleton, Factory, Builder |
| **Structural** | Object composition/relationships | Adapter, Decorator, Facade |
| **Behavioral** | Object communication | Observer, Strategy, Iterator |

---

## 16.2 Singleton Pattern

### Definition
Ensures a class has only **ONE instance** and provides a global access point to it.

### When to Use
- Database connection pool
- Logger
- Configuration manager
- Thread pool

### Implementation 1: Eager Initialization

```java
class DatabaseConnection {
    // Instance created at class loading (eager)
    private static final DatabaseConnection INSTANCE = new DatabaseConnection();
    
    // Private constructor — no one else can create
    private DatabaseConnection() {
        System.out.println("Database connected!");
    }
    
    // Global access point
    public static DatabaseConnection getInstance() {
        return INSTANCE;
    }
    
    public void query(String sql) {
        System.out.println("Executing: " + sql);
    }
}

// Usage
DatabaseConnection db1 = DatabaseConnection.getInstance();
DatabaseConnection db2 = DatabaseConnection.getInstance();
System.out.println(db1 == db2);  // true — SAME object!

db1.query("SELECT * FROM users");
```

### Implementation 2: Lazy Initialization (Thread-Safe)

```java
class Logger {
    private static volatile Logger instance;
    
    private Logger() {}
    
    // Double-checked locking (thread-safe + performant)
    public static Logger getInstance() {
        if (instance == null) {                    // First check (no lock)
            synchronized (Logger.class) {
                if (instance == null) {            // Second check (with lock)
                    instance = new Logger();
                }
            }
        }
        return instance;
    }
    
    public void log(String message) {
        System.out.println("[LOG] " + message);
    }
}
```

### Implementation 3: Enum Singleton (Best Practice)

```java
enum AppConfig {
    INSTANCE;
    
    private String appName = "MyApp";
    private int port = 8080;
    
    public String getAppName() { return appName; }
    public int getPort() { return port; }
}

// Usage
System.out.println(AppConfig.INSTANCE.getAppName());  // MyApp
System.out.println(AppConfig.INSTANCE.getPort());     // 8080
```

> **Interview Tip:** Enum singleton is considered the best approach — handles serialization and reflection attacks automatically.

---

## 16.3 Factory Pattern

### Definition
Creates objects without exposing creation logic to the client. The client uses a common interface.

### Problem Without Factory

```java
// Client must know ALL concrete classes
Shape shape;
if (type.equals("circle")) {
    shape = new Circle();
} else if (type.equals("rectangle")) {
    shape = new Rectangle();
} else if (type.equals("triangle")) {
    shape = new Triangle();
}
// Adding new shape = modifying client code!
```

### Solution With Factory

```java
// Step 1: Common interface
interface Shape {
    void draw();
    double area();
}

// Step 2: Concrete implementations
class Circle implements Shape {
    private double radius;
    Circle(double radius) { this.radius = radius; }
    
    @Override
    public void draw() { System.out.println("Drawing Circle"); }
    
    @Override
    public double area() { return Math.PI * radius * radius; }
}

class Rectangle implements Shape {
    private double length, width;
    Rectangle(double l, double w) { length = l; width = w; }
    
    @Override
    public void draw() { System.out.println("Drawing Rectangle"); }
    
    @Override
    public double area() { return length * width; }
}

class Triangle implements Shape {
    private double base, height;
    Triangle(double b, double h) { base = b; height = h; }
    
    @Override
    public void draw() { System.out.println("Drawing Triangle"); }
    
    @Override
    public double area() { return 0.5 * base * height; }
}

// Step 3: Factory class
class ShapeFactory {
    public static Shape createShape(String type) {
        switch (type.toLowerCase()) {
            case "circle":    return new Circle(5);
            case "rectangle": return new Rectangle(4, 6);
            case "triangle":  return new Triangle(3, 4);
            default: throw new IllegalArgumentException("Unknown shape: " + type);
        }
    }
}

// Step 4: Client code (clean!)
public class Main {
    public static void main(String[] args) {
        Shape s1 = ShapeFactory.createShape("circle");
        Shape s2 = ShapeFactory.createShape("rectangle");
        
        s1.draw();  // Drawing Circle
        s2.draw();  // Drawing Rectangle
        System.out.println("Area: " + s1.area());  // Area: 78.54
    }
}
```

### Benefits
- Client doesn't know concrete classes
- Adding new shapes = only change factory (not client)
- Loose coupling

---

## 16.4 MVC Pattern

### Definition
**MVC (Model-View-Controller)** separates an application into three interconnected components.

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ┌─────────┐        ┌──────────────┐              │
│   │  USER   │ ─────► │  CONTROLLER  │              │
│   └─────────┘        │  (handles    │              │
│        ▲              │   requests)  │              │
│        │              └──────┬───────┘              │
│        │                     │                      │
│        │              updates│     requests data    │
│        │                     │                      │
│   ┌────┴────┐        ┌──────▼───────┐              │
│   │  VIEW   │ ◄───── │    MODEL     │              │
│   │ (display│  data  │  (data +     │              │
│   │  to user)│        │   logic)     │              │
│   └─────────┘        └──────────────┘              │
│                                                     │
└─────────────────────────────────────────────────────┘
```

| Component | Responsibility | Java Example |
|-----------|---------------|--------------|
| **Model** | Data + business logic | POJO / Entity class |
| **View** | Display data to user | JSP / Thymeleaf / Swing |
| **Controller** | Handle input, coordinate | Servlet / @Controller |

### MVC Example (Student Management)

```java
// MODEL — holds data
class Student {
    private String name;
    private int rollNo;
    private String grade;
    
    public Student(String name, int rollNo, String grade) {
        this.name = name;
        this.rollNo = rollNo;
        this.grade = grade;
    }
    
    // Getters and setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getRollNo() { return rollNo; }
    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }
}

// VIEW — displays data
class StudentView {
    public void displayStudent(Student student) {
        System.out.println("=== Student Details ===");
        System.out.println("Name: " + student.getName());
        System.out.println("Roll: " + student.getRollNo());
        System.out.println("Grade: " + student.getGrade());
    }
}

// CONTROLLER — coordinates Model and View
class StudentController {
    private Student model;
    private StudentView view;
    
    public StudentController(Student model, StudentView view) {
        this.model = model;
        this.view = view;
    }
    
    public void setStudentName(String name) {
        model.setName(name);
    }
    
    public void setStudentGrade(String grade) {
        model.setGrade(grade);
    }
    
    public void updateView() {
        view.displayStudent(model);
    }
}

// USAGE
public class Main {
    public static void main(String[] args) {
        Student model = new Student("Alice", 101, "A");
        StudentView view = new StudentView();
        StudentController controller = new StudentController(model, view);
        
        controller.updateView();
        
        // Update
        controller.setStudentGrade("A+");
        controller.updateView();
    }
}
```

---

## 16.5 Observer Pattern

### Definition
Defines a one-to-many relationship where when one object (subject) changes state, all dependents (observers) are notified automatically.

```java
import java.util.ArrayList;
import java.util.List;

// Observer interface
interface Observer {
    void update(String message);
}

// Subject (publisher)
class NewsChannel {
    private List<Observer> subscribers = new ArrayList<>();
    private String latestNews;
    
    public void subscribe(Observer observer) {
        subscribers.add(observer);
    }
    
    public void unsubscribe(Observer observer) {
        subscribers.remove(observer);
    }
    
    public void publishNews(String news) {
        this.latestNews = news;
        notifyAll(news);
    }
    
    private void notifyAll(String news) {
        for (Observer o : subscribers) {
            o.update(news);
        }
    }
}

// Concrete observers
class EmailSubscriber implements Observer {
    private String name;
    EmailSubscriber(String name) { this.name = name; }
    
    @Override
    public void update(String message) {
        System.out.println("[Email to " + name + "] " + message);
    }
}

class AppSubscriber implements Observer {
    private String name;
    AppSubscriber(String name) { this.name = name; }
    
    @Override
    public void update(String message) {
        System.out.println("[App notification to " + name + "] " + message);
    }
}

// Usage
public class Main {
    public static void main(String[] args) {
        NewsChannel channel = new NewsChannel();
        
        Observer alice = new EmailSubscriber("Alice");
        Observer bob = new AppSubscriber("Bob");
        
        channel.subscribe(alice);
        channel.subscribe(bob);
        
        channel.publishNews("Java 22 Released!");
        // [Email to Alice] Java 22 Released!
        // [App notification to Bob] Java 22 Released!
    }
}
```

---

## 16.6 Practice & Assessment

### MCQs

**Q1.** Singleton pattern ensures:
- A) Multiple instances
- B) Exactly one instance
- C) No instances
- D) Thread creation

**Answer:** B

---

**Q2.** Factory pattern is used to:
- A) Destroy objects
- B) Create objects without exposing creation logic
- C) Sort objects
- D) Clone objects

**Answer:** B

---

**Q3.** In MVC, user input is handled by:
- A) Model
- B) View
- C) Controller
- D) Database

**Answer:** C

---

### Coding Task

**Task:** Implement a thread-safe Singleton `ConfigManager` that loads settings from a map.

```java
class ConfigManager {
    private static volatile ConfigManager instance;
    private final Map<String, String> settings = new HashMap<>();
    
    private ConfigManager() {
        // Load default settings
        settings.put("app.name", "MyApp");
        settings.put("app.version", "1.0");
        settings.put("db.host", "localhost");
    }
    
    public static ConfigManager getInstance() {
        if (instance == null) {
            synchronized (ConfigManager.class) {
                if (instance == null) {
                    instance = new ConfigManager();
                }
            }
        }
        return instance;
    }
    
    public String get(String key) {
        return settings.getOrDefault(key, "NOT_FOUND");
    }
    
    public void set(String key, String value) {
        settings.put(key, value);
    }
}
```

---

> **Next Topic:** [17 - Memory Management](17-memory-management.md)
