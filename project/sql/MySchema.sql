-- Run this file before Sample_Data.sql.

-- Drop old demo tables first so the schema can be rebuilt cleanly.
DROP TABLE IF EXISTS STATUS_EVENT;
DROP TABLE IF EXISTS PALLET;
DROP TABLE IF EXISTS LOCATION;
DROP TABLE IF EXISTS RECEIPT;

-- RECEIPT stores the inbound receipt header.
-- In this scenario, pallets arrive under one receipt at one dock.
CREATE TABLE RECEIPT (
    RECEIPT_ID VARCHAR2(20),
    DOCK_ID VARCHAR2(20) NOT NULL,
    RECEIPT_STATUS VARCHAR2(20) NOT NULL,
    PRIMARY KEY (RECEIPT_ID)
);

-- LOCATION stores the warehouse locations available to the demo.
-- Capacity, active flag, and priority support assignment and validation logic.
CREATE TABLE LOCATION (
    LOCATION_ID VARCHAR2(10),
    ZONE_CODE VARCHAR2(20) NOT NULL,
    CAPACITY NUMBER NOT NULL,
    USED_SLOTS NUMBER NOT NULL,
    ACTIVE_FLAG CHAR(1) NOT NULL,
    PRIORITY NUMBER NOT NULL,
    PRIMARY KEY (LOCATION_ID)
);

-- PALLET stores the current state of each inbound pallet.
-- RECEIPT_ID links each pallet to the receipt.
-- LOCATION_ID links each pallet to the final warehouse location.
CREATE TABLE PALLET (
    PALLET_ID VARCHAR2(20),
    RECEIPT_ID VARCHAR2(20) NOT NULL,
    SKU_CODE VARCHAR2(30) NOT NULL,
    QUANTITY NUMBER NOT NULL,
    LOCATION_ID VARCHAR2(10),
    CURRENT_STATUS VARCHAR2(20) NOT NULL,
    PRIMARY KEY (PALLET_ID),
    FOREIGN KEY (RECEIPT_ID) REFERENCES RECEIPT (RECEIPT_ID),
    FOREIGN KEY (LOCATION_ID) REFERENCES LOCATION (LOCATION_ID)
);

-- STATUS_EVENT stores the pallet status history.
-- PALLET shows the current state; STATUS_EVENT shows the lifecycle trail.
CREATE TABLE STATUS_EVENT (
    EVENT_ID NUMBER,
    PALLET_ID VARCHAR2(20) NOT NULL,
    STATUS_CODE VARCHAR2(20) NOT NULL,
    EVENT_POINT VARCHAR2(20) NOT NULL,
    NOTE_TEXT VARCHAR2(100),
    PRIMARY KEY (EVENT_ID),
    FOREIGN KEY (PALLET_ID) REFERENCES PALLET (PALLET_ID)
);
