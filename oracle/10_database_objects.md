# Section 10 — Database Objects

> Oracle supports many types of schema objects beyond tables: Views, Indexes, Sequences, and Synonyms.

---

## 10.1 VIEWS

A **view** is a stored SQL query that acts like a virtual table. Data is not physically stored in the view.

---

### CREATE VIEW

**What it does:** Creates a virtual table based on a SELECT query.

### Syntax
```sql
CREATE [OR REPLACE] [FORCE] VIEW view_name [(column_aliases)]
AS
SELECT ...
[WITH CHECK OPTION]
[WITH READ ONLY];
```

### Examples

```sql
-- Example 1: Simple view of IT employees
CREATE VIEW it_employees AS
SELECT emp_id, first_name, last_name, salary, hire_date
FROM employees
WHERE dept_id = 20;

-- Query the view like a table
SELECT * FROM it_employees;
SELECT * FROM it_employees WHERE salary > 65000;

-- Example 2: View with column aliases
CREATE VIEW emp_summary AS
SELECT e.emp_id                         AS id,
       e.first_name || ' ' || e.last_name AS full_name,
       d.dept_name,
       e.salary,
       e.hire_date
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

SELECT * FROM emp_summary ORDER BY salary DESC;

-- Example 3: View for department salary stats
CREATE VIEW dept_salary_stats AS
SELECT d.dept_name,
       COUNT(e.emp_id)    AS employee_count,
       AVG(e.salary)      AS avg_salary,
       MIN(e.salary)      AS min_salary,
       MAX(e.salary)      AS max_salary,
       SUM(e.salary)      AS total_payroll
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

SELECT * FROM dept_salary_stats ORDER BY total_payroll DESC;

-- Example 4: Read-only view (prevents DML)
CREATE VIEW orders_readonly AS
SELECT * FROM orders
WITH READ ONLY;

-- Example 5: View with CHECK OPTION (only allow matching rows via DML)
CREATE OR REPLACE VIEW high_earners AS
SELECT * FROM employees
WHERE salary >= 70000
WITH CHECK OPTION CONSTRAINT chk_high_earners;

-- This INSERT will fail (salary < 70000, violates check option)
-- INSERT INTO high_earners (emp_id, first_name, salary) VALUES (120, 'Test', 50000);

-- Example 6: OR REPLACE (update existing view without dropping)
CREATE OR REPLACE VIEW it_employees AS
SELECT emp_id, first_name, last_name, salary, job_title, hire_date
FROM employees
WHERE dept_id = 20;
```

---

### DROP VIEW

```sql
-- Drop a specific view
DROP VIEW it_employees;
DROP VIEW emp_summary;

-- Drop if exists (PL/SQL)
BEGIN
    EXECUTE IMMEDIATE 'DROP VIEW dept_salary_stats';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- View all views in current schema
SELECT view_name, text
FROM user_views;

-- Check if view is updatable
SELECT view_name, updatable
FROM user_updatable_columns
WHERE view_name = 'IT_EMPLOYEES';
```

---

## 10.2 INDEXES

An **index** is a performance structure that speeds up data retrieval. Oracle automatically creates indexes for PRIMARY KEY and UNIQUE constraints.

---

### CREATE INDEX

**What it does:** Creates an index to speed up queries on large tables.

### Syntax
```sql
CREATE [UNIQUE] INDEX index_name
ON table_name (column1 [ASC|DESC], column2, ...);
```

### Examples

```sql
-- Example 1: Simple index on salary column
CREATE INDEX idx_emp_salary
ON employees (salary);

-- Now this query is faster:
SELECT * FROM employees WHERE salary > 65000;

-- Example 2: Index on last_name for name searches
CREATE INDEX idx_emp_lastname
ON employees (last_name);

SELECT * FROM employees WHERE last_name = 'Smith';

-- Example 3: Composite index (multiple columns)
CREATE INDEX idx_emp_dept_sal
ON employees (dept_id, salary);

-- Useful for queries like:
SELECT * FROM employees WHERE dept_id = 20 ORDER BY salary DESC;

-- Example 4: Unique index
CREATE UNIQUE INDEX idx_emp_email
ON employees (email);

-- Example 5: Function-based index (case-insensitive search)
CREATE INDEX idx_upper_firstname
ON employees (UPPER(first_name));

-- Now this query uses the index:
SELECT * FROM employees WHERE UPPER(first_name) = 'ALICE';

-- Example 6: Index on orders (for status + date queries)
CREATE INDEX idx_orders_status_date
ON orders (status, order_date DESC);

-- Example 7: Bitmap index (low cardinality columns — e.g., status)
CREATE BITMAP INDEX idx_orders_status_bmp
ON orders (status);
```

---

### DROP INDEX

```sql
-- Drop an index
DROP INDEX idx_emp_salary;
DROP INDEX idx_emp_lastname;

-- View all indexes on a table
SELECT index_name, index_type, uniqueness, status
FROM user_indexes
WHERE table_name = 'EMPLOYEES';

-- View indexed columns
SELECT index_name, column_name, column_position, descend
FROM user_ind_columns
WHERE table_name = 'EMPLOYEES';
```

---

