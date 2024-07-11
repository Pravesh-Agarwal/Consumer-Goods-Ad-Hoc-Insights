/*
	4. Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? 
    The final output contains these fields,
	segment
	product_count_2020
	product_count_2021
	difference
*/

WITH 
	count_2020 AS(
		SELECT 
			dp.segment, 
			COUNT( DISTINCT fsm.product_code ) AS product_count_2020
		FROM 
			dim_product dp
		JOIN 
			fact_sales_monthly fsm
				ON 
					dp.product_code = fsm.product_code
		WHERE 
			fsm.fiscal_year = 2020
		GROUP BY 
			dp.segment
    ), 
    count_2021 AS(
		SELECT 
			dp.segment, 
			COUNT( DISTINCT fsm.product_code ) AS product_count_2021
		FROM 
			dim_product dp
		JOIN 
			fact_sales_monthly fsm
				ON 
					dp.product_code = fsm.product_code
		WHERE 
			fsm.fiscal_year = 2021
		GROUP BY 
			dp.segment
    )
SELECT 
	c20.segment, c20.product_count_2020, 
    c21.product_count_2021, 
    ( c21.product_count_2021 - c20.product_count_2020 ) AS difference
FROM 
	count_2020 c20
JOIN 
	count_2021 c21
		ON 
			c20.segment = c21.segment
ORDER BY 
	difference DESC;