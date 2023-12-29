
--Table Script:
CREATE TABLE your_table (your_column INT);

INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (4);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (10);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (3);

with cte as 
(select your_column, ROW_NUMBER() over (order by (select null)) as rownum
from your_table)
, cte2 as
(select your_column, rownum, count(your_column) over (order by rownum) as rn2 from cte)
, cte3 as
(select your_column, rownum, rn2, lag(rn2,1,0) over (order by rownum) as rn3 from cte2)
select your_column, rn3, last_value(your_column) over ( partition by rn3 order by rownum rows between unbounded preceding and unbounded following)from cte3

select * from your_table
