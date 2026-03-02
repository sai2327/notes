# 🗄️ JDBC and MySQL Connector

> **Complete guide to connecting Java with MySQL — from basics to full CRUD applications.**

---

## Table of Contents

- [Database Basics](#database-basics)
- [What is JDBC?](#what-is-jdbc)
- [JDBC Architecture](#jdbc-architecture)
- [JDBC Drivers](#jdbc-drivers)
- [MySQL Connector Setup](#mysql-connector-setup)
- [Steps to Connect Java to MySQL](#steps-to-connect-java-to-mysql)
- [CRUD Operations](#crud-operations)
  - [Insert (CREATE)](#insert-create)
  - [Select (READ)](#select-read)
  - [Update (UPDATE)](#update-update)
  - [Delete (DELETE)](#delete-delete)
- [PreparedStatement](#preparedstatement)
- [CallableStatement](#callablestatement)
- [Transaction Management](#transaction-management)
- [Connection Pooling](#connection-pooling)
- [Complete CRUD Project](#complete-crud-project)
- [Practice Sections](#practice-sections)

---

# Database Basics

## What is a Database?

A **database** is an organized collection of structured data stored electronically. A **Relational Database (RDBMS)** stores data in **tables** with rows and columns.

### Key Terms

| Term | Meaning |
|------|---------|
| **Database** | Collection of related tables |
| **Table** | Structured data in rows and columns |
| **Row (Record)** | One entry/instance of data |
| **Column (Field)** | One attribute of data |
| **Primary Key** | Unique identifier for each row |
| **Foreign Key** | Links two tables together |
| **SQL** | Structured Query Language — language to interact with databases |
| **CRUD** | Create, Read, Update, Delete |

### Sample Table: `students`

```
┌─────┬──────────┬─────┬───────────────────┬───────┐
│ id  │   name   │ age │      email        │ marks │
├─────┼──────────┼─────┼───────────────────┼───────┤
│  1  │  Alice   │  20 │ alice@mail.com    │  85   │
│  2  │  Bob     │  21 │ bob@mail.com      │  92   │
│  3  │  Charlie │  19 │ charlie@mail.com  │  78   │
└─────┴──────────┴─────┴───────────────────┴───────┘
```

### Essential SQL Commands

```sql
-- Create database
CREATE DATABASE school;
USE school;

-- Create table
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT,
    email VARCHAR(100) UNIQUE,
    marks DOUBLE
);

-- Insert
INSERT INTO students (name, age, email, marks) VALUES ('Alice', 20, 'alice@mail.com', 85);

-- Select
SELECT * FROM students;
SELECT name, marks FROM students WHERE marks > 80;

-- Update
UPDATE students SET marks = 90 WHERE id = 1;

-- Delete
DELETE FROM students WHERE id = 3;
```

---

# What is JDBC?

## Concept Explanation

**JDBC (Java Database Connectivity)** is a Java API that enables Java programs to interact with relational databases. It provides a standard interface for connecting to databases, executing SQL queries, and processing results.

### Key Points

- JDBC is part of `java.sql` and `javax.sql` packages
- It is **database-independent** — same Java code can work with MySQL, PostgreSQL, Oracle, etc.
- You need a **JDBC Driver** specific to your database
- JDBC is a **specification** (interfaces), not an implementation

### Why Use JDBC?

```
Java Application  →  JDBC API  →  JDBC Driver  →  Database
     (Your code)     (Standard)    (Vendor-specific)  (MySQL, etc.)
```

- Write once, connect to any database by changing the driver
- Supports SQL queries, stored procedures, transactions
- Secure with PreparedStatement (prevents SQL injection)

---

# JDBC Architecture

## Visual Diagram

```
┌──────────────────────────────────────────────────────────────┐
│                     Java Application                          │
│              (Your Java code with SQL queries)                │
├──────────────────────────────────────────────────────────────┤
│                        JDBC API                               │
│    (java.sql.Connection, Statement, ResultSet, etc.)         │
├──────────────────────────────────────────────────────────────┤
│                    JDBC Driver Manager                        │
│            (Manages database drivers)                         │
├──────────────────────────────────────────────────────────────┤
│                      JDBC Driver                              │
│          (MySQL Connector/J, Oracle JDBC, etc.)              │
├──────────────────────────────────────────────────────────────┤
│                       Database                                │
│              (MySQL, PostgreSQL, Oracle, etc.)               │
└──────────────────────────────────────────────────────────────┘
```

### Key JDBC Interfaces and Classes

| Interface/Class | Package | Purpose |
|----------------|---------|---------|
| `DriverManager` | `java.sql` | Manages JDBC drivers, creates connections |
| `Connection` | `java.sql` | Represents a database connection |
| `Statement` | `java.sql` | Executes static SQL queries |
| `PreparedStatement` | `java.sql` | Executes parameterized SQL (secure) |
| `CallableStatement` | `java.sql` | Calls stored procedures |
| `ResultSet` | `java.sql` | Holds query results (rows & columns) |
| `SQLException` | `java.sql` | Database error handling |
| `ResultSetMetaData` | `java.sql` | Information about ResultSet columns |

---

# JDBC Drivers

## Concept Explanation

A **JDBC Driver** translates JDBC calls into database-specific protocol calls.

### Types of JDBC Drivers

| Type | Name | Description | Performance |
|------|------|-------------|-------------|
| Type 1 | JDBC-ODBC Bridge | Uses ODBC driver (deprecated Java 8+) | Slow |
| Type 2 | Native-API | Uses native DB client library | Medium |
| Type 3 | Network Protocol | Middleware translates calls | Medium |
| Type 4 | Thin Driver | Pure Java, direct DB protocol | **Fast** ✅ |

> **MySQL Connector/J** is a **Type 4** (pure Java) driver. Always use Type 4 when available.

### Visual

```
Type 4 (Thin Driver) — Most Common:
┌──────────┐    ┌──────────────┐    ┌──────────┐
│  Java    │───►│ JDBC Driver  │───►│ Database │
│  App     │    │ (Pure Java)  │    │ (MySQL)  │
└──────────┘    └──────────────┘    └──────────┘
     No intermediate layers — fastest!
```

---

# MySQL Connector Setup

## Step-by-Step Setup

### Step 1: Install MySQL

1. Download MySQL from [mysql.com](https://dev.mysql.com/downloads/)
2. Install MySQL Server and MySQL Workbench
3. Set root password during installation
4. Start MySQL service

### Step 2: Download MySQL Connector/J

1. Go to [MySQL Connector/J Downloads](https://dev.mysql.com/downloads/connector/j/)
2. Download the **Platform Independent** ZIP file
3. Extract to get `mysql-connector-j-x.x.x.jar`

### Step 3: Add to Project

**Option A — Command Line:**
```bash
# Compile
javac -cp ".;mysql-connector-j-8.0.33.jar" YourProgram.java

# Run
java -cp ".;mysql-connector-j-8.0.33.jar" YourProgram
```

**Option B — IDE (IntelliJ/Eclipse):**
1. Right-click project → Build Path → Add External JARs
2. Select the `mysql-connector-j-x.x.x.jar` file
3. Apply

**Option C — Maven (pom.xml):**
```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>
```

### Step 3: Create Test Database

```sql
-- Open MySQL Workbench or command line
CREATE DATABASE java_demo;
USE java_demo;

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT,
    email VARCHAR(100),
    marks DOUBLE
);

-- Insert sample data
INSERT INTO students (name, age, email, marks) VALUES
('Alice', 20, 'alice@mail.com', 85.5),
('Bob', 21, 'bob@mail.com', 92.0),
('Charlie', 19, 'charlie@mail.com', 78.3);
```

---

# Steps to Connect Java to MySQL

## The 6 Steps

```
Step 1: Load Driver          → Class.forName("com.mysql.cj.jdbc.Driver")
Step 2: Establish Connection  → DriverManager.getConnection(url, user, pass)
Step 3: Create Statement      → connection.createStatement()
Step 4: Execute Query         → statement.executeQuery(sql) / executeUpdate(sql)
Step 5: Process Result        → resultSet.next(), getString(), getInt()
Step 6: Close Connection      → Close ResultSet, Statement, Connection
```

### Visual Flow

```
┌─────────────┐
│ Load Driver  │  Class.forName(...)
└──────┬───────┘
       ▼
┌──────────────────┐
│ Get Connection   │  DriverManager.getConnection(url, user, pass)
└──────┬───────────┘
       ▼
┌──────────────────┐
│ Create Statement │  conn.createStatement() / conn.prepareStatement()
└──────┬───────────┘
       ▼
┌──────────────────┐
│ Execute Query    │  stmt.executeQuery() / executeUpdate()
└──────┬───────────┘
       ▼
┌──────────────────┐
│ Process Result   │  while(rs.next()) { rs.getString("col"); }
└──────┬───────────┘
       ▼
┌──────────────────┐
│ Close Resources  │  rs.close(); stmt.close(); conn.close();
└──────────────────┘
```

### Complete Example — First Connection

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

public class FirstJDBCConnection {
    public static void main(String[] args) {

        // Database connection details
        String url = "jdbc:mysql://localhost:3306/java_demo";
        String user = "root";
        String password = "your_password";  // Change to your MySQL password

        // Step 1: Load Driver (optional in JDBC 4.0+ with service provider)
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ Driver loaded successfully!");
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Driver not found: " + e.getMessage());
            return;
        }

        // Step 2-6 using try-with-resources (auto-closes)
        try (
            // Step 2: Establish Connection
            Connection conn = DriverManager.getConnection(url, user, password);
        ) {
            System.out.println("✅ Connected to database!");

            // Step 3: Create Statement
            Statement stmt = conn.createStatement();

            // Step 4: Execute Query
            String sql = "SELECT * FROM students";
            ResultSet rs = stmt.executeQuery(sql);

            // Step 5: Process Result
            System.out.println("\n--- Student Records ---");
            System.out.printf("%-5s %-15s %-5s %-25s %-8s%n",
                    "ID", "Name", "Age", "Email", "Marks");
            System.out.println("-".repeat(60));

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int age = rs.getInt("age");
                String email = rs.getString("email");
                double marks = rs.getDouble("marks");

                System.out.printf("%-5d %-15s %-5d %-25s %-8.1f%n",
                        id, name, age, email, marks);
            }

            // Step 6: Close Resources (auto-closed by try-with-resources)
            rs.close();
            stmt.close();

        } catch (SQLException e) {
            System.out.println("❌ Database error: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
        }
    }
}
```

### Output

```
✅ Driver loaded successfully!
✅ Connected to database!

--- Student Records ---
ID    Name            Age   Email                     Marks
------------------------------------------------------------
1     Alice           20    alice@mail.com            85.5
2     Bob             21    bob@mail.com              92.0
3     Charlie         19    charlie@mail.com          78.3
```

### Connection URL Format

```
jdbc:mysql://hostname:port/database_name?parameters

Examples:
jdbc:mysql://localhost:3306/mydb
jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC
jdbc:mysql://192.168.1.100:3306/production_db
```

### Common Connection Parameters

| Parameter | Purpose | Example |
|-----------|---------|---------|
| `useSSL` | Enable/disable SSL | `useSSL=false` |
| `serverTimezone` | Set timezone | `serverTimezone=UTC` |
| `autoReconnect` | Auto-reconnect | `autoReconnect=true` |
| `useUnicode` | Support unicode | `useUnicode=true` |
| `characterEncoding` | Set encoding | `characterEncoding=utf8` |

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Wrong URL format | `jdbc:mysql://localhost:3306/dbname` |
| MySQL service not running | Start MySQL service |
| Wrong credentials | Check username/password |
| JAR not in classpath | Add connector JAR to build path |
| `ClassNotFoundException` | Driver JAR missing from classpath |
| `CommunicationsException` | MySQL server not running or wrong port |

### Quick Revision – JDBC Connection

```
┌────────────────────────────────────────────────────────────┐
│ JDBC CONNECTION STEPS                                       │
├────────────────────────────────────────────────────────────┤
│ 1. Load Driver: Class.forName("com.mysql.cj.jdbc.Driver") │
│ 2. Connect: DriverManager.getConnection(url, user, pass)  │
│ 3. Create: conn.createStatement()                          │
│ 4. Execute: stmt.executeQuery() / executeUpdate()          │
│ 5. Process: while(rs.next()) { rs.getXxx("col"); }        │
│ 6. Close: rs.close(); stmt.close(); conn.close();         │
│                                                             │
│ • Use try-with-resources for automatic closing             │
│ • URL: jdbc:mysql://localhost:3306/dbname                  │
│ • MySQL Connector/J = Type 4 (pure Java) driver           │
└────────────────────────────────────────────────────────────┘
```

---

# CRUD Operations

## Database Helper Class

Create a reusable helper for database connections:

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBHelper {
    private static final String URL = "jdbc:mysql://localhost:3306/java_demo";
    private static final String USER = "root";
    private static final String PASSWORD = "your_password";

    // Get database connection
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Static block to load driver once
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found!", e);
        }
    }
}
```

---

## Insert (CREATE)

### Using Statement

```java
import java.sql.*;

public class InsertDemo {
    public static void main(String[] args) {
        String sql = "INSERT INTO students (name, age, email, marks) " +
                     "VALUES ('Diana', 22, 'diana@mail.com', 88.5)";

        try (Connection conn = DBHelper.getConnection();
             Statement stmt = conn.createStatement()) {

            int rowsAffected = stmt.executeUpdate(sql);
            System.out.println(rowsAffected + " row(s) inserted!");

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

### Using PreparedStatement (Recommended)

```java
import java.sql.*;

public class InsertPrepared {
    public static void main(String[] args) {
        String sql = "INSERT INTO students (name, age, email, marks) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // Set parameters (1-indexed)
            pstmt.setString(1, "Eve");
            pstmt.setInt(2, 23);
            pstmt.setString(3, "eve@mail.com");
            pstmt.setDouble(4, 91.0);

            int rows = pstmt.executeUpdate();
            System.out.println(rows + " row(s) inserted!");

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

### Insert with Auto-Generated Key

```java
import java.sql.*;

public class InsertGetKey {
    public static void main(String[] args) {
        String sql = "INSERT INTO students (name, age, email, marks) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, "Frank");
            pstmt.setInt(2, 24);
            pstmt.setString(3, "frank@mail.com");
            pstmt.setDouble(4, 76.0);

            pstmt.executeUpdate();

            // Get generated ID
            ResultSet keys = pstmt.getGeneratedKeys();
            if (keys.next()) {
                System.out.println("Inserted with ID: " + keys.getInt(1));
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

### Batch Insert (Insert Multiple Rows)

```java
import java.sql.*;

public class BatchInsert {
    public static void main(String[] args) {
        String sql = "INSERT INTO students (name, age, email, marks) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // Disable auto-commit for batch performance
            conn.setAutoCommit(false);

            String[][] students = {
                {"Grace", "20", "grace@mail.com", "88.0"},
                {"Henry", "21", "henry@mail.com", "79.5"},
                {"Ivy", "22", "ivy@mail.com", "94.0"}
            };

            for (String[] s : students) {
                pstmt.setString(1, s[0]);
                pstmt.setInt(2, Integer.parseInt(s[1]));
                pstmt.setString(3, s[2]);
                pstmt.setDouble(4, Double.parseDouble(s[3]));
                pstmt.addBatch();  // Add to batch
            }

            int[] results = pstmt.executeBatch();  // Execute all at once
            conn.commit();  // Commit transaction

            System.out.println("Batch insert complete! Rows inserted: " + results.length);

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

---

## Select (READ)

### Select All Records

```java
import java.sql.*;

public class SelectAll {
    public static void main(String[] args) {
        String sql = "SELECT * FROM students";

        try (Connection conn = DBHelper.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.printf("%-5s %-15s %-5s %-25s %-8s%n",
                    "ID", "Name", "Age", "Email", "Marks");
            System.out.println("=".repeat(60));

            while (rs.next()) {
                System.out.printf("%-5d %-15s %-5d %-25s %-8.1f%n",
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("age"),
                        rs.getString("email"),
                        rs.getDouble("marks"));
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

### Select with Conditions (PreparedStatement)

```java
import java.sql.*;

public class SelectWhere {
    public static void main(String[] args) {
        // Find students with marks above threshold
        String sql = "SELECT * FROM students WHERE marks >= ? ORDER BY marks DESC";

        try (Connection conn = DBHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDouble(1, 80.0);  // Marks > 80
            ResultSet rs = pstmt.executeQuery();

            System.out.println("Students with marks >= 80:");
            while (rs.next()) {
                System.out.println(rs.getString("name") + " - " + rs.getDouble("marks"));
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

### Select Single Record

```java
import java.sql.*;

public class SelectById {
    public static void findStudent(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";

        try (Connection conn = DBHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                System.out.println("Found: " + rs.getString("name") +
                        ", Age: " + rs.getInt("age") +
                        ", Marks: " + rs.getDouble("marks"));
            } else {
                System.out.println("Student with ID " + id + " not found!");
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        findStudent(1);  // Find student with ID 1
        findStudent(99); // Non-existent
    }
}
```

### ResultSet Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `next()` | boolean | Move to next row |
| `previous()` | boolean | Move to previous row |
| `first()` | boolean | Move to first row |
| `last()` | boolean | Move to last row |
| `getInt(col)` | int | Get integer value |
| `getString(col)` | String | Get string value |
| `getDouble(col)` | double | Get double value |
| `getDate(col)` | Date | Get date value |
| `getTimestamp(col)` | Timestamp | Get timestamp |
| `wasNull()` | boolean | Check if last get was NULL |

> Column can be specified by **name** (`"age"`) or **index** (`2` — 1-based).

---

## Update (UPDATE)

```java
import java.sql.*;

public class UpdateDemo {
    public static void updateMarks(int id, double newMarks) {
        String sql = "UPDATE students SET marks = ? WHERE id = ?";

        try (Connection conn = DBHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDouble(1, newMarks);
            pstmt.setInt(2, id);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Updated! " + rows + " row(s) affected.");
            } else {
                System.out.println("No student found with ID " + id);
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        updateMarks(1, 95.0);  // Update Alice's marks to 95
        updateMarks(99, 50.0); // Non-existent ID
    }
}
```

---

## Delete (DELETE)

```java
import java.sql.*;

public class DeleteDemo {
    public static void deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE id = ?";

        try (Connection conn = DBHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("Deleted! " + rows + " row(s) removed.");
            } else {
                System.out.println("No student found with ID " + id);
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        deleteStudent(3); // Delete Charlie
    }
}
```

---

### Quick Revision – CRUD Operations

```
┌────────────────────────────────────────────────────────────┐
│ CRUD SUMMARY                                                │
├────────────────────────────────────────────────────────────┤
│ CREATE → INSERT INTO table VALUES (...)                    │
│ READ   → SELECT * FROM table WHERE ...                     │
│ UPDATE → UPDATE table SET col=? WHERE id=?                 │
│ DELETE → DELETE FROM table WHERE id=?                      │
│                                                             │
│ executeQuery() → For SELECT (returns ResultSet)            │
│ executeUpdate() → For INSERT/UPDATE/DELETE (returns int)   │
│                                                             │
│ Always use PreparedStatement (not Statement):              │
│  ✅ Prevents SQL injection                                 │
│  ✅ Better performance (precompiled)                       │
│  ✅ Handles special characters automatically               │
└────────────────────────────────────────────────────────────┘
```

---

# PreparedStatement

## Concept Explanation

`PreparedStatement` is a **precompiled SQL statement** that uses **placeholders (?)** for parameters. It's the **recommended** way to execute SQL in Java.

### Why Use PreparedStatement?

| Feature | Statement | PreparedStatement |
|---------|-----------|-------------------|
| SQL Injection | ❌ Vulnerable | ✅ Safe |
| Performance | Compiled each time | Compiled once, reused |
| Parameters | String concatenation | Set methods (type-safe) |
| Special characters | Must escape manually | Handled automatically |
| Readability | Messy with concatenation | Clean with placeholders |

### SQL Injection Example

```java
// ❌ VULNERABLE — Statement with string concatenation
String userInput = "'; DROP TABLE students; --";
String sql = "SELECT * FROM students WHERE name = '" + userInput + "'";
// Executed SQL: SELECT * FROM students WHERE name = ''; DROP TABLE students; --'
// 💀 YOUR TABLE IS DELETED!

// ✅ SAFE — PreparedStatement with parameters
String sql = "SELECT * FROM students WHERE name = ?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, userInput);
// The malicious input is treated as a literal string, not SQL code
```

### Visual Comparison

```
Statement (Dangerous):
"SELECT * FROM users WHERE name = '" + input + "'"
                                         ↑
                              Input: '; DROP TABLE users; --
                              Result: SQL INJECTION! 💀

PreparedStatement (Safe):
"SELECT * FROM users WHERE name = ?"
                                  ↑
                      Parameter set safely → treated as data, not SQL
```

### Setter Methods

| Method | SQL Type | Java Type |
|--------|----------|-----------|
| `setInt(index, value)` | INT | int |
| `setString(index, value)` | VARCHAR/TEXT | String |
| `setDouble(index, value)` | DOUBLE | double |
| `setFloat(index, value)` | FLOAT | float |
| `setLong(index, value)` | BIGINT | long |
| `setBoolean(index, value)` | BOOLEAN | boolean |
| `setDate(index, value)` | DATE | java.sql.Date |
| `setTimestamp(index, value)` | TIMESTAMP | java.sql.Timestamp |
| `setNull(index, sqlType)` | NULL | null |
| `setObject(index, value)` | Any | Object |

### Complete PreparedStatement Example

```java
import java.sql.*;

public class PreparedStatementDemo {
    public static void main(String[] args) {
        try (Connection conn = DBHelper.getConnection()) {

            // INSERT
            String insertSQL = "INSERT INTO students (name, age, email, marks) VALUES (?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(insertSQL)) {
                pstmt.setString(1, "Test Student");
                pstmt.setInt(2, 20);
                pstmt.setString(3, "test@mail.com");
                pstmt.setDouble(4, 85.5);
                pstmt.executeUpdate();
                System.out.println("Inserted successfully!");
            }

            // SELECT with LIKE
            String searchSQL = "SELECT * FROM students WHERE name LIKE ?";
            try (PreparedStatement pstmt = conn.prepareStatement(searchSQL)) {
                pstmt.setString(1, "%A%");  // Names containing 'A'
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    System.out.println(rs.getString("name") + " - " + rs.getDouble("marks"));
                }
            }

            // UPDATE multiple columns
            String updateSQL = "UPDATE students SET age = ?, marks = ? WHERE name = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(updateSQL)) {
                pstmt.setInt(1, 25);
                pstmt.setDouble(2, 95.0);
                pstmt.setString(3, "Alice");
                int updated = pstmt.executeUpdate();
                System.out.println("Updated " + updated + " row(s)");
            }

            // SELECT with multiple conditions
            String filterSQL = "SELECT * FROM students WHERE age >= ? AND marks >= ? ORDER BY marks DESC";
            try (PreparedStatement pstmt = conn.prepareStatement(filterSQL)) {
                pstmt.setInt(1, 20);
                pstmt.setDouble(2, 80);
                ResultSet rs = pstmt.executeQuery();
                System.out.println("\nStudents (age >= 20, marks >= 80):");
                while (rs.next()) {
                    System.out.printf("  %s, Age: %d, Marks: %.1f%n",
                            rs.getString("name"), rs.getInt("age"), rs.getDouble("marks"));
                }
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

### Interview Tip
- **Always use PreparedStatement** — never concatenate user input into SQL
- Index starts at **1** (not 0)
- Same PreparedStatement object can be reused with different parameters
- `clearParameters()` resets all set values

---

# CallableStatement

## Concept Explanation

`CallableStatement` is used to call **stored procedures** and **functions** from the database.

### Create a Stored Procedure in MySQL

```sql
-- Stored Procedure: Get student by ID
DELIMITER //
CREATE PROCEDURE GetStudentById(IN studentId INT)
BEGIN
    SELECT * FROM students WHERE id = studentId;
END //
DELIMITER ;

-- Stored Procedure: Add student (with output parameter)
DELIMITER //
CREATE PROCEDURE AddStudent(
    IN p_name VARCHAR(100),
    IN p_age INT,
    IN p_email VARCHAR(100),
    IN p_marks DOUBLE,
    OUT p_id INT
)
BEGIN
    INSERT INTO students (name, age, email, marks) VALUES (p_name, p_age, p_email, p_marks);
    SET p_id = LAST_INSERT_ID();
END //
DELIMITER ;

-- Stored Function: Get average marks
DELIMITER //
CREATE FUNCTION GetAverageMarks() RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE avg_marks DOUBLE;
    SELECT AVG(marks) INTO avg_marks FROM students;
    RETURN avg_marks;
END //
DELIMITER ;
```

### Java Code — Call Stored Procedure

```java
import java.sql.*;

public class CallableStatementDemo {
    public static void main(String[] args) {
        try (Connection conn = DBHelper.getConnection()) {

            // 1. Call procedure with IN parameter
            System.out.println("--- Get Student By ID ---");
            try (CallableStatement cstmt = conn.prepareCall("{CALL GetStudentById(?)}")) {
                cstmt.setInt(1, 1);
                ResultSet rs = cstmt.executeQuery();
                while (rs.next()) {
                    System.out.println(rs.getString("name") + " - " + rs.getDouble("marks"));
                }
            }

            // 2. Call procedure with IN and OUT parameters
            System.out.println("\n--- Add Student ---");
            try (CallableStatement cstmt = conn.prepareCall("{CALL AddStudent(?, ?, ?, ?, ?)}")) {
                // Set IN parameters
                cstmt.setString(1, "Zara");
                cstmt.setInt(2, 21);
                cstmt.setString(3, "zara@mail.com");
                cstmt.setDouble(4, 89.5);

                // Register OUT parameter
                cstmt.registerOutParameter(5, Types.INTEGER);

                cstmt.executeUpdate();

                // Get OUT parameter value
                int newId = cstmt.getInt(5);
                System.out.println("New student added with ID: " + newId);
            }

            // 3. Call stored function
            System.out.println("\n--- Average Marks ---");
            try (CallableStatement cstmt = conn.prepareCall("{? = CALL GetAverageMarks()}")) {
                cstmt.registerOutParameter(1, Types.DOUBLE);
                cstmt.execute();
                System.out.println("Average marks: " + cstmt.getDouble(1));
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

### Statement Types Comparison

| Feature | Statement | PreparedStatement | CallableStatement |
|---------|-----------|-------------------|-------------------|
| Purpose | Simple SQL | Parameterized SQL | Stored procedures |
| SQL Injection | Vulnerable | Safe | Safe |
| Precompiled | No | Yes | Yes |
| Parameters | No | IN only | IN, OUT, INOUT |
| Performance | Slowest | Fast | Fast |
| Use Case | Static queries | Dynamic queries | DB procedures |

---

# Transaction Management

## Concept Explanation

A **transaction** is a set of SQL operations that must **all succeed or all fail** (atomicity). If any operation fails, all changes are **rolled back**.

### ACID Properties

| Property | Meaning |
|----------|---------|
| **Atomicity** | All or nothing — complete success or complete rollback |
| **Consistency** | Database moves from one valid state to another |
| **Isolation** | Concurrent transactions don't interfere |
| **Durability** | Committed changes survive system failures |

### Visual

```
┌─────────────────────────────────────────────┐
│              TRANSACTION                     │
│                                              │
│  conn.setAutoCommit(false);                  │
│                                              │
│  ┌──────────────────────┐                    │
│  │ Debit from Account A │  ← SQL 1          │
│  └──────────┬───────────┘                    │
│             │                                │
│  ┌──────────▼───────────┐                    │
│  │ Credit to Account B  │  ← SQL 2          │
│  └──────────┬───────────┘                    │
│             │                                │
│      Success? ─── Yes ──► conn.commit();     │
│         │                                    │
│         No ──────────────► conn.rollback();  │
│                                              │
└─────────────────────────────────────────────┘
```

### Example Code — Bank Transfer

```java
import java.sql.*;

public class TransactionDemo {
    public static void main(String[] args) {
        // Setup: Create accounts table first
        // CREATE TABLE accounts (id INT PRIMARY KEY, name VARCHAR(50), balance DOUBLE);
        // INSERT INTO accounts VALUES (1, 'Alice', 1000), (2, 'Bob', 500);

        Connection conn = null;

        try {
            conn = DBHelper.getConnection();

            // Disable auto-commit — start transaction
            conn.setAutoCommit(false);

            double transferAmount = 200.0;

            // Step 1: Debit from Alice
            PreparedStatement debit = conn.prepareStatement(
                    "UPDATE accounts SET balance = balance - ? WHERE id = ? AND balance >= ?");
            debit.setDouble(1, transferAmount);
            debit.setInt(2, 1);  // Alice's ID
            debit.setDouble(3, transferAmount);  // Ensure sufficient balance

            int debitRows = debit.executeUpdate();
            if (debitRows == 0) {
                throw new SQLException("Insufficient balance!");
            }

            // Step 2: Credit to Bob
            PreparedStatement credit = conn.prepareStatement(
                    "UPDATE accounts SET balance = balance + ? WHERE id = ?");
            credit.setDouble(1, transferAmount);
            credit.setInt(2, 2);  // Bob's ID

            int creditRows = credit.executeUpdate();
            if (creditRows == 0) {
                throw new SQLException("Credit account not found!");
            }

            // Both successful — commit transaction
            conn.commit();
            System.out.println("✅ Transfer successful! $" + transferAmount + " sent.");

            // Show updated balances
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM accounts");
            while (rs.next()) {
                System.out.printf("%s: $%.2f%n", rs.getString("name"), rs.getDouble("balance"));
            }

        } catch (SQLException e) {
            System.out.println("❌ Transfer failed: " + e.getMessage());
            // Rollback on error
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("Transaction rolled back!");
                } catch (SQLException ex) {
                    System.out.println("Rollback failed: " + ex.getMessage());
                }
            }
        } finally {
            // Restore auto-commit and close
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
```

### Savepoints

```java
import java.sql.*;

public class SavepointDemo {
    public static void main(String[] args) {
        try (Connection conn = DBHelper.getConnection()) {
            conn.setAutoCommit(false);

            Statement stmt = conn.createStatement();

            // Operation 1
            stmt.executeUpdate("INSERT INTO students (name, age, email, marks) VALUES ('X', 20, 'x@mail.com', 80)");

            // Create savepoint after first insert
            Savepoint sp1 = conn.setSavepoint("after_first_insert");

            // Operation 2 (might fail)
            try {
                stmt.executeUpdate("INSERT INTO students (name, age, email, marks) VALUES ('Y', 21, 'x@mail.com', 90)");
                // ↑ This might fail if email is UNIQUE (duplicate with X)
            } catch (SQLException e) {
                System.out.println("Operation 2 failed, rolling back to savepoint");
                conn.rollback(sp1);  // Only rollback Operation 2
            }

            // Commit Operation 1 (still valid)
            conn.commit();
            System.out.println("Transaction committed (at least Operation 1)");

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

### Transaction Methods

| Method | Description |
|--------|-------------|
| `setAutoCommit(false)` | Start manual transaction |
| `commit()` | Save all changes permanently |
| `rollback()` | Undo all changes since last commit |
| `setSavepoint(name)` | Create a named savepoint |
| `rollback(savepoint)` | Rollback to specific savepoint |
| `setAutoCommit(true)` | Restore default (each SQL auto-commits) |

### Quick Revision – Transactions

```
┌────────────────────────────────────────────────────────────┐
│ TRANSACTION MANAGEMENT                                      │
├────────────────────────────────────────────────────────────┤
│ • Transaction = Group of SQL ops (all succeed or all fail) │
│ • ACID: Atomicity, Consistency, Isolation, Durability      │
│ • setAutoCommit(false) to start manual transaction         │
│ • commit() to save, rollback() to undo                     │
│ • Use Savepoints for partial rollback                      │
│ • Always rollback in catch block                           │
│ • Always restore autoCommit in finally block               │
│ • Common use: bank transfers, inventory updates            │
└────────────────────────────────────────────────────────────┘
```

---

# Connection Pooling

## Concept Explanation

**Connection Pooling** maintains a **pool of reusable database connections** instead of creating a new connection for every request. This dramatically improves performance.

### Why Connection Pooling?

```
Without Pooling:                        With Pooling:
Request 1 → Create conn → Close        Request 1 → Borrow conn → Return
Request 2 → Create conn → Close        Request 2 → Borrow conn → Return
Request 3 → Create conn → Close        Request 3 → Borrow conn → Return
  ↑ Slow! (connect/disconnect each time)   ↑ Fast! (reuse existing connections)
```

### Visual

```
┌──────────────────────────────────────────────┐
│              CONNECTION POOL                  │
│                                               │
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐        │
│  │Conn1│  │Conn2│  │Conn3│  │Conn4│  ...    │
│  │(busy)│ │(free)│ │(free)│ │(busy)│        │
│  └──┬──┘  └──┬──┘  └──┬──┘  └──┬──┘        │
│     │        │        │        │             │
├─────┼────────┼────────┼────────┼─────────────┤
│     ▼        ▼        ▼        ▼             │
│  App Thread  Available for    App Thread     │
│  using it    borrowing        using it       │
└──────────────────────────────────────────────┘
```

### Popular Connection Pool Libraries

| Library | Description |
|---------|-------------|
| **HikariCP** | Fastest, modern, most popular |
| **Apache DBCP** | Part of Apache Commons |
| **C3P0** | Older, mature library |
| **Tomcat JDBC Pool** | Built into Tomcat |

### HikariCP Example

**Maven dependency:**
```xml
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>5.0.1</version>
</dependency>
```

**Java code:**
```java
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.*;

public class ConnectionPoolDemo {
    private static HikariDataSource dataSource;

    // Initialize pool (call once at app startup)
    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:mysql://localhost:3306/java_demo");
        config.setUsername("root");
        config.setPassword("your_password");

        // Pool settings
        config.setMaximumPoolSize(10);       // Max 10 connections
        config.setMinimumIdle(2);            // Min 2 idle connections
        config.setConnectionTimeout(30000);  // 30 seconds timeout
        config.setIdleTimeout(600000);       // 10 minutes idle timeout

        dataSource = new HikariDataSource(config);
    }

    // Get connection from pool
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // Example usage
    public static void main(String[] args) {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM students")) {

            while (rs.next()) {
                System.out.println(rs.getString("name") + " - " + rs.getDouble("marks"));
            }
            // Connection returned to pool automatically (try-with-resources)

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

### Simple Connection Pool (Without Library)

```java
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SimpleConnectionPool {
    private static final int MAX_POOL_SIZE = 5;
    private static final String URL = "jdbc:mysql://localhost:3306/java_demo";
    private static final String USER = "root";
    private static final String PASS = "your_password";

    private static List<Connection> freeConnections = new ArrayList<>();
    private static List<Connection> usedConnections = new ArrayList<>();

    // Initialize pool
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            for (int i = 0; i < MAX_POOL_SIZE; i++) {
                freeConnections.add(DriverManager.getConnection(URL, USER, PASS));
            }
            System.out.println("Pool initialized with " + MAX_POOL_SIZE + " connections");
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize pool", e);
        }
    }

    // Borrow connection
    public static synchronized Connection getConnection() {
        if (freeConnections.isEmpty()) {
            throw new RuntimeException("No available connections!");
        }
        Connection conn = freeConnections.remove(freeConnections.size() - 1);
        usedConnections.add(conn);
        return conn;
    }

    // Return connection
    public static synchronized void releaseConnection(Connection conn) {
        usedConnections.remove(conn);
        freeConnections.add(conn);
    }

    // Pool status
    public static String getStatus() {
        return "Free: " + freeConnections.size() + " | Used: " + usedConnections.size();
    }

    public static void main(String[] args) throws SQLException {
        System.out.println("Status: " + getStatus());  // Free: 5, Used: 0

        Connection c1 = getConnection();
        Connection c2 = getConnection();
        System.out.println("Status: " + getStatus());  // Free: 3, Used: 2

        releaseConnection(c1);
        System.out.println("Status: " + getStatus());  // Free: 4, Used: 1

        releaseConnection(c2);
        System.out.println("Status: " + getStatus());  // Free: 5, Used: 0
    }
}
```

### Quick Revision – Connection Pooling

```
┌────────────────────────────────────────────────────────────┐
│ CONNECTION POOLING                                          │
├────────────────────────────────────────────────────────────┤
│ • Pool = reusable set of pre-created connections           │
│ • Avoids overhead of creating/destroying connections       │
│ • HikariCP = fastest and most popular pool library         │
│ • Key settings: maxPoolSize, minIdle, timeout              │
│ • Connection returned to pool on close (not destroyed)     │
│ • Always use try-with-resources for auto-return            │
│ • Production apps MUST use connection pooling              │
└────────────────────────────────────────────────────────────┘
```

---

# Complete CRUD Project

## Student Management System (Full Program)

```java
import java.sql.*;
import java.util.Scanner;

public class StudentManagement {

    // Database configuration
    private static final String URL = "jdbc:mysql://localhost:3306/java_demo";
    private static final String USER = "root";
    private static final String PASSWORD = "your_password";

    private static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // CREATE — Add student
    public static void addStudent(Scanner sc) {
        System.out.print("Enter name: ");
        String name = sc.nextLine();
        System.out.print("Enter age: ");
        int age = Integer.parseInt(sc.nextLine());
        System.out.print("Enter email: ");
        String email = sc.nextLine();
        System.out.print("Enter marks: ");
        double marks = Double.parseDouble(sc.nextLine());

        String sql = "INSERT INTO students (name, age, email, marks) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, name);
            pstmt.setInt(2, age);
            pstmt.setString(3, email);
            pstmt.setDouble(4, marks);

            pstmt.executeUpdate();

            ResultSet keys = pstmt.getGeneratedKeys();
            if (keys.next()) {
                System.out.println("✅ Student added with ID: " + keys.getInt(1));
            }

        } catch (SQLException e) {
            System.out.println("❌ Error: " + e.getMessage());
        }
    }

    // READ — View all students
    public static void viewAllStudents() {
        String sql = "SELECT * FROM students ORDER BY id";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("\n╔═════╦════════════════╦══════╦═══════════════════════╦════════╗");
            System.out.printf("║ %-3s ║ %-14s ║ %-4s ║ %-21s ║ %-6s ║%n",
                    "ID", "Name", "Age", "Email", "Marks");
            System.out.println("╠═════╬════════════════╬══════╬═══════════════════════╬════════╣");

            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                System.out.printf("║ %-3d ║ %-14s ║ %-4d ║ %-21s ║ %-6.1f ║%n",
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("age"),
                        rs.getString("email"),
                        rs.getDouble("marks"));
            }

            if (!hasData) {
                System.out.println("║           No records found!                          ║");
            }

            System.out.println("╚═════╩════════════════╩══════╩═══════════════════════╩════════╝");

        } catch (SQLException e) {
            System.out.println("❌ Error: " + e.getMessage());
        }
    }

    // READ — Search by name
    public static void searchStudent(Scanner sc) {
        System.out.print("Enter name to search: ");
        String name = sc.nextLine();

        String sql = "SELECT * FROM students WHERE name LIKE ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + name + "%");
            ResultSet rs = pstmt.executeQuery();

            System.out.println("\nSearch Results:");
            boolean found = false;
            while (rs.next()) {
                found = true;
                System.out.printf("  ID: %d | Name: %s | Age: %d | Marks: %.1f%n",
                        rs.getInt("id"), rs.getString("name"),
                        rs.getInt("age"), rs.getDouble("marks"));
            }

            if (!found) System.out.println("  No students found matching '" + name + "'");

        } catch (SQLException e) {
            System.out.println("❌ Error: " + e.getMessage());
        }
    }

    // UPDATE — Update student
    public static void updateStudent(Scanner sc) {
        System.out.print("Enter student ID to update: ");
        int id = Integer.parseInt(sc.nextLine());

        System.out.println("What to update?");
        System.out.println("1. Name  2. Age  3. Email  4. Marks");
        System.out.print("Choice: ");
        int choice = Integer.parseInt(sc.nextLine());

        String sql = "";
        Object newValue = null;

        switch (choice) {
            case 1:
                System.out.print("Enter new name: ");
                newValue = sc.nextLine();
                sql = "UPDATE students SET name = ? WHERE id = ?";
                break;
            case 2:
                System.out.print("Enter new age: ");
                newValue = Integer.parseInt(sc.nextLine());
                sql = "UPDATE students SET age = ? WHERE id = ?";
                break;
            case 3:
                System.out.print("Enter new email: ");
                newValue = sc.nextLine();
                sql = "UPDATE students SET email = ? WHERE id = ?";
                break;
            case 4:
                System.out.print("Enter new marks: ");
                newValue = Double.parseDouble(sc.nextLine());
                sql = "UPDATE students SET marks = ? WHERE id = ?";
                break;
            default:
                System.out.println("Invalid choice!");
                return;
        }

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setObject(1, newValue);
            pstmt.setInt(2, id);

            int rows = pstmt.executeUpdate();
            if (rows > 0) System.out.println("✅ Updated successfully!");
            else System.out.println("❌ Student ID " + id + " not found!");

        } catch (SQLException e) {
            System.out.println("❌ Error: " + e.getMessage());
        }
    }

    // DELETE — Delete student
    public static void deleteStudent(Scanner sc) {
        System.out.print("Enter student ID to delete: ");
        int id = Integer.parseInt(sc.nextLine());

        System.out.print("Are you sure? (y/n): ");
        String confirm = sc.nextLine();

        if (!confirm.equalsIgnoreCase("y")) {
            System.out.println("Cancelled.");
            return;
        }

        String sql = "DELETE FROM students WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            int rows = pstmt.executeUpdate();
            if (rows > 0) System.out.println("✅ Deleted successfully!");
            else System.out.println("❌ Student ID " + id + " not found!");

        } catch (SQLException e) {
            System.out.println("❌ Error: " + e.getMessage());
        }
    }

    // STATISTICS
    public static void showStatistics() {
        String sql = "SELECT COUNT(*) as total, AVG(marks) as avg_marks, " +
                     "MAX(marks) as max_marks, MIN(marks) as min_marks FROM students";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                System.out.println("\n📊 Statistics:");
                System.out.printf("  Total Students: %d%n", rs.getInt("total"));
                System.out.printf("  Average Marks:  %.2f%n", rs.getDouble("avg_marks"));
                System.out.printf("  Highest Marks:  %.1f%n", rs.getDouble("max_marks"));
                System.out.printf("  Lowest Marks:   %.1f%n", rs.getDouble("min_marks"));
            }

        } catch (SQLException e) {
            System.out.println("❌ Error: " + e.getMessage());
        }
    }

    // MAIN MENU
    public static void main(String[] args) {
        // Load driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Driver not found!");
            return;
        }

        Scanner sc = new Scanner(System.in);

        while (true) {
            System.out.println("\n╔══════════════════════════════════════╗");
            System.out.println("║    STUDENT MANAGEMENT SYSTEM         ║");
            System.out.println("╠══════════════════════════════════════╣");
            System.out.println("║  1. Add Student                      ║");
            System.out.println("║  2. View All Students                ║");
            System.out.println("║  3. Search Student                   ║");
            System.out.println("║  4. Update Student                   ║");
            System.out.println("║  5. Delete Student                   ║");
            System.out.println("║  6. Statistics                       ║");
            System.out.println("║  0. Exit                             ║");
            System.out.println("╚══════════════════════════════════════╝");
            System.out.print("Enter choice: ");

            String choice = sc.nextLine();

            switch (choice) {
                case "1": addStudent(sc); break;
                case "2": viewAllStudents(); break;
                case "3": searchStudent(sc); break;
                case "4": updateStudent(sc); break;
                case "5": deleteStudent(sc); break;
                case "6": showStatistics(); break;
                case "0":
                    System.out.println("Goodbye! 👋");
                    sc.close();
                    return;
                default:
                    System.out.println("Invalid choice! Try again.");
            }
        }
    }
}
```

---

# Practice Sections

## 📝 Practice Section – JDBC Basics

### Level 1 – Very Simple Checks (10 Questions)

| # | Question | Answer |
|---|----------|--------|
| 1 | What does JDBC stand for? | Java Database Connectivity |
| 2 | Which package contains JDBC classes? | `java.sql` |
| 3 | What method creates a database connection? | `DriverManager.getConnection()` |
| 4 | What type of JDBC driver is MySQL Connector/J? | Type 4 (Thin/Pure Java) |
| 5 | What method executes SELECT queries? | `executeQuery()` |
| 6 | What method executes INSERT/UPDATE/DELETE? | `executeUpdate()` |
| 7 | What does `rs.next()` do? | Moves cursor to next row, returns true if exists |
| 8 | What is the default port for MySQL? | 3306 |
| 9 | What prevents SQL injection? | PreparedStatement |
| 10 | What does CRUD stand for? | Create, Read, Update, Delete |

### Level 2 – Concept MCQs (10 Questions)

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Which is NOT a JDBC interface? | A) Connection B) Statement C) ResultSet D) Database | **D** |
| 2 | PreparedStatement placeholder is? | A) # B) $ C) ? D) @ | **C** |
| 3 | `executeUpdate()` returns? | A) ResultSet B) boolean C) int (rows affected) D) void | **C** |
| 4 | To call stored procedure, use? | A) Statement B) PreparedStatement C) CallableStatement D) StoredStatement | **C** |
| 5 | ResultSet column index starts from? | A) 0 B) 1 C) -1 D) Depends | **B** |
| 6 | `conn.setAutoCommit(false)` starts? | A) New connection B) Transaction C) Pool D) Thread | **B** |
| 7 | Which JDBC driver type is fastest? | A) Type 1 B) Type 2 C) Type 3 D) Type 4 | **D** |
| 8 | `conn.rollback()` undoes? | A) Last query B) All uncommitted changes C) All changes ever D) Nothing | **B** |
| 9 | Connection pooling improves? | A) SQL syntax B) Performance C) Security D) Portability | **B** |
| 10 | MySQL URL format starts with? | A) mysql:// B) jdbc:mysql:// C) db:mysql:// D) sql:// | **B** |

### Level 3 – Deep Understanding MCQs (5 Questions)

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Why is `Class.forName()` optional in JDBC 4.0+? | A) Not needed anymore B) Service Provider mechanism auto-loads driver C) Builder pattern D) Deprecated | **B** |
| 2 | `try-with-resources` and Connection — what happens? | A) Connection stays open B) Connection closed automatically C) Error thrown D) Nothing | **B** — `Connection` implements `AutoCloseable` |
| 3 | What happens if you don't close ResultSet? | A) Nothing B) Memory/resource leak C) Auto-closed D) Exception | **B** — Resources not released back to DB |
| 4 | PreparedStatement vs Statement performance difference? | A) No difference B) PreparedStatement caches execution plan C) Statement is faster D) Only syntax differs | **B** |
| 5 | In connection pooling, `conn.close()` does what? | A) Destroys connection B) Returns to pool C) Does nothing D) Throws exception | **B** — Connection is returned, not destroyed |

### Level 4 – Quick True/False (5 Questions)

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Statement is safe from SQL injection | **False** |
| 2 | JDBC is database-independent | **True** (same API, different drivers) |
| 3 | ResultSet can only move forward by default | **True** (TYPE_FORWARD_ONLY) |
| 4 | `executeQuery()` can be used for INSERT | **False** (use `executeUpdate()`) |
| 5 | Connection pooling creates a new connection for every request | **False** (reuses existing) |

### Level 5 – Small Coding Practice

**Exercise 1:** Write a program to count total records in a table.

```java
import java.sql.*;

public class CountRecords {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/java_demo";

        try (Connection conn = DriverManager.getConnection(url, "root", "your_password");
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM students")) {

            if (rs.next()) {
                System.out.println("Total students: " + rs.getInt("total"));
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

**Exercise 2:** Write a program to find the student with the highest marks.

```java
import java.sql.*;

public class TopStudent {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/java_demo";
        String sql = "SELECT * FROM students ORDER BY marks DESC LIMIT 1";

        try (Connection conn = DriverManager.getConnection(url, "root", "your_password");
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                System.out.println("Top Student: " + rs.getString("name"));
                System.out.println("Marks: " + rs.getDouble("marks"));
                System.out.println("Email: " + rs.getString("email"));
            } else {
                System.out.println("No students found!");
            }

        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

---

### 20 Tricky Interview MCQs – JDBC

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Which is the correct JDBC URL? | A) `mysql://localhost/db` B) `jdbc:mysql://localhost:3306/db` C) `jdbc://mysql:3306/db` D) `db:mysql://localhost` | **B** |
| 2 | `executeQuery()` returns? | A) int B) boolean C) ResultSet D) void | **C** |
| 3 | What does `rs.getString(1)` do? | A) Get first row B) Get first column as String C) Error D) Get one character | **B** |
| 4 | `DriverManager` manages what? | A) Database tables B) JDBC drivers C) Result sets D) Transactions | **B** |
| 5 | Which statement type is fastest for repeated queries? | A) Statement B) PreparedStatement C) CallableStatement D) All same | **B** |
| 6 | `conn.setAutoCommit(false)` followed by `conn.commit()` is? | A) Error B) Manual transaction C) Auto commit D) Rollback | **B** |
| 7 | `registerOutParameter()` is used with? | A) Statement B) PreparedStatement C) CallableStatement D) Connection | **C** |
| 8 | Default ResultSet type is? | A) SCROLL_SENSITIVE B) SCROLL_INSENSITIVE C) FORWARD_ONLY D) BIDIRECTIONAL | **C** |
| 9 | `batch update` advantage? | A) Security B) Sends multiple SQL in one round trip C) Auto-commit D) Thread safety | **B** |
| 10 | `DatabaseMetaData` provides? | A) Table data B) Database info (name, version, etc.) C) User info D) SQL syntax | **B** |
| 11 | Which exception does JDBC throw? | A) IOException B) SQLException C) DatabaseException D) JDBCException | **B** |
| 12 | `pstmt.setNull(1, Types.VARCHAR)` sets? | A) Empty string B) "null" string C) SQL NULL D) Exception | **C** |
| 13 | Connection pool `maxPoolSize=10` means? | A) 10 tables B) 10 queries max C) Max 10 simultaneous connections D) 10 users | **C** |
| 14 | `wasNull()` checks? | A) If ResultSet is empty B) If last column read was NULL C) If connection is null D) If statement is null | **B** |
| 15 | Savepoint allows? | A) Partial commit B) Partial rollback C) Auto-save D) Backup | **B** |
| 16 | `Class.forName("com.mysql.cj.jdbc.Driver")` does? | A) Creates connection B) Loads driver class into memory C) Creates database D) Nothing | **B** |
| 17 | Connection is obtained from pool — calling `close()` does? | A) Destroys connection B) Returns to pool C) Throws error D) Nothing | **B** |
| 18 | Type 4 JDBC driver means? | A) Uses ODBC B) Uses native library C) Uses middleware D) Pure Java, direct protocol | **D** |
| 19 | `ResultSetMetaData.getColumnCount()` returns? | A) Row count B) Column count C) Table count D) Database count | **B** |
| 20 | Best practice for JDBC resource management? | A) Manual close B) try-with-resources C) System.gc() D) Leave open | **B** |

