# Section 13 — Oracle Admin Commands

> Commands used to inspect, manage, and troubleshoot Oracle database objects and sessions.

---

## 13.1 SHOW TABLES (List Tables)

Oracle does not have a `SHOW TABLES` command like MySQL. Use data dictionary views instead.

```sql
-- Tables owned by current user
SELECT table_name
FROM user_tables
ORDER BY table_name;

-- Tables with row counts
SELECT table_name, num_rows, last_analyzed
FROM user_tables
ORDER BY table_name;

-- All accessible tables (including other schemas)
SELECT owner, table_name
FROM all_tables
WHERE owner IN ('HR', 'SCOTT')
ORDER BY owner, table_name;

-- DBA-level view (requires DBA role)
SELECT owner, table_name, num_rows
FROM dba_tables
ORDER BY owner, table_name;

-- Tables matching a pattern
SELECT table_name FROM user_tables
WHERE table_name LIKE 'EMP%';
```

---

## 13.2 SHOW ERRORS

**What it does:** Displays compilation errors for the most recently compiled PL/SQL object (SQL*Plus command).

```sql
-- After a CREATE OR REPLACE PROCEDURE/FUNCTION/TRIGGER with errors:
SHOW ERRORS

-- Show errors for a specific object
SHOW ERRORS PROCEDURE give_raise
SHOW ERRORS FUNCTION  annual_salary
SHOW ERRORS TRIGGER   trg_salary_audit
SHOW ERRORS PACKAGE   emp_pkg

-- Using SQL query to view errors
SELECT line, position, text AS error_message
FROM user_errors
WHERE name = 'GIVE_RAISE'
ORDER BY line, position;

-- View all objects with errors
SELECT name, type, line, text
FROM user_errors
ORDER BY type, name, line;
```

---

## 13.3 DESCRIBE

```sql
-- Describe table structure
DESC employees;
DESCRIBE employees;

-- Describe a view
DESC emp_dept_view;

-- Describe a procedure (shows parameters)
DESC give_raise;

-- Describe a function (shows return type and parameters)
DESC annual_salary;

-- Describe a package (shows public interface)
DESC emp_pkg;
```

---

## 13.4 Data Dictionary Queries

```sql
-- ─── USER_* views: objects owned by current user ───────────────────────────

-- All columns for a table
SELECT column_name, data_type, data_length, nullable, data_default
FROM user_tab_columns
WHERE table_name = 'EMPLOYEES'
ORDER BY column_id;

-- All objects (tables, views, procedures, etc.)
SELECT object_name, object_type, status, created, last_ddl_time
FROM user_objects
ORDER BY object_type, object_name;

-- Indexes on a table
SELECT index_name, index_type, uniqueness, status
FROM user_indexes
WHERE table_name = 'EMPLOYEES';

-- Constraints
SELECT constraint_name, constraint_type, status, search_condition
FROM user_constraints
WHERE table_name = 'EMPLOYEES';

-- Stored code (procedure/function/trigger source)
SELECT line, text
FROM user_source
WHERE name = 'GIVE_RAISE' AND type = 'PROCEDURE'
ORDER BY line;

-- Sequences
SELECT sequence_name, min_value, max_value, increment_by, cycle_flag, last_number
FROM user_sequences;

-- Views
SELECT view_name, text
FROM user_views
WHERE view_name = 'EMP_SUMMARY';

-- Synonyms
SELECT synonym_name, table_owner, table_name
FROM user_synonyms;

-- Triggers
SELECT trigger_name, trigger_type, triggering_event, table_name, status
FROM user_triggers;

-- Grants received by current user
SELECT grantee, privilege, table_name, admin_option
FROM user_tab_privs;

-- ─── Session Information ─────────────────────────────────────────────────────

-- Current user
SELECT USER FROM DUAL;
SHOW USER;

-- Current date / time
SELECT SYSDATE            AS current_date,
       SYSTIMESTAMP       AS current_timestamp
FROM DUAL;

-- Active sessions (DBA privilege required)
SELECT username, sid, serial#, status, machine, program
FROM v$session
WHERE username IS NOT NULL
ORDER BY username;

-- Locks (DBA)
SELECT s.username, s.sid, s.serial#, l.type, o.object_name
FROM v$session s
JOIN v$lock    l ON s.sid = l.sid
JOIN dba_objects o ON l.id1 = o.object_id
WHERE s.username IS NOT NULL;

-- ─── Table Statistics ────────────────────────────────────────────────────────

-- Gather statistics on a table (update num_rows count)
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'EMPLOYEES');
END;
/

-- Gather stats for all user tables
BEGIN
    DBMS_STATS.GATHER_SCHEMA_STATS(USER);
END;
/
```

---

## 13.5 User and Privilege Management (DBA Commands)

```sql
-- Create a new user
CREATE USER app_user IDENTIFIED BY password123;

-- Grant connect privilege
GRANT CONNECT, RESOURCE TO app_user;

-- Grant specific privileges
GRANT SELECT, INSERT, UPDATE, DELETE ON employees TO app_user;

-- Grant all privileges on a table
GRANT ALL ON employees TO app_user;

-- Grant with admin option
GRANT SELECT ON employees TO app_user WITH GRANT OPTION;

-- Revoke privilege
REVOKE INSERT ON employees FROM app_user;

-- Drop user (CASCADE drops all their objects)
DROP USER app_user CASCADE;

-- Lock / unlock user account
ALTER USER app_user ACCOUNT LOCK;
ALTER USER app_user ACCOUNT UNLOCK;

-- Change password
ALTER USER app_user IDENTIFIED BY new_password;

-- View user accounts
SELECT username, account_status, created, expiry_date
FROM dba_users
ORDER BY username;

-- View granted roles
SELECT grantee, granted_role, admin_option
FROM dba_role_privs
WHERE grantee = 'APP_USER';
```

---

## 13.6 Schema Commands

```sql
-- View current schema
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') FROM DUAL;

-- Set current schema (without reconnecting)
ALTER SESSION SET CURRENT_SCHEMA = HR;

-- Check Oracle version
SELECT * FROM v$version;

-- Check database name
SELECT NAME, DB_UNIQUE_NAME, OPEN_MODE FROM v$database;

-- Check tablespace usage (DBA)
SELECT tablespace_name,
       ROUND(used_space * 8192 / 1024 / 1024, 2)  AS used_mb,
       ROUND(tablespace_size * 8192 / 1024 / 1024, 2) AS total_mb
FROM dba_tablespace_usage_metrics
ORDER BY used_mb DESC;
```

---

## 13.7 FLASHBACK Queries

**What it does:** Query historical data from a point in the past (uses undo data).

```sql
-- Query table as it was 1 hour ago
SELECT * FROM employees
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '1' HOUR);

-- Query by SCN (System Change Number)
SELECT current_scn FROM v$database;

SELECT * FROM employees
AS OF SCN 1234567;

-- Recover deleted rows
-- (assuming not yet committed and UNDO retention is sufficient)
INSERT INTO employees
SELECT * FROM employees AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '30' MINUTE)
WHERE emp_id = 111;

COMMIT;

-- Flashback entire table (requires FLASHBACK TABLE privilege)
FLASHBACK TABLE employees TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '1' HOUR);

-- Recover a dropped table
FLASHBACK TABLE emp_backup TO BEFORE DROP;
FLASHBACK TABLE emp_backup TO BEFORE DROP RENAME TO emp_backup_recovered;
```

---

[← Previous: PL/SQL](./12_plsql.md) | [Back to README](./README.md) | [Next: Cheat Sheet →](./14_cheat_sheet.md)
