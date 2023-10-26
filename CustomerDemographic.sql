-- preview of our table
SELECT *
FROM CustomerDemographic

-- count of customer data
SELECT COUNT(customer_id)
FROM CustomerDemographic

-- checking for null
SELECT *
FROM CustomerDemographic
WHERE job_title IS NULL

SELECT *
FROM CustomerDemographic
WHERE DOB IS NULL

-- replacing NULL values wih n/a
UPDATE  CustomerDemographic
SET job_title = 'n/a'
WHERE job_title IS NULL;

--deleting NULL records 
DELETE FROM CustomerDemographic
WHERE DOB IS NULL

-- removing default column from table because it cannot be cleaned
ALTER TABLE CustomerDemographic
DROP COLUMN default;

-- checking the distinct values in the column(s)
SELECT DISTINCT(deceased_indicator)
FROM CustomerDemographic

SELECT DISTINCT(gender)
FROM CustomerDemographic

-- deleting records of deceased
DELETE FROM CustomerDemographic
WHERE deceased_indicator = 'Y'

-- cleaning gender column
UPDATE CustomerDemographic
SET gender = 'Female'
WHERE gender IN ('F', 'Femal')

UPDATE CustomerDemographic
SET gender = 'Male'
WHERE gender = 'M'

DELETE FROM CustomerDemographic
WHERE gender = 'U'

-- changing data type of column before updating it
ALTER TABLE CustomerDemographic
ALTER COLUMN owns_car
varchar(3);

-- cleaning owns_car column
UPDATE CustomerDemographic
SET owns_car = 'Yes'
WHERE owns_car = '1';

UPDATE CustomerDemographic
SET owns_car = 'No'
WHERE owns_car = '0';

-- create new column
ALTER TABLE CustomerDemographic
ADD age tinyint;

UPDATE CustomerDemographic
SET age = DATEDIFF(YEAR , DOB, GETDATE());

SELECT MAX(age) AS Maximum_age, --92
	MIN(age) AS Minimum_age, -- 21
	AVG(age) as Average_age -- 45
FROM CustomerDemographic;

-- creating new column for full name
ALTER TABLE CustomerDemographic
ADD fullname AS CONCAT(first_name, ' ',  last_name);

-- creating new column
ALTER TABLE CustomerDemographic
ADD full_name
varchar(50);

-- copying values only from computed column to new column
UPDATE CustomerDemographic
SET full_name=fullname;

-- removing unnecessary column(s)
ALTER TABLE CustomerDemographic
DROP COLUMN fullname, first_name, last_name;