---

## 🎯 Final Quick Revision – JDBC & MySQL

```
┌─────────────────────────────────────────────────────────────────┐
│                    JDBC & MySQL SUMMARY                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  JDBC BASICS:                                                    │
│  • JDBC = Java Database Connectivity API                        │
│  • 6 Steps: Load → Connect → Statement → Execute → Process     │
│              → Close                                             │
│  • URL: jdbc:mysql://localhost:3306/dbname                       │
│  • MySQL Connector/J = Type 4 pure Java driver                  │
│                                                                  │
│  STATEMENTS:                                                     │
│  • Statement → Static SQL (NOT safe)                            │
│  • PreparedStatement → Parameterized SQL (SAFE, fast)           │
│  • CallableStatement → Stored procedures                        │
│                                                                  │
│  CRUD:                                                           │
│  • executeQuery() → SELECT (returns ResultSet)                  │
│  • executeUpdate() → INSERT/UPDATE/DELETE (returns int)         │
│                                                                  │
│  TRANSACTIONS:                                                   │
│  • setAutoCommit(false) → commit() / rollback()                 │
│  • ACID properties                                               │
│  • Savepoints for partial rollback                              │
│                                                                  │
│  CONNECTION POOLING:                                             │
│  • Reuse connections instead of create/destroy                  │
│  • HikariCP = most popular library                              │
│  • close() returns connection to pool                           │
│                                                                  │
│  BEST PRACTICES:                                                 │
│  • Always use PreparedStatement                                 │
│  • Always use try-with-resources                                │
│  • Always use connection pooling in production                  │
│  • Never hardcode credentials (use config files)                │
│  • Close resources in reverse order of creation                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

---

> **📌 Tip:** Set up MySQL locally and practice every program in this file. The best way to learn JDBC is by running real queries against a real database!

---

# 🖼️ Visual Reference Diagrams – JDBC

## 📌 JDBC Architecture Layers

```
┌─────────────────────────────────────────────────────────────────┐
│               JDBC ARCHITECTURE                                  │
│                                                                  │
│  ┌───────────────────────────────────────────┐                  │
│  │           Java Application                │                  │
│  │   (your code: DriverManager, Connection)  │                  │
│  └─────────────────┬─────────────────────────┘                  │
│                    │  JDBC API (java.sql.*)                      │
│  ┌─────────────────▼─────────────────────────┐                  │
│  │           JDBC Driver Manager             │                  │
│  │       (registers & selects driver)        │                  │
│  └─────────────────┬─────────────────────────┘                  │
│                    │                                             │
│  ┌─────────────────▼─────────────────────────┐                  │
│  │           JDBC Driver                     │                  │
│  │   (Type 4: Pure Java — MySQL Connector/J) │                  │
│  └─────────────────┬─────────────────────────┘                  │
│                    │  SQL over TCP/IP                            │
│  ┌─────────────────▼─────────────────────────┐                  │
│  │           MySQL Database Server           │                  │
│  │       (processes SQL, returns results)    │                  │
│  └────────────────────────────────────────────┘                 │
│                                                                  │
│  Connection URL format:                                          │
│  jdbc:mysql://hostname:3306/dbname?useSSL=false&serverTimezone=UTC│
└─────────────────────────────────────────────────────────────────┘
```

## 📌 JDBC Connection Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│            JDBC CONNECTION LIFECYCLE                             │
│                                                                  │
│  1. Load Driver                                                  │
│     Class.forName("com.mysql.cj.jdbc.Driver");                  │
│         (modern: auto-loaded via ServiceLoader)                  │
│                    │                                             │
│                    ▼                                             │
│  2. Get Connection                                               │
│     Connection con = DriverManager.getConnection(url, usr, pwd);│
│                    │                                             │
│                    ▼                                             │
│  3. Create Statement                                             │
│     ┌──────────────────────────────────────────────────────┐   │
│     │  Statement     → executeQuery(), executeUpdate()     │   │
│     │  PreparedStatement → pre-compiled, ? parameters       │   │
│     │  CallableStatement → stored procedures               │   │
│     └──────────────────────────────────────────────────────┘   │
│                    │                                             │
│                    ▼                                             │
│  4. Execute SQL                                                  │
│     ResultSet rs = stmt.executeQuery("SELECT ...");             │
│     int rows    = stmt.executeUpdate("INSERT ...");             │
│                    │                                             │
│                    ▼                                             │
│  5. Process Results                                              │
│     while (rs.next()) { rs.getString("col"); }                  │
│                    │                                             │
│                    ▼                                             │
│  6. Close Resources (in reverse order!)                         │
│     rs.close() → stmt.close() → con.close()                    │
│     (or use try-with-resources — RECOMMENDED)                   │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Statement vs PreparedStatement vs CallableStatement

```
┌─────────────────────────────────────────────────────────────────┐
│       Statement Comparison                                       │
│                                                                  │
│  Feature              Statement  PreparedStatement  Callable    │
│  ─────────────────────────────────────────────────────────────  │
│  SQL written in        Java code   Java code         DB proc     │
│  Reusable/Precompiled  No          Yes               Yes         │
│  SQL Injection risk    HIGH        LOW (uses ?)      None        │
│  Parameters            Hard-coded  Placeholders (?)  IN/OUT/INOUT│
│  Use case              Static SQL  Dynamic/repeated  Stored proc │
│  Performance           Low         High              High        │
│                                                                  │
│  PreparedStatement example:                                      │
│  String sql = "INSERT INTO users VALUES (?, ?, ?)";             │
│  PreparedStatement ps = con.prepareStatement(sql);              │
│  ps.setInt(1, 101);                                              │
│  ps.setString(2, "Alice");                                       │
│  ps.setString(3, "alice@mail.com");                              │
│  ps.executeUpdate();                                             │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Transaction Flow

