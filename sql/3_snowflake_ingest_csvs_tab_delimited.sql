-- -----------------------------------------------------------
-- Step 1: Select the target database for your project
-- -----------------------------------------------------------
USE DATABASE RETAIL_SALES_DB;
-- -----------------------------------------------------------
-- Step 2: Create a file format to handle tab-delimited,
-- GZIP-compressed files with no header row.
-- This ensures Snowflake parses the file correctly.
-----------------------------------------------------------
CREATE
OR REPLACE FILE FORMAT ff_tab_gzip TYPE = 'CSV' FIELD_DELIMITER = '\t' -- Tab-separated fields
SKIP_HEADER = 0 -- No header row present
FIELD_OPTIONALLY_ENCLOSED_BY = '"' -- Fields may be enclosed in quotes
COMPRESSION = 'GZIP';
-- File is gzip-compressed
-- -------------------------------------- Product.csv --------------------------------------
-----------------------------------------------------------
-- Create the staging table for Product data
-- The AdventureWorks Product.csv file has no headers,
-- so column names and data types must be defined manually.
-- This table will store the RETAIL_SALES_RAW. data after ingestion.
-----------------------------------------------------------
CREATE
OR REPLACE TABLE RETAIL_SALES_RAW.PRODUCT (
    PRODUCT_ID NUMBER,
    -- Unique product identifier
    NAME STRING,
    -- Product name
    PRODUCT_NUMBER STRING,
    -- Product code or number
    MAKE_FLAG BOOLEAN,
    -- Indicates if product is manufactured in-house
    FINISHED_GOODS_FLAG BOOLEAN,
    -- True if finished product, false if component
    COLOR STRING,
    -- Product color
    SAFETY_STOCK_LEVEL NUMBER,
    -- Minimum quantity to maintain in inventory
    REORDER_POINT NUMBER,
    -- Inventory level that triggers a reorder
    STANDARD_COST FLOAT,
    -- Cost to manufacture or purchase
    LIST_PRICE FLOAT,
    -- Selling price
    SIZE STRING,
    -- Product size (e.g., S, M, L)
    SIZE_UNIT_MEASURE_CODE STRING,
    -- Unit of measure for size
    WEIGHT_UNIT_MEASURE_CODE STRING,
    -- Unit of measure for weight
    WEIGHT FLOAT,
    -- Product weight
    DAYS_TO_MANUFACTURE NUMBER,
    -- Time to produce product
    PRODUCT_LINE STRING,
    -- Product line category (e.g., R, M, S)
    CLASS STRING,
    -- Class code for product (e.g., H, M, L)
    STYLE STRING,
    -- Style code for product
    PRODUCT_SUBCATEGORY_ID NUMBER,
    -- Foreign key to product subcategory
    PRODUCT_MODEL_ID NUMBER,
    -- Foreign key to product model
    SELL_START_DATE TIMESTAMP_NTZ,
    -- Date product was first offered for sale
    SELL_END_DATE TIMESTAMP_NTZ,
    -- Date product was discontinued
    DISCONTINUED_DATE TIMESTAMP_NTZ,
    -- Date product stopped being sold
    ROWGUID STRING,
    -- Unique identifier for replication
    MODIFIED_DATE TIMESTAMP_NTZ -- Last modification timestamp
);
-- -----------------------------------------------------------
-- Load data from your user stage (@~)
-- Snowflake automatically decompresses the .gz file
-- and applies the file format defined above.
-- -----------------------------------------------------------
COPY INTO RETAIL_SALES_RAW.PRODUCT
FROM
    @~/Product.csv.gz FILE_FORMAT = (FORMAT_NAME = ff_tab_gzip);
-- -------------------------------------- SalesOrderHeader.csv --------------------------------------
    -- ---------------------------------------------------------
    -- Create staging table for Sales Order Header data
    -- The AdventureWorks SalesOrderHeader.csv file has no headers,
    -- so column names and data types are defined manually.
    -- -----------------------------------------------------------
    CREATE
    OR REPLACE TABLE RETAIL_SALES_RAW.SALESORDERHEADER (
        SALESORDERID NUMBER,
        -- Primary key for sales order
        REVISIONNUMBER NUMBER,
        -- Revision number of the order
        ORDERDATE TIMESTAMP_NTZ,
        -- Date the order was created
        DUEDATE TIMESTAMP_NTZ,
        -- Date order is due
        SHIPDATE TIMESTAMP_NTZ,
        -- Date order was shipped
        STATUS NUMBER,
        -- Order status (e.g., 1=In process, 5=Shipped)
        ONLINEORDERFLAG BOOLEAN,
        -- True if placed online
        SALESORDERNUMBER STRING,
        -- Unique order number
        PURCHASEORDERNUMBER STRING,
        -- Customer purchase order number
        ACCOUNTNUMBER STRING,
        -- Customer account number
        CUSTOMERID NUMBER,
        -- FK to Customer table
        SALESPERSONID NUMBER,
        -- FK to SalesPerson table
        TERRITORYID NUMBER,
        -- FK to SalesTerritory table
        BILLTOADDRESSID NUMBER,
        -- FK to billing address
        SHIPTOADDRESSID NUMBER,
        -- FK to shipping address
        SHIPMETHODID NUMBER,
        -- FK to ShipMethod table
        CREDITCARDID NUMBER,
        -- FK to CreditCard table
        CREDITCARDAPPROVALCODE STRING,
        -- Approval code for credit card
        CURRENCYRATEID NUMBER,
        -- FK to CurrencyRate table
        SUBTOTAL FLOAT,
        -- Order subtotal before tax and freight
        TAXAMT FLOAT,
        -- Tax amount
        FREIGHT FLOAT,
        -- Freight cost
        TOTALDUE FLOAT,
        -- Total due (subtotal + tax + freight)
        COMMENT STRING,
        -- Optional customer comment
        ROWGUID STRING,
        -- Unique identifier
        MODIFIEDDATE TIMESTAMP_NTZ -- Last modification date
    );
