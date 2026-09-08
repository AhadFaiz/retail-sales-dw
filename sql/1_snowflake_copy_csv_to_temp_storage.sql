-- Run these SnowSQL commands in shell/ command prompt.
-- Upload the required AdventureWorks CSV files to user stage (@~) in Snowflake.
-- Adjust the file path below if your directory structure is different.

PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/SalesOrderHeader.csv @~ OVERWRITE = TRUE;
PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/SalesOrderDetail.csv @~ OVERWRITE = TRUE;
PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/Product.csv @~ OVERWRITE = TRUE;
PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/ProductCategory.csv @~ OVERWRITE = TRUE;
PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/ProductSubcategory.csv @~ OVERWRITE = TRUE;
PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/Customer.csv @~ OVERWRITE = TRUE;
PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/Person.csv @~ OVERWRITE = TRUE;
PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/Address.csv @~ OVERWRITE = TRUE;
PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/StateProvince.csv @~ OVERWRITE = TRUE;
PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/CountryRegion.csv @~ OVERWRITE = TRUE;
PUT file://D:/Stackfuel/Module_3_Mini_Project_1/adworks_data_files_processed/SalesTerritory.csv @~ OVERWRITE = TRUE;

-- Verify all uploaded files
LIST @~;z
