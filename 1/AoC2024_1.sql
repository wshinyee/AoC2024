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
		, ROW_NUMBER() over (order by parsename(locPair, 2)) as lrn
		, cast(parsename(locPair, 1) as int) as rLoc
		, ROW_NUMBER() over (order by parsename(locPair, 1)) as rrn
	from rep 
)
select sum(ABS(l.lLoc - r.rLoc)) as totalDistance
from spt l
inner join spt r
	on l.lrn=r.rrn


