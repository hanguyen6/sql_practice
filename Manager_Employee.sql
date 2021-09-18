/*
Get Manager with at least 5 direct reports 
+------+----------+-----------+----------+
|Id    |Name 	  |Department |ManagerId |
+------+----------+-----------+----------+
|101   |John 	  |A 	      |null      |
|102   |Dan 	  |A 	      |101       |
|103   |James 	  |A 	      |101       |
|104   |Amy 	  |A 	      |101       |
|105   |Anne 	  |A 	      |101       |
|106   |Ron 	  |B 	      |101       |
+------+----------+-----------+----------+

*/

# Get Employee list 
WITH 
    Manager_5Report AS (
        SELECT 
            ManagerId
        FROM Employee
        GROUP BY ManagerId
        HAVING COUNT(Id) >= 5
    )
SELECT 
    e.Name
FROM Manager_5Report m
JOIN Employee e 
ON e.Id = m.ManagerId 
