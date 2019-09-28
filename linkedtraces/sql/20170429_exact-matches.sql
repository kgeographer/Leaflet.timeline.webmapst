-- get GeoNames info into owtrad, incanto
update owtrad.places op set exact_matches = 
	'[{"uri":"http://sws.geonames/'||gn.gnid||'","names":["'||gn.gn_name||'"]}]' from
	gn_align gn where op.place_id=gn.place_id
-- 
update incanto.places ip set exact_matches = 
	'[{"uri":"http://sws.geonames/'||gn.gnid||'","names":["'||gn.gn_name||'"]}]' from
	gn_align gn where ip.place_id::character varying=gn.place_id

-- get Pleiades into Bordeaux, Vicarello
update bordeaux.places bp set exact_matches = 
	'[{"uri":"'||bp.exact_matches||'","names":'||pl.names||'}]' from
	pl_align pl where bp.exact_matches=pl.uri

update bordeaux.places set gazetteer_label = initcap(gazetteer_label)

update vicarello.places vp set exact_matches = 
	'[{"uri":"'||vp.exact_matches||'","names":'||pl.names||'}]' from
	pl_align pl where vp.exact_matches=pl.uri

-- appears some Pleiades places weren't gathered
select exact_matches from vicarello.places where exact_matches like 'http%'

-- output csv for Linked Places ingest 
select * from incanto.places
select * from owtrad.places
select * from bordeaux.places
select * from vicarello.places

-- deal with courier
update courier.places cp set exact_matches = 
	'[{"uri":"'||cp.exact_matches||'","names":["'||cp.gazetteer_label||'"]}]'
select * from courier.places

-- now roundabout and xuanzang
update roundabout.places rp set exact_matches = 
	'[{"uri":"http://sws.geonames/'||gn.gnid||'","names":["'||gn.gn_name||'"]}]' from
	gn_align gn where rp.place_id=gn.place_id
	and gn.lp_label is not null;

update xuanzang.places xp set exact_matches = 
	'[{"uri":"http://sws.geonames/'||gn.gnid||'","names":["'||gn.gn_name||'"]}]' from
	gn_align gn where xp.place_id::character varying=gn.place_id
	and gn.lp_label is not null;
update xuanzang.places set gazetteer_label = toponym where gazetteer_label is null
-- odd stragglers
update xuanzang.places set exact_matches = 
	'[{"uri":"http://sws.geonames/'||geonames_id||'","names":["'||gazetteer_label||'"]}]'
	where exact_matches like 'http%'
	-- from gn_align gn where xp.place_id::character varying=gn.place_id
	-- and gn.lp_label is not null;
	
select * from roundabout.places
select * from xuanzang.places
