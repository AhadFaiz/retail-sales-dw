-- models/staging/stg_customer.sql
-- Cleans and selects historically accurate customer data from the dbt snapshot.

-- Source data now comes from the snapshot table, which includes history (SCD Type 2 columns)
select distinct
    customerid as customer_id,
    -- Apply the transformation logic
    replace(accountnumber, 'CustNo', 'AW') as account_number,
    personid as person_id,
    storeid as store_id,
    territoryid as territory_id,
    modifieddate as modified_date
    
from {{ ref('customer_snapshot') }}

where dbt_valid_to is null