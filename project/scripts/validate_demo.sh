#!/bin/bash

# This script checks that the runtime outputs match the expected scenario.

# Load expected values such as MAX_PALLETS_PER_RUN and FINAL_STATUS.
. config/assignment_rules.conf

# Validate that the status event log exists.
if [ ! -f runtime/logs/status_log.csv ]; then
    echo "[FLOWCORE] Validation failed: missing runtime/logs/status_log.csv"
    exit 1
fi

# Validate that the pallet final-state snapshot exists.
if [ ! -f runtime/snapshots/pallet_state.csv ]; then
    echo "[FLOWCORE] Validation failed: missing runtime/snapshots/pallet_state.csv"
    exit 1
fi

# Validate that the location usage snapshot exists.
if [ ! -f runtime/snapshots/location_usage.csv ]; then
    echo "[FLOWCORE] Validation failed: missing runtime/snapshots/location_usage.csv"
    exit 1
fi

# Count processed pallets, excluding the CSV header row.
pallet_count=$(tail -n +2 runtime/snapshots/pallet_state.csv | wc -l)

# Count generated status events, excluding the CSV header row.
event_count=$(tail -n +2 runtime/logs/status_log.csv | wc -l)

# Count pallets that reached the configured final status.
stored_count=$(grep -c ",$FINAL_STATUS$" runtime/snapshots/pallet_state.csv)

# Count pallets that have no assigned location.
unassigned_count=0
while IFS=',' read -r pallet_id receipt_id sku quantity location_id status
do
    if [ "$pallet_id" = "pallet_id" ]; then
        continue
    fi

    if [ -z "$location_id" ]; then
        unassigned_count=$((unassigned_count + 1))
    fi
done < runtime/snapshots/pallet_state.csv

# Count locations where used_after_run is greater than capacity.
capacity_violations=0
while IFS=',' read -r loc_id zone capacity used_after_run active priority
do
    if [ "$loc_id" = "location_id" ]; then
        continue
    fi

    if [ "$used_after_run" -gt "$capacity" ]; then
        capacity_violations=$((capacity_violations + 1))
    fi
done < runtime/snapshots/location_usage.csv

# Each pallet should produce 3 events: RECEIVED, ASSIGNED, and STORED.
expected_events=$((MAX_PALLETS_PER_RUN * 3))

# Validate that the expected number of pallets was processed.
if [ "$pallet_count" -ne "$MAX_PALLETS_PER_RUN" ]; then
    echo "[FLOWCORE] Validation failed: expected $MAX_PALLETS_PER_RUN pallets, got $pallet_count"
    exit 1
fi

# Validate that all processed pallets reached the final status.
if [ "$stored_count" -ne "$MAX_PALLETS_PER_RUN" ]; then
    echo "[FLOWCORE] Validation failed: expected $MAX_PALLETS_PER_RUN stored pallets, got $stored_count"
    exit 1
fi

# Validate the event count.
if [ "$event_count" -ne "$expected_events" ]; then
    echo "[FLOWCORE] Validation failed: expected $expected_events events, got $event_count"
    exit 1
fi

# Validate that no pallet is missing a location assignment.
if [ "$unassigned_count" -ne 0 ]; then
    echo "[FLOWCORE] Validation failed: $unassigned_count pallets have no location assignment"
    exit 1
fi

# Validate that no location exceeds capacity.
if [ "$capacity_violations" -ne 0 ]; then
    echo "[FLOWCORE] Validation failed: $capacity_violations capacity violations found"
    exit 1
fi

echo "[FLOWCORE] Validation passed: $stored_count pallets stored, $event_count events logged, no capacity violations."
