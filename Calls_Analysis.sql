
/*
Table: Calls

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| from_id     | int     |
| to_id       | int     |
| duration    | int     |
+-------------+---------+
This table does not have a primary key, it may contain duplicates.
This table contains the duration of a phone call between from_id and to_id.
from_id != to_id

Write an SQL query to report the number of calls and the total call duration between each pair of distinct persons (person1, person2) where person1 < person2.
Calls table:
+---------+-------+----------+
| from_id | to_id | duration |
+---------+-------+----------+
| 1       | 2     | 59       |
| 2       | 1     | 11       |
| 1       | 3     | 20       |
| 3       | 4     | 100      |
| 3       | 4     | 200      |
| 3       | 4     | 200      |
| 4       | 3     | 499      |
+---------+-------+----------+

Result table:
+---------+---------+------------+----------------+
| person1 | person2 | call_count | total_duration |
+---------+---------+------------+----------------+
| 1       | 2       | 2          | 70             |
| 1       | 3       | 1          | 20             |
| 3       | 4       | 4          | 999            |
+---------+---------+------------+----------------+

*/

WITH 
    # Get total calls and duration, filtering where from_id < to_id, 
    # Report (from_id, to_id) as (person1, person2)
    calls_a_b AS (
        SELECT 
            from_id AS person1,
            to_id AS person2,
            COUNT(*) AS call_count, 
            SUM(duration) AS total_duration
        FROM Calls
        WHERE from_id <  to_id
        GROUP BY from_id, to_id    
    ),
    # Get total call and durations, filtering from to_id < from_id
    # Report (to_id, from_id) as (person1, person2) 
    calls_b_a AS (
        SELECT 
            to_id AS person1,
            from_id AS person2,
            COUNT(*) AS call_count, 
            SUM(duration) AS total_duration
        FROM Calls
        WHERE from_id >  to_id
        GROUP BY from_id, to_id   
    ),
    # Get Union of two tables above 
    total_calls AS (
    SELECT *
    FROM calls_a_b
    UNION 
        SELECT 
            * 
        FROM calls_b_a    
    )
# Get total sum of calls and durations 
SELECT 
    person1,  
    person2,
    SUM(call_count) AS call_count,
    SUM(total_duration) AS total_duration
FROM total_calls
GROUP BY person1, person2



    
