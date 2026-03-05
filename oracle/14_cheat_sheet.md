# Section 14 — Oracle Command Cheat Sheet

> Quick-reference table of 100+ Oracle SQL and PL/SQL commands with syntax and purpose.

---

## 14.1 SQL Commands — Master Reference Table

### DDL Commands

| # | Command | Purpose | Quick Syntax |
|---|---------|---------|--------------|
| 1 | `CREATE TABLE` | Create a new table | `CREATE TABLE t (col type);` |
| 2 | `ALTER TABLE ... ADD` | Add a column | `ALTER TABLE t ADD col type;` |
| 3 | `ALTER TABLE ... MODIFY` | Change column type/constraint | `ALTER TABLE t MODIFY col type;` |
| 4 | `ALTER TABLE ... DROP COLUMN` | Remove a column | `ALTER TABLE t DROP COLUMN col;` |
| 5 | `ALTER TABLE ... RENAME COLUMN` | Rename a column | `ALTER TABLE t RENAME COLUMN old TO new;` |
| 6 | `DROP TABLE` | Delete a table permanently | `DROP TABLE t;` |
| 7 | `DROP TABLE ... CASCADE CONSTRAINTS` | Drop with dependent FKs | `DROP TABLE t CASCADE CONSTRAINTS;` |
| 8 | `TRUNCATE TABLE` | Remove all rows (fast, no rollback) | `TRUNCATE TABLE t;` |
| 9 | `RENAME` | Rename a table | `RENAME old TO new;` |
| 10 | `CREATE TABLE ... AS SELECT` | Create table from query (CTAS) | `CREATE TABLE t2 AS SELECT * FROM t1;` |
| 11 | `COMMENT ON TABLE` | Add metadata comment | `COMMENT ON TABLE t IS '...';` |
| 12 | `COMMENT ON COLUMN` | Add column comment | `COMMENT ON COLUMN t.col IS '...';` |

---

### DML Commands

| # | Command | Purpose | Quick Syntax |
|---|---------|---------|--------------|
| 13 | `INSERT INTO` | Insert a row | `INSERT INTO t (c1,c2) VALUES (v1,v2);` |
| 14 | `INSERT ALL` | Insert multiple rows | `INSERT ALL INTO t VALUES (...) SELECT * FROM DUAL;` |
| 15 | `INSERT ... SELECT` | Insert from another table | `INSERT INTO t SELECT * FROM t2;` |
| 16 | `UPDATE ... SET` | Update rows | `UPDATE t SET c1=v1 WHERE cond;` |
| 17 | `UPDATE ... WHERE` | Update with filter | `UPDATE t SET c=v WHERE id=1;` |
| 18 | `DELETE FROM` | Delete rows | `DELETE FROM t WHERE cond;` |
| 19 | `MERGE INTO` | Upsert (insert+update) | `MERGE INTO t USING s ON (...) WHEN MATCHED...` |

---

### Query Commands

| # | Command | Purpose | Quick Syntax |
|---|---------|---------|--------------|
| 20 | `SELECT *` | Select all columns | `SELECT * FROM t;` |
| 21 | `SELECT col` | Select specific columns | `SELECT c1, c2 FROM t;` |
| 22 | `SELECT DISTINCT` | Remove duplicates | `SELECT DISTINCT col FROM t;` |
| 23 | `WHERE` | Filter rows | `SELECT * FROM t WHERE col=val;` |
| 24 | `ORDER BY ASC` | Sort ascending | `ORDER BY col ASC;` |
| 25 | `ORDER BY DESC` | Sort descending | `ORDER BY col DESC;` |
| 26 | `GROUP BY` | Group rows | `GROUP BY col;` |
| 27 | `HAVING` | Filter groups | `HAVING COUNT(*) > 2;` |
| 28 | `ROWNUM` | Limit rows (older Oracle) | `WHERE ROWNUM <= 10;` |
| 29 | `FETCH FIRST` | Limit rows (Oracle 12c+) | `FETCH FIRST 5 ROWS ONLY;` |
| 30 | `OFFSET ... FETCH` | Pagination | `OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;` |

---

### Operators

