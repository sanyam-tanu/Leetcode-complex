

-- 3 or more consecutive empty seats : output all the seat no's :: example o/p : 4,5,6,8,9,10,11


create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');



---
select * from bms
--1. Via lead/lag

with cte as
(select *
, lead(is_empty,1) over (order by seat_no) as first_next 
, lead(is_empty,2) over (order by seat_no) as second_next
, lag(is_empty,1) over (order by seat_no) as first_prev 
, lag(is_empty,2) over (order by seat_no) as second_prev
from bms)
select seat_no from cte where 
is_empty='Y' and first_next='Y' and second_next='Y' or
is_empty='Y' and first_next='Y' and first_prev='Y' or
is_empty='Y' and first_prev='Y' and second_prev='Y' 
--
-- Method 2:

with cte as
(select *,
sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 2 preceding and current row) as prev_2,
sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 1 preceding and 1 following) prev_next,
sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between current row and 2 following ) as next_2
from bms)
select seat_no from cte where prev_2=3 or prev_next=3 or next_2=3








