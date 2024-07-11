/*
	9. Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? 
    The final output contains these fields,
	channel
	gross_sales_mln
	percentage
*/

WITH 
	channel_sales_2021 AS(
		SELECT 
			dc.channel, 
			ROUND( SUM( (fsm.sold_quantity * fgp.gross_price) / 1000000 ), 2 ) AS gross_sales_mln
		FROM 
			fact_sales_monthly fsm
		JOIN 
			dim_customer dc
				ON 
					fsm.customer_code = dc.customer_code
		JOIN 
			fact_gross_price fgp
				ON 
					fsm.product_code = fgp.product_code
					AND
					fsm.fiscal_year = fgp.fiscal_year
		WHERE 
			fsm.fiscal_year = 2021
		GROUP BY 
			dc.channel
		ORDER BY 
			gross_sales_mln DESC
	), 
    total_sales_2021 AS(
		SELECT 
			SUM(gross_sales_mln) AS total_gross_sales_mln
		FROM 
			channel_sales_2021
    )
SELECT 
	cs21.channel, 
    CONCAT( cs21.gross_sales_mln, 'M' ) AS gross_sales_mln,
    CONCAT( ROUND( ( (cs21.gross_sales_mln * 100) / ts21.total_gross_sales_mln ), 2 ), '%' ) AS percentage
FROM 
	channel_sales_2021 cs21, 
    total_sales_2021 ts21;
