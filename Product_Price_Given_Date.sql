/*
https://leetcode.com/problems/product-price-at-a-given-date/

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.

Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.


*/

# Product _price = new price at max(change_date) where change_date < 08/16

WITH 
    # Get distinct product_id 
    distinct_product AS (
        SELECT 
            DISTINCT product_id 
        FROM Products
    ),
    
    # Rank the product by change_date 
    change_before_16 AS (
        SELECT
            product_id, 
            new_price,
            RANK() OVER (PARTITION BY product_id ORDER BY change_date DESC) AS p_rank  
        FROM Products 
        WHERE change_date <= '2019-08-16'
    )

SELECT 
    p.product_id,
    COALESCE(new_price, 10) as price
FROM distinct_product p 
LEFT JOIN change_before_16 c
ON p.product_id = c.product_id AND p_rank = 1 
