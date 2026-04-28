# FlowCore Project

## Current Scope

FlowCore is currently scoped as a compact inbound warehouse commissioning simulation.

## Team Members

Arsenios Diamantakos
Panagiotis Pontikeas Eftychiadis

The selected flow is:

- receive incoming goods at an inbound dock
- represent them as inbound pallets
- assign each pallet to one valid warehouse location
- record status or event changes
- validate the final state

## Current Structure

- config/: input data and assignment rules
- scripts/: setup, run, validation, and reset scripts
- runtime/: generated logs and snapshots
- sql/: schema, sample data, and queries
- plsql/: simple PL/SQL warehouse helper function
- cpp/: C++ priority placement decision checker
- docs/: final PDF documentation and presentation files

## Current Documentation

- D01.pdf
- D02.pdf
- D03.pdf
- D04.pdf
- D05.pdf
- D06.pdf
- D07.pdf
- D08.pdf
- D09.pdf
- D10.pdf
- D11.pdf
- D12.pptx

## Run Order

1. Run D05 Bash setup, execution, and validation.
2. Run sql/MySchema.sql.
3. Run sql/Sample_Data.sql.
4. Run sql/SQL_Operations.sql.
5. Run plsql/PLSQL_Logic_Pack.sql.
6. Build and run cpp/flowcore_priority_checker.cpp.

The current verified baseline is 3 stored pallets, 9 status events, no location capacity violations, a valid PL/SQL available-slots function, and a passing C++ priority placement decision check.
