-- -----------------------------------------------------------
-- Step 1: Select the target database for your project
-- -----------------------------------------------------------
USE DATABASE RETAIL_SALES_DB;
DROP SCHEMA IF EXISTS RAW;
CREATE SCHEMA RAW;
-- -----------------------------------------------------------
-- Step 2: Create a file format to handle tab-delimited,
-- GZIP-compressed files with no header row.
-- This ensures Snowflake parses the file correctly.
-----------------------------------------------------------
CREATE
OR REPLACE FILE FORMAT ff_comma_gzip TYPE = 'CSV' FIELD_DELIMITER = ',' -- Comma-separated fields
SKIP_HEADER = 0 -- No header row present
FIELD_OPTIONALLY_ENCLOSED_BY = '"' -- Fields may be enclosed in quotes
COMPRESSION = 'GZIP';
-- File is gzip-compressed
-- -------------------------------------- Person.csv --------------------------------------
-- -----------------------------------------------------------
-- Create staging table for Person data
-- The AdventureWorks Person.csv file has no headers,
-- so column names and data types are defined manually.
-- -----------------------------------------------------------
CREATE
OR REPLACE TABLE RETAIL_SALES_RAW.PERSON (
    BUSINESSENTITYID NUMBER,
    -- Primary key for person or employee
    PERSONTYPE STRING,
    -- Type of person (e.g., EM=Employee, IN=Individual)
    NAMESTYLE BOOLEAN,
    -- Specifies if name is in Western or Eastern style
    TITLE STRING,
    -- Title (e.g., Mr., Ms., Dr.)
    FIRSTNAME STRING,
    -- First na
    MIDDLENAME STRING,
    -- Middle name
    LASTNAME STRING,
    -- Last name
    SUFFIX STRING,
    -- Name suffix (e.g., Jr., Sr.)
    EMAILPROMOTION NUMBER,
    -- Indicates if person receives promotional emails
    ADDITIONALCONTACTINFO STRING,
    -- XML column with extra contact info (can be null)
    MODIFIEDDATE STRING -- Last modification date
);
-- -----------------------------------------------------------
-- Load Person data from user stage
-- -----------------------------------------------------------
COPY INTO RETAIL_SALES_RAW.PERSON
FROM
    @~/Person.csv.gz FILE_FORMAT = (FORMAT_NAME = ff_comma_gzip);
-- -------------------------------------- Customer.csv --------------------------------------
    -- -----------------------------------------------------------
    -- Create staging table for Customer data
    -- The AdventureWorks Customer.csv file has no headers,
    -- so column names and data types are defined manually.
    -- -----------------------------------------------------------
    CREATE
    OR REPLACE TABLE RETAIL_SALES_RAW.CUSTOMER (
        CUSTOMERID NUMBER,
        -- Primary key for customer
        PERSONID NUMBER,
        -- FK to Person table
        STOREID NUMBER,
        -- FK to Store table (if applicable)
        TERRITORYID NUMBER,
        -- FK to SalesTerritory table
        ACCOUNTNUMBER STRING,
        -- Customer account number
        ROWGUID STRING,
        -- Unique identifier
        MODIFIEDDATE TIMESTAMP_NTZ -- Last modification date
    );
-- -----------------------------------------------------------
    -- Load Customer data from user stage
    -- -----------------------------------------------------------
    COPY INTO RETAIL_SALES_RAW.CUSTOMER
FROM
    @~/Customer.csv.gz FILE_FORMAT = (FORMAT_NAME = ff_comma_gzip);
-- -------------------------------------- StateProvince.csv --------------------------------------
    -- -----------------------------------------------------------
    -- Create staging table for StateProvince.csv
    -- -----------------------------------------------------------
    CREATE
    OR REPLACE TABLE RETAIL_SALES_RAW.STATEPROVINCE (
        STATEPROVINCEID NUMBER,
        STATEPROVINCECODE STRING,
        COUNTRYREGIONCODE STRING,
        ISONLYSTATEPROVINCEFLAG BOOLEAN,
        NAME STRING,
        TERRITORYID NUMBER,
        ROWGUID STRING,
        MODIFIEDDATE TIMESTAMP_NTZ
    );
