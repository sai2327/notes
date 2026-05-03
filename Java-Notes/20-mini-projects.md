# 20. Mini Projects

---

## Project 1: Student Management System (Console App)

### Features
- Add, view, search, update, delete students
- Persistent storage using file I/O
- Exception handling for invalid inputs

```java
import java.io.*;
import java.util.*;

class Student implements Serializable {
    private int id;
    private String name;
    private double gpa;
    
    public Student(int id, String name, double gpa) {
        this.id = id;
        this.name = name;
        this.gpa = gpa;
    }
    
    public int getId() { return id; }
    public String getName() { return name; }
    public double getGpa() { return gpa; }
    public void setName(String name) { this.name = name; }
    public void setGpa(double gpa) { this.gpa = gpa; }
    
    @Override
    public String toString() {
        return String.format("| %-5d | %-15s | %-5.2f |", id, name, gpa);
    }
}

public class StudentManagement {
    private static List<Student> students = new ArrayList<>();
    private static final String FILE = "students.dat";
    private static Scanner sc = new Scanner(System.in);
    
    public static void main(String[] args) {
        loadFromFile();
        
        while (true) {
            System.out.println("\n=== Student Management System ===");
            System.out.println("1. Add Student");
            System.out.println("2. View All");
            System.out.println("3. Search by ID");
            System.out.println("4. Update Student");
            System.out.println("5. Delete Student");
            System.out.println("6. Sort by GPA");
            System.out.println("0. Exit");
            System.out.print("Choice: ");
            
            int choice;
            try {
                choice = Integer.parseInt(sc.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("Invalid input!");
                continue;
            }
            
            switch (choice) {
                case 1: addStudent(); break;
                case 2: viewAll(); break;
                case 3: searchById(); break;
                case 4: updateStudent(); break;
                case 5: deleteStudent(); break;
                case 6: sortByGpa(); break;
                case 0:
                    saveToFile();
                    System.out.println("Goodbye!");
                    return;
                default:
                    System.out.println("Invalid choice!");
            }
        }
    }
    
    static void addStudent() {
        System.out.print("Enter ID: ");
        int id = Integer.parseInt(sc.nextLine());
        
        // Check duplicate
        for (Student s : students) {
            if (s.getId() == id) {
                System.out.println("ID already exists!");
                return;
            }
        }
        
        System.out.print("Enter Name: ");
        String name = sc.nextLine();
        System.out.print("Enter GPA (0-4): ");
        double gpa = Double.parseDouble(sc.nextLine());
        
        if (gpa < 0 || gpa > 4) {
            System.out.println("Invalid GPA!");
            return;
        }
        
        students.add(new Student(id, name, gpa));
        System.out.println("Student added successfully!");
    }
    
    static void viewAll() {
        if (students.isEmpty()) {
            System.out.println("No students found.");
            return;
        }
        System.out.println("| ID    | Name            | GPA   |");
        System.out.println("|-------|-----------------|-------|");
        for (Student s : students) {
            System.out.println(s);
        }
    }
    
    static void searchById() {
        System.out.print("Enter ID to search: ");
        int id = Integer.parseInt(sc.nextLine());
        
        students.stream()
            .filter(s -> s.getId() == id)
            .findFirst()
            .ifPresentOrElse(
                s -> System.out.println("Found: " + s),
                () -> System.out.println("Not found!")
            );
    }
    
    static void updateStudent() {
        System.out.print("Enter ID to update: ");
        int id = Integer.parseInt(sc.nextLine());
        
        for (Student s : students) {
            if (s.getId() == id) {
                System.out.print("New name (blank to skip): ");
                String name = sc.nextLine();
                if (!name.isEmpty()) s.setName(name);
                
                System.out.print("New GPA (blank to skip): ");
                String gpaStr = sc.nextLine();
                if (!gpaStr.isEmpty()) s.setGpa(Double.parseDouble(gpaStr));
                
                System.out.println("Updated!");
                return;
            }
        }
        System.out.println("Student not found!");
    }
    
    static void deleteStudent() {
        System.out.print("Enter ID to delete: ");
        int id = Integer.parseInt(sc.nextLine());
        
        boolean removed = students.removeIf(s -> s.getId() == id);
        System.out.println(removed ? "Deleted!" : "Not found!");
    }
    
    static void sortByGpa() {
        students.sort(Comparator.comparingDouble(Student::getGpa).reversed());
        System.out.println("Sorted by GPA (highest first):");
        viewAll();
    }
    
    @SuppressWarnings("unchecked")
    static void loadFromFile() {
        File file = new File(FILE);
        if (!file.exists()) return;
        
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {
            students = (List<Student>) ois.readObject();
            System.out.println("Loaded " + students.size() + " students from file.");
        } catch (Exception e) {
            System.out.println("Could not load data: " + e.getMessage());
        }
    }
    
    static void saveToFile() {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(FILE))) {
            oos.writeObject(students);
            System.out.println("Data saved!");
        } catch (IOException e) {
            System.out.println("Error saving: " + e.getMessage());
        }
    }
}
```