| # | Operator | Purpose | Example |
|---|----------|---------|---------|
| 31 | `=` | Equal | `WHERE id = 10` |
| 32 | `<>` / `!=` | Not equal | `WHERE id <> 10` |
| 33 | `>` | Greater than | `WHERE sal > 50000` |
| 34 | `<` | Less than | `WHERE sal < 50000` |
| 35 | `>=` | Greater than or equal | `WHERE sal >= 50000` |
| 36 | `<=` | Less than or equal | `WHERE sal <= 50000` |
| 37 | `BETWEEN ... AND` | Range (inclusive) | `WHERE sal BETWEEN 40000 AND 60000` |
| 38 | `IN (...)` | Match any in list | `WHERE dept IN (10, 20)` |
| 39 | `NOT IN (...)` | Not match any in list | `WHERE dept NOT IN (10)` |
| 40 | `LIKE '%x%'` | Pattern match | `WHERE name LIKE 'A%'` |
| 41 | `NOT LIKE` | Pattern exclusion | `WHERE name NOT LIKE '%a'` |
| 42 | `IS NULL` | Check for NULL | `WHERE mgr IS NULL` |
| 43 | `IS NOT NULL` | Check for NOT NULL | `WHERE email IS NOT NULL` |
| 44 | `AND` | Both conditions true | `WHERE a=1 AND b=2` |
| 45 | `OR` | Either condition true | `WHERE a=1 OR b=2` |
| 46 | `NOT` | Negate condition | `WHERE NOT dept=30` |
| 47 | `\|\|` | String concatenation | `fname \|\| ' ' \|\| lname` |

---

### Joins

| # | Command | Purpose | Quick Syntax |
|---|---------|---------|--------------|
| 48 | `INNER JOIN` | Matching rows only | `FROM a JOIN b ON a.id=b.id` |
| 49 | `LEFT JOIN` | All from left + matches | `FROM a LEFT JOIN b ON a.id=b.id` |
| 50 | `RIGHT JOIN` | All from right + matches | `FROM a RIGHT JOIN b ON a.id=b.id` |
| 51 | `FULL OUTER JOIN` | All rows from both | `FROM a FULL OUTER JOIN b ON a.id=b.id` |
| 52 | `CROSS JOIN` | Cartesian product | `FROM a CROSS JOIN b` |
| 53 | `SELF JOIN` | Table joined to itself | `FROM emp e JOIN emp m ON e.mgr=m.id` |

---

### Subqueries

| # | Type | Purpose | Example |
|---|------|---------|---------|
| 54 | Single-row subquery | Returns 1 value | `WHERE sal > (SELECT AVG(sal) FROM t)` |
| 55 | Multi-row IN subquery | Returns multiple values | `WHERE id IN (SELECT id FROM t2)` |
| 56 | EXISTS subquery | Checks for existence | `WHERE EXISTS (SELECT 1 FROM t2 WHERE ...)` |
| 57 | NOT EXISTS | Checks for non-existence | `WHERE NOT EXISTS (SELECT 1 FROM t2 WHERE ...)` |
| 58 | ANY subquery | True if any match | `WHERE sal > ANY (SELECT sal FROM t2)` |
| 59 | ALL subquery | True if all match | `WHERE sal > ALL (SELECT sal FROM t2)` |
| 60 | Correlated subquery | References outer query | `WHERE sal > (SELECT AVG(sal) FROM t WHERE dept=e.dept)` |
| 61 | Inline view | Subquery in FROM | `FROM (SELECT * FROM t WHERE ...) sub` |
| 62 | Scalar subquery | Single value in SELECT | `SELECT (SELECT dept_name FROM d WHERE d.id=e.dept) FROM e` |
| 63 | WITH clause (CTE) | Named temp result | `WITH cte AS (SELECT ...) SELECT * FROM cte` |

---

### Character Functions

| # | Function | Purpose | Example |
|---|----------|---------|---------|
| 64 | `UPPER(str)` | Convert to uppercase | `UPPER('hello')` → `HELLO` |
| 65 | `LOWER(str)` | Convert to lowercase | `LOWER('HELLO')` → `hello` |
| 66 | `INITCAP(str)` | Capitalize each word | `INITCAP('hello world')` → `Hello World` |
| 67 | `SUBSTR(s,n,len)` | Extract substring | `SUBSTR('Oracle',1,3)` → `Ora` |
| 68 | `LENGTH(str)` | String length | `LENGTH('Oracle')` → `6` |
| 69 | `TRIM(str)` | Remove leading/trailing spaces | `TRIM('  hi  ')` → `hi` |
| 70 | `LTRIM(str)` | Remove leading spaces/chars | `LTRIM('  hi')` → `hi` |
| 71 | `RTRIM(str)` | Remove trailing spaces/chars | `RTRIM('hi  ')` → `hi` |
| 72 | `LPAD(s,n,c)` | Left-pad string | `LPAD('5',4,'0')` → `0005` |
| 73 | `RPAD(s,n,c)` | Right-pad string | `RPAD('Hi',6,'.')` → `Hi....` |
| 74 | `REPLACE(s,old,new)` | Replace substring | `REPLACE('cat','c','b')` → `bat` |
| 75 | `INSTR(s,sub)` | Find position of substring | `INSTR('Oracle','a')` → `3` |
| 76 | `CONCAT(s1,s2)` | Concatenate 2 strings | `CONCAT('a','b')` → `ab` |
| 77 | `TRANSLATE(s,from,to)` | Char-by-char replace | `TRANSLATE('abc','abc','xyz')` → `xyz` |

