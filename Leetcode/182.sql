DROP DATABASE IF EXISTS `crm-sql-prep`;
CREATE DATABASE `crm-sql-prep`;
USE `crm-sql-prep`;

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