---

## Project 2: Library Management System

### Features
- Add/view/search/borrow/return books
- Track availability
- OOP design with multiple classes

```java
import java.util.*;

// Book class
class Book {
    private String isbn;
    private String title;
    private String author;
    private boolean available;
    
    public Book(String isbn, String title, String author) {
        this.isbn = isbn;
        this.title = title;
        this.author = author;
        this.available = true;
    }
    
    public String getIsbn() { return isbn; }
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }
    
    @Override
    public String toString() {
        return String.format("%-10s | %-25s | %-15s | %s",
            isbn, title, author, available ? "Available" : "Borrowed");
    }
}

// Library class (manages books)
class Library {
    private Map<String, Book> books = new HashMap<>();
    
    public void addBook(Book book) {
        if (books.containsKey(book.getIsbn())) {
            System.out.println("Book with this ISBN already exists!");
            return;
        }
        books.put(book.getIsbn(), book);
        System.out.println("Book added: " + book.getTitle());
    }
    
    public void viewAll() {
        if (books.isEmpty()) {
            System.out.println("Library is empty.");
            return;
        }
        System.out.println("ISBN       | Title                     | Author          | Status");
        System.out.println("-----------|---------------------------|-----------------|----------");
        books.values().forEach(System.out::println);
    }
    
    public void searchByTitle(String keyword) {
        books.values().stream()
            .filter(b -> b.getTitle().toLowerCase().contains(keyword.toLowerCase()))
            .forEach(System.out::println);
    }
    
    public boolean borrowBook(String isbn) {
        Book book = books.get(isbn);
        if (book == null) {
            System.out.println("Book not found!");
            return false;
        }
        if (!book.isAvailable()) {
            System.out.println("Book is already borrowed!");
            return false;
        }
        book.setAvailable(false);
        System.out.println("Borrowed: " + book.getTitle());
        return true;
    }
    
    public boolean returnBook(String isbn) {
        Book book = books.get(isbn);
        if (book == null) {
            System.out.println("Book not found!");
            return false;
        }
        if (book.isAvailable()) {
            System.out.println("Book is not borrowed!");
            return false;
        }
        book.setAvailable(true);
        System.out.println("Returned: " + book.getTitle());
        return true;
    }
    
    public long countAvailable() {
        return books.values().stream().filter(Book::isAvailable).count();
    }
}

// Main application
public class LibraryApp {
    public static void main(String[] args) {
        Library library = new Library();
        Scanner sc = new Scanner(System.in);
        
        // Add sample books
        library.addBook(new Book("978-001", "Java Complete Reference", "Herbert Schildt"));
        library.addBook(new Book("978-002", "Clean Code", "Robert Martin"));
        library.addBook(new Book("978-003", "Design Patterns", "Gang of Four"));
        
        while (true) {
            System.out.println("\n=== Library System ===");
            System.out.println("1. View All Books");
            System.out.println("2. Search by Title");
            System.out.println("3. Borrow Book");
            System.out.println("4. Return Book");
            System.out.println("5. Add New Book");
            System.out.println("0. Exit");
            System.out.print("Choice: ");
            
            String input = sc.nextLine();
            switch (input) {
                case "1":
                    library.viewAll();
                    System.out.println("Available: " + library.countAvailable());
                    break;
                case "2":
                    System.out.print("Enter keyword: ");
                    library.searchByTitle(sc.nextLine());
                    break;
                case "3":
                    System.out.print("Enter ISBN: ");
                    library.borrowBook(sc.nextLine());
                    break;
                case "4":
                    System.out.print("Enter ISBN: ");
                    library.returnBook(sc.nextLine());
                    break;
                case "5":
                    System.out.print("ISBN: ");
                    String isbn = sc.nextLine();
                    System.out.print("Title: ");
                    String title = sc.nextLine();
                    System.out.print("Author: ");
                    String author = sc.nextLine();
                    library.addBook(new Book(isbn, title, author));
                    break;
                case "0":
                    System.out.println("Goodbye!");
                    return;
            }
        }
    }
}
```

