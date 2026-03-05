# Section 6 — Oracle Functions

> Oracle provides a rich library of built-in functions for strings, numbers, dates, conversion, and aggregation.

---

## 6.1 Character Functions

---

### UPPER / LOWER / INITCAP

**What they do:** Change the case of a string.

```sql
-- UPPER: converts to ALL UPPERCASE
SELECT UPPER('hello world')       FROM DUAL;    -- HELLO WORLD
SELECT UPPER(first_name)          FROM employees;

-- LOWER: converts to all lowercase
SELECT LOWER('ORACLE DATABASE')   FROM DUAL;    -- oracle database
SELECT LOWER(job_title)           FROM employees;

-- INITCAP: Capitalizes First Letter Of Each Word
SELECT INITCAP('oracle sql developer')  FROM DUAL;   -- Oracle Sql Developer
SELECT INITCAP(first_name || ' ' || last_name) AS full_name FROM employees;

-- Case-insensitive search using UPPER/LOWER
SELECT * FROM employees
WHERE UPPER(job_title) = 'DBA';

SELECT * FROM employees
WHERE LOWER(first_name) = 'alice';
```

---

### SUBSTR

**What it does:** Extracts a substring from a string.

### Syntax
```sql
SUBSTR(string, start_position, [length])
```
> `start_position` is 1-based. Negative start means count from the end.

```sql
-- Extract first 3 characters
SELECT SUBSTR('Oracle', 1, 3)        FROM DUAL;   -- Ora

-- Extract from position 4 onwards
SELECT SUBSTR('Oracle Database', 4)  FROM DUAL;   -- cle Database

-- Extract last 4 characters
SELECT SUBSTR('Oracle', -4)          FROM DUAL;   -- acle

-- Get first name's first 3 characters
SELECT SUBSTR(first_name, 1, 3) AS name_code
FROM employees;

-- Extract year from string date
SELECT SUBSTR('2024-03-15', 1, 4) AS yr FROM DUAL;   -- 2024

-- Combine SUBSTR with UPPER
SELECT UPPER(SUBSTR(first_name, 1, 1)) || LOWER(SUBSTR(first_name, 2)) AS formatted_name
FROM employees;
```

---

### LENGTH

**What it does:** Returns the number of characters in a string.

```sql
SELECT LENGTH('Oracle')                   FROM DUAL;   -- 6
SELECT LENGTH('Hello World')              FROM DUAL;   -- 11
SELECT LENGTH(NULL)                       FROM DUAL;   -- NULL

-- Get character count of each employee name
SELECT first_name, LENGTH(first_name) AS name_length
FROM employees
ORDER BY name_length DESC;

-- Find names longer than 5 characters
SELECT first_name FROM employees
WHERE LENGTH(first_name) > 5;

-- Get total characters in full name
SELECT first_name || ' ' || last_name AS full_name,
       LENGTH(first_name) + LENGTH(last_name) AS total_chars
FROM employees;
```

---

### TRIM / LTRIM / RTRIM

**What they do:** Remove leading, trailing, or both spaces (or specified characters) from a string.

```sql
-- TRIM: removes both leading and trailing spaces
SELECT TRIM('   Oracle   ')           FROM DUAL;   -- 'Oracle'

-- LTRIM: removes leading spaces/characters
SELECT LTRIM('   Oracle')             FROM DUAL;   -- 'Oracle'

-- RTRIM: removes trailing spaces/characters
SELECT RTRIM('Oracle   ')             FROM DUAL;   -- 'Oracle'

-- TRIM a specific character
SELECT TRIM('0' FROM '00123400')      FROM DUAL;   -- '1234'
SELECT LTRIM('00123400', '0')         FROM DUAL;   -- '123400'
SELECT RTRIM('00123400', '0')         FROM DUAL;   -- '001234'

-- Clean up product names with extra spaces
UPDATE orders
SET product = TRIM(product);

-- Remove specific characters
SELECT TRIM(BOTH '*' FROM '***Hello***')  FROM DUAL;  -- Hello
```

---

### LPAD / RPAD

**What they do:** Pad a string with characters on the left or right to a specified length.

```sql
-- LPAD: left-pad with zeros
SELECT LPAD(emp_id, 6, '0')     FROM employees;  -- 000101

-- RPAD: right-pad with dashes
SELECT RPAD(first_name, 15, '-')  FROM employees;  -- Alice----------

-- Format a column with fixed width
SELECT LPAD(TO_CHAR(salary), 10) AS formatted_salary
FROM employees;
```

---

### INSTR

