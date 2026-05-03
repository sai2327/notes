# 14. Synonyms in Oracle SQL

## Table of Contents
- [14.1 What is a Synonym?](#141-what-is-a-synonym)
- [14.2 Creating Synonyms](#142-creating-synonyms)
- [14.3 Public vs Private Synonyms](#143-public-vs-private-synonyms)
- [14.4 Dropping Synonyms](#144-dropping-synonyms)
- [14.5 Practice & Assessment](#145-practice--assessment)

---

## 14.1 What is a Synonym?

### Definition
A **synonym** is an alternative name (alias) for a database object (table, view, sequence, procedure). It simplifies access, especially when the object belongs to another schema.

### Why Use Synonyms?
- **Simplify long names:** `hr.employee_department_mapping` → `emp_dept`
- **Hide schema name:** Users don't need to know which schema owns the object.
- **Location transparency:** If a table moves to another schema, just update the synonym.
- **Security:** Users access via synonym without knowing actual object details.

---

## 14.2 Creating Synonyms

### Syntax

```sql
CREATE [PUBLIC] SYNONYM synonym_name
FOR [schema.]object_name;
```

### Examples

```sql
-- Private synonym for a table in another schema
CREATE SYNONYM cust FOR hr.customers;
-- Now you can: SELECT * FROM cust;

-- Synonym for a sequence
CREATE SYNONYM next_id FOR hr.seq_customer_id;
-- Now: SELECT next_id.NEXTVAL FROM DUAL;

-- Synonym for a view
CREATE SYNONYM order_summary FOR reports.vw_order_summary;
```

### Using the Synonym

```sql
-- Without synonym:
SELECT * FROM hr.customers WHERE city = 'Mumbai';

-- With synonym:
SELECT * FROM cust WHERE city = 'Mumbai';
-- Same result, shorter query!
```

---

## 14.3 Public vs Private Synonyms

| Aspect | Private Synonym | Public Synonym |
|--------|----------------|----------------|
| Created by | Any user (in their schema) | DBA or privileged user |
| Visible to | Only the owner | All users in the database |
| Syntax | `CREATE SYNONYM` | `CREATE PUBLIC SYNONYM` |
| Name conflict | Schema object takes priority | Resolved last |
| Use case | Personal shortcuts | Database-wide access |

### Public Synonym Example

```sql
-- Created by DBA (needs CREATE PUBLIC SYNONYM privilege)
CREATE PUBLIC SYNONYM customers FOR hr.customers;
-- Now ALL users can: SELECT * FROM customers;
-- without needing to type hr.customers
```

### Resolution Order
When Oracle sees an object name, it looks in this order:
1. Object in user's own schema
2. Private synonym in user's schema
3. Public synonym

---

## 14.4 Dropping Synonyms

### Syntax

```sql
-- Drop private synonym
DROP SYNONYM synonym_name;

-- Drop public synonym (needs privilege)
DROP PUBLIC SYNONYM synonym_name;
```

### Example

```sql
DROP SYNONYM cust;
DROP PUBLIC SYNONYM customers;
```

### View Existing Synonyms

```sql
-- Private synonyms
SELECT synonym_name, table_owner, table_name
FROM user_synonyms;

-- All synonyms accessible to you
SELECT * FROM all_synonyms WHERE synonym_name = 'CUST';
```

---

## 14.5 Practice & Assessment

### MCQs

**Q1.** A synonym is:
- A) A copy of a table
- B) An alternative name for a database object
- C) A type of index
- D) A stored procedure

**Answer:** B) An alternative name for a database object

---

**Q2.** A PUBLIC synonym is visible to:
- A) Only the creator
- B) All users in the database
- C) Only DBAs
- D) Only the same schema

**Answer:** B) All users in the database

---

**Q3.** If a user has a table called ORDERS and there's a public synonym ORDERS pointing to another schema:
- A) The public synonym is used
- B) The user's own table is used
- C) An error occurs
- D) Both are queried

**Answer:** B) The user's own table is used (own schema takes priority)

---

### Interview Questions

1. **What is a synonym and why is it used?**
2. **What is the difference between a public and private synonym?**
3. **What is the resolution order for object names in Oracle?**
4. **Can a synonym point to an object in a remote database?**
5. **What happens if the underlying object of a synonym is dropped?**

---

> **Next Topic**: [15 - PL/SQL Programming](15-plsql-programming.md)
