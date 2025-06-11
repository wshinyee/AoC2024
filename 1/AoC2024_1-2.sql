drop table if exists #puzzle
create table #puzzle (locPair varchar(100))
BULK INSERT #puzzle
FROM 'C:\\AoC2024\1\AoC2024_1.csv';

; with rep as
(
	select replace(locPair, '   ', '.') as locPair 
	from #puzzle
), spt as
(
	select cast(parsename(locPair, 2) as int) as lLoc
		, cast(parsename(locPair, 1) as int) as rLoc
	from rep 
), score as (
	select l.lLoc * count(r.rLoc) as similarityScore
	from spt l
	left join spt r
		on l.lLoc=r.rLoc
	group by l.lLoc
)
select sum(similarityScore) as totalSimilarityScore
from score


