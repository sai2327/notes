# 19. Oracle Commands Cheat Sheet

> Quick reference for all Oracle SQL and PL/SQL commands. Print-friendly.

---

## DDL (Data Definition Language)

```sql
-- CREATE TABLE
CREATE TABLE table_name (
    col1 datatype [constraints],
    col2 datatype [constraints]
);

-- CREATE TABLE from query
CREATE TABLE new_table AS SELECT * FROM old_table WHERE condition;

-- ALTER TABLE
ALTER TABLE t ADD (col datatype);
ALTER TABLE t MODIFY (col new_datatype);
ALTER TABLE t DROP COLUMN col;
ALTER TABLE t RENAME COLUMN old TO new;
ALTER TABLE t ADD CONSTRAINT name PRIMARY KEY (col);
ALTER TABLE t DROP CONSTRAINT name;

-- DROP / TRUNCATE / RENAME
DROP TABLE t [CASCADE CONSTRAINTS] [PURGE];
TRUNCATE TABLE t;
RENAME old_name TO new_name;
```

---

## DML (Data Manipulation Language)

```sql
-- INSERT
INSERT INTO t (col1, col2) VALUES (val1, val2);
INSERT INTO t SELECT * FROM other_table;
INSERT ALL
    INTO t1 VALUES (...)
    INTO t2 VALUES (...)
SELECT * FROM DUAL;

-- UPDATE
UPDATE t SET col1 = val1, col2 = val2 WHERE condition;

-- DELETE
DELETE FROM t WHERE condition;

-- MERGE (Upsert)
MERGE INTO target t USING source s ON (t.id = s.id)
WHEN MATCHED THEN UPDATE SET t.col = s.col
WHEN NOT MATCHED THEN INSERT (col1, col2) VALUES (s.col1, s.col2);
```

---

## TCL (Transaction Control)

```sql
COMMIT;                          -- Save all changes
ROLLBACK;                        -- Undo all changes
ROLLBACK TO SAVEPOINT sp_name;   -- Undo to savepoint
SAVEPOINT sp_name;               -- Mark a point
SET TRANSACTION READ ONLY;       -- Read-only transaction
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

---

## SELECT & Clauses

```sql
SELECT [DISTINCT] col1, col2, aggregate(col)
FROM table [alias]
[JOIN table2 ON condition]
WHERE condition
GROUP BY col
HAVING aggregate_condition
ORDER BY col [ASC|DESC]
FETCH FIRST n ROWS ONLY;         -- 12c+
```

---

## JOINs

```sql
-- INNER JOIN
SELECT * FROM t1 JOIN t2 ON t1.id = t2.id;

-- LEFT/RIGHT/FULL OUTER JOIN
SELECT * FROM t1 LEFT JOIN t2 ON t1.id = t2.id;

-- CROSS JOIN
SELECT * FROM t1 CROSS JOIN t2;

-- SELF JOIN
SELECT e.name, m.name AS manager FROM emp e JOIN emp m ON e.mgr_id = m.id;
```

---

## Operators

```sql
-- Comparison: =, <>, <, >, <=, >=
-- Logical: AND, OR, NOT
-- Range: BETWEEN low AND high
-- List: IN (val1, val2, val3)
-- Pattern: LIKE '%pattern%'    (_ = single char)
-- NULL: IS NULL, IS NOT NULL
```

---

## Functions

```sql
-- String
UPPER(s), LOWER(s), INITCAP(s), SUBSTR(s,start,len), LENGTH(s)
TRIM(s), LTRIM(s), RTRIM(s), LPAD(s,n,c), RPAD(s,n,c)
REPLACE(s,old,new), INSTR(s,sub), CONCAT(s1,s2), || (concat operator)

-- Number
ROUND(n,d), TRUNC(n,d), MOD(n,d), ABS(n), CEIL(n), FLOOR(n)

-- Date
SYSDATE, CURRENT_DATE, ADD_MONTHS(d,n), MONTHS_BETWEEN(d1,d2)
NEXT_DAY(d,'DAY'), LAST_DAY(d), EXTRACT(YEAR FROM d)

-- Conversion
TO_CHAR(d,'format'), TO_DATE(s,'format'), TO_NUMBER(s)
NVL(expr,default), NVL2(expr,not_null,is_null), COALESCE(e1,e2,...)
NULLIF(e1,e2), DECODE(expr,search1,result1,...,default)
CASE WHEN condition THEN result ELSE default END