---

## Project 3: REST API with Spring Boot (Book Store)

### Structure
```
bookstore/
├── src/main/java/com/example/bookstore/
│   ├── BookstoreApplication.java
│   ├── model/Book.java
│   ├── repository/BookRepository.java
│   ├── service/BookService.java
│   └── controller/BookController.java
└── src/main/resources/application.properties
```

### Model

```java
package com.example.bookstore.model;

import jakarta.persistence.*;

@Entity
@Table(name = "books")
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String title;
    
    @Column(nullable = false)
    private String author;
    
    private double price;
    private int quantity;
    
    // Constructors
    public Book() {}
    public Book(String title, String author, double price, int quantity) {
        this.title = title;
        this.author = author;
        this.price = price;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
```

### Repository

```java
package com.example.bookstore.repository;

import com.example.bookstore.model.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BookRepository extends JpaRepository<Book, Long> {
    List<Book> findByAuthor(String author);
    List<Book> findByTitleContainingIgnoreCase(String keyword);
    List<Book> findByPriceLessThan(double price);
}
```

### Service

```java
package com.example.bookstore.service;

import com.example.bookstore.model.Book;
import com.example.bookstore.repository.BookRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class BookService {
    private final BookRepository repo;
    
    public BookService(BookRepository repo) {
        this.repo = repo;
    }
    
    public List<Book> getAll() { return repo.findAll(); }
    
    public Optional<Book> getById(Long id) { return repo.findById(id); }
    
    public Book save(Book book) { return repo.save(book); }
    
    public Book update(Long id, Book updated) {
        return repo.findById(id).map(book -> {
            book.setTitle(updated.getTitle());
            book.setAuthor(updated.getAuthor());
            book.setPrice(updated.getPrice());
            book.setQuantity(updated.getQuantity());
            return repo.save(book);
        }).orElseThrow(() -> new RuntimeException("Book not found: " + id));
    }
    
    public void delete(Long id) { repo.deleteById(id); }
    
    public List<Book> searchByTitle(String keyword) {
        return repo.findByTitleContainingIgnoreCase(keyword);
    }
}
```

### Controller

```java
package com.example.bookstore.controller;

import com.example.bookstore.model.Book;
import com.example.bookstore.service.BookService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/books")
public class BookController {
    private final BookService service;
    
    public BookController(BookService service) {
        this.service = service;
    }
    
    @GetMapping
    public List<Book> getAll() {
        return service.getAll();
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Book> getById(@PathVariable Long id) {
        return service.getById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public Book create(@RequestBody Book book) {
        return service.save(book);
    }
    
    @PutMapping("/{id}")
    public Book update(@PathVariable Long id, @RequestBody Book book) {
        return service.update(id, book);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
    
    @GetMapping("/search")
    public List<Book> search(@RequestParam String title) {
        return service.searchByTitle(title);
    }
}
```

