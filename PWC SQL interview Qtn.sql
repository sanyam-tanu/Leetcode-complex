create table source(id int, name varchar(5))

create table target(id int, name varchar(5))

insert into source values(1,'A'),(2,'B'),(3,'C'),(4,'D')

insert into target values(1,'A'),(2,'B'),(4,'X'),(5,'F');


select * from source;
select * from target;

===
-- Type 1
	select s.id, 'new_in_source' comment from source s
	left join target a on s.id=a.id where a.id is null
	union
	select a.id, 'new_in_target' comment from source s
	right join target a on s.id=a.id where s.id is null
	union 
	select s.id, 'mismatch' comment from source s
	inner join target a on s.id=a.id and s.name!=a.name 

--- ===============================================================================================

-- Type 2

select coalesce(a.id, b.id) as id, 
case when a.name is null then 'new_in_target'
when b.name is null then 'new_in_source'
else 'mismatch' end as comment
from source a full join target b on a.id=b.id 
where a.name is null or b.name is null or a.name!=b.name

----------------------==========-------------------------------------================---------------------------

-- type 3

with total as
(select *, 'target' t_name from target
union all
select *, 'source' t_name from source)

select id--, count(name) as cnt, min(name) min_name, max(name) as max_name, min(t_name) min_tname, max(t_name) max_tname 
,case when min(t_name)!=max(t_name) then 'mismatch' else concat('new in ', min(t_name)) end as comment
from total
group by id
having count(name)=1 or (count(name)=2 and min(name)!=max(name))











