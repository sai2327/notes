# 03. Operators in Oracle SQL

## Table of Contents
- [3.1 Arithmetic Operators](#31-arithmetic-operators)
- [3.2 Comparison Operators](#32-comparison-operators)
- [3.3 Logical Operators](#33-logical-operators)
- [3.4 BETWEEN Operator](#34-between-operator)
- [3.5 IN Operator](#35-in-operator)
- [3.6 LIKE Operator](#36-like-operator)
- [3.7 IS NULL Operator](#37-is-null-operator)
- [3.8 Practice & Assessment](#38-practice--assessment)

---

## 3.1 Arithmetic Operators

### Definition
Arithmetic operators perform mathematical calculations on numeric data.

| Operator | Description | Example |
|----------|-------------|---------|
| `+` | Addition | `salary + 500` |
| `-` | Subtraction | `price - discount` |
| `*` | Multiplication | `quantity * price` |
| `/` | Division | `total / 12` |

> **Note:** Oracle does NOT have a `%` modulo operator. Use the `MOD()` function instead.

### Examples

```sql
-- Example 1: Basic arithmetic in SELECT
SELECT order_id,
       amount,
       amount + 100 AS "Amount + 100",
       amount - 50  AS "Amount - 50",
       amount * 2   AS "Double Amount",
       amount / 12  AS "Monthly"
FROM orders
WHERE order_id = 1001;
```

**Output:**
```
+----------+---------+-------------+------------+---------------+---------+
| ORDER_ID | AMOUNT  | Amount + 100| Amount - 50| Double Amount | Monthly |
+----------+---------+-------------+------------+---------------+---------+
| 1001     | 2500.00 | 2600.00     | 2450.00    | 5000.00       | 208.33  |
+----------+---------+-------------+------------+---------------+---------+
```

```sql
-- Example 2: Using MOD (modulo)
SELECT MOD(10, 3) AS remainder FROM DUAL;
-- Output: 1
```

```sql
-- Example 3: Arithmetic in WHERE clause
SELECT order_id, amount
FROM orders
WHERE amount * 1.18 > 3000;
```

### Common Errors
- Division by zero gives `ORA-01476: divisor is equal to zero`.
- Arithmetic with NULL returns NULL: `5 + NULL = NULL`.

---

## 3.2 Comparison Operators

### Definition
Comparison operators compare two values and return TRUE or FALSE.

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Equal to | `city = 'Mumbai'` |
| `!=` or `<>` | Not equal to | `status != 'CANCELLED'` |
| `>` | Greater than | `amount > 2000` |
| `<` | Less than | `amount < 1000` |
| `>=` | Greater than or equal to | `amount >= 1500` |
| `<=` | Less than or equal to | `amount <= 3000` |

### Examples

```sql
-- Example 1: Equal
SELECT * FROM customers WHERE city = 'Delhi';
```

**Output:**
```
+-------------+------------+-----------+-----------------+-------+------------+
| CUSTOMER_ID | FIRST_NAME | LAST_NAME | EMAIL           | CITY  | JOIN_DATE  |
+-------------+------------+-----------+-----------------+-------+------------+
| 2           | Priya      | Sharma    | priya@email.com | Delhi | 20-MAR-23  |
+-------------+------------+-----------+-----------------+-------+------------+
```

```sql
-- Example 2: Not equal
SELECT order_id, status FROM orders
WHERE status <> 'DELIVERED';
```

**Output:**
```
+----------+-----------+
| ORDER_ID | STATUS    |
+----------+-----------+
| 1003     | SHIPPED   |
| 1004     | PENDING   |
| 1006     | CANCELLED |
| 1007     | PENDING   |
| 1008     | SHIPPED   |
+----------+-----------+
```

```sql
-- Example 3: Greater than / Less than
SELECT order_id, amount FROM orders
WHERE amount >= 1500 AND amount <= 3000;
```

### Important Notes
- String comparisons are case-sensitive in Oracle: `'Mumbai' != 'mumbai'`
- Date comparisons work naturally: `join_date > TO_DATE('2023-06-01','YYYY-MM-DD')`
- You CANNOT compare with NULL using `=` or `!=`. Use `IS NULL` / `IS NOT NULL`.

---

## 3.3 Logical Operators

### Definition
Logical operators combine multiple conditions.

| Operator | Description | Example |
|----------|-------------|---------|
| `AND` | Both conditions must be TRUE | `city = 'Mumbai' AND amount > 1000` |
| `OR` | At least one condition must be TRUE | `status = 'PENDING' OR status = 'SHIPPED'` |
| `NOT` | Reverses the condition | `NOT city = 'Delhi'` |

### Truth Tables

**AND:**
| A | B | A AND B |
|---|---|---------|
| TRUE | TRUE | TRUE |
| TRUE | FALSE | FALSE |
| FALSE | TRUE | FALSE |
| FALSE | FALSE | FALSE |

**OR:**
| A | B | A OR B |
|---|---|--------|
| TRUE | TRUE | TRUE |
| TRUE | FALSE | TRUE |
| FALSE | TRUE | TRUE |
| FALSE | FALSE | FALSE |

### Examples

```sql
-- Example 1: AND — both conditions must be true
SELECT first_name, city
FROM customers
WHERE city = 'Mumbai' AND join_date > TO_DATE('2023-12-01','YYYY-MM-DD');
```

**Output:**
```
+------------+--------+
| FIRST_NAME | CITY   |
+------------+--------+
| Vikram     | Mumbai |
+------------+--------+
```

```sql
-- Example 2: OR — at least one condition true
SELECT order_id, status
FROM orders
WHERE status = 'PENDING' OR status = 'CANCELLED';
```

**Output:**
```
+----------+-----------+
| ORDER_ID | STATUS    |
+----------+-----------+
| 1004     | PENDING   |
| 1006     | CANCELLED |
| 1007     | PENDING   |
+----------+-----------+
```

```sql
-- Example 3: NOT — reverses condition
SELECT first_name, city
FROM customers
WHERE NOT city = 'Mumbai';
```

```sql
-- Example 4: Combining AND and OR (use parentheses!)
SELECT order_id, amount, status
FROM orders
WHERE (status = 'DELIVERED' OR status = 'SHIPPED')
  AND amount > 2000;
```

### Operator Precedence
1. `NOT` (highest)
2. `AND`
3. `OR` (lowest)

> **Tip:** Always use parentheses `()` to make complex conditions clear.

---

## 3.4 BETWEEN Operator

### Definition
`BETWEEN` checks if a value is within a range (inclusive of both endpoints).

### Syntax

```sql
SELECT columns
FROM table_name
WHERE column BETWEEN low_value AND high_value;
```

This is the same as: `column >= low_value AND column <= high_value`

### Examples

```sql
-- Example 1: Numeric range
SELECT order_id, amount
FROM orders
WHERE amount BETWEEN 1000 AND 3000;
```

**Output:**
```
+----------+---------+
| ORDER_ID | AMOUNT  |
+----------+---------+
| 1001     | 2500.00 |
| 1002     | 1800.50 |
| 1006     | 1500.00 |
| 1008     | 2200.00 |
+----------+---------+
```

```sql
-- Example 2: Date range
SELECT order_id, order_date
FROM orders
WHERE order_date BETWEEN TO_DATE('2024-02-01','YYYY-MM-DD') 
                      AND TO_DATE('2024-03-31','YYYY-MM-DD');
```

**Output:**
```
+----------+------------+
| ORDER_ID | ORDER_DATE |
+----------+------------+
| 1002     | 15-FEB-24  |
| 1003     | 20-FEB-24  |
| 1004     | 05-MAR-24  |
| 1005     | 10-MAR-24  |
+----------+------------+
```

```sql
-- Example 3: NOT BETWEEN
SELECT order_id, amount
FROM orders
WHERE amount NOT BETWEEN 1000 AND 3000;
```

**Output:**
```
+----------+---------+
| ORDER_ID | AMOUNT  |
+----------+---------+
| 1003     | 3200.00 |
| 1004     | 950.75  |
| 1005     | 4100.00 |
| 1007     | 750.25  |
+----------+---------+
```

### Important Notes
- BETWEEN is **inclusive**: `BETWEEN 1000 AND 3000` includes 1000 and 3000.
- First value must be smaller: `BETWEEN 3000 AND 1000` returns no rows.
- Works with characters too: `BETWEEN 'A' AND 'M'` (alphabetical range).

---

## 3.5 IN Operator

### Definition
`IN` checks if a value matches ANY value in a list. It's a shorter way of writing multiple `OR` conditions.

### Syntax

```sql
SELECT columns
FROM table_name
WHERE column IN (value1, value2, value3);

-- With subquery
WHERE column IN (SELECT column FROM other_table);
```

### Examples

```sql
-- Example 1: List of values
SELECT first_name, city
FROM customers
WHERE city IN ('Mumbai', 'Delhi', 'Pune');
```

**Output:**
```
+------------+--------+
| FIRST_NAME | CITY   |
+------------+--------+
| Ravi       | Mumbai |
| Priya      | Delhi  |
| Vikram     | Mumbai |
+------------+--------+
```

```sql
-- Example 2: NOT IN
SELECT order_id, status
FROM orders
WHERE status NOT IN ('CANCELLED', 'PENDING');
```

**Output:**
```
+----------+-----------+
| ORDER_ID | STATUS    |
+----------+-----------+
| 1001     | DELIVERED |
| 1002     | DELIVERED |
| 1003     | SHIPPED   |
| 1005     | DELIVERED |
| 1008     | SHIPPED   |
+----------+-----------+
```

```sql
-- Example 3: IN with subquery
SELECT first_name, last_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders WHERE amount > 3000
);
```

**Output:**
```
+------------+-----------+
| FIRST_NAME | LAST_NAME |
+------------+-----------+
| Priya      | Sharma    |
+------------+-----------+
```

### Common Error with NULL
```sql
-- WARNING: NOT IN with NULL in the list returns NO rows!
SELECT * FROM customers
WHERE city NOT IN ('Mumbai', NULL);
-- Returns NOTHING because NULL comparison is unknown!
```

---

## 3.6 LIKE Operator

### Definition
`LIKE` is used for pattern matching with strings. It uses two wildcard characters:

| Wildcard | Meaning | Example |
|----------|---------|---------|
| `%` | Zero or more characters | `'R%'` matches Ravi, Ram, R |
| `_` | Exactly one character | `'_a%'` matches Ravi, Rani (2nd char = 'a') |

### Syntax

```sql
SELECT columns
FROM table_name
WHERE column LIKE 'pattern';
```

### Examples

```sql
-- Example 1: Starts with 'R'
SELECT first_name FROM customers
WHERE first_name LIKE 'R%';
```

**Output:**
```
+------------+
| FIRST_NAME |
+------------+
| Ravi       |
+------------+
```

```sql
-- Example 2: Ends with 'a'
SELECT first_name FROM customers
WHERE first_name LIKE '%a';
```

**Output:**
```
+------------+
| FIRST_NAME |
+------------+
| Priya      |
| Sneha      |
+------------+
```

```sql
-- Example 3: Contains 'am'
SELECT first_name FROM customers
WHERE first_name LIKE '%am%';
```

**Output:**
```
+------------+
| FIRST_NAME |
+------------+
| Vikram     |
+------------+
```

```sql
-- Example 4: Second character is 'r'
SELECT first_name FROM customers
WHERE first_name LIKE '_r%';
```

**Output:**
```
+------------+
| FIRST_NAME |
+------------+
| Priya      |
+------------+
```

```sql
-- Example 5: Exactly 4 characters long
SELECT first_name FROM customers
WHERE first_name LIKE '____';  -- four underscores
```

**Output:**
```
+------------+
| FIRST_NAME |
+------------+
| Ravi       |
| Amit       |
+------------+
```

```sql
-- Example 6: NOT LIKE
SELECT first_name FROM customers
WHERE first_name NOT LIKE 'A%';
```

### ESCAPE Character
If you need to search for literal `%` or `_`:

```sql
-- Find values containing literal '%'
SELECT * FROM products
WHERE description LIKE '%20\%%' ESCAPE '\';
-- Searches for '20%' in the text
```

### Important Notes
- LIKE is **case-sensitive** in Oracle. Use `UPPER()` or `LOWER()` for case-insensitive:
  ```sql
  WHERE UPPER(first_name) LIKE 'R%'
  ```
- LIKE with no wildcards behaves like `=`: `LIKE 'Ravi'` is same as `= 'Ravi'`

---

## 3.7 IS NULL Operator

### Definition
`IS NULL` checks if a column value is NULL. NULL means "unknown" or "no value" — it is NOT zero or empty string.

### Syntax

```sql
WHERE column IS NULL;
WHERE column IS NOT NULL;
```

### Why Can't We Use `= NULL`?
In Oracle, `NULL = NULL` is **unknown** (not TRUE). Any comparison with NULL using `=`, `!=`, `>`, `<` returns unknown. Only `IS NULL` correctly tests for NULL.

### Examples

```sql
-- Example 1: Find customers with no email
SELECT first_name, email
FROM customers
WHERE email IS NULL;
```

**Output:**
```
+------------+-------+
| FIRST_NAME | EMAIL |
+------------+-------+
| Vikram     | NULL  |
+------------+-------+
```

```sql
-- Example 2: Find customers who HAVE an email
SELECT first_name, email
FROM customers
WHERE email IS NOT NULL;
```

**Output:**
```
+------------+-----------------+
| FIRST_NAME | EMAIL           |
+------------+-----------------+
| Ravi       | ravi@email.com  |
| Priya      | priya@email.com |
| Amit       | amit@email.com  |
| Sneha      | sneha@email.com |
+------------+-----------------+
```

```sql
-- Example 3: Common mistake
-- WRONG: This will NOT work!
SELECT * FROM customers WHERE email = NULL;
-- Returns NO rows (even if NULLs exist)

-- CORRECT:
SELECT * FROM customers WHERE email IS NULL;
```

### NULL Behavior in Expressions

| Expression | Result |
|-----------|--------|
| `NULL + 5` | NULL |
| `NULL * 100` | NULL |
| `NULL = NULL` | Unknown (not TRUE) |
| `NULL != NULL` | Unknown (not TRUE) |
| `NULL AND TRUE` | Unknown |
| `NULL OR TRUE` | TRUE |
| `NOT NULL` | Unknown |

---

## 3.8 Practice & Assessment

### MCQs

**Q1.** What does Oracle use instead of the `%` modulo operator?
- A) `MODULO()` function
- B) `MOD()` function
- C) `REMAINDER()` function
- D) The `%` operator works in Oracle

**Answer:** B) `MOD()` function

---

**Q2.** Which operator checks if a value is within a range (inclusive)?
- A) IN
- B) LIKE
- C) BETWEEN
- D) EXISTS

