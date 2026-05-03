# 14. Spring Boot

## Table of Contents
- [14.1 What is Spring Boot?](#141-what-is-spring-boot)
- [14.2 Spring Boot Architecture](#142-spring-boot-architecture)
- [14.3 Project Setup](#143-project-setup)
- [14.4 REST API Basics](#144-rest-api-basics)
- [14.5 Building a CRUD API](#145-building-a-crud-api)
- [14.6 Dependency Injection](#146-dependency-injection)
- [14.7 Practice & Assessment](#147-practice--assessment)

---

## 14.1 What is Spring Boot?

### Definition
**Spring Boot** is a framework built on top of Spring that simplifies building production-ready Java applications with minimal configuration.

### Why Spring Boot?

| Without Spring Boot | With Spring Boot |
|---------------------|------------------|
| XML configuration files | Auto-configuration |
| Manual dependency management | Spring Initializr + starters |
| Deploy to external server | Embedded server (Tomcat) |
| Complex setup | `@SpringBootApplication` + run |

### Key Features
- **Auto-configuration** — automatically configures based on dependencies
- **Embedded servers** — Tomcat, Jetty, or Undertow built-in
- **Starter dependencies** — pre-configured dependency bundles
- **Production-ready** — health checks, metrics, externalized config
- **No XML needed** — annotation-based configuration

---

## 14.2 Spring Boot Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Client (Browser/App)                │
│                         │                            │
│                    HTTP Request                       │
│                         ▼                            │
│  ┌──────────────────────────────────────────────┐   │
│  │              Controller Layer                  │   │
│  │   @RestController — handles HTTP requests     │   │
│  └────────────────────┬─────────────────────────┘   │
│                       │                              │
│                       ▼                              │
│  ┌──────────────────────────────────────────────┐   │
│  │               Service Layer                   │   │
│  │   @Service — business logic                   │   │
│  └────────────────────┬─────────────────────────┘   │
│                       │                              │
│                       ▼                              │
│  ┌──────────────────────────────────────────────┐   │
│  │             Repository Layer                   │   │
│  │   @Repository — database access (JPA)         │   │
│  └────────────────────┬─────────────────────────┘   │
│                       │                              │
│                       ▼                              │
│               ┌──────────────┐                       │
│               │   Database   │                       │
│               └──────────────┘                       │
└─────────────────────────────────────────────────────┘
```

---

## 14.3 Project Setup

### Using Spring Initializr (https://start.spring.io)

```
Project: Maven
Language: Java
Spring Boot: 3.x
Group: com.example
Artifact: demo
Dependencies:
  - Spring Web
  - Spring Data JPA
  - H2 Database (or MySQL Driver)
  - Spring Boot DevTools
```

### Project Structure

```
demo/
├── src/
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── DemoApplication.java        ← Entry point
│   │   │   ├── controller/
│   │   │   │   └── StudentController.java
│   │   │   ├── service/
│   │   │   │   └── StudentService.java
│   │   │   ├── repository/
│   │   │   │   └── StudentRepository.java
│   │   │   └── model/
│   │   │       └── Student.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── pom.xml                                  ← Dependencies
```

### Main Application Class

```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication  // = @Configuration + @EnableAutoConfiguration + @ComponentScan
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```

### application.properties

```properties
# Server
server.port=8080

# H2 Database (in-memory for testing)
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.jpa.hibernate.ddl-auto=update
spring.h2.console.enabled=true

# MySQL (for production)
# spring.datasource.url=jdbc:mysql://localhost:3306/mydb
# spring.datasource.username=root
# spring.datasource.password=password
# spring.jpa.hibernate.ddl-auto=update
```

---

## 14.4 REST API Basics

### HTTP Methods & Mapping

| HTTP Method | Purpose | Annotation |
|-------------|---------|------------|
| GET | Read/retrieve data | `@GetMapping` |
| POST | Create new resource | `@PostMapping` |
| PUT | Update entire resource | `@PutMapping` |
| DELETE | Delete resource | `@DeleteMapping` |

### Simple Controller

```java
package com.example.demo.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class HelloController {
    
    @GetMapping("/hello")
    public String hello() {
        return "Hello, Spring Boot!";
    }
    
    @GetMapping("/hello/{name}")
    public String helloName(@PathVariable String name) {
        return "Hello, " + name + "!";
    }
    
    @GetMapping("/greet")
    public String greet(@RequestParam(defaultValue = "World") String name) {
        return "Greetings, " + name + "!";
    }
}

// GET http://localhost:8080/api/hello         → "Hello, Spring Boot!"
// GET http://localhost:8080/api/hello/Alice   → "Hello, Alice!"
// GET http://localhost:8080/api/greet?name=Bob → "Greetings, Bob!"
```

---

## 14.5 Building a CRUD API

### Step 1: Model (Entity)

```java
package com.example.demo.model;

import jakarta.persistence.*;

@Entity
@Table(name = "students")
public class Student {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    private int age;
    private double gpa;
    
    // Constructors
    public Student() {}
    
    public Student(String name, int age, double gpa) {
        this.name = name;
        this.age = age;
        this.gpa = gpa;
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    public double getGpa() { return gpa; }
    public void setGpa(double gpa) { this.gpa = gpa; }
}
```

### Step 2: Repository

```java
package com.example.demo.repository;

import com.example.demo.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    // Spring Data JPA auto-generates CRUD methods!
    // findAll(), findById(), save(), deleteById() — all free!
    
    // Custom queries (method name convention)
    List<Student> findByName(String name);
    List<Student> findByGpaGreaterThan(double gpa);
}
```

### Step 3: Service

```java
package com.example.demo.service;

import com.example.demo.model.Student;
import com.example.demo.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class StudentService {
    
    @Autowired
    private StudentRepository repository;
    
    public List<Student> getAllStudents() {
        return repository.findAll();
    }
    
    public Optional<Student> getStudentById(Long id) {
        return repository.findById(id);
    }
    
    public Student createStudent(Student student) {
        return repository.save(student);
    }
    
    public Student updateStudent(Long id, Student updated) {
        return repository.findById(id).map(student -> {
            student.setName(updated.getName());
            student.setAge(updated.getAge());
            student.setGpa(updated.getGpa());
            return repository.save(student);
        }).orElseThrow(() -> new RuntimeException("Student not found: " + id));
    }
    
    public void deleteStudent(Long id) {
        repository.deleteById(id);
    }
}
```

### Step 4: Controller

```java
package com.example.demo.controller;

import com.example.demo.model.Student;
import com.example.demo.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/students")
public class StudentController {
    
    @Autowired
    private StudentService service;
    
    // GET all students
    @GetMapping
    public List<Student> getAll() {
        return service.getAllStudents();
    }
    
    // GET student by ID
    @GetMapping("/{id}")
    public ResponseEntity<Student> getById(@PathVariable Long id) {
        return service.getStudentById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    // POST create student
    @PostMapping
    public Student create(@RequestBody Student student) {
        return service.createStudent(student);
    }
    
    // PUT update student
    @PutMapping("/{id}")
    public Student update(@PathVariable Long id, @RequestBody Student student) {
        return service.updateStudent(id, student);
    }
    
    // DELETE student
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.deleteStudent(id);
        return ResponseEntity.noContent().build();
    }
}
```

### Testing with curl

```bash
# Create
curl -X POST http://localhost:8080/api/students \
  -H "Content-Type: application/json" \
  -d '{"name":"Alice","age":20,"gpa":3.8}'

# Read all
curl http://localhost:8080/api/students

# Read one
curl http://localhost:8080/api/students/1

# Update
curl -X PUT http://localhost:8080/api/students/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Alice","age":21,"gpa":3.9}'

# Delete
curl -X DELETE http://localhost:8080/api/students/1
```

---

## 14.6 Dependency Injection

### Definition
**Dependency Injection (DI)** is a design pattern where objects receive their dependencies from outside rather than creating them internally. Spring manages object creation and wiring.

### Types of Injection

```java
// Method 1: Field injection (simple but less testable)
@Service
public class StudentService {
    @Autowired
    private StudentRepository repository;
}

// Method 2: Constructor injection (RECOMMENDED)
@Service
public class StudentService {
    private final StudentRepository repository;
    
    // Spring auto-injects StudentRepository
    public StudentService(StudentRepository repository) {
        this.repository = repository;
    }
}

// Method 3: Setter injection
@Service
public class StudentService {
    private StudentRepository repository;
    
    @Autowired
    public void setRepository(StudentRepository repository) {
        this.repository = repository;
    }
}
```

### Spring Annotations Summary

| Annotation | Purpose |
|------------|---------|
| `@SpringBootApplication` | Main class — enables auto-config |
| `@RestController` | Class handles REST HTTP requests |
| `@RequestMapping("/path")` | Base URL for controller |
| `@GetMapping` | Handle GET requests |
| `@PostMapping` | Handle POST requests |
| `@PutMapping` | Handle PUT requests |
| `@DeleteMapping` | Handle DELETE requests |
| `@PathVariable` | Extract value from URL path |
| `@RequestParam` | Extract query parameter |
| `@RequestBody` | Parse JSON body to object |
| `@Service` | Business logic component |
| `@Repository` | Data access component |
| `@Autowired` | Auto-inject dependency |
| `@Entity` | JPA database entity |
| `@Id` | Primary key |
| `@GeneratedValue` | Auto-generate ID |

---

## 14.7 Practice & Assessment

### MCQs

**Q1.** `@RestController` is a combination of:
- A) @Controller + @Service
- B) @Controller + @ResponseBody
- C) @Component + @Autowired
- D) @Bean + @Configuration

**Answer:** B — `@RestController` = `@Controller` + `@ResponseBody` (returns data, not view).

---

**Q2.** Spring Data JPA's `JpaRepository` provides:
- A) Only save()
- B) Only findAll()
- C) Full CRUD methods automatically
- D) Only custom queries

**Answer:** C — findAll, findById, save, deleteById, count, etc. — all auto-generated.

---

**Q3.** `@Autowired` is used for:
- A) Creating database tables
- B) Dependency injection
- C) URL mapping
- D) Exception handling

**Answer:** B

---

### Coding Task

**Task:** Add an endpoint to the Student API that returns students with GPA above a given threshold.

```java
// In StudentController
@GetMapping("/top")
public List<Student> getTopStudents(@RequestParam double minGpa) {
    return service.getStudentsByMinGpa(minGpa);
}

// In StudentService
public List<Student> getStudentsByMinGpa(double minGpa) {
    return repository.findByGpaGreaterThan(minGpa);
}

// Usage: GET http://localhost:8080/api/students/top?minGpa=3.5
```

---

> **Next Topic:** [15 - Advanced Java](15-advanced-java.md)
