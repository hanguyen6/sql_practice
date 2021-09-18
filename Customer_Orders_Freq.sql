# https://leetcode.com/problems/the-most-frequently-ordered-products-for-each-customer
WITH 
    # Get order count by each product and customer 
    Orders_Freq AS 
    (
        SELECT 
            customer_id,
            product_id,
            COUNT(order_id) AS order_count
        FROM Orders
        GROUP BY customer_id, product_id 
    ),
    # Rank the order count within each customer group 
    Orders_Rank AS (
        SELECT 
            o1.customer_id,
            o1.product_id, 
            DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_count DESC) order_rank
        FROM Orders_Freq o1
    )
# Filter by the most frequent order and add product name 
SELECT 
    o.customer_id,
    o.product_id,
    p.product_name
FROM Orders_Rank o 
JOIN Products p 
ON o.product_id = p.product_id AND order_rank = 1
