create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

===============

--Write a SQL query to find the winner in each group

-- The winner in each group is who scored max points, in case of tie, lower player-id wins

select * from players;
select * from matches;

======================

-- aggregation in case of wins only
select first_player, first_score from matches
union all select second_player, second_score from matches

with wins as 
(select *, case 
when first_score>second_score then '1Win'
when first_score<second_score then '1loose'
else 'tie' end as match_result
from matches), group_wins as 
(select a.*, b.group_id from wins a join players b on a.first_player=b.player_id)


select group_id, first_player as player from
(select *, rank() over (partition by group_id order by first_score desc) as rn from 
(select group_id, first_player, first_score from group_wins where match_result='1Win'
union all select group_id, second_player, second_score from group_wins where match_result='1loose'
union all select group_id, second_player, second_score from group_wins where match_result='tie' and first_player>second_player
union all select group_id, first_player, first_score from group_wins where match_result='tie' and first_player<second_player
)s)d where rn=1

====================


-- In case of just total points

select group_id, player from 
(select group_id, player, score, dense_rank() over (partition by group_id order by player asc, score desc ) as rn from  
(select player, sum(score) as score from 
(select first_player as player, first_score as score from matches
union all
select second_player as player, second_score as score from matches)a 
group by player)b join players c on b.player=c.player_id)m where rn=1




