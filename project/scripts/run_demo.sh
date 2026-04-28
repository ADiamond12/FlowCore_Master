#!/bin/bash

# D05 run script for the FlowCore inbound warehouse demo.
# This script reads the config files, processes inbound pallets,
# assigns valid locations, and writes runtime CSV outputs.

# Load assignment settings such as preferred zone, max pallets per run,
# inactive-location handling, and expected final status.
. config/assignment_rules.conf

# Ensure runtime output folders exist before writing files.
mkdir -p runtime/logs runtime/snapshots

# Create the status log header.
# Each later row represents one event in the pallet lifecycle.
echo "event_id,pallet_id,status,location_id,message" > runtime/logs/status_log.csv

# Create the pallet state snapshot header.
# Each later row represents the final state of one processed pallet.
echo "pallet_id,receipt_id,sku,quantity,location_id,status" > runtime/snapshots/pallet_state.csv

# event_id is incremented every time a status event is written.
event_id=1

# processed controls how many pallets are handled in this run.
# The limit comes from MAX_PALLETS_PER_RUN in assignment_rules.conf.
processed=0

# Read each inbound pallet row from receipt_data.csv.
while IFS=',' read -r receipt_id dock_id pallet_id sku quantity
do
    # Skip the CSV header row.
    if [ "$receipt_id" = "receipt_id" ]; then
        continue
    fi

    # Stop when the configured maximum number of pallets has been processed.
    if [ "$processed" -ge "$MAX_PALLETS_PER_RUN" ]; then
        break
    fi

    # location_id starts empty and is filled when a valid location is found.
    location_id=""

    # Scan the configured warehouse locations to find the first valid match.
    while IFS=',' read -r loc_id zone capacity used active priority
    do
        # Skip the location CSV header row.
        if [ "$loc_id" = "location_id" ]; then
            continue
        fi

        # Only use locations from the preferred zone configured for the run.
        if [ "$zone" = "$PREFERRED_ZONE" ]; then
            # Use active locations, unless inactive locations are explicitly allowed.
            if [ "$ALLOW_INACTIVE_LOCATIONS" = "Y" ] || [ "$active" = "Y" ]; then
                # Avoid assigning more than one pallet to the same location in this demo.
                if ! grep -q ",$loc_id," runtime/snapshots/pallet_state.csv; then
                    location_id="$loc_id"
                    break
                fi
            fi
        fi
    done < config/locations.csv

    # If no valid location was found, stop the run with a clear error.
    if [ -z "$location_id" ]; then
        echo "[FLOWCORE] No valid location available for pallet $pallet_id"
        exit 1
    fi

    # Record the first lifecycle event: pallet was received at the dock.
    echo "$event_id,$pallet_id,RECEIVED,$dock_id,Pallet received at dock" >> runtime/logs/status_log.csv
    event_id=$((event_id + 1))

    # Record the second lifecycle event: a warehouse location was assigned.
    echo "$event_id,$pallet_id,ASSIGNED,$location_id,Location assigned by rules" >> runtime/logs/status_log.csv
    event_id=$((event_id + 1))

    # Write the final pallet snapshot row.
    # This is the current/final state used later by validate_demo.sh.
    echo "$pallet_id,$receipt_id,$sku,$quantity,$location_id,$FINAL_STATUS" >> runtime/snapshots/pallet_state.csv

    # Record the final lifecycle event: pallet reached the configured final status.
    echo "$event_id,$pallet_id,$FINAL_STATUS,$location_id,Pallet stored successfully" >> runtime/logs/status_log.csv
    event_id=$((event_id + 1))

    # Count this pallet as successfully processed.
    processed=$((processed + 1))
done < config/receipt_data.csv

# Create the location usage snapshot header.
# This file is used to validate that no location exceeds capacity.
echo "location_id,zone,capacity,used_after_run,active,priority" > runtime/snapshots/location_usage.csv

# Re-read locations and calculate used_after_run for each one.
while IFS=',' read -r loc_id zone capacity used active priority
do
    # Skip the CSV header row.
    if [ "$loc_id" = "location_id" ]; then
        continue
    fi

    # Count how many processed pallets were assigned to this location.
    assigned_count=$(grep -c ",$loc_id," runtime/snapshots/pallet_state.csv)

    # Combine the starting used value with assignments from this run.
    used_after_run=$((used + assigned_count))

    # Write the final usage state for validation and reporting.
    echo "$loc_id,$zone,$capacity,$used_after_run,$active,$priority" >> runtime/snapshots/location_usage.csv
done < config/locations.csv

# Print a short completion message when all outputs are generated.
echo "[FLOWCORE] Demo run completed."
