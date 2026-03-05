# Section 15 — Practice Problems

> Complete exercises to test your Oracle SQL and PL/SQL knowledge.
> All queries use the sample tables: `employees`, `departments`, `students`, `orders`.

---

## Prerequisites — Setup

Run these before attempting exercises:
```sql
-- Make sure sample tables exist (see README.md setup scripts)
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM departments;
SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM orders;
```

---

## 15.1 Basic SQL Practice (Beginner)

---

**Exercise 1:** Display all employees with their full name as a single column.
```sql
-- Expected: "Alice Smith", "Bob Jones", etc.
SELECT first_name || ' ' || last_name AS full_name
FROM employees;
```

---

**Exercise 2:** List all distinct job titles in the company.
```sql
SELECT DISTINCT job_title
FROM employees
ORDER BY job_title;
```

---

**Exercise 3:** Find all employees whose salary is between 55,000 and 70,000.
```sql
SELECT emp_id, first_name, salary
FROM employees
WHERE salary BETWEEN 55000 AND 70000
ORDER BY salary;
```

---

**Exercise 4:** Display employees hired in the year 2020.
```sql
SELECT emp_id, first_name, hire_date
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') = '2020'
ORDER BY hire_date;
```

---

**Exercise 5:** Find all students whose name starts with a vowel (A, E, I, O, U).
```sql
SELECT name, course, marks
FROM students
WHERE UPPER(SUBSTR(name, 1, 1)) IN ('A','E','I','O','U')
ORDER BY name;
```

---

**Exercise 6:** Show the 3 most expensive orders.
```sql
SELECT order_id, customer, product,
       qty * unit_price AS total_value
FROM orders
ORDER BY total_value DESC
FETCH FIRST 3 ROWS ONLY;
```

---

**Exercise 7:** Count the number of employees in each department.
```sql
SELECT dept_id,
       COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id
ORDER BY dept_id;
```

---

**Exercise 8:** Find departments with average salary greater than 62,000.
```sql
SELECT dept_id,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > 62000
ORDER BY avg_salary DESC;
```

---

## 15.2 Intermediate SQL Practice

---

**Exercise 9:** Display employee names along with their department name.
```sql
SELECT e.first_name, e.last_name, d.dept_name, d.location
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_name, e.first_name;
```

---

**Exercise 10:** Find all employees who earn more than the company average salary.
```sql
SELECT emp_id, first_name, salary,
       ROUND((SELECT AVG(salary) FROM employees), 0) AS company_avg
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;
```

---

**Exercise 11:** Show each employee and their manager's name.
```sql
SELECT e.emp_id,
       e.first_name                AS employee,
       e.salary                    AS emp_salary,
       NVL(m.first_name, 'No Manager') AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
ORDER BY e.emp_id;
```

---

**Exercise 12:** For each course, show the student with the highest marks.
```sql
SELECT course, name, marks
FROM students s
WHERE marks = (
    SELECT MAX(marks) FROM students
    WHERE course = s.course
)
ORDER BY course;
```

---

**Exercise 13:** List all departments that have MORE employees than the average department size.
```sql
WITH dept_counts AS (
    SELECT dept_id, COUNT(*) AS cnt
    FROM employees
    GROUP BY dept_id
)
SELECT d.dept_name, dc.cnt AS employee_count
FROM dept_counts dc
JOIN departments d ON dc.dept_id = d.dept_id
WHERE dc.cnt > (SELECT AVG(cnt) FROM dept_counts)
ORDER BY dc.cnt DESC;
```

---

**Exercise 14:** Calculate total revenue per customer, only for delivered orders.
```sql
SELECT customer,
       COUNT(*)                   AS delivered_orders,
       SUM(qty * unit_price)      AS total_revenue,
       AVG(qty * unit_price)      AS avg_order_value
FROM orders
WHERE status = 'Delivered'
GROUP BY customer
ORDER BY total_revenue DESC;
```

---

**Exercise 15:** Find employees who share the same department as 'Alice'.
```sql
SELECT emp_id, first_name, dept_id
FROM employees
WHERE dept_id = (
    SELECT dept_id FROM employees WHERE first_name = 'Alice'
)
AND first_name != 'Alice';
```

---

## 15.3 Advanced SQL Practice

---

**Exercise 16:** Rank employees by salary within each department.
```sql
SELECT dept_id, emp_id, first_name, salary,
       RANK()       OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rank_by_sal,
       DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dense_rank,
       ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS row_num
FROM employees
ORDER BY dept_id, rank_by_sal;
```

