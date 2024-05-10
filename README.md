# Unveiling U.S. Air Quality Dynamics through AWS Insights 🌬️📊

## Introduction

Air pollution poses a significant threat to public health, yet readily available data often remains unexplored. By delving into the rich details captured in daily Air Quality System (AQS) summaries, we can move beyond basic understanding and identify actionable insights to inform decision-making. This project aims to address air pollution concerns by uncovering patterns and identifying problematic areas.
Let's explore the air quality data using AWS services and visualize it in Tableau.

## Data Sources

- **CSV files**: [AQS CSV files](https://aqs.epa.gov/aqsweb/airdata/download_files.html)
- **Web API**: [AQS Web API documentation](https://aqs.epa.gov/aqsweb/documents/data_api.html)

## AWS Architecture Diagram
![AWS Architecture Diagram](https://github.com/Niyanta5/InfoArch_AQI_Final_Project/blob/98cf669c61494f6a379974268f4dc54532f967d2/Architecture%20Diagram/awsarchitecturediagram.jpeg)

## Data Dictionary of AQI 📜

| Column Name      | Description                                                 | Category  |
|------------------|-------------------------------------------------------------|-----------|
| location_id      | Identifier for the location where the air quality data was collected. | Numerical |
| date_local       | The date of the air quality measurement in local time.      | Categorical |
| AQI              | The Air Quality Index (AQI) value representing the AQI for each pollutant. | Numerical |
| 1st Max Value    | The highest recorded concentration value for the specified parameter. | Numerical |
| 1st Max Hour     | The hour when the highest concentration value was recorded. | Numerical |
| Arithmetic Mean  | The average concentration of the specified parameter over the given date. | Numerical |
| state_code       | Code representing the state where the location is located. | Categorical |
| county_code      | Code representing the county where the location is located. | Categorical |
| latitude         | The latitude coordinates of the location.                   | Numerical |
| longitude        | The longitude coordinates of the location.                  | Numerical |
| state_name       | The name of the state where the location is located.       | Categorical |
| country_name     | The name of the country where the location is located.     | Categorical |
| city_name        | The name of the city where the location is located.        | Categorical |

## Entity Relational Model
![ER Model](https://github.com/Niyanta5/InfoArch_AQI_Final_Project/blob/79644c66947c94dfdc813d38712e9eae9122862e/Logical%20Diagram/aqi_normalized_logical_diagram.pdf)

## Grain

The grain of the data is at the daily level, where each record in the fact table represents air quality measurements for each parameter at a particular location for one day.

## Dimensions

### Time Dimension ⏰

- **Date Local**: The date of the measurements.
- **Day of the Week**: The day of the week corresponding to the date.
- **Month**: The month corresponding to the date.
- **Year**: The year corresponding to the date.

### Location Dimension 🌎

- **State Code**: Code representing the state where the measurements were taken.
- **County Code**: Code representing the county where the measurements were taken.
- **Latitude**: Latitude coordinate of the measurement location.
- **Longitude**: Longitude coordinate of the measurement location.
- **State Name**: The name of the state where the measurements were taken.
- **County Name**: The name of the county where the measurements were taken.
- **City Name**: The name of the city where the measurements were taken.

### State Dimension 🏛️

- **State Code**: Code representing the state.
- **State Name**: The name of the state.

## Air Quality Fact

Core measurements for each pollutant include:

- **AQI (Air Quality Index)**: An index used to communicate how polluted the air currently is or how polluted it is forecast to become.
- **1st Max Value**: The highest value measured for the pollutant during the day.
- **1st Max Hour**: The hour when the highest value for the pollutant was measured.
- **Arithmetic Mean**: The average value of the pollutant over the day.

## Dimensional Model
![Dimensional Model](https://github.com/Niyanta5/InfoArch_AQI_Final_Project/blob/79644c66947c94dfdc813d38712e9eae9122862e/Logical%20Diagram/Dimensional_Model.pdf)

## ETL Process Using AWS Glue:

# Phase I:
![phaseI](https://github.com/Niyanta5/InfoArch_AQI_Final_Project/blob/c2ed849e36eefcf49a6373ca07ed605b525c0092/screenshots/Glue%20Snips/ETL_Phase1.PNG)
# Phase II:
![phaseII](https://github.com/Niyanta5/InfoArch_AQI_Final_Project/blob/c2ed849e36eefcf49a6373ca07ed605b525c0092/screenshots/Glue%20Snips/ETL_Phase2.PNG)
# Phase III:
![phaseIII](https://github.com/Niyanta5/InfoArch_AQI_Final_Project/blob/c2ed849e36eefcf49a6373ca07ed605b525c0092/screenshots/Glue%20Snips/ETL_Phase3.PNG)

## Step Functions:
![Step Functions](https://github.com/Niyanta5/InfoArch_AQI_Final_Project/blob/cab135764810336df29955759b8cf9c84453544f/screenshots/Step%20Function%20Snip/Step_Function.PNG)

## Data Visualization Using Tableau
[Data Visualization in Tableau](https://public.tableau.com/app/profile/niyanta.pandey/viz/IAFinalProjectVisualization_17153012189600/FinalDashboard?publish=yes)

# Conclusion 📝

Our analysis of U.S. air quality revealed concerning trends and valuable insights. By leveraging AWS and rigorous data exploration, we identified Arizona as a state with consistently high levels of all measured pollutants (CO, NO2, PM2.5, PM10, and Ozone). Pennsylvania, while appearing in the top 5 for all pollutants, stood out for particularly high PM2.5 levels, likely due to industrial activity.

Seasonal patterns emerged, with pollution peaking in winter (December-February) and dipping in summer (June-August). This likely reflects colder temperatures trapping pollutants in winter, while summer brings warmer air and sunshine that helps disperse them. Notably, the highly concerning PM2.5 remained elevated throughout the year, with a concerning December spike. Specific locations within Arizona (Gila County) and Pennsylvania (Dauphin County) were identified as having the highest overall pollution levels in 2022.

Moving forward, integrating machine learning models and expanding data collection efforts present exciting opportunities for further refinement. Overall, this project underscores the power of data-driven approaches in tackling environmental challenges and informing decisions for a healthier future.

## Lessons Learned 🎓

### AWS Lambda:

- **Batch Processing:** Divide tasks into smaller batches for efficient processing within the 15-minute limit.
- **Code Optimization:** Enhance Lambda function performance and reduce resource usage through code optimization.

### AWS Glue:

- **Modular Design:** Break down complex ETL jobs into smaller, modular steps for improved performance and troubleshooting.
- **Query Optimization:** Optimize queries within Glue to enhance data analysis speed and efficiency in the OLAP data warehouse.

### AWS Step Functions:

- **Orchestration Power:** Orchestrate complex workflows involving multiple AWS services for organized data processing pipelines.
- **Error Handling:** Ensure robust error handling within workflows to prevent issues from impacting the entire pipeline and enable easier recovery.

## Improvements 🚀

- API calls can be implemented using AWS Lambda.
- AWS SageMaker integration can be explored for developing ML models to enhance complex data visualizations.
- Expanding the dataset to include additional years can improve pattern and trend analysis.
- AWS QuickSight can be utilized for streamlined data visualization.
- CloudWatch can be employed for monitoring purposes.
