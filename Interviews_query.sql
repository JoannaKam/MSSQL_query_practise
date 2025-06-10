--"Interviews" problem explanation: https://www.hackerrank.com/challenges/interviews/problem

--Calculate total views and unique views for each contest
WITH total_view AS (
    SELECT 
        c.contest_id,
        c.hacker_id,
        c.name,
        -- Sum of all views across all challenges under the contest
        SUM(v.total_views) AS sum_total_views,
        -- Sum of all unique views across all challenges under the contest
        SUM(v.total_unique_views) AS sum_total_unique_views
    FROM Contests c
    INNER JOIN Colleges col
        ON c.contest_id = col.contest_id
    INNER JOIN Challenges ch
        ON ch.college_id = col.college_id
    LEFT JOIN View_Stats v
        ON ch.challenge_id = v.challenge_id
    -- Grouping by contest to get totals per contest
    GROUP BY 
        c.contest_id,
        c.hacker_id,
        c.name
),

-- Calculate total and accepted submissions for each contest
total_sub AS (
    SELECT 
        c.contest_id,
        c.hacker_id,
        c.name,
        -- Sum of all submissions across all challenges under the contest
        SUM(s.total_submissions) AS sum_total_submissions,
        -- Sum of accepted submissions across all challenges under the contest
        SUM(s.total_accepted_submissions) AS sum_total_accepted_submissions
    FROM Contests c
    INNER JOIN Colleges col
        ON c.contest_id = col.contest_id
    INNER JOIN Challenges ch
        ON ch.college_id = col.college_id
    LEFT JOIN Submission_Stats s
        ON ch.challenge_id = s.challenge_id
    -- Grouping by contest to get totals per contest
    GROUP BY 
        c.contest_id,
        c.hacker_id,
        c.name
)

-- Combine view and submission stats per contest
SELECT 
    tv.contest_id,
    tv.hacker_id,
    tv.name,
    ts.sum_total_submissions,
    ts.sum_total_accepted_submissions,
    tv.sum_total_views,
    tv.sum_total_unique_views
FROM total_view tv
LEFT JOIN total_sub ts
    ON tv.contest_id = ts.contest_id
-- Final output sorted by contest ID
ORDER BY 
    tv.contest_id;