## 10.3 SEQUENCES

A **sequence** generates unique, sequential numeric values — commonly used for primary key generation.

---

### CREATE SEQUENCE

### Syntax
```sql
CREATE SEQUENCE sequence_name
    [START WITH n]
    [INCREMENT BY n]
    [MAXVALUE n | NOMAXVALUE]
    [MINVALUE n | NOMINVALUE]
    [CYCLE | NOCYCLE]
    [CACHE n | NOCACHE]
    [ORDER | NOORDER];
```

### Examples

```sql
-- Example 1: Basic auto-increment sequence for emp_id
CREATE SEQUENCE emp_seq
    START WITH 200
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Use NEXTVAL to get next value
SELECT emp_seq.NEXTVAL FROM DUAL;   -- 200
SELECT emp_seq.NEXTVAL FROM DUAL;   -- 201

-- Use CURRVAL to get current value (must call NEXTVAL first in session)
SELECT emp_seq.CURRVAL FROM DUAL;   -- 201

-- Use in INSERT
INSERT INTO employees (emp_id, first_name, last_name, salary)
VALUES (emp_seq.NEXTVAL, 'New', 'Employee', 55000);

-- Example 2: Sequence with step 10
CREATE SEQUENCE order_seq
    START WITH 2000
    INCREMENT BY 10
    MAXVALUE 99999
    NOCYCLE
    CACHE 20;

-- Example 3: Cycling sequence (resets after max)
CREATE SEQUENCE rotation_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 5
    CYCLE
    NOCACHE;

SELECT rotation_seq.NEXTVAL FROM DUAL;  -- 1
SELECT rotation_seq.NEXTVAL FROM DUAL;  -- 2
-- ... will cycle back to 1 after 5

-- Example 4: Use sequence with IDENTITY column (Oracle 12c+)
CREATE TABLE products (
    prod_id    NUMBER GENERATED ALWAYS AS IDENTITY,
    prod_name  VARCHAR2(100) NOT NULL
);

INSERT INTO products (prod_name) VALUES ('Laptop');
INSERT INTO products (prod_name) VALUES ('Phone');
SELECT * FROM products;
-- prod_id is auto-assigned: 1, 2, ...

-- Example 5: View sequence info
SELECT sequence_name, min_value, max_value, increment_by,
       cycle_flag, cache_size, last_number
FROM user_sequences;

-- Example 6: Alter a sequence
ALTER SEQUENCE emp_seq INCREMENT BY 5;
ALTER SEQUENCE emp_seq MAXVALUE 999999;

-- Example 7: Drop a sequence
DROP SEQUENCE emp_seq;
DROP SEQUENCE order_seq;
```

---

## 10.4 SYNONYMS

A **synonym** is an alias (alternate name) for a database object — useful for simplifying schema-qualified names and providing location transparency.

---

### CREATE SYNONYM

### Syntax
```sql
-- Private synonym (only for current user)
CREATE SYNONYM synonym_name FOR schema.object_name;

-- Public synonym (available to all users)
CREATE PUBLIC SYNONYM synonym_name FOR schema.object_name;
```

### Examples

```sql
-- Example 1: Create a synonym for a long table name
CREATE SYNONYM emp FOR employees;

-- Now use the shorter name
SELECT * FROM emp;
UPDATE emp SET salary = 70000 WHERE emp_id = 102;

-- Example 2: Synonym to access another user's table
-- (requires SELECT privilege on HR.employees)
CREATE SYNONYM company_employees FOR HR.employees;
SELECT * FROM company_employees;

-- Example 3: Synonym for a view
CREATE SYNONYM dept_stats FOR dept_salary_stats;
SELECT * FROM dept_stats;

-- Example 4: Public synonym (DBA privileges required)
CREATE PUBLIC SYNONYM pub_employees FOR hr.employees;
-- Now ALL users can access: SELECT * FROM pub_employees;

-- Example 5: Drop synonyms
DROP SYNONYM emp;
DROP PUBLIC SYNONYM pub_employees;

-- Example 6: View all synonyms
SELECT synonym_name, table_owner, table_name
FROM user_synonyms;

-- View public synonyms
SELECT synonym_name, table_name
FROM all_synonyms
WHERE owner = 'PUBLIC' AND table_name LIKE 'EMP%';
```

---

## 10.5 Dictionary Views for Object Information

```sql
-- All tables owned by current user
SELECT table_name, num_rows, last_analyzed
FROM user_tables
ORDER BY table_name;

-- All views
SELECT view_name FROM user_views;

-- All indexes
SELECT index_name, table_name, index_type FROM user_indexes;

-- All sequences
SELECT sequence_name, last_number FROM user_sequences;

-- All synonyms
SELECT synonym_name, table_name FROM user_synonyms;

-- All constraints
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
ORDER BY table_name, constraint_type;

-- All triggers
SELECT trigger_name, table_name, trigger_type, status
FROM user_triggers;

-- All procedures and functions
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PROCEDURE','FUNCTION','PACKAGE')
ORDER BY object_type, object_name;
```

---

[← Previous: Constraints](./09_constraints.md) | [Back to README](./README.md) | [Next: Transactions →](./11_transactions.md)
