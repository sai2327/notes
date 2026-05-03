# 19. Interview Questions — Java Complete

## Core Java

---

### Q1. What is the difference between `==` and `.equals()`?

**Answer:**
- `==` compares **references** (memory addresses) — are they the same object?
- `.equals()` compares **content** (overridden in String, Integer, etc.)

```java
String s1 = "Hello";
String s2 = new String("Hello");

System.out.println(s1 == s2);      // false (different objects)
System.out.println(s1.equals(s2)); // true  (same content)
```

> **Rule:** Always use `.equals()` for object comparison. Use `==` only for primitives or checking `null`.

---

### Q2. Why is Java platform independent?

**Answer:** Java source code is compiled to **bytecode** (.class files), not machine code. Bytecode runs on the **JVM**, which is available for every platform. The JVM translates bytecode to native machine code at runtime. So "Write Once, Run Anywhere."

---

### Q3. What is the difference between `String`, `StringBuilder`, and `StringBuffer`?

| Feature | String | StringBuilder | StringBuffer |
|---------|--------|---------------|--------------|
| Mutable? | No (immutable) | Yes | Yes |
| Thread-safe? | Yes (immutable) | No | Yes (synchronized) |
| Performance | Slowest for modifications | Fastest | Moderate |
| When to use | Few changes | Single-threaded modifications | Multi-threaded modifications |

---

### Q4. Explain `final`, `finally`, and `finalize`.

| Keyword | Purpose |
|---------|---------|
| `final` | Variable: constant. Method: can't override. Class: can't extend. |
| `finally` | Block that always executes after try-catch (cleanup). |
| `finalize()` | Method called before GC collects object (deprecated). |

---

### Q5. What is the difference between Abstract Class and Interface?

| Feature | Abstract Class | Interface |
|---------|---------------|-----------|
| Methods | Abstract + concrete | Abstract + default (Java 8+) |
| Variables | Any type | Only public static final |
| Constructor | Yes | No |
| Inheritance | Single (extends) | Multiple (implements) |
| When | IS-A + shared code | CAN-DO capability |

---

### Q6. What is method overloading vs overriding?

| | Overloading | Overriding |
|---|---|---|
| Where | Same class | Parent → Child |
| Parameters | Must differ | Must be same |
| Return type | Can differ | Must be same/covariant |
| Binding | Compile-time | Runtime |
| Keyword | — | `@Override` |

---

### Q7. Explain the `static` keyword.

- **Static variable:** Shared by all objects of the class (one copy)
- **Static method:** Can be called without creating object (`ClassName.method()`)
- **Static block:** Executes once when class is loaded
- **Static class:** Only nested classes can be static
- **Cannot access:** Instance variables/methods directly

---

### Q8. What is the difference between `HashMap` and `HashTable`?

| Feature | HashMap | HashTable |
|---------|---------|-----------|
| Thread-safe | No | Yes (synchronized) |
| Null keys | 1 allowed | Not allowed |
| Null values | Multiple allowed | Not allowed |
| Performance | Faster | Slower (synchronization overhead) |
| Iterator | Fail-fast | Enumerator |

> **Modern alternative:** Use `ConcurrentHashMap` instead of HashTable.

---

### Q9. What is the difference between `ArrayList` and `LinkedList`?

| Feature | ArrayList | LinkedList |
|---------|-----------|------------|
| Structure | Dynamic array | Doubly linked list |
| Random access | O(1) | O(n) |
| Insert/Delete (middle) | O(n) | O(1) at node |
| Memory | Less | More (pointers) |
| Best for | Read-heavy | Insert/delete-heavy |

---

### Q10. What are checked vs unchecked exceptions?

- **Checked:** Must be handled at compile time (IOException, SQLException). Caused by external factors.
- **Unchecked (Runtime):** Optional to handle (NullPointerException, ArithmeticException). Caused by programming errors.
- **Error:** Serious JVM issues (StackOverflowError, OutOfMemoryError). Don't catch these.

---

### Q11. Explain garbage collection.

**Answer:** GC automatically reclaims memory from objects no longer referenced. Objects become eligible when:
1. Reference set to null
2. Reference reassigned
3. Object created in method that returned
4. Island of isolation

JVM uses generational GC: Young Gen (Eden + Survivor) → Old Gen. Minor GC cleans Young, Major GC cleans Old.

---

### Q12. What is the difference between `throw` and `throws`?

| `throw` | `throws` |
|---------|----------|
| Used in method body | Used in method declaration |
| Throws single exception | Declares possible exceptions |
| `throw new Exception()` | `void m() throws IOException` |

---

### Q13. What is multithreading? How do you create threads?

**Answer:** Running multiple threads concurrently within one program.

Two ways to create:
1. `class MyThread extends Thread { void run() {...} }` — limits inheritance
2. `class MyTask implements Runnable { void run() {...} }` — preferred (can extend other class)

---

### Q14. What is synchronization? Why is it needed?

**Answer:** Synchronization ensures only ONE thread accesses a critical section at a time. Without it, **race conditions** occur — multiple threads modifying shared data simultaneously leads to inconsistent results.

```java
synchronized void increment() { count++; }  // Thread-safe
```

---

### Q15. Explain the `this` and `super` keywords.

| `this` | `super` |
|--------|---------|
| Current object reference | Parent class reference |
| `this.field` = current object's field | `super.field` = parent's field |
| `this()` = call current class constructor | `super()` = call parent constructor |
| Resolves name conflict | Access overridden methods |

---

