# 13. Sequences in Oracle SQL

## Table of Contents
- [13.1 What is a Sequence?](#131-what-is-a-sequence)
- [13.2 Creating a Sequence](#132-creating-a-sequence)
- [13.3 Using NEXTVAL and CURRVAL](#133-using-nextval-and-currval)
- [13.4 Modifying and Dropping Sequences](#134-modifying-and-dropping-sequences)
- [13.5 Practice & Assessment](#135-practice--assessment)

---

## 13.1 What is a Sequence?

### Definition
A **sequence** is a database object that generates unique, sequential numbers automatically. It is commonly used to generate primary key values.

### Why Use Sequences?
- Guarantees unique numbers across multiple sessions.
- No manual tracking of "next ID" needed.
- Thread-safe — multiple users can call NEXTVAL simultaneously without conflicts.

---

## 13.2 Creating a Sequence

### Syntax

```sql
CREATE SEQUENCE sequence_name
    [START WITH n]
    [INCREMENT BY n]
    [MAXVALUE n | NOMAXVALUE]
    [MINVALUE n | NOMINVALUE]
    [CYCLE | NOCYCLE]
    [CACHE n | NOCACHE]
    [ORDER | NOORDER];
```

### Parameters Explained

| Parameter | Default | Description |
|-----------|---------|-------------|
| `START WITH` | 1 | First number generated |
| `INCREMENT BY` | 1 | Step between numbers |
| `MAXVALUE` | 10^27 | Largest number allowed |
| `MINVALUE` | 1 | Smallest number (for descending) |
| `CYCLE` | NOCYCLE | Restart after reaching max? |
| `CACHE` | 20 | Pre-generate numbers for speed |
| `ORDER` | NOORDER | Guarantee order in RAC |

### Examples

```sql
-- Basic sequence starting at 1
CREATE SEQUENCE seq_customer_id
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Sequence for order IDs
CREATE SEQUENCE seq_order_id
    START WITH 10000
    INCREMENT BY 1
    MAXVALUE 999999
    CACHE 20;

-- Descending sequence
CREATE SEQUENCE seq_countdown
    START WITH 100
    INCREMENT BY -1
    MINVALUE 1
    CYCLE;
```

---

## 13.3 Using NEXTVAL and CURRVAL

### NEXTVAL
Gets the **next value** from the sequence and advances it.

```sql
-- Get next value
SELECT seq_customer_id.NEXTVAL FROM DUAL;
-- First call: 100
-- Second call: 101
-- Third call: 102
```

### CURRVAL
Gets the **current value** (last NEXTVAL called in this session). You must call NEXTVAL at least once before using CURRVAL.

```sql
SELECT seq_customer_id.CURRVAL FROM DUAL;
-- Returns the last NEXTVAL value for THIS session
```

### Using in INSERT

```sql
-- Auto-generate customer_id
INSERT INTO customers (customer_id, first_name, last_name, city)
VALUES (seq_customer_id.NEXTVAL, 'Neha', 'Gupta', 'Jaipur');

INSERT INTO customers (customer_id, first_name, last_name, city)
VALUES (seq_customer_id.NEXTVAL, 'Rahul', 'Joshi', 'Pune');

-- Check what IDs were assigned
SELECT seq_customer_id.CURRVAL FROM DUAL;
```

### Using with Default (Oracle 12c+)

```sql
-- Define sequence as column default
CREATE TABLE new_orders (
    order_id    NUMBER DEFAULT seq_order_id.NEXTVAL PRIMARY KEY,
    customer_id NUMBER(5),
    amount      NUMBER(10,2)
);

-- Now just skip the ID column
INSERT INTO new_orders (customer_id, amount) VALUES (1, 500);
INSERT INTO new_orders (customer_id, amount) VALUES (2, 750);
-- order_id is automatically generated!
```

### Where NEXTVAL Can Be Used

| Allowed | Not Allowed |
|---------|-------------|
| SELECT (from DUAL or table) | SELECT with DISTINCT |
| INSERT...VALUES | Subquery in INSERT |
| UPDATE SET clause | WHERE clause |
| DEFAULT column value | VIEW queries |
| PL/SQL assignments | GROUP BY, HAVING |

### Important Notes
- NEXTVAL advances the sequence **permanently** — even if you ROLLBACK the transaction.
- Gaps are normal (from rollbacks, cache loss on restart, etc.).
- Each session has its own CURRVAL (independent).

---

## 13.4 Modifying and Dropping Sequences

### ALTER SEQUENCE

```sql
-- Change increment
ALTER SEQUENCE seq_customer_id INCREMENT BY 5;

-- Change max value
ALTER SEQUENCE seq_customer_id MAXVALUE 999999;

-- Enable caching
ALTER SEQUENCE seq_customer_id CACHE 50;
```

> **Note:** You cannot change START WITH. To reset, DROP and recreate the sequence.

### DROP SEQUENCE

```sql
DROP SEQUENCE seq_customer_id;
```

### View Sequence Info

```sql
SELECT sequence_name, min_value, max_value, increment_by, last_number
FROM user_sequences;
```

---

## 13.5 Practice & Assessment

### MCQs

**Q1.** A sequence guarantees:
- A) No gaps in numbers
- B) Unique numbers
- C) Sequential order across sessions
- D) All of the above

**Answer:** B) Unique numbers (gaps can occur; order not guaranteed without ORDER)

---

**Q2.** `CURRVAL` returns:
- A) The next value
- B) The last NEXTVAL value in the current session
- C) The first value
- D) The maximum value

**Answer:** B) The last NEXTVAL value in the current session

---

**Q3.** If you ROLLBACK after using NEXTVAL:
- A) The sequence value is also rolled back
- B) The sequence value is NOT rolled back (it's consumed)
- C) An error occurs
- D) The sequence is dropped

**Answer:** B) The sequence value is NOT rolled back (gaps are created)

---

**Q4.** To reset a sequence to start from 1 again:
- A) `ALTER SEQUENCE seq RESTART`
- B) `ALTER SEQUENCE seq START WITH 1`
- C) Drop and recreate the sequence
- D) `RESET SEQUENCE seq`

**Answer:** C) Drop and recreate the sequence

---

### Interview Questions

1. **What is a sequence and why is it used?**
2. **What is the difference between NEXTVAL and CURRVAL?**
3. **Can a sequence guarantee no gaps? Why not?**
4. **What does CACHE do in a sequence?**
5. **Can you use a sequence in a WHERE clause?**
6. **What happens to the sequence if you ROLLBACK a transaction?**
7. **How do you use a sequence as a default column value?**
8. **What is the difference between a sequence and an identity column?**
9. **Can two tables share the same sequence?**
10. **What is CYCLE in a sequence?**

---

> **Next Topic**: [14 - Synonyms](14-synonyms.md)
