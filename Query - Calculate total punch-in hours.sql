
-- Calculate the total number of clocked hours.		

create table clocked_hours(

empd_id int,

swipe time,

flag char

)

insert into clocked_hours values

(11114,'08:30','I'),

(11114,'10:30','O'),

(11114,'11:30','I'),

(11114,'15:30','O'),

(11115,'09:30','I'),

(11115,'17:30','O');


select empd_id,  sum(datediff(hour,swipe,next_swipe)) as tot_minutes from
(select *, lead(swipe,1) over (partition by '' order by empd_id, swipe) as next_swipe,
lead(flag,1) over (partition by '' order by empd_id, swipe) as next_flag
from clocked_hours)c where flag='I' and next_flag='O' 
group by empd_id


--============--========--=============--==================

with cte as 
(select *, row_number() over (partition by empd_id, flag order by swipe) as rn 
from clocked_hours) 
, cte2 as 
(select empd_id, rn, datediff(hour,min(swipe), max(swipe)) as tot_time from cte
group by empd_id, rn)
select empd_id, sum(tot_time) from cte2 group by empd_id



