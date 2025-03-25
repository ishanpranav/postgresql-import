# Asset classes

## Overview

### S&P 500 Index Total Returns

1. __Title:__ S&P 500 Total Returns (SP500)
2. __URL:__
  [https://www.slickcharts.com/sp500/returns](https://www.slickcharts.com/sp500/returns)
3. __Source:__
   * __Source:__ Slickcharts
   * __Publisher:__ S&P Dow Jones Indices LLC
   * __Publication date:__ 2025-02-12
   * __Access date:__ 2025-02-13
4. __License:__ Standard & Poors Release
5. __Usable:__ Yes

### ICE BofA U.S. Corporate Index

1. __Title:__ ICE BofA US Corporate Index Total Return Index Value
  ([BAMLCC0A0CMTRIV](https://fred.stlouisfed.org/series/BAMLCC0A0CMTRIV))
2. __URL:__
  [https://fred.stlouisfed.org/series/BAMLCC0A0CMTRIV](https://fred.stlouisfed.org/series/BAMLCC0A0CMTRIV)
3. __Source:__
   * __Source:__ FRED, the Federal Reserve Bank of St. Louis 
   * __Publisher:__ Ice Data Indices, LLC
   * __Publication date:__ 2025-02-12
   * __Access date:__ 2025-02-13
4. __License:__ ICE BofA Indices Release
5. __Usable:__ Yes

### S&P Case–Shiller Index

1. __Title:__ S&P CoreLogic Case-Shiller U.S. National Home Price Index
  ([CSUSHPINSA](https://fred.stlouisfed.org/series/CSUSHPINSA))
2. __URL:__
  [https://fred.stlouisfed.org/series/CSUSHPINSA](https://fred.stlouisfed.org/series/CSUSHPINSA)
3. __Source:__
   * __Source:__ FRED, the Federal Reserve Bank of St. Louis
   * __Publisher:__ S&P Dow Jones Indices LLC
   * __Publication date:__ 2025-01-28
   * __Access date:__ 2025-02-13
4. __License:__ S&P CoreLogic Case-Shiller Home Price Indices Release
5. __Usable:__ Yes

### 10-year U.S. Treasury yield

1. __Title:__ Market Yield on U.S. Treasury Securities at 10-Year Constant
  Maturity, Quoted on an Investment Basis
  ([DGS10](https://fred.stlouisfed.org/series/DGS10))
2. __URL:__
  [https://fred.stlouisfed.org/series/DGS10](https://fred.stlouisfed.org/series/DGS10)
3. __Source:__
   * __Source:__ FRED, the Federal Reserve Bank of St. Louis
   * __Publisher:__ Board of Governors of the Federal Reserve System (US)
   * __Publication date:__ 2025-02-12
   *  __Access date:__ 2025-02-13
4. __License:__ H.15 Selected Interest Rates Release
5. __Usable:__ Yes

### U.S. presidential party

1. __Title:__ List of presidents of the United States
2. __URL:__
  [https://en.wikipedia.org/wiki/List_of_presidents_of_the_United_States](https://en.wikipedia.org/wiki/List_of_presidents_of_the_United_States)
3. __Source:__
   * __Source:__ Wikipedia
   * __Publisher:__ Wikimedia Foundation
   * __Publication date:__ 2025-02-13
   *  __Access date:__ 2025-02-13
4. __License:__ Creative Commons Attribution Share-Alike 4.0 license
5. __Usable:__ Yes

## Table design

We will populate a PostgreSQL table using our observations. Since there are no
other tables (and thus no need for foreign keys), we will use the observation
date as the primary key. This ensures that there is a single observation for
a given date, and that each observation can be uniquely identified by its date.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `date` | `DATE` | `PRIMARY KEY` | The date of the time series observation. |
| `debt_value` | `DECIMAL(10, 2)` | `NOT NULL` | The value of the ICE BofA U.S. Corporate Index. This is a proxy for the debt market. |
| `real_value` | `DECIMAL(10, 2)` | `NOT NULL` | The value of the S&P Case–Shiller Index. This is a proxy for the real estate market. 
| `equity_return` | `DOUBLE PRECISION` | `NOT NULL` | The total return of the S&P 500 Index. This is a proxy for the return of the equity market. |
| `risk_free_rate` | `DOUBLE PRECISION` | `NOT NULL` | The 10-year U.S. Treasury yield. This is a proxy for the risk-free rate. |
| `party` | `CHAR(1)` | `NOT NULL` | The U.S. presidential party: `'D'` indicates the Democratic Party; `'R'` indicates the Republican Party. |

We can convert this specification into a SQL command:

```sql
CREATE TABLE observation (
    "date"         DATE             PRIMARY KEY,
    debt_value     DECIMAL(10, 2)   NOT NULL,
    real_value     DECIMAL(10, 2)   NOT NULL,
    equity_return  DOUBLE PRECISION NOT NULL,
    risk_free_rate DOUBLE PRECISION NOT NULL,
    party          CHAR(1)          NOT NULL
);
```

## Import

We can import all columns from the `fredgraph.csv` file.

```sql
COPY observation (
  "date",
  debt_value,
  risk_free_rate,
  real_value,
  equity_return,
  party
)
FROM 'fredgraph.csv' WITH (FORMAT 'csv', DELIMITER ',', HEADER)
;
```

## Database information

First, we can execute PostgreSQL instructions to examine the instance, databases, and tables.

The `\l` instruction lists the databases in the PostgreSQL instance.

```
\l
```

```
postgres-# \l
                                                List of databases
   Name    |  Owner   | Encoding | Locale Provider | Collate | Ctype | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+---------+-------+--------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | en-US   | en-US |        |           |
 template0 | postgres | UTF8     | libc            | en-US   | en-US |        |           | =c/postgres          +
           |          |          |                 |         |       |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en-US   | en-US |        |           | =c/postgres          +
           |          |          |                 |         |       |        |           | postgres=CTc/postgres
(3 rows)
```

The `\dt` instruction lists the tables in the current database.

```
\dt
```

```
            List of relations
 Schema |    Name     | Type  |  Owner
--------+-------------+-------+----------
 public | observation | table | postgres
(1 row)
```

The `\d` instruction describes the given table.

```
\d observation
```

```
     Column     |       Type       | Collation | Nullable | Default
----------------+------------------+-----------+----------+---------
 date           | date             |           | not null |
 debt_value     | numeric(10,2)    |           | not null |
 real_value     | numeric(10,2)    |           | not null |
 equity_return  | double precision |           | not null |
 risk_free_rate | double precision |           | not null |
 party          | character(2)     |           | not null |
Indexes:
    "observation_pkey" PRIMARY KEY, btree (date)
```

## Query results

1. We can calculate the total number of rows in the database.

```sql
SELECT COUNT(*) FROM observation;
```

```
 count
-------
    37
(1 row)
```

There are 37 rows in the database.

2. We can also display the date, S&P 500 Index total return, and 10-year U.S.
  Treasury yield for the first 15 years in the time series.

```sql
SELECT "date", equity_return, risk_free_rate
FROM observation
LIMIT 15
;
```

```
    date    | equity_return | risk_free_rate
------------+---------------+----------------
 1987-01-01 |          5.25 |           8.83
 1988-01-01 |         16.61 |           9.14
 1989-01-01 |         31.69 |           7.93
 1990-01-01 |          -3.1 |           8.08
 1991-01-01 |         30.47 |           6.71
 1992-01-01 |          7.62 |            6.7
 1993-01-01 |         10.08 |           5.83
 1994-01-01 |          1.32 |           7.84
 1995-01-01 |         37.58 |           5.58
 1996-01-01 |         22.96 |           6.43
 1997-01-01 |         33.36 |           5.75
 1998-01-01 |         28.58 |           4.65
 1999-01-01 |         21.04 |           6.45
 2000-01-01 |          -9.1 |           5.12
 2001-01-01 |        -11.89 |           5.07
(15 rows)
```

The first 15 rows show a range of equity returns, and risk-free rates ranging
from about 5 percent to as high as 9 percent.

3. We can sort the observations in reverse chronological order, choosing only
  the most recent 15 years.

```sql
SELECT "date", equity_return, risk_free_rate
FROM observation
ORDER BY "date" DESC
LIMIT 15
;
```

```
  date    | equity_return | risk_free_rate
------------+---------------+----------------
2023-01-01 |         26.29 |           3.88
2022-01-01 |        -18.11 |           3.88
2021-01-01 |         28.71 |           1.52
2020-01-01 |          18.4 |           0.93
2019-01-01 |         31.49 |           1.92
2018-01-01 |         -4.38 |           2.69
2017-01-01 |         21.83 |            2.4
2016-01-01 |         11.96 |           2.45
2015-01-01 |          1.38 |           2.27
2014-01-01 |         13.69 |           2.17
2013-01-01 |         32.39 |           3.04
2012-01-01 |            16 |           1.78
2011-01-01 |          2.11 |           1.89
2010-01-01 |         15.06 |            3.3
2009-01-01 |         26.46 |           3.85
```

In the most recent 15 years, risk-free rates are much lower. In some years, the
risk-free rate was less than 1 percent; and, in the last 15 years, it did not
reach 4 percent.

4. Next, we can add a new column for the total return of the ICE BofA U.S. Corporate Index.

```sql
ALTER TABLE observation
ADD COLUMN debt_return DOUBLE PRECISION;
;
```

```
ALTER TABLE
```

```
...
 debt_return    | double precision |           |          |
...
```

5. Then, we can assign values to the new column.

First, we use the `LAG` function over the chronological observations to gather
each `debt_value` entry, alongside its `previous_debt_value` and save these
results in the `debt_value_lagging` expression.

Then, we update the `observation` table to contain the percent-change in the
debt index for all rows except the first. The first row is `NULL`.

```sql
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
```

```
UPDATE 37
```

```
    date    | debt_value | real_value | equity_return | risk_free_rate | party |     debt_return
------------+------------+------------+---------------+----------------+-------+---------------------
 1987-01-01 |     357.67 |      68.34 |          5.25 |           8.83 | R     |
 1988-01-01 |     392.57 |      73.28 |         16.61 |           9.14 | R     |    9.75759778566835
 1989-01-01 |     447.98 |      76.50 |         31.69 |           7.93 | R     |   14.11468018442571
 1990-01-01 |     481.00 |      75.97 |          -3.1 |           8.08 | R     |    7.37086477074869
...
```

6. Next, we can examine the unique values in the `party` column to confirm that
  only the Democratic and Republican parties are represented here.

```sql
SELECT DISTINCT party FROM observation;
```

```
 party
-------
 R
 D
(2 rows)
```

As expected, there are two political parties represented in the data.

7. Now, we can group years by the risk-free rate (rounded to the nearest 1
  percent) and count the number of years in each rate environment.

```sql
SELECT
    ROUND(risk_free_rate) AS risk_free_percent,
    COUNT(*) AS count
FROM observation
GROUP BY risk_free_percent
ORDER BY risk_free_percent
;
```

```
 risk_free_percent | count
-------------------+-------
                 1 |     1
                 2 |     9
                 3 |     3
                 4 |     8
                 5 |     4
                 6 |     5
                 7 |     2
                 8 |     3
                 9 |     2
(9 rows)
```

The risk-free rate is most often between 2 and 4 percent, with the highest
number of years experiencing a 10-year U.S. Treasury yield nearest to 2
percent.

8. Finally, we can filter this grouping to exclude outliers (groups with only a
  single year).

```sql
SELECT
    ROUND(risk_free_rate) AS risk_free_percent,
    COUNT(*) AS count
FROM observation
GROUP BY risk_free_percent
HAVING COUNT(*) > 1
ORDER BY count DESC
;
```

```
 risk_free_percent | count
-------------------+-------
                 2 |     9
                 4 |     8
                 6 |     5
                 5 |     4
                 3 |     3
                 8 |     3
                 7 |     2
                 9 |     2
(8 rows)
```

9. Let's group years by political party to see the distribution.

```sql
SELECT
  party,
  COUNT(*) AS count
FROM observation
GROUP BY party
ORDER BY count DESC
;
```

```
 party | count
-------+-------
 D     |    19
 R     |    18
(2 rows)
```

In recent memory, the number of years with a Democratic president has been
roughly equal to the number of years with a Republican president.

10. Now, we can count only the years with positive equity returns to determine
  which party coincided with positive returns more often.

```sql
SELECT
    party,
    COUNT(*) AS count
FROM observation
WHERE equity_return > 0
GROUP BY party
ORDER BY count DESC
;
```

```
 party | count
-------+-------
 D     |    17
 R     |    13
(2 rows)
```

In this sample, the Democratic Party coincides with positive equity returns
more often than the Republican Party.

11. Again grouping by party, we can compute the average returns and risk-free
  rates under each party.

```sql
SELECT
    party,
    AVG(equity_return) AS average_equity_return,
    AVG(risk_free_rate) AS average_risk_free_rate
FROM observation
GROUP BY party
ORDER BY party
;
```

```
 party | average_equity_return | average_risk_free_rate
-------+-----------------------+------------------------
 D     |    15.882105263157895 |     4.0884210526315785
 R     |     8.368888888888888 |      4.896111111111112
(2 rows)
```

In this sample, although the average risk-free rates are close (about 4 percent
compared with around 5 percent), the average equity returns are very different
(around 15 percent compared with around 8 percent).

12. 