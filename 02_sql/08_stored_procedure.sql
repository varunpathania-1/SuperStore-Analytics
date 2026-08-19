-- Stored procedure adn user defined functioons

-- Stored procedure: Executive KPI dashboard
DELIMITER $$
CREATE PROCEDURE sp_executive_kpis()

BEGIN

SELECT
ROUND(SUM(sales_amount),2) AS total_sales,
ROUND(SUM(profit),2) AS total_profit,
COUNT(DISTINCT order_id) total_orders,
COUNT(DISTINCT customer_id) total_customers,
ROUND(SUM(profit)/SUM(sales_amount)*100,2) AS profit_margin_pct
FROM retail_sales_cleaned;
END $$
DELIMITER ;
CALL sp_executive_kpis();


-- Stores Procedure: Sales by region
DELIMITER $$
CREATE PROCEDURE sp_sales_by_region()

BEGIN

SELECT region,
ROUND(SUM(sales_amount),2) total_sales,
ROUND(SUM(profit),2) total_profit
FROM retail_sales_cleaned
GROUP BY region
ORDER BY total_sales DESC;
END $$
DELIMITER ;
CALL sp_sales_by_region();


-- Parameterised stored procedure
DELIMITER $$
CREATE PROCEDURE sp_region_summary(IN p_region VARCHAR(50))

BEGIN

SELECT region,
ROUND(SUM(sales_amount),2) total_sales,
ROUND(SUM(profit),2) total_profit,
SUM(quantity) quantity_sold
FROM retail_sales_cleaned
WHERE region=p_region
GROUP BY region;
END $$
DELIMITER ;
CALL sp_region_summary('North');


-- User defined function
DELIMITER $$

CREATE FUNCTION fn_profit_margin(sales_amount DECIMAL(12,2),profit DECIMAL(12,2))
RETURNS DECIMAL(8,2)
DETERMINISTIC

BEGIN

RETURN ROUND(profit/sales_amount*100,2);
END $$
DELIMITER ;
SELECT sales_amount, profit, fn_profit_margin(sales_amount,profit)
FROM retail_sales_cleaned
LIMIT 10;


-- Procedure: Monthly Sales Report
DELIMITER $$

CREATE PROCEDURE sp_monthly_sales()
  
BEGIN

SELECT
YEAR(order_date) year,
MONTHNAME(order_date) month,
ROUND(SUM(sales_amount),2) total_sales,
ROUND(SUM(profit),2) total_profit
FROM retail_sales_cleaned
GROUP BY
YEAR(order_date),
MONTH(order_date),
MONTHNAME(order_date)
ORDER BY year, MONTH(order_date);
END $$
DELIMITER ;
CALL sp_monthly_sales();


-- Procedure: Top N customers
DELIMITER $$
CREATE PROCEDURE sp_top_customers (IN p_limit INT)

BEGIN
 
SELECT customer_id, customer_name,
ROUND(SUM(sales_amount),2) total_sales
FROM retail_sales_cleaned
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC
LIMIT p_limit;
END $$
DELIMITER ;
CALL sp_top_customers(10);
