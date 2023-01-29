USE ROLE TRAININGDBA;
USE WAREHOUSE XSMALL;
USE DATABASE TRAINING;
USE SCHEMA PUBLIC;

-- ****************************** 1.- File Format ******************************
CREATE OR REPLACE FILE FORMAT TRAINING.PUBLIC.FILE_FORMAT_CSV_GENERIC
    TYPE = CSV
    COMPRESSION = GZIP
    SKIP_HEADER = 1
    SKIP_BLANK_LINES = TRUE
    DATE_FORMAT = AUTO
    TIME_FORMAT = AUTO
    TIMESTAMP_FORMAT = AUTO
    TRIM_SPACE = TRUE
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE
    REPLACE_INVALID_CHARACTERS = TRUE
    EMPTY_FIELD_AS_NULL = TRUE
    ENCODING = UTF8;

-- ****************************** 2.- Creating External Stages ******************************
CREATE OR REPLACE STAGE TRAINING.PUBLIC.STAGE_EXTERNAL_REAL_STATE
  URL='s3://snowflake-s3-sfc-demo-ep/realtor/'
  FILE_FORMAT = TRAINING.PUBLIC.FILE_FORMAT_CSV_GENERIC;

-- ****************************** 3.- Creating Table ******************************
CREATE OR REPLACE TABLE TRAINING.PUBLIC.REAL_STATE AS
SELECT status,
       price,
       bed,
       bath,
       acre_lot,
       full_address,
       street,
       city,
       state,
       CASE
           WHEN LEN(zip_code) = 3 THEN CONCAT('00', zip_code)
           WHEN LEN(zip_code) = 4 THEN CONCAT('0', zip_code)
            ELSE zip_code
       END AS ZIP_CODE,
       house_size,
       sold_date,
       metadata$filename,
       metadata$file_row_number
FROM (SELECT t.$1                   AS status,
             t.$2                   AS price,
             t.$3::INT::VARCHAR     AS bed,
             t.$4::INT::VARCHAR     AS bath,
             t.$5                   AS acre_lot,
             t.$6                   AS full_address,
             t.$7                   AS street,
             t.$8                   AS city,
             t.$9                   AS state,
             t.$10::INT::VARCHAR    AS zip_code,
             t.$11                  AS house_size,
             t.$12                  AS sold_date,
             metadata$filename,
             metadata$file_row_number
      FROM @TRAINING.PUBLIC.STAGE_EXTERNAL_REAL_STATE (FILE_FORMAT => TRAINING.PUBLIC.FILE_FORMAT_CSV_GENERIC) t);

-- ****************************** 4.- Exploring Data ******************************
SELECT * FROM TRAINING.PUBLIC.REAL_STATE SAMPLE(150 ROWS);
