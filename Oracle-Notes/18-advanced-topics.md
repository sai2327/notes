# 18. Advanced Topics

## Table of Contents
- [18.1 Dynamic SQL](#181-dynamic-sql)
- [18.2 Performance Tuning Basics](#182-performance-tuning-basics)
- [18.3 EXPLAIN PLAN](#183-explain-plan)
- [18.4 Hints](#184-hints)
- [18.5 Compound Triggers](#185-compound-triggers)
- [18.6 Collections (PL/SQL Arrays)](#186-collections-plsql-arrays)
- [18.7 Bulk Operations](#187-bulk-operations)
- [18.8 Practice & Assessment](#188-practice--assessment)

---

## 18.1 Dynamic SQL

### Definition
**Dynamic SQL** builds and executes SQL statements at runtime as strings. Used when the table name, column name, or WHERE clause is not known until execution.

### EXECUTE IMMEDIATE

```sql
-- Simple dynamic SQL
DECLARE
    v_sql VARCHAR2(200);
    v_count NUMBER;
BEGIN
    v_sql := 'SELECT COUNT(*) FROM customers WHERE city = :1';
    EXECUTE IMMEDIATE v_sql INTO v_count USING 'Mumbai';
    DBMS_OUTPUT.PUT_LINE('Mumbai customers: ' || v_count);
END;
/
```

### Dynamic DDL

```sql
DECLARE
    v_table_name VARCHAR2(30) := 'TEMP_DATA';
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE ' || v_table_name || 
                      ' (id NUMBER, name VARCHAR2(50))';
    DBMS_OUTPUT.PUT_LINE('Table ' || v_table_name || ' created.');
END;
/
```

### Dynamic DML with RETURNING

```sql
DECLARE
    v_sql VARCHAR2(200);
    v_old_status VARCHAR2(20);
BEGIN
    v_sql := 'UPDATE orders SET status = :1 WHERE order_id = :2 RETURNING status INTO :3';
    -- Note: RETURNING with EXECUTE IMMEDIATE uses different syntax
    
    EXECUTE IMMEDIATE 
        'UPDATE orders SET status = ''SHIPPED'' WHERE order_id = 1003 RETURNING status INTO :x'
        RETURNING INTO v_old_status;
    
    DBMS_OUTPUT.PUT_LINE('Updated status: ' || v_old_status);
END;
/
```

### DBMS_SQL (for complex dynamic SQL)

```sql
DECLARE
    v_cursor  INTEGER;
    v_rows    INTEGER;
BEGIN
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, 'DELETE FROM orders WHERE status = ''CANCELLED''', DBMS_SQL.NATIVE);
    v_rows := DBMS_SQL.EXECUTE(v_cursor);
    DBMS_SQL.CLOSE_CURSOR(v_cursor);
    DBMS_OUTPUT.PUT_LINE(v_rows || ' rows deleted');
END;
/
```

> **Security Warning:** Always use bind variables (`:1`, `:param`) to prevent SQL injection. Never concatenate user input directly into SQL strings.

---

## 18.2 Performance Tuning Basics

### Common Causes of Slow Queries

| Issue | Solution |
|-------|----------|
| Missing indexes | Add appropriate indexes |
| Full table scans on large tables | Index the WHERE columns |
| SELECT * when few columns needed | Select only required columns |
| Unnecessary DISTINCT | Fix query logic instead |
| Functions on indexed columns | Use function-based indexes |
| Correlated subqueries | Rewrite as JOINs |

### Basic Tuning Steps

1. **Identify slow SQL** — Use V$SQL, AWR reports
2. **Get execution plan** — EXPLAIN PLAN
3. **Check indexes** — Are the right columns indexed?
4. **Check statistics** — `DBMS_STATS.GATHER_TABLE_STATS`
5. **Rewrite query** — JOINs vs subqueries, eliminate unnecessary work

### Gathering Statistics

```sql
-- Gather stats for optimizer
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname => 'HR',
        tabname => 'CUSTOMERS',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE
    );
END;
/
```

---

## 18.3 EXPLAIN PLAN

### Generate Plan

```sql
EXPLAIN PLAN FOR
SELECT c.first_name, SUM(o.amount)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.city = 'Mumbai'
GROUP BY c.first_name;
```

### View Plan

```sql
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

### Sample Output

```
---------------------------------------------------------------------------
| Id | Operation           | Name      | Rows | Bytes | Cost | Time     |
---------------------------------------------------------------------------
|  0 | SELECT STATEMENT    |           |    2 |   104 |    6 | 00:00:01 |
|  1 |  HASH GROUP BY      |           |    2 |   104 |    6 | 00:00:01 |
|  2 |   HASH JOIN         |           |    4 |   208 |    5 | 00:00:01 |
|  3 |    TABLE ACCESS FULL| CUSTOMERS |    2 |    56 |    3 | 00:00:01 |
|  4 |    TABLE ACCESS FULL| ORDERS    |    8 |   192 |    2 | 00:00:01 |
---------------------------------------------------------------------------
```

### Key Operations to Watch

| Operation | Meaning | Good/Bad |
|-----------|---------|----------|
| TABLE ACCESS FULL | Reads entire table | Bad for large tables |
| INDEX RANGE SCAN | Uses index partially | Good |
| INDEX UNIQUE SCAN | Uses unique index | Best |
| HASH JOIN | Joins using hash table | Good for large sets |
| NESTED LOOPS | Loops for each row | Good for small sets |
| SORT ORDER BY | Sorting result | Expected for ORDER BY |

---

## 18.4 Hints

### Definition
**Hints** are instructions to the optimizer to choose a specific execution plan.

```sql
-- Force full table scan
SELECT /*+ FULL(c) */ first_name FROM customers c WHERE customer_id = 1;

-- Force index use
SELECT /*+ INDEX(o idx_orders_customer) */ * FROM orders o WHERE customer_id = 1;

-- Force nested loops join
SELECT /*+ USE_NL(c o) */ c.first_name, o.amount
FROM customers c JOIN orders o ON c.customer_id = o.customer_id;

-- Parallel execution
SELECT /*+ PARALLEL(customers, 4) */ * FROM customers;
```

### Common Hints

| Hint | Purpose |
|------|---------|
| `/*+ FULL(table) */` | Force full table scan |
| `/*+ INDEX(table index) */` | Force specific index |
| `/*+ NO_INDEX(table index) */` | Avoid an index |
| `/*+ USE_NL(t1 t2) */` | Nested loops join |
| `/*+ USE_HASH(t1 t2) */` | Hash join |
| `/*+ PARALLEL(table, n) */` | Parallel execution |
| `/*+ FIRST_ROWS(n) */` | Optimize for first n rows |

> **Best Practice:** Use hints sparingly. Fix the root cause (missing stats, indexes) instead.

---

## 18.5 Compound Triggers

### Definition
A **compound trigger** combines multiple trigger timing points (BEFORE/AFTER, STATEMENT/ROW) in one trigger body.

### Syntax

```sql
CREATE OR REPLACE TRIGGER trg_orders_compound
FOR INSERT OR UPDATE ON orders
COMPOUND TRIGGER

    -- Shared variables
    TYPE t_order_ids IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_order_ids t_order_ids;
    v_index PLS_INTEGER := 0;

    BEFORE STATEMENT IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Before Statement ---');
        v_index := 0;
    END BEFORE STATEMENT;

    BEFORE EACH ROW IS
    BEGIN
        -- Auto-set order date
        IF :NEW.order_date IS NULL THEN
            :NEW.order_date := SYSDATE;
        END IF;
    END BEFORE EACH ROW;

    AFTER EACH ROW IS
    BEGIN
        v_index := v_index + 1;
        v_order_ids(v_index) := :NEW.order_id;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        -- Process all affected orders
        FOR i IN 1..v_index LOOP
            DBMS_OUTPUT.PUT_LINE('Processed order: ' || v_order_ids(i));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('--- After Statement: ' || v_index || ' rows ---');
    END AFTER STATEMENT;

END trg_orders_compound;
/
```

### Why Use Compound Triggers?
- Avoid the **mutating table** error (ORA-04091).
- Collect row-level data and process it at the statement level.
- Cleaner than creating multiple separate triggers.

---

## 18.6 Collections (PL/SQL Arrays)

### Types

| Type | Index | Sparse? | Created In |
|------|-------|---------|-----------|
| Associative Array | String or INTEGER | Yes | PL/SQL only |
| VARRAY | INTEGER (1..n) | No (fixed size) | PL/SQL or SQL |
| Nested Table | INTEGER | Yes (after DELETE) | PL/SQL or SQL |

### Associative Array

```sql
DECLARE
    TYPE t_city_pop IS TABLE OF NUMBER INDEX BY VARCHAR2(50);
    v_cities t_city_pop;
BEGIN
    v_cities('Mumbai') := 20000000;
    v_cities('Delhi') := 19000000;
    v_cities('Ahmedabad') := 8000000;
    
    DBMS_OUTPUT.PUT_LINE('Mumbai: ' || v_cities('Mumbai'));
    DBMS_OUTPUT.PUT_LINE('Count: ' || v_cities.COUNT);
END;
/
```

### Nested Table

```sql
DECLARE
    TYPE t_names IS TABLE OF VARCHAR2(50);
    v_names t_names := t_names('Ravi', 'Priya', 'Amit');
BEGIN
    v_names.EXTEND;
    v_names(4) := 'Sneha';
    
    FOR i IN 1..v_names.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(i || ': ' || v_names(i));
    END LOOP;
END;
/
```

---

## 18.7 Bulk Operations

### BULK COLLECT (Fetch many rows at once)

```sql
DECLARE
    TYPE t_names IS TABLE OF VARCHAR2(50);
    v_names t_names;
BEGIN
    SELECT first_name BULK COLLECT INTO v_names FROM customers;
    
    FOR i IN 1..v_names.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_names(i));
    END LOOP;
END;
/
```

### FORALL (DML on many rows at once)

```sql
DECLARE
    TYPE t_ids IS TABLE OF NUMBER;
    v_ids t_ids := t_ids(1001, 1002, 1003);
BEGIN
    FORALL i IN 1..v_ids.COUNT
        UPDATE orders SET status = 'PROCESSED' WHERE order_id = v_ids(i);
    
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows updated');
    COMMIT;
END;
/
```

### Performance Comparison

```
Without BULK COLLECT (row-by-row):  ~5 seconds for 10,000 rows
With BULK COLLECT:                  ~0.1 seconds for 10,000 rows
```

---

## 18.8 Practice & Assessment

### MCQs

**Q1.** Dynamic SQL is needed when:
- A) You know the table name at compile time
- B) The SQL statement is built at runtime
- C) You want faster execution
- D) You need transactions

**Answer:** B) The SQL statement is built at runtime

---

**Q2.** `TABLE ACCESS FULL` in an execution plan means:
- A) The best possible access method
- B) Every row in the table is read
- C) An index is being used
- D) The table is empty

**Answer:** B) Every row in the table is read

---

**Q3.** To prevent SQL injection in dynamic SQL, you should:
- A) Use UPPER() on input
- B) Use bind variables (:param)
- C) Use TRIM() on input
- D) Limit string length

**Answer:** B) Use bind variables (:param)

---

**Q4.** BULK COLLECT improves performance by:
- A) Using parallel queries
- B) Reducing context switches between SQL and PL/SQL engines
- C) Compressing data
- D) Using materialized views

**Answer:** B) Reducing context switches between SQL and PL/SQL engines

---

### Interview Questions

1. **What is dynamic SQL and when do you use it?**
2. **What is SQL injection and how do you prevent it in PL/SQL?**
3. **How do you read an execution plan?**
4. **What is the difference between FULL TABLE SCAN and INDEX RANGE SCAN?**
5. **When would you use optimizer hints?**
6. **What is a compound trigger? When is it useful?**
7. **Explain BULK COLLECT and FORALL.**
8. **What is the mutating table error and how do you solve it?**
9. **What are the types of collections in PL/SQL?**
10. **How does Oracle's Cost-Based Optimizer (CBO) work?**

---

> **Next Topic**: [19 - Oracle Commands Cheat Sheet](19-oracle-commands-cheat-sheet.md)
