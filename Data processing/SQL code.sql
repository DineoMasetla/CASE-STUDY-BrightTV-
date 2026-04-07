select * from `workspace`.`default`.`bright_tv_viewership` limit 100;

-- CONVERSION: UTC to SAST
SELECT
    UserID0,
    Channel2,
    RecordDate2                                             AS RecordDate_UTC,
    RecordDate2 + INTERVAL 2 HOURS                         AS RecordDate_SAST,
    DATE(RecordDate2 + INTERVAL 2 HOURS)                   AS sa_date,
    HOUR(RecordDate2 + INTERVAL 2 HOURS)                   AS sa_hour,
    `Duration 2`
FROM `workspace`.`default`.`bright_tv_viewership`;

---Joining the tables
SELECT *
FROM `workspace`.`default`.`bright_tv_viewership`  v
JOIN `workspace`.`default`.`bright_tv_viewers_profile` p
ON v.UserID0 = p.UserID;

-- Sessions per day
SELECT
    DATE(RecordDate2 + INTERVAL 2 HOURS)            AS sa_date,
    COUNT(*)                                        AS sessions
FROM `workspace`.`default`.`bright_tv_viewership`
GROUP BY sa_date
ORDER BY sa_date;

-- Sessions per hour
SELECT
    HOUR(RecordDate2 + INTERVAL 2 HOURS)            AS sa_hour,
    COUNT(*)                                        AS sessions
FROM `workspace`.`default`.`bright_tv_viewership`
GROUP BY sa_hour
ORDER BY sa_hour;

-- Most active province
SELECT
    p.Province,
    COUNT(*)                                        AS sessions
FROM `workspace`.`default`.`bright_tv_viewership` v
JOIN `workspace`.`default`.`bright_tv_viewers_profile` p
    ON v.UserID = p.UserID
WHERE p.Province IS NOT NULL
  AND TRIM(p.Province) != ''
GROUP BY p.Province
ORDER BY sessions DESC;

-- Most active age groups
SELECT
    CASE
        WHEN p.Age < 18              THEN 'Under 18'
        WHEN p.Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN p.Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN p.Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN p.Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN p.Age >= 55             THEN '55+'
    END                                             AS age_band,
    COUNT(*)                                        AS sessions
FROM `workspace`.`default`.`bright_tv_viewership` v
JOIN `workspace`.`default`.`bright_tv_viewers_profile` p
    ON v.UserID = p.UserID
WHERE p.Age BETWEEN 5 AND 100
GROUP BY age_band
ORDER BY sessions DESC;



