# Data Quality Notes

## RAW_CUSTOMER
- Checked for NULLs in CUSTOMERID: none found
- Checked for duplicate CUSTOMERID values: none found

## RAW_ADDRESS
- Checked for NULLs in ADDRESSID: none found

## RAW_COUNTRYREGION
- COUNTRYREGIONCODE contains 238 distinct values
- All values appear to be valid 2-letter country codes, no obvious formatting issues

## General Notes
- Raw tables loaded via SnowSQL PUT + COPY INTO, verified row counts match expected volumes for all 10 tables
- No header rows in source CSVs; column names and types were manually defined per Solution Scripts structure
