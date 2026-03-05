# Section 3 — Data Manipulation Language (DML)

> **DML commands** insert, update, delete, and merge rows in tables.
> DML changes are **NOT auto-committed** — always use COMMIT or ROLLBACK.

---

## 3.1 INSERT

**What it does:** Adds one or more new rows into a table.

### Syntax
```sql
-- Insert with column list (recommended)
INSERT INTO table_name (col1, col2, ...) VALUES (val1, val2, ...);

-- Insert without column list (must match all columns in order)
INSERT INTO table_name VALUES (val1, val2, ...);
```

### Examples

```sql
-- Insert a single employee record
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, job_title)
VALUES (109, 'James', 'Taylor', 20, 62000, DATE '2024-01-10', 'Developer');

-- Insert with SYSDATE for date
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, job_title)
VALUES (110, 'Nina', 'Parker', 40, 58000, SYSDATE, 'Designer');

-- Insert into students table
INSERT INTO students (student_id, name, grade, marks, course, enroll_date)
VALUES (7, 'Mehul Joshi', 'B', 82.5, 'Physics', DATE '2023-08-01');

-- Insert into orders table
INSERT INTO orders (order_id, customer, product, qty, unit_price, order_date, status)
VALUES (1007, 'Frank', 'Monitor', 2, 12000, SYSDATE, 'Pending');

-- Insert from another table
INSERT INTO emp_backup
SELECT * FROM employees WHERE dept_id = 20;

-- Insert with NULL value
INSERT INTO employees (emp_id, first_name, last_name, dept_id, salary, hire_date, job_title, manager_id)
VALUES (111, 'Sara', 'Khan', 30, 57000, SYSDATE, 'Intern', NULL);

COMMIT;
```

---

## 3.2 INSERT ALL

**What it does:** Inserts multiple rows into one or more tables in a single statement.

### Syntax
```sql
-- Unconditional INSERT ALL
INSERT ALL
    INTO table1 (cols) VALUES (vals)
    INTO table2 (cols) VALUES (vals)
    ...
SELECT * FROM DUAL;

-- Conditional INSERT ALL
INSERT ALL
    WHEN condition1 THEN INTO table1 VALUES (...)
    WHEN condition2 THEN INTO table2 VALUES (...)
    ELSE INTO table3 VALUES (...)
SELECT ... FROM source_table;
```

### Examples

```sql
-- Example 1: Insert multiple rows into one table
INSERT ALL
    INTO students (student_id, name, grade, marks, course)
        VALUES (8,  'Ravi Kumar',    'A', 91.0, 'Computer Science')
    INTO students (student_id, name, grade, marks, course)
        VALUES (9,  'Pooja Sharma',  'B', 76.5, 'Mathematics')
    INTO students (student_id, name, grade, marks, course)
        VALUES (10, 'Nikhil Verma',  'C', 63.0, 'Physics')
SELECT * FROM DUAL;

COMMIT;

-- Example 2: Conditional INSERT ALL — route rows to different tables
-- First, create target tables
CREATE TABLE high_earners   AS SELECT * FROM employees WHERE 1=2;
CREATE TABLE mid_earners    AS SELECT * FROM employees WHERE 1=2;
CREATE TABLE low_earners    AS SELECT * FROM employees WHERE 1=2;

-- Then insert conditionally
INSERT ALL
    WHEN salary >= 70000 THEN
        INTO high_earners VALUES (emp_id, first_name, last_name, dept_id, salary, hire_date, job_title, manager_id)
    WHEN salary BETWEEN 55000 AND 69999 THEN
        INTO mid_earners  VALUES (emp_id, first_name, last_name, dept_id, salary, hire_date, job_title, manager_id)
    ELSE
        INTO low_earners  VALUES (emp_id, first_name, last_name, dept_id, salary, hire_date, job_title, manager_id)
SELECT emp_id, first_name, last_name, dept_id, salary, hire_date, job_title, manager_id
FROM employees;

COMMIT;

-- Verify
SELECT 'HIGH'  AS category, COUNT(*) AS cnt FROM high_earners
UNION ALL
SELECT 'MID'   AS category, COUNT(*) AS cnt FROM mid_earners
UNION ALL
SELECT 'LOW'   AS category, COUNT(*) AS cnt FROM low_earners;

-- Example 3: INSERT FIRST (stops at first matched condition)
INSERT FIRST
    WHEN salary > 70000 THEN
        INTO high_earners VALUES (emp_id, first_name, last_name, dept_id, salary, hire_date, job_title, manager_id)
    WHEN dept_id = 20 THEN
        INTO mid_earners  VALUES (emp_id, first_name, last_name, dept_id, salary, hire_date, job_title, manager_id)
SELECT emp_id, first_name, last_name, dept_id, salary, hire_date, job_title, manager_id
FROM employees;

COMMIT;
```

---

## 3.3 UPDATE

**What it does:** Modifies existing row values in a table.

### Syntax
```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
[WHERE condition];
```

> ⚠️ **WARNING:** Always use a WHERE clause! Without it, ALL rows are updated.

### Examples

```sql
-- Example 1: Update salary for one employee
UPDATE employees
SET salary = 75000
WHERE emp_id = 103;

-- Example 2: Give 10% raise to IT department
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 20;

-- Example 3: Update multiple columns
UPDATE employees
SET salary    = 80000,
    job_title = 'Senior Developer'
WHERE emp_id = 102;

-- Example 4: Update using subquery
UPDATE employees
SET salary = salary * 1.05
WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'Finance');

-- Example 5: Update order status
UPDATE orders
SET status = 'Delivered'
WHERE order_id = 1002;

-- Example 6: Update all pending orders before a date
UPDATE orders
SET status = 'Cancelled'
WHERE status = 'Pending'
  AND order_date < DATE '2024-02-01';

-- Example 7: Update student grade based on marks
UPDATE students
SET grade = CASE
    WHEN marks >= 90 THEN 'A'
    WHEN marks >= 75 THEN 'B'
    WHEN marks >= 60 THEN 'C'
    WHEN marks >= 40 THEN 'D'
    ELSE 'F'
END;

COMMIT;
```

