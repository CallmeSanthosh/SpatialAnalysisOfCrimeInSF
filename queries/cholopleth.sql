-- choropleth steps
--step 1
ALTER TABLE sf_district ADD COLUMN NumCrimeCases INTEGER DEFAULT 0;

--step 2
SELECT sfd.sfdistrict_id,sfd.name, count(*) as NumPtsInPoly
FROM sf_crime_data as sfc, sf_district as sfd 
where st_contains(sfd.dgeom, sfc.cgeom)
GROUP BY sfd.sfdistrict_id;

--step 3

With DistrictPolygonQuery as (
	SELECT sfd.sfdistrict_id,sfd.name, count(*) as NumPtsInDistrict
	FROM sf_crime_data as sfc, sf_district as sfd 
	where st_contains(sfd.dgeom, sfc.cgeom)
	GROUP BY sfd.sfdistrict_id
)
UPDATE sf_district
SET numcrimecases = DistrictPolygonQuery.NumPtsInDistrict
FROM DistrictPolygonQuery
WHERE DistrictPolygonQuery.sfdistrict_id = sf_district.sfdistrict_id;

--step 4
select * from sf_district;