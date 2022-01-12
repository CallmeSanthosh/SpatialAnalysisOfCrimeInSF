--step 1
ALTER TABLE sf_crime_data DROP COLUMN IF EXISTS DISTANCE;
ALTER TABLE sf_crime_data ADD COLUMN DISTANCE NUMERIC;
UPDATE sf_crime_data set DISTANCE = 0.0;

--step 2
DROP TABLE IF EXISTS sf_policestationbuffer CASCADE;
CREATE TABLE  sf_policestationbuffer
  AS
SELECT sfps_id as sfpsb_id,ST_Buffer(pgeom,2000) as bufgeom from sf_policestation;

--step 3
ALTER TABLE sf_policestationbuffer ADD PRIMARY KEY (sfpsb_id);

-- Create a SPATIAL INDEX on the newly created table. 
CREATE INDEX "sf_policestationbuffer_bufgeom_idx" ON sf_policestationbuffer
USING GIST (bufgeom);

--step 4
SELECT min(DistanceToBuffer) as ShortestDistance, getMinDistanceQuery.sfcrime_id as crimePt_PK from (
    SELECT sfc.cgeom<->pb.bufgeom as DistanceToBuffer,sfc.sfcrime_id
    FROM sf_crime_data as sfc, sf_policestationbuffer as pb
  )
as getMinDistanceQuery
GROUP BY sfcrime_id;

--step 5
with TableSubquery as (
SELECT min(DistanceToBuffer) as ShortestDistance, getMinDistanceQuery.sfcrime_id as crimePt_PK from (
    SELECT sfc.cgeom<->pb.bufgeom as DistanceToBuffer,sfc.sfcrime_id
    FROM sf_crime_data as sfc, sf_policestationbuffer as pb
  )
as getMinDistanceQuery
GROUP BY sfcrime_id
)
update sf_crime_data
set DISTANCE = TableSubquery.ShortestDistance
from
	TableSubquery
where 	sf_crime_data.sfcrime_id = TableSubquery.crimePt_PK;