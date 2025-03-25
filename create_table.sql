-- create_table.sql
-- Copyright (c) 2025 Ishan Pranav
-- Licensed under the MIT license.

CREATE TABLE observation (
    "date"         DATE             PRIMARY KEY,
    debt_value     DECIMAL(10, 2)   NOT NULL,
    real_value     DECIMAL(10, 2)   NOT NULL,
    equity_return  DOUBLE PRECISION NOT NULL,
    risk_free_rate DOUBLE PRECISION NOT NULL,
    party          CHAR(1)          NOT NULL
);
