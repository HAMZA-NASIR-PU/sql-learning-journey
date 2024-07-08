# The Ultimate SQL Question Repository

## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> Learning Resources
[techTFQ SQL For Beginners](https://www.youtube.com/watch?v=a-hFbr-4VQQ&list=PLavw5C92dz9Ef4E-1Zi9KfCTXS_IN8gXZ)

[Secret To Optimizing SQL Queries - Understand The SQL Execution Order](https://www.youtube.com/watch?v=BHwzDmr6d7s)

## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> Mastering SQL Joins: Avoiding Common Pitfalls

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

## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> Order of execution of a SQL Query

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


## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> CRM System - Find customers that bought product A and B but not C

In this example, we demonstrate how to find customers from `customers` table that bought product `A` and `B` but not `C` in a Customer Relationship Management (CRM) system.

```sql
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
(107, 3, 'B');
```

### Solution 1

```sql
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
```

### Solution 2

```sql
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
```

To show the count of each product (A, B, and C) bought by every customer, use `CASE` statement inside the `SUM` aggregate function.

```sql
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
    c.customer_id, c.customer_name;
```

## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> CRM System - Update Customer Information Based on Recent Orders

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


## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> CRM System - Customer Status Update

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

## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> CRM System - Updating Email Preferences Based on Customer Interactions

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

### Solution 1

```sql
UPDATE customers t3
LEFT JOIN (
    SELECT customer_id
    FROM interactions
    WHERE interaction_type = 'email'
      AND interaction_date > DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
) t1 ON t3.customer_id = t1.customer_id
SET t3.email_preference = CASE
    WHEN t1.customer_id IS NULL THEN 'inactive'
    ELSE 'active'
END;
```

#### Solution 2

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


## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> CRM - Customer Engagement Score Update

### Overview

In a CRM system, we want to update a customer's engagement score based on a combination of their purchase history, recent interactions, and whether they have referred new customers. The engagement score will be calculated as follows:

1. Increase the score by 10 points for every $500 spent in the last year.
2. Increase the score by 5 points for each interaction in the last 6 months.
3. Increase the score by 50 points for each referred customer who has made a purchase.

### Tables

#### `customers`
- `customer_id`: Unique identifier for each customer
- `name`: Name of the customer
- `email`: Email address of the customer
- `engagement_score`: Score indicating customer engagement

#### `orders`
- `order_id`: Unique identifier for each order
- `customer_id`: Identifier for the customer who placed the order
- `order_date`: Date when the order was placed
- `total_amount`: Total amount of the order

#### `interactions`
- `interaction_id`: Unique identifier for each interaction
- `customer_id`: Identifier for the customer who had the interaction
- `interaction_type`: Type of interaction (e.g., email, call, chat)
- `interaction_date`: Date when the interaction occurred

#### `referrals`
- `referrer_id`: Customer ID of the referrer
- `referred_id`: Customer ID of the referred customer

```sql
SET SQL_SAFE_UPDATES = 0;
UPDATE customers
LEFT JOIN (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent,
        COUNT(*) AS order_count
    FROM orders
    WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    GROUP BY customer_id
) AS recent_orders ON customers.customer_id = recent_orders.customer_id
LEFT JOIN (
    SELECT 
        customer_id,
        COUNT(*) AS recent_interactions
    FROM interactions
    WHERE interaction_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    GROUP BY customer_id
) AS recent_interactions ON customers.customer_id = recent_interactions.customer_id
LEFT JOIN (
    SELECT 
        referrer_id,
        COUNT(*) AS successful_referrals
    FROM referrals
    JOIN orders ON referrals.referred_id = orders.customer_id
    GROUP BY referrer_id
) AS successful_referrals ON customers.customer_id = successful_referrals.referrer_id
SET customers.engagement_score = 
    customers.engagement_score + 
    COALESCE(FLOOR(recent_orders.total_spent / 500) * 10, 0) + 
    COALESCE(recent_interactions.recent_interactions * 5, 0) + 
    COALESCE(successful_referrals.successful_referrals * 50, 0);

```

Using LEFT JOIN ensures that customers who haven't made any purchases, had any interactions, or referred any customers are still included in the update with default values (such as zero or NULL).

### Key Points

- Using LEFT JOIN: Ensures all customers are considered, even those without corresponding records in the joined tables.
 
- Using COALESCE: Handles NULL values by replacing them with 0 to ensure accurate calculations.

### Explanation

1. Recent Orders Subquery
   - Aggregates the total spending and counts the number of orders for each customer in the last year.

2. Recent Interactions Subquery
   - Counts the number of interactions for each customer in the last 6 months.  

3. Successful Referrals Subquery
   - Counts the number of successful referrals (referrals where the referred customer has made at least one purchase) for each referrer.

4. Main Query
   - Joins the customers table with the results of the subqueries.
   - Uses the SET clause to update the engagement_score based on:
      - 10 points for every $500 spent in the last year (FLOOR(recent_orders.total_spent / 500) * 10).
      - 5 points for each recent interaction in the last 6 months (recent_interactions.recent_interactions * 5).
      - 50 points for each successful referral (successful_referrals.successful_referrals * 50).
   - The COALESCE function is used to handle NULL values in case a customer has no orders, interactions, or referrals.

This advanced query incorporates multiple data sources and complex conditions to calculate and update the engagement score comprehensively.


## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> CRM - Customer Segmentation and Tier Update

### Overview

In this scenario, we want to update the tier of customers based on their purchase history, interaction frequency, and whether they have an active subscription. The tiers are defined as follows:

- Platinum: Customers who have spent more than $5,000 in the last year, have had more than 20 interactions in the last 6 months, and have an active subscription.
- Gold: Customers who have spent between $2,000 and $5,000 in the last year, have had more than 10 interactions in the last 6 months, or have an active subscription.
- Silver: Customers who have spent between $500 and $2,000 in the last year, or have had more than 5 interactions in the last 6 months.
- Bronze: All other customers.

### Tables

#### `customers`
- `customer_id`: Unique identifier for each customer
- `name`: Name of the customer
- `tier`: Email address of the customer
- `subscription_status`: values: 'active', 'inactive'
  
#### `orders`
- `order_id`: Unique identifier for each order
- `customer_id`: Identifier for the customer who placed the order
- `order_date`: Date when the order was placed
- `total_amount`: Total amount of the order

#### `interactions`
- `interaction_id`: Unique identifier for each interaction
- `customer_id`: Identifier for the customer who had the interaction
- `interaction_type`: Type of interaction (e.g., email, call, chat)
- `interaction_date`: Date when the interaction occurred


```sql
UPDATE customers
LEFT JOIN (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM orders
    WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    GROUP BY customer_id
) AS recent_orders ON customers.customer_id = recent_orders.customer_id
LEFT JOIN (
    SELECT 
        customer_id,
        COUNT(*) AS recent_interactions
    FROM interactions
    WHERE interaction_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    GROUP BY customer_id
) AS recent_interactions ON customers.customer_id = recent_interactions.customer_id
SET customers.tier = CASE
    WHEN recent_orders.total_spent > 5000 
         AND recent_interactions.recent_interactions > 20 
         AND customers.subscription_status = 'active' 
        THEN 'Platinum'
    WHEN recent_orders.total_spent BETWEEN 2000 AND 5000 
         AND (recent_interactions.recent_interactions > 10 
              OR customers.subscription_status = 'active')
        THEN 'Gold'
    WHEN recent_orders.total_spent BETWEEN 500 AND 2000 
         OR recent_interactions.recent_interactions > 5
        THEN 'Silver'
    ELSE 'Bronze'
END;
```


### Explanation

1. Recent Orders Subquery
   - Aggregates the total spending for each customer in the last year.

2. Recent Interactions Subquery
   - Counts the number of interactions for each customer in the last 6 months.

3. Main Query
   - Joins the customers table with the results of the subqueries.
   - Uses a CASE statement to determine the tier of each customer based on:
      - Platinum: Spending > $5,000, > 20 interactions in the last 6 months, and an active subscription.
      - Gold: Spending between $2,000 and $5,000, and either > 10 interactions or an active subscription.
      - Silver: Spending between $500 and $2,000, or > 5 interactions.
      - Bronze: All other customers.
   - The LEFT JOIN ensures all customers are included even if they have no orders or interactions.


This query segments customers into different tiers based on complex conditions involving their purchase behavior, interaction frequency, and subscription status. It is a typical example of how CRM systems can leverage SQL for advanced customer analytics and segmentation.


## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> Leetcode - Problem 182. Duplicate Emails


| Id  | email  |
|-------------|-----------------|
| 1           | john@example.com     |
| 2           | bob@example.com     |
| 3           | john@example.com     |

```sql
CREATE TABLE Person (
    Id INT PRIMARY KEY,
    Email VARCHAR(255)
);

INSERT INTO Person (Id, Email) VALUES 
(1, 'john@example.com'),
(2, 'bob@example.com'),
(3, 'john@example.com');

-- Solution 1: Using GROUP BY and HAVING
SELECT Email
FROM Person
GROUP BY Email
HAVING COUNT(*) > 1;

-- Solution 2: Using a subquery with IN
SELECT DISTINCT Email
FROM Person
WHERE Email IN (
    SELECT Email
    FROM Person
    GROUP BY Email
    HAVING COUNT(*) > 1
);

-- Solution 3: Using JOIN
SELECT p1.Email
FROM Person p1
JOIN Person p2 ON p1.Email = p2.Email
WHERE p1.Id <> p2.Id
GROUP BY p1.Email;
```

Each of these solutions will return:

| Email          |
|----------------|
| john@example.com |


## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> LeetCode - Problem 2837: Total Traveled Distance


### Overview

You are given two tables: Users and Rides. Users contains user_id and user_name, while Rides contains ride_id, user_id, and distance traveled.

Write an SQL query to report the total distance traveled by each user. If a user has no recorded rides, return 0 as the total_distance.


### Tables

#### `Users`
- `user_id`: Unique identifier for each user
- `user_name`: Name of the user
  
#### `Rides`
- `ride_id`: Unique identifier for each ride
- `user_id`: Identifier for the user who took the ride
- `distance`: Distance traveled in the ride


| user_id	| user_name |
|-------------|-----------------|
| 1	| Alice |
| 2	| Bob |
| 3	| Charlie |


ride_id  |	user_id |	distance |
|-------------|-----------------|-----------------|
| 1 |	1 |	10 |
| 2 |	1 |	15 |
| 3 |	2 |	20 |


### Solution

```sql
SELECT t1.user_id, 
       COALESCE(t2.total_distance, 0) AS total_distance 
FROM Users t1 
LEFT JOIN (
    SELECT user_id, SUM(distance) AS total_distance 
    FROM Rides 
    GROUP BY user_id
) AS t2 ON t1.user_id = t2.user_id;
```

## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> CRM System - Cleanup Orders and Related Shipments for Inactive Customers


In a CRM system, we want to clean up records related to customers who have been inactive for more than 3 years. Specifically, we need to delete such customers along with their associated orders and shipments.

### customers

| customer_id | name          | last_order_date |
|-------------|---------------|-----------------|
| 1           | Alice Johnson | 2020-04-20      |
| 2           | Bob Smith     | 2021-06-15      |
| 3           | Charlie Brown | 2019-09-10      |
| 4           | Diana Prince  | 2022-01-05      |
| 5           | Eve Davis     | 2018-11-23      |

### orders

| order_id | customer_id | order_date  | total_amount |
|----------|-------------|-------------|--------------|
| 101      | 1           | 2020-04-18  | 250.00       |
| 102      | 2           | 2021-06-10  | 150.00       |
| 103      | 3           | 2019-08-25  | 300.00       |
| 104      | 4           | 2022-01-03  | 100.00       |
| 105      | 5           | 2018-11-20  | 500.00       |

### shipments

| shipment_id | order_id | shipment_date | status     |
|-------------|----------|---------------|------------|
| 201         | 101      | 2020-04-19    | Delivered  |
| 202         | 102      | 2021-06-12    | Shipped    |
| 203         | 103      | 2019-08-30    | Delivered  |
| 204         | 104      | 2022-01-07    | In Transit |
| 205         | 105      | 2018-11-25    | Delivered  |

```sql
-- Creating tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    last_order_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT,
    shipment_date DATE,
    status VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Inserting data into customers
INSERT INTO customers (customer_id, name, last_order_date) VALUES
(1, 'Alice Johnson', '2020-04-20'),
(2, 'Bob Smith', '2021-06-15'),
(3, 'Charlie Brown', '2019-09-10'),
(4, 'Diana Prince', '2022-01-05'),
(5, 'Eve Davis', '2018-11-23'),
(6, 'Ricardo Diaz', '2018-11-23');

-- Inserting data into orders
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2020-04-18', 250.00),
(102, 2, '2021-06-10', 150.00),
(103, 3, '2019-08-25', 300.00),
(104, 4, '2022-01-03', 100.00),
(105, 5, '2018-11-20', 500.00);

-- Inserting data into shipments
INSERT INTO shipments (shipment_id, order_id, shipment_date, status) VALUES
(201, 101, '2020-04-19', 'Delivered'),
(202, 102, '2021-06-12', 'Shipped'),
(203, 103, '2019-08-30', 'Delivered'),
(204, 104, '2022-01-07', 'In Transit'),
(205, 105, '2018-11-25', 'Delivered');
```

```sql
SET SQL_SAFE_UPDATES = 0;
DELETE c, o, s
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN shipments s ON o.order_id = s.order_id
WHERE c.last_order_date < DATE_SUB(NOW(), INTERVAL 3 YEAR);
```

### Explanation:

- `DELETE c, o, s`: Specifies that we want to delete from the `customers`, `orders`, and `shipments` tables.
- `FROM customers c`: Specifies the primary table (`customers`) from which to start.
- `LEFT JOIN orders o ON c.customer_id = o.customer_id`: Joins the `customers` table with the `orders` table on the customer_id.
- `LEFT JOIN shipments s ON o.order_id = s.order_id`: Joins the `orders` table with the `shipments` table on the order_id.
- `WHERE c.last_order_date < DATE_SUB(NOW(), INTERVAL 3 YEAR)`: Adds a condition to delete only those customers who have not placed any orders in the last 3 years.

### Referential Integrity Issue

`Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (my_db.orders, CONSTRAINT orders_ibfk_1 FOREIGN KEY (customer_id) REFERENCES customers (customer_id))`

The error you're encountering is due to the foreign key constraint between the orders and customers tables. When you try to delete a customer that has corresponding orders, the foreign key constraint prevents the deletion to maintain referential integrity.
To work around this, you need to delete the dependent rows in the orders and shipments tables before deleting the rows in the customers table.You can do this by using multiple DELETE statements or by modifying the foreign key constraints to include ON DELETE CASCADE. Here, I'll provide an example with multiple DELETE statements:

```sql
-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Delete from shipments table first
DELETE s
FROM shipments s
JOIN orders o ON s.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.last_order_date < DATE_SUB(NOW(), INTERVAL 3 YEAR);

-- Delete from orders table next
DELETE o
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.last_order_date < DATE_SUB(NOW(), INTERVAL 3 YEAR);

-- Finally, delete from customers table
DELETE c
FROM customers c
WHERE c.last_order_date < DATE_SUB(NOW(), INTERVAL 3 YEAR);

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;
```

In MySQL, `ON DELETE CASCADE` is a referential action that can be specified when defining a foreign key constraint between two tables. It defines what action MySQL should take when a row in the parent (referenced) table is deleted.
Here's what ON DELETE CASCADE specifically does:

- `Cascade Deletion`: When a row in the parent table (referenced by the foreign key) is deleted, MySQL automatically deletes all rows in the child table (that contains the foreign key) that reference the deleted row in the parent table.

- `Maintains Referential Integrity`: This ensures that the relationship between the tables remains valid, as deleting a parent record would naturally require deletion of related child records to avoid orphaned references.

### Outcome:

After executing the DELETE query, Alice Johnson (customer_id = 1), Charlie Brown (customer_id = 3), and Eve Davis (customer_id = 5), along with their related orders (order_id = 101, 103, 105) and shipments (shipment_id = 201, 203, 205), will be deleted from the `customers`, `orders`, and `shipments` tables.


However, it's good to note that the DELETE statement with JOIN should be used carefully because it will delete records from all the tables mentioned. Make sure you have backups or are certain about the data you are deleting.

For clarity and safety, especially in a production environment, it is often a good idea to test your DELETE statement with a SELECT statement first to ensure it is targeting the correct records:

```sql
SELECT c.*, o.*, s.*
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN shipments s ON o.order_id = s.order_id
WHERE c.last_order_date < DATE_SUB(NOW(), INTERVAL 3 YEAR);
```

## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> CRM System - Get the total amount and payment of each customer (Using COALESCE in SELECT Statements to Handle NULL Values in CRM Data)

You have a CRM database with tables for `customers`, `orders`, and `payments`. You want to get the total amount and total payment of each customer.

The CRM system consists of three tables:

#### `customers`
- `id`: Unique identifier for each customer
- `name`: Name of the customer

#### `orders`
- `id`: Unique identifier for each order
- `customer_id`: Identifier for the customer who placed the order
- `amount`: amount of the order

#### `payments`
- `id`: Unique identifier for each payment
- `customer_id`: Identifier for the customer who placed the payment
- `amount`: Total payment


```sql
-- Create customers table
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Create orders table
CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Create payments table
CREATE TABLE payments (
    id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);
-- Insert customers
INSERT INTO customers (id, name) VALUES
    (1, 'John'),
    (2, 'Alice'),
    (3, 'Bob'),
    (4, 'Emma');

-- Insert orders
INSERT INTO orders (id, customer_id, amount) VALUES
    (1, 1, 100.00),
    (2, 1, 50.00),
    (3, 2, 75.00);

-- Insert payments
INSERT INTO payments (id, customer_id, amount) VALUES
    (1, 1, 120.00),
    (2, 2, 80.00);
```

####  ustomers

| id | name  |
|----|-------|
| 1  | John  |
| 2  | Alice |
| 3  | Bob   |
| 4  | Emma  |


#### orders

| id | customer_id | amount |
|----|-------------|--------|
| 1  | 1           | 100.00 |
| 2  | 1           | 50.00  |
| 3  | 2           | 75.00  |

#### payments

| id | customer_id | amount |
|----|-------------|--------|
| 1  | 1           | 120.00 |
| 2  | 2           | 80.00  |

### Solution

```sql
SELECT
    c.id AS customer_id,
    c.name AS customer_name,
    COALESCE(SUM(o.amount), 0) AS total_orders,
    COALESCE(SUM(p.amount), 0) AS total_payments
FROM
    customers c
LEFT JOIN
    orders o ON c.id = o.customer_id
LEFT JOIN
    payments p ON c.id = p.customer_id
GROUP BY
    c.id, c.name;
```


## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> CRM System - Adjusting Salesperson Commission Based on Recent Sales in a Sales Management System

### Scenario

In a sales management system, you have three tables: `salespeople`, `sales`, and `products`. You need to update the commission rate of salespeople based on their sales performance over the last quarter. Specifically, if a salesperson has sold more than $10,000 worth of products in the last quarter, their commission rate should be increased by 2%.

### Tables

#### `salespeople`
- `salesperson_id`: Unique identifier for each salesperson
- `name`: Name of the salesperson
- `commission_rate`: Current commission rate as a percentage

#### `sales`
- `sale_id: Unique identifier for each sale
- `salesperson_id`: Identifier for the salesperson who made the sale
- `sale_date`: Date when the sale was made
- `product_id`: Identifier for the product sold
- `quantity`: Quantity of the product sold

#### `products`
- `product_id`: Unique identifier for each product
- `product_name`: Name of the product
- `price`: Price of the product

### Solution 1

```sql
UPDATE salespeople t3
JOIN (
    SELECT t1.salesperson_id, SUM(t2.price * t1.quantity) AS total_sales
    FROM sales t1
    JOIN products t2 ON t1.product_id = t2.product_id
    WHERE t1.sale_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
    GROUP BY t1.salesperson_id
) AS t4 ON t3.salesperson_id = t4.salesperson_id
SET t3.commission_rate = CASE
    WHEN t4.total_sales > 10000 THEN t3.commission_rate + 2
    ELSE t3.commission_rate
END;
```

### Solution 2

```sql
UPDATE salespeople sp
JOIN (
    SELECT s.salesperson_id, SUM(p.price * s.quantity) AS total_sales
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    WHERE s.sale_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
    GROUP BY s.salesperson_id
    HAVING total_sales > 10000
) sales_summary ON sp.salesperson_id = sales_summary.salesperson_id
SET sp.commission_rate = sp.commission_rate + 2.00
WHERE sp.commission_rate <= 10.00;
```

### Explanation

1. Inner Query
   - The subquery calculates the total sales amount for each salesperson over the last three months.
   - It joins the sales table (t1) with the products table (t2) on product_id.
   - It filters the sales records to include only those within the last three months using DATE_SUB(CURDATE(), INTERVAL 3 MONTH).
   - The SUM function calculates the total sales amount by multiplying the price of each product by the quantity sold.
   - The GROUP BY clause groups the results by salesperson_id.
2. Update Statement
   - The UPDATE statement targets the salespeople table (t3).
   - It joins the salespeople table with the result of the subquery (t4) on salesperson_id.
   - The SET clause uses a CASE statement to update the commission_rate. If the total_sales exceeds $10,000, it increases the commission_rate by 2. Otherwise, it keeps the current commission_rate.

## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> ERP System - Calculating Employee Absence Days Excluding Weekends in an ERP System

### Scenario

In an ERP system for a company, we need to calculate the total number of days an employee is absent due to leave, excluding weekends (Saturday and Sunday). This calculation is crucial for accurate payroll processing and performance evaluations.
Let's consider a company with an ERP system that tracks employee leaves. Employee John Doe takes a leave from July 1, 2024, to July 15, 2024. We need to determine the total number of working days he is absent, excluding weekends.

```sql
CREATE TABLE employee_leaves (
    employee_id INT,
    employee_name VARCHAR(50),
    start_date DATE,
    end_date DATE
);

INSERT INTO employee_leaves (employee_id, employee_name, start_date, end_date)
VALUES 
(1, 'John Doe', '2024-07-01', '2024-07-15');
```

```sql
WITH RECURSIVE date_series AS (
    SELECT start_date AS leave_date
    FROM employee_leaves
    WHERE employee_id = 1
    UNION ALL
    SELECT leave_date + INTERVAL 1 DAY
    FROM date_series
    WHERE leave_date + INTERVAL 1 DAY <= (SELECT end_date FROM employee_leaves WHERE employee_id = 1)
),
working_days AS (
    SELECT leave_date
    FROM date_series
    WHERE DAYOFWEEK(leave_date) NOT IN (1, 7) -- 1 = Sunday, 7 = Saturday
)
SELECT employee_id, employee_name, COUNT(leave_date) AS total_working_days_absent
FROM working_days
JOIN employee_leaves ON working_days.leave_date BETWEEN employee_leaves.start_date AND employee_leaves.end_date
WHERE employee_id = 1
GROUP BY employee_id, employee_name;
```


## <img src="https://user-images.githubusercontent.com/74038190/212257467-871d32b7-e401-42e8-a166-fcfd7baa4c6b.gif" width ="25" style="margin-bottom: -5px;"> Example 1 – Finding Bosses and Hierarchical Level for All Employees

[Recursive CTE - Learn SQL]([https://www.youtube.com/watch?v=a-hFbr-4VQQ&list=PLavw5C92dz9Ef4E-1Zi9KfCTXS_IN8gXZ](https://learnsql.com/blog/sql-recursive-cte/))


```sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    boss_id INT,
    FOREIGN KEY (boss_id) REFERENCES employees(id)
);

INSERT INTO employees (id, first_name, last_name, boss_id) VALUES
(1, 'Domenic', 'Leaver', 5),
(2, 'Cleveland', 'Hewins', 1),
(3, 'Kakalina', 'Atherton', 8),
(4, 'Roxanna', 'Fairlie', NULL),
(5, 'Hermie', 'Comsty', 4),
(6, 'Pooh', 'Goss', 8),
(7, 'Faulkner', 'Challiss', 5),
(8, 'Bobbe', 'Blakeway', 4),
(9, 'Laurene', 'Burchill', 1),
(10, 'Augusta', 'Gosdin', 8),
(11, 'Alice', 'Johnson', NULL),
(12, 'Eve', 'Smith', 11),
(13, 'John', 'Doe', 11);
```

### Solution

```sql
WITH RECURSIVE company_hierarchy AS (
  SELECT    id,
            first_name,
            last_name,
            boss_id,
        0 AS hierarchy_level
  FROM employees
  WHERE boss_id IS NULL
 
  UNION ALL
   
  SELECT    e.id,
            e.first_name,
            e.last_name,
            e.boss_id,
        hierarchy_level + 1
  FROM employees e, company_hierarchy ch
  WHERE e.boss_id = ch.id
)
 
SELECT   ch.first_name AS employee_first_name,
       ch.last_name AS employee_last_name,
       e.first_name AS boss_first_name,
       e.last_name AS boss_last_name,
       hierarchy_level
FROM company_hierarchy ch
LEFT JOIN employees e
ON ch.boss_id = e.id
ORDER BY ch.hierarchy_level, ch.boss_id;



WITH RECURSIVE company_hierarchy AS (
    SELECT e.id, e.first_name, e.last_name, e.boss_id , 0 hierarchy FROM employees e WHERE e.boss_id IS NULL
    UNION ALL
    SELECT e.id, e.first_name, e.last_name, e.boss_id , hierarchy + 1 FROM employees e JOIN company_hierarchy ch ON e.boss_id = ch.id
)
SELECT * FROM company_hierarchy;
```

### Final Result

| employee_first_name | employee_last_name | boss_first_name | boss_last_name | hierarchy_level 
| --------------------|--------------------|-----------------|----------------|----------------
| Roxanna             | Fairlie            | NULL            | NULL           | 0
| Alice               | Johnson            | NULL            | NULL           | 0
| Hermie              | Comsty             | Roxanna         | Fairlie        | 1
| Bobbe               | Blakeway           | Roxanna         | Fairlie        | 1
| Eve                 | Smith              | Alice           | Johnson        | 1
| John                | Doe                | Alice           | Johnson        | 1
| Domenic             | Leaver             | Hermie          | Comsty         | 2
| Faulkner            | Challiss           | Hermie          | Comsty         | 2
| Kakalina            | Atherton           | Bobbe           | Blakeway       | 2
| Pooh                | Goss               | Bobbe           | Blakeway       | 2
| Augusta             | Gosdin             | Bobbe           | Blakeway       | 2
| Cleveland           | Hewins             | Domenic         | Leaver         | 3
| Laurene             | Burchill           | Domenic         | Leaver         | 3



The recursive query works separately for each row result in each iteration of the recursion. Let's delve deeper into how this works.

### Detailed Explanation 

The recursive Common Table Expression (CTE) processes each row independently within each iteration of the recursive step.

1. Initial Population (Base Case)
   - The base case populates the initial rows where boss_id IS NULL.
     ```sql
     SELECT id, first_name, last_name, boss_id, 0 AS hierarchy_level
FROM employees
WHERE boss_id IS NULL;
     ```

   Given the example data, the initial result set include

    ```sql
    id: 4, first_name: Roxanna, last_name: Fairlie, boss_id: NULL, hierarchy_level: 0
    id: 11, first_name: Alice, last_name: Johnson, boss_id: NULL, hierarchy_level: 0
    ```
