DROP DATABASE IF EXISTS `crm-sql-prep`;
CREATE DATABASE `crm-sql-prep`;
USE `crm-sql-prep`;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


INSERT INTO customers (customer_id, customer_name, email) VALUES
(1, 'Customer A', 'Email A'),
(2, 'Customer B', 'EmailB'),
(3, 'Customer C', 'Email C'),
(4, 'Customer D', 'Email D');


INSERT INTO orders (order_id, customer_id, product_name) VALUES
(101, 1, 'A'),  
(102, 1, 'B'),
(103, 1, 'C'),
(104, 2, 'B'),
(105, 2, 'C'),
(106, 3, 'A'),
(107, 3, 'B'),
(108, 3, 'A');

-- customer A ===> A->1, B->1, C->1
-- customer B ===> A->0, B->1, C->1
-- customer C ===> A->2, B->1, C->0
-- customer D ===> A->0, B->0, C->0

-- Get count of each product
SELECT c.customer_id, c.customer_name, 
SUM(CASE WHEN o.product_name = 'A' THEN 1 ELSE 0 END) product_a_count,
SUM(CASE WHEN o.product_name = 'B' THEN 1 ELSE 0 END) product_b_count,
SUM(CASE WHEN o.product_name = 'C' THEN 1 ELSE 0 END) product_c_count
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;



-- Solution 1
SELECT 
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(CASE WHEN o.product_name = 'A' THEN 1 ELSE 0 END), 0) AS product_A_count,
    COALESCE(SUM(CASE WHEN o.product_name = 'B' THEN 1 ELSE 0 END), 0) AS product_B_count,
    COALESCE(SUM(CASE WHEN o.product_name = 'C' THEN 1 ELSE 0 END), 0) AS product_C_count
FROM 
    customers c
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.customer_name
HAVING 
    product_A_count > 0
    AND product_B_count > 0
    AND product_C_count = 0;



-- Solution 2
SELECT customers.customer_id, customers.customer_name, customers.email,
       IFNULL(a.product_a_count, 0) AS product_a_count,
       IFNULL(b.product_b_count, 0) AS product_b_count,
       IFNULL(c.product_c_count, 0) AS product_c_count
FROM customers 
LEFT JOIN (
    SELECT customer_id, COUNT(*) AS product_a_count
    FROM orders
    WHERE product_name = 'A'
    GROUP BY customer_id
) a ON customers.customer_id = a.customer_id
LEFT JOIN (
    SELECT customer_id, COUNT(*) AS product_b_count
    FROM orders
    WHERE product_name = 'B'
    GROUP BY customer_id
) b ON customers.customer_id = b.customer_id
LEFT JOIN (
    SELECT customer_id, COUNT(*) AS product_c_count
    FROM orders
    WHERE product_name = 'C'
    GROUP BY customer_id
) c ON customers.customer_id = c.customer_id
WHERE IFNULL(a.product_a_count, 0) > 0
  AND IFNULL(b.product_b_count, 0) > 0
  AND IFNULL(c.product_c_count, 0) = 0;


-- Solution 3
SELECT c.customer_id, 
IFNULL(o.product_a_count, 0) AS product_a_count,
IFNULL(o.product_b_count, 0) AS product_b_count,
IFNULL(o.product_c_count, 0) AS product_c_count
FROM customers c
LEFT JOIN (
SELECT o1.customer_id, COUNT(CASE WHEN o1.product_name = 'A' THEN 1 ELSE NULL END) AS 'product_a_count', COUNT(CASE WHEN o1.product_name = 'B' THEN 1 ELSE NULL END) AS 'product_b_count',
COUNT(CASE WHEN o1.product_name = 'C' THEN 1 ELSE NULL END) AS 'product_c_count'
FROM orders o1
GROUP BY o1.customer_id
) AS o ON c.customer_id = o.customer_id
WHERE COALESCE(o.product_a_count, 0) <> 0 AND COALESCE(o.product_b_count, 0) <> 0 AND COALESCE(o.product_c_count, 0) = 0;
