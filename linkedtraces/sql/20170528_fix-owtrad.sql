-- straighten out owtrad for once and all
-- drop table all_nodes;

select 'africa'::character varying as continent,nodeid1,node1,dataid,
	coalesce(detail,'') as detail,
	country1,long1 as lng,lat1 as lat,datastatus,geom
	into all_nodes 
	from africa_nodes
UNION
select 'asia'::character varying as continent,nodeid1,node1,dataid,
	coalesce(detail,'') as detail,
	country1,long1 as lng,lat1 as lat,datastatus,geom
	from asia_nodes
UNION
select 'europe'::character varying as continent,nodeid1,node1,dataid,
	coalesce(detail,'') as detail,
	country1,long1 as lng,lat1 as lat,datastatus,geom
	from europe_nodes

ALTER TABLE public.all_nodes
  ADD CONSTRAINT pk_allnodes PRIMARY KEY(dataid);
select * from all_nodes where dataid is null
delete from all_nodes where dataid is null -- only one is null
select * from all_nodes where node1 = 'Rimnic'
-- get duplicate dataids -> 1220 (610 pairs?)
select * from all_nodes an
where (select count(*) from all_nodes inr
where inr.dataid = an.dataid) > 1
order by an.dataid

-- aggregate node1 names from duplicate nodeid1 -> 1083
with z as (
	select * from all_nodes an
	where (select count(*) from all_nodes inr
	where inr.nodeid1 = an.nodeid1) > 1
	order by an.nodeid1
) select nodeid1,array_agg(node1) as names,lng,lat from z group by nodeid1,lng,lat

with z as (
select array_agg(continent) as continents,nodeid1,array_agg(node1) as names,array_agg(dataid) as dataids,
	array_agg(coalesce(detail,'')) as details,
	array_agg(country1) as countries,lng,lat,datastatus --,geom
	FROM all_nodes 
	GROUP BY nodeid1,lng,lat,datastatus -- 3262 distinct places
	order by nodeid1
) select nodeid1, count(*) from z group by nodeid1 order by count desc
	
select nodeid1,array_agg(node1) as names,lng,lat from z group by nodeid1,lng,lat

select count(*) from all_nodes