/*
+-------------+------+
| Column Name | Type |
+-------------+------+
| user1_id    | int  |
| user2_id    | int  |
+-------------+------+
(user1_id, user2_id) is the primary key for this table.
Each row of this table indicates that the users user1_id and user2_id are friends.
Note that user1_id < user2_id.

A friendship between a pair of friends x and y is strong if x and y have at least three common friends.
Note that the result table should not contain duplicates with user1_id < user2_id.

Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 1        | 3        |
| 2        | 3        |
| 1        | 4        |
| 2        | 4        |
| 1        | 5        |
| 2        | 5        |
| 1        | 7        |
| 3        | 7        |
| 1        | 6        |
| 3        | 6        |
| 2        | 6        |
+----------+----------+

Result table:
+----------+----------+---------------+
| user1_id | user2_id | common_friend |
+----------+----------+---------------+
| 1        | 2        | 4             |
| 1        | 3        | 3             |
+----------+----------+---------------+

*/
# Common Friend: If A -> B, A-> C, B-> C then C is common friend of (A,B)

WITH
    ## Get all pairs of friends regardless of their order 
    all_pairs AS (
        SELECT 
            user1_id, 
            user2_id
        FROM Friendship 
        UNION 
            SELECT 
                user2_id,
                user1_id
            FROM Friendship
    )
## Join 3 tables to get common friends 
SELECT 
    f.user1_id,
    f.user2_id,
    COUNT(*) AS common_friend
FROM Friendship f
JOIN all_pairs a1
JOIN all_pairs a2 
ON f.user1_id = a1.user1_id 
    AND f.user2_id = a2.user1_id 
    AND a1.user2_id = a2.user2_id 
GROUP BY f.user1_id, f.user2_id 
HAVING COUNT(*) >= 3
