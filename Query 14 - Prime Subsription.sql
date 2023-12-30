create table users1
(
user_id integer,
name varchar(20),
join_date date
);
/* prime subscription-
Given the following two tables, return the fraction of users, rounded to two decimal places,
who accessed Amazon music and upgraded to prime membership within the first 30 days of signing up. */


insert into users1
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

insert into events values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));

---- Wrong Query----


with cte as(
select count(distinct user_id) as cnt from users1)

select rtrim(round(count(*)/(select * from cte),2),3) from 
(select * from events where type='Music')a
full join
(select * from events where type='P')b on a.user_id=b.user_id 
where DATEDIFF(day, a.access_date, b.access_date)<30

select user_id, type,
case when type='Music' then access_date end as Music_date,
case when type='P' then access_date end as prime_date 
from events

select * from users1

----- Corrrect Query -----

select round(1.0*count(case when datediff(day,u.join_date, e.access_date)<=30 then u.user_id end)/count(u.user_id)*100,2) from users1 u
left join events e on u.user_id=e.user_id and e.type='P'
where u.user_id in ( select user_id from events where type='Music')


select * from events