/* https://leetcode.com/problems/tournament-winners/
Table: Players

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| player_id   | int   |
| group_id    | int   |
+-------------+-------+
player_id is the primary key of this table.
Each row of this table indicates the group of each player.
Table: Matches

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| first_player  | int     |
| second_player | int     | 
| first_score   | int     |
| second_score  | int     |
+---------------+---------+
match_id is the primary key of this table.
Each row is a record of a match, first_player and second_player contain the player_id of each match.
first_score and second_score contain the number of points of the first_player and second_player respectively.
You may assume that, in each match, players belongs to the same group.
 
The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest player_id wins.
Write an SQL query to find the winner in each group.

Players table:
+-----------+------------+
| player_id | group_id   |
+-----------+------------+
| 15        | 1          |
| 25        | 1          |
| 30        | 1          |
| 45        | 1          |
| 10        | 2          |
| 35        | 2          |
| 50        | 2          |
| 20        | 3          |
| 40        | 3          |
+-----------+------------+

Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | first_player | second_player | first_score | second_score |
+------------+--------------+---------------+-------------+--------------+
| 1          | 15           | 45            | 3           | 0            |
| 2          | 30           | 25            | 1           | 2            |
| 3          | 30           | 15            | 2           | 0            |
| 4          | 40           | 20            | 5           | 2            |
| 5          | 35           | 50            | 1           | 1            |
+------------+--------------+---------------+-------------+--------------+

Result table:
+-----------+------------+
| group_id  | player_id  |
+-----------+------------+ 
| 1         | 15         |
| 2         | 35         |
| 3         | 40         |
+-----------+------------+

*/

# Calculate the total scores of each player in the group 
# Compare total scores within each group 
# Return the player with highest total scores in a group 

WITH 
    # Get total scores of the players 
    total_scores_union AS (
        SELECT 
            first_player AS player_id,
            SUM(first_score) AS total_scores
        FROM Matches 
        GROUP BY first_player
            UNION ALL
        SELECT 
            second_player AS player_id,
            SUM(second_score) AS total_scores 
        FROM Matches
        GROUP BY second_player
    ),
    total_scores AS (
        SELECT 
            player_id,
            SUM(total_scores) AS total_scores
        FROM total_scores_union t
        GROUP BY player_id
        ORDER BY player_id
    ),
    # Add group_id to total_scores table 
    total_scores_with_groupId AS (
        SELECT 
            p.group_id,
            p.player_id,
            s.total_scores
        FROM total_scores s
        JOIN Players p
        ON p.player_id = s.player_id
    ),
    # Get highest score per group id 
    highest_scores_per_group AS (
        SELECT 
            p.group_id, 
            MAX(s.total_scores) AS highest_scores
        FROM total_scores s
        JOIN Players p
        ON p.player_id = s.player_id 
        GROUP BY p.group_id
    )

SELECT 
    ts.group_id, 
    MIN(ts.player_id) as player_id 
FROM total_scores_with_groupId  ts
JOIN highest_scores_per_group hs
ON ts.group_id = hs.group_id 
    AND ts.total_scores = hs.highest_scores 
GROUP BY ts.group_id

