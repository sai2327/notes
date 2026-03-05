# Oracle Database Complete Command Reference Guide

> **A practical handbook for Oracle SQL & PL/SQL — Syntax, Examples, and Real Queries**

---

## Table of Contents

| # | Section | File |
|---|---------|------|
| 01 | Basic Database Commands | [01_basic_commands.md](./01_basic_commands.md) |
| 02 | Table Creation & Structure (DDL) | [02_ddl_commands.md](./02_ddl_commands.md) |
| 03 | Data Manipulation (DML) | [03_dml_commands.md](./03_dml_commands.md) |
| 04 | Data Query Commands | [04_query_commands.md](./04_query_commands.md) |
| 05 | Operators | [05_operators.md](./05_operators.md) |
| 06 | Oracle Functions | [06_functions.md](./06_functions.md) |
| 07 | Joins | [07_joins.md](./07_joins.md) |
| 08 | Subqueries | [08_subqueries.md](./08_subqueries.md) |
| 09 | Constraints | [09_constraints.md](./09_constraints.md) |
| 10 | Database Objects | [10_database_objects.md](./10_database_objects.md) |
| 11 | Transaction Control | [11_transactions.md](./11_transactions.md) |
| 12 | PL/SQL Commands | [12_plsql.md](./12_plsql.md) |
| 13 | Oracle Admin Commands | [13_admin_commands.md](./13_admin_commands.md) |
| 14 | Oracle Command Cheat Sheet | [14_cheat_sheet.md](./14_cheat_sheet.md) |
| 15 | Practice Problems | [15_practice.md](./15_practice.md) |

---

## Quick Start — Sample Tables Used Throughout This Guide

Before running examples, create these sample tables in Oracle SQL Developer:

```sql
-- DEPARTMENTS table
CREATE TABLE departments (
    dept_id     NUMBER PRIMARY KEY,
    dept_name   VARCHAR2(50) NOT NULL,
    location    VARCHAR2(50)
);

INSERT INTO departments VALUES (10, 'HR',        'New York');
INSERT INTO departments VALUES (20, 'IT',        'Chicago');
INSERT INTO departments VALUES (30, 'Finance',   'Dallas');
INSERT INTO departments VALUES (40, 'Marketing', 'Boston');
COMMIT;

-- EMPLOYEES table
CREATE TABLE employees (
    emp_id      NUMBER PRIMARY KEY,
    first_name  VARCHAR2(50),
    last_name   VARCHAR2(50),
    dept_id     NUMBER REFERENCES departments(dept_id),
    salary      NUMBER(10,2),
    hire_date   DATE,
    job_title   VARCHAR2(50),
    manager_id  NUMBER
);

INSERT INTO employees VALUES (101, 'Alice',  'Smith',   10, 55000, DATE '2020-01-15', 'HR Manager',      NULL);
INSERT INTO employees VALUES (102, 'Bob',    'Jones',   20, 72000, DATE '2019-06-01', 'DBA',             101);
INSERT INTO employees VALUES (103, 'Carol',  'White',   20, 68000, DATE '2021-03-10', 'Developer',       101);
INSERT INTO employees VALUES (104, 'David',  'Brown',   30, 61000, DATE '2018-11-20', 'Analyst',         101);
INSERT INTO employees VALUES (105, 'Eva',    'Davis',   10, 53000, DATE '2022-07-05', 'HR Executive',    101);
INSERT INTO employees VALUES (106, 'Frank',  'Miller',  30, 75000, DATE '2017-04-18', 'Finance Manager', NULL);
INSERT INTO employees VALUES (107, 'Grace',  'Wilson',  40, 64000, DATE '2023-01-22', 'Marketing Lead',  106);
INSERT INTO employees VALUES (108, 'Henry',  'Moore',   20, 59000, DATE '2020-09-30', 'Developer',       102);
COMMIT;

-- STUDENTS table
CREATE TABLE students (
    student_id  NUMBER PRIMARY KEY,
    name        VARCHAR2(100),
    grade       VARCHAR2(2),
    marks       NUMBER(5,2),
    course      VARCHAR2(50),
    enroll_date DATE
);

INSERT INTO students VALUES (1, 'Aarav Shah',   'A',  92.5, 'Computer Science', DATE '2022-08-01');
INSERT INTO students VALUES (2, 'Priya Patel',  'B',  78.0, 'Mathematics',      DATE '2022-08-01');
INSERT INTO students VALUES (3, 'Rohan Mehta',  'A',  88.0, 'Computer Science', DATE '2021-08-01');
INSERT INTO students VALUES (4, 'Sneha Reddy',  'C',  65.5, 'Physics',          DATE '2023-08-01');
INSERT INTO students VALUES (5, 'Karan Singh',  'B',  81.0, 'Mathematics',      DATE '2022-08-01');
INSERT INTO students VALUES (6, 'Divya Nair',   'A',  95.0, 'Computer Science', DATE '2021-08-01');
COMMIT;

-- ORDERS table
CREATE TABLE orders (
    order_id    NUMBER PRIMARY KEY,
    customer    VARCHAR2(100),
    product     VARCHAR2(100),
    qty         NUMBER,
    unit_price  NUMBER(10,2),
    order_date  DATE,
    status      VARCHAR2(20)
);

INSERT INTO orders VALUES (1001, 'Alice',  'Laptop',  2, 75000, DATE '2024-01-10', 'Delivered');
INSERT INTO orders VALUES (1002, 'Bob',    'Phone',   1, 25000, DATE '2024-01-15', 'Pending');
INSERT INTO orders VALUES (1003, 'Carol',  'Tablet',  3, 18000, DATE '2024-02-01', 'Shipped');
INSERT INTO orders VALUES (1004, 'David',  'Laptop',  1, 75000, DATE '2024-02-10', 'Delivered');
INSERT INTO orders VALUES (1005, 'Alice',  'Headset', 5,  3500, DATE '2024-03-01', 'Pending');
INSERT INTO orders VALUES (1006, 'Eva',    'Phone',   2, 25000, DATE '2024-03-15', 'Cancelled');
COMMIT;
```

---

## How to Use This Guide

1. Open **Oracle SQL Developer** or connect via **SQL*Plus**
2. Run the sample table creation scripts above
3. Navigate to any section using the Table of Contents
4. Every command has **syntax + multiple examples + expected output**

---

## Oracle Version

This guide covers **Oracle Database 19c / 21c** commands. Most commands are compatible with Oracle 11g and above.

---

*Guide created for learners, developers, and DBAs.*
