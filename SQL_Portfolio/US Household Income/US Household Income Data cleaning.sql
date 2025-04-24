Select id,count(id) 
from us_household_income
group by id
having count(id) > 1;


select *
from(
	select row_id,
    id,
	ROW_NUMBER() over(partition by id order by id) row_num
	from us_household_income
	) duplicates
where row_num > 1;


delete from us_household_income
where row_id IN(
	select row_id
    from(
		select row_id,
        id,
        row_number() over(partition by id order by id) row_num
        from us_household_income
        ) duplicates
	where row_num > 1)
;

Select State_Name
from us_household_income
where State_Name = 'alabama';

update us_household_income
set State_Name = 'Georgia'
where State_Name = 'georgia';

update us_household_income
set State_Name = 'Alabama'
where State_Name = 'alabama';

SELECT State_Name
FROM us_household_income
WHERE State_Name != CONCAT(UPPER(LEFT(State_Name, 1)), LOWER(SUBSTRING(State_Name, 2)));


select * 
from us_household_income;



SELECT COALESCE(row_id, '') AS Place
FROM us_household_income;



UPDATE us_household_income
SET Place = ''
WHERE Place IS NULL;


UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
and City = 'Vinemont';





select Type, count(Type)
from us_household_income
group by Type;



UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';







