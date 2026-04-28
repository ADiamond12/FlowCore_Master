-- Run MySchema.sql before this file.

-- Clear old sample data before inserting the baseline again.
DELETE FROM STATUS_EVENT;
DELETE FROM PALLET;
DELETE FROM LOCATION;
DELETE FROM RECEIPT;

COMMIT;

-- Insert the inbound receipt used by the current FlowCore scenario.
INSERT INTO RECEIPT VALUES ('RCV-1001', 'DOCK-01', 'COMPLETE');

-- Insert warehouse locations.
-- A01, A02, and A03 are used by the three pallets.
-- B01 is an active reserve location.
-- C01 is inactive and supports filtering examples.
INSERT INTO LOCATION VALUES ('A01', 'INBOUND_A', 1, 1, 'Y', 3);
INSERT INTO LOCATION VALUES ('A02', 'INBOUND_A', 1, 1, 'Y', 3);
INSERT INTO LOCATION VALUES ('A03', 'INBOUND_A', 1, 1, 'Y', 2);
INSERT INTO LOCATION VALUES ('B01', 'RESERVE_B', 2, 0, 'Y', 1);
INSERT INTO LOCATION VALUES ('C01', 'HOLDING_C', 1, 0, 'N', 0);

-- Insert the three pallets from the inbound receipt dataset.
-- Each pallet has a SKU, quantity, assigned location, and final status.
INSERT INTO PALLET VALUES ('PLT-1001', 'RCV-1001', 'SKU-RED-01', 12, 'A01', 'STORED');
INSERT INTO PALLET VALUES ('PLT-1002', 'RCV-1001', 'SKU-BLUE-02', 8, 'A02', 'STORED');
INSERT INTO PALLET VALUES ('PLT-1003', 'RCV-1001', 'SKU-GREEN-03', 15, 'A03', 'STORED');

-- Insert the lifecycle events for PLT-1001.
-- The flow is RECEIVED -> ASSIGNED -> STORED.
INSERT INTO STATUS_EVENT VALUES (1, 'PLT-1001', 'RECEIVED', 'DOCK-01', 'Pallet received at dock');
INSERT INTO STATUS_EVENT VALUES (2, 'PLT-1001', 'ASSIGNED', 'A01', 'Location assigned by rules');
INSERT INTO STATUS_EVENT VALUES (3, 'PLT-1001', 'STORED', 'A01', 'Pallet stored successfully');

-- Insert the lifecycle events for PLT-1002.
INSERT INTO STATUS_EVENT VALUES (4, 'PLT-1002', 'RECEIVED', 'DOCK-01', 'Pallet received at dock');
INSERT INTO STATUS_EVENT VALUES (5, 'PLT-1002', 'ASSIGNED', 'A02', 'Location assigned by rules');
INSERT INTO STATUS_EVENT VALUES (6, 'PLT-1002', 'STORED', 'A02', 'Pallet stored successfully');

-- Insert the lifecycle events for PLT-1003.
INSERT INTO STATUS_EVENT VALUES (7, 'PLT-1003', 'RECEIVED', 'DOCK-01', 'Pallet received at dock');
INSERT INTO STATUS_EVENT VALUES (8, 'PLT-1003', 'ASSIGNED', 'A03', 'Location assigned by rules');
INSERT INTO STATUS_EVENT VALUES (9, 'PLT-1003', 'STORED', 'A03', 'Pallet stored successfully');

COMMIT;
