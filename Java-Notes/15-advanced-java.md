# 15. Advanced Java Concepts

## Table of Contents
- [15.1 Generics](#151-generics)
- [15.2 Lambda Expressions](#152-lambda-expressions)
- [15.3 Functional Interfaces](#153-functional-interfaces)
- [15.4 Streams API](#154-streams-api)
- [15.5 Optional Class](#155-optional-class)
- [15.6 Practice & Assessment](#156-practice--assessment)

---

## 15.1 Generics

### Definition
**Generics** allow you to write classes, interfaces, and methods that work with any type while providing compile-time type safety.

### Without Generics (Unsafe)

```java
// Old way — no type safety
ArrayList list = new ArrayList();
list.add("Hello");
list.add(123);       // No error at compile time!
String s = (String) list.get(1);  // ClassCastException at RUNTIME!
```

### With Generics (Safe)

```java
// Type-safe — compiler catches errors
ArrayList<String> list = new ArrayList<>();
list.add("Hello");
// list.add(123);    // COMPILE ERROR! Only Strings allowed
String s = list.get(0);  // No cast needed
```

### Generic Class

```java
class Box<T> {
    private T content;
    
    public void set(T content) {
        this.content = content;
    }
    
    public T get() {
        return content;
    }
}

// Usage
Box<String> stringBox = new Box<>();
stringBox.set("Hello");
String value = stringBox.get();  // No casting

Box<Integer> intBox = new Box<>();
intBox.set(42);
int num = intBox.get();
```

### Generic Method

```java
public class Util {
    // Generic method — works with any type
    public static <T> void printArray(T[] array) {
        for (T item : array) {
            System.out.print(item + " ");
        }
        System.out.println();
    }
    
    public static <T extends Comparable<T>> T findMax(T a, T b) {
        return a.compareTo(b) > 0 ? a : b;
    }
}

// Usage
Integer[] ints = {1, 2, 3};
String[] strs = {"A", "B", "C"};
Util.printArray(ints);   // 1 2 3
Util.printArray(strs);   // A B C
System.out.println(Util.findMax(10, 20));  // 20
```

### Bounded Type Parameters

```java
// T must implement Comparable
public static <T extends Comparable<T>> T max(T a, T b) {
    return a.compareTo(b) >= 0 ? a : b;
}

// Multiple bounds
public static <T extends Number & Comparable<T>> T process(T item) {
    return item;
}
```

### Wildcards

```java
// ? — unknown type
List<?> list;                          // Any type

// Upper bound — ? extends Number (Number or subclass)
void printNumbers(List<? extends Number> list) {
    for (Number n : list) {
        System.out.println(n.doubleValue());
    }
}

// Lower bound — ? super Integer (Integer or superclass)
void addIntegers(List<? super Integer> list) {
    list.add(1);
    list.add(2);
}
```

---

## 15.2 Lambda Expressions

### Definition
A **lambda expression** is a concise way to represent an anonymous function (one method of a functional interface).

### Syntax

```java
// Full syntax
(parameters) -> { body }

// Simplified forms
(a, b) -> a + b              // Expression body (auto-returns)
x -> x * 2                   // Single param (no parens needed)
() -> System.out.println("Hi")  // No params
```

### Before vs After Lambda

```java
// BEFORE: Anonymous class (verbose)
Runnable r1 = new Runnable() {
    @Override
    public void run() {
        System.out.println("Running");
    }
};

// AFTER: Lambda (concise)
Runnable r2 = () -> System.out.println("Running");

// BEFORE: Comparator
Collections.sort(list, new Comparator<String>() {
    @Override
    public int compare(String a, String b) {
        return a.length() - b.length();
    }
});

// AFTER: Lambda
Collections.sort(list, (a, b) -> a.length() - b.length());

// EVEN SHORTER: Method reference
Collections.sort(list, Comparator.comparingInt(String::length));
```

### Using Lambdas with Collections

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "Dave");

// forEach
names.forEach(name -> System.out.println(name));
names.forEach(System.out::println);  // Method reference

// sort
names.sort((a, b) -> a.compareTo(b));
names.sort(String::compareTo);  // Method reference

// removeIf
names.removeIf(name -> name.length() < 4);
System.out.println(names);  // [Alice, Charlie, Dave]
```

---

## 15.3 Functional Interfaces

### Definition
A **functional interface** has exactly ONE abstract method. Can be used as lambda target.

### Built-in Functional Interfaces (java.util.function)

| Interface | Method | Purpose | Example |
|-----------|--------|---------|---------|
| `Predicate<T>` | `test(T)` → boolean | Filter/condition | `x -> x > 5` |
| `Function<T,R>` | `apply(T)` → R | Transform | `s -> s.length()` |
| `Consumer<T>` | `accept(T)` → void | Process/use | `s -> System.out.println(s)` |
| `Supplier<T>` | `get()` → T | Provide value | `() -> new ArrayList<>()` |
| `UnaryOperator<T>` | `apply(T)` → T | Transform same type | `x -> x * 2` |
| `BinaryOperator<T>` | `apply(T,T)` → T | Combine two | `(a,b) -> a + b` |

### Examples

```java
import java.util.function.*;

// Predicate — test condition
Predicate<Integer> isEven = n -> n % 2 == 0;
System.out.println(isEven.test(4));  // true
System.out.println(isEven.test(7));  // false

// Chaining predicates
Predicate<Integer> isPositive = n -> n > 0;
Predicate<Integer> isPositiveEven = isEven.and(isPositive);
System.out.println(isPositiveEven.test(4));   // true
System.out.println(isPositiveEven.test(-2));  // false

// Function — transform
Function<String, Integer> strLength = String::length;
System.out.println(strLength.apply("Hello"));  // 5

// Chaining functions
Function<Integer, Integer> doubleIt = x -> x * 2;
Function<Integer, Integer> addThree = x -> x + 3;
Function<Integer, Integer> combined = doubleIt.andThen(addThree);
System.out.println(combined.apply(5));  // 13 (5*2=10, 10+3=13)

// Consumer — perform action
Consumer<String> printer = System.out::println;
printer.accept("Hello!");  // prints: Hello!

// Supplier — provide value
Supplier<Double> random = Math::random;
System.out.println(random.get());  // 0.xxx random number
```

### Custom Functional Interface

```java
@FunctionalInterface
interface MathOperation {
    double operate(double a, double b);
}

// Usage
MathOperation add = (a, b) -> a + b;
MathOperation power = Math::pow;

System.out.println(add.operate(5, 3));    // 8.0
System.out.println(power.operate(2, 10)); // 1024.0
```

---

## 15.4 Streams API

### Definition
**Streams** provide a functional approach to process collections of data — filter, transform, aggregate — in a declarative, pipeline style.

### Stream Pipeline

```
Source → Intermediate Operations → Terminal Operation
(collection)   (lazy, chainable)    (triggers execution)
```

### Creating Streams

```java
// From collection
List<String> list = List.of("a", "b", "c");
Stream<String> stream1 = list.stream();

// From array
Stream<Integer> stream2 = Arrays.stream(new Integer[]{1, 2, 3});

// Using Stream.of
Stream<String> stream3 = Stream.of("x", "y", "z");

// Generate
Stream<Double> randoms = Stream.generate(Math::random).limit(5);

// Iterate
Stream<Integer> counting = Stream.iterate(1, n -> n + 1).limit(10);
```

### Key Operations

```java
List<String> names = List.of("Alice", "Bob", "Charlie", "Dave", "Eve", "Alice");

// filter — keep elements matching condition
List<String> longNames = names.stream()
    .filter(n -> n.length() > 3)
    .collect(Collectors.toList());
// [Alice, Charlie, Dave, Alice]

// map — transform each element
List<Integer> lengths = names.stream()
    .map(String::length)
    .collect(Collectors.toList());
// [5, 3, 7, 4, 3, 5]

// distinct — remove duplicates
List<String> unique = names.stream()
    .distinct()
    .collect(Collectors.toList());
// [Alice, Bob, Charlie, Dave, Eve]

// sorted
List<String> sorted = names.stream()
    .sorted()
    .collect(Collectors.toList());
// [Alice, Alice, Bob, Charlie, Dave, Eve]

// limit and skip
List<String> firstThree = names.stream().limit(3).collect(Collectors.toList());
List<String> skipTwo = names.stream().skip(2).collect(Collectors.toList());

// count
long count = names.stream().filter(n -> n.startsWith("A")).count();
// 2

// forEach (terminal)
names.stream().forEach(System.out::println);

// reduce — combine to single value
int totalLength = names.stream()
    .mapToInt(String::length)
    .sum();
// 27

// findFirst
Optional<String> first = names.stream()
    .filter(n -> n.startsWith("C"))
    .findFirst();
// Optional[Charlie]

// anyMatch, allMatch, noneMatch
boolean anyLong = names.stream().anyMatch(n -> n.length() > 5);  // true
boolean allShort = names.stream().allMatch(n -> n.length() < 10); // true
```

### Practical Examples

```java
// Example 1: Get names of students with GPA > 3.5, sorted
List<Student> students = getStudents();
List<String> topStudents = students.stream()
    .filter(s -> s.getGpa() > 3.5)
    .sorted(Comparator.comparingDouble(Student::getGpa).reversed())
    .map(Student::getName)
    .collect(Collectors.toList());

// Example 2: Calculate average salary
double avgSalary = employees.stream()
    .mapToDouble(Employee::getSalary)
    .average()
    .orElse(0.0);

// Example 3: Group by department
Map<String, List<Employee>> byDept = employees.stream()
    .collect(Collectors.groupingBy(Employee::getDepartment));

// Example 4: Join strings
String joined = names.stream()
    .collect(Collectors.joining(", "));
// "Alice, Bob, Charlie, Dave, Eve, Alice"

// Example 5: Frequency map
Map<String, Long> freq = names.stream()
    .collect(Collectors.groupingBy(n -> n, Collectors.counting()));
// {Alice=2, Bob=1, Charlie=1, Dave=1, Eve=1}
```

---

## 15.5 Optional Class

### Definition
**Optional** is a container that may or may not contain a value. Avoids `NullPointerException`.

```java
import java.util.Optional;

// Creating Optional
Optional<String> full = Optional.of("Hello");       // Must be non-null
Optional<String> nullable = Optional.ofNullable(null);  // May be null
Optional<String> empty = Optional.empty();          // Empty

// Checking and getting
if (full.isPresent()) {
    System.out.println(full.get());  // "Hello"
}

// ifPresent — execute if value exists
full.ifPresent(System.out::println);  // prints "Hello"

// orElse — default value if empty
String result = nullable.orElse("Default");  // "Default"

// orElseGet — lazy default
String result2 = nullable.orElseGet(() -> "Computed Default");

// orElseThrow
String result3 = nullable.orElseThrow(() -> new RuntimeException("Not found!"));

// map — transform if present
Optional<Integer> length = full.map(String::length);  // Optional[5]

// filter
Optional<String> filtered = full.filter(s -> s.length() > 3);  // Optional[Hello]
```

---

## 15.6 Practice & Assessment

### MCQs

**Q1.** Lambda expressions require:
- A) Abstract class
- B) Functional interface (one abstract method)
- C) Multiple abstract methods
- D) Static methods only

**Answer:** B

---

**Q2.** `stream.filter()` is:
- A) Terminal operation
- B) Intermediate operation
- C) Source operation
- D) None

**Answer:** B — filter is intermediate (lazy, returns stream).

---

**Q3.** `Optional.orElse("default")` returns:
- A) Always the Optional value
- B) Always "default"
- C) The value if present, else "default"
- D) null

**Answer:** C

---

### Coding Tasks

**Task 1:** Filter a list of integers to get only even numbers, square them, and find the sum.

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

int sum = numbers.stream()
    .filter(n -> n % 2 == 0)       // [2, 4, 6, 8, 10]
    .map(n -> n * n)               // [4, 16, 36, 64, 100]
    .reduce(0, Integer::sum);      // 220

System.out.println("Sum of squares of evens: " + sum);  // 220
```

**Task 2:** Given a list of strings, return the longest string using streams.

```java
List<String> words = List.of("Java", "Programming", "Stream", "Lambda");

String longest = words.stream()
    .max(Comparator.comparingInt(String::length))
    .orElse("");

System.out.println("Longest: " + longest);  // Programming
```

---

> **Next Topic:** [16 - Design Patterns](16-design-patterns.md)
