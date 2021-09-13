/*
Table: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| Id           | int     |
| Name         | varchar |
| Salary       | int     |
| DepartmentId | int     |
+--------------+---------+
Id is the primary key for this table.
Each row contains the ID, name, salary, and department of one employee.
 

Table: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| Id          | int     |
| Name        | varchar |
+-------------+---------+
Id is the primary key for this table.
Each row contains the ID and the name of one department.
*/

# A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
# Rank the salary within each department 
WITH 
    Emp_With_Ranked_Salary AS (
        SELECT 
            Id, 
            Name,
            DepartmentId,
            Salary,
            DENSE_RANK() OVER(PARTITION BY DepartmentId  ORDER BY Salary DESC) AS SalaryRank
        FROM Employee
    ), 
    # Get top 3 Salary only 
    Emp_Top3_Salary_By_DepartMent AS (
        SELECT 
            * 
        FROM Emp_With_Ranked_Salary
        WHERE SalaryRank <= 3    
    )
# Join with Department table to show department name 
SELECT 
    d.Name AS Department,
    emp.Name AS Employee, 
    emp.Salary
FROM Emp_Top3_Salary_By_DepartMent emp 
JOIN Department d
ON emp.DepartmentId = d.Id 