---

**Exercise 17:** Show running total of salaries, ordered by hire date.
```sql
SELECT emp_id, first_name, hire_date, salary,
       SUM(salary) OVER (ORDER BY hire_date) AS running_total,
       AVG(salary) OVER (ORDER BY hire_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM employees
ORDER BY hire_date;
```

---

**Exercise 18:** Find the second highest salary in the company.
```sql
-- Method 1: Using subquery
SELECT MAX(salary) AS second_highest
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Method 2: Using DENSE_RANK
SELECT DISTINCT salary AS second_highest
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
)
WHERE rnk = 2;
```

---

**Exercise 19:** Pivot: Show total salary per department as columns.
```sql
SELECT *
FROM (
    SELECT d.dept_name, e.salary
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
)
PIVOT (
    SUM(salary)
    FOR dept_name IN ('HR' AS hr, 'IT' AS it, 'Finance' AS finance, 'Marketing' AS marketing)
);
```

---

**Exercise 20:** Find employees with no subordinates (leaf employees in hierarchy).
```sql
SELECT emp_id, first_name, job_title
FROM employees
WHERE emp_id NOT IN (
    SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL
)
ORDER BY emp_id;
```

---

## 15.4 DDL/DML Practice

---

**Exercise 21:** Create a `products` table and insert 5 records.
```sql
CREATE TABLE products (
    prod_id    NUMBER       PRIMARY KEY,
    prod_name  VARCHAR2(100) NOT NULL,
    category   VARCHAR2(50),
    price      NUMBER(10,2)  CHECK (price > 0),
    stock_qty  NUMBER        DEFAULT 0,
    created_at DATE          DEFAULT SYSDATE
);

INSERT INTO products VALUES (1, 'Laptop Pro',    'Electronics', 85000, 50, SYSDATE);
INSERT INTO products VALUES (2, 'Wireless Mouse', 'Accessories',  1500, 200, SYSDATE);
INSERT INTO products VALUES (3, 'USB-C Hub',      'Accessories',  3500, 150, SYSDATE);
INSERT INTO products VALUES (4, 'Monitor 27"',   'Electronics', 22000, 30, SYSDATE);
INSERT INTO products VALUES (5, 'Keyboard',       'Accessories',  2500, 120, SYSDATE);

COMMIT;

SELECT * FROM products;
```

---

**Exercise 22:** Apply a 10% price increase to all Electronics products.
```sql
UPDATE products
SET price = price * 1.10
WHERE category = 'Electronics';

COMMIT;

SELECT prod_name, category, price FROM products ORDER BY category;
```

---

**Exercise 23:** Add a `discount` column and set it based on category.
```sql
ALTER TABLE products ADD discount NUMBER(5,2) DEFAULT 0;

UPDATE products
SET discount = CASE
    WHEN category = 'Electronics' THEN 5
    WHEN category = 'Accessories'  THEN 10
    ELSE 0
END;

COMMIT;

SELECT prod_name, price, discount, price * (1 - discount/100) AS discounted_price
FROM products;
```

---

## 15.5 PL/SQL Practice

---

**Exercise 24:** Write a PL/SQL block that prints grade and message for a given student.
```sql
DECLARE
    v_student_id  NUMBER := 1;
    v_name        students.name%TYPE;
    v_marks       students.marks%TYPE;
    v_grade       VARCHAR2(5);
    v_message     VARCHAR2(100);
BEGIN
    SELECT name, marks INTO v_name, v_marks
    FROM students WHERE student_id = v_student_id;

    v_grade := CASE
        WHEN v_marks >= 90 THEN 'A'
        WHEN v_marks >= 75 THEN 'B'
        WHEN v_marks >= 60 THEN 'C'
        WHEN v_marks >= 40 THEN 'D'
        ELSE                    'F'
    END;

    v_message := CASE v_grade
        WHEN 'A' THEN 'Excellent!'
        WHEN 'B' THEN 'Very Good'
        WHEN 'C' THEN 'Good'
        WHEN 'D' THEN 'Needs Improvement'
        ELSE          'Failed'
    END;

    DBMS_OUTPUT.PUT_LINE('Student : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Marks   : ' || v_marks);
    DBMS_OUTPUT.PUT_LINE('Grade   : ' || v_grade);
    DBMS_OUTPUT.PUT_LINE('Message : ' || v_message);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student ' || v_student_id || ' not found.');
END;
/
```

---

