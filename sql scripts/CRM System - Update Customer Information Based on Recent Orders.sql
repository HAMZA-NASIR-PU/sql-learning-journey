DROP DATABASE IF EXISTS `crm-sql-prep`;
CREATE DATABASE `crm-sql-prep`;
USE `crm-sql-prep`;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    last_order_date DATE
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Inserting data into customers table
INSERT INTO customers (name, email, last_order_date) VALUES
('John Doe', 'john.doe@example.com', '2023-05-10'),
('Jane Smith', 'jane.smith@example.com', '2023-06-15'),
('Michael Johnson', 'michael.johnson@example.com', '2023-04-20'),
('Emily Davis', 'emily.davis@example.com', '2023-03-18');

-- Inserting data into orders table
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2023-05-10', 150.00),
(2, '2023-06-15', 200.50),
(3, '2023-04-20', 75.25),
(4, '2023-03-18', 300.75),
(1, '2023-06-01', 50.00),
(2, '2023-05-25', 100.00),
(3, '2023-06-10', 120.00);

SELECT * FROM customers;

-- Solution
SET SQL_SAFE_UPDATES = 0;  -- Disable safe mode in mysql
UPDATE customers
JOIN (
    SELECT customer_id, MAX(order_date) AS latest_order_date
    FROM orders
    GROUP BY customer_id
) AS recent_orders ON customers.customer_id = recent_orders.customer_id
SET customers.last_order_date = recent_orders.latest_order_date;

-- After Update:
-- John Doe ==> 2023-06-01
-- Jane Smith ==> 2023-06-15
-- Michael Johnson  ==> 2023-06-10
-- Emily Davis ==> 2023-03-18