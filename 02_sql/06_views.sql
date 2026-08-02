-- SQL views

-- Executive KPI view
CREATE OR REPLACE VIEW vw_executive_kpis AS

SELECT

    ROUND(SUM(sales_amount),2) AS total_sales,

    ROUND(SUM(profit),2) AS total_profit,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_id) AS total_customers,

    SUM(quantity) AS total_quantity,

    ROUND(
        SUM(profit)/SUM(sales_amount)*100,
        2
    ) AS profit_margin_pct

FROM retail_sales_cleaned;


SELECT *
FROM vw_executive_kpis;



-- Monthly sales view
CREATE OR REPLACE VIEW vw_monthly_sales AS

SELECT

    YEAR(order_date) AS year,

    MONTH(order_date) AS month,

    MONTHNAME(order_date) AS month_name,

    ROUND(SUM(sales_amount),2) AS total_sales,

    ROUND(SUM(profit),2) AS total_profit,

    COUNT(DISTINCT order_id) AS total_orders

FROM retail_sales_cleaned

GROUP BY

    YEAR(order_date),

    MONTH(order_date),

    MONTHNAME(order_date);
    
    
select * from vw_monthly_sales;


-- Customer performance view
CREATE OR REPLACE VIEW vw_customer_performance AS

SELECT

    customer_id,

    customer_name,

    ROUND(SUM(sales_amount),2) AS total_sales,

    ROUND(SUM(profit),2) AS total_profit,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(sales_amount)/COUNT(DISTINCT order_id),
        2
    ) AS average_order_value

FROM retail_sales_cleaned

GROUP BY

    customer_id,

    customer_name;
    

select * from vw_customer_performance;


-- Product performance view
CREATE OR REPLACE VIEW vw_product_performance AS

SELECT

    product_category,

    product_name,

    ROUND(SUM(sales_amount),2) AS total_sales,

    ROUND(SUM(profit),2) AS total_profit,

    SUM(quantity) AS quantity_sold,

    ROUND(AVG(discount_pct)*100,2) AS avg_discount_pct

FROM retail_sales_cleaned

GROUP BY

    product_category,

    product_name;


select * from vw_product_performance;


-- Regional performance view
CREATE OR REPLACE VIEW vw_regional_performance AS

SELECT

    region,

    ROUND(SUM(sales_amount),2) AS total_sales,

    ROUND(SUM(profit),2) AS total_profit,

    ROUND(
        SUM(profit)/SUM(sales_amount)*100,
        2
    ) AS profit_margin_pct,

    ROUND(AVG(customer_satisfaction),2) AS avg_customer_rating

FROM retail_sales_cleaned

GROUP BY region;


select * from vw_regional_performance;


-- Category performance view
CREATE OR REPLACE VIEW vw_category_performance AS

SELECT

    product_category,

    ROUND(SUM(sales_amount),2) AS total_sales,

    ROUND(SUM(profit),2) AS total_profit,

    SUM(quantity) AS quantity_sold,

    ROUND(
        SUM(profit)/SUM(sales_amount)*100,
        2
    ) AS profit_margin_pct,

    ROUND(AVG(discount_pct)*100,2) AS avg_discount_pct,

    ROUND(AVG(customer_satisfaction),2) AS avg_customer_rating

FROM retail_sales_cleaned

GROUP BY product_category;


select * from vw_category_performance;