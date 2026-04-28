# FlowCore Warehouse Project

FlowCore is a compact inbound warehouse commissioning simulation. It demonstrates how a small warehouse process can be configured, executed, stored, validated, and presented through separate technical layers.

## Team Members

Arsenios Diamantakos
@panagiotispontikeas

## Project Scope

The selected scenario follows one controlled inbound flow:

- receive goods at DOCK-01
- represent the goods as pallets
- assign pallets to valid warehouse locations
- record warehouse status events
- validate the final stored state

The baseline result is 3 stored pallets, 9 status events, no location capacity violations, a valid PL/SQL available-slots function, and a passing C++ priority placement decision check.

## Main Project Folders

- project/config: scenario input files and warehouse rules
- project/scripts: Bash setup, run, validation, and reset scripts
- project/sql: Oracle schema, sample data, and SQL operations
- project/plsql: PL/SQL warehouse helper function
- project/cpp: C++ priority placement decision checker
- project/runtime: generated logs, snapshots, and reports
- project/docs: final documentation and presentation files

## Run Order

1. Open the project folder.
2. Run the Bash setup, demo, and validation scripts.
3. Run the Oracle schema file.
4. Run the Oracle sample data file.
5. Run the SQL operations file.
6. Run the PL/SQL logic pack.
7. Build and run the C++ priority placement checker.

## Deliverables

The project documentation covers D01 through D12:

- requirements, scope, and assumptions
- warehouse process flow
- architecture
- environment setup
- Bash runtime execution
- Oracle schema and sample data
- SQL operations
- PL/SQL logic
- C++ logic module
- validation and deployment pack
- executive summary
- final team presentation

This repository is the final FlowCore project workspace prepared for review and demonstration.
