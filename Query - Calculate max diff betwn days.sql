/* Query to find the maximum difference between the dates for easch user and if thre's only one date, then take the difference from '2021-1-1' */

create table uservisits
(user_id INT,
visit_date date)

insert into uservisits values 
( 1    , '2020-11-28'),
( 1    , '2020-10-20'),
( 1    , '2020-12-3' ),
( 2    , '2020-10-5' ),
( 2    , '2020-12-9' ),
( 3    , '2020-11-11')



select * from uservisits;

with cte as
(select *, 
count(user_id) over ( partition by user_id ) as no_of_visits, 
max(visit_date) over ( partition by user_id ) as max_date from uservisits )
select user_id, 
max(DATEDIFF(day, visit_date, case when no_of_visits>1 then max_date else '2021-1-1' end)) as biggest_window 
from cte
group by user_id;

------

with cte as(
select *,datediff(day,visit_date,lead(visit_date,1,'2021-01-01') over(partition by user_id order by visit_date)) as diff
from uservisits)
select user_id,max(diff) as max_window
from cte
group by user_id;