**Exercise 25:** Procedure to print all employees in a given department.
```sql
CREATE OR REPLACE PROCEDURE list_dept_employees (p_dept_id IN NUMBER)
AS
    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Employees in Dept ' || p_dept_id || ' ===');

    FOR rec IN (
        SELECT emp_id, first_name, salary, job_title
        FROM employees
        WHERE dept_id = p_dept_id
        ORDER BY salary DESC
    ) LOOP
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE(
            v_count || '. ' ||
            RPAD(rec.first_name, 15) || ' | ' ||
            RPAD(rec.job_title, 20)  || ' | ' ||
            TO_CHAR(rec.salary, '999,999')
        );
    END LOOP;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No employees in this department.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Total: ' || v_count || ' employee(s).');
    END IF;
END;
/

EXEC list_dept_employees(20);
EXEC list_dept_employees(10);
```

---

**Exercise 26:** Function to calculate employee bonus.
```sql
CREATE OR REPLACE FUNCTION calc_bonus (
    p_emp_id IN NUMBER,
    p_year   IN NUMBER DEFAULT EXTRACT(YEAR FROM SYSDATE)
)
RETURN NUMBER
AS
    v_salary     NUMBER;
    v_years      NUMBER;
    v_bonus_pct  NUMBER;
    v_bonus      NUMBER;
BEGIN
    SELECT salary,
           FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date) / 12)
    INTO v_salary, v_years
    FROM employees WHERE emp_id = p_emp_id;

    v_bonus_pct := CASE
        WHEN v_years >= 5 THEN 20
        WHEN v_years >= 3 THEN 15
        WHEN v_years >= 1 THEN 10
        ELSE 5
    END;

    v_bonus := ROUND(v_salary * v_bonus_pct / 100, 0);
    RETURN v_bonus;

EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
END calc_bonus;
/

-- Use in query
SELECT emp_id, first_name, salary, hire_date,
       calc_bonus(emp_id) AS bonus,
       salary + calc_bonus(emp_id) AS total_package
FROM employees
ORDER BY bonus DESC;
```

---

## 15.6 Output Prediction Exercises

**Predict the output before running each query:**

---

**Predict 1:**
```sql
SELECT MOD(17, 5), FLOOR(7.9), CEIL(7.1), ROUND(7.5, 0) FROM DUAL;
```
> Expected: `2`, `7`, `8`, `8`

---

**Predict 2:**
```sql
SELECT NVL(NULL, 'Default'), NVL('Value', 'Default') FROM DUAL;
```
> Expected: `Default`, `Value`

---

**Predict 3:**
```sql
SELECT SUBSTR('Hello World', 7, 5) FROM DUAL;
```
> Expected: `World`

---

**Predict 4:**
```sql
SELECT LENGTH(TRIM('   Oracle   ')) FROM DUAL;
```
> Expected: `6`

---

**Predict 5:**
```sql
DECLARE
    x NUMBER := 10;
    y NUMBER := 3;
BEGIN
    DBMS_OUTPUT.PUT_LINE(x / y);
    DBMS_OUTPUT.PUT_LINE(ROUND(x / y, 2));
    DBMS_OUTPUT.PUT_LINE(MOD(x, y));
END;
/
```
> Expected: `3.3333333333...`, `3.33`, `1`

---

**Predict 6:**
```sql
SELECT CASE
    WHEN 5 > 3 AND 2 < 1 THEN 'First'
    WHEN 5 > 3 OR  2 < 1 THEN 'Second'
    ELSE 'Third'
END FROM DUAL;
```
> Expected: `Second`  
> (First condition fails because `2 < 1` is FALSE; Second succeeds because OR needs only one TRUE)

---

## 15.7 Challenge Problems

---

**Challenge 1:** Find employees who earn more than their department's average and list the difference.
```sql
SELECT e.emp_id,
       e.first_name,
       e.dept_id,
       e.salary,
       ROUND(dept_avg.avg_sal, 0)        AS dept_avg,
       e.salary - dept_avg.avg_sal       AS above_avg_by
FROM employees e
JOIN (
    SELECT dept_id, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY dept_id
) dept_avg ON e.dept_id = dept_avg.dept_id
WHERE e.salary > dept_avg.avg_sal
ORDER BY e.dept_id, above_avg_by DESC;
```

---

**Challenge 2:** Generate an employee hierarchy report using CONNECT BY.
```sql
SELECT LPAD(' ', (LEVEL - 1) * 4) || first_name AS hierarchy,
       LEVEL                                       AS depth,
       emp_id,
       manager_id,
       job_title
FROM employees
START WITH manager_id IS NULL          -- start from top
CONNECT BY PRIOR emp_id = manager_id   -- walk down hierarchy
ORDER SIBLINGS BY first_name;
```

