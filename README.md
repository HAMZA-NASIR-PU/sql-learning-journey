# sql-learning-journey

## Learning Resources
[techTFQ SQL For Beginners](https://www.youtube.com/watch?v=a-hFbr-4VQQ&list=PLavw5C92dz9Ef4E-1Zi9KfCTXS_IN8gXZ)

[Secret To Optimizing SQL Queries - Understand The SQL Execution Order](https://www.youtube.com/watch?v=BHwzDmr6d7s)

## Mastering SQL Joins: Avoiding Common Pitfalls

In SQL, understanding the nuances between different types of joins can significantly impact the results of your queries. One common misconception revolves around the distinction between LEFT JOIN and INNER JOIN, particularly when adding conditions that involve the right table. Let's delve into this issue with a practical example.

Consider two tables in a database: `orders` and `customers`. You want to retrieve all orders, even those without a matching customer, but you're only interested in `active` customers.

### The LEFT JOIN Misstep

A LEFT JOIN ensures all records from the left table (orders) are included, along with matching records from the right table (customers). However, problems arise when filtering the right table in the WHERE clause:

```sql
SELECT *
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.status = 'active'; -- Issue: This turns the LEFT JOIN into an INNER JOIN
```

Adding c.status = 'active' in the WHERE clause filters out NULL values from customers, effectively excluding orders with no matching 'active' customer. This unintended consequence alters the join's behavior from a LEFT JOIN to an INNER JOIN.

### The Solution: Proper Usage of ON Clause

To maintain the integrity of a LEFT JOIN while filtering conditions from the right table, use the ON clause instead of WHERE:

```sql
SELECT *
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id AND c.status = 'active';
```

### Conclusion

By applying conditions directly within the ON clause of a LEFT JOIN, you preserve the intended left-to-right table inclusion, ensuring all orders are retrieved while adhering to specific customer status criteria.

#### Solution 2
Use WHERE clause with the right table in the subquery

```sql
SELECT o.*
FROM orders o
LEFT JOIN (SELECT c.* FROM customers c WHERE c.status = 'active') AS active_customers ON o.customer_id = active_customers.customer_id;
```


## CRM System - Update Customer Information Based on Recent Orders

### Overview

In this example, we demonstrate how to update the `last_order_date` in the `customers` table to reflect the most recent order date from the `orders` table in a Customer Relationship Management (CRM) system.

### Tables

The CRM system consists of two tables:

#### `customers`
- `customer_id`: Unique identifier for each customer
- `name`: Name of the customer
- `email`: Email address of the customer
- `last_order_date`: Recent order date
  
### #`orders`
- `order_id`: Unique identifier for each order
- `customer_id`: Identifier for the customer who placed the order
- `order_date`: Date when the order was placed
- `total_amount`: Total amount of the order

#### Customers

| customer_id | name | email | last_order_date |
|-------------|------|-------|-----------------|
| 1           | John Doe | john@example.com | 2023-06-15     |
| 2           | Jane Smith | jane@example.com | 2023-06-20     |

#### Orders

| order_id | customer_id | order_date | total_amount |
|----------|-------------|------------|--------------|
| 101      | 1           | 2023-06-15 | 100.00       |
| 102      | 2           | 2023-06-18 | 150.00       |
| 103      | 1           | 2023-06-20 | 200.00       |
| 104      | 2           | 2023-06-22 | 300.00       |

### Goal

Update the `last_order_date` in the `customers` table to reflect the most recent order date from the `orders` table.

### SQL Update Statement

To achieve this, use the following SQL query:

```sql
UPDATE customers
JOIN (
    SELECT customer_id, MAX(order_date) AS latest_order_date
    FROM orders
    GROUP BY customer_id
) AS recent_orders ON customers.customer_id = recent_orders.customer_id
SET customers.last_order_date = recent_orders.latest_order_date;
```
### Example

Before running the update, the `customers` table looks like this:

| customer_id | name | email | last_order_date |
|-------------|------|-------|-----------------|
| 1           | John Doe | john@example.com | 2023-06-15     |
| 2           | Jane Smith | jane@example.com | 2023-06-20     |

After running the update, the `customers` table will be updated to:

| customer_id | name | email | last_order_date |
|-------------|------|-------|-----------------|
| 1           | John Doe | john@example.com | 2023-06-20     |
| 2           | Jane Smith | jane@example.com | 2023-06-22     |

### Conclusion

This query efficiently updates the `last_order_date` for each customer to reflect their most recent order, ensuring that the `customers` table always has the latest information.


## CRM System - Customer Status Update

This explains how to update the status of customers in a Customer Relationship Management (CRM) system to "VIP" if their total spending exceeds a certain amount (e.g., $10,000). The process involves using an SQL `UPDATE` query with a `JOIN` in MySQL.

### Database Structure

The CRM system consists of two tables:

#### `customers`
- `customer_id`: Unique identifier for each customer
- `name`: Name of the customer
- `email`: Email address of the customer
- `status`: Status of the customer (e.g., "VIP")

### #`orders`
- `order_id`: Unique identifier for each order
- `customer_id`: Identifier for the customer who placed the order
- `order_date`: Date when the order was placed
- `total_amount`: Total amount of the order

### Updating Customer Status

To update the status of customers to "VIP" if their total spending exceeds $10,000, you can use the following SQL query:

#### Solution 1

```sql
UPDATE customers
JOIN (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM orders
    GROUP BY customer_id
) AS customer_orders ON customers.customer_id = customer_orders.customer_id
SET customers.status = 'VIP'
WHERE customer_orders.total_spent > 10000;
```
#### Solution 2

```sql
SET SQL_SAFE_UPDATES = 0;  --Disable safe mode in mysql;
UPDATE customers
JOIN (SELECT customer_id, SUM(total_amount) AS total_spending 
     FROM orders GROUP BY customer_id HAVING SUM(total_amount) > 10000) AS spending
ON customers.customer_id = spending.customer_id
SET customers.status = 'VIP';
```
### Example

Before running the update, the `customers` table looks like this:
#### Customers

| customer_id | name | email | status |
|-------------|------|-------|-----------------|
| 1           | John Doe | john@example.com | NULL     |
| 2           | Jane Smith | jane@example.com | NULL     |

#### Orders

| order_id | customer_id | order_date | total_amount |
|----------|-------------|------------|--------------|
| 101      | 1           | 2023-06-15 | 6000.00       |
| 102      | 1           | 2023-06-18 | 5000.00       |
| 103      | 2           | 2023-06-20 | 8000.00       |

After running the update, the `customers` table will be updated to:

| customer_id | name | email | status |
|-------------|------|-------|-----------------|
| 1           | John Doe | john@example.com | VIP     |
| 2           | Jane Smith | jane@example.com | NULL     |

### Conclusion

This SQL query helps in efficiently updating customer statuses based on their spending. Modify the threshold value as per your requirements to categorize customers as "VIP" or any other status.
