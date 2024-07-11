/*
	6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct 
    for the fiscal year 2021 and in the Indian market. 
    The final output contains these fields,
	customer_code
	customer
	average_discount_percentage
*/
WITH 
	pid21 AS(
		SELECT 
			customer_code, pre_invoice_discount_pct 
		FROM 
			fact_pre_invoice_deductions
		WHERE 
			fiscal_year = 2021
	),
    market AS(
		SELECT 
			customer, customer_code
		FROM 
			dim_customer
		WHERE 
			market = 'India'
    )
SELECT 
	dis.customer_code, 
    m.customer, 
    AVG(dis.pre_invoice_discount_pct) AS average_discount_percentage
FROM 
	pid21 dis
JOIN 
	market m
		ON 
			m.customer_code = dis.customer_code
GROUP BY 
	m.customer
ORDER BY 
	pre_invoice_discount_pct DESC
LIMIT 
	5;