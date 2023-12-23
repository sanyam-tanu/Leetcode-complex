-- Find nth occourence of sunday from current date

declare @day date;
declare @n int;
declare @i int;
set @day= CURRENT_TIMESTAMP;
set @n=5;
select dateadd(week,@n,dateadd(day,8-datepart(weekday,@day),@day))



