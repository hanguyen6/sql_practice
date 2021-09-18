/*
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates that the employee with ID employee_id and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.

Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.


*/
# Write your MySQL query statement below
WITH 
    RECURSIVE Subordinate AS (
        SELECT 
            employee_id,
            manager_id,
            1 AS levels 
        FROM Employees 
        WHERE employee_id = 1 
            UNION  
        SELECT 
            e.employee_id,
            e.manager_id,
            levels + 1
        FROM Employees e 
        JOIN Subordinate s 
        WHERE e.manager_id = s.employee_id AND e.employee_id != s.manager_id
    )
SELECT 
    employee_id
FROM Subordinate
WHERE employee_id != 1
