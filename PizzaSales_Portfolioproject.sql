                                                  -- PIZZA SALES PROJECT -- 
# KPI'S
SELECT SUM(total_price) AS Total_Revenue FROM pizza_data;

# 2. Average Order Value
SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value FROM pizza_data;

# 3. Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold FROM pizza_data;

# 4. Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_data;

# 5. Average Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM pizza_data;

# B. Daily trend for total orders 
SELECT extract(day from order_date) AS order_day, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_data
GROUP BY extract(day from order_date);

# Hourly trend for orders 
SELECT extract(hour from order_time) as order_hours, COUNT(DISTINCT order_id) as total_orders
from pizza_data
group by extract(hour from order_time)
order by extract(hour from order_time);

# % of sales by pizza category 
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_data) AS DECIMAL(10,2)) AS PCT
FROM pizza_data 
GROUP BY pizza_category;

# % of sales by pizza size
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_data) AS DECIMAL(10,2)) AS PCT
FROM pizza_data
GROUP BY pizza_size
ORDER BY pizza_size;

# Total pizzas sold by pizza category 
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;

# Top 5 best sellers by total pizza sold 
SELECT * 
FROM (
SELECT 
SUM(quantity) AS Total_Pizza_Sold, 
pizza_name, 
rank() over (order by sum(quantity) DESC) AS pizza_rank
FROM pizza_data
GROUP BY pizza_name
) as sub_query 
WHERE pizza_rank <= 5;

# Bottom 5 best sellers by total pizzas sold
SELECT * 
FROM (
SELECT 
SUM(quantity) AS Total_Pizza_Sold, 
pizza_name, 
rank() over (order by sum(quantity) ASC) AS pizza_rank
FROM pizza_data
GROUP BY pizza_name
) as sub_query 
WHERE pizza_rank <= 5 



    

    
    

