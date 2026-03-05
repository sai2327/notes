# Section 5 — Operators

> Oracle SQL supports a rich set of operators for filtering, comparing, and combining data.

---

## 5.1 Arithmetic Operators

**What they do:** Perform mathematical calculations on numeric values.

| Operator | Description        | Example         |
|----------|--------------------|-----------------|
| `+`      | Addition           | `salary + 1000` |
| `-`      | Subtraction        | `salary - 500`  |
| `*`      | Multiplication     | `salary * 12`   |
| `/`      | Division           | `salary / 30`   |
| `MOD`    | Modulus (remainder)| `MOD(10, 3)`    |

### Examples

```sql
-- Calculate annual salary, bonus, and daily rate
SELECT first_name,
       salary                      AS monthly_salary,
       salary * 12                 AS annual_salary,
       salary * 0.15               AS yearly_bonus,
       ROUND(salary / 30, 2)       AS daily_rate,
       salary + 5000               AS after_raise
FROM employees;

-- Calculate total order value
SELECT order_id,
       product,
       qty,
       unit_price,
       qty * unit_price             AS total_value,
       qty * unit_price * 0.18      AS gst_amount,
       qty * unit_price * 1.18      AS total_with_gst
FROM orders;

-- Use arithmetic in WHERE clause
SELECT * FROM employees
WHERE salary * 12 > 750000;

-- Modulus example
SELECT emp_id, MOD(emp_id, 2) AS is_even
FROM employees;
```

---

## 5.2 Comparison Operators

**What they do:** Compare two values and return TRUE or FALSE.

| Operator | Description              | Example              |
|----------|--------------------------|----------------------|
| `=`      | Equal to                 | `salary = 60000`     |
| `<>` / `!=` | Not equal to          | `dept_id <> 10`      |
| `>`      | Greater than             | `salary > 70000`     |
| `<`      | Less than                | `salary < 50000`     |
| `>=`     | Greater than or equal    | `marks >= 60`        |
| `<=`     | Less than or equal       | `marks <= 90`        |

### Examples

```sql
-- Equal to
SELECT * FROM employees WHERE dept_id = 20;

-- Not equal
SELECT * FROM employees WHERE dept_id != 10;
SELECT * FROM employees WHERE dept_id <> 10;   -- same result

-- Greater than / less than
SELECT * FROM employees WHERE salary > 65000;
SELECT * FROM students   WHERE marks  < 70;

-- Greater than or equal
SELECT * FROM employees WHERE hire_date >= DATE '2020-01-01';

-- Less than or equal
SELECT * FROM orders WHERE qty <= 2;

-- Combining comparisons
SELECT first_name, salary, dept_id
FROM employees
WHERE salary >= 60000
  AND salary <= 80000
  AND dept_id <> 40;
```

---

## 5.3 Logical Operators

**What they do:** Combine multiple conditions.

| Operator | Description                                  |
|----------|----------------------------------------------|
| `AND`    | Both conditions must be TRUE                 |
| `OR`     | At least one condition must be TRUE          |
| `NOT`    | Reverses the condition (TRUE → FALSE)        |

### Truth Table

| A     | B     | A AND B | A OR B | NOT A |
|-------|-------|---------|--------|-------|
| TRUE  | TRUE  | TRUE    | TRUE   | FALSE |
| TRUE  | FALSE | FALSE   | TRUE   | FALSE |
| FALSE | TRUE  | FALSE   | TRUE   | TRUE  |
| FALSE | FALSE | FALSE   | FALSE  | TRUE  |

### Examples

```sql
-- AND: both conditions must be true
SELECT * FROM employees
WHERE dept_id = 20 AND salary > 65000;

-- OR: either condition can be true
SELECT * FROM employees
WHERE dept_id = 10 OR dept_id = 40;

-- NOT: negates condition
SELECT * FROM employees
WHERE NOT dept_id = 30;

-- NOT with IN
SELECT * FROM employees
WHERE dept_id NOT IN (10, 40);

-- NOT with LIKE
SELECT * FROM employees
WHERE first_name NOT LIKE 'A%';

-- Complex combination
SELECT emp_id, first_name, dept_id, salary
FROM employees
WHERE (dept_id = 20 OR dept_id = 30)
  AND salary > 60000
  AND NOT job_title LIKE '%Manager%';

-- Students who passed (marks >= 40) and enrolled in 2022
SELECT name, course, marks
FROM students
WHERE marks >= 40
  AND enroll_date BETWEEN DATE '2022-01-01' AND DATE '2022-12-31';
```

---

## 5.4 BETWEEN Operator

**What it does:** Checks if a value falls within a range (inclusive of both endpoints).

### Syntax
```sql
column BETWEEN low_value AND high_value
column NOT BETWEEN low_value AND high_value
```

### Examples

```sql
-- Salary range
SELECT emp_id, first_name, salary
FROM employees
WHERE salary BETWEEN 55000 AND 70000;

-- Date range
SELECT * FROM employees
WHERE hire_date BETWEEN DATE '2020-01-01' AND DATE '2022-12-31';

-- Marks range
SELECT name, marks
FROM students
WHERE marks BETWEEN 70 AND 90;

-- NOT BETWEEN
SELECT * FROM employees
WHERE salary NOT BETWEEN 55000 AND 65000;

-- BETWEEN with strings (alphabetical range)
SELECT * FROM employees
WHERE first_name BETWEEN 'A' AND 'E';

-- Orders in a price range
SELECT order_id, product, unit_price
FROM orders
WHERE unit_price BETWEEN 10000 AND 50000;
```

---

## 5.5 IN Operator

**What it does:** Checks if a value matches any value in a list or subquery result.

