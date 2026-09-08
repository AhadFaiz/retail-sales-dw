-- snapshots/snap_person.sql
-- ==========================================================

-- Where the historical table will be saved
-- The column that uniquely identifies the entity being tracked
-- Specifies that dbt should look for changes in specific columns
-- List of columns that, if changed, trigger a new historical record

{% snapshot person_snapshot %}

{{
    config(
        target_schema='SNPT',
        unique_key = 'businessentityid',
        strategy = 'check',
        check_cols = [                             
            'persontype',
            'namestyle',
            'title',
            'firstname',
            'middlename',
            'lastname',
            'suffix',
            'emailpromotion',
            'additionalcontactinfo',
        ]
    )
}}

select
    businessentityid,
    persontype,
    namestyle,
    title,
    firstname,
    middlename,
    lastname,
    suffix,
    emailpromotion,
    additionalcontactinfo,
    modifieddate
from {{ source('raw_data_source', 'RAW_PERSON') }}

{% endsnapshot %}

