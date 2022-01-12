-- Top 3 crimes ranked from 2018 to 2020 on a yearly basis

select * from 
(
select
	category,
	count(category) as crime_count,
	date_part('year', crime_date) as crime_year,
	dense_rank() over (partition by date_part('year', crime_date) order by count(category) desc, date_part('year', crime_date) desc) as crime_ranking
from
	sf_crime_data
group by category,crime_year) as SubQuery
where crime_ranking in (1,2,3);

