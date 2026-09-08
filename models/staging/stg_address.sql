-- models/staging/stg_address.sql
-- Reads raw address data
-- No need for Snapshot.
-- addressid is stored in RAW_SALESORDERHEADER table. Even if the address for a customer changes, orders were shipped to their previous address. 
-- So, the existing address for that customer should be kept, and the new address record should be stored with a new addressid. No need to update previous records.

select distinct
    addressid as address_id,
    addressline1 as address_line_1,
    addressline2 as address_line_2,
    city,
    stateprovinceid as state_province_id,
    postalcode as postal_code,
    spatiallocation as spatial_location,
    modifieddate as modified_date

from {{ source('raw_data_source', 'RAW_ADDRESS') }}