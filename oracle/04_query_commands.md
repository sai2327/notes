# Section 4 — Data Query Commands

> **SELECT** and its clauses are the most-used commands in Oracle SQL.
> This section covers: SELECT, DISTINCT, WHERE, ORDER BY, GROUP BY, HAVING.

---

## 4.1 SELECT

**What it does:** Retrieves data from one or more tables.

### Syntax
```sql
SELECT [DISTINCT] column1, column2, ...
FROM   table_name
[WHERE condition]
[GROUP BY columns]
[HAVING condition]
[ORDER BY columns [ASC|DESC]];
```

### Examples

```sql
-- Select all columns
SELECT * FROM employees;

-- Select specific columns
SELECT emp_id, first_name, last_name, salary
FROM employees;

-- Select with alias
SELECT emp_id         AS "Employee ID",
       first_name     AS "First Name",
       salary         AS "Monthly Salary"
FROM employees;

-- Select with expression
SELECT first_name,
       last_name,
       salary,
       salary * 12    AS annual_salary,
       salary * 0.10  AS bonus
FROM employees;

-- Select with string concatenation
SELECT first_name || ' ' || last_name AS full_name,
       job_title
FROM employees;

-- Select from dual
SELECT SYSDATE AS today, USER AS current_user FROM DUAL;

-- Select with ROWNUM (limits rows)
SELECT * FROM employees WHERE ROWNUM <= 5;

-- Select top 3 highest salaries
SELECT emp_id, first_name, salary
FROM employees
ORDER BY salary DESC
FETCH FIRST 3 ROWS ONLY;        -- Oracle 12c+

-- Alternative using ROWNUM for older Oracle
SELECT * FROM (
    SELECT emp_id, first_name, salary
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM <= 3;
```

---

## 4.2 DISTINCT

**What it does:** Removes duplicate rows from query results.

### Syntax
```sql
SELECT DISTINCT column1, column2, ...
FROM table_name;
```

### Examples

```sql
-- Get unique department IDs from employees
SELECT DISTINCT dept_id
FROM employees;

-- Get unique job titles
SELECT DISTINCT job_title
FROM employees;

-- Get unique courses in students
SELECT DISTINCT course
FROM students;

-- Get unique (course, grade) combinations
SELECT DISTINCT course, grade
FROM students
ORDER BY course, grade;

-- Count distinct departments
SELECT COUNT(DISTINCT dept_id) AS unique_depts
FROM employees;

-- Get distinct order statuses
SELECT DISTINCT status
FROM orders
ORDER BY status;
```

**Expected Output for `SELECT DISTINCT dept_id FROM employees`:**
```
DEPT_ID
-------
     10
     20
     30
     40
```

---

## 4.3 WHERE

**What it does:** Filters rows based on one or more conditions.

### Syntax
```sql
SELECT columns
FROM table_name
WHERE condition;
```

### Examples

```sql
-- Simple equality filter
SELECT * FROM employees
WHERE dept_id = 20;

-- Not equal
SELECT * FROM employees
WHERE dept_id <> 10;

-- Greater than
SELECT * FROM employees
WHERE salary > 65000;

-- Multiple conditions with AND
SELECT * FROM employees
WHERE dept_id = 20 AND salary > 60000;

-- Multiple conditions with OR
SELECT * FROM employees
WHERE dept_id = 10 OR dept_id = 30;

-- NOT condition
SELECT * FROM employees
WHERE NOT dept_id = 40;

-- Filter by date range
SELECT * FROM employees
WHERE hire_date >= DATE '2020-01-01'
  AND hire_date <= DATE '2022-12-31';

-- Filter with LIKE (pattern match)
SELECT * FROM employees
WHERE first_name LIKE 'A%';     -- starts with A

SELECT * FROM employees
WHERE last_name LIKE '%on%';    -- contains 'on'

-- Filter NULL values
SELECT * FROM employees
WHERE manager_id IS NULL;       -- top-level managers

SELECT * FROM employees
WHERE manager_id IS NOT NULL;  -- non-managers

-- IN clause
SELECT * FROM employees
WHERE dept_id IN (10, 20, 30);

-- BETWEEN clause
SELECT * FROM employees
WHERE salary BETWEEN 55000 AND 70000;

-- Filter students by grade
SELECT * FROM students
WHERE grade IN ('A', 'B')
ORDER BY marks DESC;

-- Complex WHERE with subquery
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

---

## 4.4 ORDER BY

**What it does:** Sorts the query result by one or more columns, ascending or descending.

### Syntax
```sql
SELECT columns
FROM table_name
[WHERE condition]
ORDER BY column1 [ASC|DESC], column2 [ASC|DESC], ...;
```

### Examples

```sql
-- Sort by salary ascending (default)
SELECT emp_id, first_name, salary
FROM employees
ORDER BY salary;

-- Sort by salary descending
SELECT emp_id, first_name, salary
FROM employees
ORDER BY salary DESC;

-- Sort by multiple columns
SELECT emp_id, first_name, dept_id, salary
FROM employees
ORDER BY dept_id ASC, salary DESC;

-- Sort by column position (column number in SELECT list)
SELECT emp_id, first_name, salary
FROM employees
ORDER BY 3 DESC;          -- 3rd column = salary

-- Sort by alias
SELECT first_name, salary * 12 AS annual_sal
FROM employees
ORDER BY annual_sal DESC;

-- Sort with NULLs at end (Oracle default: NULLs LAST for ASC)
SELECT emp_id, first_name, manager_id
FROM employees
ORDER BY manager_id ASC NULLS LAST;

-- Sort NULLs first
SELECT emp_id, first_name, manager_id
FROM employees
ORDER BY manager_id ASC NULLS FIRST;