```
┌─────────────────────────────────────────────────────────────────┐
│             JDBC TRANSACTION FLOW                               │
│                                                                  │
│  Default: auto-commit ON (each SQL is committed immediately)    │
│                                                                  │
│  Manual Transaction:                                             │
│  con.setAutoCommit(false);   ←── turn off auto-commit           │
│                                                                  │
│  try {                                                           │
│      stmt.executeUpdate("UPDATE accounts SET ...");  ←── step 1 │
│      stmt.executeUpdate("UPDATE accounts SET ...");  ←── step 2 │
│      con.commit();           ←── all steps succeeded: COMMIT    │
│  } catch (Exception e) {                                         │
│      con.rollback();         ←── any step failed: ROLLBACK      │
│  }                                                               │
│                                                                  │
│  Timeline:                                                       │
│  ─────────────────────────────────────────────────────────────  │
│  [SQL1] [SQL2] [SQL3]  →  COMMIT  (permanent)                   │
│  [SQL1] [SQL2] [FAIL]  →  ROLLBACK (all undone)                 │
│                                                                  │
│  ACID Properties satisfied with transactions:                   │
│  A = Atomicity, C = Consistency, I = Isolation, D = Durability  │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 ResultSet Navigation

```
┌─────────────────────────────────────────────────────────────────┐
│              RESULTSET NAVIGATION                                │
│                                                                  │
│  Default: FORWARD_ONLY cursor                                    │
│                                                                  │
│  Before table:                                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  ^ cursor starts here (before first row)                 │  │
│  │  [Row 1: id=1, name="Alice"]                             │  │
│  │  [Row 2: id=2, name="Bob"]                               │  │
│  │  [Row 3: id=3, name="Carol"]                             │  │
│  │  v after last row                                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  rs.next()         → moves cursor forward 1 row (true/false)   │
│  rs.getString("name") → get column by name                     │
│  rs.getInt(1)         → get column by position (1-based)       │
│  rs.first()           → go to first row (SCROLL_INSENSITIVE)   │
│  rs.last()            → go to last row                         │
│                                                                  │
│  Scrollable ResultSet:                                           │
│  stmt = con.createStatement(                                     │
│      ResultSet.TYPE_SCROLL_INSENSITIVE,                          │
│      ResultSet.CONCUR_READ_ONLY);                                │
└─────────────────────────────────────────────────────────────────┘
```

---

# 📚 Extra Examples – JDBC

## Example: Full CRUD with try-with-resources

```java
import java.sql.*;

