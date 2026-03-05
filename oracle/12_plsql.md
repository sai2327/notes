# Section 12 — PL/SQL Commands

> **PL/SQL** (Procedural Language/SQL) is Oracle's procedural extension to SQL.
> It adds variables, conditions, loops, procedures, functions, and exception handling.

---

## 12.1 PL/SQL Block Structure

Every PL/SQL program is structured as a **block**:

```
DECLARE   (optional)  — variable declarations
BEGIN     (required)  — executable statements
EXCEPTION (optional)  — error handling
END;      (required)  — end of block
```

### Minimal PL/SQL Block

```sql
-- Simplest PL/SQL block
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, Oracle!');
END;
/

-- Enable output (run this first in SQL*Plus / SQL Developer)
SET SERVEROUTPUT ON;
```

---

## 12.2 DECLARE — Variables and Constants

**What it does:** Declares variables, constants, and cursors used in the block.

### Syntax
```sql
variable_name  datatype [:= initial_value];
constant_name  CONSTANT datatype := value;
```

### Examples

```sql
SET SERVEROUTPUT ON;

DECLARE
    -- Scalar variables
    v_emp_id    NUMBER          := 101;
    v_name      VARCHAR2(100);
    v_salary    NUMBER(10,2)    := 0;
    v_hire_date DATE;
    v_active    BOOLEAN         := TRUE;

    -- Constant
    c_tax_rate  CONSTANT NUMBER := 0.18;

    -- %TYPE: matches the column's data type automatically
    v_dept_name departments.dept_name%TYPE;
    v_emp_sal   employees.salary%TYPE;

    -- %ROWTYPE: holds an entire row
    v_emp_row   employees%ROWTYPE;

BEGIN
    -- Assign values
    v_name := 'Alice Smith';
    v_salary := 65000;

    -- Use %TYPE variable
    SELECT dept_name INTO v_dept_name
    FROM departments WHERE dept_id = 20;

    -- Use %ROWTYPE
    SELECT * INTO v_emp_row
    FROM employees WHERE emp_id = 101;

    -- Fetch individual columns
    SELECT first_name, salary, hire_date
    INTO v_name, v_salary, v_hire_date
    FROM employees WHERE emp_id = v_emp_id;

    -- Calculations
    DBMS_OUTPUT.PUT_LINE('Employee : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Salary   : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('Tax      : ' || (v_salary * c_tax_rate));
    DBMS_OUTPUT.PUT_LINE('Net Pay  : ' || (v_salary - v_salary * c_tax_rate));
    DBMS_OUTPUT.PUT_LINE('Dept     : ' || v_dept_name);
    DBMS_OUTPUT.PUT_LINE('Row Name : ' || v_emp_row.first_name);

END;
/
```

---

## 12.3 IF Statements

### Simple IF

```sql
SET SERVEROUTPUT ON;

DECLARE
    v_salary NUMBER := 72000;
BEGIN
    IF v_salary > 70000 THEN
        DBMS_OUTPUT.PUT_LINE('High Earner');
    END IF;
END;
/
```

### IF-ELSE

```sql
DECLARE
    v_marks NUMBER := 65;
BEGIN
    IF v_marks >= 40 THEN
        DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('FAIL');
    END IF;
END;
/
```

### IF-ELSIF-ELSE

```sql
DECLARE
    v_marks NUMBER := 78;
    v_grade VARCHAR2(5);
BEGIN
    IF    v_marks >= 90 THEN v_grade := 'A';
    ELSIF v_marks >= 75 THEN v_grade := 'B';
    ELSIF v_marks >= 60 THEN v_grade := 'C';
    ELSIF v_marks >= 40 THEN v_grade := 'D';
    ELSE                     v_grade := 'F';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Marks: ' || v_marks || ' | Grade: ' || v_grade);
END;
/
```

---

## 12.4 CASE Statements

### Simple CASE

```sql
DECLARE
    v_dept_id NUMBER := 20;
    v_dept    VARCHAR2(50);
BEGIN
    v_dept := CASE v_dept_id
                  WHEN 10 THEN 'HR'
                  WHEN 20 THEN 'IT'
                  WHEN 30 THEN 'Finance'
                  WHEN 40 THEN 'Marketing'
                  ELSE 'Unknown'
              END;
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept);
END;
/
```

### Searched CASE

