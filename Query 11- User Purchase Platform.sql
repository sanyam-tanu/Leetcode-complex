create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

====================

-- User Purchase Platform
/* We have a spending table which has users spending data. Shopping can be done from both mobuke and web. 
Write a sql query to find total number of users and total money spent using mobile only, desktop only, and both*/




with all_spend as (
select spend_date,user_id, max(platform) as platform, sum(amount) as total_amount
from spending
group by spend_date,user_id having count(distinct platform)=1
union all
select spend_date,user_id, 'both' as platform, sum(amount) as total_amount
from spending
group by spend_date,user_id having count(platform)>1
union all  -- below row indiacates insertion of dummy row in the database to get the desired output
select spend_date,null as user_id, 'both' as platform, 0 as total_amount
from spending
)

select spend_date, platform, sum(total_amount) as total_amount, count(distinct user_id) as total_users
from all_spend group by spend_date, platform order by spend_date, platform desc


