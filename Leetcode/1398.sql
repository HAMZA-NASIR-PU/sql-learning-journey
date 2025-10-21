CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Daniel'),
(2, 'Diana'),
(3, 'Elizabeth'),
(4, 'Jhon');

INSERT INTO Orders (order_id, customer_id, product_name) VALUES
(10, 1, 'A'),
(20, 1, 'B'),
(30, 1, 'D'),
(40, 1, 'C'),
(50, 2, 'A'),
(60, 3, 'A'),
(70, 3, 'B'),
(80, 3, 'D'),
(90, 4, 'C');

-- Approach
SELECT product_name = 'A'
FROM Orders;

SELECT product_name = 'B'
FROM Orders;

SELECT product_name = 'C'
FROM Orders;


-- Solution 1.

WITH cte AS
(
  SELECT customer_id FROM Orders
  GROUP BY customer_id
  HAVING SUM(product_name = 'A') > 0 AND SUM(product_name = 'B') > 0 AND SUM(product_name = 'C')
);

SELECT * FROM Customers
WHERE customer_id IN (SELECT customer_id FROM cte);


-- Solution 2

SELECT 
    c.customer_id,
    c.customer_name
FROM 
    Customers c
JOIN 
    Orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.customer_name
HAVING 
    SUM(o.product_name = 'A') > 0
    AND SUM(o.product_name = 'B') > 0
    AND SUM(o.product_name = 'C') = 0
ORDER BY 
    c.customer_id;

