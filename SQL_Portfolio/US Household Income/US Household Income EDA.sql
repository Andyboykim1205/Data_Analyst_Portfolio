-- Preview the raw data from both tables
SELECT * FROM US_Project.us_household_income;
SELECT * FROM US_Project.us_household_income_statistics;

-- Top 10 states with the largest total land area
SELECT State_Name, SUM(ALand) AS Total_Land, SUM(AWater) AS Total_Water
FROM us_household_income
GROUP BY State_Name
ORDER BY Total_Land DESC
LIMIT 10;

-- Join both tables on ID and filter out entries with missing Mean income
SELECT * 
FROM US_Project.us_household_income u
INNER JOIN US_Project.us_household_income_statistics us
ON u.id = us.id
WHERE us.Mean <> 0;

-- Top 10 cities with the highest mean income
SELECT u.City, u.State_Name, us.Mean
FROM us_household_income u
JOIN us_household_income_statistics us ON u.id = us.id
ORDER BY us.Mean DESC
LIMIT 10;

-- Income statistics grouped by state: sample size, average mean, median, and standard deviation
SELECT u.State_Name,
       COUNT(*) AS sample_size,
       AVG(us.Mean) AS avg_mean_income,
       AVG(us.Median) AS avg_median_income,
       AVG(us.Stdev) AS avg_stdev
FROM us_household_income u
JOIN us_household_income_statistics us ON u.id = us.id
GROUP BY u.State_Name
ORDER BY avg_mean_income DESC;

-- Compare average land area with average income for each state
SELECT 
  u.State_Name,
  AVG(u.ALand) AS avg_land,
  AVG(us.Mean) AS avg_income
FROM us_household_income u
JOIN us_household_income_statistics us ON u.id = us.id
GROUP BY u.State_Name
ORDER BY avg_income DESC;

-- Identify cities with unusually high standard deviation (potential outliers)
SELECT u.City, u.State_Name, us.Stdev, us.Mean
FROM us_household_income u
JOIN us_household_income_statistics us ON u.id = us.id
WHERE us.Stdev > 20000
ORDER BY us.Stdev DESC;

-- Check for missing values in key columns
SELECT
  SUM(CASE WHEN us.Mean IS NULL THEN 1 ELSE 0 END) AS missing_mean,
  SUM(CASE WHEN us.Median IS NULL THEN 1 ELSE 0 END) AS missing_median,
  SUM(CASE WHEN u.Zip_Code IS NULL THEN 1 ELSE 0 END) AS missing_zip
FROM us_household_income u
JOIN us_household_income_statistics us ON u.id = us.id;

-- Create a view combining key income info by state and zip code
CREATE VIEW income_view AS
SELECT
  u.id AS u_id,
  us.id AS s_id,
  u.State_Name,
  u.Zip_Code,
  us.Mean,
  us.Median
FROM us_household_income u
JOIN us_household_income_statistics us
ON u.State_Name = us.State_Name;
