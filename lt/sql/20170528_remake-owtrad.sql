-- remake owtrad with continent-distinct nodeids
-- set search_path = public, new
-- NODES -> PLACES
set search_path = new, public
drop table new.africa_nodes;
drop table new.asia_nodes;
drop table new.europe_nodes;
-- make new node tables
select 'afr_'||nodeid1 as nodeid,node1 as name,dataid,country1 as country,
	detail,datastatus,long1 as lng,lat1 as lat,geom
	into new.africa_nodes from africa_nodes;
	-- 231
select 'asia_'||nodeid1 as nodeid,node1 as name,dataid,country1 as country,
	detail,datastatus,long1 as lng,lat1 as lat,geom
	into new.asia_nodes from asia_nodes;
	-- 2393
select 'eur_'||nodeid1 as nodeid,node1 as name,dataid,country1 as country,
	detail,datastatus,long1 as lng,lat1 as lat,geom
	into new.europe_nodes from europe_nodes;
	-- 1586
-- select 231+2393+1586 = 4210

-- merge nodes as places
-- drop table new.all_places
-- select column_name from information_schema.columns where table_name='africa_nodes'
select * into all_places from africa_nodes
UNION
select * from asia_nodes
UNION
select * from europe_nodes
-- 4210
delete from all_places where dataid is null;
ALTER TABLE new.all_places
  ADD CONSTRAINT pk_allplaces PRIMARY KEY(nodeid,dataid);

-- ROUTES -> SEGMENTS
select column_name from information_schema.columns where table_name='africa_routes'
--drop table new.africa_routes
--drop table new.asia_routes
--drop table new.europe_routes
select 'afr_'||dataid as dataid,'afr_'||nodeid1 as source,'afr_'||nodeid2 as target,detail,uses,type,
	role,goods1,goods2,goods3,dir,dist,travmode,travtime,earlydate,latedate,
	dataqlty,src,long1,lat1,coordsrc1,long2,lat2,coordsrc2,probl,geom
	into new.africa_routes from africa_routes;
	-- 262
select 'asia_'||dataid as dataid,'asia_'||nodeid1 as source,'asia_'||nodeid2 as target,detail,uses,type,
	role,goods1,goods2,goods3,dir,dist,travmode,travtime,earlydate,latedate,
	dataqlty,src,long1,lat1,coordsrc1,long2,lat2,coordsrc2,probl,geom
	into new.asia_routes from asia_routes;
	-- 2636
select 'eur_'||dataid as dataid,'eur_'||nodeid1 as source,'eur_'||nodeid2 as target,detail,uses,type,
	role,goods1,goods2,goods3,dir,dist,travmode,travtime,earlydate,latedate,
	dataqlty,src,long1,lat1,coordsrc1,long2,lat2,coordsrc2,probl,geom
	into new.europe_routes from europe_routes;
	-- 1840
-- select 262+2636+1840 = 4738

-- merge routes as segments
-- drop table new.all_segments
select * into all_segments from africa_routes
UNION
select * from asia_routes
UNION
select * from europe_routes
-- 4738

ALTER TABLE new.all_segments
  ADD CONSTRAINT pk_allsegments PRIMARY KEY(dataid,source,target);

-- WTF????? there are duplicate ids within continent datasets
-- json_build_object('foo',1,'bar',2)
with z as (
select nodeid, dataid, name, lng, lat 
	-- into temp z 
	from all_places an
	where (select count(*) from new.all_places inr
		where inr.nodeid = an.nodeid) > 1
	order by an.nodeid
) select nodeid, 
	json_build_object('id',dataid,'name',name) AS name
-- 	array_to_string(array_agg(distinct(dataid)),',') AS dataids,
-- 	array_to_string(array_agg(distinct(name)),',') AS names, lng, lat
	from z group by nodeid, dataid, name, lng, lat
	order by nodeid

-- make new.z_places; something like a gazetteer record (placeid, names[])
with z as (
select nodeid, 
	json_build_object(
		'name',name,'id',dataid,'country',country,
		'detail',detail,'datastatus',datastatus
	) AS name,lng, lat
-- 	from all_places group by nodeid, dataid, lng, lat
 	from all_places group by nodeid, dataid, name, country, detail, datastatus, lng, lat
	order by nodeid
) select nodeid, lng, lat, '['||array_to_string(array_agg(name),',')||']' as names
	into new.z_places
	from z group by nodeid, lng, lat
	order by nodeid

	
-- create segment labels
update all_segments s set s_name = p.name from all_places p
	where s.

-- create places_owtrad.csv
