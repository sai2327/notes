# Section 1 — Basic Database Commands

> Commands used to connect, identify, and navigate the Oracle environment.

---

## 1.1 CONNECT

**What it does:** Connects to an Oracle database using a username, password, and service name.

### Syntax
```sql
CONNECT username/password@hostname:port/service_name
CONNECT username/password@TNS_alias
```

### Examples

```sql
-- Connect as a regular user
CONNECT hr/hr@localhost:1521/XEPDB1

-- Connect as SYSDBA (admin)
CONNECT sys/password@localhost:1521/XEPDB1 AS SYSDBA

-- Connect to local default instance (SQL*Plus only)
CONNECT scott/tiger

-- Disconnect and reconnect
DISCONNECT
CONNECT hr/hr@ORCL
```

**Expected Output:**
```
Connected.
```

---

## 1.2 SHOW USER

**What it does:** Displays the name of the currently connected user.

### Syntax
```sql
SHOW USER
```

### Examples

```sql
-- Check who is currently logged in
SHOW USER

-- In SQL*Plus / SQL Developer Script Output:
-- USER is "HR"

-- Alternative using SQL query:
SELECT USER FROM DUAL;

-- Get full session info:
SELECT SYS_CONTEXT('USERENV', 'SESSION_USER') AS current_user,
       SYS_CONTEXT('USERENV', 'DB_NAME')      AS database_name,
       SYS_CONTEXT('USERENV', 'HOST')         AS host_machine
FROM DUAL;
```

**Expected Output:**
```
USER is "HR"

CURRENT_USER    DATABASE_NAME    HOST_MACHINE
------------    -------------    ------------
HR              XEPDB1           MYPC
```

---

## 1.3 DESCRIBE

**What it does:** Shows the structure (columns, data types, and nullable info) of a table, view, or procedure.

### Syntax
```sql
DESCRIBE table_name
DESC table_name        -- shorthand
```

### Examples

```sql
-- Describe the employees table
DESC employees;

-- Describe the departments table
DESCRIBE departments;

-- Describe a view
DESC emp_view;

-- Describe a stored procedure
DESC get_employee_info;
```

**Expected Output for `DESC employees`:**
```
 Name         Null?    Type
 ------------ -------- ---------------
 EMP_ID       NOT NULL NUMBER
 FIRST_NAME            VARCHAR2(50)
 LAST_NAME             VARCHAR2(50)
 DEPT_ID               NUMBER
 SALARY                NUMBER(10,2)
 HIRE_DATE             DATE
 JOB_TITLE             VARCHAR2(50)
 MANAGER_ID            NUMBER
```

---

## 1.4 HELP

**What it does:** Displays help information about SQL*Plus commands (available in SQL*Plus only).

### Syntax
```sql
HELP command_name
HELP INDEX         -- lists all help topics
```

### Examples

```sql
-- Get help on SELECT command
HELP SELECT

-- Get help on formatting
HELP COLUMN

-- See all available help topics
HELP INDEX

-- Get help on SET command
HELP SET
```

**Expected Output:**
```
SELECT
------
Retrieves data from one or more tables ...
```

---

## 1.5 EXIT / QUIT

**What it does:** Closes the current SQL*Plus session and exits to the operating system.

### Syntax
```sql
EXIT
QUIT
EXIT SUCCESS
EXIT FAILURE
EXIT n          -- exit with code n
```

### Examples

```sql
-- Normal exit
EXIT

-- Exit with success code
EXIT SUCCESS

-- Exit with failure code (for scripting)
EXIT FAILURE

-- Commit pending changes and exit
COMMIT;
EXIT

-- Rollback and exit
ROLLBACK;
EXIT
```

---

## 1.6 DUAL Table

**What it does:** Oracle's built-in single-row, single-column dummy table used for expressions and function testing.

### Syntax
```sql
SELECT expression FROM DUAL;
```

### Examples

```sql
-- Test a calculation
SELECT 100 * 12 FROM DUAL;

-- Get today's date
SELECT SYSDATE FROM DUAL;

-- Test a function
SELECT UPPER('oracle') FROM DUAL;

-- Math expression
SELECT SQRT(144) FROM DUAL;

-- String concatenation
SELECT 'Hello' || ' ' || 'World' FROM DUAL;
```

**Expected Output:**
```
100 * 12
--------
1200

SYSDATE
---------
05-MAR-26

UPPER('ORACLE')
---------------
ORACLE
```

---

## 1.7 SET Commands (SQL*Plus Formatting)

**What it does:** Controls display settings in SQL*Plus output.

### Syntax
```sql
SET option value
```

### Examples

```sql
-- Set page size (lines per page)
SET PAGESIZE 50

-- Set line width
SET LINESIZE 200

-- Show column headings
SET HEADING ON

-- Turn off row count display
SET FEEDBACK OFF

-- Enable time display for each query
SET TIMING ON

-- Show substitution variables
SET VERIFY OFF

-- Enable autocommit
SET AUTOCOMMIT ON

-- Combine multiple settings for clean output
SET PAGESIZE 100
SET LINESIZE 200
SET FEEDBACK ON
SET HEADING ON
```

---

## 1.8 SPOOL

**What it does:** Saves SQL*Plus output to a file.

### Syntax
```sql
SPOOL filename
-- ... run queries ...
SPOOL OFF
```

### Examples

```sql
-- Start saving output to a file
SPOOL C:\output\results.txt

SELECT * FROM employees;

-- Stop spooling
SPOOL OFF

-- Append to existing file
SPOOL C:\output\results.txt APPEND

SELECT * FROM departments;

SPOOL OFF
```

---

[Back to README](./README.md) | [Next: DDL Commands →](./02_ddl_commands.md)
