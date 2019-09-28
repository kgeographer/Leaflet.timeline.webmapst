-- explorations and transformations on OWTRAD dataset
-- new.all_places, new.all_segments

-- why isn't dataid unique? 601 are duplicated
-- and the places are not the same
-- with z as (
select nodeid, dataid, name, lng, lat 
	-- into temp z 
	from new.all_places an
	where (select count(*) from new.all_places inr
		where inr.dataid = an.dataid) > 1
	order by an.dataid
-- ) select nodeid, dataid from z
-- ) select distinct(dataid) from z

-- neither are nodeids unique
select nodeid, dataid, name, lng, lat 
	-- into temp z 
	from new.all_places an
	where (select count(*) from new.all_places inr
		where inr.nodeid = an.nodeid) > 1
	order by an.nodeid