public class StudentCRUD {
    static final String URL  = "jdbc:mysql://localhost:3306/school?useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "password";

    // CREATE
    static void insertStudent(int id, String name, int marks) throws SQLException {
        String sql = "INSERT INTO students(id, name, marks) VALUES(?, ?, ?)";
        try (Connection con = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setString(2, name);
            ps.setInt(3, marks);
            int rows = ps.executeUpdate();
            System.out.println("Inserted " + rows + " row(s). [" + name + "]");
        }
    }

    // READ
    static void readAllStudents() throws SQLException {
        String sql = "SELECT * FROM students ORDER BY id";
        try (Connection con = DriverManager.getConnection(URL, USER, PASS);
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            System.out.printf("%-5s %-20s %-6s%n", "ID", "Name", "Marks");
            System.out.println("-".repeat(35));
            while (rs.next()) {
                System.out.printf("%-5d %-20s %-6d%n",
                    rs.getInt("id"), rs.getString("name"), rs.getInt("marks"));
            }
        }
    }

    // UPDATE
    static void updateMarks(int id, int newMarks) throws SQLException {
        String sql = "UPDATE students SET marks=? WHERE id=?";
        try (Connection con = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newMarks);
            ps.setInt(2, id);
            int rows = ps.executeUpdate();
            System.out.println("Updated " + rows + " row(s) for id=" + id);
        }
    }

    // DELETE
    static void deleteStudent(int id) throws SQLException {
        String sql = "DELETE FROM students WHERE id=?";
        try (Connection con = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            System.out.println("Deleted " + rows + " row(s) for id=" + id);
        }
    }

    public static void main(String[] args) {
        try {
            insertStudent(1, "Alice", 92);
            insertStudent(2, "Bob", 87);
            insertStudent(3, "Carol", 95);
            System.out.println("\n== All Students ==");
            readAllStudents();

            updateMarks(2, 90);
            System.out.println("\n== After Update ==");
            readAllStudents();

            deleteStudent(1);
            System.out.println("\n== After Delete ==");
            readAllStudents();
        } catch (SQLException e) {
            System.err.println("SQL Error [" + e.getSQLState() + "]: " + e.getMessage());
        }
    }
}
// Setup SQL:
// CREATE DATABASE school;
// USE school;
// CREATE TABLE students(id INT PRIMARY KEY, name VARCHAR(50), marks INT);
```

## Example: Transaction – Bank Transfer

```java
import java.sql.*;