### Test with cURL

```bash
# Create
curl -X POST http://localhost:8080/api/books \
  -H "Content-Type: application/json" \
  -d '{"title":"Java 17","author":"Oracle","price":49.99,"quantity":10}'

# Get all
curl http://localhost:8080/api/books

# Get by ID
curl http://localhost:8080/api/books/1

# Update
curl -X PUT http://localhost:8080/api/books/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Java 21","author":"Oracle","price":59.99,"quantity":15}'

# Delete
curl -X DELETE http://localhost:8080/api/books/1

# Search
curl "http://localhost:8080/api/books/search?title=java"
```

---

## Project 4: GUI Calculator (Swing)

```java
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Calculator extends JFrame implements ActionListener {
    private JTextField display;
    private double num1, num2, result;
    private String operator;
    
    public Calculator() {
        setTitle("Calculator");
        setSize(300, 400);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLayout(new BorderLayout());
        
        // Display
        display = new JTextField();
        display.setFont(new Font("Arial", Font.BOLD, 24));
        display.setHorizontalAlignment(JTextField.RIGHT);
        display.setEditable(false);
        add(display, BorderLayout.NORTH);
        
        // Button panel
        JPanel panel = new JPanel(new GridLayout(5, 4, 5, 5));
        
        String[] buttons = {
            "C", "±", "%", "/",
            "7", "8", "9", "*",
            "4", "5", "6", "-",
            "1", "2", "3", "+",
            "0", ".", "DEL", "="
        };
        
        for (String text : buttons) {
            JButton btn = new JButton(text);
            btn.setFont(new Font("Arial", Font.BOLD, 18));
            btn.addActionListener(this);
            
            if (text.matches("[/\\*\\-+=%]")) {
                btn.setBackground(new Color(255, 159, 10));
                btn.setForeground(Color.WHITE);
            }
            panel.add(btn);
        }
        
        add(panel, BorderLayout.CENTER);
        setVisible(true);
    }
    
    @Override
    public void actionPerformed(ActionEvent e) {
        String cmd = e.getActionCommand();
        
        switch (cmd) {
            case "C":
                display.setText("");
                num1 = num2 = result = 0;
                operator = "";
                break;
                
            case "DEL":
                String text = display.getText();
                if (!text.isEmpty()) {
                    display.setText(text.substring(0, text.length() - 1));
                }
                break;
                
            case "±":
                if (!display.getText().isEmpty()) {
                    double val = Double.parseDouble(display.getText());
                    display.setText(String.valueOf(-val));
                }
                break;
                
            case "+": case "-": case "*": case "/": case "%":
                num1 = Double.parseDouble(display.getText());
                operator = cmd;
                display.setText("");
                break;
                
            case "=":
                num2 = Double.parseDouble(display.getText());
                switch (operator) {
                    case "+": result = num1 + num2; break;
                    case "-": result = num1 - num2; break;
                    case "*": result = num1 * num2; break;
                    case "/":
                        if (num2 == 0) {
                            display.setText("Error");
                            return;
                        }
                        result = num1 / num2;
                        break;
                    case "%": result = num1 % num2; break;
                }
                // Display result (remove .0 for whole numbers)
                if (result == (int) result) {
                    display.setText(String.valueOf((int) result));
                } else {
                    display.setText(String.valueOf(result));
                }
                break;
                
            default:  // Number or dot
                display.setText(display.getText() + cmd);
        }
    }
    
    public static void main(String[] args) {
        SwingUtilities.invokeLater(Calculator::new);
    }
}
```

---

## Project 5: Bank Account System (OOP + Multithreading)

