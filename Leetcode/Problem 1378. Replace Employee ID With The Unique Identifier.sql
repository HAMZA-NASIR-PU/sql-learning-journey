DROP DATABASE IF EXISTS `crm-sql-prep`;
CREATE DATABASE `crm-sql-prep`;
USE `crm-sql-prep`;

CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);


CREATE TABLE EmployeeUNI (
    id INT,
    unique_id INT PRIMARY KEY
);

-- Insert data into Employees table
INSERT INTO Employees (id, name) VALUES
(1, 'Alice'),
(7, 'Bob'),
(11, 'Meir'),
(90, 'Winston')
(3, 'Jonathan');

-- Insert data into EmployeeUNI table
INSERT INTO EmployeeUNI (id, unique_id) VALUES
(3, 1),
(11, 2),
(90, 3);

SELECT eu.unique_id, e.name
FROM Employees e
LEFT JOIN EmployeeUNI eu
ON e.id = eu.id
