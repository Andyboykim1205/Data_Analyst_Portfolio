#World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM worldlifexpectancy
;


SELECT Country, min(`Life expectancy`), max(`Life expectancy`), round(max(`Life expectancy`) - min(`Life expectancy`),1) as increment_gap
FROM worldlifexpectancy
group by Country
having min(`Life expectancy`) <> 0
and max(`Life expectancy`) <> 0
and Country LIKE '%Korea%'
order by increment_gap asc
;


SELECT Country, ROUND(AVG(GDP),1) as avg_gdp, ROUND(AVG(`Life expectancy`),1) as life_exp
FROM worldlifexpectancy
group by Country
having life_exp > 0
and avg_gdp > 0
order by avg_gdp asc, life_exp DESC
;


















