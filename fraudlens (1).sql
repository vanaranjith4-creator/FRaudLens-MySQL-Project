-- FRAUDLENS: FINANCIAL TRANSACTION RISK ANALYSIS
-- SQL Project | MySQL
-- =====================================================

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS fraudlens_db;
USE fraudlens_db;
-- =====================================================
-- 2. CREATE CUSTOMERS TABLE
-- =====================================================
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    city VARCHAR(60) NOT NULL,
    registration_date DATE NOT NULL
);

-- =====================================================
-- 3. CREATE ACCOUNTS TABLE
-- =====================================================
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    account_number VARCHAR(24) NOT NULL UNIQUE,
    account_type VARCHAR(20) NOT NULL,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    account_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    opened_date DATE NOT NULL,
    CHECK (account_type IN ('Savings', 'Current', 'Salary')),
    CHECK (balance >= 0),
    CHECK (account_status IN ('Active', 'Frozen', 'Closed')),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- =====================================================
-- 4. CREATE MERCHANTS TABLE
-- =====================================================
CREATE TABLE Merchants (
    merchant_id INT PRIMARY KEY AUTO_INCREMENT,
    merchant_name VARCHAR(100) NOT NULL,
    merchant_category VARCHAR(50) NOT NULL,
    city VARCHAR(60) NOT NULL,
    merchant_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CHECK (merchant_status IN ('Active', 'Under Review', 'Blocked'))
);

-- =====================================================
-- 5. CREATE RISK_RULES TABLE
-- =====================================================
CREATE TABLE Risk_Rules (
    rule_id INT PRIMARY KEY AUTO_INCREMENT,
    rule_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL,
    threshold_amount DECIMAL(12,2) DEFAULT NULL,
    risk_level VARCHAR(20) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CHECK (risk_level IN ('Low', 'Medium', 'High', 'Critical'))
);

-- =====================================================
-- 6. CREATE TRANSACTIONS TABLE
-- =====================================================
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    merchant_id INT,
    transaction_date DATETIME NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    transaction_status VARCHAR(20) NOT NULL DEFAULT 'Completed',
    location_city VARCHAR(60) NOT NULL,
    device_id VARCHAR(60),
    CHECK (transaction_type IN ('Transfer', 'Withdrawal', 'Deposit', 'Purchase')),
    CHECK (amount > 0),
    CHECK (payment_method IN ('UPI', 'Card', 'Net Banking', 'ATM', 'IMPS', 'NEFT')),
    CHECK (transaction_status IN ('Completed', 'Pending', 'Failed', 'Reversed')),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (merchant_id) REFERENCES Merchants(merchant_id)
);

-- =====================================================
-- 7. CREATE FRAUD_ALERTS TABLE
-- =====================================================
CREATE TABLE Fraud_Alerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT NOT NULL,
    rule_id INT NOT NULL,
    alert_date DATETIME NOT NULL,
    risk_level VARCHAR(20) NOT NULL,
    alert_status VARCHAR(20) NOT NULL DEFAULT 'Open',
    notes VARCHAR(255),
    CHECK (risk_level IN ('Low', 'Medium', 'High', 'Critical')),
    CHECK (alert_status IN ('Open', 'Investigating', 'Resolved', 'False Positive')),
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id),
    FOREIGN KEY (rule_id) REFERENCES Risk_Rules(rule_id)
);

-- =====================================================
-- 8. INSERT SAMPLE CUSTOMERS
-- =====================================================
INSERT INTO Customers
(customer_name, email, phone, city, registration_date)
VALUES
('ranjith Kumar', 'ranjithkumar@gmail.com', '6281346360', 'Visakhapatnam', '2025-01-12'),
('Srivamsi', 'srivamsi@gmail.com', '8688697834', 'Hyderabad', '2025-02-18'),
('Ravi Teja', 'raviteja67@gmail.com', '9949079839', 'Vijayawada', '2025-03-05'),
('Mukesh', 'mukesh12@gmail.com','8106155301', 'Visakhapatnam', '2025-04-21'),
('Sampath', 'sampath23@gmail.com', '6300878875', 'Bengaluru', '2025-05-10'),
('Ramana', 'ramana89@gmail.com', '9701205587', 'Chennai', '2025-06-15'),
('Srinadh', 'srinadh34@gmail.com', '9949914924', 'Hyderabad', '2025-07-09'),
('Bhanu Reddy', 'bhanureddy21@gmail.com', '9491355377', 'Pune', '2025-08-02');

