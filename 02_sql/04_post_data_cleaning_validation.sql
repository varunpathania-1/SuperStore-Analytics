-- data cleaning validation

-- rows count
SELECT COUNT(*)
FROM retail_sales_cleaned;

-- dulpicate check
SELECT order_id,
COUNT(*)
FROM retail_sales_cleaned
GROUP BY order_id
HAVING COUNT(*)>1;

-- null check
SELECT
SUM(order_id IS NULL) AS order_id_nulls,
SUM(order_date IS NULL) AS order_date_nulls,
SUM(customer_id IS NULL) AS customer_id_nulls,
SUM(customer_name IS NULL) AS customer_name_nulls,
SUM(age IS NULL) AS age_nulls,
SUM(gender IS NULL) AS gender_nulls,
SUM(region IS NULL) AS region_nulls,
SUM(city IS NULL) AS city_nulls,
SUM(product_name IS NULL) AS product_name_nulls,
SUM(product_category IS NULL) AS category_nulls,
SUM(quantity IS NULL) AS quantity_nulls,
SUM(unit_price IS NULL) AS unit_price_nulls,
SUM(discount_pct IS NULL) AS discount_pct_nulls,
SUM(sales_amount IS NULL) AS sales_nulls,
SUM(profit IS NULL) AS profit_nulls,
SUM(shipping_cost IS NULL) AS shipping_cost_nulls,
SUM(payment_method IS NULL) AS payment_method_nulls,
SUM(customer_satisfaction IS NULL) AS customer_satisfaction_nulls,
SUM(return_flag IS NULL) AS return_flag_nulls,
SUM(order_status IS NULL) AS order_status_nulls,
SUM(days_to_ship IS NULL) AS days_to_ship_nulls
FROM retail_sales_cleaned;

-- blank string
SELECT
SUM(TRIM(customer_name)='') customer_name,
SUM(TRIM(city)='') city,
SUM(TRIM(product_name)='') product
FROM retail_sales_cleaned;

-- date validation
SELECT
MIN(order_date),
MAX(order_date)
FROM retail_sales_cleaned;

-- gender validation
SELECT gender,
COUNT(*)
FROM retail_sales_cleaned
GROUP BY gender;

-- region validation
SELECT
DISTINCT region
FROM retail_sales_cleaned;

-- numeric rules validation
SELECT *
FROM retail_sales_cleaned
WHERE quantity<=0;

-- shipping days validation
SELECT *
FROM retail_sales_cleaned
WHERE days_to_ship<0;

-- discount validation
SELECT *
FROM retail_sales_cleaned
WHERE discount_pct<0
OR discount_pct>1;

-- data profiling
SELECT
COUNT(*) TotalRows,
COUNT(DISTINCT order_id) Orders,
COUNT(DISTINCT customer_id) Customers,
COUNT(DISTINCT product_name) Products
FROM retail_sales_cleaned;
