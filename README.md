# 🍕 NYC Andiamo Pizza Sales Analysis  
![Language](https://img.shields.io/badge/Language-SQL-blue)  ![Visualization](https://img.shields.io/badge/Visualization-Excel-purple)  ![Status](https://img.shields.io/badge/Project-Completed-brightgreen) ![Data](https://img.shields.io/badge/Data-PizzaSales-orange)  

---

## 1. Business Objective
Help **NYC Andiamo Pizza** improve profitability and operational efficiency by:
- Identifying top-performing products and categories  
- Finding peak sales times for staffing optimization  
- Understanding customer preferences for menu design  
- Improving inventory planning with demand data

---

## 📂 Resources

- SQL Script: [Pizza Sales SQL Script](https://github.com/TrungLe123692/NYC-Andiamo-Pizza-Sales-Analytics-Project-/blob/main/PizzaSales_Portfolioproject.sql)  
- Excel Dashboard: [Excel Dashboard Image](https://github.com/TrungLe123692/NYC-Andiamo-Pizza-Sales-Analytics-Project-/blob/main/Pizza%20Sales%20Excel%20Dashboard.png)
- Dataset Source: [Pizza Sales Dataset](https://github.com/TrungLe123692/NYC-Andiamo-Pizza-Sales-Analytics-Project-/blob/main/Pizza%20Data.xlsx)

---

## 2. About the Data and Stucture

The project uses the **[2015 NYC Andiamo Pizza Sales Dataset](https://github.com/TrungLe123692/NYC-Andiamo-Pizza-Sales-Analytics-Project-/blob/main/Pizza%20Data.xlsx)** with **48,000+ transactions** and **14 columns** detailing order IDs, dates, times, product info, quantities, and prices, covering a full year of pizza sales in New York City.


| Column            | Description                                                   | Data Type   |
|-------------------|---------------------------------------------------------------|-------------|
| pizza_id          | Unique ID for each pizza sold                                 | INT         |
| order_id          | ID for each order                                             | INT         |
| total_orders      | Normalized fraction per pizza                                 | FLOAT(4,1)  |
| pizza_name_id     | Unique ID for each pizza name                                 | VARCHAR(50) |
| quantity          | Number of pizzas sold                                         | INT         |
| order_date        | Date when the order was placed                                | DATE        |
| order_day         | Day of the week for the order                                 | VARCHAR(20) |
| order_time        | Time when the order was placed                                | TIMESTAMP   |
| unit_price        | Price per pizza                                               | DECIMAL(6,2)|
| total_price       | Total price per pizza line                                    | DECIMAL(8,2)|
| pizza_size        | Size of pizza (Small, Medium, Large, etc.)                    | VARCHAR(20) |
| pizza_category    | Category (Classic, Veggie, Supreme, etc.)                     | VARCHAR(50) |
| pizza_ingredients | Ingredients used                                              | VARCHAR(255)|
| pizza_name        | Full name of the pizza                                        | VARCHAR(100)|


[Project Structure](https://github.com/TrungLe123692/NYC-Andiamo-Pizza-Sales-Analytics-Project-/blob/main/Project%20Structure)

<img width="435" height="632" alt="Screenshot 2025-08-10 153716" src="https://github.com/user-attachments/assets/57fa28e9-4165-4ea7-9c92-a92021e54b18" />

---

## 3. Data Analyst Techniques 

- **3.1. Data Aggregation (`SUM`, `COUNT`, `AVG`, `GROUP BY`)**
  
  ▪ Used aggregate functions to compute key metrics such as **total revenue**, **total pizzas sold**, and **total orders**.  
  ▪ Applied `GROUP BY` to segment results by **pizza category**, **pizza size**, and **time period** for more granular insights.  
  ▪ Example: Summing `total_price` grouped by `pizza_category` to identify top-performing product categories.  

- **3.2. KPI Calculation (Revenue, AOV, Orders, Quantity)**
  
  ▪ Designed and calculated **core performance metrics** including:  
    - **Total Revenue** (`SUM(total_price)`)  
    - **Average Order Value (AOV)** (Revenue ÷ Unique Orders)  
    - **Total Orders** (`COUNT(DISTINCT order_id)`)  
    - **Total Pizzas Sold** (`SUM(quantity)`)  
    - **Average Pizzas per Order** (Pizzas Sold ÷ Orders)  
  ▪ Ensured precision by applying `CAST()` for decimal formatting in business reporting.  

- **3.3. Window Functions (`RANK() OVER`)**
  
  ▪ Used `RANK()` to assign ranking to pizzas based on **sales volume** in both **descending** (top sellers) and **ascending** (bottom sellers) order.  
  ▪ Enabled filtering for **top 5** and **bottom 5** performers through subqueries, streamlining menu engineering decisions.  

- **3.4. Date & Time Handling (`EXTRACT`, `MONTH`)**
  
  ▪ Extracted **day** and **hour** from order timestamps to detect **daily and hourly demand peaks**.  
  ▪ Filtered by `MONTH(order_date)` to perform **seasonal or monthly category sales analysis**.  
  ▪ Facilitated time-based staffing and promotional planning.  

- **3.5. Percentage Contribution Calculations**
  
  ▪ Computed each category’s and size’s contribution to total revenue using:  
    - `SUM(total_price) * 100 / (SELECT SUM(total_price)...)`  
  ▪ Allowed management to identify **high-impact products** for targeted marketing and resource allocation.  

- **3.6. Filtering & Ranking with Subqueries**
  
  ▪ Implemented **nested SELECT statements** to apply filters **after aggregation** (e.g., filter top 5 best sellers after ranking).  
  ▪ Ensured efficient query structure to avoid recomputing aggregates multiple times.  

- **3.7. Business-Oriented Query Structuring for Decision-Making**
  
  ▪ Wrote queries with **clear business objectives** in mind, focusing on actionable outcomes such as:  
    - Peak sales hours → staffing adjustments  
    - Category/size preferences → menu optimization  
    - Top/bottom sellers → promotional focus or removal  

- **3.8. Excel Dashboarding (Pivot Tables, Slicers, Charts)**
  
  ▪ Imported SQL query outputs into Excel for visualization.  
  ▪ Created **pivot tables** to summarize key metrics dynamically.  
  ▪ Added **slicers** for interactive filtering by date, category, and size.  
  ▪ Designed **charts** (bar, line, pie) to visualize trends, category performance, and size preferences for stakeholders.

---

  ## 4. SQL Script 

### **4.1. KPI – Total Revenue**

- **Aggregation**: `SUM()` to calculate total revenue from all orders  
- **Business Purpose**: Determine total income generated over the year  
- **Columns Used**: `total_price` (DECIMAL(8,2))  
- **Why**: Revenue is the primary KPI to assess overall sales performance  

```sql
SELECT SUM(total_price) AS Total_Revenue 
FROM pizza_data;
```

---

### **4.2. KPI – Average Order Value (AOV)**

- **Calculation**: AOV = Total Revenue ÷ Number of Unique Orders  
- **Aggregation Functions**: `SUM()`, `COUNT(DISTINCT)`  
- **Columns Used**: `total_price`, `order_id`  
- **Why**: Measures customer spending behavior per order, helps pricing & upselling  

```sql
SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value 
FROM pizza_data;
```

---

### **4.3. KPI – Total Pizzas Sold**

- **Aggregation**: `SUM(quantity)` to find the total number of pizzas sold  
- **Columns Used**: `quantity` (INT)  
- **Why**: Indicates total sales volume, critical for inventory planning  

```sql
SELECT SUM(quantity) AS Total_pizza_sold 
FROM pizza_data;
```

---

### **4.4. KPI – Total Orders**

- **Unique Count**: `COUNT(DISTINCT order_id)` for total transactions  
- **Columns Used**: `order_id` (INT)  
- **Why**: Tracks number of unique customer purchases, not total items  

```sql
SELECT COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_data;
```

---

### **4.5. KPI – Average Pizzas Per Order**

- **Division of Aggregates**: SUM(quantity) ÷ COUNT(DISTINCT order_id)  
- **Precision Control**: `CAST()` to format decimals for reporting  
- **Columns Used**: `quantity`, `order_id`  
- **Why**: Shows average basket size, useful for upselling strategies  

```sql
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM pizza_data;
```

---

### **4.6. Daily Trend for Orders**

- **Date Extraction**: `EXTRACT(DAY FROM order_date)` to group by calendar day  
- **Aggregation**: `COUNT(DISTINCT order_id)` for daily order count  
- **Columns Used**: `order_date`, `order_id`  
- **Why**: Identify which days of the month have peak orders for scheduling & promos  

```sql
SELECT EXTRACT(DAY FROM order_date) AS order_day, 
       COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_data
GROUP BY EXTRACT(DAY FROM order_date);
```

---

### **4.7. Hourly Trend for Orders**

- **Time Extraction**: `EXTRACT(HOUR FROM order_time)` for hourly grouping  
- **Aggregation**: `COUNT(DISTINCT order_id)` for number of orders per hour  
- **Columns Used**: `order_time`, `order_id`  
- **Why**: Reveals busiest times for demand-driven staffing  

```sql
SELECT EXTRACT(HOUR FROM order_time) AS order_hours, 
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_data
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY EXTRACT(HOUR FROM order_time);
```

---

### **4.8. % of Sales by Pizza Category**

- **Group Aggregation**: `SUM(total_price)` grouped by category  
- **Percentage Calculation**: Share of total sales using subquery division  
- **Columns Used**: `pizza_category`, `total_price`  
- **Why**: Identifies which categories drive the most revenue for menu focus  

```sql
SELECT pizza_category, 
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
       CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_data) AS DECIMAL(10,2)) AS PCT
FROM pizza_data 
GROUP BY pizza_category;
```

---

### **4.9. % of Sales by Pizza Size**

- **Group Aggregation**: `SUM(total_price)` grouped by pizza size  
- **Percentage Calculation**: Category share of overall sales  
- **Columns Used**: `pizza_size`, `total_price`  
- **Why**: Determines customer size preference for pricing & production planning  

```sql
SELECT pizza_size, 
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
       CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_data) AS DECIMAL(10,2)) AS PCT
FROM pizza_data
GROUP BY pizza_size
ORDER BY pizza_size;
```

---

### **4.10. Total Pizzas Sold by Category (Monthly)**

- **Conditional Filtering**: `WHERE MONTH(order_date) = X` for month-specific sales  
- **Aggregation**: `SUM(quantity)` grouped by category  
- **Columns Used**: `pizza_category`, `quantity`, `order_date`  
- **Why**: Detects seasonal category demand for inventory control  

```sql
SELECT pizza_category, 
       SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;
```

---

### **4.11. Top 5 Best Sellers**

- **Ranking**: `RANK()` window function to rank products by volume sold  
- **Subquery Filtering**: Limit results to top performers  
- **Columns Used**: `pizza_name`, `quantity`  
- **Why**: Identify best-sellers for menu promotion  

```sql
SELECT * 
FROM (
  SELECT SUM(quantity) AS Total_Pizza_Sold, 
         pizza_name, 
         RANK() OVER (ORDER BY SUM(quantity) DESC) AS pizza_rank
  FROM pizza_data
  GROUP BY pizza_name
) AS sub_query 
WHERE pizza_rank <= 5;
```

---

### **4.12. Bottom 5 Best Sellers**

- **Ranking**: `RANK()` for ascending order to find lowest-selling products  
- **Subquery Filtering**: Select bottom performers for potential menu removal  
- **Columns Used**: `pizza_name`, `quantity`  
- **Why**: Helps in menu engineering to remove underperformers  

```sql
SELECT * 
FROM (
  SELECT SUM(quantity) AS Total_Pizza_Sold, 
         pizza_name, 
         RANK() OVER (ORDER BY SUM(quantity) ASC) AS pizza_rank
  FROM pizza_data
  GROUP BY pizza_name
) AS sub_query 
WHERE pizza_rank <= 5;

```

## 7. Business Insights

- **Revenue Optimization**  
  ▪ Higher sales during certain hours and days present opportunities for time-based promotions.  
  ▪ Top categories and sizes can be priced strategically to maximize margins.  

- **Smart Inventory Management**  
  ▪ Knowing which products sell best supports better purchasing decisions.  
  ▪ Seasonal category trends guide stocking levels to reduce waste.  

- **Demand-Driven Staffing**  
  ▪ Aligning staff schedules with peak order times ensures efficiency.  

- **Menu Engineering**  
  ▪ Promote top 5 best sellers and consider phasing out bottom 5.  
  ▪ Adjust menu design to emphasize profitable categories.

---

## 8. Next Steps & Future Improvements

- **Customer Segmentation** – Integrate customer-level data for targeted offers.  
- **Predictive Analytics** – Forecast sales to improve staffing and inventory planning.  
- **POS Integration** – Automate live data feeds for real-time decision-making.  
- **Marketing Impact Tracking** – Measure the effect of promotions and campaigns on sales.

---

## 9. Why This Matters
Transforming raw sales data into **actionable insights** enables NYC Andiamo Pizza to stay competitive in the fast-moving NYC food market.  
By combining SQL analytics with interactive Excel dashboards, the business gains a **continuous decision-making tool** that adapts to customer demand.

