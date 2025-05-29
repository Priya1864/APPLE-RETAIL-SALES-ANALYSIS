# APPLE-RETAIL-SALES-ANALYSIS

## Project Description

The Apple Retail Sales Analysis Project is a comprehensive, real-time analytics solution focused on analyzing product sales and warranty claims across Apple stores globally. With over 1 million sales transactions and 250,000 warranty claims, this project simulates a real-world business intelligence environment.

The project enables deep insights into store performance, product sales, warranty issues, pricing, and customer behavior using structured SQL queries and visual dashboards.

---

## Dataset Overview

| Table Name | Description                         | Records     |
|------------|-------------------------------------|-------------|
| category   | Product categories                  | 10          |
| store      | Store details (global locations)    | 165         |
| products   | Apple products                      | 164         |
| sales      | Retail sales transactions           | 1,000,000   |
| warranty   | Product warranty claims             | 250,000     |

---

## Database Schema

### Table: category
- category_id (Primary Key)
- category_name

### Table: store
- store_id (Primary Key)
- store_name
- city
- country

### Table: products
- product_id (Primary Key)
- product_name
- category_id (Foreign Key referencing category)
- launch_date
- price

### Table: sales
- sales_id (Primary Key)
- sale_date
- store_id (Foreign Key referencing store)
- product_id (Foreign Key referencing products)
- quantity

### Table: warranty
- claim_id (Primary Key)
- claim_date
- sales_id (Foreign Key referencing sales)
- repair_status

---

## Project Objectives

- Track overall and regional sales performance
- Identify best-selling products and top-performing stores
- Analyze warranty claim frequency and repair trends
- Determine product lifecycle and pricing impact
- Support business decisions with data-driven insights

---

## Key Insights and KPIs

- Total sales and revenue by year, month, and quarter
- Top-selling products and categories
- Warranty claim ratios by product and category
- Average price and quantity sold per store
- Geographical sales performance by city and country
- Product performance post-launch

---

## Tools and Technologies Used

| Tool         | Purpose                                |
|--------------|----------------------------------------|
| SQL          | Data modeling and analytical queries   |





---

## 🔍 Sample SQL Queries

- Total sales by year, product, and category.
- Warranty claims with >10% claim ratio.
- Most profitable store by region.
- Average selling price trend for each product.
- Sales and claims correlation per product.

---

## ✅ Deliverables

- ✅ Fully normalized SQL schema.
- ✅ Raw data files (CSV).
- ✅ Power BI dashboard.
- ✅ 20+ advanced SQL queries for insights.
- ✅ Clean, modular project structure.

----
# Conclusion
Sales are heavily influenced by seasonality and product launch cycles.

Specific stores and countries drive a significant portion of total revenue.

Warranty claim trends reveal potential quality or usability issues with recent product lines.

This project is created for educational and portfolio purposes only. All data used is synthetically generated.

---
# Recommendations
## Warranty Improvement:

Investigate root causes of warranty claims for new launches, especially mobile devices.

Inventory Strategy:

Allocate more stock to high-performing regions during Q4.

Use claim history to optimize returns/replacement policies.

Marketing Focus:

Promote mid-range products that show strong volume performance.

Design region-specific promotions based on store-level insights.

Product Launch Monitoring:

Closely monitor warranty claims in the first 3 months post-launch.

Gather customer feedback early to address potential design flaws.

Store Optimization:

Consider scaling operations in underperforming regions with low claims but decent sales potential.



## 📬 Contact

**Author:** [PRIYA]  

> ⭐ *Star this project if you find it helpful or use it in your learning journey!*


# This project is created for educational and portfolio purposes only. All data used is synthetically generated.







