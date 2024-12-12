## Introduction

This project involves cleaning and preparing a household income dataset, structuring it for analysis, and uncovering valuable insights using SQL queries.

## 5 Questions answered by the SQL queries

1. Which are the TOP 10 State in terms of Land?
3. Which are the TOP 10 State in terms of Water?
3. Which are the TOP 10 States in terms of average household income?
4. Which are the LOWEST  10 States in terms of average household income?
5. Which are the TOP 15 Cities in the US in terms of average household income?

# Tools Used

- **SQL**
- **MySQL**
- **Visual Studio Code**
- **Git & Github**

 ## The analysis
 
 ### Query1
 
 ```SQL
 SELECT state_name, SUM(ALand) as land_area, SUM(AWater) as water_area
FROM ushouseholdincome_staging
GROUP BY state_name
ORDER BY land_area DESC
LIMIT 10;
 ```
 
 ![Analysis](<sql_results/q1.png>)
 
 ### Query2
 
 ```SQL
SELECT state_name, SUM(ALand) as land_area, SUM(AWater) as water_area
FROM ushouseholdincome_staging
GROUP BY state_name
ORDER BY water_area DESC
LIMIT 10;
 ```
 ![Analysis](<sql_results/q2.png>)
 
 ### Query3
 
 ```SQL
 SELECT u.state_name, ROUND(AVG(Mean),1) as mean, ROUND(AVG(Median),1) as median
FROM ushouseholdincome_staging as u
INNER JOIN ushouseholdincome_statistics_staging as us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.state_name
ORDER BY mean DESC
LIMIT 10;
 ```
  ![Analysis](<sql_results/q3.png>)
 
 ### Query4
 
 ```SQL
 -- Puerto rico included in the dataset (an unincorporated territory of the United States)
SELECT u.state_name, ROUND(AVG(Mean),1) as mean, ROUND(AVG(Median),1) as median
FROM ushouseholdincome_staging as u
INNER JOIN ushouseholdincome_statistics_staging as us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.state_name
ORDER BY mean 
LIMIT 10;
 ```
 ![Analysis](<sql_results/q4.png>)
 
 ### Query5
 
 ```SQL
 SELECT u.state_name, City, ROUND(AVG(Mean),1) as mean
FROM ushouseholdincome_staging as u
JOIN ushouseholdincome_statistics_staging as us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.state_name, City
ORDER BY mean DESC
LIMIT 15;
 ```
 ![Analysis](<sql_results/q5.png>)
 