```sql
DECLARE
    v_salary NUMBER;
    v_level  VARCHAR2(20);
BEGIN
    SELECT salary INTO v_salary FROM employees WHERE emp_id = 102;

    v_level := CASE
        WHEN v_salary >= 70000 THEN 'Senior'
        WHEN v_salary >= 55000 THEN 'Mid-Level'
        ELSE                        'Junior'
    END;

    DBMS_OUTPUT.PUT_LINE('Salary Level: ' || v_level);
END;
/
```

---

## 12.5 Loops

---

### Basic LOOP

```sql
DECLARE
    v_counter NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Count: ' || v_counter);
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 5;
    END LOOP;
END;
/
```

---

### WHILE LOOP

```sql
DECLARE
    v_n NUMBER := 1;
    v_sum NUMBER := 0;
BEGIN
    WHILE v_n <= 10 LOOP
        v_sum := v_sum + v_n;
        v_n := v_n + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Sum 1 to 10: ' || v_sum);  -- 55
END;
/
```

---

### FOR LOOP (Numeric)

```sql
-- Count 1 to 5
BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('Iteration: ' || i);
    END LOOP;
END;
/

-- Reverse loop
BEGIN
    FOR i IN REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('Countdown: ' || i);
    END LOOP;
END;
/

-- Multiplication table
BEGIN
    FOR i IN 1..5 LOOP
        FOR j IN 1..5 LOOP
            DBMS_OUTPUT.PUT_LINE(i || ' x ' || j || ' = ' || (i*j));
        END LOOP;
    END LOOP;
END;
/
```

---

### Cursor FOR LOOP (most common loop)

```sql
-- Loop through query results automatically
BEGIN
    FOR rec IN (SELECT emp_id, first_name, salary FROM employees ORDER BY emp_id) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.emp_id || ' | ' || rec.first_name || ' | ' || rec.salary);
    END LOOP;
END;
/
```

---

## 12.6 Cursors

A **cursor** is a pointer to the result set of a query. Used for processing rows one at a time.

---

### Explicit Cursor

```sql
DECLARE
    -- 1. Declare cursor
    CURSOR emp_cursor IS
        SELECT emp_id, first_name, salary
        FROM employees
        WHERE dept_id = 20
        ORDER BY salary DESC;

    -- Variables to hold fetched values
    v_id    employees.emp_id%TYPE;
    v_name  employees.first_name%TYPE;
    v_sal   employees.salary%TYPE;

BEGIN
    -- 2. Open cursor
    OPEN emp_cursor;

    -- 3. Fetch rows in a loop
    LOOP
        FETCH emp_cursor INTO v_id, v_name, v_sal;
        EXIT WHEN emp_cursor%NOTFOUND;    -- exit when no more rows

        DBMS_OUTPUT.PUT_LINE(v_id || ' | ' || v_name || ' | ' || v_sal);
    END LOOP;

    -- 4. Close cursor
    CLOSE emp_cursor;
END;
/
```

### Cursor Attributes

| Attribute          | Description                                     |
|--------------------|-------------------------------------------------|
| `%FOUND`           | TRUE if last FETCH returned a row               |
| `%NOTFOUND`        | TRUE if last FETCH returned no row              |
| `%ROWCOUNT`        | Number of rows fetched so far                   |
| `%ISOPEN`          | TRUE if cursor is open                          |

---

### Cursor with Parameters

```sql
DECLARE
    CURSOR dept_emp_cursor (p_dept_id NUMBER) IS
        SELECT first_name, salary
        FROM employees
        WHERE dept_id = p_dept_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== IT Department ===');
    FOR rec IN dept_emp_cursor(20) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.first_name || ' - ' || rec.salary);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('=== HR Department ===');
    FOR rec IN dept_emp_cursor(10) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.first_name || ' - ' || rec.salary);
    END LOOP;
END;
/
```

---

### REF CURSOR (Dynamic Cursor)

```sql
DECLARE
    TYPE emp_refcursor IS REF CURSOR RETURN employees%ROWTYPE;
    v_cursor emp_refcursor;
    v_emp    employees%ROWTYPE;
BEGIN
    OPEN v_cursor FOR SELECT * FROM employees WHERE salary > 65000;

    LOOP
        FETCH v_cursor INTO v_emp;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_emp.first_name || ': ' || v_emp.salary);
    END LOOP;

    CLOSE v_cursor;
END;
/
```

---

## 12.7 Exception Handling

**Predefined Oracle Exceptions:**

