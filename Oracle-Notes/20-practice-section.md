# 20. Practice Section & Sample Exam

## Table of Contents
- [20.1 MCQs (All Topics)](#201-mcqs-all-topics)
- [20.2 Short Answer Questions](#202-short-answer-questions)
- [20.3 SQL Practice Problems](#203-sql-practice-problems)
- [20.4 Output Prediction](#204-output-prediction)
- [20.5 Real-World Problems](#205-real-world-problems)
- [20.6 Sample Exam Paper](#206-sample-exam-paper)
- [20.7 Answer Key](#207-answer-key)

---

## 20.1 MCQs (All Topics)

### Database Basics

**Q1.** Oracle stores data in:
- A) Flat files
- B) Tablespaces and datafiles
- C) CSV files
- D) JSON documents

**Q2.** SGA stands for:
- A) System Global Area
- B) Server General Architecture
- C) Stored Global Array
- D) SQL Generated Area

---

### SQL Fundamentals

**Q3.** Which clause filters groups?
- A) WHERE
- B) GROUP BY
- C) HAVING
- D) ORDER BY

**Q4.** DISTINCT applies to:
- A) One column only
- B) The entire row combination
- C) Numeric columns only
- D) The first column

---

### Operators

**Q5.** `SELECT * FROM emp WHERE salary BETWEEN 30000 AND 50000` includes:
- A) Only values > 30000 and < 50000
- B) Values >= 30000 and <= 50000
- C) Only value = 30000 or 50000
- D) NULL values

**Q6.** `LIKE 'A__'` matches:
- A) Any string starting with A
- B) A followed by exactly 2 characters
- C) A followed by any number of characters
- D) Only 'A'

---

### Functions

**Q7.** `SELECT SUBSTR('ORACLE', 3, 2) FROM DUAL` returns:
- A) 'OR'
- B) 'AC'
- C) 'RA'
- D) 'CL'

**Q8.** `NVL(NULL, 'default')` returns:
- A) NULL
- B) 'default'
- C) Error
- D) 0

---

### Joins

**Q9.** A LEFT JOIN returns:
- A) Only matching rows
- B) All rows from left + matching from right
- C) All rows from right + matching from left
- D) All rows from both

**Q10.** A CROSS JOIN between 5 rows and 3 rows produces:
- A) 5 rows
- B) 8 rows
- C) 15 rows
- D) 3 rows

---

### Subqueries

**Q11.** A correlated subquery:
- A) Runs once for the entire outer query
- B) Runs once for each row of the outer query
- C) Cannot reference outer query columns
- D) Always uses IN operator

---

### Constraints

**Q12.** A table can have how many PRIMARY KEY constraints?
- A) Unlimited
- B) One
- C) Two
- D) Same as number of columns

**Q13.** ON DELETE CASCADE means:
- A) Child rows are set to NULL
- B) Parent deletion is blocked
- C) Child rows are automatically deleted
- D) Child rows are updated

---

### DDL

**Q14.** TRUNCATE vs DELETE:
- A) TRUNCATE can be rolled back
- B) DELETE is faster for large tables
- C) TRUNCATE cannot have WHERE clause
- D) DELETE is DDL

---

### Views & Indexes

**Q15.** A view with GROUP BY:
- A) Can be updated with INSERT
- B) Cannot be updated (read-only)
- C) Automatically creates an index
- D) Must have HAVING clause

**Q16.** Bitmap indexes are best for:
- A) High cardinality columns
- B) Low cardinality columns (few distinct values)
- C) Primary key columns
- D) VARCHAR2 columns

---

### PL/SQL

**Q17.** In PL/SQL, `:=` is:
- A) Comparison operator
- B) Assignment operator
- C) Equality check
- D) Not equal

**Q18.** Which is NOT a predefined exception?
- A) NO_DATA_FOUND
- B) TOO_MANY_ROWS
- C) TABLE_NOT_FOUND
- D) ZERO_DIVIDE

---

### Transactions

**Q19.** DDL statements in Oracle:
- A) Can be rolled back
- B) Cause implicit COMMIT
- C) Need explicit COMMIT
- D) Are part of the current transaction

**Q20.** In Oracle, readers:
- A) Always block writers
- B) Never block writers
- C) Block writers in SERIALIZABLE mode
- D) Block writers on indexed columns

---

## 20.2 Short Answer Questions

1. What is the difference between `TRUNCATE` and `DELETE`?
2. Explain `%TYPE` and `%ROWTYPE` in PL/SQL.
3. What are the ACID properties?
4. When would you use a SELF JOIN?
5. What is the difference between `HAVING` and `WHERE`?
6. Explain the difference between a procedure and a function.
7. What is a mutating table error?
8. Name three aggregate functions and their purpose.
9. What is normalization? Name the first three normal forms.
10. What is an implicit COMMIT?

---

## 20.3 SQL Practice Problems

### Easy

**P1.** List all customers from Mumbai, ordered by first_name.
```sql
-- Write your query here
```

