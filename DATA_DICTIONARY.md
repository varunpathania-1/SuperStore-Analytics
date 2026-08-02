# 📖 DATA_DICTIONARY.md

# SuperStore Sales Analytics – Data Dictionary

## Overview

This document describes every column in the final analytics dataset (`retail_sales_final.csv`). It serves as a reference for analysts, developers, and business stakeholders to understand the structure, meaning, and purpose of each field.

---

# Dataset Information

| Property     | Value                                                                        |
| ------------ | ---------------------------------------------------------------------------- |
| Dataset Name | retail_sales_final.csv                                                       |
| Source       | Retail Sales Dataset                                                         |
| Project      | SuperStore Sales Analytics                                                   |
| Purpose      | Business Intelligence & Sales Analytics                                      |
| Final Format | CSV                                                                          |
| Primary Key  | order_id (combined with product details if an order contains multiple items) |

---

# Column Dictionary

| Column Name           | Data Type     | Description                                | Example        |
| --------------------- | ------------- | ------------------------------------------ | -------------- |
| order_id              | VARCHAR       | Unique identifier for each customer order  | ORD100245      |
| customer_id           | VARCHAR       | Unique identifier for each customer        | CUST1023       |
| customer_name         | VARCHAR       | Customer's full name                       | John Smith     |
| gender                | VARCHAR       | Customer gender                            | Male           |
| age                   | INT           | Customer age                               | 32             |
| city                  | VARCHAR       | Customer city                              | New York       |
| state                 | VARCHAR       | Customer state                             | California     |
| region                | VARCHAR       | Business region where the order was placed | West           |
| order_date            | DATE          | Date the order was placed                  | 2024-03-15     |
| ship_date             | DATE          | Date the order was shipped                 | 2024-03-18     |
| days_to_ship          | INT           | Number of days between order and shipment  | 3              |
| shipping_mode         | VARCHAR       | Shipping method selected                   | Standard Class |
| shipping_cost         | DECIMAL(10,2) | Shipping cost for the order                | 18.50          |
| payment_method        | VARCHAR       | Payment method used                        | Credit Card    |
| order_status          | VARCHAR       | Current order status                       | Delivered      |
| product_id            | VARCHAR       | Unique product identifier                  | P10045         |
| product_name          | VARCHAR       | Product name                               | Office Chair   |
| product_category      | VARCHAR       | Product category                           | Furniture      |
| quantity              | INT           | Quantity purchased                         | 2              |
| unit_price            | DECIMAL(10,2) | Selling price per unit                     | 250.00         |
| discount_pct          | DECIMAL(5,2)  | Discount applied (decimal format)          | 0.20           |
| sales                 | DECIMAL(12,2) | Total sales amount                         | 400.00         |
| profit                | DECIMAL(12,2) | Profit earned from the order               | 80.00          |
| return_flag           | VARCHAR       | Indicates whether the order was returned   | Yes            |
| customer_satisfaction | INT           | Customer satisfaction rating (1–5)         | 4              |

---

# Engineered Features

The following columns were created during the **Feature Engineering** phase using Python.

| Column Name             | Data Type | Description                                                          |
| ----------------------- | --------- | -------------------------------------------------------------------- |
| year                    | INT       | Order year extracted from order_date                                 |
| quarter                 | INT       | Quarter extracted from order_date                                    |
| month                   | INT       | Month number                                                         |
| month_name              | VARCHAR   | Month name                                                           |
| day_name                | VARCHAR   | Day of the week                                                      |
| week                    | INT       | ISO week number                                                      |
| profit_margin_pct       | DECIMAL   | Profit divided by sales × 100                                        |
| profit_category         | VARCHAR   | Indicates Profit or Loss                                             |
| profit_band             | VARCHAR   | Profit grouped into business bands                                   |
| discount_percentage     | DECIMAL   | Discount converted to percentage                                     |
| discount_band           | VARCHAR   | Discount grouped into ranges                                         |
| customer_lifetime_sales | DECIMAL   | Total sales generated by each customer                               |
| customer_segment        | VARCHAR   | Customer segment (Bronze, Silver, Gold, Platinum)                    |
| customer_orders         | INT       | Number of unique orders placed by a customer                         |
| shipping_days           | INT       | Shipping duration in days                                            |
| shipping_performance    | VARCHAR   | Shipping classified as Fast or Slow                                  |
| average_selling_price   | DECIMAL   | Sales divided by quantity                                            |
| high_value_order        | VARCHAR   | Indicates whether the order value exceeds the business threshold     |
| order_size              | VARCHAR   | Order grouped into Small, Medium, Large, or Enterprise               |
| is_returned             | INT       | Binary return flag (1 = Returned, 0 = Not Returned)                  |
| satisfaction_level      | VARCHAR   | Customer satisfaction grouped into Poor, Average, Good, or Excellent |

---

# Data Quality Rules

The dataset follows the following validation rules:

* `order_id` should never be NULL.
* `customer_id` should never be NULL.
* `sales` must be greater than or equal to 0.
* `quantity` must be greater than 0.
* `unit_price` must be greater than 0.
* `discount_pct` must be between 0 and 1.
* `days_to_ship` must be greater than or equal to 0.
* `customer_satisfaction` must be between 1 and 5.
* `return_flag` must contain only **True** or **False**.

---

# Business KPIs Derived

The dataset supports the calculation of the following business metrics:

* Total Sales
* Total Profit
* Profit Margin %
* Average Order Value (AOV)
* Customer Lifetime Value (CLV)
* Repeat Customer Rate
* Return Rate
* Average Shipping Time
* Sales by Region
* Sales by Category
* Monthly Sales Trend
* Quarterly Sales Trend
* Year-over-Year Growth
* Discount Analysis
* Customer Segmentation
* Product Performance
* Regional Performance

---

# Data Pipeline

```text
Raw CSV
   │
   ▼
SQL Database
   │
   ▼
Data Cleaning & Validation
   │
   ▼
Python Feature Engineering
   │
   ▼
retail_sales_final.csv
   │
   ▼
Power BI Dashboard
```

---

# Notes

* This dataset was cleaned using SQL before being validated and enriched in Python.
* Additional business features were engineered to support advanced analytics and interactive Power BI dashboards.
* The final dataset is intended for business reporting, dashboarding, and interview-ready analytics demonstrations.