| Exception               | SQLCODE | Trigger                                  |
|-------------------------|---------|------------------------------------------|
| `NO_DATA_FOUND`         | +100    | SELECT INTO returns no rows              |
| `TOO_MANY_ROWS`         | -1422   | SELECT INTO returns more than one row    |
| `ZERO_DIVIDE`           | -1476   | Division by zero                         |
| `VALUE_ERROR`           | -6502   | Numeric/value conversion error           |
| `DUP_VAL_ON_INDEX`      | -1      | Unique constraint violated               |
| `INVALID_NUMBER`        | -1722   | Invalid number string                    |
| `OTHERS`                | -       | Catches all other exceptions             |

```sql
-- Example 1: Handle NO_DATA_FOUND
DECLARE
    v_name employees.first_name%TYPE;
BEGIN
    SELECT first_name INTO v_name
    FROM employees WHERE emp_id = 9999;   -- doesn't exist

    DBMS_OUTPUT.PUT_LINE('Found: ' || v_name);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No employee with that ID.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Multiple rows returned!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

-- Example 2: Handle division by zero
DECLARE
    v_result NUMBER;
BEGIN
    v_result := 100 / 0;
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_result);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Cannot divide by zero!');
END;
/

-- Example 3: User-defined exception
DECLARE
    e_low_salary EXCEPTION;   -- declare custom exception
    v_salary     NUMBER := 8000;
BEGIN
    IF v_salary < 10000 THEN
        RAISE e_low_salary;   -- raise it
    END IF;
    DBMS_OUTPUT.PUT_LINE('Salary OK');
EXCEPTION
    WHEN e_low_salary THEN
        DBMS_OUTPUT.PUT_LINE('Salary too low! Minimum is 10000.');
END;
/

-- Example 4: RAISE_APPLICATION_ERROR (custom error with code)
DECLARE
    v_emp_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_emp_count FROM employees WHERE emp_id = 9999;
    IF v_emp_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee ID 9999 not found');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error ' || SQLCODE || ': ' || SQLERRM);
END;
/
```

---

## 12.8 PROCEDURES

**What it does:** A named PL/SQL block that performs an action. Called by name. Can have IN, OUT, IN OUT parameters.

### Syntax
```sql
CREATE [OR REPLACE] PROCEDURE proc_name
    [(parameter [IN|OUT|IN OUT] datatype, ...)]
AS
    -- declarations
BEGIN
    -- statements
EXCEPTION
    -- handlers
END proc_name;
/
```

### Examples

```sql
-- Example 1: Procedure to give salary raise
CREATE OR REPLACE PROCEDURE give_raise (
    p_emp_id   IN  NUMBER,
    p_percent  IN  NUMBER
)
AS
    v_current_sal NUMBER;
BEGIN
    SELECT salary INTO v_current_sal
    FROM employees WHERE emp_id = p_emp_id;

    UPDATE employees
    SET salary = salary * (1 + p_percent / 100)
    WHERE emp_id = p_emp_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Raise applied for EMP ' || p_emp_id ||
                         ': was ' || v_current_sal ||
                         ', now ' || (v_current_sal * (1 + p_percent/100)));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee ' || p_emp_id || ' not found.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END give_raise;
/

-- Call the procedure
EXEC give_raise(102, 10);           -- 10% raise for emp 102
EXECUTE give_raise(103, 15);        -- 15% raise for emp 103

-- From PL/SQL block
BEGIN
    give_raise(104, 5);
END;
/

-- Example 2: Procedure with OUT parameter
CREATE OR REPLACE PROCEDURE get_emp_info (
    p_emp_id    IN  NUMBER,
    p_name      OUT VARCHAR2,
    p_salary    OUT NUMBER,
    p_dept      OUT VARCHAR2
)
AS
BEGIN
    SELECT e.first_name || ' ' || e.last_name,
           e.salary,
           d.dept_name
    INTO p_name, p_salary, p_dept
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    WHERE e.emp_id = p_emp_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_name := 'NOT FOUND';
        p_salary := 0;
        p_dept := 'N/A';
END get_emp_info;
/

-- Call procedure with OUT params
DECLARE
    v_name   VARCHAR2(100);
    v_sal    NUMBER;
    v_dept   VARCHAR2(50);
BEGIN
    get_emp_info(102, v_name, v_sal, v_dept);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('Dept: ' || v_dept);
END;
/

-- View procedure source code
SELECT text FROM user_source WHERE name = 'GIVE_RAISE' ORDER BY line;

-- Drop procedure
DROP PROCEDURE give_raise;
```

---

## 12.9 FUNCTIONS

**What it does:** A named PL/SQL block that returns a single value. Can be used inside SQL queries.

