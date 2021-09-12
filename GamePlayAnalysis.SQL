/*
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
*/

-- Show each player, how many games played so far by the player
SELECT 
    player_id,
    event_date,
    SUM(games_played) OVER(PARTITION BY player_id ORDER BY event_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS games_played_so_far 
FROM activity
ORDER BY player_id, event_date DESC

-- Show fraction of user who login after their first log 
-- Calculate day diff from the day user login 
-- Filter users having day diff = 1 
-- Calculate fraction of user having day diff = 1 

SELECT 
    ROUND(COUNT(activity.player_id) / (SELECT COUNT(DISTINCT player_id) FROM activity), 2) AS fraction
FROM activity 
JOIN 
    (SELECT 
        player_id,
        MIN(event_date) as min_date
    FROM activity
    GROUP BY player_id) AS first_log 
ON activity.player_id = first_log.player_id
WHERE event_date - min_date = 1 


-- Solution using CTA, Window Function 
WITH 
sub1 AS (
    SELECT 
        player_id, 
        (event_date - MIN(event_date) OVER(PARTITION BY player_id ORDER BY event_date)) AS days_from_first_login
    FROM activity 
),
sub2 AS (
    SELECT 
        COUNT(DISTINCT player_id) AS total_players
    FROM activity 
)
SELECT ROUND(COUNT(player_id) / sub2.total_players, 2) AS fraction
FROM sub1, sub2
WHERE days_from_first_login = 1
