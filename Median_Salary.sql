/*
https://leetcode.com/problems/median-employee-salary/

The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|1    | A          | 2341   |
|2    | A          | 341    |
|3    | A          | 15     |
|4    | A          | 15314  |
|5    | A          | 451    |
|6    | A          | 513    |
|7    | B          | 15     |
|8    | B          | 13     |
|9    | B          | 1154   |
|10   | B          | 1345   |
|11   | B          | 1221   |
|12   | B          | 234    |
|13   | C          | 2345   |
|14   | C          | 2645   |
|15   | C          | 2645   |
|16   | C          | 2652   |
|17   | C          | 65     |
+-----+------------+--------+
Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|5    | A          | 451    |
|6    | A          | 513    |
|12   | B          | 234    |
|9    | B          | 1154   |
|14   | C          | 2645   |
+-----+------------+--------+

*/

# ROW_NUMBER ORDER BY salary within a company: Salary_Rank 
# Get the middle position within a company: Mid_Num
# Get row(s) of median Salary where ABS(Salary_Rank - Mid_Num) < 1 

WITH 
    Employee_rank_salary AS (
        SELECT 
            id,
            Company,
            Salary,
            ROW_NUMBER() OVER(PARTITION BY Company ORDER BY Salary) Salary_Rank
        FROM Employee
    ),
    Employee_middle AS (
        SELECT
            Company, 
            (COUNT(*) + 1) / 2 AS Mid_Num 
        FROM Employee_rank_salary
        GROUP BY Company 
    )


SELECT 
    m.Id,
    m.Company,
    m.Salary
FROM Employee_middle e
LEFT JOIN Employee_rank_salary m 
ON m.Company = e.Company AND ABS(m.Salary_Rank - e.Mid_Num) < 1
ORDER BY m.Id

