# Section 8 — Subqueries

> A **subquery** (inner query / nested query) is a SELECT statement inside another SQL statement.

---

## 8.1 Single-Row Subquery

**What it does:** Returns exactly ONE row with ONE column. Used with comparison operators: `=`, `>`, `<`, `>=`, `<=`, `<>`.

### Syntax
```sql
SELECT columns
FROM table
WHERE column = (SELECT single_value FROM table WHERE condition);
```

### Examples

```sql
-- Example 1: Employee earning the highest salary
SELECT emp_id, first_name, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);

-- Example 2: Employees earning more than the average salary
SELECT emp_id, first_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- Example 3: Employees in the same department as 'Bob'
SELECT emp_id, first_name, dept_id
FROM employees
WHERE dept_id = (SELECT dept_id FROM employees WHERE first_name = 'Bob');

-- Example 4: Most recently hired employee
SELECT emp_id, first_name, hire_date
FROM employees
WHERE hire_date = (SELECT MAX(hire_date) FROM employees);

-- Example 5: Student with the highest marks
SELECT name, course, marks
FROM students
WHERE marks = (SELECT MAX(marks) FROM students);

-- Example 6: Use subquery in UPDATE
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'IT');

COMMIT;

-- Example 7: Use subquery in DELETE
DELETE FROM orders
WHERE customer = (SELECT first_name FROM employees WHERE emp_id = 101);

-- Verification
SELECT * FROM employees ORDER BY salary DESC;
```

---

## 8.2 Multiple-Row Subquery

**What it does:** Returns multiple rows. Used with: `IN`, `NOT IN`, `ANY`, `ALL`, `EXISTS`.

### Syntax
```sql
SELECT columns FROM table
WHERE column IN (SELECT col FROM another_table WHERE condition);
```

---

### IN Subquery

```sql
-- Example 1: Employees in departments located in 'Chicago' or 'Dallas'
SELECT emp_id, first_name, dept_id
FROM employees
WHERE dept_id IN (
    SELECT dept_id FROM departments
    WHERE location IN ('Chicago', 'Dallas')
);

-- Example 2: Students enrolled in courses that have top scorers (marks >= 90)
SELECT name, course, marks
FROM students
WHERE course IN (
    SELECT DISTINCT course FROM students WHERE marks >= 90
);

-- Example 3: Orders placed by IT employees
SELECT order_id, customer, product
FROM orders
WHERE customer IN (
    SELECT first_name FROM employees WHERE dept_id = 20
);

-- Example 4: NOT IN — employees NOT in IT or Finance
SELECT first_name, dept_id
FROM employees
WHERE dept_id NOT IN (
    SELECT dept_id FROM departments WHERE dept_name IN ('IT', 'Finance')
);
```

---

### ANY / SOME Subquery

```sql
-- ANY: true if the condition is true for at LEAST ONE row returned
-- Employees earning more than at least one IT employee
SELECT emp_id, first_name, salary
FROM employees
WHERE salary > ANY (
    SELECT salary FROM employees WHERE dept_id = 20
);
-- Returns employees earning more than the MINIMUM IT salary

-- = ANY is same as IN
SELECT * FROM employees
WHERE dept_id = ANY (SELECT dept_id FROM departments WHERE location = 'Chicago');
```

---

### ALL Subquery

```sql
-- ALL: true only if condition is true for ALL rows returned
-- Employees earning more than EVERY IT employee
SELECT emp_id, first_name, salary
FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees WHERE dept_id = 20
);
-- Returns employees earning more than the MAXIMUM IT salary

-- Practical: orders costing more than ALL orders from 'Bob'
SELECT order_id, customer, qty * unit_price AS total
FROM orders
WHERE qty * unit_price > ALL (
    SELECT qty * unit_price FROM orders WHERE customer = 'Bob'
);
```

---

### EXISTS / NOT EXISTS Subquery

**What it does:** Returns TRUE if the subquery returns at least one row. More efficient than IN for large datasets.

```sql
-- Example 1: Departments that HAVE employees
SELECT dept_id, dept_name
FROM departments d
WHERE EXISTS (
    SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id
);

-- Example 2: Departments with NO employees
SELECT dept_id, dept_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id
);
-- Returns Legal (dept 50)

-- Example 3: Customers who have placed at least one order
SELECT DISTINCT first_name
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer = e.first_name
);

-- Example 4: Delete departments with no employees
DELETE FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id
);
```

---

## 8.3 Correlated Subquery

**What it does:** A subquery that references columns from the **outer** query. Executed once for EACH row of the outer query.

### Syntax
```sql
SELECT columns
FROM outer_table o
WHERE column operator (
    SELECT aggregate_or_value
    FROM inner_table i
    WHERE i.col = o.col     -- references outer query!
);
```

### Examples

