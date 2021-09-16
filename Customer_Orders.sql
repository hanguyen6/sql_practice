# https://leetcode.com/problems/customer-order-frequency/submissions/
# JOIN three tables customers, products and orders to get overview of customers who purchased a number of products 
# Calculate total spending per customer 
# Filter by total spending > 100

WITH 
    customer_purchases AS (
        SELECT 
            c.customer_id,
            c.name,
            p.product_id,
            p.price AS product_price,
            EXTRACT(MONTH FROM o.order_date) AS order_month,
            EXTRACT(YEAR FROM o.order_date) AS order_year, 
            o.quantity AS product_quantity,
            p.price * o.quantity AS total_prices
        FROM Customers c 
        JOIN Product p 
        JOIN Orders o 
        ON c.customer_id = o.customer_id AND p.product_id = o.product_id 
    ), 
    customer_purchases_monthly AS (
        SELECT 
            order_month,
            order_year,
            customer_id,
            name,
            SUM(total_prices) AS total_prices_monthly
        FROM customer_purchases cp
        GROUP BY order_year, order_month, customer_id, name
        ORDER BY customer_id, name
    ),
    june_purchase_100 AS (
        SELECT 
            *
        FROM customer_purchases_monthly
        WHERE (order_year = 2020 AND order_month = 6 AND total_prices_monthly >= 100) 
    ), 
    july_purchase_100 AS (
        SELECT 
            *
        FROM customer_purchases_monthly
        WHERE (order_year = 2020 AND order_month = 7 AND total_prices_monthly >= 100) 
    ) 

SELECT
    j1.customer_id,
    j1.name
FROM june_purchase_100 j1
JOIN july_purchase_100 j2
ON j1.customer_id = j2.customer_id



### No-Join Solution 
WITH 
    purchases_june_july_100 AS (
        SELECT 
            customer_id,
            name,
            order_year,
            order_month,
            total_prices_monthly,
            CASE 
                WHEN total_prices_monthly >= 100 THEN 1
                ELSE 0 END AS spending_100
        FROM customer_purchases_monthly
        WHERE order_year = 2020 AND order_month IN (6,7)
    )

SELECT
    customer_id,
    name
FROM purchases_june_july_100 
GROUP BY customer_id, name
HAVING SUM(spending_100) = 2

 