---

### Number Functions

| # | Function | Purpose | Example |
|---|----------|---------|---------|
| 78 | `ROUND(n,d)` | Round to d decimals | `ROUND(3.14159,2)` → `3.14` |
| 79 | `TRUNC(n,d)` | Truncate to d decimals | `TRUNC(3.99,0)` → `3` |
| 80 | `CEIL(n)` | Round up to integer | `CEIL(3.1)` → `4` |
| 81 | `FLOOR(n)` | Round down to integer | `FLOOR(3.9)` → `3` |
| 82 | `MOD(n,d)` | Modulus (remainder) | `MOD(10,3)` → `1` |
| 83 | `ABS(n)` | Absolute value | `ABS(-5)` → `5` |
| 84 | `POWER(n,e)` | Raise to power | `POWER(2,10)` → `1024` |
| 85 | `SQRT(n)` | Square root | `SQRT(144)` → `12` |
| 86 | `SIGN(n)` | Return sign (-1,0,1) | `SIGN(-5)` → `-1` |

---

### Date Functions

| # | Function | Purpose | Example |
|---|----------|---------|---------|
| 87 | `SYSDATE` | Current date & time | `SELECT SYSDATE FROM DUAL` |
| 88 | `SYSTIMESTAMP` | Current timestamp with TZ | `SELECT SYSTIMESTAMP FROM DUAL` |
| 89 | `ADD_MONTHS(d,n)` | Add months to date | `ADD_MONTHS(SYSDATE, 3)` |
| 90 | `MONTHS_BETWEEN(d1,d2)` | Months between dates | `MONTHS_BETWEEN(SYSDATE, hire_date)` |
| 91 | `NEXT_DAY(d,day)` | Next occurrence of weekday | `NEXT_DAY(SYSDATE,'MONDAY')` |
| 92 | `LAST_DAY(d)` | Last day of month | `LAST_DAY(SYSDATE)` |
| 93 | `TRUNC(d,'fmt')` | Truncate date | `TRUNC(SYSDATE,'MM')` → 1st of month |
| 94 | `EXTRACT(part FROM d)` | Extract year/month/day | `EXTRACT(YEAR FROM SYSDATE)` |

---

### Conversion Functions

| # | Function | Purpose | Example |
|---|----------|---------|---------|
| 95 | `TO_CHAR(n, fmt)` | Number to string | `TO_CHAR(75000,'999,999')` → `75,000` |
| 96 | `TO_CHAR(d, fmt)` | Date to string | `TO_CHAR(SYSDATE,'DD-MON-YYYY')` |
| 97 | `TO_DATE(s, fmt)` | String to date | `TO_DATE('2024-03-15','YYYY-MM-DD')` |
| 98 | `TO_NUMBER(s, fmt)` | String to number | `TO_NUMBER('1,234.56','9,999.99')` |
| 99 | `CAST(val AS type)` | Type casting | `CAST('100' AS NUMBER)` |
| 100 | `NVL(val, default)` | Replace NULL | `NVL(mgr_id, 0)` |
| 101 | `NVL2(v, ifnn, ifn)` | Value based on NULL | `NVL2(mgr, 'Yes','No')` |
| 102 | `COALESCE(v1,v2,...)` | First non-null | `COALESCE(a, b, c, 'default')` |
| 103 | `NULLIF(v1,v2)` | NULL if equal | `NULLIF(qty, 0)` |

---

### Aggregate Functions

