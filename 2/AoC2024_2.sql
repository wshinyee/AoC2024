drop table if exists #puzzle
create table #puzzle (report varchar(200))
BULK INSERT #puzzle
FROM 'C:\\AoC2024\2\AoC2024_2.csv';

drop table if exists #reportLvl
create table #reportLvl (id int identity, report varchar(200), lvl int)
insert into #reportLvl (report, lvl)
select report
	, len(report) - len(replace(report, ' ', '')) + 1 as lvl
from #puzzle

; with cte_rec as
(
	select id
		, lvl
		, '0' as ascDesc
		, 1 as statusSafe
		, cast(left(report, charindex(' ', report + ' ') - 1) as int) as splitted_value
		, cast(stuff(report, 1, charindex(' ', report + ' '), '') as varchar(200)) as report
		, 1 as split_lvl
	from #reportLvl

	union all

	select id
		, lvl
		, case when splitted_value - cast(left(report, charindex(' ', report + ' ') - 1) as int) < 0 then '-' 
				when splitted_value - cast(left(report, charindex(' ', report + ' ') - 1) as int)  > 0 then '+' 
			else '' end as ascDesc 
		, case 
			when splitted_value=cast(left(report, charindex(' ', report + ' ') - 1) as int) then 0
			when (ABS(splitted_value - cast(left(report, charindex(' ', report + ' ') - 1) as int)) < 1
									OR ABS(splitted_value - cast(left(report, charindex(' ', report + ' ') - 1) as int)) > 3) then 0
			when ascDesc <> '0' and (
				case when splitted_value - cast(left(report, charindex(' ', report + ' ') - 1) as int) < 0 then '-' 
					when splitted_value - cast(left(report, charindex(' ', report + ' ') - 1) as int) > 0 then '+' 
				else '' end
				<> ascDesc
			) then 0
			else 1 end as statusSafe
		, cast(left(report, charindex(' ', report + ' ') - 1) as int) as splitted_value
		, cast(stuff(report, 1, charindex(' ', report + ' '), '') as varchar(200)) as report
		, split_lvl + 1 
	from cte_rec
	where split_lvl + 1  <= lvl
)
select COUNT(DISTINCT ID) AS totalSafeReport
from cte_rec
where id not in (
	select distinct id from cte_rec
	where statusSafe=0
)