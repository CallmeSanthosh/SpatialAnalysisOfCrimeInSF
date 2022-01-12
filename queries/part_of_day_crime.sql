-- Find on which part of the day is most crimes are happening

DROP VIEW IF EXISTS part_of_day_crime;
CREATE  OR REPLACE VIEW  part_of_day_crime AS 
SELECT 
 *,
CASE
    WHEN date_part('hours',crime_date) >= 5 and date_part('hours',crime_date) < 12  THEN 'Morning'
    WHEN date_part('hours',crime_date) >= 12 and date_part('hours',crime_date) < 17  THEN 'Afternoon'
    WHEN date_part('hours',crime_date) >= 17 and date_part('hours',crime_date) < 19  THEN 'Evening'
    ELSE 'Night'
END AS part_of_day_crime
FROM sf_crime_data;

-- Find the count of crimes occured on parts of the day
select part_of_day_crime, count(*) as crime_count from part_of_day_crime group by part_of_day_crime order by crime_count desc;