-- =====================================================
-- 9. INSERT SAMPLE ACCOUNTS
-- =====================================================
INSERT INTO Accounts
(customer_id, account_number, account_type, balance, account_status, opened_date)
VALUES
(1, 'FL100000001', 'Savings', 42000.00, 'Active', '2025-01-12'),
(2, 'FL100000002', 'Savings', 18500.00, 'Active', '2025-02-18'),
(3, 'FL100000003', 'Current', 76500.00, 'Active', '2025-03-05'),
(4, 'FL100000004', 'Salary', 32000.00, 'Active', '2025-04-21'),
(5, 'FL100000005', 'Savings', 91000.00, 'Active', '2025-05-10'),
(6, 'FL100000006', 'Savings', 25000.00, 'Frozen', '2025-06-15'),
(7, 'FL100000007', 'Salary', 15700.00, 'Active', '2025-07-09'),
(8, 'FL100000008', 'Savings', 54000.00, 'Active', '2025-08-02');

-- =====================================================
-- 10. INSERT SAMPLE MERCHANTS
-- =====================================================
INSERT INTO Merchants
(merchant_name, merchant_category, city, merchant_status)
VALUES
('QuickCart Online', 'E-Commerce', 'Hyderabad', 'Active'),
('Metro Fuel Station', 'Fuel', 'Visakhapatnam', 'Active'),
('Bright Electronics', 'Electronics', 'Bengaluru', 'Active'),
('TravelWay Bookings', 'Travel', 'Chennai', 'Under Review'),
('DailyNeeds Market', 'Grocery', 'Vijayawada', 'Active'),
('GameZone Digital', 'Digital Goods', 'Pune', 'Blocked');

-- =====================================================
-- 11. INSERT RISK RULES
-- =====================================================
INSERT INTO Risk_Rules
(rule_name, description, threshold_amount, risk_level, is_active)
VALUES
('High Value Transaction', 'Transaction amount is greater than 50000', 50000.00, 'High', TRUE),
('Unusual Purchase', 'Purchase amount is greater than 20000', 20000.00, 'Medium', TRUE),
('Blocked Merchant', 'Transaction is linked to a blocked merchant', NULL, 'Critical', TRUE),
('Frozen Account Activity', 'Transaction is associated with a frozen account', NULL, 'Critical', TRUE),
('Failed Transaction Review', 'Failed transaction should be reviewed', NULL, 'Medium', TRUE);

