/*
Table request_accepted

+--------------+-------------+------------+
| requester_id | accepter_id | accept_date|
|--------------|-------------|------------|
| 1            | 2           | 2016_06-03 |
| 1            | 3           | 2016-06-08 |
| 2            | 3           | 2016-06-08 |
| 3            | 4           | 2016-06-09 |
+--------------+-------------+------------+
This table holds the data of friend acceptance, while requester_id and accepter_id both are the id of a person.
It is guaranteed there is only 1 people having the most friends.
The friend request could only been accepted once, which mean there is no multiple records with the same requester_id and accepter_id value.

*/
# Show all user_id in the table 
WITH all_user_id AS(
    SELECT 
        requester_id AS id
    FROM request_accepted 
    UNION ALL 
        SELECT 
            accepter_id
        FROM request_accepted 
)
# Show user who has the most friends
SELECT 
    id,
    COUNT(id) num
FROM all_user_id
GROUP BY id 
ORDER BY COUNT(id) DESC LIMIT 1