**What it does:** Returns the position of a substring within a string.

```sql
-- Find first occurrence
SELECT INSTR('Oracle Database', 'a')       FROM DUAL;   -- 3

-- Find 2nd occurrence
SELECT INSTR('Oracle Database', 'a', 1, 2) FROM DUAL;   -- 10

-- Check if an email contains '@'
SELECT name FROM students
WHERE INSTR(name, 'a') > 0;

-- Find position of space (to split name)
SELECT first_name,
       INSTR(first_name, 'e') AS pos_of_e
FROM employees;
```

---

### REPLACE / TRANSLATE

```sql
-- REPLACE: replaces all occurrences of a substring
SELECT REPLACE('Hello World', 'World', 'Oracle')  FROM DUAL;  -- Hello Oracle
SELECT REPLACE('2024-03-15', '-', '/')            FROM DUAL;  -- 2024/03/15

-- Update product name
UPDATE orders
SET product = REPLACE(product, 'Phone', 'Smartphone');

-- TRANSLATE: character-by-character substitution
SELECT TRANSLATE('Hello123', '0123456789', 'XXXXXXXXXX')  FROM DUAL;  -- HelloXXX
```

---

## 6.2 Number Functions

---

### ROUND

**What it does:** Rounds a number to a specified number of decimal places.

### Syntax
```sql
ROUND(number, decimal_places)
```

```sql
SELECT ROUND(3.14159, 2)     FROM DUAL;   -- 3.14
SELECT ROUND(3.14159, 0)     FROM DUAL;   -- 3
SELECT ROUND(3.75, 0)        FROM DUAL;   -- 4
SELECT ROUND(1234.567, -2)   FROM DUAL;   -- 1200  (round to nearest 100)

-- Round salary to nearest thousand
SELECT first_name, salary,
       ROUND(salary, -3) AS rounded_salary
FROM employees;

-- Round marks
SELECT name, marks, ROUND(marks, 0) AS rounded_marks
FROM students;
```

---

### CEIL / FLOOR

**What they do:** Round up (CEIL) or down (FLOOR) to the nearest integer.

```sql
SELECT CEIL(3.1)     FROM DUAL;   -- 4
SELECT CEIL(3.9)     FROM DUAL;   -- 4
SELECT CEIL(-3.1)    FROM DUAL;   -- -3

SELECT FLOOR(3.9)    FROM DUAL;   -- 3
SELECT FLOOR(3.1)    FROM DUAL;   -- 3
SELECT FLOOR(-3.1)   FROM DUAL;   -- -4

-- Calculate pages needed (ceiling division)
-- 100 records, 15 per page = 7 pages
SELECT CEIL(100 / 15) AS pages_needed FROM DUAL;  -- 7

-- Daily cost (never round down)
SELECT first_name, CEIL(salary / 30) AS daily_cost
FROM employees;
```

---

### MOD

**What it does:** Returns the remainder of a division.

```sql
SELECT MOD(10, 3)    FROM DUAL;   -- 1
SELECT MOD(20, 4)    FROM DUAL;   -- 0
SELECT MOD(15, 7)    FROM DUAL;   -- 1

-- Find even/odd employee IDs
SELECT emp_id, first_name,
       CASE WHEN MOD(emp_id, 2) = 0 THEN 'Even' ELSE 'Odd' END AS parity
FROM employees;

-- Find orders with even order IDs
SELECT * FROM orders WHERE MOD(order_id, 2) = 0;
```

---

### ABS / SQRT / POWER

```sql
-- ABS: absolute value
SELECT ABS(-250)     FROM DUAL;   -- 250
SELECT ABS(salary - 65000) AS diff_from_target FROM employees;

-- SQRT: square root
SELECT SQRT(144)     FROM DUAL;   -- 12
SELECT SQRT(marks)   FROM students;

-- POWER: raise to a power
SELECT POWER(2, 10)  FROM DUAL;   -- 1024
SELECT POWER(salary, 0.5) AS salary_sqrt FROM employees;
```

---

## 6.3 Date Functions

---

### SYSDATE

**What it does:** Returns the current date and time from the database server.

```sql
-- Current date and time
SELECT SYSDATE FROM DUAL;

-- Current date formatted
SELECT TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') AS now FROM DUAL;

-- Tomorrow
SELECT SYSDATE + 1 AS tomorrow FROM DUAL;

-- Yesterday
SELECT SYSDATE - 1 AS yesterday FROM DUAL;

-- Days until year end
SELECT TRUNC(DATE '2026-12-31') - TRUNC(SYSDATE) AS days_remaining FROM DUAL;

-- SYSTIMESTAMP (includes timezone)
SELECT SYSTIMESTAMP FROM DUAL;
```