-- -----------------------------------------------------------
    -- Load data from staged file into staging table
    -- -----------------------------------------------------------
    COPY INTO RETAIL_SALES_RAW.STATEPROVINCE
FROM
    @~/StateProvince.csv FILE_FORMAT = (FORMAT_NAME = ff_comma_gzip);
-- -------------------------------------- CountryRegion.csv --------------------------------------
    -- -----------------------------------------------------------
    -- Create staging table for CountryRegion.csv
    -- -----------------------------------------------------------
    CREATE
    OR REPLACE TABLE RETAIL_SALES_RAW.COUNTRYREGION (
        COUNTRYREGIONCODE STRING,
        -- Primary key / country code
        NAME STRING,
        -- Country/region name
        CURRENCYCODE STRING,
        -- Currency code
        MODIFIEDDATE TIMESTAMP_NTZ -- Last modification timestamp
    );
-- -----------------------------------------------------------
    -- Load data from staged file into staging table
    -- -----------------------------------------------------------
    COPY INTO RETAIL_SALES_RAW.COUNTRYREGION
FROM
    @~/CountryRegion.csv FILE_FORMAT = (FORMAT_NAME = ff_comma_gzip);
-- -------------------------------------- Address.csv --------------------------------------
    -- -----------------------------------------------------------
    -- Create staging table for Address.csv
    -- -----------------------------------------------------------
    CREATE
    OR REPLACE TABLE RETAIL_SALES_RAW.ADDRESS (
        ADDRESSID NUMBER,
        -- Primary key for address
        ADDRESSLINE1 STRING,
        -- First line of the address
        ADDRESSLINE2 STRING,
        -- Second line (optional)
        CITY STRING,
        -- City name
        STATEPROVINCEID NUMBER,
        -- FK to StateProvince
        POSTALCODE STRING,
        -- ZIP or postal code
        SPATIALLOCATION STRING,
        -- Spatial location (geometry/geography)
        ROWGUID STRING,
        -- Unique identifier
        MODIFIEDDATE TIMESTAMP_NTZ -- Last modification timestamp
    );
-- -----------------------------------------------------------
    -- Load data from staged file into staging table
    -- -----------------------------------------------------------
    COPY INTO RETAIL_SALES_RAW.ADDRESS
FROM
    @~/Address.csv.gz FILE_FORMAT = (FORMAT_NAME = ff_comma_gzip);
-- -------------------------------------- SalesOrderDetail.csv --------------------------------------
    -- -----------------------------------------------------------
    -- Create staging table for Sales Order Detail data
    -- The AdventureWorks SalesOrderDetail.csv file has no headers,
    -- so column names and data types are defined manually.
    -- -----------------------------------------------------------
    CREATE
    OR REPLACE TABLE RETAIL_SALES_RAW.SALESORDERDETAIL (
        SALESORDERID NUMBER,
        -- FK to SalesOrderHeader
        SALESORDERDETAILID NUMBER,
        -- Unique ID for sales order line item
        CARRIERTRACKINGNUMBER STRING,
        -- Tracking number for the shipment
        ORDERQTY NUMBER,
        -- Quantity ordered
        PRODUCTID NUMBER,
        -- FK to Product table
        SPECIALOFFERID NUMBER,
        -- FK to SpecialOffer table
        UNITPRICE FLOAT,
        -- Unit price of the product
        UNITPRICEDISCOUNT FLOAT,
        -- Discount applied to the unit price
        LINETOTAL FLOAT,
        -- Total for this line item (calculated)
        ROWGUID STRING,
        -- Unique identifier
        MODIFIEDDATE TIMESTAMP_NTZ -- Last modification date
    );
-- -----------------------------------------------------------
    -- Load SalesOrderDetail data from user stage
    -- -----------------------------------------------------------
    COPY INTO RETAIL_SALES_RAW.SALESORDERDETAIL
FROM
    @~/SalesOrderDetail.csv.gz FILE_FORMAT = (FORMAT_NAME = ff_comma_gzip);