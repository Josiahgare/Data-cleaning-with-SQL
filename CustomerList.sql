
-- creating new table
SELECT CD.customer_id, CD.full_name, CD.gender, CD.age, CD.DOB,CA.address, CA.postcode, 
	CA.state, CA.country, CD.wealth_segment, CD.job_industry_category, CD.job_title, 
	CD.owns_car, CD.past_3_years_bike_related_purchases, CD.tenure, CA.property_valuation
INTO CustomerList
FROM CustomerDemographic CD
LEFT JOIN CustomerAddress CA ON CD.customer_id = CA.customer_id;

SELECT *
FROM CustomerList
ORDER BY customer_id;

-- removing records with address
DELETE FROM CustomerList
WHERE state IS NULL;