## Collections & Advanced

---

### Q16. What is the difference between `Comparable` and `Comparator`?

| Comparable | Comparator |
|-----------|------------|
| `java.lang` | `java.util` |
| `compareTo(T)` | `compare(T, T)` |
| Natural ordering (inside class) | Custom ordering (outside) |
| Single sorting logic | Multiple sorting logics |

---

### Q17. What are Generics? Why use them?

**Answer:** Generics enable type-safe code by parameterizing types. Benefits:
- Compile-time type checking (no ClassCastException)
- No explicit casting needed
- Code reusability (one class/method works for any type)

```java
List<String> list = new ArrayList<>();  // Only Strings allowed
```

---

### Q18. What is the Stream API?

**Answer:** A functional-style API for processing sequences of elements. Provides filter, map, reduce, collect operations. Benefits: concise code, can leverage parallel processing.

```java
list.stream().filter(x -> x > 5).map(x -> x * 2).collect(Collectors.toList());
```

---

### Q19. What is a functional interface?

**Answer:** An interface with exactly one abstract method. Can be used with lambda expressions. Examples: `Runnable`, `Comparator`, `Predicate`, `Function`. Annotated with `@FunctionalInterface`.

---

### Q20. What is Dependency Injection?

**Answer:** A design pattern where objects receive their dependencies from outside (framework/container) rather than creating them internally. Benefits: loose coupling, testability, flexibility. In Spring: `@Autowired` or constructor injection.

---

## Tricky Output Questions

---

### Q21. What is the output?

```java
String s1 = "Hello";
String s2 = "Hel" + "lo";
System.out.println(s1 == s2);
```

**Answer:** `true` — Compile-time constant concatenation creates same pool reference.

---

### Q22. What is the output?

```java
int[] a = {1, 2, 3};
int[] b = a;
b[0] = 99;
System.out.println(a[0]);
```

**Answer:** `99` — Arrays are objects. `b = a` copies reference, both point to same array.

---

### Q23. What is the output?

```java
System.out.println(10 + 20 + "Hello");
System.out.println("Hello" + 10 + 20);
```

**Answer:**
```
30Hello     ← 10+20=30, then concatenate with "Hello"
Hello1020   ← "Hello"+10="Hello10", then +"20"="Hello1020"
```

---

### Q24. What is the output?

```java
Integer a = 127;
Integer b = 127;
Integer c = 128;
Integer d = 128;
System.out.println(a == b);  // ?
System.out.println(c == d);  // ?
```

**Answer:**
```
true    ← Integer cache: -128 to 127 are cached objects
false   ← 128 is outside cache, different objects
```

---

### Q25. Can we override a static method?

**Answer:** No. Static methods belong to the class, not objects. You can **hide** a static method in a subclass (same signature), but it's not true overriding (no runtime polymorphism). The version called depends on the reference type, not object type.

---

## Spring Boot / Framework Questions

---

### Q26. What is Spring Boot auto-configuration?

**Answer:** Spring Boot automatically configures beans based on:
- Dependencies on classpath
- Properties in application.properties
- Existing bean definitions

Example: If `spring-boot-starter-web` is on classpath, it auto-configures an embedded Tomcat server.

---

### Q27. What are Spring Boot Starters?

**Answer:** Pre-defined dependency descriptors that bundle related dependencies:
- `spring-boot-starter-web` → Spring MVC + Tomcat + JSON
- `spring-boot-starter-data-jpa` → Hibernate + JPA + DataSource
- `spring-boot-starter-security` → Spring Security

---

### Q28. What is `@RestController` vs `@Controller`?

| `@Controller` | `@RestController` |
|---------------|-------------------|
| Returns view name (HTML page) | Returns data (JSON/XML) |
| Needs `@ResponseBody` on methods | `@ResponseBody` included |
| For web pages | For REST APIs |

---

### Q29. Explain `@RequestMapping`, `@GetMapping`, `@PostMapping`.

- `@RequestMapping("/path")` — map URL to class/method (any HTTP method)
- `@GetMapping` — shortcut for `@RequestMapping(method = GET)`
- `@PostMapping` — shortcut for `@RequestMapping(method = POST)`

---

### Q30. What is JPA and Spring Data JPA?

- **JPA** (Java Persistence API): Specification for ORM (Object-Relational Mapping)
- **Hibernate**: Most popular JPA implementation
- **Spring Data JPA**: Simplifies JPA — auto-generates CRUD from repository interface

```java
interface UserRepo extends JpaRepository<User, Long> {
    // findAll(), findById(), save(), deleteById() — FREE!
    List<User> findByAge(int age);  // Custom query from method name!
}
```

---

## Quick Comparison Table

| Topic | Option A | Option B |
|-------|----------|----------|
| `==` vs `equals()` | Reference comparison | Content comparison |
| `final` vs `finally` | Constant/no-override | Always-execute block |
| `throw` vs `throws` | Throw exception | Declare exception |
| `abstract` vs `interface` | Partial abstraction | Full abstraction |
| `ArrayList` vs `LinkedList` | Fast read | Fast insert/delete |
| `HashMap` vs `TreeMap` | O(1), unordered | O(log n), sorted |
| `Comparable` vs `Comparator` | Inside class | External |
| `String` vs `StringBuilder` | Immutable | Mutable |
| Stack vs Heap | Local vars, frames | Objects |
| Checked vs Unchecked | Must handle | Optional |

---

> **Next Topic:** [20 - Mini Projects](20-mini-projects.md)
