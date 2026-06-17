-- Tokai Logistics Database Schema
-- Single table design for last-mile delivery performance analysis

CREATE TABLE IF NOT EXISTS deliveries (
    Package_ID                    TEXT     PRIMARY KEY,
    Origin_Hub                    TEXT     NOT NULL,
    Destination_Prefecture        TEXT     NOT NULL,
    Destination_Ward              TEXT     NOT NULL,
    Delivery_Window               TEXT     NOT NULL,
    Scheduled_Delivery_DateTime   DATETIME NOT NULL,
    Actual_Delivery_DateTime      DATETIME NOT NULL,
    Delay_Minutes                 INTEGER  NOT NULL,
    Delivery_Status               TEXT     NOT NULL,
    Weather_Condition             TEXT     NOT NULL,
    Vehicle_Type                  TEXT     NOT NULL,
    Package_Weight_kg             REAL     NOT NULL,
    Delivery_Attempt_Number       INTEGER  NOT NULL,
    Driver_ID                     TEXT     NOT NULL,
    Redelivery_Cost_JPY           INTEGER  NOT NULL,
    SLA_Penalty_JPY               INTEGER  NOT NULL,
    Total_Revenue_Impact_JPY      INTEGER  NOT NULL
);

-- Index on commonly filtered columns for query performance
CREATE INDEX idx_origin_hub ON deliveries(Origin_Hub);
CREATE INDEX idx_delivery_status ON deliveries(Delivery_Status);
CREATE INDEX idx_scheduled_date ON deliveries(Scheduled_Delivery_DateTime);