-- =====================================================
-- 12. INSERT SAMPLE TRANSACTIONS
-- =====================================================
INSERT INTO Transactions
(account_id, merchant_id, transaction_date, transaction_type, amount,
payment_method, transaction_status, location_city, device_id)
VALUES
(1, 1, '2026-10-01 09:15:00', 'Purchase', 1250.00, 'UPI', 'Completed', 'Visakhapatnam', 'DEV-A11'),
(1, 2, '2026-10-01 11:40:00', 'Purchase', 1800.00, 'Card', 'Completed', 'Visakhapatnam', 'DEV-A11'),
(2, 1, '2026-10-02 13:10:00', 'Purchase', 24500.00, 'Net Banking', 'Completed', 'Hyderabad', 'DEV-B21'),
(3, 3, '2026-10-02 16:25:00', 'Purchase', 62000.00, 'Card', 'Completed', 'Bengaluru', 'DEV-C31'),
(4, 5, '2026-10-03 08:05:00', 'Purchase', 750.00, 'UPI', 'Completed', 'Visakhapatnam', 'DEV-D41'),
(5, 4, '2026-10-03 21:50:00', 'Purchase', 38500.00, 'Net Banking', 'Pending', 'Chennai', 'DEV-E51'),
(6, 6, '2026-10-04 00:20:00', 'Purchase', 2999.00, 'UPI', 'Failed', 'Pune', 'DEV-F61'),
(7, 1, '2026-10-04 10:00:00', 'Transfer', 55000.00, 'IMPS', 'Completed', 'Hyderabad', 'DEV-G71'),
(8, 3, '2026-10-05 14:45:00', 'Purchase', 8400.00, 'Card', 'Completed', 'Pune', 'DEV-H81'),
(2, 2, '2026-10-06 02:10:00', 'Withdrawal', 7000.00, 'ATM', 'Completed', 'Hyderabad', 'DEV-B21'),
(3, 6, '2026-10-06 02:14:00', 'Purchase', 1800.00, 'UPI', 'Failed', 'Pune', 'DEV-C32'),
(6, 1, '2026-10-07 12:30:00', 'Purchase', 1100.00, 'UPI', 'Failed', 'Chennai', 'DEV-F61'),
(5, 3, '2026-10-08 18:35:00', 'Purchase', 22500.00, 'Card', 'Completed', 'Bengaluru', 'DEV-E51'),
(4, 5, '2026-10-09 19:05:00', 'Transfer', 3200.00, 'NEFT', 'Completed', 'Visakhapatnam', 'DEV-D41'),
(7, 4, '2026-10-10 23:40:00', 'Purchase', 27000.00, 'Net Banking', 'Pending', 'Chennai', 'DEV-G71'),
(8, 2, '2026-10-11 09:20:00', 'Purchase', 950.00, 'UPI', 'Completed', 'Pune', 'DEV-H81'),
(1, 3, '2026-10-12 01:05:00', 'Purchase', 54000.00, 'Card', 'Completed', 'Bengaluru', 'DEV-A99'),
(7, 6, '2026-10-12 22:55:00', 'Purchase', 1500.00, 'UPI', 'Failed', 'Pune', 'DEV-G72'),
(2, 1, '2026-10-13 15:25:00', 'Purchase', 1600.00, 'UPI', 'Completed', 'Hyderabad', 'DEV-B21'),
(5, 4, '2026-10-14 03:15:00', 'Transfer', 68000.00, 'IMPS', 'Completed', 'Chennai', 'DEV-E99');

-- =====================================================
-- 13. INSERT SAMPLE FRAUD ALERTS
-- Note: These are rule-based sample alerts, not confirmed fraud.
-- =====================================================
INSERT INTO Fraud_Alerts
(transaction_id, rule_id, alert_date, risk_level, alert_status, notes)
VALUES
(3, 2, '2026-10-02 13:11:00', 'Medium', 'Open', 'Purchase exceeds unusual-purchase threshold'),
(4, 1, '2026-10-02 16:26:00', 'High', 'Investigating', 'High-value transaction requires review'),
(6, 2, '2026-10-03 21:51:00', 'Medium', 'Open', 'Large pending purchase requires review'),
(7, 3, '2026-10-04 00:21:00', 'Critical', 'Investigating', 'Transaction is linked to a blocked merchant'),
(8, 1, '2026-10-04 10:01:00', 'High', 'Open', 'High-value transfer requires review'),
(11, 3, '2026-10-06 02:15:00', 'Critical', 'Open', 'Transaction is linked to a blocked merchant'),
(12, 4, '2026-10-07 12:31:00', 'Critical', 'Investigating', 'Transaction is associated with a frozen account'),
(17, 1, '2026-10-12 01:06:00', 'High', 'Open', 'High-value transaction at an unusual hour'),
(20, 1, '2026-10-14 03:16:00', 'High', 'Open', 'High-value transfer at an unusual hour');

-- =====================================================
-- 14. BASIC QUERIES
-- =====================================================
SELECT * FROM Customers;
SELECT * FROM Accounts;
SELECT * FROM Merchants;
SELECT * FROM Transactions;
SELECT * FROM Fraud_Alerts;
SELECT * FROM Risk_Rules;

-- Show completed transactions
SELECT *
FROM Transactions
WHERE transaction_status = 'Completed';

-- Show the five largest transactions
SELECT transaction_id, account_id, amount, transaction_date
FROM Transactions
ORDER BY amount DESC
LIMIT 5;

-- =====================================================
-- 15. FILTERING OPERATORS
-- =====================================================
SELECT * FROM Transactions WHERE amount > 20000;
SELECT * FROM Transactions WHERE amount BETWEEN 5000 AND 30000;
SELECT * FROM Transactions WHERE payment_method IN ('UPI', 'Card');
SELECT * FROM Transactions WHERE transaction_status <> 'Completed';
SELECT * FROM Customers WHERE customer_name LIKE 'A%';
SELECT * FROM Transactions WHERE merchant_id IS NULL;
SELECT * FROM Accounts WHERE account_status = 'Active';

