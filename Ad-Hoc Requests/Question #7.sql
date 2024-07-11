/*
	7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. 
    This analysis helps to get an idea of low and high-performing months and take strategic decisions.
	The final report contains these columns:
	Month
	Year
	Gross sales Amount
*/

SELECT 
	DATE_FORMAT( fsm.date, '%M (%Y)' ) AS Month, 
    fsm.fiscal_year AS Fiscal_Year, 
    ROUND( SUM( (fsm.sold_quantity * fgp.gross_price) ), 2 ) AS Gross_Sales_Amount
FROM 
	fact_sales_monthly fsm
JOIN 
	dim_customer dc
		ON
			dc.customer_code = fsm.customer_code
JOIN 
	fact_gross_price fgp
		ON 
			fgp.product_code = fsm.product_code
            AND 
            fgp.fiscal_year = fsm.fiscal_year
WHERE 
	dc.customer = 'Atliq Exclusive'
GROUP BY 
	Month, 
	Fiscal_Year
ORDER BY 
	Fiscal_Year;