# Section 2 — Table Creation & Structure (DDL)

> **DDL (Data Definition Language)** commands define and modify the structure of database objects.
> DDL changes are **auto-committed** — they cannot be rolled back.

---

## 2.1 CREATE TABLE

**What it does:** Creates a new table with defined columns and data types.

### Syntax
```sql
CREATE TABLE table_name (
    column1  datatype [constraint],
    column2  datatype [constraint],
    ...
    [table_constraints]
);
```

### Oracle Data Types

| Data Type       | Description                          | Example            |
|-----------------|--------------------------------------|--------------------|
| `NUMBER(p,s)`   | Numeric (precision, scale)           | `NUMBER(10,2)`     |
| `VARCHAR2(n)`   | Variable-length string               | `VARCHAR2(100)`    |
| `CHAR(n)`       | Fixed-length string                  | `CHAR(1)`          |
| `DATE`          | Date and time                        | `DATE`             |
| `TIMESTAMP`     | Date/time with fractional seconds    | `TIMESTAMP`        |
| `CLOB`          | Large character data (up to 4GB)     | `CLOB`             |
| `BLOB`          | Binary large object                  | `BLOB`             |
| `BOOLEAN`       | TRUE/FALSE (PL/SQL only)             | `BOOLEAN`          |

### Examples

```sql
-- Example 1: Basic table creation
CREATE TABLE departments (
    dept_id    NUMBER(5)    PRIMARY KEY,
    dept_name  VARCHAR2(50) NOT NULL,
    location   VARCHAR2(50)
);

-- Example 2: Employees table with foreign key
CREATE TABLE employees (
    emp_id      NUMBER(6)    PRIMARY KEY,
    first_name  VARCHAR2(50) NOT NULL,
    last_name   VARCHAR2(50) NOT NULL,
    dept_id     NUMBER(5)    REFERENCES departments(dept_id),
    salary      NUMBER(10,2) CHECK (salary > 0),
    hire_date   DATE         DEFAULT SYSDATE,
    job_title   VARCHAR2(50),
    manager_id  NUMBER(6)
);

-- Example 3: Students table
CREATE TABLE students (
    student_id  NUMBER       PRIMARY KEY,
    name        VARCHAR2(100) NOT NULL,
    grade       CHAR(1),
    marks       NUMBER(5,2),
    course      VARCHAR2(50),
    enroll_date DATE DEFAULT SYSDATE,
    CONSTRAINT chk_grade CHECK (grade IN ('A','B','C','D','F')),
    CONSTRAINT chk_marks CHECK (marks BETWEEN 0 AND 100)
);

-- Example 4: Orders table
CREATE TABLE orders (
    order_id    NUMBER       PRIMARY KEY,
    customer    VARCHAR2(100) NOT NULL,
    product     VARCHAR2(100),
    qty         NUMBER       DEFAULT 1,
    unit_price  NUMBER(10,2),
    order_date  DATE         DEFAULT SYSDATE,
    status      VARCHAR2(20) DEFAULT 'Pending'
                             CHECK (status IN ('Pending','Shipped','Delivered','Cancelled'))
);

-- Example 5: Create table from another table (CTAS)
CREATE TABLE emp_backup AS
SELECT * FROM employees;

-- Example 6: Create empty table with structure only
CREATE TABLE emp_structure AS
SELECT * FROM employees WHERE 1=2;
```

---

## 2.2 ALTER TABLE

**What it does:** Modifies the structure of an existing table — add, modify, rename, or drop columns and constraints.

### Syntax
```sql
ALTER TABLE table_name action;
```

---

### 2.2.1 Adding Columns

```sql
-- Add a single column
ALTER TABLE employees
ADD email VARCHAR2(100);

-- Add column with default value
ALTER TABLE employees
ADD is_active CHAR(1) DEFAULT 'Y';

-- Add multiple columns
ALTER TABLE students
ADD (phone VARCHAR2(15), email VARCHAR2(100), city VARCHAR2(50));

-- Add column with constraint
ALTER TABLE orders
ADD discount NUMBER(5,2) DEFAULT 0 CHECK (discount >= 0 AND discount <= 100);
```

---

### 2.2.2 Modifying Columns

```sql
-- Change data type size
ALTER TABLE employees
MODIFY first_name VARCHAR2(100);

-- Change default value
ALTER TABLE orders
MODIFY status DEFAULT 'Pending';

-- Make a column NOT NULL
ALTER TABLE employees
MODIFY email NOT NULL;

-- Remove NOT NULL constraint
ALTER TABLE employees
MODIFY email NULL;

-- Modify multiple columns
ALTER TABLE students
MODIFY (name VARCHAR2(150), course VARCHAR2(100));
```

---

### 2.2.3 Dropping Columns

