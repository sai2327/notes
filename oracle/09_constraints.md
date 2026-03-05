# Section 9 — Constraints

> **Constraints** enforce rules on data in a table to maintain accuracy and integrity.

---

## 9.1 NOT NULL

**What it does:** Ensures a column cannot store NULL values.

### During Table Creation
```sql
CREATE TABLE students (
    student_id  NUMBER       NOT NULL,
    name        VARCHAR2(100) NOT NULL,
    email       VARCHAR2(100),           -- nullable
    course      VARCHAR2(50) NOT NULL
);
```

### Using ALTER TABLE
```sql
-- Add NOT NULL constraint
ALTER TABLE employees
MODIFY job_title NOT NULL;

-- Remove NOT NULL (allow nulls again)
ALTER TABLE employees
MODIFY job_title NULL;
```

---

## 9.2 UNIQUE

**What it does:** Ensures all values in a column (or column group) are distinct. Allows one NULL.

### During Table Creation
```sql
CREATE TABLE employees (
    emp_id  NUMBER PRIMARY KEY,
    email   VARCHAR2(100) UNIQUE,              -- column-level
    phone   VARCHAR2(15),
    CONSTRAINT uq_phone UNIQUE (phone)         -- table-level with name
);
```

### Using ALTER TABLE
```sql
-- Add unique constraint
ALTER TABLE employees
ADD CONSTRAINT uq_emp_email UNIQUE (email);

-- Add composite unique (combination must be unique)
ALTER TABLE orders
ADD CONSTRAINT uq_order_product UNIQUE (customer, product, order_date);

-- Drop unique constraint
ALTER TABLE employees
DROP CONSTRAINT uq_emp_email;

-- Verify unique constraint
SELECT constraint_name, constraint_type, column_name
FROM user_cons_columns
WHERE table_name = 'EMPLOYEES';
```

---

## 9.3 PRIMARY KEY

**What it does:** Uniquely identifies each row. Combines NOT NULL + UNIQUE. Only one per table.

### During Table Creation
```sql
-- Column-level
CREATE TABLE departments (
    dept_id   NUMBER PRIMARY KEY,
    dept_name VARCHAR2(50) NOT NULL
);

-- Table-level with constraint name
CREATE TABLE employees (
    emp_id    NUMBER,
    first_name VARCHAR2(50),
    CONSTRAINT pk_employees PRIMARY KEY (emp_id)
);

-- Composite primary key (multi-column)
CREATE TABLE enrollment (
    student_id  NUMBER,
    course_id   NUMBER,
    enroll_date DATE,
    CONSTRAINT pk_enrollment PRIMARY KEY (student_id, course_id)
);
```

### Using ALTER TABLE
```sql
-- Add primary key
ALTER TABLE students
ADD CONSTRAINT pk_students PRIMARY KEY (student_id);

-- Drop primary key
ALTER TABLE students
DROP PRIMARY KEY;

-- Drop primary key by constraint name
ALTER TABLE students
DROP CONSTRAINT pk_students;

-- Disable/enable primary key
ALTER TABLE employees DISABLE PRIMARY KEY;
ALTER TABLE employees ENABLE  PRIMARY KEY;
```

---

## 9.4 FOREIGN KEY

**What it does:** Enforces referential integrity — links a column to the primary key of another table.

### During Table Creation
```sql
-- Column-level
CREATE TABLE employees (
    emp_id    NUMBER PRIMARY KEY,
    dept_id   NUMBER REFERENCES departments(dept_id),
    manager_id NUMBER REFERENCES employees(emp_id)   -- self-referencing FK
);

-- Table-level with constraint name and action
CREATE TABLE employees (
    emp_id    NUMBER,
    dept_id   NUMBER,
    CONSTRAINT pk_emp PRIMARY KEY (emp_id),
    CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
        ON DELETE CASCADE
);
```

### ON DELETE Options
```sql
-- ON DELETE CASCADE: deleting parent also deletes child rows
CREATE TABLE orders (
    order_id   NUMBER PRIMARY KEY,
    emp_id     NUMBER,
    CONSTRAINT fk_order_emp FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE CASCADE
);

-- ON DELETE SET NULL: sets child FK to NULL when parent is deleted
CREATE TABLE orders (
    order_id   NUMBER PRIMARY KEY,
    emp_id     NUMBER,
    CONSTRAINT fk_order_emp FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON DELETE SET NULL
);
```

