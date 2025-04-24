World Life Expectancy Data Cleaning Project

This project focuses on cleaning and preparing a real-world life expectancy dataset using MySQL. 
The dataset contains information such as country, year, life expectancy, and development status (e.g., Developed vs Developing).

Objectives
Remove duplicate records.
Standardize column names for readability.
Handle missing values in the Status and Life expectancy columns.
Use SQL window functions and joins to clean and enrich the data.

What I Learned
How to detect and remove duplicates using ROW_NUMBER().
How to perform conditional updates with self-joins.
How to impute missing values using the average of adjacent years.
How to write clean and maintainable SQL scripts.

Tools Used
MySQL
SQL window functions (e.g., ROW_NUMBER())
Common SQL operations: JOIN, UPDATE, DELETE, ALTER, and GROUP BY

File Structure
life_expectancy_cleaning.sql: Main SQL script used to clean and transform the dataset.
(Optional) life_expectancy_dataset.csv: Raw dataset used for the project (if you're allowed to share it).