-- =====================================================
-- 16. AGGREGATE FUNCTIONS
-- =====================================================
SELECT COUNT(*) AS total_transactions FROM Transactions;
SELECT SUM(amount) AS total_transaction_value FROM Transactions;
SELECT AVG(amount) AS average_transaction_amount FROM Transactions;
SELECT MIN(amount) AS minimum_transaction_amount FROM Transactions;
SELECT MAX(amount) AS maximum_transaction_amount FROM Transactions;

-- =====================================================
-- 17. GROUP BY AND HAVING
-- =====================================================
SELECT transaction_status, COUNT(*) AS transaction_count
FROM Transactions
GROUP BY transaction_status;

SELECT payment_method, SUM(amount) AS total_amount
FROM Transactions
GROUP BY payment_method
ORDER BY total_amount DESC;

SELECT account_id, COUNT(*) AS transaction_count, SUM(amount) AS total_amount
FROM Transactions
GROUP BY account_id
HAVING COUNT(*) >= 2;

SELECT location_city, COUNT(*) AS transaction_count
FROM Transactions
GROUP BY location_city
HAVING COUNT(*) > 1;

-- =====================================================
-- 18. STRING AND DATE FUNCTIONS
-- =====================================================
SELECT UPPER(customer_name) AS customer_name_upper
FROM Customers;

SELECT CONCAT(customer_name, ' - ', city) AS customer_details
FROM Customers;

SELECT transaction_id, DATE(transaction_date) AS transaction_day
FROM Transactions;

SELECT transaction_id, HOUR(transaction_date) AS transaction_hour
FROM Transactions;

SELECT transaction_id, DATEDIFF(CURDATE(), DATE(transaction_date)) AS days_ago
FROM Transactions;

-- =====================================================
-- 19. CASE: SIMPLE RISK CLASSIFICATION
-- These thresholds are illustrative business rules.
-- =====================================================
SELECT
    transaction_id,
    amount,
    transaction_status,
    CASE
        WHEN amount >= 50000 THEN 'High'
        WHEN amount >= 20000 THEN 'Medium'
        ELSE 'Low'
    END AS amount_risk_level
FROM Transactions
ORDER BY amount DESC;

-- =====================================================
-- 20. INNER JOIN
-- Customer and account transaction details
-- =====================================================
SELECT
    t.transaction_id,
    c.customer_name,
    a.account_number,
    t.amount,
    t.transaction_type,
    t.transaction_status
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id;

-- =====================================================
-- 21. LEFT JOIN
-- Show every customer, including customers without transactions
-- =====================================================
SELECT
    c.customer_id,
    c.customer_name,
    t.transaction_id,
    t.amount
FROM Customers c
LEFT JOIN Accounts a ON c.customer_id = a.customer_id
LEFT JOIN Transactions t ON a.account_id = t.account_id
ORDER BY c.customer_id;

-- =====================================================
-- 22. RIGHT JOIN
-- Show all merchants, including merchants with no transactions
-- =====================================================
SELECT
    m.merchant_name,
    t.transaction_id,
    t.amount
FROM Transactions t
RIGHT JOIN Merchants m ON t.merchant_id = m.merchant_id;

-- =====================================================
-- 23. CROSS JOIN (demonstration only)
-- Produces every customer/merchant combination
-- =====================================================
SELECT c.customer_name, m.merchant_name
FROM Customers c
CROSS JOIN Merchants m;

-- =====================================================
-- 24. FULL OUTER JOIN SIMULATION IN MYSQL
-- =====================================================
SELECT c.customer_name, a.account_number
FROM Customers c
LEFT JOIN Accounts a ON c.customer_id = a.customer_id
UNION
SELECT c.customer_name, a.account_number
FROM Customers c
RIGHT JOIN Accounts a ON c.customer_id = a.customer_id;

-- =====================================================
-- 25. SUBQUERIES
-- Transactions above average amount
-- =====================================================
SELECT transaction_id, amount
FROM Transactions
WHERE amount > (SELECT AVG(amount) FROM Transactions)
ORDER BY amount DESC;

-- Transactions equal to the maximum amount
SELECT transaction_id, amount
FROM Transactions
WHERE amount = (SELECT MAX(amount) FROM Transactions);

