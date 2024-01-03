
-- the activity table tells app-installed and the app purchases along with country imformation


CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');


-----

-- Q1: Total active users each day

select event_date, count(distinct user_id) as daily_count from activity group by event_date

-- Q2: Total active users each week 
select DATEPART(week, event_date) as wk, count(distinct user_id) as weekely_count from activity group by DATEPART(week, event_date)


-- Q3: Date wise same day users who installed and purchase on the same day

select event_date, count(new_user) from
(SELEcT event_date, user_id, case when count( distinct event_name) =2 then user_id else null end as new_user
from activity group by EVENT_DATE, user_id)a group by event_date

-- Q4: Number of paid users in India, USA and other countries. Other's should be tagged as others

select 
with country_wise as
(select case when country not in ('India', 'USA') then 'others' else country end as country1 , count(distinct user_id) as dstnct from activity where event_name='app-purchase'
group by case when country not in ('India', 'USA') then 'others' else country end)
, total as ( select count(distinct user_id) as total from activity where event_name='app-purchase' )
select country1, 1.0*dstnct/total from country_wise, total


-- Q5 : Out of all the users who installed on any day, how many made the purcahse on the next day.

select * from activity

with cte as
(select *,
lag(event_name,1) over ( partition by user_id order by event_date) as prev_day_event,
lag(event_date,1) over ( partition by user_id order by event_date) as prev_date
 from activity),
 cte1 as
 (select event_date, user_id,
 case when datediff(day, prev_date, event_date)=1 then user_id else null end as new
 from cte where event_name='app-purchase' and prev_day_event='app-installed')

 select event_date, count(new) from cte1 
 group by event_date
  
