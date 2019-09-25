-- Biondo
SET search_path = biondo;

-- distinct places
SELECT DISTINCT ON (uri) id, uri FROM alltags;

SELECT uri, geom, count(*), array_agg(quote_transcription) AS toponyms INTO places FROM alltags
    GROUP BY uri, geom ORDER BY count DESC;
DROP TABLE places;

SELECT uri FROM alltags WHERE tags = 'w'

-- select 
SELECT quote_transcription FROM alltags WHERE uri IS NULL ORDER BY quote_transcription;

WITH z AS (
SELECT quote_transcription AS QUOTE FROM alltags WHERE uri IS NULL
) SELECT * FROM alltags WHERE quote_transcription IN (SELECT QUOTE FROM z)
 

SELECT quote_transcription, count(*) FROM alltags WHERE uri IS NULL 
    GROUP BY quote_transcription ORDER BY quote_transcription;
    
-- tag waypoints
UPDATE places p SET waypoint = TRUE WHERE p.uri IN (
SELECT DISTINCT(p.uri) FROM places p JOIN alltags a ON p.uri = a.uri
    WHERE a.tags = 'w'
) 
-- how many waypoints
SELECT DISTINCT(uri) FROM alltags WHERE tags = 'w';

SELECT toponyms[1] FROM places;
UPDATE places SET title = toponyms[1];