# 18. Databases (SQLite, MySQL, SQLAlchemy)

## Table of Contents
- [18.1 Introduction to Databases](#181-introduction-to-databases)
- [18.2 SQLite with Python](#182-sqlite-with-python)
- [18.3 MySQL with Python](#183-mysql-with-python)
- [18.4 SQLAlchemy ORM](#184-sqlalchemy-orm)
- [18.5 Practice & Assessment](#185-practice--assessment)

---

## 18.1 Introduction to Databases

### Database Types

```
┌───────────────────────────────────────────────────────┐
│  SQL (Relational)          NoSQL                       │
│  ┌──────────────────┐     ┌──────────────────┐       │
│  │ Tables with rows │     │ Documents (JSON) │       │
│  │ Fixed schema     │     │ Flexible schema  │       │
│  │ ACID compliant   │     │ Eventual consist.│       │
│  │                  │     │                  │       │
│  │ SQLite, MySQL,   │     │ MongoDB, Redis,  │       │
│  │ PostgreSQL       │     │ Firebase         │       │
│  └──────────────────┘     └──────────────────┘       │
└───────────────────────────────────────────────────────┘
```

### CRUD Operations

| Operation | SQL | Purpose |
|-----------|-----|---------|
| **C**reate | INSERT | Add new data |
| **R**ead | SELECT | Retrieve data |
| **U**pdate | UPDATE | Modify data |
| **D**elete | DELETE | Remove data |

---

## 18.2 SQLite with Python

### Setup (No installation needed — built into Python!)

```python
import sqlite3

# Connect (creates file if doesn't exist)
conn = sqlite3.connect("school.db")
cursor = conn.cursor()

# Create table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER,
        grade REAL,
        enrolled_date TEXT DEFAULT CURRENT_DATE
    )
""")
conn.commit()
```

### CRUD Operations

```python
# CREATE — Insert data
cursor.execute(
    "INSERT INTO students (name, age, grade) VALUES (?, ?, ?)",
    ("Alice", 20, 3.8)
)

# Insert multiple
students_data = [
    ("Bob", 22, 3.5),
    ("Charlie", 21, 3.9),
    ("Diana", 23, 3.2),
    ("Eve", 20, 3.7)
]
cursor.executemany(
    "INSERT INTO students (name, age, grade) VALUES (?, ?, ?)",
    students_data
)
conn.commit()

# READ — Select data
cursor.execute("SELECT * FROM students")
all_students = cursor.fetchall()
for student in all_students:
    print(student)
# (1, 'Alice', 20, 3.8, '2024-01-15')
# (2, 'Bob', 22, 3.5, '2024-01-15')
# ...

# Select with condition
cursor.execute("SELECT name, grade FROM students WHERE grade > ?", (3.6,))
high_achievers = cursor.fetchall()
print(high_achievers)  # [('Alice', 3.8), ('Charlie', 3.9), ('Eve', 3.7)]

# UPDATE
cursor.execute("UPDATE students SET grade = ? WHERE name = ?", (3.6, "Bob"))
conn.commit()

# DELETE
cursor.execute("DELETE FROM students WHERE name = ?", ("Diana",))
conn.commit()

# Always close!
conn.close()
```

### Using Context Manager

```python
import sqlite3

def get_all_students():
    with sqlite3.connect("school.db") as conn:
        conn.row_factory = sqlite3.Row  # Access by column name
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM students ORDER BY grade DESC")
        return [dict(row) for row in cursor.fetchall()]

students = get_all_students()
for s in students:
    print(f"{s['name']}: GPA {s['grade']}")
```

> ⚠️ **Security:** ALWAYS use parameterized queries (`?` placeholders). NEVER use f-strings with SQL — prevents SQL injection!

---

## 18.3 MySQL with Python

```python
# Install: pip install mysql-connector-python
import mysql.connector

# Connect
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="password",
    database="school_db"
)
cursor = conn.cursor(dictionary=True)  # Results as dicts

# Create table
cursor.execute("""
    CREATE TABLE IF NOT EXISTS employees (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        department VARCHAR(50),
        salary DECIMAL(10, 2),
        hire_date DATE
    )
""")

# Insert
cursor.execute(
    "INSERT INTO employees (name, department, salary) VALUES (%s, %s, %s)",
    ("Alice", "Engineering", 85000.00)
)
conn.commit()

# Select
cursor.execute("SELECT * FROM employees WHERE department = %s", ("Engineering",))
results = cursor.fetchall()
for row in results:
    print(f"{row['name']}: ${row['salary']}")

conn.close()
```

---

## 18.4 SQLAlchemy ORM

### Definition
**SQLAlchemy** is Python's most popular ORM (Object-Relational Mapper) — work with databases using Python objects instead of raw SQL.

```
┌───────────────────────────────────────────────────────┐
│  ORM MAPPING                                           │
│                                                       │
│  Python Class  ←──────────►  Database Table           │
│  Instance      ←──────────►  Table Row                │
│  Attribute     ←──────────►  Column                   │
│                                                       │
│  User()        ←──────────►  users table              │
│  user.name     ←──────────►  name column              │
└───────────────────────────────────────────────────────┘
```

```python
# Install: pip install sqlalchemy
from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime
from sqlalchemy.orm import declarative_base, sessionmaker
from datetime import datetime

# Setup
engine = create_engine("sqlite:///library.db", echo=False)
Base = declarative_base()
Session = sessionmaker(bind=engine)

# Define Model
class Book(Base):
    __tablename__ = "books"
    
    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    author = Column(String(100), nullable=False)
    price = Column(Float, default=0.0)
    published = Column(DateTime, default=datetime.utcnow)
    
    def __repr__(self):
        return f"<Book('{self.title}' by {self.author})>"

# Create tables
Base.metadata.create_all(engine)

# CRUD with Session
session = Session()

# CREATE
book1 = Book(title="Python Crash Course", author="Eric Matthes", price=35.99)
book2 = Book(title="Fluent Python", author="Luciano Ramalho", price=45.99)
session.add(book1)
session.add_all([book2])
session.commit()

# READ
all_books = session.query(Book).all()
for book in all_books:
    print(book)

# Filter
cheap_books = session.query(Book).filter(Book.price < 40).all()
python_books = session.query(Book).filter(Book.title.contains("Python")).all()

# Single result
book = session.query(Book).filter_by(author="Eric Matthes").first()

# UPDATE
book.price = 29.99
session.commit()

# DELETE
session.delete(book)
session.commit()

session.close()
```

### Relationships

```python
from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship

class Author(Base):
    __tablename__ = "authors"
    
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    books = relationship("Book", back_populates="author_rel")

class Book(Base):
    __tablename__ = "books"
    
    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    author_id = Column(Integer, ForeignKey("authors.id"))
    author_rel = relationship("Author", back_populates="books")

# Usage
author = Author(name="J.K. Rowling")
author.books.append(Book(title="Harry Potter 1"))
author.books.append(Book(title="Harry Potter 2"))
session.add(author)
session.commit()

# Access relationship
for book in author.books:
    print(book.title)
```

---

## 18.5 Practice & Assessment

### MCQs

**Q1.** What does ORM stand for?
- A) Object Related Model
- B) Object-Relational Mapper
- C) Online Resource Manager
- D) Open Relational Module

**Answer:** B

---

**Q2.** Why use parameterized queries instead of f-strings?
- A) Faster execution
- B) Prevent SQL injection attacks
- C) Better formatting
- D) Required by Python

