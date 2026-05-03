# 18. Java Cheat Sheet — Quick Reference

---

## Data Types

| Type | Size | Range | Default |
|------|------|-------|---------|
| `byte` | 1B | -128 to 127 | 0 |
| `short` | 2B | -32K to 32K | 0 |
| `int` | 4B | -2.1B to 2.1B | 0 |
| `long` | 8B | very large | 0L |
| `float` | 4B | ~7 digits | 0.0f |
| `double` | 8B | ~15 digits | 0.0 |
| `char` | 2B | Unicode | '\u0000' |
| `boolean` | 1bit | true/false | false |

---

## OOP Summary

| Concept | Definition | Keyword |
|---------|-----------|---------|
| **Encapsulation** | Hide data, expose via getters/setters | `private` + public methods |
| **Inheritance** | Child acquires parent properties | `extends` |
| **Polymorphism** | Same method, different behavior | Overloading / Overriding |
| **Abstraction** | Hide implementation, show interface | `abstract` / `interface` |

### Access Modifiers

| Modifier | Class | Package | Subclass | World |
|----------|:-----:|:-------:|:--------:|:-----:|
| private | ✅ | ❌ | ❌ | ❌ |
| default | ✅ | ✅ | ❌ | ❌ |
| protected | ✅ | ✅ | ✅ | ❌ |
| public | ✅ | ✅ | ✅ | ✅ |

---

## String Methods Quick Reference

```java
str.length()              // Size
str.charAt(i)             // Char at index
str.substring(s, e)       // Extract part
str.toLowerCase()         // Lowercase
str.toUpperCase()         // Uppercase
str.trim()                // Remove spaces
str.contains("x")         // Check substring
str.indexOf("x")          // Find position
str.replace("a", "b")     // Replace
str.split(",")            // Split to array
str.equals(other)         // Compare content
str.equalsIgnoreCase(o)   // Compare ignore case
str.startsWith("x")       // Prefix check
str.isEmpty()             // Is empty?
String.valueOf(num)       // Convert to String
Integer.parseInt("123")   // String to int
```

---

## Collections Quick Reference

| Collection | Duplicates | Ordered | Sorted | Thread-Safe |
|-----------|:---------:|:-------:|:------:|:-----------:|
| ArrayList | ✅ | ✅ | ❌ | ❌ |
| LinkedList | ✅ | ✅ | ❌ | ❌ |
| HashSet | ❌ | ❌ | ❌ | ❌ |
| TreeSet | ❌ | ✅ | ✅ | ❌ |
| LinkedHashSet | ❌ | ✅(insert) | ❌ | ❌ |
| HashMap | Keys:❌ | ❌ | ❌ | ❌ |
| TreeMap | Keys:❌ | ✅ | ✅(key) | ❌ |
| LinkedHashMap | Keys:❌ | ✅(insert) | ❌ | ❌ |
| Vector | ✅ | ✅ | ❌ | ✅ |
| ConcurrentHashMap | Keys:❌ | ❌ | ❌ | ✅ |

### Common Operations

```java
// ArrayList
list.add(e);  list.get(i);  list.remove(i);  list.size();
list.contains(e);  list.indexOf(e);  Collections.sort(list);

// HashMap
map.put(k, v);  map.get(k);  map.remove(k);  map.size();
map.containsKey(k);  map.keySet();  map.entrySet();
map.getOrDefault(k, def);  map.forEach((k,v) -> ...);

// HashSet
set.add(e);  set.remove(e);  set.contains(e);  set.size();
```

---

## Exception Handling

```java
try {
    // risky code
} catch (SpecificException e) {
    // handle
} catch (Exception e) {
    // catch-all (last)
} finally {
    // always runs (cleanup)
}

throw new ExceptionType("message");     // throw manually
void method() throws IOException { }    // declare in signature
```