**Answer:** C) BETWEEN

---

**Q3.** What does `LIKE '_a%'` match?
- A) Any string starting with 'a'
- B) Any string with 'a' as the second character
- C) Any string ending with 'a'
- D) Any string containing 'a'

**Answer:** B) Any string with 'a' as the second character

---

**Q4.** What does `SELECT 5 + NULL FROM DUAL` return?
- A) 5
- B) 0
- C) NULL
- D) Error

**Answer:** C) NULL

---

**Q5.** `NOT IN` with a NULL value in the list:
- A) Ignores the NULL and works normally
- B) Returns all rows
- C) Returns no rows
- D) Throws an error

**Answer:** C) Returns no rows

---

**Q6.** Which operator has the highest precedence?
- A) OR
- B) AND
- C) NOT
- D) They are all equal

**Answer:** C) NOT

---

### SQL Coding Problems

**Problem 1:** Find all orders with amount between 1000 and 2500 that are either DELIVERED or SHIPPED.
```sql
-- Solution:
SELECT order_id, amount, status
FROM orders
WHERE amount BETWEEN 1000 AND 2500
  AND status IN ('DELIVERED', 'SHIPPED');
```

**Problem 2:** Find all customers whose last name starts with 'S' or 'P'.
```sql
-- Solution:
SELECT first_name, last_name
FROM customers
WHERE last_name LIKE 'S%' OR last_name LIKE 'P%';
```

