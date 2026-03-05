# Section 7 — Joins

> Joins combine rows from two or more tables based on related columns.

---

## Sample Tables for This Section

```sql
-- Reminder of the tables:
-- employees  (emp_id, first_name, last_name, dept_id, salary, hire_date, job_title, manager_id)
-- departments (dept_id, dept_name, location)

-- Note: dept_id 50 has NO employees (for demonstrating outer joins)
INSERT INTO departments VALUES (50, 'Legal', 'Miami');
COMMIT;

-- emp_id 108 (Henry Moore) is in dept 20
-- No employee is assigned to dept 50 (Legal)
```

---

## 7.1 INNER JOIN (JOIN)

**What it does:** Returns only rows that have matching values in BOTH tables.

### Syntax
```sql
-- ANSI syntax (recommended)
SELECT columns
FROM table1
INNER JOIN table2 ON table1.common_col = table2.common_col;

-- Oracle traditional syntax
SELECT columns
FROM table1, table2
WHERE table1.common_col = table2.common_col;
```

### Examples

```sql
-- Example 1: Employees with their department names
SELECT e.emp_id,
       e.first_name,
       e.last_name,
       d.dept_name,
       e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
ORDER BY e.emp_id;

-- Example 2: Same using Oracle traditional syntax
SELECT e.emp_id, e.first_name, d.dept_name
FROM employees e, departments d
WHERE e.dept_id = d.dept_id;

-- Example 3: Add a filter condition
SELECT e.first_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'IT'
ORDER BY e.salary DESC;

-- Example 4: Multiple table join (employees → departments → orders by customer name)
SELECT o.order_id, o.customer, o.product, e.first_name AS emp_name
FROM orders o
INNER JOIN employees e ON o.customer = e.first_name;
```

**Expected Output (partial):**
```
EMP_ID  FIRST_NAME  LAST_NAME  DEPT_NAME  SALARY
------  ----------  ---------  ---------  ------
101     Alice       Smith      HR         55000
102     Bob         Jones      IT         72000
103     Carol       White      IT         68000
...
```

> Note: Dept 50 (Legal) does NOT appear — INNER JOIN only returns matching rows.

---

## 7.2 LEFT JOIN (LEFT OUTER JOIN)

**What it does:** Returns ALL rows from the LEFT table, plus matching rows from RIGHT. Non-matching right rows show as NULL.

### Syntax
```sql
SELECT columns
FROM left_table
LEFT JOIN right_table ON left_table.col = right_table.col;

-- Oracle traditional (using + on right side):
SELECT columns
FROM left_table, right_table
WHERE left_table.col = right_table.col(+);
```

### Examples

```sql
-- Example 1: All employees, with department name (NULL if no dept)
SELECT e.emp_id, e.first_name, e.dept_id,
       d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
ORDER BY e.emp_id;

-- Example 2: All departments, including ones without employees
SELECT d.dept_id, d.dept_name, d.location,
       e.first_name AS employee
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
ORDER BY d.dept_id;

-- Example 3: Find departments with NO employees
SELECT d.dept_id, d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;
-- Output: dept 50 (Legal)

-- Example 4: All customers and their orders (include customers with no orders)
SELECT e.first_name AS customer,
       o.order_id,
       o.product
FROM employees e
LEFT JOIN orders o ON e.first_name = o.customer
ORDER BY e.first_name;

-- Example 5: Oracle legacy syntax
SELECT e.first_name, d.dept_name
FROM employees e, departments d
WHERE e.dept_id = d.dept_id(+);
```

---

## 7.3 RIGHT JOIN (RIGHT OUTER JOIN)

**What it does:** Returns ALL rows from the RIGHT table, plus matching rows from LEFT. Non-matching left rows show as NULL.

### Syntax
```sql
SELECT columns
FROM left_table
RIGHT JOIN right_table ON left_table.col = right_table.col;

-- Oracle traditional:
WHERE left_table.col(+) = right_table.col
```

### Examples

```sql
-- Example 1: All departments, including unoccupied ones
SELECT e.emp_id, e.first_name,
       d.dept_id, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_id;
-- Legal department shows with NULL employee columns

-- Example 2: All orders, even those with no matching employee
SELECT e.first_name, o.order_id, o.product
FROM employees e
RIGHT JOIN orders o ON e.first_name = o.customer
ORDER BY o.order_id;

-- Example 3: Oracle legacy syntax
SELECT e.first_name, d.dept_name
FROM employees e, departments d
WHERE e.dept_id(+) = d.dept_id;
```

> **Tip:** A RIGHT JOIN can always be rewritten as a LEFT JOIN by swapping table order.

---

## 7.4 FULL OUTER JOIN

**What it does:** Returns ALL rows from BOTH tables. NULLs appear where there's no match on either side.

### Syntax
```sql
SELECT columns
FROM table1
FULL OUTER JOIN table2 ON table1.col = table2.col;
```

### Examples