---

### ADD_MONTHS

**What it does:** Adds or subtracts a specified number of months from a date.

```sql
SELECT ADD_MONTHS(SYSDATE, 3)     FROM DUAL;  -- 3 months from now
SELECT ADD_MONTHS(SYSDATE, -6)    FROM DUAL;  -- 6 months ago
SELECT ADD_MONTHS(DATE '2024-01-31', 1) FROM DUAL;  -- 2024-02-29

-- Employees' 1-year anniversary
SELECT first_name, hire_date,
       ADD_MONTHS(hire_date, 12) AS one_year_ann
FROM employees;

-- Orders due in 30 days (approximately 1 month)
SELECT order_id, customer,
       ADD_MONTHS(order_date, 1) AS due_date
FROM orders;
```

---

### MONTHS_BETWEEN

**What it does:** Returns the number of months between two dates.

```sql
SELECT MONTHS_BETWEEN(DATE '2025-06-15', DATE '2024-01-15') FROM DUAL;  -- 17

-- Employee tenure in months
SELECT first_name, hire_date,
       ROUND(MONTHS_BETWEEN(SYSDATE, hire_date), 1) AS months_served
FROM employees
ORDER BY months_served DESC;

-- Employee tenure in years
SELECT first_name, hire_date,
       FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS years_exp
FROM employees;
```

---

### NEXT_DAY

**What it does:** Returns the date of the next specified weekday after a given date.

```sql
-- Next Monday from today
SELECT NEXT_DAY(SYSDATE, 'MONDAY')    FROM DUAL;

-- Next Friday
SELECT NEXT_DAY(SYSDATE, 'FRIDAY')    FROM DUAL;

-- Next Sunday from a specific date
SELECT NEXT_DAY(DATE '2024-03-05', 'SUNDAY') FROM DUAL;  -- 2024-03-10
```

---

### LAST_DAY

**What it does:** Returns the last day of the month for a given date.

```sql
SELECT LAST_DAY(SYSDATE)                FROM DUAL;
SELECT LAST_DAY(DATE '2024-02-01')      FROM DUAL;   -- 2024-02-29 (leap year)
SELECT LAST_DAY(DATE '2024-01-15')      FROM DUAL;   -- 2024-01-31

-- Days remaining in current month
SELECT LAST_DAY(SYSDATE) - SYSDATE AS days_left FROM DUAL;
```

---

### TRUNC (Date)

**What it does:** Truncates a date to a specified unit.

```sql
-- Truncate to day (removes time portion)
SELECT TRUNC(SYSDATE)                   FROM DUAL;

-- Truncate to month (1st of current month)
SELECT TRUNC(SYSDATE, 'MM')             FROM DUAL;

-- Truncate to year (Jan 1st of current year)
SELECT TRUNC(SYSDATE, 'YYYY')           FROM DUAL;

-- Employees hired in 2020 (comparing truncated dates)
SELECT * FROM employees
WHERE TRUNC(hire_date, 'YYYY') = DATE '2020-01-01';
```

---

## 6.4 Conversion Functions

---

### TO_CHAR

**What it does:** Converts a number or date to a formatted string.

```sql
-- Date to string
SELECT TO_CHAR(SYSDATE, 'DD-MON-YYYY')          FROM DUAL;  -- 05-MAR-2026
SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY')            FROM DUAL;  -- 05/03/2026
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')            FROM DUAL;  -- 2026-03-05
SELECT TO_CHAR(SYSDATE, 'DAY, DD MONTH YYYY')    FROM DUAL;  -- THURSDAY, 05 MARCH 2026
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS')            FROM DUAL;  -- 14:30:55
SELECT TO_CHAR(SYSDATE, 'DY')                    FROM DUAL;  -- THU

-- Number to string with formatting
SELECT TO_CHAR(75000, '99,999.00')               FROM DUAL;  -- 75,000.00
SELECT TO_CHAR(salary, '$999,999.00')            FROM employees;

-- Hire date formatted
SELECT first_name,
       TO_CHAR(hire_date, 'DD Month YYYY') AS hire_date_fmt
FROM employees;

-- Extract year / month
SELECT TO_CHAR(hire_date, 'YYYY') AS year,
       TO_CHAR(hire_date, 'MM')   AS month,
       first_name
FROM employees;
```

**Common Date Format Codes:**

