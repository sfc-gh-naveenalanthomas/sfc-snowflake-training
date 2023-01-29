USE ROLE TRAININGDBA;
USE WAREHOUSE XSMALL;
USE DATABASE TRAINING;
USE SCHEMA PUBLIC;

-- ****************************** 1.- Get Data from Marketplace ******************************
-- 1.- Follow the README.md file under the training directory

-- ****************************** 2.- Exploring data from marketplace ******************************
SELECT TOP 100 * FROM US_ZIP_CODE_METADATA.ZIP_DEMOGRAPHICS.ZIP_CODE_METADATA;


-- ****************************** 3.- Joining Data with real state ******************************
SELECT TOP 100 *
FROM TRAINING.PUBLIC.REAL_STATE re
INNER JOIN US_ZIP_CODE_METADATA.ZIP_DEMOGRAPHICS.ZIP_CODE_METADATA d
 ON re.ZIP_CODE = d.ZIP;