```sql
-- Example 1: Employees earning more than the AVERAGE in their OWN department
SELECT e.emp_id, e.first_name, e.dept_id, e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept_id = e.dept_id    -- correlated: uses outer e.dept_id
)
ORDER BY e.dept_id, e.salary DESC;

-- Example 2: Employees who are the highest paid in their department
SELECT e.emp_id, e.first_name, e.dept_id, e.salary
FROM employees e
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE dept_id = e.dept_id
);

-- Example 3: Students scoring above average in their own course
SELECT s.name, s.course, s.marks
FROM students s
WHERE s.marks > (
    SELECT AVG(marks)
    FROM students
    WHERE course = s.course
)
ORDER BY s.course, s.marks DESC;

-- Example 4: Orders with qty greater than average for same product
SELECT o.order_id, o.product, o.qty
FROM orders o
WHERE o.qty > (
    SELECT AVG(qty)
    FROM orders
    WHERE product = o.product
);

-- Example 5: Update using correlated subquery
-- Set a flag column for above-average earners per dept
ALTER TABLE employees ADD above_avg CHAR(1);

UPDATE employees e
SET above_avg = CASE
    WHEN salary > (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id)
    THEN 'Y' ELSE 'N'
END;

COMMIT;
SELECT emp_id, first_name, salary, above_avg FROM employees ORDER BY dept_id;
```

---

## 8.4 Subquery in FROM Clause (Inline View)

**What it does:** Uses a subquery as a "virtual table" in the FROM clause.

```sql
-- Example 1: Top earners per department (using inline view)
SELECT dept_id, first_name, salary
FROM (
    SELECT dept_id, first_name, salary,
           RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk
    FROM employees
)
WHERE rnk = 1
ORDER BY dept_id;

-- Example 2: Departments with above-average headcount
SELECT *
FROM (
    SELECT dept_id, COUNT(*) AS emp_count
    FROM employees
    GROUP BY dept_id
) dept_counts
WHERE emp_count > (SELECT AVG(cnt) FROM (
        SELECT COUNT(*) AS cnt FROM employees GROUP BY dept_id
    )
);

-- Example 3: Paginated results using inline view
SELECT * FROM (
    SELECT e.*, ROWNUM AS rn
    FROM (SELECT * FROM employees ORDER BY salary DESC) e
    WHERE ROWNUM <= 5
)
WHERE rn >= 3;
```

---

## 8.5 Subquery in SELECT Clause (Scalar Subquery)

**What it does:** Returns a single value from a subquery, used as a column expression in SELECT.

```sql
-- Example 1: Show each employee with company-wide average salary
SELECT first_name,
       salary,
       (SELECT ROUND(AVG(salary), 0) FROM employees) AS company_avg,
       salary - (SELECT ROUND(AVG(salary), 0) FROM employees) AS diff_from_avg
FROM employees
ORDER BY diff_from_avg DESC;

-- Example 2: Show department name without JOIN
SELECT emp_id,
       first_name,
       dept_id,
       (SELECT dept_name FROM departments WHERE dept_id = e.dept_id) AS dept_name
FROM employees e;

-- Example 3: Total orders count per customer
SELECT first_name,
       (SELECT COUNT(*) FROM orders WHERE customer = e.first_name) AS order_count
FROM employees e
ORDER BY order_count DESC;
```

---

## 8.6 CTE — WITH Clause (Common Table Expression)

**What it does:** Defines a named temporary result set for use within a single SQL statement. Improves readability.

```sql
-- Example 1: Employees above department average
WITH dept_avg AS (
    SELECT dept_id, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY dept_id
)
SELECT e.first_name, e.salary, da.avg_sal, e.dept_id
FROM employees e
JOIN dept_avg da ON e.dept_id = da.dept_id
WHERE e.salary > da.avg_sal
ORDER BY e.dept_id;

-- Example 2: Multiple CTEs
WITH
    top_depts AS (
        SELECT dept_id
        FROM employees
        GROUP BY dept_id
        HAVING COUNT(*) >= 2
    ),
    dept_info AS (
        SELECT d.dept_id, d.dept_name, d.location
        FROM departments d
        JOIN top_depts t ON d.dept_id = t.dept_id
    )
SELECT di.dept_name, di.location, e.first_name, e.salary
FROM dept_info di
JOIN employees e ON di.dept_id = e.dept_id
ORDER BY di.dept_name, e.salary DESC;

-- Example 3: Recursive CTE — employee hierarchy
WITH emp_hierarchy (emp_id, first_name, manager_id, level_num) AS (
    -- Anchor: top-level managers
    SELECT emp_id, first_name, manager_id, 1 AS level_num
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    -- Recursive: their reports
    SELECT e.emp_id, e.first_name, e.manager_id, h.level_num + 1
    FROM employees e
    JOIN emp_hierarchy h ON e.manager_id = h.emp_id
)
SELECT LPAD(' ', (level_num - 1) * 4) || first_name AS hierarchy,
       level_num, emp_id, manager_id
FROM emp_hierarchy
ORDER BY level_num, emp_id;
```

---

## 8.7 Subquery Types Summary

| Type                 | Returns               | Used With                              |
|----------------------|-----------------------|----------------------------------------|
| Single-row subquery  | 1 row, 1 column       | `=`, `>`, `<`, `>=`, `<=`, `<>`        |
| Multiple-row subquery| Multiple rows         | `IN`, `NOT IN`, `ANY`, `ALL`           |
| Correlated subquery  | Depends on outer row  | `WHERE`, `SELECT`, `HAVING`            |
| Inline view          | Table (result set)    | `FROM` clause                          |
| Scalar subquery      | Single value          | `SELECT` clause                        |
| EXISTS subquery      | TRUE/FALSE            | `WHERE EXISTS`, `WHERE NOT EXISTS`     |

---

[← Previous: Joins](./07_joins.md) | [Back to README](./README.md) | [Next: Constraints →](./09_constraints.md)
