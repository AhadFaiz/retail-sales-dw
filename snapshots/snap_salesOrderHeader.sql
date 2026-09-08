-- snapshots/snap_salesOrderHeader.sql
-- ==========================================================
-- Purpose:
-- Snapshot to track historical changes in order-level data.
-- Captures updates to key mutable fields such as status, shipdate,
-- financial amounts, and total order due.
-- The snapshot records when changes occur using dbt_valid_from and dbt_valid_to.
-- ==========================================================

{% snapshot salesorderheader_snapshot %}

{{
    config(     
        target_schema='SNPT',
        unique_key='salesorderid',             
        strategy='check',                    
        check_cols= 'all'
    )
}}



-- Select the source data exactly as it appears in staging
select
    salesorderid,
    revisionnumber,
    orderdate,
    duedate,
    shipdate,
    status,
    onlineorderflag,
    salesordernumber,
    purchaseordernumber,
    accountnumber,
    customerid,
    salespersonid,
    territoryid,
    billtoaddressid,
    shiptoaddressid,
    shipmethodid,
    creditcardid,
    creditcardapprovalcode,
    currencyrateid,
    subtotal,
    taxamt,
    freight,
    totaldue,
    comment,
    modifieddate
from {{ source('raw_data_source', 'RAW_SALESORDERHEADER') }}

{% endsnapshot %}