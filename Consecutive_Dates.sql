# https://leetcode.com/problems/report-contiguous-dates/
# Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

# Filter by date from 2019-01-01 to 2019-12-31
# Union two filtered tables 
# In each table, group by consecutive dates 
    ## By taking Different of ROW_NUMBER() OVER (ORDER BY dates) 
    ##    and RANK() OVER(PARTITION BY status ORDER BY dates)
# Take MIN and MAX of consecutive dates within group of (status, group) as start_date and end_date 

/*
e.g


fail_date
2019-10-3
2019-10-5
2019-10-7
2019-10-9

Succeeded
success_date
2019-10-2
2019-10-4
2019-10-6
2019-10-8
2019-10-10

=> Status_Result_Grouped 
["dates", "status", "row_num", "d_rank", "grp"]
["2019-10-03", "failed",    2,      1,      1], 
["2019-10-05", "failed",    4,      2,      2], 
["2019-10-07", "failed",    6,      3,      3], 
["2019-10-09", "failed",    8,      4,      4], 
["2019-10-02", "succeeded", 1,      1,      0],
["2019-10-04", "succeeded", 3,      2,      1], 
["2019-10-06", "succeeded", 5,      3,      2], 
["2019-10-08", "succeeded", 7,      4,      3],
["2019-10-10", "succeeded", 9,      5,      4]

*/

WITH 
    Status_Result  AS (
        SELECT 
            fail_date AS dates, 
            'failed' AS status
        FROM failed
            WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
        UNION
            SELECT 
                success_date AS dates, 
                'succeeded' AS status
            FROM succeeded
            WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'
    ),

    Status_Result_Grouped AS (
        SELECT 
            dates, 
            status,
            ROW_NUMBER() OVER (ORDER BY dates) AS row_num,
            RANK() OVER (PARTITION BY status ORDER BY dates) AS d_rank, 
            (ROW_NUMBER() OVER (ORDER BY dates) - RANK() OVER (PARTITION BY status ORDER BY dates)) AS grp
            
FROM Status_Result)


SELECT 
    status AS period_state ,
    MIN(dates) AS start_date,
    MAX(dates) AS end_date
FROM Status_Result_Grouped
GROUP BY grp, status
ORDER BY dates
