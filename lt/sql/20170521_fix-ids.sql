-- collection;route_id;segment_id;source;target;label;geometry;timespan;
-- duration;follows;ships;seq;days

select 'incanto' as collection, journey as route_id, 
	journey::text||'-'||seq::text as segment_id,
	'in_'||source as source, 'in_'||target as target, label_s||' <> '||label_t as label,
	st_asgeojson(geom) as geometry, year as timespan,days||'d' as duration,
	'' as follows, ships,days
	from incanto.segments_r 
	where geom is not null
	order by segment_id

-- fix source/target ids in owt.segments
update owtrad.segments set s = 'owt_'||source::text;
update owtrad.segments set t = 'owt_'||target::text;

select collection,route_id,segment_id,s AS source,t AS target,label,geometry,timespan,duration,
	follows,dataset,dataid,uses,type,role,goods,dir,dist,travmode,travtime,dataqlty,src,probl
	FROM owtrad.segments
-- back up
select * into owtrad.segments_bak from owtrad.segments
update owtrad.segments s set label = p1.toponym || ' <> ' || p2.toponym
	from owtrad.places p1, owtrad.places p2
	where s.s = p1.place_id and
	s.t = p2.place_id
-- back up
select * into incanto.segments_r_bak from incanto.segments_r
select * from incanto.segments_r where label_s = 'Grenade' or label_t = 'Granade'
select * from incanto.places where place_id = 60046
update incanto.segments_r s set label_s = p.toponym from incanto.places p
	where s.source = p.place_id;
update incanto.segments_r s set label_t = p.toponym from incanto.places p
	where s.target = p.place_id