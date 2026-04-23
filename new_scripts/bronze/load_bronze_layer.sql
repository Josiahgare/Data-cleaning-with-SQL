CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		
		SET @batch_start_time = GETDATE();

		PRINT '=======================================';
		PRINT 'Loading data into Bronze layer';
		PRINT '=======================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncate table: bronze.CustomerAddress';
		TRUNCATE TABLE bronze.CustomerAddress;

		PRINT '>> Inserting data into bronze.CustomerAddress';
		BULK INSERT bronze.CustomerAddress
		FROM 'C:\Users\DELL\Downloads\SQL\BikesDB\dataset\CustomerAddress.csv'
		WITH (
			FIRSTROW = 3,
			FIELDTERMINATOR = ',',
			CODEPAGE = '65001',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';
		PRINT '-------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncate table: bronze.CustomerDemographic';
		TRUNCATE TABLE bronze.CustomerDemographic;


		PRINT '>> Inserting data into bronze.CustomerDemographic';
		BULK INSERT bronze.CustomerDemographic
		FROM 'C:\Users\DELL\Downloads\SQL\BikesDB\dataset\CustomerDemographic.csv'
		WITH (
			FIRSTROW = 3,
			FIELDTERMINATOR = ',',
			CODEPAGE = '65001',
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';
		PRINT '-------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncate table: bronze.Transactions';
		TRUNCATE TABLE bronze.Transactions;


		PRINT '>> Inserting data into bronze.Transactions';
		BULK INSERT bronze.Transactions
		FROM 'C:\Users\DELL\Downloads\SQL\BikesDB\dataset\Transactions.csv'
		WITH (
			FIRSTROW = 3,
			FIELDTERMINATOR = ',',
			CODEPAGE = '65001',
			MAXERRORS = 10000,
			KEEPNULLS,
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds';
		PRINT '-------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '======================================='
		PRINT 'Loading Bronze Layer is Completed'
		PRINT '		>> Total Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS VARCHAR) + 'seconds';
		PRINT '======================================='

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

EXEC bronze.load_bronze;
GO

USE BikesDB;