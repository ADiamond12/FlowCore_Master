-- This file runs after MySchema.sql and Sample_Data.sql.

-- This confirms the inbound receipt exists before we query pallets.
SELECT * FROM RECEIPT;

-- Show the main pallet fields used by the scenario.
SELECT
    PALLET_ID,
    SKU_CODE,
    QUANTITY,
    LOCATION_ID,
    CURRENT_STATUS
FROM PALLET
ORDER BY PALLET_ID;

-- Show only pallets that reached the final STORED status.
SELECT
    PALLET_ID,
    SKU_CODE,
    QUANTITY,
    LOCATION_ID,
    CURRENT_STATUS
FROM PALLET
WHERE CURRENT_STATUS = 'STORED'
ORDER BY QUANTITY DESC;

-- Show only active warehouse locations.
SELECT
    LOCATION_ID,
    ZONE_CODE,
    CAPACITY,
    USED_SLOTS,
    ACTIVE_FLAG,
    PRIORITY
FROM LOCATION
WHERE ACTIVE_FLAG = 'Y'
ORDER BY PRIORITY DESC, LOCATION_ID;

-- Join pallets to their receipt.
-- INNER JOIN is correct here because every pallet in this scenario
-- must belong to an existing receipt.
SELECT
    P.PALLET_ID,
    P.SKU_CODE,
    P.QUANTITY,
    R.RECEIPT_ID,
    R.DOCK_ID,
    R.RECEIPT_STATUS
FROM PALLET P
INNER JOIN RECEIPT R
    ON P.RECEIPT_ID = R.RECEIPT_ID
ORDER BY P.PALLET_ID;

-- Join pallets to their final warehouse location.
-- This shows where each pallet was stored and brings in location details.
SELECT
    P.PALLET_ID,
    P.LOCATION_ID,
    L.ZONE_CODE,
    L.CAPACITY,
    L.ACTIVE_FLAG
FROM PALLET P
INNER JOIN LOCATION L
    ON P.LOCATION_ID = L.LOCATION_ID
ORDER BY P.LOCATION_ID;

-- Join status events to pallets.
-- This confirms that every status event belongs to a real pallet.
SELECT
    E.EVENT_ID,
    E.PALLET_ID,
    E.STATUS_CODE,
    E.EVENT_POINT,
    E.NOTE_TEXT
FROM STATUS_EVENT E
INNER JOIN PALLET P
    ON E.PALLET_ID = P.PALLET_ID
ORDER BY E.EVENT_ID;

-- Count all pallets in the current scenario.
SELECT COUNT(*) AS TOTAL_PALLETS
FROM PALLET;

-- Count pallets and total quantity per receipt.
SELECT
    RECEIPT_ID,
    COUNT(*) AS PALLET_COUNT,
    SUM(QUANTITY) AS TOTAL_QUANTITY
FROM PALLET
GROUP BY RECEIPT_ID;

-- Count pallets and total quantity per location.
SELECT
    LOCATION_ID,
    COUNT(*) AS PALLET_COUNT,
    SUM(QUANTITY) AS TOTAL_QUANTITY
FROM PALLET
GROUP BY LOCATION_ID
ORDER BY LOCATION_ID;

-- Count how many events exist for each status.
SELECT
    STATUS_CODE,
    COUNT(*) AS EVENT_COUNT
FROM STATUS_EVENT
GROUP BY STATUS_CODE
ORDER BY STATUS_CODE;

-- Show only location groups that currently have at least one pallet.
SELECT
    LOCATION_ID,
    COUNT(*) AS PALLET_COUNT
FROM PALLET
GROUP BY LOCATION_ID
HAVING COUNT(*) >= 1
ORDER BY LOCATION_ID;

-- Validation check 1:
-- A pallet with status STORED should always have a location.
SELECT
    PALLET_ID,
    CURRENT_STATUS,
    LOCATION_ID
FROM PALLET
WHERE CURRENT_STATUS = 'STORED'
  AND LOCATION_ID IS NULL;

-- Validation check 2:
-- Check whether any location has more assigned pallets than its capacity.
SELECT
    L.LOCATION_ID,
    L.CAPACITY,
    COUNT(P.PALLET_ID) AS ASSIGNED_PALLETS
FROM LOCATION L
LEFT JOIN PALLET P
    ON L.LOCATION_ID = P.LOCATION_ID
GROUP BY L.LOCATION_ID, L.CAPACITY
HAVING COUNT(P.PALLET_ID) > L.CAPACITY
ORDER BY L.LOCATION_ID;

-- Validation check 3:
-- Find status events that reference a pallet that does not exist.
SELECT
    E.EVENT_ID,
    E.PALLET_ID
FROM STATUS_EVENT E
LEFT JOIN PALLET P
    ON E.PALLET_ID = P.PALLET_ID
WHERE P.PALLET_ID IS NULL
ORDER BY E.EVENT_ID;

-- Show the original priority of B01 before the update.
SELECT
    LOCATION_ID,
    PRIORITY
FROM LOCATION
WHERE LOCATION_ID = 'B01';

-- Temporarily update B01 priority to demonstrate an UPDATE statement.
UPDATE LOCATION
SET PRIORITY = 2
WHERE LOCATION_ID = 'B01';

-- Show the updated value after the UPDATE.
SELECT
    LOCATION_ID,
    PRIORITY
FROM LOCATION
WHERE LOCATION_ID = 'B01';

-- Undo the update.
ROLLBACK;

-- Confirm that the priority returned to its original value.
SELECT
    LOCATION_ID,
    PRIORITY
FROM LOCATION
WHERE LOCATION_ID = 'B01';
