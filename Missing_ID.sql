/*
Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
+---------------+---------+
customer_id is the primary key for this table.
Each row of this table contains the name and the id customer.
 
Write an SQL query to find the missing customer IDs. The missing IDs are ones that are not in the Customers table but are in the range between 1 and the maximum customer_id present in the table.

Notice that the maximum customer_id will not exceed 100.

Return the result table ordered by ids in ascending order.
*/

### Generate sequence number from 1 to Max(cstomer_id) using Recursive CTE
WITH 
    RECURSIVE num_range_customers AS(
        SELECT 
            1 AS num 
        UNION
            SELECT 
                num + 1 
            FROM num_range
            WHERE num < (
                    SELECT 
                        MAX(customer_id)
                    FROM Customers  
                )
    ),
    ## Without Recursive, given that Id <= 100, use math formula to generate number from 1 to 100 
    num_range_100 AS (
        SELECT 
            (num1 * 10 + num2 + 1) AS num
        FROM
            (SELECT 0 num1 
                UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) par1, 
            (SELECT 0 num2 
                UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) par2
        ORDER BY num
    ),
    num_range_customers2 AS(
        SELECT * 
        FROM num_range_100 
        WHERE num <= (
                    SELECT 
                        MAX(customer_id)
                    FROM Customers  
                )
    )
    
### Left Left-Join num_range table with Customers table to find missing Id 
SELECT 
    num AS ids 
FROM num_range_customers2 n
LEFT JOIN Customers c
ON n.num = c.customer_id 
WHERE c.customer_id IS NULL
ORDER BY ids
