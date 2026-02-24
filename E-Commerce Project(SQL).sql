CREATE DATABASE ecommerce;


-- 1. KPIs

SELECT 
    ROUND(SUM(price), 2) AS Total_Sales,
    ROUND(SUM(freight_value), 2) AS Total_Freight,
    ROUND(SUM(price + freight_value), 2) AS Total_Order_Value
FROM 
    olist_order_items_dataset;
    
--  KPI Total Revenue
    
    SELECT 
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM 
    olist_order_payments_dataset;
    
   
   -- Total Profit
   
    SELECT 
    SUM(price - freight_value) AS total_profit
FROM
	olist_order_items_dataset;
    
    
    -- Total Number Orders
    
    SELECT
    COUNT(*) AS total_orders
FROM
	olist_orders_dataset;
    
    
-- KPI Average review score

SELECT 
    ROUND(AVG(review_score), 2) AS average_review_score
FROM 
    olist_order_reviews_dataset;


-- 2. Payment type wise sales

 SELECT 
    payment_type,
    ROUND(SUM(payment_value), 2) AS Total_Collected,
    AVG(payment_installments) AS Avg_Installments
FROM 
    olist_order_payments_dataset
GROUP BY 
    payment_type;


-- 3. Total Orders by Customer State
   
   SELECT 
    c.customer_state, 
    COUNT(o.order_id) AS total_orders
FROM 
    olist_orders_dataset o
JOIN 
    olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY 
    c.customer_state
ORDER BY 
    total_orders DESC;
    
    
-- 4. Review Score by Payment Type

    SELECT 
    p.payment_type,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(r.review_id) AS total_reviews
FROM 
    olist_order_payments_dataset p
JOIN 
    olist_order_reviews_dataset r ON p.order_id = r.order_id
GROUP BY 
    p.payment_type
ORDER BY 
    avg_review_score DESC;
    
    
-- 5. Top 10 Stores (Sellers) by Total Sales

   SELECT 
    s.seller_id, 
    s.seller_city, 
    s.seller_state,
    ROUND(SUM(i.price), 2) AS total_sales
FROM 
    olist_order_items_dataset i
JOIN 
    olist_sellers_dataset s ON i.seller_id = s.seller_id
GROUP BY 
    s.seller_id, s.seller_city, s.seller_state
ORDER BY 
    total_sales DESC
LIMIT 10;


-- 6. Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

SELECT 
    CASE 
        WHEN WEEKDAY(o.order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    ROUND(SUM(p.payment_value), 2) AS Total_Revenue
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY 
    Day_Type;


-- 7. MTD Sales
SELECT 

    SUM(CASE WHEN order_purchase_timestamp >= '2018-08-01' THEN payment_value ELSE 0 END) AS MTD_Sales  
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_payments_dataset p ON o.order_id = p.order_id;
    
    
    
  