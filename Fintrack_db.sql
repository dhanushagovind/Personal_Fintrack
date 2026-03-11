-- =========================================
-- FINTRACK PERSONAL FINANCE TRACKER
-- COMPLETE SQL SCRIPT (RUN ALL AT ONCE)
-- =========================================

-- Remove existing database if present
DROP DATABASE IF EXISTS fintrack;

-- Create new database
CREATE DATABASE fintrack;

-- Use the database
USE fintrack;

-- =========================================
-- CREATE USERS TABLE
-- =========================================

CREATE TABLE users (
user_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL
);

-- =========================================
-- CREATE CATEGORIES TABLE
-- =========================================

CREATE TABLE categories (
category_id INT AUTO_INCREMENT PRIMARY KEY,
category_name VARCHAR(50) NOT NULL
);

-- =========================================
-- CREATE TRANSACTIONS TABLE
-- =========================================

CREATE TABLE transactions (
transaction_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT,
category_id INT,
type ENUM('income','expense'),
amount DECIMAL(10,2),
description VARCHAR(255),
date DATE,
FOREIGN KEY (user_id) REFERENCES users(user_id),
FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- =========================================
-- INSERT SINGLE USER
-- =========================================

INSERT INTO users (name)
VALUES ('Anusha');

-- =========================================
-- INSERT CATEGORIES
-- =========================================

INSERT INTO categories (category_name) VALUES
('Food'),
('Travel'),
('Shopping'),
('Bills'),
('Salary'),
('Entertainment'),
('Health'),
('Education');

-- =========================================
-- INSERT 10 TRANSACTIONS
-- =========================================

INSERT INTO transactions
(user_id, category_id, type, amount, description, date)
VALUES
(1,5,'income',50000,'Monthly Salary','2026-03-01'),
(1,1,'expense',250,'Lunch at restaurant','2026-03-02'),
(1,2,'expense',800,'Taxi fare','2026-03-03'),
(1,3,'expense',1500,'Clothes shopping','2026-03-04'),
(1,4,'expense',2000,'Electricity bill','2026-03-05'),
(1,6,'expense',600,'Movie ticket','2026-03-06'),
(1,7,'expense',400,'Medicine purchase','2026-03-06'),
(1,8,'expense',1200,'Online course','2026-03-07'),
(1,1,'expense',300,'Dinner','2026-03-07'),
(1,2,'expense',500,'Bus travel','2026-03-08');

-- =========================================
-- VIEW ALL TRANSACTIONS
-- =========================================

SELECT * FROM transactions;

-- =========================================
-- SHOW TRANSACTIONS WITH CATEGORY
-- =========================================

SELECT
t.transaction_id,
c.category_name,
t.type,
t.amount,
t.description,
t.date
FROM transactions t
JOIN categories c
ON t.category_id = c.category_id;

-- =========================================
-- TOTAL EXPENSE BY CATEGORY
-- =========================================

SELECT
c.category_name,
SUM(t.amount) AS total_expense
FROM transactions t
JOIN categories c
ON t.category_id = c.category_id
WHERE t.type='expense'
GROUP BY c.category_name;

-- =========================================
-- CURRENT BALANCE
-- =========================================

SELECT
SUM(CASE WHEN type='income' THEN amount ELSE 0 END) -
SUM(CASE WHEN type='expense' THEN amount ELSE 0 END)
AS current_balance
FROM transactions;

SELECT * FROM transactions;

CREATE VIEW financial_summary AS
SELECT
c.category_name,
SUM(CASE WHEN t.type='income' THEN t.amount ELSE 0 END) AS total_income,
SUM(CASE WHEN t.type='expense' THEN t.amount ELSE 0 END) AS total_expense
FROM transactions t
JOIN categories c
ON t.category_id = c.category_id
GROUP BY c.category_name;

SELECT * FROM financial_summary;

DELIMITER $$

CREATE TRIGGER check_amount
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Amount must be greater than zero';
    END IF;
END $$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE monthly_report()
BEGIN
SELECT
MONTH(date) AS month,
SUM(CASE WHEN type='income' THEN amount ELSE 0 END) AS total_income,
SUM(CASE WHEN type='expense' THEN amount ELSE 0 END) AS total_expense
FROM transactions
GROUP BY MONTH(date);
END //

DELIMITER ;

CALL monthly_report();

CREATE INDEX idx_date
ON transactions(date);

SELECT * FROM transactions
WHERE date = '2026-03-08';

DROP TABLE budgets;

CREATE TABLE budgets (
budget_id INT AUTO_INCREMENT PRIMARY KEY,
category_id INT,
monthly_budget DECIMAL(10,2),
FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

SELECT 
c.category_name,
SUM(t.amount) AS total_spent,
b.monthly_budget
FROM transactions t
JOIN categories c ON t.category_id = c.category_id
JOIN budgets b ON c.category_id = b.category_id
WHERE t.type='expense'
AND MONTH(t.date)=MONTH(CURDATE())
GROUP BY c.category_name, b.monthly_budget
HAVING total_spent > b.monthly_budget;

SELECT * FROM budgets;

SELECT 
category_id,
SUM(amount) AS total_spent
FROM transactions
WHERE type='expense'
GROUP BY category_id;

INSERT INTO budgets(category_id, monthly_budget)
VALUES (1, 300);

SELECT 
c.category_name,
SUM(t.amount) AS total_spent,
b.monthly_budget
FROM transactions t
JOIN categories c ON t.category_id = c.category_id
JOIN budgets b ON t.category_id = b.category_id
WHERE t.type = 'expense'
GROUP BY c.category_name, b.monthly_budget
HAVING SUM(t.amount) > b.monthly_budget;

SELECT 
c.category_name,
SUM(t.amount) AS total_spent,
b.monthly_budget,
CASE
WHEN SUM(t.amount) > b.monthly_budget THEN 'Overspending'
ELSE 'Within Budget'
END AS status
FROM transactions t
JOIN categories c ON t.category_id = c.category_id
JOIN budgets b ON t.category_id = b.category_id
WHERE t.type='expense'
GROUP BY c.category_name, b.monthly_budget;

INSERT INTO budgets (category_id, monthly_budget) VALUES
(1,5000),
(2,3000),
(3,2000),
(4,4000),
(5,1500);

INSERT INTO transactions
(category_id,type,amount,description,date)
VALUES
(1,'expense',3000,'Restaurant','2026-03-09');

DELETE FROM budgets
WHERE budget_id NOT IN (
SELECT * FROM (
SELECT MIN(budget_id)
FROM budgets
GROUP BY category_id
) AS temp
);

SELECT * FROM budgets;

DROP TRIGGER IF EXISTS detect_overspending;

DELIMITER $$

CREATE TRIGGER detect_overspending
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN

DECLARE total_spent DECIMAL(10,2);
DECLARE limit_budget DECIMAL(10,2);

SELECT SUM(amount)
INTO total_spent
FROM transactions
WHERE category_id = NEW.category_id
AND type = 'expense';

SELECT monthly_budget
INTO limit_budget
FROM budgets
WHERE category_id = NEW.category_id
LIMIT 1;

IF total_spent > limit_budget THEN
INSERT INTO overspending_alerts(category_id,total_spent,budget)
VALUES(NEW.category_id,total_spent,limit_budget);
END IF;

END$$

DELIMITER ;

CREATE TABLE overspending_alerts (
alert_id INT AUTO_INCREMENT PRIMARY KEY,
category_id INT,
total_spent DECIMAL(10,2),
budget DECIMAL(10,2),
alert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO transactions 
(category_id,type,amount,description,date)
VALUES 
(1,'expense',3000,'Restaurant','2026-03-08');

INSERT INTO transactions 
(category_id,type,amount,description,date)
VALUES 
(1,'expense',2500,'Groceries','2026-03-08');

SELECT * FROM overspending_alerts;

CREATE VIEW monthly_expense_summary AS
SELECT 
    MONTH(date) AS month,
    category_id,
    SUM(amount) AS total_expense
FROM transactions
WHERE type='expense'
GROUP BY MONTH(date), category_id;

SELECT * FROM monthly_expense_summary;

CREATE VIEW unusual_transactions AS
SELECT *
FROM transactions
WHERE amount >
(
SELECT AVG(amount)*2
FROM transactions
WHERE type='expense'
);

SELECT * FROM unusual_transactions;

CREATE VIEW category_spending AS
SELECT 
c.category_name,
SUM(t.amount) AS total_spent
FROM transactions t
JOIN categories c
ON t.category_id = c.category_id
WHERE t.type='expense'
GROUP BY c.category_name;

SELECT * FROM category_spending;

CREATE VIEW budget_recommendation AS
SELECT 
    c.category_name,
    AVG(t.amount) AS avg_spending,
    AVG(t.amount) * 1.1 AS recommended_budget
FROM transactions t
JOIN categories c
ON t.category_id = c.category_id
WHERE t.type = 'expense'
GROUP BY c.category_name;