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


/* Show day1-Retention 
- install date of a player to be the first login day of that player.
- day 1 retention of some date X to be the number of players whose install date is X
--- and they logged back in on the day right after X, 
-- divided by the number of players whose install date is X, 
--- rounded to 2 decimal places.
Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention.
*/

-- Show users with install date and days different from the install date 
WITH 
    sub1 AS (
        SELECT 
            player_id, 
            (MIN(event_date) OVER(PARTITION BY player_id ORDER BY event_date))
                AS install_dt,
            (event_date - MIN(event_date) OVER(PARTITION BY player_id ORDER BY event_date))
                AS days_from_first_login
        FROM activity
    ),

-- Show number of installs by days 
    sub2 AS (
        SELECT
            DISTINCT player_id, 
            MIN(event_date) OVER (PARTITION BY player_id ORDER BY event_date) 
                AS install_dt
        FROM activity 
    )

SELECT 
    sub3.install_dt,
    sub3.installs, 
    ROUND((CASE 
        WHEN sub4.log_backs > 0 THEN sub4.log_backs
        ELSE 0
    END) / sub3.installs, 2) AS Day1_retention
FROM (
    SELECT 
        install_dt,
        COUNT(player_id) as installs 
    FROM sub2 
    GROUP BY install_dt
) sub3
LEFT JOIN (
    SELECT   
        install_dt, 
        COUNT(player_id) as log_backs
    FROM sub1
    WHERE days_from_first_login = 1
    GROUP BY install_dt
) AS sub4 
ON sub3.install_dt = sub4.install_dt
