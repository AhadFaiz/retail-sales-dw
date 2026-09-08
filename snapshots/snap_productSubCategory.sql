-- snapshots/snap_productsubcategory.sql
-- ==========================================================
-- Purpose:
-- Tracks historical changes in product subcategory reference data.
-- Captures updates to names and category relationships over time.
-- ==========================================================

{% snapshot productsubcategory_snapshot %}

{{
    config(
        target_schema='SNPT',
        unique_key = 'productsubcategoryid',   
        strategy = 'check',                    
        check_cols = [                         
            'productcategoryid',
            'name'
        ]
    )
}}

-- Select source data directly (no transformations)
select distinct
    productsubcategoryid,   -- Business key for subcategory
    productcategoryid,      -- Foreign key to related product category
    name,                   -- Name of the product subcategory
    modifieddate,           -- Last modified timestamp
    rowguid                 -- Globally unique identifier
from {{ source('raw_data_source', 'RAW_PRODUCTSUBCATEGORY') }}

{% endsnapshot %}
