-- Run this file after MySchema.sql and Sample_Data.sql.
-- The function returns the available slot count for one warehouse location.
-- A location with 0 available slots should not
-- receive another pallet.
CREATE OR REPLACE FUNCTION GET_LOCATION_AVAILABLE_SLOTS (
    P_LOCATION_ID IN LOCATION.LOCATION_ID%TYPE
) RETURN NUMBER
AS
    V_CAPACITY LOCATION.CAPACITY%TYPE;
    V_USED_SLOTS LOCATION.USED_SLOTS%TYPE;
    V_ASSIGNED_PALLETS NUMBER;
BEGIN
    -- Read the configured capacity and existing used slots for the location.
    SELECT
        CAPACITY,
        USED_SLOTS
    INTO
        V_CAPACITY,
        V_USED_SLOTS
    FROM LOCATION
    WHERE LOCATION_ID = P_LOCATION_ID;

    -- Count pallets currently assigned to the same location in the demo data.
    SELECT COUNT(*)
    INTO V_ASSIGNED_PALLETS
    FROM PALLET
    WHERE LOCATION_ID = P_LOCATION_ID;

    RETURN V_CAPACITY - V_USED_SLOTS - V_ASSIGNED_PALLETS;
EXCEPTION
   
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

-- Show each location and the remaining slots calculated by the function.
SELECT
    LOCATION_ID,
    ZONE_CODE,
    CAPACITY,
    USED_SLOTS,
    GET_LOCATION_AVAILABLE_SLOTS(LOCATION_ID) AS AVAILABLE_SLOTS
FROM LOCATION
ORDER BY LOCATION_ID;

-- Function compile check:
SELECT
    OBJECT_NAME,
    OBJECT_TYPE,
    STATUS
FROM USER_OBJECTS
WHERE OBJECT_NAME = 'GET_LOCATION_AVAILABLE_SLOTS';
