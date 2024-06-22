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

The `WHERE` takes place after the `JOIN` is performed and it filters on the data from both tables. Whereas with `ON` conditions on the left join, the filtering only takes place on the right table.

#### Solution 2
Use WHERE clause with the right table in the subquery

```sql
SELECT o.*
FROM orders o
LEFT JOIN (SELECT c.* FROM customers c WHERE c.status = 'active') AS active_customers ON o.customer_id = active_customers.customer_id;
```

## Order of execution of a SQL Query

Consider the following sql query:

```sql
SELECT
    departments.department_name,
    COUNT(employees.employee_id) AS employee_count,
    AVG(employees.salary) AS average_salary
FROM
    employees
JOIN
    departments ON employees.department_id = departments.department_id
GROUP BY
    departments.department_name
HAVING
    COUNT(employees.employee_id) > 5
ORDER BY
    average_salary DESC;
```

1. **FROM Clause**:
   - The `FROM` clause is processed first. It determines the tables to be queried.
   - The `employees` table is identified as the primary table.

2. **JOIN Clause**:
   - Next, the `JOIN` clause is executed. 
   - The `employees` table is joined with the `departments` table on the `department_id` column.
   - This creates a combined result set that includes columns from both tables.

3. **WHERE Clause**:
   - If there were a `WHERE` clause, it would be executed next to filter rows based on specified conditions.
   - In this query, there is no `WHERE` clause.

4. **GROUP BY Clause**:
   - The `GROUP BY` clause is then executed to group rows that have the same values in specified columns.
   - Rows are grouped by `departments.department_name`.

5. **HAVING Clause**:
   - The `HAVING` clause is processed next. It filters groups created by the `GROUP BY` clause based on aggregate conditions.
   - Only groups with a count of employees greater than 5 are included in the final result.

6. **SELECT Clause**:
   - The `SELECT` clause is executed to determine which columns will appear in the result.
   - It calculates the `department_name`, `COUNT(employees.employee_id) AS employee_count`, and `AVG(employees.salary) AS average_salary`.

7. **ORDER BY Clause**:
   - The `ORDER BY` clause is executed last to sort the final result set.
   - The results are ordered by `average_salary` in descending order.
  

### Execution Steps Explained

1. **FROM**:
   - Identify `employees` table.

2. **JOIN**:
   - Combine `employees` with `departments` based on matching `department_id`.

3. **GROUP BY**:
   - Group the combined rows by `department_name`.

4. **HAVING**:
   - Filter groups to only those with more than 5 employees.

5. **SELECT**:
   - Calculate and select the required columns: department name, employee count, and average salary.

6. **ORDER BY**:
   - Sort the final results by average salary in descending order.




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
  
#### `orders`
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

#### `orders`
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

## CRM System - Updating Email Preferences Based on Customer Interactions

### Introduction

In this example, we want to update the email preferences of customers based on their recent interactions. Specifically, we'll mark a customer's email preference as 'inactive' if they haven't had an email interaction in the past year.

#### `customers`
- `customer_id`: Unique identifier for each customer
- `name`: Name of the customer
- `email`: Email address of the customer
- `email_preference`: active or inactive

#### `interactions`
- `interaction_id`: Unique identifier for each interaction
- `customer_id`: Identifier for the customer who did the interaction
- `interaction_type`: email/phone/chat
- `interaction_date`: Date on which a particular interaction taken place.

#### Solution

```sql
UPDATE customers
LEFT JOIN (SELECT customer_id, MAX(interaction_date) AS last_email_date FROM interactions
		   WHERE interaction_type='email' GROUP BY customer_id) AS email_interactions
ON customers.customer_id = email_interactions.customer_id
SET customers.email_preference='inactive'
WHERE email_interactions.last_email_date IS NULL
      OR email_interactions.last_email_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
```

### Conclusion

By using this query, we can effectively manage the email preferences of customers based on their recent interactions, ensuring that inactive customers are appropriately marked. This helps in maintaining an up-to-date and relevant email list for marketing and communication purposes.
