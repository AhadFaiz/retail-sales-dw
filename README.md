# Retail Sales Data Warehouse

## Overview
This project builds a modern data warehouse on Snowflake using dbt for a retail analytics company, transforming raw AdventureWorks data into an analytics-ready dimensional model to support sales, customer, and product performance reporting.

## Architecture

- **RAW** (`RETAIL_SALES_RAW`): Raw AdventureWorks CSVs loaded via SnowSQL, no transformations.
- **SNPT** (`RETAIL_SALES_SNPT`): dbt snapshots tracking historical changes in source tables (check strategy).
- **STG** (`RETAIL_SALES_STG`): Cleaned staging views — snake_case columns, active records only.
- **PROD** (`RETAIL_SALES_PROD`): Dimension, fact, and reporting tables for analytics.

## Setup Instructions

1. Create and activate a virtual environment:
```bash
   python3 -m venv .venv
   source .venv/bin/activate
```
2. Install dependencies:
```bash
   pip install -r requirements.txt
```
3. Configure `~/.dbt/profiles.yml` with your Snowflake credentials (see `profiles.example.yml` for structure).
4. Verify the connection:
```bash
   dbt debug
```

## How to Run

```bash
dbt snapshot                          # Build historical snapshots
dbt build --select path:models/staging   # Build staging views + tests
dbt build --select path:models/marts     # Build dimension/fact/reporting tables
dbt build                             # Run everything end-to-end
dbt build --full-refresh              # Force full rebuild if needed
```

## Model Reference

| Model | Layer | Materialization | Grain |
|---|---|---|---|
| snap_customer, snap_person, snap_product, etc. | SNPT | snapshot | One row per historical version |
| stg_customer, stg_address, stg_product, etc. | STG | view | One row per active record |
| dim_customer | PROD | incremental | One row per customer |
| dim_product | PROD | incremental | One row per product |
| dim_location | PROD | incremental | One row per address |
| fct_sales_per_order_line | PROD | incremental | One row per sales order line |
| rep_monthly_sales | PROD | table | One row per month/category/territory |

## Data Quality Notes

See [`docs/data-quality-notes.md`](docs/data-quality-notes.md) for full findings. Summary:
- No NULLs found in primary keys across raw tables.
- No duplicate primary keys found.
- `RAW_COUNTRYREGION` contains 238 valid, consistently formatted country codes.

## Incremental Logic Verification

`dbt build` was run twice consecutively to confirm incremental models only process new/changed data on the second run (screenshots included in submission). After fixing a filter condition (`>=` → `>`) in `dim_customer`, the second run affected 0 rows, confirming the incremental logic works as intended.