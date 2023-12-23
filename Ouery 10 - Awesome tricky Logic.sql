create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success')

with calculate_date as
(select *, dateadd(day, -1*row_number() over (partition by state order by date_value),date_value) as base_date from tasks)
select min(date_value) as start_day, max(date_value) as end_day, state from calculate_date
group by base_date, state order by start_day 