-- Customers with at least one high-value transaction
SELECT customer_id, customer_name
FROM Customers
WHERE customer_id IN (
    SELECT a.customer_id
    FROM Accounts a
    JOIN Transactions t ON a.account_id = t.account_id
    WHERE t.amount >= 50000
);

-- =====================================================
-- 26. UNION AND UNION ALL
-- =====================================================
SELECT location_city AS city FROM Transactions
UNION
SELECT city FROM Merchants;

SELECT location_city AS city FROM Transactions
UNION ALL
SELECT city FROM Merchants;

-- =====================================================
-- 27. CTE: CUSTOMER TRANSACTION SUMMARY
-- =====================================================
WITH CustomerTotals AS (
    SELECT
        a.customer_id,
        COUNT(t.transaction_id) AS total_transactions,
        COALESCE(SUM(t.amount), 0) AS total_amount
    FROM Accounts a
    LEFT JOIN Transactions t ON a.account_id = t.account_id
    GROUP BY a.customer_id
)
SELECT c.customer_name, ct.total_transactions, ct.total_amount
FROM CustomerTotals ct
JOIN Customers c ON c.customer_id = ct.customer_id
ORDER BY ct.total_amount DESC;

-- =====================================================
-- 28. WINDOW FUNCTIONS
-- Rank transactions by amount
-- =====================================================
SELECT
    transaction_id,
    account_id,
    amount,
    DENSE_RANK() OVER (ORDER BY amount DESC) AS amount_rank
FROM Transactions;

-- Running transaction amount per account
SELECT
    account_id,
    transaction_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY account_id
        ORDER BY transaction_date
    ) AS running_amount
FROM Transactions;

-- =====================================================
-- 29. FRAUD ALERT ANALYSIS
-- =====================================================
SELECT
    fa.alert_id,
    t.transaction_id,
    c.customer_name,
    t.amount,
    rr.rule_name,
    fa.risk_level,
    fa.alert_status,
    fa.notes
FROM Fraud_Alerts fa
JOIN Transactions t ON fa.transaction_id = t.transaction_id
JOIN Accounts a ON t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id
JOIN Risk_Rules rr ON fa.rule_id = rr.rule_id
ORDER BY FIELD(fa.risk_level, 'Critical', 'High', 'Medium', 'Low'), fa.alert_date DESC;

-- Count alerts by risk level
SELECT risk_level, COUNT(*) AS alert_count
FROM Fraud_Alerts
GROUP BY risk_level
ORDER BY alert_count DESC;

-- Open alerts requiring review
SELECT *
FROM Fraud_Alerts
WHERE alert_status IN ('Open', 'Investigating');

-- Transactions involving blocked merchants
SELECT t.transaction_id, m.merchant_name, t.amount, t.transaction_status
FROM Transactions t
JOIN Merchants m ON t.merchant_id = m.merchant_id
WHERE m.merchant_status = 'Blocked';

-- =====================================================
-- 30. VIEW
-- =====================================================
CREATE VIEW transaction_risk_report AS
SELECT
    t.transaction_id,
    c.customer_name,
    a.account_number,
    m.merchant_name,
    t.transaction_date,
    t.transaction_type,
    t.amount,
    t.payment_method,
    t.transaction_status,
    t.location_city
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id
LEFT JOIN Merchants m ON t.merchant_id = m.merchant_id;

SELECT * FROM transaction_risk_report;

-- =====================================================
-- 31. INDEX
-- =====================================================
CREATE INDEX idx_transactions_date ON Transactions(transaction_date);
CREATE INDEX idx_transactions_amount ON Transactions(amount);
CREATE INDEX idx_transactions_account_date ON Transactions(account_id, transaction_date);

-- Example query that can benefit from indexes
SELECT transaction_id, amount, transaction_date
FROM Transactions
WHERE account_id = 1
ORDER BY transaction_date;

-- =====================================================
-- 32. TRANSACTION MANAGEMENT
-- Demonstration only: this update is rolled back.
-- =====================================================
START TRANSACTION;
UPDATE Fraud_Alerts
SET alert_status = 'Investigating'
WHERE alert_id = 1;
ROLLBACK;
-- =====================================================
-- END OF FRAUDLENS PROJECT
-- =====================================================