**P2.** Count orders for each status.
```sql
-- Write your query here
```

**P3.** Find the maximum order amount.
```sql
-- Write your query here
```

---

### Medium

**P4.** Find customers who have placed more than 2 orders.
```sql
-- Write your query here
```

**P5.** List customers who have never placed an order.
```sql
-- Write your query here
```

**P6.** Find the second highest order amount.
```sql
-- Write your query here
```

**P7.** Show each customer's name and their total spending (including those with 0).
```sql
-- Write your query here
```

---

### Hard

**P8.** For each city, find the customer with the highest total spending.
```sql
-- Write your query here
```

**P9.** Find customers whose total spending is above the average total spending of all customers.
```sql
-- Write your query here
```

**P10.** Write a query to find consecutive orders (orders placed on the same day by any customer).
```sql
-- Write your query here
```

---

## 20.4 Output Prediction

**Predict the output of each query using the sample schema.**

**OP1:**
```sql
SELECT NVL(NULL, NVL(NULL, 'Hello')) FROM DUAL;
```

**OP2:**
```sql
SELECT COUNT(*), COUNT(NULL), COUNT('x') FROM DUAL;
```

**OP3:**
```sql
SELECT DECODE(1, 1, 'A', 2, 'B', 'C') FROM DUAL;
```

**OP4:**
```sql
DECLARE
    v_x NUMBER := 10;
BEGIN
    IF v_x > 5 THEN
        v_x := v_x * 2;
    END IF;
    IF v_x > 15 THEN
        v_x := v_x + 1;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_x);
END;
/
```

**OP5:**
```sql
SELECT SUBSTR('HELLO WORLD', -5) FROM DUAL;
```

---

## 20.5 Real-World Problems

**RW1: E-Commerce Report**
Write a query to generate a report showing:
- Customer name
- Number of orders
- Total amount spent
- Average order value
- Their most recent order date

Only include customers with at least one order. Sort by total amount descending.

---

**RW2: Monthly Sales Summary**
Write a query to show total sales per month for the current year, including months with zero sales.

---

**RW3: Customer Loyalty Procedure**
Create a stored procedure that accepts a customer_id and returns their loyalty tier:
- Platinum: > 5000 total spent
- Gold: > 2500 total spent
- Silver: > 1000 total spent
- Bronze: <= 1000 total spent

---

**RW4: Audit Trigger**
Create a trigger that logs every DELETE on the orders table, recording the order_id, amount, who deleted it, and when.

---

## 20.6 Sample Exam Paper

### Duration: 2 Hours | Total Marks: 60

---

**Section A: MCQ (10 marks — 1 mark each)**

1. Which is NOT a DDL command? (a) CREATE (b) INSERT (c) ALTER (d) DROP
2. `SELECT 10 + NULL FROM DUAL` returns: (a) 10 (b) NULL (c) 0 (d) Error
3. COMMIT is a: (a) DDL (b) DML (c) TCL (d) DCL
4. To prevent duplicate values: (a) NOT NULL (b) CHECK (c) UNIQUE (d) DEFAULT
5. `MONTHS_BETWEEN('01-MAR-24','01-JAN-24')` = (a) 1 (b) 2 (c) 3 (d) 60
6. A view is: (a) A copy of data (b) A stored query (c) An index (d) A trigger
7. Anonymous PL/SQL block starts with: (a) CREATE (b) DECLARE/BEGIN (c) DEFINE (d) PROCEDURE
8. ROLLBACK TO SAVEPOINT undoes: (a) Everything (b) Only to that savepoint (c) Nothing (d) The savepoint itself
9. Which index type for M/F gender column? (a) B-Tree (b) Bitmap (c) Unique (d) Composite
10. A function must: (a) Have OUT param (b) RETURN a value (c) Modify data (d) Accept params

---

**Section B: Short Answer (15 marks — 3 marks each)**

11. Explain the difference between `WHERE` and `HAVING` with an example.
12. What is a correlated subquery? Give an example.
13. Explain `ON DELETE CASCADE` vs `ON DELETE SET NULL`.
14. What is the purpose of `SAVEPOINT` in transactions?
15. List and explain any 3 predefined exceptions in PL/SQL.

---

**Section C: SQL Queries (20 marks — 4 marks each)**

*Use the CUSTOMERS and ORDERS schema.*

16. Find the names of customers who placed orders worth more than ₹2000.
17. Display city-wise total order amount, only for cities with total > ₹5000.
18. List all customers and their orders (include customers with no orders).
19. Find the customer(s) with the highest single order amount.
20. Create a view showing customer name, order count, and total spent.

---

**Section D: PL/SQL (15 marks — 5 marks each)**

21. Write a PL/SQL block using a cursor to print all orders for customer_id = 1 with their status.
22. Create a function `get_discount(p_amount NUMBER)` that returns:
    - 20% if amount > 5000
    - 10% if amount > 2000
    - 5% otherwise
