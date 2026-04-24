# Data Dictionary for Gold Layer

## Overview
The Gold Layer is the business level data representation structured to support analytical and reporting use cases. 
It consists of **dimension tables** and **fact tables** for specific business metrics

### 1. gold.dim_customers
*  **Purpose:** Stores customer details enriched with demographic and geographic data.
*  **Columns:**

| Column Name | Data Type | Description|
|---|---|---|
| customer_key | INT | Surrogate key uniquely identifying each customer record in the customer dimension table |
| customer_id | INT | Unique numerical identifier assigned to each customer |
| customer_name | NVARCHAR(50) | The full name of the customer |
| postcode | INT | The customer's postal address |
| customer_state | NVARCHAR(50) | The state of residence for the customer (e.g. 'Queensland') |
| property_valuation | INT | The value of customer property |
| gender | NVARCHAR(50) | The gender of the customer (e.g. 'Male', 'Female', 'n/a') |
| purchased_history_3years| INT |The purchase history related to bike and accessories of the customer in three years |
| age | INT | The age of the customer |
|job_title| NVARCHAR(50) | The job title of customer at customer place of work (e.g Administrative Officer) |
|job_industry_category| NVARCHAR(50) | The industry which the customer job is (e.g Financial Services)|
|wealth_segment| NVARCHAR(50) | The category of customer's business with the company|
|owns_car| NVARCHAR(50) | If customer owns a car or not |
|customer_duration_in_years| TINYINT | The duration the customer has been with the company |


### 2.  gold.dim_products
*  **Purpose:** Provides information about the products and their attributes.
*  **Columns:**

| Column Name | Data Type | Description|
|---|---|---|
| product_key | INT | Surrogate key uniquely identifying each product record in the product dimension table
| product_id | INT | An identifier assigned to the product for internal tracking and referencing |
| brand | NVARCHAR(50) | The names of products (e.g Giant Bicycles) |
| product_line | NVARCHAR(50) | The specific product line or series to which the product belongs (e.g. Road, Mountain, Standard, Touring) |
| product_class | NVARCHAR(50) | The specific product class to which the product belong (e.g high, low, medium) |
| product_size | NVARCHAR(50) | The size of the product (e.g. large, medium, small) |
| standard_cost | INT | The cost or base price of the product in decimal currency units (e.g. 53.62) |
| product_first_sold_date| DATE | The first day the product was sold |


### 3.  gold.fact_transactions
*  **Purpose:** Stores transactional sales data for analytical purposes.
*  **Columns:**

| Column Name | Data Type | Description|
|---|---|---|
| transaction_id | INT | A unique numeric identifier for each transactions (e.g. '1', '2') |
| product_key | INT | Surrogate key linking the transactions to the product dimension table |
| customer_key | INT | Surrogate key linking the transactions to the customer dimension table |
| transaction_date | DATE | The date when the transaction was done |
| online_order | NVARCHAR(50) | If the customer ordered online or not |
| order_status | NVARCHAR(50) | If the customer ordered was approved or not |
| brand | NVARCHAR(50) | The names of products (e.g Giant Bicycles) |
| product_line | NVARCHAR(50) | The specific product line or series to which the product belongs (e.g. Road, Mountain, Standard, Touring) |
| product_class | NVARCHAR(50) | The specific product class to which the product belong (e.g high, low, medium) |
| product_size | NVARCHAR(50) | The size of the product (e.g. large, medium, small) |
| list_price | INT | The total monetary value of the sale for the product, in decimal currency units (e.g. 71.49) |
| standard_cost | INT | The cost or base price of the product, in decimal currency units (e.g. 53.62) |
| product_first_sold_date| DATE | The first day the product was sold |

