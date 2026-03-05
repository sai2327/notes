# Section 11 — Transaction Control

> A **transaction** is a logical unit of work containing one or more SQL statements.
> Oracle follows **ACID** properties: Atomicity, Consistency, Isolation, Durability.

---

## 11.1 COMMIT

**What it does:** Permanently saves all changes made in the current transaction. Makes changes visible to other users.

### Syntax
```sql
COMMIT;
COMMIT WORK;   -- equivalent, WORK is optional
```

### Examples

```sql
-- Example 1: Simple commit after DML
INSERT INTO employees (emp_id, first_name, last_name, salary, dept_id)
VALUES (120, 'Tom', 'Hardy', 58000, 20);

UPDATE employees
SET salary = 60000
WHERE emp_id = 120;

COMMIT;    -- saves both INSERT and UPDATE permanently

-- Verify
SELECT emp_id, first_name, salary FROM employees WHERE emp_id = 120;

-- Example 2: Multiple DML with commit
BEGIN
    INSERT INTO departments VALUES (60, 'Security', 'Austin');
    INSERT INTO employees (emp_id, first_name, dept_id, salary)
    VALUES (121, 'Raj', 60, 52000);
    COMMIT;
END;
/

-- Example 3: Auto-commit behavior
-- DDL statements (CREATE, DROP, ALTER) automatically commit
CREATE TABLE temp_table (id NUMBER);   -- implicitly commits
-- Any pending DML before this is also committed!
```

---

## 11.2 ROLLBACK

**What it does:** Undoes all changes made in the current transaction (back to last COMMIT or SAVEPOINT).

### Syntax
```sql
ROLLBACK;
ROLLBACK TO SAVEPOINT savepoint_name;
```

### Examples

```sql
-- Example 1: Rollback an erroneous DELETE
DELETE FROM employees WHERE dept_id = 20;
-- Oops! Too many rows deleted

SELECT COUNT(*) FROM employees WHERE dept_id = 20;  -- 0 rows!

ROLLBACK;   -- undo the delete

SELECT COUNT(*) FROM employees WHERE dept_id = 20;  -- rows restored!

-- Example 2: Rollback an incorrect UPDATE
UPDATE employees SET salary = 0;    -- WRONG! Forgot WHERE clause
SELECT MIN(salary) FROM employees;  -- 0!

ROLLBACK;

SELECT MIN(salary) FROM employees;  -- back to normal

-- Example 3: Rollback to a savepoint (partial rollback)
INSERT INTO orders VALUES (2001, 'Test1', 'Widget', 5, 100, SYSDATE, 'Pending');
SAVEPOINT sp1;

INSERT INTO orders VALUES (2002, 'Test2', 'Gadget', 3, 200, SYSDATE, 'Pending');
SAVEPOINT sp2;

INSERT INTO orders VALUES (2003, 'Test3', 'Device', 1, 500, SYSDATE, 'Pending');

-- Rollback only to sp2 (undo order 2003 only)
ROLLBACK TO SAVEPOINT sp2;
SELECT * FROM orders WHERE order_id >= 2001;
-- 2001 and 2002 remain; 2003 is gone

COMMIT;   -- commits 2001 and 2002

-- Example 4: Transaction that handles error
BEGIN
    UPDATE employees SET salary = salary * 1.10 WHERE dept_id = 20;
    -- Simulate something going wrong
    RAISE_APPLICATION_ERROR(-20001, 'Error occurred');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Transaction rolled back: ' || SQLERRM);
END;
/
```

---

## 11.3 SAVEPOINT

**What it does:** Creates a named point within a transaction. Allows partial rollback to that point without losing all changes.

### Syntax
```sql
SAVEPOINT savepoint_name;
ROLLBACK TO SAVEPOINT savepoint_name;
RELEASE SAVEPOINT savepoint_name;   -- removes a savepoint (optional)
```

### Examples

```sql
-- Example 1: Three-step transaction with savepoints
-- Step 1: Process IT department raise
UPDATE employees SET salary = salary * 1.10 WHERE dept_id = 20;
SAVEPOINT sp_it_done;

-- Step 2: Process HR department raise
UPDATE employees SET salary = salary * 1.05 WHERE dept_id = 10;
SAVEPOINT sp_hr_done;

-- Step 3: Process Finance department raise (mistake - wrong multiplier)
UPDATE employees SET salary = salary * 2.00 WHERE dept_id = 30;  -- Too much!

-- Rollback only Finance update
ROLLBACK TO SAVEPOINT sp_hr_done;

-- IT and HR updates are still pending; Finance is rolled back
SELECT dept_id, first_name, salary FROM employees ORDER BY dept_id;

-- Apply the correct Finance raise
UPDATE employees SET salary = salary * 1.08 WHERE dept_id = 30;

-- Commit everything
COMMIT;

-- Example 2: E-commerce order processing with savepoints
BEGIN
    -- Stage 1: Create order header
    INSERT INTO orders (order_id, customer, product, qty, unit_price, status)
    VALUES (3001, 'Alice', 'Laptop', 1, 75000, 'Processing');
    SAVEPOINT order_created;

    -- Stage 2: Deduct from inventory (hypothetical table)
    -- UPDATE inventory SET qty = qty - 1 WHERE product = 'Laptop';
    SAVEPOINT inventory_updated;

    -- Stage 3: Create invoice
    -- INSERT INTO invoices ...
    SAVEPOINT invoice_created;

    -- All stages successful — commit
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Order 3001 processed successfully.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO order_created;   -- undo inventory and invoice only
        DBMS_OUTPUT.PUT_LINE('Rolling back to order creation: ' || SQLERRM);
        COMMIT;   -- commit the order header (for audit trail)
END;
/
```

---

## 11.4 Transaction Lifecycle

```
START (after COMMIT/ROLLBACK or first DML)
    │
    ├── INSERT / UPDATE / DELETE / MERGE
    │       │
    │       ├── SAVEPOINT sp1
    │       ├── more DML
    │       ├── SAVEPOINT sp2
    │       └── more DML
    │
    ├── COMMIT  ──► Changes permanently saved
    │
    └── ROLLBACK ──► All changes undone
                   └── ROLLBACK TO sp1 ──► Partial undo
```

---

## 11.5 Transaction Best Practices

```sql
-- 1. Always commit or rollback after DML
INSERT INTO employees VALUES (...);
-- do business logic
COMMIT;   -- don't forget!

-- 2. Use explicit transactions in PL/SQL
DECLARE
    v_count NUMBER;
BEGIN
    UPDATE orders SET status = 'Shipped' WHERE status = 'Pending';
    v_count := SQL%ROWCOUNT;
    IF v_count > 0 THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(v_count || ' orders shipped.');
    ELSE
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No orders to update.');
    END IF;
END;
/

-- 3. SET AUTOCOMMIT (SQL*Plus only — NOT recommended for production)
SET AUTOCOMMIT ON    -- commits after every DML
SET AUTOCOMMIT OFF   -- default, manual commit required
```

---

## 11.6 TRANSACTION Isolation Levels

```sql
-- Set transaction level (Oracle default: READ COMMITTED)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Serializable — highest isolation
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Read only transaction
SET TRANSACTION READ ONLY;

-- Example: Consistent read
SET TRANSACTION READ ONLY;
SELECT SUM(salary) FROM employees;        -- snapshot at this moment
SELECT COUNT(*) FROM employees;           -- same consistent snapshot
COMMIT;   -- ends read-only transaction
```

---

[← Previous: Database Objects](./10_database_objects.md) | [Back to README](./README.md) | [Next: PL/SQL →](./12_plsql.md)
