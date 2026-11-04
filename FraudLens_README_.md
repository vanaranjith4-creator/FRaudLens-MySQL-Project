# FraudLens: Financial Transaction Risk Analysis

## 📌 Project Overview

**FraudLens** is a MySQL-based database project designed to organize financial transaction data and highlight transactions that may require fraud-risk review. It connects customer, account, merchant, transaction, risk-rule, and fraud-alert information so that transaction activity can be examined from several angles.

The project uses illustrative sample records and rule-based alerts. An alert indicates that a transaction should be reviewed; it does **not** prove that fraud has occurred.

## 🎯 Project Objectives

- Store customer and account information in related tables.
- Maintain merchant details and merchant status.
- Record transactions, including amount, date, payment method, location, and status.
- Define configurable risk rules and maintain fraud-review alerts.
- Identify high-value transactions and activity associated with blocked merchants or frozen accounts.
- Summarize transaction values and counts using SQL.
- Demonstrate relational database design and practical MySQL querying techniques.

## 🛠️ Technologies Used

- **Database:** MySQL
- **Query language:** SQL
- **Main project file:** `fraudlens.sql`

## 🗄️ Database Structure

The SQL script creates the `fraudlens_db` database and defines six main tables.

### 1. `Customers`

Stores customer profile information.

- `customer_id` — primary key and unique customer identifier
- `customer_name` — customer name
- `email` — unique email address
- `phone` — optional unique phone number
- `city` — customer city
- `registration_date` — date the customer registered

### 2. `Accounts`

Stores accounts belonging to customers.

- `account_id` — primary key
- `customer_id` — links an account to a customer
- `account_number` — unique account number
- `account_type` — Savings, Current, or Salary
- `balance` — account balance
- `account_status` — Active, Frozen, or Closed
- `opened_date` — account opening date

The foreign key connects each account to a customer. Check constraints restrict account types, statuses, and negative balances.

### 3. `Merchants`

Stores merchant information used in transaction analysis.

- `merchant_id` — primary key
- `merchant_name` — merchant name
- `merchant_category` — business category
- `city` — merchant city
- `merchant_status` — Active, Under Review, or Blocked

### 4. `Risk_Rules`

Defines the example rules used to classify activity for review.

- `rule_id` — primary key
- `rule_name` — unique rule name
- `description` — explanation of the rule
- `threshold_amount` — optional amount threshold
- `risk_level` — Low, Medium, High, or Critical
- `is_active` — indicates whether a rule is active

The sample rules cover high-value transactions, unusual purchases, blocked merchants, frozen-account activity, and failed transactions.

### 5. `Transactions`

Stores financial transaction records.

- `transaction_id` — primary key
- `account_id` — account associated with the transaction
- `merchant_id` — associated merchant, when applicable
- `transaction_date` — date and time
- `transaction_type` — Transfer, Withdrawal, Deposit, or Purchase
- `amount` — transaction amount
- `payment_method` — UPI, Card, Net Banking, ATM, IMPS, or NEFT
- `transaction_status` — Completed, Pending, Failed, or Reversed
- `location_city` — city where the transaction was recorded
- `device_id` — device identifier recorded for the transaction

Foreign keys connect transactions to accounts and, where provided, merchants. Check constraints validate several allowed values and require a positive transaction amount.

### 6. `Fraud_Alerts`

Stores alerts raised for transactions that need review.

- `alert_id` — primary key
- `transaction_id` — transaction being reviewed
- `rule_id` — risk rule associated with the alert
- `alert_date` — date and time the alert was recorded
- `risk_level` — Low, Medium, High, or Critical
- `alert_status` — Open, Investigating, Resolved, or False Positive
- `notes` — explanation recorded for the alert

Foreign keys link each alert to its transaction and risk rule.

## 🔗 Table Relationships

- **Customers → Accounts:** one customer can have multiple accounts.
- **Accounts → Transactions:** one account can have multiple transactions.
- **Merchants → Transactions:** a merchant can be associated with multiple transactions; a transaction may have no merchant recorded.
- **Transactions → Fraud_Alerts:** a transaction can have associated alert records.
- **Risk_Rules → Fraud_Alerts:** a risk rule can be referenced by multiple alerts.

These relationships are implemented with primary keys and foreign keys to keep related records connected.

## ✨ Project Features

