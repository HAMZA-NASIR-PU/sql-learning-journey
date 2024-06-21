# sql-learning-journey

## CRM System - Update Customer Information Based on Recent Orders

### Overview

In this example, we demonstrate how to update the `last_order_date` in the `customers` table to reflect the most recent order date from the `orders` table in a Customer Relationship Management (CRM) system.

### Tables

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
