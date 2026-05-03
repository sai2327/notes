-- ============================================================
-- ORACLE DATABASE SAMPLE SCHEMA
-- Used throughout the Oracle Notes (Topics 01-20)
-- ============================================================
-- Run this script to set up the practice database.
-- Compatible with Oracle 12c and above.
-- ============================================================

-- ========================
-- DROP EXISTING OBJECTS
-- ========================
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE orders CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customers CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_customer_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_order_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- ========================
-- CREATE SEQUENCES
-- ========================
CREATE SEQUENCE seq_customer_id START WITH 100 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_order_id START WITH 2000 INCREMENT BY 1 NOCACHE;

-- ========================
-- CREATE CUSTOMERS TABLE
-- ========================
CREATE TABLE customers (
    customer_id   NUMBER        PRIMARY KEY,
    first_name    VARCHAR2(50)  NOT NULL,
    last_name     VARCHAR2(50)  NOT NULL,
    email         VARCHAR2(100) UNIQUE,
    city          VARCHAR2(50),
    join_date     DATE          DEFAULT SYSDATE
);

-- ========================
-- CREATE ORDERS TABLE
-- ========================
CREATE TABLE orders (
    order_id      NUMBER        PRIMARY KEY,
    customer_id   NUMBER        NOT NULL,
    order_date    DATE          DEFAULT SYSDATE,
    amount        NUMBER(10,2)  NOT NULL CHECK (amount > 0),
    status        VARCHAR2(20)  DEFAULT 'PENDING' 
                                CHECK (status IN ('PENDING','SHIPPED','DELIVERED','CANCELLED')),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

-- ========================
-- CREATE INDEXES
-- ========================
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_customers_city ON customers(city);

-- ========================
-- INSERT CUSTOMERS
-- ========================
INSERT INTO customers (customer_id, first_name, last_name, email, city, join_date)
VALUES (1, 'Ravi', 'Kumar', 'ravi.kumar@email.com', 'Mumbai', TO_DATE('2023-01-15','YYYY-MM-DD'));

INSERT INTO customers (customer_id, first_name, last_name, email, city, join_date)
VALUES (2, 'Priya', 'Sharma', 'priya.sharma@email.com', 'Delhi', TO_DATE('2023-03-22','YYYY-MM-DD'));

INSERT INTO customers (customer_id, first_name, last_name, email, city, join_date)
VALUES (3, 'Amit', 'Patel', 'amit.patel@email.com', 'Ahmedabad', TO_DATE('2023-05-10','YYYY-MM-DD'));

INSERT INTO customers (customer_id, first_name, last_name, email, city, join_date)
VALUES (4, 'Sneha', 'Reddy', 'sneha.reddy@email.com', 'Hyderabad', TO_DATE('2023-07-01','YYYY-MM-DD'));

INSERT INTO customers (customer_id, first_name, last_name, email, city, join_date)
VALUES (5, 'Vikram', 'Singh', 'vikram.singh@email.com', 'Mumbai', TO_DATE('2023-09-18','YYYY-MM-DD'));

-- ========================
-- INSERT ORDERS
-- ========================
INSERT INTO orders (order_id, customer_id, order_date, amount, status)
VALUES (1001, 1, TO_DATE('2024-01-05','YYYY-MM-DD'), 2500.00, 'DELIVERED');

INSERT INTO orders (order_id, customer_id, order_date, amount, status)
VALUES (1002, 1, TO_DATE('2024-02-14','YYYY-MM-DD'), 1800.50, 'DELIVERED');

INSERT INTO orders (order_id, customer_id, order_date, amount, status)
VALUES (1003, 2, TO_DATE('2024-01-20','YYYY-MM-DD'), 3200.00, 'SHIPPED');

INSERT INTO orders (order_id, customer_id, order_date, amount, status)
VALUES (1004, 2, TO_DATE('2024-03-01','YYYY-MM-DD'), 950.75, 'PENDING');

INSERT INTO orders (order_id, customer_id, order_date, amount, status)
VALUES (1005, 3, TO_DATE('2024-02-28','YYYY-MM-DD'), 4500.00, 'DELIVERED');

INSERT INTO orders (order_id, customer_id, order_date, amount, status)
VALUES (1006, 4, TO_DATE('2024-03-15','YYYY-MM-DD'), 1200.00, 'CANCELLED');

INSERT INTO orders (order_id, customer_id, order_date, amount, status)
VALUES (1007, 1, TO_DATE('2024-04-01','YYYY-MM-DD'), 750.25, 'PENDING');

INSERT INTO orders (order_id, customer_id, order_date, amount, status)
VALUES (1008, 5, TO_DATE('2024-03-20','YYYY-MM-DD'), 5600.00, 'DELIVERED');

INSERT INTO orders (order_id, customer_id, order_date, amount, status)
VALUES (1009, 3, TO_DATE('2024-04-10','YYYY-MM-DD'), 890.00, 'SHIPPED');

INSERT INTO orders (order_id, customer_id, order_date, amount, status)
VALUES (1010, 5, TO_DATE('2024-04-15','YYYY-MM-DD'), 3100.50, 'PENDING');

-- ========================
-- COMMIT ALL DATA
-- ========================
COMMIT;

-- ========================
-- VERIFY DATA
-- ========================
SELECT 'CUSTOMERS' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'ORDERS', COUNT(*) FROM orders;

-- Expected output:
-- TABLE_NAME  ROW_COUNT
-- ----------  ---------
-- CUSTOMERS   5
-- ORDERS      10

-- ========================
-- SAMPLE QUERIES TO TEST
-- ========================

-- All customers
SELECT * FROM customers ORDER BY customer_id;

-- All orders with customer names
SELECT c.first_name, c.last_name, o.order_id, o.amount, o.status
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- Customer order summary
SELECT c.first_name, 
       COUNT(o.order_id) AS total_orders,
       NVL(SUM(o.amount), 0) AS total_spent,
       NVL(ROUND(AVG(o.amount), 2), 0) AS avg_order
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.first_name
ORDER BY total_spent DESC;

-- Expected output:
-- FIRST_NAME  TOTAL_ORDERS  TOTAL_SPENT  AVG_ORDER
-- ----------  ------------  -----------  ---------
-- Vikram      2             8700.50      4350.25
-- Amit        2             5390.00      2695.00
-- Ravi        3             5050.75      1683.58
-- Priya       2             4150.75      2075.38
-- Sneha       1             1200.00      1200.00

PROMPT Schema setup complete! You can now practice all Oracle Notes examples.
