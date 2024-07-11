/*
	10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? 
    The final output contains these
	fields,
	division
	product_code
	product
	total_sold_quantity
	rank_order
*/ 

WITH 
	division_sales_2021 AS(
		SELECT 
			dp.division, dp.product_code, 
            CONCAT( dp.product, ' (', dp.variant, ')') AS product, 
			SUM( fsm.sold_quantity ) AS total_sold_quantity
		FROM fact_sales_monthly fsm
		JOIN dim_product dp
				ON 
					fsm.product_code = dp.product_code
		WHERE 
			fsm.fiscal_year = 2021
		GROUP BY 
			division,
			dp.product_code,
			dp.product
	), 
	sales_rank_2021 AS(	
        SELECT 
			*, 
			DENSE_RANK() OVER( PARTITION BY division ORDER BY total_sold_quantity DESC ) AS rank_order
		FROM 
			division_sales_2021
	)
    SELECT 
		*
	FROM 
		sales_rank_2021
	WHERE 
		rank_order <= 3;