| # | Function | Purpose | Example |
|---|----------|---------|---------|
| 104 | `COUNT(*)` | Count all rows | `SELECT COUNT(*) FROM t;` |
| 105 | `COUNT(col)` | Count non-null values | `SELECT COUNT(mgr) FROM emp;` |
| 106 | `COUNT(DISTINCT col)` | Count unique values | `SELECT COUNT(DISTINCT dept) FROM emp;` |
| 107 | `SUM(col)` | Total sum | `SELECT SUM(salary) FROM emp;` |
| 108 | `AVG(col)` | Average value | `SELECT AVG(salary) FROM emp;` |
| 109 | `MIN(col)` | Minimum value | `SELECT MIN(salary) FROM emp;` |
| 110 | `MAX(col)` | Maximum value | `SELECT MAX(salary) FROM emp;` |

---

### Constraints

| # | Constraint | Purpose | Quick Syntax |
|---|------------|---------|--------------|
| 111 | `PRIMARY KEY` | Unique row identifier | `col NUMBER PRIMARY KEY` |
| 112 | `NOT NULL` | Prevents null values | `col VARCHAR2(50) NOT NULL` |
| 113 | `UNIQUE` | All values distinct | `CONSTRAINT uq_c UNIQUE (col)` |
| 114 | `FOREIGN KEY` | References another PK | `FOREIGN KEY (col) REFERENCES t(pk)` |
| 115 | `CHECK` | Validates condition | `CHECK (salary > 0)` |
| 116 | `DEFAULT` | Default when null | `col DATE DEFAULT SYSDATE` |

---

### Database Objects

| # | Command | Purpose | Quick Syntax |
|---|---------|---------|--------------|
| 117 | `CREATE VIEW` | Create virtual table | `CREATE VIEW v AS SELECT...` |
| 118 | `DROP VIEW` | Remove view | `DROP VIEW v;` |
| 119 | `CREATE INDEX` | Speed up queries | `CREATE INDEX i ON t(col);` |
| 120 | `DROP INDEX` | Remove index | `DROP INDEX i;` |
| 121 | `CREATE SEQUENCE` | Auto-increment numbers | `CREATE SEQUENCE s START WITH 1;` |
| 122 | `seq.NEXTVAL` | Get next sequence value | `SELECT seq.NEXTVAL FROM DUAL;` |
| 123 | `seq.CURRVAL` | Get current value | `SELECT seq.CURRVAL FROM DUAL;` |
| 124 | `CREATE SYNONYM` | Alias for object | `CREATE SYNONYM s FOR schema.t;` |
| 125 | `DROP SYNONYM` | Remove synonym | `DROP SYNONYM s;` |

---

### Transaction Control

| # | Command | Purpose | Quick Syntax |
|---|---------|---------|--------------|
| 126 | `COMMIT` | Save changes permanently | `COMMIT;` |
| 127 | `ROLLBACK` | Undo all changes | `ROLLBACK;` |
| 128 | `SAVEPOINT sp` | Create rollback point | `SAVEPOINT sp1;` |
| 129 | `ROLLBACK TO sp` | Partial rollback | `ROLLBACK TO SAVEPOINT sp1;` |

---

### PL/SQL Commands

| # | Command | Purpose | Quick Syntax |
|---|---------|---------|--------------|
| 130 | `DECLARE ... BEGIN ... END` | PL/SQL block | `DECLARE v NUMBER; BEGIN ... END;` |
| 131 | `DBMS_OUTPUT.PUT_LINE` | Print to console | `DBMS_OUTPUT.PUT_LINE('text');` |
| 132 | `IF ... ELSIF ... ELSE ... END IF` | Conditional | `IF x>0 THEN ... END IF;` |
| 133 | `CASE ... WHEN ... END` | Case statement | `CASE x WHEN 1 THEN ... END;` |
| 134 | `LOOP ... EXIT WHEN ... END LOOP` | Basic loop | `LOOP ... EXIT WHEN i>10; END LOOP;` |
| 135 | `WHILE ... LOOP ... END LOOP` | While loop | `WHILE x<10 LOOP ... END LOOP;` |
| 136 | `FOR i IN 1..n LOOP ... END LOOP` | For loop | `FOR i IN 1..5 LOOP ... END LOOP;` |
| 137 | `CURSOR IS SELECT ...` | Declare cursor | `CURSOR c IS SELECT * FROM t;` |
| 138 | `OPEN cursor` | Open cursor | `OPEN c;` |
| 139 | `FETCH cursor INTO` | Get next row | `FETCH c INTO v1, v2;` |
| 140 | `CLOSE cursor` | Close cursor | `CLOSE c;` |
| 141 | `cursor%FOUND` | Row found? | `IF c%FOUND THEN ...` |
| 142 | `cursor%NOTFOUND` | No more rows? | `EXIT WHEN c%NOTFOUND;` |
| 143 | `cursor%ROWCOUNT` | Rows fetched so far | `v_count := c%ROWCOUNT;` |
| 144 | `EXCEPTION WHEN ... THEN` | Error handling | `WHEN NO_DATA_FOUND THEN ...` |
| 145 | `RAISE_APPLICATION_ERROR` | Custom error | `RAISE_APPLICATION_ERROR(-20001,'msg');` |
| 146 | `SQLCODE` | Error code | `DBMS_OUTPUT.PUT_LINE(SQLCODE);` |
| 147 | `SQLERRM` | Error message | `DBMS_OUTPUT.PUT_LINE(SQLERRM);` |
| 148 | `CREATE PROCEDURE` | Named block | `CREATE OR REPLACE PROCEDURE p AS ...` |
| 149 | `EXECUTE proc` | Run procedure | `EXEC give_raise(101, 10);` |
| 150 | `CREATE FUNCTION` | Returns value | `CREATE OR REPLACE FUNCTION f RETURN NUMBER AS ...` |
| 151 | `CREATE TRIGGER` | Auto-event handler | `CREATE OR REPLACE TRIGGER t BEFORE INSERT ON tbl ...` |
| 152 | `CREATE PACKAGE` | Group procedures/functions | `CREATE OR REPLACE PACKAGE pkg AS ...` |

