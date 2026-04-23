USE MASTER;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'BikesDB')
BEGIN
    ALTER DATABASE BikesDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BikesDB;
END;
GO

CREATE DATABASE BikesDB;
GO

USE BikesDB;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO


IF OBJECT_ID ('bronze.CustomerAddress', 'U') IS NOT NULL
    DROP TABLE bronze.CustomerAddress;
GO

CREATE TABLE bronze.CustomerAddress (
    customer_id         INT,
    address             NVARCHAR(50),
    postcode            INT,
    state               NVARCHAR(50),
    country             NVARCHAR(50),
    property_valuation  INT
);
GO


IF OBJECT_ID ('bronze.CustomerDemographic', 'U') IS NOT NULL
    DROP TABLE bronze.CustomerDemographic;
GO

CREATE TABLE bronze.CustomerDemographic (
    customer_id                 INT,
    first_name                  NVARCHAR(50),
    last_name                   NVARCHAR(50),
    gender                      NVARCHAR(50),
    past_3_years_bike_related_purchases INT,
    DOB                         NVARCHAR(50),
    job_title                   NVARCHAR(50),
    job_industry_category       NVARCHAR(50),
    wealth_segment              NVARCHAR(50),
    deceased_indicator          NVARCHAR(50),
    owns_car                    NVARCHAR(50),
    tenure                      NVARCHAR(50),
    defaults                    NVARCHAR(MAX)
);
GO


IF OBJECT_ID ('bronze.Transactions', 'U') IS NOT NULL
    DROP TABLE bronze.Transactions;
GO

CREATE TABLE bronze.Transactions (
    transaction_id          INT,
    product_id              INT,
    customer_id             INT,
    transaction_date        NVARCHAR(50),
    online_order            NVARCHAR(50),
    order_status            NVARCHAR(50),
    brand                   NVARCHAR(50),
    product_line            NVARCHAR(50),
    product_class           NVARCHAR(50),
    product_size            NVARCHAR(50),
    list_price              NVARCHAR(50),
    standard_cost           NVARCHAR(50),
    product_first_sold_date NVARCHAR(50)
);
GO

