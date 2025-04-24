-- View all data from the fully qualified table
SELECT * FROM world_life_expectancy.worldlifexpectancy;

-- View all data (without schema specified, assuming default DB)
SELECT * FROM worldlifexpectancy;

-- Rename the "Lifeexpectancy" column to include a space (more readable)
ALTER TABLE worldlifexpectancy 
CHANGE COLUMN Lifeexpectancy `Life expectancy` VARCHAR(1024);

-- Find duplicate rows based on Country and Year
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy.worldlifexpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

-- Select duplicate entries using ROW_NUMBER()
SELECT *
FROM (
    SELECT Row_ID,
           CONCAT(Country, Year) AS CountryYear,
           ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
    FROM worldlifexpectancy
) AS Row_table
WHERE Row_Num > 1;

-- Delete duplicate rows while keeping one of each Country-Year pair
DELETE 
FROM worldlifexpectancy 
WHERE Row_ID IN (
    SELECT Row_ID
    FROM (
        SELECT Row_ID,
               CONCAT(Country, Year) AS CountryYear,
               ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
        FROM worldlifexpectancy
    ) AS Row_table
    WHERE Row_Num > 1
);

-- Check table after duplicate removal
SELECT * FROM worldlifexpectancy;


-- View entries where the country's development status is 'Developing'
SELECT * 
FROM worldlifexpectancy
WHERE Status = 'Developing';

-- Update rows to set Status = 'Developing' where it already is (redundant)
UPDATE worldlifexpectancy 
SET Status = 'Developing'
WHERE Country IN (
    SELECT Country
    FROM worldlifexpectancy
    WHERE Status = 'Developing'
);

-- Update missing Status values to 'Developing' if another row with same Country has 'Developing'
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2 
    ON t1.Country = t2.Country 
SET t1.Status = 'Developing'
WHERE t1.Status = '' 
  AND t2.Status = 'Developing';

-- Update missing Status values to 'Developed' if another row with same Country has 'Developed'
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2 
    ON t1.Country = t2.Country 
SET t1.Status = 'Developed'
WHERE t1.Status = '' 
  AND t2.Status = 'Developed';

-- Find records with missing life expectancy and calculate the average from previous and next year
SELECT 
    t1.Country,
    t1.Year,
    t1.`Life expectancy` AS Current_Year_LE,
    t2.`Life expectancy` AS Prev_Year_LE,
    t3.`Life expectancy` AS Next_Year_LE,
    ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1) AS Imputed_LE
FROM worldlifexpectancy t1
JOIN worldlifexpectancy t2 
    ON t1.Country = t2.Country AND t1.Year = t2.Year - 1
JOIN worldlifexpectancy t3 
    ON t1.Country = t3.Country AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = '';

-- Fill in missing life expectancy values with the average of the previous and next year
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2 
    ON t1.Country = t2.Country AND t1.Year = t2.Year - 1
JOIN worldlifexpectancy t3 
    ON t1.Country = t3.Country AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = '';