-- Sort students by marks descending, name ascending
SELECT name, course, marks
FROM students
ORDER BY marks DESC, name ASC;

-- Sort orders by date, then status
SELECT order_id, customer, order_date, status
FROM orders
ORDER BY order_date DESC, status ASC;
```

---

## 4.5 GROUP BY

**What it does:** Groups rows that have the same values in specified columns, typically used with aggregate functions.

### Syntax
```sql
SELECT column, aggregate_function(col)
FROM table_name
[WHERE condition]
GROUP BY column
[HAVING condition]
[ORDER BY column];
```

> **Rule:** Every column in SELECT that is NOT inside an aggregate function MUST appear in GROUP BY.

### Examples

```sql
-- Count employees per department
SELECT dept_id, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id
ORDER BY dept_id;

-- Average salary per department
SELECT dept_id,
       COUNT(*)     AS emp_count,
       AVG(salary)  AS avg_salary,
       MIN(salary)  AS min_salary,
       MAX(salary)  AS max_salary,
       SUM(salary)  AS total_salary
FROM employees
GROUP BY dept_id
ORDER BY dept_id;

-- Count students per course
SELECT course,
       COUNT(*)         AS total_students,
       AVG(marks)       AS avg_marks,
       MAX(marks)       AS top_marks
FROM students
GROUP BY course
ORDER BY avg_marks DESC;

-- Total revenue per customer
SELECT customer,
       COUNT(*)              AS total_orders,
       SUM(qty * unit_price) AS total_revenue
FROM orders
GROUP BY customer
ORDER BY total_revenue DESC;

-- Group by multiple columns
SELECT dept_id, job_title, COUNT(*) AS cnt, AVG(salary) AS avg_sal
FROM employees
GROUP BY dept_id, job_title
ORDER BY dept_id, avg_sal DESC;

-- Group by with WHERE (filter before grouping)
SELECT dept_id, AVG(salary) AS avg_sal
FROM employees
WHERE hire_date >= DATE '2019-01-01'
GROUP BY dept_id;

-- ROLLUP — adds subtotals and grand total
SELECT dept_id, job_title, SUM(salary) AS total_sal
FROM employees
GROUP BY ROLLUP(dept_id, job_title)
ORDER BY dept_id, job_title;

-- CUBE — all combinations of subtotals
SELECT dept_id, job_title, SUM(salary) AS total_sal
FROM employees
GROUP BY CUBE(dept_id, job_title)
ORDER BY dept_id, job_title;
```

---

## 4.6 HAVING

**What it does:** Filters groups created by GROUP BY (same role as WHERE, but for groups and aggregates).

### Syntax
```sql
SELECT column, aggregate_function(col)
FROM table_name
GROUP BY column
HAVING aggregate_condition;
```

> **Key difference:** `WHERE` filters individual rows **before** grouping. `HAVING` filters groups **after** grouping.

### Examples

```sql
-- Find departments with more than 2 employees
SELECT dept_id, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id
HAVING COUNT(*) > 2;

-- Find departments with average salary > 65000
SELECT dept_id, AVG(salary) AS avg_sal
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > 65000
ORDER BY avg_sal DESC;

-- Courses with more than 1 student scoring 'A'
SELECT course, COUNT(*) AS a_students
FROM students
WHERE grade = 'A'
GROUP BY course
HAVING COUNT(*) > 1;

-- Customers who spent more than 100000 total
SELECT customer,
       SUM(qty * unit_price) AS total_spent
FROM orders
WHERE status = 'Delivered'
GROUP BY customer
HAVING SUM(qty * unit_price) > 100000;

-- Combined WHERE + GROUP BY + HAVING + ORDER BY
SELECT dept_id,
       COUNT(*)        AS emp_count,
       AVG(salary)     AS avg_sal,
       MAX(salary)     AS max_sal
FROM employees
WHERE hire_date BETWEEN DATE '2018-01-01' AND DATE '2023-12-31'
GROUP BY dept_id
HAVING COUNT(*) >= 2
   AND AVG(salary) > 60000
ORDER BY avg_sal DESC;
```

**Expected Output:**
```
DEPT_ID  EMP_COUNT  AVG_SAL   MAX_SAL
-------  ---------  --------  -------
     20          3  66333.33    72000
     30          2  68000.00    75000
```

---

## 4.7 SELECT Query Execution Order

Oracle processes SELECT clauses in this order:

```
1. FROM          — source tables
2. WHERE         — row-level filter
3. GROUP BY      — group rows
4. HAVING        — group-level filter
5. SELECT        — choose columns / compute expressions
6. DISTINCT      — remove duplicates
7. ORDER BY      — sort result
8. FETCH/ROWNUM  — limit rows
```

---

## 4.8 Pagination with OFFSET / FETCH

```sql
-- Oracle 12c+ Pagination
-- Page 1: rows 1–5
SELECT emp_id, first_name, salary
FROM employees
ORDER BY salary DESC
FETCH FIRST 5 ROWS ONLY;

-- Page 2: rows 6–10
SELECT emp_id, first_name, salary
FROM employees
ORDER BY salary DESC
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;

-- Page 3: rows 11–15
SELECT emp_id, first_name, salary
FROM employees
ORDER BY salary DESC
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;

-- Oracle 11g Pagination (using ROWNUM and subquery)
SELECT *
FROM (
    SELECT e.*, ROWNUM AS rn
    FROM (
        SELECT emp_id, first_name, salary
        FROM employees
        ORDER BY salary DESC
    ) e
    WHERE ROWNUM <= 10
)
WHERE rn >= 6;
```

---

[← Previous: DML Commands](./03_dml_commands.md) | [Back to README](./README.md) | [Next: Operators →](./05_operators.md)