**Answer:** B — Parameterized queries sanitize input and prevent injection.

---

### Coding Task

**Task:** Create a complete CRUD application for a contact book using SQLite.

```python
import sqlite3

class ContactBook:
    def __init__(self, db_name="contacts.db"):
        self.conn = sqlite3.connect(db_name)
        self.conn.row_factory = sqlite3.Row
        self.create_table()
    
    def create_table(self):
        self.conn.execute("""
            CREATE TABLE IF NOT EXISTS contacts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                phone TEXT,
                email TEXT
            )
        """)
        self.conn.commit()
    
    def add(self, name, phone, email):
        self.conn.execute(
            "INSERT INTO contacts (name, phone, email) VALUES (?, ?, ?)",
            (name, phone, email)
        )
        self.conn.commit()
        print(f"Added: {name}")
    
    def get_all(self):
        return [dict(r) for r in self.conn.execute("SELECT * FROM contacts").fetchall()]
    
    def search(self, keyword):
        return [dict(r) for r in self.conn.execute(
            "SELECT * FROM contacts WHERE name LIKE ?",
            (f"%{keyword}%",)
        ).fetchall()]
    
    def delete(self, contact_id):
        self.conn.execute("DELETE FROM contacts WHERE id = ?", (contact_id,))
        self.conn.commit()
    
    def close(self):
        self.conn.close()

# Usage
cb = ContactBook()
cb.add("Alice", "555-0101", "alice@email.com")
cb.add("Bob", "555-0102", "bob@email.com")
print(cb.get_all())
print(cb.search("Ali"))
cb.close()
```

---

> **Next Topic:** [19 - Machine Learning](19-machine-learning.md)