```java
import java.util.*;
import java.util.concurrent.*;

// Account class (thread-safe)
class BankAccount {
    private final String accountId;
    private final String owner;
    private double balance;
    private final List<String> transactions = new ArrayList<>();
    
    public BankAccount(String accountId, String owner, double initialBalance) {
        this.accountId = accountId;
        this.owner = owner;
        this.balance = initialBalance;
        addTransaction("Account created with balance: $" + initialBalance);
    }
    
    public synchronized void deposit(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Amount must be positive");
        balance += amount;
        addTransaction("Deposited: $" + amount + " | Balance: $" + balance);
    }
    
    public synchronized void withdraw(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Amount must be positive");
        if (amount > balance) throw new IllegalArgumentException("Insufficient funds");
        balance -= amount;
        addTransaction("Withdrew: $" + amount + " | Balance: $" + balance);
    }
    
    public synchronized double getBalance() { return balance; }
    public String getAccountId() { return accountId; }
    public String getOwner() { return owner; }
    
    public synchronized List<String> getTransactions() {
        return new ArrayList<>(transactions);
    }
    
    private void addTransaction(String msg) {
        transactions.add("[" + java.time.LocalDateTime.now() + "] " + msg);
    }
    
    @Override
    public String toString() {
        return String.format("Account: %s | Owner: %s | Balance: $%.2f",
            accountId, owner, balance);
    }
}

// Transfer simulation with threads
public class BankSystem {
    public static void main(String[] args) throws InterruptedException {
        BankAccount alice = new BankAccount("ACC001", "Alice", 1000);
        BankAccount bob = new BankAccount("ACC002", "Bob", 500);
        
        System.out.println("Initial State:");
        System.out.println(alice);
        System.out.println(bob);
        
        // Simulate concurrent transfers
        ExecutorService executor = Executors.newFixedThreadPool(4);
        
        // Alice deposits multiple times
        for (int i = 0; i < 5; i++) {
            executor.submit(() -> {
                alice.deposit(100);
                System.out.println(Thread.currentThread().getName()
                    + " → Alice deposit. Balance: $" + alice.getBalance());
            });
        }
        
        // Bob withdraws multiple times
        for (int i = 0; i < 3; i++) {
            executor.submit(() -> {
                try {
                    bob.withdraw(100);
                    System.out.println(Thread.currentThread().getName()
                        + " → Bob withdraw. Balance: $" + bob.getBalance());
                } catch (IllegalArgumentException e) {
                    System.out.println("Failed: " + e.getMessage());
                }
            });
        }
        
        executor.shutdown();
        executor.awaitTermination(5, TimeUnit.SECONDS);
        
        System.out.println("\nFinal State:");
        System.out.println(alice);
        System.out.println(bob);
        
        System.out.println("\nAlice's Transactions:");
        alice.getTransactions().forEach(System.out::println);
    }
}
```

**Output (thread order may vary):**
```
Initial State:
Account: ACC001 | Owner: Alice | Balance: $1000.00
Account: ACC002 | Owner: Bob | Balance: $500.00
pool-1-thread-1 → Alice deposit. Balance: $1100.0
pool-1-thread-2 → Alice deposit. Balance: $1200.0
pool-1-thread-3 → Alice deposit. Balance: $1300.0
pool-1-thread-4 → Bob withdraw. Balance: $400.0
pool-1-thread-1 → Alice deposit. Balance: $1400.0
pool-1-thread-2 → Alice deposit. Balance: $1500.0
pool-1-thread-3 → Bob withdraw. Balance: $300.0
pool-1-thread-4 → Bob withdraw. Balance: $200.0

Final State:
Account: ACC001 | Owner: Alice | Balance: $1500.00
Account: ACC002 | Owner: Bob | Balance: $200.00
```

---

## Summary of Projects

| Project | Concepts Practiced |
|---------|-------------------|
| Student Management | OOP, Collections, File I/O, Streams |
| Library System | OOP, HashMap, Encapsulation, Menu-driven |
| REST API (Spring Boot) | MVC, JPA, REST, Dependency Injection |
| GUI Calculator | Swing, Event Handling, Layout Managers |
| Bank System | Multithreading, Synchronization, ExecutorService |

---

> **Congratulations!** You have completed the entire Java Notes series from basics to advanced projects. Keep practicing by extending these projects with additional features!
