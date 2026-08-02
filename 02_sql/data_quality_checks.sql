-- data quality checks

-- Verify Total Rows
SELECT COUNT(*) AS total_rows
FROM stg_retail_sales;

-- Verify Total Columns
SELECT COUNT(*) AS total_columns
FROM information_schema.columns
WHERE table_schema = DATABASE()
  AND table_name = 'stg_retail_sales';
  
-- Inspect Sample Records
SELECT *
FROM stg_retail_sales
LIMIT 10;

-- Check for Duplicate Rows
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM stg_retail_sales
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Check Complete Row Duplicates
SELECT
    order_id,
    customer_id,
    product_name,
    order_date,
    COUNT(*) AS duplicate_count
FROM stg_retail_sales
GROUP BY
    order_id,
    customer_id,
    product_name,
    order_date
HAVING COUNT(*) > 1;

-- Check NULL Values
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
FROM stg_retail_sales;

-- Check Blank Strings
SELECT
    SUM(TRIM(customer_name) = '') AS blank_customer_names,
    SUM(TRIM(product_name) = '') AS blank_products,
    SUM(TRIM(city) = '') AS blank_cities,
    SUM(TRIM(region) = '') AS blank_regions
FROM stg_retail_sales;

-- Check Data Types
DESCRIBE stg_retail_sales;

-- Profile Unique Values
-- Region 
SELECT DISTINCT region
FROM stg_retail_sales
ORDER BY region;
-- Order status
SELECT DISTINCT order_status
FROM stg_retail_sales
ORDER BY order_status;
-- Gender
SELECT DISTINCT gender
FROM stg_retail_sales
ORDER BY gender;
-- Payment Method
SELECT DISTINCT payment_method
FROM stg_retail_sales
ORDER BY payment_method;

-- Profile Mixed Date Formats
SELECT order_date
FROM stg_retail_sales
WHERE order_date IS NOT NULL
LIMIT 50;

SELECT
    CASE
        WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN 'YYYY-MM-DD'

        WHEN order_date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
            THEN 'DD/MM/YYYY or MM/DD/YYYY'

        WHEN order_date REGEXP '^[A-Za-z]+ [0-9]{1,2} [0-9]{4}$'
            THEN 'Month DD YYYY'

        ELSE 'Other'
    END AS date_format,
    COUNT(*) AS total_rows
FROM stg_retail_sales
GROUP BY date_format;

-- Validate Numeric Columns
-- Quantity
SELECT *
FROM stg_retail_sales
WHERE quantity <= 0;
-- Sales
SELECT *
FROM stg_retail_sales
WHERE sales_amount < 0;
-- Profit
SELECT *
FROM stg_retail_sales
WHERE profit IS NULL;
-- Discount
SELECT *
FROM stg_retail_sales
WHERE discount_pct < 0
   OR discount_pct > 1;
-- Shipping Days
SELECT *
FROM stg_retail_sales
WHERE days_to_ship < 0;

-- Validate Business Logic

SELECT
    order_id,
    quantity,
    unit_price,
    discount_pct,
    sales_amount,
    ROUND(quantity * unit_price * (1 - discount_pct / 100), 2) AS expected_sales
FROM stg_retail_sales
WHERE ABS(
    sales_amount -
    ROUND(quantity * unit_price * (1 - discount_pct / 100), 2)
) > 0.01;