23. Create a trigger that automatically sets `order_date` to SYSDATE and `status` to 'PENDING' when a new order is inserted (if they are NULL).

---

## 20.7 Answer Key

### MCQ Answers (Section 20.1)

| Q | Answer | Q | Answer |
|---|--------|---|--------|
| 1 | B | 11 | B |
| 2 | A | 12 | B |
| 3 | C | 13 | C |
| 4 | B | 14 | C |
| 5 | B | 15 | B |
| 6 | B | 16 | B |
| 7 | C | 17 | B |
| 8 | B | 18 | C |
| 9 | B | 19 | B |
| 10 | C | 20 | B |

---

### Output Prediction Answers

**OP1:** `Hello` (outer NVL evaluates inner NVL which returns 'Hello')

**OP2:** `1, 0, 1` (COUNT(*) counts rows, COUNT(NULL) = 0, COUNT('x') = 1)

**OP3:** `A` (DECODE matches 1=1, returns 'A')

**OP4:** `21` (10*2=20, then 20>15 so 20+1=21)

**OP5:** `WORLD` (negative position counts from the end)

---

### SQL Practice Solutions

**P1:**
```sql
SELECT * FROM customers WHERE city = 'Mumbai' ORDER BY first_name;
```

**P2:**
```sql
SELECT status, COUNT(*) AS order_count FROM orders GROUP BY status;
```

**P3:**
```sql
SELECT MAX(amount) FROM orders;
```

**P4:**
```sql
SELECT c.first_name, COUNT(o.order_id) AS cnt
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.first_name HAVING COUNT(o.order_id) > 2;
```

**P5:**
```sql
SELECT first_name FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);
-- OR
SELECT c.first_name FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

**P6:**
```sql
SELECT MAX(amount) FROM orders
WHERE amount < (SELECT MAX(amount) FROM orders);
```

**P7:**
```sql
SELECT c.first_name, NVL(SUM(o.amount), 0) AS total
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.first_name ORDER BY total DESC;
```

**P8:**
```sql
SELECT city, first_name, total FROM (
    SELECT c.city, c.first_name, SUM(o.amount) AS total,
           RANK() OVER (PARTITION BY c.city ORDER BY SUM(o.amount) DESC) AS rnk
    FROM customers c JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.city, c.first_name
) WHERE rnk = 1;
```

**P9:**
```sql
SELECT c.first_name, SUM(o.amount) AS total
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.first_name
HAVING SUM(o.amount) > (
    SELECT AVG(cust_total) FROM (
        SELECT SUM(amount) AS cust_total FROM orders GROUP BY customer_id
    )
);
```

---

### Exam Section Answers

**Section A:** 1-B, 2-B, 3-C, 4-C, 5-B, 6-B, 7-B, 8-B, 9-B, 10-B

**Section C Solutions:**

**Q16:**
```sql
SELECT DISTINCT c.first_name, c.last_name
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
WHERE o.amount > 2000;
```

**Q17:**
```sql
SELECT c.city, SUM(o.amount) AS total
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city HAVING SUM(o.amount) > 5000;
```

**Q18:**
```sql
SELECT c.first_name, o.order_id, o.amount
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id;
```

**Q19:**
```sql
SELECT c.first_name, o.amount
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
WHERE o.amount = (SELECT MAX(amount) FROM orders);
```

**Q20:**
```sql
CREATE VIEW vw_customer_summary AS
SELECT c.first_name || ' ' || c.last_name AS full_name,
       COUNT(o.order_id) AS order_count,
       NVL(SUM(o.amount), 0) AS total_spent
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.first_name, c.last_name;
```

---

**Section D Solutions:**

**Q21:**
```sql
DECLARE
    CURSOR c_orders IS
        SELECT order_id, amount, status FROM orders WHERE customer_id = 1;
BEGIN
    FOR rec IN c_orders LOOP
        DBMS_OUTPUT.PUT_LINE('Order ' || rec.order_id || 
                             ': ₹' || rec.amount || ' [' || rec.status || ']');
    END LOOP;
END;
/
```

**Q22:**
```sql
CREATE OR REPLACE FUNCTION get_discount(p_amount NUMBER) RETURN NUMBER AS
BEGIN
    IF p_amount > 5000 THEN RETURN p_amount * 0.20;
    ELSIF p_amount > 2000 THEN RETURN p_amount * 0.10;
    ELSE RETURN p_amount * 0.05;
    END IF;
END get_discount;
/
```

**Q23:**
```sql
CREATE OR REPLACE TRIGGER trg_set_order_defaults
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF :NEW.order_date IS NULL THEN
        :NEW.order_date := SYSDATE;
    END IF;
    IF :NEW.status IS NULL THEN
        :NEW.status := 'PENDING';
    END IF;
END;
/
```

---

> **Congratulations!** You have completed the Oracle Database Notes. Go back to [Sample Schema](sample-schema.sql) to set up the practice database.