-- Aggregate
COUNT(*), SUM(col), AVG(col), MIN(col), MAX(col)
COUNT(DISTINCT col), LISTAGG(col,',') WITHIN GROUP (ORDER BY col)
```

---

## Constraints

```sql
col datatype NOT NULL
col datatype UNIQUE
col datatype PRIMARY KEY
col datatype REFERENCES other_table(col) [ON DELETE CASCADE|SET NULL]
col datatype CHECK (condition)
col datatype DEFAULT value
```

---

## Indexes

```sql
CREATE INDEX idx ON t(col);
CREATE UNIQUE INDEX idx ON t(col);
CREATE INDEX idx ON t(col1, col2);              -- composite
CREATE BITMAP INDEX idx ON t(col);              -- for low cardinality
CREATE INDEX idx ON t(UPPER(col));              -- function-based
DROP INDEX idx;
ALTER INDEX idx REBUILD;
```

---

## Sequences

```sql
CREATE SEQUENCE seq START WITH 1 INCREMENT BY 1 NOCACHE;
seq.NEXTVAL                -- get next value
seq.CURRVAL                -- get current value
ALTER SEQUENCE seq INCREMENT BY 5;
DROP SEQUENCE seq;
```

---

## Views

```sql
CREATE [OR REPLACE] VIEW v AS SELECT ... ;
CREATE VIEW v AS SELECT ... WITH CHECK OPTION;
DROP VIEW v;
```

---

## Synonyms

```sql
CREATE [PUBLIC] SYNONYM syn FOR schema.object;
DROP [PUBLIC] SYNONYM syn;
```

---

## PL/SQL

```sql
-- Anonymous Block
DECLARE
    var datatype [:= value];
BEGIN
    statements;
EXCEPTION
    WHEN exception THEN handler;
END;
/

-- Procedure
CREATE [OR REPLACE] PROCEDURE proc (param IN|OUT|IN OUT datatype) AS
BEGIN ... END;
/

-- Function
CREATE [OR REPLACE] FUNCTION func (param datatype) RETURN datatype AS
BEGIN ... RETURN value; END;
/

-- Package
CREATE [OR REPLACE] PACKAGE pkg AS ... END;
/
CREATE [OR REPLACE] PACKAGE BODY pkg AS ... END;
/

-- Trigger
CREATE [OR REPLACE] TRIGGER trg
BEFORE|AFTER INSERT|UPDATE|DELETE ON table
[FOR EACH ROW]
BEGIN ... END;
/

-- Cursor
CURSOR c IS SELECT ...;
OPEN c; FETCH c INTO var; CLOSE c;
FOR rec IN (SELECT ...) LOOP ... END LOOP;

-- Exception
WHEN NO_DATA_FOUND THEN ...
WHEN TOO_MANY_ROWS THEN ...
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
RAISE_APPLICATION_ERROR(-20001, 'message');

-- Dynamic SQL
EXECUTE IMMEDIATE 'SQL string' [INTO var] [USING param];

-- Bulk Operations
SELECT col BULK COLLECT INTO collection FROM table;
FORALL i IN 1..n DML_statement;
```

---

## Useful System Queries

```sql
-- Current user and date
SELECT USER, SYSDATE FROM DUAL;

-- All tables owned
SELECT table_name FROM user_tables;

-- All columns in a table
DESC table_name;
SELECT column_name, data_type FROM user_tab_columns WHERE table_name = 'TABLE';

-- All constraints
SELECT constraint_name, constraint_type FROM user_constraints WHERE table_name = 'TABLE';

-- All indexes
SELECT index_name, column_name FROM user_ind_columns WHERE table_name = 'TABLE';

-- Table row count
SELECT COUNT(*) FROM table_name;

-- Session info
SELECT SID, SERIAL#, USERNAME FROM V$SESSION WHERE USERNAME IS NOT NULL;
```

---

## Data Types Quick Reference

| Type | Description | Example |
|------|-------------|---------|
| `NUMBER(p,s)` | Numeric | `NUMBER(10,2)` |
| `VARCHAR2(n)` | Variable string | `VARCHAR2(100)` |
| `CHAR(n)` | Fixed string | `CHAR(10)` |
| `DATE` | Date + time | `SYSDATE` |
| `TIMESTAMP` | Date + fractional seconds | `SYSTIMESTAMP` |
| `CLOB` | Large text (up to 4GB) | - |
| `BLOB` | Binary data (up to 4GB) | - |
| `BOOLEAN` | TRUE/FALSE (PL/SQL only) | - |

---

> **Next**: [20 - Practice Section](20-practice-section.md)