---

## 3.4 DELETE

**What it does:** Removes one or more rows from a table based on a condition.

### Syntax
```sql
DELETE FROM table_name
[WHERE condition];
```

> ⚠️ **WARNING:** Without WHERE clause, ALL rows are deleted (can be rolled back, unlike TRUNCATE).

### Examples

```sql
-- Example 1: Delete a specific employee
DELETE FROM employees
WHERE emp_id = 111;

-- Example 2: Delete all cancelled orders
DELETE FROM orders
WHERE status = 'Cancelled';

-- Example 3: Delete employees in a department (using subquery)
DELETE FROM employees
WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'Marketing');

-- Example 4: Delete students with low marks
DELETE FROM students
WHERE marks < 40;

-- Example 5: Delete orders older than 1 year
DELETE FROM orders
WHERE order_date < ADD_MONTHS(SYSDATE, -12);

-- Example 6: Delete duplicate rows (keep lowest rowid)
DELETE FROM employees e1
WHERE ROWID > (
    SELECT MIN(ROWID)
    FROM employees e2
    WHERE e1.emp_id = e2.emp_id
);

-- After DELETE, check count and commit
SELECT COUNT(*) FROM employees;
COMMIT;
```

---

## 3.5 MERGE

**What it does:** Combines INSERT and UPDATE into one statement — inserts if row doesn't exist, updates if it does ("upsert").

### Syntax
```sql
MERGE INTO target_table t
USING source_table s
ON (t.join_column = s.join_column)
WHEN MATCHED THEN
    UPDATE SET t.col1 = s.col1, t.col2 = s.col2
    [DELETE WHERE condition]
WHEN NOT MATCHED THEN
    INSERT (col1, col2, ...) VALUES (s.col1, s.col2, ...);
```

### Examples

```sql
-- Example 1: Create a staging table to merge from
CREATE TABLE emp_updates (
    emp_id     NUMBER,
    salary     NUMBER(10,2),
    job_title  VARCHAR2(50)
);

INSERT INTO emp_updates VALUES (102, 78000, 'Lead DBA');
INSERT INTO emp_updates VALUES (103, 72000, 'Senior Developer');
INSERT INTO emp_updates VALUES (112, 65000, 'Tester');   -- new employee
COMMIT;

-- MERGE: update existing, insert new
MERGE INTO employees e
USING emp_updates u
ON (e.emp_id = u.emp_id)
WHEN MATCHED THEN
    UPDATE SET
        e.salary    = u.salary,
        e.job_title = u.job_title
WHEN NOT MATCHED THEN
    INSERT (emp_id, first_name, last_name, dept_id, salary, hire_date, job_title)
    VALUES (u.emp_id, 'New', 'Employee', 20, u.salary, SYSDATE, u.job_title);

COMMIT;

-- Verify the results
SELECT emp_id, first_name, salary, job_title
FROM employees
WHERE emp_id IN (102, 103, 112);

-- Example 2: MERGE with DELETE clause
-- Delete matched rows where salary < 50000 (after update)
MERGE INTO employees e
USING emp_updates u
ON (e.emp_id = u.emp_id)
WHEN MATCHED THEN
    UPDATE SET e.salary = u.salary
    DELETE WHERE e.salary < 50000
WHEN NOT MATCHED THEN
    INSERT (emp_id, first_name, salary)
    VALUES (u.emp_id, 'Unknown', u.salary);

COMMIT;

-- Example 3: MERGE orders — update qty if order exists, else insert
CREATE TABLE orders_staging (
    order_id   NUMBER,
    customer   VARCHAR2(100),
    product    VARCHAR2(100),
    qty        NUMBER,
    unit_price NUMBER(10,2),
    status     VARCHAR2(20)
);

INSERT INTO orders_staging VALUES (1002, 'Bob',   'Phone',  3, 25000, 'Shipped');
INSERT INTO orders_staging VALUES (1008, 'Grace', 'Tablet', 2, 18000, 'Pending');
COMMIT;

MERGE INTO orders o
USING orders_staging s
ON (o.order_id = s.order_id)
WHEN MATCHED THEN
    UPDATE SET o.qty    = s.qty,
               o.status = s.status
WHEN NOT MATCHED THEN
    INSERT (order_id, customer, product, qty, unit_price, order_date, status)
    VALUES (s.order_id, s.customer, s.product, s.qty, s.unit_price, SYSDATE, s.status);

COMMIT;
```

---

## 3.6 DML Summary Table

| Command      | Action                              | Rollback Possible |
|--------------|-------------------------------------|-------------------|
| `INSERT`     | Adds new rows                       | Yes               |
| `INSERT ALL` | Adds multiple rows / to multi-table | Yes               |
| `UPDATE`     | Modifies existing rows              | Yes               |
| `DELETE`     | Removes specific rows               | Yes               |
| `MERGE`      | Insert + Update in one statement    | Yes               |
| `TRUNCATE`   | Removes ALL rows (DDL, not DML)     | **No**            |

---

[← Previous: DDL Commands](./02_ddl_commands.md) | [Back to README](./README.md) | [Next: Query Commands →](./04_query_commands.md)
