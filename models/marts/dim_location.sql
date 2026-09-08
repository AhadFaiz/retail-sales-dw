-- models/marts/dim_location.sql
-- ===========================================================
-- Dimension table for location details
-- Preserves historical versions of addresses (Type 2 style)
-- Grain: One row per address version
-- A single customer can have multiple addresses, so address records can be simply added with a new addressid.
-- But, data might have been updated in stg_stateProvince and stg_countryRegion. So, we neeed the 'merge' strategy.
-- ===========================================================

{{
    config(
        incremental_strategy='merge', 
        unique_key = 'address_id'
    )
}}

-- is_incremental() condition is FALSE for the first run. If 'dim_location` table exists, then this 'if' statement will be executed 
-- Determine the most recent modification date in the existing table
-- to process only new or changed records during incremental runs
{% if is_incremental() %}
    {% set MAX_START_DATE_query %}
        select ifnull(max(modified_at), '1900-01-01') from {{ this }} as MAX_START_DT
    {% endset %}

    {% if execute %}
        {% set MAX_START_DT = run_query(MAX_START_DATE_query).columns[0][0] %}
    {% endif %}
{% endif %}

-- Joind Data from different staging views to create dimension table
with joined_location_data as (
    select
    a.address_id,
    a.address_line_1,
    a.address_line_2,
    a.city,
    s.state_province_code,
    s.state,
    s.territory_id,
    a.postal_code,
    c.country_region_code,
    c.country,
    greatest(a.modified_date, s.modified_date, c.modified_date) as modified_at

from {{ ref('stg_address') }} a
left join {{ ref('stg_stateProvince') }} s
    on a.state_province_id = s.state_province_id
left join {{ ref('stg_countryRegion') }} c
    on s.country_region_code = c.country_region_code
)

select *
from joined_location_data

-- Incremental filter: only include records modified after the last load
{% if is_incremental() %}
where modified_at >= '{{ MAX_START_DT }}'
{% endif %}