public class BankTransfer {
    static final String URL  = "jdbc:mysql://localhost:3306/bank?useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "password";

    static void transfer(int fromAccId, int toAccId, double amount) {
        String debit  = "UPDATE accounts SET balance = balance - ? WHERE acc_id = ?";
        String credit = "UPDATE accounts SET balance = balance + ? WHERE acc_id = ?";
        String checkBal = "SELECT balance FROM accounts WHERE acc_id = ?";

        Connection con = null;
        try {
            con = DriverManager.getConnection(URL, USER, PASS);
            con.setAutoCommit(false); // START TRANSACTION

            // Check sufficient balance
            PreparedStatement checkPs = con.prepareStatement(checkBal);
            checkPs.setInt(1, fromAccId);
            ResultSet rs = checkPs.executeQuery();
            if (!rs.next() || rs.getDouble("balance") < amount) {
                throw new SQLException("Insufficient balance or account not found.");
            }

            // Debit from sender
            PreparedStatement debitPs = con.prepareStatement(debit);
            debitPs.setDouble(1, amount);
            debitPs.setInt(2, fromAccId);
            debitPs.executeUpdate();

            // Simulate error: uncomment to test rollback
            // if (true) throw new SQLException("Simulated failure!");

            // Credit to receiver
            PreparedStatement creditPs = con.prepareStatement(credit);
            creditPs.setDouble(1, amount);
            creditPs.setInt(2, toAccId);
            creditPs.executeUpdate();

            con.commit(); // COMMIT: both operations succeeded
            System.out.printf("✓ Transferred ₹%.2f from Acc#%d to Acc#%d%n", amount, fromAccId, toAccId);

        } catch (SQLException e) {
            System.err.println("Transfer failed: " + e.getMessage());
            if (con != null) {
                try { con.rollback(); System.out.println("Transaction rolled back."); }
                catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); }
                catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public static void main(String[] args) {
        transfer(101, 102, 5000.00);
    }
}
// Setup SQL:
// CREATE DATABASE bank;
// USE bank;
// CREATE TABLE accounts(acc_id INT PRIMARY KEY, holder VARCHAR(50), balance DOUBLE);
// INSERT INTO accounts VALUES(101,'Alice',20000),(102,'Bob',5000);
```

## Example: Batch Insert

```java
import java.sql.*;

public class BatchInsertDemo {
    public static void main(String[] args) throws SQLException {
        String url  = "jdbc:mysql://localhost:3306/school?useSSL=false&serverTimezone=UTC";
        String sql  = "INSERT INTO students(id, name, marks) VALUES(?, ?, ?)";

        String[][] data = {
            {"10","David","78"}, {"11","Eve","88"},
            {"12","Frank","72"}, {"13","Grace","91"},
            {"14","Hank","65"}, {"15","Ivy","84"}
        };

        try (Connection con = DriverManager.getConnection(url, "root", "password");
             PreparedStatement ps = con.prepareStatement(sql)) {

            con.setAutoCommit(false);

            for (String[] row : data) {
                ps.setInt(1, Integer.parseInt(row[0]));
                ps.setString(2, row[1]);
                ps.setInt(3, Integer.parseInt(row[2]));
                ps.addBatch(); // add to batch
            }

            int[] results = ps.executeBatch(); // execute all at once
            con.commit();

            System.out.println("Batch inserted " + results.length + " rows.");
        }
    }
}
```

---

# 📝 Extended Question Bank – JDBC

## ✍️ Fill in the Blanks – JDBC

| # | Statement | Answer |
|---|-----------|--------|
| 1 | JDBC stands for _______. | **Java Database Connectivity** |
| 2 | The connection URL for MySQL starts with _______. | **jdbc:mysql://** |
| 3 | `DriverManager.getConnection()` returns a _______ object. | **Connection** |
| 4 | `PreparedStatement` uses _______ as parameter placeholders. | **? (question marks)** |
| 5 | `executeQuery()` returns a _______ object. | **ResultSet** |
| 6 | `executeUpdate()` returns _______ value. | **int (number of rows affected)** |
| 7 | To move to the next row in ResultSet, call _______. | **rs.next()** |
| 8 | `con.setAutoCommit(false)` is used to start _______. | **a transaction** |
| 9 | To undo a transaction, call _______. | **con.rollback()** |
| 10 | `con.commit()` makes changes _______. | **permanent** |
| 11 | The JDBC driver class for MySQL is _______. | **com.mysql.cj.jdbc.Driver** |
| 12 | `ResultSet.getString(1)` retrieves the _______ column. | **first** |
| 13 | The package containing all JDBC interfaces is _______. | **java.sql** |
| 14 | Inserting multiple rows in a single network call is called _______. | **batch processing / batch insert** |
| 15 | `CallableStatement` is used to execute _______. | **stored procedures** |

---

## 🔗 Match the Following – JDBC

### Set A – Interface to Purpose

| Interface | Purpose |
|-----------|---------|
| 1. Connection | A. Navigates rows returned by a query |
| 2. Statement | B. Executes stored procedures |
| 3. PreparedStatement | C. Represents the database connection |
| 4. ResultSet | D. Sends plain SQL to the database |
| 5. CallableStatement | E. Pre-compiled SQL with parameters |

**Answers:** 1→C, 2→D, 3→E, 4→A, 5→B

---

### Set B – Method to Action

| Method | Action |
|--------|--------|
| 1. executeQuery() | A. Permanently saves transaction changes |
| 2. executeUpdate() | B. Returns rows from SELECT |
| 3. commit() | C. Inserts/updates/deletes, returns row count |
| 4. rollback() | D. Adds SQL to batch list |
| 5. addBatch() | E. Undoes uncommitted transaction changes |

**Answers:** 1→B, 2→C, 3→A, 4→E, 5→D

---

## 🐛 Error Spotting – JDBC

### Bug 1
```java
Connection con = DriverManager.getConnection(url, "root", "password");
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM students");
// Missing: close resources!
```
**Bug:** Resources are never closed — causes connection leaks. Use try-with-resources.

---

### Bug 2
```java
String sql = "INSERT INTO users VALUES(" + userId + ", '" + name + "')";
Statement st = con.createStatement();
st.executeUpdate(sql);
```
**Bug:** SQL injection vulnerability — user input directly in SQL. Use `PreparedStatement` with `?` placeholders.

---

### Bug 3
```java
PreparedStatement ps = con.prepareStatement("SELECT * FROM t WHERE id=?");
ps.setInt(2, 101); // Bug!
ps.executeQuery();
```
**Bug:** Parameter index starts at 1, not 0 or 2. Should be `ps.setInt(1, 101)`.

---

### Bug 4
```java
ResultSet rs = st.executeQuery("SELECT * FROM students");
rs.getString("name"); // Bug! No rs.next() called
```
**Bug:** Cursor starts before the first row. Must call `rs.next()` before reading data.

---

### Bug 5
```java
con.setAutoCommit(false);
try {
    st.executeUpdate("UPDATE ...");
    con.commit();
} catch (Exception e) {
    // Bug: no rollback!
}
```
**Bug:** Missing `con.rollback()` in the catch block — partial changes may remain uncommitted in some drivers. Always rollback on exception.

---

## 🖥️ Output Prediction – JDBC

### Q1 — What does `executeUpdate` return?
```java
int rows = ps.executeUpdate(); // deletes 3 rows
System.out.println("Deleted: " + rows);
```
**Output:** `Deleted: 3`

---

### Q2 — Batch results
```java
int[] results = ps.executeBatch(); // 4 rows inserted, all succeed
System.out.println("Batch count: " + results.length);
```
**Output:** `Batch count: 4`

---

### Q3 — ResultSet column access
```java
// Table row: id=5, name="Zara", marks=93
while (rs.next()) {
    System.out.println(rs.getInt(1) + " - " + rs.getString("name"));
}
```
**Output:** `5 - Zara`

---

### Q4 — AutoCommit behavior
```java
System.out.println(con.getAutoCommit()); // fresh connection
con.setAutoCommit(false);
System.out.println(con.getAutoCommit());
```
**Output:**
```
true
false
```

---

## 🧐 Short Answer – JDBC

| # | Question | Answer |
|---|----------|--------|
| 1 | What is JDBC? | A Java API for connecting and executing queries against relational databases |
| 2 | Why use PreparedStatement over Statement? | Prevents SQL injection, better performance (pre-compiled), cleaner code |
| 3 | What is a Connection pool? | A cache of reusable connections to avoid expensive open/close per request |
| 4 | What does `rs.next()` return when no more rows exist? | `false` |
| 5 | How do you get number of columns in a ResultSet? | `rs.getMetaData().getColumnCount()` |
| 6 | What is the default port for MySQL? | 3306 |
| 7 | Difference between `commit()` and `rollback()`? | commit() makes all transaction changes permanent; rollback() undoes all uncommitted changes |
| 8 | What is `executeBatch()` used for? | Execute multiple SQL commands in one database round-trip for better performance |
| 9 | Name the three types of JDBC Statements | Statement, PreparedStatement, CallableStatement |
| 10 | Why should Connection be closed after use? | To release database resources, avoid connection leaks, and return connection to pool |