---

### Admin / Utility Commands

| # | Command | Purpose | Quick Syntax |
|---|---------|---------|--------------|
| 153 | `CONNECT` | Connect to database | `CONNECT user/pass@host:port/svc;` |
| 154 | `DISCONNECT` | Disconnect session | `DISCONNECT;` |
| 155 | `SHOW USER` | Current user | `SHOW USER;` |
| 156 | `DESCRIBE` | Table/object structure | `DESC employees;` |
| 157 | `SHOW ERRORS` | PL/SQL compile errors | `SHOW ERRORS PROCEDURE p;` |
| 158 | `SET SERVEROUTPUT ON` | Enable PL/SQL output | `SET SERVEROUTPUT ON;` |
| 159 | `SET PAGESIZE` | Output page size | `SET PAGESIZE 100;` |
| 160 | `SET LINESIZE` | Output line width | `SET LINESIZE 200;` |
| 161 | `SPOOL filename` | Save output to file | `SPOOL C:\out.txt;` |
| 162 | `SPOOL OFF` | Stop spooling | `SPOOL OFF;` |
| 163 | `EXIT` | Exit SQL*Plus | `EXIT;` |
| 164 | `FLASHBACK TABLE` | Recover dropped table | `FLASHBACK TABLE t TO BEFORE DROP;` |
| 165 | `SHOW RECYCLEBIN` | View recycled objects | `SELECT * FROM RECYCLEBIN;` |

---

## 14.2 Oracle Data Types Quick Reference

| Data Type | Storage | Use Case |
|-----------|---------|----------|
| `NUMBER(p,s)` | Variable | Numeric data |
| `VARCHAR2(n)` | 1–4000 bytes | Variable-length text |
| `CHAR(n)` | Fixed n bytes | Fixed-length text |
| `DATE` | 7 bytes | Date + time (no fractions) |
| `TIMESTAMP` | 11 bytes | Date + time with fractions |
| `TIMESTAMP WITH TIME ZONE` | 13 bytes | Timestamp + timezone |
| `CLOB` | Up to 4 GB | Large text data |
| `BLOB` | Up to 4 GB | Binary data (images, files) |
| `NVARCHAR2(n)` | Variable | Unicode variable text |
| `INTERVAL YEAR TO MONTH` | 5 bytes | Year/month intervals |
| `INTERVAL DAY TO SECOND` | 11 bytes | Day/time intervals |
| `BOOLEAN` | PL/SQL only | TRUE / FALSE / NULL |

---

## 14.3 SQL*Plus Formatting Cheat Sheet

```sql
-- Basic session setup (run at start)
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET PAGESIZE 100;
SET LINESIZE 200;
SET FEEDBACK ON;
SET HEADING ON;
SET TIMING OFF;
SET VERIFY OFF;

-- Column formatting
COLUMN first_name FORMAT A20;        -- 20-char string column
COLUMN salary     FORMAT 999,999.00; -- number format
COLUMN hire_date  FORMAT A15;        -- date as string

-- Clear column formatting
CLEAR COLUMNS;
```

---

[← Previous: Admin Commands](./13_admin_commands.md) | [Back to README](./README.md) | [Next: Practice →](./15_practice.md)
