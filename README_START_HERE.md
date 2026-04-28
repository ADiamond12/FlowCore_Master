# FlowCore Master Workspace

This folder is the active FlowCore project workspace.

The current implementation is a compact inbound warehouse commissioning simulation. It contains the Bash runtime flow, Oracle SQL schema and data, SQL operations, PL/SQL logic, C++ priority placement logic, and the final project documentation.

## Team Members

Arsenios Diamantakos
Panagiotis Pontikeas Eftychiadis

## Active Project Root

Use this folder first:

project/

## Current Scenario

The current FlowCore scenario is:

- receive inbound goods at DOCK-01
- represent the goods as pallets
- assign pallets to warehouse locations
- record status events
- validate the final stored state

## Current Deliverable Status

- D01 to D04: scope, process, architecture, and setup documentation
- D05: Linux/Bash operational flow
- D06: Oracle schema and sample data
- D07: SQL operations pack
- D08: PL/SQL logic pack
- D09: C++ priority placement decision checker
- D10: test, validation, and deployment pack
- D11: executive summary presentation
- D12: final team presentation

## Main Folders

- project/config: scenario input files
- project/scripts: Bash run and validation scripts
- project/sql: Oracle SQL schema, sample data, and SQL operations
- project/plsql: PL/SQL logic pack
- project/cpp: C++ priority placement decision checker
- project/docs: project documentation and generated documents
- project/runtime: generated runtime logs and snapshots

## Recommended Run Order

1. Run D05 Bash setup, execution, and validation
2. Run D06 Oracle schema
3. Run D06 sample data
4. Run D07 SQL operations
5. Run D08 PL/SQL logic
6. Build and run D09 C++ priority placement decision checker

This workspace is the current source of truth for the FlowCore project.
