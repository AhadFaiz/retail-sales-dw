-- models/staging/stg_productsubcategory.sql
-- Reads raw product subcategory data

select distinct
    productsubcategoryid as product_subcategory_id,
    productcategoryid as product_category_id,
    name as product_subcategory,
    modifieddate as modified_date

from {{ ref('productsubcategory_snapshot') }}

where dbt_valid_to is null