| Format | Description          | Example    |
|--------|----------------------|------------|
| `DD`   | Day (01-31)          | 05         |
| `MM`   | Month number (01-12) | 03         |
| `MON`  | Month abbreviation   | MAR        |
| `MONTH`| Full month name      | MARCH      |
| `YYYY` | 4-digit year         | 2026       |
| `YY`   | 2-digit year         | 26         |
| `DAY`  | Full day name        | THURSDAY   |
| `DY`   | Day abbreviation     | THU        |
| `HH24` | Hour (0-23)          | 14         |
| `MI`   | Minutes              | 30         |
| `SS`   | Seconds              | 55         |

---

### TO_DATE

**What it does:** Converts a string to a DATE value.

```sql
-- Basic date conversion
SELECT TO_DATE('2024-03-15', 'YYYY-MM-DD')       FROM DUAL;

-- Insert with TO_DATE
INSERT INTO employees (emp_id, first_name, hire_date)
VALUES (115, 'Tom', TO_DATE('15-JAN-2024', 'DD-MON-YYYY'));

-- Use in WHERE clause
SELECT * FROM employees
WHERE hire_date >= TO_DATE('01-JAN-2020', 'DD-MON-YYYY');

-- Convert DD/MM/YYYY format
SELECT TO_DATE('25/12/2024', 'DD/MM/YYYY') AS xmas FROM DUAL;
```

---

### TO_NUMBER

**What it does:** Converts a string to a numeric value.

```sql
-- Convert string to number
SELECT TO_NUMBER('12345')              FROM DUAL;   -- 12345
SELECT TO_NUMBER('1,234.56', '9,999.99') FROM DUAL; -- 1234.56

-- Use in calculation
SELECT TO_NUMBER('5000') * 12 AS annual FROM DUAL;

-- Safe conversion in UPDATE
UPDATE orders
SET unit_price = TO_NUMBER('15000')
WHERE order_id = 1002;
```

---

## 6.5 Aggregate Functions

**What they do:** Perform calculations on a set of rows and return a single value.

---

### COUNT

```sql
-- Count all rows
SELECT COUNT(*) FROM employees;

-- Count non-null values in a column
SELECT COUNT(manager_id) AS has_manager FROM employees;

-- Count distinct values
SELECT COUNT(DISTINCT dept_id) AS dept_count FROM employees;

-- Count per group
SELECT dept_id, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id;

-- Count with condition
SELECT COUNT(*) AS high_earners
FROM employees
WHERE salary > 65000;
```

---

### SUM

```sql
-- Total salary
SELECT SUM(salary) AS total_payroll FROM employees;

-- Total revenue per customer
SELECT customer, SUM(qty * unit_price) AS revenue
FROM orders
GROUP BY customer;

-- Total salary by department
SELECT dept_id, SUM(salary) AS dept_total
FROM employees
GROUP BY dept_id
ORDER BY dept_total DESC;
```

---

### AVG

```sql
-- Average salary
SELECT AVG(salary) AS avg_salary FROM employees;

-- Average marks per course
SELECT course, ROUND(AVG(marks), 2) AS avg_marks
FROM students
GROUP BY course;

-- Employees earning above average
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

---

### MIN / MAX

```sql
-- Global min and max salary
SELECT MIN(salary) AS lowest, MAX(salary) AS highest FROM employees;

-- Earliest and latest hire date
SELECT MIN(hire_date) AS first_hire, MAX(hire_date) AS last_hire FROM employees;

-- Per department
SELECT dept_id,
       MIN(salary) AS min_sal,
       MAX(salary) AS max_sal,
       MAX(salary) - MIN(salary) AS salary_range
FROM employees
GROUP BY dept_id
ORDER BY dept_id;

-- Best and worst marks per course
SELECT course,
       MIN(marks) AS lowest_marks,
       MAX(marks) AS highest_marks
FROM students
GROUP BY course;
```

---

## 6.6 NULL Handling Functions

```sql
-- NVL: replace NULL with a default
SELECT emp_id, NVL(manager_id, 0) AS mgr FROM employees;

-- NVL2: value_if_not_null, value_if_null
SELECT first_name, NVL2(manager_id, 'Has Manager', 'No Manager') AS status
FROM employees;

-- COALESCE: first non-null in a list
SELECT COALESCE(NULL, NULL, 'Third', 'Fourth') FROM DUAL;  -- Third

-- NULLIF: return NULL if equal
SELECT NULLIF(salary, 0) FROM employees;
```

---

[← Previous: Operators](./05_operators.md) | [Back to README](./README.md) | [Next: Joins →](./07_joins.md)