- Database and table creation
- Sample data for customers, accounts, merchants, risk rules, transactions, and alerts
- Filtering with `WHERE`, `BETWEEN`, `IN`, `LIKE`, and `IS NULL`
- Sorting with `ORDER BY` and limiting results with `LIMIT`
- Aggregate functions such as `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`
- Grouping and filtering grouped results with `GROUP BY` and `HAVING`
- String and date/time functions
- Conditional risk categorization using `CASE`
- `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and `CROSS JOIN`
- Full outer join simulation using `UNION`
- Subqueries and set operations using `UNION` and `UNION ALL`
- Common Table Expressions (CTEs)
- Window functions, including `DENSE_RANK()` and running totals
- Fraud-alert analysis by risk level and status
- A reusable `transaction_risk_report` view
- Indexes on transaction date, amount, and account/date
- Transaction control with `START TRANSACTION`, `ROLLBACK`, and an optional `COMMIT` example

## 📂 Project Structure

```text
FraudLens/
├── fraudlens.sql
└── README.md
```

## 🚀 How to Run the Project

### Step 1: Install MySQL

Install MySQL Server and open a MySQL-compatible SQL client such as MySQL Workbench.

### Step 2: Open the SQL script

Open `fraudlens.sql` in MySQL Workbench or another MySQL SQL editor.

### Step 3: Execute the script

Run the script to create `fraudlens_db`, create the six tables, insert the sample records, and execute the example queries.

You can also run the file from a terminal where the MySQL command-line client is installed:

```bash
mysql -u root -p < fraudlens.sql
```

Enter your MySQL password when prompted. If you use the command-line approach, the script's `SELECT` statements will print result sets in the terminal.

### Step 4: Select the database and inspect the tables

Run these statements in MySQL Workbench to inspect the sample data:

```sql
USE fraudlens_db;

SELECT * FROM Customers;
SELECT * FROM Accounts;
SELECT * FROM Merchants;
SELECT * FROM Risk_Rules;
SELECT * FROM Transactions;
SELECT * FROM Fraud_Alerts;
```

### Step 5: Review the transaction-risk report

After the script has created the view, run:

```sql
SELECT * FROM transaction_risk_report;
```

The view combines transaction data with customer and account details and includes merchant details where available.

**Note:** The script uses MySQL-specific syntax such as `AUTO_INCREMENT`, `USE`, `CURDATE()`, `FIELD()`, and MySQL-style view and index statements. Run it in MySQL; other database systems may require changes.

## 📊 Example SQL Queries

### 1. Find the five largest transactions

```sql
SELECT transaction_id, account_id, amount, transaction_date
FROM Transactions
ORDER BY amount DESC
LIMIT 5;
```

This sorts transactions from highest to lowest amount and returns up to five rows.

### 2. Classify transactions by amount

```sql
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
```

This query applies the example amount thresholds in the SQL script. The classification is a simple screening aid, not a complete fraud-detection model.

### 3. Review alerts with customer and rule details

```sql
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
ORDER BY FIELD(fa.risk_level, 'Critical', 'High', 'Medium', 'Low'),
         fa.alert_date DESC;
```

This joins the related tables to show who is associated with an alerted transaction, which rule was referenced, and the alert's current status.

### 4. Summarize transactions by payment method

```sql
SELECT
    payment_method,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM Transactions
GROUP BY payment_method
ORDER BY total_amount DESC;
```

This provides a simple overview of transaction volume and value for each payment method.

### 5. Find transactions linked to blocked merchants

```sql
SELECT
    t.transaction_id,
    m.merchant_name,
    t.amount,
    t.transaction_status
FROM Transactions t
JOIN Merchants m ON t.merchant_id = m.merchant_id
WHERE m.merchant_status = 'Blocked';
```

This identifies transactions associated with merchants marked as blocked in the sample data. It flags records for review rather than establishing that a transaction is fraudulent.

### 6. Rank transactions by amount

```sql
SELECT
    transaction_id,
    account_id,
    amount,
    DENSE_RANK() OVER (ORDER BY amount DESC) AS amount_rank
FROM Transactions;
```

This demonstrates a window function by ranking transactions from highest to lowest amount. Equal amounts receive the same rank.

## 📚 SQL Concepts Demonstrated

The project gives practice with:

- **DDL:** `CREATE DATABASE`, `CREATE TABLE`, `CREATE VIEW`, and `CREATE INDEX`
- **DML:** `INSERT` and `UPDATE`
- **DQL:** `SELECT`
- Primary keys, foreign keys, unique constraints, default values, and check constraints
- Filtering, sorting, and limiting rows
- Aggregate functions and grouped analysis
- Joins and subqueries
- `UNION` and `UNION ALL`
- CTEs and window functions
- Views and indexes
- Transactions and rollback operations

## ⚠️ Scope and Limitations

- The records are sample data included for learning and demonstration.
- The risk rules and amount thresholds are illustrative business rules.
- A fraud alert is a signal for investigation, not confirmation of fraud.
- The project does not implement a machine-learning model or real-time payment monitoring.
- The script's sample alerts are inserted explicitly; the SQL script does not automatically generate a new alert for every transaction that meets a risk condition.
- The example data should not be treated as real customer or banking information.

## 🔮 Possible Future Enhancements

- Add SQL procedures or triggers to evaluate configured risk rules automatically.
- Create reports for alert resolution time and false-positive rates.
- Add detection for repeated transactions within short time intervals.
- Compare transaction locations and device activity to identify unusual patterns.
- Add configurable thresholds and rule enable/disable controls to the alerting workflow.
- Create a dashboard for transaction and alert summaries.
- Add user roles and permissions for analysts and administrators.
- Test queries with a larger synthetic dataset and compare query performance before and after indexing.

## 👨‍💻 Author

Vana Ranjith Kumar

## 📄 License

This project is intended for educational and personal learning purposes. Add a specific open-source license if you want to distribute it under formal license terms.
