--USE BikesDB;
WITH trans_error AS (
SELECT *
FROM bronze.Transactions
WHERE brand IS NOT NULL AND transaction_id NOT IN (2611, 2640) 
    AND standard_cost NOT LIKE '$%[0-9].%' AND LEN(product_first_sold_date) != 5)

, error_combined AS (
SELECT 
	transaction_id,
    product_id,
    customer_id,
    transaction_date,
    online_order,
    order_status,
    brand,
    product_line,
    product_class,
    product_size,
    list_price,
	CASE
		WHEN standard_cost LIKE ('"%') THEN standard_cost + product_first_sold_date
		ELSE standard_cost
	END AS combined_value
FROM trans_error)

SELECT 
	transaction_id,
    product_id,
    customer_id,
    transaction_date,
    online_order,
    order_status,
    brand,
    product_line,
    product_class,
    product_size,
    CAST(list_price AS DECIMAL(10,2)) AS list_price,
	CAST(LEFT(REPLACE(REPLACE(combined_value, '"', ''), '$', ''), 7) AS DECIMAL(10,2))AS standard_cost,
    CAST(DATEADD
                (day, CONVERT(INT, 
                RIGHT(REPLACE(REPLACE(combined_value, '"', ''), '$', ''), 5)
                            ) - 2, '1900-01-01') 
    AS DATE) AS product_first_sold_date
FROM error_combined;

SELECT 
    SUM(standard_cost),
    SUM(list_price)
FROM silver.Transactions 
GROUP BY brand

SELECT *
FROM silver.Transactions t
LEFT JOIN gold.dim_products p
ON t.product_id = p.product_id
AND t.brand = p.brand
AND t.product_line = p.product_line
AND t.product_class = p.product_class
AND t.product_size = p.product_size
WHERE p.product_key IS NULL;