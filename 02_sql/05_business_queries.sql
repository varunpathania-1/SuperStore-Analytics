/*============================================================
business quries
Project : SuperStore Sales Analytics
Purpose : Business Intelligence Queries
===========================================================

============================================================
Section 1 :Executive KPIs
============================================================*/

-- total revenue
SELECT round(sum(sales_amount),2) as total_revenue
FROM retail_sales_cleaned;

-- total profit
select * from retail_sales_cleaned limit 10;
SELECT round(sum(profit),2) as total_profit
FROM retail_sales_cleaned;

-- profit margin percentage
SELECT round(sum(profit)/sum(sales_amount)*100,2) as profit_margin_percentage
FROM retail_sales_cleaned;

-- total orders
SELECT COUNT(distinct(order_id)) as total_orders
FROM retail_sales_cleaned;

-- total customers
SELECT COUNT(distinct(customer_id)) as total_customers
FROM retail_sales_cleaned;

-- average order value
SELECT round(sum(sales_amount)/count(distinct order_id),2) as average_order_value
FROM retail_sales_cleaned;

-- total quantity sold
SELECT sum(quantity) as total_quantity
FROM retail_sales_cleaned;

-- average discount
SELECT round(avg(discount_pct)*100,2) as average_discount_percentage
FROM retail_sales_cleaned;

-- average shipping time
SELECT round(avg(days_to_ship),2) as average_shipping_days
FROM retail_sales_cleaned;

-- return rate
SELECT round(sum(return_flag='True')/count(*)*100,2) as return_rate
FROM retail_sales_cleaned;