```sql
-- Example 1: All employees AND all departments
SELECT e.emp_id, e.first_name,
       d.dept_id, d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_id;
-- Legal dept shows dept_name but NULL for emp_id, first_name

-- Example 2: Full join to find orphaned records on both sides
SELECT e.emp_id, e.first_name, d.dept_id, d.dept_name
FROM employees e
FULL OUTER JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;

-- Example 3: Using UNION to simulate FULL OUTER JOIN (older Oracle)
SELECT e.emp_id, e.first_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.emp_id, e.first_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

---

## 7.5 SELF JOIN

**What it does:** Joins a table to itself — used for hierarchical data like employee-manager relationships.

### Syntax
```sql
SELECT a.columns, b.columns
FROM table_name a
JOIN table_name b ON a.column = b.column;
```

### Examples

```sql
-- Example 1: Show employee and their manager name
SELECT e.emp_id,
       e.first_name   AS employee,
       e.job_title    AS emp_role,
       m.first_name   AS manager,
       m.job_title    AS mgr_role
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
ORDER BY m.first_name NULLS LAST, e.first_name;

-- Example 2: Find all employees who earn more than their manager
SELECT e.first_name AS employee,
       e.salary     AS emp_salary,
       m.first_name AS manager,
       m.salary     AS mgr_salary
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;

-- Example 3: Find peers (same manager, different employees)
SELECT a.first_name AS employee1,
       b.first_name AS employee2,
       a.manager_id AS shared_manager
FROM employees a
JOIN employees b ON a.manager_id = b.manager_id
WHERE a.emp_id < b.emp_id
ORDER BY a.manager_id;
```

---

## 7.6 CROSS JOIN (Cartesian Product)

**What it does:** Returns every combination of rows from both tables (no ON condition). Result = rows in table1 × rows in table2.

### Syntax
```sql
SELECT columns
FROM table1
CROSS JOIN table2;

-- Oracle traditional (comma-separated, no WHERE):
SELECT columns FROM table1, table2;
```

### Examples

```sql
-- Example 1: Cross join departments and employees (all combinations)
SELECT d.dept_name, e.first_name
FROM departments d
CROSS JOIN employees e
ORDER BY d.dept_name, e.first_name;
-- Result: 5 depts × 8 employees = 40 rows

-- Example 2: Generate a multiplication table using DUAL tricks
SELECT a.n * b.n AS product
FROM (SELECT LEVEL AS n FROM DUAL CONNECT BY LEVEL <= 5) a
CROSS JOIN (SELECT LEVEL AS n FROM DUAL CONNECT BY LEVEL <= 5) b
ORDER BY a.n, b.n;

-- Example 3: Use case — assign all products to all warehouses
CREATE TABLE products   (prod_id NUMBER, prod_name VARCHAR2(50));
CREATE TABLE warehouses (wh_id   NUMBER, wh_name   VARCHAR2(50));

INSERT INTO products VALUES (1, 'Laptop');
INSERT INTO products VALUES (2, 'Phone');
INSERT INTO warehouses VALUES (101, 'Delhi WH');
INSERT INTO warehouses VALUES (102, 'Mumbai WH');
COMMIT;

SELECT p.prod_name, w.wh_name
FROM products p
CROSS JOIN warehouses w;
-- Returns all 4 combinations
```

---

## 7.7 Natural Join

**What it does:** Automatically joins on all columns with the same name in both tables (Oracle-specific).

```sql
-- Automatically joins on dept_id (same name in both tables)
SELECT emp_id, first_name, dept_name
FROM employees
NATURAL JOIN departments;
```

> ⚠️ **Not recommended** — fragile if column names change. Always use explicit JOIN ... ON.

---

## 7.8 Join Summary

| Join Type        | Returns                                          |
|------------------|--------------------------------------------------|
| `INNER JOIN`     | Only matching rows from both tables              |
| `LEFT JOIN`      | All rows from left + matching from right         |
| `RIGHT JOIN`     | All rows from right + matching from left         |
| `FULL OUTER JOIN`| All rows from both tables                        |
| `SELF JOIN`      | Table joined to itself                           |
| `CROSS JOIN`     | All combinations (Cartesian product)             |

---

## 7.9 Multi-Table Joins

```sql
-- Join 3 tables: employees + departments + orders
SELECT e.emp_id,
       e.first_name,
       d.dept_name,
       d.location,
       o.order_id,
       o.product
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN orders o ON e.first_name = o.customer
ORDER BY e.emp_id;

-- WITH aggregate: revenue per department
SELECT d.dept_name,
       COUNT(o.order_id)         AS total_orders,
       SUM(o.qty * o.unit_price) AS total_revenue
FROM departments d
JOIN employees e   ON d.dept_id = e.dept_id
LEFT JOIN orders o ON e.first_name = o.customer
GROUP BY d.dept_name
ORDER BY total_revenue DESC NULLS LAST;
```

---

[← Previous: Functions](./06_functions.md) | [Back to README](./README.md) | [Next: Subqueries →](./08_subqueries.md)
