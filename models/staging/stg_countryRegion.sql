-- models/staging/stg_countryregion.sql
-- Reads raw country region data

select distinct
    countryregioncode as country_region_code,
    name as country,
    currencycode as currency_code,
    modifieddate as modified_date

from {{ ref('countryregion_snapshot') }}

where  countryregioncode is not null and
dbt_valid_to is null