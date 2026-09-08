-- models/staging/stg_stateprovince.sql
-- Reads raw state province data

select distinct
    stateprovinceid as state_province_id,
    stateprovincecode as state_province_code,
    countryregioncode as country_region_code, 
    isonlystateprovinceflag as is_only_state_province_flag,
    name as state,
    territoryid as territory_id,
    modifieddate as modified_date

from {{ ref('stateprovince_snapshot') }}

where dbt_valid_to is null