---

**Challenge 3:** Report showing students with name, course, marks, and percentile rank.
```sql
SELECT name, course, marks,
       ROUND(PERCENT_RANK() OVER (PARTITION BY course ORDER BY marks) * 100, 1) AS percentile,
       RANK()       OVER (PARTITION BY course ORDER BY marks DESC) AS course_rank,
       RANK()       OVER (ORDER BY marks DESC) AS overall_rank
FROM students
ORDER BY course, course_rank;
```

---

**Challenge 4:** Find the month with the most employee hires.
```sql
SELECT TO_CHAR(hire_date, 'YYYY-MM') AS hire_month,
       TO_CHAR(hire_date, 'Month YYYY') AS month_name,
       COUNT(*) AS hires
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY-MM'), TO_CHAR(hire_date, 'Month YYYY')
ORDER BY hires DESC, hire_month
FETCH FIRST 3 ROWS ONLY;
```

---

**Challenge 5:** Complete DML transaction — process a salary revision with audit log.
```sql
-- Setup
CREATE TABLE revision_log (
    log_id     NUMBER GENERATED ALWAYS AS IDENTITY,
    emp_id     NUMBER,
    old_salary NUMBER,
    new_salary NUMBER,
    revision_pct NUMBER,
    log_date   DATE DEFAULT SYSDATE,
    processed_by VARCHAR2(50) DEFAULT USER
);

-- Process revisions in a transaction
DECLARE
    CURSOR emp_cur IS
        SELECT emp_id, first_name, salary, dept_id
        FROM employees
        FOR UPDATE OF salary;

    v_revision_pct  NUMBER;
    v_new_salary    NUMBER;
    v_count         NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Salary Revision Processing ===');

    FOR emp IN emp_cur LOOP
        -- Set revision % by department
        v_revision_pct := CASE
            WHEN emp.dept_id = 20 THEN 12   -- IT: 12%
            WHEN emp.dept_id = 30 THEN 8    -- Finance: 8%
            ELSE                       5    -- Others: 5%
        END;

        v_new_salary := ROUND(emp.salary * (1 + v_revision_pct/100), 0);

        -- Update salary
        UPDATE employees
        SET salary = v_new_salary
        WHERE CURRENT OF emp_cur;

        -- Log the change
        INSERT INTO revision_log (emp_id, old_salary, new_salary, revision_pct)
        VALUES (emp.emp_id, emp.salary, v_new_salary, v_revision_pct);

        v_count := v_count + 1;

        DBMS_OUTPUT.PUT_LINE(
            emp.first_name || ': ' || emp.salary ||
            ' -> ' || v_new_salary ||
            ' (+' || v_revision_pct || '%)'
        );
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Done. ' || v_count || ' employees updated.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM || ' - Transaction rolled back.');
END;
/

-- Review results
SELECT e.first_name, r.old_salary, r.new_salary, r.revision_pct, r.log_date
FROM revision_log r
JOIN employees e ON r.emp_id = e.emp_id
ORDER BY r.log_id;
```

---

## 15.8 Self-Test Checklist

After completing this guide, you should be able to:

| Skill | Level |
|-------|-------|
| Create and modify tables with DDL | ✅ Beginner |
| Write INSERT, UPDATE, DELETE with conditions | ✅ Beginner |
| Use SELECT with WHERE, ORDER BY, GROUP BY, HAVING | ✅ Beginner |
| Use all major Oracle functions (string/number/date) | ✅ Beginner |
| Write INNER, LEFT, RIGHT, FULL, SELF, CROSS joins | ✅ Intermediate |
| Write single-row and multi-row subqueries | ✅ Intermediate |
| Use correlated subqueries and CTEs | ✅ Intermediate |
| Create views, indexes, sequences, synonyms | ✅ Intermediate |
| Manage transactions with COMMIT/ROLLBACK/SAVEPOINT | ✅ Intermediate |
| Write PL/SQL blocks with variables, IF, CASE, loops | ✅ Intermediate |
| Write explicit cursors and handle exceptions | ✅ Intermediate |
| Create procedures, functions, and triggers | ✅ Advanced |
| Use window/analytic functions (RANK, DENSE_RANK, etc.) | ✅ Advanced |
| Debug with SHOW ERRORS and data dictionary views | ✅ Advanced |

---

[← Previous: Cheat Sheet](./14_cheat_sheet.md) | [Back to README](./README.md)
