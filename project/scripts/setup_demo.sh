#!/bin/bash

# This script prepares a clean runtime area before the scenario runs.

# Create the output folders if they do not already exist.
mkdir -p runtime/logs runtime/snapshots runtime/reports

# Remove old generated files from previous runs.
rm -f runtime/logs/* runtime/snapshots/* runtime/reports/*

echo "[FLOWCORE] Runtime environment prepared."
