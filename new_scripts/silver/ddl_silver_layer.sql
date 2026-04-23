-- ddl silver layer

IF OBJECT_ID ('silver.CustomerAddress', 'U') IS NOT NULL
    DROP TABLE silver.CustomerAddress;
GO

CREATE TABLE silver.CustomerAddress (
    customer_id         INT,
    customer_address    NVARCHAR(50),
    postcode            INT,
    customer_state      NVARCHAR(50),
    country             NVARCHAR(50),
    property_valuation  INT,
    db_create_date      DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.CustomerDemographic', 'U') IS NOT NULL
    DROP TABLE silver.CustomerDemographic;
GO

CREATE TABLE silver.CustomerDemographic (
    customer_id                 INT,
    customer_name               NVARCHAR(50),
    gender                      NVARCHAR(50),
    past_3_years_bike_related_purchases INT,
    DOB                         DATE,
    job_title                   NVARCHAR(50),
    job_industry_category       NVARCHAR(50),
    wealth_segment              NVARCHAR(50),
    deceased_indicator          NVARCHAR(3),
    owns_car                    NVARCHAR(3),
    tenure                      TINYINT,
    db_create_date              DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.Transactions', 'U') IS NOT NULL
    DROP TABLE silver.Transactions;
GO

CREATE TABLE silver.Transactions (
    transaction_id          INT,
    product_id              INT,
    customer_id             INT,
    transaction_date        DATE,
    online_order            NVARCHAR(50),
    order_status            NVARCHAR(50),
    brand                   NVARCHAR(50),
    product_line            NVARCHAR(50),
    product_class           NVARCHAR(50),
    product_size            NVARCHAR(50),
    list_price              FLOAT,
    standard_cost           FLOAT,
    product_first_sold_date DATE,
    db_create_date          DATETIME2 DEFAULT GETDATE()
);
GO


