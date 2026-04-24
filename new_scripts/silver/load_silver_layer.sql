-- load silver layer
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME

    BEGIN TRY
        
        SET @batch_start_time = GETDATE();

        PRINT '==============================='
        PRINT 'Loading Silver Layer'
        PRINT '==============================='

        SET @start_time = GETDATE();

        PRINT '>> Truncate table: silver.CustomerAddress';
        TRUNCATE TABLE silver.CustomerAddress;
        
        PRINT '>> Inserting table: silver.CustomerAddress';
        INSERT INTO silver.CustomerAddress (
            customer_id,
            customer_address,
            postcode,
            customer_state,
            country,
            property_valuation
        )
        SELECT
            customer_id,
            address AS customer_address,
            postcode,
            CASE state
                WHEN 'VIC' THEN 'Victoria'
                WHEN 'NSW' THEN 'New South Wales'
                WHEN 'QLD' THEN 'Queensland'
                ELSE state
            END AS customer_state,
            country,
            property_valuation
        FROM bronze.CustomerAddress ;
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';
        PRINT '-----------------------------------';

        -- ================================================
        SET @start_time = GETDATE();

        PRINT '>> Truncate table: silver.CustomerAddress';
        TRUNCATE TABLE silver.CustomerDemographic;

        PRINT '>> Inserting table: silver.CustomerAddress';
        INSERT INTO silver.CustomerDemographic (
            customer_id,
            customer_name,
            gender,
            past_3_years_bike_related_purchases,
            DOB,
            job_title,
            job_industry_category,
            wealth_segment,
            deceased_indicator,
            owns_car,
            tenure   
        )
        SELECT
            customer_id,
            CONCAT(first_name, ' ', last_name) AS customer_name,
            CASE 
                WHEN upper(gender) IN ('F', 'FEMAL', 'FEMALE') THEN 'Female'
                WHEN upper(gender) IN ('M', 'MALE') THEN 'Male'
                WHEN UPPER(gender) = 'U' THEN 'Unknown'
                ELSE gender
            END AS gender,
            past_3_years_bike_related_purchases,
            TRY_CONVERT(DATE, DOB) AS DOB,
            TRIM(COALESCE(job_title, 'n/a')) AS job_title,
            TRIM(COALESCE(job_industry_category, 'n/a')) AS job_industry_category,
            TRIM(COALESCE(wealth_segment, 'n/a')) AS wealth_segment,
    
            CASE    
                WHEN UPPER(deceased_indicator) = 'N' THEN 'No'
                WHEN UPPER(deceased_indicator) = 'Y' THEN 'Yes'
                ELSE deceased_indicator
            END AS deceased_indicator,
            owns_car,
            COALESCE(CAST(tenure AS tinyint), 0) AS tenure
        FROM bronze.CustomerDemographic;
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';
        PRINT '-----------------------------------';

        -- ================================================
        SET @start_time = GETDATE();

        PRINT '>> Truncate table: silver.Transactions';
        TRUNCATE TABLE silver.Transactions;

        PRINT '>> Inserting table: silver.Transactions';

        WITH trans_error AS (
        SELECT *
        FROM bronze.Transactions
        WHERE brand IS NOT NULL AND transaction_id NOT IN (2611, 2640) 
            AND standard_cost NOT LIKE '$%[0-9].%' AND LEN(product_first_sold_date) != 5
            )

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

        INSERT INTO silver.Transactions (
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
            standard_cost,
            product_first_sold_date 
        )

        SELECT
            transaction_id,
            product_id,
            customer_id,
            CONVERT(DATE, transaction_date, 103) AS transaction_date,
            COALESCE(online_order, 'n/a'),
            order_status,
            brand,
            product_line,
            product_class,
            product_size,
            CAST(list_price AS DECIMAL(10,2)) AS list_price,
            CAST(REPLACE(standard_cost, '$', '') AS DECIMAL(10,2)) AS standard_cost,
            CAST(DATEADD(day, CONVERT(INT, product_first_sold_date) - 2, '1900-01-01') AS DATE) AS product_first_sold_date
        FROM bronze.Transactions
        WHERE brand IS NOT NULL 
              AND transaction_id NOT IN (2611, 2640)
              AND (
                    standard_cost LIKE '$%[0-9].%'
                    AND LEN(product_first_sold_date) = 5
                  )
        
        UNION ALL
        
        SELECT 
	        transaction_id,
            product_id,
            customer_id,
            CONVERT(DATE, transaction_date, 103) AS transaction_date,
            COALESCE(online_order, 'n/a'),
            order_status,
            brand,
            product_line,
            product_class,
            product_size,
            CAST(list_price AS DECIMAL(10,2)) AS list_price,
	        CAST(LEFT(REPLACE(REPLACE(combined_value, '"', ''), '$', ''), 7) AS DECIMAL(10,2)) AS standard_cost,
            CAST(DATEADD
                        (day, CONVERT(INT, 
                        RIGHT(REPLACE(REPLACE(combined_value, '"', ''), '$', ''), 5)
                                    ) - 2, '1900-01-01') 
            AS DATE) AS product_first_sold_date
        FROM error_combined;
        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';
        PRINT '-----------------------------------';

        SET @batch_end_time = GETDATE();
        PRINT '====================================';
        PRINT 'Loading Silver Layer is Completed';
        PRINT '     >> Total Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS VARCHAR) + 'seconds';
        PRINT '-----------------------------------';
    
    END TRY
    BEGIN CATCH
        PRINT '=====================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message ' + ERROR_MESSAGE();				
		PRINT 'Error Number ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=====================================================';
    END CATCH
END
GO

EXEC silver.load_silver;
GO

SELECT * FROM silver.CustomerAddress;
GO
SELECT * FROM silver.CustomerDemographic;
GO
SELECT * FROM silver.Transactions;
GO
