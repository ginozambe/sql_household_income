# Household Income

SELECT * 
FROM household_income.ushouseholdincome_staging;
SELECT * 
FROM household_income.ushouseholdincome_statistics_staging;

# CLEANING

## Change column name

-- Alter column table name
ALTER TABLE ushouseholdincome_statistics_staging RENAME COLUMN `ï»¿id` TO `id`;

## Remove duplicates

-- identify duplicates for table 1
SELECT id, COUNT(id)
FROM ushouseholdincome_staging
GROUP BY id
HAVING COUNT(id) > 1;

-- select duplicate rows for table 1
SELECT * 
FROM (
SELECT id, row_id, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) as count
FROM ushouseholdincome_staging) AS duplicates
WHERE count > 1;

-- delete duplicate rows for table 1
DELETE FROM ushouseholdincome_staging
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT id, row_id, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) as count
		FROM ushouseholdincome_staging) AS duplicates
		WHERE count > 1);
        
-- identify duplicates for table 2
-- NO DUPLICATES
SELECT id, COUNT(id)
FROM ushouseholdincome_staging
GROUP BY id
HAVING COUNT(id) > 1;


## Standardize State name

-- Select state names
SELECT DISTINCT state_name
FROM ushouseholdincome_staging
ORDER BY state_name;

-- Update state names
UPDATE ushouseholdincome_staging
SET state_name = 'Georgia'
WHERE state_name = 'georia';
UPDATE ushouseholdincome_staging
SET state_name = 'Alabama'
WHERE state_name = 'alabama';

## NULLs Place

-- Find nulls in places
SELECT *
FROM ushouseholdincome_staging
WHERE county = 'Autauga County'
ORDER BY Place;

-- Update nulls with values
UPDATE ushouseholdincome_staging
SET Place = 'Autaugaville'
WHERE County = 'Autauga County' AND City = 'Vinemont';

## Standardize Type Name

-- Find type names
SELECT type, COUNT(type)
FROM ushouseholdincome_staging
GROUP BY Type;

-- Standardize boroughs
UPDATE ushouseholdincome_staging
SET Type = 'Borough'
WHERE Type = 'Boroughs';

## Standardize Aland & AWater

-- Check if any blank data in ALand or AWater
SELECT ALand, AWater
FROM ushouseholdincome_staging
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL) 
AND (ALand = 0 OR ALand = '' OR ALand IS NULL);

# ANALYSIS

## View Dataset
SELECT * 
FROM household_income.ushouseholdincome_staging;
SELECT * 
FROM household_income.ushouseholdincome_statistics_staging;

-- Which are the TOP 10 State in terms of Land?

SELECT state_name, SUM(ALand) as land_area, SUM(AWater) as water_area
FROM ushouseholdincome_staging
GROUP BY state_name
ORDER BY land_area DESC
LIMIT 10;

-- Which are the TOP 10 State in terms of Water?

SELECT state_name, SUM(ALand) as land_area, SUM(AWater) as water_area
FROM ushouseholdincome_staging
GROUP BY state_name
ORDER BY water_area DESC
LIMIT 10;

-- Which are the TOP 10 States in terms of average household income?

SELECT u.state_name, ROUND(AVG(Mean),1) as mean, ROUND(AVG(Median),1) as median
FROM ushouseholdincome_staging as u
INNER JOIN ushouseholdincome_statistics_staging as us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.state_name
ORDER BY mean DESC
LIMIT 10;

-- Which are the LOWEST  10 States in terms of average household income?
-- Puerto rico included in the dataset (an unincorporated territory of the United States)
SELECT u.state_name, ROUND(AVG(Mean),1) as mean, ROUND(AVG(Median),1) as median
FROM ushouseholdincome_staging as u
INNER JOIN ushouseholdincome_statistics_staging as us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.state_name
ORDER BY mean 
LIMIT 10;

-- Which are the TOP 15 Cities in the US in terms of average household income?

SELECT u.state_name, City, ROUND(AVG(Mean),1) as mean
FROM ushouseholdincome_staging as u
JOIN ushouseholdincome_statistics_staging as us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.state_name, City
ORDER BY mean DESC
LIMIT 15;



