-- preview of our table
SELECT *
FROM CustomerAddress;

-- count of customer data
SELECT COUNT(customer_id)
FROM CustomerAddress

-- checking for null
SELECT *
FROM CustomerAddress
WHERE postcode IS NULL --no null value found

-- checking the distinct values in the column(s)
SELECT DISTINCT(state)
FROM CustomerAddress

-- cleaning state column to be consistent
UPDATE  CustomerAddress
SET state = 'VIC'
WHERE state = 'Victoria';

UPDATE  CustomerAddress
SET state = 'NSW'
WHERE state = 'New South Wales';
