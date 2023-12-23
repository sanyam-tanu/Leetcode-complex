/* Market Analysis: Write and sqL query to find for each seller, whether the brand of the second item(by date) they sold is their favorite. If a seller sold 
less than two items, report the answer for that seller as no. o/p */

drop table users;
create table users (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );
 
 delete from users;
 delete from items;
 delete from orders;



 insert into users values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);


 select * from users;
 select * from items;
 select * from orders;

 with order2 as(
 select * from (select *, rank() over (partition by seller_id order by order_date asc) as rn from orders)a )
 ,final_result as (
 select u.user_id,o.*, u.favorite_brand,i.item_brand, case when favorite_brand=item_brand then 'yes' else 'no' end as item_fav_brand
 from users u 
 left join order2 o on o.seller_id= u.user_id and rn=2
 left join items i on o.item_id=i.item_id)
 select user_id, item_fav_brand from final_result
