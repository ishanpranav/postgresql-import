-- queries.sql
-- Copyright (c) 2025 Ishan Pranav
-- Licensed under the MIT license.

-- 1. the total number of rows in the database

SELECT COUNT(*) FROM observation;

-- 2. show the first 15 rows, but only display 3 columns (your choice)

SELECT "date", equity_return, risk_free_rate
FROM observation
LIMIT 15
;

-- 3. do the same as above, but chose a column to sort on, and sort in
--    descending order

SELECT "date", equity_return, risk_free_rate
FROM observation
ORDER BY "date" DESC
LIMIT 15
;

-- 4. add a new column without a default value

ALTER TABLE observation
ADD COLUMN debt_return DOUBLE PRECISION;
;

-- 5. set the value of that new column

WITH debt_value_lagging AS (
    SELECT
        "date",
        debt_value AS current,
        LAG(debt_value) OVER (ORDER BY "date") AS previous
    FROM observation
)
UPDATE observation
SET debt_return = ((current / previous) - 1) * 100
FROM debt_value_lagging
WHERE observation.date = debt_value_lagging.date
;

-- 6. show only the unique (non duplicates) of a column of your choice

SELECT DISTINCT party FROM observation;

-- 7. group rows together by a column value (your choice) and use an aggregate
---   function to calculate something about that group

SELECT
    ROUND(risk_free_rate) AS risk_free_percent,
    COUNT(*) AS count
FROM observation
GROUP BY risk_free_percent
ORDER BY risk_free_percent
;

-- 8. now, using the same grouping query or creating another one, find a way to
--    filter the query results based on the values for the groups 

SELECT
    ROUND(risk_free_rate) AS risk_free_percent,
    COUNT(*) AS count
FROM observation
GROUP BY risk_free_percent
HAVING COUNT(*) > 1
ORDER BY count DESC
;

-- 9. number of years per party

SELECT
  party,
  COUNT(*) AS count
FROM observation
GROUP BY party
ORDER BY count DESC
;

-- 10. number of years with positive equity returns by party

SELECT
    party,
    COUNT(*) AS count
FROM observation
WHERE equity_return > 0
GROUP BY party
ORDER BY count DESC
;

-- 11. average values by party

SELECT
    party,
    AVG(equity_return) AS average_equity_return,
    AVG(risk_free_rate) AS average_risk_free_rate
FROM observation
GROUP BY party
ORDER BY party
;

-- 12. sharpe ratios
