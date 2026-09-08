-- models/staging/stg_person.sql
-- Cleans person data

select distinct
    businessentityid as business_entity_id,
    replace(persontype, 'Vendor Contact', 'VC') as person_type,
    namestyle as name_style,
    title as title,
    initcap(firstname) as first_name,
    middlename as middle_name,
    lastname as last_name,
    suffix as suffix,
    emailpromotion as email_promotion,
    additionalcontactinfo as additional_contact_info,
    try_to_date(regexp_replace(modifieddate, '[^0-9\\- :]', ''), 'YYYY-MM-DD HH24:MI:SS') as modified_date

from {{ ref('person_snapshot') }}

where dbt_valid_to is null