### Syntax
```sql
CREATE [OR REPLACE] FUNCTION func_name
    [(parameter datatype, ...)]
RETURN return_datatype
AS
    -- declarations
BEGIN
    -- statements
    RETURN value;
END func_name;
/
```

### Examples

```sql
-- Example 1: Function to calculate annual salary
CREATE OR REPLACE FUNCTION annual_salary (
    p_monthly NUMBER,
    p_bonus   NUMBER DEFAULT 0
)
RETURN NUMBER
AS
BEGIN
    RETURN (p_monthly * 12) + p_bonus;
END annual_salary;
/

-- Use in SQL query
SELECT first_name, salary,
       annual_salary(salary)         AS annual_base,
       annual_salary(salary, 50000)  AS with_bonus
FROM employees;

-- Example 2: Function to get department name
CREATE OR REPLACE FUNCTION get_dept_name (p_dept_id NUMBER)
RETURN VARCHAR2
AS
    v_name VARCHAR2(50);
BEGIN
    SELECT dept_name INTO v_name
    FROM departments WHERE dept_id = p_dept_id;
    RETURN v_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown';
END get_dept_name;
/

-- Use in query
SELECT emp_id, first_name, get_dept_name(dept_id) AS department
FROM employees;

-- Example 3: Function to check if employee is a manager
CREATE OR REPLACE FUNCTION is_manager (p_emp_id NUMBER)
RETURN VARCHAR2
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM employees WHERE manager_id = p_emp_id;

    IF v_count > 0 THEN RETURN 'Yes';
    ELSE RETURN 'No';
    END IF;
END is_manager;
/

SELECT emp_id, first_name, is_manager(emp_id) AS manager_status
FROM employees;

-- Drop function
DROP FUNCTION annual_salary;
```

---

## 12.10 TRIGGERS

**What it does:** Automatically executes a PL/SQL block when a specified event (INSERT, UPDATE, DELETE) occurs on a table.

### Syntax
```sql
CREATE [OR REPLACE] TRIGGER trigger_name
    {BEFORE | AFTER | INSTEAD OF}
    {INSERT | UPDATE [OF col] | DELETE} [OR ...]
    ON table_name
    [FOR EACH ROW]
    [WHEN (condition)]
BEGIN
    -- trigger body
END;
/
```

### Trigger Timing

| Timing        | Description                                  |
|---------------|----------------------------------------------|
| `BEFORE`      | Fires before the DML operation               |
| `AFTER`       | Fires after the DML operation                |
| `INSTEAD OF`  | Replaces the DML (used for views)            |
| `FOR EACH ROW`| Row-level trigger (fires for each row)       |
| (no FOR EACH) | Statement-level (fires once per statement)   |

### Pseudo-records: `:NEW` and `:OLD`

| Record  | Available For   | Contains                  |
|---------|-----------------|---------------------------|
| `:NEW`  | INSERT, UPDATE  | New value being inserted  |
| `:OLD`  | UPDATE, DELETE  | Old value before change   |

### Examples

```sql
-- Example 1: Audit trigger — log salary changes
CREATE TABLE salary_audit (
    audit_id    NUMBER GENERATED ALWAYS AS IDENTITY,
    emp_id      NUMBER,
    old_salary  NUMBER,
    new_salary  NUMBER,
    change_date DATE DEFAULT SYSDATE,
    changed_by  VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER trg_salary_audit
AFTER UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    IF :OLD.salary != :NEW.salary THEN
        INSERT INTO salary_audit (emp_id, old_salary, new_salary, changed_by)
        VALUES (:NEW.emp_id, :OLD.salary, :NEW.salary, USER);
    END IF;
END;
/

-- Test the trigger
UPDATE employees SET salary = 80000 WHERE emp_id = 102;
COMMIT;

SELECT * FROM salary_audit;

-- Example 2: BEFORE INSERT trigger — validate salary
CREATE OR REPLACE TRIGGER trg_validate_salary
BEFORE INSERT OR UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    IF :NEW.salary < 10000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be less than 10,000');
    END IF;

    IF :NEW.salary > 500000 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Salary cannot exceed 500,000');
    END IF;
END;
/

-- This will fail:
-- INSERT INTO employees VALUES (130, 'Test', 'User', 20, 5000, SYSDATE, 'Intern', NULL);

-- Example 3: Auto-timestamp trigger
ALTER TABLE employees ADD last_updated DATE;

CREATE OR REPLACE TRIGGER trg_last_updated
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
    :NEW.last_updated := SYSDATE;
END;
/

UPDATE employees SET salary = salary WHERE emp_id = 101;
SELECT emp_id, last_updated FROM employees WHERE emp_id = 101;

-- Example 4: INSTEAD OF trigger on a view
CREATE VIEW emp_dept_view AS
SELECT e.emp_id, e.first_name, e.salary, d.dept_name
FROM employees e JOIN departments d ON e.dept_id = d.dept_id;

CREATE OR REPLACE TRIGGER trg_emp_dept_view
INSTEAD OF UPDATE ON emp_dept_view
FOR EACH ROW
BEGIN
    UPDATE employees SET salary = :NEW.salary WHERE emp_id = :NEW.emp_id;
END;
/

-- Now this works on the view:
UPDATE emp_dept_view SET salary = 75000 WHERE emp_id = 103;
COMMIT;

-- Manage triggers
ALTER TRIGGER trg_salary_audit DISABLE;
ALTER TRIGGER trg_salary_audit ENABLE;
DROP TRIGGER trg_salary_audit;

-- View all triggers
SELECT trigger_name, trigger_type, triggering_event, status
FROM user_triggers;
```

