/*
https://leetcode.com/problems/find-median-given-frequency-of-numbers/

The Numbers table keeps the value of number and its frequency.

+----------+-------------+
|  Number  |  Frequency  |
+----------+-------------|
|  0       |  7          |
|  1       |  1          |
|  2       |  3          |
|  3       |  1          |
+----------+-------------+
In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

+--------+
| median |
+--------|
| 0.0000 |
+--------+
Write a query to find the median of all numbers and name the result as median.

## Find the middle position and the range include the middle position  
number_sum 
["number", "bottom", "up", "m"]
    [0, 0, 7, 6.0000], 
    [1, 7, 8, 6.0000], 
    [2, 8, 11, 6.0000], 
    [3, 11, 12, 6.0000]
*/

WITH 
    number_sum AS (
        SELECT
            number,
            SUM(Frequency) OVER (ORDER BY number)  - Frequency AS bottom,
            SUM(Frequency) OVER (ORDER BY number) AS up,
            SUM(Frequency) OVER () / 2 AS m
         FROM Numbers
    ) 
    
SELECT 
    AVG(number) as median
FROM number_sum
WHERE m < up AND m > bottom 