**Problem 3:** Find all customers whose email is not null and who are from cities that contain the letter 'a' (case insensitive).
```sql
-- Solution:
SELECT first_name, city, email
FROM customers
WHERE email IS NOT NULL
  AND UPPER(city) LIKE '%A%';
```

---

### Output Prediction

**P1.**
```sql
SELECT * FROM customers WHERE city NOT IN ('Mumbai', 'Delhi');
```
**Answer:** Returns Amit (Ahmedabad) and Sneha (Hyderabad) — 2 rows.

**P2.**
```sql
SELECT COUNT(*) FROM orders WHERE amount BETWEEN 1000 AND 2000;
```
**Answer:** `3` (orders 1002=1800.50, 1006=1500.00, and... wait: 1002=1800.50, 1006=1500.00 — checking: 1001=2500 no, 1002=1800.50 yes, 1003=3200 no, 1004=950.75 no, 1005=4100 no, 1006=1500 yes, 1007=750.25 no, 1008=2200 no → **2**)

**P3.**
```sql
SELECT first_name FROM customers WHERE first_name LIKE '%i%';
```
**Answer:** `Ravi`, `Priya`, `Amit`, `Vikram` (all contain 'i')

---

### Interview Questions

1. **What is the difference between `=` and `LIKE`?**
2. **Why can't we use `= NULL` in Oracle?**
3. **What happens when you do arithmetic with NULL?**
4. **Explain the difference between `IN` and `BETWEEN`.**
5. **What is operator precedence for AND, OR, NOT?**
6. **How do you perform a case-insensitive LIKE search?**
7. **What is the ESCAPE clause in LIKE?**
8. **What is the problem with `NOT IN` when NULLs are present?**
9. **What is the difference between `!=` and `<>`?**
10. **How does `BETWEEN` work with dates?**

---

> **Next Topic**: [04 - Functions](04-functions.md)
