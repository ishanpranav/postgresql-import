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
  real_value,
  equity_return,
  risk_free_rate,
  party
)
FROM 'data/fredgraph.csv' WITH (FORMAT 'csv', DELIMITER ',', HEADER)
;
```

## Database information

## Query results
