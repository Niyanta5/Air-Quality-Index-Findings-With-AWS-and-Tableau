USE AQI_Normalized;
DELIMITER //
CREATE PROCEDURE create_dimension_facts()
BEGIN
  -- Check if database exists
  SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA
  WHERE SCHEMA_NAME = 'AQI_DW'
  INTO @db_exists;

  IF @db_exists IS NULL THEN
    -- Create database if it doesn't exist
    CREATE DATABASE AQI_DW;

   CREATE TABLE `AQI_DW`.Time_Dimension (
	Time_Key BIGINT PRIMARY KEY AUTO_INCREMENT,
	Day INT,
	Month INT,
	Year INT
	);

	CREATE TABLE `AQI_DW`.Location_Dimension (
	Location_Key BIGINT PRIMARY KEY AUTO_INCREMENT,
	State_Key BIGINT,
	County_Code BIGINT,
	Latitude DOUBLE,
	Longitude DOUBLE,
	County_Name TEXT,
	City_Name TEXT
	);

	CREATE TABLE `AQI_DW`.State_Dimension (
	State_Key BIGINT PRIMARY KEY AUTO_INCREMENT,
	State_Code VARCHAR(2) NOT NULL,
	State_Name VARCHAR(50) NOT NULL
	);

	CREATE TABLE `AQI_DW`.Air_Quality_Fact (
	Location_Key BIGINT,
	Time_Key BIGINT,
	AQI_CO DOUBLE,
	1st_Max_Value_CO DOUBLE,
	1st_Max_Hour_CO BIGINT,
	Arithmetic_Mean_CO DOUBLE,
	AQI_NO2 DOUBLE,
	1st_Max_Value_NO2 DOUBLE,
	1st_Max_Hour_NO2 BIGINT,
	Arithmetic_Mean_NO2 DOUBLE,
	AQI_Ozone DOUBLE,
	1st_Max_Value_Ozone DOUBLE,
	1st_Max_Hour_Ozone BIGINT,
	Arithmetic_Mean_Ozone DOUBLE,
	AQI_PM10 DOUBLE,
	1st_Max_Value_PM10 DOUBLE,
	1st_Max_Hour_PM10 BIGINT,
	Arithmetic_Mean_PM10 DOUBLE,
	AQI_PM25 DOUBLE,
	1st_Max_Value_PM25 DOUBLE,
	1st_Max_Hour_PM25 BIGINT,
	Arithmetic_Mean_PM25 DOUBLE,
	PRIMARY KEY (Location_Key, Time_Key),
	FOREIGN KEY (Location_Key) REFERENCES Location_Dimension(Location_Key),
	FOREIGN KEY (Time_Key) REFERENCES Time_Dimension(Time_Key));
    END IF;
END
//
