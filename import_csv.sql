-- import_csv.sql
-- Copyright (c) 2025 Ishan Pranav
-- Licensed under the MIT license.

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
