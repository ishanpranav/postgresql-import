-- import_csv.sql
-- Copyright (c) 2025 Ishan Pranav
-- Licensed under the MIT license.

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
