SELECT *
FROM bronze.CustomerAddress;

SELECT *
FROM INFORMATION_SCHEMA.TABLES

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CustomerAddress'

-- check for nulls in PK
SELECT COUNT(*)
FROM bronze.CustomerAddress
WHERE customer_id IS NULL

SELECT *
FROM bronze.CustomerAddress
WHERE address IS NULL OR 
	  postcode IS NULL OR
	  state IS NULL OR
	  property_valuation IS NULL

-- checking for duplicate
SELECT 
	customer_id,
	COUNT(customer_id)
FROM bronze.CustomerAddress
GROUP BY customer_id
HAVING COUNT(customer_id) > 1

-- check for trailing or leading spaces
SELECT 
	COUNT(address)
FROM bronze.CustomerAddress
WHERE LEN(address) != LEN(TRIM(address))

-- checking for consistency
SELECT DISTINCT state,
	COUNT(state) AS total_customers
FROM bronze.CustomerAddress
GROUP BY state


 -- ======================================

SELECT *
FROM bronze.CustomerDemographic;

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CustomerDemographic'
	AND TABLE_SCHEMA = 'bronze';

-- checking the cardinality value in the column
SELECT 
	DISTINCT gender
FROM bronze.CustomerDemographic;

SELECT 
	DISTINCT deceased_indicator
FROM bronze.CustomerDemographic;

SELECT 
	DISTINCT owns_car
FROM bronze.CustomerDemographic;

-- checking nulls
SELECT 
	job_title,
	job_industry_category,
	wealth_segment,
	deceased_indicator
FROM bronze.CustomerDemographic
WHERE job_title IS NULL OR
	job_industry_category IS NULL OR
	wealth_segment IS NULL OR
	deceased_indicator IS NULL;

SELECT 
	DISTINCT tenure
FROM bronze.CustomerDemographic;

SELECT
	MAX(tenure) oldest_tenure,
	MIN(tenure) youngest_tenure
FROM (
	SELECT
	COALESCE(CAST(tenure AS tinyint), 0) AS tenure
	FROM bronze.CustomerDemographic)Y;


-- ======================================

SELECT * FROM bronze.Transactions;

SELECT COUNT(customer_id) FROM bronze.Transactions WHERE customer_id IS NULL;
SELECT COUNT(customer_id) FROM bronze.Transactions;
SELECT COUNT(DISTINCT customer_id) FROM bronze.Transactions;

-- investigating product IDs of 0
SELECT 
	product_id,
	COUNT(product_id)
FROM bronze.Transactions
GROUP BY product_id;

SELECT 
	*
FROM bronze.Transactions
WHERE product_id = 0 AND list_price = '311.54';


-- converting to date format ymd from dmy
SELECT transaction_date, TRY_CONVERT(DATE, transaction_date, 103) 
FROM bronze.Transactions;

-- Invstigating and identifying bad data
SELECT online_order, COUNT(online_order) FROM bronze.Transactions GROUP BY online_order;
SELECT order_status, COUNT(order_status) FROM bronze.Transactions GROUP BY order_status;
SELECT brand, COUNT(brand) FROM bronze.Transactions GROUP BY brand;
SELECT product_line, COUNT(product_line) FROM bronze.Transactions GROUP BY product_line;
SELECT product_class, COUNT( product_class) FROM bronze.Transactions GROUP BY product_class;
SELECT product_size, COUNT( product_size) FROM bronze.Transactions GROUP BY product_size;

SELECT * FROM bronze.Transactions WHERE online_order LIKE 'TrUD%';
SELECT * FROM bronze.Transactions WHERE online_order LIKE 'TPEE%';

SELECT * FROM bronze.Transactions WHERE order_status LIKE '100%';

SELECT * FROM bronze.Transactions WHERE brand LIKE '363%';
SELECT * FROM bronze.Transactions WHERE brand LIKE 'Giant Bicyc|es%';
SELECT * FROM bronze.Transactions WHERE brand IS NULL;

SELECT COUNT(*) FROM bronze.Transactions WHERE brand IS NULL;

SELECT * FROM bronze.Transactions WHERE transaction_id IN (2640, 2611);


-- formatting data type
SELECT
	TRY_CONVERT(FLOAT, RIGHT(standard_cost, LEN(standard_cost) -1)) AS standard_cost
FROM bronze.Transactions;

SELECT
	TRY_CAST(list_price AS FLOAT) AS list_price
FROM bronze.Transactions;

-- Checking and formatting date
SELECT
	product_first_sold_date,
    CAST(DATEADD(day, TRY_CONVERT(INT, product_first_sold_date) - 2, '1900-01-01') AS DATE) AS product_first_sold_date
FROM bronze.Transactions


USE BikesDB;