-- monthly sales trend
SELECT YEAR(order_date) as year, MONTH(order_date) as month, MONTHNAME(order_date) as month_name, round(sum(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY YEAR(order_date), MONTH(order_date), MONTHNAME(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);
    
-- yearly sales trends
SELECT YEAR(order_date) as year, ROUND(SUM(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY YEAR(order_date)
ORDER BY year;

-- Quarterly sales
SELECT YEAR(order_date) as year, QUARTER(order_date) as quarter, ROUND(SUM(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY YEAR(order_date), QUARTER(order_date)
ORDER BY year, quarter;
    
-- Sales by region
SELECT region, round(sum(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY region
ORDER BY total_sales desc;

--  Sales by city
SELECT city, round(sum(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY city
ORDER BY total_sales desc;

-- sales by category
SELECT product_category, round(sum(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY total_sales desc;

-- Top 10 products by sales
SELECT product_name, round(sum(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY total_sales desc 
limit 10;

-- bottom 10 products by sales
SELECT product_name, round(sum(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY total_sales 
limit 10;

-- Sales by payment method
SELECT payment_method, round(sum(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY payment_method
ORDER BY total_sales desc;

-- average sales per order
SELECT round(AVG(order_total),2) as average_sales_per_order
FROM
(
SELECT
order_id,
sum(sales_amount) as order_total
FROM retail_sales_cleaned
GROUP BY order_id
) AS orders;

-- total profit by region
SELECT region, round(sum(profit),2) as total_profit
FROM retail_sales_cleaned
GROUP BY region
ORDER BY total_profit DESC;

-- profit by product category
SELECT product_category, round(sum(profit),2) as total_profit
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY total_profit desc;

-- Top 10 profitable products
SELECT product_name, round(sum(profit),2) as total_profit
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY total_profit desc
limit 10;

-- bottom 10 profitable products
SELECT product_name, round(sum(profit),2) as total_profit
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY total_profit asc
limit 10;

-- profit margin by category
SELECT product_category,
round(sum(profit) / sum(sales_amount) * 100,2) as profit_margin_pct
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY profit_margin_pct DESC;

-- monthly profit trends
SELECT
YEAR(order_date) as year,
MONTH(order_date) as month,
MONTHNAME(order_date) as month_name,
ROUND(SUM(profit),2) as total_profit
FROM retail_sales_cleaned
GROUP BY
YEAR(order_date),
MONTH(order_date),
MONTHNAME(order_date)
ORDER BY year, month;
    
-- profit by city
SELECT city, round(sum(profit),2) as total_profit
FROM retail_sales_cleaned
GROUP BY city
ORDER BY total_profit desc;

-- average profit by order
SELECT round(AVG(order_profit),2) as avg_profit_per_order
FROM
(
SELECT
order_id,
sum(profit) as order_profit
    FROM retail_sales_cleaned
    GROUP BY order_id
) as order_summary;

-- products with negative profit
SELECT product_name, round(sum(profit),2) as total_profit
FROM retail_sales_cleaned
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- compare sales vs profit
SELECT product_category,
round(sum(sales_amount),2) as total_sales,
round(sum(profit),2) as total_profit,
round(sum(profit) / sum(sales_amount) * 100,2) as profit_margin_pct
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY total_sales desc;

-- Top 10 customers by sale
SELECT customer_id, customer_name,
round(sum(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY customer_id, customer_name
ORDER BY total_sales desc
LIMIT 10;

-- Top 10 customers by profit
SELECT customer_id, customer_name,
round(sum(profit),2) as total_profit
FROM retail_sales_cleaned
GROUP BY customer_id, customer_name
ORDER BY total_profit DESC
LIMIT 10;

-- Bottom 10 customers by profit
SELECT customer_id, customer_name,
round(sum(profit),2) as total_profit
FROM retail_sales_cleaned
GROUP BY customer_id, customer_name
ORDER BY total_profit
LIMIT 10;

-- Customer lifetime value(sales)
SELECT customer_id, customer_name,
round(sum(sales_amount),2) as lifetime_sales
FROM retail_sales_cleaned
GROUP BY customer_id, customer_name
ORDER BY lifetime_sales DESC;

-- Average order value by customer
SELECT customer_id, customer_name,
round(sum(sales_amount) / COUNT(DISTINCT order_id),2) as avg_order_value
FROM retail_sales_cleaned
GROUP BY customer_id, customer_name
ORDER BY avg_order_value DESC;

-- Repeat customers
SELECT customer_id, customer_name,
COUNT(DISTINCT order_id) as total_orders
FROM retail_sales_cleaned
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY total_orders DESC;

-- One time customers
SELECT customer_id, customer_name
FROM retail_sales_cleaned
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT order_id) = 1;

-- Customer satisfaction analysis
SELECT customer_satisfaction, COUNT(*) as total_orders
FROM retail_sales_cleaned
GROUP BY customer_satisfaction
ORDER BY customer_satisfaction DESC;

-- Customer satisfaction by region
SELECT region, round(AVG(customer_satisfaction),2) as avg_rating
FROM retail_sales_cleaned
GROUP BY region
ORDER BY avg_rating DESC;

-- customer segmentation
SELECT customer_id, customer_name,
round(sum(sales_amount),2) as total_sales,

CASE
WHEN SUM(sales_amount)>=5000 THEN 'Platinum'
WHEN SUM(sales_amount)>=3000 THEN 'Gold'
WHEN SUM(sales_amount)>=1500 THEN 'Silver'
ELSE 'Bronze'
END as customer_segment

FROM retail_sales_cleane
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC;

-- Top 10 Top selling products
SELECT product_name, sum(quantity) as total_quantity_sold
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Bottom 10 products by quantity sold
SELECT product_name, sum(quantity) as total_quantity_sold
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY total_quantity_sold ASC
LIMIT 10;

-- Highest revenue products
SELECT product_name, round(sum(sales_amount),2) as total_sales
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Highest profit products
SELECT product_name, round(sum(profit),2) as total_profit
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

-- Profit margin by product
SELECT product_name,
round(sum(profit) / sum(sales_amount) * 100,2) as profit_margin_pct
FROM retail_sales_cleaned
GROUP BY product_name
HAVING SUM(sales_amount) > 0
ORDER BY profit_margin_pct DESC;

-- Average selling price by product
SELECT product_name, round(avg(unit_price),2) as average_unit_price
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY average_unit_price DESC;

-- Return rate by product
SELECT product_name,
round(sum(
CASE WHEN return_flag = 'Yes' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) as return_rate_pct
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY return_rate_pct DESC;

-- Products with highest average discount
SELECT product_name,
round(avg(discount_pct) * 100,2) as average_discount_pct
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY average_discount_pct DESC;

-- Revenue vs Profit by product
SELECT product_name,
round(sum(sales_amount),2) as total_sales,
round(sum(profit),2) as total_profit,
round(sum(profit) / sum(sales_amount) * 100,2) as profit_margin_pct
FROM retail_sales_cleaned
GROUP BY product_name
HAVING SUM(sales_amount) > 0
ORDER BY total_sales DESC;

-- product performance score
SELECT product_name,
round(sum(sales_amount),2) as total_sales,
round(sum(profit),2) as total_profit,
sum(quantity) as total_quantity,
round(avg(discount_pct) * 100,2) as avg_discount_pct,
round(avg(customer_satisfaction),2) as avg_customer_rating
FROM retail_sales_cleaned
GROUP BY product_name
ORDER BY total_profit DESC, total_sales DESC;
    
    
-- Category Analysis
-- Sales by Category
SELECT
    product_category,
    ROUND(SUM(sales_amount),2) AS total_sales
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY total_sales DESC;

-- Profit by category
SELECT
    product_category,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY total_profit DESC;

-- Profit margin  by category
SELECT
    product_category,
    ROUND(
        SUM(profit) / SUM(sales_amount) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales_cleaned
GROUP BY product_category
HAVING SUM(sales_amount) > 0
ORDER BY profit_margin_pct DESC;

-- Quantity sold by cateory
SELECT
    product_category,
    SUM(quantity) AS total_quantity
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY total_quantity DESC;

-- Average discount by category
SELECT
    product_category,
    ROUND(AVG(discount_pct) * 100,2) AS average_discount_pct
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY average_discount_pct DESC;

-- Average customer satisfaction by category

SELECT
    product_category,
    ROUND(AVG(customer_satisfaction),2) AS avg_customer_rating
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY avg_customer_rating DESC;

-- Return rate by category
SELECT
    product_category,
    ROUND(
        SUM(CASE WHEN return_flag = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS return_rate_pct
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY return_rate_pct DESC;

-- Category oerformance dashboard
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

GROUP BY product_category

HAVING SUM(sales_amount) > 0

ORDER BY total_profit DESC;


-- Regional analysis
-- Sales by region
SELECT
    region,
    ROUND(SUM(sales_amount),2) AS total_sales
FROM retail_sales_cleaned
GROUP BY region
ORDER BY total_sales DESC;

-- Profit by region
SELECT
    region,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales_cleaned
GROUP BY region
ORDER BY total_profit DESC;

-- Profit margin by region
SELECT
    region,
    ROUND(
        SUM(profit) / SUM(sales_amount) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales_cleaned
GROUP BY region
HAVING SUM(sales_amount) > 0
ORDER BY profit_margin_pct DESC;

-- Top 10 cities by sales
SELECT
    city,
    ROUND(SUM(sales_amount),2) AS total_sales
FROM retail_sales_cleaned
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 cities by profit
SELECT
    city,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales_cleaned
GROUP BY city
ORDER BY total_profit DESC
LIMIT 10;

-- Customer satisfaction by region
SELECT
    region,
    ROUND(AVG(customer_satisfaction),2) AS avg_customer_rating
FROM retail_sales_cleaned
GROUP BY region
ORDER BY avg_customer_rating DESC;

-- Return rate by region
SELECT
    region,
    ROUND(
        SUM(CASE WHEN return_flag = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS return_rate_pct
FROM retail_sales_cleaned
GROUP BY region
ORDER BY return_rate_pct DESC;

-- Regionla performance dashboard
SELECT

    region,

    ROUND(SUM(sales_amount),2) AS total_sales,

    ROUND(SUM(profit),2) AS total_profit,

    SUM(quantity) AS quantity_sold,

    ROUND(
        SUM(profit)/SUM(sales_amount)*100,
        2
    ) AS profit_margin_pct,

    ROUND(AVG(discount_pct)*100,2) AS avg_discount_pct,

    ROUND(AVG(customer_satisfaction),2) AS avg_customer_rating,

    ROUND(
        SUM(CASE WHEN return_flag='Yes' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),
        2
    ) AS return_rate_pct

FROM retail_sales_cleaned

GROUP BY region

HAVING SUM(sales_amount) > 0

ORDER BY total_profit DESC;

-- shipping and logistics analysis
-- Average shipping time
SELECT
    ROUND(AVG(days_to_ship),2) AS avg_shipping_days
FROM retail_sales_cleaned;

-- Shipping time by region
SELECT
    region,
    ROUND(AVG(days_to_ship),2) AS avg_shipping_days
FROM retail_sales_cleaned
GROUP BY region
ORDER BY avg_shipping_days DESC;

-- Average shipping cost by region
SELECT
    region,
    ROUND(AVG(shipping_cost),2) AS avg_shipping_cost
FROM retail_sales_cleaned
GROUP BY region
ORDER BY avg_shipping_cost DESC;

-- Total shipping cost by category
SELECT
    product_category,
    ROUND(SUM(shipping_cost),2) AS total_shipping_cost
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY total_shipping_cost DESC;

-- Shipping cost as a Percentage of Sales
SELECT
    ROUND(
        SUM(shipping_cost) * 100.0 / SUM(sales_amount),
        2
    ) AS shipping_cost_pct
FROM retail_sales_cleaned
HAVING SUM(sales_amount) > 0;

-- Orders with highest shipping cost
SELECT
    order_id,
    customer_name,
    shipping_cost,
    sales_amount,
    profit
FROM retail_sales_cleaned
ORDER BY shipping_cost DESC
LIMIT 10;

-- Shipping cost vs profit by category
SELECT
    product_category,
    ROUND(SUM(shipping_cost),2) AS total_shipping_cost,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(
        SUM(shipping_cost) * 100.0 / SUM(profit),
        2
    ) AS shipping_to_profit_pct
FROM retail_sales_cleaned
GROUP BY product_category
HAVING SUM(profit) > 0
ORDER BY shipping_to_profit_pct DESC;

-- Shipping performance dashboard
SELECT

    region,

    ROUND(AVG(days_to_ship),2) AS avg_shipping_days,

    ROUND(SUM(shipping_cost),2) AS total_shipping_cost,

    ROUND(AVG(shipping_cost),2) AS avg_shipping_cost,

    ROUND(SUM(sales_amount),2) AS total_sales,

    ROUND(SUM(profit),2) AS total_profit,

    ROUND(
        SUM(shipping_cost) * 100.0 / SUM(sales_amount),
        2
    ) AS shipping_cost_pct

FROM retail_sales_cleaned

GROUP BY region

HAVING SUM(sales_amount) > 0

ORDER BY avg_shipping_days DESC;

-- Discount analysis
-- Average discount across all orders
SELECT
    ROUND(AVG(discount_pct) * 100,2) AS average_discount_pct
FROM retail_sales_cleaned;

-- Average discount by category
SELECT
    product_category,
    ROUND(AVG(discount_pct) * 100,2) AS average_discount_pct
FROM retail_sales_cleaned
GROUP BY product_category
ORDER BY average_discount_pct DESC;

-- Average discount by region
SELECT
    region,
    ROUND(AVG(discount_pct) * 100,2) AS average_discount_pct
FROM retail_sales_cleaned
GROUP BY region
ORDER BY average_discount_pct DESC;

-- Dsicount vs profit by category
SELECT
    product_category,
    ROUND(AVG(discount_pct) * 100,2) AS avg_discount_pct,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(
        SUM(profit) / SUM(sales_amount) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales_cleaned
GROUP BY product_category
HAVING SUM(sales_amount) > 0
ORDER BY avg_discount_pct DESC;

-- High discount orders
SELECT
    order_id,
    customer_name,
    product_name,
    sales_amount,
    discount_pct,
    profit
FROM retail_sales_cleaned
WHERE discount_pct >= 0.30
ORDER BY discount_pct DESC, sales_amount DESC;

-- Return rate by discount band
SELECT
    CASE
        WHEN discount_pct < 0.10 THEN '0–9%'
        WHEN discount_pct < 0.20 THEN '10–19%'
        WHEN discount_pct < 0.30 THEN '20–29%'
        ELSE '30%+'
    END AS discount_band,
    COUNT(*) AS total_orders,
    ROUND(
        SUM(CASE WHEN return_flag = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS return_rate_pct
FROM retail_sales_cleaned
GROUP BY discount_band
ORDER BY MIN(discount_pct);

-- Sales and profit by discount band
SELECT
    CASE
        WHEN discount_pct < 0.10 THEN '0–9%'
        WHEN discount_pct < 0.20 THEN '10–19%'
        WHEN discount_pct < 0.30 THEN '20–29%'
        ELSE '30%+'
    END AS discount_band,
    ROUND(SUM(sales_amount),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(
        SUM(profit) / SUM(sales_amount) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales_cleaned
GROUP BY discount_band
HAVING SUM(sales_amount) > 0
ORDER BY MIN(discount_pct);

-- Discount performance dashboard
SELECT
    product_category,
    ROUND(AVG(discount_pct) * 100,2) AS avg_discount_pct,
    ROUND(SUM(sales_amount),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND(
        SUM(profit) / SUM(sales_amount) * 100,
        2
    ) AS profit_margin_pct,
    ROUND(
        SUM(CASE WHEN return_flag = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS return_rate_pct
FROM retail_sales_cleaned
GROUP BY product_category
HAVING SUM(sales_amount) > 0
ORDER BY avg_discount_pct DESC;

-- Time intelligence
-- Monthly sales trend
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    ROUND(SUM(sales_amount),2) AS total_sales
FROM retail_sales_cleaned
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY
    year,
    month;
    
-- Monthly profit trend
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales_cleaned
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY
    year,
    month;
    
-- Quarterly sales
SELECT
    YEAR(order_date) AS year,
    QUARTER(order_date) AS quarter,
    ROUND(SUM(sales_amount),2) AS total_sales
FROM retail_sales_cleaned
GROUP BY
    YEAR(order_date),
    QUARTER(order_date)
ORDER BY
    year,
    quarter;
    
-- Quarterly profit
SELECT
    YEAR(order_date) AS year,
    QUARTER(order_date) AS quarter,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales_cleaned
GROUP BY
    YEAR(order_date),
    QUARTER(order_date)
ORDER BY
    year,
    quarter;
    
-- Yearly sales
SELECT
    YEAR(order_date) AS year,
    ROUND(SUM(sales_amount),2) AS total_sales
FROM retail_sales_cleaned
GROUP BY YEAR(order_date)
ORDER BY year;

-- Yearly profit
SELECT
    YEAR(order_date) AS year,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales_cleaned
GROUP BY YEAR(order_date)
ORDER BY year;

-- Best sales month
SELECT
    YEAR(order_date) AS year,
    MONTHNAME(order_date) AS month,
    ROUND(SUM(sales_amount),2) AS total_sales
FROM retail_sales_cleaned
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY total_sales DESC
LIMIT 1;

-- Best profit month
SELECT
    YEAR(order_date) AS year,
    MONTHNAME(order_date) AS month,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales_cleaned
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY total_profit DESC
LIMIT 1;

-- Average monthly sales
SELECT
    ROUND(AVG(monthly_sales),2) AS avg_monthly_sales
FROM (
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(sales_amount) AS monthly_sales
    FROM retail_sales_cleaned
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
) AS monthly_summary;

-- Average monthly profit
SELECT
    ROUND(AVG(monthly_profit),2) AS avg_monthly_profit
FROM (
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(profit) AS monthly_profit
    FROM retail_sales_cleaned
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
) AS monthly_summary;

-- Sales by day of week
SELECT
    DAYNAME(order_date) AS day_name,
    ROUND(SUM(sales_amount),2) AS total_sales
FROM retail_sales_cleaned
GROUP BY DAYNAME(order_date)
ORDER BY total_sales DESC;

-- Orders by month
SELECT
    YEAR(order_date) AS year,
    MONTHNAME(order_date) AS month,
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales_cleaned
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY
    year,
    MONTH(order_date);
    
-- Advanced window functions
-- rank products by sales
SELECT
    product_name,
    ROUND(SUM(sales_amount),2) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(sales_amount) DESC
    ) AS sales_rank
FROM retail_sales_cleaned
GROUP BY product_name;

-- Dense rank product
SELECT
    product_name,
    ROUND(SUM(sales_amount),2) AS total_sales,

    DENSE_RANK() OVER(
        ORDER BY SUM(sales_amount) DESC
    ) AS 'dense_rank'

FROM retail_sales_cleaned

GROUP BY product_name;

-- Row number by product
SELECT

product_name,

SUM(sales_amount) total_sales,

ROW_NUMBER() OVER(

ORDER BY SUM(sales_amount) DESC

) AS row_num

FROM retail_sales_cleaned

GROUP BY product_name;

-- Rank customer within region
SELECT

region,

customer_name,

ROUND(SUM(sales_amount),2) total_sales,

RANK() OVER(

PARTITION BY region

ORDER BY SUM(sales_amount) DESC

) AS regional_rank

FROM retail_sales_cleaned

GROUP BY
region,
customer_name;

-- Running total of sales
SELECT

order_date,

ROUND(SUM(sales_amount),2) daily_sales,

ROUND(

SUM(SUM(sales_amount))

OVER(

ORDER BY order_date

),

2

) AS running_sales

FROM retail_sales_cleaned

GROUP BY order_date

ORDER BY order_date;

-- Running pprofit
SELECT

order_date,

ROUND(SUM(profit),2) daily_profit,

ROUND(

SUM(SUM(profit))

OVER(

ORDER BY order_date

),

2

) AS running_profit

FROM retail_sales_cleaned

GROUP BY order_date;

-- Previous month sales
WITH monthly_sales AS (

SELECT

YEAR(order_date) year,

MONTH(order_date) month,

SUM(sales_amount) sales

FROM retail_sales_cleaned

GROUP BY
YEAR(order_date),
MONTH(order_date)

)

SELECT

year,

month,

sales,

LAG(sales)

OVER(

ORDER BY year,month

) previous_month_sales

FROM monthly_sales;

-- Month over month over growth
WITH monthly_sales AS (

SELECT

YEAR(order_date) year,

MONTH(order_date) month,

SUM(sales_amount) sales

FROM retail_sales_cleaned

GROUP BY
YEAR(order_date),
MONTH(order_date)

)

SELECT

year,

month,

sales,

ROUND(

(

sales-

LAG(sales)

OVER(

ORDER BY year,month

)

)

/

LAG(sales)

OVER(

ORDER BY year,month

)

*100

,2

)

AS mom_growth

FROM monthly_sales;

-- Next month sales
WITH monthly_sales AS (

SELECT

YEAR(order_date) year,

MONTH(order_date) month,

SUM(sales_amount) sales

FROM retail_sales_cleaned

GROUP BY
YEAR(order_date),
MONTH(order_date)

)

SELECT

*,

LEAD(sales)

OVER(

ORDER BY year,month

)

AS next_month_sales

FROM monthly_sales;

-- Rolling 3 month sales average
WITH monthly_sales AS (

SELECT

YEAR(order_date) year,

MONTH(order_date) month,

SUM(sales_amount) sales

FROM retail_sales_cleaned

GROUP BY
YEAR(order_date),
MONTH(order_date)

)

SELECT

year,

month,

sales,

ROUND(

AVG(sales)

OVER(

ORDER BY year,month

ROWS BETWEEN 2 PRECEDING
AND CURRENT ROW

),

2

)

AS rolling_3_month_avg

FROM monthly_sales;

-- Top products by category
WITH ranked_products AS (

SELECT

product_category,

product_name,

SUM(sales_amount) sales,

ROW_NUMBER()

OVER(

PARTITION BY product_category

ORDER BY SUM(sales_amount) DESC

) rn

FROM retail_sales_cleaned

GROUP BY
product_category,
product_name

)

SELECT *

FROM ranked_products

WHERE rn=1;

-- Highest profit customer by region
WITH ranked_customer AS (

SELECT

region,

customer_name,

SUM(profit) profit,

ROW_NUMBER()

OVER(

PARTITION BY region

ORDER BY SUM(profit) DESC

) rn

FROM retail_sales_cleaned

GROUP BY
region,
customer_name

)

SELECT *

FROM ranked_customer

WHERE rn=1;

-- Quartile analysis
SELECT

customer_name,

SUM(sales_amount) total_sales,

NTILE(4)

OVER(

ORDER BY SUM(sales_amount) DESC

)

AS sales_quartile

FROM retail_sales_cleaned

GROUP BY customer_name;

-- First order value per customer
SELECT

customer_name,

order_date,

sales_amount,

FIRST_VALUE(sales_amount)

OVER(

PARTITION BY customer_name

ORDER BY order_date

)

AS first_order_sales

FROM retail_sales_cleaned;

-- Latest order value
SELECT

customer_name,

order_date,

sales_amount,

LAST_VALUE(sales_amount)

OVER(

PARTITION BY customer_name

ORDER BY order_date

ROWS BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING

)

AS latest_order_sales

FROM retail_sales_cleaned;

-- Cusotmer purchase sequence
SELECT

customer_name,

order_date,

sales_amount,

ROW_NUMBER()

OVER(

PARTITION BY customer_name

ORDER BY order_date

)

AS purchase_number

FROM retail_sales_cleaned;

-- Common Table Expression
-- Monthly sales using cte
WITH monthly_sales AS (
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        ROUND(SUM(sales_amount),2) AS total_sales
    FROM retail_sales_cleaned
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)

SELECT *
FROM monthly_sales
ORDER BY year, month;

-- Top 5v customer using cte
WITH customer_sales AS (

SELECT

customer_id,

customer_name,

SUM(sales_amount) total_sales

FROM retail_sales_cleaned

GROUP BY
customer_id,
customer_name

)

SELECT *

FROM customer_sales

ORDER BY total_sales DESC

LIMIT 5;

-- Topm products per category
WITH ranked_products AS (

SELECT

product_category,

product_name,

SUM(sales_amount) total_sales,

ROW_NUMBER()

OVER(

PARTITION BY product_category

ORDER BY SUM(sales_amount) DESC

) rn

FROM retail_sales_cleaned

GROUP BY
product_category,
product_name

)

SELECT *

FROM ranked_products

WHERE rn=1;

-- MOnthly pprofit summary
WITH monthly_profit AS (

SELECT

YEAR(order_date) year,

MONTH(order_date) month,

SUM(profit) total_profit

FROM retail_sales_cleaned

GROUP BY
YEAR(order_date),
MONTH(order_date)

)

SELECT *

FROM monthly_profit

ORDER BY year,month;

-- Customer above average sales
WITH customer_sales AS (

SELECT

customer_id,

customer_name,

SUM(sales_amount) total_sales

FROM retail_sales_cleaned

GROUP BY
customer_id,
customer_name

),

average_sales AS (

SELECT AVG(total_sales) avg_sales

FROM customer_sales

)

SELECT

cs.*

FROM customer_sales cs

JOIN average_sales a

ON cs.total_sales>a.avg_sales;

-- Categories above average profit
WITH category_profit AS (

SELECT

product_category,

SUM(profit) total_profit

FROM retail_sales_cleaned

GROUP BY product_category

),

avg_profit AS (

SELECT AVG(total_profit) avg_profit

FROM category_profit

)

SELECT

cp.*

FROM category_profit cp

JOIN avg_profit ap

ON cp.total_profit>ap.avg_profit;

-- Regional sales contribution
WITH regional_sales AS (

SELECT

region,

SUM(sales_amount) total_sales

FROM retail_sales_cleaned

GROUP BY region

),

company_sales AS (

SELECT SUM(total_sales) grand_total

FROM regional_sales

)

SELECT

rs.region,

rs.total_sales,

ROUND(

rs.total_sales

/

cs.grand_total

*100

,2

)

AS contribution_pct

FROM regional_sales rs

CROSS JOIN company_sales cs;

-- Daily sales with running total
WITH daily_sales AS (

SELECT

order_date,

SUM(sales_amount) sales

FROM retail_sales_cleaned

GROUP BY order_date

)

SELECT

order_date,

sales,

SUM(sales)

OVER(

ORDER BY order_date

)

AS running_sales

FROM daily_sales;

-- Highest prfit product in each category
WITH ranked_products AS (

SELECT

product_category,

product_name,

SUM(profit) total_profit,

ROW_NUMBER()

OVER(

PARTITION BY product_category

ORDER BY SUM(profit) DESC

) rn

FROM retail_sales_cleaned

GROUP BY
product_category,
product_name

)

SELECT *

FROM ranked_products

WHERE rn=1;

-- Monthly kpi dashboard
WITH monthly_kpis AS (

SELECT

YEAR(order_date) year,

MONTH(order_date) month,

SUM(sales_amount) total_sales,

SUM(profit) total_profit,

COUNT(DISTINCT order_id) total_orders,

SUM(quantity) total_quantity

FROM retail_sales_cleaned

GROUP BY
YEAR(order_date),
MONTH(order_date)

)

SELECT

year,

month,

ROUND(total_sales,2) total_sales,

ROUND(total_profit,2) total_profit,

total_orders,

total_quantity,

ROUND(

total_profit

/

total_sales

*100

,2

)

AS profit_margin_pct

FROM monthly_kpis

ORDER BY year,month;

-- Advanced subqueries
-- Customer above average sales
SELECT
    customer_id,
    customer_name,
    ROUND(SUM(sales_amount),2) AS total_sales
FROM retail_sales_cleaned
GROUP BY
    customer_id,
    customer_name
HAVING SUM(sales_amount) >
(
    SELECT AVG(customer_sales)
    FROM
    (
        SELECT SUM(sales_amount) AS customer_sales
        FROM retail_sales_cleaned
        GROUP BY customer_id
    ) avg_table
);

-- Products with sales above average product sales
SELECT
    product_name,
    ROUND(SUM(sales_amount),2) AS total_sales
FROM retail_sales_cleaned
GROUP BY product_name
HAVING SUM(sales_amount) >
(
    SELECT AVG(product_sales)
    FROM
    (
        SELECT SUM(sales_amount) AS product_sales
        FROM retail_sales_cleaned
        GROUP BY product_name
    ) avg_products
)
ORDER BY total_sales DESC;

-- Most profitable category
SELECT
    product_category,
    ROUND(SUM(profit),2) AS total_profit
FROM retail_sales_cleaned
GROUP BY product_category
HAVING SUM(profit) =
(
    SELECT MAX(category_profit)
    FROM
    (
        SELECT
            SUM(profit) AS category_profit
        FROM retail_sales_cleaned
        GROUP BY product_category
    ) p
);

-- Customers with more orders than average
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales_cleaned
GROUP BY
    customer_id,
    customer_name
HAVING COUNT(DISTINCT order_id) >
(
    SELECT AVG(order_count)
    FROM
    (
        SELECT COUNT(DISTINCT order_id) AS order_count
        FROM retail_sales_cleaned
        GROUP BY customer_id
    ) t
);

-- Orders with sales greater than overall average
SELECT
    order_id,
    ROUND(SUM(sales_amount),2) AS order_sales
FROM retail_sales_cleaned
GROUP BY order_id
HAVING SUM(sales_amount) >
(
    SELECT AVG(order_sales)
    FROM
    (
        SELECT
            SUM(sales_amount) AS order_sales
        FROM retail_sales_cleaned
        GROUP BY order_id
    ) avg_orders
);

-- Products never returned
SELECT DISTINCT
    product_name
FROM retail_sales_cleaned p
WHERE NOT EXISTS
(
    SELECT 1
    FROM retail_sales_cleaned r
    WHERE
        r.product_name = p.product_name
        AND r.return_flag = 'Yes'
)
ORDER BY product_name;

-- Customers whoo ppurchased in multiple region
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT region) AS regions_purchased
FROM retail_sales_cleaned
GROUP BY
    customer_id,
    customer_name
HAVING COUNT(DISTINCT region) > 1;

-- Highest value order per customer
SELECT
    customer_id,
    customer_name,
    order_id,
    order_sales
FROM
(
    SELECT
        customer_id,
        customer_name,
        order_id,
        SUM(sales_amount) AS order_sales,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY SUM(sales_amount) DESC
        ) AS rn
    FROM retail_sales_cleaned
    GROUP BY
        customer_id,
        customer_name,
        order_id
) ranked_orders
WHERE rn = 1
ORDER BY order_sales DESC;

-- 