---

## 12.11 Packages

**What it does:** A package groups related procedures, functions, variables, and types into a single named unit.

```sql
-- Package Specification (public interface)
CREATE OR REPLACE PACKAGE emp_pkg AS
    -- Public constant
    c_max_salary   CONSTANT NUMBER := 500000;

    -- Public procedure declaration
    PROCEDURE give_raise(p_emp_id NUMBER, p_percent NUMBER);

    -- Public function declaration
    FUNCTION get_salary(p_emp_id NUMBER) RETURN NUMBER;
END emp_pkg;
/

-- Package Body (implementation)
CREATE OR REPLACE PACKAGE BODY emp_pkg AS

    PROCEDURE give_raise(p_emp_id NUMBER, p_percent NUMBER) AS
    BEGIN
        UPDATE employees
        SET salary = LEAST(salary * (1 + p_percent/100), c_max_salary)
        WHERE emp_id = p_emp_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Raise applied for EMP: ' || p_emp_id);
    END give_raise;

    FUNCTION get_salary(p_emp_id NUMBER) RETURN NUMBER AS
        v_sal NUMBER;
    BEGIN
        SELECT salary INTO v_sal FROM employees WHERE emp_id = p_emp_id;
        RETURN v_sal;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN -1;
    END get_salary;

END emp_pkg;
/

-- Use the package
EXEC emp_pkg.give_raise(102, 10);
SELECT emp_pkg.get_salary(102) FROM DUAL;

-- Drop package
DROP PACKAGE emp_pkg;
```

---

## 12.12 Collections — Associative Arrays

```sql
DECLARE
    -- Define associative array type
    TYPE salary_table IS TABLE OF NUMBER INDEX BY VARCHAR2(50);
    v_salaries salary_table;

BEGIN
    -- Populate
    v_salaries('Alice')  := 55000;
    v_salaries('Bob')    := 72000;
    v_salaries('Carol')  := 68000;

    -- Access
    DBMS_OUTPUT.PUT_LINE('Alice salary: ' || v_salaries('Alice'));
    DBMS_OUTPUT.PUT_LINE('Bob salary  : ' || v_salaries('Bob'));

    -- Iterate
    DECLARE
        v_key VARCHAR2(50);
    BEGIN
        v_key := v_salaries.FIRST;
        WHILE v_key IS NOT NULL LOOP
            DBMS_OUTPUT.PUT_LINE(v_key || ': ' || v_salaries(v_key));
            v_key := v_salaries.NEXT(v_key);
        END LOOP;
    END;
END;
/
```

---

## 12.13 DBMS_OUTPUT Reference

```sql
-- Enable output
SET SERVEROUTPUT ON;
SET SERVEROUTPUT ON SIZE 1000000;   -- larger buffer

-- Basic line output
DBMS_OUTPUT.PUT_LINE('Hello, World!');

-- Without newline
DBMS_OUTPUT.PUT('Count: ');
DBMS_OUTPUT.PUT(5);
DBMS_OUTPUT.NEW_LINE;    -- adds newline

-- Clear buffer
DBMS_OUTPUT.DISABLE;
DBMS_OUTPUT.ENABLE;
```

---

[← Previous: Transactions](./11_transactions.md) | [Back to README](./README.md) | [Next: Admin Commands →](./13_admin_commands.md)