### Using ALTER TABLE
```sql
-- Add foreign key
ALTER TABLE employees
ADD CONSTRAINT fk_emp_dept
    FOREIGN KEY (dept_id)
    REFERENCES departments(dept_id);

-- Drop foreign key
ALTER TABLE employees
DROP CONSTRAINT fk_emp_dept;

-- Disable FK (to load bulk data faster)
ALTER TABLE employees DISABLE CONSTRAINT fk_emp_dept;
ALTER TABLE employees ENABLE  CONSTRAINT fk_emp_dept;

-- View all foreign keys
SELECT a.constraint_name, a.table_name, a.column_name,
       c.r_constraint_name, c_pk.table_name AS referenced_table
FROM user_cons_columns a
JOIN user_constraints c   ON a.constraint_name = c.constraint_name
JOIN user_constraints c_pk ON c.r_constraint_name = c_pk.constraint_name
WHERE c.constraint_type = 'R';
```

---

## 9.5 CHECK

**What it does:** Validates that column values satisfy a specified condition.

### During Table Creation
```sql
-- Column-level check
CREATE TABLE employees (
    emp_id   NUMBER PRIMARY KEY,
    salary   NUMBER  CHECK (salary > 0),
    grade    CHAR(1) CHECK (grade IN ('A','B','C','D','F'))
);

-- Table-level check with name
CREATE TABLE students (
    marks  NUMBER(5,2),
    CONSTRAINT chk_marks CHECK (marks BETWEEN 0 AND 100)
);

-- Complex check constraint
CREATE TABLE orders (
    qty        NUMBER,
    unit_price NUMBER(10,2),
    discount   NUMBER(5,2),
    CONSTRAINT chk_discount CHECK (discount >= 0 AND discount < unit_price)
);
```

### Using ALTER TABLE
```sql
-- Add check constraint
ALTER TABLE employees
ADD CONSTRAINT chk_salary CHECK (salary BETWEEN 10000 AND 500000);

-- Add check on hire date
ALTER TABLE employees
ADD CONSTRAINT chk_hire_date CHECK (hire_date >= DATE '2000-01-01');

-- Drop check constraint
ALTER TABLE employees
DROP CONSTRAINT chk_salary;

-- View check constraints
SELECT constraint_name, search_condition
FROM user_constraints
WHERE table_name = 'EMPLOYEES' AND constraint_type = 'C';
```

---

## 9.6 DEFAULT

**What it does:** Specifies a default value for a column when no value is provided during INSERT.

### During Table Creation
```sql
CREATE TABLE orders (
    order_id    NUMBER PRIMARY KEY,
    order_date  DATE    DEFAULT SYSDATE,
    status      VARCHAR2(20) DEFAULT 'Pending',
    qty         NUMBER  DEFAULT 1,
    discount    NUMBER  DEFAULT 0
);
```

### Using ALTER TABLE
```sql
-- Add default value to existing column
ALTER TABLE employees
MODIFY hire_date DEFAULT SYSDATE;

-- Remove default value
ALTER TABLE employees
MODIFY hire_date DEFAULT NULL;
```

### Using DEFAULT in INSERT
```sql
-- Use DEFAULT keyword explicitly
INSERT INTO orders (order_id, customer, product)
VALUES (1010, 'Tom', 'Keyboard');
-- order_date = SYSDATE, status = 'Pending', qty = 1

-- Force default using keyword
INSERT INTO orders (order_id, customer, product, qty)
VALUES (1011, 'Sam', 'Mouse', DEFAULT);
-- qty = 1 (default)
```

---

## 9.7 Constraints Summary Table

| Constraint    | Purpose                               | Allows NULL | Count per Table |
|---------------|---------------------------------------|-------------|-----------------|
| `NOT NULL`    | Column must have a value              | No          | Multiple        |
| `UNIQUE`      | All values distinct, one NULL OK      | Yes (one)   | Multiple        |
| `PRIMARY KEY` | Unique + Not Null row identifier      | No          | **One only**    |
| `FOREIGN KEY` | References a PK in another table      | Yes         | Multiple        |
| `CHECK`       | Custom validation condition           | Yes         | Multiple        |
| `DEFAULT`     | Default value when not specified      | -           | Multiple        |

---

## 9.8 View All Constraints

```sql
-- View all constraints on a table
SELECT constraint_name,
       constraint_type,
       status,
       search_condition
FROM user_constraints
WHERE table_name = 'EMPLOYEES'
ORDER BY constraint_type;

-- Constraint types:
-- P = Primary Key
-- U = Unique
-- R = Referential (Foreign Key)
-- C = Check (includes NOT NULL)

-- View constraint columns
SELECT c.constraint_name,
       c.constraint_type,
       cc.column_name
FROM user_constraints c
JOIN user_cons_columns cc ON c.constraint_name = cc.constraint_name
WHERE c.table_name = 'EMPLOYEES';
```

---

[← Previous: Subqueries](./08_subqueries.md) | [Back to README](./README.md) | [Next: Database Objects →](./10_database_objects.md)
