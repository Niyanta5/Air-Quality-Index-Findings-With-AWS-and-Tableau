USE AQI;

DELIMITER //
CREATE PROCEDURE create_and_populate_aqi_db()
BEGIN
  -- Check if database exists
  SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA
  WHERE SCHEMA_NAME = 'AQI_Normalized'
  INTO @db_exists;

  IF @db_exists IS NULL THEN
    -- Create database if it doesn't exist
    CREATE DATABASE AQI_Normalized;

    -- Create tables
    CREATE TABLE `AQI_Normalized`.`Locations` (
      location_id INT PRIMARY KEY AUTO_INCREMENT,
      state_code VARCHAR(2) NOT NULL,
      county_code VARCHAR(5) NOT NULL,
      latitude DECIMAL(10,6) NOT NULL,
      longitude DECIMAL(10,6) NOT NULL,
      state_name VARCHAR(50) NOT NULL,
      county_name VARCHAR(50) NOT NULL,
      city_name VARCHAR(50)
    );

    CREATE TABLE AQI_Normalized.AirQualityOzone (
      location_id INT,
      date_local DATE NOT NULL,
      aqi_ozone INT,
      first_max_value_ozone DECIMAL(5,2),
      first_max_hour_ozone INT,
      arithmetic_mean_ozone DECIMAL(5,2),
      PRIMARY KEY (location_id, date_local),
      FOREIGN KEY (location_id) REFERENCES Locations(location_id)
    );

    CREATE TABLE AQI_Normalized.AirQualityPM25 (
      location_id INT,
      date_local DATE NOT NULL,
      aqi_pm_2_5 INT,
      first_max_value_pm_2_5 DECIMAL(5,2),
      first_max_hour_pm_2_5 INT,
      arithmetic_mean_pm_2_5 DECIMAL(5,2),
      PRIMARY KEY (location_id, date_local),
      FOREIGN KEY (location_id) REFERENCES Locations(location_id)
    );

    CREATE TABLE AQI_Normalized.AirQualityPM10 (
      location_id INT,
      date_local DATE NOT NULL,
      aqi_pm_10 INT,
      first_max_value_pm_10 DECIMAL(10,2),
      first_max_hour_pm_10 INT,
      arithmetic_mean_pm_10 DECIMAL(10,2),
      PRIMARY KEY (location_id, date_local),
      FOREIGN KEY (location_id) REFERENCES Locations(location_id)
    );

    CREATE TABLE `AQI_Normalized`.`AirQualityCO` (
      location_id INT,
      date_local DATE NOT NULL,
      aqi_co INT,
      first_max_value_co DECIMAL(5,2),
      first_max_hour_co INT,
      arithmetic_mean_co DECIMAL(5,2),
      PRIMARY KEY (location_id, date_local),
      FOREIGN KEY (location_id) REFERENCES Locations(location_id)
    );

    CREATE TABLE AQI_Normalized.AirQualityNO2(
      location_id INT,
      date_local DATE NOT NULL,
      aqi_no2 INT,
      first_max_value_no2 DECIMAL(5,2),
      first_max_hour_no2 INT,
      arithmetic_mean_no2 DECIMAL(5,2),
      PRIMARY KEY (location_id, date_local),
      FOREIGN KEY (location_id) REFERENCES Locations(location_id)
    );
  END IF;

  -- Populate tables (assuming tables exist)
  INSERT INTO `AQI_Normalized`.`Locations`
(
`state_code`,
`county_code`,
`latitude`,
`longitude`,
`state_name`,
`county_name`,
`city_name`
)
SELECT DISTINCT `State Code`,`County Code`,`Latitude`,`Longitude`,`State Name`,`County Name`,`City Name` FROM AQI.Ozone LIMIT 100000;

INSERT INTO `AQI_Normalized`.`AirQualityCO`
(
`location_id`,
`date_local`,
`aqi_co`,
`first_max_value_co`,
`first_max_hour_co`,
`arithmetic_mean_co`
)
SELECT DISTINCT T2.location_id, T1.`Date Local`,
AVG(T1.`AQI CO`),
AVG(T1.`1st Max Value CO`),
AVG(T1.`1st Max Hour CO`),
AVG(T1.`Arithmetic Mean CO`) FROM AQI.`Carbon Monoxide` T1
JOIN  `AQI_Normalized`.`Locations` T2 ON T1.`State Code` = T2.`state_code` AND T1.`County Code` = T2.`county_code` AND
    T1.`City Name` = T2.`city_name` AND T1.`Latitude` = T2.`latitude` AND T1.`Longitude` = T2.`longitude`
    GROUP BY
    T2.`location_id`, T1.`Date Local` LIMIT 100000;