| Checked | Unchecked |
|---------|-----------|
| IOException | NullPointerException |
| SQLException | ArrayIndexOutOfBoundsException |
| FileNotFoundException | ArithmeticException |
| ClassNotFoundException | NumberFormatException |

---

## Multithreading

```java
// Create thread
Thread t = new Thread(() -> { /* task */ });
t.start();

// Key methods
Thread.sleep(ms);     // Pause
t.join();             // Wait for t to finish
synchronized(obj) { } // Mutual exclusion
wait(); notify();     // Inter-thread communication
```

---

## Streams API

```java
list.stream()
    .filter(x -> condition)       // Keep matching
    .map(x -> transform)          // Transform
    .sorted()                     // Sort
    .distinct()                   // Remove duplicates
    .limit(n)                     // First n
    .forEach(System.out::println) // Terminal: print
    .collect(Collectors.toList()) // Terminal: to list
    .count()                      // Terminal: count
    .reduce(0, Integer::sum)      // Terminal: aggregate
    .findFirst()                  // Terminal: first match
    .anyMatch(x -> cond)          // Terminal: boolean
```

---

## Lambda & Functional Interfaces

```java
// Lambda syntax
(params) -> expression
(params) -> { statements; }

// Built-in interfaces
Predicate<T>    test(T) → boolean     x -> x > 5
Function<T,R>   apply(T) → R         s -> s.length()
Consumer<T>     accept(T) → void     x -> System.out.println(x)
Supplier<T>     get() → T            () -> new ArrayList<>()
```

---

## JDBC Template

```java
String url = "jdbc:mysql://localhost:3306/db";
try (Connection conn = DriverManager.getConnection(url, user, pass);
     PreparedStatement ps = conn.prepareStatement("SELECT * FROM t WHERE id=?")) {
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();
    while (rs.next()) {
        rs.getString("name");
        rs.getInt("age");
    }
}
```

---

## Spring Boot Annotations

| Annotation | Purpose |
|------------|---------|
| `@SpringBootApplication` | Main class |
| `@RestController` | REST API controller |
| `@GetMapping("/path")` | Handle GET |
| `@PostMapping("/path")` | Handle POST |
| `@PutMapping("/path")` | Handle PUT |
| `@DeleteMapping("/path")` | Handle DELETE |
| `@PathVariable` | URL path variable |
| `@RequestParam` | Query parameter |
| `@RequestBody` | JSON body → object |
| `@Service` | Business logic layer |
| `@Repository` | Data access layer |
| `@Autowired` | Inject dependency |
| `@Entity` | JPA entity |

---

## Design Patterns

| Pattern | Type | Key Idea |
|---------|------|----------|
| **Singleton** | Creational | One instance only |
| **Factory** | Creational | Create without exposing logic |
| **Observer** | Behavioral | Notify dependents on change |
| **MVC** | Architectural | Separate Model-View-Controller |
| **Builder** | Creational | Step-by-step object construction |
| **Strategy** | Behavioral | Swap algorithms at runtime |

---

## Memory

| Area | Stores | Error |
|------|--------|-------|
| Stack | Local vars, method frames | StackOverflowError |
| Heap | Objects | OutOfMemoryError |
| String Pool | String literals | — |

---

## Common Syntax Shortcuts

```java
// Ternary
result = (condition) ? valueIfTrue : valueIfFalse;

// var (Java 10+)
var list = new ArrayList<String>();

// Text block (Java 15+)
String json = """
    {
        "name": "Alice",
        "age": 20
    }
    """;

// Record (Java 16+)
record Point(int x, int y) {}
Point p = new Point(5, 10);
p.x();  // 5

// Sealed classes (Java 17+)
sealed interface Shape permits Circle, Rectangle {}

// Pattern matching instanceof (Java 16+)
if (obj instanceof String s) {
    System.out.println(s.length());  // No cast needed!
}
```

---

> **Next Topic:** [19 - Interview Questions](19-interview-questions.md)
