DROP DATABASE IF EXISTS `crm-sql-prep`;
CREATE DATABASE `crm-sql-prep`;
USE `crm-sql-prep`;

CREATE TABLE Tweets (
    tweet_id INT PRIMARY KEY,
    content VARCHAR(280)
);


INSERT INTO Tweets (tweet_id, content) VALUES
(1, 'Just setting up my twttr'),
(2, 'Hello World!'),
(3, 'This is a tweet that is exactly 140 characters long and should be considered a valid tweet because it does not exceed the maximum length allowed.'),
(4, 'This tweet exceeds the 140 character limit and should be flagged as invalid because it is too long. It has way more characters than allowed. This part pushes it over the limit.'),
(5, 'Short tweet.');


SELECT tweet_id 
FROM Tweets
WHERE LENGTH(content) > 15;