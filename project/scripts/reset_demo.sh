#!/bin/bash

# This script clears generated runtime files after a run.

# Ensure the runtime folders exist before trying to clean them.
mkdir -p runtime/logs runtime/snapshots runtime/reports

# Delete generated logs and snapshots.
# Source files under config/ are not touched.
rm -f runtime/logs/* runtime/snapshots/* runtime/reports/*

echo "[FLOWCORE] Runtime outputs cleared."
