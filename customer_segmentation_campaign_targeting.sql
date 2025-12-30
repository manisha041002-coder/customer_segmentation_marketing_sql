/* =====================================================
   PROJECT: Customer Segmentation & Campaign Targeting
   FOCUS: Zoho Digital Marketing (SQL + Marketing Logic)
   ===================================================== */

-- 1️⃣ Create Database
CREATE DATABASE IF NOT EXISTS ecommerce_marketing;
USE ecommerce_marketing;

-- 2️⃣ Drop tables if already exist (safe rerun)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- 3️⃣ Create Tables

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    prime_member BOOLEAN
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    payment_mode VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 4️⃣ Insert Sample Data

INSERT INTO customers VALUES
(1, 'Ravi', 'Chennai', TRUE),
(2, 'Priya', 'Bangalore', FALSE),
(3, 'Ankit', 'Hyderabad', TRUE),
(4, 'Meena', 'Coimbatore', FALSE);

INSERT INTO products VALUES
(101, 'Mobile', 15000, 100),
(102, 'Laptop', 55000, 40),
(103, 'Headphones', 2000, 200),
(104, 'Smartwatch', 5000, 80);

INSERT INTO orders VALUES
(1001, 1, '2025-09-01', 'UPI'),
(1002, 2, '2025-09-03', 'COD'),
(1003, 1, '2025-09-10', 'Credit Card'),
(1004, 3, '2025-09-12', 'UPI'),
(1005, 4, '2025-09-15', 'Debit Card');

INSERT INTO order_items VALUES
(1, 1001, 101, 1, 15000),
(2, 1001, 103, 2, 2000),
(3, 1002, 102, 1, 55000),
(4, 1003, 103, 1, 2000),
(5, 1004, 104, 1, 5000),
(6, 1004, 103, 1, 2000),
(7, 1005, 101, 1, 15000);

-- 5️⃣ Customer Purchase Summary (Behavior Analysis)

SELECT 
    c.customer_id,
    c.name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- 6️⃣ Customer Segmentation (Marketing Logic)

SELECT 
    c.customer_id,
    c.name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.price) AS total_spent,
    CASE
        WHEN SUM(oi.quantity * oi.price) >= 30000 THEN 'High Value Customer'
        WHEN COUNT(DISTINCT o.order_id) > 1 THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS customer_segment
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name;

-- 7️⃣ Campaign Targeting (Zoho Digital Marketing Focus)

SELECT 
    c.customer_id,
    c.name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.price) AS total_spent,
    CASE
        WHEN SUM(oi.quantity * oi.price) >= 30000 
            THEN 'Loyalty / Upsell Campaign'
        WHEN COUNT(DISTINCT o.order_id) > 1 
            THEN 'Retention Campaign'
        ELSE 
            'Re-engagement Campaign'
    END AS recommended_campaign
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name;

-- 8️⃣ Prime vs Non-Prime Marketing Insight

SELECT 
    c.prime_member,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.prime_member;

-- 9️⃣ Low-Stock Products (Campaign Safety Check)

SELECT *
FROM products
WHERE stock < 50;