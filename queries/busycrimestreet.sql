DROP VIEW IF EXISTS busycrimestreet;
CREATE  OR REPLACE VIEW  busycrimestreet AS

select sfroad_id, rgeom from 
(
select count(*) as crimecount,sfr.streetname, rank() over(order by count(*) desc) as crimeRank
from sf_crime_data as sfc, sf_road as sfr 
where date_part('year', sfc.crime_date) = '2020' 
and st_distance(sfc.cgeom, sfr.rgeom) <= 10
group by sfr.streetname
order by crimecount desc
) as subquery, sf_road as sfr
where subquery.crimeRank = 1 and sfr.streetname=subquery.streetname;
