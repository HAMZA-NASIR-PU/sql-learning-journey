DROP DATABASE IF EXISTS `crm-sql-prep`;
CREATE DATABASE `crm-sql-prep`;
USE `crm-sql-prep`;

CREATE TABLE employees (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    boss_id INT,
    FOREIGN KEY (boss_id) REFERENCES employees(id)
);

-- Step 1: Insert top-level employees
INSERT INTO employees (id, first_name, last_name, boss_id) VALUES
(4, 'Roxanna', 'Fairlie', NULL),
(11, 'Alice', 'Johnson', NULL);

-- Step 2: Insert next level of employees
INSERT INTO employees (id, first_name, last_name, boss_id) VALUES
(5, 'Hermie', 'Comsty', 4),
(8, 'Bobbe', 'Blakeway', 4),
(12, 'Eve', 'Smith', 11),
(13, 'John', 'Doe', 11);

-- Step 3: Continue inserting the remaining employees
INSERT INTO employees (id, first_name, last_name, boss_id) VALUES
(1, 'Domenic', 'Leaver', 5),
(7, 'Faulkner', 'Challiss', 5),
(3, 'Kakalina', 'Atherton', 8),
(6, 'Pooh', 'Goss', 8),
(10, 'Augusta', 'Gosdin', 8);

-- Step 4: Insert employees that reference the previously inserted IDs
INSERT INTO employees (id, first_name, last_name, boss_id) VALUES
(2, 'Cleveland', 'Hewins', 1),
(9, 'Laurene', 'Burchill', 1);



WITH RECURSIVE company_hierarchy AS (
    SELECT e.id, e.first_name, e.last_name, e.boss_id , 0 hierarchy FROM employees e WHERE e.boss_id IS NULL
    UNION ALL
    SELECT e.id, e.first_name, e.last_name, e.boss_id , hierarchy + 1 FROM employees e JOIN company_hierarchy ch ON e.boss_id = ch.id
)
SELECT * FROM company_hierarchy;



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