INSERT INTO AQI_Normalized.AirQualityOzone (
    location_id,
    date_local,
    aqi_ozone,
    first_max_value_ozone,
    first_max_hour_ozone,
    arithmetic_mean_ozone
)
SELECT
    T2.`location_id`,
    T1.`Date Local`,
    AVG(T1.`AQI Ozone`),
    AVG(T1.`1st Max Value Ozone`),
    AVG(T1.`1st Max Hour Ozone`),
    AVG(T1.`Arithmetic Mean Ozone`)
FROM
    AQI.`Ozone` T1
JOIN
    AQI_Normalized.Locations T2 ON T1.`State Code` = T2.`state_code` AND T1.`County Code` = T2.`county_code` AND
    T1.`City Name` = T2.`city_name` AND T1.`Latitude` = T2.`latitude` AND T1.`Longitude` = T2.`longitude`
    GROUP BY
    T2.`location_id`, T1.`Date Local` LIMIT 100000;

INSERT INTO AQI_Normalized.AirQualityPM10 (
    location_id,
    date_local,
    aqi_pm_10,
    first_max_value_pm_10,
    first_max_hour_pm_10,
    arithmetic_mean_pm_10
)
SELECT DISTINCT
    T2.`location_id`,
    T1.`Date Local`,
    AVG(T1.`AQI PM 10`),
    AVG(T1.`1st Max Value PM 10`),
    AVG(T1.`1st Max Hour PM 10`),
    AVG(T1.`Arithmetic Mean PM 10`)
FROM
    AQI.`PM10` T1
JOIN
    AQI_Normalized.Locations T2 ON T1.`State Code` = T2.`state_code` AND T1.`County Code` = T2.`county_code` AND
    T1.`City Name` = T2.`city_name` AND T1.`Latitude` = T2.`latitude` AND T1.`Longitude` = T2.`longitude`
    GROUP BY
    T2.`location_id`, T1.`Date Local` LIMIT 100000;
   
    INSERT INTO AQI_Normalized.AirQualityPM25 (
    location_id,
    date_local,
    aqi_pm_2_5,
    first_max_value_pm_2_5,
    first_max_hour_pm_2_5,
    arithmetic_mean_pm_2_5
)
SELECT DISTINCT
    T2.`location_id`,
    T1.`Date Local`,
    AVG(T1.`AQI PM 2.5`),
    AVG(T1.`1st Max Value PM 2.5`),
    AVG(T1.`1st Max Hour PM 2.5`),
    AVG(T1.`Arithmetic Mean PM 2.5`)
FROM
    AQI.`PM2.5` T1
JOIN
    AQI_Normalized.Locations T2 ON T1.`State Code` = T2.`state_code` AND T1.`County Code` = T2.`county_code` AND
    T1.`City Name` = T2.`city_name` AND T1.`Latitude` = T2.`latitude` AND T1.`Longitude` = T2.`longitude`
    GROUP BY
    T2.`location_id`, T1.`Date Local` LIMIT 100000;
   
   
    INSERT INTO AQI_Normalized.AirQualityNO2 (
    location_id,
    date_local,
    aqi_no2,
    first_max_value_no2,
    first_max_hour_no2,
    arithmetic_mean_no2
)
SELECT
    T2.`location_id`,
    T1.`Date Local`,
    AVG(T1.`AQI NO2`),
    AVG(T1.`1st Max Value NO2`),
    AVG(T1.`1st Max Hour NO2`),
    AVG(T1.`Arithmetic Mean NO2`)
FROM
    AQI.`Nitrogen Dioxide` T1
JOIN
     AQI_Normalized.Locations T2 ON T1.`State Code` = T2.`state_code` AND T1.`County Code` = T2.`county_code` AND
    T1.`City Name` = T2.`city_name` AND T1.`Latitude` = T2.`latitude` AND T1.`Longitude` = T2.`longitude`
    GROUP BY
    T2.`location_id`, T1.`Date Local` LIMIT 100000;
END
//