### Syntax
```sql
column IN (value1, value2, ...)
column IN (SELECT ...)
column NOT IN (value1, value2, ...)
```

### Examples

```sql
-- IN with list
SELECT * FROM employees
WHERE dept_id IN (10, 30);

-- IN with strings
SELECT * FROM students
WHERE course IN ('Computer Science', 'Mathematics');

-- NOT IN
SELECT * FROM employees
WHERE dept_id NOT IN (20, 40);

-- IN with subquery
SELECT * FROM employees
WHERE dept_id IN (SELECT dept_id FROM departments WHERE location = 'Chicago');

-- IN with orders
SELECT * FROM orders
WHERE status IN ('Pending', 'Shipped');

-- NOT IN — employees not in IT dept
SELECT first_name, job_title
FROM employees
WHERE emp_id NOT IN (SELECT emp_id FROM employees WHERE dept_id = 20);

-- IN with multiple columns (Oracle supports this)
SELECT * FROM employees
WHERE (dept_id, job_title) IN (
    (20, 'DBA'),
    (30, 'Analyst')
);
```

> ⚠️ **Caution:** `NOT IN` returns no rows if the subquery contains a NULL value. Use `NOT EXISTS` as a safer alternative.

---

## 5.6 LIKE Operator

**What it does:** Performs pattern matching on character strings.

### Wildcards

| Wildcard | Matches                                  | Example          |
|----------|------------------------------------------|------------------|
| `%`      | Zero or more characters                  | `'A%'` → Alice   |
| `_`      | Exactly one character                    | `'_ob'` → Bob    |

### Syntax
```sql
column LIKE 'pattern'
column NOT LIKE 'pattern'
column LIKE 'pattern' ESCAPE 'escape_char'
```

### Examples

```sql
-- Starts with 'A'
SELECT * FROM employees WHERE first_name LIKE 'A%';

-- Ends with 's'
SELECT * FROM employees WHERE last_name LIKE '%s';

-- Contains 'an' anywhere
SELECT * FROM employees WHERE first_name LIKE '%an%';

-- Second letter is 'o'
SELECT * FROM employees WHERE first_name LIKE '_o%';

-- Exactly 3 characters
SELECT * FROM employees WHERE first_name LIKE '___';

-- NOT LIKE
SELECT * FROM employees WHERE first_name NOT LIKE 'A%';

-- Email contains 'gmail'
SELECT name FROM students WHERE name LIKE '%a%';

-- LIKE with ESCAPE — search for literal % sign
-- Suppose product column has '50% off'
SELECT * FROM orders WHERE product LIKE '%\%%' ESCAPE '\';

-- Case-insensitive LIKE using UPPER
SELECT * FROM employees
WHERE UPPER(job_title) LIKE '%MANAGER%';

-- Find students whose name starts with 'P' or 'R'
SELECT name, course FROM students
WHERE name LIKE 'P%' OR name LIKE 'R%';
```

---

## 5.7 IS NULL / IS NOT NULL

**What it does:** Checks whether a column value is NULL (unknown/missing).

> ⚠️ You cannot use `= NULL`. Always use `IS NULL`.

### Syntax
```sql
column IS NULL
column IS NOT NULL
```

### Examples

```sql
-- Employees without a manager (top-level)
SELECT emp_id, first_name, job_title
FROM employees
WHERE manager_id IS NULL;

-- Employees who have a manager
SELECT emp_id, first_name, manager_id
FROM employees
WHERE manager_id IS NOT NULL;

-- Orders without a status
SELECT * FROM orders
WHERE status IS NULL;

-- NVL — replace NULL with a value
SELECT emp_id, first_name,
       NVL(manager_id, 0) AS manager_id
FROM employees;

-- NVL2 — different value for NULL vs NOT NULL
SELECT first_name,
       NVL2(manager_id, 'Has Manager', 'No Manager') AS manager_status
FROM employees;

-- COALESCE — return first non-null value
SELECT emp_id,
       COALESCE(manager_id, dept_id, emp_id) AS some_id
FROM employees;

-- NULLIF — returns NULL if two values are equal
SELECT emp_id,
       NULLIF(dept_id, 20) AS dept_check
FROM employees;

-- Count non-null values
SELECT COUNT(manager_id)  AS with_manager,
       COUNT(*)            AS total_employees
FROM employees;
```

---

## 5.8 CONCAT Operator (||)

**What it does:** Concatenates two or more strings.

```sql
-- Using || operator
SELECT first_name || ' ' || last_name AS full_name FROM employees;

-- Using CONCAT function (only 2 arguments)
SELECT CONCAT(first_name, last_name) AS name FROM employees;

-- Multi-part concatenation
SELECT emp_id || ': ' || first_name || ' ' || last_name || ' (' || job_title || ')' AS employee_info
FROM employees;
```

---

## 5.9 Operator Precedence

Oracle evaluates operators in this order (highest to lowest):

```
1. Arithmetic:      * /  (then + -)
2. Concatenation:   ||
3. Comparison:      =  <>  <  >  <=  >=  LIKE  IN  BETWEEN  IS NULL
4. Logical NOT:     NOT
5. Logical AND:     AND
6. Logical OR:      OR
```

```sql
-- Without parentheses - AND evaluated before OR
SELECT * FROM employees
WHERE dept_id = 10 OR dept_id = 20 AND salary > 65000;
-- Equivalent to: dept_id = 10 OR (dept_id = 20 AND salary > 65000)

-- Use parentheses to force evaluation order
SELECT * FROM employees
WHERE (dept_id = 10 OR dept_id = 20) AND salary > 65000;
```

---

[← Previous: Query Commands](./04_query_commands.md) | [Back to README](./README.md) | [Next: Functions →](./06_functions.md)
