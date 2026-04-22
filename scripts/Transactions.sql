/*
=====================================
Data Exploration of Transactions
=====================================
Script Purpose:
  	This script explores the customer transactions, checks for nulls, formats columns,
	derive new columns, and transforms the data as well.

*/

-- preview of our table
SELECT *
FROM Transactions;
GO

-- count of customer data
SELECT COUNT(DISTINCT(customer_id))
FROM Transactions;
GO

-- counting NULL values
SELECT COUNT(*)
FROM Transactions
WHERE online_order IS NULL;
GO

-- checking the data type of the column(s)
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Transactions'
AND COLUMN_NAME = 'online_order';
GO

-- changing data type of the column(s)
ALTER TABLE Transactions
ALTER COLUMN online_order
varchar(5);
GO

-- changing values in the column(s)
UPDATE Transactions
SET online_order = 'FALSE'
WHERE online_order = '0';
GO

UPDATE Transactions
SET online_order = 'TRUE'
WHERE online_order = '1';
GO

-- formatting the list_price column to 2 decimal places
UPDATE Transactions
SET list_price = ROUND(list_price, 2);
GO

-- investigating NULL records
SELECT DISTINCT brand, product_line, product_class, product_size, list_price, standard_cost
FROM Transactions
ORDER BY list_price;
GO

-- removing NULL records that will affect analysis
DELETE FROM Transactions
WHERE standard_cost IS NULL;
GO

-- removing column not needed for analysis
ALTER TABLE Transactions
DROP COLUMN product_first_sold_date;
GO

-- =============================================================
-- Data Preparation
-- =============================================================

-- creating new table and populating it
ALTER TABLE Transactions
ADD profit AS list_price - standard_cost;
GO

-- ----------------------------------
-- Date manipulation
-- ----------------------------------

ALTER TABLE Transactions
ADD t_month AS DATENAME(MONTH, transaction_date);
GO

ALTER TABLE Transactions
ADD t_weekday AS DATENAME(WEEKDAY, transaction_date);
GO
  
ALTER TABLE Transactions
ADD t_week AS 'W' + DATENAME(WEEK, transaction_date);
GO

ALTER TABLE Transactions
ADD t_quarter AS 'Q' + DATENAME(QUARTER, transaction_date);
GO

-- ----------------------------------
-- getting total number of products
-- ----------------------------------
SELECT COUNT(DISTINCT(product_id)) AS Total_num_product
FROM Transactions;
GO

SELECT 
	AVG(profit) AS Average_profit, 
	MAX(profit) AS Maximum_profit, 
	MIN(profit) AS Minimum_profit,
	SUM(profit) AS Total_profit
FROM Transactions;
GO
