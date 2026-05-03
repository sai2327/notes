# 02. SQL Fundamentals

## Table of Contents
- [2.1 Sample Schema](#21-sample-schema)
- [2.2 SELECT Statement](#22-select-statement)
- [2.3 FROM Clause](#23-from-clause)
- [2.4 WHERE Clause](#24-where-clause)
- [2.5 ORDER BY](#25-order-by)
- [2.6 GROUP BY](#26-group-by)
- [2.7 HAVING](#27-having)
- [2.8 DISTINCT](#28-distinct)
- [2.9 Aliases](#29-aliases)
- [2.10 Practice & Assessment](#210-practice--assessment)

---

## 2.1 Sample Schema

We will use these tables throughout all examples:

```sql
-- Create CUSTOMERS table
CREATE TABLE customers (
    customer_id   NUMBER(5)    PRIMARY KEY,
    first_name    VARCHAR2(30) NOT NULL,
    last_name     VARCHAR2(30) NOT NULL,
    email         VARCHAR2(60),
    city          VARCHAR2(30),
    join_date     DATE
);

-- Create ORDERS table
CREATE TABLE orders (
    order_id      NUMBER(6)    PRIMARY KEY,
    customer_id   NUMBER(5)    REFERENCES customers(customer_id),
    order_date    DATE         DEFAULT SYSDATE,
    amount        NUMBER(10,2),
    status        VARCHAR2(20) DEFAULT 'PENDING'
);

-- Insert sample data into CUSTOMERS
INSERT INTO customers VALUES (1, 'Ravi', 'Kumar', 'ravi@email.com', 'Mumbai', TO_DATE('2023-01-15','YYYY-MM-DD'));
INSERT INTO customers VALUES (2, 'Priya', 'Sharma', 'priya@email.com', 'Delhi', TO_DATE('2023-03-20','YYYY-MM-DD'));
INSERT INTO customers VALUES (3, 'Amit', 'Patel', 'amit@email.com', 'Ahmedabad', TO_DATE('2023-05-10','YYYY-MM-DD'));
INSERT INTO customers VALUES (4, 'Sneha', 'Reddy', 'sneha@email.com', 'Hyderabad', TO_DATE('2023-07-01','YYYY-MM-DD'));
INSERT INTO customers VALUES (5, 'Vikram', 'Singh', NULL, 'Mumbai', TO_DATE('2024-01-05','YYYY-MM-DD'));

-- Insert sample data into ORDERS
INSERT INTO orders VALUES (1001, 1, TO_DATE('2024-01-10','YYYY-MM-DD'), 2500.00, 'DELIVERED');
INSERT INTO orders VALUES (1002, 1, TO_DATE('2024-02-15','YYYY-MM-DD'), 1800.50, 'DELIVERED');
INSERT INTO orders VALUES (1003, 2, TO_DATE('2024-02-20','YYYY-MM-DD'), 3200.00, 'SHIPPED');
INSERT INTO orders VALUES (1004, 3, TO_DATE('2024-03-05','YYYY-MM-DD'), 950.75, 'PENDING');
INSERT INTO orders VALUES (1005, 2, TO_DATE('2024-03-10','YYYY-MM-DD'), 4100.00, 'DELIVERED');
INSERT INTO orders VALUES (1006, 4, TO_DATE('2024-04-01','YYYY-MM-DD'), 1500.00, 'CANCELLED');
INSERT INTO orders VALUES (1007, 1, TO_DATE('2024-04-15','YYYY-MM-DD'), 750.25, 'PENDING');
INSERT INTO orders VALUES (1008, 3, TO_DATE('2024-05-01','YYYY-MM-DD'), 2200.00, 'SHIPPED');

COMMIT;
```

### Sample Data View

**CUSTOMERS:**
```
+-------------+------------+-----------+-----------------+-----------+------------+
| CUSTOMER_ID | FIRST_NAME | LAST_NAME | EMAIL           | CITY      | JOIN_DATE  |
+-------------+------------+-----------+-----------------+-----------+------------+
| 1           | Ravi       | Kumar     | ravi@email.com  | Mumbai    | 15-JAN-23  |
| 2           | Priya      | Sharma    | priya@email.com | Delhi     | 20-MAR-23  |
| 3           | Amit       | Patel     | amit@email.com  | Ahmedabad | 10-MAY-23  |
| 4           | Sneha      | Reddy     | sneha@email.com | Hyderabad | 01-JUL-23  |
| 5           | Vikram     | Singh     | NULL            | Mumbai    | 05-JAN-24  |
+-------------+------------+-----------+-----------------+-----------+------------+
```

**ORDERS:**
```
+----------+-------------+------------+---------+-----------+
| ORDER_ID | CUSTOMER_ID | ORDER_DATE | AMOUNT  | STATUS    |
+----------+-------------+------------+---------+-----------+
| 1001     | 1           | 10-JAN-24  | 2500.00 | DELIVERED |
| 1002     | 1           | 15-FEB-24  | 1800.50 | DELIVERED |
| 1003     | 2           | 20-FEB-24  | 3200.00 | SHIPPED   |
| 1004     | 3           | 05-MAR-24  | 950.75  | PENDING   |
| 1005     | 2           | 10-MAR-24  | 4100.00 | DELIVERED |
| 1006     | 4           | 01-APR-24  | 1500.00 | CANCELLED |
| 1007     | 1           | 15-APR-24  | 750.25  | PENDING   |
| 1008     | 3           | 01-MAY-24  | 2200.00 | SHIPPED   |
+----------+-------------+------------+---------+-----------+
```

---

## 2.2 SELECT Statement

### Definition
The `SELECT` statement retrieves data from one or more tables. It is the most used SQL command.

### Syntax

```sql
SELECT column1, column2, ...
FROM table_name;

-- Select ALL columns
SELECT *
FROM table_name;
```

### Examples

**Example 1: Select specific columns**
```sql
SELECT first_name, last_name, city
FROM customers;
```

**Output:**
```
+------------+-----------+-----------+
| FIRST_NAME | LAST_NAME | CITY      |
+------------+-----------+-----------+
| Ravi       | Kumar     | Mumbai    |
| Priya      | Sharma    | Delhi     |
| Amit       | Patel     | Ahmedabad |
| Sneha      | Reddy     | Hyderabad |
| Vikram     | Singh     | Mumbai    |
+------------+-----------+-----------+
```

**Example 2: Select all columns**
```sql
SELECT * FROM orders;
```
> Returns all 8 columns of all 8 rows from the orders table.

**Example 3: Expressions in SELECT**
```sql
SELECT first_name, last_name, 
       salary * 12 AS annual_salary
FROM employees;
```

### Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `ORA-00942: table or view does not exist` | Wrong table name or no permission | Check spelling; ensure table exists |
| `ORA-00904: invalid identifier` | Wrong column name | Check column names with `DESC table_name` |

### Best Practices
- Avoid `SELECT *` in production code — specify only needed columns.
- Use meaningful aliases for calculated columns.

---

## 2.3 FROM Clause

### Definition
The `FROM` clause specifies which table(s) to retrieve data from.

### Syntax

```sql
SELECT columns
FROM table_name;

-- Multiple tables
SELECT columns
FROM table1, table2;    -- Old style (implicit join)

-- With alias
SELECT columns
FROM table_name alias_name;
```

### Examples

**Example 1: Single table**
```sql
SELECT order_id, amount
FROM orders;
```

**Example 2: Table alias**
```sql
SELECT c.first_name, c.city
FROM customers c;
```
> `c` is the alias for `customers`. Useful when queries involve multiple tables.

---

## 2.4 WHERE Clause

### Definition
The `WHERE` clause filters rows based on a condition. Only rows where the condition is TRUE are included in the result.

### Syntax

```sql
SELECT columns
FROM table_name
WHERE condition;
```

### Examples

**Example 1: Simple equality**
```sql
SELECT first_name, last_name, city
FROM customers
WHERE city = 'Mumbai';
```

**Output:**
```
+------------+-----------+--------+
| FIRST_NAME | LAST_NAME | CITY   |
+------------+-----------+--------+
| Ravi       | Kumar     | Mumbai |
| Vikram     | Singh     | Mumbai |
+------------+-----------+--------+
```

**Example 2: Numeric comparison**
```sql
SELECT order_id, amount, status
FROM orders
WHERE amount > 2000;
```

**Output:**
```
+----------+---------+-----------+
| ORDER_ID | AMOUNT  | STATUS    |
+----------+---------+-----------+
| 1001     | 2500.00 | DELIVERED |
| 1003     | 3200.00 | SHIPPED   |
| 1005     | 4100.00 | DELIVERED |
| 1008     | 2200.00 | SHIPPED   |
+----------+---------+-----------+
```

**Example 3: Date comparison**
```sql
SELECT first_name, join_date
FROM customers
WHERE join_date > TO_DATE('2023-06-01', 'YYYY-MM-DD');
```

**Output:**
```
+------------+------------+
| FIRST_NAME | JOIN_DATE  |
+------------+------------+
| Sneha      | 01-JUL-23  |
| Vikram     | 05-JAN-24  |
+------------+------------+
```

**Example 4: Multiple conditions**
```sql
SELECT order_id, amount, status
FROM orders
WHERE amount > 1000 AND status = 'DELIVERED';
```

### Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| String not in quotes | `WHERE city = Mumbai` | Use `WHERE city = 'Mumbai'` |
| Wrong date format | `WHERE join_date = '2023-01-15'` | Use `TO_DATE('2023-01-15','YYYY-MM-DD')` |
| Using `=` for NULL | `WHERE email = NULL` | Use `WHERE email IS NULL` |

---

## 2.5 ORDER BY

### Definition
`ORDER BY` sorts the result set by one or more columns. By default, it sorts in **ascending** order.

### Syntax

```sql
SELECT columns
FROM table_name
WHERE condition
ORDER BY column1 [ASC|DESC], column2 [ASC|DESC];
```

### Examples

**Example 1: Ascending (default)**
```sql
SELECT first_name, city
FROM customers
ORDER BY first_name;
```

**Output:**
```
+------------+-----------+
| FIRST_NAME | CITY      |
+------------+-----------+
| Amit       | Ahmedabad |
| Priya      | Delhi     |
| Ravi       | Mumbai    |
| Sneha      | Hyderabad |
| Vikram     | Mumbai    |
+------------+-----------+
```

**Example 2: Descending**
```sql
SELECT order_id, amount
FROM orders
ORDER BY amount DESC;
```

**Output:**
```
+----------+---------+
| ORDER_ID | AMOUNT  |
+----------+---------+
| 1005     | 4100.00 |
| 1003     | 3200.00 |
| 1001     | 2500.00 |
| 1008     | 2200.00 |
| 1002     | 1800.50 |
| 1006     | 1500.00 |
| 1004     | 950.75  |
| 1007     | 750.25  |
+----------+---------+
```

**Example 3: Multiple columns**
```sql
SELECT city, first_name
FROM customers
ORDER BY city ASC, first_name DESC;
```

**Example 4: Order by column position**
```sql
SELECT first_name, city
FROM customers
ORDER BY 2;  -- sorts by 2nd column (city)
```

### Best Practices
- Always specify `ASC` or `DESC` explicitly for clarity.
- `NULL` values sort last in ascending order, first in descending.
- You can use `NULLS FIRST` or `NULLS LAST` to control NULL placement.

```sql
SELECT first_name, email
FROM customers
ORDER BY email NULLS FIRST;
```

---

## 2.6 GROUP BY

### Definition
`GROUP BY` groups rows that have the same values in specified columns. It is used with **aggregate functions** (COUNT, SUM, AVG, MIN, MAX) to perform calculations on each group.

### Syntax

```sql
SELECT column1, AGGREGATE_FUNCTION(column2)
FROM table_name
WHERE condition
GROUP BY column1;
```

### Important Rule
Every column in the `SELECT` list must either:
1. Be in the `GROUP BY` clause, OR
2. Be inside an aggregate function.

### Examples

**Example 1: Count customers per city**
```sql
SELECT city, COUNT(*) AS num_customers
FROM customers
GROUP BY city;
```

**Output:**
```
+-----------+---------------+
| CITY      | NUM_CUSTOMERS |
+-----------+---------------+
| Mumbai    | 2             |
| Delhi     | 1             |
| Ahmedabad | 1             |
| Hyderabad | 1             |
+-----------+---------------+
```

**Example 2: Total and average order amount per customer**
```sql
SELECT customer_id, 
       COUNT(*) AS total_orders,
       SUM(amount) AS total_spent,
       ROUND(AVG(amount), 2) AS avg_order
FROM orders
GROUP BY customer_id;
```

**Output:**
```
+-------------+--------------+-------------+-----------+
| CUSTOMER_ID | TOTAL_ORDERS | TOTAL_SPENT | AVG_ORDER |
+-------------+--------------+-------------+-----------+
| 1           | 3            | 5050.75     | 1683.58   |
| 2           | 2            | 7300.00     | 3650.00   |
| 3           | 2            | 3150.75     | 1575.38   |
| 4           | 1            | 1500.00     | 1500.00   |
+-------------+--------------+-------------+-----------+
```

**Example 3: Count orders per status**
```sql
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;
```

**Output:**
```
+-----------+-------------+
| STATUS    | ORDER_COUNT |
+-----------+-------------+
| DELIVERED | 3           |
| SHIPPED   | 2           |
| PENDING   | 2           |
| CANCELLED | 1           |
+-----------+-------------+
```

### Common Errors

```sql
-- ERROR: ORA-00979: not a GROUP BY expression
SELECT customer_id, first_name, COUNT(*)
FROM orders
GROUP BY customer_id;
-- first_name is neither in GROUP BY nor in an aggregate function!
```

---

## 2.7 HAVING

### Definition
`HAVING` filters **groups** created by `GROUP BY`. It is like `WHERE` but for groups.

### WHERE vs HAVING

| Aspect | WHERE | HAVING |
|--------|-------|--------|
| Filters | Individual rows | Groups |
| Used with | Any SELECT | GROUP BY |
| Aggregate functions | Cannot use | Can use |
| Execution order | Before grouping | After grouping |

### Syntax

```sql
SELECT column1, AGGREGATE_FUNCTION(column2)
FROM table_name
WHERE row_condition
GROUP BY column1
HAVING group_condition;
```

### Examples

**Example 1: Customers with more than 1 order**
```sql
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

**Output:**
```
+-------------+--------------+
| CUSTOMER_ID | TOTAL_ORDERS |
+-------------+--------------+
| 1           | 3            |
| 2           | 2            |
| 3           | 2            |
+-------------+--------------+
```

**Example 2: Cities with average order amount above 2000**
```sql
SELECT c.city, AVG(o.amount) AS avg_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING AVG(o.amount) > 2000;
```

**Example 3: Combining WHERE and HAVING**
```sql
SELECT customer_id, SUM(amount) AS total
FROM orders
WHERE status != 'CANCELLED'       -- filter rows first
GROUP BY customer_id
HAVING SUM(amount) > 3000;       -- then filter groups
```

---

## 2.8 DISTINCT

### Definition
`DISTINCT` removes duplicate rows from the result set.

### Syntax

```sql
SELECT DISTINCT column1, column2
FROM table_name;
```

### Examples

**Example 1: Unique cities**
```sql
SELECT DISTINCT city
FROM customers;
```

**Output:**
```
+-----------+
| CITY      |
+-----------+
| Mumbai    |
| Delhi     |
| Ahmedabad |
| Hyderabad |
+-----------+
```

**Example 2: Unique statuses**
```sql
SELECT DISTINCT status
FROM orders;
```

**Output:**
```
+-----------+
| STATUS    |
+-----------+
| DELIVERED |
| SHIPPED   |
| PENDING   |
| CANCELLED |
+-----------+
```

**Example 3: Count distinct values**
```sql
SELECT COUNT(DISTINCT city) AS unique_cities
FROM customers;
```

**Output:**
```
+---------------+
| UNIQUE_CITIES |
+---------------+
| 4             |
+---------------+
```

### Best Practices
- `DISTINCT` applies to the entire row, not just one column.
- Avoid using `DISTINCT` to hide a bad join that produces duplicates — fix the join instead.

---

## 2.9 Aliases

### Definition
Aliases give a temporary name to a column or table. They make output more readable and queries easier to write.

### Syntax

```sql
-- Column alias
SELECT column_name AS alias_name
FROM table_name;

-- Table alias
SELECT t.column_name
FROM table_name t;
```

### Examples

**Example 1: Column alias**
```sql
SELECT first_name AS "First Name", 
       last_name AS "Last Name",
       city AS "Customer City"
FROM customers;
```

> Use double quotes for aliases with spaces or special characters.

**Example 2: Calculated column with alias**
```sql
SELECT order_id,
       amount,
       amount * 0.18 AS gst,
       amount * 1.18 AS total_with_gst
FROM orders;
```

**Output:**
```
+----------+---------+--------+---------------+
| ORDER_ID | AMOUNT  | GST    | TOTAL_WITH_GST|
+----------+---------+--------+---------------+
| 1001     | 2500.00 | 450.00 | 2950.00       |
| 1002     | 1800.50 | 324.09 | 2124.59       |
| ...      | ...     | ...    | ...           |
+----------+---------+--------+---------------+
```

**Example 3: Table alias in joins**
```sql
SELECT c.first_name, o.order_id, o.amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;
```

### Rules
- `AS` keyword is optional: `SELECT city city_name` works but is less clear.
- Column aliases CANNOT be used in `WHERE` (use in `ORDER BY` only).

```sql
-- ERROR: alias not recognized in WHERE
SELECT amount * 1.18 AS total
FROM orders
WHERE total > 3000;  -- ORA-00904: "TOTAL": invalid identifier

-- CORRECT: repeat the expression
SELECT amount * 1.18 AS total
FROM orders
WHERE amount * 1.18 > 3000;
```

---

## 2.10 Practice & Assessment

### MCQs

**Q1.** Which clause is used to filter individual rows?
- A) HAVING
- B) GROUP BY
- C) WHERE
- D) ORDER BY

**Answer:** C) WHERE

---

**Q2.** What is the default sort order in ORDER BY?
- A) Descending
- B) Ascending
- C) Random
- D) No order

**Answer:** B) Ascending

---

**Q3.** Which of the following is TRUE about GROUP BY?
- A) Every column in SELECT must be in GROUP BY
- B) You can use WHERE to filter groups
- C) Non-aggregated columns in SELECT must appear in GROUP BY
- D) GROUP BY sorts results automatically

**Answer:** C) Non-aggregated columns in SELECT must appear in GROUP BY

---

**Q4.** `SELECT DISTINCT city, status FROM orders` removes duplicates based on:
- A) city only
- B) status only
- C) The combination of city and status
- D) Neither

**Answer:** C) The combination of city and status

---

**Q5.** Which will cause an error?
- A) `SELECT first_name AS name FROM customers WHERE first_name = 'Ravi'`
- B) `SELECT amount * 2 AS double_amt FROM orders WHERE double_amt > 1000`
- C) `SELECT city FROM customers ORDER BY city DESC`
- D) `SELECT COUNT(*) FROM orders GROUP BY status`

**Answer:** B) — You cannot use a column alias in the WHERE clause.

---

**Q6.** What is the difference between WHERE and HAVING?
- A) WHERE filters groups, HAVING filters rows
- B) WHERE filters rows before grouping, HAVING filters groups after grouping
- C) They are identical
- D) HAVING works without GROUP BY

**Answer:** B) WHERE filters rows before grouping, HAVING filters groups after grouping

---

### SQL Coding Problems

**Problem 1:** Write a query to find all customers from Mumbai who joined after January 2023.
```sql
-- Solution:
SELECT first_name, last_name, join_date
FROM customers
WHERE city = 'Mumbai' AND join_date > TO_DATE('2023-01-31','YYYY-MM-DD');
```

**Problem 2:** Write a query to find the total amount of DELIVERED orders for each customer, showing only those who spent more than 3000.
```sql
-- Solution:
SELECT customer_id, SUM(amount) AS total_delivered
FROM orders
WHERE status = 'DELIVERED'
GROUP BY customer_id
HAVING SUM(amount) > 3000;
```

**Problem 3:** Display all orders sorted by amount in descending order. Show order_id, amount, and a column showing amount with 18% GST added, labeled as "Amount with GST".
```sql
-- Solution:
SELECT order_id, 
       amount, 
       ROUND(amount * 1.18, 2) AS "Amount with GST"
FROM orders
ORDER BY amount DESC;
```

---

### Output Prediction

**P1.** Given our sample data, what does this return?
```sql
SELECT COUNT(*) FROM orders WHERE status = 'DELIVERED';
```
**Answer:** `3`

**P2.** What does this return?
```sql
SELECT DISTINCT city FROM customers ORDER BY city;
```
**Answer:**
```
Ahmedabad
Delhi
Hyderabad
Mumbai
```

**P3.** What does this return?
```sql
SELECT customer_id, MAX(amount)
FROM orders
GROUP BY customer_id
HAVING MAX(amount) > 3000;
```
**Answer:**
```
+-------------+-------------+
| CUSTOMER_ID | MAX(AMOUNT) |
+-------------+-------------+
| 2           | 4100.00     |
+-------------+-------------+
```

---

### Interview Questions

1. **What is the execution order of a SELECT statement?**
   > FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY

2. **Can we use column aliases in WHERE? Why not?**
3. **What is the difference between WHERE and HAVING?**
4. **What happens if you use GROUP BY without an aggregate function?**
5. **What is the difference between `COUNT(*)` and `COUNT(column_name)`?**
6. **How does NULL affect sorting in ORDER BY?**
7. **Can you ORDER BY a column not in the SELECT list?**
8. **What is the performance impact of SELECT * vs specific columns?**
9. **How does DISTINCT work with multiple columns?**
10. **What is the maximum number of columns in a GROUP BY clause?**

---

> **Next Topic**: [03 - Operators](03-operators.md)