-- -----------------------------------------------------------
    -- Load SalesOrderHeader data from user stage
    -- -----------------------------------------------------------
    COPY INTO RETAIL_SALES_RAW.SALESORDERHEADER
FROM
    @~/SalesOrderHeader.csv.gz FILE_FORMAT = (FORMAT_NAME = ff_tab_gzip);
-- -------------------------------------- ProductCategory.csv --------------------------------------
    -- -----------------------------------------------------------
    -- Create staging table for Product Category data
    -- The AdventureWorks ProductCategory.csv file has no headers,
    -- so column names and data types are defined manually.
    -- -----------------------------------------------------------
    CREATE
    OR REPLACE TABLE RETAIL_SALES_RAW.PRODUCTCATEGORY (
        PRODUCTCATEGORYID NUMBER,
        -- Primary key for product category
        NAME STRING,
        -- Name of the category
        ROWGUID STRING,
        -- Unique identifier
        MODIFIEDDATE TIMESTAMP_NTZ -- Last modification date
    );
-- -----------------------------------------------------------
    -- Load ProductCategory data from user stage
    -- -----------------------------------------------------------
    COPY INTO RETAIL_SALES_RAW.PRODUCTCATEGORY
FROM
    @~/ProductCategory.csv.gz FILE_FORMAT = (FORMAT_NAME = ff_tab_gzip);
-- -------------------------------------- ProductSubcategory.csv --------------------------------------
    -- -----------------------------------------------------------
    -- Create staging table for Product Subcategory data
    -- The AdventureWorks ProductSubcategory.csv file has no headers,
    -- so column names and data types are defined manually.
    -- -----------------------------------------------------------
    CREATE
    OR REPLACE TABLE RETAIL_SALES_RAW.PRODUCTSUBCATEGORY (
        PRODUCTSUBCATEGORYID NUMBER,
        -- Primary key for product subcategory
        PRODUCTCATEGORYID NUMBER,
        -- FK to ProductCategory table
        NAME STRING,
        -- Name of the subcategory
        ROWGUID STRING,
        -- Unique identifier
        MODIFIEDDATE TIMESTAMP_NTZ -- Last modification date
    );
-- -----------------------------------------------------------
    -- Load ProductSubcategory data from user stage
    -- -----------------------------------------------------------
    COPY INTO RETAIL_SALES_RAW.PRODUCTSUBCATEGORY
FROM
    @~/ProductSubcategory.csv.gz FILE_FORMAT = (FORMAT_NAME = ff_tab_gzip);
-- -------------------------------------- SalesTerritory.csv --------------------------------------
    -- -----------------------------------------------------------
    -- Create staging table for SalesTerritory data
    -- The AdventureWorks SalesTerritory.csv file has no headers,
    -- so column names and data types are defined manually.
    -- -----------------------------------------------------------
    CREATE
    OR REPLACE TABLE RETAIL_SALES_RAW.SALESTERRITORY (
        TERRITORYID NUMBER,
        -- Primary key for sales territory
        NAME STRING,
        -- Name of the territory
        COUNTRYREGIONCODE STRING,
        -- FK to CountryRegion table
        TERRITORY_GROUP STRING,
        -- Territory group (e.g., North America)
        SALESYTD FLOAT,
        -- Year-to-date COPY
        SALESLASTYEAR FLOAT,
        -- Sales from the previous year
        COSTYTD FLOAT,
        -- Year-to-date cost
        COSTLASTYEAR FLOAT,
        -- Cost from the previous year
        ROWGUID STRING,
        -- Unique identifier
        MODIFIEDDATE TIMESTAMP_NTZ -- Last modification date
    );
-- -----------------------------------------------------------
    -- Load SalesTerritory data from user stage (comma-separated file)
    -- -----------------------------------------------------------
    COPY INTO RETAIL_SALES_RAW.SALESTERRITORY
FROM
    @~/SalesTerritory.csv.gz FILE_FORMAT = (FORMAT_NAME = ff_tab_gzip);