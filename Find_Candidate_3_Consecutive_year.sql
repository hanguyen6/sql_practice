# https://leetcode.com/problems/find-interview-candidates/
# Filter candidates won more than 3 contests 
WITH 
    gold_medals_3_times AS (
        SELECT 
            gold_medal
        FROM Contests c 
        GROUP BY gold_medal
        HAVING (COUNT(contest_id) >=3 )
),

    contests_2 AS (
        SELECT 
            contest_id,
            gold_medal  as user_id
        FROM Contests 
            UNION 
        SELECT 
            contest_id,
            silver_medal
        FROM Contests 
            UNION
        SELECT 
            contest_id,
            bronze_medal        
        FROM Contests 
    ), 
    
    contests_3 AS (
        SELECT 
            user_id,
            contest_id,
            contest_id - LAG(contest_id) OVER (PARTITION BY user_id ORDER BY contest_id) AS last_contest_diff,
            contest_id - MIN(contest_id) OVER (PARTITION BY user_id ORDER BY contest_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS last_two_contest_diff  
        FROM contests_2
        ORDER BY contest_id
    ), 
    interview_candidate AS (
        SELECT 
            user_id 
        FROM contests_3
        WHERE last_contest_diff = 1 AND last_two_contest_diff = 2 
            UNION 
        SELECT 
            gold_medal
        FROM gold_medals_3_times    
    )

SELECT 
    u.name, 
    u.mail
FROM interview_candidate i 
JOIN Users u 
ON u.user_id = i.user_id 
