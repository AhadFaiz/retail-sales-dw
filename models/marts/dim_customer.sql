-- models/marts/dim_customer.sql
-- ===========================================================
-- Dimension table combining customer-level information 
-- with related person details.
--
-- Grain: One row per customer
-- Purpose: Enrich customer attributes for downstream reporting
--
-- Incremental Logic:
-- Only loads new or updated records 
-- based on the latest 'modified_data' timestamp from the sources.
-- ===========================================================

{{
    config(
        incremental_strategy = 'merge',
        unique_key = ['customer_id', 'person_id']
    )
}}

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

with joined_customer_data as (
-- Combine customer and person
    select
        c.customer_id,         
        c.account_number,        
        c.person_id,             
        p.title,                 
        p.name_style,            
        p.first_name,            
        p.middle_name,           
        p.last_name,             
        p.suffix,                
        c.store_id,            
        c.territory_id,        
        greatest(c.modified_date, p.modified_date) as modified_at    
    from {{ ref('stg_customer') }} as c
    left join {{ ref('stg_person') }} as p
        on c.person_id = p.business_entity_id
)

select *
from joined_customer_data

-- Incremental filter: only include records modified after the last load
{% if is_incremental() %}
where modified_at > '{{ MAX_START_DT }}'
{% endif %}
