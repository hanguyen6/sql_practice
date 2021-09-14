# https://leetcode.com/problems/last-person-to-fit-in-the-bus/
# Sort table by turn column ASC 
# Get a sliding window of number of people get in the bus in order 
# Calculate running total weight of the sliding window 
# Filter running total <= 1000 kilogram
# Get the name of person in the last row 

WITH 
    queue_in_order AS (
        SELECT 
            turn,
            person_id,
            person_name,
            weight,
            SUM(weight) OVER(ORDER BY turn ASC) AS running_total_weight
        FROM 
            Queue
        ORDER BY turn
    )

SELECT 
    person_name
FROM queue_in_order
WHERE running_total_weight <= 1000
ORDER BY running_total_weight DESC
LIMIT 1 

/* 
## Use subQuery 

WITH max_1000 AS (
    SELECT 
        MAX(running_total_weight) AS max_total_weight_under_1000
    FROM queue_in_order
    WHERE running_total_weight <= 1000
 )

SELECT person_name 
FROM queue_in_order, max_1000
WHERE running_total_weight = max_total_weight_under_1000 

*/