```sql
-- Drop a single column
ALTER TABLE employees
DROP COLUMN email;

-- Mark column as unused (faster, no undo log)
ALTER TABLE employees
SET UNUSED COLUMN is_active;

-- Drop all unused columns
ALTER TABLE employees
DROP UNUSED COLUMNS;

-- Drop multiple columns
ALTER TABLE students
DROP (phone, city);
```

---

### 2.2.4 Renaming Columns

```sql
-- Rename a column
ALTER TABLE employees
RENAME COLUMN first_name TO fname;

-- Rename back
ALTER TABLE employees
RENAME COLUMN fname TO first_name;

-- Rename in orders table
ALTER TABLE orders
RENAME COLUMN unit_price TO price_per_unit;
```

---

### 2.2.5 Adding Constraints via ALTER TABLE

```sql
-- Add PRIMARY KEY
ALTER TABLE employees
ADD CONSTRAINT pk_emp PRIMARY KEY (emp_id);

-- Add FOREIGN KEY
ALTER TABLE employees
ADD CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

-- Add UNIQUE constraint
ALTER TABLE employees
ADD CONSTRAINT uq_email UNIQUE (email);

-- Add CHECK constraint
ALTER TABLE employees
ADD CONSTRAINT chk_salary CHECK (salary BETWEEN 10000 AND 500000);

-- Add NOT NULL (done via MODIFY)
ALTER TABLE employees
MODIFY job_title NOT NULL;

-- Drop a constraint
ALTER TABLE employees
DROP CONSTRAINT chk_salary;

-- Disable a constraint
ALTER TABLE employees
DISABLE CONSTRAINT fk_dept;

-- Enable a constraint
ALTER TABLE employees
ENABLE CONSTRAINT fk_dept;
```

---

## 2.3 DROP TABLE

**What it does:** Permanently removes a table and all its data from the database.

### Syntax
```sql
DROP TABLE table_name [CASCADE CONSTRAINTS] [PURGE];
```

### Examples

```sql
-- Drop a simple table
DROP TABLE emp_backup;

-- Drop table with dependent foreign key constraints
DROP TABLE departments CASCADE CONSTRAINTS;

-- Drop table and bypass recycle bin (no recovery possible)
DROP TABLE emp_structure PURGE;

-- Check if table exists before dropping (PL/SQL)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE temp_employees';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist, skipping drop.');
        ELSE
            RAISE;
        END IF;
END;
/

-- Recover a dropped table from recycle bin
FLASHBACK TABLE emp_backup TO BEFORE DROP;

-- Show objects in recycle bin
SELECT * FROM RECYCLEBIN;
```

---

## 2.4 TRUNCATE TABLE

**What it does:** Removes all rows from a table instantly (no undo log, no WHERE clause). Faster than DELETE for clearing data.

### Syntax
```sql
TRUNCATE TABLE table_name;
```

### Examples

```sql
-- Remove all rows from orders table
TRUNCATE TABLE orders;

-- Remove all rows from students table
TRUNCATE TABLE students;

-- Truncate with REUSE STORAGE (keeps allocated space)
TRUNCATE TABLE employees REUSE STORAGE;

-- Truncate and release storage
TRUNCATE TABLE employees DROP STORAGE;
```

**Difference: DELETE vs TRUNCATE**

| Feature         | DELETE          | TRUNCATE             |
|-----------------|-----------------|----------------------|
| Can use WHERE   | Yes             | No                   |
| Can rollback    | Yes             | No (DDL)             |
| Speed           | Slower          | Very fast            |
| Triggers fired  | Yes             | No                   |
| Resets sequence | No              | Yes (if applicable)  |

---

## 2.5 RENAME TABLE

**What it does:** Renames an existing table.

### Syntax
```sql
RENAME old_table_name TO new_table_name;

-- Or using ALTER TABLE:
ALTER TABLE old_name RENAME TO new_name;
```

### Examples

```sql
-- Rename employees to staff
RENAME employees TO staff;

-- Rename back
RENAME staff TO employees;

-- Using ALTER TABLE syntax
ALTER TABLE orders RENAME TO sales_orders;

-- Rename back
ALTER TABLE sales_orders RENAME TO orders;

-- Rename a view
RENAME old_view TO new_view;
```

---

## 2.6 COMMENT ON TABLE/COLUMN

**What it does:** Adds descriptive metadata comments to tables and columns.

### Examples

```sql
-- Comment on a table
COMMENT ON TABLE employees IS 'Stores all employee records for the company';

-- Comment on a column
COMMENT ON COLUMN employees.salary IS 'Monthly gross salary in INR';

-- View comments
SELECT table_name, comments
FROM user_tab_comments
WHERE table_name = 'EMPLOYEES';

SELECT column_name, comments
FROM user_col_comments
WHERE table_name = 'EMPLOYEES';
```

---

[← Previous: Basic Commands](./01_basic_commands.md) | [Back to README](./README.md) | [Next: DML Commands →](./03_dml_commands.md)
