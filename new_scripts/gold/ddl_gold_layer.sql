/*
==============================================================================================
DDL Script: Create Gold VIEWs
==============================================================================================
Script Purpose:
    This Script creates views for the Gold layer in the data warehouse.
	The Gold layer represent the final dimension and fact tables (Star Schema)

	Each view performs transformations and combines data from silver layer to
	produce a clean, enriched,and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting
==============================================================================================
*/

-- ====================================================================================
-- Create Dimension: gold.dim_customers
-- ====================================================================================

DROP VIEW IF EXISTS gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY ca.customer_id) AS customer_key,
    ca.customer_id,
    cd.customer_name,
    ca.postcode,
    ca.customer_state,
    ca.property_valuation,
    cd.gender,
    cd.past_3_years_bike_related_purchases AS purchase_history_3years,
    DATEDIFF(year, cd.DOB, GETDATE()) AS age,
    cd.job_title,
    cd.job_industry_category,
    cd.wealth_segment,
    cd.owns_car,
    cd.tenure AS customer_duration_in_years   
FROM silver.CustomerAddress ca
LEFT JOIN silver.CustomerDemographic cd
ON ca.customer_id = cd.customer_id
WHERE cd.deceased_indicator = 'No'
;
GO

-- ====================================================================================
-- Create Dimension: gold.dim_products
-- ====================================================================================

DROP VIEW IF EXISTS gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
WITH rank_product AS (
SELECT 
    product_id,
    brand,
    product_line,
    product_class,
    product_size,
    standard_cost,
    product_first_sold_date,
    ROW_NUMBER() OVER (
                    PARTITION BY 
                                product_id,
                                brand,
                                product_line,
                                product_class,
                                product_size 
                    ORDER BY product_first_sold_date) AS flag
FROM silver.Transactions
)

SELECT 
    ROW_NUMBER() OVER (ORDER BY product_id, brand, product_line, product_class, product_size) AS product_key,
    product_id,
    brand,
    product_line,
    product_class,
    product_size,
    standard_cost,
    product_first_sold_date
FROM rank_product
WHERE flag = 1
;
GO

-- ====================================================================================
-- Create Fact: gold.fact_transactions
-- ====================================================================================

DROP VIEW IF EXISTS gold.fact_transactions;
GO

CREATE VIEW gold.fact_transactions AS 
SELECT
    t.transaction_id,
    p.product_key,
    c.customer_key,
    t.transaction_date,
    t.online_order,
    t.order_status,
    t.brand,
    t.product_line,
    t.product_class,
    t.product_size,
    t.list_price,
    t.standard_cost,
    t.product_first_sold_date
FROM silver.Transactions t
LEFT JOIN gold.dim_products p
ON t.product_id = p.product_id
    AND t.brand = p.brand
    AND t.product_line = p.product_line
    AND t.product_class = p.product_class
    AND t.product_size = p.product_size
LEFT JOIN gold.dim_customers c
ON t.customer_id = c.customer_id
;
GO

-- checking VIEWs
SELECT * FROM gold.dim_customers;
SELECT * FROM gold.dim_products
SELECT * FROM gold.fact_transactions;

