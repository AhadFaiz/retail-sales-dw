-- models/staging/stg_productcategory.sql
-- Reads raw product category data

select distinct
    productcategoryid as product_category_id,
    name as product_category,
    modifieddate as modified_date
    
from {{ ref('productcategory_snapshot') }}

where dbt_valid_to is null