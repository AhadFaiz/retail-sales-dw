-- modelssnapshots/snap_stateprovince.sql
-- ==========================================================
-- Purpose:
-- Tracks historical changes in state or province reference data.
-- Captures updates to name, code, territory, and status flags.
-- ==========================================================

{% snapshot stateprovince_snapshot %}

{{
    config(
        target_schema='SNPT',
        unique_key = 'stateprovinceid',
        strategy = 'check',                   
        check_cols = [                        
            'stateprovincecode',
            'countryregioncode',
            'isonlystateprovinceflag',
            'name',
            'territoryid'
        ]
    )
}}

-- Select the source data directly (no transformations)
select distinct
    stateprovinceid,          -- Business key for state/province
    stateprovincecode,        -- State or province short code
    countryregioncode,        -- Foreign key to related country/region
    isonlystateprovinceflag,  -- Boolean flag for unique state/province representation
    name,                     -- Full name of the state/province
    territoryid,              -- Sales or geographic territory reference
    modifieddate,             -- Last updated timestamp
    rowguid                   -- Globally unique identifier
from {{ source('raw_data_source', 'RAW_STATEPROVINCE') }}

{% endsnapshot %}