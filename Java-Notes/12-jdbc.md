# 12. JDBC (Java Database Connectivity)

## Table of Contents
- [12.1 What is JDBC?](#121-what-is-jdbc)
- [12.2 JDBC Architecture](#122-jdbc-architecture)
- [12.3 JDBC Steps](#123-jdbc-steps)
- [12.4 CRUD Operations](#124-crud-operations)
- [12.5 PreparedStatement](#125-preparedstatement)
- [12.6 Practice & Assessment](#126-practice--assessment)

---

## 12.1 What is JDBC?

### Definition
**JDBC** (Java Database Connectivity) is a Java API that enables Java programs to interact with relational databases (MySQL, Oracle, PostgreSQL, etc.).

### Purpose
- Execute SQL queries from Java
- Retrieve and process results
- Insert, update, delete records
- Database-independent code (change driver, same code)

---

## 12.2 JDBC Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Java Application                       │
│                         │                                │
│                    JDBC API                               │
│            (java.sql package)                            │
│                         │                                │
│                  JDBC Driver Manager                      │
│                    /    |    \                           │
│            ┌──────┐ ┌──────┐ ┌──────┐                  │
│            │MySQL │ │Oracle│ │Postgr│   ← JDBC Drivers  │
│            │Driver│ │Driver│ │Driver│                    │
│            └──┬───┘ └──┬───┘ └──┬───┘                  │
└───────────────┼─────────┼───────┼───────────────────────┘
                │         │       │
            ┌───┴──┐  ┌───┴──┐ ┌──┴───┐
            │MySQL │  │Oracle│ │Postgr │   ← Databases
            │ DB   │  │ DB   │ │ DB    │
            └──────┘  └──────┘ └───────┘
```

### Key Interfaces (java.sql)

| Interface/Class | Purpose |
|----------------|---------|
| `DriverManager` | Manages JDBC drivers, creates connections |
| `Connection` | Represents database connection |
| `Statement` | Executes SQL queries |
| `PreparedStatement` | Executes parameterized SQL (safe!) |
| `ResultSet` | Holds query results (rows/columns) |

---

## 12.3 JDBC Steps

```
Step 1: Load/Register driver
Step 2: Establish connection
Step 3: Create statement
Step 4: Execute query
Step 5: Process results
Step 6: Close connection
```

### Complete Example (MySQL)

```java
import java.sql.*;

public class JDBCDemo {
    public static void main(String[] args) {
        // Connection details
        String url = "jdbc:mysql://localhost:3306/school";
        String user = "root";
        String password = "password123";
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            // Step 1: Load driver (optional in JDBC 4.0+, auto-loaded)
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Step 2: Establish connection
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to database!");
            
            // Step 3: Create statement
            stmt = conn.createStatement();
            
            // Step 4: Execute query
            rs = stmt.executeQuery("SELECT * FROM students");
            
            // Step 5: Process results
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                double gpa = rs.getDouble("gpa");
                System.out.println(id + " | " + name + " | " + gpa);
            }
            
        } catch (ClassNotFoundException e) {
            System.out.println("Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
        } finally {
            // Step 6: Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
```

### Modern Version (try-with-resources)

```java
String url = "jdbc:mysql://localhost:3306/school";

try (Connection conn = DriverManager.getConnection(url, "root", "pass");
     Statement stmt = conn.createStatement();
     ResultSet rs = stmt.executeQuery("SELECT * FROM students")) {
    
    while (rs.next()) {
        System.out.println(rs.getInt("id") + " - " + rs.getString("name"));
    }
    
} catch (SQLException e) {
    System.out.println("Error: " + e.getMessage());
}
```

---

## 12.4 CRUD Operations

### CREATE (Insert)

```java
String sql = "INSERT INTO students (name, age, gpa) VALUES ('Alice', 20, 3.8)";
int rowsAffected = stmt.executeUpdate(sql);
System.out.println(rowsAffected + " row(s) inserted.");
```

### READ (Select)

```java
ResultSet rs = stmt.executeQuery("SELECT * FROM students WHERE gpa > 3.5");
while (rs.next()) {
    System.out.println(rs.getString("name") + ": " + rs.getDouble("gpa"));
}
```

### UPDATE

```java
String sql = "UPDATE students SET gpa = 3.9 WHERE name = 'Alice'";
int rowsAffected = stmt.executeUpdate(sql);
System.out.println(rowsAffected + " row(s) updated.");
```

### DELETE

```java
String sql = "DELETE FROM students WHERE id = 5";
int rowsAffected = stmt.executeUpdate(sql);
System.out.println(rowsAffected + " row(s) deleted.");
```

### executeQuery vs executeUpdate

| Method | Used For | Returns |
|--------|----------|---------|
| `executeQuery()` | SELECT | ResultSet |
| `executeUpdate()` | INSERT, UPDATE, DELETE, DDL | int (rows affected) |

---

## 12.5 PreparedStatement

### Why PreparedStatement?
1. **Prevents SQL Injection** (security!)
2. **Better performance** (precompiled)
3. **Cleaner code** (parameterized)

### SQL Injection Problem

```java
// DANGEROUS — user input directly in SQL!
String name = userInput;  // What if: "'; DROP TABLE students; --"
String sql = "SELECT * FROM students WHERE name = '" + name + "'";
// This becomes: SELECT * FROM students WHERE name = ''; DROP TABLE students; --'
// TABLE DELETED!
```

### Safe with PreparedStatement

```java
// INSERT
String sql = "INSERT INTO students (name, age, gpa) VALUES (?, ?, ?)";
try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
    pstmt.setString(1, "Bob");     // 1st ?
    pstmt.setInt(2, 22);           // 2nd ?
    pstmt.setDouble(3, 3.6);      // 3rd ?
    
    int rows = pstmt.executeUpdate();
    System.out.println(rows + " row inserted.");
}

// SELECT with parameter
String sql2 = "SELECT * FROM students WHERE gpa >= ?";
try (PreparedStatement pstmt = conn.prepareStatement(sql2)) {
    pstmt.setDouble(1, 3.5);
    
    ResultSet rs = pstmt.executeQuery();
    while (rs.next()) {
        System.out.println(rs.getString("name") + ": " + rs.getDouble("gpa"));
    }
}

// UPDATE
String sql3 = "UPDATE students SET gpa = ? WHERE name = ?";
try (PreparedStatement pstmt = conn.prepareStatement(sql3)) {
    pstmt.setDouble(1, 3.95);
    pstmt.setString(2, "Alice");
    pstmt.executeUpdate();
}
```

### Batch Operations

```java
String sql = "INSERT INTO students (name, age, gpa) VALUES (?, ?, ?)";
try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
    
    String[][] data = {{"Alice", "20", "3.8"}, {"Bob", "22", "3.5"}, {"Charlie", "21", "3.9"}};
    
    for (String[] row : data) {
        pstmt.setString(1, row[0]);
        pstmt.setInt(2, Integer.parseInt(row[1]));
        pstmt.setDouble(3, Double.parseDouble(row[2]));
        pstmt.addBatch();
    }
    
    int[] results = pstmt.executeBatch();
    System.out.println("Inserted " + results.length + " rows in batch.");
}
```

---

## 12.6 Practice & Assessment

### MCQs

**Q1.** Which prevents SQL injection?
- A) Statement
- B) PreparedStatement
- C) ResultSet
- D) DriverManager

**Answer:** B — PreparedStatement uses parameterized queries.

---

**Q2.** `executeQuery()` returns:
- A) int
- B) boolean
- C) ResultSet
- D) void

**Answer:** C

---

**Q3.** The correct JDBC URL format for MySQL is:
- A) `mysql://localhost/db`
- B) `jdbc:mysql://localhost:3306/db`
- C) `jdbc://mysql:3306/db`
- D) `http://localhost:3306/db`

**Answer:** B

---

### Coding Task

**Task:** Write a complete Java program that:
1. Connects to a database
2. Creates a `products` table
3. Inserts 3 products
4. Reads and displays all products
5. Updates a product price
6. Deletes a product

```java
import java.sql.*;

public class ProductCRUD {
    private static final String URL = "jdbc:mysql://localhost:3306/shop";
    private static final String USER = "root";
    private static final String PASS = "password";
    
    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS)) {
            
            // Create table
            try (Statement stmt = conn.createStatement()) {
                stmt.executeUpdate(
                    "CREATE TABLE IF NOT EXISTS products (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "name VARCHAR(50), " +
                    "price DOUBLE)"
                );
            }
            
            // Insert
            String insertSql = "INSERT INTO products (name, price) VALUES (?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                String[][] items = {{"Laptop", "999.99"}, {"Phone", "699.99"}, {"Tablet", "399.99"}};
                for (String[] item : items) {
                    ps.setString(1, item[0]);
                    ps.setDouble(2, Double.parseDouble(item[1]));
                    ps.executeUpdate();
                }
            }
            
            // Read
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM products")) {
                while (rs.next()) {
                    System.out.printf("%d | %-10s | $%.2f%n",
                        rs.getInt("id"), rs.getString("name"), rs.getDouble("price"));
                }
            }
            
            // Update
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE products SET price = ? WHERE name = ?")) {
                ps.setDouble(1, 899.99);
                ps.setString(2, "Laptop");
                ps.executeUpdate();
            }
            
            // Delete
            try (PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM products WHERE name = ?")) {
                ps.setString(1, "Tablet");
                ps.executeUpdate();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

---

> **Next Topic:** [13 - Java Swing](13-java-swing.md)
